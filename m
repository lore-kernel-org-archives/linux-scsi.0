From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue reached
Date: Sun, 2 Mar 2003 08:57:28 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030302085728.A11407@infradead.org>
References: <20030228111924.A32018@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030228111924.A32018@beaverton.ibm.com>; from patmans@us.ibm.com on Fri, Feb 28, 2003 at 11:19:24AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

The patch looks fine to me in principle, a few nitpicks are below.
(btw, any chance you could post a current scsi midlayer multipathing
patch?  I see there is BK activity.. :))

> +++ edited/drivers/scsi/hosts.c	Thu Feb 27 16:21:09 2003
> @@ -383,6 +383,7 @@
>  	scsi_assign_lock(shost, &shost->default_lock);
>  	INIT_LIST_HEAD(&shost->my_devices);
>  	INIT_LIST_HEAD(&shost->eh_cmd_q);
> +	INIT_LIST_HEAD(&shost->pending_queue);

This isn't consistant, either ew use _q in all new code or _queue.
(peronally I prefer the latter)

> +void scsi_host_send_pending (struct Scsi_Host *shost)

codingstyle issue:  no space between function name and opening brace.

> +{
> +	struct scsi_cmnd *scmd;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	while (!shost->host_self_blocked
> +	       && !list_empty(&shost->pending_queue)) {

Linux codingstyle sais the && should be before the line break.

