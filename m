Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B286740099C;
	Thu, 30 Jul 2026 10:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785408580; cv=none; b=WahvYsLlOjss4Gvi6AlqSkQ9/Skzg7bWM/zaEA7cm/3B3zl3f7J3ER2LdOY99WSUfzlJtcb8esWLCsRUZsDOWtNAMRAha3KfX6Y7nwTu/jZWWQC3Jo3WqS6Jqzc8xSTXXbJRZQl1va+8WuEyADQLt0EvqkoIePZ4oLxSRMOCixE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785408580; c=relaxed/simple;
	bh=nvhW/EnQNXNu3f8M4iHmpoS0v9xw4gtlPV3det9IDh8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hncQ/kXyMKEBZ6/5lVOEr75l0LAsp3fXWpub3beyM62cIXIj3b0fG5Y/FqHotu/q3yQkJ2EqS1JRwPWECu82vq7HmzMLXYLH2CYf62M5EMAGCqAr7vGPrgE3aZamNg0M1yUFuKsTNVJjfqwibmSNJiBPJsUT59TZwFL3Cmw2gzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SJr1AKm2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJr1AKm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833311F00A3A;
	Thu, 30 Jul 2026 10:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785408579;
	bh=U3Q+DnhuLI1jTEOruSjoQN91JDslxyvdVfft9YuKBh8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SJr1AKm2ecnyFZ0Y6S/D1At5UmjtmdexkPES9ujhUAOR+5rew49LJUIdnddrJ3+pD
	 kr39G1qxUbu8HclrZlRUJvMgt0K2CO/b5wNVtBrWVueJ9PwwyKIWodkqxQYc4K5q6L
	 n2aJZT5lqrm6kWNsIZNN8yBEaI2ICtscngKGyBX6L0Cwzyq9XDqKiWCHMDkDvBBog0
	 th9LH/jzMDe4d4WPFaoNK9tIHGT6hA+69WTwJBSdLW0csySLIgVkcCmgSi/F00WKb+
	 4zW4vivwIPt+PYzGffc+U7UGGa7JFHshy/w+FzRMnMdqJ9TFtB6wnx4VTISOfCq4Q/
	 CmP23LyBK8iFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 22/26] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, neil.armstrong@linaro.org, conor+dt@kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, vkoul@kernel.org, olteanv@gmail.com
In-Reply-To: <20260730-mt8196-ufs-v10-22-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-22-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 10:49:38 +0000
Message-Id: <20260730104938.833311F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Incomplete feature removal leaves behind unused struct field and de=
ad code for UFS clock vcore scaling.
--

--- Patch [22]: [PATCH v10 22/26] scsi: ufs: mediatek: Remove undocumented =
"clk-scale-up-vcore-min" ---
commit 35c917bdf36a893b4dd563ccc122d8d25ec6d9ed
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Remove undocumented "clk-scale-up-vcore-min"

This commit removes support for the undocumented "clk-scale-up-vcore-min"=20
property from the MediaTek UFS driver. It deletes the device tree parsing=20
logic and the initial vcore regulator setup.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 90c8606d85a9d..5dd72b8261815 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -918,24 +916,7 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
>  	if (!ufs_mtk_is_clk_scale_ready(hba)) {
>  		hba->caps &=3D ~UFSHCD_CAP_CLK_SCALING;
>  		dev_info(hba->dev, "%s: Clock scaling unavailable", __func__);
> -		return;
> -	}
> -
> -	if (!host->reg_vcore)
> -		return;
> -
> -	if (of_property_read_u32(dev->of_node, "clk-scale-up-vcore-min",
> -				 &volt)) {
> -		dev_info(dev, "failed to get clk-scale-up-vcore-min");
> -		return;
>  	}
> -
> -	host->mclk.vcore_volt =3D volt;

[Severity: Low]
Since this patch removes the code that populates host->mclk.vcore_volt, doe=
s=20
it leave behind an unused field and dead code elsewhere in the driver?

In drivers/ufs/host/ufs-mediatek.h:
struct ufs_mtk_clk {
        ...
        int vcore_volt;
        ...
};

And in drivers/ufs/host/ufs-mediatek.c:_ufs_mtk_clk_scale():

    volt =3D host->mclk.vcore_volt;
    if (host->reg_vcore && volt)
            clk_bind_vcore =3D true;

Because vcore_volt is zero-initialized and no longer updated, clk_bind_vcor=
e=20
appears to always be false, which makes the subsequent regulator scaling=20
branches permanently unreachable. Should these leftovers be cleaned up as=20
well?

> -
> -	/* If default boot is max gear, request vcore */
> -	if (volt && host->clk_scale_up)
> -		if (regulator_set_voltage(host->reg_vcore, volt, INT_MAX))
> -			dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D22
