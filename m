Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931F4472543;
	Fri,  2 Oct 2026 09:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932469; cv=none; b=FitQTPiOf6Fo2xpy6yEzeLBpFaIWYgsoYJvs85FHHQivL20ZbK3YMAUG1sYumvIH6H/I0DXqqa9twM5tmlwmRv2+BvNnHb0TpIZH6xk1KdSOK8tFAaybW9ysgmH37Pk0ZAY8XMmDb5w6YO9ZBWpL031OjxcztxRvIjlP6n18UVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932469; c=relaxed/simple;
	bh=8a5M2UzdE9erIc40zaFKfBubjXN33wBfKyZk5Y+CYQU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Fr47NbPFsPA/HPoLs+nb/ArdykGN/WGji8EP2NihUvXAVjWCzgXesOMwUVJ1ofnT4NGm7StkorncRH1Aihilyi6Q/vJcpvcMd4ZJfrfPL+i2V3RxjzFsZrOjLPkIkp3MCoNM1B3VVyZyjjyA6l7fuFljfApx7MsobgMnypJmNwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WsPaLk1Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WsPaLk1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D671F0089B;
	Fri,  2 Oct 2026 09:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932468;
	bh=PLiMLe5i2c7cYYrJ2ruLw0LhUXzOc1w4t4yCcfmU7RQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WsPaLk1QQ3kwK/sFZwnLg22osTL8PmYuaUwr4Ryv9/rIwnutVBWBCOdZ4ivRUl9Wl
	 wYYZhP7Qze5e6BGfgrmDIxffImPtuenny1ChTXOmBZkoLgZ8DuHqv+kBRqm5H1fjUD
	 gZwaFLusBOWjFV6sh1ndbEAyvsHzsdmrmrZBaP1v1x3iG6VKYAqU+I7blle/PvFjWN
	 O++PGbd0JDlW+7M2aa6ElBLNnUbo1jTeiZT4sQAZTw5VmU7BV8cMa3qldbNnC0UNg+
	 j991YtR+QTj42KwQ4GlySvHlrvuSPEKgmeWuXtppwwqwHk7qFgJ5+Z8Lq2KliAd/UI
	 bRWZiC4e897vw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 2/2] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yixun Lan" <dlan@kernel.org>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org
In-Reply-To: <20261002-08-k3-ufs-support-v7-2-bb39007ff9ae@kernel.org>
References: <20261002-08-k3-ufs-support-v7-0-bb39007ff9ae@kernel.org>
 <20261002-08-k3-ufs-support-v7-2-bb39007ff9ae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:14:27 +0000
Message-Id: <20261002091428.35D671F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] scsi: ufs: spacemit: 100ms timeout on 1-lane UFS devices during =
hibern8
- [Medium] scsi: ufs: spacemit: bRefClkGatingWaitTime violation after hiber=
n8 enter
- [Medium] scsi: ufs: spacemit: simultaneous ref clock enable and reset de-=
assertion
--

commit efcda2c96a818b5a53e91fa2558654c937a9ba68
Author: Yixun Lan <dlan@kernel.org>

scsi: ufs: spacemit: k3: Add UFS Host Controller driver

This commit introduces the UFS Host Controller driver for the SpacemiT K3
SoC. It implements support for features compatible with JEDEC UFS 2.2, MIPI
UniPro v1.61, and the M-PHY v3.0 standard.

> diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-space=
mit.c
> new file mode 100644
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

[Severity: Medium]
Will this loop always hit its 100ms timeout on 1-lane UFS devices?

It appears that on a 1-lane device, the state for lane 1 will not reach
TX_FSM_HIBERN8, causing the do-while condition to wait until retries run out
before proceeding.

[ ... ]

> +static int ufs_spacemit_device_reset(struct ufs_hba *hba)
> +{
> +	/* Disable reference clock & asserted ufs device reset */
> +	ufshcd_writel(hba, 0x000, UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> +	usleep_range(10, 15);
> +
> +	/* Enable reference clock & deassert ufs device reset */
> +	ufshcd_writel(hba, MPHY_DEVICE_REFCLK_OE | MPHY_DEVICE_HW_RESET,
> +		      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);

[Severity: Medium]
Could toggling the reference clock output enable and device reset
de-assertion in a single MMIO write cause device initialization failures?

The UFS specification (e.g., JESD220C 5.3.1.2) typically requires the
reference clock to be valid and stable before RST_n is de-asserted. Writing
MPHY_DEVICE_REFCLK_OE and MPHY_DEVICE_HW_RESET simultaneously might violate
this sequential stability requirement.

[ ... ]

> +static void ufs_spacemit_post_hibern8(struct ufs_hba *hba, enum uic_cmd_=
dme cmd)
> +{

[ ... ]

> +	if (cmd =3D=3D UIC_CMD_DME_HIBER_ENTER) {
> +		err =3D ufs_spacemit_check_hibern8(hba);
> +		if (err)
> +			dev_err(hba->dev, "ufs_spacemit_check_hibern8 error\n");
> +
> +		ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> +
> +		/* Power down M-PHY */
> +		ufshcd_writel(hba, 0x0, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +
> +		/* Disable reference clock, keep device reset deasserted */
> +		ufshcd_writel(hba, MPHY_DEVICE_HW_RESET,
> +			      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> +	}
> +}

[Severity: Medium]
Does disabling the reference clock immediately after confirming HIBERN8
enter violate the device's clock gating wait time?

By not waiting for hba->dev_info.clk_gating_wait_us (bRefClkGatingWaitTime)
before disabling the clock, this could potentially cause strict UFS devices
to hang or fail internal state transitions during hibernation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002-08-k3-ufs-=
support-v7-0-bb39007ff9ae@kernel.org?part=3D2
