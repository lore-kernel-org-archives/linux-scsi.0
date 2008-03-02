From: michaelc@cs.wisc.edu
Subject: [PATCH 1/9] scsi: Add helper code so transport classes/driver can control queueing
Date: Sun,  2 Mar 2008 03:03:14 -0600
Message-ID: <1204448602-5435-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbYCBJEJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 04:04:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, david.somayajulu@qlogic.com, andrew.vasquez@qlogic.com, James.Smart@Emulex.com, Eric.Moore@lsil.com
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

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi.c        |   11 +++++--
 drivers/scsi/scsi_lib.c    |   72 +++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_scan.c   |    1 +
 include/scsi/scsi.h        |    1 +
 include/scsi/scsi_device.h |   10 ++++++
 5 files changed, 84 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index fecba05..a26f976 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -628,9 +628,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
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
@@ -729,6 +732,7 @@ static struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 void scsi_finish_command(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
+	struct scsi_target *starget = scsi_target(sdev);
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_driver *drv;
 	unsigned int good_bytes;
@@ -744,6 +748,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 	 * XXX(hch): What about locking?
          */
         shost->host_blocked = 0;
+	starget->target_blocked = 0;
         sdev->device_blocked = 0;
 
 	/*
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba21d97..92b4f0e 100644
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
@@ -1295,6 +1305,51 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
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
+			SCSI_LOG_MLQUEUE(3,
+				   starget_printk(KERN_INFO, starget,
+				   "unblocking target at zero depth\n"));
+		} else {
+			blk_plug_device(sdev->request_queue);
+			return 0;
+		}
+	}
+
+	if ((starget->can_queue > 0 &&
+	     starget->target_busy >= starget->can_queue) ||
+	     starget->target_blocked) {
+		if (list_empty(&sdev->starved_entry))
+			list_add_tail(&sdev->starved_entry,
+				      &shost->starved_list);
+		return 0;
+	}
+
+	return 1;
+}
+
 /*
  * scsi_host_queue_ready: if we can send requests to shost, return 1 else
  * return 0. We must end up running the queue again whenever 0 is
@@ -1342,6 +1397,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 {
 	struct scsi_cmnd *cmd = req->special;
 	struct scsi_device *sdev = cmd->device;
+	struct scsi_target *starget = scsi_target(sdev);
 	struct Scsi_Host *shost = sdev->host;
 
 	blkdev_dequeue_request(req);
@@ -1365,6 +1421,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 	spin_unlock(sdev->request_queue->queue_lock);
 	spin_lock(shost->host_lock);
 	shost->host_busy++;
+	starget->target_busy++;
 	spin_unlock(shost->host_lock);
 	spin_lock(sdev->request_queue->queue_lock);
 
@@ -1478,14 +1535,13 @@ static void scsi_request_fn(struct request_queue *q)
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
index 1dc165a..c9f7b74 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -396,6 +396,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 		shost->host_no, channel, id);
 	starget->id = id;
 	starget->channel = channel;
+	starget->can_queue = 0;
 	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
 	starget->state = STARGET_RUNNING;
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
index ab7acbe..f8e4184 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -205,6 +205,16 @@ struct scsi_target {
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

