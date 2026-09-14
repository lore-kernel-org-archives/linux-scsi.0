Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0EB45198E;
	Mon, 14 Sep 2026 13:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789392333; cv=none; b=YcsTk117EKT1iB6Sz1Id2rbDL/0ThGfDSFypK2qu5AKaVDVcPSsMb2512X7URF85GYSK5UYFF0nKZU83uokYhik0LWQaDulpr9oD3O6OS4bR0T5tn5Bl/MJDxp1BL725so5a3W1PU8S8fZ9NzUFDSi9bvrEWliIgt/3bYS5Aia0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789392333; c=relaxed/simple;
	bh=5zPQx9oSaj57aNTmom7FrNbh88NFxTRzMOMkSFLR2jk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UgE9bd6FlqqNC6aOFKlz7cPJF8YM1vSo40UNX3igP8C/qUY+XuuP2y4CxANu6WiTD3MaAMuENXJN+tI/OisujxtZFi38Tlf5v7MuRgMz5V7kV7gInILaILsBy5NHV6zvGBorYoZVdpJpw1f0Z+Pl5F2Bfv1IHpG+j6JmoNZwhZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KFeULYDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KFeULYDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E761F000FF;
	Mon, 14 Sep 2026 13:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789392331;
	bh=Rry/0ntt2y+SFc/0AThu1SLgcoTiaKx70bKXtE6pHoA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KFeULYDdlytz8FK+lGByfjXmtWTj7607kz7hGP9ZR48PcA0vhNkw7FwF84G2OkRhU
	 JaFzn7vGRC2g77EezEWnbU6mS7HWp7H3S+Y5MouoG+D0VcWRD00qpO96ShHqXRriNd
	 7BLjuz/WO8GeVioXuxFz7PWnkmz8WM6oSZ51wZK4jwKpfSz6BgIGAJPR2mNrmvfbb4
	 EToefo2A1HbQJDnEveRG1PhAitidgId5V+00EFXQDc3GjRQ801ywdYF6522EV6ANBi
	 Ntoen1b6w00TZrbIeN5uZneTc7u70lLgtpauxzNXtM8TlBRnKHdoFAS3mldd+v/qZj
	 Jq8hmQIs9cdjQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 23/24] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: vkoul@kernel.org, olteanv@gmail.com, neil.armstrong@linaro.org, conor+dt@kernel.org, devicetree@vger.kernel.org, robh@kernel.org, linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org
In-Reply-To: <20260914-mt8196-ufs-v12-23-9279d7ef814d@collabora.com>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
 <20260914-mt8196-ufs-v12-23-9279d7ef814d@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 13:25:30 +0000
Message-Id: <20260914132530.A2E761F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Clock scaling state is updated unconditionally even if clock opera=
tions fail, and partial reparenting is not reverted.
--

commit 42aaaa81d59b5f138bb60c0e81306845236f3259
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Remove undocumented "clk-scale-up-vcore-min"

The MediaTek UFS driver contains support for an undocumented,
non-vendor-prefixed u32 property named "clk-scale-up-vcore-min".
Since it is not part of any binding, this patch removes it.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 2ebf7a3118dab..ef8924704c902 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -2000,14 +1976,6 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba=
, bool scale_up)
>  	}
> =20
>  	if (scale_up) {
> -		if (clk_bind_vcore) {
> -			ret =3D regulator_set_voltage(host->reg_vcore, volt, INT_MAX);
> -			if (ret) {
> -				dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
> -				goto out;
> -			}
> -		}
> -
>  		ret =3D clk_set_parent(clki->clk, mclk->ufs_sel_max_clki->clk);
>  		if (ret) {
>  			dev_err(hba->dev, "%s: Failed to set clock mux: %pe\n",
>  				__func__, ERR_PTR(ret));
>  			goto out;
>  		}

[Severity: High]
This is a pre-existing issue, but I noticed that if clk_set_parent() succee=
ds
here, but the subsequent reparenting for fde_clki->clk fails, the function
jumps to the cleanup block without reverting this successful parent switch:

		if (clk_fde_scale) {
			ret =3D clk_set_parent(fde_clki->clk, mclk->ufs_fde_max_clki->clk);
			if (ret) {
				dev_err(hba->dev, "%s: Failed to set fde clock mux: %pe\n",
					__func__, ERR_PTR(ret));
				goto out;
			}
		}

Because _ufs_mtk_clk_scale() returns void, the caller ufs_mtk_clk_scale() h=
as
no way to know that the hardware operations partially failed, and it
unconditionally updates the software state anyway:

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_clk_scale() {
    ...
	_ufs_mtk_clk_scale(hba, scale_up);

	host->clk_scale_up =3D scale_up;

	/* Must always set before clk_set_rate() */
	if (scale_up)
		clki->curr_freq =3D clki->max_freq;
	else
		clki->curr_freq =3D clki->min_freq;
    ...
}

Will this permanently desynchronize the hardware and software states if clo=
ck
reparenting fails, leaving the UFS controller in a broken mixed-clock state
where future scaling requests are ignored?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-mt8196-ufs=
-v12-0-9279d7ef814d@collabora.com?part=3D23
