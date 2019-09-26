#Author: Walker Kehoe 
#moar comments

function islandFinder(matrix, minsize, thresh, row, col, islands, key, island_dict)
    #recursive function
    if islands[row+1,col+1] == 0 && matrix[row,col] >= thresh #if square has been checked
        #and matrix value >= threshold
        islands[row+1,col+1] = 1 #mark as checked
        push!(island_dict[key],(row,col)) #add row,col pair to dictionary containing islands
        #the below checks all east-west-north-south squares for valid land
        islandFinder(matrix,minsize,thresh,row,col+1,islands, key, island_dict)
        islandFinder(matrix,minsize,thresh,row,col-1,islands, key, island_dict)
        islandFinder(matrix,minsize,thresh,row+1,col,islands, key, island_dict)
        islandFinder(matrix,minsize,thresh,row-1,col,islands, key, island_dict)
    end
end

function main(thresh, minsize, matrix)
    #main function to determine islands with "land" values above a certain threshold and area
    rows = size(matrix,1)
    cols = size(matrix,2)
    islands = ones(Int64,(rows+2),(cols+2)) #create a padded matrix
    #with 1's on edges to limit search to within matrix bounds
    islands[2:(rows+1),2:(cols+1)] = zeros(Int64,rows,cols)
    island_dict = Dict{Int,Array}() #dictionary for storing vaid islands
    result = zeros(Int64,rows,cols) #binary matrix for results
    key = 0 #dictionary key
    #loop to get islands & build and use dictionary of valid islands
    for col = 1:cols
        for row = 1:rows
            key += 1
            island_dict[key] = []
            islandFinder(matrix, minsize, thresh, row, col, islands, key, island_dict)
            if length(island_dict[key]) >= minsize #if island has minimum area
                for v in island_dict[key]
                    result[v[1],v[2]] = 1 #add it to the results matrix
                end
            end
        end
    end
    result
end

#testing with a random 5x5 matrix with values 0,1,2
input = rand([0,1,2], 5, 5)
#threshold = 1, minimum island size = 2
result =  main(1,2,input)
