From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/10] block: implement CONFIG_DEBUG_BLOCK_EXT_DEVT
Date: Mon, 14 Jul 2008 16:12:14 +0900
Message-ID: <1216019534-29977-11-git-send-email-tj@kernel.org>
References: <1216019534-29977-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:47991 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756859AbYGNHR0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 03:17:26 -0400
In-Reply-To: <1216019534-29977-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>

Extended devt introduces non-contiguos device numbers.  This patch
implements a debug option which forces most devt allocations to be
from the extended area and spreads them out.  This is enabled by
default if DEBUG_KERNEL is set and achieves...

1. Detects code paths in kernel or userland which expect predetermined
   consecutive device numbers.

2. When something goes wrong, avoid corruption as adding to the minor
   of earlier partition won't lead to the wrong but valid device.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c          |   38 +++++++++++++++++++++++++++++++++++---
 drivers/ide/ide-disk.c |    6 ++++++
 drivers/scsi/sd.c      |    6 ++++++
 lib/Kconfig.debug      |   16 ++++++++++++++++
 4 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 1b8ca16..e2deec2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -299,6 +299,38 @@ EXPORT_SYMBOL(unregister_blkdev);
 static struct kobj_map *bdev_map;
 
 /**
+ * blk_mangle_minor - scatter minor numbers apart
+ * @minor: minor number to mangle
+ *
+ * Scatter consecutively allocated @minor number apart if MANGLE_DEVT
+ * is enabled.  Mangling twice gives the original value.
+ *
+ * RETURNS:
+ * Mangled value.
+ *
+ * CONTEXT:
+ * Don't care.
+ */
+static int blk_mangle_minor(int minor)
+{
+#ifdef CONFIG_DEBUG_BLOCK_EXT_DEVT
+	int i;
+
+	for (i = 0; i < MINORBITS / 2; i++) {
+		int low = minor & (1 << i);
+		int high = minor & (1 << (MINORBITS - 1 - i));
+		int distance = MINORBITS - 1 - 2 * i;
+
+		minor ^= low | high;	/* clear both bits */
+		low <<= distance;	/* swap the positions */
+		high >>= distance;
+		minor |= low | high;	/* and set */
+	}
+#endif
+	return minor;
+}
+
+/**
  * blk_alloc_devt - allocate a dev_t for a partition
  * @part: partition to allocate dev_t for
  * @gfp_mask: memory allocation flag
@@ -338,7 +370,7 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
 		return -EBUSY;
 	}
 
-	*devt = MKDEV(BLOCK_EXT_MAJOR, idx);
+	*devt = MKDEV(BLOCK_EXT_MAJOR, blk_mangle_minor(idx));
 	return 0;
 }
 
@@ -360,7 +392,7 @@ void blk_free_devt(dev_t devt)
 
 	if (MAJOR(devt) == BLOCK_EXT_MAJOR) {
 		mutex_lock(&ext_devt_mutex);
-		idr_remove(&ext_devt_idr, MINOR(devt));
+		idr_remove(&ext_devt_idr, blk_mangle_minor(MINOR(devt)));
 		mutex_unlock(&ext_devt_mutex);
 	}
 }
@@ -469,7 +501,7 @@ struct gendisk *get_gendisk(dev_t devt, int *partno)
 		struct hd_struct *part;
 
 		mutex_lock(&ext_devt_mutex);
-		part = idr_find(&ext_devt_idr, MINOR(devt));
+		part = idr_find(&ext_devt_idr, blk_mangle_minor(MINOR(devt)));
 		if (part && get_disk(part_to_disk(part))) {
 			*partno = part->partno;
 			disk = part_to_disk(part);
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index f8b091a..3c6f0fa 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -42,7 +42,13 @@
 #include <asm/div64.h>
 
 #define IDE_DISK_PARTS		(1 << PARTN_BITS)
+
+#if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define IDE_DISK_MINORS		IDE_DISK_PARTS
+#else
+#define IDE_DISK_MINORS		1
+#endif
+
 #define IDE_DISK_EXT_MINORS	(IDE_DISK_PARTS - IDE_DISK_MINORS)
 
 struct ide_disk_obj {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0a8b559..f355a39 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -87,7 +87,13 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 
 #define SD_PARTS	64
+
+#if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define SD_MINORS	16
+#else
+#define SD_MINORS	1
+#endif
+
 #define SD_EXT_MINORS	(SD_PARTS - SD_MINORS)
 
 static int  sd_revalidate_disk(struct gendisk *);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d2099f4..46bc380 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -565,6 +565,22 @@ config BACKTRACE_SELF_TEST
 
 	  Say N if you are unsure.
 
+config DEBUG_BLOCK_EXT_DEVT
+        bool "Force extended block device numbers and spread them"
+	depends on DEBUG_KERNEL
+	depends on BLOCK
+	default y
+	help
+	  Conventionally, block device numbers are allocated from
+	  predetermined contiguous area.  However, extended block area
+	  may introduce non-contiguous block device numbers.  This
+	  option forces most block device numbers to be allocated from
+	  the extended space and spreads them to discover kernel or
+	  userland code paths which assume predetermined contiguous
+	  device number allocation.
+
+	  Say N if you are unsure.
+
 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
 	depends on DEBUG_KERNEL
-- 
1.5.4.5

