Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D9C40F73A;
	Mon,  3 Aug 2026 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764466; cv=none; b=oHoEEasGQEY6F6iVnQgNjmfRz9aETdJXxumaT4m8jBL+668kxOmMM85AtYc4+66OHu1DhK1LuvnCuzIl1GaefDhxaBwgVfdLnAGrs+wcHWHOMketqJ4Q/Z9Xf8wpLvw0NEKHoBEx7isM2grTUTiTr85bnF2O5K+8PCoBJNkz1cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764466; c=relaxed/simple;
	bh=25SKFpv1QTTVXKCOjBnd3SiFiPl5BeDwrMJaUS6kxTI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BuO8ORrJ18X/CYHo9tUmL2jtKEdK7altiNNZp0jSwzq5t7IqXlEHFlFc9sK+Hg3+v0Y+n+MIkeHD3kmMS5MTsV6hc2GKt9eiRWJNkVufMRcnWg06o87h++AakJGNurxyUFBZynXqX0+R31pcmFN5p0DhEtOgR0fplaIMOrtIU3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpKHb8Pe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpKHb8Pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829451F000E9;
	Mon,  3 Aug 2026 13:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785764465;
	bh=rwr6Hg1BMYnjKFBU1U6rymvC8GBDfyq+kH6V3tyk8d4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dpKHb8Pefq4/wjvOGUmLoqVb3r/7LarRVwjg+EFyMSZ1Zg9ceOQJrVty6TEMiu0gl
	 oMv8SX9nu94oEooK2ZnOnFMu/YhjXZbYLtfQG6WpGBwsWNb9oei16H0AKTAsu+ledh
	 LnqHKEclBqoNZfF1s2DeR0ayoq6UJKXdNDzmromZjW3peBA5HYY4dvuvmzDSgOmMui
	 oyTakNvmcVvGdtkgwiCpG8NgG5MS3WrHzDSsISR8CG6usZ64RxILs+yTNdkRja9HLF
	 MOcqqGT5Uox92Bh3bkxBBwkd8hQeF3kyeMWAkZX0wuA+nyu17B16htKm4V7PehAvEU
	 0Y/HJW2YR0fyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/2] phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
Reply-To: sashiko-reviews@lists.linux.dev
To: palash.kambar@oss.qualcomm.com
Cc: vkoul@kernel.org, linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, neil.armstrong@linaro.org, robh@kernel.org, olteanv@gmail.com, devicetree@vger.kernel.org, conor+dt@kernel.org
In-Reply-To: <20260803130852.1432714-2-palash.kambar@oss.qualcomm.com>
References: <20260803130852.1432714-1-palash.kambar@oss.qualcomm.com>
 <20260803130852.1432714-2-palash.kambar@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 13:41:03 +0000
Message-Id: <20260803134104.829451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing UFS_HS_G4 PHY configuration fallback overlay for the Hawi =
SoC, leading to uninitialized critical registers.
--

--- Patch [1]: [PATCH v5 1/2] phy: qcom-qmp-ufs: Add UFS PHY support on Haw=
i ---
commit 4d0cc515a612b40d0f5a7fc9e44b9fbc6b1527fb
Author: Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: phy: qcom-qmp-ufs: Add UFS PHY support on Hawi

Add the init sequence tables and config for the UFS QMP phy found in
the Hawi SoC.

> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualco=
mm/phy-qcom-qmp-ufs.c
> index 0f4ad24aa4058..d4aca22c181e4 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c

[ ... ]

> @@ -1845,6 +1868,119 @@ static const struct qmp_phy_cfg sm8750_ufsphy_cfg=
 =3D {
> =20
>  };
> =20
> +static const struct qmp_phy_init_tbl hawi_ufsphy_serdes[] =3D {

[ ... ]

> +static const struct qmp_phy_cfg hawi_ufsphy_cfg =3D {
> +	.lanes			=3D 2,
> +
> +	.offsets		=3D &qmp_ufs_offsets_v7,
> +	.max_supported_gear	=3D UFS_HS_G5,
> +
> +	.tbls =3D {
> +		.serdes		=3D hawi_ufsphy_serdes,
> +		.serdes_num	=3D ARRAY_SIZE(hawi_ufsphy_serdes),
> +		.tx		=3D hawi_ufsphy_tx,
> +		.tx_num		=3D ARRAY_SIZE(hawi_ufsphy_tx),
> +		.rx		=3D hawi_ufsphy_rx,
> +		.rx_num		=3D ARRAY_SIZE(hawi_ufsphy_rx),
> +		.pcs		=3D hawi_ufsphy_pcs,
> +		.pcs_num	=3D ARRAY_SIZE(hawi_ufsphy_pcs),
> +	},
> +
> +	.tbls_hs_overlay[0] =3D {
> +		.pcs		=3D hawi_ufsphy_g5_pcs,
> +		.pcs_num	=3D ARRAY_SIZE(hawi_ufsphy_g5_pcs),
> +		.max_gear	=3D UFS_HS_G5,
> +	},

[Severity: High]
Does this missing G4 overlay cause initialization to fail when a device
requests HS-G4?

If a UFS 3.1 device is attached (max gear G4) or link training drops to G4,
the host driver will call phy_set_mode() with UFS_HS_G4. Since the
tbls_hs_overlay array only defines an entry for UFS_HS_G5,
qmp_ufs_get_gear_overlay() will return -EINVAL.

This leaves critical PCS registers like QPHY_V7_PCS_UFS_PLL_CNTL,
TX_HSGEAR_CAPABILITY, and RX_HSGEAR_CAPABILITY at their hardware defaults,
which could lead to link failures. Should there be a fallback G4 overlay
defined here?

> +
> +	.vreg_list		=3D hawi_ufsphy_vreg_l,
> +	.num_vregs		=3D ARRAY_SIZE(hawi_ufsphy_vreg_l),
> +	.regs			=3D ufsphy_v7_regs_layout,
> +};

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803130852.1432=
714-1-palash.kambar@oss.qualcomm.com?part=3D1
