From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Patch(2.5.56): ide-scsi.c hotplug-oriented rearrangement
Date: Mon, 13 Jan 2003 02:51:11 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030113025111.A3630@baldur.yggdrasil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, gadio@netvision.net.il
Cc: andre@linux-ide.org, axboe@suse.de, alan@lxorguk.ukuu.org.uk


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

	The following changes to ide-scsi.c are a recovery of the
changes that I had in ide-scsi.c in the stock kernel's before
Martin Dalecki's IDE tree was reverted and a few other changes.

	The principal change is that each ATAPI device is a Scsi_host
(which reflects reality), instead of having one fake Scsi_Host with
that appears to have all of the ATAPI devices on one bus regardless of
actual hardware topology.  This way it is much easier for software to
tell that, for example, a scsi copy command will not work between two
ATAPI devices.  More importantly, hot plugging should theoretically
work now, since Scsi_hosts are allocated and deallocated as ATAPI
devices are added or removed. 

	This change eliminates the idescsi_drives[] array and the
ide_driver_t.id field that was used to index it.

	The idescsi_scsi_t data structure is now allocated at
the end of the struct Scsi_Host rather than being a separate
memory allocation.  The calculation of various private pointers
are changed slightly as a result.

	Other minor nits include making all global routines
static and adding some missing error branches in
init_idescsi_module.

	I've verified that I can at least read raw data
from a DVD-ROM with with this change.

	When I unload this ide-scsi module, the stock ide-scsi module
or the stock ide-cd modules in 2.5.56, I get what appears to be the
same kernel bad memory reference, apparently due to some generic
device device added to drivers/ide/ide.c.  It does not appear to
be due to this patch.

	The patch is a net deletion of one line.

	If nobody sees a problem with this patch, then I'd like to
move forward on getting it into Linus's releases.  Any help would be
appreciated.

-- 
Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Milpitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America
                         "Free Software For The Rest Of Us."

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ide-scsi.diff"

--- linux-2.5.56/drivers/scsi/ide-scsi.c	2003-01-10 12:11:59.000000000 -0800
+++ linux/drivers/scsi/ide-scsi.c	2003-01-13 02:24:48.000000000 -0800
@@ -96,9 +96,18 @@
 	unsigned long flags;			/* Status/Action flags */
 	unsigned long transform;		/* SCSI cmd translation layer */
 	unsigned long log;			/* log flags */
-	int id;
 } idescsi_scsi_t;
 
+static inline idescsi_scsi_t *scsihost_to_idescsi(struct Scsi_Host *host)
+{
+	return (idescsi_scsi_t*) (&host[1]);
+}
+
+static inline idescsi_scsi_t *drive_to_idescsi(ide_drive_t *ide_drive)
+{
+	return scsihost_to_idescsi(ide_drive->driver_data);
+}
+
 /*
  *	Per ATAPI device status bits.
  */
@@ -262,7 +271,7 @@
 
 static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_command)
 {
-	idescsi_scsi_t *scsi = drive->driver_data;
+	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	idescsi_pc_t   *pc;
 	struct request *rq;
 	u8             *buf;
@@ -299,7 +308,7 @@
 
 static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 {
-	idescsi_scsi_t *scsi = drive->driver_data;
+	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	struct request *rq = HWGROUP(drive)->rq;
 	idescsi_pc_t *pc = (idescsi_pc_t *) rq->special;
 	int log = test_bit(IDESCSI_LOG_CMD, &scsi->log);
@@ -369,7 +378,7 @@
  */
 static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 {
-	idescsi_scsi_t *scsi = drive->driver_data;
+	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	idescsi_pc_t *pc=scsi->pc;
 	struct request *rq = pc->rq;
 	atapi_bcount_t bcount;
@@ -463,7 +472,7 @@
 
 static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 {
-	idescsi_scsi_t *scsi = drive->driver_data;
+	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	idescsi_pc_t *pc = scsi->pc;
 	atapi_ireason_t ireason;
 	ide_startstop_t startstop;
@@ -493,7 +502,7 @@
  */
 static ide_startstop_t idescsi_issue_pc (ide_drive_t *drive, idescsi_pc_t *pc)
 {
-	idescsi_scsi_t *scsi = drive->driver_data;
+	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	atapi_feature_t feature;
 	atapi_bcount_t bcount;
 	struct request *rq = pc->rq;
@@ -555,11 +564,9 @@
 	return ide_stopped;
 }
 
-static ide_drive_t *idescsi_drives[MAX_HWIFS * MAX_DRIVES];
-
 static void idescsi_add_settings(ide_drive_t *drive)
 {
-	idescsi_scsi_t *scsi = drive->driver_data;
+	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 
 /*
  *			drive	setting name	read/write	ioctl	ioctl		data type	min	max	mul_factor	div_factor	data pointer		set function
@@ -574,15 +581,10 @@
 /*
  *	Driver initialization.
  */
-static void idescsi_setup (ide_drive_t *drive, idescsi_scsi_t *scsi, int id)
+static void idescsi_setup (ide_drive_t *drive, idescsi_scsi_t *scsi)
 {
 	DRIVER(drive)->busy++;
-	idescsi_drives[id] = drive;
-	drive->driver_data = scsi;
 	drive->ready_stat = 0;
-	memset (scsi, 0, sizeof (idescsi_scsi_t));
-	scsi->drive = drive;
-	scsi->id = id;
 	if (drive->id && (drive->id->config & 0x0060) == 0x20)
 		set_bit (IDESCSI_DRQ_INTERRUPT, &scsi->flags);
 	set_bit(IDESCSI_TRANSFORM, &scsi->transform);
@@ -596,13 +598,17 @@
 
 static int idescsi_cleanup (ide_drive_t *drive)
 {
-	idescsi_scsi_t *scsi = drive->driver_data;
+	struct Scsi_Host *scsihost = drive->driver_data;
 
 	if (ide_unregister_subdriver(drive))
 		return 1;
+	
+	/* FIXME?: Are these two statements necessary? */
 	drive->driver_data = NULL;
 	drive->disk->fops = ide_fops;
-	kfree(scsi);
+
+	scsi_remove_host(scsihost);
+	scsi_unregister(scsihost);
 	return 0;
 }
 
@@ -654,52 +660,23 @@
 	.ioctl		= idescsi_ide_ioctl,
 };
 
-static int idescsi_attach(ide_drive_t *drive)
-{
-	idescsi_scsi_t *scsi;
-	int id;
-
-	if (!strstr("ide-scsi", drive->driver_req))
-		goto failed;
-	if (!drive->present)
-		goto failed;
-	/* we accept everything except ide-disk */
-	if (drive->media == ide_disk)
-		goto failed;
-	if ((scsi = (idescsi_scsi_t *) kmalloc (sizeof (idescsi_scsi_t), GFP_KERNEL)) == NULL) {
-		printk (KERN_ERR "ide-scsi: %s: Can't allocate a scsi structure\n", drive->name);
-		goto failed;
-	}
-	if (ide_register_subdriver (drive, &idescsi_driver, IDE_SUBDRIVER_VERSION)) {
-		printk (KERN_ERR "ide-scsi: %s: Failed to register the driver with ide.c\n", drive->name);
-		kfree (scsi);
-		goto failed;
-	}
-	for (id = 0; id < MAX_HWIFS * MAX_DRIVES && idescsi_drives[id]; id++)
-		;
-	idescsi_setup (drive, scsi, id);
-	drive->disk->fops = &idescsi_ops;
-	return 0;
-failed:
-	return 1;
-}
+static int idescsi_attach(ide_drive_t *drive);
 
-int idescsi_slave_configure(Scsi_Device * sdp)
+static int idescsi_slave_configure(Scsi_Device * sdp)
 {
 	/* Configure detected device */
 	scsi_adjust_queue_depth(sdp, MSG_SIMPLE_TAG, sdp->host->cmd_per_lun);
 	return 0;
 }
 
-const char *idescsi_info (struct Scsi_Host *host)
+static const char *idescsi_info (struct Scsi_Host *host)
 {
 	return "SCSI host adapter emulation for IDE ATAPI devices";
 }
 
-int idescsi_ioctl (Scsi_Device *dev, int cmd, void *arg)
+static int idescsi_ioctl (Scsi_Device *dev, int cmd, void *arg)
 {
-	ide_drive_t *drive = idescsi_drives[dev->id];
-	idescsi_scsi_t *scsi = drive->driver_data;
+	idescsi_scsi_t *scsi = scsihost_to_idescsi(dev->host);
 
 	if (cmd == SG_SET_TRANSFORM) {
 		if (arg)
@@ -789,7 +766,7 @@
 
 static inline int should_transform(ide_drive_t *drive, Scsi_Cmnd *cmd)
 {
-	idescsi_scsi_t *scsi = drive->driver_data;
+	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	struct gendisk *disk = cmd->request->rq_disk;
 
 	if (disk) {
@@ -800,10 +777,10 @@
 	return test_bit(IDESCSI_TRANSFORM, &scsi->transform);
 }
 
-int idescsi_queue (Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
+static int idescsi_queue (Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
 {
-	ide_drive_t *drive = idescsi_drives[cmd->target];
-	idescsi_scsi_t *scsi;
+	idescsi_scsi_t *scsi = scsihost_to_idescsi(cmd->host);
+	ide_drive_t *drive = scsi->drive;
 	struct request *rq = NULL;
 	idescsi_pc_t *pc = NULL;
 
@@ -811,7 +788,7 @@
 		printk (KERN_ERR "ide-scsi: drive id %d not present\n", cmd->target);
 		goto abort;
 	}
-	scsi = drive->driver_data;
+	scsi = drive_to_idescsi(drive);
 	pc = kmalloc (sizeof (idescsi_pc_t), GFP_ATOMIC);
 	rq = kmalloc (sizeof (struct request), GFP_ATOMIC);
 	if (rq == NULL || pc == NULL) {
@@ -865,43 +842,43 @@
 	return 1;
 }
 
-int idescsi_abort (Scsi_Cmnd *cmd)
+static int idescsi_abort (Scsi_Cmnd *cmd)
 {
 	int countdown = 8;
 	unsigned long flags;
-	ide_drive_t *drive = idescsi_drives[cmd->target];
-	idescsi_scsi_t *scsi;
+	idescsi_scsi_t *scsi = scsihost_to_idescsi(cmd->host);
+	ide_drive_t *drive = scsi->drive;
 
 	printk (KERN_ERR "ide-scsi: abort called for %lu\n", cmd->serial_number);
-	if (drive && (scsi = drive->driver_data))
-		while (countdown--) {
-			/* is cmd active?
-			 *  need to lock so this stuff doesn't change under us */
-			spin_lock_irqsave(&ide_lock, flags);
-			if (scsi->pc && scsi->pc->scsi_cmd && 
-					scsi->pc->scsi_cmd->serial_number == cmd->serial_number) {
-				/* yep - let's give it some more time - 
-				 * we can do that, we're in _our_ error kernel thread */
-				spin_unlock_irqrestore(&ide_lock, flags);
-				scsi_sleep(HZ);
-				continue;
-			}
-			/* no, but is it queued in the ide subsystem? */
-			if (elv_queue_empty(&drive->queue)) {
-				spin_unlock_irqrestore(&ide_lock, flags);
-				return SUCCESS;
-			}
+	while (countdown--) {
+		/* is cmd active?
+		 *  need to lock so this stuff doesn't change under us */
+		spin_lock_irqsave(&ide_lock, flags);
+		if (scsi->pc && scsi->pc->scsi_cmd && 
+				scsi->pc->scsi_cmd->serial_number == cmd->serial_number) {
+			/* yep - let's give it some more time - 
+			 * we can do that, we're in _our_ error kernel thread */
+			spin_unlock_irqrestore(&ide_lock, flags);
+			scsi_sleep(HZ);
+			continue;
+		}
+		/* no, but is it queued in the ide subsystem? */
+		if (elv_queue_empty(&drive->queue)) {
 			spin_unlock_irqrestore(&ide_lock, flags);
-			schedule_timeout(HZ/10);
+			return SUCCESS;
 		}
+		spin_unlock_irqrestore(&ide_lock, flags);
+		schedule_timeout(HZ/10);
+	}
 	return FAILED;
 }
 
-int idescsi_reset (Scsi_Cmnd *cmd)
+static int idescsi_reset (Scsi_Cmnd *cmd)
 {
 	unsigned long flags;
 	struct request *req;
-	ide_drive_t *drive = idescsi_drives[cmd->target];
+	idescsi_scsi_t *idescsi = scsihost_to_idescsi(cmd->host);
+	ide_drive_t *drive = idescsi->drive;
 
 	printk (KERN_ERR "ide-scsi: reset called for %lu\n", cmd->serial_number);
 	/* first null the handler for the drive and let any process
@@ -919,7 +896,8 @@
 	}
 	/* FIXME - this will probably leak memory */
 	HWGROUP(drive)->rq = NULL;
-	if (drive->driver_data) ((idescsi_scsi_t *)drive->driver_data)->pc = NULL;
+	if (drive_to_idescsi(drive))
+		drive_to_idescsi(drive)->pc = NULL;
 	spin_unlock_irqrestore(&ide_lock, flags);
 	/* finally, reset the drive (and its partner on the bus...) */
 	ide_do_reset (drive);	
@@ -929,7 +907,8 @@
 static int idescsi_bios(struct scsi_device *sdev, struct block_device *bdev,
 		sector_t capacity, int *parm)
 {
-	ide_drive_t *drive = idescsi_drives[sdev->id];
+	idescsi_scsi_t *idescsi = scsihost_to_idescsi(sdev->host);
+	ide_drive_t *drive = idescsi->drive;
 
 	if (drive->bios_cyl && drive->bios_head && drive->bios_sect) {
 		parm[0] = drive->bios_head;
@@ -956,10 +935,9 @@
 	.max_sectors		= 128,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.emulated		= 1,
+	.proc_name		= "ide-scsi",
 };
 
-static struct Scsi_Host *idescsi_host;
-
 static struct device     idescsi_primary = {
 	.name		= "Ide-scsi Parent",
 	.bus_id		= "ide-scsi",
@@ -968,39 +946,60 @@
 	.name		= "ide-scsi",
 };
 
-static int __init init_idescsi_module(void)
+static int idescsi_attach(ide_drive_t *drive)
 {
-	int id;
-	int last_lun = 0;
+	idescsi_scsi_t *idescsi;
+	struct Scsi_Host *host;
+	int err;
 
-	ide_register_driver(&idescsi_driver);
-	device_register(&idescsi_primary);
-	bus_register   (&idescsi_emu_bus);
-	idescsi_template.proc_name = "ide-scsi";
-	idescsi_host = scsi_register(&idescsi_template, 0);
-	if(idescsi_host == NULL)
+	if (!strstr("ide-scsi", drive->driver_req) ||
+	    !drive->present ||
+	    drive->media == ide_disk ||
+	    !(host = scsi_register(&idescsi_template,sizeof(idescsi_scsi_t))))
 		return 1;
-		
-	for (id = 0; id < MAX_HWIFS * MAX_DRIVES && idescsi_drives[id]; id++)
-		last_lun = IDE_MAX(last_lun, idescsi_drives[id]->last_lun);
-	idescsi_host->max_id = id;
-	idescsi_host->max_lun = last_lun + 1;
-	scsi_add_host(idescsi_host, &idescsi_primary);
-	return 0;
+
+	host->max_id = 1;
+	host->max_lun = 1;
+	drive->driver_data = host;
+	idescsi = scsihost_to_idescsi(host);
+	idescsi->drive = drive;
+	err = ide_register_subdriver (drive, &idescsi_driver,
+				      IDE_SUBDRIVER_VERSION);
+	if (!err) {
+		idescsi_setup (drive, idescsi);
+		drive->disk->fops = &idescsi_ops;
+		err = scsi_add_host(host, &idescsi_primary);
+		if (!err)
+			return 0;
+		/* fall through on error */
+		ide_unregister_subdriver(drive);
+	}
+
+	scsi_unregister(host);
+	return err;
 }
 
-static void __exit exit_idescsi_module(void)
+static int __init init_idescsi_module(void)
 {
-	ide_drive_t *drive;
-	int id;
+	int err;
 
-	scsi_remove_host(idescsi_host);
-	for (id = 0; id < MAX_HWIFS * MAX_DRIVES; id++) {
-		drive = idescsi_drives[id];
-		if (drive)
-			DRIVER(drive)->busy = 0;
+	err = bus_register(&idescsi_emu_bus);
+	if (!err) {
+		err = device_register(&idescsi_primary);
+		if (!err) {
+			err = ide_register_driver(&idescsi_driver);
+			if (!err)
+				return 0;
+
+			device_unregister(&idescsi_primary);
+		}
+		bus_unregister(&idescsi_emu_bus);
 	}
-	scsi_unregister   (idescsi_host);
+	return err;
+}
+
+static void __exit exit_idescsi_module(void)
+{
 	device_unregister(&idescsi_primary);
 	bus_unregister   (&idescsi_emu_bus);
 	ide_unregister_driver(&idescsi_driver);

--qDbXVdCdHGoSgWSk--
