From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] get rid of ->finish method for highlevel drivers
Date: Mon, 21 Oct 2002 21:34:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021021213441.A2864@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

the ->finish method is a relicat from the old day were we never had
hotplugging and allowed the driver to do fixups after all busses
had been scanned.  Nowdays only sd and sr actually implement it,
and both only defer actions to there that should actually happen in
->attach.  Change both drivers to move that code into ->attach,
clenaup the Templates to use C99 initializers and get rid of the
methods.

This also cleans up some very crude race-avoidable code in those
drivers, btw..


diff -uNr -Xdontdiff -p linux-2.5.44-uc0/drivers/scsi/hosts.c linux/drivers/scsi/hosts.c
--- linux-2.5.44-uc0/drivers/scsi/hosts.c	Mon Oct 21 17:18:03 2002
+++ linux/drivers/scsi/hosts.c	Mon Oct 21 20:46:14 2002
@@ -573,14 +573,6 @@ int scsi_register_host(Scsi_Host_Templat
 					}
 				}
 		}
-
-		/* This does any final handling that is required. */
-		for (sdev_tp = scsi_devicelist; sdev_tp;
-		     sdev_tp = sdev_tp->next) {
-			if (sdev_tp->finish && sdev_tp->nr_dev) {
-				(*sdev_tp->finish) ();
-			}
-		}
 	}
 
 	return 0;
diff -uNr -Xdontdiff -p linux-2.5.44-uc0/drivers/scsi/hosts.h linux/drivers/scsi/hosts.h
--- linux-2.5.44-uc0/drivers/scsi/hosts.h	Mon Oct 21 17:18:19 2002
+++ linux/drivers/scsi/hosts.h	Mon Oct 21 20:43:56 2002
@@ -583,7 +583,6 @@ struct Scsi_Device_Template
     int (*detect)(Scsi_Device *); /* Returns 1 if we can attach this device */
     int (*init)(void);		  /* Sizes arrays based upon number of devices
 		   *  detected */
-    void (*finish)(void);	  /* Perform initialization after attachment */
     int (*attach)(Scsi_Device *); /* Attach devices to arrays */
     void (*detach)(Scsi_Device *);
     int (*init_command)(Scsi_Cmnd *);     /* Used by new queueing code. 
diff -uNr -Xdontdiff -p linux-2.5.44-uc0/drivers/scsi/scsi.c linux/drivers/scsi/scsi.c
--- linux-2.5.44-uc0/drivers/scsi/scsi.c	Mon Oct 21 17:19:01 2002
+++ linux/drivers/scsi/scsi.c	Mon Oct 21 20:44:58 2002
@@ -2034,18 +2039,14 @@ int scsi_register_device(struct Scsi_Dev
 		}
 	}
 
-	/*
-	 * This does any final handling that is required.
-	 */
-	if (tpnt->finish && tpnt->nr_dev)
-		(*tpnt->finish) ();
 	MOD_INC_USE_COUNT;
 
 	if (out_of_space) {
 		scsi_unregister_device(tpnt);	/* easiest way to clean up?? */
 		return 1;
-	} else
-		return 0;
+	}
+
+	return 0;
 }
 
 int scsi_unregister_device(struct Scsi_Device_Template *tpnt)
diff -uNr -Xdontdiff -p linux-2.5.44-uc0/drivers/scsi/scsi_scan.c linux/drivers/scsi/scsi_scan.c
--- linux-2.5.44-uc0/drivers/scsi/scsi_scan.c	Mon Oct 21 17:20:04 2002
+++ linux/drivers/scsi/scsi_scan.c	Mon Oct 21 20:47:21 2002
@@ -2012,11 +2012,6 @@ static void scsi_scan_selected_lun(struc
 						       __FUNCTION__);
 				}
 			}
-
-		for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
-			if (sdt->finish && sdt->nr_dev)
-				(*sdt->finish) ();
-
 	}
 }
 
diff -uNr -Xdontdiff -p linux-2.5.44-uc0/drivers/scsi/sd.c linux/drivers/scsi/sd.c
--- linux-2.5.44-uc0/drivers/scsi/sd.c	Mon Oct 21 17:20:02 2002
+++ linux/drivers/scsi/sd.c	Mon Oct 21 20:52:13 2002
@@ -92,7 +92,6 @@ static int sd_revalidate(struct gendisk 
 static void sd_init_onedisk(Scsi_Disk * sdkp, struct gendisk *disk);
 
 static int sd_init(void);
-static void sd_finish(void);
 static int sd_attach(Scsi_Device *);
 static int sd_detect(Scsi_Device *);
 static void sd_detach(Scsi_Device *);
@@ -103,23 +102,19 @@ static int sd_notifier(struct notifier_b
 static struct notifier_block sd_notifier_block = {sd_notifier, NULL, 0}; 
 
 static struct Scsi_Device_Template sd_template = {
-	module:THIS_MODULE,
-	name:"disk",
-	tag:"sd",
-	scsi_type:TYPE_DISK,
-	major:SCSI_DISK0_MAJOR,
-        /*
-         * Secondary range of majors that this driver handles.
-         */
-	min_major:SCSI_DISK1_MAJOR,
-	max_major:SCSI_DISK7_MAJOR,
-	blk:1,
-	detect:sd_detect,
-	init:sd_init,
-	finish:sd_finish,
-	attach:sd_attach,
-	detach:sd_detach,
-	init_command:sd_init_command,
+	.module		= THIS_MODULE,
+	.name		= "disk",
+	.tag		= "sd",
+	.scsi_type	= TYPE_DISK,
+	.major		= SCSI_DISK0_MAJOR,
+	.min_major	= SCSI_DISK1_MAJOR,
+	.max_major	= SCSI_DISK7_MAJOR,
+	.blk		= 1,
+	.detect		= sd_detect,
+	.init		= sd_init,
+	.attach		= sd_attach,
+	.detach		= sd_detach,
+	.init_command	= sd_init_command,
 };
 
 static void sd_rw_intr(Scsi_Cmnd * SCpnt);
@@ -1291,38 +1286,6 @@ cleanup_mem:
 }
 
 /**
- *	sd_finish - called during driver initialization, after all
- *	the sd_attach() calls are finished.
- *
- *	Note: this function is invoked from the scsi mid-level.
- *	This function is not called after driver initialization has completed.
- *	Specifically later device attachments invoke sd_attach() but not
- *	this function.
- **/
-static void sd_finish()
-{
-	int k;
-	Scsi_Disk * sdkp;
-
-	SCSI_LOG_HLQUEUE(3, printk("sd_finish: \n"));
-
-	for (k = 0; k < sd_template.dev_max; ++k) {
-		sdkp = sd_get_sdisk(k);
-		if (sdkp && (0 == sdkp->capacity) && sdkp->device) {
-			sd_init_onedisk(sdkp, sd_disks[k]);
-			if (sdkp->has_been_registered)
-				continue;
-			set_capacity(sd_disks[k], sdkp->capacity);
-			sd_disks[k]->private_data = sdkp;
-			sd_disks[k]->queue = &sdkp->device->request_queue;
-			add_disk(sd_disks[k]);
-			sdkp->has_been_registered = 1;
-		}
-	}
-	return;
-}
-
-/**
  *	sd_detect - called at the start of driver initialization, once 
  *	for each scsi device (not just disks) present.
  *
@@ -1358,13 +1321,12 @@ static int sd_detect(Scsi_Device * sdp)
  **/
 static int sd_attach(Scsi_Device * sdp)
 {
-	Scsi_Disk *sdkp;
+	Scsi_Disk *sdkp = NULL;	/* shut up lame gcc warning */
 	int dsk_nr;
 	unsigned long iflags;
 	struct gendisk *gd;
 
-	if ((NULL == sdp) ||
-	    ((sdp->type != TYPE_DISK) && (sdp->type != TYPE_MOD)))
+	if ((sdp->type != TYPE_DISK) && (sdp->type != TYPE_MOD))
 		return 0;
 
 	gd = alloc_disk(16);
@@ -1373,15 +1335,16 @@ static int sd_attach(Scsi_Device * sdp)
 
 	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 
 			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
+
 	if (sd_template.nr_dev >= sd_template.dev_max) {
-		sdp->attached--;
 		printk(KERN_ERR "sd_init: no more room for device\n");
-		put_disk(gd);
-		return 1;
+		goto out;
 	}
 
-/* Assume sd_attach is not re-entrant (for time being) */
-/* Also think about sd_attach() and sd_detach() running coincidentally. */
+	/*
+	 * Assume sd_attach is not re-entrant (for time being)
+	 * Also think about sd_attach() and sd_detach() running coincidentally.
+	 */
 	write_lock_irqsave(&sd_dsk_arr_lock, iflags);
 	for (dsk_nr = 0; dsk_nr < sd_template.dev_max; dsk_nr++) {
 		sdkp = sd_dsk_arr[dsk_nr];
@@ -1393,15 +1356,15 @@ static int sd_attach(Scsi_Device * sdp)
 	}
 	write_unlock_irqrestore(&sd_dsk_arr_lock, iflags);
 
-	if (dsk_nr >= sd_template.dev_max) {
-		/* panic("scsi_devices corrupt (sd)");  overkill */
+	if (!sdkp || dsk_nr >= sd_template.dev_max) {
 		printk(KERN_ERR "sd_init: sd_dsk_arr corrupted\n");
-		put_disk(gd);
-		return 1;
+		goto out;
 	}
 
+	sd_init_onedisk(sdkp, gd);
 	sd_template.nr_dev++;
-        gd->de = sdp->de;
+
+	gd->de = sdp->de;
 	gd->major = SD_MAJOR(dsk_nr>>4);
 	gd->first_minor = (dsk_nr & 15)<<4;
 	gd->fops = &sd_fops;
@@ -1409,14 +1372,26 @@ static int sd_attach(Scsi_Device * sdp)
 		sprintf(gd->disk_name, "sd%c%c",'a'+dsk_nr/26-1,'a'+dsk_nr%26);
 	else
 		sprintf(gd->disk_name, "sd%c",'a'+dsk_nr%26);
-        gd->flags = sdp->removable ? GENHD_FL_REMOVABLE : 0;
-        gd->driverfs_dev = &sdp->sdev_driverfs_dev;
-        gd->flags |= GENHD_FL_DRIVERFS | GENHD_FL_DEVFS;
+	gd->flags = sdp->removable ? GENHD_FL_REMOVABLE : 0;
+	gd->driverfs_dev = &sdp->sdev_driverfs_dev;
+	gd->flags |= GENHD_FL_DRIVERFS | GENHD_FL_DEVFS;
+	gd->private_data = sdkp;
+	gd->queue = &sdkp->device->request_queue;
+
+	set_capacity(gd, sdkp->capacity);
+	add_disk(gd);
+
 	sd_disks[dsk_nr] = gd;
+
 	printk(KERN_NOTICE "Attached scsi %sdisk %s at scsi%d, channel %d, "
 	       "id %d, lun %d\n", sdp->removable ? "removable " : "",
 	       gd->disk_name, sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	return 0;
+
+out:
+	sdp->attached--;
+	put_disk(gd);
+	return 1;
 }
 
 static int sd_revalidate(struct gendisk *disk)
@@ -1472,10 +1447,7 @@ static void sd_detach(Scsi_Device * sdp)
 	sdkp->capacity = 0;
 	/* sdkp->detaching = 1; */
 
-	if (sdkp->has_been_registered) {
-		sdkp->has_been_registered = 0;
-		del_gendisk(sd_disks[dsk_nr]);
-	}
+	del_gendisk(sd_disks[dsk_nr]);
 	sdp->attached--;
 	sd_template.dev_noticed--;
 	sd_template.nr_dev--;
diff -uNr -Xdontdiff -p linux-2.5.44-uc0/drivers/scsi/sd.h linux/drivers/scsi/sd.h
--- linux-2.5.44-uc0/drivers/scsi/sd.h	Mon Oct 21 17:19:51 2002
+++ linux/drivers/scsi/sd.h	Mon Oct 21 20:34:15 2002
@@ -25,7 +25,6 @@ typedef struct scsi_disk {
 	Scsi_Device *device;
 	unsigned char media_present;
 	unsigned char write_prot;
-	unsigned has_been_registered:1;
 	unsigned WCE:1;         /* state of disk WCE bit */
 	unsigned RCD:1;         /* state of disk RCD bit */
 } Scsi_Disk;
diff -uNr -Xdontdiff -p linux-2.5.44-uc0/drivers/scsi/sr.c linux/drivers/scsi/sr.c
--- linux-2.5.44-uc0/drivers/scsi/sr.c	Mon Oct 21 17:18:14 2002
+++ linux/drivers/scsi/sr.c	Mon Oct 21 20:57:29 2002
@@ -63,27 +63,24 @@ MODULE_PARM(xa_test, "i");	/* see sr_ioc
 #define SR_TIMEOUT	(30 * HZ)
 
 static int sr_init(void);
-static void sr_finish(void);
 static int sr_attach(Scsi_Device *);
 static int sr_detect(Scsi_Device *);
 static void sr_detach(Scsi_Device *);
 
 static int sr_init_command(Scsi_Cmnd *);
 
-static struct Scsi_Device_Template sr_template =
-{
-	module:THIS_MODULE,
-	name:"cdrom",
-	tag:"sr",
-	scsi_type:TYPE_ROM,
-	major:SCSI_CDROM_MAJOR,
-	blk:1,
-	detect:sr_detect,
-	init:sr_init,
-	finish:sr_finish,
-	attach:sr_attach,
-	detach:sr_detach,
-	init_command:sr_init_command
+static struct Scsi_Device_Template sr_template = {
+	.module		= THIS_MODULE,
+	.name		= "cdrom",
+	.tag		= "sr",
+	.scsi_type	= TYPE_ROM,
+	.major		= SCSI_CDROM_MAJOR,
+	.blk		= 1,
+	.detect		= sr_detect,
+	.init		= sr_init,
+	.attach		= sr_attach,
+	.detach		= sr_detach,
+	.init_command	= sr_init_command
 };
 
 static Scsi_CD *scsi_CDs;
@@ -91,6 +88,7 @@ static Scsi_CD *scsi_CDs;
 static int sr_open(struct cdrom_device_info *, int);
 static void get_sectorsize(Scsi_CD *);
 static void get_capabilities(Scsi_CD *);
+static int sr_init_one(Scsi_CD *, int);
 
 static int sr_media_change(struct cdrom_device_info *, int);
 static int sr_packet(struct cdrom_device_info *, struct cdrom_generic_command *);
@@ -473,10 +471,9 @@ static int sr_attach(Scsi_Device * SDp)
 	if (SDp->type != TYPE_ROM && SDp->type != TYPE_WORM)
 		return 1;
 
-	if (sr_template.nr_dev >= sr_template.dev_max) {
-		SDp->attached--;
-		return 1;
-	}
+	if (sr_template.nr_dev >= sr_template.dev_max)
+		goto fail;
+
 	for (cpnt = scsi_CDs, i = 0; i < sr_template.dev_max; i++, cpnt++)
 		if (!cpnt->device)
 			break;
@@ -484,6 +481,8 @@ static int sr_attach(Scsi_Device * SDp)
 	if (i >= sr_template.dev_max)
 		panic("scsi_devices corrupt (sr)");
 
+	if (sr_init_one(cpnt, i))
+		goto fail;
 
 	scsi_CDs[i].device = SDp;
 
@@ -494,6 +493,10 @@ static int sr_attach(Scsi_Device * SDp)
 	printk("Attached scsi CD-ROM %s at scsi%d, channel %d, id %d, lun %d\n",
 	       scsi_CDs[i].cdi.name, SDp->host->host_no, SDp->channel, SDp->id, SDp->lun);
 	return 0;
+
+fail:
+	SDp->attached--;
+	return 1;
 }
 
 
@@ -744,64 +747,56 @@ cleanup_dev:
 	return 1;
 }
 
-void sr_finish()
+static int sr_init_one(Scsi_CD *cd, int first_minor)
 {
-	int i;
+	struct gendisk *disk;
 
-	for (i = 0; i < sr_template.nr_dev; ++i) {
-		struct gendisk *disk;
-		Scsi_CD *cd = &scsi_CDs[i];
-		/* If we have already seen this, then skip it.  Comes up
-		 * with loadable modules. */
-		if (cd->disk)
-			continue;
-		disk = alloc_disk(1);
-		if (!disk)
-			continue;
-		if (cd->disk) {
-			put_disk(disk);
-			continue;
-		}
-		disk->major = MAJOR_NR;
-		disk->first_minor = i;
-		strcpy(disk->disk_name, cd->cdi.name);
-		disk->fops = &sr_bdops;
-		disk->flags = GENHD_FL_CD;
-		cd->disk = disk;
-		cd->capacity = 0x1fffff;
-		cd->device->sector_size = 2048;/* A guess, just in case */
-		cd->needs_sector_size = 1;
-		cd->device->changed = 1;	/* force recheck CD type */
+	disk = alloc_disk(1);
+	if (!disk)
+		return -ENOMEM;
+
+	disk->major = MAJOR_NR;
+	disk->first_minor = first_minor;
+	strcpy(disk->disk_name, cd->cdi.name);
+	disk->fops = &sr_bdops;
+	disk->flags = GENHD_FL_CD;
+	cd->disk = disk;
+	cd->capacity = 0x1fffff;
+	cd->device->sector_size = 2048;/* A guess, just in case */
+	cd->needs_sector_size = 1;
+	cd->device->changed = 1;	/* force recheck CD type */
 #if 0
-		/* seems better to leave this for later */
-		get_sectorsize(cd);
-		printk("Scd sectorsize = %d bytes.\n", cd->sector_size);
+	/* seems better to leave this for later */
+	get_sectorsize(cd);
+	printk("Scd sectorsize = %d bytes.\n", cd->sector_size);
 #endif
-		cd->use = 1;
+	cd->use = 1;
 
-		cd->device->ten = 1;
-		cd->device->remap = 1;
-		cd->readcd_known = 0;
-		cd->readcd_cdda = 0;
-
-		cd->cdi.ops = &sr_dops;
-		cd->cdi.handle = cd;
-		cd->cdi.mask = 0;
-		cd->cdi.capacity = 1;
-		/*
-		 *	FIXME: someone needs to handle a get_capabilities
-		 *	failure properly ??
-		 */
-		get_capabilities(cd);
-		sr_vendor_init(cd);
-		disk->de = cd->device->de;
-		disk->driverfs_dev = &cd->device->sdev_driverfs_dev;
-		register_cdrom(&cd->cdi);
-		set_capacity(disk, cd->capacity);
-		disk->private_data = cd;
-		disk->queue = &cd->device->request_queue;
-		add_disk(disk);
-	}
+	cd->device->ten = 1;
+	cd->device->remap = 1;
+	cd->readcd_known = 0;
+	cd->readcd_cdda = 0;
+
+	cd->cdi.ops = &sr_dops;
+	cd->cdi.handle = cd;
+	cd->cdi.mask = 0;
+	cd->cdi.capacity = 1;
+
+	/*
+	 *	FIXME: someone needs to handle a get_capabilities
+	 *	failure properly ??
+	 */
+	get_capabilities(cd);
+	sr_vendor_init(cd);
+	disk->de = cd->device->de;
+	disk->driverfs_dev = &cd->device->sdev_driverfs_dev;
+	register_cdrom(&cd->cdi);
+	set_capacity(disk, cd->capacity);
+	disk->private_data = cd;
+	disk->queue = &cd->device->request_queue;
+	add_disk(disk);
+
+	return 0;
 }
 
 static void sr_detach(Scsi_Device * SDp)
