Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5166948EC9D;
	Fri, 16 Oct 2026 12:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154623; cv=none; b=FC4GVxZF/hP8YsMmPlOCefnj94sp/SO6p74TN5czMP75Nti+CsIuP82OdeiPGLS6te+k1BWwhAIIXYa3kyD7cx29maW45hDrX09ciPxUoIhnDlj+MWUvDgvs3uYby2ylUGBc5OoyW0AMAcAL/xMAVOF6UXXkBXo3BDwID7lZXpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154623; c=relaxed/simple;
	bh=dls08gHxBUjwJU+/AZOM7H6ToUoEuSmrDhJ9sY9mINE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=huF+XrObSrQQJB+2kCJEsTUKoIOIS0HACyWsf+FJiKixVtA36yJSTRfSItNyzctEMpoMhGQ+I3BMcp6DHgt+l1DlF2gNvMUQkX2SneU8l5Gl1UHgb6bTTgTVpKaLenVsHZ89V3x3tKoTwKJ1G7jViEB7ej5g4rAu58Mr9Z3DseY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1MTx9Bp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1MTx9Bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366DE1F000C4;
	Fri, 16 Oct 2026 12:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792154618;
	bh=sFVNTFoGHUrASjkmYtjqwEFnuAOqRGnu4QXjJP3mM8E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d1MTx9Bp17fkiU+2EgdscZLYd+23JjVfiT17kwNdnFAbA0rzBYYT44HI0f1POl0TS
	 NWOMfHQAuBvTDuM9Kb7wibrYjEvC07nrwkeGBMqTe/LBEG6f0Q+bmR9KUv73a5WYoz
	 7wE3HQ0qhvRfPMasY/gwwnTNm6RMPBLtD9j1Bhd6Jj/Zy9kA6g9qNwADx66rfP60QS
	 TGq8zk8Fcne5BuoT0uDvIbbBC0k3aTPo1SqCB3ne7iRN3SobYYQ7msNzYsQQVjCnwJ
	 hW8OyjLK9BWM4BR4bMHO2JBMPknqUYl1tVWZxO8knk6t9pRgOmSvT4/5xlF/82sb0w
	 e92tVO3s8U/YA==
Message-ID: <sashiko-outbox-174328@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 13/23] scsi: ufs: mediatek: Remove vendor kernel
 quirks cruft
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20261016-mt8196-ufs-v14-13-e8d565e0cd45@collabora.com>
References: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
 <20261016-mt8196-ufs-v14-13-e8d565e0cd45@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 12:43:37 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] scsi: ufs: mediatek: Orphaned SIP macro and enum definitions
--

commit e7bac0e7488467d72dbbc1b3e957e1e9f9f5563a
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

    scsi: ufs: mediatek: Remove vendor kernel quirks cruft
   =20
Both ufs_mtk_vreg_fix_vcc and ufs_mtk_vreg_fix_vccqx look like they are
vendor kernel hacks to work around existing downstream device trees.
Mainline does not need or want them, so remove them.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 46c9153be6e22..41e2e9f867013 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1066,73 +1066,6 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hb=
a)
>  	}
>  }
> =20
> -#define MAX_VCC_NAME 30
> -static int ufs_mtk_vreg_fix_vcc(struct ufs_hba *hba)
> -{
> -	struct ufs_vreg_info *info =3D &hba->vreg_info;
> -	struct device_node *np =3D hba->dev->of_node;
> -	struct device *dev =3D hba->dev;
> -	char vcc_name[MAX_VCC_NAME];
> -	struct arm_smccc_res res;
> -	int err, ver;
> -
> -	if (info->vcc)
> -		return 0;
> -
> -	if (of_property_read_bool(np, "mediatek,ufs-vcc-by-num")) {
> -		ufs_mtk_get_vcc_num(res);

[Severity: Low]
Removing ufs_mtk_vreg_fix_vcc() removes the only caller of
ufs_mtk_get_vcc_num(). Does this leave the ufs_mtk_get_vcc_num() macro,
the UFS_MTK_SIP_GET_VCC_NUM definition, and enum ufs_mtk_vcc_num completely
unused in drivers/ufs/host/ufs-mediatek-sip.h?

Could these definitions also be removed to avoid leaving dead code?

> -		if (res.a1 > UFS_VCC_NONE && res.a1 < UFS_VCC_MAX)
> -			snprintf(vcc_name, MAX_VCC_NAME, "vcc-opt%lu", res.a1);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016-mt8196-ufs=
-v14-0-e8d565e0cd45@collabora.com?part=3D13
