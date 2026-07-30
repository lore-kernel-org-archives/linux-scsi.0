Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691CF25F7B9
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453351; cv=none; b=CVWoxblodB21iIU/+FfCeurmeopb2ENCFbNYqQA4729DqinjXYWAFO7WbFr4CENZjthGkFBzhRQuhfCtHD51tgNSwa5foVlvqWVKGwz+Lm/T4SnaxozM8oS1UPB2Pd25ddCyD4C9OHBL71mm3dqNZWfE0MWeTw6kx6yrXVCzkjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453351; c=relaxed/simple;
	bh=P/ysoE4nqcA6/LIQPlDaUHxKUfbzH8tG5OfP61UErfw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M6Mnpcps5vdIC8gjGlmMkeFZcy2fX7Y7yFkjs+1vLwPcu2XuFM74fM/KL4uqJoC3eAbb9Ho1xkszIeiWQqUgv3YI1mf0Kz0g5P1SYj0yIt6X6Y991XMoH0A+EFJrYxr00M9DSGsGu2L97OpII2ygsLaxP2X4xNArCTy/hPrZwHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WHyGLw+8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WHyGLw+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78421F000E9;
	Thu, 30 Jul 2026 23:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453350;
	bh=05/gaYdLpfzoJy2rNHwoN0MVC9bxg2+EmnXW3wua0t4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WHyGLw+8B6HIrELwDS2Xb3Zjw18dc42QzKy5BLVxHTe/jxAuqQaeC1/XPz8TuhD7D
	 F/c82Glx4i57GtxzK/WlcHKf8Y9DgXdxx++bYV/nBUmfkjSlJhPmu1amCGbflRwgEY
	 R6DLMMkQxoLIpymGICQAqKgmC9+7xJ1RZOdvlU/gp5FfmHY7/mRkrZ6STnmT1OLGHK
	 +uHrnfxZNG7GEWWtmTCPgvIlVGCw/t+kibJ47UipSf5Wl3aarng/7F9Mx9PxSM5O81
	 1ss2JMnIZB/838EDOSkPJtvuv2BnAnw+CuEVXmQEgu0aopSvm0o4iUnCqhKIHfbIgG
	 UDkM7LCF6RtTw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 32/57] scsi: ips: Prepare for enabling lock context
 analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <af0effbc214b28654685796b43f2783236c52c14.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <af0effbc214b28654685796b43f2783236c52c14.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:15:49 +0000
Message-Id: <20260730231549.E78421F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Calling scsi_done() before unmapping DMA causes a potential use-af=
ter-free of the scsi_cmnd structure.
- [High] Incorrect waitlist traversal causes premature loop termination and=
 a potential use-after-free on `struct scsi_cmnd` if command submission fai=
ls.
- [High] Memory allocations use GFP_KERNEL in atomic contexts (while holdin=
g a spinlock or in a hardirq handler), which can sleep and cause a kernel p=
anic.
- [High] Process-context functions acquire the SCSI host_lock using spin_lo=
ck() instead of spin_lock_irqsave(), leaving them vulnerable to deadlocks f=
rom the interrupt handler.
- [High] ips_wait() busy-waits with udelay(1000) for up to 60 seconds with =
hardware interrupts disabled, leading to a hard lockup.
- [High] Using BUG_ON() for scsi_dma_map() failures causes an unnecessary k=
ernel panic.
--

--- Patch [32]: [PATCH v3 32/57] scsi: ips: Prepare for enabling lock conte=
xt analysis ---
commit 3f51682bbdf047060a964b17e4ca87b13e0de2ad
Author: Bart Van Assche <bvanassche@acm.org>
scsi: ips: Prepare for enabling lock context analysis

This commit annotates ips_next() with __context_unsafe to indicate it
performs conditional locking. This prepares the driver for context lock
analysis.

> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index 41ed73966a48c..5ef70f058ecd6 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -2506,6 +2506,7 @@ ips_hainit(ips_ha_t * ha)
>  /***********************************************************************=
*****/
>  static void
>  ips_next(ips_ha_t * ha, int intr)
> +	__context_unsafe(conditional locking)
>  {
>  	ips_scb_t *scb;

[Severity: High]
This isn't a bug introduced by this patch, but does calling scsi_done()
before unmapping the DMA cause a potential use-after-free?

In ips_next() and ips_done(), the command is completed before the SCB is
freed:

drivers/scsi/ips.c:ips_next() {
    ...
    case IPS_FAILURE:
        if (scb->scsi_cmd) {
            scb->scsi_cmd->result =3D DID_ERROR << 16;
            scsi_done(scb->scsi_cmd);
        }

        ips_freescb(ha, scb);
        break;
    ...
}

Because scsi_done() hands ownership of the command to the block layer,
the block layer might asynchronously complete and free or recycle the
struct scsi_cmnd. Could ips_freescb() then dereference a freed pointer
when it subsequently calls scsi_dma_unmap(scb->scsi_cmd)?


[Severity: High]
This is a pre-existing issue, but does the waitlist traversal in
ips_next() prematurely terminate the loop and risk a use-after-free?

The list linkage is destroyed by explicitly clearing host_scribble:

drivers/scsi/ips.c:ips_next() {
    ...
    SC =3D ips_removeq_wait(&ha->scb_waitlist, q);
    ...
    SC->host_scribble =3D NULL;
    ...
}

If command submission fails or completes synchronously, scsi_done() is
invoked on the command, passing ownership of the command (aliased by p)
to the block layer. Could the loop then execute the following iteration
step using potentially freed memory?

drivers/scsi/ips.c:ips_next() {
    ...
    p =3D (struct scsi_cmnd *) p->host_scribble;
    ...
}

Furthermore, since host_scribble was set to NULL, would p become NULL
and terminate the dispatch loop early, starving any remaining queued
commands?


[Severity: High]
This isn't a bug introduced by this patch, but do the memory allocations
use GFP_KERNEL in atomic contexts?

When ips_next() processes passthru commands, it holds the host_lock
spinlock. If called from ips_queue_lck via IPS_INTR_IORL, it runs with
interrupts disabled and the lock is not dropped.

During this path, functions like ips_alloc_passthru_buffer() and
ips_flash_copperhead() perform allocations using GFP_KERNEL:

drivers/scsi/ips.c:ips_alloc_passthru_buffer() {
    ...
    bigger_buf =3D dma_alloc_coherent(&ha->pcidev->dev, length,
                                    &dma_busaddr, GFP_KERNEL);
    ...
}

Since GFP_KERNEL allows blocking, can this sleep in an atomic context
and trigger a kernel panic?


[Severity: High]
This is a pre-existing issue, but is there a deadlock vulnerability
between process-context functions and the interrupt handler?

The hardware interrupt handler do_ipsintr() runs in hardirq context and
acquires the lock using spin_lock(). Meanwhile, process-context
functions like ips_eh_abort() also acquire it without disabling local
interrupts:

drivers/scsi/ips.c:ips_eh_abort() {
    ...
    spin_lock(host->host_lock);
    ...
}

If an interrupt fires on the same CPU while the scsi_eh thread holds the
lock, will the interrupt handler attempt to acquire the lock and cause
an AB-BA self-deadlock?


[Severity: High]
This isn't a bug introduced by this patch, but does ips_wait()
busy-wait for too long with hardware interrupts disabled?

In ips_eh_reset(), hardware interrupts are completely disabled on the
local CPU:

drivers/scsi/ips.c:ips_eh_reset() {
    ...
    spin_lock_irq(SC->device->host->host_lock);
    rc =3D __ips_eh_reset(SC);
    ...
}

This triggers a flush that eventually falls back to a polling loop in
ips_wait(), which calls udelay(1000) up to 60,000 times:

drivers/scsi/ips.c:ips_wait() {
    ...
    /* This looks like a very evil loop, but it only does this during start=
-up */
    udelay(1000);
    time--;
    ...
}

Could looping for up to 60 seconds with interrupts disabled violate
latency requirements and trigger the kernel's hard lockup watchdog?


[Severity: High]
This is a pre-existing issue, but does using BUG_ON() for DMA mapping
failures cause an unnecessary kernel panic?

In ips_next(), a mapping failure triggers a system panic:

drivers/scsi/ips.c:ips_next() {
    ...
    scb->sg_count =3D scsi_dma_map(SC);
    BUG_ON(scb->sg_count < 0);
    ...
}

Since scsi_dma_map() can return negative values like -ENOMEM when IOMMU
mappings or DMA resources are exhausted, would it be better to gracefully
fail the command or propagate the error rather than intentionally crashing
the system?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D32
