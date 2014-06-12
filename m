From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/14] scsi: split __scsi_queue_insert
Date: Thu, 12 Jun 2014 15:48:54 +0200
Message-ID: <1402580946-11470-3-git-send-email-hch@lst.de>
References: <1402580946-11470-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59424 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbaFLNq6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jun 2014 09:46:58 -0400
In-Reply-To: <1402580946-11470-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliot <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Factor out a helper to set the _blocked values, which we'll reuse for the
blk-mq code path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f7e3163..7662168 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -75,28 +75,12 @@ struct kmem_cache *scsi_sdb_cache;
  */
 #define SCSI_QUEUE_DELAY	3
 
-/**
- * __scsi_queue_insert - private queue insertion
- * @cmd: The SCSI command being requeued
- * @reason:  The reason for the requeue
- * @unbusy: Whether the queue should be unbusied
- *
- * This is a private queue insertion.  The public interface
- * scsi_queue_insert() always assumes the queue should be unbusied
- * because it's always called before the completion.  This function is
- * for a requeue after completion, which should only occur in this
- * file.
- */
-static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
+static void
+scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_device *device = cmd->device;
 	struct scsi_target *starget = scsi_target(device);
-	struct request_queue *q = device->request_queue;
-	unsigned long flags;
-
-	SCSI_LOG_MLQUEUE(1,
-		 printk("Inserting command %p into mlqueue\n", cmd));
 
 	/*
 	 * Set the appropriate busy bit for the device/host.
@@ -123,6 +107,30 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 		starget->target_blocked = starget->max_target_blocked;
 		break;
 	}
+}
+
+/**
+ * __scsi_queue_insert - private queue insertion
+ * @cmd: The SCSI command being requeued
+ * @reason:  The reason for the requeue
+ * @unbusy: Whether the queue should be unbusied
+ *
+ * This is a private queue insertion.  The public interface
+ * scsi_queue_insert() always assumes the queue should be unbusied
+ * because it's always called before the completion.  This function is
+ * for a requeue after completion, which should only occur in this
+ * file.
+ */
+static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
+{
+	struct scsi_device *device = cmd->device;
+	struct request_queue *q = device->request_queue;
+	unsigned long flags;
+
+	SCSI_LOG_MLQUEUE(1,
+		 printk("Inserting command %p into mlqueue\n", cmd));
+
+	scsi_set_blocked(cmd, reason);
 
 	/*
 	 * Decrement the counters, since these commands are no longer
-- 
1.7.10.4

