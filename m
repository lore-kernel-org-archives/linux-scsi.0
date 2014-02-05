From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/15] scsi: split __scsi_queue_insert
Date: Wed, 05 Feb 2014 04:41:28 -0800
Message-ID: <20140205124153.915685932@bombadil.infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaBEMlz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:41:55 -0500
Content-Disposition: inline; filename=0010-scsi-split-__scsi_queue_insert.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Factor out a helper to set the _blocked values, which we'll reuse for the
blk-mq code path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5f4b70b..3b3c3ab 100644
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
@@ -125,6 +109,30 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 			   starget->max_target_blocked);
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


