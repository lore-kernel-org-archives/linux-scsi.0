From: Min Zhang <mzhang@mvista.com>
Subject: Re: [PATCH] scsi: timeout reset timer before command is queued
Date: Mon, 14 Dec 2009 18:40:13 -0800
Message-ID: <4B26F70D.6090409@mvista.com>
References: <4B21B143.0@mvista.com> <4B24B962.4070804@panasas.com> <4B26E38C.1000605@mvista.com> <20091215022126.GK7812@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hu47.mvista.com ([206.112.117.47]:51423 "HELO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753928AbZLOCkR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2009 21:40:17 -0500
In-Reply-To: <20091215022126.GK7812@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

Try again, don't know which white space you refer to or how to fix it:

Following is a 2nd version patch further address the timer fired up as 
early as in blk_queue_start_tag instead of later in scsi_request_fn 
after blk_queue_start_tag fails.
---
Kernel panic of NULL pointer in scsi_dispatch_cmd during fiber channel
scsi disk access. It is because scsi command can time out even before
dispatcher queues it to lower level driver, then scsi_times_out error
handler could complete the request and free the command memory while
scsi_dispatch_cmd still uses the command pointer.

This patch adds new SCSI_EH_RESET_TIMER flag per command to indicate the
command hasn't been queuecommand, so scsi_times_out won't complete and
free the command.  req->special command pointer is also NULLed when the
command is freed.

This premature time out is rare, mostly triggered by occasional network
delay for fibre channel scsi disk. The patch is verified by
instrumenting a testing delay to force scsi_times_out and then
monitoring the command pointer integrity.

Signed-off-by: Min Zhang <mzhang@mvista.com>
Date:   Mon Dec 14 16:41:46 2009 -0800

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index dd098ca..9be78a5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -743,6 +743,9 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
      */
     scsi_cmd_get_serial(host, cmd);
 
+    /* Timeout error handler can start processing cmd now */
+    cmd->eh_eflags &= ~SCSI_EH_RESET_TIMER;
+
     if (unlikely(host->shost_state == SHOST_DEL)) {
         cmd->result = (DID_NO_CONNECT << 16);
         scsi_done(cmd);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1b0060b..94dca64 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -128,6 +128,14 @@ enum blk_eh_timer_return scsi_times_out(struct 
request *req)
 
     scsi_log_completion(scmd, TIMEOUT_ERROR);
 
+    /*
+     * Extend timeout if cmd has not been queued yet, otherwise error
+     * handler could complete request and free the cmd memory while
+     * the dispatch handler still uses the cmd pointer.
+     */
+    if (scmd->eh_eflags | SCSI_EH_RESET_TIMER)
+        return BLK_EH_RESET_TIMER;
+
     if (scmd->device->host->transportt->eh_timed_out)
         rtn = scmd->device->host->transportt->eh_timed_out(scmd);
     else if (scmd->device->host->hostt->eh_timed_out)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5987da8..a369e0c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -492,11 +492,13 @@ void scsi_next_command(struct scsi_cmnd *cmd)
 {
     struct scsi_device *sdev = cmd->device;
     struct request_queue *q = sdev->request_queue;
+    struct request *req = cmd->request;
 
     /* need to hold a reference on the device before we let go of the 
cmd */
     get_device(&sdev->sdev_gendev);
 
     scsi_put_command(cmd);
+    req->special = NULL;
     scsi_run_queue(q);
 
     /* ok to remove device now */
@@ -1487,6 +1489,13 @@ static void scsi_request_fn(struct request_queue *q)
             continue;
         }
 
+        /*
+         * Prevent timeout error handler from processing
+         * the cmd until it is queued in scsi_dispatch_cmd,
+         * otherwise cmd pointer might be freed by error handle
+         */
+        cmd = req->special;
+        cmd->eh_eflags |= SCSI_EH_RESET_TIMER;
 
         /*
          * Remove the request from the request list.
@@ -1496,7 +1505,6 @@ static void scsi_request_fn(struct request_queue *q)
         sdev->device_busy++;
 
         spin_unlock(q->queue_lock);
-        cmd = req->special;
         if (unlikely(cmd == NULL)) {
             printk(KERN_CRIT "impossible request in %s.\n"
                      "please mail a stack trace to "
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 1fbf7c7..4c71010 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -16,6 +16,7 @@ struct scsi_nl_hdr;
  * Scsi Error Handler Flags
  */
 #define SCSI_EH_CANCEL_CMD    0x0001    /* Cancel this cmd */
+#define SCSI_EH_RESET_TIMER    0x0002    /* Reset timer on the this cmd */
 
 #define SCSI_SENSE_VALID(scmd) \
     (((scmd)->sense_buffer[0] & 0x70) == 0x70)

