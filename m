From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: timeout reset timer before command is queued
Date: Sun, 13 Dec 2009 11:52:34 +0200
Message-ID: <4B24B962.4070804@panasas.com>
References: <4B21B143.0@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:24767 "HELO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751915AbZLMJwi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Dec 2009 04:52:38 -0500
In-Reply-To: <4B21B143.0@mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Min Zhang <mzhang@mvista.com>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

On 12/11/2009 04:41 AM, Min Zhang wrote:
> Kernel panic of NULL pointer in scsi_dispatch_cmd during fiber channel 
> scsi disk access. It is because scsi command can time out even before 
> dispatcher queues it to lower level driver, then scsi_times_out error 
> handler could complete the request and free the command memory while 
> scsi_dispatch_cmd still uses the command pointer.
> 
> This patch adds new SCSI_EH_RESET_TIMER flag per command to indicate the 
> command hasn't been queued, so scsi_times_out won't complete and free 
> the command.  req->special command pointer is also NULLed when the 
> command is freed.
> 
> This premature time out is rare, mostly triggered by occasional network 
> delay for fibre channel scsi disk. The patch is verified by 
> instrumenting a testing delay to force scsi_times_out and then 
> monitoring the command pointer integrity.
> 
> Signed-off-by: Min Zhang <mzhang@mvista.com>
> 

OK I stare at the existing code hard and I do not understand why we
ask about (blk_queue_tagged(q) && !blk_queue_start_tag(q, req)) twice?
And why we let in a failing chance between the blk_start and the dispatch?

I mean why not do the below?

This should also solve Min's problem by not letting any failure between
blk_start_request and scsi_dispatch_cmd.
(Only compile tested just to explain the question above)
---
git diff --stat -p -M drivers/scsi/
 drivers/scsi/scsi_lib.c |   38 ++++++++++++++++++--------------------
 1 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5987da8..e748b6f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1487,26 +1487,6 @@ static void scsi_request_fn(struct request_queue *q)
 			continue;
 		}
 
-
-		/*
-		 * Remove the request from the request list.
-		 */
-		if (!(blk_queue_tagged(q) && !blk_queue_start_tag(q, req)))
-			blk_start_request(req);
-		sdev->device_busy++;
-
-		spin_unlock(q->queue_lock);
-		cmd = req->special;
-		if (unlikely(cmd == NULL)) {
-			printk(KERN_CRIT "impossible request in %s.\n"
-					 "please mail a stack trace to "
-					 "linux-scsi@vger.kernel.org\n",
-					 __func__);
-			blk_dump_rq_flags(req, "foo");
-			BUG();
-		}
-		spin_lock(shost->host_lock);
-
 		/*
 		 * We hit this when the driver is using a host wide
 		 * tag map. For device level tag maps the queue_depth check
@@ -1528,6 +1508,24 @@ static void scsi_request_fn(struct request_queue *q)
 		if (!scsi_host_queue_ready(q, shost, sdev))
 			goto not_ready;
 
+		/*
+		 * Remove the request from the request list.
+		 */
+		blk_start_request(req);
+		sdev->device_busy++;
+
+		spin_unlock(q->queue_lock);
+		cmd = req->special;
+		if (unlikely(cmd == NULL)) {
+			printk(KERN_CRIT "impossible request in %s.\n"
+					 "please mail a stack trace to "
+					 "linux-scsi@vger.kernel.org\n",
+					 __func__);
+			blk_dump_rq_flags(req, "foo");
+			BUG();
+		}
+		spin_lock(shost->host_lock);
+
 		scsi_target(sdev)->target_busy++;
 		shost->host_busy++;
 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index dd098ca..9be78a5 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -743,6 +743,9 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>       */
>      scsi_cmd_get_serial(host, cmd);
>  
> +    /* Timeout error handler can start processing cmd now */
> +    cmd->eh_eflags &= ~SCSI_EH_RESET_TIMER;
> +
>      if (unlikely(host->shost_state == SHOST_DEL)) {
>          cmd->result = (DID_NO_CONNECT << 16);
>          scsi_done(cmd);
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 1b0060b..94dca64 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -128,6 +128,14 @@ enum blk_eh_timer_return scsi_times_out(struct 
> request *req)
>  
>      scsi_log_completion(scmd, TIMEOUT_ERROR);
>  
> +    /*
> +     * Extend timeout if cmd has not been queued yet, otherwise error
> +     * handler could complete request and free the cmd memory while
> +     * the dispatch handler still uses the cmd pointer.
> +     */
> +    if (scmd->eh_eflags | SCSI_EH_RESET_TIMER)
> +        return BLK_EH_RESET_TIMER;
> +
>      if (scmd->device->host->transportt->eh_timed_out)
>          rtn = scmd->device->host->transportt->eh_timed_out(scmd);
>      else if (scmd->device->host->hostt->eh_timed_out)
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 5987da8..fd1afb6 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -492,11 +492,13 @@ void scsi_next_command(struct scsi_cmnd *cmd)
>  {
>      struct scsi_device *sdev = cmd->device;
>      struct request_queue *q = sdev->request_queue;
> +    struct request *req = cmd->request;
>  
>      /* need to hold a reference on the device before we let go of the 
> cmd */
>      get_device(&sdev->sdev_gendev);
>  
>      scsi_put_command(cmd);
> +    req->special = NULL;
>      scsi_run_queue(q);
>  
>      /* ok to remove device now */
> @@ -1491,12 +1493,21 @@ static void scsi_request_fn(struct request_queue *q)
>          /*
>           * Remove the request from the request list.
>           */
> +        cmd = req->special;
>          if (!(blk_queue_tagged(q) && !blk_queue_start_tag(q, req)))
> +        {
> +            /*
> +             * Prevent timeout error handler from processing
> +             * the cmd until it is queued in scsi_dispatch_cmd,
> +             * otherwise cmd pointer might be freed by error handle
> +             */
> +            cmd->eh_eflags |= SCSI_EH_RESET_TIMER;
> +
>              blk_start_request(req);
> +        }
>          sdev->device_busy++;
>  
>          spin_unlock(q->queue_lock);
> -        cmd = req->special;
>          if (unlikely(cmd == NULL)) {
>              printk(KERN_CRIT "impossible request in %s.\n"
>                       "please mail a stack trace to "
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 1fbf7c7..4c71010 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -16,6 +16,7 @@ struct scsi_nl_hdr;
>   * Scsi Error Handler Flags
>   */
>  #define SCSI_EH_CANCEL_CMD    0x0001    /* Cancel this cmd */
> +#define SCSI_EH_RESET_TIMER    0x0002    /* Reset timer on the this cmd */
>  
>  #define SCSI_SENSE_VALID(scmd) \
>      (((scmd)->sense_buffer[0] & 0x70) == 0x70)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

