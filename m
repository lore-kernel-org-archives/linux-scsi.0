Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010EF4908AC;
	Thu,  1 Oct 2026 08:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790843642; cv=none; b=qJSlmFVnkNIO/0ZX1pBTl36txmnfADS5BEy8C/knyptTIuE52gNTuI86To72DZQ2mh+6HD6HXVt2tUO1y1sUAJPewC0B6mpnnnS1iltA00Em2KxGF9HJQPiVYvPPPk01JyehKe8dWchnMQ8wV/aj8i3p6q4/Ou2BphFqbLVYNow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790843642; c=relaxed/simple;
	bh=y9jUgVbYeeynPwWsmZrk3B+I9zZclwaMUbelyHDp4sA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NVTPwuprkvBo/oRZ+src556QGuW536YLtuSssMXVdAYLk6H/lIwftnTB4ItgQ0XKDDd1TsCNJRJXC5BxLG0mgbSYVuDGdVJP09RIIrUGXDDN6FUaYiNp5yykgfDtx8nTVvy3Y2TpBIKn6qfJtbo3EItXGD5AaXIeCzcZ2epeG+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hCQ/5+Js; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hCQ/5+Js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69411F000FF;
	Thu,  1 Oct 2026 08:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790843640;
	bh=5+cdwiD3eCkQyUYa5ri7RsiBtsgtzMxedchp/Eo4UUI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hCQ/5+Js7tHbMFqAC5cI8Dp1jZlusD4ZPNMVzJMK4GPBxCVSe0V8RpaakDzWKz9uC
	 aBvjldaicI35wkRrqlbD1L7AA79K1t39iwA7YOfK6DHhWU8KDKlYPqh6dfqP+DVj0f
	 sPqa4fTFEGNjqQB46S9lNWDt51piT4OnWc8y6f6yA6Cf0BXodCCv+AUA73Rt5yinqC
	 e7LjiARrMAoh16Xg5k5zcfZnz5kANO+/rdTQ16g9BSWY6fYjk1Dw19NaNVwTiKkDfU
	 8IvQRTMmDfXEDHdSgPjA/pH7Fmz+epXlKdckYLrh4AkoJOjOFVgUdjfSqGwmZ9rAKo
	 emoeVgmcEGEdg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 14/24] scsi: ufs: mediatek: Use the common PHY
 framework
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: devicetree@vger.kernel.org, linux-phy@lists.infradead.org, olteanv@gmail.com, robh@kernel.org, neil.armstrong@linaro.org, conor+dt@kernel.org, vkoul@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261001-mt8196-ufs-v13-14-60854adab6d9@collabora.com>
References: <20261001-mt8196-ufs-v13-0-60854adab6d9@collabora.com>
 <20261001-mt8196-ufs-v13-14-60854adab6d9@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 08:33:59 +0000
Message-Id: <20261001083359.B69411F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] ufs: PM state mismatch on PHY power off failure in suspend
- [Medium] ufs: MTCMOS power leak on PHY power on failure in resume
--

commit 9793309b55b85fbb5631e6f681c0c84e2da2dd42
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Use the common PHY framework

This commit switches the Mediatek UFS driver to use the common PHY framework
instead of manually parsing the OF tree for the PHY node. It updates the
initialization, resume, and suspend paths to power the PHY on and off using
the framework's APIs.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index e4b41de4de3a2..6d5687f5e7558 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -2502,9 +2447,8 @@ static int ufs_mtk_system_resume(struct device *dev)
>  static int ufs_mtk_runtime_suspend(struct device *dev)
>  {
>  	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> -	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
>  	struct arm_smccc_res res;
> -	int ret =3D 0;
> +	int ret;
> =20
>  	ret =3D ufshcd_runtime_suspend(dev);
>  	if (ret)
> @@ -2515,8 +2459,11 @@ static int ufs_mtk_runtime_suspend(struct device *=
dev)
>  	if (ufs_mtk_is_rtff_mtcmos(hba))
>  		ufs_mtk_mtcmos_ctrl(false, res);
> =20
> -	if (host->phy_dev)
> -		pm_runtime_put_sync(host->phy_dev);
> +	ret =3D ufs_mtk_mphy_power_on(hba, false);
> +	if (ret) {
> +		dev_err(dev, "Failed to power off PHY: %pe\n", ERR_PTR(ret));
> +		return ret;

[Severity: High]
Does returning the error directly here leave the PM state mismatched?

If ufs_mtk_mphy_power_on() fails, this returns early without rolling back t=
he
already suspended UFS hardware (suspended via ufshcd_runtime_suspend()
earlier in this function).

The PM core may mark the device as RPM_ACTIVE because the callback failed,
despite the hardware physically being suspended. Could this cause subsequent
I/O to assume the device is active and hang?

> +	}
> =20
>  	return 0;
>  }
> @@ -2524,14 +2471,17 @@ static int ufs_mtk_runtime_suspend(struct device =
*dev)
>  static int ufs_mtk_runtime_resume(struct device *dev)
>  {
>  	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> -	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
>  	struct arm_smccc_res res;
> +	int ret;
> =20
>  	if (ufs_mtk_is_rtff_mtcmos(hba))
>  		ufs_mtk_mtcmos_ctrl(true, res);
> =20
> -	if (host->phy_dev)
> -		pm_runtime_get_sync(host->phy_dev);
> +	ret =3D ufs_mtk_mphy_power_on(hba, true);
> +	if (ret) {
> +		dev_err(dev, "Failed to power on PHY: %pe\n", ERR_PTR(ret));
> +		return ret;

[Severity: Medium]
Can this leak the MTCMOS power state if ufs_mtk_mphy_power_on() fails?

If ufs_mtk_mphy_power_on() fails, the function returns early without rolling
back the MTCMOS power state that was just enabled via
ufs_mtk_mtcmos_ctrl(true, res).

Does this leave the MTCMOS domain powered on indefinitely after a failed
resume attempt?

> +	}
> =20
>  	ufs_mtk_dev_vreg_set_lpm(hba, false);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-mt8196-ufs=
-v13-0-60854adab6d9@collabora.com?part=3D14
