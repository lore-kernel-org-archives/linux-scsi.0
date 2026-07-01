Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBB435F16C
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 14:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782917595; cv=none; b=AM2y5cVprq6UdSeNzSVUCGxf+LritwQe9NoDHA0a9FB5p0N41pLcxAiELnVX/4B1tOzA55b0LMTuQzAKEbH5+L2iMxSWD6+1WNfim16xDyGx30B5oz+b5UpXI5h6i+QxbC5E04V54CZEYeH+qzfd6KTjA/bYAPWKVFwCyzwM16g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782917595; c=relaxed/simple;
	bh=Aqe2ZpP/MR3dlG4VJlI4UcxFIOo3t7ElVpxd8MUBUrk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=btsyXxnoMiaU9hGwgTjHPWuWAUKdWj5WbTTHongI9ObuC0QU732CDYLpXkhSOmaXMsrF+NlGjccH8UoUx0P4Bvs5ErcC/9c1mDZ0kAxjtZKvuAazSjwz9EaPvPyM0H1RBpl//IHXP7XZs/6yuHcRHWWR5KQpqxAePDNdT8IqJU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KWyouGa3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KWyouGa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D6A1F000E9;
	Wed,  1 Jul 2026 14:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782917593;
	bh=0WJox7dcjZMmuueJwo3iEGjNE3mJFZrEnZTR2YM2uQg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KWyouGa3z36flclOVilmLK8KWDI0+B0+P3YKSznfZgceWodIZyW+V7/XNjt1P04Jj
	 qp/C32A0alSeoINaI3tU36mlsGGMq+gKhq4goGpkRjpEC76z8/eswzlMzJEvNkGkVq
	 2LOugSXPXvIfT2ay6DGkM7aHYgNnH677zZO/XhZ/QjNVu1dvTyvwi4bnJe8DmiNC9E
	 DE+CkLAwglYNMOuohs54sMRwq0hLp6WkEWk5x6/agKbpgvQw41R6yxTN47h7t6WvH2
	 /1EcjZL15kTagTUq53/MfnnWsTXIw/+uoNq/rhKh33aFeTpq1Y5XLmK0Jz4s328I+3
	 tPQgDwPA5w+BA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: smartpqi: cancel pending workers before freeing
 controller
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fan Wu" <fanwu01@zju.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260701142757.8447-1-fanwu01@zju.edu.cn>
References: <20260701142757.8447-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 14:53:12 +0000
Message-Id: <20260701145313.31D6A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Canceling event_work during controller teardown introduces an unre=
coverable deadlock if the worker is blocked in pqi_wait_if_ctrl_blocked().

Pre-existing issues:
- [Critical] Concurrent execution of `pqi_fail_all_outstanding_requests` ca=
n lead to double completion of SCSI commands, causing a use-after-free and =
double-free vulnerability.
- [High] Incomplete teardown ordering allows `event_work` to re-arm `rescan=
_work` after it has been cancelled, leading to a Use-After-Free when `ctrl_=
info` is freed.
- [High] `pqi_suspend_or_freeze()` races with `ctrl_offline_work`, causing =
a double free of IRQ vectors.
--

commit 038afb1987e7de8ef32f28b104faf6296b50e850
Author: Fan Wu <fanwu01@zju.edu.cn>

scsi: smartpqi: cancel pending workers before freeing controller

The smartpqi driver does not cancel pending workers during controller
teardown, leading to use-after-free bugs when queued workers dereference a
freed controller. This patch drains the workers in pqi_free_ctrl_resources()
using disable_work_sync() and cancel_work_sync() in an order that prevents
arming chains from surviving the teardown.

> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
> index 5ec583dc2e7df..b16c50761f1ca 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -8897,7 +8897,16 @@ static void pqi_free_interrupts(struct pqi_ctrl_in=
fo *ctrl_info)
> =20
>  static void pqi_free_ctrl_resources(struct pqi_ctrl_info *ctrl_info)
>  {
> +	/*
> +	 * Disable, not cancel: the callback also frees IRQs, and
> +	 * pqi_take_ctrl_offline() can re-queue it after a cancel.
> +	 */
> +	disable_work_sync(&ctrl_info->ctrl_offline_work);

[Severity: Critical]
This is a pre-existing issue, but can concurrent execution of
pqi_fail_all_outstanding_requests() lead to double completion of SCSI
commands?

pqi_fail_all_outstanding_requests() iterates over the I/O request pool and
completes requests using a non-atomic check:

smartpqi_init.c:pqi_fail_all_outstanding_requests() {
    ...
    if (atomic_read(&io_request->refcount) =3D=3D 0)
        continue;
    ...
}

If a hardware error triggers ctrl_offline_work while a surprise removal
triggers pqi_remove_ctrl(), both threads can execute
pqi_fail_all_outstanding_requests() concurrently.

Both threads might see a non-zero refcount and invoke io_complete_callback
for the same request, leading to double frees and data corruption.

[Severity: High]
This is a pre-existing issue, but can pqi_suspend_or_freeze() race with
ctrl_offline_work and cause a double free of IRQ vectors?

pqi_suspend_or_freeze() calls pqi_free_irqs() without draining
ctrl_offline_work. If a hardware error queues ctrl_offline_work just before
suspend, the worker runs concurrently and also calls pqi_free_irqs().

Because pqi_free_irqs() lacks locking:

smartpqi_init.c:pqi_free_irqs() {
    for (i =3D 0; i < ctrl_info->num_msix_vectors_initialized; i++)
        free_irq(pci_irq_vector(ctrl_info->pci_dev, i),
                 &ctrl_info->queue_groups[i]);
    ...
}

Both threads can simultaneously read a positive num_msix_vectors_initialized
and call free_irq() on the same MSI-X vectors.

>  	pqi_free_interrupts(ctrl_info);
> +	/* IRQs queue event_work, which can queue OFA work. */
> +	cancel_work_sync(&ctrl_info->event_work);

[Severity: High]
Does this cancellation introduce a deadlock if the event worker is currently
blocked?

In pqi_remove_ctrl(), pqi_ctrl_block_requests() is called which sets
block_requests to true.=20

If event_work is executing, its callback pqi_event_worker() unconditionally
waits for block_requests to become false:

smartpqi_init.c:pqi_event_worker() {
    ...
    pqi_wait_if_ctrl_blocked(ctrl_info);
    ...
}

Since block_requests is never cleared during teardown, the worker blocks
forever. cancel_work_sync() will then wait forever for the worker to finish,
causing a deadlock.

[Severity: High]
This is a pre-existing issue, but does the teardown order allow event_work
to re-arm rescan_work after it was cancelled?

In pqi_remove_ctrl(), pqi_cancel_rescan_worker() cancels rescan_work before
pqi_free_ctrl_resources() drains event_work here.

However, event_work can arm rescan_work via
pqi_schedule_rescan_worker_with_delay():

smartpqi_init.c:pqi_schedule_rescan_worker_with_delay() {
    if (pqi_ctrl_offline(ctrl_info))
        return;
    schedule_delayed_work(&ctrl_info->rescan_work, delay);
}

If event_work checks pqi_ctrl_offline() and sees false, but is preempted
while pqi_remove_ctrl() sets the controller offline and cancels rescan_work,
the resumed event_work will queue rescan_work again.

This newly queued work is leaked and could cause a use-after-free when the
controller is freed.

> +	cancel_work_sync(&ctrl_info->ofa_memory_alloc_work);
> +	cancel_work_sync(&ctrl_info->ofa_quiesce_work);
>  	if (ctrl_info->queue_memory_base)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260701142757.8447=
-1-fanwu01@zju.edu.cn?part=3D1
