From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 43/77] ncr5380: Standardize reselection handling
Date: Tue, 22 Dec 2015 12:18:21 +1100
Message-ID: <20151222011749.695503926@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-standardize-reselection-handling
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Bring the two NCR5380_reselect() implementations into agreement.

Replace infinite loops in atari_NCR5380.c with timeouts, as per NCR5380.c.

Remove 'abort' flag in NCR5380.c as per atari_NCR5380.c -- if reselection
fails, there may be no MESSAGE IN phase so don't attempt data transfer.

During selection, don't interfere with the chip registers after a
reselection interrupt intervenes.

Clean up some trivial issues with code style, comments and printk.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |  115 +++++++++++++++++++++++--------------------
 drivers/scsi/atari_NCR5380.c |   50 ++++++++++--------
 2 files changed, 93 insertions(+), 72 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:16:34.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:16:35.000000000 +1100
@@ -1182,6 +1182,10 @@ static int NCR5380_select(struct Scsi_Ho
 	else
 		udelay(2);
 
+	/* NCR5380_reselect() clears MODE_REG after a reselection interrupt */
+	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE))
+		return -1;
+
 	dprintk(NDEBUG_ARBITRATION, "scsi%d : won arbitration\n", instance->host_no);
 
 	/* 
@@ -1953,12 +1957,14 @@ static void NCR5380_information_transfer
 						cmd->scsi_done(cmd);
 					}
 
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					/* 
 					 * Restore phase bits to 0 so an interrupted selection, 
 					 * arbitration can resume.
 					 */
 					NCR5380_write(TARGET_COMMAND_REG, 0);
+
+					/* Enable reselect interrupts */
+					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					return;
 				case MESSAGE_REJECT:
 					/* Accept message by clearing ACK */
@@ -2144,7 +2150,6 @@ static void NCR5380_reselect(struct Scsi
 	unsigned char msg[3];
 	unsigned char *data;
 	struct scsi_cmnd *tmp = NULL, *prev;
-	int abort = 0;
 
 	/*
 	 * Disable arbitration, etc. since the host adapter obviously
@@ -2154,7 +2159,7 @@ static void NCR5380_reselect(struct Scsi
 	NCR5380_write(MODE_REG, MR_BASE);
 
 	target_mask = NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->id_mask);
-	dprintk(NDEBUG_SELECTION, "scsi%d : reselect\n", instance->host_no);
+	dprintk(NDEBUG_RESELECTION, "scsi%d : reselect\n", instance->host_no);
 
 	/* 
 	 * At this point, we have detected that our SCSI ID is on the bus,
@@ -2166,77 +2171,85 @@ static void NCR5380_reselect(struct Scsi
 	 */
 
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_BSY);
-
-	/* FIXME: timeout too long, must fail to workqueue */	
-	if(NCR5380_poll_politely(instance, STATUS_REG, SR_SEL, 0, 2*HZ)<0)
-		abort = 1;
-		
+	if (NCR5380_poll_politely(instance,
+	                          STATUS_REG, SR_SEL, 0, 2 * HZ) < 0) {
+		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+		return;
+	}
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
 	/*
 	 * Wait for target to go into MSGIN.
-	 * FIXME: timeout needed and fail to work queeu
 	 */
 
 	if (NCR5380_poll_politely(instance,
-	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ) < 0)
-		abort = 1;
+	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ) < 0) {
+		do_abort(instance);
+		return;
+	}
 
 	len = 1;
 	data = msg;
 	phase = PHASE_MSGIN;
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
 
+	if (len) {
+		do_abort(instance);
+		return;
+	}
+
 	if (!(msg[0] & 0x80)) {
-		printk(KERN_ERR "scsi%d : expecting IDENTIFY message, got ", instance->host_no);
+		shost_printk(KERN_ERR, instance, "expecting IDENTIFY message, got ");
 		spi_print_msg(msg);
-		abort = 1;
-	} else {
-		/* Accept message by clearing ACK */
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		lun = (msg[0] & 0x07);
-
-		/* 
-		 * We need to add code for SCSI-II to track which devices have
-		 * I_T_L_Q nexuses established, and which have simple I_T_L
-		 * nexuses so we can chose to do additional data transfer.
-		 */
+		printk("\n");
+		do_abort(instance);
+		return;
+	}
+	lun = msg[0] & 0x07;
 
-		/* 
-		 * Find the command corresponding to the I_T_L or I_T_L_Q  nexus we 
-		 * just reestablished, and remove it from the disconnected queue.
-		 */
+	/*
+	 * We need to add code for SCSI-II to track which devices have
+	 * I_T_L_Q nexuses established, and which have simple I_T_L
+	 * nexuses so we can chose to do additional data transfer.
+	 */
 
+	/*
+	 * Find the command corresponding to the I_T_L or I_T_L_Q  nexus we
+	 * just reestablished, and remove it from the disconnected queue.
+	 */
 
-		for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue, prev = NULL; tmp; prev = tmp, tmp = (struct scsi_cmnd *) tmp->host_scribble)
-			if ((target_mask == (1 << tmp->device->id)) && (lun == (u8)tmp->device->lun)
-			    ) {
-				if (prev) {
-					REMOVE(prev, prev->host_scribble, tmp, tmp->host_scribble);
-					prev->host_scribble = tmp->host_scribble;
-				} else {
-					REMOVE(-1, hostdata->disconnected_queue, tmp, tmp->host_scribble);
-					hostdata->disconnected_queue = (struct scsi_cmnd *) tmp->host_scribble;
-				}
-				tmp->host_scribble = NULL;
-				break;
+	for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue, prev = NULL;
+	     tmp; prev = tmp, tmp = (struct scsi_cmnd *) tmp->host_scribble) {
+		if ((target_mask == (1 << tmp->device->id)) && (lun == (u8)tmp->device->lun)) {
+			if (prev) {
+				REMOVE(prev, prev->host_scribble, tmp, tmp->host_scribble);
+				prev->host_scribble = tmp->host_scribble;
+			} else {
+				REMOVE(-1, hostdata->disconnected_queue, tmp, tmp->host_scribble);
+				hostdata->disconnected_queue =
+					(struct scsi_cmnd *) tmp->host_scribble;
 			}
-		if (!tmp) {
-			printk(KERN_ERR "scsi%d : warning : target bitmask %02x lun %d not in disconnect_queue.\n", instance->host_no, target_mask, lun);
-			/* 
-			 * Since we have an established nexus that we can't do anything with,
-			 * we must abort it.  
-			 */
-			abort = 1;
+			tmp->host_scribble = NULL;
+			break;
 		}
 	}
-
-	if (abort) {
+	if (!tmp) {
+		shost_printk(KERN_ERR, instance, "target bitmask 0x%02x lun %d not in disconnected queue.\n",
+		             target_mask, lun);
+		/*
+		 * Since we have an established nexus that we can't do anything with,
+		 * we must abort it.
+		 */
 		do_abort(instance);
-	} else {
-		hostdata->connected = tmp;
-		dprintk(NDEBUG_RESELECTION, "scsi%d : nexus established, target = %d, lun = %llu, tag = %d\n", instance->host_no, tmp->device->id, tmp->device->lun, tmp->tag);
+		return;
 	}
+
+	/* Accept message by clearing ACK */
+	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+
+	hostdata->connected = tmp;
+	dprintk(NDEBUG_RESELECTION, "scsi%d : nexus established, target = %d, lun = %llu, tag = %d\n",
+	        instance->host_no, tmp->device->id, tmp->device->lun, tmp->tag);
 }
 
 /*
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-22 12:16:30.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-22 12:16:35.000000000 +1100
@@ -1446,11 +1446,9 @@ static int NCR5380_select(struct Scsi_Ho
 	else
 		udelay(2);
 
-	if (hostdata->connected) {
-		NCR5380_write(MODE_REG, MR_BASE);
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+	/* NCR5380_reselect() clears MODE_REG after a reselection interrupt */
+	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE))
 		return -1;
-	}
 
 	dprintk(NDEBUG_ARBITRATION, "scsi%d: won arbitration\n", HOSTNO);
 
@@ -2223,13 +2221,15 @@ static void NCR5380_information_transfer
 						cmd->scsi_done(cmd);
 					}
 
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					/*
 					 * Restore phase bits to 0 so an interrupted selection,
 					 * arbitration can resume.
 					 */
 					NCR5380_write(TARGET_COMMAND_REG, 0);
 
+					/* Enable reselect interrupts */
+					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
+
 					/* ++roman: For Falcon SCSI, release the lock on the
 					 * ST-DMA here if no other commands are waiting on the
 					 * disconnected queue.
@@ -2482,17 +2482,22 @@ static void NCR5380_reselect(struct Scsi
 	 */
 
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_BSY);
-
-	while (NCR5380_read(STATUS_REG) & SR_SEL)
-		;
+	if (NCR5380_poll_politely(instance,
+	                          STATUS_REG, SR_SEL, 0, 2 * HZ) < 0) {
+		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+		return;
+	}
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
 	/*
 	 * Wait for target to go into MSGIN.
 	 */
 
-	while (!(NCR5380_read(STATUS_REG) & SR_REQ))
-		;
+	if (NCR5380_poll_politely(instance,
+	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ) < 0) {
+		do_abort(instance);
+		return;
+	}
 
 #if defined(CONFIG_SUN3) && defined(REAL_DMA)
 	/* acknowledge toggle to MSGIN */
@@ -2505,15 +2510,21 @@ static void NCR5380_reselect(struct Scsi
 	data = msg;
 	phase = PHASE_MSGIN;
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
+
+	if (len) {
+		do_abort(instance);
+		return;
+	}
 #endif
 
 	if (!(msg[0] & 0x80)) {
-		printk(KERN_DEBUG "scsi%d: expecting IDENTIFY message, got ", HOSTNO);
+		shost_printk(KERN_ERR, instance, "expecting IDENTIFY message, got ");
 		spi_print_msg(msg);
+		printk("\n");
 		do_abort(instance);
 		return;
 	}
-	lun = (msg[0] & 0x07);
+	lun = msg[0] & 0x07;
 
 #if defined(SUPPORT_TAGS) && !defined(CONFIG_SUN3)
 	/* If the phase is still MSGIN, the target wants to send some more
@@ -2541,7 +2552,7 @@ static void NCR5380_reselect(struct Scsi
 
 	for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue, prev = NULL;
 	     tmp; prev = tmp, tmp = NEXT(tmp)) {
-		if ((target_mask == (1 << tmp->device->id)) && (lun == tmp->device->lun)
+		if ((target_mask == (1 << tmp->device->id)) && (lun == (u8)tmp->device->lun)
 #ifdef SUPPORT_TAGS
 		    && (tag == tmp->tag)
 #endif
@@ -2559,16 +2570,13 @@ static void NCR5380_reselect(struct Scsi
 	}
 
 	if (!tmp) {
-		printk(KERN_WARNING "scsi%d: warning: target bitmask %02x lun %d "
 #ifdef SUPPORT_TAGS
-		       "tag %d "
-#endif
-		       "not in disconnected_queue.\n",
-		       HOSTNO, target_mask, lun
-#ifdef SUPPORT_TAGS
-		       , tag
+		shost_printk(KERN_ERR, instance, "target bitmask 0x%02x lun %d tag %d not in disconnected queue.\n",
+		             target_mask, lun, tag);
+#else
+		shost_printk(KERN_ERR, instance, "target bitmask 0x%02x lun %d not in disconnected queue.\n",
+		             target_mask, lun);
 #endif
-			);
 		/*
 		 * Since we have an established nexus that we can't do anything
 		 * with, we must abort it.
