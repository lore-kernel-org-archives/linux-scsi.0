From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] merge sd.h into sd.c and some cleanup
Date: Sat, 26 Oct 2002 03:18:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021026031850.A5491@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Now that only sd.c includes sd.h it can be safely merged into it.
Also get rid of typedef abuse in sd.c


--- 1.76/drivers/scsi/sd.c	Thu Oct 24 21:27:14 2002
+++ edited/drivers/scsi/sd.c	Sat Oct 26 01:20:04 2002
@@ -18,7 +17,7 @@
  *	 - Alex Davis <letmein@erols.com> Fix problem where partition info
  *	   not being read in sd_open. Fix problem where removable media 
  *	   could be ejected after sd_open.
- *	 - Douglas Gilbert <dgilbert@interlog.com> cleanup for lk 2.5 series
+ *	 - Douglas Gilbert <dgilbert@interlog.com> cleanup for lk 2.5.x
  *
  *	Logging policy (needs CONFIG_SCSI_LOGGING defined):
  *	 - setting up transfer: SCSI_LOG_HLQUEUE levels 1 and 2
@@ -29,39 +28,34 @@
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
 #include <linux/mm.h>
 #include <linux/bio.h>
-#include <linux/string.h>
+#include <linux/genhd.h>
 #include <linux/hdreg.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
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
 #include <linux/blk.h>
 #include <linux/blkpg.h>
+#include <asm/uaccess.h>
+
 #include "scsi.h"
 #include "hosts.h"
-#include "sd.h"
 #include <scsi/scsi_ioctl.h>
-#include <scsi/scsicam.h>	/* must follow "hosts.h" */
+#include <scsi/scsicam.h>
 
-#include <linux/genhd.h>
 
-/* static char sd_version_str[] = "Version: 2.0.3 (20020417)"; */
+#define N_SD_MAJORS	8
+#define SD_MAJOR_MASK	(N_SD_MAJORS - 1)
 
 #define SD_MAJOR(i) (!(i) ? SCSI_DISK0_MAJOR : SCSI_DISK1_MAJOR-1+(i))
 
@@ -72,30 +66,44 @@
 #define MKDEV_SD(index)		MKDEV_SD_PARTITION((index) << 4)
 #define N_USED_SD_MAJORS	(1 + ((sd_template.dev_max - 1) >> 4))
 
-#define MAX_RETRIES 5
-
 /*
  *  Time out in seconds for disks and Magneto-opticals (which are slower).
  */
+#define SD_TIMEOUT		(30 * HZ)
+#define SD_MOD_TIMEOUT		(75 * HZ)
 
-#define SD_TIMEOUT (30 * HZ)
-#define SD_MOD_TIMEOUT (75 * HZ)
+/*
+ * Amount to over allocate sd_dsk_arr by
+ */
+#define SD_DSK_ARR_LUMP		6
 
-#define SD_DSK_ARR_LUMP 6 /* amount to over allocate sd_dsk_arr by */
+/*
+ * Number of allowed retries
+ */
+#define SD_MAX_RETRIES		5
+
+struct scsi_disk {
+	struct scsi_device *device;
+	sector_t	capacity;	/* size in 512-byte sectors */
+	u8		media_present;
+	u8		write_prot;
+	unsigned	WCE : 1;	/* state of disk WCE bit */
+	unsigned	RCD : 1;	/* state of disk RCD bit */
+};
 
-static Scsi_Disk ** sd_dsk_arr;
+static struct scsi_disk ** sd_dsk_arr;
 static rwlock_t sd_dsk_arr_lock = RW_LOCK_UNLOCKED;
 
 static int check_scsidisk_media_change(struct gendisk *);
 static int sd_revalidate(struct gendisk *);
 
-static void sd_init_onedisk(Scsi_Disk * sdkp, struct gendisk *disk);
+static void sd_init_onedisk(struct scsi_disk * sdkp, struct gendisk *disk);
 
 static int sd_init(void);
-static int sd_attach(Scsi_Device *);
-static int sd_detect(Scsi_Device *);
-static void sd_detach(Scsi_Device *);
-static int sd_init_command(Scsi_Cmnd *);
+static int sd_attach(struct scsi_device *);
+static int sd_detect(struct scsi_device *);
+static void sd_detach(struct scsi_device *);
+static int sd_init_command(struct scsi_cmnd *);
 static int sd_synchronize_cache(int, int);
 static int sd_notifier(struct notifier_block *, unsigned long, void *);
 
@@ -117,9 +125,9 @@
 	.init_command	= sd_init_command,
 };
 
-static void sd_rw_intr(Scsi_Cmnd * SCpnt);
+static void sd_rw_intr(struct scsi_cmnd * SCpnt);
 
-static Scsi_Disk * sd_get_sdisk(int index);
+static struct scsi_disk * sd_get_sdisk(int index);
 
 #if defined(CONFIG_PPC32)
 /**
@@ -139,8 +147,8 @@
 kdev_t __init
 sd_find_target(void *hp, int scsi_id)
 {
-	Scsi_Disk *sdkp;
-	Scsi_Device *sdp;
+	struct scsi_disk *sdkp;
+	struct scsi_device *sdp;
 	struct Scsi_Host *shp = hp;
 	int dsk_nr;
 	kdev_t retval = NODEV;
@@ -183,8 +191,8 @@
 {
 	struct block_device *bdev = inode->i_bdev;
 	struct gendisk *disk = bdev->bd_disk;
-        Scsi_Disk *sdkp = disk->private_data;
-	Scsi_Device *sdp = sdkp->device;
+	struct scsi_disk *sdkp = disk->private_data;
+	struct scsi_device *sdp = sdkp->device;
 	sector_t capacity = sdkp->capacity;
 	struct Scsi_Host *host;
 	int diskinfo[4];
@@ -276,12 +284,12 @@
  *
  *	Returns 1 if successful and 0 if error (or cannot be done now).
  **/
-static int sd_init_command(Scsi_Cmnd * SCpnt)
+static int sd_init_command(struct scsi_cmnd * SCpnt)
 {
 	int this_count, timeout;
 	struct gendisk *disk;
 	sector_t block;
-	Scsi_Device *sdp = SCpnt->device;
+	struct scsi_device *sdp = SCpnt->device;
 
 	timeout = SD_TIMEOUT;
 	if (SCpnt->device->type != TYPE_DISK)
@@ -435,7 +443,7 @@
 	SCpnt->transfersize = sdp->sector_size;
 	SCpnt->underflow = this_count << 9;
 
-	SCpnt->allowed = MAX_RETRIES;
+	SCpnt->allowed = SD_MAX_RETRIES;
 	SCpnt->timeout_per_command = timeout;
 
 	/*
@@ -467,8 +475,8 @@
 static int sd_open(struct inode *inode, struct file *filp)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	Scsi_Disk *sdkp = disk->private_data;
-	Scsi_Device * sdp = sdkp->device;
+	struct scsi_disk *sdkp = disk->private_data;
+	struct scsi_device * sdp = sdkp->device;
 	int retval = -ENXIO;
 
 	SCSI_LOG_HLQUEUE(3, printk("sd_open: disk=%s\n", disk->disk_name));
@@ -552,8 +560,8 @@
 static int sd_release(struct inode *inode, struct file *filp)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	Scsi_Disk *sdkp = disk->private_data;
-	Scsi_Device *sdp = sdkp->device;
+	struct scsi_disk *sdkp = disk->private_data;
+	struct scsi_device *sdp = sdkp->device;
 
 	SCSI_LOG_HLQUEUE(3, printk("sd_release: disk=%s\n", disk->disk_name));
 	if (!sdp)
@@ -594,7 +602,7 @@
  *
  *	Note: potentially run from within an ISR. Must not block.
  **/
-static void sd_rw_intr(Scsi_Cmnd * SCpnt)
+static void sd_rw_intr(struct scsi_cmnd * SCpnt)
 {
 	int result = SCpnt->result;
 	int this_count = SCpnt->bufflen >> 9;
@@ -690,7 +698,7 @@
 }
 
 static void
-sd_set_media_not_present(Scsi_Disk *sdkp) {
+sd_set_media_not_present(struct scsi_disk *sdkp) {
 	sdkp->media_present = 0;
 	sdkp->capacity = 0;
 	sdkp->device->changed = 1;
@@ -706,8 +714,8 @@
  **/
 static int check_scsidisk_media_change(struct gendisk *disk)
 {
-	Scsi_Disk *sdkp = disk->private_data;
-	Scsi_Device *sdp = sdkp->device;
+	struct scsi_disk *sdkp = disk->private_data;
+	struct scsi_device *sdp = sdkp->device;
 	int retval;
 	int flag = 0;	/* <<<< what is this for?? */
 
@@ -755,7 +763,7 @@
 	}
 	/*
 	 * For removable scsi disk we have to recognise the presence
-	 * of a disk in the drive. This is kept in the Scsi_Disk
+	 * of a disk in the drive. This is kept in the struct scsi_disk
 	 * struct and tested at open !  Daniel Roche ( dan@lectra.fr )
 	 */
 
@@ -768,7 +776,7 @@
 }
 
 static int
-sd_media_not_present(Scsi_Disk *sdkp, Scsi_Request *SRpnt) {
+sd_media_not_present(struct scsi_disk *sdkp, struct scsi_request *SRpnt) {
 	int the_result = SRpnt->sr_result;
 
 	if (the_result != 0
@@ -786,10 +794,10 @@
  * spinup disk - called only in sd_init_onedisk()
  */
 static void
-sd_spinup_disk(Scsi_Disk *sdkp, char *diskname,
-	       Scsi_Request *SRpnt, unsigned char *buffer) {
+sd_spinup_disk(struct scsi_disk *sdkp, char *diskname,
+	       struct scsi_request *SRpnt, unsigned char *buffer) {
 	unsigned char cmd[10];
-	Scsi_Device *sdp = sdkp->device;
+	struct scsi_device *sdp = sdkp->device;
 	unsigned long spintime_value = 0;
 	int the_result, retries, spintime;
 
@@ -810,7 +818,7 @@
 			SRpnt->sr_data_direction = SCSI_DATA_NONE;
 
 			scsi_wait_req (SRpnt, (void *) cmd, (void *) buffer,
-				       0/*512*/, SD_TIMEOUT, MAX_RETRIES);
+				       0/*512*/, SD_TIMEOUT, SD_MAX_RETRIES);
 
 			the_result = SRpnt->sr_result;
 			retries++;
@@ -846,7 +854,7 @@
 				SRpnt->sr_data_direction = SCSI_DATA_READ;
 				scsi_wait_req(SRpnt, (void *)cmd, 
 					      (void *) buffer, 0/*512*/, 
-					      SD_TIMEOUT, MAX_RETRIES);
+					      SD_TIMEOUT, SD_MAX_RETRIES);
 				spintime_value = jiffies;
 			}
 			spintime = 1;
@@ -873,8 +881,8 @@
  * sd_read_cache_type - called only from sd_init_onedisk()
  */
 static void
-sd_read_cache_type(Scsi_Disk *sdkp, char *diskname,
-		   Scsi_Request *SRpnt, unsigned char *buffer) {
+sd_read_cache_type(struct scsi_disk *sdkp, char *diskname,
+		   struct scsi_request *SRpnt, unsigned char *buffer) {
 
 	unsigned char cmd[10];
 	int the_result, retries;
@@ -896,7 +904,7 @@
 
 		SRpnt->sr_data_direction = SCSI_DATA_READ;
 		scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
-			    128, SD_TIMEOUT, MAX_RETRIES);
+			    128, SD_TIMEOUT, SD_MAX_RETRIES);
 
 		the_result = SRpnt->sr_result;
 		retries--;
@@ -947,10 +955,10 @@
  * read disk capacity - called only in sd_init_onedisk()
  */
 static void
-sd_read_capacity(Scsi_Disk *sdkp, char *diskname,
-		 Scsi_Request *SRpnt, unsigned char *buffer) {
+sd_read_capacity(struct scsi_disk *sdkp, char *diskname,
+		 struct scsi_request *SRpnt, unsigned char *buffer) {
 	unsigned char cmd[10];
-	Scsi_Device *sdp = sdkp->device;
+	struct scsi_device *sdp = sdkp->device;
 	int the_result, retries;
 	int sector_size;
 
@@ -966,7 +974,7 @@
 		SRpnt->sr_data_direction = SCSI_DATA_READ;
 
 		scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
-			      8, SD_TIMEOUT, MAX_RETRIES);
+			      8, SD_TIMEOUT, SD_MAX_RETRIES);
 
 		if (sd_media_not_present(sdkp, SRpnt))
 			return;
@@ -1071,7 +1079,7 @@
 }
 
 static int
-sd_do_mode_sense6(Scsi_Device *sdp, Scsi_Request *SRpnt,
+sd_do_mode_sense6(struct scsi_device *sdp, struct scsi_request *SRpnt,
 		  int modepage, unsigned char *buffer, int len) {
 	unsigned char cmd[8];
 
@@ -1086,7 +1094,7 @@
 	SRpnt->sr_data_direction = SCSI_DATA_READ;
 
 	scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
-		      len, SD_TIMEOUT, MAX_RETRIES);
+		      len, SD_TIMEOUT, SD_MAX_RETRIES);
 
 	return SRpnt->sr_result;
 }
@@ -1095,9 +1103,9 @@
  * read write protect setting, if possible - called only in sd_init_onedisk()
  */
 static void
-sd_read_write_protect_flag(Scsi_Disk *sdkp, char *diskname,
-			   Scsi_Request *SRpnt, unsigned char *buffer) {
-	Scsi_Device *sdp = sdkp->device;
+sd_read_write_protect_flag(struct scsi_disk *sdkp, char *diskname,
+		   struct scsi_request *SRpnt, unsigned char *buffer) {
+	struct scsi_device *sdp = sdkp->device;
 	int res;
 
 	/*
@@ -1136,18 +1144,18 @@
 /**
  *	sd_init_onedisk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
- *	@sdkp: pointer to associated Scsi_Disk object
+ *	@sdkp: pointer to associated struct scsi_disk object
  *	@dsk_nr: disk number within this driver (e.g. 0->/dev/sda,
  *	1->/dev/sdb, etc)
  *
  *	Note: this function is local to this driver.
  **/
 static void
-sd_init_onedisk(Scsi_Disk * sdkp, struct gendisk *disk)
+sd_init_onedisk(struct scsi_disk * sdkp, struct gendisk *disk)
 {
 	unsigned char *buffer;
-	Scsi_Device *sdp;
-	Scsi_Request *SRpnt;
+	struct scsi_device *sdp;
+	struct scsi_request *SRpnt;
 
 	SCSI_LOG_HLQUEUE(3, printk("sd_init_onedisk: disk=%s\n", disk->disk_name));
 
@@ -1215,7 +1223,7 @@
 static int sd_init()
 {
 	int k, maxparts;
-	Scsi_Disk * sdkp;
+	struct scsi_disk * sdkp;
 
 	SCSI_LOG_HLQUEUE(3, printk("sd_init: dev_noticed=%d\n",
 			    sd_template.dev_noticed));
@@ -1255,10 +1263,10 @@
 	if (sd_dsk_arr) {
 		zero_mem_lth(sd_dsk_arr, sd_template.dev_max);
 		for (k = 0; k < sd_template.dev_max; ++k) {
-			sdkp = vmalloc(sizeof(Scsi_Disk));
+			sdkp = vmalloc(sizeof(struct scsi_disk));
 			if (NULL == sdkp)
 				goto cleanup_mem;
-			memset(sdkp, 0, sizeof(Scsi_Disk));
+			memset(sdkp, 0, sizeof(struct scsi_disk));
 			sd_dsk_arr[k] = sdkp;
 		}
 	}
@@ -1300,7 +1308,7 @@
  *	Note: this function is invoked from the scsi mid-level.
  *	This function is called before sd_init() so very little is available.
  **/
-static int sd_detect(Scsi_Device * sdp)
+static int sd_detect(struct scsi_device * sdp)
 {
 	SCSI_LOG_HLQUEUE(3, printk("sd_detect: type=%d\n", sdp->type));
 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD)
@@ -1324,9 +1332,9 @@
  *	(e.g. /dev/sda). More precisely it is the block device major 
  *	and minor number that is chosen here.
  **/
-static int sd_attach(Scsi_Device * sdp)
+static int sd_attach(struct scsi_device * sdp)
 {
-	Scsi_Disk *sdkp = NULL;	/* shut up lame gcc warning */
+	struct scsi_disk *sdkp = NULL;	/* shut up lame gcc warning */
 	int dsk_nr;
 	unsigned long iflags;
 	struct gendisk *gd;
@@ -1354,7 +1362,7 @@
 	for (dsk_nr = 0; dsk_nr < sd_template.dev_max; dsk_nr++) {
 		sdkp = sd_dsk_arr[dsk_nr];
 		if (!sdkp->device) {
-			memset(sdkp, 0, sizeof(Scsi_Disk));
+			memset(sdkp, 0, sizeof(struct scsi_disk));
 			sdkp->device = sdp;
 			break;
 		}
@@ -1401,7 +1409,7 @@
 
 static int sd_revalidate(struct gendisk *disk)
 {
-	Scsi_Disk *sdkp = disk->private_data;
+	struct scsi_disk *sdkp = disk->private_data;
 
 	if (!sdkp->device)
 		return -ENODEV;
@@ -1422,9 +1430,9 @@
  *	that could be re-used by a subsequent sd_attach().
  *	This function is not called when the built-in sd driver is "exit-ed".
  **/
-static void sd_detach(Scsi_Device * sdp)
+static void sd_detach(struct scsi_device * sdp)
 {
-	Scsi_Disk *sdkp = NULL;
+	struct scsi_disk *sdkp = NULL;
 	int dsk_nr;
 	unsigned long iflags;
 
@@ -1516,7 +1524,7 @@
 	      || event == SYS_POWER_OFF))
 		return NOTIFY_DONE;
 	for (i = 0; i < sd_template.dev_max; i++) {
-		Scsi_Disk *sdkp = sd_get_sdisk(i);
+		struct scsi_disk *sdkp = sd_get_sdisk(i);
 
 		if (!sdkp || !sdkp->device)
 			continue;
@@ -1539,9 +1547,9 @@
  * have user context) */
 static int sd_synchronize_cache(int index, int verbose)
 {
-	Scsi_Request *SRpnt;
-	Scsi_Disk *sdkp = sd_get_sdisk(index);
-	Scsi_Device *SDpnt = sdkp->device;
+	struct scsi_request *SRpnt;
+	struct scsi_disk *sdkp = sd_get_sdisk(index);
+	struct scsi_device *SDpnt = sdkp->device;
 	int retries, the_result;
 
 	if (!SDpnt->online)
@@ -1570,7 +1578,7 @@
 		/* leave the rest of the command zero to indicate 
 		 * flush everything */
 		scsi_wait_req(SRpnt, (void *)cmd, NULL, 0,
-			      SD_TIMEOUT, MAX_RETRIES);
+			      SD_TIMEOUT, SD_MAX_RETRIES);
 
 		if(SRpnt->sr_result == 0)
 			break;
@@ -1593,9 +1601,9 @@
 	return (the_result == 0);
 }
 
-static Scsi_Disk * sd_get_sdisk(int index)
+static struct scsi_disk * sd_get_sdisk(int index)
 {
-	Scsi_Disk * sdkp = NULL;
+	struct scsi_disk * sdkp = NULL;
 	unsigned long iflags;
 
 	read_lock_irqsave(&sd_dsk_arr_lock, iflags);
--- 1.8/drivers/scsi/sd.h	Mon Oct 21 16:34:15 2002
+++ edited/drivers/scsi/sd.h	Sat Oct 26 00:21:08 2002
@@ -1,43 +0,0 @@
-/*
- *    sd.h Copyright (C) 1992 Drew Eckhardt 
- *      SCSI disk driver header file by
- *              Drew Eckhardt 
- *
- *      <drew@colorado.edu>
- *
- *       Modified by Eric Youngdale eric@andante.org to
- *       add scatter-gather, multiple outstanding request, and other
- *       enhancements.
- */
-#ifndef _SD_H
-#define _SD_H
-
-#ifndef _SCSI_H
-#include "scsi.h"
-#endif
-
-#ifndef _GENDISK_H
-#include <linux/genhd.h>
-#endif
-
-typedef struct scsi_disk {
-	sector_t capacity;		/* size in 512-byte sectors */
-	Scsi_Device *device;
-	unsigned char media_present;
-	unsigned char write_prot;
-	unsigned WCE:1;         /* state of disk WCE bit */
-	unsigned RCD:1;         /* state of disk RCD bit */
-} Scsi_Disk;
-
-extern int revalidate_scsidisk(kdev_t dev, int maxusage);
-
-/*
- * Used by pmac to find the device associated with a target.
- */
-extern kdev_t sd_find_target(void *host, int tgt);
-
-#define N_SD_MAJORS	8
-
-#define SD_MAJOR_MASK	(N_SD_MAJORS - 1)
-
-#endif
