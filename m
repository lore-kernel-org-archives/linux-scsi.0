From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/13] block: replace @ext_minors with GENHD_FL_EXT_DEVT
Date: Mon, 14 Jul 2008 16:48:12 +0900
Message-ID: <1216021693-483-13-git-send-email-tj@kernel.org>
References: <1216021693-483-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:37992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbYGNHti (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 03:49:38 -0400
In-Reply-To: <1216021693-483-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>

With previous changes, it's meaningless to limit the number of
partitions.  Replace @ext_minors with GENHD_FL_EXT_DEVT such that
setting the flag allows the disk to have maximum number of allowed
partitions (only limited by the number of entries in parsed_partitions
as determined by MAX_PART constant).

This kills not-too-pretty alloc_disk_ext[_node]() functions and makes
@minors parameter to alloc_disk[_node]() unnecessary.  The parameter
is left alone to avoid disturbing the users.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c          |   16 +---------------
 drivers/ide/ide-disk.c |   14 +++++---------
 drivers/scsi/sd.c      |    9 ++-------
 fs/partitions/check.h  |    4 +---
 include/linux/genhd.h  |   16 ++++++++--------
 5 files changed, 17 insertions(+), 42 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 72aef36..b38c235 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1025,19 +1025,10 @@ struct gendisk *alloc_disk(int minors)
 {
 	return alloc_disk_node(minors, -1);
 }
+EXPORT_SYMBOL(alloc_disk);
 
 struct gendisk *alloc_disk_node(int minors, int node_id)
 {
-	return alloc_disk_ext_node(minors, 0, node_id);
-}
-
-struct gendisk *alloc_disk_ext(int minors, int ext_minors)
-{
-	return alloc_disk_ext_node(minors, ext_minors, -1);
-}
-
-struct gendisk *alloc_disk_ext_node(int minors, int ext_minors, int node_id)
-{
 	struct gendisk *disk;
 
 	disk = kmalloc_node(sizeof(struct gendisk),
@@ -1055,7 +1046,6 @@ struct gendisk *alloc_disk_ext_node(int minors, int ext_minors, int node_id)
 		disk->part_tbl->part[0] = &disk->part0;
 
 		disk->minors = minors;
-		disk->ext_minors = ext_minors;
 		rand_initialize_disk(disk);
 		disk_to_dev(disk)->class = &block_class;
 		disk_to_dev(disk)->type = &disk_type;
@@ -1066,11 +1056,7 @@ struct gendisk *alloc_disk_ext_node(int minors, int ext_minors, int node_id)
 	}
 	return disk;
 }
-
-EXPORT_SYMBOL(alloc_disk);
 EXPORT_SYMBOL(alloc_disk_node);
-EXPORT_SYMBOL(alloc_disk_ext);
-EXPORT_SYMBOL(alloc_disk_ext_node);
 
 struct kobject *get_disk(struct gendisk *disk)
 {
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 3c6f0fa..6d7cf15 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -41,16 +41,12 @@
 #include <asm/io.h>
 #include <asm/div64.h>
 
-#define IDE_DISK_PARTS		(1 << PARTN_BITS)
-
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
-#define IDE_DISK_MINORS		IDE_DISK_PARTS
+#define IDE_DISK_MINORS		(1 << PARTN_BITS)
 #else
 #define IDE_DISK_MINORS		1
 #endif
 
-#define IDE_DISK_EXT_MINORS	(IDE_DISK_PARTS - IDE_DISK_MINORS)
-
 struct ide_disk_obj {
 	ide_drive_t	*drive;
 	ide_driver_t	*driver;
@@ -1168,8 +1164,7 @@ static int ide_disk_probe(ide_drive_t *drive)
 	if (!idkp)
 		goto failed;
 
-	g = alloc_disk_ext_node(IDE_DISK_MINORS, IDE_DISK_EXT_MINORS,
-				hwif_to_node(drive->hwif));
+	g = alloc_disk_node(IDE_DISK_MINORS, hwif_to_node(drive->hwif));
 	if (!g)
 		goto out_free_idkp;
 
@@ -1196,9 +1191,10 @@ static int ide_disk_probe(ide_drive_t *drive)
 		drive->attach = 1;
 
 	g->minors = IDE_DISK_MINORS;
-	g->ext_minors = IDE_DISK_EXT_MINORS;
 	g->driverfs_dev = &drive->gendev;
-	g->flags = drive->removable ? GENHD_FL_REMOVABLE : 0;
+	g->flags |= GENHD_FL_EXT_DEVT;
+	if (drive->removable)
+		g->flags |= GENHD_FL_REMOVABLE;
 	set_capacity(g, idedisk_capacity(drive));
 	g->fops = &idedisk_ops;
 	add_disk(g);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f355a39..1f41e3d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -86,16 +86,12 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 
-#define SD_PARTS	64
-
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define SD_MINORS	16
 #else
 #define SD_MINORS	1
 #endif
 
-#define SD_EXT_MINORS	(SD_PARTS - SD_MINORS)
-
 static int  sd_revalidate_disk(struct gendisk *);
 static int  sd_probe(struct device *);
 static int  sd_remove(struct device *);
@@ -1651,7 +1647,7 @@ static int sd_probe(struct device *dev)
 	if (!sdkp)
 		goto out;
 
-	gd = alloc_disk_ext(SD_MINORS, SD_EXT_MINORS);
+	gd = alloc_disk(SD_MINORS);
 	if (!gd)
 		goto out_free;
 
@@ -1696,7 +1692,6 @@ static int sd_probe(struct device *dev)
 	gd->major = sd_major((index & 0xf0) >> 4);
 	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
 	gd->minors = SD_MINORS;
-	gd->ext_minors = SD_EXT_MINORS;
 	gd->fops = &sd_fops;
 
 	if (index < 26) {
@@ -1720,7 +1715,7 @@ static int sd_probe(struct device *dev)
 	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
 
 	gd->driverfs_dev = &sdp->sdev_gendev;
-	gd->flags = GENHD_FL_DRIVERFS;
+	gd->flags = GENHD_FL_EXT_DEVT | GENHD_FL_DRIVERFS;
 	if (sdp->removable)
 		gd->flags |= GENHD_FL_REMOVABLE;
 
diff --git a/fs/partitions/check.h b/fs/partitions/check.h
index 17ae8ec..98dbe1a 100644
--- a/fs/partitions/check.h
+++ b/fs/partitions/check.h
@@ -5,15 +5,13 @@
  * add_gd_partition adds a partitions details to the devices partition
  * description.
  */
-enum { MAX_PART = 256 };
-
 struct parsed_partitions {
 	char name[BDEVNAME_SIZE];
 	struct {
 		sector_t from;
 		sector_t size;
 		int flags;
-	} parts[MAX_PART];
+	} parts[DISK_MAX_PARTS];
 	int next;
 	int limit;
 };
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index c7d9251..a48f350 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -58,6 +58,8 @@ enum {
 	UNIXWARE_PARTITION = 0x63,	/* Same as GNU_HURD and SCO Unix */
 };
 
+#define DISK_MAX_PARTS			256
+
 #include <linux/major.h>
 #include <linux/device.h>
 #include <linux/smp.h>
@@ -112,6 +114,7 @@ struct hd_struct {
 #define GENHD_FL_CD				8
 #define GENHD_FL_UP				16
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
+#define GENHD_FL_EXT_DEVT			64 /* allow extended devt */
 
 struct disk_part_tbl {
 	struct rcu_head rcu_head;
@@ -120,15 +123,13 @@ struct disk_part_tbl {
 };
 
 struct gendisk {
-	/* major, first_minor, minors and ext_minors are input
-	 * parameters only, don't use directly.  Use disk_devt() and
-	 * disk_max_parts().
+	/* major, first_minor and minors are input parameters only,
+	 * don't use directly.  Use disk_devt() and disk_max_parts().
 	 */
 	int major;			/* major number of driver */
 	int first_minor;
 	int minors;                     /* maximum number of minors, =1 for
                                          * disks that can't be partitioned. */
-	int ext_minors;			/* number of extended dynamic minors */
 
 	char disk_name[32];		/* name of major driver */
 
@@ -169,7 +170,9 @@ static inline struct gendisk *part_to_disk(struct hd_struct *part)
 
 static inline int disk_max_parts(struct gendisk *disk)
 {
-	return disk->minors + disk->ext_minors;
+	if (disk->flags & GENHD_FL_EXT_DEVT)
+		return DISK_MAX_PARTS;
+	return disk->minors;
 }
 
 static inline bool disk_partitionable(struct gendisk *disk)
@@ -507,9 +510,6 @@ extern void printk_all_partitions(void);
 
 extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
-extern struct gendisk *alloc_disk_ext_node(int minors, int ext_minrs,
-					   int node_id);
-extern struct gendisk *alloc_disk_ext(int minors, int ext_minors);
 extern struct kobject *get_disk(struct gendisk *disk);
 extern void put_disk(struct gendisk *disk);
 extern void blk_register_region(dev_t devt, unsigned long range,
-- 
1.5.4.5

