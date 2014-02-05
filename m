From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/15] scsi: centralize command re-queueing in scsi_dispatch_fn
Date: Wed, 05 Feb 2014 04:41:27 -0800
Message-ID: <20140205124153.703981660@bombadil.infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaBEMlz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:41:55 -0500
Content-Disposition: inline; filename=0009-scsi-centralize-command-re-queueing-in-scsi_dispatch.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Make sure we only have the logic for requeing commands in one place.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c     |   36 +++++++++++++-----------------------
 drivers/scsi/scsi_lib.c |    6 ++++--
 2 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 5cb935a..adb8bfb 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -620,9 +620,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		 * returns an immediate error upwards, and signals
 		 * that the device is no longer present */
 		cmd->result = DID_NO_CONNECT << 16;
-		scsi_done(cmd);
-		/* return 0 (because the command has been processed) */
-		goto out;
+		goto done;
 	}
 
 	/* Check to see if the scsi lld made this device blocked. */
@@ -634,16 +632,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
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
@@ -667,35 +657,35 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
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
index c6fc552..5f4b70b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1633,8 +1633,10 @@ static void scsi_request_fn(struct request_queue *q)
 		 */
 		rtn = scsi_dispatch_cmd(cmd);
 		spin_lock_irq(q->queue_lock);
-		if (rtn)
+		if (rtn) {
+			scsi_queue_insert(cmd, rtn);
 			goto out_delay;
+		}
 	}
 
 	return;
@@ -1654,7 +1656,7 @@ static void scsi_request_fn(struct request_queue *q)
 	blk_requeue_request(q, req);
 	atomic_dec(&sdev->device_busy);
 out_delay:
-	if (atomic_read(&sdev->device_busy) == 0)
+	if (atomic_read(&sdev->device_busy) == 0 && !scsi_device_blocked(sdev))
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 }
 
-- 
1.7.10.4


