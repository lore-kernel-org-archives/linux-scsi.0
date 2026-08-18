Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5226D2D061C
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787077945; cv=none; b=XPNLOYCE/4KClN9/tSgeo4Zv/cPPgj7EHZbvUnZf/bGIpIFjD/ff4XpQ96wVmivd48KtIS1yHk5ivaQj2jlzocbd1F8ystDTV4nWnshbVSXPjfUHjtE/xEeI7a2zKLzZf+elMtoa7jbw7M6yWQ1/zzWkF2/Dhacu+qzRpXF4buY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787077945; c=relaxed/simple;
	bh=VuBShjbtD13WQcyzEvDoBeVXP6+AKZgsIKXMOLnt5wg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jYJoCZ428duvsq+EVPFfZeIBEbNLaFkUVW8U+h4OyumjuvtJBx9zSoJ1n02e3LrucGtV5z2aSFjrjx/9ssJMMK1WWvoL0/R18/j9ArZK+3RAQeOXk68INQ8XmaxsLvjq+onLTtDhqMwYuBsi4ucQmCCMtmn+oVIQ0n/647FgqXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMGasaw1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMGasaw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90ED1F000E9;
	Tue, 18 Aug 2026 18:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787077943;
	bh=+RXJ7AXvsfh3cPyqUuY9BXl/+wx5CCTsOnrv2HF0fck=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mMGasaw15DtWmuAl8urg1nGJul+N9PfW3x01kg9AN2yRv/78FeAFh8/N+BWBZ75uj
	 ZEqmp2bSQh1acnN++/V67lqJJ6hUc4huu+Pbn97/nSxp+rATcnGUWjBuMg9EgPwEBN
	 nPubESxgoji830jrcbOTfU5dyCk5KQgNI+zRvHplouwoK9gGWCRaSJEUglcharnege
	 FhCI1oVoZ/StzNg1VP5aLKYsSXi8g8efPdcIJLD3wQPum9agWrM2WOao4ENA+ctsHD
	 7NldaEiHIkEuWiCuX+wLbGxJkIbLMKSxSlcdYwSZh7mBLFV+DFhG4KB6T0+9n2Vw+w
	 29UDt6hkTepIg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 17/17] mpi3mr: Fix NULL pointer dereference on PCI error
 recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-18-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-18-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:32:23 +0000
Message-Id: <20260818183223.B90ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] Calling `mpi3mr_cleanup_fwevt_list` during PCI error recovery caus=
es a deadlock due to a race with the fwevt worker thread calling SML functi=
ons.
- [High] Setting `stop_drv_processing =3D 1` during PCI channel freeze brea=
ks transparent I/O recovery by permanently failing commands with `DID_NO_CO=
NNECT`.

Pre-existing issues:
- [High] Unprotected and unreferenced access to `mrioc->current_event` and =
`fwevt` in `mpi3mr_cleanup_fwevt_list` leads to a Use-After-Free, exacerbat=
ed by the patch executing it asynchronously during PCI error recovery.
- [High] Skipping `cancel_work_sync` for events blocked in the SCSI mid-lay=
er (SML) leaves the worker thread running, allowing access to unmapped regi=
sters on suspend.
- [High] Missing memory barriers between `stop_drv_processing` and `mrioc->=
current_event` allows the worker thread to bypass the abort check and acces=
s unmapped memory.
--

--- Patch [17]: [PATCH 17/17] mpi3mr: Fix NULL pointer dereference on PCI e=
rror recovery ---
commit 21853a66ae88d53ee80d24101e9ce79158e66a4e
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix NULL pointer dereference on PCI error recovery

On a frozen PCI channel the driver unmaps the register window and frees
the interrupts, but leaves the firmware event workqueue running. An
event handler that is already in flight can still reach the register
window after it has been unmapped. Stop event processing and drain the
queue first, and start it again when the channel resumes.

> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -5972,6 +5972,8 @@ mpi3mr_pcierr_error_detected(struct pci_dev *pdev, =
pci_channel_state_t state)
>  			return PCI_ERS_RESULT_DISCONNECT;
>  		}
> =20
> +		mrioc->stop_drv_processing =3D 1;

[Severity: High]
Does setting stop_drv_processing to 1 here break transparent I/O recovery?

If mrioc->stop_drv_processing evaluates to true in mpi3mr_qcmd(), it
preempts the block_on_pci_err check. Instead of returning
SCSI_MLQUEUE_HOST_BUSY to allow the midlayer to safely pause and retry
I/Os once the PCI channel recovers, it causes all incoming queued
read/write commands to immediately fail with DID_NO_CONNECT:

mpi3mr_qcmd() {
    ...
    if (mrioc->stop_drv_processing && !(mpi3mr_allow_scmd_to_fw(scmd))) {
        scmd->result =3D DID_NO_CONNECT << 16;
        scsi_done(scmd);
        goto out;
    }
    ...
}

Could this lead to immediate I/O errors and potential filesystem corruption
instead of transparently pausing I/O?

[Severity: High]
This is a pre-existing issue, but does the lack of explicit memory barriers
here allow a race condition?

The synchronization between writing stop_drv_processing here and reading
mrioc->current_event in mpi3mr_cleanup_fwevt_list() appears to be lockless.
Concurrently, mpi3mr_fwevt_bh() writes mrioc->current_event and reads
stop_drv_processing.

Without smp_mb(), could the CPU reorder these operations such that
mpi3mr_pcierr_error_detected() reads a NULL current_event while
mpi3mr_fwevt_bh() sees stop_drv_processing as 0? This would let the worker
continue and access PCI registers after they have been unmapped.

> +		mpi3mr_cleanup_fwevt_list(mrioc);

[Severity: High]
Can calling mpi3mr_cleanup_fwevt_list() during PCI error recovery cause a
deadlock?

During PCI error recovery, mrioc->block_on_pci_err is true. This cleanup
function reads fwevt->pending_at_sml locklessly. If the worker hasn't yet
set pending_at_sml to 1, the cleanup function sees 0 and calls
cancel_work_sync(), which blocks the PCI error handler.

The worker thread could then set pending_at_sml to 1 and call SCSI mid-layer
functions like scsi_remove_target(), issuing I/O commands like
SYNCHRONIZE_CACHE. Because mpi3mr_allow_scmd_to_fw() permits these bypass
commands, mpi3mr_qcmd() will hit the block_on_pci_err check and return
SCSI_MLQUEUE_HOST_BUSY.

Since the SCSI mid-layer retries indefinitely, the worker thread remains
permanently blocked, and cancel_work_sync() deadlocks the PCI error handler.

[Severity: High]
This is a pre-existing issue, but does the asynchronous call to
mpi3mr_cleanup_fwevt_list() introduced here exacerbate a use-after-free
risk?

In mpi3mr_cleanup_fwevt_list(), mrioc->current_event is read locklessly
into a local fwevt pointer. Concurrently, the firmware event worker thread
might finish its execution, drop all references via mpi3mr_fwevt_put(), and
free the mpi3mr_fwevt structure.

If mpi3mr_cleanup_fwevt_list() accesses fwevt->pending_at_sml or fwevt->work
after the last reference is dropped but before mrioc->current_event is
set to NULL, does this trigger a use-after-free?

[Severity: High]
This isn't a bug introduced by this patch, but does skipping
cancel_work_sync() in mpi3mr_cleanup_fwevt_list() when
fwevt->pending_at_sml is set leave the worker thread running?

If the event is pending at the SCSI mid-layer, the code sets
fwevt->discard =3D 1 and returns early without stopping the worker thread:

mpi3mr_cleanup_fwevt_list() {
    ...
    if (current_work() =3D=3D &fwevt->work || fwevt->pending_at_sml) {
        fwevt->discard =3D 1;
        return;
    }
    ...
}

During operations like system suspend where pci_err_recovery is false, the
caller unmaps mrioc->sysif_regs. Once unblocked, the worker thread continues
to mpi3mr_process_event_ack() and mpi3mr_admin_request_post().

Since pci_err_recovery is false, it blindly dereferences the unmapped
mrioc->sysif_regs to post the request, causing a kernel panic.

>  		scsi_block_requests(mrioc->shost);
>  		mpi3mr_stop_watchdog(mrioc);
>  		mpi3mr_cleanup_resources(mrioc);

[ ... ]

> @@ -6069,6 +6071,7 @@ static void mpi3mr_pcierr_resume(struct pci_dev *pd=
ev)
> =20
>  	if (mrioc->block_on_pci_err) {
>  		mrioc->block_on_pci_err =3D false;
> +		mrioc->stop_drv_processing =3D 0;
>  		scsi_unblock_requests(shost);
>  		mpi3mr_start_watchdog(mrioc);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D17
