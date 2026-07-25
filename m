Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0413EAC8D;
	Sat, 25 Jul 2026 10:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784976530; cv=none; b=oXuyr6Mfm32e8qq0JXDUlMtzFGeaGXwVujPxlgs1yiaZ51eScOCfjS0J+k01SvCALuE3zPC5mZefX0tMQJpDH0Ed1Nefac7w03F26gbq2foQCx36+ftejw2P0u2rQlEuzeHBcOfjCFvVZiwYZk9UnTKJt+2zov5Q8S3A5qPFnqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784976530; c=relaxed/simple;
	bh=/k1kCd1nc1/D4EnbnXh1IKqLykcnVHXQNg8TRhX5SOs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YzGb29gpJsP8d2kSbC11NIaZT5ouG1Py0TqICYwiGk8fQw28Gb2eR0xyWc8G+wT51nxCw8Q9RGfJBwGvjqs8fSNayPzJ2sG5oF9vpr4axsVj1yi/moGqMtjchUH/alPF16rK5EN3TZ7x1+eu3FDXNVJBoCq6Qq4V3HnjTnKDE0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5HokVJ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5HokVJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971611F000E9;
	Sat, 25 Jul 2026 10:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784976528;
	bh=4CToTZ38567IveF5/p5rXomOK8ecia3QYw9AKendGgo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O5HokVJ1BNqgY7eliYZcakBP9KdkyMvO/y4DXZyEjZ1zD9dHmy5DG5PtUqmFgSu8i
	 eKFMVADrVFrBc+Cmlckf3I2qefP46ss6jFYRtLBitAV50lCoV5pGNw7w54DxzesAvS
	 f3l1xvNlhhr7y8Z+Mw+nhkBDWkWSMca5sjwPYTOZELopwQFdR29DgL3osPGXGYUIg0
	 GDG7LrdjyUOW907w6FJEEI1IRu8ULY33se1fz8J321F1RY2ZZ2JnRhHgURun6jigSt
	 +UWwxGV+KxmafyGWYXRq7Lrcvm6jSWus06nMxIJNhf2g0gWIe4ih+4aXd+UkC5Gpek
	 wfIGRP2j6Afeg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yixun Lan" <dlan@kernel.org>
Cc: devicetree@vger.kernel.org, robh@kernel.org, linux-scsi@vger.kernel.org, conor+dt@kernel.org
In-Reply-To: <20260725-08-k3-ufs-support-v2-2-45036a2a2418@kernel.org>
References: <20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org>
 <20260725-08-k3-ufs-support-v2-2-45036a2a2418@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 25 Jul 2026 10:48:48 +0000
Message-Id: <20260725104848.971611F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] The host driver asserts the physical device reset pin during Hiber=
n8 (runtime PM suspend), wiping the UFS device state.
- [High] Failure error codes from essential DME configurations and M-PHY in=
itialization are silently ignored.
- [High] Missing Power Management (PM) operations in the platform driver.
- [Medium] Bitwise OR is used on negative integer error codes from `ufshcd_=
dme_get`.
--

--- Patch [2]: [PATCH v2 2/3] scsi: ufs: spacemit: k3: Add UFS Host Control=
ler driver ---
commit 7cc317e95f9d6ed1949a4f8f4ae915ca4f1bb1f3
Author: Yixun Lan <dlan@kernel.org>

scsi: ufs: spacemit: k3: Add UFS Host Controller driver

This commit adds a new UFS Host Controller driver for the SpacemiT K3 SoC.
The controller supports features compatible with JEDEC UFS 2.2, MIPI UniPro
v1.61 and M-PHY v3.0 standards.

> diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-space=
mit.c
> new file mode 100644
> index 0000000000000..30e5092071af8
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.c

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
> +		err |=3D ufshcd_dme_get(hba,
> +				      UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> +						      UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)),
> +				      &tx_fsm_val_1);

[Severity: Medium]
Does using the bitwise OR operator here corrupt the error codes?

ufshcd_dme_get() returns standard negative error codes like -EINVAL. Perfor=
ming
a bitwise OR on two negative two's complement integers produces a mathemati=
cally
meaningless negative value, which will destroy the original error values.

[ ... ]

> +static int ufs_spacemit_link_startup_notify(struct ufs_hba *hba,
> +					    enum ufs_notify_change_status status)
> +{
> +	switch (status) {
> +	case PRE_CHANGE:
> +		ufs_spacemit_link_startup_pre_change(hba);
> +		break;
> +	case POST_CHANGE:
> +		ufs_spacemit_link_startup_post_change(hba);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}

[Severity: High]
Is it safe to ignore the return values from the link startup phases?

If M-PHY initialization fails (e.g., PLL lock timeout) or DME configurations
fail during ufs_spacemit_link_startup_pre_change() or post_change(), the
failure is masked from the core because this function always returns 0.

Could this cause obscure link failures or timeouts later when the hardware
is in an uninitialized or inconsistent state?

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
> +
> +		/* Keep reference clock enabled, assert device reset */
> +		ufshcd_writel(hba, MPHY_DEVICE_RESET_ASSERT,
> +			      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);

[Severity: High]
Does asserting the hardware reset pin during Hibern8 wipe the device state?

Looking at ufs_spacemit_device_reset(), UFS_DEVICE_IO_CTRL controls the phy=
sical
UFS device hardware reset pin (RST_n). Asserting a hard reset during Hibern8
(such as during runtime suspend) wipes the device's internal state and LUN
contexts.

Will the device fail to respond when the core attempts to exit Hibern8
without a full LinkStartup sequence?

[ ... ]

> +static struct platform_driver ufs_spacemit_pltform =3D {
> +	.probe	=3D ufs_spacemit_probe,
> +	.remove	=3D ufs_spacemit_remove,
> +	.driver	=3D {
> +		.name	=3D "ufshcd-spacemit",
> +		.of_match_table =3D of_match_ptr(ufs_spacemit_of_match),
> +	},
> +};
> +module_platform_driver(ufs_spacemit_pltform);

[Severity: High]
Are we missing the power management operations for this platform driver?

Without assigning the .pm field (e.g., to &ufshcd_pltfrm_pm_ops), the UFS h=
ost
controller will not participate in system suspend/resume or runtime PM, whi=
ch
could lead to failure to transition power states or battery drain.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260725-08-k3-ufs-=
support-v2-0-45036a2a2418@kernel.org?part=3D2
