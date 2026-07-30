Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54123A71A8;
	Thu, 30 Jul 2026 10:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785407035; cv=none; b=GywYFYL1mE1fWxX4zaFpnVvrSS1kDXGjlHEv4/XiZQwMU3jBq5M8Qmx2upFXQgmBkIWIkmf4UOR1dTdkNq6fZmB97T3RJ/vWB0V0tDtwBG81x59+MNsnVx/xVRAZpOxDVr1Nm4l3a5c40xgdFtI175Z9+CEfeR84y5s+v0W1ayo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785407035; c=relaxed/simple;
	bh=3s6gJLRDbm0o3vgou5sG1BIyH1H5nRgZR1oonF4K9Ng=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mkmzSViCVwajdaS9rs+t54bLbq/kiue7KPEcepVSRfk51HKpcHA50ONTbQc4UUJJ3xVHhoa+0SXykS6ZYOIqxUxuiYO5tFSOs1q+lnPfZedputVu8HkFScsS8+x6+h0h5nXqFpANZRebibYvDWygZP9IPRCEPna6n/9AtKFpWTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z8KqiF3G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z8KqiF3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E811F1F000E9;
	Thu, 30 Jul 2026 10:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785407034;
	bh=Uk6VtPeCvlYjRrRZ+uVLXSq1rSrpwZvzAcFksOKIteA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z8KqiF3G7/85Yg+8cgr77OxAvA8btC2FA60bgErR9liASSP7IuFOPxL3vbbgBoQms
	 fIl9iHuAA3DTxpRoYyEemEZyYcUJbCfCJG38m4MWeuHhkBgNYS0u8jmFkcCWPLtlO9
	 x+vyvh+V4WSKf3DNSZGRxvCEQsG2YjjIWVszIh+K5POaGmT6ZVxZnRCz6Mev0ZdSH0
	 UBy4SrrEyz+AlYO1n+bgQP8PveSzr1e5U0rmOMYp5F15DwoIMOl1JJ03Uf8gz1uRuw
	 4/WWmU3WqnFVQS79YU8aVJAxCECZdzLmS7sW2dLmkWRpZAFOA1amyYYH79GN5WGH5H
	 8FPtsQnKBo3Ew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 11/26] scsi: ufs: mediatek: Remove undocumented
 downstream reset cruft
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: robh@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, vkoul@kernel.org, conor+dt@kernel.org
In-Reply-To: <20260730-mt8196-ufs-v10-11-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-11-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 10:23:53 +0000
Message-Id: <20260730102353.E811F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The kobject reference for `phy_dev` is dropped too early during pr=
obe, leaving a dangling pointer stored in `host->phy_dev` that leads to a u=
se-after-free in runtime PM callbacks.
- [High] The runtime PM usage count and enablement state for `phy_dev` are =
permanently leaked if the probe fails, and the PM state is never restored o=
n driver removal.
--

--- Patch [11]: [PATCH v10 11/26] scsi: ufs: mediatek: Remove undocumented =
downstream reset cruft ---
commit 2e47ec1b9626d31e1288701fe0c4a25c195e38d4
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Remove undocumented downstream reset cruft

The MediaTek UFS host driver's probe function allows using a ti,syscon-reset
as a reset, without going through the appropriate abstractions or documenti=
ng
this in the binding. This commit removes this downstream code as it does not
belong here.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 65036c8390318..a2749e79514c4 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -2402,38 +2402,12 @@ MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);
>  static int ufs_mtk_probe(struct platform_device *pdev)
>  {
>  	int err;
> -	struct device *dev =3D &pdev->dev, *phy_dev =3D NULL;
> -	struct device_node *reset_node, *phy_node =3D NULL;
> -	struct platform_device *reset_pdev, *phy_pdev =3D NULL;
> -	struct device_link *link;
>  	struct ufs_hba *hba;
> +	struct platform_device *phy_pdev =3D NULL;
> +	struct device *dev =3D &pdev->dev, *phy_dev =3D NULL;
> +	struct device_node *phy_node =3D NULL;
>  	struct ufs_mtk_host *host;
> =20
> -	reset_node =3D of_find_compatible_node(NULL, NULL,
> -					     "ti,syscon-reset");
> -	if (!reset_node) {
> -		dev_notice(dev, "find ti,syscon-reset fail\n");
> -		goto skip_reset;
> -	}
> -	reset_pdev =3D of_find_device_by_node(reset_node);
> -	if (!reset_pdev) {
> -		dev_notice(dev, "find reset_pdev fail\n");
> -		goto skip_reset;
> -	}
> -	link =3D device_link_add(dev, &reset_pdev->dev,
> -		DL_FLAG_AUTOPROBE_CONSUMER);
> -	put_device(&reset_pdev->dev);
> -	if (!link) {
> -		dev_notice(dev, "add reset device_link fail\n");
> -		goto skip_reset;
> -	}
> -	/* supplier is not probed */
> -	if (link->status =3D=3D DL_STATE_DORMANT) {
> -		err =3D -EPROBE_DEFER;
> -		goto out;
> -	}
> -
> -skip_reset:
>  	/* find phy node */
>  	phy_node =3D of_parse_phandle(dev->of_node, "phys", 0);
> =20
> @@ -2479,7 +2453,6 @@ static int ufs_mtk_probe(struct platform_device *pd=
ev)
> =20
>  out:
>  	of_node_put(phy_node);
> -	of_node_put(reset_node);
>  	return err;
>  }

[Severity: High]
This isn't a bug introduced by this patch, but could this lead to a
use-after-free of phy_dev?

In ufs_mtk_probe(), after looking up the PHY device, the kobject reference
is dropped almost immediately:

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_probe() {
	phy_pdev =3D of_find_device_by_node(phy_node);
	if (!phy_pdev)
		goto skip_phy;
	phy_dev =3D &phy_pdev->dev;
	...
	put_device(phy_dev);
	...
}

However, the pointer is later saved into the host structure for later use:

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_probe() {
	...
	if (phy_node && phy_dev) {
		host =3D ufshcd_get_variant(hba);
		host->phy_dev =3D phy_dev;
	}
	...
}

If the PHY device is later unbound via sysfs and its memory freed, would the
UFS host's runtime PM callbacks, such as ufs_mtk_runtime_suspend(),
dereference this dangling host->phy_dev pointer when calling
pm_runtime_put_sync()?

[Severity: High]
This is also a pre-existing issue, but is there a PM runtime usage count
leak in ufs_mtk_probe() on error paths?

If a failure occurs during initialization (e.g., ufshcd_pltfrm_init() fails=
),
the function jumps to the out label without calling pm_runtime_put_sync() or
pm_runtime_disable() for phy_dev:

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_probe() {
	if (phy_node) {
		...
		pm_runtime_enable(phy_dev);
		pm_runtime_get_sync(phy_dev);
		...
	}
	...
	err =3D ufshcd_pltfrm_init(pdev, &ufs_hba_mtk_vops);
	if (err)
		goto out;
	...
out:
	of_node_put(phy_node);
	return err;
}

Additionally, ufs_mtk_remove() doesn't appear to tear down this state.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D11
