Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473FD42D753
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785929925; cv=none; b=lFASk+xLU7T93Wk9JGzGW7xE5Dl1Vwo4bq2kRouM2RhlrcvwIJuimJ29kbGw3EvuxmDGvwAuB3kneDZGrGA9TECYu/GGRIkfYOGcFaEW1mQl+1pSvyzECB7Xx/uJ3uZMZAtTKrqyUM3OwHlb16yO/g1RO++tYn08wWGqvgQDGeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785929925; c=relaxed/simple;
	bh=uXgMYaw63rA1DDFtuCeG31RiNZsum9PZNgbQxvq6sTA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J6ZBAQHq+CAfINMOO9pLHRTWLd3GHsGsJmQFJShOoHx/BStY4KRUET51Xzd1QhPDw0qzwvjrALGwDV9Du+ZBp1RtuHyVLHVx6iLeQDLIILqBoBh0+6iTzLh+riiMAxM6aqwQufXDEJQQSoCM6DAy6i8bSbN4SmA6veyE9u19TT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MhxCBRtx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MhxCBRtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E441F000E9;
	Wed,  5 Aug 2026 11:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785929924;
	bh=v48gNeN1iikNDc5VJlaxtdIq7oQkq1oU6VqNBMrT0n0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MhxCBRtxc0bWp+IKdmRgUlkZEe/QOWAMdncQsYfo5SogtYBLDw50t1HJAt+2p82OP
	 SIHKVt/Zi+ybz2lstFF3Q07Z9hutNji1tWhPDmB0b9Asui/baWbenWYzeswq72GXVu
	 SQl5x429oeVMErGNH+E+M0cMFlV/S1QxNCQxxCyunOwBbzKkqPC3q8qhh8dZHdFv25
	 e7BSV96yXZvqPeaWFCmq+xXPrYzEP4J8H2Z4Rn+vcfnu5TF7WYVAvwTg6HrMmqWT/9
	 gWotrJDepoj11y+5Hst16fExHqrHt5fMpKxt1u1bq4T2c0eK0oX/N2ESjCpmOIfMkp
	 suLo9sWHOeTdA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 07/10] mpi3mr: Fix firmware event reference leak
 during cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260805110634.346670-8-ranjan.kumar@broadcom.com>
References: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
 <20260805110634.346670-8-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 05 Aug 2026 11:38:43 +0000
Message-Id: <20260805113844.02E441F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Race condition / TOCTOU when accessing fwevt_worker_thread can cau=
se a NULL pointer dereference.
- [High] Incomplete deadlock fix in SAS transport path allows ABBA deadlock=
 with SCSI mid-layer.
- [Medium] Memory leak of firmware event when workqueue is not available.
--

--- Patch [7]: [PATCH v4 07/10] mpi3mr: Fix firmware event reference leak d=
uring cleanup ---
commit 02873552fdbb7ea8056e6479b78735dc33631a59
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix firmware event reference leak during cleanup

This patch fixes a reference leak during firmware event cleanup when an eve=
nt
is currently executing or pending at the SCSI mid-layer. It also resolves
multiple concurrency and deadlock issues in the firmware event handling pat=
hs.

Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@=
broadcom.com?part=3D7
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar=
@broadcom.com?part=3D7
Closes: https://sashiko.dev/#/patchset/20260724102505.115136-1-ranjan.kumar=
@broadcom.com?part=3D7

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 23a6a5e3df5f4..a34ea7e056900 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -282,32 +282,6 @@ void mpi3mr_hdb_trigger_data_event(struct mpi3mr_ioc=
 *mrioc,
>  	mpi3mr_fwevt_add_to_list(mrioc, fwevt);
>  }

[Severity: High]
This is a pre-existing issue, but can the lockless check in
mpi3mr_fwevt_add_to_list() cause a race condition leading to a NULL pointer
dereference?

If mpi3mr_fwevt_add_to_list() checks mrioc->fwevt_worker_thread locklessly:

	if (!mrioc->fwevt_worker_thread)
		return;

And concurrently, during driver shutdown or unload, the workqueue pointer is
set to NULL while holding fwevt_lock:

	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
	wq =3D mrioc->fwevt_worker_thread;
	mrioc->fwevt_worker_thread =3D NULL;
	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);

Could mpi3mr_fwevt_add_to_list() pass the lockless check, then block on
fwevt_lock, and after acquiring the lock, unconditionally pass the now-NULL
mrioc->fwevt_worker_thread to queue_work()?

[Severity: Medium]
This is also a pre-existing issue, but does the early return in
mpi3mr_fwevt_add_to_list() leak the firmware event?

	if (!mrioc->fwevt_worker_thread)
		return;

Since mpi3mr_alloc_fwevt() initializes the reference count to 1, if the wor=
ker
thread is already gone and we take this early return, do we need to call
mpi3mr_fwevt_put() to prevent leaking the allocated firmware event?

> -/**
> - * mpi3mr_fwevt_del_from_list - Delete firmware event from list
> - * @mrioc: Adapter instance reference
> - * @fwevt: Firmware event reference

[ ... ]

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index 240f67a8e2e3b..b309cfdf66873 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c

[ ... ]

> @@ -1457,8 +1458,10 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add=
(struct mpi3mr_ioc *mrioc,
>  	}
>  	rphy->identify =3D mr_sas_port->remote_identify;
> =20
> +	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
>  	if (mrioc->current_event)
>  		mrioc->current_event->pending_at_sml =3D 1;
> +	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
> =20
>  	if ((sas_rphy_add(rphy))) {
>  		ioc_err(mrioc, "failure at %s:%d/%s()!\n",

[Severity: High]
This is a pre-existing issue, but does this code allow an ABBA deadlock with
the SCSI mid-layer?

Unlike mpi3mr_report_tgtdev_to_host(), this function does not check
mrioc->reset_in_progress or mrioc->stop_drv_processing before setting
pending_at_sml =3D 1 and calling sas_rphy_add().

If a controller reset initiates, it waits for the event worker via
cancel_work_sync(). If the worker thread is here and calls sas_rphy_add(),
the SML commands might receive SCSI_MLQUEUE_HOST_BUSY from
mpi3mr_queuecommand() because the reset is active.

Since SML will retry infinitely while the reset is underway, does this cause
the event worker thread to deadlock against the thread waiting for the reset
to complete?

[ ... ]

> @@ -1578,8 +1585,10 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_i=
oc *mrioc, u64 sas_address,
> =20
>  	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> =20
> +	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
>  	if (mrioc->current_event)
>  		mrioc->current_event->pending_at_sml =3D 1;
> +	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
> =20
>  	list_for_each_entry_safe(mr_sas_phy, next_phy,
>  	    &mr_sas_port->phy_list, port_siblings) {

[Severity: High]
This is a pre-existing issue, but this appears to be susceptible to the same
deadlock with the SCSI mid-layer.

If a reset is in progress, setting pending_at_sml =3D 1 without a bailout
check can cause the worker thread to hang if the SML commands retry
infinitely due to the active reset. Should this have the same bailout check
as mpi3mr_remove_tgtdev_from_host()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260805110634.3466=
70-1-ranjan.kumar@broadcom.com?part=3D7
