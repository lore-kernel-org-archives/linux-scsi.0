From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix sd device number handling
Date: Fri, 29 Nov 2002 23:14:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021129231424.A12951@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This is the final patch to make sd work properly in a hotplug
enviroment.  Add a bitmap for currently used disks so that we
can properly reuse dev_t when a disk is hot-unplugged.

While at that add support for the eight additional majors
allocated to sd in the latest devices.txt [1].

If only register_blkdev finally died we could nuke almost all
knowledge of majors/minors from sd...

[1] http://www.lanana.org/docs/device-list/devices.txt

--- 1.95/drivers/scsi/sd.c	Thu Nov 28 16:39:22 2002
+++ edited/drivers/scsi/sd.c	Fri Nov 29 22:56:42 2002
@@ -29,8 +29,6 @@
  *	than the level indicated above to trigger output.	
  */
 
-#define MAJOR_NR SCSI_DISK0_MAJOR
-
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/fs.h>
@@ -57,8 +55,8 @@
 /*
  * Remaining dev_t-handling stuff
  */
-#define SD_MAJORS	8
-#define SD_MAJOR(i)	((i) ? SCSI_DISK1_MAJOR-1+(i) : SCSI_DISK0_MAJOR)
+#define SD_MAJORS	16
+#define SD_DISKS	(SD_MAJORS << 4)
 
 /*
  * Time out in seconds for disks and Magneto-opticals (which are slower).
@@ -77,16 +75,19 @@
 	struct scsi_device *device;
 	struct gendisk	*disk;
 	sector_t	capacity;	/* size in 512-byte sectors */
+	u32		index;
 	u8		media_present;
 	u8		write_prot;
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit */
 };
 
-static int sd_nr_dev;	/* XXX(hch) bad hack, we want a bitmap instead */
 static LIST_HEAD(sd_devlist);
 static spinlock_t sd_devlist_lock = SPIN_LOCK_UNLOCKED;
 
+static unsigned long sd_index_bits[SD_DISKS / BITS_PER_LONG];
+static spinlock_t sd_index_lock = SPIN_LOCK_UNLOCKED;
+
 static void sd_init_onedisk(struct scsi_disk * sdkp, struct gendisk *disk);
 static void sd_rw_intr(struct scsi_cmnd * SCpnt);
 
@@ -111,6 +112,21 @@
 	},
 };
 
+static int sd_major(int major_idx)
+{
+	switch (major_idx) {
+	case 0:
+		return SCSI_DISK0_MAJOR;
+	case 1 ... 7:
+		return SCSI_DISK1_MAJOR + major_idx - 1;
+	case 8 ... 15:
+		return SCSI_DISK8_MAJOR + major_idx;
+	default:
+		BUG();
+		return 0;	/* shut up gcc */
+	}
+}
+
 static struct scsi_disk *sd_find_by_sdev(Scsi_Device *sd)
 {
 	struct scsi_disk *sdkp;
@@ -1156,9 +1172,10 @@
  **/
 static int sd_attach(struct scsi_device * sdp)
 {
-	struct scsi_disk *sdkp = NULL;	/* shut up lame gcc warning */
+	struct scsi_disk *sdkp;
 	struct gendisk *gd;
-	int dsk_nr, error;
+	u32 index;
+	int error;
 
 	if ((sdp->type != TYPE_DISK) && (sdp->type != TYPE_MOD))
 		return 1;
@@ -1179,28 +1196,33 @@
 	if (!gd)
 		goto out_free;
 
-	/*
-	 * XXX  This doesn't make us better than the previous code in the
-	 * XXX  end (not worse either, though..).
-	 * XXX  To properly support hotplugging we should have a bitmap and
-	 * XXX  use find_first_zero_bit on it.  This will happen at the
-	 * XXX  same time template->nr_* goes away.		--hch
-	 */
-	dsk_nr = sd_nr_dev++;
+	spin_lock(&sd_index_lock);
+	index = find_first_zero_bit(sd_index_bits, SD_DISKS);
+	if (index == SD_DISKS) {
+		spin_unlock(&sd_index_lock);
+		error = -EBUSY;
+		goto out_put;
+	}
+	__set_bit(index, sd_index_bits);
+	spin_unlock(&sd_index_lock);
 
 	sdkp->device = sdp;
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
+	sdkp->index = index;
 
 	gd->de = sdp->de;
-	gd->major = SD_MAJOR(dsk_nr>>4);
-	gd->first_minor = (dsk_nr & 15)<<4;
+	gd->major = sd_major(index >> 4);
+	gd->first_minor = (index & 15) << 4;
 	gd->minors = 16;
 	gd->fops = &sd_fops;
-	if (dsk_nr > 26)
-		sprintf(gd->disk_name, "sd%c%c",'a'+dsk_nr/26-1,'a'+dsk_nr%26);
-	else
-		sprintf(gd->disk_name, "sd%c",'a'+dsk_nr%26);
+
+	if (index > 26) {
+		sprintf(gd->disk_name, "sd%c%c",
+			'a' + index/26-1,'a' + index % 26);
+	} else {
+		sprintf(gd->disk_name, "sd%c", 'a' + index % 26);
+	}
 
 	sd_init_onedisk(sdkp, gd);
 
@@ -1222,6 +1244,8 @@
 
 	return 0;
 
+out_put:
+	put_disk(gd);
 out_free:
 	kfree(sdkp);
 out_detach:
@@ -1263,7 +1287,11 @@
 	sd_devlist_remove(sdkp);
 	del_gendisk(sdkp->disk);
 	scsi_slave_detach(sdp);
-	sd_nr_dev--;
+
+	spin_lock(&sd_index_lock);
+	clear_bit(sdkp->index, sd_index_bits);
+	spin_unlock(&sd_index_lock);
+
 	put_disk(sdkp->disk);
 	kfree(sdkp);
 }
@@ -1281,10 +1309,10 @@
 	SCSI_LOG_HLQUEUE(3, printk("init_sd: sd driver entry point\n"));
 
 	for (i = 0; i < SD_MAJORS; i++) {
-		if (register_blkdev(SD_MAJOR(i), "sd", &sd_fops))
+		if (register_blkdev(sd_major(i), "sd", &sd_fops))
 			printk(KERN_NOTICE
 			       "Unable to get major %d for SCSI disk\n",
-			       SD_MAJOR(i));
+			       sd_major(i));
 		else
 			majors++;
 	}
@@ -1313,7 +1341,7 @@
 	unregister_reboot_notifier(&sd_notifier_block);
 	scsi_unregister_device(&sd_template);
 	for (i = 0; i < SD_MAJORS; i++)
-		unregister_blkdev(SD_MAJOR(i), "sd");
+		unregister_blkdev(sd_major(i), "sd");
 }
 
 /*
--- 1.6/include/linux/major.h	Fri Nov  8 08:45:14 2002
+++ edited/include/linux/major.h	Fri Nov 29 22:50:49 2002
@@ -94,6 +94,14 @@
 #define SCSI_DISK6_MAJOR	70
 #define SCSI_DISK7_MAJOR	71
 
+#define SCSI_DISK8_MAJOR	128
+#define SCSI_DISK9_MAJOR	129
+#define SCSI_DISK10_MAJOR	130
+#define SCSI_DISK11_MAJOR	131
+#define SCSI_DISK12_MAJOR	132
+#define SCSI_DISK13_MAJOR	133
+#define SCSI_DISK14_MAJOR	134
+#define SCSI_DISK15_MAJOR	135
 
 #define COMPAQ_SMART2_MAJOR	72
 #define COMPAQ_SMART2_MAJOR1	73
