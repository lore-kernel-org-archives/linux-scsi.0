Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E396D48E0ED;
	Fri, 16 Oct 2026 12:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154631; cv=none; b=VUDWZxw0JQZum36zPUzUssLGFMaXaEZxx+QwxuTy9bn0rP1aGDEW/ImBXUCHpm5Qd0yr41FGXL3RCpIphVTPunHdz0T3MQ7J3lzgJE/XxWDecWup/dl2XziYaRAeYRoNqClv+28ng5aCr4TG86D8fje9YM+uj0gEQe0dWIkiAUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154631; c=relaxed/simple;
	bh=YEJY76x0hmQ03NAZWTD52GO4Fo0tgSdmcDgtl3oiyW0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=gbVmANT1H9QBv8rsy0c1TNx28APS24aGJcuX4x9L7rHImHCfWQD05bTids7wQI0ICCqVY1mPOykq3ufdiUKJGCBQjLmGpwGM+GUZz9pahECTAB3HsQeGYs3OwDdPrQdDvvWq8meKaEd9wvXnEU7KeK+UNeDpM+C920ijX79z5BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CAmu+SHz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CAmu+SHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335471F000C4;
	Fri, 16 Oct 2026 12:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792154629;
	bh=f9OSO7ggmunqqtMo4iT/tzqZ98l95/47dBKLB9aZ8B4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CAmu+SHzxPHdD9MdFNj80zi8J792EPhEZ8Jy1dGcJp3Q+BKqkQTG2PWV5TMVnprGA
	 8EV91sv/P2Kqb47aZbtpepdCfq2ZYfHMVTKZRhYi8RBNnpO5jYF20orXyzA8gNarRb
	 kjMM+MKrvnh+hhbvk0J5nJvbrAdIV5sWfug2pVrTMhyzlWvaQYjliRVVUgaSLTNj2M
	 YRsIzN5OOuFHkvor4YZM3JDMeRm5xC1IEhn6f2Iy90ymVAvzeajN51lPoBEthGSByW
	 eq+OFnlFxyNw+BKKS5AvBJHNOr5/5Lj3jtEzSNU8bG/i4CMg+hPYkYmHv2vwhjhMXn
	 YomWoz4YSV2gg==
Message-ID: <sashiko-outbox-174329@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 08/23] scsi: ufs: mediatek: Add dual 0.9V supply
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20261016-mt8196-ufs-v14-8-e8d565e0cd45@collabora.com>
References: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
 <20261016-mt8196-ufs-v14-8-e8d565e0cd45@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 12:43:48 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: ufs: mediatek: bypass of allow_pwr_on leaves regulator ena=
bled on error
--

commit 169f13062deb73e7db2227752ba9ee6ad0ec3257
Author: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

scsi: ufs: mediatek: Add dual 0.9V supply support

This commit adds support for an additional 0.9V supply pin on the MT8196
SoC compared to the MT8183 SoC. It introduces management for a second
optional 0.9V regulator named "avdd09-1".

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index bcb7f350984c0..c8c5f85507af6 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -513,20 +514,43 @@ static int ufs_mtk_wait_link_state(struct ufs_hba *=
hba, u32 state,
>  static int ufs_mtk_09v_off(struct ufs_mtk_host *host, bool allow_pwr_on)
>  {
>  	struct arm_smccc_res res;
> -	int ret;
> +	int ret, ret2;
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
> -		if (allow_pwr_on)
> -			ufs_mtk_va09_pwr_ctrl(res, 1);
> =20
> -		return ret;
> +	if (host->reg_avdd09) {
> +		ret =3D regulator_disable(host->reg_avdd09);
> +		if (ret) {
> +			dev_err(host->hba->dev, "Failed to disable avdd09-supply: %pe\n",
> +				ERR_PTR(ret));
> +			if (allow_pwr_on)
> +				ufs_mtk_va09_pwr_ctrl(res, 1);
> +
> +			return ret;
> +		}
> +	}
> +
> +	if (host->reg_avdd09_1) {
> +		ret =3D regulator_disable(host->reg_avdd09_1);
> +		if (ret) {
> +			dev_err(host->hba->dev, "Failed to disable avdd09-1-supply: %pe\n",
> +				ERR_PTR(ret));
> +
> +			if (host->reg_avdd09) {
> +				ret2 =3D regulator_enable(host->reg_avdd09);

[Severity: Medium]
When regulator_disable() fails for reg_avdd09_1, does this unintentionally
re-enable the avdd09 regulator even if allow_pwr_on is false?

For example, ufs_mtk_mphy_power_on() calls ufs_mtk_09v_off(host, false) on
its error path to force regulators off.

If the allow_pwr_on parameter is false to prevent rolling back to a powered=
-on
state, unconditionally calling regulator_enable() here seems to defeat the
purpose of the flag. This could leave the regulator actively powered on aft=
er
a forced shutdown.

Should this regulator_enable() be conditioned on allow_pwr_on as well?

> +				if (ret2)
> +					dev_err(host->hba->dev,
> +						"Failed to re-enable avdd09-supply: %pe\n",
> +						ERR_PTR(ret2));
> +			}
> +			if (allow_pwr_on)
> +				ufs_mtk_va09_pwr_ctrl(res, 1);
> +
> +			return ret;
> +		}
>  	}
> =20
>  	return 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016-mt8196-ufs=
-v14-0-e8d565e0cd45@collabora.com?part=3D8
