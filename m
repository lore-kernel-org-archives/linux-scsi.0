Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FF73FAE11;
	Thu, 30 Jul 2026 10:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785407369; cv=none; b=sonV5ScrAM5hHEBl4zDNeHqflNdudg7gPwa+1g6yuItOTkn9ngMnPPGoGbIMnHazDYE5tlzGP7HZGyj5/A+AMWjZ65RThwHC42DydYd8E71wanqnjDuPfMzCASk9XoDD8FME1X7CHmnGQhK17oou0A+giiZAiVwqgIsNHTJq9/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785407369; c=relaxed/simple;
	bh=MJkvIetUngvkuSfySJviioWmUC4ex1YG7W6BInm928E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z9s9VQIDnm0QRARDMlO6oxSFgr1YXW01THQ9uiWConKCcVC/U+tayd8sDZL9+F3IK9+nbnQudGegCY3m8ROuDAQFFA9p9ifJ+h+BihBidwHgHWuJdb0uJQ09ZadcahvfO4NOhD7blx73Gda3tQGDK/1+DUvD+HC1oclDplowf3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ahoODyhw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahoODyhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DED51F00A3A;
	Thu, 30 Jul 2026 10:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785407366;
	bh=lxDGpSGRyFg88rMPrLKpcIfpJzZSjbomdsMgil7+wac=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ahoODyhwFF7QOyJst2LKreNcTlXhHFMdkbwH08SFKFrD9J0BK1Y8A4Q/vx1XrP1Id
	 1STIGsiMykvgalatBeL9bbQbSwcTJGJJnR41Su2w60gbpM4kqXqaPcqz2a2JhebWIe
	 eC57mBVqU8UA6bbOvKTGa4T/rbMb/v4lO1ozFNAhUzdCWNs+EVL3LbvzlKhrFXsDfi
	 ToC0eMSRB80uxGxjiqKz3RdTHFLnyyUsdo9dX/Li+V10fllNNiQ9Ci329knrigdIq4
	 2F6166+yPV/Q42bVRcCWT3LnYwiYzjBIEXskkcH5WtfSJ9PSusvNyYgcHg13N5rKj0
	 Phly+/Q8GhQVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 06/26] scsi: ufs: mediatek: Rework resets
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, devicetree@vger.kernel.org, olteanv@gmail.com, linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, robh@kernel.org
In-Reply-To: <20260730-mt8196-ufs-v10-6-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-6-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 10:29:25 +0000
Message-Id: <20260730102926.1DED51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Hardware Reset Sequence Violation due to inverted bulk reset array=
 order and improper PHY synchronization.
- [High] Missing mandatory hardware reset delay when UFS MPHY is unbound.
--

--- Patch [6]: [PATCH v10 06/26] scsi: ufs: mediatek: Rework resets ---
commit 6e1eee5b92733c43e2ae7add5906da2c59fbe389
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Rework resets

This commit reworks the reset control getting in the driver's probe
function to use the bulk reset APIs instead of getting resets individually.
It also removes all remnants of the MPHY reset from this driver.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -93,6 +93,12 @@ static const char *const ufs_uic_dl_err_str[] =3D {
>  	"PA_INIT"
>  };
> =20
> +static const char *const ufs_reset_names[] =3D {
> +	"unipro",
> +	"crypto",
> +	"hci",
> +};

[Severity: High]
Does this array ordering accidentally reverse the original hardware reset
sequence?

The original code explicitly asserted resets in the order: HCI, Crypto,
UniPro, and deasserted them in the order: UniPro, Crypto, HCI.

Because reset_control_bulk_assert() iterates forwards and
reset_control_bulk_deassert() iterates backwards, this new array ordering
will assert UniPro, Crypto, HCI, and deassert HCI, Crypto, UniPro.

[ ... ]

> @@ -203,49 +209,45 @@ static void ufs_mtk_crypto_enable(struct ufs_hba *h=
ba)
>  static void ufs_mtk_host_reset(struct ufs_hba *hba)
>  {
>  	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
> -	struct arm_smccc_res res;
> -
> -	reset_control_assert(host->hci_reset);
> -	reset_control_assert(host->crypto_reset);
> -	reset_control_assert(host->unipro_reset);
> -	reset_control_assert(host->mphy_reset);
> -
> -	usleep_range(100, 110);
> =20
> -	reset_control_deassert(host->unipro_reset);
> -	reset_control_deassert(host->crypto_reset);
> -	reset_control_deassert(host->hci_reset);
> -	reset_control_deassert(host->mphy_reset);
> +	int ret;
> =20
> -	/* restore mphy setting aftre mphy reset */
> -	if (host->mphy_reset)
> -		ufs_mtk_mphy_ctrl(UFS_MPHY_RESTORE, res);
> -}
> +	ret =3D reset_control_bulk_assert(MTK_UFS_NUM_RESETS, host->resets);
> +	if (ret)
> +		dev_warn(hba->dev, "Host reset assert failed: %pe\n", ERR_PTR(ret));
> =20
> +	ret =3D phy_reset(host->mphy);

[Severity: High]
Are we restoring the PHY while the MAC/host controller blocks are still held
in reset?

In the original code, the MPHY SMC restore was called after all controller
blocks were deasserted. Here, phy_reset() executes the full MPHY reset and
restore before reset_control_bulk_deassert() is called.

> +
> +	/*
> +	 * Only sleep if MPHY doesn't have a reset implemented (which already
> +	 * sleeps) or the PHY reset function failed somehow, just to be safe
> +	 */
> +	if (ret) {
> +		usleep_range(100, 110);
> +		if (ret !=3D -EOPNOTSUPP)
> +			dev_warn(hba->dev, "PHY reset failed: %pe\n", ERR_PTR(ret));
>  	}

[Severity: High]
Does this skip the mandatory hardware reset delay when the UFS MPHY is
unbound?

If host->mphy is NULL, phy_reset(NULL) will return 0. This causes the if (r=
et)
condition to evaluate to false, bypassing the usleep_range(100, 110)
fallback.

This would result in the MAC/HCI resets being asserted and deasserted
instantaneously back-to-back, which can cause the controller IP block to
fail to reset.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D6
