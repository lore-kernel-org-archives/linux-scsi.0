Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83C43C3F45
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785452689; cv=none; b=UY0PEC3L5IhMSpyB1BTdtgIwaKkDdmgu6W6E7ulm3OCis9jEugzwjsmnEd+OM0f4zyYnkIVH5UuR3i0GFXenie5WXEN3wZjSqp4M1DxELtinPSAsfAY7+MUlZZJjQx+mpoRmt7b1iqwuFDgvxvPm4ZuTrKSq+vWWpNejNc4R/Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785452689; c=relaxed/simple;
	bh=w+j05vDgoX44vTF3pXDk1wOJl/c81WXD2vAY0oGpI2s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GKS2xfBzlCg2x5m1XlcDdrvfWtHVq/wn5CSLyGSWm8TBXPecDbg55hwd8SX7j9KjJBNTeK6uMHZKfSdTsiiqywtVp81Ejgs98uKLdkqY2LXKm7FEDBjvM+IxC1khXDiQv/usLbjIaV3G4w3sBhq2+2D5k5sfdud3a+o2NL/37y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AoG+vDjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AoG+vDjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F391F000E9;
	Thu, 30 Jul 2026 23:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785452687;
	bh=i6BYfiXCJK8iSchUmPT2RlL7H/x0c9bTjyPwP9PYKIw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AoG+vDjWqb5wNrP4soMi3ATuAmljawlnRAHXWAgLqK6tRoBofBP1FtaYyZehwYfi0
	 YKrP3O/60OjE3Ti+dZNGizhmGFJxO2xRvz9a8+jECpUq1HHT1LMnk7vM2nkhXR69T3
	 nRbhBAwxSh+S2QS9J85M7hXi3PP4hj3WkyLZOkMPHHoQ7CoMAisLe/WWYdswKb54yZ
	 Eg7etfVALx3cU9Txm8BW5BGGbJYQvOZEC82C30zWMSiftJYL1Tgq4WUlLxlVQOtpNa
	 guyPhwSf/aliEBSv9cJ2LUx15MtauMU0sA5GE3hye8bVgDDPrYdXrXz9pqs0e8gl1J
	 y84vnHaudAW1w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/57] scsi: aacraid: Prepare for enabling lock
 context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <e6fae05fcb62f58bbab103354b0e0fe5138bb30d.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <e6fae05fcb62f58bbab103354b0e0fe5138bb30d.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:04:46 +0000
Message-Id: <20260730230447.37F391F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Data race on `fibptr->flags` in `aac_hba_send` and `aac_fib_se=
nd` can lead to lost flags set by the interrupt handler.
- [High] Permanent leak of `dev->management_fib_count` on early error paths=
 in `aac_fib_send` and `aac_hba_send`.
- [High] Dangling pointer in `dev->sync_fib_list` when `wait_for_completion=
_interruptible` is interrupted by a signal.
- [High] The `_aac_reset_adapter()` function can sleep while holding a spin=
lock (`host->host_lock`) and with interrupts disabled.
--

--- Patch [8]: [PATCH v3 08/57] scsi: aacraid: Prepare for enabling lock co=
ntext analysis ---
commit b24c9703822591fc27fa76398a50df3f082577ac
Author: Bart Van Assche <bvanassche@acm.org>

scsi: aacraid: Prepare for enabling lock context analysis

Document the aac_send_reset_adapter() locking requirements with
__must_hold(). Annotate functions that perform conditional locking with
__no_context_analysis.

> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsu=
p.c
> index c4485629f7923..fb4d78233c6d7 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -475,6 +475,7 @@ int aac_queue_get(struct aac_dev * dev, u32 * index, =
u32 qid, struct hw_fib * hw
>  int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
>  		int priority, int wait, int reply, fib_callback callback,
>  		void *callback_data)
> +	__context_unsafe(conditional locking)
>  {

[Severity: High]
This isn't a bug introduced by this patch, but does an interrupted wait lea=
ve a
dangling pointer in dev->sync_fib_list?

In aac_fib_send(), if dev->sync_mode is enabled and wait is non-zero, fibptr
is appended to dev->sync_fib_list. The code then waits:

    if (wait_for_completion_interruptible(&fibptr->event_wait)) {
        fibptr->flags &=3D ~FIB_CONTEXT_FLAG_WAIT;
        return -EFAULT;
    }

If interrupted by a signal, it returns -EFAULT without removing fibptr from
dev->sync_fib_list. The caller will free the FIB, adding it to the free list
while it remains on sync_fib_list. Will this lead to a use-after-free when
dev->sync_fib_list is later processed?

[ ... ]

> @@ -698,6 +699,7 @@ int aac_fib_send(u16 command, struct fib *fibptr, uns=
igned long size,
> =20
>  int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
>  		void *callback_data)
> +	__context_unsafe(conditional locking)
>  {

[Severity: High]
This isn't a bug introduced by this patch, but is it possible that
dev->management_fib_count leaks on early error paths?

In aac_hba_send(), when wait is 1, dev->management_fib_count is incremented.
If aac_adapter_deliver() succeeds, but the PCI device goes offline:

    if (wait) {
        spin_unlock_irqrestore(&fibptr->event_lock, flags);

        if (unlikely(aac_pci_offline(dev)))
            return -EFAULT;

The function returns -EFAULT directly without decrementing the management c=
ount.
Because fibptr->done is not set to 2, the interrupt handler will also not
decrement it. A similar leak appears to occur in aac_fib_send().

Will this eventually exhaust the AAC_NUM_MGT_FIB pool and cause future
management commands to fail with -EBUSY?

[Severity: Critical]
This isn't a bug introduced by this patch, but does the lockless update of
fibptr->flags risk losing flags set by the interrupt handler?

In aac_hba_send(), after the command is submitted via aac_adapter_deliver():

    if (wait) {
        ...
        fibptr->flags |=3D FIB_CONTEXT_FLAG_WAIT;
        if (wait_for_completion_interruptible(&fibptr->event_wait))
            fibptr->done =3D 2;
        fibptr->flags &=3D ~(FIB_CONTEXT_FLAG_WAIT);

These bitwise operations are not atomic. Concurrently, the adapter can
complete the command and trigger the interrupt handler aac_intr_normal(),
which locklessly sets flags:

    if (isFastResponse)
        fib->flags |=3D FIB_CONTEXT_FLAG_FASTRESP;

Can the read-modify-write in aac_hba_send() overwrite and lose the
FIB_CONTEXT_FLAG_FASTRESP flag, causing the completion path to misinterpret
the response?

[ ... ]

> @@ -1466,6 +1468,7 @@ static void aac_schedule_bus_scan(struct aac_dev *a=
ac)
>  }
> =20
>  static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_=
type)
> +	__context_unsafe(conditional locking)
>  {

[Severity: High]
This isn't a bug introduced by this patch, but does _aac_reset_adapter() sl=
eep
while holding a spinlock?

aac_reset_adapter() acquires host->host_lock (a spinlock) and calls
_aac_reset_adapter(). Inside _aac_reset_adapter(), the lock is conditionally
dropped (setting jafo =3D 1) only if aac->thread is not NULL and the current
thread is not the command thread.

If aac->thread is NULL, or if called by the command thread itself, jafo
remains 0 and the spinlock is never unlocked. The function then proceeds to
call blocking functions like schedule() and ssleep():

    if (is_response_expected || fib->flags & FIB_CONTEXT_FLAG_WAIT) {
        ...
        schedule();
        retval =3D 0;
    }

    /* Give some extra time for ioctls to complete. */
    if (retval =3D=3D 0)
        ssleep(2);

Could this lead to a deadlock since the spinlock is held with interrupts
disabled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D8
