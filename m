Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146983C3425;
	Thu, 30 Jul 2026 10:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785406620; cv=none; b=PxkfBaL+wlhT/fd+jP9IM8M8/Q/n8Zg5E64QjL4I4E2BDGKWcPXbrPWwl6tSPUYUBPJbmvibpETVGTlRPzftci2tuf+GWlOjoD8PbWqeJuqEvJKl0OObqRbfGpLjS63/Z7NDapjNedHpeGmeOR7DSSFwc442vB9xEusmyr7iIxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785406620; c=relaxed/simple;
	bh=wZrXVAFk4Wz5GsIwscLd1zqwzOOIHIlvELxneiYbhgE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uW8epMjrqcO0fe7byEQKK9HBy1qLJ9ACYzVfOOQ20AeWsjJF5gKeHLrmtei7Uc1KRfTS+oL3RSfoGF4Nfo01LR2BNGoLRCKlyBMoYnwhkdGV8YBBYfcYiP4Y6WDDaTuhFOSZn+kp9P4WGUN8CQH+bmOpjChj+F8LoZHxTAZ8TSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EgK0G5RQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EgK0G5RQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427531F00A3A;
	Thu, 30 Jul 2026 10:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785406618;
	bh=QoCHR5a7rUrMw+Ospw1ml8lNy2FhpkFHESUJrl4P6zI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EgK0G5RQmJjVlmO4DV9UIHZa97CDxFnRvOZUtPQLiluAtGwsAtTtrWMmarwov9Vka
	 EzTQGnEKM3FLzlaUZTnl7I41pX9agw7iefY1HAUH5vOPo1+KyflsFHjzwwRDCUuTXr
	 fYWmFfbgSOWNkTsK7iVirxELYD0JD9PeEpShrP15QWM2j47pmJGlBptZCa8L/d/Riq
	 O1B5bDximr2GfTXvc7ns5t3CZSlPAyzPWzCsLekuFCAwSyg+YdXEiyt7L3PMZTtoCc
	 EboURRp7beBVTFhMYsXJC51aQfNyN2T1VYuC6/OUzJajVknfqq3zkjGdMXdzlOt+CZ
	 7c4eDS+Uqy8rw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 09/26] scsi: ufs: mediatek: Rework the crypt-boost
 stuff
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: devicetree@vger.kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, linux-phy@lists.infradead.org, conor+dt@kernel.org, robh@kernel.org, olteanv@gmail.com, linux-scsi@vger.kernel.org
In-Reply-To: <20260730-mt8196-ufs-v10-9-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-9-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 10:16:57 +0000
Message-Id: <20260730101658.427531F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] Missing newline character `\n` in `dev_err` format string.
- [Low] Incompatible pointer type passed to `of_property_read_u32`.
--

--- Patch [9]: [PATCH v10 09/26] scsi: ufs: mediatek: Rework the crypt-boos=
t stuff ---
commit cbee34751328446d33c164e90e794b44773af5eb
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Rework the crypt-boost stuff

This commit reworks the crypt-boost functionality by adding vendor
prefixes to the device tree properties, removing unnecessary clock
wrappers, and restructuring the initialization code.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 50e7701d7943b..55701172bcf15 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -633,65 +618,51 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba=
, bool boost)
[ ... ]
> +	cfg->reg_vcore =3D devm_regulator_get_optional(dev, "dvfsrc-vcore");
> +	if (IS_ERR(cfg->reg_vcore)) {
> +		dev_err(dev, "Failed to get dvfsrc-vcore: %pe", cfg->reg_vcore);

[Severity: Low]
This isn't a bug, but should this error message include a trailing newline?

Without it, the next printed kernel message might be appended to the same
line, resulting in garbled logs.

> +		return;
>  	}
> =20
> -	if (of_property_read_u32(dev->of_node, "boost-crypt-vcore-min",
> -				 &volt)) {
> -		dev_info(dev, "failed to get boost-crypt-vcore-min");
> -		goto disable_caps;
> +	ret =3D of_property_read_u32(dev->of_node, "mediatek,boost-crypt-vcore-=
min",
> +				   &cfg->vcore_volt);

[Severity: Low]
Does passing &cfg->vcore_volt to of_property_read_u32() cause a compiler
warning here?

Looking at struct ufs_mtk_crypt_cfg, vcore_volt is declared as an int, but
of_property_read_u32() expects a pointer to a u32. This might trigger an
incompatible pointer type or pointer sign warning on strict build
configurations.

> +	if (ret) {
> +		dev_err(dev, "Failed to get mediatek,boost-crypt-vcore-min: %pe\n",
> +			ERR_PTR(ret));
> +		return;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D9
