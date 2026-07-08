Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E917C3AE6E9
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 19:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783540782; cv=none; b=RKrgR2XCw6ugicqVsLwJWH6r0TJGrUZEm4jzC3mCT98i+blanBBWftBuTCTFWwdY4Gmh069mJoQQ65q2nB2FJtPQ8xzEzwa6Ia8JH2E7yOPJEl+cRmL+/2K0zLjl+Xuu92qnLmEuMiaMF+1UGaj4B16lMVV2BusQDhQAd3Rtj0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783540782; c=relaxed/simple;
	bh=JcrVd5UMEtFLk9YD6Jx7kCbkGRG1rydxjZF/bu/6l5I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mDafoXN2dvzrD6ItAMpXxLCRiVBh1vKc097/HMnB0hqkgAt6nujO1z9F8X7ypjcTLg0e0ry7hrniK4IY+ffrOlyhpReIrOEbdn7r3EcEGzgtOm7fskGnzEpEt5BDSCxQdUUXlVQn6NWwT97eaTLhiHgLjYRcUdfrw/Btsf7Ww8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frntnx1u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frntnx1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792641F000E9;
	Wed,  8 Jul 2026 19:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783540780;
	bh=27f7nklyYlhZ+hlUcwpGlyxTVaCypWfs9Ugksg5rfeg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=frntnx1uOq0n29MbwKxq9XNXVXixUTsCQapee5d7V9VFHefKd7IRHOodv7hAqtywM
	 NbA0WA3UKAZ8N98rVj6PFVqfU35vLCxW2LpcsktKefzE+ZrhuNrb+PKExUIyIHOCUP
	 mZbTF+HB3n96RJejTfO+UT5WJsi9IsH17skdwepphG/p8qSVyYlCvb29YU9P2FnDie
	 AI47wEqp2BMhLPktC3Mr2h71nrO5flG6WhDkNwByPgCoHIE3ntHd2NcMboJu63vW/5
	 DlzmgkrePe3cJ2Vo9s+MftOch60AhMcA6uHtwzhdN6wJkwP8q5i0RXAFsKnDoCGt9X
	 ExszqHYoOsMSQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/10] mpi3mr: Fix firmware event reference leak
 during cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260708183305.244485-8-ranjan.kumar@broadcom.com>
References: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
 <20260708183305.244485-8-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 19:59:39 +0000
Message-Id: <20260708195940.792641F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The lock-based TOCTOU fix is incomplete and fails to prevent a Use=
-After-Free because the worker thread modifies `current_event` locklessly.
- [High] A Use-After-Free write exists during event cleanup because `mpi3mr=
_dequeue_fwevt()` drops the event's reference before it is passed to `mpi3m=
r_cancel_work()`.
- [High] A race window during event dispatch allows `mpi3mr_cleanup_fwevt_l=
ist()` to return early and bypass cancelling an active firmware event.
--

--- Patch [7]: [PATCH v2 07/10] mpi3mr: Fix firmware event reference leak d=
uring cleanup ---
commit 594f8db6a0f63b3b0acbdd43108522c6a9ed9f0b
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix firmware event reference leak during cleanup

This commit addresses a firmware event reference leak in the cleanup routine
by properly releasing the reference before returning from the early exit and
normal cancel paths. It also adds a lock around the read of the current
event to prevent a race condition with the firmware event worker thread.

Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@=
broadcom.com?part=3D7

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index df7365d19b44a..273512ab25ba0 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -379,6 +379,7 @@ static void mpi3mr_cancel_work(struct mpi3mr_fwevt *f=
wevt)
>  void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc)
>  {
>  	struct mpi3mr_fwevt *fwevt =3D NULL;
> +	unsigned long flags;
> =20
>  	if ((list_empty(&mrioc->fwevt_list) && !mrioc->current_event) ||
>  	    !mrioc->fwevt_worker_thread)
>  		return;

[Severity: High]
This is a pre-existing issue, but does this early exit condition allow a ra=
ce
where we bypass cancelling an active firmware event?

During event dispatch, the event is removed from the list and assigned to
current_event sequentially without atomicity:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_fwevt_bh() {
    ...
    mpi3mr_fwevt_del_from_list(mrioc, fwevt);
    mrioc->current_event =3D fwevt;
    ...
}

This creates a race window where the list is empty, but current_event is
still NULL. If mpi3mr_cleanup_fwevt_list() executes during this window,
could its lockless check evaluate to true and return early without waiting
for the work to complete?

> =20
>  	while ((fwevt =3D mpi3mr_dequeue_fwevt(mrioc)))
>  		mpi3mr_cancel_work(fwevt);

[Severity: High]
This is a pre-existing issue, but does passing this pointer to
mpi3mr_cancel_work() result in a use-after-free?

The mpi3mr_dequeue_fwevt() function drops the list reference before returni=
ng
the pointer:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_dequeue_fwevt() {
    ...
    list_del_init(&fwevt->list);
    mpi3mr_fwevt_put(fwevt);
    ...
}

When we pass this unreferenced pointer to mpi3mr_cancel_work(), it calls
cancel_work_sync(&fwevt->work). If the worker thread finishes executing
concurrently and drops its remaining references, the structure could be fre=
ed.
Would cancel_work_sync() then write to freed memory when it calls
clear_work_data() on the embedded work structure?

> =20
> -	if (mrioc->current_event) {
> -		fwevt =3D mrioc->current_event;
> +	/*
> +	 * Safely read current_event under lock to prevent TOCTOU race
> +	 * with the firmware event worker thread.
> +	 */
> +	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
> +	fwevt =3D mrioc->current_event;
> +	if (fwevt)
> +		mpi3mr_fwevt_get(fwevt);
> +	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);

[Severity: High]
This is a pre-existing issue, but does the lock-based fix still leave
a use-after-free window because the worker thread modifies current_event
locklessly?

The read-side acquires the lock here, but the worker thread locklessly clea=
rs
current_event and drops the final reference:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_fwevt_bh() {
    ...
    mpi3mr_fwevt_put(fwevt);
    mrioc->current_event =3D NULL;
    ...
}

If mpi3mr_cleanup_fwevt_list() reads a non-NULL current_event, but gets
preempted before calling mpi3mr_fwevt_get(), could the worker thread
concurrently clear the pointer and free the memory? When the cleanup routine
resumes, it would call mpi3mr_fwevt_get() on a freed structure.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708183305.2444=
85-1-ranjan.kumar@broadcom.com?part=3D7
