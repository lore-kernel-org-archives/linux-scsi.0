From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 1/4] Introduce scsi_start_queue()
Date: Mon, 17 Apr 2017 10:34:33 -0700
Message-ID: <20170417173436.15555-2-bart.vanassche@sandisk.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:32059 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754704AbdDQRe5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2017 13:34:57 -0400
In-Reply-To: <20170417173436.15555-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Hannes Reinecke <hare@suse.de>

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Israel Rukshin <israelr@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c  | 25 +++++++++++++++----------
 drivers/scsi/scsi_priv.h |  1 +
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f41e6b84a1bd..4893f2908edf 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2987,6 +2987,20 @@ scsi_internal_device_block(struct scsi_device *sdev, bool wait)
 }
 EXPORT_SYMBOL_GPL(scsi_internal_device_block);
  
+void scsi_start_queue(struct scsi_device *sdev)
+{
+	struct request_queue *q = sdev->request_queue;
+	unsigned long flags;
+
+	if (q->mq_ops) {
+		blk_mq_start_stopped_hw_queues(q, false);
+	} else {
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_start_queue(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
+}
+
 /**
  * scsi_internal_device_unblock - resume a device after a block request
  * @sdev:	device to resume
@@ -3007,9 +3021,6 @@ int
 scsi_internal_device_unblock(struct scsi_device *sdev,
 			     enum scsi_device_state new_state)
 {
-	struct request_queue *q = sdev->request_queue; 
-	unsigned long flags;
-
 	/*
 	 * Try to transition the scsi device to SDEV_RUNNING or one of the
 	 * offlined states and goose the device queue if successful.
@@ -3027,13 +3038,7 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
 		 sdev->sdev_state != SDEV_OFFLINE)
 		return -EINVAL;
 
-	if (q->mq_ops) {
-		blk_mq_start_stopped_hw_queues(q, false);
-	} else {
-		spin_lock_irqsave(q->queue_lock, flags);
-		blk_start_queue(q);
-		spin_unlock_irqrestore(q->queue_lock, flags);
-	}
+	scsi_start_queue(sdev);
 
 	return 0;
 }
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index f11bd102d6d5..c7629e31a75b 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -89,6 +89,7 @@ extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern void scsi_requeue_run_queue(struct work_struct *work);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
 extern struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev);
+extern void scsi_start_queue(struct scsi_device *sdev);
 extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
 extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
 extern int scsi_init_queue(void);
-- 
2.12.2
