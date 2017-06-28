From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 40/47] aic7xxx: do not reference scsi command when resetting device
Date: Wed, 28 Jun 2017 10:33:06 +0200
Message-ID: <1498638793-44672-41-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53827 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751559AbdF1Idj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:39 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When sending a device reset we should not take a reference to the
scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 102 ++++++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 72f3007..fe8f675 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -365,7 +365,8 @@ static void ahc_linux_queue_cmd_complete(struct ahc_softc *ahc,
 					 struct scsi_cmnd *cmd);
 static void ahc_linux_freeze_simq(struct ahc_softc *ahc);
 static void ahc_linux_release_simq(struct ahc_softc *ahc);
-static int  ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag);
+static int  ahc_linux_queue_recovery_cmd(struct scsi_device *sdev,
+					 struct scsi_cmnd *cmd);
 static void ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);
 static u_int ahc_linux_user_tagdepth(struct ahc_softc *ahc,
 				     struct ahc_devinfo *devinfo);
@@ -745,7 +746,7 @@ static DEF_SCSI_QCMD(ahc_linux_queue)
 {
 	int error;
 
-	error = ahc_linux_queue_recovery_cmd(cmd, SCB_ABORT);
+	error = ahc_linux_queue_recovery_cmd(cmd->device, cmd);
 	if (error != 0)
 		printk("aic7xxx_abort returns 0x%x\n", error);
 	return (error);
@@ -759,7 +760,7 @@ static DEF_SCSI_QCMD(ahc_linux_queue)
 {
 	int error;
 
-	error = ahc_linux_queue_recovery_cmd(cmd, SCB_DEVICE_RESET);
+	error = ahc_linux_queue_recovery_cmd(cmd->device, NULL);
 	if (error != 0)
 		printk("aic7xxx_dev_reset returns 0x%x\n", error);
 	return (error);
@@ -2050,11 +2051,12 @@ struct scsi_host_template aic7xxx_driver_template = {
 }
 
 static int
-ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
+ahc_linux_queue_recovery_cmd(struct scsi_device *sdev,
+			     struct scsi_cmnd *cmd)
 {
 	struct ahc_softc *ahc;
 	struct ahc_linux_device *dev;
-	struct scb *pending_scb;
+	struct scb *pending_scb = NULL, *scb;
 	u_int  saved_scbptr;
 	u_int  active_scb_index;
 	u_int  last_phase;
@@ -2067,18 +2069,19 @@ struct scsi_host_template aic7xxx_driver_template = {
 	int    disconnected;
 	unsigned long flags;
 
-	pending_scb = NULL;
 	paused = FALSE;
 	wait = FALSE;
-	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
+	ahc = *(struct ahc_softc **)sdev->host->hostdata;
 
-	scmd_printk(KERN_INFO, cmd, "Attempting to queue a%s message\n",
-	       flag == SCB_ABORT ? "n ABORT" : " TARGET RESET");
+	sdev_printk(KERN_INFO, sdev, "Attempting to queue a%s message\n",
+	       cmd ? "n ABORT" : " TARGET RESET");
 
-	printk("CDB:");
-	for (cdb_byte = 0; cdb_byte < cmd->cmd_len; cdb_byte++)
-		printk(" 0x%x", cmd->cmnd[cdb_byte]);
-	printk("\n");
+	if (cmd) {
+		printk("CDB:");
+		for (cdb_byte = 0; cdb_byte < cmd->cmd_len; cdb_byte++)
+			printk(" 0x%x", cmd->cmnd[cdb_byte]);
+		printk("\n");
+	}
 
 	ahc_lock(ahc, &flags);
 
@@ -2089,7 +2092,7 @@ struct scsi_host_template aic7xxx_driver_template = {
 	 * at all, and the system wanted us to just abort the
 	 * command, return success.
 	 */
-	dev = scsi_transport_device_data(cmd->device);
+	dev = scsi_transport_device_data(sdev);
 
 	if (dev == NULL) {
 		/*
@@ -2097,13 +2100,12 @@ struct scsi_host_template aic7xxx_driver_template = {
 		 * so we must not still own the command.
 		 */
 		printk("%s:%d:%d:%d: Is not an active device\n",
-		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       (u8)cmd->device->lun);
+		       ahc_name(ahc), sdev->channel, sdev->id, (u8)sdev->lun);
 		retval = SUCCESS;
 		goto no_cmd;
 	}
 
-	if ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED)) == 0
+	if (cmd && (dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED)) == 0
 	 && ahc_search_untagged_queues(ahc, cmd, cmd->device->id,
 				       cmd->device->channel + 'A',
 				       (u8)cmd->device->lun,
@@ -2118,25 +2120,28 @@ struct scsi_host_template aic7xxx_driver_template = {
 	/*
 	 * See if we can find a matching cmd in the pending list.
 	 */
-	LIST_FOREACH(pending_scb, &ahc->pending_scbs, pending_links) {
-		if (pending_scb->io_ctx == cmd)
+	LIST_FOREACH(scb, &ahc->pending_scbs, pending_links) {
+		if (cmd && scb->io_ctx == cmd) {
+			pending_scb = scb;
 			break;
+		}
 	}
 
-	if (pending_scb == NULL && flag == SCB_DEVICE_RESET) {
-
+	if (!cmd) {
 		/* Any SCB for this device will do for a target reset */
-		LIST_FOREACH(pending_scb, &ahc->pending_scbs, pending_links) {
-		  	if (ahc_match_scb(ahc, pending_scb, scmd_id(cmd),
-					  scmd_channel(cmd) + 'A',
+		LIST_FOREACH(scb, &ahc->pending_scbs, pending_links) {
+			if (ahc_match_scb(ahc, scb, sdev->id,
+					  sdev->channel + 'A',
 					  CAM_LUN_WILDCARD,
-					  SCB_LIST_NULL, ROLE_INITIATOR))
+					  SCB_LIST_NULL, ROLE_INITIATOR)) {
+				pending_scb = scb;
 				break;
+			}
 		}
 	}
 
 	if (pending_scb == NULL) {
-		scmd_printk(KERN_INFO, cmd, "Command not found\n");
+		sdev_printk(KERN_INFO, sdev, "Command not found\n");
 		goto no_cmd;
 	}
 
@@ -2167,22 +2172,22 @@ struct scsi_host_template aic7xxx_driver_template = {
 	ahc_dump_card_state(ahc);
 
 	disconnected = TRUE;
-	if (flag == SCB_ABORT) {
-		if (ahc_search_qinfifo(ahc, cmd->device->id,
-				       cmd->device->channel + 'A',
-				       cmd->device->lun,
+	if (cmd) {
+		if (ahc_search_qinfifo(ahc, sdev->id,
+				       sdev->channel + 'A',
+				       sdev->lun,
 				       pending_scb->hscb->tag,
 				       ROLE_INITIATOR, CAM_REQ_ABORTED,
 				       SEARCH_COMPLETE) > 0) {
 			printk("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
-			       ahc_name(ahc), cmd->device->channel,
-			       cmd->device->id, (u8)cmd->device->lun);
+			       ahc_name(ahc), sdev->channel,
+			       sdev->id, (u8)sdev->lun);
 			retval = SUCCESS;
 			goto done;
 		}
-	} else if (ahc_search_qinfifo(ahc, cmd->device->id,
-				      cmd->device->channel + 'A',
-				      cmd->device->lun,
+	} else if (ahc_search_qinfifo(ahc, sdev->id,
+				      sdev->channel + 'A',
+				      sdev->lun,
 				      pending_scb->hscb->tag,
 				      ROLE_INITIATOR, /*status*/0,
 				      SEARCH_COUNT) > 0) {
@@ -2195,7 +2200,7 @@ struct scsi_host_template aic7xxx_driver_template = {
 		bus_scb = ahc_lookup_scb(ahc, ahc_inb(ahc, SCB_TAG));
 		if (bus_scb == pending_scb)
 			disconnected = FALSE;
-		else if (flag != SCB_ABORT
+		else if (!cmd
 		      && ahc_inb(ahc, SAVED_SCSIID) == pending_scb->hscb->scsiid
 		      && ahc_inb(ahc, SAVED_LUN) == SCB_GET_LUN(pending_scb))
 			disconnected = FALSE;
@@ -2215,18 +2220,18 @@ struct scsi_host_template aic7xxx_driver_template = {
 	saved_scsiid = ahc_inb(ahc, SAVED_SCSIID);
 	if (last_phase != P_BUSFREE
 	 && (pending_scb->hscb->tag == active_scb_index
-	  || (flag == SCB_DEVICE_RESET
-	   && SCSIID_TARGET(ahc, saved_scsiid) == scmd_id(cmd)))) {
+	  || (!cmd && SCSIID_TARGET(ahc, saved_scsiid) == sdev->id))) {
 
 		/*
 		 * We're active on the bus, so assert ATN
 		 * and hope that the target responds.
 		 */
 		pending_scb = ahc_lookup_scb(ahc, active_scb_index);
-		pending_scb->flags |= SCB_RECOVERY_SCB|flag;
+		pending_scb->flags |= SCB_RECOVERY_SCB;
+		pending_scb->flags |= cmd ? SCB_ABORT : SCB_DEVICE_RESET;
 		ahc_outb(ahc, MSG_OUT, HOST_MSG);
 		ahc_outb(ahc, SCSISIGO, last_phase|ATNO);
-		scmd_printk(KERN_INFO, cmd, "Device is active, asserting ATN\n");
+		sdev_printk(KERN_INFO, sdev, "Device is active, asserting ATN\n");
 		wait = TRUE;
 	} else if (disconnected) {
 
@@ -2247,7 +2252,8 @@ struct scsi_host_template aic7xxx_driver_template = {
 		 * an unsolicited reselection occurred.
 		 */
 		pending_scb->hscb->control |= MK_MESSAGE|DISCONNECTED;
-		pending_scb->flags |= SCB_RECOVERY_SCB|flag;
+		pending_scb->flags |= SCB_RECOVERY_SCB;
+		pending_scb->flags |= cmd ? SCB_ABORT : SCB_DEVICE_RESET;
 
 		/*
 		 * Remove any cached copy of this SCB in the
@@ -2256,9 +2262,9 @@ struct scsi_host_template aic7xxx_driver_template = {
 		 * same element in the SCB, SCB_NEXT, for
 		 * both the qinfifo and the disconnected list.
 		 */
-		ahc_search_disc_list(ahc, cmd->device->id,
-				     cmd->device->channel + 'A',
-				     cmd->device->lun, pending_scb->hscb->tag,
+		ahc_search_disc_list(ahc, sdev->id,
+				     sdev->channel + 'A',
+				     sdev->lun, pending_scb->hscb->tag,
 				     /*stop_on_first*/TRUE,
 				     /*remove*/TRUE,
 				     /*save_state*/FALSE);
@@ -2281,9 +2287,9 @@ struct scsi_host_template aic7xxx_driver_template = {
 		 * so we are the next SCB for this target
 		 * to run.
 		 */
-		ahc_search_qinfifo(ahc, cmd->device->id,
-				   cmd->device->channel + 'A',
-				   cmd->device->lun, SCB_LIST_NULL,
+		ahc_search_qinfifo(ahc, sdev->id,
+				   sdev->channel + 'A',
+				   (u8)sdev->lun, SCB_LIST_NULL,
 				   ROLE_INITIATOR, CAM_REQUEUE_REQ,
 				   SEARCH_COMPLETE);
 		ahc_qinfifo_requeue_tail(ahc, pending_scb);
@@ -2292,7 +2298,7 @@ struct scsi_host_template aic7xxx_driver_template = {
 		printk("Device is disconnected, re-queuing SCB\n");
 		wait = TRUE;
 	} else {
-		scmd_printk(KERN_INFO, cmd, "Unable to deliver message\n");
+		sdev_printk(KERN_INFO, sdev, "Unable to deliver message\n");
 		retval = FAILED;
 		goto done;
 	}
-- 
1.8.5.6
