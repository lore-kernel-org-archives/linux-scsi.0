Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3682638A72F
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 11:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890949; cv=none; b=Q4agdCS6wPn+LBzXtskkQ3WuHaVq84IUvlHN1NogEZbcrnTi1B4e+B0hmlzXifWM83RvRLaOmbIarG9Jlf8bzOzGzmCwUb/88x04DzwWTpuXtPMNBDlEVue1xLjZgc+bXb7gi4xrYRIG643B3Y+XxkcM/G7z0Fltg/1THWnwhOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890949; c=relaxed/simple;
	bh=s2RjNEDlIiPfTfmvw4wP3n8xhm/3Ieq2te1BLZSGi5A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Q70JyHWhhbjSJIOfvTaFBlDDTruO9MrVHAUWR6rpNbker02y1cN2lm5hNa/RRFCYjBvo9Wrxsr9nDQF5uLI2dSyYNSM7awj3Kja51AEJ1hvWsHoknSGQLjgbuYa5Wdhg7wb3JlZXZlm/rgwp1Md0GhjiL5r0sI/MfBGpRUDs8OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DQLSaiJU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DQLSaiJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E344D1F01830;
	Fri, 24 Jul 2026 11:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784890946;
	bh=kiB6AgXjx/LVQ6+Aus3D4mUJzUk7fywQ4QUEBVTy/k8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DQLSaiJUHqhsXYTubT0EJdYg63UsTC/M3qmfdUoEUL+GuWpty/af7T6PKBj5bQBWo
	 OM34DJ18SWMx16S9EPC0l9TBYWi7aRdZ0bdjAaof0ju2viyRJA3bd39esTWj13Wd1X
	 Mgl1r6B7LOFEKKUQIQP2OdtyHhGq3RSKYfvpjWeeiVdUMfxMZUbhrt/0I6Sk63IsjF
	 cnmRbflpsb23kG7p52roZYaSd/rfybplqmX7vw8vpaiKBk/F+Rh6geSX2nD+zjOMHv
	 o1HdqDz+cR15zx8STtEqkZmFFCZziM4zya94a+DM/frd00XeF5X80TMP5yiCwJkBQ3
	 43so7ZdiX7K3w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/10] mpi3mr: Fix firmware event reference leak
 during cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724102505.115136-8-ranjan.kumar@broadcom.com>
References: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
 <20260724102505.115136-8-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:02:25 +0000
Message-Id: <20260724110225.E344D1F01830@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A Time-of-Check to Time-of-Use (TOCTOU) race on `fwevt->pending_at=
_sml` leads to an ABBA deadlock between the SCSI Error Handler (EH) thread =
and the firmware event worker thread.
- [High] Bypassing `cancel_work_sync()` during suspend leads to a fatal ker=
nel crash when the uncancelled worker thread accesses unmapped PCI memory.
--

--- Patch [7]: [PATCH v3 07/10] mpi3mr: Fix firmware event reference leak d=
uring cleanup ---
commit a2fc36963f11ee80eb780471cf03043bba280bae
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix firmware event reference leak during cleanup

During firmware event cleanup, when an event is currently executing or
pending at the SCSI mid-layer, the driver sets a discard flag and exits
the cleanup routine early. This early exit skips the normal cancel path,
resulting in the firmware event reference count not being decremented,
leading to a reference leak.

Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@=
broadcom.com?part=3D7
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar=
@broadcom.com?part=3D7

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 39624fae9131f..545570d490fac 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
[ ... ]
> @@ -379,16 +354,39 @@ static void mpi3mr_cancel_work(struct mpi3mr_fwevt =
*fwevt)
>  void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc)
>  {
[ ... ]
> +	if (fwevt) {
>  		/*
>  		 * Don't call cancel_work_sync() API for the
>  		 * fwevt work if the controller reset is
>  		 * get called as part of processing the
>  		 * same fwevt work (or) when worker thread is
>  		 * waiting for device add/remove APIs to complete.
>  		 * Otherwise we will see deadlock.
>  		 */
>  		if (current_work() =3D=3D &fwevt->work || fwevt->pending_at_sml) {
>  			fwevt->discard =3D 1;
> +			mpi3mr_fwevt_put(fwevt);
>  			return;
>  		}

[Severity: High]
This isn't a bug introduced by this patch, but could this lockless read of
pending_at_sml lead to an ABBA deadlock?

If the EH thread reads fwevt->pending_at_sml locklessly and sees false, it
proceeds to call cancel_work_sync() and blocks on the worker thread.
Concurrently, the worker thread sets mrioc->current_event->pending_at_sml =
=3D 1
locklessly in mpi3mr_report_tgtdev_to_host() and calls into the SCSI mid-la=
yer:

	mrioc->current_event->pending_at_sml =3D 1;
	scsi_scan_target(&mrioc->shost->shost_gendev, ...);

If the SCSI queue is stopped by the EH thread, these SCSI commands will blo=
ck
indefinitely, causing the worker thread to wait for the EH thread, while the
EH thread waits for the worker thread.

[Severity: High]
This is a pre-existing issue and was not introduced by the patch under revi=
ew,
but does skipping cancel_work_sync() here risk a fatal crash during suspend?

During system suspend, mpi3mr_suspend() calls mpi3mr_cleanup_fwevt_list(). =
If
this returns early without waiting for the worker thread, mpi3mr_suspend()
proceeds to mpi3mr_cleanup_resources(), unmapping PCI memory.

When the worker thread later unblocks, it returns to mpi3mr_fwevt_bh(), ski=
ps
the stop_drv_processing check (having passed it earlier), and attempts to
access unmapped PCI memory:

evt_ack:
	if (fwevt->send_ack)
		mpi3mr_process_event_ack(mrioc, fwevt->event_id,
		    fwevt->evt_ctx);

Could this cause a kernel panic when mpi3mr_process_event_ack() tries to use
the now-unmapped mrioc->sysif_regs?

> =20
>  		mpi3mr_cancel_work(fwevt);
>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724102505.1151=
36-1-ranjan.kumar@broadcom.com?part=3D7
