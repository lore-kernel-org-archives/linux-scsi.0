From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/14] scsi: centralize command re-queueing in scsi_dispatch_fn
Date: Fri, 18 Jul 2014 12:13:02 +0200
Message-ID: <1405678393-11497-4-git-send-email-hch@lst.de>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405678393-11497-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Make sure we only have the logic for requeing commands in one place.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Webb Scales <webbnh@hp.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Robert Elliott <elliott@hp.com>
---
 drivers/scsi/scsi.c     | 35 ++++++++++++-----------------------
 drivers/scsi/scsi_lib.c |  9 ++++++---
 2 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 321f854..2396e89 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -645,9 +645,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		 * returns an immediate error upwards, and signals
 		 * that the device is no longer present */
 		cmd->result = DID_NO_CONNECT << 16;
-		scsi_done(cmd);
-		/* return 0 (because the command has been processed) */
-		goto out;
+		goto done;
 	}
 
 	/* Check to see if the scsi lld made this device blocked. */
@@ -659,17 +657,9 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		 * occur until the device transitions out of the
 		 * suspend state.
 		 */
-
-		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
-
 		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
 			"queuecommand : device blocked\n"));
-
-		/*
-		 * NOTE: rtn is still zero here because we don't need the
-		 * queue to be plugged on return (it's already stopped)
-		 */
-		goto out;
+		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
 	/*
@@ -693,20 +683,19 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 			       "cdb_size=%d host->max_cmd_len=%d\n",
 			       cmd->cmd_len, cmd->device->host->max_cmd_len));
 		cmd->result = (DID_ABORT << 16);
-
-		scsi_done(cmd);
-		goto out;
+		goto done;
 	}
 
 	if (unlikely(host->shost_state == SHOST_DEL)) {
 		cmd->result = (DID_NO_CONNECT << 16);
-		scsi_done(cmd);
-	} else {
-		trace_scsi_dispatch_cmd_start(cmd);
-		cmd->scsi_done = scsi_done;
-		rtn = host->hostt->queuecommand(host, cmd);
+		goto done;
+
 	}
 
+	trace_scsi_dispatch_cmd_start(cmd);
+
+	cmd->scsi_done = scsi_done;
+	rtn = host->hostt->queuecommand(host, cmd);
 	if (rtn) {
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
@@ -715,12 +704,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 
 		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
 			"queuecommand : request rejected\n"));
-
-		scsi_queue_insert(cmd, rtn);
 	}
 
- out:
 	return rtn;
+ done:
+	scsi_done(cmd);
+	return 0;
 }
 
 /**
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3ac677c..bf73427 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1557,9 +1557,12 @@ static void scsi_request_fn(struct request_queue *q)
 		 * Dispatch the command to the low-level driver.
 		 */
 		rtn = scsi_dispatch_cmd(cmd);
-		spin_lock_irq(q->queue_lock);
-		if (rtn)
+		if (rtn) {
+			scsi_queue_insert(cmd, rtn);
+			spin_lock_irq(q->queue_lock);
 			goto out_delay;
+		}
+		spin_lock_irq(q->queue_lock);
 	}
 
 	return;
@@ -1579,7 +1582,7 @@ static void scsi_request_fn(struct request_queue *q)
 	blk_requeue_request(q, req);
 	sdev->device_busy--;
 out_delay:
-	if (sdev->device_busy == 0)
+	if (sdev->device_busy == 0 && !scsi_device_blocked(sdev))
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 }
 
-- 
1.9.1
