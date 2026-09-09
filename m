Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CBD3D6692
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 09:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788945794; cv=none; b=DkpR4YEkxNV+1WwqyVkjIrV0zZp1Hbny5SUON4XOzjptuYTVO4coq5/W7giPCaIgEjTJPtuT4ENwmfqs/n3puSAMgGvxRdfyexDewykGReGv9gW1LSS5jrP2JAfGMoN3hoyQxEO1hznMKE9HSqCggeASrxKf8QRqLkSJVamRZgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788945794; c=relaxed/simple;
	bh=iOUBhSAwIPv7da2ivKRQEgEQhHOXeHY45jYjOhzHUfQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mWv7e3DzbGxpLcf0J/HR2xo/6u7KLixkGtnAbIaewp7ucaOwLn64fBHOzUsiVQrcv49WmGFJpfxq5YENpz2bC9UJQVAMS1cwVySEIJsm6Mk5ZznbYJdnlFA3yvrwfGMyY+WLBEmw2jaoctA6vM9gOOi2TwWp/vrVRzz2qonuEyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UX6/q1Dr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UX6/q1Dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9861F0156E;
	Wed,  9 Sep 2026 09:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788945789;
	bh=6Dt3K4wqq1POY831b13yRy5W5cGO1ZNAUu9WUltQqoM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UX6/q1DrMA9ae38WOgyCw9vaP2DwadJSAquykm5rrDIIaPmd0WihyRnOGsYRzwNdU
	 PTzphEHDvLwv854TQF5jF15T0Ak2SC8ksYOd0uPVOdeinM1RzhhlwXwA8rTDXtNi/d
	 2uPrcH35fTi7lWzOcgTGEPxqow1XYZmJIIIdwmXcFb5Fr52/BXRFRbsuf6z9/6lxz1
	 Fo/UimjKTMF82soxL0Cud0TGHnDIHuwwuME8KcCDaZqI9Uf+JkVUOAwObNKHCaa1Tb
	 75ADFOecGm/bZSKNbbRfiBERNObNIySwFo2DV3qaX7fu4TYpnhR9BIKMLxh9TBKzrJ
	 lkBnakAZHjEGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] ufs: core: serialize AHIT register access between
 sysfs and host driver
Reply-To: sashiko-reviews@lists.linux.dev
To: peter.wang@mediatek.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260909091120.1134414-1-peter.wang@mediatek.com>
References: <20260909091120.1134414-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 09:23:09 +0000
Message-Id: <20260909092309.AE9861F0156E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The `ahit_disable_depth` counter leaks when a DME power mode chang=
e fails, permanently blocking sysfs AHIT updates.
--

commit 1d1062f790f3ef8d13bc9cf9bc515eb73918a76f
Author: Peter Wang <peter.wang@mediatek.com>

ufs: core: serialize AHIT register access between sysfs and host driver

This commit introduces a mutex and depth counter to serialize Auto-Hibernate
Idle Timer (AHIT) register access between sysfs updates and power mode chan=
ges.
The counter suppresses sysfs writes while a host driver has forced AHIT off.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 541bbaf92c21c..b0ce134ec9cf1 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1508,19 +1508,27 @@ static int ufs_mtk_pwr_change_notify(struct ufs_h=
ba *hba,
>  				struct ufs_pa_layer_attr *dev_req_params)
>  {
>  	int ret =3D 0;
> =20
>  	switch (stage) {
>  	case PRE_CHANGE:
>  		if (ufshcd_is_auto_hibern8_supported(hba)) {
> -			reg =3D ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +			/* Block sysfs AHIT writes while we force AHIT off */
> +			mutex_lock(&hba->ahit_mutex);
> +			hba->ahit_disable_depth++;

[Severity: High]
Does this code leak the ahit_disable_depth counter if a power mode change
fails?

If ufshcd_dme_change_power_mode() fails after ufshcd_vops_pwr_change_notify=
()
has run for PRE_CHANGE, the POST_CHANGE notification is skipped:

drivers/ufs/core/ufshcd.c:ufshcd_change_power_mode() {
    ...
	ufshcd_vops_pwr_change_notify(hba, PRE_CHANGE, pwr_mode);

	ret =3D ufshcd_dme_change_power_mode(hba, pwr_mode, pmc_policy);

	if (!ret)
		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, pwr_mode);
    ...
}

Because POST_CHANGE is never called on failure, the ahit_disable_depth
counter is never decremented. This permanently blocks sysfs AHIT updates in
ufshcd_auto_hibern8_update() until the device is reset or the system is
rebooted.

> +			mutex_unlock(&hba->ahit_mutex);
>  			ufs_mtk_auto_hibern8_disable(hba);
>  		}
>  		ret =3D ufs_mtk_pre_pwr_change(hba, dev_req_params);
>  		break;
>  	case POST_CHANGE:
> -		if (ufshcd_is_auto_hibern8_supported(hba))
> -			ufshcd_writel(hba, reg, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +		if (ufshcd_is_auto_hibern8_supported(hba)) {
> +			mutex_lock(&hba->ahit_mutex);
> +			/* re-enable only when the last disabler drops off */
> +			if (!--hba->ahit_disable_depth)
> +				ufshcd_writel(hba, hba->ahit,
> +					      REG_AUTO_HIBERNATE_IDLE_TIMER);
> +			mutex_unlock(&hba->ahit_mutex);
> +		}
>  		break;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909091120.1134=
414-1-peter.wang@mediatek.com?part=3D1
