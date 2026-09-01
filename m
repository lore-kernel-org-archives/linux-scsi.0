Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549AC42BEAA;
	Tue,  1 Sep 2026 16:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788279518; cv=none; b=egzFYhJxQGtSxRMZWX6Q8ZgQ85/r0SaI7CsdWaPC4rIyAe65YczsQ2grEDI6t8lG+Xt7blUZo6FWRMBOO9BIhoHeRjkRDkIvPwhojCk6vu0u6rMZzfarvb6BPAGbV3I/h6dqcbmVi3oBidhm79uDawHRM6bRZo2xWAOre4Va6Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788279518; c=relaxed/simple;
	bh=U16uEXi0db1iTII8CMOEDq6cwyZhO1lZLFaSyA+CtKk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rJ8r46B57LsU+e+Cp+MxkLoW4LtpOOhHX1iGgTnOdb2N5dwQpiSBWh4TLni0IlKoHa+e7Pnc3AQfr1DKDBQIvJA4Hp0107EWsRBmzzLZBCgWwRZGl3eubFTFQIdv6a44Xr4MWedAQy2oOpwRnKnXqZnZscBKcgnGuvvUr26Y7fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KvFF6mBw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KvFF6mBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFA91F000E9;
	Tue,  1 Sep 2026 16:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788279515;
	bh=zxysoKyIvSHPIzqfXxkvp0kcCUztD7lpcnz06wNw6jQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KvFF6mBwWb9GLmzp6i2RT3SiCVr7boSEObWDcKLYNgRl0sVvXDk6sBImMK2jHAXOW
	 khGC69q+tPLyKJ9whfrYyBZwFvbN4A3N9joem80HlU0FVfjkzMSu2MQHDleXMdio1t
	 uZqqnYCENlUwSfVeVy2bStYxmBRukz6blNQ6Uhyn7gBCRNhMfEbkrSQfcGONvuv86S
	 ZmhbunAHAKgZsxzldDUHM6YO/we1IJEVJm2RzxAH0UnhKx7zMDoqVCIK7ao1Pca9PB
	 TE+aGcQo5H67eltHi9AmrLf2LiT4ejSvhQeeyPJartRAnP21ETZXpqzJkk/Oq7yWid
	 lrtL0uyUp6cjw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 17/24] scsi: ufs: mediatek: Clean up logging prints
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: robh@kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, neil.armstrong@linaro.org, vkoul@kernel.org, conor+dt@kernel.org, linux-phy@lists.infradead.org, olteanv@gmail.com
In-Reply-To: <20260901-mt8196-ufs-v11-17-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
 <20260901-mt8196-ufs-v11-17-dbd007704490@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 16:18:34 +0000
Message-Id: <20260901161835.1AFA91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Missing explicit `#include <linux/string_choices.h>` for `str_true_=
false()`.
--

commit 14b4b7d3f0923b03c71e3a5fddb58666e933f64a
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Clean up logging prints

This commit cleans up the logging levels in the MediaTek UFS driver to ensu=
re
errors are logged at the error level rather than info or warning levels. It
also updates prints to use the user-friendly %pe format codes for errors.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 43fb5dbb250b0..a84bffe069eb8 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -859,7 +855,8 @@ static bool ufs_mtk_is_legacy_chipset(struct ufs_hba =
*hba, u32 hw_ip_ver)
>  	default:
>  		break;
>  	}
> -	dev_info(hba->dev, "legacy IP version - 0x%x, is legacy : %d", hw_ip_ve=
r, is_legacy);
> +	dev_dbg(hba->dev, "IP version 0x%x, legacy =3D %s", hw_ip_ver,
> +		str_true_false(is_legacy));

[Severity: Low]
Does this code rely on implicit header inclusions? Using str_true_false()=20
in ufs_mtk_is_legacy_chipset() requires linux/string_choices.h, but it=20
doesn't appear to be explicitly included in this file or added by this patc=
h.

> =20
>  	return is_legacy;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-mt8196-ufs=
-v11-0-dbd007704490@collabora.com?part=3D17
