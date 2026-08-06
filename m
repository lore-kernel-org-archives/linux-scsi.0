Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750EC383C86;
	Thu,  6 Aug 2026 16:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035399; cv=none; b=oi/pKUEHwhgRYWPM13HKN61IT/3c0KLiU955uan9xgiSP6skKHk5hG1hcvNJQNGsae2IJvjr5y/YFp89JLcVxVzsQuMifKKxZeN8VCFYuJ1Hw9Ps7nuuH4CM5nvWW0yHQE24THrn9zjZmVpaknGpz8KsUn8rUR/33Yr1zdHMan8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035399; c=relaxed/simple;
	bh=mvu9oFVZY3scZvFiz5+udASeKQJTWYRmGxaG8mQ/DQM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S5GTCJdaCcQovNpkDVzkE8qRTFlJG88Tt2coQu7K07H9QUnoohWzi/DZBZs+BHgnllqDQs9QQQ2iBFeDSsEnnungb5BgO0bnPWqLNgEbXu7xr4Oi29uMzeP/b2wTQrSObDxCTpy0L6lNJpH20m4G0s0Bonu4/82mJAroxhMgiLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJHvE8Ue; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJHvE8Ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E41A1F000E9;
	Thu,  6 Aug 2026 16:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786035398;
	bh=jQalDzxS4F0x5EYDYWJ38lpm4ErORvj/HvawwC8RNU8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CJHvE8UeK6g0Q/nkJVrZ9dMbRr+2R73DUYQ/u1NZ7K4hkbHErHBlCaBVTVe36Bn/K
	 GqG+nGhxejIUCO8fN/5zNCwxBNB5U3jPogsqFntzDEw535k+k/mC751zHZDcrWdVVe
	 jeFbrgorWskrjs/qXGO0+AEKEGRNoXOKOacNZ5y9yjKI+8mBkkoAuD916+5TPet16q
	 JrmkMvKNxxg1i0UBSbOfa53IBoC7CbbJRM+YV6Efq8HWux+I78aeuforPUwlnH5z8s
	 43XsUO2PMgGHf/Yi5RiHZiHcxWm7bcbZVrJwLe2xdAADUd7EwUo2B3k/MKuQAwhmMP
	 dEbUogmm/m9fQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 2/2] phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
Reply-To: sashiko-reviews@lists.linux.dev
To: palash.kambar@oss.qualcomm.com
Cc: vkoul@kernel.org, linux-scsi@vger.kernel.org, neil.armstrong@linaro.org, robh@kernel.org, devicetree@vger.kernel.org, conor+dt@kernel.org, olteanv@gmail.com, linux-phy@lists.infradead.org
In-Reply-To: <20260806161301.1010876-3-palash.kambar@oss.qualcomm.com>
References: <20260806161301.1010876-1-palash.kambar@oss.qualcomm.com>
 <20260806161301.1010876-3-palash.kambar@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 16:56:37 +0000
Message-Id: <20260806165637.8E41A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing configuration overlay for UFS Gear 4 in Hawi UFS PHY
--

--- Patch [2]: [PATCH v6 2/2] phy: qcom-qmp-ufs: Add UFS PHY support on Haw=
i ---
commit 69d2ab29b4fbd3a27d861c7619c3a546898758d6
Author: Palash Kambar <palash.kambar@oss.qualcomm.com>

phy: qcom-qmp-ufs: Add UFS PHY support on Hawi

This patch adds the init sequence tables and configuration for the UFS QMP
PHY found in the Hawi SoC.

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

> +static const struct qmp_phy_init_tbl hawi_ufsphy_g5_pcs[] =3D {
> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_PLL_CNTL, 0x3b),
> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_TX_HSGEAR_CAPABILITY, 0x05),
> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_RX_HSGEAR_CAPABILITY, 0x05),
> +};
> +
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
Does this configuration need a fallback overlay for Gear 4?

Looking at qmp_ufs_get_gear_overlay(), if the UFS controller negotiates Gea=
r 4
(or lower) with the connected UFS device, it will return -EINVAL because the
only overlay provided here has max_gear =3D UFS_HS_G5:

	for (idx =3D NUM_OVERLAY - 1; idx >=3D 0; idx--) {
		max_gear =3D cfg->tbls_hs_overlay[idx].max_gear;

		/* Skip if the table is not available */
		if (max_gear =3D=3D 0)
			continue;

		/* Direct matching, bail */
		if (qmp->submode =3D=3D max_gear)
			return idx;

		/* If no direct matching, the lowest gear is the best matching */
		if (max_gear < floor_max_gear) {
			ret =3D idx;
			floor_max_gear =3D max_gear;
		}
	}

	return ret;

Without an overlay where max_gear < 5, it fails to find a fallback. If the
overlay fails to apply, critical hardware configurations like
QPHY_V7_PCS_UFS_PLL_CNTL and the HSGEAR capabilities are omitted since they
are only present in the G5 overlay and not in the base hawi_ufsphy_pcs tabl=
e.

Will this cause UFS link failure and render the storage unusable for any ge=
ar
below G5?

> +
> +	.vreg_list		=3D hawi_ufsphy_vreg_l,
> +	.num_vregs		=3D ARRAY_SIZE(hawi_ufsphy_vreg_l),
> +	.regs			=3D ufsphy_v7_regs_layout,
> +};

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806161301.1010=
876-1-palash.kambar@oss.qualcomm.com?part=3D2
