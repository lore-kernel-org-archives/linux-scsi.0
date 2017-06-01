From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 05/12] Introduce scsi_start_queue()
Date: Thu, 1 Jun 2017 16:27:04 -0700
Message-ID: <20170601232711.29062-6-bart.vanassche@sandisk.com>
References: <20170601232711.29062-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:7438 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdFAXer (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 19:34:47 -0400
In-Reply-To: <20170601232711.29062-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Israel Rukshin <israelr@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_lib.c  | 25 +++++++++++++++----------
 drivers/scsi/scsi_priv.h |  1 +
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 845d47244e70..6a58a124714f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3030,6 +3030,20 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
 	return err;
 }
  
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
  * scsi_internal_device_unblock_nowait - resume a device after a block request
  * @sdev:	device to resume
@@ -3048,9 +3062,6 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
 int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
 					enum scsi_device_state new_state)
 {
-	struct request_queue *q = sdev->request_queue; 
-	unsigned long flags;
-
 	/*
 	 * Try to transition the scsi device to SDEV_RUNNING or one of the
 	 * offlined states and goose the device queue if successful.
@@ -3068,13 +3079,7 @@ int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
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
index 59ebc1795bb3..f86057842f9a 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -88,6 +88,7 @@ extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern void scsi_requeue_run_queue(struct work_struct *work);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
 extern struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev);
+extern void scsi_start_queue(struct scsi_device *sdev);
 extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
 extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
 extern int scsi_init_queue(void);
-- 
2.12.2
