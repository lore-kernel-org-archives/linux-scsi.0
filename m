Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958D2372B3C;
	Tue,  8 Sep 2026 07:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788851410; cv=none; b=IfNb+Kq3flCg+z+g4OSXh/fnC4A9R8IOjKLIhZuMfIWB6NUt18I90yM2OnGx5x0+qAAYdC5RlE0zlAw6dMqoQSH1F0BfBgkOASXZFzNzan69Gb1EVRoo4J7UZntH7FBwuhaM5FBAOGXqvTzwAMTJJWkr1ufb8l8RUTWlXA88Lww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788851410; c=relaxed/simple;
	bh=9I/F2D/VeTFND7TmCx4VAvkT0VihmIR6iZEsj1zartE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MDZtom3MF5592kzDezrNTb+Y2PhsnnDAsO4sIHCM3oK3R1nXH+mv61VpWjq3zUUuoPnopat+k5qUyA5O3cgsOqzRppe7zIgzD8UrWQ0yCfTk04T9hVobRpLIJzgexcy+dqIsAnpaebQLfi0ED2sDFX3fuUINJBZijtnlSRrHOhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AELUli2+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AELUli2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6641F00A3A;
	Tue,  8 Sep 2026 07:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788851408;
	bh=tASNgWLVTewlPxH9GFItCaaNFjGZpPtTNZ4AsX2lYbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AELUli2++W+6IC7Q2pnh/aDqU3jAPlJxSfmPEX4tN32DDcO7NeRqXvkBvmzy1ICVF
	 rSaE9HpWuapopCKjHYTuvhTUOutqD0cEqeiVH0w64k9scZm58F70dwyQNtmGUOCFSd
	 Ve5U43ctxIDIy6pBGZyc7p0dT/VLiEM2LdAuP0g7dMNTCZXna3nCypNz2ujAO6wrUM
	 e2RVY2tRmhufR7h0Wtn2yRONVAbESnQF3cTqFk6MXM+JHp98hMF7z2691L5ghz06W7
	 +FyZz/Ya2cgeP6oXZWHfspQinwlh9IQL7b5fBJwi0j6TZQ5go4lG13CtAc/XRKTdZb
	 vtdumZ7ZScHsQ==
Date: Tue, 8 Sep 2026 07:10:04 +0000
From: Yixun Lan <dlan@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: conor+dt@kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org,
	devicetree@vger.kernel.org, spacemit@lists.linux.dev
Subject: Re: [PATCH v3 3/3] riscv: dts: spacemit: k3: Add UFS support
Message-ID: <20260908071004-GKB2346@kernel.org>
References: <20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org>
 <20260806-08-k3-ufs-support-v3-3-037fb322acdb@kernel.org>
 <20260806031259.01EF91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260806031259.01EF91F000E9@smtp.kernel.org>

Hi All,

On 03:12 Thu 06 Aug     , sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> - [High] Failure to enter HIBERN8 state is ignored before forcibly powering down the M-PHY.
> - [High] Missing DME attributes configuration for TX lane 1 and inconsistent MIB selector usage.
> - [Medium] The retrieved connected TX lanes value is silently discarded.
> - [Low] Redundant and ineffective call to `ufshcd_vops_phy_initialization`.
> - [Low] The device tree references an undefined clock macro `CLK_APMU_UFS_REFCLK`, which causes a Device Tree compilation failure.
> --
> 
> --- Patch [3]: [PATCH v3 3/3] riscv: dts: spacemit: k3: Add UFS support ---
> commit 7b2ecae3ba0ff920d65fce0475cce3fc5045f08d
> Author: Yixun Lan <dlan@kernel.org>
> Subject: riscv: dts: spacemit: k3: Add UFS support
> 
> Add UFS Host Controller support for SpacemiT K3 SoC, and enable
> it both on Pico-ITX and CoM260-IFX boards.
> 
> > diff --git a/arch/riscv/boot/dts/spacemit/k3.dtsi b/arch/riscv/boot/dts/spacemit/k3.dtsi
> > index 19fc9b49668ed..cee1569608ea2 100644
> > --- a/arch/riscv/boot/dts/spacemit/k3.dtsi
> > +++ b/arch/riscv/boot/dts/spacemit/k3.dtsi
> > @@ -469,6 +469,28 @@ usb2_phy: phy@c0a20000 {
> >  			status = "disabled";
> >  		};
> >  
> > +		ufshc: ufshc@c0e00000 {
> > +			compatible = "spacemit,k3-ufshc";
> > +			reg = <0x0 0xc0e00000 0x0 0x40000>;
> > +			clocks = <&syscon_apmu CLK_APMU_UFS_ACLK>,
> > +				 <&syscon_apmu CLK_APMU_UFS_REFCLK>;
> 
> [Severity: Low]
> Does this reference an undefined clock macro?
> 
> The device tree references CLK_APMU_UFS_REFCLK, but this macro appears to be
> undefined. Will this cause a compilation failure when building the device tree?
> 
this should be solved in v7.3-rc1, which ufs clock driver has been merged

> [ ... ]
> 
> > diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-spacemit.c
> > new file mode 100644
> > index 0000000000000..94942ea27fb7d
> > --- /dev/null
> > +++ b/drivers/ufs/host/ufs-spacemit.c
> > @@ -0,0 +1,687 @@
> 
> [ ... ]
> 
> > +static int ufs_spacemit_uniprov1p6_init(struct ufs_hba *hba)
> > +{
> > +	static const struct ufshcd_dme_attr_val setup_attrs[] = {
> 
> [ ... ]
> 
> > +		/* TX HB8_TIME CAP */
> > +		{ UIC_ARG_MIB_SEL(0x000F, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x64 },
> > +		{ UIC_ARG_MIB_SEL(0x000F, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)), 0x64 },
> > +		/* RX HB8_TIME CAP */
> > +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x64 },
> > +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x64 },
> > +		/* TX EQ 3DB */
> > +		{ UIC_ARG_MIB_SEL(0x00CD, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),  0x5 },
> 
> [Severity: High]
> Are we missing the TX EQ 3DB configuration for lane 1 here?
> 
> The device tree specifies lanes-per-direction = <2>, but this DME attribute
> is only configured for TX lane 0. Could this leave lane 1 with undefined or
> default parameters and prevent successful 2-lane initialization?
> 
No need, false report..
The configuration ally to lane 1 too
> [ ... ]
> 
> > +static int ufs_spacemit_link_startup_post_change(struct ufs_hba *hba)
> > +{
> > +	/* Add 0xe8 make UFS2.1 run GEAR3 + 2Lane@409M */
> > +	static const struct ufshcd_dme_attr_val setup_attrs[] = {
> > +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x97 },
> > +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0xd7 },
> > +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x17 },
> 
> [Severity: High]
> Is the DME configuration for TX lane 1 missing?
> 
> Similar to ufs_spacemit_uniprov1p6_init(), attribute 0xe8 is explicitly
> targeting only lane 0. Does lane 1 also need to be configured for 2-lane mode?
> 
no need, false report
same reason as above

> > +		{ UIC_ARG_MIB(DL_AFC0REQTIMEOUTVAL), UFS_DL_AFC0REQTIMEOUTVAL_MAX },
> > +	};
> > +	u32 tx_lanes;
> > +	int err;
> > +
> > +	err = ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> > +	if (err < 0)
> > +		return err;
> > +
> > +	return ufs_spacemit_get_connected_tx_lanes(hba, &tx_lanes);
> 
> [Severity: Medium]
> Is the retrieved tx_lanes value meant to be used?
> 
> The value of tx_lanes is populated by ufs_spacemit_get_connected_tx_lanes()
> but is then silently discarded when returning. Should this value be verified
> against the configuration?
> 
tx_lanes is not used, I will drop this

> [ ... ]
> 
> > +static void ufs_spacemit_post_hibern8(struct ufs_hba *hba, enum uic_cmd_dme cmd)
> > +{
> > +	static const struct ufshcd_dme_attr_val setup_attrs[] = {
> > +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x84 },
> > +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x84 },
> > +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x80 },
> > +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x80 },
> > +		{ UIC_ARG_MIB(0xdd), 0x57 },
> > +		{ UIC_ARG_MIB(0xdd), 0xd7 },
> > +		{ UIC_ARG_MIB(0xe8), 0x57 },
> > +		{ UIC_ARG_MIB(0xe8), 0xd7 },
> > +	};
> > +
> > +	if (cmd == UIC_CMD_DME_HIBER_ENTER) {
> > +		ufs_spacemit_check_hibern8(hba);
> > +
> > +		ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> > +
> > +		/* Power down M-PHY */
> > +		ufshcd_writel(hba, 0x0, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> 
> [Severity: High]
> Should we check the return value of ufs_spacemit_check_hibern8(hba) before
> powering down the M-PHY?
> 
will check return value, and give a warning 

> If the HIBERN8 check times out and returns -ETIMEDOUT, the error is ignored
> and the driver unconditionally powers down the PHY. Can this cause a bus lockup
> or hardware error if the M-PHY isn't actually in the HIBERN8 state?
> 
I'm not sure what's the best way to deal with this.. any suggestion?

> [ ... ]
> 
> > +static int ufs_spacemit_init(struct ufs_hba *hba)
> > +{
> > +	int err = 0;
> > +	struct device *dev = hba->dev;
> > +	struct ufs_spacemit_host *host;
> > +	struct reset_control *rst;
> > +
> > +	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> > +	if (!host)
> > +		return -ENOMEM;
> > +
> > +	rst = devm_reset_control_get_exclusive_deasserted(dev, NULL);
> > +	if (IS_ERR(rst))
> > +		return dev_err_probe(dev, PTR_ERR(rst), "Failed to get reset control\n");
> > +
> > +	host->hba = hba;
> > +	ufshcd_set_variant(hba, host);
> > +	ufs_spacemit_advertise_quirks(hba);
> > +
> > +	err = ufshcd_vops_phy_initialization(host->hba);
> > +	return err;
> > +}
> 
> [Severity: Low]
> Is this call to ufshcd_vops_phy_initialization() effective?
> 
> ufs_hba_spacemit_vops does not define the phy_initialization callback, so
> the wrapper function will silently return 0. Does this need to be called here,
> or is it redundant since the real PHY initialization occurs in
> ufs_spacemit_link_startup_pre_change()?

Indeed, there is no phy_initialization(), I will drop this code
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org?part=3

-- 
Yixun Lan (dlan)
