From: michaelc@cs.wisc.edu
Subject: [PATCH 1/2] scsi: Add helper code so transport classes/driver can control queueing
Date: Mon, 28 Apr 2008 23:22:16 -0500
Message-ID: <1209442937-15130-2-git-send-email-michaelc@cs.wisc.edu>
References: <1209442937-15130-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYD2EWW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2008 00:22:22 -0400
In-Reply-To: <1209442937-15130-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

SCSI-ml manages the queueing limits for the device and host, but
does not do so at the target level. However something something similar
can come in userful when a driver is transitioning a transport object to
the the blocked state, becuase at that time we do not want to queue
io and we do not want the queuecommand to be called again.

The patch adds code similar to the exisiting SCSI_ML_*BUSY handlers.
You can now return SCSI_MLQUEUE_TARGET_BUSY when we hit
a transport level queueing issue like the hw cannot allocate some
resource at the iscsi session/connection level, or the target has temporarily
closed or shrunk the queueing window, or if we are transitioning
to the blocked state.

For bnx2i we will also need to be able to limit queueing at this level.
bnx2i will hook into libiscsi, but will allocate a scsi host per
netdevice/hba, so unlike pure software iscsi/iser which is allocating
a host per session, it cannot set the scsi_host->can_queue and return
SCSI_MLQUEUE_HOST_BUSY to reflect queueing limits on the transport.

The iscsi class/driver can also set a scsi_target->can_queue value which
reflects the max commands the driver/class can support. For iscsi this
reflects the number of commands we can support for each session due to
session/connection hw limits, driver limits, and to also reflect the
session/targets's queueing window.

Changes:
v1 - initial patch.
v2 - Fix scsi_run_queue handling of multiple blocked targets.
Previously we would break from the main loop if a device was added back on
the starved list. We now run over the list and check if any target is
blocked.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi.c        |   11 +++-
 drivers/scsi/scsi_lib.c    |  104 +++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/scsi_scan.c   |    1 +
 include/scsi/scsi.h        |    1 +
 include/scsi/scsi_device.h |   10 ++++
 5 files changed, 108 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index dc36321..484b639 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -731,9 +731,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	if (rtn) {
 		if (scsi_delete_timer(cmd)) {
 			atomic_inc(&cmd->device->iodone_cnt);
-			scsi_queue_insert(cmd,
-					  (rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
-					  rtn : SCSI_MLQUEUE_HOST_BUSY);
+
+			if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
+			    rtn != SCSI_MLQUEUE_TARGET_BUSY)
+				rtn = SCSI_MLQUEUE_HOST_BUSY;
+
+			scsi_queue_insert(cmd, rtn);
 		}
 		SCSI_LOG_MLQUEUE(3,
 		    printk("queuecommand : request rejected\n"));
@@ -832,6 +835,7 @@ static struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 void scsi_finish_command(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
+	struct scsi_target *starget = scsi_target(sdev);
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_driver *drv;
 	unsigned int good_bytes;
@@ -847,6 +851,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 	 * XXX(hch): What about locking?
          */
         shost->host_blocked = 0;
+	starget->target_blocked = 0;
         sdev->device_blocked = 0;
 
 	/*
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 67f412b..cfd6e75 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -114,6 +114,7 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_device *device = cmd->device;
+	struct scsi_target *starget = scsi_target(device);
 	struct request_queue *q = device->request_queue;
 	unsigned long flags;
 
@@ -133,10 +134,17 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	 * if a command is requeued with no other commands outstanding
 	 * either for the device or for the host.
 	 */
-	if (reason == SCSI_MLQUEUE_HOST_BUSY)
+	switch (reason) {
+	case SCSI_MLQUEUE_HOST_BUSY:
 		host->host_blocked = host->max_host_blocked;
-	else if (reason == SCSI_MLQUEUE_DEVICE_BUSY)
+		break;
+	case SCSI_MLQUEUE_DEVICE_BUSY:
 		device->device_blocked = device->max_device_blocked;
+		break;
+	case SCSI_MLQUEUE_TARGET_BUSY:
+		starget->target_blocked = starget->max_target_blocked;
+		break;
+	}
 
 	/*
 	 * Decrement the counters, since these commands are no longer
@@ -451,10 +459,12 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 void scsi_device_unbusy(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
+	struct scsi_target *starget = scsi_target(sdev);
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_busy--;
+	starget->target_busy--;
 	if (unlikely(scsi_host_in_recovery(shost) &&
 		     (shost->host_failed || shost->host_eh_scheduled)))
 		scsi_eh_wakeup(shost);
@@ -510,6 +520,13 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
+static inline int scsi_target_is_busy(struct scsi_target *starget)
+{
+	return ((starget->can_queue > 0 &&
+		 starget->target_busy >= starget->can_queue) ||
+		 starget->target_blocked);
+}
+
 /*
  * Function:	scsi_run_queue()
  *
@@ -524,7 +541,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
  */
 static void scsi_run_queue(struct request_queue *q)
 {
-	struct scsi_device *sdev = q->queuedata;
+	struct scsi_device *starved_head = NULL, *sdev = q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
 	unsigned long flags;
 
@@ -548,6 +565,21 @@ static void scsi_run_queue(struct request_queue *q)
 		 */
 		sdev = list_entry(shost->starved_list.next,
 					  struct scsi_device, starved_entry);
+		/*
+		 * The *queue_ready functions can add a device back onto the
+		 * starved list's tail, so we must check for a infinite loop.
+		 */
+		if (sdev == starved_head)
+			break;
+		if (!starved_head)
+			starved_head = sdev;
+
+		if (scsi_target_is_busy(scsi_target(sdev))) {
+			list_move_tail(&sdev->starved_entry,
+				       &shost->starved_list);
+			continue;
+		}
+
 		list_del_init(&sdev->starved_entry);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 
@@ -562,13 +594,6 @@ static void scsi_run_queue(struct request_queue *q)
 			blk_run_queue(sdev->request_queue);
 
 		spin_lock_irqsave(shost->host_lock, flags);
-		if (unlikely(!list_empty(&sdev->starved_entry)))
-			/*
-			 * sdev lost a race, and was put back on the
-			 * starved list. This is unlikely but without this
-			 * in theory we could loop forever.
-			 */
-			break;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
@@ -1293,6 +1318,52 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 	return 1;
 }
 
+
+/*
+ * scsi_target_queue_ready: checks if there we can send commands to target
+ * @sdev: scsi device on starget to check.
+ *
+ * Called with the host lock held.
+ */
+static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
+					   struct scsi_device *sdev)
+{
+	struct scsi_target *starget = scsi_target(sdev);
+
+	if (starget->single_lun) {
+		if (starget->starget_sdev_user &&
+		    starget->starget_sdev_user != sdev)
+			return 0;
+		starget->starget_sdev_user = sdev;
+	}
+
+	if (starget->target_busy == 0 && starget->target_blocked) {
+		/*
+		 * unblock after target_blocked iterates to zero
+		 */
+		if (--starget->target_blocked == 0) {
+			SCSI_LOG_MLQUEUE(3, starget_printk(KERN_INFO, starget,
+					 "unblocking target at zero depth\n"));
+		} else {
+			blk_plug_device(sdev->request_queue);
+			return 0;
+		}
+	}
+
+	if (scsi_target_is_busy(starget)) {
+		if (list_empty(&sdev->starved_entry)) {
+			list_add_tail(&sdev->starved_entry,
+				      &shost->starved_list);
+			return 0;
+		}
+	}
+
+	/* We're OK to process the command, so we can't be starved */
+	if (!list_empty(&sdev->starved_entry))
+		list_del_init(&sdev->starved_entry);
+	return 1;
+}
+
 /*
  * scsi_host_queue_ready: if we can send requests to shost, return 1 else
  * return 0. We must end up running the queue again whenever 0 is
@@ -1340,6 +1411,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 {
 	struct scsi_cmnd *cmd = req->special;
 	struct scsi_device *sdev = cmd->device;
+	struct scsi_target *starget = scsi_target(sdev);
 	struct Scsi_Host *shost = sdev->host;
 
 	blkdev_dequeue_request(req);
@@ -1363,6 +1435,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 	spin_unlock(sdev->request_queue->queue_lock);
 	spin_lock(shost->host_lock);
 	shost->host_busy++;
+	starget->target_busy++;
 	spin_unlock(shost->host_lock);
 	spin_lock(sdev->request_queue->queue_lock);
 
@@ -1476,14 +1549,13 @@ static void scsi_request_fn(struct request_queue *q)
 		}
 		spin_lock(shost->host_lock);
 
+		if (!scsi_target_queue_ready(shost, sdev))
+			goto not_ready;
+
 		if (!scsi_host_queue_ready(q, shost, sdev))
 			goto not_ready;
-		if (scsi_target(sdev)->single_lun) {
-			if (scsi_target(sdev)->starget_sdev_user &&
-			    scsi_target(sdev)->starget_sdev_user != sdev)
-				goto not_ready;
-			scsi_target(sdev)->starget_sdev_user = sdev;
-		}
+
+		scsi_target(sdev)->target_busy++;
 		shost->host_busy++;
 
 		/*
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index fcd7455..c991106 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -419,6 +419,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	dev->type = &scsi_target_type;
 	starget->id = id;
 	starget->channel = channel;
+	starget->can_queue = 0;
 	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
 	starget->state = STARGET_CREATED;
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 1f74bcd..2160b36 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -381,6 +381,7 @@ struct scsi_lun {
 #define SCSI_MLQUEUE_HOST_BUSY   0x1055
 #define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
 #define SCSI_MLQUEUE_EH_RETRY    0x1057
+#define SCSI_MLQUEUE_TARGET_BUSY 0x1058
 
 /*
  *  Use these to separate status msg and our bytes
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f6a9fe0..06b7b59 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -206,6 +206,16 @@ struct scsi_target {
 						 * for the device at a time. */
 	unsigned int		pdt_1f_for_no_lun;	/* PDT = 0x1f */
 						/* means no lun present */
+	/* commands actually active on LLD. protected by host lock. */
+	unsigned int		target_busy;
+	/*
+	 * LLDs should set this in the slave_alloc host template callout.
+	 * If set to zero then there is not limit.
+	 */
+	unsigned int		can_queue;
+	unsigned int		target_blocked;
+	unsigned int		max_target_blocked;
+#define SCSI_DEFAULT_TARGET_BLOCKED	3
 
 	char			scsi_level;
 	struct execute_work	ew;
-- 
1.5.4.1

