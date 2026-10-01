Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A047131ED83;
	Thu,  1 Oct 2026 08:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790843530; cv=none; b=jqUhn51LvLcVo4pZZxDUuztJDdvfXnw8hNemiKVJ279gickeFuq/9HSzdY4rZ8b1O0/XxIK5ATgoXWQ8Exb9u1oJSdWEuBLUQ07I3kBSuwo0zqisTja/OxAPCsMXx0HNBTd1BJAniwTOMZ3Y94UxK1wTYOFsXAokPTo3IdrVBDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790843530; c=relaxed/simple;
	bh=glhKukGiJzIZVH57m6PrhvO+x0h376PbA7JcNCP8iDA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oNiO7fcL383hqisS/pRsPVOGimFsPmK90z6ZGRI0jOX5k1jOVtRAr413Y0/oa8+SzMBxolyP4LM7IJ2Cn1jVztqrtSn1LUm0AZPfFKJWs5tDxz8yKNB4G1zgMfSU2dkfhbfUgvtPOA8kpwteRxDanH29ozNUFcbPXE9NfODG1zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I+2CrSH/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+2CrSH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE081F00898;
	Thu,  1 Oct 2026 08:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790843529;
	bh=mpY7MydxNt5SFaoXiVAk9+VF27dF7m0gGzMCvNKGgWQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I+2CrSH/LpqRidQAyz2KJdfq89yXzRyEQ6Fpoy8+LI6Xh1ueYLo7zJqhOuc4caY3J
	 9P27DtK2kMTnLBHFL4qJaLTmcfAsxTIOiGKzRyb/hIkMi1cxFosJramru+TOKXU791
	 IVL9FCUC8tCXQnKHMJfulDPq2O9YBRFGq5EWSrRKehVjrR2KjTPbrEJTHBB1ACtydF
	 Y7WR3vwJrOSyJajiBaZ/PrTWZatIMZRKuhPOWAjsCrCChQio5MXQ/GOgGfuNhGdnPo
	 ztdzmr9g8FiitxfZvv2T0jTyW79bExhGZexr5Xt4/FIz9Dk1yz7LuDOypKClqMMJKM
	 vtnQlzuavbC6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 17/24] scsi: ufs: mediatek: Clean up logging prints
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: vkoul@kernel.org, olteanv@gmail.com, linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, conor+dt@kernel.org, neil.armstrong@linaro.org, devicetree@vger.kernel.org, robh@kernel.org
In-Reply-To: <20261001-mt8196-ufs-v13-17-60854adab6d9@collabora.com>
References: <20261001-mt8196-ufs-v13-0-60854adab6d9@collabora.com>
 <20261001-mt8196-ufs-v13-17-60854adab6d9@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 08:32:08 +0000
Message-Id: <20261001083208.9DE081F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ufs: %pe obfuscates positive error from ufshcd_uic_change_pwr_mo=
de()
--

commit 3b8bc7216dce3fa2b458c4095b432de91443fd2c
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Clean up logging prints

This patch cleans up logging prints in the MediaTek UFS driver by
adjusting verbosity levels and using the %pe format specifier for
printing error pointers instead of generic integer logging.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 2edfa8bd877af..8e5a0a39ce6cf 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -1411,10 +1403,9 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *=
hba,
>  		ret =3D ufshcd_uic_change_pwr_mode(hba,
>  					FASTAUTO_MODE << 4 | FASTAUTO_MODE);
> =20
> -		if (ret) {
> -			dev_err(hba->dev, "%s: HSG1B FASTAUTO failed ret=3D%d\n",
> -				__func__, ret);
> -		}
> +		if (ret)
> +			dev_err(hba->dev, "%s: HSG1B FASTAUTO failed: %pe\n",
> +				__func__, ERR_PTR(ret));

[Severity: Medium]
When ufshcd_uic_change_pwr_mode() fails due to a positive UPMCRS status
code (e.g., PWR_REMOTE or PWR_BUSY), the returned positive value is
evaluated by if (ret) and passed to ERR_PTR().

Because the %pe format specifier checks IS_ERR(), which evaluates to false
for small positive integers, it will fall back to printing a hashed pointer
instead of the numeric error value.=20

Will this obfuscate the actual error code during UFS link initialization or
power mode change failures?

>  	}
> =20
>  	/* if already configured to the requested pwr_mode, skip adapt */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-mt8196-ufs=
-v13-0-60854adab6d9@collabora.com?part=3D17
