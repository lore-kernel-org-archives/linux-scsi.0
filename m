From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Deadlock in usb-storage error handling
Date: Thu, 20 Mar 2014 15:48:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1403201518130.863-100000@iolanthe.rowland.org>
References: <1395339778.2244.41.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42499 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755381AbaCTTsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Mar 2014 15:48:09 -0400
In-Reply-To: <1395339778.2244.41.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andreas Reis <andreas.reis@gmail.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 20 Mar 2014, James Bottomley wrote:

> On Thu, 2014-03-20 at 12:34 -0400, Alan Stern wrote:
> > On Thu, 20 Mar 2014, James Bottomley wrote:
> > 
> > > OK, so I think we have three things to do
> > > 
> > >      1. Investigate SCSI and fix it's abort state problem that's causing
> > >         it not to send the abort second time around
> > >      2. Fix usb-storage to fail a reset it can't do (i.e. device reset
> > >         with outstanding commands)
> > >      3. Find out why we're sending a spurious request sense.
> > > 
> > > I can look at 1 and 3 if you want to take 2.
> > 
> > It's a deal!  Thanks for your help.
> 
> And this looks to be 3: a bug in the way we attach sense data to
> commands (we shouldn't look for attached sense if the device error code
> didn't imply there would be any).
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 771c16b..d020149 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1157,6 +1157,15 @@ int scsi_eh_get_sense(struct list_head *work_q,
>  					     __func__));
>  			break;
>  		}
> +		if (status_byte(scmd->result) != CHECK_CONDITION)
> +			/*
> +			 * don't request sense if there's no check condition
> +			 * status because the error we're processing isn't one
> +			 * that has a sense code (and some devices get
> +			 * confused by sense requests out of the blue)
> +			 */
> +			continue;
> +
>  		SCSI_LOG_ERROR_RECOVERY(2, scmd_printk(KERN_INFO, scmd,
>  						  "%s: requesting sense\n",
>  						  current->comm));

I tried this patch first, because fixing the earlier bug would mask
this one.

The patch sort of worked.  But the first time I tried it, it failed in
a rather amusing way.  While the second retry was running and hung,
scmd->result _was_ equal to CHECK_CONDITION -- because that was the
result from the _first_ retry, and it had never gotten cleared!

scmd->result needs to be set to 0 before the queuecommand callback is
invoked.  I ended up adding this to your patch, and then it worked
perfectly:


Index: usb-3.14/drivers/scsi/scsi_error.c
===================================================================
--- usb-3.14.orig/drivers/scsi/scsi_error.c
+++ usb-3.14/drivers/scsi/scsi_error.c
@@ -924,6 +924,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd
 	memset(scmd->cmnd, 0, BLK_MAX_CDB);
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 	scmd->request->next_rq = NULL;
+	scmd->result = 0;
 
 	if (sense_bytes) {
 		scmd->sdb.length = min_t(unsigned, SCSI_SENSE_BUFFERSIZE,
Index: usb-3.14/drivers/scsi/scsi_lib.c
===================================================================
--- usb-3.14.orig/drivers/scsi/scsi_lib.c
+++ usb-3.14/drivers/scsi/scsi_lib.c
@@ -159,6 +159,7 @@ static void __scsi_queue_insert(struct s
 	 * lock such that the kblockd_schedule_work() call happens
 	 * before blk_cleanup_queue() finishes.
 	 */
+	cmd->result = 0;
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, cmd->request);
 	kblockd_schedule_work(q, &device->requeue_work);


Maybe only the second one is necessary, but it seemed best to be
consistent.

Alan Stern

