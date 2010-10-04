From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] scsi: Remove QUEUE_FLAG_REENTER from SCSI code
Date: Mon, 4 Oct 2010 15:47:00 +0200
Message-ID: <20101004134700.GA12628@schmichrtp.mainz.de.ibm.com>
References: <Pine.LNX.4.64.1008281908150.13508@ask.diku.dk>
 <20100902105326.GA4097@schmichrtp.mainz.de.ibm.com>
 <4C7FA91B.60607@suse.de>
 <20100902142835.GA4992@schmichrtp.mainz.de.ibm.com>
 <20100902150158.GA10556@schmichrtp.mainz.de.ibm.com>
 <1285574293.2888.107.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:36824 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0JDNrT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2010 09:47:19 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate3.uk.ibm.com (8.13.1/8.13.1) with ESMTP id o94Dl4sj008374
	for <linux-scsi@vger.kernel.org>; Mon, 4 Oct 2010 13:47:04 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o94Dl4hZ3387410
	for <linux-scsi@vger.kernel.org>; Mon, 4 Oct 2010 14:47:04 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o94Dl3Wc021826
	for <linux-scsi@vger.kernel.org>; Mon, 4 Oct 2010 14:47:04 +0100
Content-Disposition: inline
In-Reply-To: <1285574293.2888.107.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, Julia Lawall <julia@diku.dk>, linux-scsi@vger.kernel.org, joe@perches.com, James Smart <James.Smart@Emulex.Com>

On Mon, Sep 27, 2010 at 04:58:13PM +0900, James Bottomley wrote:
> On Thu, 2010-09-02 at 17:01 +0200, Christof Schmitt wrote:
> > scsi_run_queue and fc_bsg_goose_queue try to call __blk_run_queue with
> > the flag QUEUE_FLAG_REENTER set. Since __blk_run_queue already sets
> > the flag internally, this part can be removed from the SCSI and FC
> > transport code. With this change, the function fc_bsg_goose_queue can
> > simply be replaced with a conditional call to blk_run_queue.
> 
> OK, so Hannes made me look at this again:
> 
> Actually, there is a problem here ... and the original code doesn't pick
> it up.  We could still be recursing unacceptably because the fc login
> interrupt can come in while we're running the block queue, but if it's
> not the rport queue (which it likely won't be) we won't see the
> recursion.
> 
> The actual solution is not to run the queue directly from the interrupt
> at all (and dink with the REENTER) flags, but simply to use the
> kblockd_schedule_work() API to cause the queue to be run in workqueue
> context.  Redo the patch like that and I'll apply it.
> 
> James

I spent some more time to understand the requirements of the flag
setting:

As far as i see, the FC rport bsg queue does not have the recursion
problem. fc_remote_port_add is the only caller of fc_bsg_goose_queue
and fc_remote_port_add has to be called from thread context. So,
fc_bsg_goose_queue can be reduced to a simple call to blk_run_queue.

scsi_run_queue has the recursion problem: It calls blk_run_queue that
can call the request_fn that in SCSI can recurse back to
scsi_queue_insert and scsi_run_queue.  The problem in commit
04846f25920d4b05d6040c531cc601049260db52 looks like a long list of
starved devices and each starved device entry adds to the stack.

So, the solution would be to:
1) Replace fc_bsg_goose_queue with a direkt call to blk_run_queue
2) As mentioned above, in scsi_run_queue defer the call to the block
   workqueue.

Is it worth adding a block layer function to keep the workqueue usage
in blk-core? Or simply open code the required steps in scsi_run_queue,
e.g.

queue_flag_set(QUEUE_FLAG_PLUGGED, q);
kblockd_schedule_work(q, &q->unplug_work);
?

Christof

> 
> 
> > Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> > ---
> >  drivers/scsi/scsi_lib.c          |   15 +--------------
> >  drivers/scsi/scsi_transport_fc.c |   34 ++--------------------------------
> >  2 files changed, 3 insertions(+), 46 deletions(-)
> > 
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -411,8 +411,6 @@ static void scsi_run_queue(struct reques
> >  	list_splice_init(&shost->starved_list, &starved_list);
> >  
> >  	while (!list_empty(&starved_list)) {
> > -		int flagset;
> > -
> >  		/*
> >  		 * As long as shost is accepting commands and we have
> >  		 * starved queues, call blk_run_queue. scsi_request_fn
> > @@ -436,18 +434,7 @@ static void scsi_run_queue(struct reques
> >  		}
> >  
> >  		spin_unlock(shost->host_lock);
> > -
> > -		spin_lock(sdev->request_queue->queue_lock);
> > -		flagset = test_bit(QUEUE_FLAG_REENTER, &q->queue_flags) &&
> > -				!test_bit(QUEUE_FLAG_REENTER,
> > -					&sdev->request_queue->queue_flags);
> > -		if (flagset)
> > -			queue_flag_set(QUEUE_FLAG_REENTER, sdev->request_queue);
> > -		__blk_run_queue(sdev->request_queue);
> > -		if (flagset)
> > -			queue_flag_clear(QUEUE_FLAG_REENTER, sdev->request_queue);
> > -		spin_unlock(sdev->request_queue->queue_lock);
> > -
> > +		blk_run_queue(sdev->request_queue);
> >  		spin_lock(shost->host_lock);
> >  	}
> >  	/* put any unprocessed entries back */
> > --- a/drivers/scsi/scsi_transport_fc.c
> > +++ b/drivers/scsi/scsi_transport_fc.c
> > @@ -50,7 +50,6 @@ static int fc_vport_setup(struct Scsi_Ho
> >  static int fc_bsg_hostadd(struct Scsi_Host *, struct fc_host_attrs *);
> >  static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
> >  static void fc_bsg_remove(struct request_queue *);
> > -static void fc_bsg_goose_queue(struct fc_rport *);
> >  
> >  /*
> >   * Redefine so that we can have same named attributes in the
> > @@ -2737,7 +2736,8 @@ fc_remote_port_add(struct Scsi_Host *sho
> >  					spin_unlock_irqrestore(shost->host_lock,
> >  							flags);
> >  
> > -				fc_bsg_goose_queue(rport);
> > +				if (rport->rqst_q)
> > +					blk_run_queue(rport->rqst_q);
> >  
> >  				return rport;
> >  			}
> > @@ -3752,36 +3752,6 @@ fail_host_msg:
> >  	return FC_DISPATCH_UNLOCKED;
> >  }
> >  
> > -
> > -/*
> > - * fc_bsg_goose_queue - restart rport queue in case it was stopped
> > - * @rport:	rport to be restarted
> > - */
> > -static void
> > -fc_bsg_goose_queue(struct fc_rport *rport)
> > -{
> > -	int flagset;
> > -	unsigned long flags;
> > -
> > -	if (!rport->rqst_q)
> > -		return;
> > -
> > -	get_device(&rport->dev);
> > -
> > -	spin_lock_irqsave(rport->rqst_q->queue_lock, flags);
> > -	flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
> > -		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
> > -	if (flagset)
> > -		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
> > -	__blk_run_queue(rport->rqst_q);
> > -	if (flagset)
> > -		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
> > -	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
> > -
> > -	put_device(&rport->dev);
> > -}
> > -
> > -
> >  /**
> >   * fc_bsg_rport_dispatch - process rport bsg requests and dispatch to LLDD
> >   * @q:		rport request queue
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
