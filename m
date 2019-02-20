From: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH v2 2/3] arm64: dts: hisilicon: hi3670: Add UFS controller
 support
Date: Wed, 20 Feb 2019 12:35:08 +0100
Message-ID: <20190220113508.GB7498@ulmo>
References: <20190105072859.9134-1-manivannan.sadhasivam@linaro.org>
 <20190105072859.9134-3-manivannan.sadhasivam@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190105072859.9134-3-manivannan.sadhasivam@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, liwei213@huawei.com, robh+dt@kernel.org, devicetree@vger.kernel.org, guodong.xu@linaro.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, amit.kucheria@linaro.org, john.stultz@linaro.org, linux-arm-kernel@lists.infradead.org, Wei Xu <xuwei5@hisilicon.com>, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 05, 2019 at 12:58:58PM +0530, Manivannan Sadhasivam wrote:
> Add UFS controller support for HiSilicon HI3670 SoC.
>=20
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  arch/arm64/boot/dts/hisilicon/hi3670.dtsi | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)

Hi Martin,

it looks like you picked this up into the SCSI tree (perhaps
inadvertently). It's been causing linux-next to fail to build since
Monday (next-20190218) because it references a phandle (&crg_rst)
that's not available.

There's a patch on the mailing lists to add that, but I think at this
point it'd be better if you could drop this from the SCSI tree and we
let the HiSilicon maintainers deal with the dependency in their tree.

Cc'ing Wei and linux-next.

Thierry

>=20
> diff --git a/arch/arm64/boot/dts/hisilicon/hi3670.dtsi b/arch/arm64/boot/=
dts/hisilicon/hi3670.dtsi
> index 6ccdf5040ffd..285219dd657f 100644
> --- a/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
> +++ b/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
> @@ -654,6 +654,24 @@
>  			clock-names =3D "apb_pclk";
>  		};
> =20
> +		/* UFS */
> +		ufs: ufs@ff3c0000 {
> +			compatible =3D "hisilicon,hi3670-ufs", "jedec,ufs-2.1";
> +			/* 0: HCI standard */
> +			/* 1: UFS SYS CTRL */
> +			reg =3D <0x0 0xff3c0000 0x0 0x1000>,
> +				<0x0 0xff3e0000 0x0 0x1000>;
> +			interrupt-parent =3D <&gic>;
> +			interrupts =3D <GIC_SPI 278 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks =3D <&crg_ctrl HI3670_CLK_GATE_UFSIO_REF>,
> +				<&crg_ctrl HI3670_CLK_GATE_UFS_SUBSYS>;
> +			clock-names =3D "ref_clk", "phy_clk";
> +			freq-table-hz =3D <0 0>, <0 0>;
> +			/* offset: 0x84; bit: 12 */
> +			resets =3D <&crg_rst 0x84 12>;
> +			reset-names =3D "rst";
> +		};
> +
>  		/* SD */
>  		dwmmc1: dwmmc1@ff37f000 {
>  			compatible =3D "hisilicon,hi3670-dw-mshc";
> --=20
> 2.17.1
>=20
>=20
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlxtO2gACgkQ3SOs138+
s6EQ4A/+IUN1SE3WaCK5xyaflGB+s9Z2NlJHtFZjA849/vp6tdyveL7I9ngv1n7i
+zwaR089y/jpfWvnbRl50/RTyyxHbyayXeG3PqU8zyE56TYdCcpmwPBxELOzkyQr
GERB7gcYZgl8r0g69Fc2I6bS0El9NLWBD6uhuvbBFV8Emy1+M2fF0JNvUmQTrmHL
q/IwCUDkr17jSH/dYan1rGMKmyPQ5v3uRC/nVqgnc8jYKBTMKkZ3M9oEqbK7Wr2r
Fgri+YPa0PkJ0A0hhBxP2nEslmStWuJ6EQfUYI2veFxMGS/xnTjlWg1qnWuiyh5+
/UYcSGiYYfmoAOPOyrJez9Gn70Phnk4GVujIKrWtY7LjWbQbZE6tpQwjeMhfesMm
IBE40J0OIPifoM9ve8sKwL5jHKI8nUvGS80wCFaC00/MzNIkL8V13uZgkLhZwV/M
9r4JHJs1XHbrBXNdiYnJGW/i9Ct9tFiIGi92rnuR/yAhlXUhkFEPqxEb1ZmupTwY
xB6BagYolo44WWdPm0MgNn7WEFjSu7dhWcAHRalV9MQYMhYuSYD6Sdej1PktvhdR
uYK9U32xsnsDVH/ZLwkDL/SkdMfUeVX4/0HZG70jJv8Tzji0BsBioHRpPomy5Rsn
FJmf52KkS3RWgw9MCwXU5Jqh98cbQqZBE6ooTY2f+h8aOarTY/c=
=JXaV
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
