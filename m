From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/14] scsi: centralize command re-queueing in scsi_dispatch_fn
Date: Thu, 12 Jun 2014 15:48:55 +0200
Message-ID: <1402580946-11470-4-git-send-email-hch@lst.de>
References: <1402580946-11470-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1402580946-11470-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliot <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Make sure we only have the logic for requeing commands in one place.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c     |   36 +++++++++++++-----------------------
 drivers/scsi/scsi_lib.c |    9 ++++++---
 2 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 88d46fe..b91abab 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -648,9 +648,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		 * returns an immediate error upwards, and signals
 		 * that the device is no longer present */
 		cmd->result = DID_NO_CONNECT << 16;
-		scsi_done(cmd);
-		/* return 0 (because the command has been processed) */
-		goto out;
+		goto done;
 	}
 
 	/* Check to see if the scsi lld made this device blocked. */
@@ -662,16 +660,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		 * occur until the device transitions out of the
 		 * suspend state.
 		 */
-
-		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
-
 		SCSI_LOG_MLQUEUE(3, printk("queuecommand : device blocked \n"));
-
-		/*
-		 * NOTE: rtn is still zero here because we don't need the
-		 * queue to be plugged on return (it's already stopped)
-		 */
-		goto out;
+		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
 	/* 
@@ -695,35 +685,35 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
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
 		    rtn != SCSI_MLQUEUE_TARGET_BUSY)
 			rtn = SCSI_MLQUEUE_HOST_BUSY;
 
-		scsi_queue_insert(cmd, rtn);
-
 		SCSI_LOG_MLQUEUE(3,
 		    printk("queuecommand : request rejected\n"));
 	}
 
- out:
 	SCSI_LOG_MLQUEUE(3, printk("leaving scsi_dispatch_cmnd()\n"));
 	return rtn;
+ done:
+	SCSI_LOG_MLQUEUE(3, printk("scsi_dispatch_cmnd() failed\n"));
+	scsi_done(cmd);
+	return 0;
 }
 
 /**
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7662168..98eb358 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1583,9 +1583,12 @@ static void scsi_request_fn(struct request_queue *q)
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
@@ -1605,7 +1608,7 @@ static void scsi_request_fn(struct request_queue *q)
 	blk_requeue_request(q, req);
 	sdev->device_busy--;
 out_delay:
-	if (sdev->device_busy == 0)
+	if (sdev->device_busy == 0 && !scsi_device_blocked(sdev))
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 }
 
-- 
1.7.10.4
