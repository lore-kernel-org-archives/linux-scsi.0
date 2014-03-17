From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 30/39] scsi: centralize command re-queueing in scsi_dispatch_fn
Date: Mon, 17 Mar 2014 06:28:03 -0700
Message-ID: <20140317133135.836674066@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276AbaCQNbg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2014 09:31:36 -0400
Content-Disposition: inline; filename=0030-scsi-centralize-command-re-queueing-in-scsi_dispatch.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Make sure we only have the logic for requeing commands in one place.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c     |   36 +++++++++++++-----------------------
 drivers/scsi/scsi_lib.c |    9 ++++++---
 2 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 0e8a077..0df3913 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -639,9 +639,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		 * returns an immediate error upwards, and signals
 		 * that the device is no longer present */
 		cmd->result = DID_NO_CONNECT << 16;
-		scsi_done(cmd);
-		/* return 0 (because the command has been processed) */
-		goto out;
+		goto done;
 	}
 
 	/* Check to see if the scsi lld made this device blocked. */
@@ -653,16 +651,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
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
@@ -686,35 +676,35 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
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
index 9889c75..53d06e8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1598,9 +1598,12 @@ static void scsi_request_fn(struct request_queue *q)
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
@@ -1620,7 +1623,7 @@ static void scsi_request_fn(struct request_queue *q)
 	blk_requeue_request(q, req);
 	atomic_dec(&sdev->device_busy);
 out_delay:
-	if (atomic_read(&sdev->device_busy) == 0)
+	if (atomic_read(&sdev->device_busy) == 0 && !scsi_device_blocked(sdev))
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 }
 
-- 
1.7.10.4


