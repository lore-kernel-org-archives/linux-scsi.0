From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] get rid of global arrays in sd
Date: Mon, 28 Oct 2002 17:38:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021028173820.A25365@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Okay, this is the final version of the sd patch to remove sd_dsk_arr.
Instead of keeping a big global array we allocate one structure for
each disk dynamically in sd_attach.  We can use the higher level
private data to access it almost everywhere, for the few other
places we keep a linked list of all disks (these are walked only
in slow-pathe=DF).

This patch also allows to get rid of the sd_init midlayer method and
the CONFIG_SD_EXTRA_DEVS option - sd has no more static limit to
the number of disk except of the number of assigned majors.


--- 1.3/drivers/scsi/Config.help	Tue Oct  1 19:04:56 2002
+++ edited/drivers/scsi/Config.help	Mon Oct 28 16:27:38 2002
@@ -34,19 +34,6 @@
   is located on a SCSI disk. In this case, do not compile the driver
   for your SCSI host adapter (below) as a module either.
=20
-CONFIG_SD_EXTRA_DEVS
-  This controls the amount of additional space allocated in tables for
-  drivers that are loaded as modules after the kernel is booted.  In
-  the event that the SCSI core itself was loaded as a module, this
-  value is the number of additional disks that can be loaded after the
-  first host driver is loaded.
-
-  Admittedly this isn't pretty, but there are tons of race conditions
-  involved with resizing the internal arrays on the fly.  Someday this
-  flag will go away, and everything will work automatically.
-
-  If you don't understand what's going on, go with the default.
-
 CONFIG_CHR_DEV_ST
   If you want to use a SCSI tape drive under Linux, say Y and read the
   SCSI-HOWTO, available from
--- 1.16/drivers/scsi/Config.in	Fri Oct 11 10:24:07 2002
+++ edited/drivers/scsi/Config.in	Mon Oct 28 16:27:38 2002
@@ -2,10 +2,6 @@
=20
 dep_tristate '  SCSI disk support' CONFIG_BLK_DEV_SD $CONFIG_SCSI
=20
-if [ "$CONFIG_BLK_DEV_SD" !=3D "n" ]; then
-   int  'Maximum number of SCSI disks that can be loaded as modules' C=
ONFIG_SD_EXTRA_DEVS 40
-fi
-
 dep_tristate '  SCSI tape support' CONFIG_CHR_DEV_ST $CONFIG_SCSI
=20
 dep_tristate '  SCSI OnStream SC-x0 tape support' CONFIG_CHR_DEV_OSST =
$CONFIG_SCSI
--- 1.23/drivers/scsi/hosts.h	Mon Oct 28 01:41:15 2002
+++ edited/drivers/scsi/hosts.h	Mon Oct 28 16:27:38 2002
@@ -620,13 +620,9 @@
  * The generics driver has been updated to resize as required.  So as =
the tape
  * driver. Two down, two more to go.
  */
-#ifndef CONFIG_SD_EXTRA_DEVS
-#define CONFIG_SD_EXTRA_DEVS 2
-#endif
 #ifndef CONFIG_SR_EXTRA_DEVS
 #define CONFIG_SR_EXTRA_DEVS 2
 #endif
-#define SD_EXTRA_DEVS CONFIG_SD_EXTRA_DEVS
 #define SR_EXTRA_DEVS CONFIG_SR_EXTRA_DEVS
=20
=20
--- 1.78/drivers/scsi/sd.c	Sun Oct 27 16:54:59 2002
+++ edited/drivers/scsi/sd.c	Mon Oct 28 17:17:57 2002
@@ -54,29 +54,17 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
=20
-
-#define N_SD_MAJORS	8
-#define SD_MAJOR_MASK	(N_SD_MAJORS - 1)
-
-#define SD_MAJOR(i) (!(i) ? SCSI_DISK0_MAJOR : SCSI_DISK1_MAJOR-1+(i))
-
-#define SCSI_DISKS_PER_MAJOR	16
-#define SD_MAJOR_NUMBER(i)	SD_MAJOR((i) >> 8)
-#define SD_MINOR_NUMBER(i)	((i) & 255)
-#define MKDEV_SD_PARTITION(i)	mk_kdev(SD_MAJOR_NUMBER(i), (i) & 255)
-#define MKDEV_SD(index)		MKDEV_SD_PARTITION((index) << 4)
-#define N_USED_SD_MAJORS	(1 + ((sd_template.dev_max - 1) >> 4))
-
 /*
- *  Time out in seconds for disks and Magneto-opticals (which are slow=
er).
+ * Remaining dev_t-handling stuff
  */
-#define SD_TIMEOUT		(30 * HZ)
-#define SD_MOD_TIMEOUT		(75 * HZ)
+#define SD_MAJORS	8
+#define SD_MAJOR(i)	((i) ? SCSI_DISK1_MAJOR+(i) : SCSI_DISK0_MAJOR)
=20
 /*
- * Amount to over allocate sd_dsk_arr by
+ * Time out in seconds for disks and Magneto-opticals (which are slowe=
r).
  */
-#define SD_DSK_ARR_LUMP		6
+#define SD_TIMEOUT		(30 * HZ)
+#define SD_MOD_TIMEOUT		(75 * HZ)
=20
 /*
  * Number of allowed retries
@@ -84,6 +72,7 @@
 #define SD_MAX_RETRIES		5
=20
 struct scsi_disk {
+	struct list_head list;		/* list of all scsi_disks */
 	struct scsi_device *device;
 	struct gendisk	*disk;
 	sector_t	capacity;	/* size in 512-byte sectors */
@@ -93,20 +82,20 @@
 	unsigned	RCD : 1;	/* state of disk RCD bit */
 };
=20
-static struct scsi_disk ** sd_dsk_arr;
-static rwlock_t sd_dsk_arr_lock =3D RW_LOCK_UNLOCKED;
+static LIST_HEAD(sd_devlist);
+static spinlock_t sd_devlist_lock =3D SPIN_LOCK_UNLOCKED;
=20
 static int check_scsidisk_media_change(struct gendisk *);
 static int sd_revalidate(struct gendisk *);
=20
 static void sd_init_onedisk(struct scsi_disk * sdkp, struct gendisk *d=
isk);
+static void sd_rw_intr(struct scsi_cmnd * SCpnt);
=20
-static int sd_init(void);
 static int sd_attach(struct scsi_device *);
 static int sd_detect(struct scsi_device *);
 static void sd_detach(struct scsi_device *);
 static int sd_init_command(struct scsi_cmnd *);
-static int sd_synchronize_cache(int, int);
+static int sd_synchronize_cache(struct scsi_disk *, int);
 static int sd_notifier(struct notifier_block *, unsigned long, void *)=
;
=20
 static struct notifier_block sd_notifier_block =3D {sd_notifier, NULL,=
 0};=20
@@ -121,58 +110,40 @@
 	.max_major	=3D SCSI_DISK7_MAJOR,
 	.blk		=3D 1,
 	.detect		=3D sd_detect,
-	.init		=3D sd_init,
 	.attach		=3D sd_attach,
 	.detach		=3D sd_detach,
 	.init_command	=3D sd_init_command,
 };
=20
-static void sd_rw_intr(struct scsi_cmnd * SCpnt);
-
-static struct scsi_disk * sd_get_sdisk(int index);
-
-#if defined(CONFIG_PPC32)
-/**
- *	sd_find_target - find kdev_t of first scsi disk that matches
- *	given host and scsi_id.=20
- *	@host: Scsi_Host object pointer that owns scsi device of interest
- *	@scsi_id: scsi (target) id number of device of interest
- *
- *	Returns kdev_t of first scsi device that matches arguments or
- *	NODEV of no match.
- *
- *	Notes: Looks like a hack, should scan for <host,channel,id,lin>
- *	tuple.
- *	[Architectural dependency: ppc only.] Moved here from=20
- *	arch/ppc/pmac_setup.c.
- **/
-kdev_t __init
-sd_find_target(void *hp, int scsi_id)
+static struct scsi_disk *sd_find_by_sdev(Scsi_Device *sd)
 {
 	struct scsi_disk *sdkp;
-	struct scsi_device *sdp;
-	struct Scsi_Host *shp =3D hp;
-	int dsk_nr;
-	kdev_t retval =3D NODEV;
-	unsigned long iflags;
=20
-	SCSI_LOG_HLQUEUE(3, printk("sd_find_target: host_nr=3D%d, "
-			    "scsi_id=3D%d\n", shp->host_no, scsi_id));
-	read_lock_irqsave(&sd_dsk_arr_lock, iflags);
-	for (dsk_nr =3D 0; dsk_nr < sd_template.dev_max; ++dsk_nr) {
-		sdkp =3D sd_dsk_arr[dsk_nr];
-		if (sdkp =3D=3D NULL)
-			continue;
-		sdp =3D sdkp->device;
-		if (sdp && (sdp->host =3D=3D shp) && (sdp->id =3D=3D scsi_id)) {
-			retval =3D MKDEV_SD(dsk_nr);
-			break;
+	spin_lock(&sd_devlist_lock);
+	list_for_each_entry(sdkp, &sd_devlist, list) {
+		if (sdkp->device =3D=3D sd) {
+			spin_unlock(&sd_devlist_lock);
+			return sdkp;
 		}
 	}
-	read_unlock_irqrestore(&sd_dsk_arr_lock, iflags);
-	return retval;
+
+	spin_unlock(&sd_devlist_lock);
+	return NULL;
+}
+
+static inline void sd_devlist_insert(struct scsi_disk *sdkp)
+{
+	spin_lock(&sd_devlist_lock);
+	list_add(&sdkp->list, &sd_devlist);
+	spin_unlock(&sd_devlist_lock);
+}
+
+static inline void sd_devlist_remove(struct scsi_disk *sdkp)
+{
+	spin_lock(&sd_devlist_lock);
+	list_del(&sdkp->list);
+	spin_unlock(&sd_devlist_lock);
 }
-#endif
=20
 /**
  *	sd_ioctl - process an ioctl
@@ -1188,94 +1159,6 @@
 	kfree(buffer);
 }
=20
-/*
- * The sd_init() function looks at all SCSI drives present, determines
- * their size, and reads partition table entries for them.
- */
-
-static int sd_registered;
-
-/**
- *	sd_init- called during driver initialization (after
- *	sd_detect() is called for each scsi device present).
- *
- *	Returns 0 is successful (or already called); 1 if error
- *
- *	Note: this function is invoked from the scsi mid-level.
- **/
-static int sd_init()
-{
-	int k, maxparts;
-	struct scsi_disk * sdkp;
-
-	SCSI_LOG_HLQUEUE(3, printk("sd_init: dev_noticed=3D%d\n",
-			    sd_template.dev_noticed));
-	if (sd_template.dev_noticed =3D=3D 0)
-		return 0;
-
-	if (NULL =3D=3D sd_dsk_arr)
-		sd_template.dev_max =3D sd_template.dev_noticed + SD_EXTRA_DEVS;
-
-	if (sd_template.dev_max > N_SD_MAJORS * SCSI_DISKS_PER_MAJOR)
-		sd_template.dev_max =3D N_SD_MAJORS * SCSI_DISKS_PER_MAJOR;
-
-	/* At most 16 partitions on each scsi disk. */
-	maxparts =3D (sd_template.dev_max << 4);
-	if (maxparts =3D=3D 0)
-		return 0;
-
-	if (!sd_registered) {
-		for (k =3D 0; k < N_USED_SD_MAJORS; k++) {
-			if (register_blkdev(SD_MAJOR(k), "sd", &sd_fops)) {
-				printk(KERN_NOTICE "Unable to get major %d "
-				       "for SCSI disk\n", SD_MAJOR(k));
-				return 1;
-			}
-		}
-		sd_registered++;
-	}
-	/* We do not support attaching loadable devices yet. */
-	if (sd_dsk_arr)
-		return 0;
-
-	/* allocate memory */
-#define init_mem_lth(x,n)	x =3D vmalloc((n) * sizeof(*x))
-#define zero_mem_lth(x,n)	memset(x, 0, (n) * sizeof(*x))
-
-	init_mem_lth(sd_dsk_arr, sd_template.dev_max);
-	if (sd_dsk_arr) {
-		zero_mem_lth(sd_dsk_arr, sd_template.dev_max);
-		for (k =3D 0; k < sd_template.dev_max; ++k) {
-			sdkp =3D vmalloc(sizeof(struct scsi_disk));
-			if (NULL =3D=3D sdkp)
-				goto cleanup_mem;
-			memset(sdkp, 0, sizeof(struct scsi_disk));
-			sd_dsk_arr[k] =3D sdkp;
-		}
-	}
-
-	if (!sd_dsk_arr)
-		goto cleanup_mem;
-
-	return 0;
-
-#undef init_mem_lth
-#undef zero_mem_lth
-
-cleanup_mem:
-	if (sd_dsk_arr) {
-                for (k =3D 0; k < sd_template.dev_max; ++k)
-			vfree(sd_dsk_arr[k]);
-		vfree(sd_dsk_arr);
-		sd_dsk_arr =3D NULL;
-	}
-	for (k =3D 0; k < N_USED_SD_MAJORS; k++) {
-		unregister_blkdev(SD_MAJOR(k), "sd");
-	}
-	sd_registered--;
-	return 1;
-}
-
 /**
  *	sd_detect - called at the start of driver initialization, once=20
  *	for each scsi device (not just disks) present.
@@ -1284,7 +1167,6 @@
  *	1 if this device is of interest (e.g. a disk).
  *
  *	Note: this function is invoked from the scsi mid-level.
- *	This function is called before sd_init() so very little is availabl=
e.
  **/
 static int sd_detect(struct scsi_device * sdp)
 {
@@ -1309,51 +1191,43 @@
  *	<host,channel,id,lun> (found in sdp) and new device name=20
  *	(e.g. /dev/sda). More precisely it is the block device major=20
  *	and minor number that is chosen here.
+ *
+ *	Assume sd_attach is not re-entrant (for time being)
+ *	Also think about sd_attach() and sd_detach() running coincidentally=
=2E
  **/
 static int sd_attach(struct scsi_device * sdp)
 {
 	struct scsi_disk *sdkp =3D NULL;	/* shut up lame gcc warning */
 	int dsk_nr;
-	unsigned long iflags;
 	struct gendisk *gd;
=20
 	if ((sdp->type !=3D TYPE_DISK) && (sdp->type !=3D TYPE_MOD))
 		return 0;
=20
-	gd =3D alloc_disk(16);
-	if (!gd)
-		return 1;
-
 	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n",=
=20
 			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
=20
-	if (sd_template.nr_dev >=3D sd_template.dev_max) {
-		printk(KERN_ERR "sd_init: no more room for device\n");
+	sdkp =3D kmalloc(sizeof(*sdkp), GFP_KERNEL);
+	if (!sdkp)
 		goto out;
-	}
+
+	gd =3D alloc_disk(16);
+	if (!gd)
+		goto out_free;
=20
 	/*
-	 * Assume sd_attach is not re-entrant (for time being)
-	 * Also think about sd_attach() and sd_detach() running coincidentall=
y.
+	 * XXX  This doesn't make us better than the previous code in the
+	 * XXX  end (not worse either, though..).
+	 * XXX  To properly support hotplugging we should have a bitmap and
+	 * XXX  use find_first_zero_bit on it.  This will happen at the
+	 * XXX  same time template->nr_* goes away.		--hch
 	 */
-	write_lock_irqsave(&sd_dsk_arr_lock, iflags);
-	for (dsk_nr =3D 0; dsk_nr < sd_template.dev_max; dsk_nr++) {
-		sdkp =3D sd_dsk_arr[dsk_nr];
-		if (!sdkp->device) {
-			memset(sdkp, 0, sizeof(struct scsi_disk));
-			sdkp->device =3D sdp;
-			break;
-		}
-	}
-	write_unlock_irqrestore(&sd_dsk_arr_lock, iflags);
+	dsk_nr =3D sd_template.nr_dev++;
=20
-	if (!sdkp || dsk_nr >=3D sd_template.dev_max) {
-		printk(KERN_ERR "sd_init: sd_dsk_arr corrupted\n");
-		goto out;
-	}
+	sdkp->device =3D sdp;
+	sdkp->disk =3D gd;
=20
 	sd_init_onedisk(sdkp, gd);
-	sd_template.nr_dev++;
=20
 	gd->de =3D sdp->de;
 	gd->major =3D SD_MAJOR(dsk_nr>>4);
@@ -1363,24 +1237,28 @@
 		sprintf(gd->disk_name, "sd%c%c",'a'+dsk_nr/26-1,'a'+dsk_nr%26);
 	else
 		sprintf(gd->disk_name, "sd%c",'a'+dsk_nr%26);
-	gd->flags =3D sdp->removable ? GENHD_FL_REMOVABLE : 0;
 	gd->driverfs_dev =3D &sdp->sdev_driverfs_dev;
-	gd->flags |=3D GENHD_FL_DRIVERFS | GENHD_FL_DEVFS;
+	gd->flags =3D GENHD_FL_DRIVERFS | GENHD_FL_DEVFS;
+	if (sdp->removable)
+		gd->flags |=3D GENHD_FL_REMOVABLE;
 	gd->private_data =3D sdkp;
 	gd->queue =3D &sdkp->device->request_queue;
=20
+	sd_devlist_insert(sdkp);
 	set_capacity(gd, sdkp->capacity);
 	add_disk(gd);
-	sdkp->disk =3D gd;
=20
 	printk(KERN_NOTICE "Attached scsi %sdisk %s at scsi%d, channel %d, "
 	       "id %d, lun %d\n", sdp->removable ? "removable " : "",
-	       gd->disk_name, sdp->host->host_no, sdp->channel, sdp->id, sdp-=
>lun);
+	       gd->disk_name, sdp->host->host_no, sdp->channel,
+	       sdp->id, sdp->lun);
+
 	return 0;
=20
+out_free:
+	kfree(sdkp);
 out:
 	sdp->attached--;
-	put_disk(gd);
 	return 1;
 }
=20
@@ -1409,39 +1287,30 @@
  **/
 static void sd_detach(struct scsi_device * sdp)
 {
-	struct scsi_disk *sdkp =3D NULL;
-	int dsk_nr;
-	unsigned long iflags;
+	struct scsi_disk *sdkp;
=20
 	SCSI_LOG_HLQUEUE(3, printk("sd_detach: <%d,%d,%d,%d>\n",=20
 			    sdp->host->host_no, sdp->channel, sdp->id,=20
 			    sdp->lun));
-	write_lock_irqsave(&sd_dsk_arr_lock, iflags);
-	for (dsk_nr =3D 0; dsk_nr < sd_template.dev_max; dsk_nr++) {
-		sdkp =3D sd_dsk_arr[dsk_nr];
-		if (sdkp->device =3D=3D sdp) {
-			break;
-		}
-	}
-	write_unlock_irqrestore(&sd_dsk_arr_lock, iflags);
-	if (dsk_nr >=3D sd_template.dev_max)
+
+	sdkp =3D sd_find_by_sdev(sdp);
+	if (!sdkp)
 		return;
=20
 	/* check that we actually have a write back cache to synchronize */
-	if(sdkp->WCE) {
+	if (sdkp->WCE) {
 		printk(KERN_NOTICE "Synchronizing SCSI cache: ");
-		sd_synchronize_cache(dsk_nr, 1);
+		sd_synchronize_cache(sdkp, 1);
 		printk("\n");
 	}
-	sdkp->device =3D NULL;
-	sdkp->capacity =3D 0;
-	/* sdkp->detaching =3D 1; */
=20
+	sd_devlist_remove(sdkp);
 	del_gendisk(sdkp->disk);
 	sdp->attached--;
 	sd_template.dev_noticed--;
 	sd_template.nr_dev--;
 	put_disk(sdkp->disk);
+	kfree(sdkp);
 }
=20
 /**
@@ -1452,16 +1321,29 @@
  **/
 static int __init init_sd(void)
 {
-	int rc;
+	int majors =3D 0, rc =3D -ENODEV, i;
+
 	SCSI_LOG_HLQUEUE(3, printk("init_sd: sd driver entry point\n"));
-	sd_template.module =3D THIS_MODULE;
-	rc =3D scsi_register_device(&sd_template);
-	if (!rc) {
-		sd_template.scsi_driverfs_driver.name =3D (char *)sd_template.tag;
-		sd_template.scsi_driverfs_driver.bus =3D &scsi_driverfs_bus_type;
-		driver_register(&sd_template.scsi_driverfs_driver);
-		register_reboot_notifier(&sd_notifier_block);
+
+	for (i =3D 0; i < SD_MAJORS; i++) {
+		if (register_blkdev(SD_MAJOR(i), "sd", &sd_fops))
+			printk(KERN_NOTICE
+			       "Unable to get major %d for SCSI disk\n",
+			       SD_MAJOR(i));
+		else
+			majors++;
 	}
+
+	if (!majors)
+		return -ENODEV;
+
+	rc =3D scsi_register_device(&sd_template);
+	if (rc)
+		return rc;
+	sd_template.scsi_driverfs_driver.name =3D (char *)sd_template.tag;
+	sd_template.scsi_driverfs_driver.bus =3D &scsi_driverfs_bus_type;
+	driver_register(&sd_template.scsi_driverfs_driver);
+	register_reboot_notifier(&sd_notifier_block);
 	return rc;
 }
=20
@@ -1472,48 +1354,38 @@
  **/
 static void __exit exit_sd(void)
 {
-	int k;
+	int i;
=20
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
-	scsi_unregister_device(&sd_template);
-	for (k =3D 0; k < N_USED_SD_MAJORS; k++)
-		unregister_blkdev(SD_MAJOR(k), "sd");
-
-	sd_registered--;
-	if (sd_dsk_arr !=3D NULL) {
-		for (k =3D 0; k < sd_template.dev_max; ++k)
-			vfree(sd_dsk_arr[k]);
-		vfree(sd_dsk_arr);
-	}
-	sd_template.dev_max =3D 0;
-	driver_unregister(&sd_template.scsi_driverfs_driver);
=20
 	unregister_reboot_notifier(&sd_notifier_block);
+	scsi_unregister_device(&sd_template);
+	for (i =3D 0; i < SD_MAJORS; i++)
+		unregister_blkdev(SD_MAJOR(i), "sd");
+	driver_unregister(&sd_template.scsi_driverfs_driver);
 }
=20
-static int sd_notifier(struct notifier_block *nbt, unsigned long event=
, void *buf)
+/*
+ * XXX: this function does not take sd_devlist_lock to synchronize
+ *	access to sd_devlist.  This should be safe as no other reboot
+ *	notifier can access it.
+ */
+static int sd_notifier(struct notifier_block *n, unsigned long event, =
void *p)
 {
-	int i;
-	char *msg =3D "Synchronizing SCSI caches: ";
-
-	if (!(event =3D=3D SYS_RESTART || event =3D=3D SYS_HALT=20
-	      || event =3D=3D SYS_POWER_OFF))
+	if (event !=3D SYS_RESTART &&
+	    event !=3D SYS_HALT &&
+	    event !=3D SYS_POWER_OFF)
 		return NOTIFY_DONE;
-	for (i =3D 0; i < sd_template.dev_max; i++) {
-		struct scsi_disk *sdkp =3D sd_get_sdisk(i);
=20
-		if (!sdkp || !sdkp->device)
-			continue;
-		if (sdkp->WCE) {
-			if(msg) {
-				printk(KERN_NOTICE "%s", msg);
-				msg =3D NULL;
-			}
-			sd_synchronize_cache(i, 1);
-		}
-	}
-	if(!msg)
+	if (!list_empty(&sd_devlist)) {
+		struct scsi_disk *sdkp;
+
+		printk(KERN_NOTICE "Synchronizing SCSI caches: ");
+		list_for_each_entry(sdkp, &sd_devlist, list)
+			if (sdkp->WCE)
+				sd_synchronize_cache(sdkp, 1);
 		printk("\n");
+	}
=20
 	return NOTIFY_OK;
 }
@@ -1521,10 +1393,9 @@
 /* send a SYNCHRONIZE CACHE instruction down to the device through the
  * normal SCSI command structure.  Wait for the command to complete (m=
ust
  * have user context) */
-static int sd_synchronize_cache(int index, int verbose)
+static int sd_synchronize_cache(struct scsi_disk *sdkp, int verbose)
 {
 	struct scsi_request *SRpnt;
-	struct scsi_disk *sdkp =3D sd_get_sdisk(index);
 	struct scsi_device *SDpnt =3D sdkp->device;
 	int retries, the_result;
=20
@@ -1570,18 +1441,6 @@
 	}
 	scsi_release_request(SRpnt);
 	return (the_result =3D=3D 0);
-}
-
-static struct scsi_disk * sd_get_sdisk(int index)
-{
-	struct scsi_disk * sdkp =3D NULL;
-	unsigned long iflags;
-
-	read_lock_irqsave(&sd_dsk_arr_lock, iflags);
-	if (sd_dsk_arr && (index >=3D 0) && (index < sd_template.dev_max))
-		sdkp =3D sd_dsk_arr[index];
-	read_unlock_irqrestore(&sd_dsk_arr_lock, iflags);
-	return sdkp;
 }
=20
 MODULE_LICENSE("GPL");
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
