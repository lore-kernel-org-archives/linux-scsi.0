From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] get rid of global arrays in sr
Date: Sun, 3 Nov 2002 18:20:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021103182050.A7037@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de
Cc: linux-scsi@vger.kernel.org

Similar cleanup to the recent sd patch:  allocate the scsi_cd struct
in sd_attach instead of needing the global array and sd_init.

Tested with a DVD reader/CD write combination and ide-scsi.


--- 1.1/drivers/scsi/Kconfig	Tue Oct 29 20:17:15 2002
+++ edited/drivers/scsi/Kconfig	Sun Nov  3 13:23:26 2002
@@ -85,23 +85,6 @@
 	  drives (and HP Writers). If you have such a drive and get the first
 	  session only, try saying Y here; everybody else says N.
 
-config SR_EXTRA_DEVS
-	int "Maximum number of CDROM devices that can be loaded as modules"
-	depends on BLK_DEV_SR
-	default "2"
-	---help---
-	  This controls the amount of additional space allocated in tables for
-	  drivers that are loaded as modules after the kernel is booted. In
-	  the event that the SCSI core itself was loaded as a module, this
-	  value is the number of additional CD-ROMs that can be loaded after
-	  the first host driver is loaded.
-
-	  Admittedly this isn't pretty, but there are tons of race conditions
-	  involved with resizing the internal arrays on the fly.  Someday this
-	  flag will go away, and everything will work automatically.
-
-	  If you don't understand what's going on, go with the default.
-
 config CHR_DEV_SG
 	tristate "SCSI generic support"
 	depends on SCSI
===== drivers/scsi/hosts.h 1.27 vs edited =====
--- 1.27/drivers/scsi/hosts.h	Fri Nov  1 15:42:44 2002
+++ edited/drivers/scsi/hosts.h	Sun Nov  3 13:24:37 2002
@@ -605,28 +605,6 @@
 extern void scsi_host_busy_dec_and_test(struct Scsi_Host *, Scsi_Device *);
 extern void scsi_host_failed_inc_and_test(struct Scsi_Host *);
 
-/*
- * This is an ugly hack.  If we expect to be able to load devices at run time,
- * we need to leave extra room in some of the data structures.	Doing a
- * realloc to enlarge the structures would be riddled with race conditions,
- * so until a better solution is discovered, we use this crude approach
- *
- * Even bigger hack for SparcSTORAGE arrays. Those are at least 6 disks, but
- * usually up to 30 disks, so everyone would need to change this. -jj
- *
- * Note: These things are all evil and all need to go away.  My plan is to
- * tackle the character devices first, as there aren't any locking implications
- * in the block device layer.   The block devices will require more work.
- *
- * The generics driver has been updated to resize as required.  So as the tape
- * driver. Two down, two more to go.
- */
-#ifndef CONFIG_SR_EXTRA_DEVS
-#define CONFIG_SR_EXTRA_DEVS 2
-#endif
-#define SR_EXTRA_DEVS CONFIG_SR_EXTRA_DEVS
-
-
 /**
  * scsi_find_device - find a device given the host
  * @shost:	SCSI host pointer
--- 1.61/drivers/scsi/sr.c	Fri Nov  1 07:28:12 2002
+++ edited/drivers/scsi/sr.c	Sun Nov  3 13:49:04 2002
@@ -65,7 +65,6 @@
 	 CDC_PLAY_AUDIO|CDC_RESET|CDC_IOCTLS|CDC_DRIVE_STATUS| \
 	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_GENERIC_PACKET)
 
-static int sr_init(void);
 static int sr_attach(struct scsi_device *);
 static int sr_detect(struct scsi_device *);
 static void sr_detach(struct scsi_device *);
@@ -79,22 +78,52 @@
 	.scsi_type	= TYPE_ROM,
 	.blk		= 1,
 	.detect		= sr_detect,
-	.init		= sr_init,
 	.attach		= sr_attach,
 	.detach		= sr_detach,
 	.init_command	= sr_init_command
 };
 
-static struct scsi_cd *scsi_CDs;
+static LIST_HEAD(sr_devlist);
+static spinlock_t sr_devlist_lock = SPIN_LOCK_UNLOCKED;
 
 static int sr_open(struct cdrom_device_info *, int);
 static void get_sectorsize(struct scsi_cd *);
 static void get_capabilities(struct scsi_cd *);
-static int sr_init_one(struct scsi_cd *, int);
 
 static int sr_media_change(struct cdrom_device_info *, int);
 static int sr_packet(struct cdrom_device_info *, struct cdrom_generic_command *);
 
+static Scsi_CD *sr_find_by_sdev(Scsi_Device *sd)
+{
+	struct list_head *p;
+	Scsi_CD *cd;
+
+	spin_lock(&sr_devlist_lock);
+	list_for_each(p, &sr_devlist) {
+		cd = list_entry(p, Scsi_CD, list);
+		if (cd->device == sd) {
+			spin_unlock(&sr_devlist_lock);
+			return cd;
+		}
+	}
+	spin_unlock(&sr_devlist_lock);
+	return NULL;
+}
+
+static inline void sr_devlist_insert(Scsi_CD *cd)
+{
+	spin_lock(&sr_devlist_lock);
+	list_add(&cd->list, &sr_devlist);
+	spin_unlock(&sr_devlist_lock);
+}
+
+static inline void sr_devlist_remove(Scsi_CD *cd)
+{
+	spin_lock(&sr_devlist_lock);
+	list_del(&cd->list);
+	spin_unlock(&sr_devlist_lock);
+}
+
 static void sr_release(struct cdrom_device_info *cdi)
 {
 	struct scsi_cd *cd = cdi->handle;
@@ -470,40 +499,84 @@
 	return 1;
 }
 
-static int sr_attach(struct scsi_device * SDp)
+static int sr_attach(struct scsi_device *sdev)
 {
-	struct scsi_cd *cpnt;
-	int i;
+	struct gendisk *disk;
+	struct scsi_cd *cd;
+	int minor;
 
-	if (SDp->type != TYPE_ROM && SDp->type != TYPE_WORM)
+	if (sdev->type != TYPE_ROM && sdev->type != TYPE_WORM)
 		return 1;
 
-	if (sr_template.nr_dev >= sr_template.dev_max)
+	cd = kmalloc(sizeof(*cd), GFP_KERNEL);
+	if (!cd)
 		goto fail;
+	memset(cd, 0, sizeof(*cd));
 
-	for (cpnt = scsi_CDs, i = 0; i < sr_template.dev_max; i++, cpnt++)
-		if (!cpnt->device)
-			break;
+	disk = alloc_disk(1);
+	if (!disk)
+		goto fail_free;
 
-	if (i >= sr_template.dev_max)
-		panic("scsi_devices corrupt (sr)");
+	/*
+	 * XXX  This doesn't make us better than the previous code in the
+	 * XXX  end (not worse either, though..).
+	 * XXX  To properly support hotplugging we should have a bitmap and
+	 * XXX  use find_first_zero_bit on it.  This will happen at the
+	 * XXX  same time template->nr_* goes away.		--hch
+	 */
+	minor = sr_template.nr_dev++;
 
-	scsi_CDs[i].device = SDp;
+	disk->major = MAJOR_NR;
+	disk->first_minor = minor;
+	sprintf(disk->disk_name, "sr%d", minor);
+	disk->fops = &sr_bdops;
+	disk->flags = GENHD_FL_CD;
 
-	if (sr_init_one(cpnt, i))
-		goto fail;
+	cd->device = sdev;
+	cd->disk = disk;
+	cd->driver = &sr_template;
+	cd->disk = disk;
+	cd->capacity = 0x1fffff;
+	cd->needs_sector_size = 1;
+	cd->device->changed = 1;	/* force recheck CD type */
+	cd->use = 1;
+	cd->readcd_known = 0;
+	cd->readcd_cdda = 0;
+
+	cd->cdi.ops = &sr_dops;
+	cd->cdi.handle = cd;
+	cd->cdi.mask = 0;
+	cd->cdi.capacity = 1;
+	sprintf(cd->cdi.name, "sr%d", minor);
 
-	sr_template.nr_dev++;
-	if (sr_template.nr_dev > sr_template.dev_max)
-		panic("scsi_devices corrupt (sr)");
-
-	printk("Attached scsi CD-ROM %s at scsi%d, channel %d, id %d, lun %d\n",
-	       scsi_CDs[i].cdi.name, SDp->host->host_no, SDp->channel,
-	       SDp->id, SDp->lun);
+	sdev->sector_size = 2048;	/* A guess, just in case */
+	sdev->ten = 1;
+	sdev->remap = 1;
+
+	/* FIXME: need to handle a get_capabilities failure properly ?? */
+	get_capabilities(cd);
+	sr_vendor_init(cd);
+
+	disk->de = sdev->de;
+	disk->driverfs_dev = &sdev->sdev_driverfs_dev;
+	register_cdrom(&cd->cdi);
+	set_capacity(disk, cd->capacity);
+	disk->private_data = &cd->driver;
+	disk->queue = &sdev->request_queue;
+
+	add_disk(disk);
+	sr_devlist_insert(cd);
+
+	printk(KERN_DEBUG
+	    "Attached scsi CD-ROM %s at scsi%d, channel %d, id %d, lun %d\n",
+	    cd->cdi.name, sdev->host->host_no, sdev->channel,
+	    sdev->id, sdev->lun);
 	return 0;
 
+fail_free:
+	kfree(cd);
 fail:
-	SDp->attached--;
+	sdev->attached--;
 	return 1;
 }
 
@@ -723,126 +796,32 @@
 	return cgc->stat;
 }
 
-static int sr_registered;
-
-static int sr_init()
-{
-	int i;
-	if (sr_template.dev_noticed == 0)
-		return 0;
-
-	if (!sr_registered) {
-		if (register_blkdev(MAJOR_NR, "sr", &sr_bdops)) {
-			printk("Unable to get major %d for SCSI-CD\n",
-					MAJOR_NR);
-			return 1;
-		}
-		sr_registered++;
-	}
-	if (scsi_CDs)
-		return 0;
-
-	sr_template.dev_max = sr_template.dev_noticed + SR_EXTRA_DEVS;
-	scsi_CDs = kmalloc(sr_template.dev_max * sizeof(struct scsi_cd), GFP_ATOMIC);
-	if (!scsi_CDs)
-		goto cleanup_dev;
-	memset(scsi_CDs, 0, sr_template.dev_max * sizeof(struct scsi_cd));
-	for (i = 0; i < sr_template.dev_max; i++)
-		sprintf(scsi_CDs[i].cdi.name, "sr%d", i);
-	return 0;
-
-cleanup_dev:
-	unregister_blkdev(MAJOR_NR, "sr");
-	sr_registered--;
-	return 1;
-}
-
-static int sr_init_one(struct scsi_cd *cd, int first_minor)
+static void sr_detach(struct scsi_device * SDp)
 {
-	struct gendisk *disk;
-
-	disk = alloc_disk(1);
-	if (!disk)
-		return -ENOMEM;
-
-	disk->major = MAJOR_NR;
-	disk->first_minor = first_minor;
-	strcpy(disk->disk_name, cd->cdi.name);
-	disk->fops = &sr_bdops;
-	disk->flags = GENHD_FL_CD;
-	cd->driver = &sr_template;
-	cd->disk = disk;
-	cd->capacity = 0x1fffff;
-	cd->device->sector_size = 2048;/* A guess, just in case */
-	cd->needs_sector_size = 1;
-	cd->device->changed = 1;	/* force recheck CD type */
-#if 0
-	/* seems better to leave this for later */
-	get_sectorsize(cd);
-	printk("Scd sectorsize = %d bytes.\n", cd->sector_size);
-#endif
-	cd->use = 1;
+	struct scsi_cd *cd;
 
-	cd->device->ten = 1;
-	cd->device->remap = 1;
-	cd->readcd_known = 0;
-	cd->readcd_cdda = 0;
-
-	cd->cdi.ops = &sr_dops;
-	cd->cdi.handle = cd;
-	cd->cdi.mask = 0;
-	cd->cdi.capacity = 1;
-
-	/*
-	 *	FIXME: someone needs to handle a get_capabilities
-	 *	failure properly ??
-	 */
-	get_capabilities(cd);
-	sr_vendor_init(cd);
-	disk->de = cd->device->de;
-	disk->driverfs_dev = &cd->device->sdev_driverfs_dev;
-	register_cdrom(&cd->cdi);
-	set_capacity(disk, cd->capacity);
-	disk->private_data = &cd->driver;
-	disk->queue = &cd->device->request_queue;
-	add_disk(disk);
-
-	return 0;
-}
+	cd = sr_find_by_sdev(SDp);
+	if (!cd)
+		return;
 
-static void sr_detach(struct scsi_device * SDp)
-{
-	struct scsi_cd *cpnt;
-	int i;
+	sr_devlist_remove(cd);
+	del_gendisk(cd->disk);
+	put_disk(cd->disk);
+	unregister_cdrom(&cd->cdi);
 
-	for (cpnt = scsi_CDs, i = 0; i < sr_template.dev_max; i++, cpnt++) {
-		if (cpnt->device == SDp) {
-			/*
-			 * Since the cdrom is read-only, no need to sync
-			 * the device.
-			 * We should be kind to our buffer cache, however.
-			 */
-			del_gendisk(cpnt->disk);
-			put_disk(cpnt->disk);
-			cpnt->disk = NULL;
+	SDp->attached--;
+	sr_template.nr_dev--;
 
-			/*
-			 * Reset things back to a sane state so that one can
-			 * re-load a new driver (perhaps the same one).
-			 */
-			unregister_cdrom(&(cpnt->cdi));
-			cpnt->device = NULL;
-			cpnt->capacity = 0;
-			SDp->attached--;
-			sr_template.nr_dev--;
-			sr_template.dev_noticed--;
-			return;
-		}
-	}
+	kfree(cd);
 }
 
 static int __init init_sr(void)
 {
+	int rc;
+
+	rc = register_blkdev(MAJOR_NR, "sr", &sr_bdops);
+	if (rc)
+		return rc;
 	return scsi_register_device(&sr_template);
 }
 
@@ -850,11 +829,6 @@
 {
 	scsi_unregister_device(&sr_template);
 	unregister_blkdev(MAJOR_NR, "sr");
-	sr_registered--;
-	if (scsi_CDs != NULL)
-		kfree(scsi_CDs);
-
-	sr_template.dev_max = 0;
 }
 
 module_init(init_sr);
===== drivers/scsi/sr.h 1.8 vs edited =====
--- 1.8/drivers/scsi/sr.h	Fri Nov  1 07:28:11 2002
+++ edited/drivers/scsi/sr.h	Sun Nov  3 13:46:32 2002
@@ -26,6 +26,7 @@
 
 typedef struct scsi_cd {
 	struct Scsi_Device_Template *driver;
+	struct list_head list;
 	unsigned capacity;	/* size in blocks                       */
 	Scsi_Device *device;
 	unsigned int vendor;	/* vendor code, see sr_vendor.c         */
