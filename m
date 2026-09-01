Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E62351C35;
	Tue,  1 Sep 2026 15:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788278378; cv=none; b=OM5g/qCun7cTLGxecmok8lqAM4O+32VzjwTRJ7B4LPyIXkHendQmsefT2lnM6XBOPuaBjOF1lKScXS/6s+NH/8uNnvCAUDhrrGSTc8KEgmoq96BvgdhCJmfRVO2JnqaIN+Pw/q670IkEFXY17o8VFaXOmyvPs0ClYlbZ4oDJpNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788278378; c=relaxed/simple;
	bh=ydbCa8n4Y3WIrgtlIEtnDhkmJHb5HWM0k/pUfqpiBoc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uHrINoStCkyVw6PBohBDeiBP6Ff/MKkk65xcb7zv8XF0gMTpTUL6Z8u8Qnw2866+YfgefCdP82raYUfMEwrD+/gXIxbMdXkVSRG5iwm3y3CAXnd952C/mH/wkQxU+F98ZVWyt4nh3eBI+ih7DrEenuPbx9QMiWMm8CO/46NFHd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zj10QOWN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zj10QOWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77AF1F000E9;
	Tue,  1 Sep 2026 15:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788278376;
	bh=7j42vq1/p7q82MIrqQwSAqyGBwrFxI6uBLhdizLdlxk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zj10QOWNMDTDgFraeo2mB4lb7NaR4gsZAX9Sk3grKtRtu0tslrTf1d3FEKfftrQVk
	 +hLRyjgZFB824IJijNdDhtSQmLjYxzDHiO6jmrTe3I6bFSICuDPMhj1BGwtG0K1jn0
	 +f/c5SBRwjN9Ke54kHnlKhkVnNu7KlGetqeYVieu+UCZTqgkaPlFFRXKdTnhra8tSN
	 2/v0VMUv0mWrZXc1GHDT7BP1nbghfynwmukmzMc0SX7+9UpttxWmkCnXTgwBajyfEy
	 NMJbDlVUQxfgjQAe0lJjPuLfIRo5qWH/+JEt3mno5H0nWfK0Kfma0YdeKz5BY/PnUU
	 IFX8lzldgLASg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 08/24] scsi: ufs: mediatek: Add dual 0.9V supply
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-scsi@vger.kernel.org, conor+dt@kernel.org, vkoul@kernel.org, robh@kernel.org, linux-phy@lists.infradead.org, devicetree@vger.kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20260901-mt8196-ufs-v11-8-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
 <20260901-mt8196-ufs-v11-8-dbd007704490@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 15:59:35 +0000
Message-Id: <20260901155935.E77AF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Missing rollback of avdd09 regulator state on avdd09-1 error paths=
 in ufs_mtk_09v_on() and ufs_mtk_09v_off().
- [Medium] Incorrect variable passed to %pe format specifier in dev_err_pro=
be() for avdd09-1 regulator error.
--

commit 233271811903bef688f03076564e8ae57965014c
Author: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

scsi: ufs: mediatek: Add dual 0.9V supply support

The MT8196 SoC has an additional pin compared to the MT8183 SoC to feed
the host controller with a 0.9V supply. This patch adds management for a
second optional 0.9V regulator named "avdd09-1" in preparation for this
SoC support.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index eb7a0cc464f43..f298ea6f6ecb9 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -515,16 +516,29 @@ static int ufs_mtk_09v_off(struct ufs_mtk_host *hos=
t)
>  	struct arm_smccc_res res;
>  	int ret;
> =20
> -	if (!host->reg_avdd09)
> +	if (!host->reg_avdd09 && !host->reg_avdd09_1)
>  		return 0;
> =20
>  	ufs_mtk_va09_pwr_ctrl(res, 0);
> -	ret =3D regulator_disable(host->reg_avdd09);
> -	if (ret) {
> -		dev_err(host->hba->dev, "Failed to disable avdd09-supply: %pe\n",
> -			ERR_PTR(ret));
> -		ufs_mtk_va09_pwr_ctrl(res, 1);
> -		return ret;
> +
> +	if (host->reg_avdd09) {
> +		ret =3D regulator_disable(host->reg_avdd09);
> +		if (ret) {
> +			dev_err(host->hba->dev, "Failed to disable avdd09-supply: %pe\n",
> +				ERR_PTR(ret));
> +			ufs_mtk_va09_pwr_ctrl(res, 1);
> +			return ret;
> +		}
> +	}
> +
> +	if (host->reg_avdd09_1) {
> +		ret =3D regulator_disable(host->reg_avdd09_1);
> +		if (ret) {
> +			dev_err(host->hba->dev, "Failed to disable avdd09-1-supply: %pe\n",
> +				ERR_PTR(ret));
> +			ufs_mtk_va09_pwr_ctrl(res, 1);
> +			return ret;
> +		}

[Severity: High]
Does this error path leave host->reg_avdd09 disabled if disabling
host->reg_avdd09_1 fails?

If the second disable fails, returning here means the power state becomes
desynchronized. Should host->reg_avdd09 be re-enabled here to match the
driver's expected state before returning the error?

>  	}
> =20
>  	return 0;
> @@ -535,14 +549,25 @@ static int ufs_mtk_09v_on(struct ufs_mtk_host *host)
>  	struct arm_smccc_res res;
>  	int ret;
> =20
> -	if (!host->reg_avdd09)
> +	if (!host->reg_avdd09 && !host->reg_avdd09_1)
>  		return 0;
> =20
> -	ret =3D regulator_enable(host->reg_avdd09);
> -	if (ret) {
> -		dev_err(host->hba->dev, "Failed to enable avdd09-supply: %pe\n",
> -			ERR_PTR(ret));
> -		return ret;
> +	if (host->reg_avdd09) {
> +		ret =3D regulator_enable(host->reg_avdd09);
> +		if (ret) {
> +			dev_err(host->hba->dev, "Failed to enable avdd09-supply: %pe\n",
> +				ERR_PTR(ret));
> +			return ret;
> +		}
> +	}
> +
> +	if (host->reg_avdd09_1) {
> +		ret =3D regulator_enable(host->reg_avdd09_1);
> +		if (ret) {
> +			dev_err(host->hba->dev, "Failed to enable avdd09-1-supply: %pe\n",
> +				ERR_PTR(ret));
> +			return ret;
> +		}

[Severity: High]
Does this path leak a reference count for host->reg_avdd09?

If enabling host->reg_avdd09_1 fails after host->reg_avdd09 was successfully
enabled, the function returns immediately without disabling host->reg_avdd0=
9.
Should host->reg_avdd09 be disabled before returning?

>  	}
> =20
>  	ufs_mtk_va09_pwr_ctrl(res, 1);
> @@ -1232,20 +1257,33 @@ static int ufs_mtk_get_supplies(struct ufs_mtk_ho=
st *host)
>  	struct device *dev =3D host->hba->dev;
>  	const struct ufs_mtk_soc_data *data =3D of_device_get_match_data(dev);
> =20
> -	if (!data || !data->has_avdd09)
> +	if (!data)
>  		return 0;

[ ... ]

> +	if (data->has_avdd09_1) {
> +		host->reg_avdd09_1 =3D devm_regulator_get_optional(dev, "avdd09-1");
> +		if (IS_ERR(host->reg_avdd09_1)) {
> +			if (PTR_ERR(host->reg_avdd09_1) !=3D -ENODEV) {
> +				return dev_err_probe(dev,
> +						     PTR_ERR(host->reg_avdd09_1),
> +						     "Failed to get avdd09-1 regulator: %pe\n",
> +						     host->reg_avdd09);

[Severity: Medium]
Are we passing the correct variable to the %pe format specifier here?

It looks like host->reg_avdd09 is passed instead of host->reg_avdd09_1, whi=
ch
would cause dev_err_probe() to print the pointer value or hash of the wrong
regulator instead of the actual error string.

> +			}
> +			host->reg_avdd09_1 =3D NULL;
> +		}
>  	}
> =20
>  	return 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-mt8196-ufs=
-v11-0-dbd007704490@collabora.com?part=3D8
