From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] ide-scsi patches against lk 2.5.52
Date: Tue, 24 Dec 2002 11:06:15 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E07A4F7.3040302@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080309030807070008090102"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-32.triode.net.au [202.147.125.32])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id gBO04Di21874
	for <linux-scsi@vger.kernel.org>; Tue, 24 Dec 2002 11:04:13 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080309030807070008090102
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Since there have been several patches flying back
and forth during the last week, attached are 2
rollup patches on drivers/scsi/ide-scsi.c and
drivers/ide/ide.c against lk 2.5.52 .

These patches are almost all Willem Riede's work.

Doug Gilbert

--------------080309030807070008090102
Content-Type: text/plain;
 name="ide-scsi_2552wr2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ide-scsi_2552wr2.diff"

--- linux/drivers/scsi/ide-scsi.c	2002-12-10 17:38:29.000000000 +1100
+++ linux/drivers/scsi/ide-scsi.c2552wr2	2002-12-24 09:30:17.000000000 +1100
@@ -28,9 +28,10 @@
  * Ver 0.8   Feb 05 99   Optical media need translation too. Reverse 0.7.
  * Ver 0.9   Jul 04 99   Fix a bug in SG_SET_TRANSFORM.
  * Ver 0.91  Jun 10 02   Fix "off by one" error in transforms
+ * Ver 0.92  Dec 31 02   Implement new SCSI mid level API
  */
 
-#define IDESCSI_VERSION "0.9"
+#define IDESCSI_VERSION "0.92"
 
 #include <linux/module.h>
 #include <linux/config.h>
@@ -259,6 +260,43 @@
 	printk("]\n");
 }
 
+static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_command)
+{
+	idescsi_scsi_t *scsi = drive->driver_data;
+	idescsi_pc_t   *pc;
+	struct request *rq;
+	u8             *buf;
+
+	/* stuff a sense request in front of our current request */
+	pc = kmalloc (sizeof (idescsi_pc_t), GFP_ATOMIC);
+	rq = kmalloc (sizeof (struct request), GFP_ATOMIC);
+	buf = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_ATOMIC);
+	if (pc == NULL || rq == NULL || buf == NULL) {
+		if (pc) kfree(pc);
+		if (rq) kfree(rq);
+		if (buf) kfree(buf);
+		return -ENOMEM;
+	}
+	memset (pc, 0, sizeof (idescsi_pc_t));
+	memset (buf, 0, SCSI_SENSE_BUFFERSIZE);
+	ide_init_drive_cmd(rq);
+	rq->special = (char *) pc;
+	pc->rq = rq;
+	pc->buffer = buf;
+	pc->c[0] = REQUEST_SENSE;
+	pc->c[4] = pc->request_transfer = pc->buffer_size = SCSI_SENSE_BUFFERSIZE;
+	rq->flags = REQ_SENSE;
+	pc->timeout = jiffies + WAIT_READY;
+	/* NOTE! Save the failed packet command in "rq->buffer" */
+	rq->buffer = (void *) failed_command->special;
+	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
+	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
+		printk ("ide-scsi: %s: queue cmd = ", drive->name);
+		hexdump(pc->c, 6);
+	}
+	return ide_do_drive_cmd(drive, rq, ide_preempt);
+}
+
 static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 {
 	idescsi_scsi_t *scsi = drive->driver_data;
@@ -269,19 +307,35 @@
 	u8 *scsi_buf;
 	unsigned long flags;
 
-	if (!(rq->flags & REQ_SPECIAL)) {
+	if (!(rq->flags & (REQ_SPECIAL|REQ_SENSE))) {
 		ide_end_request(drive, uptodate, nrsecs);
 		return 0;
 	}
 	ide_end_drive_cmd (drive, 0, 0);
-	if (rq->errors >= ERROR_MAX) {
+	if (rq->flags & REQ_SENSE) {
+		idescsi_pc_t *opc = (idescsi_pc_t *) rq->buffer;
+		if (log) {
+			printk ("ide-scsi: %s: wrap up check %lu, rst = ", drive->name, opc->scsi_cmd->serial_number);
+			hexdump(pc->buffer,16);
+		}
+		memcpy((void *) opc->scsi_cmd->sense_buffer, pc->buffer, SCSI_SENSE_BUFFERSIZE);
+		kfree(pc->buffer);
+		kfree(pc);
+		kfree(rq);
+		pc = opc;
+		rq = pc->rq;
+		pc->scsi_cmd->result = (CHECK_CONDITION << 1) | (DID_OK << 16);
+	} else if (rq->errors >= ERROR_MAX) {
 		pc->scsi_cmd->result = DID_ERROR << 16;
 		if (log)
 			printk ("ide-scsi: %s: I/O error for %lu\n", drive->name, pc->scsi_cmd->serial_number);
 	} else if (rq->errors) {
-		pc->scsi_cmd->result = (CHECK_CONDITION << 1) | (DID_OK << 16);
 		if (log)
 			printk ("ide-scsi: %s: check condition for %lu\n", drive->name, pc->scsi_cmd->serial_number);
+		if (!idescsi_check_condition(drive, rq))
+			/* we started a request sense, so we'll be back, exit for now */
+			return 0;
+		pc->scsi_cmd->result = (CHECK_CONDITION << 1) | (DID_OK << 16);
 	} else {
 		pc->scsi_cmd->result = DID_OK << 16;
 		idescsi_transform_pc2 (drive, pc);
@@ -489,11 +543,11 @@
 static ide_startstop_t idescsi_do_request (ide_drive_t *drive, struct request *rq, sector_t block)
 {
 #if IDESCSI_DEBUG_LOG
-	printk (KERN_INFO "rq_status: %d, dev: %s, cmd: %d, errors: %d\n",rq->rq_status, rq->rq_disk->disk_name,rq->cmd,rq->errors);
-	printk (KERN_INFO "sector: %ld, nr_sectors: %ld, current_nr_sectors: %ld\n",rq->sector,rq->nr_sectors,rq->current_nr_sectors);
+	printk (KERN_INFO "rq_status: %d, dev: %s, cmd: %x, errors: %d\n",rq->rq_status, rq->rq_disk->disk_name,rq->cmd[0],rq->errors);
+	printk (KERN_INFO "sector: %ld, nr_sectors: %ld, current_nr_sectors: %d\n",rq->sector,rq->nr_sectors,rq->current_nr_sectors);
 #endif /* IDESCSI_DEBUG_LOG */
 
-	if (rq->flags & REQ_SPECIAL) {
+	if (rq->flags & (REQ_SPECIAL|REQ_SENSE)) {
 		return idescsi_issue_pc (drive, (idescsi_pc_t *) rq->special);
 	}
 	blk_dump_rq_flags(rq, "ide-scsi: unsup command");
@@ -629,35 +683,10 @@
 	return 1;
 }
 
-int idescsi_detect (Scsi_Host_Template *host_template)
-{
-	struct Scsi_Host *host;
-	int id;
-	int last_lun = 0;
-
-	host_template->proc_name = "ide-scsi";
-	host = scsi_register(host_template, 0);
-	if(host == NULL)
-		return 0;
-		
-	for (id = 0; id < MAX_HWIFS * MAX_DRIVES && idescsi_drives[id]; id++)
-		last_lun = IDE_MAX(last_lun, idescsi_drives[id]->last_lun);
-	host->max_id = id;
-	host->max_lun = last_lun + 1;
-	host->can_queue = host->cmd_per_lun * id;
-	return 1;
-}
-
-int idescsi_release (struct Scsi_Host *host)
+int idescsi_slave_configure(Scsi_Device * sdp)
 {
-	ide_drive_t *drive;
-	int id;
-
-	for (id = 0; id < MAX_HWIFS * MAX_DRIVES; id++) {
-		drive = idescsi_drives[id];
-		if (drive)
-			DRIVER(drive)->busy--;
-	}
+	/* Configure detected device */
+	scsi_adjust_queue_depth(sdp, MSG_SIMPLE_TAG, sdp->host->cmd_per_lun);
 	return 0;
 }
 
@@ -832,17 +861,68 @@
 	if (rq) kfree (rq);
 	cmd->result = DID_ERROR << 16;
 	done(cmd);
-	return 0;
+	return 1;
 }
 
 int idescsi_abort (Scsi_Cmnd *cmd)
 {
-	return SCSI_ABORT_SNOOZE;
+	int countdown = 8;
+	unsigned long flags;
+	ide_drive_t *drive = idescsi_drives[cmd->target];
+	idescsi_scsi_t *scsi;
+
+	printk (KERN_ERR "ide-scsi: abort called for %lu\n", cmd->serial_number);
+	if (drive && (scsi = drive->driver_data))
+		while (countdown--) {
+			/* is cmd active?
+			 *  need to lock so this stuff doesn't change under us */
+			spin_lock_irqsave(&ide_lock, flags);
+			if (scsi->pc && scsi->pc->scsi_cmd && 
+					scsi->pc->scsi_cmd->serial_number == cmd->serial_number) {
+				/* yep - let's give it some more time - 
+				 * we can do that, we're in _our_ error kernel thread */
+				spin_unlock_irqrestore(&ide_lock, flags);
+				scsi_sleep(HZ);
+				continue;
+			}
+			/* no, but is it queued in the ide subsystem? */
+			if (elv_queue_empty(&drive->queue)) {
+				spin_unlock_irqrestore(&ide_lock, flags);
+				return SUCCESS;
+			}
+			spin_unlock_irqrestore(&ide_lock, flags);
+			schedule_timeout(HZ/10);
+		}
+	return FAILED;
 }
 
-int idescsi_reset (Scsi_Cmnd *cmd, unsigned int resetflags)
+int idescsi_reset (Scsi_Cmnd *cmd)
 {
-	return SCSI_RESET_SUCCESS;
+	unsigned long flags;
+	struct request *req;
+	ide_drive_t *drive = idescsi_drives[cmd->target];
+
+	printk (KERN_ERR "ide-scsi: reset called for %lu\n", cmd->serial_number);
+	/* first null the handler for the drive and let any process
+	 * doing IO (on another CPU) run to (partial) completion
+	 * the lock prevents processing new requests */
+	spin_lock_irqsave(&ide_lock, flags);
+	while (HWGROUP(drive)->handler) {
+		HWGROUP(drive)->handler = NULL;
+		schedule_timeout(1);
+	}
+	/* now nuke the drive queue */
+	while ((req = elv_next_request(&drive->queue))) {
+		blkdev_dequeue_request(req);
+		end_that_request_last(req);
+	}
+	/* FIXME - this will probably leak memory */
+	HWGROUP(drive)->rq = NULL;
+	if (drive->driver_data) ((idescsi_scsi_t *)drive->driver_data)->pc = NULL;
+	spin_unlock_irqrestore(&ide_lock, flags);
+	/* finally, reset the drive (and its partner on the bus...) */
+	ide_do_reset (drive);	
+	return SUCCESS;
 }
 
 static int idescsi_bios(struct scsi_device *sdev, struct block_device *bdev,
@@ -859,32 +939,69 @@
 }
 
 static Scsi_Host_Template idescsi_template = {
-	.module		= THIS_MODULE,
-	.name		= "idescsi",
-	.detect		= idescsi_detect,
-	.release	= idescsi_release,
-	.info		= idescsi_info,
-	.ioctl		= idescsi_ioctl,
-	.queuecommand	= idescsi_queue,
-	.bios_param	= idescsi_bios,
-	.can_queue	= 10,
-	.this_id	= -1,
-	.sg_tablesize	= 256,
-	.cmd_per_lun	= 5,
-	.use_clustering	= DISABLE_CLUSTERING,
-	.emulated	= 1,
+	.module			= THIS_MODULE,
+	.name			= "idescsi",
+	.info			= idescsi_info,
+	.slave_configure        = idescsi_slave_configure,
+	.ioctl			= idescsi_ioctl,
+	.queuecommand		= idescsi_queue,
+	.eh_abort_handler	= idescsi_abort,
+	.eh_device_reset_handler = idescsi_reset,
+	.bios_param		= idescsi_bios,
+	.can_queue		= 40,
+	.this_id		= -1,
+	.sg_tablesize		= 256,
+	.cmd_per_lun		= 5,
+	.max_sectors		= 128,
+	.use_clustering		= DISABLE_CLUSTERING,
+	.emulated		= 1,
+};
+
+static struct Scsi_Host *idescsi_host;
+
+static struct device     idescsi_primary = {
+	.name		= "Ide-scsi Parent",
+	.bus_id		= "ide-scsi",
+};
+static struct bus_type   idescsi_emu_bus = {
+	.name		= "ide-scsi",
 };
 
 static int __init init_idescsi_module(void)
 {
+	int id;
+	int last_lun = 0;
+
 	ide_register_driver(&idescsi_driver);
-	scsi_register_host(&idescsi_template);
+	device_register(&idescsi_primary);
+	bus_register   (&idescsi_emu_bus);
+	idescsi_template.proc_name = "ide-scsi";
+	idescsi_host = scsi_register(&idescsi_template, 0);
+	if(idescsi_host == NULL)
+		return 1;
+		
+	for (id = 0; id < MAX_HWIFS * MAX_DRIVES && idescsi_drives[id]; id++)
+		last_lun = IDE_MAX(last_lun, idescsi_drives[id]->last_lun);
+	idescsi_host->max_id = id;
+	idescsi_host->max_lun = last_lun + 1;
+	scsi_add_host(idescsi_host, &idescsi_primary);
 	return 0;
 }
 
 static void __exit exit_idescsi_module(void)
 {
-	scsi_unregister_host(&idescsi_template);
+	ide_drive_t *drive;
+	int id;
+
+	scsi_remove_host(idescsi_host);
+	for (id = 0; id < MAX_HWIFS * MAX_DRIVES; id++) {
+		drive = idescsi_drives[id];
+		if (drive)
+			DRIVER(drive)->busy--;
+	}
+	scsi_unregister   (idescsi_host);
+	device_unregister(&idescsi_primary);
+	bus_unregister   (&idescsi_emu_bus);
 	ide_unregister_driver(&idescsi_driver);
 }
 

--------------080309030807070008090102
Content-Type: text/plain;
 name="ide_2552_wr1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ide_2552_wr1.diff"

--- linux/drivers/ide/ide.c	2002-12-10 17:38:28.000000000 +1100
+++ linux/drivers/ide/ide.c2552willem	2002-12-24 09:10:25.000000000 +1100
@@ -2314,6 +2314,8 @@
 {
 	ide_drive_t *drive;
 
+	driver_unregister(&driver->gen_driver);
+
 	spin_lock(&drivers_lock);
 	list_del(&driver->drivers);
 	spin_unlock(&drivers_lock);

--------------080309030807070008090102--

