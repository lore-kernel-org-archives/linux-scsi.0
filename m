Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794278388;
	b=ziGWjTLAFE3YX7W7rwxkG7C1KXO7YOti2THBu/MYzcxZ6ZDKeh8vBRR4XTjUHRk84/aw
	 StanJdtSQm+HPJaXba80ntCIezrkKTUbiaYl30UuPnj9U6C35v4TdKEW/dIgqt1EnEjmp
	 sdFElAi5pHaj0AG+YchAMgwDx6IE1MTbuVt1/Del2Yur51kNVwL9I4ei3u6yJue8ptrzg
	 vTjzHTWxn606xGXA33ehkJh7fVVY8p8oxWsc3oEZMwIesLD8dWVvnIOAbvAkGrrs8lgub
	 8Ny4e85rZJHGS9eU+G7EbhwYSjMdo7g53BEaBzvgmMp7NT4EXhaknDKMu9KHsQO4idg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794278388;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=e/hgBg6wQ+73uA/gnQyK/Gi9nXRDmywIXvbgYHvOhhw=;
	b=Wb0jOHwtvEteuoE+FUgDtNrW8Gwh3iVgimkGtAGEmHst1SEllMDpXPEA7szfC42o07Zi
	 XrC/VEYVWBITNm9W4M+Homiia+jWCNMoRgg/hnqSrUOXH6pl8GdC4e4q3GAEhU0U+oqF3
	 bc4VceEqXGgxtoLrZRQXMBi7sZcTZ2/zH9SDzVQSTO7XudBSIMLBl0zF4szv6x8NsJguX
	 XsKFlIPeFC5u+Azkjyg1yefb9f2PPBrQ/brVHIp/a811mJrkZfsXY+3NwCsCXYFNEZoPd
	 4kjGQvKf6s+cdljsl8PRGRGHG5xUVcPIn2YkawfjXM0fUTQ4AdvoAmwJzTVhTDCbI8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YV+p0qkg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DA3606A31C
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 02:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YV+p0qkg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF75A1F0089F;
	Tue, 10 Nov 2026 02:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794278387;
	bh=e/hgBg6wQ+73uA/gnQyK/Gi9nXRDmywIXvbgYHvOhhw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=YV+p0qkgs2XUdlr8peYTQOvJ6g51uwoyjCOw1LBCT7zrr7zV24MD1ySnJGEUyEenn
	 qpaOKmn+AeErr/gsPshMxt6MpiYNHnEl/zJ3oloYJG7fPd9U9Hf4i4o/8YOPezc6qj
	 OL16y3WoilQi+2KTxT7ntV9Z7zT++eXPaWomYeol1TpgNWyx0R5muWgLYRyDwv1A/R
	 GYNRmhqvWHprS7xsBdbe2YQAA+pK2tfHwCDuKQ88Wbe+IRUcqmx2s7BmvEdGHLqxvD
	 4kZK5i5X5pCrEF1C5v0dbq1Z5hC6ZF2Bcp+EKP/SKnNx22EtiNBRJXB4vJq2K0zgBx
	 oIicETfhWpvyQ==
Message-ID: <sashiko-outbox-206058@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 2/3] scsi: ufs: core: Hold host_sem in
 ufshcd_wl_poweroff()
Reply-To: sashiko-reviews@lists.linux.dev
To: "HOYOUNG SEO" <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <973576304.21794277202839.JavaMail.epsvc@epcpadp1new>
References: <cover.1794275305.git.hy50.seo@samsung.com>
 <CGME20261110020747epcas2p20410190486c9b48b4b2a4e9d8a4c2292@epcas2p2.samsung.com>
 <973576304.21794277202839.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 02:39:47 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] scsi: ufs: core: ufshcd_wl_poweroff() fails on
  runtime-suspended WLUN
- [Medium] scsi: ufs: core: missing is_sys_suspended set in
  ufshcd_wl_poweroff()
- [Medium] scsi: ufs: core: unnormalized return value in
  ufshcd_wl_poweroff()
--

commit adb43cfc03f9f1ca024eaa8ee5c87641ce38cdf8
Author: HOYOUNG SEO <hy50.seo@samsung.com>

scsi: ufs: core: Hold host_sem in ufshcd_wl_poweroff()

This commit acquires hba->host_sem in ufshcd_wl_poweroff() before calling
__ufshcd_wl_suspend() and propagates any error returned by
__ufshcd_wl_suspend().

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index d95b929b282da..688760a98d4b4 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -11586,9 +11586,15 @@ static int ufshcd_wl_poweroff(struct device *dev)
>  {
>  	struct scsi_device *sdev =3D to_scsi_device(dev);
>  	struct ufs_hba *hba =3D shost_priv(sdev->host);
> +	int ret;
> =20
> -	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
> -	return 0;
> +	/* Released by ufshcd_wl_resume() if hibernation is aborted. */
> +	down(&hba->host_sem);
> +	ret =3D __ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
> +	if (ret)
> +		up(&hba->host_sem);
> +
> +	return ret;
>  }
>  #endif

[Severity: High]
Can ufshcd_wl_poweroff() fail with -EBUSY when hba->ufs_device_wlun is
runtime-suspended?

During hibernation prepare, __ufshcd_suspend_prepare() leaves
ufs_device_wlun runtime-suspended whenever ufshcd_rpm_ok_for_spm(hba) is
true (for example, when hba->rpm_lvl and hba->spm_lvl are both
UFS_PM_LVL_3).  Unlike ufshcd_wl_suspend() (which checks
pm_runtime_suspended(dev)) and ufshcd_wl_shutdown() (which calls
ufshcd_rpm_get_sync(hba) first), ufshcd_wl_poweroff() calls
__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM) directly:

drivers/ufs/core/ufshcd.c:__ufshcd_wl_suspend() {
	...
	/* UFS device & link must be active before we enter in this function */
	if (!ufshcd_is_ufs_dev_active(hba) || !ufshcd_is_link_active(hba)) {
		/*  Wait err handler finish or trigger err recovery */
		if (!ufshcd_eh_in_progress(hba))
			ufshcd_force_error_recovery(hba);
		ret =3D -EBUSY;
		goto enable_scaling;
	}
	...
}

When the WLUN is runtime-suspended in UFS_SLEEP_PWR_MODE /
UIC_LINK_HIBERN8_STATE, __ufshcd_wl_suspend() triggers error recovery,
clears hba->clk_gating.is_suspended while runtime-suspended, and returns
-EBUSY.  Propagating ret from ufshcd_wl_poweroff() then causes
dpm_suspend_start(PMSG_HIBERNATE) to fail and abort hibernation.

In addition, if the WLUN is runtime-suspended at UFS_PM_LVL_5
(UFS_POWERDOWN_PWR_MODE and UIC_LINK_OFF_STATE), __ufshcd_wl_suspend()
takes a second ufshcd_hold(hba) reference and returns 0 via the
enable_scaling path without releasing it.  If hibernation is later
aborted, ufshcd_wl_resume() skips __ufshcd_wl_resume() because
pm_runtime_suspended(dev) is true, leaking that ufshcd_hold(hba)
reference.

[Severity: Medium]
Should ufshcd_wl_poweroff() also set hba->is_sys_suspended =3D true when
__ufshcd_wl_suspend() succeeds, matching ufshcd_wl_suspend()?

If hibernation is aborted after ufshcd_wl_poweroff() succeeds and the
subsequent .restore callback (ufshcd_wl_resume()) fails in
__ufshcd_wl_resume(), ufshcd_wl_resume() releases hba->host_sem so
ufshcd_err_handler() can recover the link:

drivers/ufs/core/ufshcd.c:ufshcd_err_handling_prepare() {
	...
	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||
	    hba->is_sys_suspended) {
		enum ufs_pm_op pm_op;
		...
		pm_op =3D hba->is_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
		ufshcd_vops_resume(hba, pm_op);
	}
	...
}

Because hba->is_sys_suspended was never set to true,
ufshcd_err_handling_prepare() sees both pm_runtime_status_suspended() and
hba->is_sys_suspended as false, skipping regulator, IRQ, and clock
restoration as well as ufshcd_vops_resume(hba, UFS_SYSTEM_PM) during error
recovery.

[Severity: Medium]
Can ufshcd_wl_poweroff() return a positive UIC status code and skip error
recovery when a power mode or link state transition fails?

In __ufshcd_wl_suspend(), the error handling blocks after
ufshcd_set_dev_pwr_mode() and ufshcd_link_state_transition() are guarded
by pm_op !=3D UFS_SHUTDOWN_PM:

drivers/ufs/core/ufshcd.c:__ufshcd_wl_suspend() {
	...
	ret =3D ufshcd_link_state_transition(hba, req_link_state, check_for_bkops);
	if (ret && pm_op !=3D UFS_SHUTDOWN_PM) {
		ufshcd_force_error_recovery(hba);
		ret =3D -EBUSY;
	}
	if (ret)
		goto set_dev_active;
	...
}

When ufshcd_uic_pwr_ctrl() fails with a non-PWR_LOCAL status in
ufshcd_get_upmcrs(hba), it skips scheduling eh_work because
hba->pm_op_in_progress is true and returns that positive UPMCRS status
code.  Because ufshcd_wl_poweroff() passes UFS_SHUTDOWN_PM,
__ufshcd_wl_suspend() neither calls ufshcd_force_error_recovery(hba) nor
normalizes ret to -EBUSY, so power_down() in kernel/power/hibernate.c
(which only rolls back on -EBUSY or -EAGAIN) does not roll back
hibernation cleanly and error recovery is not scheduled if hibernation
aborts.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1582071873.61794277=
203231.JavaMail.epsvc@epcpadp1new?part=3D2
