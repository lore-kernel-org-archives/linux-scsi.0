Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4112425392A;
	Tue,  8 Sep 2026 07:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788851608; cv=none; b=n0M73Au8myQVgNiZW/UigL/u7gz0ZdvmFzvcHmCAYwGIzLn3GhFscoudillSOE5KZs3ZiGZdEIGZumViHwKNsuMuhLcyZRljEZSbmcan+HS5PlIcZQGAj7jMIQmUrHH/8TUmIzTwkTUN1q0XQdq+F7JtocFRK3zCSpszy4xCGAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788851608; c=relaxed/simple;
	bh=KRXtATEgrFmLeBNK9LkneRsouu2pp1ENxC6Q8+UuXVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ngn78eJAPJPlT+WgDQKfsYi02PUxEmnbRpkjkea91bVAJAo4k/4QA1i+vPLawsivC52gn2BRML2XVhlXl4uW8zLeAxv96WVlOwr9rhUpcbYCKA2UIQMZuC28CIvWoUFpwm15alSKKOKhTyubodxHrR3K+MU9rEXAyHADrA9TORQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJ9YEedW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJ9YEedW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DA11F00A3A;
	Tue,  8 Sep 2026 07:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788851607;
	bh=sfr6qJVBCy8FPvYCADUyVgs6ZgXF3C++eLzbjQmhwGc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OJ9YEedWHovbxto92C/83HC8gJzoZRDH2hOwYo8Qv77woDEkgRvEYXKaWcVxpvi7x
	 r0ssBFdhTO4JfHQHHP2s7xJvbO31c/VyaIRkfSUqgaqelG8Vr6LckkZAlhXGx78nEY
	 sEva6UsBbBxi19Wdg9DDCfOUzPMOf3mYhxMCRBwhvr7PHDFM81b4Af0vvGyWekqVYa
	 8r7mnSjoBipUybmJDNAwg1dKfgU1C/4HBZ6LMZZip79jipJ82PQVy7eM1iZiq5nZJp
	 Grnkng+sp2vhrYlS5OAjfE2QE9Pra7BV4GHLxRYiU3Z2th1q7Ukex3IpKFHmB/ZlX9
	 283g9AvblXDSw==
Date: Tue, 8 Sep 2026 07:13:24 +0000
From: Yixun Lan <dlan@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, robh@kernel.org, devicetree@vger.kernel.org,
	conor+dt@kernel.org
Subject: Re: [PATCH v3 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <20260908071324-GKE2330@kernel.org>
References: <20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org>
 <20260806-08-k3-ufs-support-v3-2-037fb322acdb@kernel.org>
 <20260806031021.75DDF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260806031021.75DDF1F000E9@smtp.kernel.org>

Hi All,

On 03:10 Thu 06 Aug     , sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential issue(s) to consider:
> - [High] Vendor M-PHY TX attributes are only configured for TX Lane 0, neglecting Lane 1 in a 2-lane setup.
> - [High] Hardcoded dual-lane check in `ufs_spacemit_check_hibern8` will fail and timeout on 1-lane UFS devices.
> - [High] The UFS hardware reset pulse width is too short, violating the JEDEC UFS specification.
> - [Medium] Misleading macro names and comments for device reset contradict hardware behavior.
> - [Medium] Silently ignoring DME configuration errors.
> - [Low] Usage of `of_match_ptr` causes build warnings when `CONFIG_OF` is disabled.
> --
> 
> --- Patch [2]: [PATCH v3 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller driver ---
> commit a6bb8f511d306cddb9d21e41123fafdbcd63a6c9
> Author: Yixun Lan <dlan@kernel.org>
> Subject: scsi: ufs: spacemit: k3: Add UFS Host Controller driver
> 
> SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
> which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
> M-PHY v3.0 standard.
> 
> > diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-spacemit.c
> > new file mode 100644
> > index 0000000000000..94942ea27fb7d
> > --- /dev/null
> > +++ b/drivers/ufs/host/ufs-spacemit.c
> 
> [ ... ]
> 
> > +/* PHY register magic values */
> > +#define MPHY_PU_ALL			0x87f
> > +#define MPHY_PU_WITH_HB8_RESET		0xb7f
> > +#define MPHY_DEVICE_RESET_DEASSERT	0x101
> > +#define MPHY_DEVICE_RESET_ASSERT	0x001
> 
> [Severity: Medium]
> Is this macro name misleading? Looking at ufs_spacemit_device_reset(), it
> uses 0x000 to assert the reset and 0x101 to de-assert it. This means 0x001
> actually disables the reference clock while keeping the reset de-asserted.
> 
Yes, will separate the definition of clock and reset, which something like below, 
and will adjust code accordingly

#define MPHY_DEVICE_REFCLK_OE          BIT(8)
#define MPHY_DEVICE_HW_RESET           BIT(0)


> [ ... ]
> 
> > +static int ufs_spacemit_check_hibern8(struct ufs_hba *hba)
> > +{
> > +	u32 tx_fsm_val_0 = 0;
> > +	u32 tx_fsm_val_1 = 0;
> > +	int retries = DIV_ROUND_UP(HBRN8_POLL_TOUT_MS * 1000, 100);
> > +	int err = 0;
> > +
> > +	do {
> > +		err = ufshcd_dme_get(hba,
> > +				     UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> > +						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
> > +				     &tx_fsm_val_0);
> > +		if (err)
> > +			break;
> > +
> > +		err = ufshcd_dme_get(hba,
> > +				     UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> > +						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)),
> > +				     &tx_fsm_val_1);
> > +		if (err || (tx_fsm_val_0 == TX_FSM_HIBERN8 &&
> > +			    tx_fsm_val_1 == TX_FSM_HIBERN8))
> > +			break;
> 
> [Severity: High]
> Will this hardcoded dual-lane check timeout on single-lane UFS devices?
> 
it seems valid, we shouldn't check lane 1 if single-lane device connected..

> If a 1-lane memory chip is connected, Lane 1 is inactive. Querying its state
> will either return a DME error or read a non-Hibern8 state, causing the loop
> to timeout after 100ms and break power management.
> 
..
> Could this check be updated to use the dynamically negotiated lane count from
> dev_req_params to know how many lanes to poll?
> 
but, I need some suggestion from maintainer to see if I really need to go this
way, currently there is no real single-lane device on K3 platform to test.
I probably will leave this code unchanged for now..

> [ ... ]
> 
> > +static int ufs_spacemit_uniprov1p6_init(struct ufs_hba *hba)
> > +{
> > +	static const struct ufshcd_dme_attr_val setup_attrs[] = {
> > +		{ UIC_ARG_MIB(0x1552), 0x4f }, /* PA_TXHSG1SYNCLENGTH */
> [ ... ]
> > +		/* RX HB8_TIME CAP */
> > +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x64 },
> > +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x64 },
> > +		/* TX EQ 3DB */
> > +		{ UIC_ARG_MIB_SEL(0x00CD, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),  0x5 },
> 
> [Severity: High]
> Should this TX equalization be applied to Lane 1 as well?
> 
Not needed

> The host controller is configured for 2 lanes, but this setup attribute only
> targets UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0). Omitting tuning parameters for the
> second lane could cause asymmetric lane configurations or link instability.
> 
The vendor confirm the configuration will apply to both lanes

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
> Does attribute 0xe8 need to be programmed for both lanes?
> 
No
> Similar to the TX equalization setup, this only programs Lane 0 despite the
> driver specifying dual-lane support.
> 
Similar reason, the settings will apply to 2 lanes, so no need to change

> [ ... ]
> 
> > +static int ufs_spacemit_apply_dev_quirks(struct ufs_hba *hba)
> > +{
> > +	static const struct ufshcd_dme_attr_val setup_attrs[] = {
> [ ... ]
> > +	};
> > +
> > +	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME)
> > +		ufs_spacemit_quirk_host_pa_saveconfigtime(hba);
> > +
> > +	if (hba->dev_info.wmanufacturerid == UFS_VENDOR_WDC)
> > +		hba->dev_quirks |= UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE;
> > +
> > +	ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> 
> [Severity: Medium]
> Is it safe to ignore the return values of these DME configuration functions?
> 
> If ufs_spacemit_quirk_host_pa_saveconfigtime() or ufs_spacemit_dme_set()
> fail, the errors are not propagated. Could this allow initialization to proceed
> with an incorrectly configured M-PHY?
> 
ok, will fix this and propagate error code

> [ ... ]
> 
> > +static int ufs_spacemit_device_reset(struct ufs_hba *hba)
> > +{
> > +	/* Stop device ref_clk & asserted ufs device reset */
> > +	ufshcd_writel(hba, 0x000, UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> > +	usleep_range(10, 15);
> 
> [Severity: High]
> Is this reset pulse width long enough?
> 
yes

> The JEDEC UFS specification mandates that the host must maintain the RST_n
> signal low for a minimum of 1 ms. A 10 to 15 microsecond delay might cause
> the memory chip to fail to reset properly.
> 
this is false report, minimum delay is 1us, give 10 to 15us is sufficient

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
> 
> [Severity: High]
> Are these attributes defaulting to Lane 0?
> 
No, will apply to 2 lanes

> Using UIC_ARG_MIB() defaults to Lane 0. If these need to be applied to Lane 1
> as well during post-Hibern8 configuration, they are currently missing.
> 
It will apply to Lane 1 too, so the code here is correct

> [ ... ]
> 
> > +	if (cmd == UIC_CMD_DME_HIBER_ENTER) {
> > +		ufs_spacemit_check_hibern8(hba);
> > +
> > +		ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> > +
> > +		/* Power down M-PHY */
> > +		ufshcd_writel(hba, 0x0, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> > +
> > +		/* Keep reference clock enabled, assert device reset */
> > +		ufshcd_writel(hba, MPHY_DEVICE_RESET_ASSERT,
> > +			      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> 
> [Severity: Medium]
> Does this operation contradict its comment?
> 
> The code writes MPHY_DEVICE_RESET_ASSERT (0x001), which disables the reference
> clock but keeps the reset de-asserted. The comment says "Keep reference clock
> enabled, assert device reset", which is the exact opposite.
> 
> While keeping reset de-asserted is the correct action for Hibern8 (asserting
> reset would destroy the device's state), the comment and macro name suggest
> incorrect hardware behavior.
> 
will fix this

> [ ... ]
> 
> > +static struct platform_driver ufs_spacemit_pltform = {
> > +	.probe	= ufs_spacemit_probe,
> > +	.remove	= ufs_spacemit_remove,
> > +	.driver	= {
> > +		.name	= "ufshcd-spacemit",
> > +		.of_match_table = of_match_ptr(ufs_spacemit_of_match),
> > +	},
> > +};
> 
> [Severity: Low]
> Does the use of of_match_ptr() here cause a compiler warning?
> 
yes

> Because ufs_spacemit_of_match is defined unconditionally, building with
> CONFIG_OF disabled will evaluate of_match_ptr() to NULL, leaving the array
> unused and triggering a -Wunused-variable warning.
> 
will fix it, will add a __maybe_unused annotate

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org?part=2

-- 
Yixun Lan (dlan)
