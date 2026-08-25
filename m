Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C723431E6
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 16:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787674792; cv=none; b=A3TTxoGioU6rGcJmoYcxKdl1uTV2G3nsNbMC11NcHWaPbUGU+rZm2GitKACh22ZjQzWWvoSb+OC1PhtI4izKMwC3WxqDR8q0ohJjpV3IR3DHBwnd34y/HDmvUnrTDQMKwdLD/nIFi5SwBfJwslUsg5DUYVcTMaRaiu4EhhI/5/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787674792; c=relaxed/simple;
	bh=omO34x7byIMOzy2pnsqyNY7766/9m2lokt+FOm6wQZk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mGr6G7ttEgDBA3LdZHh4kCzB2yksttK5cKY1SXPwccM9rsm/VdL8EqG/q2l7oRgpBXidhJ297pNanHQH13nctXB56IJuuy/jPqBb1rtADqcVZLzCpnjibmGJPie0KwMZeuIrxN3erp2V15+T1W7C3CPbXUhjxM/RbeMKdsNk3sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XvMNfQkL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XvMNfQkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9DB1F000E9;
	Tue, 25 Aug 2026 16:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787674790;
	bh=WdFm/WKM+fm8MQqHIs3ZkzqiulWZGx/9k8cf4fTI3Ok=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XvMNfQkL+tE7scqLaHHcAJQ31vvoOvjWk8dmrUknmt+HdkJTZzJCCuGMXEVBOjPqL
	 QPhJL+oRd5kCptEq9ol0iE4FgXvZ0ueCRLY9JeEU9+YqItI39EiiR5gwinCGXZk9rl
	 W5BFG3ZHf1j0LAyl/0LPmHP2m7EAG5a5sS22zzC/hmcYrlXLMT7LAFSH30CF4iKxPz
	 b1dn//kGUJN5A044AnX6bZecBDwbr0J1qNODCXeZOxhiEt51wfw8rpKvnMiIJ0tTVR
	 IoOUYYXtImUT8VAfK3OJtiEh7aLMnNvvilzOECYVJIf25MYy6+r7QfrPCkgXoXXe2m
	 3+JDeZwqDssnQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 16/17] mpi3mr: Fix use-after-free of the firmware
 event workqueue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-17-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-17-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 16:19:49 +0000
Message-Id: <20260825161949.DC9DB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-after-free in `mpi3mr_cancel_work` when canceling concurrently=
 executing firmware event work.
- [High] Data race leading to Use-After-Free of `mrioc->current_event` duri=
ng firmware event cleanup.
--

commit c5c6dc4f18099cddf01a3785308a8b8fac21872d
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix use-after-free of the firmware event workqueue
   =20
The enqueue path reads the workqueue pointer before taking the event
lock, while the remove path clears that pointer and destroys the
workqueue while holding it. The enqueue can therefore reach
queue_work() after the workqueue is gone.
   =20
Move the check inside the lock.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 543e9b8e3fc37..e97e343b14fa5 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -233,10 +233,11 @@ static void mpi3mr_fwevt_add_to_list(struct mpi3mr_=
ioc *mrioc,
>  {
>  	unsigned long flags;
> =20
> -	if (!mrioc->fwevt_worker_thread)
> -		return;
> -
>  	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
> +	if (!mrioc->fwevt_worker_thread) {
> +		spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
> +		return;
> +	}
>  	/* get fwevt reference count while adding it to fwevt_list */
>  	mpi3mr_fwevt_get(fwevt);
>  	INIT_LIST_HEAD(&fwevt->list);

[Severity: High]
This isn't a bug introduced by this patch, but looking at how firmware even=
ts
are managed and cleaned up, is there a use-after-free risk during cancellat=
ion?

When mpi3mr_cleanup_fwevt_list() flushes pending events, it removes the eve=
nt
from the list and immediately drops its list reference:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_dequeue_fwevt() {
    ...
    list_del_init(&fwevt->list);
    /*
     * Put fwevt reference count after
     * removing it from fwevt_list
     */
    mpi3mr_fwevt_put(fwevt);
    ...
}

It then calls mpi3mr_cancel_work(fwevt), which invokes
cancel_work_sync(&fwevt->work). If the work is already executing but hasn't=
 yet
removed itself from the list in mpi3mr_fwevt_bh(), cancel_work_sync() will
block waiting for the worker thread.

When the worker thread completes, it drops all remaining references and fre=
es
the event memory:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_fwevt_worker() {
    ...
    mpi3mr_fwevt_bh(fwevt->mrioc, fwevt);
    /*
     * Put fwevt reference count after
     * dequeuing it from worker queue
     */
    mpi3mr_fwevt_put(fwevt);
}

Does this leave cancel_work_sync() operating on a freed work_struct?


[Severity: High]
This is a pre-existing issue, but there appears to be a data race when acce=
ssing
mrioc->current_event in the cleanup path.

In mpi3mr_cleanup_fwevt_list(), after draining the list, the current_event
pointer is accessed without holding a lock or taking a reference:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_cleanup_fwevt_list() {
    ...
    if (mrioc->current_event) {
        fwevt =3D mrioc->current_event;
        ...
        if (current_work() =3D=3D &fwevt->work || fwevt->pending_at_sml) {
    ...
}

Concurrently, if the worker thread is finishing execution in mpi3mr_fwevt_b=
h(),
it drops the reference and sets the pointer to NULL:

    mpi3mr_fwevt_put(fwevt);
    mrioc->current_event =3D NULL;

If the cleanup thread reads mrioc->current_event before it is set to NULL, =
and
the worker thread completes and drops its final reference (freeing the even=
t),
could the cleanup thread dereference freed memory when evaluating
fwevt->pending_at_sml or calling mpi3mr_cancel_work(fwevt)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D16
