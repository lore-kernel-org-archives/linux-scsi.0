Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571091;
	b=Rn4IJ0hp52p68wjhepfTkidlyuQpLm2WC5CO4V0rYLQrDOt5slsnkHfArSs0DcRyNck4
	 bQv9xf3j8WIHCLEovw1EWYvqzJeOPrKK4qXP4+Lg5YsIrcbEcNsfi/QjIizNhHOv102b3
	 DzFnEImNhtXTvUUc9bc4Ydq6iT8vEZIW+rqm2gttSoXlvkslDlKyRFIgMJfmpzCKpba8E
	 uvPTd2RN8t5tyU21Tt45zTG7l7r3Tq7yBDtNldeOLmOU7WMjJCD8lZ6vVGBzfTN10nm3K
	 ttgCdae6Ruz6xoXDFE6AXZQQ8sC6Qryypo1GSNToywXtUEA0xV6/iRG+/GU/rNjho2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571091;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rbpy3UhlaUNE/1RZ4YGOGImTE7uf0g+8X3vILR14TKo=;
	b=nV7kQIZHWfa+3kONCswHiDp/cI11ErTHYsDHnKqu/9EFlBYqOszSz2PYYnYsk1i9ssgC
	 LQQcIexDxfXiIKJXj20eufaPLlNQtWMVgF4BlRGTdaxqZXe8gYYQtOls6v5DDfqA5bl8H
	 9GGAIzc5xXN/0mD1+XVDNzqUf2Oesj9+ytZ7rlZeeIBX+7VoGnzLJqLCq1C3Im8QBwLKp
	 o+4GZ/ldxrlPHARqSHnXDUpGMyoC6tmQnWVzlhdzM7OwG0zmrkJdpfHJeL8+fmp2pF/0g
	 DKudWpTXdsxq0g1tfOouCGx+QMKO4fbIZ26CMK0gBPvjgHwXMSWx4+PZw1bUzQ0QZMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RLOtjtqL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E9F606A88D
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 11:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RLOtjtqL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E841F000C4;
	Fri, 13 Nov 2026 11:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571090;
	bh=rbpy3UhlaUNE/1RZ4YGOGImTE7uf0g+8X3vILR14TKo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=RLOtjtqLWDL6nDVjPk8x1kR//0qGWLm2dPyXYmfgn5n+Ku1GGhj5weUWINRaATGVw
	 BAFBJ7YSF4Uw7/l4lU/0/21SuSpbg87vdlCXrhutps+09q/N1x26kM05PCKKxFuEMi
	 SCmYb8mK4akvLpLN0w8xar6xoc4n/poVH1Ty1hxYeRVbvEfPn4blYycYRM5WqD5JKS
	 ZY3RNlVVWWS+E7BouABW5Ijg+dyufzfKI91iYv3uDLeCF2ZfdCeZiD9jc/OyU9rMxE
	 BHhNqKPBvoHRqhxEPlyGZgzn7who+uxdh2+7wtIUkLNc8tXPsIhy81AYL3HMkgMbHe
	 Tzo/1lsJT78hw==
Message-ID: <sashiko-outbox-212746@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Do not recover the link
 concurrently with a PM callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261113111202.3551341-3-stanleyjhu@google.com>
References: <20261113111202.3551341-1-stanleyjhu@google.com>
 <20261113111202.3551341-3-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 11:58:10 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] scsi: ufs: core: unrecovered non-fatal SSU failure in
  __ufshcd_wl_resume()
- [Medium] scsi: ufs: core: stale error flags after
  ufshcd_link_recovery() cause double reset
--

commit 1891702caa856d9953dfbbc2c8ef55704458a505
Author: Brian Kao <powenkao@google.com>

scsi: ufs: core: Do not recover the link concurrently with a PM callback

This commit removes the pm_op_in_progress link recovery path from
ufshcd_err_handler() and adds link recovery in __ufshcd_wl_resume() when
START STOP UNIT fails while error handling is scheduled for a fatal error.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0f5365bd90f04..825906b643faf 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7074,23 +7074,6 @@ static void ufshcd_err_handler(struct work_struct =
*work)
>  		 hba->saved_uic_err, hba->force_reset,
>  		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
> =20
> -	if (hba->ufs_device_wlun) {
> -		/*
> -		 * Use ufshcd_rpm_get_noresume() here to safely perform link
> -		 * recovery even if an error occurs during runtime suspend or
> -		 * runtime resume. This avoids potential deadlocks that could
> -		 * happen if we tried to resume the device while a PM operation
> -		 * is already in progress.
> -		 */
> -		ufshcd_rpm_get_noresume(hba);
> -		if (hba->pm_op_in_progress) {
> -			ufshcd_link_recovery(hba);
> -			ufshcd_rpm_put(hba);
> -			return;
> -		}
> -		ufshcd_rpm_put(hba);
> -	}
> -
>  	down(&hba->host_sem);
>  	spin_lock_irqsave(&hba->host->host_lock, flags);
>  	if (ufshcd_err_handling_should_stop(hba)) {
> @@ -10638,6 +10621,8 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba=
, enum ufs_pm_op pm_op)
> =20
>  	if (!ufshcd_is_ufs_dev_active(hba)) {
>  		ret =3D ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
> +		if (ret && hba->ufshcd_state =3D=3D UFSHCD_STATE_EH_SCHEDULED_FATAL)
> +			ret =3D ufshcd_link_recovery(hba);
>  		if (ret)
>  			goto set_old_link_state;

[Severity: High]
What happens if START STOP UNIT fails without timing out while
hba->ufshcd_state is UFSHCD_STATE_EH_SCHEDULED_NON_FATAL?

UIC errors not matched by ufshcd_is_saved_err_fatal(), such as
UFSHCD_UIC_DL_TCx_REPLAY_ERROR or UFSHCD_UIC_DL_NAC_RECEIVED_ERROR, set
hba->ufshcd_state to UFSHCD_STATE_EH_SCHEDULED_NON_FATAL and queue
ufshcd_err_handler(), which now blocks in ufshcd_err_handling_prepare() ->
ufshcd_rpm_get_sync() waiting for __ufshcd_wl_resume().  Under
UFSHCD_STATE_EH_SCHEDULED_NON_FATAL, ufshcd_queuecommand() still dispatches
START STOP UNIT, and if it completes with an OCS error such as
OCS_PEER_COMM_FAILURE (mapped to DID_ERROR), fenced is false and
ufshcd_is_hba_active(hba) remains true, so neither ufshcd_set_dev_pwr_mode()
nor __ufshcd_wl_resume() calls ufshcd_link_recovery().  __ufshcd_wl_resume()
then returns -EIO, and when ufshcd_err_handler() wakes in rpm_resume() and
retries sdev_runtime_resume(), blk_post_runtime_resume() calls
blk_clear_pm_only() a second time without an intervening suspend,
underflowing q->pm_only and hanging the queue.

Also, if ufshcd_link_recovery() fails here, jumping to set_old_link_state
calls ufshcd_link_state_transition(hba, old_link_state, 0) on a failed
controller whose link state was reset to UIC_LINK_OFF_STATE, rather than
jumping to vendor_suspend as the hibern8-exit recovery path does.

[Severity: Medium]
Does calling ufshcd_link_recovery() here leave hba->force_reset,
hba->saved_err, and hba->saved_uic_err set, causing ufshcd_err_handler() to
reset the device and host controller a second time?

When ufshcd_set_dev_pwr_mode() submits START STOP UNIT while
hba->ufshcd_state is UFSHCD_STATE_EH_SCHEDULED_FATAL, ufshcd_queuecommand()
sets hba->force_reset =3D true and fails the command with DID_BAD_TARGET:

drivers/ufs/core/ufshcd.c:ufshcd_queuecommand() {
    ...
	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
		if (hba->pm_op_in_progress) {
			hba->force_reset =3D true;
			set_host_byte(cmd, DID_BAD_TARGET);
			scsi_done(cmd);
			goto out;
		}
    ...
}

Unlike ufshcd_reset_and_restore(), ufshcd_link_recovery() does not clear
hba->saved_err, hba->saved_uic_err, or hba->force_reset.  Once
__ufshcd_wl_resume() finishes and unblocks ufshcd_err_handling_prepare(),
ufshcd_err_handling_should_stop() sees those flags still set and returns
false, so ufshcd_err_handler() proceeds to do_reset and runs
ufshcd_reset_and_restore() again.  In addition, if a non-fatal UIC error
interrupt fires during ufshcd_link_recovery() after interrupts are
re-enabled, ufshcd_schedule_eh_work() sees the stale hba->force_reset and
fatal error bits and sets hba->ufshcd_state back to
UFSHCD_STATE_EH_SCHEDULED_FATAL, preventing ufshcd_process_probe_result()
from transitioning hba->ufshcd_state to UFSHCD_STATE_OPERATIONAL.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113111202.3551=
341-1-stanleyjhu@google.com?part=3D2
