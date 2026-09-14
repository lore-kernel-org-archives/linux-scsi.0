Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746B34499B0;
	Mon, 14 Sep 2026 12:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388486; cv=none; b=b9Od9Yyhj51gSf3A0LEpnzNs00AD7n0IPfEW2pvCVEL0njQ8ZuQ3hmqdjfELpBL6tJCLOentbvyhvBSPwj4dlRy+KjIIkZkaFYovYafinqX01T5C5ykSgpNupreKhKrlPYoQBS5IPtJxSIF4egxPCW0T4o3a4QFy99BRXm1Wd1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388486; c=relaxed/simple;
	bh=ApsZGKuPi3IwisuXYR4uVlRDKwOUYJO7HSStNuLCH7w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T55oHDPerPFIY6bh0+DllMlVcziF4OxBlSiaYdhkj7fd1n92xPphGRt0LmzXZ7rXHNueNowwo1VNm6uLw6LCTaydr9nyWkQowbDrz7OX3UXot4UjC531efKooAR8+5t2SGCfERiAwEtPYBF4yNNei263mahdB34xnpusNoGWlXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0N4iX5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0N4iX5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80631F000FF;
	Mon, 14 Sep 2026 12:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388485;
	bh=RBJbzxmO+Vl6+bOBg4GNP5t1gGxwYu+KqDZ/3fHyHIk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G0N4iX5TmB2lNBpvlydl6JqxmM1AKpVtLAjDNL1i6Yt1L8PK0xv+HrewAcKU2ytwu
	 OyKy2AmZ03In+nGG45APhb9RHUSpPMGSJKIqNy+QDz4YbSxj+96Z/uTrOZQ9XLzrH/
	 Eb8TpDpnHX86KNhk99Speuzuf2skEP/NqRb2+I1weadNw6BSgjH9LEVg0roNOlZ9D/
	 cmxzzc8+xssCqPMkaMXcnQhfjdwJDv3YM8dZlos6BzptRevYt8JTTcuMdg65yk2GpX
	 R5ZV8zojq26gKlvdLRQiPabtgD9T4tFNv8Y6WzUhFSfvy1mktjDzx/Kgt8u70QM20s
	 i47R1fV5NMvtQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 08/24] scsi: ufs: mediatek: Add dual 0.9V supply
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, linux-scsi@vger.kernel.org, olteanv@gmail.com, devicetree@vger.kernel.org, neil.armstrong@linaro.org
In-Reply-To: <20260914-mt8196-ufs-v12-8-9279d7ef814d@collabora.com>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
 <20260914-mt8196-ufs-v12-8-9279d7ef814d@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 12:21:24 +0000
Message-Id: <20260914122124.B80631F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unchecked NULL pointer dereference of optional regulator `host->re=
g_avdd09` in error recovery paths.
--

commit c69b1189125cd5106318d877fff7d1bf82dfd012
Author: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

scsi: ufs: mediatek: Add dual 0.9V supply support

This commit adds support for an additional 0.9V supply on the MT8196 SoC.
It introduces a second optional 0.9V regulator named "avdd09-1" to the
platform data and manages its enabling and disabling alongside the primary
supply.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index f43bee50adb28..467fc77c90e12 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -513,18 +514,37 @@ static int ufs_mtk_wait_link_state(struct ufs_hba *=
hba, u32 state,
>  static int ufs_mtk_09v_off(struct ufs_mtk_host *host)
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
> +
> +			ret2 =3D regulator_enable(host->reg_avdd09);

[Severity: High]
Can this cause a NULL pointer dereference?

Since host->reg_avdd09 is fetched using devm_regulator_get_optional(), it
can be NULL if it is absent from the device tree. If a system only has the
avdd09-1 supply configured and disabling it fails, this error path will
unconditionally call regulator_enable() with a NULL pointer, which will
cause a crash when the core API dereferences it.

> +			if (ret2)
> +				dev_err(host->hba->dev, "Failed to re-enable avdd09-supply: %pe\n",
> +					ERR_PTR(ret2));
> +
> +			ufs_mtk_va09_pwr_ctrl(res, 1);
> +			return ret;
> +		}
>  	}
> =20
>  	return 0;
> @@ -535,14 +555,26 @@ static int ufs_mtk_09v_on(struct ufs_mtk_host *host)
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
> +			regulator_disable(host->reg_avdd09);

[Severity: High]
Could this lead to a kernel panic if avdd09 is missing from the device tree?

Similar to the off path, if host->reg_avdd09 is NULL and enabling
reg_avdd09_1 fails during runtime, calling regulator_disable() on a NULL
pointer will result in an immediate crash.

Should there be a check to ensure host->reg_avdd09 is not NULL before
attempting to disable or enable it in these error paths?

> +			return ret;
> +		}
>  	}
> =20
>  	ufs_mtk_va09_pwr_ctrl(res, 1);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-mt8196-ufs=
-v12-0-9279d7ef814d@collabora.com?part=3D8
