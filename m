From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: aha1542 oops caused by new request_irq routines
Date: Mon, 31 May 2010 18:43:34 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1005311829360.2933@localhost.localdomain>
References: <AANLkTilB661W9H9IPxn9TGBvv-omVnAh43r3XR5uM58m@mail.gmail.com> <1275316364.2823.22.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:56580 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab0EaQnp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2010 12:43:45 -0400
In-Reply-To: <1275316364.2823.22.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tedheadster <tedheadster@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 31 May 2010, James Bottomley wrote:

> On Mon, 2010-05-31 at 10:03 -0400, Tedheadster wrote:
> > I'm reliably getting this oops:
> > 
> > Configuring Adaptec (SCSI-ID 6) at IO:334, IRQ 10, DMA priority 6
> > BUG: sleeping function called from invalid context at mm/slub.c:1598
> > in_atomic(): 0, irqs_disabled(): 1, pid: 4782, name: modprobe
> > Pid: 4782, comm: modprobe Not tainted 2.6.30.10-105.2.23.RODATA.fc11.i586 #1
> > Call Trace:
> >  [<c0469e58>] ? request_threaded_irq+0x85/0x145
> >  [<c0422ab7>] __might_sleep+0xc4/0xc9
> >  [<c04a4322>] kmem_cache_alloc_notrace+0x29/0xb0
> >  [<c0469e58>] request_threaded_irq+0x85/0x145
> >  [<d086439c>] ? do_aha1542_intr_handle+0x0/0x2be [aha1542]
> >  [<d08696aa>] aha1542_detect+0x631/0x76f [aha1542]
> >  [<d0869841>] init_this_scsi_driver+0x59/0xc7 [aha1542]
> >  [<d08697e8>] ? init_this_scsi_driver+0x0/0xc7 [aha1542]
> >  [<c040114b>] do_one_initcall+0x51/0x13f
> >  [<c0451111>] sys_init_module+0x8b/0x192
> >  [<c0403535>] syscall_call+0x7/0xb
> > scsi5 : Adaptec 1542
> 
> So this one's a bit tricky.  aha1542 uses a global spinlock to give it
> thread safety and various other things.  In this case it's trying to use
> the lock to hold off the interrupt until everything is set up.
> 
> Now that we're doing a GFP_KERNEL allocation in the interrupt handler
> code you can't disable interrupts while calling request_irq since this
> is an old card liable to spurious interrupts as it gets poked in setup.
>
> I think a possible solution is this, since the mere act of installing an
> interrupt handler shouldn't trigger the problem.
> 
> However, I thought the pattern of disabling interrupts and setting up
> the handler and registers was a common one ... is there some way this is
> supposed to work now that doesn't involve altering the drivers?

Most drivers do the sane thing:

     Disable interrupts at the device level
     Install handler via request_irq()
     Setup stuff
     Enable interrupts at the device level

So no, there is no way this is supposed to work with drivers which
don't follow that simple scheme.

commit 0e43785c5 (irq: use GFP_KERNEL for action allocation in
request_irq()) changed that particular instance to GFP_KERNEL because
the request_irq code calls (and always did) code which cannot be
called in atomic contexts, e.g. the proc entry handling.

Thanks,

	tglx
