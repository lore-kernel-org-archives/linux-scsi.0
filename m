Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4649C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387774AbiEBVmt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387733AbiEBVmI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:42:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AA0E0DA
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:38:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0FC191F8A4;
        Mon,  2 May 2022 21:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651527513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qPWzcHzIE2TX20L3KVEAvXUOQWic8O9NXyXfds0Y0ss=;
        b=F+hTola2yAmlh0KXvr0gsb3zzhtU2ZfhXVukJ5xrB2S4OwU7bmx4dw/lAz9omRj+jGeIxc
        EVVjJVPv1sgsSSF2axEkjpdgIkA7oMEBiofjDdQ18AgHaBAAMvrKSe2Wa6eyGrkwZ7fFT4
        g94fJV0UqZV5tTvyuOYxsHtJr6A/qYc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651527513;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qPWzcHzIE2TX20L3KVEAvXUOQWic8O9NXyXfds0Y0ss=;
        b=kY/jfEc40Y1GwW3DtZjKWxFWrDtkvUtz8+w8kUFvDjEnHM9SWjBWdLiOG4oHZNbQrN1wbL
        Ft4NINPEW8vbZ8BA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 0B2CD2C15D;
        Mon,  2 May 2022 21:38:33 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 090D25194112; Mon,  2 May 2022 23:38:33 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 15/24] aic7xxx: do not reference scsi command when resetting device
Date:   Mon,  2 May 2022 23:38:11 +0200
Message-Id: <20220502213820.3187-16-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502213820.3187-1-hare@suse.de>
References: <20220502213820.3187-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When sending a device reset we should not take a reference to the
scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 102 +++++++++++++++--------------
 1 file changed, 54 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 85fe8808399f..0ad429b7ebcf 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -366,7 +366,8 @@ static void ahc_linux_queue_cmd_complete(struct ahc_softc *ahc,
 					 struct scsi_cmnd *cmd);
 static void ahc_linux_freeze_simq(struct ahc_softc *ahc);
 static void ahc_linux_release_simq(struct ahc_softc *ahc);
-static int  ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag);
+static int  ahc_linux_queue_recovery_cmd(struct scsi_device *sdev,
+					 struct scsi_cmnd *cmd);
 static void ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);
 static u_int ahc_linux_user_tagdepth(struct ahc_softc *ahc,
 				     struct ahc_devinfo *devinfo);
@@ -728,7 +729,7 @@ ahc_linux_abort(struct scsi_cmnd *cmd)
 {
 	int error;
 
-	error = ahc_linux_queue_recovery_cmd(cmd, SCB_ABORT);
+	error = ahc_linux_queue_recovery_cmd(cmd->device, cmd);
 	if (error != SUCCESS)
 		printk("aic7xxx_abort returns 0x%x\n", error);
 	return (error);
@@ -742,7 +743,7 @@ ahc_linux_dev_reset(struct scsi_cmnd *cmd)
 {
 	int error;
 
-	error = ahc_linux_queue_recovery_cmd(cmd, SCB_DEVICE_RESET);
+	error = ahc_linux_queue_recovery_cmd(cmd->device, NULL);
 	if (error != SUCCESS)
 		printk("aic7xxx_dev_reset returns 0x%x\n", error);
 	return (error);
@@ -2034,11 +2035,12 @@ ahc_linux_release_simq(struct ahc_softc *ahc)
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
@@ -2051,18 +2053,19 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
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
 
@@ -2073,7 +2076,7 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 	 * at all, and the system wanted us to just abort the
 	 * command, return success.
 	 */
-	dev = scsi_transport_device_data(cmd->device);
+	dev = scsi_transport_device_data(sdev);
 
 	if (dev == NULL) {
 		/*
@@ -2081,13 +2084,12 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
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
@@ -2102,25 +2104,28 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
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
-			if (ahc_match_scb(ahc, pending_scb, scmd_id(cmd),
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
 
@@ -2151,22 +2156,22 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
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
@@ -2179,7 +2184,7 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 		bus_scb = ahc_lookup_scb(ahc, ahc_inb(ahc, SCB_TAG));
 		if (bus_scb == pending_scb)
 			disconnected = FALSE;
-		else if (flag != SCB_ABORT
+		else if (!cmd
 		      && ahc_inb(ahc, SAVED_SCSIID) == pending_scb->hscb->scsiid
 		      && ahc_inb(ahc, SAVED_LUN) == SCB_GET_LUN(pending_scb))
 			disconnected = FALSE;
@@ -2199,18 +2204,18 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
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
 
@@ -2231,7 +2236,8 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 		 * an unsolicited reselection occurred.
 		 */
 		pending_scb->hscb->control |= MK_MESSAGE|DISCONNECTED;
-		pending_scb->flags |= SCB_RECOVERY_SCB|flag;
+		pending_scb->flags |= SCB_RECOVERY_SCB;
+		pending_scb->flags |= cmd ? SCB_ABORT : SCB_DEVICE_RESET;
 
 		/*
 		 * Remove any cached copy of this SCB in the
@@ -2240,9 +2246,9 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
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
@@ -2265,9 +2271,9 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
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
@@ -2276,7 +2282,7 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 		printk("Device is disconnected, re-queuing SCB\n");
 		wait = TRUE;
 	} else {
-		scmd_printk(KERN_INFO, cmd, "Unable to deliver message\n");
+		sdev_printk(KERN_INFO, sdev, "Unable to deliver message\n");
 		retval = FAILED;
 		goto done;
 	}
-- 
2.29.2

