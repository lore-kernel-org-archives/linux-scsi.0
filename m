From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/07] aic79xx: Update error recovery
Date: Wed, 08 Mar 2006 12:58:16 +0100
Message-ID: <440EC6D8.9020502@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020202080204040608050800"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:5606 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751689AbWCHL6R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 06:58:17 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 4089C1D853
	for <linux-scsi@vger.kernel.org>; Wed,  8 Mar 2006 12:58:16 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020202080204040608050800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

This patch updates the error recovery. Routines for TARGET RESET
and ABORT COMMAND are split up as the logic is quite dissimilar.

Signed-off-by: Hannes Reinecke <hare@suse.de>

--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------020202080204040608050800
Content-Type: text/plain;
 name="04-aic79xx-update-error-handling.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04-aic79xx-update-error-handling.txt"

[PATCH 04/07] aic79xx: Update error recovery

This patch updates the error recovery. Routines for TARGET RESET
and ABORT COMMAND are split up as the logic is quite dissimilar.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---
 aic79xx_osm.c |  323 +++++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 200 insertions(+), 123 deletions(-)

--- a/drivers/scsi/aic7xxx/aic79xx_osm.c	2006-03-08 12:37:27.000000000 +0100
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c	2006-03-08 12:39:25.000000000 +0100
@@ -373,7 +373,7 @@ static void ahd_linux_handle_scsi_status
 					 struct scb *);
 static void ahd_linux_queue_cmd_complete(struct ahd_softc *ahd,
 					 struct scsi_cmnd *cmd);
-static int  ahd_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag);
+static int ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd);
 static void ahd_linux_initialize_scsi_bus(struct ahd_softc *ahd);
 static u_int ahd_linux_user_tagdepth(struct ahd_softc *ahd,
 				     struct ahd_devinfo *devinfo);
@@ -648,10 +648,9 @@ static int
 ahd_linux_abort(struct scsi_cmnd *cmd)
 {
 	int error;
+	
+	error = ahd_linux_queue_abort_cmd(cmd);
 
-	error = ahd_linux_queue_recovery_cmd(cmd, SCB_ABORT);
-	if (error != 0)
-		printf("aic79xx_abort returns 0x%x\n", error);
 	return error;
 }
 
@@ -661,12 +660,97 @@ ahd_linux_abort(struct scsi_cmnd *cmd)
 static int
 ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 {
-	int error;
+	struct ahd_softc *ahd;
+	struct ahd_linux_device *dev;
+	struct scb *reset_scb;
+	u_int  cdb_byte;
+	int    retval = SUCCESS;
+	int    paused;
+	int    wait;
+	struct	ahd_initiator_tinfo *tinfo;
+	struct	ahd_tmode_tstate *tstate;
+	unsigned long flags;
+	DECLARE_COMPLETION(done);
 
-	error = ahd_linux_queue_recovery_cmd(cmd, SCB_DEVICE_RESET);
-	if (error != 0)
-		printf("aic79xx_dev_reset returns 0x%x\n", error);
-	return error;
+	reset_scb = NULL;
+	paused = FALSE;
+	wait = FALSE;
+	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
+
+	scmd_printk(KERN_INFO, cmd,
+		    "Attempting to queue a TARGET RESET message:");
+
+	printf("CDB:");
+	for (cdb_byte = 0; cdb_byte < cmd->cmd_len; cdb_byte++)
+		printf(" 0x%x", cmd->cmnd[cdb_byte]);
+	printf("\n");
+
+	/*
+	 * Determine if we currently own this command.
+	 */
+	dev = scsi_transport_device_data(cmd->device);
+
+	if (dev == NULL) {
+		/*
+		 * No target device for this command exists,
+		 * so we must not still own the command.
+		 */
+		scmd_printk(KERN_INFO, cmd, "Is not an active device\n");
+		return SUCCESS;
+	}
+
+	/*
+	 * Generate us a new SCB
+	 */
+	reset_scb = ahd_get_scb(ahd, AHD_NEVER_COL_IDX);
+	if (!reset_scb) {
+		scmd_printk(KERN_INFO, cmd, "No SCB available\n");
+		return FAILED;
+	}
+
+	tinfo = ahd_fetch_transinfo(ahd, 'A', ahd->our_id,
+				    cmd->device->id, &tstate);
+	reset_scb->io_ctx = cmd;
+	reset_scb->platform_data->dev = dev;
+	reset_scb->sg_count = 0;
+	ahd_set_residual(reset_scb, 0);
+	ahd_set_sense_residual(reset_scb, 0);
+	reset_scb->platform_data->xfer_len = 0;
+	reset_scb->hscb->control = 0;
+	reset_scb->hscb->scsiid = BUILD_SCSIID(ahd,cmd);
+	reset_scb->hscb->lun = cmd->device->lun;
+	reset_scb->hscb->cdb_len = 0;
+	reset_scb->hscb->task_management = SIU_TASKMGMT_LUN_RESET;
+	reset_scb->flags |= SCB_DEVICE_RESET|SCB_RECOVERY_SCB|SCB_ACTIVE;
+	if ((tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ) != 0) {
+		reset_scb->flags |= SCB_PACKETIZED;
+	} else {
+		reset_scb->hscb->control |= MK_MESSAGE;
+	}
+	dev->openings--;
+	dev->active++;
+	dev->commands_issued++;
+
+	ahd_lock(ahd, &flags);
+
+	LIST_INSERT_HEAD(&ahd->pending_scbs, reset_scb, pending_links);
+	ahd_queue_scb(ahd, reset_scb);
+
+	ahd->platform_data->eh_done = &done;
+	ahd_unlock(ahd, &flags);
+
+	printf("%s: Device reset code sleeping\n", ahd_name(ahd));
+	if (!wait_for_completion_timeout(&done, 5 * HZ)) {
+		ahd_lock(ahd, &flags);
+		ahd->platform_data->eh_done = NULL;
+		ahd_unlock(ahd, &flags);
+		printf("%s: Device reset timer expired (active %d)\n",
+		       ahd_name(ahd), dev->active);
+		retval = FAILED;
+	}
+	printf("%s: Device reset returning 0x%x\n", ahd_name(ahd), retval);
+
+	return (retval);
 }
 
 /*
@@ -1954,72 +2038,108 @@ ahd_linux_handle_scsi_status(struct ahd_
 static void
 ahd_linux_queue_cmd_complete(struct ahd_softc *ahd, struct scsi_cmnd *cmd)
 {
+	int status;
+	int new_status = DID_OK;
+	int do_fallback = 0;
+	int scsi_status;
+
 	/*
 	 * Map CAM error codes into Linux Error codes.  We
 	 * avoid the conversion so that the DV code has the
 	 * full error information available when making
 	 * state change decisions.
 	 */
-	{
-		uint32_t status;
-		u_int new_status;
 
-		status = ahd_cmd_get_transaction_status(cmd);
-		switch (status) {
-		case CAM_REQ_INPROG:
-		case CAM_REQ_CMP:
-		case CAM_SCSI_STATUS_ERROR:
-			new_status = DID_OK;
-			break;
-		case CAM_REQ_ABORTED:
-			new_status = DID_ABORT;
-			break;
-		case CAM_BUSY:
-			new_status = DID_BUS_BUSY;
-			break;
-		case CAM_REQ_INVALID:
-		case CAM_PATH_INVALID:
-			new_status = DID_BAD_TARGET;
-			break;
-		case CAM_SEL_TIMEOUT:
-			new_status = DID_NO_CONNECT;
-			break;
-		case CAM_SCSI_BUS_RESET:
-		case CAM_BDR_SENT:
-			new_status = DID_RESET;
-			break;
-		case CAM_UNCOR_PARITY:
-			new_status = DID_PARITY;
-			break;
-		case CAM_CMD_TIMEOUT:
-			new_status = DID_TIME_OUT;
-			break;
-		case CAM_UA_ABORT:
-		case CAM_REQ_CMP_ERR:
-		case CAM_AUTOSENSE_FAIL:
-		case CAM_NO_HBA:
-		case CAM_DATA_RUN_ERR:
-		case CAM_UNEXP_BUSFREE:
-		case CAM_SEQUENCE_FAIL:
-		case CAM_CCB_LEN_ERR:
-		case CAM_PROVIDE_FAIL:
-		case CAM_REQ_TERMIO:
-		case CAM_UNREC_HBA_ERROR:
-		case CAM_REQ_TOO_BIG:
-			new_status = DID_ERROR;
-			break;
-		case CAM_REQUEUE_REQ:
-			new_status = DID_REQUEUE;
+	status = ahd_cmd_get_transaction_status(cmd);
+	switch (status) {
+	case CAM_REQ_INPROG:
+	case CAM_REQ_CMP:
+		new_status = DID_OK;
+		break;
+	case CAM_AUTOSENSE_FAIL:
+		new_status = DID_ERROR;
+		/* Fallthrough */
+	case CAM_SCSI_STATUS_ERROR:
+		scsi_status = ahd_cmd_get_scsi_status(cmd);
+
+		switch(scsi_status) {
+		case SCSI_STATUS_CMD_TERMINATED:
+		case SCSI_STATUS_CHECK_COND:
+			if ((cmd->result >> 24) != DRIVER_SENSE) {
+				do_fallback = 1;
+			} else {
+				struct scsi_sense_data *sense;
+				
+				sense = (struct scsi_sense_data *)
+					&cmd->sense_buffer;
+				if (sense->extra_len >= 5 &&
+				    (sense->add_sense_code == 0x47
+				     || sense->add_sense_code == 0x48))
+					do_fallback = 1;
+			}
 			break;
 		default:
-			/* We should never get here */
-			new_status = DID_ERROR;
 			break;
 		}
+		break;
+	case CAM_REQ_ABORTED:
+		new_status = DID_ABORT;
+		break;
+	case CAM_BUSY:
+		new_status = DID_BUS_BUSY;
+		break;
+	case CAM_REQ_INVALID:
+	case CAM_PATH_INVALID:
+		new_status = DID_BAD_TARGET;
+		break;
+	case CAM_SEL_TIMEOUT:
+		new_status = DID_NO_CONNECT;
+		break;
+	case CAM_SCSI_BUS_RESET:
+	case CAM_BDR_SENT:
+		new_status = DID_RESET;
+		break;
+	case CAM_UNCOR_PARITY:
+		new_status = DID_PARITY;
+		do_fallback = 1;
+		break;
+	case CAM_CMD_TIMEOUT:
+		new_status = DID_TIME_OUT;
+		do_fallback = 1;
+		break;
+	case CAM_REQ_CMP_ERR:
+	case CAM_UNEXP_BUSFREE:
+	case CAM_DATA_RUN_ERR:
+		new_status = DID_ERROR;
+		do_fallback = 1;
+		break;
+	case CAM_UA_ABORT:
+	case CAM_NO_HBA:
+	case CAM_SEQUENCE_FAIL:
+	case CAM_CCB_LEN_ERR:
+	case CAM_PROVIDE_FAIL:
+	case CAM_REQ_TERMIO:
+	case CAM_UNREC_HBA_ERROR:
+	case CAM_REQ_TOO_BIG:
+		new_status = DID_ERROR;
+		break;
+	case CAM_REQUEUE_REQ:
+		new_status = DID_REQUEUE;
+		break;
+	default:
+		/* We should never get here */
+		new_status = DID_ERROR;
+		break;
+	}
 
-		ahd_cmd_set_transaction_status(cmd, new_status);
+	if (do_fallback) {
+		printf("%s: device overrun (status %x) on %d:%d:%d\n",
+		       ahd_name(ahd), status, cmd->device->channel,
+		       cmd->device->id, cmd->device->lun);
 	}
 
+	ahd_cmd_set_transaction_status(cmd, new_status);
+
 	cmd->scsi_done(cmd);
 }
 
@@ -2036,7 +2156,7 @@ ahd_release_simq(struct ahd_softc *ahd)
 }
 
 static int
-ahd_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
+ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 {
 	struct ahd_softc *ahd;
 	struct ahd_linux_device *dev;
@@ -2051,7 +2171,6 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	int    paused;
 	int    wait;
 	int    disconnected;
-	int    found;
 	ahd_mode_state saved_modes;
 	unsigned long flags;
 
@@ -2061,8 +2180,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
 	scmd_printk(KERN_INFO, cmd,
-	       "Attempting to queue a%s message:",
-	       flag == SCB_ABORT ? "n ABORT" : " TARGET RESET");
+		    "Attempting to queue an ABORT message:");
 
 	printf("CDB:");
 	for (cdb_byte = 0; cdb_byte < cmd->cmd_len; cdb_byte++)
@@ -2098,19 +2216,6 @@ ahd_linux_queue_recovery_cmd(struct scsi
 			break;
 	}
 
-	if (pending_scb == NULL && flag == SCB_DEVICE_RESET) {
-
-		/* Any SCB for this device will do for a target reset */
-		LIST_FOREACH(pending_scb, &ahd->pending_scbs, pending_links) {
-		  	if (ahd_match_scb(ahd, pending_scb,
-					  scmd_id(cmd),
-					  scmd_channel(cmd) + 'A',
-					  CAM_LUN_WILDCARD,
-					  SCB_LIST_NULL, ROLE_INITIATOR))
-				break;
-		}
-	}
-
 	if (pending_scb == NULL) {
 		scmd_printk(KERN_INFO, cmd, "Command not found\n");
 		goto no_cmd;
@@ -2144,25 +2249,17 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	ahd_dump_card_state(ahd);
 
 	disconnected = TRUE;
-	if (flag == SCB_ABORT) {
-		if (ahd_search_qinfifo(ahd, cmd->device->id, 
-				       cmd->device->channel + 'A',
-				       cmd->device->lun, 
-				       pending_scb->hscb->tag,
-				       ROLE_INITIATOR, CAM_REQ_ABORTED,
-				       SEARCH_COMPLETE) > 0) {
-			printf("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
-			       ahd_name(ahd), cmd->device->channel, 
-			       cmd->device->id, cmd->device->lun);
-			retval = SUCCESS;
-			goto done;
-		}
-	} else if (ahd_search_qinfifo(ahd, cmd->device->id,
-				      cmd->device->channel + 'A',
-				      cmd->device->lun, pending_scb->hscb->tag,
-				      ROLE_INITIATOR, /*status*/0,
-				      SEARCH_COUNT) > 0) {
-		disconnected = FALSE;
+	if (ahd_search_qinfifo(ahd, cmd->device->id, 
+			       cmd->device->channel + 'A',
+			       cmd->device->lun, 
+			       pending_scb->hscb->tag,
+			       ROLE_INITIATOR, CAM_REQ_ABORTED,
+			       SEARCH_COMPLETE) > 0) {
+		printf("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
+		       ahd_name(ahd), cmd->device->channel, 
+		       cmd->device->id, cmd->device->lun);
+		retval = SUCCESS;
+		goto done;
 	}
 
 	saved_modes = ahd_save_modes(ahd);
@@ -2170,17 +2267,12 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	last_phase = ahd_inb(ahd, LASTPHASE);
 	saved_scbptr = ahd_get_scbptr(ahd);
 	active_scbptr = saved_scbptr;
-	if (disconnected && ((last_phase != P_BUSFREE) || 
-			     (ahd_inb(ahd, SEQ_FLAGS) & NOT_IDENTIFIED) == 0)) {
+	if (disconnected && (ahd_inb(ahd, SEQ_FLAGS) & NOT_IDENTIFIED) == 0) {
 		struct scb *bus_scb;
 
 		bus_scb = ahd_lookup_scb(ahd, active_scbptr);
 		if (bus_scb == pending_scb)
 			disconnected = FALSE;
-		else if (flag != SCB_ABORT
-			 && ahd_inb(ahd, SAVED_SCSIID) == pending_scb->hscb->scsiid
-			 && ahd_inb(ahd, SAVED_LUN) == SCB_GET_LUN(pending_scb))
-			disconnected = FALSE;
 	}
 
 	/*
@@ -2189,41 +2281,26 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	 * bus or is in the disconnected state.
 	 */
 	saved_scsiid = ahd_inb(ahd, SAVED_SCSIID);
-	if (SCB_GET_TAG(pending_scb) == active_scbptr
-	     || (flag == SCB_DEVICE_RESET
-		 && SCSIID_TARGET(ahd, saved_scsiid) == scmd_id(cmd))) {
+	if (last_phase != P_BUSFREE
+	    && SCB_GET_TAG(pending_scb) == active_scbptr) {
 
 		/*
 		 * We're active on the bus, so assert ATN
 		 * and hope that the target responds.
 		 */
 		pending_scb = ahd_lookup_scb(ahd, active_scbptr);
-		pending_scb->flags |= SCB_RECOVERY_SCB|SCB_DEVICE_RESET;
+		pending_scb->flags |= SCB_RECOVERY_SCB|SCB_ABORT;
 		ahd_outb(ahd, MSG_OUT, HOST_MSG);
 		ahd_outb(ahd, SCSISIGO, last_phase|ATNO);
-		scmd_printk(KERN_INFO, cmd, "BDR message in message buffer\n");
+		scmd_printk(KERN_INFO, cmd, "Device is active, asserting ATN\n");
 		wait = TRUE;
-	} else if (last_phase != P_BUSFREE
-		   && ahd_inb(ahd, SCSIPHASE) == 0) {
-		/*
-		 * SCB is not identified, there
-		 * is no pending REQ, and the sequencer
-		 * has not seen a busfree.  Looks like
-		 * a stuck connection waiting to
-		 * go busfree.  Reset the bus.
-		 */
-		found = ahd_reset_channel(ahd, cmd->device->channel + 'A',
-					  /*Initiate Reset*/TRUE);
-		printf("%s: Issued Channel %c Bus Reset. "
-		       "%d SCBs aborted\n", ahd_name(ahd),
-		       cmd->device->channel + 'A', found);
 	} else if (disconnected) {
 
 		/*
 		 * Actually re-queue this SCB in an attempt
 		 * to select the device before it reconnects.
 		 */
-		pending_scb->flags |= SCB_RECOVERY_SCB|flag;
+		pending_scb->flags |= SCB_RECOVERY_SCB|SCB_ABORT;
 		ahd_set_scbptr(ahd, SCB_GET_TAG(pending_scb));
 		pending_scb->hscb->cdb_len = 0;
 		pending_scb->hscb->task_attribute = 0;

--------------020202080204040608050800--
