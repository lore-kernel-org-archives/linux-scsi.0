Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47C4401A3B;
	Thu, 30 Jul 2026 10:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785408086; cv=none; b=GNN7iuTTQBkyMRqkGAcVH4VPt7IfIAyDjps4IUm3WMKBbK48whmpPt4Ss/K/OBDCV2s7JOEbsHYfekBuYum1+uFrAMIwb3SelDGQds6MD8PrVIWzIxuGPhlHFRDbcSsWRxAVBeKBZrm9/Cs4zbcQIqNVWJtj15e0Z3/GrFXYews=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785408086; c=relaxed/simple;
	bh=OO29DmOlPBt9gG542Ba6kbdep/HPhwN1TcF8c12wRXg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TarBJbAOW2pe9uH9as7Pi5VDUxR2GlKalPKjxsLK4XNkCyaiq5TyRysGzFq+TZJpfPCRJWaZxJ7samVTbQCFVbLwnnE5DJ3cN52iZxXfCjSiHnbld1I4Bg03sIO3WRSz0ZhX7ZNG7Go8JGV8QtXOPotCfH45ZNaySOUGFx4viBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TgSmzxS3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TgSmzxS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C606C1F000E9;
	Thu, 30 Jul 2026 10:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785408085;
	bh=CjTAtVu3KYZkXZ9wcCH77hKReMY6yFhPPMguW0zSoE0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TgSmzxS3ZqCA3e3E/Gm+5p0Di4rNoybGAC1GY8FPo7oxFf9gvys5RfCw+1qKLaS4L
	 M0kqQpH1I4nKIHzuUKVxOWMd65/jx/8d1lhSxXli4dogu1cIoc9pTgwAOLvR00hCig
	 3prCn5S7z+VDvpyLQY54+U4Dveo7zLuHwRgX1GT/NxWyaoDAYrUakmFXYrthLnpyGP
	 2q42770o0Figw4+0YlV/n3xzJ4x3BLUrOo1LrUdsSRXgnm/kJZ6Kl+OLqhzb6J/ZRK
	 Yrc7BAtg29zegEGXUaqL1Z++BPYb4O/LIeUIOn7qdUGhgmG01wwldxivJhWfHDzM69
	 kzdU55FtL3HVw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 18/26] scsi: ufs: mediatek: Don't acquire
 dvfsrc-vcore twice
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: conor+dt@kernel.org, olteanv@gmail.com, neil.armstrong@linaro.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, vkoul@kernel.org, robh@kernel.org, linux-phy@lists.infradead.org
In-Reply-To: <20260730-mt8196-ufs-v10-18-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-18-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 10:41:24 +0000
Message-Id: <20260730104124.C606C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Consolidating `dvfsrc-vcore` into a single shared regulator handle=
 prevents the regulator core from aggregating voltage constraints, causing =
independent features to overwrite each other's voltage requests and leading=
 to hardware undervoltage.
--

--- Patch [18]: [PATCH v10 18/26] scsi: ufs: mediatek: Don't acquire dvfsrc=
-vcore twice ---
commit f445ade145082cbe60e3dee2e8a70aa32aec9d9b
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Don't acquire dvfsrc-vcore twice

This patch consolidates the dvfsrc-vcore regulator into a single shared
handle on the host structure, rather than acquiring two separate references.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 0821de5b8a8fc..8214cf0b3a169 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -2005,7 +1998,7 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba,=
 bool scale_up)
>  		}
> =20
>  		if (clk_bind_vcore) {
> -			ret =3D regulator_set_voltage(reg, 0, INT_MAX);
> +			ret =3D regulator_set_voltage(host->reg_vcore, 0, INT_MAX);

[Severity: High]
Will consolidating to a single host->reg_vcore handle prevent the regulator
core from properly aggregating voltage constraints?

During a clock scale-down, ufs_mtk_clk_scale_notify() runs _ufs_mtk_clk_sca=
le()
with scale_up =3D false during the pre-change notification phase. Since
host->reg_vcore is now a single shared consumer handle, calling
regulator_set_voltage() with 0V here will immediately drop the physical
voltage constraint.

However, the crypto boost clock isn't downclocked until the post-change
notification phase calls ufs_mtk_boost_crypt(). Can this violate DVFS
constraints and cause a hardware undervoltage by dropping the voltage while
the crypto clock is still running at high frequency?

It appears the regulator core relies on separate consumer handles to aggreg=
ate
maximum voltage requests across independent features like clock scaling and
crypto boost, which might explain why two separate references were original=
ly
used.

>  			if (ret) {
>  				dev_err(hba->dev, "%s: Failed to set vcore to minimum: %pe\n",
>  					__func__, ERR_PTR(ret));

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D18
