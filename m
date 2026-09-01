Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EF547DFA8;
	Tue,  1 Sep 2026 16:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788280012; cv=none; b=RQ1Eqvw6yOEzG70Oz20Kq3D2AQDPMuQ1rMYZr5pksfZVqAoFOsCoY58dN9CpQfkjYVsvLqnj9WVdnp1/McMHdvj4WZJkUxirPpi4nIES1hCniKqzIqwqoaWc/KotLCeX9a1gUtw22eIKJ2R6scfwDq6pZfAyLIRsYoh+4myZhWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788280012; c=relaxed/simple;
	bh=VDPrcUUypC8KpVgHLZizy6lmKxS/ZLwHGx4uNkD4HsA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Bx7MLP0/Zwe9BcF07XykwfZ8KjGTDnTHRheYQJOhf2D4ht3NF6Dfn25C2RDFN1gXIeMIFDZCHosfn2KDAp3hzDgmcHGIAVuOc3xhyoFwvlLJtzPwLkhPtJupJ7iaBsqDahnx02JZmqblIoWaKOhMSwFEAX/bw70RwkxnpGZ9AGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SA7rYR8L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SA7rYR8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B6D1F000E9;
	Tue,  1 Sep 2026 16:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788280010;
	bh=NVCcuS1Pbbtguh8VUMzbatetxCy9mJfpPGOgAUSyILU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SA7rYR8LHLfmH2XL38prYerkgTaI3USKMEzKCDKkQJ/XHEmTANnpxpxEYIzO0xTf3
	 LBNN4bnHGVA4Yq+K3BN+5WE1sTO6qaLLvZvuUJ646vLNUr15PwwNsj4qghbb/JhElI
	 Z3FP3IZucbZhN62JzR/LAoJ+RZbxJVn4FBfvMONeB5XSI42K1H8l0YdcLScTmtedO4
	 /ex1ndktdXkxd1p7p9y3iwoSNR0E65nJC6ogd6NrgnQxm9+2a66aTOBTdI9kLpf4yP
	 6b39Tj0ijp18Cxb9jk8u8KozbDs9QAgf+02v87bu4BDi2FYnsQtA/1fvaIn7B1CqUY
	 VyabUpqeuhpag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 22/24] scsi: ufs: mediatek: Remove ret local from
 link_startup_notify
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org, linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, olteanv@gmail.com, devicetree@vger.kernel.org
In-Reply-To: <20260901-mt8196-ufs-v11-22-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
 <20260901-mt8196-ufs-v11-22-dbd007704490@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 16:26:49 +0000
Message-Id: <20260901162649.E5B6D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The return value of ufshcd_dme_set() is overwritten on MT6989 plat=
forms without being checked, losing the error state.
- [High] The return value of ufs_mtk_auto_hibern8_disable() is completely i=
gnored in ufs_mtk_pwr_change_notify().
--

commit 8329ac726de58d3aa2453eb0ed319e7fbbfb2a6d
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Remove ret local from link_startup_notify

This commit removes the unused local ret variable from
ufs_mtk_link_startup_notify. It also refactors the function to return
directly from the switch statement.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 4782fdf54866b..bcde58e3aee86 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1543,21 +1543,15 @@ static void ufs_mtk_post_link(struct ufs_hba *hba)
>  static int ufs_mtk_link_startup_notify(struct ufs_hba *hba,
>  				       enum ufs_notify_change_status stage)
>  {
> -	int ret =3D 0;
> -
>  	switch (stage) {
>  	case PRE_CHANGE:
> -		ret =3D ufs_mtk_pre_link(hba);
> -		break;
> +		return ufs_mtk_pre_link(hba);

[Severity: High]
This isn't a bug introduced by this patch, but looking at ufs_mtk_pre_link()
which is called here:

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_pre_link() {
	...
	ret =3D ufshcd_dme_set(hba, UIC_ARG_MIB(VS_SAVEPOWERCONTROL), tmp);

	/* Enable the 1144 functions setting */
	if (host->ip_ver =3D=3D IP_VER_MT6989) {
		ret =3D ufshcd_dme_get(hba, UIC_ARG_MIB(VS_DEBUGOMC), &tmp);
	...
}

Does this code unconditionally overwrite the return value of ufshcd_dme_set=
()
when the IP version matches MT6989 without being checked?

If ufshcd_dme_set() fails while disabling deep stall, the failure appears to
be silently ignored on these platforms.

Leaving deep stall inappropriately configured might lead to UFS bus lockups
and command timeouts.

>  	case POST_CHANGE:
>  		ufs_mtk_post_link(hba);
> -		break;
> -	default:
> -		ret =3D -EINVAL;
> -		break;
> +		return 0;
>  	}
> =20
> -	return ret;
> +	return -EINVAL;
>  }

[ ... ]

[Severity: High]
This is also a pre-existing issue in this file, but while reviewing the not=
ify
functions, I noticed this in ufs_mtk_pwr_change_notify():

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_pwr_change_notify() {
	...
	case PRE_CHANGE:
		if (ufshcd_is_auto_hibern8_supported(hba)) {
			host->ahit =3D ufshcd_readl(
				hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
			ufs_mtk_auto_hibern8_disable(hba);
		}
		return ufs_mtk_pre_pwr_change(hba, dev_req_params);
	...
}

Is the return value of ufs_mtk_auto_hibern8_disable() intentionally ignored
here?

If it fails and returns an error like -EBUSY, the code proceeds to execute
ufs_mtk_pre_pwr_change().

Executing power mode changes while the link is stuck in hibern8 and error
recovery is pending could result in hardware lockups and unresponsiveness in
the storage subsystem.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-mt8196-ufs=
-v11-0-dbd007704490@collabora.com?part=3D22
