From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 6/10] add request retries field
Date: Tue, 08 Nov 2005 04:06:47 -0600
Message-ID: <1131444407.23111.67.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:9631 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932502AbVKHKH2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 05:07:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, linux-scsi@vger.kernel.org

For tape we need to control the retries, so this patch adds a retries
field  on the request for REQ_PC commands to use.

For block SG_IO commands we set the retries to 1. This is the same
as before for sd, but for sr this decreases the retries (it
used to be 3 for sr). If the latter behavior is not acceptable I can
send a patch so that we only use the retries counter
for REQ_PC commands initiated from scsi-ml and the scsi ULDs so
block/scsi_ioct.c ones use some ULD value, or we could increase
the block/scsi_ioctl.c retires to 3.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/block/scsi_ioctl.c b/drivers/block/scsi_ioctl.c
index 4e390df..79b8901 100644
--- a/drivers/block/scsi_ioctl.c
+++ b/drivers/block/scsi_ioctl.c
@@ -303,6 +303,7 @@ static int sg_io(struct file *file, requ
 		rq->timeout = q->sg_timeout;
 	if (!rq->timeout)
 		rq->timeout = BLK_DEFAULT_TIMEOUT;
+	rq->retries = 1;
 
 	start_time = jiffies;
 
@@ -413,6 +414,7 @@ static int sg_scsi_ioctl(struct file *fi
 			rq->timeout = BLK_DEFAULT_TIMEOUT;
 			break;
 	}
+	rq->retries = 1;
 
 	memset(sense, 0, sizeof(sense));
 	rq->sense = sense;
@@ -571,6 +573,7 @@ int scsi_cmd_ioctl(struct file *file, st
 			rq->data = NULL;
 			rq->data_len = 0;
 			rq->timeout = BLK_DEFAULT_TIMEOUT;
+			rq->retries = 1;
 			memset(rq->cmd, 0, sizeof(rq->cmd));
 			rq->cmd[0] = GPCMD_START_STOP_UNIT;
 			rq->cmd[4] = 0x02 + (close != 0);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ed22a1..10627a5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -259,6 +259,7 @@ int scsi_execute(struct scsi_device *sde
 	memcpy(req->cmd, cmd, req->cmd_len);
 	req->sense = sense;
 	req->sense_len = 0;
+	req->retries = retries;
 	req->timeout = timeout;
 	req->flags |= flags | REQ_BLOCK_PC | REQ_SPECIAL | REQ_QUIET;
 
@@ -474,6 +475,7 @@ int scsi_execute_async(struct scsi_devic
 	req->sense = sioc->sense;
 	req->sense_len = 0;
 	req->timeout = timeout;
+	req->retries = retries;
 	req->flags |= REQ_BLOCK_PC | REQ_QUIET;
 	req->end_io_data = sioc;
 
@@ -1387,7 +1389,7 @@ static int scsi_prep_fn(struct request_q
 				cmd->sc_data_direction = DMA_NONE;
 			
 			cmd->transfersize = req->data_len;
-			cmd->allowed = 3;
+			cmd->allowed = req->retries;
 			cmd->timeout_per_command = req->timeout;
 			cmd->done = scsi_generic_done;
 		}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bb5b242..4b43d73 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -86,7 +86,6 @@
  * Number of allowed retries
  */
 #define SD_MAX_RETRIES		5
-#define SD_PASSTHROUGH_RETRIES	1
 
 static void scsi_disk_release(struct kref *kref);
 
@@ -262,7 +261,7 @@ static int sd_init_command(struct scsi_c
 			timeout = rq->timeout;
 
 		SCpnt->transfersize = rq->data_len;
-		SCpnt->allowed = SD_PASSTHROUGH_RETRIES;
+		SCpnt->allowed = rq->retries;
 		goto queue;
 	}
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index d68cea7..bbcf428 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -338,6 +338,7 @@ static int sr_init_command(struct scsi_c
 		if (rq->timeout)
 			timeout = rq->timeout;
 
+		SCpnt->allowed = rq->retries;
 		SCpnt->transfersize = rq->data_len;
 		goto queue;
 	}
@@ -435,9 +436,8 @@ static int sr_init_command(struct scsi_c
 	 */
 	SCpnt->transfersize = cd->device->sector_size;
 	SCpnt->underflow = this_count << 9;
-
-queue:
 	SCpnt->allowed = MAX_RETRIES;
+queue:
 	SCpnt->timeout_per_command = timeout;
 
 	/*
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9c5ef70..002e05f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4206,6 +4206,7 @@ static int st_init_command(struct scsi_c
 	else
 		SCpnt->sc_data_direction = DMA_NONE;
 
+	SCpnt->allowed = rq->retries;
 	SCpnt->timeout_per_command = rq->timeout;
 	SCpnt->transfersize = rq->data_len;
 	SCpnt->done = st_intr;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e0b47fa..5814b39 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -184,6 +184,7 @@ struct request {
 	void *sense;
 
 	unsigned int timeout;
+	int retries;
 
 	/*
 	 * For Power Management requests


