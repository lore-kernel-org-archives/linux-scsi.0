From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.14-rc1 3/13] ieee1394/sbp2: fixes for hot-unplug and
 module unloading
Date: Sun, 18 Sep 2005 01:11:42 +0200 (CEST)
Message-ID: <200509172311.j8HNBicH030417@einhorn.in-berlin.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:24256 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751217AbVIQXMJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2005 19:12:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

To: linux1394-devel@lists.sourceforge.net
cc: linux-scsi@vger.kernel.org, bcollins@debian.org, scjody@steamballoon.com, 
    dan@dennedy.org, James.Bottomley@SteelEye.com
MIME-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii

sbp2:
fixes for deadlocks of the ieee1394 and scsi subsystems and long delays in
futile error recovery attempts when SBP-2 devices are removed or drivers are
unloaded.

 - Complete commands quickly with DID_NO_CONNECT if the 1394 node is gone or if
   the 1394 low-level driver was unloaded.
 - Skip unnecessary work in the eh_abort_handler and eh_device_reset_handler if
   the node or 1394 low-level driver is gone. 
 - Let scsi's high-level shut down gracefully when sbp2 is being unloaded or
   detached from the 1394 unit. A call to scsi_remove_device is added for this
   purpose, which requires us to store a scsi_device pointer.
 - scsi_device pointer is obtained from slave_alloc hook and cleared by
   slave_destroy. This avoids usage of the pointer after the scsi device was
   deleted e.g. by the user via scsi_mod's sysfs interface.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

 drivers/ieee1394/sbp2.c |   96 +++++++++++++++++++++++++++++-------------------
 1 files changed, 58 insertions(+), 38 deletions(-)

--- linux-2.6.14-rc1.orig/drivers/ieee1394/sbp2.c	2005-09-13 05:12:09.000000000 +0200
+++ linux-2.6.14-rc1/drivers/ieee1394/sbp2.c	2005-09-17 16:14:30.000000000 +0200
@@ -596,6 +596,14 @@ static void sbp2util_mark_command_comple
 	spin_unlock_irqrestore(&scsi_id->sbp2_command_orb_lock, flags);
 }
 
+/*
+ * Is scsi_id valid? Is the 1394 node still present?
+ */
+static inline int sbp2util_node_is_available(struct scsi_id_instance_data *scsi_id)
+{
+	return scsi_id && scsi_id->ne && !scsi_id->ne->in_limbo;
+}
+
 

 
 /*********************************************
@@ -631,11 +639,23 @@ static int sbp2_remove(struct device *de
 {
 	struct unit_directory *ud;
 	struct scsi_id_instance_data *scsi_id;
+	struct scsi_device *sdev;
 
 	SBP2_DEBUG("sbp2_remove");
 
 	ud = container_of(dev, struct unit_directory, device);
 	scsi_id = ud->device.driver_data;
+	if (!scsi_id)
+		return 0;
+
+	/* Trigger shutdown functions in scsi's highlevel. */
+	if (scsi_id->scsi_host)
+		scsi_unblock_requests(scsi_id->scsi_host);
+	sdev = scsi_id->sdev;
+	if (sdev) {
+		scsi_id->sdev = NULL;
+		scsi_remove_device(sdev);
+	}
 
 	sbp2_logout_device(scsi_id);
 	sbp2_remove_device(scsi_id);
@@ -2473,37 +2493,26 @@ static int sbp2scsi_queuecommand(struct 
 	struct scsi_id_instance_data *scsi_id =
 		(struct scsi_id_instance_data *)SCpnt->device->host->hostdata[0];
 	struct sbp2scsi_host_info *hi;
+	int result = DID_NO_CONNECT << 16;
 
 	SBP2_DEBUG("sbp2scsi_queuecommand");
 
-	/*
-	 * If scsi_id is null, it means there is no device in this slot,
-	 * so we should return selection timeout.
-	 */
-	if (!scsi_id) {
-		SCpnt->result = DID_NO_CONNECT << 16;
-		done (SCpnt);
-		return 0;
-	}
+	if (!sbp2util_node_is_available(scsi_id))
+		goto done;
 
 	hi = scsi_id->hi;
 
 	if (!hi) {
 		SBP2_ERR("sbp2scsi_host_info is NULL - this is bad!");
-		SCpnt->result = DID_NO_CONNECT << 16;
-		done (SCpnt);
-		return(0);
+		goto done;
 	}
 
 	/*
 	 * Until we handle multiple luns, just return selection time-out
 	 * to any IO directed at non-zero LUNs
 	 */
-	if (SCpnt->device->lun) {
-		SCpnt->result = DID_NO_CONNECT << 16;
-		done (SCpnt);
-		return(0);
-	}
+	if (SCpnt->device->lun)
+		goto done;
 
 	/*
 	 * Check for request sense command, and handle it here
@@ -2514,7 +2523,7 @@ static int sbp2scsi_queuecommand(struct 
 		memcpy(SCpnt->request_buffer, SCpnt->sense_buffer, SCpnt->request_bufflen);
 		memset(SCpnt->sense_buffer, 0, sizeof(SCpnt->sense_buffer));
 		sbp2scsi_complete_command(scsi_id, SBP2_SCSI_STATUS_GOOD, SCpnt, done);
-		return(0);
+		return 0;
 	}
 
 	/*
@@ -2522,9 +2531,8 @@ static int sbp2scsi_queuecommand(struct 
 	 */
 	if (!hpsb_node_entry_valid(scsi_id->ne)) {
 		SBP2_ERR("Bus reset in progress - rejecting command");
-		SCpnt->result = DID_BUS_BUSY << 16;
-		done (SCpnt);
-		return(0);
+		result = DID_BUS_BUSY << 16;
+		goto done;
 	}
 
 	/*
@@ -2535,8 +2543,12 @@ static int sbp2scsi_queuecommand(struct 
 		sbp2scsi_complete_command(scsi_id, SBP2_SCSI_STATUS_SELECTION_TIMEOUT,
 					  SCpnt, done);
 	}
+	return 0;
 
-	return(0);
+done:
+	SCpnt->result = result;
+	done(SCpnt);
+	return 0;
 }
 
 /*
@@ -2683,14 +2695,27 @@ static void sbp2scsi_complete_command(st
 }
 
 
-static int sbp2scsi_slave_configure (struct scsi_device *sdev)
+static int sbp2scsi_slave_alloc(struct scsi_device *sdev)
 {
-	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
+	((struct scsi_id_instance_data *)sdev->host->hostdata[0])->sdev = sdev;
+	return 0;
+}
+
 
+static int sbp2scsi_slave_configure(struct scsi_device *sdev)
+{
+	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
 	return 0;
 }
 
 
+static void sbp2scsi_slave_destroy(struct scsi_device *sdev)
+{
+	((struct scsi_id_instance_data *)sdev->host->hostdata[0])->sdev = NULL;
+	return;
+}
+
+
 /*
  * Called by scsi stack when something has really gone wrong.  Usually
  * called when a command has timed-out for some reason.
@@ -2705,7 +2730,7 @@ static int sbp2scsi_abort(struct scsi_cm
 	SBP2_ERR("aborting sbp2 command");
 	scsi_print_command(SCpnt);
 
-	if (scsi_id) {
+	if (sbp2util_node_is_available(scsi_id)) {
 
 		/*
 		 * Right now, just return any matching command structures
@@ -2742,31 +2767,24 @@ static int sbp2scsi_abort(struct scsi_cm
 /*
  * Called by scsi stack when something has really gone wrong.
  */
-static int __sbp2scsi_reset(struct scsi_cmnd *SCpnt)
+static int sbp2scsi_reset(struct scsi_cmnd *SCpnt)
 {
 	struct scsi_id_instance_data *scsi_id =
 		(struct scsi_id_instance_data *)SCpnt->device->host->hostdata[0];
+	unsigned long flags;
 
 	SBP2_ERR("reset requested");
 
-	if (scsi_id) {
+	spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
+
+	if (sbp2util_node_is_available(scsi_id)) {
 		SBP2_ERR("Generating sbp2 fetch agent reset");
 		sbp2_agent_reset(scsi_id, 0);
 	}
 
-	return(SUCCESS);
-}
-
-static int sbp2scsi_reset(struct scsi_cmnd *SCpnt)
-{
-	unsigned long flags;
-	int rc;
-
-	spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
-	rc = __sbp2scsi_reset(SCpnt);
 	spin_unlock_irqrestore(SCpnt->device->host->host_lock, flags);
 
-	return rc;
+	return SUCCESS;
 }
 
 static const char *sbp2scsi_info (struct Scsi_Host *host)
@@ -2817,7 +2835,9 @@ static struct scsi_host_template scsi_dr
 	.eh_device_reset_handler =	sbp2scsi_reset,
 	.eh_bus_reset_handler =		sbp2scsi_reset,
 	.eh_host_reset_handler =	sbp2scsi_reset,
+	.slave_alloc =			sbp2scsi_slave_alloc,
 	.slave_configure =		sbp2scsi_slave_configure,
+	.slave_destroy =		sbp2scsi_slave_destroy,
 	.this_id =			-1,
 	.sg_tablesize =			SG_ALL,
 	.use_clustering =		ENABLE_CLUSTERING,

