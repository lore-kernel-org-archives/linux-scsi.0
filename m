From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue reached
Date: Sun, 2 Mar 2003 10:15:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030302101530.A21052@beaverton.ibm.com>
References: <20030228111924.A32018@beaverton.ibm.com> <20030302085728.A11407@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030302085728.A11407@infradead.org>; from hch@infradead.org on Sun, Mar 02, 2003 at 08:57:28AM +0000
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Sun, Mar 02, 2003 at 08:57:28AM +0000, Christoph Hellwig wrote:
> The patch looks fine to me in principle, a few nitpicks are below.
> (btw, any chance you could post a current scsi midlayer multipathing
> patch?  I see there is BK activity.. :))

The last multi-path patch is available here:

http://www-124.ibm.com/storageio/multipath/scsi-multipath/releases/2.5.59-mpath-1.patch.gz

Did you want to see something newer?

Mike was talking about pulling it forward to 2.5.latest, maybe he has
started.

> > +++ edited/drivers/scsi/hosts.c	Thu Feb 27 16:21:09 2003
> > @@ -383,6 +383,7 @@
> >  	scsi_assign_lock(shost, &shost->default_lock);
> >  	INIT_LIST_HEAD(&shost->my_devices);
> >  	INIT_LIST_HEAD(&shost->eh_cmd_q);
> > +	INIT_LIST_HEAD(&shost->pending_queue);
> 
> This isn't consistant, either ew use _q in all new code or _queue.
> (peronally I prefer the latter)

Yes, I also prefer _queue, maybe I should make it pending_cmd, then the
name is not an issue, and the type is not embeded in the name (the _q
implies that it is a queue or list_head)?

> > +void scsi_host_send_pending (struct Scsi_Host *shost)
> 
> codingstyle issue:  no space between function name and opening brace.
> 
> > +{
> > +	struct scsi_cmnd *scmd;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(shost->host_lock, flags);
> > +	while (!shost->host_self_blocked
> > +	       && !list_empty(&shost->pending_queue)) {
> 
> Linux codingstyle sais the && should be before the line break.

OK thanks.

-- Patrick Mansfield
