Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F3F339386;
	Thu,  6 Aug 2026 03:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785985981; cv=none; b=Fuoeo4CyMujWRChsd7FfRHb81dYwRWj8gy6usmN84a0Cj7aXZ26JEvvyQNK+fnMP3fszRBNzxdUTQ+0gj0nN8ddw8PynWuTZSO0ylnjuWMjuTqWa9FD6ribBUibV5LJ2gPuJrWi96GbfQ9JBFTE7gqiWHXzokKwnF2Tq15j+nos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785985981; c=relaxed/simple;
	bh=uRqUYKe3CaKtrulB6twHExRdf1/JDJSf7M3O+KRp8bw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hvXEKqlNroFsWfL7fBnzZ+j4t/7xJSzH9WgqysqiUuJ7VxfArHJSF2butVLoyiZOorC+Oyey3zW/tPwZPEnFsWYfhqRzYH7K5KZIPww3vq6nmEQQAIcTd5pH5JZF2RXhCy27syx/M+bt/bLxG4kfj+N4+e9nbRNTDCOmXKSAZ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJ91bZx4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJ91bZx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EF91F000E9;
	Thu,  6 Aug 2026 03:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785985979;
	bh=usgIrmbCsM95d284eA2JBn9yLxogCNh6rPtWzi6fYsQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JJ91bZx4firDa0OJsXOg8up2fI2R3qQ5YqGnH90zJPUYuiMRc0sNx++xl14uARGOA
	 0BA2XC/OsV7vvuhQQZbalE3GuFj8qpXfTLZgHqx27JeKVKpptx6XGlWeWL2iUvGlJk
	 sY+IlXrggNe62lFENE+X5ClYlo1gu/MPzx4ZKwr440ZIXmQ1EOkXnDgO1uCHypxw8r
	 533NYB562SqUYL2HTA09Y1/EYbfgQY2rvryTh44sRy7FIqECNWGLCMWpi9CjmI0piM
	 dCES/u4YeVf9CIretfSDzXCMgEHcdk/v0a0jtRuuzQvLi6BuGYZAl/fVXGQKEJ8E//
	 GkMLsN/Eu2djw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/3] riscv: dts: spacemit: k3: Add UFS support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yixun Lan" <dlan@kernel.org>
Cc: conor+dt@kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20260806-08-k3-ufs-support-v3-3-037fb322acdb@kernel.org>
References: <20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org>
 <20260806-08-k3-ufs-support-v3-3-037fb322acdb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 03:12:57 +0000
Message-Id: <20260806031259.01EF91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Failure to enter HIBERN8 state is ignored before forcibly powering=
 down the M-PHY.
- [High] Missing DME attributes configuration for TX lane 1 and inconsisten=
t MIB selector usage.
- [Medium] The retrieved connected TX lanes value is silently discarded.
- [Low] Redundant and ineffective call to `ufshcd_vops_phy_initialization`.
- [Low] The device tree references an undefined clock macro `CLK_APMU_UFS_R=
EFCLK`, which causes a Device Tree compilation failure.
--

--- Patch [3]: [PATCH v3 3/3] riscv: dts: spacemit: k3: Add UFS support ---
commit 7b2ecae3ba0ff920d65fce0475cce3fc5045f08d
Author: Yixun Lan <dlan@kernel.org>
Subject: riscv: dts: spacemit: k3: Add UFS support

Add UFS Host Controller support for SpacemiT K3 SoC, and enable
it both on Pico-ITX and CoM260-IFX boards.

> diff --git a/arch/riscv/boot/dts/spacemit/k3.dtsi b/arch/riscv/boot/dts/s=
pacemit/k3.dtsi
> index 19fc9b49668ed..cee1569608ea2 100644
> --- a/arch/riscv/boot/dts/spacemit/k3.dtsi
> +++ b/arch/riscv/boot/dts/spacemit/k3.dtsi
> @@ -469,6 +469,28 @@ usb2_phy: phy@c0a20000 {
>  			status =3D "disabled";
>  		};
> =20
> +		ufshc: ufshc@c0e00000 {
> +			compatible =3D "spacemit,k3-ufshc";
> +			reg =3D <0x0 0xc0e00000 0x0 0x40000>;
> +			clocks =3D <&syscon_apmu CLK_APMU_UFS_ACLK>,
> +				 <&syscon_apmu CLK_APMU_UFS_REFCLK>;

[Severity: Low]
Does this reference an undefined clock macro?

The device tree references CLK_APMU_UFS_REFCLK, but this macro appears to be
undefined. Will this cause a compilation failure when building the device t=
ree?

[ ... ]

> diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-space=
mit.c
> new file mode 100644
> index 0000000000000..94942ea27fb7d
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.c
> @@ -0,0 +1,687 @@

[ ... ]

> +static int ufs_spacemit_uniprov1p6_init(struct ufs_hba *hba)
> +{
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {

[ ... ]

> +		/* TX HB8_TIME CAP */
> +		{ UIC_ARG_MIB_SEL(0x000F, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x64 },
> +		{ UIC_ARG_MIB_SEL(0x000F, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)), 0x64 },
> +		/* RX HB8_TIME CAP */
> +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x64 },
> +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x64 },
> +		/* TX EQ 3DB */
> +		{ UIC_ARG_MIB_SEL(0x00CD, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),  0x5 },

[Severity: High]
Are we missing the TX EQ 3DB configuration for lane 1 here?

The device tree specifies lanes-per-direction =3D <2>, but this DME attribu=
te
is only configured for TX lane 0. Could this leave lane 1 with undefined or
default parameters and prevent successful 2-lane initialization?

[ ... ]

> +static int ufs_spacemit_link_startup_post_change(struct ufs_hba *hba)
> +{
> +	/* Add 0xe8 make UFS2.1 run GEAR3 + 2Lane@409M */
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {
> +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x97 },
> +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0xd7 },
> +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x17 },

[Severity: High]
Is the DME configuration for TX lane 1 missing?

Similar to ufs_spacemit_uniprov1p6_init(), attribute 0xe8 is explicitly
targeting only lane 0. Does lane 1 also need to be configured for 2-lane mo=
de?

> +		{ UIC_ARG_MIB(DL_AFC0REQTIMEOUTVAL), UFS_DL_AFC0REQTIMEOUTVAL_MAX },
> +	};
> +	u32 tx_lanes;
> +	int err;
> +
> +	err =3D ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> +	if (err < 0)
> +		return err;
> +
> +	return ufs_spacemit_get_connected_tx_lanes(hba, &tx_lanes);

[Severity: Medium]
Is the retrieved tx_lanes value meant to be used?

The value of tx_lanes is populated by ufs_spacemit_get_connected_tx_lanes()
but is then silently discarded when returning. Should this value be verified
against the configuration?

[ ... ]

> +static void ufs_spacemit_post_hibern8(struct ufs_hba *hba, enum uic_cmd_=
dme cmd)
> +{
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x84 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x84 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x80 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x80 },
> +		{ UIC_ARG_MIB(0xdd), 0x57 },
> +		{ UIC_ARG_MIB(0xdd), 0xd7 },
> +		{ UIC_ARG_MIB(0xe8), 0x57 },
> +		{ UIC_ARG_MIB(0xe8), 0xd7 },
> +	};
> +
> +	if (cmd =3D=3D UIC_CMD_DME_HIBER_ENTER) {
> +		ufs_spacemit_check_hibern8(hba);
> +
> +		ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> +
> +		/* Power down M-PHY */
> +		ufshcd_writel(hba, 0x0, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);

[Severity: High]
Should we check the return value of ufs_spacemit_check_hibern8(hba) before
powering down the M-PHY?

If the HIBERN8 check times out and returns -ETIMEDOUT, the error is ignored
and the driver unconditionally powers down the PHY. Can this cause a bus lo=
ckup
or hardware error if the M-PHY isn't actually in the HIBERN8 state?

[ ... ]

> +static int ufs_spacemit_init(struct ufs_hba *hba)
> +{
> +	int err =3D 0;
> +	struct device *dev =3D hba->dev;
> +	struct ufs_spacemit_host *host;
> +	struct reset_control *rst;
> +
> +	host =3D devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> +	if (!host)
> +		return -ENOMEM;
> +
> +	rst =3D devm_reset_control_get_exclusive_deasserted(dev, NULL);
> +	if (IS_ERR(rst))
> +		return dev_err_probe(dev, PTR_ERR(rst), "Failed to get reset control\n=
");
> +
> +	host->hba =3D hba;
> +	ufshcd_set_variant(hba, host);
> +	ufs_spacemit_advertise_quirks(hba);
> +
> +	err =3D ufshcd_vops_phy_initialization(host->hba);
> +	return err;
> +}

[Severity: Low]
Is this call to ufshcd_vops_phy_initialization() effective?

ufs_hba_spacemit_vops does not define the phy_initialization callback, so
the wrapper function will silently return 0. Does this need to be called he=
re,
or is it redundant since the real PHY initialization occurs in
ufs_spacemit_link_startup_pre_change()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806-08-k3-ufs-=
support-v3-0-037fb322acdb@kernel.org?part=3D3
