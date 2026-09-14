Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9788E44781E;
	Mon, 14 Sep 2026 12:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390722; cv=none; b=jqOatn2CHKHuB+z2bww1YHcx87D5pSY4tcO4QVZnH4nTSmpwMpLzMFU4OTkzu6oXj5V/sWb3mV6oKuze8jE2jGhz+EQPFg9OjucMeoBFWkLfEegdYTzu1+n01Xwh07POTURNloaWRYhdf2eoSUA6ZpDBuJDMTfPf48uu5+Xje3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390722; c=relaxed/simple;
	bh=7H9dnY6wsJtZbf2mjTq8YqUQStBF5b7JSb0nOakOZAE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rAAnZO3dYcc6MBtTmN9gxakb/E7RLbh2nmfgvmpPNCx2CbFp5dyM8WosX1Qr9xmJ567iYosj3hfdqFE7L8or2qyXUJOzArDaTxtHlU/zfbJZEMFQ3uAiRZ377R0POSvH6UylQBt5EYhem9TqV/Gjo6MsxpA+TCt8Zj6YHyWeGkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j33lRb/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j33lRb/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F0D1F0089A;
	Mon, 14 Sep 2026 12:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789390721;
	bh=q7P/XxnfFbOpFBgH2nN6WeSNPU29sWcz6NGAJwuE7q4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j33lRb/WtPSc1p+/G8H6Ounna1cbV/nYNSwGzjIYrUEuuJi7JHCMh/ohtpBzABqDx
	 m+oKdiYqGpPbbTUvo+oYdbkA3YQVTw8FAfp1ILnJMfz4u+dMy94URJCVXSfkB6qQvI
	 JxP+8Kk3yn2v+GvGg3WY8DnLH75C7qwyno4tFxcMgTh6jNdgDNX0gkwrAKMYs74hRl
	 VvIoc+tDPj3CEIZ9HzMyyu1b4UAAcSq+TWLIr7C/rPaL/H0pJ5MM9xDlH85YPSkwsT
	 RYDPzc5z5hcA8viiHusjwnHiThgoZBg3APVtIqpcvh6XmymhqUN/mude/ModhEFkB5
	 rs91TCdpWLXMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 14/24] scsi: ufs: mediatek: Use the common PHY
 framework
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: devicetree@vger.kernel.org, vkoul@kernel.org, olteanv@gmail.com, linux-scsi@vger.kernel.org, neil.armstrong@linaro.org, linux-phy@lists.infradead.org, conor+dt@kernel.org, robh@kernel.org
In-Reply-To: <20260914-mt8196-ufs-v12-14-9279d7ef814d@collabora.com>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
 <20260914-mt8196-ufs-v12-14-9279d7ef814d@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 12:58:40 +0000
Message-Id: <20260914125840.98F0D1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Returning an error in `ufs_mtk_runtime_suspend` without rolling ba=
ck the hardware state causes a fatal PM state desync.

Pre-existing issues:
- [High] `ufs_mtk_mphy_power_on` fails to update `mphy_powered_on` when ret=
urning an error, permanently desynchronizing the PHY state.
--

commit 090d0e1cc91ef448f0346929e47ee45484365fd1
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Use the common PHY framework

This commit changes the driver to use the common PHY framework to acquire t=
he
device's PHY during initialization. This simplifies the driver by removing
reinvented PHY framework code and OF parsing.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 3c10a9fd09dfc..538009e3b1f17 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -2497,9 +2442,8 @@ static int ufs_mtk_system_resume(struct device *dev)
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
> @@ -2510,8 +2454,11 @@ static int ufs_mtk_runtime_suspend(struct device *=
dev)
>  	if (ufs_mtk_is_rtff_mtcmos(hba))
>  		ufs_mtk_mtcmos_ctrl(false, res);
> =20
> -	if (host->phy_dev)
> -		pm_runtime_put_sync(host->phy_dev);
> +	ret =3D ufs_mtk_mphy_power_on(hba, false);

[Severity: High]
This is a pre-existing issue, but ufs_mtk_mphy_power_on() fails to update
mphy_powered_on when returning an error, which can permanently desynchronize
the PHY state.

Looking at ufs_mtk_mphy_power_on():

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_mphy_power_on() {
    ...
	} else {
		phy_power_off(mphy);
		ret =3D ufs_mtk_09v_off(host);
		if (ret)
			return ret;
	}

	host->mphy_powered_on =3D on;

	return 0;
}

If ufs_mtk_09v_off() fails during power off, it returns the error immediate=
ly,
leaving host->mphy_powered_on as true.

On the next resume, ufs_mtk_mphy_power_on(hba, true) will return early beca=
use
on =3D=3D host->mphy_powered_on, skipping phy_power_on(mphy).

Can this permanently leave the PHY powered off and make the storage
inaccessible?

> +	if (ret) {
> +		dev_err(dev, "Failed to power off PHY: %pe\n", ERR_PTR(ret));
> +		return ret;

[Severity: High]
If ufs_mtk_mphy_power_on() fails, this returns an error immediately without
rolling back the earlier suspend operations.

Since the UFS hardware is already left physically suspended (clocks gated,
VREGs and MTCMOS powered down via ufshcd_runtime_suspend and=20
ufs_mtk_dev_vreg_set_lpm), returning an error causes the PM core to mismatch
the physical hardware state and consider the device active.

Can this cause a fatal PM state desync, where subsequent I/O requests crash=
 or
hang the bus because the PM core will skip calling runtime_resume?

> +	}
> =20
>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-mt8196-ufs=
-v12-0-9279d7ef814d@collabora.com?part=3D14
