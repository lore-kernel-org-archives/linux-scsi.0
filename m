From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12020] New: scsi_times_out NULL pointer dereference
Date: Thu, 13 Nov 2008 16:46:54 -0600
Message-ID: <1226616414.3537.26.camel@localhost.localdomain>
References: <bug-12020-11613@http.bugzilla.kernel.org/>
	 <1226603010.3537.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40131 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197AbYKMWrD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2008 17:47:03 -0500
In-Reply-To: <1226603010.3537.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>

On Thu, 2008-11-13 at 13:03 -0600, James Bottomley wrote:
> Actually, I think the trace is slightly off.  I suspect this is the
> problem:
> 
> 	struct scsi_cmnd *scmd = req->special;
> 
> I bet req->special is NULL because the command timed out even before it
> was prepared by the subsystem.
> 
> Does this fix it?
> 
> The fix is more of a bandaid than anything ... we can't really have
> commands timing out in the mid-layer because we expect we have full
> control of them.  With this patch, if we run out of resets, block will
> complete a command we're still processing.
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 94ed262..5612c42 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -127,6 +127,13 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
>  	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
>  	enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
>  
> +	if (!scmd)
> +		/*
> +		 * nasty: command timed out before the mid layer
> +		 * even prepared it
> +		 */
> +		return BLK_EH_RESET_TIMER;
> +
>  	scsi_log_completion(scmd, TIMEOUT_ERROR);
>  
>  	if (scmd->device->host->transportt->eh_timed_out)

Mike Anderson pointed out that we have a potential window where the
timer can fire after we've unprepped the request in SCSI (so making
req->special NULL) but before we call blk_requeue_request() which stops
the timer.  We can rejig the locking to prevent this from happening, so
could you (separately) try this patch?

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f5d3b96..3475b74 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -649,8 +643,8 @@ static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 	struct request *req = cmd->request;
 	unsigned long flags;
 
-	scsi_unprep_request(req);
 	spin_lock_irqsave(q->queue_lock, flags);
+	scsi_unprep_request(req);
 	blk_requeue_request(q, req);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 


