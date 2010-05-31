From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: aha1542 oops caused by new request_irq routines
Date: Mon, 31 May 2010 09:32:44 -0500
Message-ID: <1275316364.2823.22.camel@mulgrave.site>
References: <AANLkTilB661W9H9IPxn9TGBvv-omVnAh43r3XR5uM58m@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab0EaOcv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2010 10:32:51 -0400
In-Reply-To: <AANLkTilB661W9H9IPxn9TGBvv-omVnAh43r3XR5uM58m@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tedheadster <tedheadster@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>

On Mon, 2010-05-31 at 10:03 -0400, Tedheadster wrote:
> I'm reliably getting this oops:
> 
> Configuring Adaptec (SCSI-ID 6) at IO:334, IRQ 10, DMA priority 6
> BUG: sleeping function called from invalid context at mm/slub.c:1598
> in_atomic(): 0, irqs_disabled(): 1, pid: 4782, name: modprobe
> Pid: 4782, comm: modprobe Not tainted 2.6.30.10-105.2.23.RODATA.fc11.i586 #1
> Call Trace:
>  [<c0469e58>] ? request_threaded_irq+0x85/0x145
>  [<c0422ab7>] __might_sleep+0xc4/0xc9
>  [<c04a4322>] kmem_cache_alloc_notrace+0x29/0xb0
>  [<c0469e58>] request_threaded_irq+0x85/0x145
>  [<d086439c>] ? do_aha1542_intr_handle+0x0/0x2be [aha1542]
>  [<d08696aa>] aha1542_detect+0x631/0x76f [aha1542]
>  [<d0869841>] init_this_scsi_driver+0x59/0xc7 [aha1542]
>  [<d08697e8>] ? init_this_scsi_driver+0x0/0xc7 [aha1542]
>  [<c040114b>] do_one_initcall+0x51/0x13f
>  [<c0451111>] sys_init_module+0x8b/0x192
>  [<c0403535>] syscall_call+0x7/0xb
> scsi5 : Adaptec 1542

So this one's a bit tricky.  aha1542 uses a global spinlock to give it
thread safety and various other things.  In this case it's trying to use
the lock to hold off the interrupt until everything is set up.

Now that we're doing a GFP_KERNEL allocation in the interrupt handler
code you can't disable interrupts while calling request_irq since this
is an old card liable to spurious interrupts as it gets poked in setup.
I think a possible solution is this, since the mere act of installing an
interrupt handler shouldn't trigger the problem.

However, I thought the pattern of disabling interrupts and setting up
the handler and registers was a common one ... is there some way this is
supposed to work now that doesn't involve altering the drivers?

James

---

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 2a8cf13..0852079 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -1190,13 +1190,12 @@ fail:
 			DEB(aha1542_stat());
 
 			DEB(printk("aha1542_detect: enable interrupt channel %d\n", irq_level));
-			spin_lock_irqsave(&aha1542_lock, flags);
 			if (request_irq(irq_level, do_aha1542_intr_handle, 0,
 					"aha1542", shpnt)) {
 				printk(KERN_ERR "Unable to allocate IRQ for adaptec controller.\n");
-				spin_unlock_irqrestore(&aha1542_lock, flags);
 				goto unregister;
 			}
+			spin_lock_irqsave(&aha1542_lock, flags);
 			if (dma_chan != 0xFF) {
 				if (request_dma(dma_chan, "aha1542")) {
 					printk(KERN_ERR "Unable to allocate DMA channel for Adaptec.\n");


