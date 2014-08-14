From: Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v3] scsi: ufs-msm: add UFS controller support for Qualcomm MSM chips
Date: Thu, 14 Aug 2014 10:03:02 -0500
Message-ID: <F891F359-FFF1-4F72-ADEF-B023F1D50A0F@codeaurora.org>
References: <1408026157-26972-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1408026157-26972-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Grant Likely <grant.likely@linaro.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Aug 14, 2014, at 9:22 AM, Yaniv Gardi <ygardi@codeaurora.org> wrote:

> The files in this change implement the UFS HW (controller & PHY) spec=
ific
> behavior in Qualcomm MSM chips.
>=20
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> ---
> Documentation/devicetree/bindings/ufs/ufs-msm.txt  |   37 +
> .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |    4 +
> drivers/scsi/ufs/Kconfig                           |   12 +
> drivers/scsi/ufs/Makefile                          |    4 +
> drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.c            |  254 +++++
> drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.h            |  216 ++++
> drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.c            |  368 +++++++
> drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.h            |  735 +++++++++++=
++
> drivers/scsi/ufs/ufs-msm-phy.c                     |  646 +++++++++++=
+
> drivers/scsi/ufs/ufs-msm-phy.h                     |  193 ++++

Any reason not to put the phy driver in drivers/phy ?

> drivers/scsi/ufs/ufs-msm.c                         | 1105 +++++++++++=
+++++++++
> drivers/scsi/ufs/ufs-msm.h                         |  158 +++
> 12 files changed, 3732 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/ufs/ufs-msm.txt
> create mode 100644 drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.c
> create mode 100644 drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.h
> create mode 100644 drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.c
> create mode 100644 drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.h
> create mode 100644 drivers/scsi/ufs/ufs-msm-phy.c
> create mode 100644 drivers/scsi/ufs/ufs-msm-phy.h
> create mode 100644 drivers/scsi/ufs/ufs-msm.c
> create mode 100644 drivers/scsi/ufs/ufs-msm.h

Seems like we should spit this into two patches, one for the phy and on=
e for the UFS driver itself.  Maybe even three, one for the 20nm phy, o=
ne for the 28nm phy, and one for ufs-msm.c,h.

>=20
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-msm.txt b/Docu=
mentation/devicetree/bindings/ufs/ufs-msm.txt
> new file mode 100644
> index 0000000..b5caace
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-msm.txt

This should probably be bindings/phy/qcom-ufs-phy.txt

> @@ -0,0 +1,37 @@
> +* MSM Universal Flash Storage (UFS) PHY
> +
> +UFSPHY nodes are defined to describe on-chip UFS PHY hardware macro.
> +Each UFS PHY node should have its own node.
> +
> +To bind UFS PHY with UFS host controller, the controller node should
> +contain a phandle reference to UFS PHY node.
> +
> +Required properties:
> +- compatible        : compatible list, contains "qcom,ufs-msm-phy-qm=
p-28nm"
> +                      or "qcom,ufs-msm-phy-qmp-20nm" according to th=
e relevant
> +                      phy in use

Do we really need =91-msm=92 in the compat name?

> +- reg               : <registers mapping>
> +- #phy-cells         : This property shall be set to 0
> +- vdda-phy-supply   : phandle to main PHY supply for analog domain
> +- vdda-pll-supply   : phandle to PHY PLL and Power-Gen block power s=
upply
> +
> +Optional properties:
> +- vdda-phy-max-microamp : specifies max. load that can be drawn from=
 phy supply
> +- vdda-pll-max-microamp : specifies max. load that can be drawn from=
 pll supply
> +
> +Example:
> +
> +	ufsphy1: ufsphy@0xfc597000 {
> +		compatible =3D "qcom,ufs-msm-phy-qmp-28nm";
> +		reg =3D <0xfc597000 0x800>;
> +		#phy-cells =3D <0>;
> +		vdda-phy-supply =3D <&pma8084_l4>;
> +		vdda-pll-supply =3D <&pma8084_l12>;
> +		vdda-phy-max-microamp =3D <50000>;
> +		vdda-pll-max-microamp =3D <1000>;
> +	};
> +
> +	ufshc@0xfc598000 {
> +		...
> +		phys =3D <&ufsphy1>;
> +	};
> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt =
b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> index e73a619..378585c 100644
> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> @@ -9,6 +9,9 @@ Required properties:
> - reg               : <registers mapping>
>=20
> Optional properties:
> +- phys			: phandle to UFS PHY node
> +- phy-names		: the string "ufs_msm_phy" when is found in a node, alo=
ng
> +			  with "phys" attribute, provides phandle to UFS PHY node

seems like the phy-names should be more generic like =93ufsphy"

> - vcc-supply            : phandle to VCC supply regulator node
> - vccq-supply           : phandle to VCCQ supply regulator node
> - vccq2-supply          : phandle to VCCQ2 supply regulator node
> @@ -39,6 +42,7 @@ Example:
> 		reg =3D <0xfc598000 0x800>;
> 		interrupts =3D <0 28 0>;
>=20
> +		ufs-phy =3D <&ufsphy>;
> 		vcc-supply =3D <&xxx_reg1>;
> 		vcc-supply-1p8;
> 		vccq-supply =3D <&xxx_reg2>;


> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 6e07b2a..a8259e0 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -70,3 +70,15 @@ config SCSI_UFSHCD_PLATFORM
> 	If you have a controller with this interface, say Y or M here.
>=20
> 	  If unsure, say N.
> +
> +config SCSI_UFS_MSM
> +	bool "MSM specific hooks to UFS controller platform driver"
> +	depends on SCSI_UFSHCD_PLATFORM && ARCH_MSM

This should probably be ARCH_QCOM instead of ARCH_MSM

> +	help
> +	  This selects the MSM specific additions to UFSHCD platform driver=
=2E
> +	  UFS host on MSM needs some vendor specific configuration before
> +	  accessing the hardware which includes PHY configuration and vendo=
r
> +	  specific registers.
> +
> +	  Select this if you have UFS controller on MSM chipset.
> +	  If unsure, say N.

[ snip ]

- k
--=20
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, host=
ed by The Linux Foundation
