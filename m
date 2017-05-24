From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 04/31] Introduce scsi_start_queue()
Date: Tue, 23 May 2017 17:33:53 -0700
Message-ID: <20170524003420.5381-5-bart.vanassche@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Hannes Reinecke <hare@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Israel Rukshin <israelr@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_lib.c  | 25 +++++++++++++++----------
 drivers/scsi/scsi_priv.h |  1 +
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3d82cbe605cd..0ee5c2133e4c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3019,6 +3019,20 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
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
@@ -3037,9 +3051,6 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
 int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
 					enum scsi_device_state new_state)
 {
-	struct request_queue *q = sdev->request_queue; 
-	unsigned long flags;
-
 	/*
 	 * Try to transition the scsi device to SDEV_RUNNING or one of the
 	 * offlined states and goose the device queue if successful.
@@ -3057,13 +3068,7 @@ int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
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
