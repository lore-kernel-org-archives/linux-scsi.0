From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/3] libata: add support for blk-iopoll
Date: Mon, 10 Aug 2009 19:22:35 +0200
Message-ID: <20090810172235.GL12579@kernel.dk>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com> <1249588685-4662-3-git-send-email-jens.axboe@oracle.com> <20090810111523.035e0d20@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:52085 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233AbZHJRWf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Aug 2009 13:22:35 -0400
Content-Disposition: inline
In-Reply-To: <20090810111523.035e0d20@bike.lwn.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, jeff@garzik.org

On Mon, Aug 10 2009, Jonathan Corbet wrote:
> Hey, Jens,
> 
> I'm a little slow in looking at this, hopefully it's not completely
> noise...
> 
> > @@ -2157,7 +2194,12 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
> >  
> >  		ap = host->ports[i];
> >  		if (ap) {
> > -			ahci_port_intr(ap);
> > +			if (!blk_iopoll_enabled)
> > +				ahci_port_intr(ap);
> > +			else if (blk_iopoll_sched_prep(&ap->iopoll)) {
> > +				ap_irq_disable(ap);
> > +				blk_iopoll_sched(&ap->iopoll);
> > +			}
> >  			VPRINTK("port %u\n", i);
> >  		} else {
> >  			VPRINTK("port %u (no irq)\n", i);
> 
> It seems to me that, if blk_iopoll_sched_prep() fails, the interrupt
> will be dropped on the floor; would you not need an explicit
> ahci_port_intr() call in that case too?  Unless I've misunderstood as
> usual...

If that happens, it is probably a spurious IRQ since it's already
scheduled to run (and hasn't yet). So it should be fine, in reality it
should not happen since the IRQ should have been acked and the iopoll
handler scheduled.

> Documenting the "zero means failure" nature of blk_iopoll_sched_prep()
> might also be a good idea; I predict confusion otherwise.

There's no real failure case, it zero just means "already scheduled".
But we do usually use 0 as the "normal" case, so good point anyway. I'll
change it.

-- 
Jens Axboe

