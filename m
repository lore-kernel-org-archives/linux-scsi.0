Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0602848BE;
	Thu,  1 Oct 2026 08:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790843434; cv=none; b=FwcgWH/e3ySnTe/5hnURwJx7fbOReK91S+Py5rEQd38BZbGong0KqBMv2VKJNJhAtbmVKtXg4tBWVmXav45YVWDDAAZdHytNsFsVNeAr4I+ve54FqtPWpSizAMID2/qhgfyiCgXgVWK+VgIQcM5SFSAanHBvWUen/QGzpsqgsi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790843434; c=relaxed/simple;
	bh=5DlmcJQRYmi5BO+0RZCwb8rzFiI1dcZiKwNfU2UgCMk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pRm/ZxatwfdhuBsNRPB8QUHgwO+W+/C7lY6xaxG0WNhf5MPUccFkYSJELKcOL412LSqUpj7jGzrm+3VZNgZMKKgrhYEylzGZSOaYCJtU0onhD+W1cqvFdj+cfONTEO4wT84txr8Mmhcu1FxEEUtDAwJFMsaOVveVgpf2jqiOmBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgnR3HH+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgnR3HH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339681F000FF;
	Thu,  1 Oct 2026 08:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790843432;
	bh=tx802UC4J2g+jpO1y12LT8axhFS70v9Ik/UZtnMKgCI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QgnR3HH+O19Vw4ah1ceswscnK77HynLb0Q5JqBQegxRjRYI0S1AdrgLtis1wO7/CV
	 G+ihxG5+Teo/cBJpls93amMtB1KgBssOlb0/Mn8UckDeF6+CxXtP1t4LxppkbQqa3I
	 s5io3Gufw0QgZxsRvSeRF7I/oPGzHj5Pv/U4j+4jlnDGt84nHLmKo//Ig5V9NXwDl6
	 9cf5wSxr6kS0Ny7R7fgOPRKa6knQqU4frB5l+v9pFoMYG3a7LmygXVAl0fpMU8w3iH
	 BMoHE6ZNi6MmvQJwc3A6mlvCA6XFPaZ4VRbfGAXY69jOoRcoLAUwnz3E+VuBHaAwR7
	 RuEzPvWtOnNEA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 19/24] scsi: ufs: mediatek: Don't acquire
 dvfsrc-vcore twice
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, neil.armstrong@linaro.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, linux-phy@lists.infradead.org, olteanv@gmail.com
In-Reply-To: <20261001-mt8196-ufs-v13-19-60854adab6d9@collabora.com>
References: <20261001-mt8196-ufs-v13-0-60854adab6d9@collabora.com>
 <20261001-mt8196-ufs-v13-19-60854adab6d9@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 08:30:29 +0000
Message-Id: <20261001083030.339681F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] ufs: mediatek: missing dev_err_probe() causes probe deferral log sp=
am
--

commit d793732f4bb7b06145e7bd2323a3d21f956e829a
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Don't acquire dvfsrc-vcore twice

The ufs-mediatek driver needs to manage an optional dvfsrc-vcore regulator
but currently acquires two different references to it in different places.
This commit centralizes the reg_vcore acquisition in the host struct and
reworks the regulator users to eliminate the duplicated logic.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabor=
a.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index ca31f07d382b4..d14192dc3e31c 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -1106,6 +1091,17 @@ static int ufs_mtk_get_supplies(struct ufs_mtk_hos=
t *host)
>  	const struct ufs_mtk_soc_data *data =3D of_device_get_match_data(dev);
>  	int ret;
> =20
> +	host->reg_vcore =3D devm_regulator_get_optional(dev, "dvfsrc-vcore");
> +	if (IS_ERR(host->reg_vcore)) {
> +		if (PTR_ERR(host->reg_vcore) !=3D -ENODEV) {
> +			dev_err(dev, "Failed to get dvfsrc-vcore supply: %pe\n",
> +				host->reg_vcore);

[Severity: Low]
Since devm_regulator_get_optional() can return -EPROBE_DEFER, will using
dev_err() here cause spurious error logs in dmesg every time the probe is
deferred?

Could this be changed to dev_err_probe() to quietly handle the -EPROBE_DEFER
case while properly logging real errors?

> +			return PTR_ERR(host->reg_vcore);
> +		}
> +
> +		host->reg_vcore =3D NULL;
> +	}
> +
>  	if (!data)
>  		return 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-mt8196-ufs=
-v13-0-60854adab6d9@collabora.com?part=3D19
