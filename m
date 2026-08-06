Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2610B1DE8BF;
	Thu,  6 Aug 2026 03:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785985823; cv=none; b=ldjz1KMB4AOzG/0PWjaKQFP3XsMXV4FeNCh+2NIoiM4zvERb8h5XQaVuuCDpYMwemi2LIi97wkOMNqHWKteHKEtbwAZNmsIG+O4qOxCXg/svxWy8vzrq+QYTigScSeZMbcHOJaEghwfsfp+mAJyv4KhCp7uvZYpnxHp/PYDR8H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785985823; c=relaxed/simple;
	bh=78fM8o0eQ9v74NxSVDnRgUVAxwusRmHGPPGwFbDidrU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=h3fNfhpY/uK1Mk3nnJXpiIdjdbQi50pfvPcO07l7bw2EeK6HISGuxUJv9Qk+LKBniKYJaasBafaYbE442q4NuXJ8Pyj4KWKzfGFnJ6vkeC81gI3pn3fHam1GI2FHmQQ03noQ1V2UxoB4roFWGmtXAshHXvOYLCeoL91qoY/v7T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jcnusuxv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jcnusuxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DDF1F000E9;
	Thu,  6 Aug 2026 03:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785985821;
	bh=KCpUbMG/WEWePO1ZTE2T9wN4A6JKKxRzVQem+ZWe3f8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jcnusuxvIPzuCadswfvrEYj9H2r6dBi1abLkqor+RxrFLx2H+JkvAaU2MsDKgihhC
	 KZe7mAZ3sU3uejmypUSqCTZlWCBxDGQSqWS6aO8LSAakG+e0rMJL9k7eHe46qGryit
	 odL/HVwEqsqxejKvhV9j9ayy74hv87InIEw4kZq9d0Ca34dLGleJNZOvsPX5tG4THc
	 cgvlAff7NrJPHJyviwIrYmq5utZmL4p+fRXYbEPWjyQskQ2vlua/xVux4s2+YBZEad
	 7uDXLREAusTVux1/E+/mVoVQPMQ+bA4U3a3GVcLcpMaUu0f/OqeHYuakbbRscuvkny
	 2jMU2zTj5lGXQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yixun Lan" <dlan@kernel.org>
Cc: linux-scsi@vger.kernel.org, robh@kernel.org, devicetree@vger.kernel.org, conor+dt@kernel.org
In-Reply-To: <20260806-08-k3-ufs-support-v3-2-037fb322acdb@kernel.org>
References: <20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org>
 <20260806-08-k3-ufs-support-v3-2-037fb322acdb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 03:10:20 +0000
Message-Id: <20260806031021.75DDF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] Vendor M-PHY TX attributes are only configured for TX Lane 0, negl=
ecting Lane 1 in a 2-lane setup.
- [High] Hardcoded dual-lane check in `ufs_spacemit_check_hibern8` will fai=
l and timeout on 1-lane UFS devices.
- [High] The UFS hardware reset pulse width is too short, violating the JED=
EC UFS specification.
- [Medium] Misleading macro names and comments for device reset contradict =
hardware behavior.
- [Medium] Silently ignoring DME configuration errors.
- [Low] Usage of `of_match_ptr` causes build warnings when `CONFIG_OF` is d=
isabled.
--

--- Patch [2]: [PATCH v3 2/3] scsi: ufs: spacemit: k3: Add UFS Host Control=
ler driver ---
commit a6bb8f511d306cddb9d21e41123fafdbcd63a6c9
Author: Yixun Lan <dlan@kernel.org>
Subject: scsi: ufs: spacemit: k3: Add UFS Host Controller driver

SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
M-PHY v3.0 standard.

> diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-space=
mit.c
> new file mode 100644
> index 0000000000000..94942ea27fb7d
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.c

[ ... ]

> +/* PHY register magic values */
> +#define MPHY_PU_ALL			0x87f
> +#define MPHY_PU_WITH_HB8_RESET		0xb7f
> +#define MPHY_DEVICE_RESET_DEASSERT	0x101
> +#define MPHY_DEVICE_RESET_ASSERT	0x001

[Severity: Medium]
Is this macro name misleading? Looking at ufs_spacemit_device_reset(), it
uses 0x000 to assert the reset and 0x101 to de-assert it. This means 0x001
actually disables the reference clock while keeping the reset de-asserted.

[ ... ]

> +static int ufs_spacemit_check_hibern8(struct ufs_hba *hba)
> +{
> +	u32 tx_fsm_val_0 =3D 0;
> +	u32 tx_fsm_val_1 =3D 0;
> +	int retries =3D DIV_ROUND_UP(HBRN8_POLL_TOUT_MS * 1000, 100);
> +	int err =3D 0;
> +
> +	do {
> +		err =3D ufshcd_dme_get(hba,
> +				     UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> +						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
> +				     &tx_fsm_val_0);
> +		if (err)
> +			break;
> +
> +		err =3D ufshcd_dme_get(hba,
> +				     UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> +						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)),
> +				     &tx_fsm_val_1);
> +		if (err || (tx_fsm_val_0 =3D=3D TX_FSM_HIBERN8 &&
> +			    tx_fsm_val_1 =3D=3D TX_FSM_HIBERN8))
> +			break;

[Severity: High]
Will this hardcoded dual-lane check timeout on single-lane UFS devices?

If a 1-lane memory chip is connected, Lane 1 is inactive. Querying its state
will either return a DME error or read a non-Hibern8 state, causing the loop
to timeout after 100ms and break power management.

Could this check be updated to use the dynamically negotiated lane count fr=
om
dev_req_params to know how many lanes to poll?

[ ... ]

> +static int ufs_spacemit_uniprov1p6_init(struct ufs_hba *hba)
> +{
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {
> +		{ UIC_ARG_MIB(0x1552), 0x4f }, /* PA_TXHSG1SYNCLENGTH */
[ ... ]
> +		/* RX HB8_TIME CAP */
> +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x64 },
> +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x64 },
> +		/* TX EQ 3DB */
> +		{ UIC_ARG_MIB_SEL(0x00CD, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),  0x5 },

[Severity: High]
Should this TX equalization be applied to Lane 1 as well?

The host controller is configured for 2 lanes, but this setup attribute only
targets UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0). Omitting tuning parameters for the
second lane could cause asymmetric lane configurations or link instability.

[ ... ]

> +static int ufs_spacemit_link_startup_post_change(struct ufs_hba *hba)
> +{
> +	/* Add 0xe8 make UFS2.1 run GEAR3 + 2Lane@409M */
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {
> +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x97 },
> +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0xd7 },
> +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x17 },

[Severity: High]
Does attribute 0xe8 need to be programmed for both lanes?

Similar to the TX equalization setup, this only programs Lane 0 despite the
driver specifying dual-lane support.

[ ... ]

> +static int ufs_spacemit_apply_dev_quirks(struct ufs_hba *hba)
> +{
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {
[ ... ]
> +	};
> +
> +	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME)
> +		ufs_spacemit_quirk_host_pa_saveconfigtime(hba);
> +
> +	if (hba->dev_info.wmanufacturerid =3D=3D UFS_VENDOR_WDC)
> +		hba->dev_quirks |=3D UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE;
> +
> +	ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));

[Severity: Medium]
Is it safe to ignore the return values of these DME configuration functions?

If ufs_spacemit_quirk_host_pa_saveconfigtime() or ufs_spacemit_dme_set()
fail, the errors are not propagated. Could this allow initialization to pro=
ceed
with an incorrectly configured M-PHY?

[ ... ]

> +static int ufs_spacemit_device_reset(struct ufs_hba *hba)
> +{
> +	/* Stop device ref_clk & asserted ufs device reset */
> +	ufshcd_writel(hba, 0x000, UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> +	usleep_range(10, 15);

[Severity: High]
Is this reset pulse width long enough?

The JEDEC UFS specification mandates that the host must maintain the RST_n
signal low for a minimum of 1 ms. A 10 to 15 microsecond delay might cause
the memory chip to fail to reset properly.

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

[Severity: High]
Are these attributes defaulting to Lane 0?

Using UIC_ARG_MIB() defaults to Lane 0. If these need to be applied to Lane=
 1
as well during post-Hibern8 configuration, they are currently missing.

[ ... ]

> +	if (cmd =3D=3D UIC_CMD_DME_HIBER_ENTER) {
> +		ufs_spacemit_check_hibern8(hba);
> +
> +		ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> +
> +		/* Power down M-PHY */
> +		ufshcd_writel(hba, 0x0, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +
> +		/* Keep reference clock enabled, assert device reset */
> +		ufshcd_writel(hba, MPHY_DEVICE_RESET_ASSERT,
> +			      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);

[Severity: Medium]
Does this operation contradict its comment?

The code writes MPHY_DEVICE_RESET_ASSERT (0x001), which disables the refere=
nce
clock but keeps the reset de-asserted. The comment says "Keep reference clo=
ck
enabled, assert device reset", which is the exact opposite.

While keeping reset de-asserted is the correct action for Hibern8 (asserting
reset would destroy the device's state), the comment and macro name suggest
incorrect hardware behavior.

[ ... ]

> +static struct platform_driver ufs_spacemit_pltform =3D {
> +	.probe	=3D ufs_spacemit_probe,
> +	.remove	=3D ufs_spacemit_remove,
> +	.driver	=3D {
> +		.name	=3D "ufshcd-spacemit",
> +		.of_match_table =3D of_match_ptr(ufs_spacemit_of_match),
> +	},
> +};

[Severity: Low]
Does the use of of_match_ptr() here cause a compiler warning?

Because ufs_spacemit_of_match is defined unconditionally, building with
CONFIG_OF disabled will evaluate of_match_ptr() to NULL, leaving the array
unused and triggering a -Wunused-variable warning.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806-08-k3-ufs-=
support-v3-0-037fb322acdb@kernel.org?part=3D2
