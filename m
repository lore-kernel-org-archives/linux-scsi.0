Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787734915B6;
	Fri, 16 Oct 2026 12:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154643; cv=none; b=PPLLcBYkMjPV2/wGVvNuIf9FrXp6DQuyNcnVPD0Y2BeMNAEQjXzY0eIwl2pMMQoNr76UUC3jvcx5qLlW8o7RgD+4ggaM8rGiQm9EbNVjwFMtlpjA3CJPkTpKIQpuoTNxCL1cGk5KOsOV7x1EI4XYH1xNVNVoEyidvAVMTMSAUmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154643; c=relaxed/simple;
	bh=TIlDyISobs9MM9pNdIPxMAICV8j47VZMTAjch6iKFV8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=rDs3Gp9NxtzbfPEGAuUZv7Ui7BGCDt+bu/q/HEmIaT7leiz9Sj8cWIiQrHoDlbaWET3JuokrUWqfxJj8scZTbX3uFfg7K1/4Q0N8ak4puEGHtom+JDz01zcVBAfyJ1ewnVUTNZ83p1d71Sik5P5L6VjgESLEi19ywbaroArQX88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hV192nui; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hV192nui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5866C1F000C4;
	Fri, 16 Oct 2026 12:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792154640;
	bh=awipEOFjF3CP5bTbtcd3FdjcFGoV8veaDF5o6dntZoc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hV192nui9zlOXIhGZRrQQ0Teq2V2pXxGS/hADzSQbVn6jWxRB+5W2o9z4+D4hPrSB
	 CrZeo69r/YXgOMv67DWrw+4FcWqiULJg+px9Y2OsZ/qZPuy3S+1/HYLskTYhOP1Dqv
	 KzkEMZpGTLQxz1RvJzCyXII6sW1mJzvcR+r+mpzS7RaiOFRMtkK5MO2O4Kt308RMvl
	 Spaq29cuJKocR8zwkTPtrzqbKiklTFqi8nRusmFwD6kI7bm8bYu96hT1uqnjYwrGB/
	 JKZkOJQ0GaAA3pT2kQnjIC81CHmv0SBvYpiOwnhSv9OQszqUGB86UXHlgVt/2QeSSI
	 Z4OXbu58jYtmA==
Message-ID: <sashiko-outbox-174330@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 10/23] scsi: ufs: mediatek: Rework the crypt-boost
 stuff
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20261016-mt8196-ufs-v14-10-e8d565e0cd45@collabora.com>
References: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
 <20261016-mt8196-ufs-v14-10-e8d565e0cd45@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 12:43:59 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ufs: mediatek: silently swallowing probe deferral for crypt boos=
t clocks
--

commit c7e82dd177e902585d5b946c4b24b62fd9a85995
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Rework the crypt-boost stuff

This commit reworks the initialization of crypt-boost functionality by
removing clock wrapper functions and directly calling devm_clk_get() in
ufs_mtk_init_boost_crypt(). It also updates property names to include
the mediatek vendor prefix.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 1be533020ed4c..2bcf35bfabb77 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -680,65 +665,53 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba=
, bool boost)

[ ... ]

> +	cfg->clk_crypt_mux =3D devm_clk_get(dev, "crypt_mux");
> +	if (IS_ERR(cfg->clk_crypt_mux)) {
> +		dev_err(dev, "Failed to get clock crypt_mux: %pe\n", cfg->clk_crypt_mu=
x);
> +		return;
> +	}
        ^^^^^^^

[Severity: Medium]
Does this code silently swallow probe deferrals?

If the UFS host driver probes before the clock providers for crypt_mux,
crypt_lp, or crypt_perf, devm_clk_get() will return -EPROBE_DEFER.

Because ufs_mtk_init_boost_crypt() returns void, this error is caught,
logged, and swallowed instead of being propagated up to the probe sequence.

This means the UFS_MTK_CAP_BOOST_CRYPT_ENGINE functionality is permanently
disabled instead of correctly waiting for the clock providers to probe.

Note that while a follow-up patch fixes this exact issue for the
dvfsrc-vcore regulator by moving it to ufs_mtk_get_supplies(), the clocks
were left behind in ufs_mtk_init_boost_crypt() and remain broken at the
end of the series.

> =20
> -	if (ufs_mtk_init_host_clk(hba, "crypt_lp",
> -				  &cfg->clk_crypt_lp))
> -		goto disable_caps;
> +	cfg->clk_crypt_lp =3D devm_clk_get(dev, "crypt_lp");
> +	if (IS_ERR(cfg->clk_crypt_lp)) {
> +		dev_err(dev, "Failed to get clock crypt_lp: %pe\n", cfg->clk_crypt_lp);
> +		return;
> +	}
> =20
> -	if (ufs_mtk_init_host_clk(hba, "crypt_perf",
> -				  &cfg->clk_crypt_perf))
> -		goto disable_caps;
> +	cfg->clk_crypt_perf =3D devm_clk_get(dev, "crypt_perf");
> +	if (IS_ERR(cfg->clk_crypt_perf)) {
> +		dev_err(dev, "Failed to get clock crypt_perf: %pe\n", cfg->clk_crypt_p=
erf);
> +		return;
> +	}
> =20
> -	cfg->reg_vcore =3D reg;
> -	cfg->vcore_volt =3D volt;
> +	host->crypt =3D cfg;
>  	host->caps |=3D UFS_MTK_CAP_BOOST_CRYPT_ENGINE;
> -
> -disable_caps:
> -	return;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016-mt8196-ufs=
-v14-0-e8d565e0cd45@collabora.com?part=3D10
