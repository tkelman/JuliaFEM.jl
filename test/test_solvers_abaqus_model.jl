# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/JuliaFEM.jl/blob/master/LICENSE.md

using JuliaFEM
using JuliaFEM.Abaqus
using JuliaFEM.Testing

@testset "parse abaqus inp file to AbaqusModel" begin
    fn = Pkg.dir("JuliaFEM") * "/test/testdata/cube_tet4.inp"
    model = abaqus_read_model(fn)

    @test length(model.properties) == 1
    section = first(model.properties)
    @test section.element_set == :CUBE
    @test section.material == :MAT

    @test haskey(model.materials, :MAT)
    material = model.materials[:MAT]
    @test isapprox(first(material.properties).E, 208.0e3)

    @test length(model.steps) == 1
    step = first(model.steps)
    @test length(step.content) == 2

    bc = step.content[1]
    @test bc[1] == [:SYM12, 3]
    @test bc[2] == [:SYM23, 1]
    @test bc[3] == [:SYM13, 2]

    load = step.content[2]
    @test load[1] == [:LOAD, :P, 1.00000]
end

#=
@testset "given abaqus model solve field" begin
    fn = Pkg.dir("JuliaFEM") * "/test/testdata/cube_tet4.inp"
    model = abaqus_read_model(fn)
    model()
end
=#
