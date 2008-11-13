From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12020] scsi_times_out NULL pointer dereference
Date: Thu, 13 Nov 2008 14:47:09 -0800 (PST)
Message-ID: <20081113224709.D126511D108@picon.linux-foundation.org>
References: <bug-12020-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715AbYKMWrl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2008 17:47:41 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mADMl91W019785
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2008 14:47:10 -0800
In-Reply-To: <bug-12020-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12020





------- Comment #4 from anonymous@kernel-bugs.osdl.org  2008-11-13 14:47 -------
Reply-To: James.Bottomley@HansenPartnership.com

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
@@ -649,8 +643,8 @@ static void scsi_requeue_command(struct request_queue *q,
struct scsi_cmnd *cmd)
        struct request *req = cmd->request;
        unsigned long flags;

-       scsi_unprep_request(req);
        spin_lock_irqsave(q->queue_lock, flags);
+       scsi_unprep_request(req);
        blk_requeue_request(q, req);
        spin_unlock_irqrestore(q->queue_lock, flags);



-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
