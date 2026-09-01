Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA1E34FF74;
	Tue,  1 Sep 2026 15:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788278304; cv=none; b=Iw1f6vvbE78EEDynv7gxBxxv1Mz//yyW00d33mxk3VNpf3XF/HF5tEwnMhepsE/SBR7n3KjHonytzKg6M97RhajQFC2/XJGQYTf9KzlK5wOTvesgRNo7kxWPKzhbju+9MQro9+6hRu9R1+ot2MGp5OLJAITY2RrOEJn+cHIKks8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788278304; c=relaxed/simple;
	bh=1vc2jP17DSJadeA7HFF/DMd4qeIgBX+PzMwotPk+1w8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=s13IKLaFmRsJkD2RJ710zxMUnoQ0g7ym3giINVL1cyrUZlQnBavTnDa7g9WaJkMxGFAud877v3cO830gEiFcr7s457n2tuvWB983XrE3MX1Xs1jJoqYVetgqQaBl0NPk3WaZ64bcsKWTAVi+XS1Py3SK12cXrYnNdA/sG6VLH/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i271huYc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i271huYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144271F000E9;
	Tue,  1 Sep 2026 15:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788278303;
	bh=zvgnTgwyrU8nafpmJLmWSm+0Rd2b54xKNuxR6gJPHNw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i271huYcw9ja0VgWWxaQbzFSvcvY2AEVoaIJFlYlLNR72s+yIv6VCcYFTobuxWyfG
	 Rjh7bp2Boi0AYY+7H+UNupfPvvqCzw/1R1FGNoIzhfq29GIGr3dl8gbHr510ZRkgG8
	 id+HiEYY4WyyGdFmpTE5solGTQqpFfokU2TBBLDcrpFbDO2nNO4OkCz1wR1yz6PIxQ
	 ArE+Tx2lo10SVReS4iPIEGiGLq2uNkdRBW6CbgqfPrbXUIHmsNAYZa7ZaubdHoiKCM
	 LKDdlq2oamZaFP45Xw/acOVAL5UYQd+Vbvr+Hx0P3w7bLEiI2/TNR8cH440HIvPyob
	 XUgmTRYjRSEfg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 06/24] scsi: ufs: mediatek: Rework resets
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: conor+dt@kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, neil.armstrong@linaro.org, linux-phy@lists.infradead.org, vkoul@kernel.org, olteanv@gmail.com, devicetree@vger.kernel.org
In-Reply-To: <20260901-mt8196-ufs-v11-6-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
 <20260901-mt8196-ufs-v11-6-dbd007704490@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 15:58:22 +0000
Message-Id: <20260901155823.144271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] A spurious warning 'PHY reset failed: (null)' is logged during host=
 reset when the optional MPHY is absent.
--

commit 37450d6f129323aed779a5a4a77bdb0dba397435
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Rework resets

This commit reworks the UFS Mediatek driver to use bulk reset APIs.
It also removes legacy MPHY reset components and transitions to optional
reset variants.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -204,49 +210,46 @@ static void ufs_mtk_crypto_enable(struct ufs_hba *h=
ba)
>  static void ufs_mtk_host_reset(struct ufs_hba *hba)
>  {
>  	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);

[ ... ]

> +	ret =3D phy_reset(host->mphy);
> =20
> -	/* restore mphy setting aftre mphy reset */
> -	if (host->mphy_reset)
> -		ufs_mtk_mphy_ctrl(UFS_MPHY_RESTORE, res);
> -}
> +	/*
> +	 * Only sleep if there is no MPHY or MPHY doesn't have a reset
> +	 * implemented (which already sleeps) or the PHY reset function failed
> +	 * somehow, just to be safe
> +	 */
> +	if (!host->mphy || ret) {
> +		usleep_range(100, 110);
> +		if (ret !=3D -EOPNOTSUPP)
> +			dev_warn(hba->dev, "PHY reset failed: %pe\n", ERR_PTR(ret));

[Severity: Low]
Does this code inadvertently log a spurious warning when the optional MPHY =
is
absent?

In ufs_mtk_host_reset(), when host->mphy is NULL, phy_reset(NULL) returns 0.
The condition if (!host->mphy || ret) evaluates to true, and since 0 is not
equal to -EOPNOTSUPP, this path seems to incorrectly trigger the dev_warn()=
 on
every reset. This will result in a confusing error message like
'PHY reset failed: (null)'.

>  	}
> +
> +	ret =3D reset_control_bulk_deassert(MTK_UFS_NUM_RESETS, host->resets);
> +	if (ret)
> +		dev_warn(hba->dev, "Host reset deassert failed: %pe\n", ERR_PTR(ret));
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-mt8196-ufs=
-v11-0-dbd007704490@collabora.com?part=3D6
