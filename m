Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793864550;
	b=dA+Bbz/J59ULoI8joYATWKFErvbVWtzTkfhWKUvB/5nZqbnmc86+aMq7fZ3YCyrbdIrt
	 jsJEkzCJEEMk41vwArebWSBCQGT8WFqU99s/3kykHdNZvaDMDCdiIia532ecBzkcNIVKS
	 x/Qiiqh0eT+5C01C/PGv00Yu+xEg2fcAAP4BAFgQENOoZfBSBSNLzcQ+ceVxvroC+avw0
	 StpvH6a189wQomavQlnL4RMqnstAnCqHDw5rKIGBe7TbF0WRZsrvKK7QOLrJQJt5Siz1h
	 tD96Y3fnhpbyehC1RImGBogabZCExM7Zobibouvcj9J2toSYphNs/qZBoa/vaGVVblg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793864550;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9pRlxeSne2aVpGYm6JwtKYwWXDsu0D+NpAQ6dRaR6aA=;
	b=ABMmxfvTpJRT/F9/1R8JLQXQV/8kYwTSN/MV2SP53qHBN94UeFC3IVdz9pB5IY5eZ7zX
	 tPw5pGj7wNzKVGyX3t6SDNGsJdZ03KsFK6c0O93YAchxDtm/TLu84HF77mj6yJquElGo2
	 XXwio1jCTxq3426AB7yrapibgGUUCePzE4o9ALONL6SzLg62n4eeVb/LTBplTVxhuxEJ+
	 WIXq5/Co6R/tW22O4MUQEG21Npg/yQIjUFk+uHTZ/7L2/0yEg7umF8oppB0FDW9CW2hyL
	 zrow3yWMinR1zERwqiVZeSJL8E7YFKBeqmCTMmkWQwlQB4QocjsBiuMln2cnP7cynHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IRaDoTd7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7E9606A31B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 07:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IRaDoTd7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C9B1F00A15;
	Thu,  5 Nov 2026 07:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793864550;
	bh=9pRlxeSne2aVpGYm6JwtKYwWXDsu0D+NpAQ6dRaR6aA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IRaDoTd7fQLloziT0NbNfRXewAGsdLGYrlG/Dvdv9/Vq01Qx2uA9XjC4Auw7dEUdJ
	 vZQRlbiH56f8461ltZDp8jFO2fkivKDvWm7dz7UuxmD2adHzqpeTn/GLiyIt17mqyC
	 AXlAP3Q15Xl2Gb1TFfnUNlzBW9GHnPChktYJARtyWPpRMaOVDXFrmYS5FlE8xK8J9z
	 0RSx7VVRFffys6/mdbLG4+1ZrrhPcKesud0K6mveqVi6sk2Mh+mHJgHuaEnuIHoPHc
	 XfFtFvsey/SRS0YO5/IEzd71EEe1SgpnF5+2PSP+xvXXVXPpP66K1eYzRGjgqwabKs
	 hahHmnvT2utug==
Message-ID: <sashiko-outbox-198692@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: ufs: core: Skip redundant variant resume
 after error recovery power-up
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261105071518.1458428-2-stanleyjhu@google.com>
References: <20261105071518.1458428-1-stanleyjhu@google.com>
 <20261105071518.1458428-2-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 07:42:29 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ufs: core: W-LUN left RPM_SUSPENDED after error recovery res=
et
--

commit 2e7bb517d17be41f390aa16033a12c2fb8953c6f
Author: Stanley Jhu <stanleyjhu@google.com>

scsi: ufs: core: Skip redundant variant resume after error recovery power-up

This commit tracks POST_CHANGE variant suspend state in
hba->is_vops_suspended so ufshcd_vops_resume() is skipped if the variant is
already resumed when ufs_device_wlun remains RPM_SUSPENDED across error
recovery.

> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
> index e55c2a02c1f50..9e4d8174a0f08 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -236,20 +236,31 @@ static inline void ufshcd_vops_fixup_dev_quirks(str=
uct ufs_hba *hba)
>  }
> =20
>  static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_o=
p op,
> -				enum ufs_notify_change_status status)
> +				      enum ufs_notify_change_status status)
>  {
> +	int ret =3D 0;
> +
>  	if (hba->vops && hba->vops->suspend)
> -		return hba->vops->suspend(hba, op, status);
> +		ret =3D hba->vops->suspend(hba, op, status);
> +	if (!ret && status =3D=3D POST_CHANGE)
> +		hba->is_vops_suspended =3D true;
> =20
> -	return 0;
> +	return ret;
>  }
> =20
>  static inline int ufshcd_vops_resume(struct ufs_hba *hba, enum ufs_pm_op=
 op)
>  {
> +	int ret =3D 0;
> +
> +	if (!hba->is_vops_suspended)
> +		return 0;

[Severity: High]
Does skipping ufshcd_vops_resume() here leave ufs_device_wlun out of sync
with the actual hardware and clock-gating state when error recovery resets
and restores the host after a failed W-LUN runtime resume?

When __ufshcd_wl_suspend() suspends the W-LUN, it calls ufshcd_hold(hba)
(incrementing hba->clk_gating.active_reqs) and sets
hba->clk_gating.is_suspended =3D true. If a subsequent __ufshcd_wl_resume()
fails (for example, in ufshcd_set_dev_pwr_mode()), it rolls back to
vendor_suspend: and exits through out:, which clears is_suspended and drops
the clock-gating hold without a matching ufshcd_hold(hba) on future resume
attempts:

drivers/ufs/core/ufshcd.c:__ufshcd_wl_resume() {
	...
vendor_suspend:
	ufshcd_vops_suspend(hba, pm_op, POST_CHANGE);
out:
	if (ret)
		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
	hba->clk_gating.is_suspended =3D false;
	ufshcd_release(hba);
	hba->pm_op_in_progress =3D false;
	return ret;
}

Because commit eef1d74bf88f ("PM: runtime: Only set runtime_error on
suspend callback failures") leaves ufs_device_wlun->sdev_gendev in
RPM_SUSPENDED with power.runtime_error =3D=3D 0, every subsequent call to
__ufshcd_wl_resume() without an intervening __ufshcd_wl_suspend() (first
from ufshcd_err_handling_prepare() -> ufshcd_rpm_get_sync(), and again on
the next runtime resume after recovery) calls ufshcd_release(hba) without
a matching ufshcd_hold(hba), underflowing hba->clk_gating.active_reqs.

Furthermore, during ufshcd_err_handler(), ufshcd_err_handling_prepare()
powers on the regulators, clocks, and variant, and ufshcd_reset_and_restore=
()
restores the controller, setting hba->uic_link_state =3D UIC_LINK_ACTIVE_ST=
ATE
and hba->curr_dev_pwr_mode =3D UFS_ACTIVE_PWR_MODE. However,
ufshcd_recover_pm_error() only marks ufs_device_wlun active if
power.runtime_error is set:

drivers/ufs/core/ufshcd.c:ufshcd_recover_pm_error() {
	...
	if (hba->ufs_device_wlun->sdev_gendev.power.runtime_error) {
		pm_runtime_get_sync(&starget->dev);
		pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev);
		pm_runtime_put_sync(&starget->dev);
		resume_sdev_queues =3D true;
	}
	...
}

With power.runtime_error =3D=3D 0, ufs_device_wlun, starget->dev, and
shost->shost_gendev remain in RPM_SUSPENDED (and consumer SCSI device
queues are not resumed here, though a later commit wakes consumer queues).
When ufshcd_err_handling_unprepare() then finishes:

drivers/ufs/core/ufshcd.c:ufshcd_err_handling_unprepare() {
	...
	if (ufshcd_is_clkscaling_supported(hba))
		ufshcd_clk_scaling_suspend(hba, false);
	ufshcd_rpm_put(hba);
	pm_runtime_put(hba->dev);
}

ufshcd_rpm_put(hba) will not run __ufshcd_wl_suspend() because
ufs_device_wlun is already RPM_SUSPENDED, and pm_runtime_put(hba->dev) can
runtime suspend hba->dev via ufshcd_suspend() while the UFS device is in
UFS_ACTIVE_PWR_MODE, the UniPro link is in UIC_LINK_ACTIVE_STATE, devfreq
clock scaling is active, and the variant is resumed.

Should ufshcd_recover_pm_error() instead transition ufs_device_wlun back to
RPM_ACTIVE when ufshcd_reset_and_restore() has powered up the device and
link, rather than leaving ufs_device_wlun in RPM_SUSPENDED with the hardware
and variant resumed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105071518.1458=
428-1-stanleyjhu@google.com?part=3D1
