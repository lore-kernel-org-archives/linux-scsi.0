From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH][RFC] get rid of global array and ->init in sd.c and sr.c
Date: Tue, 22 Oct 2002 21:07:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021022210739.A10079@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, axboe@suse.dk
Cc: linux-scsi@vger.kernel.org

Okay, here's a rather big patch doing major surgery to sd.c and sr.c,
the patch is again 2.5.44 + my last patch.

(1) Move register_blockdev out of ->init to the module_init routine.
    This is symetric to where we unregister it, and the most logical
    place for it.  Note that we can't open a block device before it's
    gendisk is registered anyway (i.e. in ->attach).
(2) Allocate the Scsi_CD/Scsi_Disk structures one at a time in
    ->attach instead of the ugly global arrays
(3) To still find the devices in ->detach add a global linked list of
    those structures - sd.c also uses it for it's reboot notifier
(4) Get rid of ->init

Note that I could only actually test the sd.c portion, sr.c stuff
will hopefully be tested soon.

Known issues:  We don't have a hotplug aware allocation of minors yet,
we really need some kind of bitmap for this.  I hope we'll get one
for free when Al has finished his CIDR for device :)  The other
problem is that sd's rebott notifer walks the devlist without taking the
lock.  The problem is that it would have to wait under the lock, so we'd
have to make it a semaphore.  But as it's in the reboot notifier we
can't have contention anyway..


--- linux/drivers/scsi/Config.help	Mon Oct 21 17:19:44 2002
+++ linux-scsi/drivers/scsi/Config.help	Tue Oct 22 17:57:35 2002
@@ -34,19 +34,6 @@ CONFIG_BLK_DEV_SD
   is located on a SCSI disk. In this case, do not compile the driver
   for your SCSI host adapter (below) as a module either.
 
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
@@ -93,19 +80,6 @@ CONFIG_BLK_DEV_SR
   The module will be called sr_mod.o. If you want to compile it as a
   module, say M here and read <file:Documentation/modules.txt> and
   <file:Documentation/scsi.txt>.
-
-CONFIG_SR_EXTRA_DEVS
-  This controls the amount of additional space allocated in tables for
-  drivers that are loaded as modules after the kernel is booted. In
-  the event that the SCSI core itself was loaded as a module, this
-  value is the number of additional CD-ROMs that can be loaded after
-  the first host driver is loaded.
-
-  Admittedly this isn't pretty, but there are tons of race conditions
-  involved with resizing the internal arrays on the fly.  Someday this
-  flag will go away, and everything will work automatically.
-
-  If you don't understand what's going on, go with the default.
 
 CONFIG_BLK_DEV_SR_VENDOR
   This enables the usage of vendor specific SCSI commands. This is
--- linux/drivers/scsi/Config.in	Mon Oct 21 17:18:27 2002
+++ linux-scsi/drivers/scsi/Config.in	Tue Oct 22 20:14:55 2002
@@ -1,21 +1,10 @@
 comment 'SCSI support type (disk, tape, CD-ROM)'
 
 dep_tristate '  SCSI disk support' CONFIG_BLK_DEV_SD $CONFIG_SCSI
-
-if [ "$CONFIG_BLK_DEV_SD" != "n" ]; then
-   int  'Maximum number of SCSI disks that can be loaded as modules' CONFIG_SD_EXTRA_DEVS 40
-fi
-
 dep_tristate '  SCSI tape support' CONFIG_CHR_DEV_ST $CONFIG_SCSI
-
 dep_tristate '  SCSI OnStream SC-x0 tape support' CONFIG_CHR_DEV_OSST $CONFIG_SCSI
-
 dep_tristate '  SCSI CDROM support' CONFIG_BLK_DEV_SR $CONFIG_SCSI
-
-if [ "$CONFIG_BLK_DEV_SR" != "n" ]; then
-   bool '    Enable vendor-specific extensions (for SCSI CDROM)' CONFIG_BLK_DEV_SR_VENDOR
-   int  'Maximum number of CDROM devices that can be loaded as modules' CONFIG_SR_EXTRA_DEVS 2
-fi
+dep_mbool'    Enable vendor-specific extensions (for SCSI CDROM)' CONFIG_BLK_DEV_SR_VENDOR $CONFIG_BLK_DEV_SR
 dep_tristate '  SCSI generic support' CONFIG_CHR_DEV_SG $CONFIG_SCSI
 
 comment 'Some SCSI devices (e.g. CD jukebox) support multiple LUNs'
--- linux/drivers/scsi/hosts.h	Mon Oct 21 20:43:56 2002
+++ linux-scsi/drivers/scsi/hosts.h	Tue Oct 22 17:59:31 2002
@@ -614,32 +614,6 @@ extern void scsi_host_busy_inc(struct Sc
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
-#ifndef CONFIG_SD_EXTRA_DEVS
-#define CONFIG_SD_EXTRA_DEVS 2
-#endif
-#ifndef CONFIG_SR_EXTRA_DEVS
-#define CONFIG_SR_EXTRA_DEVS 2
-#endif
-#define SD_EXTRA_DEVS CONFIG_SD_EXTRA_DEVS
-#define SR_EXTRA_DEVS CONFIG_SR_EXTRA_DEVS
-
-
 /**
  * scsi_find_device - find a device given the host
  * @shost:	SCSI host pointer
--- linux/drivers/scsi/sd.c	Mon Oct 21 20:52:13 2002
+++ linux-scsi/drivers/scsi/sd.c	Tue Oct 22 20:16:38 2002
@@ -19,6 +19,8 @@
  *	   not being read in sd_open. Fix problem where removable media 
  *	   could be ejected after sd_open.
  *	 - Douglas Gilbert <dgilbert@interlog.com> cleanup for lk 2.5 series
+ *	 - Christoph Hellwig <hch@infradead.org> get rid of remaining
+ *	   global arrays, more cleanup.
  *
  *	Logging policy (needs CONFIG_SCSI_LOGGING defined):
  *	 - setting up transfer: SCSI_LOG_HLQUEUE levels 1 and 2
@@ -29,9 +31,10 @@
  *	than the level indicated above to trigger output.	
  */
 
+#define MAJOR_NR SCSI_DISK0_MAJOR
+
 #include <linux/config.h>
 #include <linux/module.h>
-
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -44,33 +47,20 @@
 #include <linux/init.h>
 #include <linux/reboot.h>
 #include <linux/vmalloc.h>
-#include <linux/smp.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
-
-#define MAJOR_NR SCSI_DISK0_MAJOR
-#define LOCAL_END_REQUEST
+#include <linux/genhd.h>
 #include <linux/blk.h>
 #include <linux/blkpg.h>
+#include <asm/uaccess.h>
+
 #include "scsi.h"
 #include "hosts.h"
 #include "sd.h"
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>	/* must follow "hosts.h" */
 
-#include <linux/genhd.h>
 
-/* static char sd_version_str[] = "Version: 2.0.3 (20020417)"; */
-
-#define SD_MAJOR(i) (!(i) ? SCSI_DISK0_MAJOR : SCSI_DISK1_MAJOR-1+(i))
-
-#define SCSI_DISKS_PER_MAJOR	16
-#define SD_MAJOR_NUMBER(i)	SD_MAJOR((i) >> 8)
-#define SD_MINOR_NUMBER(i)	((i) & 255)
-#define MKDEV_SD_PARTITION(i)	mk_kdev(SD_MAJOR_NUMBER(i), (i) & 255)
-#define MKDEV_SD(index)		MKDEV_SD_PARTITION((index) << 4)
-#define N_USED_SD_MAJORS	(1 + ((sd_template.dev_max - 1) >> 4))
+#define SD_MAJORS	8
+#define SD_MAJOR(i)	((i) ? SCSI_DISK1_MAJOR-1 + (i) : SCSI_DISK0_MAJOR)
 
 #define MAX_RETRIES 5
 
@@ -81,22 +71,20 @@
 #define SD_TIMEOUT (30 * HZ)
 #define SD_MOD_TIMEOUT (75 * HZ)
 
-#define SD_DSK_ARR_LUMP 6 /* amount to over allocate sd_dsk_arr by */
-
-static Scsi_Disk ** sd_dsk_arr;
-static rwlock_t sd_dsk_arr_lock = RW_LOCK_UNLOCKED;
+static LIST_HEAD(sd_devlist);
+static spinlock_t sd_devlist_lock = SPIN_LOCK_UNLOCKED;
 
 static int check_scsidisk_media_change(struct gendisk *);
 static int sd_revalidate(struct gendisk *);
 
 static void sd_init_onedisk(Scsi_Disk * sdkp, struct gendisk *disk);
 
-static int sd_init(void);
+static void sd_rw_intr(Scsi_Cmnd * SCpnt);
 static int sd_attach(Scsi_Device *);
 static int sd_detect(Scsi_Device *);
 static void sd_detach(Scsi_Device *);
 static int sd_init_command(Scsi_Cmnd *);
-static int sd_synchronize_cache(int, int);
+static int sd_synchronize_cache(struct scsi_disk *, int);
 static int sd_notifier(struct notifier_block *, unsigned long, void *);
 
 static struct notifier_block sd_notifier_block = {sd_notifier, NULL, 0}; 
@@ -111,15 +99,41 @@ static struct Scsi_Device_Template sd_te
 	.max_major	= SCSI_DISK7_MAJOR,
 	.blk		= 1,
 	.detect		= sd_detect,
-	.init		= sd_init,
 	.attach		= sd_attach,
 	.detach		= sd_detach,
 	.init_command	= sd_init_command,
 };
 
-static void sd_rw_intr(Scsi_Cmnd * SCpnt);
+static struct scsi_disk *sd_find_by_sdev(Scsi_Device *sd)
+{
+	struct list_head *p;
+	struct scsi_disk *sdkp;
 
-static Scsi_Disk * sd_get_sdisk(int index);
+	spin_lock(&sd_devlist_lock);
+	list_for_each(p, &sd_devlist) {
+		sdkp = list_entry(p, struct scsi_disk, list);
+		if (sdkp->device == sd) {
+			spin_unlock(&sd_devlist_lock);
+			return sdkp;
+		}
+	}
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
+}
 
 #if defined(CONFIG_PPC32)
 /**
@@ -135,6 +149,8 @@ static Scsi_Disk * sd_get_sdisk(int inde
  *	tuple.
  *	[Architectural dependency: ppc only.] Moved here from 
  *	arch/ppc/pmac_setup.c.
+ *
+ *	XXX This is broken in 2.5.
  **/
 kdev_t __init
 sd_find_target(void *hp, int scsi_id)
@@ -142,24 +158,18 @@ sd_find_target(void *hp, int scsi_id)
 	Scsi_Disk *sdkp;
 	Scsi_Device *sdp;
 	struct Scsi_Host *shp = hp;
-	int dsk_nr;
 	kdev_t retval = NODEV;
-	unsigned long iflags;
 
-	SCSI_LOG_HLQUEUE(3, printk("sd_find_target: host_nr=%d, "
-			    "scsi_id=%d\n", shp->host_no, scsi_id));
-	read_lock_irqsave(&sd_dsk_arr_lock, iflags);
-	for (dsk_nr = 0; dsk_nr < sd_template.dev_max; ++dsk_nr) {
-		sdkp = sd_dsk_arr[dsk_nr];
-		if (sdkp == NULL)
-			continue;
+	spin_lock(&sd_devlist_lock);
+	list_for_each(p, &sd_devlist) {
+		sdkp = list_entry(p, struct scsi_disk, list);
 		sdp = sdkp->device;
 		if (sdp && (sdp->host == shp) && (sdp->id == scsi_id)) {
 			retval = MKDEV_SD(dsk_nr);
 			break;
 		}
 	}
-	read_unlock_irqrestore(&sd_dsk_arr_lock, iflags);
+	spin_unlock(&sd_devlist_lock);
 	return retval;
 }
 #endif
@@ -244,25 +254,6 @@ static int sd_ioctl(struct inode * inode
 	}
 }
 
-static void sd_dskname(unsigned int dsk_nr, char *buffer)
-{
-	if (dsk_nr < 26)
-		sprintf(buffer, "sd%c", 'a' + dsk_nr);
-	else {
-		unsigned int min1;
-		unsigned int min2;
-		/*
-		 * For larger numbers of disks, we need to go to a new
-		 * naming scheme.
-		 */
-		min1 = dsk_nr / 26;
-		min2 = dsk_nr % 26;
-		sprintf(buffer, "sd%c%c", 'a' + min1 - 1, 'a' + min2);
-	}
-}
-
-static struct gendisk **sd_disks;
-
 /**
  *	sd_init_command - build a scsi (read or write) command from
  *	information in the request structure.
@@ -1192,99 +1183,6 @@ sd_init_onedisk(Scsi_Disk * sdkp, struct
 	kfree(buffer);
 }
 
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
-	Scsi_Disk * sdkp;
-
-	SCSI_LOG_HLQUEUE(3, printk("sd_init: dev_noticed=%d\n",
-			    sd_template.dev_noticed));
-	if (sd_template.dev_noticed == 0)
-		return 0;
-
-	if (NULL == sd_dsk_arr)
-		sd_template.dev_max = sd_template.dev_noticed + SD_EXTRA_DEVS;
-
-	if (sd_template.dev_max > N_SD_MAJORS * SCSI_DISKS_PER_MAJOR)
-		sd_template.dev_max = N_SD_MAJORS * SCSI_DISKS_PER_MAJOR;
-
-	/* At most 16 partitions on each scsi disk. */
-	maxparts = (sd_template.dev_max << 4);
-	if (maxparts == 0)
-		return 0;
-
-	if (!sd_registered) {
-		for (k = 0; k < N_USED_SD_MAJORS; k++) {
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
-#define init_mem_lth(x,n)	x = vmalloc((n) * sizeof(*x))
-#define zero_mem_lth(x,n)	memset(x, 0, (n) * sizeof(*x))
-
-	init_mem_lth(sd_dsk_arr, sd_template.dev_max);
-	if (sd_dsk_arr) {
-		zero_mem_lth(sd_dsk_arr, sd_template.dev_max);
-		for (k = 0; k < sd_template.dev_max; ++k) {
-			sdkp = vmalloc(sizeof(Scsi_Disk));
-			if (NULL == sdkp)
-				goto cleanup_mem;
-			memset(sdkp, 0, sizeof(Scsi_Disk));
-			sd_dsk_arr[k] = sdkp;
-		}
-	}
-	init_mem_lth(sd_disks, sd_template.dev_max);
-	if (sd_disks)
-		zero_mem_lth(sd_disks, sd_template.dev_max);
-
-	if (!sd_dsk_arr || !sd_disks)
-		goto cleanup_mem;
-
-	return 0;
-
-#undef init_mem_lth
-#undef zero_mem_lth
-
-cleanup_mem:
-	vfree(sd_disks);
-	sd_disks = NULL;
-	if (sd_dsk_arr) {
-                for (k = 0; k < sd_template.dev_max; ++k)
-			vfree(sd_dsk_arr[k]);
-		vfree(sd_dsk_arr);
-		sd_dsk_arr = NULL;
-	}
-	for (k = 0; k < N_USED_SD_MAJORS; k++) {
-		unregister_blkdev(SD_MAJOR(k), "sd");
-	}
-	sd_registered--;
-	return 1;
-}
-
 /**
  *	sd_detect - called at the start of driver initialization, once 
  *	for each scsi device (not just disks) present.
@@ -1293,7 +1191,6 @@ cleanup_mem:
  *	1 if this device is of interest (e.g. a disk).
  *
  *	Note: this function is invoked from the scsi mid-level.
- *	This function is called before sd_init() so very little is available.
  **/
 static int sd_detect(Scsi_Device * sdp)
 {
@@ -1318,51 +1215,39 @@ static int sd_detect(Scsi_Device * sdp)
  *	<host,channel,id,lun> (found in sdp) and new device name 
  *	(e.g. /dev/sda). More precisely it is the block device major 
  *	and minor number that is chosen here.
- **/
+ *
+ *	Assume sd_attach is not re-entrant (for time being)
+ *	Also think about sd_attach() and sd_detach() running coincidentally.
+ */
 static int sd_attach(Scsi_Device * sdp)
 {
 	Scsi_Disk *sdkp = NULL;	/* shut up lame gcc warning */
 	int dsk_nr;
-	unsigned long iflags;
 	struct gendisk *gd;
 
 	if ((sdp->type != TYPE_DISK) && (sdp->type != TYPE_MOD))
 		return 0;
 
-	gd = alloc_disk(16);
-	if (!gd)
-		return 1;
-
 	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 
 			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
 
-	if (sd_template.nr_dev >= sd_template.dev_max) {
-		printk(KERN_ERR "sd_init: no more room for device\n");
+	sdkp = kmalloc(sizeof(*sdkp), GFP_KERNEL);
+	if (!sdkp)
 		goto out;
-	}
+	memset(sdkp, 0, sizeof(*sdkp));
+
+	gd = alloc_disk(16);
+	if (!gd)
+		goto out_free;
 
 	/*
-	 * Assume sd_attach is not re-entrant (for time being)
-	 * Also think about sd_attach() and sd_detach() running coincidentally.
+	 * XXX	This doesn't make us better than the previous code in the
+	 * XXX	end (not worse either, though..).
+	 * XXX	To properly support hotplugging we should have a bitmap and
+	 * XXX	use find_first_zero_bit on it.  This will happen at the
+	 * XXX	same time template->nr_* goes away.		--hch
 	 */
-	write_lock_irqsave(&sd_dsk_arr_lock, iflags);
-	for (dsk_nr = 0; dsk_nr < sd_template.dev_max; dsk_nr++) {
-		sdkp = sd_dsk_arr[dsk_nr];
-		if (!sdkp->device) {
-			memset(sdkp, 0, sizeof(Scsi_Disk));
-			sdkp->device = sdp;
-			break;
-		}
-	}
-	write_unlock_irqrestore(&sd_dsk_arr_lock, iflags);
-
-	if (!sdkp || dsk_nr >= sd_template.dev_max) {
-		printk(KERN_ERR "sd_init: sd_dsk_arr corrupted\n");
-		goto out;
-	}
-
-	sd_init_onedisk(sdkp, gd);
-	sd_template.nr_dev++;
+	dsk_nr = sd_template.nr_dev;
 
 	gd->de = sdp->de;
 	gd->major = SD_MAJOR(dsk_nr>>4);
@@ -1372,25 +1257,32 @@ static int sd_attach(Scsi_Device * sdp)
 		sprintf(gd->disk_name, "sd%c%c",'a'+dsk_nr/26-1,'a'+dsk_nr%26);
 	else
 		sprintf(gd->disk_name, "sd%c",'a'+dsk_nr%26);
-	gd->flags = sdp->removable ? GENHD_FL_REMOVABLE : 0;
 	gd->driverfs_dev = &sdp->sdev_driverfs_dev;
-	gd->flags |= GENHD_FL_DRIVERFS | GENHD_FL_DEVFS;
+	gd->flags = GENHD_FL_DRIVERFS | GENHD_FL_DEVFS;
+	if (sdp->removable)
+		gd->flags |= GENHD_FL_REMOVABLE;
+	gd->queue = &sdp->request_queue;
 	gd->private_data = sdkp;
-	gd->queue = &sdkp->device->request_queue;
 
+	sdkp->device = sdp;
+	sdkp->gd = gd;
+
+	sd_init_onedisk(sdkp, gd);
 	set_capacity(gd, sdkp->capacity);
-	add_disk(gd);
 
-	sd_disks[dsk_nr] = gd;
+	add_disk(gd);
+	sd_devlist_insert(sdkp);
+	sd_template.nr_dev++;
 
 	printk(KERN_NOTICE "Attached scsi %sdisk %s at scsi%d, channel %d, "
 	       "id %d, lun %d\n", sdp->removable ? "removable " : "",
 	       gd->disk_name, sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	return 0;
 
+out_free:
+	kfree(sdkp);
 out:
 	sdp->attached--;
-	put_disk(gd);
 	return 1;
 }
 
@@ -1420,105 +1312,58 @@ static int sd_revalidate(struct gendisk 
 static void sd_detach(Scsi_Device * sdp)
 {
 	Scsi_Disk *sdkp = NULL;
-	int dsk_nr;
-	unsigned long iflags;
 
 	SCSI_LOG_HLQUEUE(3, printk("sd_detach: <%d,%d,%d,%d>\n", 
 			    sdp->host->host_no, sdp->channel, sdp->id, 
 			    sdp->lun));
-	write_lock_irqsave(&sd_dsk_arr_lock, iflags);
-	for (dsk_nr = 0; dsk_nr < sd_template.dev_max; dsk_nr++) {
-		sdkp = sd_dsk_arr[dsk_nr];
-		if (sdkp->device == sdp) {
-			break;
-		}
-	}
-	write_unlock_irqrestore(&sd_dsk_arr_lock, iflags);
-	if (dsk_nr >= sd_template.dev_max)
+	
+	sdkp = sd_find_by_sdev(sdp);
+	if (!sdkp)
 		return;
 
 	/* check that we actually have a write back cache to synchronize */
 	if(sdkp->WCE) {
 		printk(KERN_NOTICE "Synchronizing SCSI cache: ");
-		sd_synchronize_cache(dsk_nr, 1);
+		sd_synchronize_cache(sdkp, 1);
 		printk("\n");
 	}
-	sdkp->device = NULL;
-	sdkp->capacity = 0;
-	/* sdkp->detaching = 1; */
 
-	del_gendisk(sd_disks[dsk_nr]);
+	sd_devlist_remove(sdkp);
+	del_gendisk(sdkp->gd);
+	put_disk(sdkp->gd);
+
 	sdp->attached--;
 	sd_template.dev_noticed--;
 	sd_template.nr_dev--;
-	put_disk(sd_disks[dsk_nr]);
-	sd_disks[dsk_nr] = NULL;
-}
-
-/**
- *	init_sd - entry point for this driver (both when built in or when
- *	a module).
- *
- *	Note: this function registers this driver with the scsi mid-level.
- **/
-static int __init init_sd(void)
-{
-	int rc;
-
-	SCSI_LOG_HLQUEUE(3, printk("init_sd: sd driver entry point\n"));
-
-	rc = scsi_register_device(&sd_template);
-	if (!rc)
-		register_reboot_notifier(&sd_notifier_block);
-	return rc;
-}
-
-/**
- *	exit_sd - exit point for this driver (when it is	a module).
- *
- *	Note: this function unregisters this driver from the scsi mid-level.
- **/
-static void __exit exit_sd(void)
-{
-	int k;
-
-	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
-	scsi_unregister_device(&sd_template);
-	for (k = 0; k < N_USED_SD_MAJORS; k++)
-		unregister_blkdev(SD_MAJOR(k), "sd");
 
-	sd_registered--;
-	if (sd_dsk_arr != NULL) {
-		for (k = 0; k < sd_template.dev_max; ++k)
-			vfree(sd_dsk_arr[k]);
-		vfree(sd_dsk_arr);
-	}
-	sd_template.dev_max = 0;
-
-	unregister_reboot_notifier(&sd_notifier_block);
+	kfree(sdkp);
 }
 
 static int sd_notifier(struct notifier_block *nbt, unsigned long event, void *buf)
 {
-	int i;
 	char *msg = "Synchronizing SCSI caches: ";
+	struct list_head *p;
+	struct scsi_disk *sdkp;
 
-	if (!(event == SYS_RESTART || event == SYS_HALT 
-	      || event == SYS_POWER_OFF))
+	if (event != SYS_RESTART &&
+	    event != SYS_HALT &&
+	    event != SYS_POWER_OFF)
 		return NOTIFY_DONE;
-	for (i = 0; i < sd_template.dev_max; i++) {
-		Scsi_Disk *sdkp = sd_get_sdisk(i);
 
-		if (!sdkp || !sdkp->device)
+	list_for_each(p, &sd_devlist) {
+		sdkp = list_entry(p, struct scsi_disk, list);
+
+		if (!sdkp->device)
 			continue;
 		if (sdkp->WCE) {
 			if(msg) {
 				printk(KERN_NOTICE "%s", msg);
 				msg = NULL;
 			}
-			sd_synchronize_cache(i, 1);
+			sd_synchronize_cache(sdkp, 1);
 		}
 	}
+
 	if(!msg)
 		printk("\n");
 
@@ -1528,20 +1373,14 @@ static int sd_notifier(struct notifier_b
 /* send a SYNCHRONIZE CACHE instruction down to the device through the
  * normal SCSI command structure.  Wait for the command to complete (must
  * have user context) */
-static int sd_synchronize_cache(int index, int verbose)
+static int sd_synchronize_cache(struct scsi_disk *sdkp, int verbose)
 {
 	Scsi_Request *SRpnt;
-	Scsi_Disk *sdkp = sd_get_sdisk(index);
 	Scsi_Device *SDpnt = sdkp->device;
 	int retries, the_result;
 
-	if(verbose) {
-		char buf[16];
-
-		sd_dskname(index, buf);
-
-		printk("%s ", buf);
-	}
+	if(verbose)
+		printk("%s ", sdkp->gd->disk_name);
 
 	SRpnt = scsi_allocate_request(SDpnt);
 	if(!SRpnt) {
@@ -1581,16 +1420,46 @@ static int sd_synchronize_cache(int inde
 	return (the_result == 0);
 }
 
-static Scsi_Disk * sd_get_sdisk(int index)
+/**
+ *	init_sd - entry point for this driver (both when built in or when
+ *	a module).
+ *
+ *	Note: this function registers this driver with the scsi mid-level.
+ **/
+static int __init init_sd(void)
+{
+	int majors = 0, rc = -ENODEV, i;
+
+	for (i = 0; i < SD_MAJORS; i++) {
+		if (register_blkdev(SD_MAJOR(i), "sd", &sd_fops))
+			printk(KERN_NOTICE
+			      "Unable to get major %d for SCSI disk\n",
+			      SD_MAJOR(i));
+		else
+			majors++;
+	}
+	if (!majors)
+		return -ENODEV;
+
+	rc = scsi_register_device(&sd_template);
+	if (rc)
+		return rc;
+	return register_reboot_notifier(&sd_notifier_block);
+}
+
+/**
+ *	exit_sd - exit point for this driver (when it is	a module).
+ *
+ *	Note: this function unregisters this driver from the scsi mid-level.
+ **/
+static void __exit exit_sd(void)
 {
-	Scsi_Disk * sdkp = NULL;
-	unsigned long iflags;
+	int i;
 
-	read_lock_irqsave(&sd_dsk_arr_lock, iflags);
-	if (sd_dsk_arr && (index >= 0) && (index < sd_template.dev_max))
-		sdkp = sd_dsk_arr[index];
-	read_unlock_irqrestore(&sd_dsk_arr_lock, iflags);
-	return sdkp;
+	unregister_reboot_notifier(&sd_notifier_block);
+	scsi_unregister_device(&sd_template);
+	for (i = 0; i < SD_MAJORS; i++)
+		unregister_blkdev(SD_MAJOR(i), "sd");
 }
 
 MODULE_LICENSE("GPL");
--- linux/drivers/scsi/sd.h	Mon Oct 21 20:34:15 2002
+++ linux-scsi/drivers/scsi/sd.h	Tue Oct 22 17:24:02 2002
@@ -12,32 +12,20 @@
 #ifndef _SD_H
 #define _SD_H
 
-#ifndef _SCSI_H
-#include "scsi.h"
-#endif
-
-#ifndef _GENDISK_H
-#include <linux/genhd.h>
-#endif
-
 typedef struct scsi_disk {
+	struct list_head list;
 	sector_t capacity;		/* size in 512-byte sectors */
 	Scsi_Device *device;
+	struct gendisk *gd;
 	unsigned char media_present;
 	unsigned char write_prot;
 	unsigned WCE:1;         /* state of disk WCE bit */
 	unsigned RCD:1;         /* state of disk RCD bit */
 } Scsi_Disk;
 
-extern int revalidate_scsidisk(kdev_t dev, int maxusage);
-
 /*
  * Used by pmac to find the device associated with a target.
  */
 extern kdev_t sd_find_target(void *host, int tgt);
-
-#define N_SD_MAJORS	8
-
-#define SD_MAJOR_MASK	(N_SD_MAJORS - 1)
 
 #endif
--- linux/drivers/scsi/sr.c	Mon Oct 21 20:57:29 2002
+++ linux-scsi/drivers/scsi/sr.c	Tue Oct 22 17:54:58 2002
@@ -33,8 +33,9 @@
  *
  */
 
-#include <linux/module.h>
+#define MAJOR_NR SCSI_CDROM_MAJOR
 
+#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -45,13 +46,10 @@
 #include <linux/cdrom.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
-#include <asm/system.h>
-#include <asm/io.h>
+#include <linux/spinlock.h>
+#include <linux/blk.h>
 #include <asm/uaccess.h>
 
-#define MAJOR_NR SCSI_CDROM_MAJOR
-#define LOCAL_END_REQUEST
-#include <linux/blk.h>
 #include "scsi.h"
 #include "hosts.h"
 #include "sr.h"
@@ -62,11 +60,12 @@ MODULE_PARM(xa_test, "i");	/* see sr_ioc
 #define MAX_RETRIES	3
 #define SR_TIMEOUT	(30 * HZ)
 
-static int sr_init(void);
+static LIST_HEAD(sr_devlist);
+static spinlock_t sr_devlist_lock = SPIN_LOCK_UNLOCKED;
+
 static int sr_attach(Scsi_Device *);
 static int sr_detect(Scsi_Device *);
 static void sr_detach(Scsi_Device *);
-
 static int sr_init_command(Scsi_Cmnd *);
 
 static struct Scsi_Device_Template sr_template = {
@@ -77,37 +76,20 @@ static struct Scsi_Device_Template sr_te
 	.major		= SCSI_CDROM_MAJOR,
 	.blk		= 1,
 	.detect		= sr_detect,
-	.init		= sr_init,
 	.attach		= sr_attach,
 	.detach		= sr_detach,
 	.init_command	= sr_init_command
 };
 
-static Scsi_CD *scsi_CDs;
-
 static int sr_open(struct cdrom_device_info *, int);
-static void get_sectorsize(Scsi_CD *);
-static void get_capabilities(Scsi_CD *);
-static int sr_init_one(Scsi_CD *, int);
+static void sr_release(struct cdrom_device_info *);
 
+static void sr_get_sectorsize(Scsi_CD *);
+static void sr_get_capabilities(Scsi_CD *);
 static int sr_media_change(struct cdrom_device_info *, int);
 static int sr_packet(struct cdrom_device_info *, struct cdrom_generic_command *);
 
-static void sr_release(struct cdrom_device_info *cdi)
-{
-	Scsi_CD *cd = cdi->handle;
-
-	if (cd->device->sector_size > 2048)
-		sr_set_blocklength(cd, 2048);
-	cd->device->access_count--;
-	if (cd->device->host->hostt->module)
-		__MOD_DEC_USE_COUNT(cd->device->host->hostt->module);
-	if (sr_template.module)
-		__MOD_DEC_USE_COUNT(sr_template.module);
-}
-
-static struct cdrom_device_ops sr_dops =
-{
+static struct cdrom_device_ops sr_dops = {
 	open:			sr_open,
 	release:		sr_release,
 	drive_status:		sr_drive_status,
@@ -130,6 +112,37 @@ static struct cdrom_device_ops sr_dops =
 	generic_packet:		sr_packet,
 };
 
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
 /*
  * This function checks to see if the media has been changed in the
  * CDROM drive.  It is possible that we have already sensed a change,
@@ -415,8 +428,7 @@ static int sr_block_media_changed(struct
 	return cdrom_media_changed(&cd->cdi);
 }
 
-struct block_device_operations sr_bdops =
-{
+struct block_device_operations sr_bdops = {
 	.owner		= THIS_MODULE,
 	.open		= sr_block_open,
 	.release	= sr_block_release,
@@ -449,11 +461,24 @@ static int sr_open(struct cdrom_device_i
 	 */
 
 	if (cd->needs_sector_size)
-		get_sectorsize(cd);
+		sr_get_sectorsize(cd);
 
 	return 0;
 }
 
+static void sr_release(struct cdrom_device_info *cdi)
+{
+	Scsi_CD *cd = cdi->handle;
+
+	if (cd->device->sector_size > 2048)
+		sr_set_blocklength(cd, 2048);
+	cd->device->access_count--;
+	if (cd->device->host->hostt->module)
+		__MOD_DEC_USE_COUNT(cd->device->host->hostt->module);
+	if (sr_template.module)
+		__MOD_DEC_USE_COUNT(sr_template.module);
+}
+
 static int sr_detect(Scsi_Device * SDp)
 {
 
@@ -465,8 +490,9 @@ static int sr_detect(Scsi_Device * SDp)
 
 static int sr_attach(Scsi_Device * SDp)
 {
-	Scsi_CD *cpnt;
-	int i;
+	struct gendisk *disk;
+	Scsi_CD *cd;
+	int minor;
 
 	if (SDp->type != TYPE_ROM && SDp->type != TYPE_WORM)
 		return 1;
@@ -474,33 +500,99 @@ static int sr_attach(Scsi_Device * SDp)
 	if (sr_template.nr_dev >= sr_template.dev_max)
 		goto fail;
 
-	for (cpnt = scsi_CDs, i = 0; i < sr_template.dev_max; i++, cpnt++)
-		if (!cpnt->device)
-			break;
-
-	if (i >= sr_template.dev_max)
-		panic("scsi_devices corrupt (sr)");
+	/*
+	 * XXX	This doesn't make us better than the previous code in the
+	 * XXX	end (not worse either, though..).
+	 * XXX	To properly support hotplugging we should have a bitmap and
+	 * XXX	use find_first_zero_bit on it.  This will happen at the
+	 * XXX	same time template->nr_* goes away.		--hch
+	 */
+	minor = sr_template.nr_dev;
 
-	if (sr_init_one(cpnt, i))
+	cd = kmalloc(sizeof(*cd), GFP_KERNEL);
+	if (!cd)
 		goto fail;
+	memset(cd, 0, sizeof(*cd));
+	
+	disk = alloc_disk(1);
+	if (!disk)
+		goto fail_free;
+
+	disk->major = MAJOR_NR;
+	disk->first_minor = minor;
+	sprintf(disk->disk_name, "sr%d", minor);
+	disk->fops = &sr_bdops;
+	disk->flags = GENHD_FL_CD;
 
-	scsi_CDs[i].device = SDp;
+	cd->device = SDp;
+	cd->disk = disk;
+	cd->capacity = 0x1fffff;
+	cd->device->sector_size = 2048;/* A guess, just in case */
+	cd->needs_sector_size = 1;
+	cd->device->changed = 1;	/* force recheck CD type */
+	cd->use = 1;
+
+	cd->device->ten = 1;
+	cd->device->remap = 1;
+	cd->readcd_known = 0;
+	cd->readcd_cdda = 0;
+
+	cd->cdi.ops = &sr_dops;
+	cd->cdi.handle = cd;
+	cd->cdi.mask = 0;
+	cd->cdi.capacity = 1;
+	sprintf(cd->cdi.name, "sr%d", minor);
+
+	/*
+	 * FIXME: someone needs to handle a get_capabilities
+	 * failure properly ??
+	 */
+	sr_get_capabilities(cd);
+	sr_vendor_init(cd);
+	disk->de = cd->device->de;
+	disk->driverfs_dev = &cd->device->sdev_driverfs_dev;
+	register_cdrom(&cd->cdi);
+	set_capacity(disk, cd->capacity);
+	disk->private_data = cd;
+	disk->queue = &cd->device->request_queue;
 
+	add_disk(disk);
+	sr_devlist_insert(cd);
 	sr_template.nr_dev++;
-	if (sr_template.nr_dev > sr_template.dev_max)
-		panic("scsi_devices corrupt (sr)");
 
-	printk("Attached scsi CD-ROM %s at scsi%d, channel %d, id %d, lun %d\n",
-	       scsi_CDs[i].cdi.name, SDp->host->host_no, SDp->channel, SDp->id, SDp->lun);
+	printk(KERN_INFO
+	    "Attached scsi CD-ROM %s at scsi%d, channel %d, id %d, lun %d\n",
+	    cd->cdi.name, SDp->host->host_no, SDp->channel,
+	    SDp->id, SDp->lun);
 	return 0;
 
+fail_free:
+	kfree(cd);
 fail:
 	SDp->attached--;
 	return 1;
 }
 
+static void sr_detach(Scsi_Device * SDp)
+{
+	Scsi_CD *cd;
+
+	cd = sr_find_by_sdev(SDp);
+	if (cd) {
+		sr_devlist_remove(cd);
+		del_gendisk(cd->disk);
+		put_disk(cd->disk);
+		unregister_cdrom(&cd->cdi);
+
+		SDp->attached--;
+		sr_template.nr_dev--;
+		sr_template.dev_noticed--;
 
-static void get_sectorsize(Scsi_CD *cd)
+		kfree(cd);
+	}
+}
+
+static void sr_get_sectorsize(Scsi_CD *cd)
 {
 	unsigned char cmd[10];
 	unsigned char *buffer;
@@ -603,7 +695,7 @@ Enomem:
 	goto out;
 }
 
-void get_capabilities(Scsi_CD *cd)
+void sr_get_capabilities(Scsi_CD *cd)
 {
 	struct cdrom_generic_command cgc;
 	unsigned char *buffer;
@@ -714,124 +806,13 @@ static int sr_packet(struct cdrom_device
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
-			printk("Unable to get major %d for SCSI-CD\n", MAJOR_NR);
-			return 1;
-		}
-		sr_registered++;
-	}
-	if (scsi_CDs)
-		return 0;
-
-	sr_template.dev_max = sr_template.dev_noticed + SR_EXTRA_DEVS;
-	scsi_CDs = kmalloc(sr_template.dev_max * sizeof(Scsi_CD), GFP_ATOMIC);
-	if (!scsi_CDs)
-		goto cleanup_dev;
-	memset(scsi_CDs, 0, sr_template.dev_max * sizeof(Scsi_CD));
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
-static int sr_init_one(Scsi_CD *cd, int first_minor)
-{
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
-
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
-	disk->private_data = cd;
-	disk->queue = &cd->device->request_queue;
-	add_disk(disk);
-
-	return 0;
-}
-
-static void sr_detach(Scsi_Device * SDp)
-{
-	Scsi_CD *cpnt;
-	int i;
-
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
-
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
-}
-
 static int __init init_sr(void)
 {
+	int rc;
+
+	rc = register_blkdev(MAJOR_NR, "sr", &sr_bdops);
+	if (rc)
+		return rc;
 	return scsi_register_device(&sr_template);
 }
 
@@ -839,11 +820,6 @@ static void __exit exit_sr(void)
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
--- linux/drivers/scsi/sr.h	Mon Oct 21 17:18:22 2002
+++ linux-scsi/drivers/scsi/sr.h	Tue Oct 22 16:39:49 2002
@@ -25,6 +25,7 @@
 #define IOCTL_TIMEOUT 30*HZ
 
 typedef struct {
+	struct list_head list;
 	unsigned capacity;	/* size in blocks                       */
 	Scsi_Device *device;
 	unsigned int vendor;	/* vendor code, see sr_vendor.c         */
