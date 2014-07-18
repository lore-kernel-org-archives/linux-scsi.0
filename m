From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/14] scsi: fix the {host,target,device}_blocked counter mess
Date: Fri, 18 Jul 2014 12:13:08 +0200
Message-ID: <1405678393-11497-10-git-send-email-hch@lst.de>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44295 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934222AbaGRKLO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jul 2014 06:11:14 -0400
In-Reply-To: <1405678393-11497-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org

Seems like these counters are missing any sort of synchronization for
updates, as a over 10 year old comment from me noted.  Fix this by
using atomic counters, and while we're at it also make sure they are
in the same cacheline as the _busy counters and not needlessly stored
to in every I/O completion.

With the new model the _busy counters can temporarily go negative,
so all the readers are updated to check for > 0 values.  Longer
term every successful I/O completion will reset the counters to zero,
so the temporarily negative values will not cause any harm.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Webb Scales <webbnh@hp.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Robert Elliott <elliott@hp.com>
---
 drivers/scsi/scsi.c        | 21 +++++++--------
 drivers/scsi/scsi_lib.c    | 66 +++++++++++++++++++++++-----------------------
 drivers/scsi/scsi_sysfs.c  | 10 ++++++-
 include/scsi/scsi_device.h |  7 ++---
 include/scsi/scsi_host.h   |  7 ++---
 5 files changed, 58 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 21fb97b..3dde8a3 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -726,17 +726,16 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 
 	scsi_device_unbusy(sdev);
 
-        /*
-         * Clear the flags which say that the device/host is no longer
-         * capable of accepting new commands.  These are set in scsi_queue.c
-         * for both the queue full condition on a device, and for a
-         * host full condition on the host.
-	 *
-	 * XXX(hch): What about locking?
-         */
-        shost->host_blocked = 0;
-	starget->target_blocked = 0;
-        sdev->device_blocked = 0;
+	/*
+	 * Clear the flags that say that the device/target/host is no longer
+	 * capable of accepting new commands.
+	 */
+	if (atomic_read(&shost->host_blocked))
+		atomic_set(&shost->host_blocked, 0);
+	if (atomic_read(&starget->target_blocked))
+		atomic_set(&starget->target_blocked, 0);
+	if (atomic_read(&sdev->device_blocked))
+		atomic_set(&sdev->device_blocked, 0);
 
 	/*
 	 * If we have valid sense information, then some kind of recovery
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1ddf0fb..69da4cb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -99,14 +99,16 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
 	 */
 	switch (reason) {
 	case SCSI_MLQUEUE_HOST_BUSY:
-		host->host_blocked = host->max_host_blocked;
+		atomic_set(&host->host_blocked, host->max_host_blocked);
 		break;
 	case SCSI_MLQUEUE_DEVICE_BUSY:
 	case SCSI_MLQUEUE_EH_RETRY:
-		device->device_blocked = device->max_device_blocked;
+		atomic_set(&device->device_blocked,
+			   device->max_device_blocked);
 		break;
 	case SCSI_MLQUEUE_TARGET_BUSY:
-		starget->target_blocked = starget->max_target_blocked;
+		atomic_set(&starget->target_blocked,
+			   starget->max_target_blocked);
 		break;
 	}
 }
@@ -351,29 +353,35 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
-static inline int scsi_device_is_busy(struct scsi_device *sdev)
+static inline bool scsi_device_is_busy(struct scsi_device *sdev)
 {
-	if (atomic_read(&sdev->device_busy) >= sdev->queue_depth ||
-	    sdev->device_blocked)
-		return 1;
-	return 0;
+	if (atomic_read(&sdev->device_busy) >= sdev->queue_depth)
+		return true;
+	if (atomic_read(&sdev->device_blocked) > 0)
+		return true;
+	return false;
 }
 
-static inline int scsi_target_is_busy(struct scsi_target *starget)
+static inline bool scsi_target_is_busy(struct scsi_target *starget)
 {
-	return ((starget->can_queue > 0 &&
-		 atomic_read(&starget->target_busy) >= starget->can_queue) ||
-		 starget->target_blocked);
+	if (starget->can_queue > 0 &&
+	    atomic_read(&starget->target_busy) >= starget->can_queue)
+		return true;
+	if (atomic_read(&starget->target_blocked) > 0)
+		return true;
+	return false;
 }
 
-static inline int scsi_host_is_busy(struct Scsi_Host *shost)
+static inline bool scsi_host_is_busy(struct Scsi_Host *shost)
 {
-	if ((shost->can_queue > 0 &&
-	     atomic_read(&shost->host_busy) >= shost->can_queue) ||
-	    shost->host_blocked || shost->host_self_blocked)
-		return 1;
-
-	return 0;
+	if (shost->can_queue > 0 &&
+	    atomic_read(&shost->host_busy) >= shost->can_queue)
+		return true;
+	if (atomic_read(&shost->host_blocked) > 0)
+		return true;
+	if (shost->host_self_blocked)
+		return true;
+	return false;
 }
 
 static void scsi_starved_list_run(struct Scsi_Host *shost)
@@ -1256,14 +1264,14 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 	unsigned int busy;
 
 	busy = atomic_inc_return(&sdev->device_busy) - 1;
-	if (sdev->device_blocked) {
+	if (atomic_read(&sdev->device_blocked)) {
 		if (busy)
 			goto out_dec;
 
 		/*
 		 * unblock after device_blocked iterates to zero
 		 */
-		if (--sdev->device_blocked != 0) {
+		if (atomic_dec_return(&sdev->device_blocked) > 0) {
 			blk_delay_queue(q, SCSI_QUEUE_DELAY);
 			goto out_dec;
 		}
@@ -1302,19 +1310,15 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 	}
 
 	busy = atomic_inc_return(&starget->target_busy) - 1;
-	if (starget->target_blocked) {
+	if (atomic_read(&starget->target_blocked) > 0) {
 		if (busy)
 			goto starved;
 
 		/*
 		 * unblock after target_blocked iterates to zero
 		 */
-		spin_lock_irq(shost->host_lock);
-		if (--starget->target_blocked != 0) {
-			spin_unlock_irq(shost->host_lock);
+		if (atomic_dec_return(&starget->target_blocked) > 0)
 			goto out_dec;
-		}
-		spin_unlock_irq(shost->host_lock);
 
 		SCSI_LOG_MLQUEUE(3, starget_printk(KERN_INFO, starget,
 				 "unblocking target at zero depth\n"));
@@ -1349,19 +1353,15 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 		return 0;
 
 	busy = atomic_inc_return(&shost->host_busy) - 1;
-	if (shost->host_blocked) {
+	if (atomic_read(&shost->host_blocked) > 0) {
 		if (busy)
 			goto starved;
 
 		/*
 		 * unblock after host_blocked iterates to zero
 		 */
-		spin_lock_irq(shost->host_lock);
-		if (--shost->host_blocked != 0) {
-			spin_unlock_irq(shost->host_lock);
+		if (atomic_dec_return(&shost->host_blocked) > 0)
 			goto out_dec;
-		}
-		spin_unlock_irq(shost->host_lock);
 
 		SCSI_LOG_MLQUEUE(3,
 			shost_printk(KERN_INFO, shost,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 54e3dac..deef063 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -584,7 +584,6 @@ static int scsi_sdev_check_buf_bit(const char *buf)
 /*
  * Create the actual show/store functions and data structures.
  */
-sdev_rd_attr (device_blocked, "%d\n");
 sdev_rd_attr (type, "%d\n");
 sdev_rd_attr (scsi_level, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
@@ -600,6 +599,15 @@ sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(device_busy, S_IRUGO, sdev_show_device_busy, NULL);
 
+static ssize_t
+sdev_show_device_blocked(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	return snprintf(buf, 20, "%d\n", atomic_read(&sdev->device_blocked));
+}
+static DEVICE_ATTR(device_blocked, S_IRUGO, sdev_show_device_blocked, NULL);
+
 /*
  * TODO: can we make these symlinks to the block layer ones?
  */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3329901..0f853f2 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -82,6 +82,8 @@ struct scsi_device {
 	struct list_head    same_target_siblings; /* just the devices sharing same target id */
 
 	atomic_t device_busy;		/* commands actually active on LLDD */
+	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
+
 	spinlock_t list_lock;
 	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
 	struct list_head starved_entry;
@@ -180,8 +182,6 @@ struct scsi_device {
 	struct list_head event_list;	/* asserted events */
 	struct work_struct event_work;
 
-	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
-
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
 #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
@@ -291,12 +291,13 @@ struct scsi_target {
 						 * the same target will also. */
 	/* commands actually active on LLD. */
 	atomic_t		target_busy;
+	atomic_t		target_blocked;
+
 	/*
 	 * LLDs should set this in the slave_alloc host template callout.
 	 * If set to zero then there is not limit.
 	 */
 	unsigned int		can_queue;
-	unsigned int		target_blocked;
 	unsigned int		max_target_blocked;
 #define SCSI_DEFAULT_TARGET_BLOCKED	3
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 51f7911..5e8ebc1 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -583,6 +583,8 @@ struct Scsi_Host {
 	struct blk_queue_tag	*bqt;
 
 	atomic_t host_busy;		   /* commands actually active on low-level */
+	atomic_t host_blocked;
+
 	unsigned int host_failed;	   /* commands that failed.
 					      protected by host_lock */
 	unsigned int host_eh_scheduled;    /* EH scheduled without command */
@@ -682,11 +684,6 @@ struct Scsi_Host {
 	struct workqueue_struct *tmf_work_q;
 
 	/*
-	 * Host has rejected a command because it was busy.
-	 */
-	unsigned int host_blocked;
-
-	/*
 	 * Value host_blocked counts down from
 	 */
 	unsigned int max_host_blocked;
-- 
1.9.1

