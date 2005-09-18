From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] fix retries and command completion when using REQ_BLOCK_PC
Date: Sun, 18 Sep 2005 12:19:04 -0500
Message-ID: <1127063944.1421.16.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47826 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932174AbVIRTTL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 15:19:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, linux-scsi@vger.kernel.org

Hi Jens and James,

As you know a side effect of SCSI using REQ_BLOCK_PC is that commands
that used to originate from SCSI do not obey the retries value, and we
now add extra processing of failures in scsi_io_completion.

The patch below adds a retry count on the request which is used like the
timeout value. And it changes scsi_generic_done to always complete the
entire command which emulates the old behavior we had with
scsi_wait_req/scsi_do_req where scsi_io_completeion does not process the
error and request additional retries.

Patch was made against scsi-rc-fixes.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/block/scsi_ioctl.c b/drivers/block/scsi_ioctl.c
--- a/drivers/block/scsi_ioctl.c
+++ b/drivers/block/scsi_ioctl.c
@@ -302,6 +302,7 @@ static int sg_io(struct file *file, requ
 		rq->timeout = q->sg_timeout;
 	if (!rq->timeout)
 		rq->timeout = BLK_DEFAULT_TIMEOUT;
+	rq->retries = 1;
 
 	start_time = jiffies;
 
@@ -412,6 +413,7 @@ static int sg_scsi_ioctl(struct file *fi
 			rq->timeout = BLK_DEFAULT_TIMEOUT;
 			break;
 	}
+	rq->retries = 1;
 
 	memset(sense, 0, sizeof(sense));
 	rq->sense = sense;
@@ -570,6 +572,7 @@ int scsi_cmd_ioctl(struct file *file, st
 			rq->data = NULL;
 			rq->data_len = 0;
 			rq->timeout = BLK_DEFAULT_TIMEOUT;
+			rq->retries = 1;
 			memset(rq->cmd, 0, sizeof(rq->cmd));
 			rq->cmd[0] = GPCMD_START_STOP_UNIT;
 			rq->cmd[4] = 0x02 + (close != 0);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -337,6 +337,7 @@ int scsi_execute(struct scsi_device *sde
 	memcpy(req->cmd, cmd, req->cmd_len);
 	req->sense = sense;
 	req->sense_len = 0;
+	req->retries = retries;
 	req->timeout = timeout;
 	req->flags |= flags | REQ_BLOCK_PC | REQ_SPECIAL | REQ_QUIET;
 
@@ -1125,7 +1126,13 @@ static int scsi_issue_flush_fn(request_q
 static void scsi_generic_done(struct scsi_cmnd *cmd)
 {
 	BUG_ON(!blk_pc_request(cmd->request));
-	scsi_io_completion(cmd, cmd->result == 0 ? cmd->bufflen : 0, 0);
+	/*
+	 * This will complete the whole command with uptodate=1 so
+	 * as far as the block layer is concerned the command completed
+	 * successfully. Since his is a REQ_BLOCK_PC command though the
+	 * caller should check the request errors value
+	 */
+	scsi_io_completion(cmd, cmd->bufflen, 0);
 }
 
 static int scsi_prep_fn(struct request_queue *q, struct request *req)
@@ -1273,7 +1280,7 @@ static int scsi_prep_fn(struct request_q
 				cmd->sc_data_direction = DMA_NONE;
 			
 			cmd->transfersize = req->data_len;
-			cmd->allowed = 3;
+			cmd->allowed = req->retries;
 			cmd->timeout_per_command = req->timeout;
 			cmd->done = scsi_generic_done;
 		}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -86,7 +86,6 @@
  * Number of allowed retries
  */
 #define SD_MAX_RETRIES		5
-#define SD_PASSTHROUGH_RETRIES	1
 
 static void scsi_disk_release(struct kref *kref);
 
@@ -248,7 +247,7 @@ static int sd_init_command(struct scsi_c
 			timeout = rq->timeout;
 
 		SCpnt->transfersize = rq->data_len;
-		SCpnt->allowed = SD_PASSTHROUGH_RETRIES;
+		SCpnt->allowed = rq->retries;
 		goto queue;
 	}
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4215,6 +4215,7 @@ static int st_init_command(struct scsi_c
 	else
 		SCpnt->sc_data_direction = DMA_NONE;
 
+	SCpnt->allowed = rq->retries;
 	SCpnt->timeout_per_command = rq->timeout;
 	SCpnt->transfersize = rq->data_len;
 	SCpnt->done = st_intr;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -184,6 +184,7 @@ struct request {
 	void *sense;
 
 	unsigned int timeout;
+	int retries;
 
 	/*
 	 * For Power Management requests


