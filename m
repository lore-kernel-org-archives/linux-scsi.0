From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] switch sd numbering to idr
Date: Sat, 14 Aug 2004 16:35:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040814143536.GA26100@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:27563 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263467AbUHNOfk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Aug 2004 10:35:40 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Switch sd.c device number allocation to use idr, this limits memory
usage for lowend setups and highend setups are only limited by the
available names now.


--- 1.155/drivers/scsi/sd.c	2004-08-13 02:03:53 +02:00
+++ edited/drivers/scsi/sd.c	2004-08-14 15:46:26 +02:00
@@ -42,6 +42,7 @@
 #include <linux/genhd.h>
 #include <linux/hdreg.h>
 #include <linux/errno.h>
+#include <linux/idr.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
@@ -62,12 +63,18 @@
 
 #include "scsi_logging.h"
 
-
 /*
- * Remaining dev_t-handling stuff
+ * More than enough for everybody ;)  The huge number of majors
+ * is a leftover from 16bit dev_t days, we don't really need that
+ * much numberspace.
  */
 #define SD_MAJORS	16
-#define SD_DISKS	32768	/* anything between 256 and 262144 */
+
+/*
+ * This is limited by the naming scheme enforced in sd_probe,
+ * add another character to it if you really need more disks.
+ */
+#define SD_MAX_DISKS	(((26 * 26) + 26 + 1) * 26)
 
 /*
  * Time out in seconds for disks and Magneto-opticals (which are slower).
@@ -96,8 +103,7 @@
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 };
 
-
-static unsigned long sd_index_bits[SD_DISKS / BITS_PER_LONG];
+static DEFINE_IDR(sd_index_idr);
 static spinlock_t sd_index_lock = SPIN_LOCK_UNLOCKED;
 
 /* This semaphore is used to mediate the 0->1 reference get in the
@@ -128,7 +134,8 @@
 	.init_command		= sd_init_command,
 };
 
-/* Device no to disk mapping:
+/*
+ * Device no to disk mapping:
  * 
  *       major         disc2     disc  p1
  *   |............|.............|....|....| <- dev_t
@@ -141,7 +148,6 @@
  * As we stay compatible with our numbering scheme, we can reuse 
  * the well-know SCSI majors 8, 65--71, 136--143.
  */
-
 static int sd_major(int major_idx)
 {
 	switch (major_idx) {
@@ -157,14 +163,6 @@
 	}
 }
 
-static unsigned int make_sd_dev(unsigned int sd_nr, unsigned int part)
-{
-	return  (part & 0xf) | ((sd_nr & 0xf) << 4) |
-		(sd_major((sd_nr & 0xf0) >> 4) << 20) | (sd_nr & 0xfff00);
-}
-
-/* reverse mapping dev -> (sd_nr, part) not currently needed */
-
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,kref)
 
 static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
@@ -1347,7 +1345,7 @@
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
 	u32 index;
-	int error, devno;
+	int error;
 
 	error = -ENODEV;
 	if ((sdp->type != TYPE_DISK) && (sdp->type != TYPE_MOD))
@@ -1364,25 +1362,21 @@
 	memset (sdkp, 0, sizeof(*sdkp));
 	kref_init(&sdkp->kref, scsi_disk_release);
 
-	/* Note: We can accomodate 64 partitions, but the genhd code
-	 * assumes partitions allocate consecutive minors, which they don't.
-	 * So for now stay with max 16 partitions and leave two spare bits. 
-	 * Later, we may change the genhd code and the alloc_disk() call
-	 * and the ->minors assignment here. 	KG, 2004-02-10
-	 */ 
 	gd = alloc_disk(16);
 	if (!gd)
 		goto out_free;
 
+	if (!idr_pre_get(&sd_index_idr, GFP_KERNEL))
+		goto out_put;
+
 	spin_lock(&sd_index_lock);
-	index = find_first_zero_bit(sd_index_bits, SD_DISKS);
-	if (index == SD_DISKS) {
-		spin_unlock(&sd_index_lock);
+	error = idr_get_new(&sd_index_idr, NULL, &index);
+	spin_unlock(&sd_index_lock);
+
+	if (index >= SD_MAX_DISKS)
 		error = -EBUSY;
+	if (error)
 		goto out_put;
-	}
-	__set_bit(index, sd_index_bits);
-	spin_unlock(&sd_index_lock);
 
 	sdkp->device = sdp;
 	sdkp->driver = &sd_template;
@@ -1397,15 +1391,14 @@
 			sdp->timeout = SD_MOD_TIMEOUT;
 	}
 
-	devno = make_sd_dev(index, 0);
-	gd->major = MAJOR(devno);
-	gd->first_minor = MINOR(devno);
+	gd->major = sd_major((index & 0xf0) >> 4);
+	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
 	gd->minors = 16;
 	gd->fops = &sd_fops;
 
 	if (index < 26) {
 		sprintf(gd->disk_name, "sd%c", 'a' + index % 26);
-	} else if (index < (26*27)) {
+	} else if (index < (26 + 1) * 26) {
 		sprintf(gd->disk_name, "sd%c%c",
 			'a' + index / 26 - 1,'a' + index % 26);
 	} else {
@@ -1485,7 +1478,7 @@
 	struct gendisk *disk = sdkp->disk;
 	
 	spin_lock(&sd_index_lock);
-	clear_bit(sdkp->index, sd_index_bits);
+	idr_remove(&sd_index_idr, sdkp->index);
 	spin_unlock(&sd_index_lock);
 
 	disk->private_data = NULL;
