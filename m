From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 2/3] libata: add support for blk-iopoll
Date: Mon, 10 Aug 2009 11:15:23 -0600
Message-ID: <20090810111523.035e0d20@bike.lwn.net>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com>
	<1249588685-4662-3-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932367AbZHJRSF@vger.kernel.org>
In-Reply-To: <1249588685-4662-3-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, jeff@garzik.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Hey, Jens,

I'm a little slow in looking at this, hopefully it's not completely
noise...

> @@ -2157,7 +2194,12 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
>  
>  		ap = host->ports[i];
>  		if (ap) {
> -			ahci_port_intr(ap);
> +			if (!blk_iopoll_enabled)
> +				ahci_port_intr(ap);
> +			else if (blk_iopoll_sched_prep(&ap->iopoll)) {
> +				ap_irq_disable(ap);
> +				blk_iopoll_sched(&ap->iopoll);
> +			}
>  			VPRINTK("port %u\n", i);
>  		} else {
>  			VPRINTK("port %u (no irq)\n", i);

It seems to me that, if blk_iopoll_sched_prep() fails, the interrupt
will be dropped on the floor; would you not need an explicit
ahci_port_intr() call in that case too?  Unless I've misunderstood as
usual...

Documenting the "zero means failure" nature of blk_iopoll_sched_prep()
might also be a good idea; I predict confusion otherwise.

jon
