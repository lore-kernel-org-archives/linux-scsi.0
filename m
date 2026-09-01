Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF62242BEAA;
	Tue,  1 Sep 2026 16:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788279070; cv=none; b=UkB8OJV9hy1gE131n8xc4i3Jebm03HH3JfIM8QvkQVlheHVeypXPjZ1Ot0Ll8Ftmgdo3XudJZzyJnc2waX5JuzjHxtZossSfY7YryH9KhJUVvNU0R+jsXeGZ6mycyRpdRsI/1CBYdzZTvYe4SvTk6Y93gH5ZtX0WFfgItFKY3nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788279070; c=relaxed/simple;
	bh=/mg/LarjeEFR+a2AcdFHnTPh8U2AsEYB9/rZDEZKiuo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FHgbWhKVQ+Hre6+ZciJTfKzUffpUorOleE0MwsMl7WDjAIl/ZuHxOgrMDPrRRA7RjHoEqW43B36+kqKYtNluZ9IBVM8NuPaKGT8n1oo8zucEcjcNkdGwU9eoPbn7310gR6FEx1tmO5ZFYQNlNfSaOeR6my/+KxL+CPD/uexCiNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A7ZSBk+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A7ZSBk+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C175A1F000E9;
	Tue,  1 Sep 2026 16:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788279069;
	bh=+YWU8hjMtZOoVqfdvhTkUjpT+2v10oM7nCmOFuTWuu4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A7ZSBk+/cY43bB79SNKM87+VVn6yGUIiWWPB7NsC8IymoeNj6lx+V2yuZNtyjVHFw
	 FRVYmSs254yya2vgcUvRalwhfdwE6kSKDZ761czVMG/TU2JRNYHi4uoSfiAMGXOSnv
	 LDoSiNkM99LQRx4hzLN0/WV8yjqD1+ftNAh2qH9CXL/D1sVSkUYlBVE4KmqZrs/1Fr
	 sV3GYv4pGsnOrCb8GfCX8wWsH4j9JlKMlvw9jOs9lrP3q2A1JCeLb5RsIUqbXbW+M4
	 h7yQVNHAkdxe17DCspaomTjiQuEYBurKXh0JOx5Nf9CKBn/vxV/vWy+oNEX7Cmp3O8
	 tzge4nhLna2gA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 11/24] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: conor+dt@kernel.org, olteanv@gmail.com, neil.armstrong@linaro.org, robh@kernel.org, devicetree@vger.kernel.org, vkoul@kernel.org, linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260901-mt8196-ufs-v11-11-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
 <20260901-mt8196-ufs-v11-11-dbd007704490@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 16:11:08 +0000
Message-Id: <20260901161108.C175A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Use of dev_err() instead of dev_err_probe() for a function that can=
 return -EPROBE_DEFER.
--

commit 46d3c0154cbe65fe31d813b45eaa3cb1732757ae
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Handle misc host voltage regulators

MediaTek SoCs handled by this driver contain a per-SoC specific set of
miscellaneous supplies. Add the necessary driver code to acquire these
supplies using the regulator bulk API and keep them on during suspend.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 6bbf53b658f2d..f61727879c3c7 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -1217,10 +1219,20 @@ static int ufs_mtk_get_supplies(struct ufs_mtk_ho=
st *host)
>  {
>  	struct device *dev =3D host->hba->dev;
>  	const struct ufs_mtk_soc_data *data =3D of_device_get_match_data(dev);
> +	int ret;
> =20
>  	if (!data)
>  		return 0;
> =20
> +	if (data->num_reg_names) {
> +		ret =3D devm_regulator_bulk_get_enable(dev, data->num_reg_names,
> +						     data->reg_names);
> +		if (ret) {
> +			dev_err(dev, "Failed to get misc regulators: %pe\n", ERR_PTR(ret));

[Severity: Low]
Could this spam dmesg during probe deferral?

If the regulators are not yet available when ufs_mtk_probe() calls
ufs_mtk_get_supplies(), devm_regulator_bulk_get_enable() will return
-EPROBE_DEFER. This causes dev_err() to print an error message on every pro=
be
retry.

Would it be better to use dev_err_probe() here instead to quietly handle
-EPROBE_DEFER and avoid the log spam?

> +			return ret;
> +		}
> +	}
> +
>  	if (data->has_avdd09) {
>  		host->reg_avdd09 =3D devm_regulator_get_optional(dev, "avdd09");
>  		if (IS_ERR(host->reg_avdd09)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-mt8196-ufs=
-v11-0-dbd007704490@collabora.com?part=3D11
