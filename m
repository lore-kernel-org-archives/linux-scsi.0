From: Willem Riede <wrlk@riede.org>
Subject: ide-scsi error handling
Date: Sun, 18 May 2003 19:07:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030518230706.GA19202@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pcp02781107pcs.eatntn01.nj.comcast.net ([68.85.61.149]:2038
	"EHLO linnie.riede.org") by vger.kernel.org with ESMTP
	id S262252AbTERWvz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 May 2003 18:51:55 -0400
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.12.8/8.12.8) with ESMTP id h4IN76Y8019610
	for <linux-scsi@vger.kernel.org>; Sun, 18 May 2003 19:07:06 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Now that current 2.5 kernels boot again for me (haven't been able
to run current kernels for months, but I digress) I've done some
more work on the error handling in ide-scsi.

The patch below works for me "most of the time". I'd appreciate if
others try it, and report results, or inspect the patch and comment.

Against 2.5.69-bk13.

Thanks, Willem Riede.

diff -uwr linux-2.5.69-bk13/drivers/ide/ide-iops.c linux-2.5.69-bk13-wr/drivers/ide/ide-iops.c
--- linux-2.5.69-bk13/drivers/ide/ide-iops.c	2003-05-18 11:10:22.000000000 -0400
+++ linux-2.5.69-bk13-wr/drivers/ide/ide-iops.c	2003-05-18 13:51:02.000000000 -0400
@@ -1134,6 +1134,7 @@
 		if (hwif->reset_poll(drive)) {
 			printk(KERN_ERR "%s: host reset_poll failure for %s.\n",
 				hwif->name, drive->name);
+			hwgroup->busy--;
 			return ide_stopped;
 		}
 	}
@@ -1179,6 +1180,7 @@
 		}
 	}
 	hwgroup->poll_timeout = 0;	/* done polling */
+	hwgroup->busy--;
 	return ide_stopped;
 }
 
@@ -1267,6 +1269,7 @@
 #if OK_TO_RESET_CONTROLLER
 	if (!IDE_CONTROL_REG) {
 		spin_unlock_irqrestore(&ide_lock, flags);
+		hwgroup->busy--;
 		return ide_stopped;
 	}
 
@@ -1315,6 +1318,7 @@
 
 ide_startstop_t ide_do_reset (ide_drive_t *drive)
 {
+	HWGROUP(drive)->busy++;
 	return do_reset1(drive, 0);
 }
 
diff -uwr linux-2.5.69-bk13/drivers/scsi/ide-scsi.c linux-2.5.69-bk13-wr/drivers/scsi/ide-scsi.c
--- linux-2.5.69-bk13/drivers/scsi/ide-scsi.c	2003-05-18 11:11:30.000000000 -0400
+++ linux-2.5.69-bk13-wr/drivers/scsi/ide-scsi.c	2003-05-18 14:23:47.000000000 -0400
@@ -270,7 +270,7 @@
 	printk("]\n");
 }
 
-static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_command)
+static int idescsi_check_condition(ide_drive_t *drive, idescsi_pc_t *failed_command)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	idescsi_pc_t   *pc;
@@ -298,8 +298,8 @@
 	rq->flags = REQ_SENSE;
 	pc->timeout = jiffies + WAIT_READY;
 	/* NOTE! Save the failed packet command in "rq->buffer" */
-	rq->buffer = (void *) failed_command->special;
-	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
+	rq->buffer = (void *) failed_command;
+	pc->scsi_cmd = failed_command->scsi_cmd;
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: queue cmd = ", drive->name);
 		hexdump(pc->c, 6);
@@ -307,6 +307,23 @@
 	return ide_do_drive_cmd(drive, rq, ide_preempt);
 }
 
+ide_startstop_t idescsi_atapi_abort (ide_drive_t *drive, const char *msg)
+{
+	struct request *rq;
+
+	if (drive == NULL || (rq = HWGROUP(drive)->rq) == NULL)
+		return ide_stopped;
+	/* retry only "normal" I/O: */
+	if (rq->flags & (REQ_DRIVE_CMD | REQ_DRIVE_TASK)) {
+		rq->errors = 1;
+		ide_end_drive_cmd(drive, BUSY_STAT, 0);
+		return ide_stopped;
+	}
+	rq->errors |= ERROR_RESET;
+	DRIVER(drive)->end_request(drive, 0, 0);
+	return ide_stopped;
+}
+
 static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
@@ -342,7 +359,7 @@
 	} else if (rq->errors) {
 		if (log)
 			printk ("ide-scsi: %s: check condition for %lu\n", drive->name, pc->scsi_cmd->serial_number);
-		if (!idescsi_check_condition(drive, rq))
+		if (!idescsi_check_condition(drive, pc))
 			/* we started a request sense, so we'll be back, exit for now */
 			return 0;
 		pc->scsi_cmd->result = (CHECK_CONDITION << 1) | (DID_OK << 16);
@@ -536,12 +553,8 @@
 		set_bit(PC_DMA_OK, &pc->flags);
 
 	if (test_bit(IDESCSI_DRQ_INTERRUPT, &scsi->flags)) {
-		if (HWGROUP(drive)->handler != NULL)
-			BUG();
-		ide_set_handler(drive, &idescsi_transfer_pc,
-				get_timeout(pc), NULL);
 		/* Issue the packet command */
-		HWIF(drive)->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
+		ide_execute_command(drive, WIN_PACKETCMD, &idescsi_transfer_pc, get_timeout(pc), NULL);
 		return ide_started;
 	} else {
 		/* Issue the packet command */
@@ -633,6 +646,7 @@
 	.cleanup		= idescsi_cleanup,
 	.do_request		= idescsi_do_request,
 	.end_request		= idescsi_end_request,
+	.abort			= idescsi_atapi_abort,
 	.drives			= LIST_HEAD_INIT(idescsi_driver.drives),
 };
 
@@ -664,8 +678,6 @@
 	.ioctl		= idescsi_ide_ioctl,
 };
 
-static int idescsi_attach(ide_drive_t *drive);
-
 static int idescsi_slave_configure(Scsi_Device * sdp)
 {
 	/* Configure detected device */
@@ -846,13 +858,15 @@
 	return 1;
 }
 
-static int idescsi_abort (Scsi_Cmnd *cmd)
+static int idescsi_scsi_eh_abort (Scsi_Cmnd *cmd)
 {
-	int countdown = 8;
+	int countdown = 120;    /* maximum is 12 seconds because ide interrupt timeout is 10 sec. */
 	unsigned long flags;
 	idescsi_scsi_t *scsi = scsihost_to_idescsi(cmd->device->host);
 	ide_drive_t *drive = scsi->drive;
 
+	if (!drive)
+		return FAILED;
 	printk (KERN_ERR "ide-scsi: abort called for %lu\n", cmd->serial_number);
 	while (countdown--) {
 		/* is cmd active?
@@ -863,56 +877,85 @@
 			/* yep - let's give it some more time - 
 			 * we can do that, we're in _our_ error kernel thread */
 			spin_unlock_irqrestore(&ide_lock, flags);
-			scsi_sleep(HZ);
+#if IDESCSI_DEBUG_LOG
+			printk(KERN_WARNING "ide-scsi: waiting in abort\n");
+#endif
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(HZ/10);
 			continue;
 		}
 		/* no, but is it queued in the ide subsystem? */
 		if (elv_queue_empty(&drive->queue)) {
 			spin_unlock_irqrestore(&ide_lock, flags);
+#if IDESCSI_DEBUG_LOG
+			printk(KERN_WARNING "ide-scsi: abort success return\n");
+#endif
 			return SUCCESS;
 		}
 		spin_unlock_irqrestore(&ide_lock, flags);
+		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(HZ/10);
 	}
+#if IDESCSI_DEBUG_LOG
+	printk(KERN_WARNING "ide-scsi: abort fail return\n");
+#endif
 	return FAILED;
 }
 
-static int idescsi_reset (Scsi_Cmnd *cmd)
+static int idescsi_scsi_eh_reset (Scsi_Cmnd *cmd)
 {
+	int countdown = 10;
 	unsigned long flags;
 	struct request *req;
 	idescsi_scsi_t *idescsi = scsihost_to_idescsi(cmd->device->host);
 	ide_drive_t *drive = idescsi->drive;
 
+	if (!drive)
+		return FAILED;
 	printk (KERN_ERR "ide-scsi: reset called for %lu\n", cmd->serial_number);
-	/* first null the handler for the drive and let any process
-	 * doing IO (on another CPU) run to (partial) completion
-	 * the lock prevents processing new requests */
+        /*
+         * Abort the current command on the group if there is one, taking care not to
+         * allow anything else to be queued and to die on the spot if we miss one somehow
+         */
 	spin_lock_irqsave(&ide_lock, flags);
-	while (HWGROUP(drive)->handler) {
-		HWGROUP(drive)->handler = NULL;
-		schedule_timeout(1);
-	}
-	/* now nuke the drive queue */
-	while ((req = elv_next_request(&drive->queue))) {
-		blkdev_dequeue_request(req);
-		end_that_request_last(req);
-	}
+        DRIVER(drive)->abort(drive, "drive reset");
+        if (HWGROUP(drive)->handler)
+                BUG();
 	/* FIXME - this will probably leak memory */
 	HWGROUP(drive)->rq = NULL;
 	if (drive_to_idescsi(drive))
 		drive_to_idescsi(drive)->pc = NULL;
+        /*
+         * we use the busy flag to reserve the hwgroup for ourselves without holding
+         * the ide lock for a long time during the reset, reset will clear the busy
+         */
+        HWGROUP(drive)->busy = 1;
 	spin_unlock_irqrestore(&ide_lock, flags);
+#if IDESCSI_DEBUG_LOG
+	printk(KERN_WARNING "ide-scsi: drive->abort completed, now do_reset\n");
+#endif
 	/* finally, reset the drive (and its partner on the bus...) */
-	ide_do_reset (drive);	
+	(void) ide_do_reset (drive);
+	/* in theory, this can take 30 seconds, but ide_spin_wait_hwgroup waits only 3,
+	 * usually, that is enough, but we call repeatedly, just to be covered */
+	while (ide_spin_wait_hwgroup(drive) && countdown--)
+		printk (KERN_INFO "ide-scsi: waiting for reset drive to complete\n");
+	/* for some reason when successful ide_spin_wait_hwgroup exits with ide_lock taken */
+	if (countdown) spin_unlock_irq(&ide_lock);
+	if (HWGROUP(drive)->handler) {
+		printk (KERN_CRIT "ide-scsi: reset drive did not complete in time\n");
+		return FAILED;
+	}
+#if IDESCSI_DEBUG_LOG
+	printk(KERN_WARNING "ide-scsi: reset success return\n");
+#endif
 	return SUCCESS;
 }
 
 static int idescsi_bios(struct scsi_device *sdev, struct block_device *bdev,
 		sector_t capacity, int *parm)
 {
-	idescsi_scsi_t *idescsi = scsihost_to_idescsi(sdev->host);
-	ide_drive_t *drive = idescsi->drive;
+	ide_drive_t *drive = scsihost_to_idescsi(sdev->host)->drive;
 
 	if (drive->bios_cyl && drive->bios_head && drive->bios_sect) {
 		parm[0] = drive->bios_head;
@@ -929,8 +972,10 @@
 	.slave_configure        = idescsi_slave_configure,
 	.ioctl			= idescsi_ioctl,
 	.queuecommand		= idescsi_queue,
-	.eh_abort_handler	= idescsi_abort,
-	.eh_device_reset_handler = idescsi_reset,
+	.eh_abort_handler	= idescsi_scsi_eh_abort,
+	.eh_device_reset_handler = idescsi_scsi_eh_reset,
+	.eh_bus_reset_handler   = idescsi_scsi_eh_reset,
+	.eh_host_reset_handler  = idescsi_scsi_eh_reset,
 	.bios_param		= idescsi_bios,
 	.can_queue		= 40,
 	.this_id		= -1,
