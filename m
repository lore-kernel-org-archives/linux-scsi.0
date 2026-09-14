Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCF638655C;
	Mon, 14 Sep 2026 12:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789389948; cv=none; b=PHKfUevQ3a4F5zO/te640ibABU4YVBUr+UUzKvAX1L9+lxibMV8nQcf9XanFwHG3VAIHVEwtEcMsvwuMkB4NSjZfNn8USGNjhZR79+vbNn05FP/r9wj0Qt3Vt37XkGoHwwsJN9TjRl+jnT+tq+F9w8K/0qy54cTlSnW2mYHJQto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789389948; c=relaxed/simple;
	bh=HXezGdCdDEsGlJc/9Ck6BcpNP3nSqAU42o80/9cAu58=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NK+0EZqKhET4+qNLl6aZgbZLZxLCRfnYwX3zi+CEF2rIwS5GWQbDV9yse8xSVp53JUUFJicCTGvuvBp0FoOxJqSxKWloQVau8X1dsUMNnMJOYRhYq+fO8FOfb3fx9SEdAqVqbEbGOzDY1gw4xcU37UCwjnIGMbdeJTpevVfhPEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I3fDGOn1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I3fDGOn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC2F1F000FF;
	Mon, 14 Sep 2026 12:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789389946;
	bh=57ZSRc601GzQEtLlCHRTFktl0ay/BmrztWI7CWEW9Qw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I3fDGOn1jmkk8Iiht45jTiEeqGr5Z2kuLM99TprHV5GOUfi4me0Yj56ERMgRxwHJT
	 XJWXHIaNmU8ACSvSqQQ2L6iF1yYqszCIuBb0cfPwG0a1Rw7O0jh0sjo1PXFUFaFJhv
	 qdpCXaX7QzE/1zi9HTPq02U40zVMIA0r3Z8KeEendIi1UKSeBFQsDKS6jdF3o/KNU8
	 a2JY6pw7gdOlO5vGMuUUzmq8X+6tvrc0yzo7vZSS+XKckgYPCd8Q/DAhiJ8U9/iwJo
	 q/7UllQCs6KcVMyIk8TYZsv6FhqJalf/ys06FlplKUaH/c8VTF1N7QgOGLEIqiWCul
	 mHg7PHt8fgB7Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 13/24] scsi: ufs: mediatek: Remove vendor kernel
 quirks cruft
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-scsi@vger.kernel.org, conor+dt@kernel.org, robh@kernel.org, devicetree@vger.kernel.org, neil.armstrong@linaro.org, vkoul@kernel.org, olteanv@gmail.com, linux-phy@lists.infradead.org
In-Reply-To: <20260914-mt8196-ufs-v12-13-9279d7ef814d@collabora.com>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
 <20260914-mt8196-ufs-v12-13-9279d7ef814d@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 12:45:46 +0000
Message-Id: <20260914124546.7AC2F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Incomplete cleanup: unused macro, enum, and SiP command left in hea=
der file
--

commit 5f2b17479ebe3d92418015f1a81b60d943aa3ac6
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Remove vendor kernel quirks cruft
   =20
Both ufs_mtk_vreg_fix_vcc and ufs_mtk_vreg_fix_vccqx look like they are
vendor kernel hacks to work around existing downstream device trees.
Mainline does not need or want them, so remove them.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 3d108a0929205..3c10a9fd09dfc 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1053,73 +1053,6 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hb=
a)
>  	}
>  }
> =20
> -#define MAX_VCC_NAME 30
> -static int ufs_mtk_vreg_fix_vcc(struct ufs_hba *hba)
> -{
[ ... ]
> -	if (of_property_read_bool(np, "mediatek,ufs-vcc-by-num")) {
> -		ufs_mtk_get_vcc_num(res);
> -		if (res.a1 > UFS_VCC_NONE && res.a1 < UFS_VCC_MAX)

[Severity: Low]
With the removal of this function, does this also mean that
ufs_mtk_get_vcc_num(), enum ufs_mtk_vcc_num, and UFS_MTK_SIP_GET_VCC_NUM
are now entirely unused?

Looking at drivers/ufs/host/ufs-mediatek-sip.h, it seems like these were
only used here and could be removed as well to avoid leaving dead code behi=
nd:

drivers/ufs/host/ufs-mediatek-sip.h:
#define UFS_MTK_SIP_GET_VCC_NUM           BIT(6)

...

enum ufs_mtk_vcc_num {
	UFS_VCC_NONE =3D 0,
	UFS_VCC_1,
	UFS_VCC_2,
	UFS_VCC_MAX
};

...

#define ufs_mtk_get_vcc_num(res) \
	ufs_mtk_smc(UFS_MTK_SIP_GET_VCC_NUM, &(res))

Could these be cleaned up in this patch as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-mt8196-ufs=
-v12-0-9279d7ef814d@collabora.com?part=3D13
