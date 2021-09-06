Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF7BC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 01:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 769606101C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 01:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238660AbhIFB7e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Sep 2021 21:59:34 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:22459 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238872AbhIFB7T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2021 21:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630893496; x=1662429496;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=8tQek1BuCHd6+e3To9J3XU0DZ1rXln0abM7Vu7Q/aXs=;
  b=mO1cl1BG3xwiyA++e6yD96vTmCqExD6Eg4O1Of4NQ5hzxkH/mP/W3dgm
   GisOTgyFnrSTmZy8NnJy3KA6E5wBe1X8pMcp1y7Y8DemRlTDaGJ+WNoJ0
   S59kY2QBlafR7kGeZqS2o9H+bTCExebJSyfXFAx36rJQVQ6SB46jFuyB3
   t0opKd1R8KuEARDMNnO8KT5CRGd5dWXDvCQALlyNFS280I1DocLn3fCF+
   9v5JPUAlDhZbutzjGS5Q/rZ1ylkxu5NSiZTKXjyzGQGkRQL/14+tGvfFK
   uSIgO2iVUmg0zxKPH3D4Dj+pU7tgUp+N+xgJUv+He9ry1giGTfeauRE/0
   A==;
X-IronPort-AV: E=Sophos;i="5.85,271,1624291200"; 
   d="scan'208";a="179789028"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2021 09:58:16 +0800
IronPort-SDR: G2xTtQb7TktW2jcwe9Zd26BTTw9UR+c+5I0u8MC3m6xSuHy3QU/d2kYVFeIkCW+GAIFmcIEOGH
 UE4TG27VFbZc2AkVU8UjRD3ZYopP8WIlf3sVV1PY1IoX75p0yd4vvNgz3iAAdTqhD157KDT/9g
 Jumve9ul4KI0xbbkaXm966Sm1g/k/4M6LbG7eqeyTkznq+T8/7EqI+rHa4pBLb3uI04lqGHxbO
 YBBUWWEkEa/r73Pd8MzbKgAcLGcoA2kFCLqs8ZBajO4x3n/fbZF9+En6qbNAHvJpgF0wMdV7uQ
 znclGXTcXPpsWm8KNFNf+99a
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 18:33:16 -0700
IronPort-SDR: 0CAdCgW4K6JlTF1CWwLYpeBPmLvQDF9Y8qCydD9atzukPYc+K0HcQOglhG7F5Ku/HDXPQA4z4T
 +d7NpKGFyEIm1WnPIibDvn0IxfahPtkWTOHI4KUi++dif7t0Vjly80LkJq3f1yAsAz4TmuO7ea
 vMK8Xso5Dxwdk6zgaFY3vsS89fOkvuS10lwAtiCS/+0i4Qr9v1SDa+RNEYIe+XWYyg1O+m9EhU
 SZ/QmrWpsxHFhPU+nngNZmZFsEddko8StZs+MzPiymrJAKg7GME3C1PRq5/dDffHE1crwkPs62
 OWU=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 05 Sep 2021 18:58:15 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v7 1/5] block: Add independent access ranges support
Date:   Mon,  6 Sep 2021 10:58:06 +0900
Message-Id: <20210906015810.732799-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210906015810.732799-1-damien.lemoal@wdc.com>
References: <20210906015810.732799-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The Concurrent Positioning Ranges VPD page (for SCSI) and data log page
(for ATA) contain parameters describing the set of contiguous LBAs that
can be served independently by a single LUN multi-actuator hard-disk.
Similarly, a logically defined block device composed of multiple disks
can in some cases execute requests directed at different sector ranges
in parallel. A dm-linear device aggregating 2 block devices together is
an example.

This patch implements support for exposing a block device independent
access ranges to the user through sysfs to allow optimizing device
accesses to increase performance.

To describe the set of independent sector ranges of a device (actuators
of a multi-actuator HDDs or table entries of a dm-linear device),
The type struct blk_independent_access_ranges is introduced. This
structure describes the sector ranges using an array of
struct blk_independent_access_range structures. This range structure
defines the start sector and number of sectors of the access range.
The ranges in the array cannot overlap and must contain all sectors
within the device capacity.

The function disk_set_iaranges() allows a device driver to signal to
the block layer that a device has multiple independent access ranges.
In this case, a struct blk_independent_access_ranges is attached to
the device request queue by the function disk_set_iaranges(). The
function disk_alloc_iaranges() is provided for drivers to allocate this
structure.

struct blk_independent_access_ranges contains kobjects (struct kobject)
to expose to the user through sysfs the set of independent access ranges
supported by a device. When the device is initialized, sysfs
registration of the ranges information is done from blk_register_queue()
using the block layer internal function disk_register_iaranges(). If a
driver calls disk_set_iaranges() for a registered queue, e.g. when a
device is revalidated, disk_set_iaranges() will execute
disk_register_iaranges() to update the sysfs attribute files.

The sysfs file structure created starts from the
independent_access_ranges sub-directory and contains the start sector
and number of sectors of each range, with the information for each
range grouped in numbered sub-directories.

E.g. for a dual actuator HDD, the user sees:

$ tree /sys/block/sdk/queue/independent_access_ranges/
/sys/block/sdk/queue/independent_access_ranges/
|-- 0
|   |-- nr_sectors
|   `-- sector
`-- 1
    |-- nr_sectors
    `-- sector

For a regular device with a single access range, the
independent_access_ranges sysfs directory does not exist.

Device revalidation may lead to changes to this structure and to the
attribute values. When manipulated, the queue sysfs_lock and
sysfs_dir_lock mutexes are held for atomicity, similarly to how the
blk-mq and elevator sysfs queue sub-directories are protected.

The code related to the management of independent access ranges is
added in the new file block/blk-iaranges.c.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/Makefile         |   2 +-
 block/blk-iaranges.c   | 345 +++++++++++++++++++++++++++++++++++++++++
 block/blk-sysfs.c      |  26 +++-
 block/blk.h            |   4 +
 include/linux/blkdev.h |  39 +++++
 5 files changed, 407 insertions(+), 9 deletions(-)
 create mode 100644 block/blk-iaranges.c

diff --git a/block/Makefile b/block/Makefile
index 1d0d466f2182..f9c4c255df76 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_BLOCK) := bio.o elevator.o blk-core.o blk-sysfs.o \
 			blk-lib.o blk-mq.o blk-mq-tag.o blk-stat.o \
 			blk-mq-sysfs.o blk-mq-cpumap.o blk-mq-sched.o ioctl.o \
 			genhd.o ioprio.o badblocks.o partitions/ blk-rq-qos.o \
-			disk-events.o
+			disk-events.o blk-iaranges.o
 
 obj-$(CONFIG_BOUNCE)		+= bounce.o
 obj-$(CONFIG_BLK_SCSI_REQUEST)	+= scsi_ioctl.o
diff --git a/block/blk-iaranges.c b/block/blk-iaranges.c
new file mode 100644
index 000000000000..a60a98c487cd
--- /dev/null
+++ b/block/blk-iaranges.c
@@ -0,0 +1,345 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  Block device concurrent positioning ranges.
+ *
+ *  Copyright (C) 2021 Western Digital Corporation or its Affiliates.
+ */
+#include <linux/kernel.h>
+#include <linux/blkdev.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+
+#include "blk.h"
+
+static ssize_t
+blk_iarange_sector_show(struct blk_independent_access_range *iar, char *buf)
+{
+	return sprintf(buf, "%llu\n", iar->sector);
+}
+
+static ssize_t
+blk_iarange_nr_sectors_show(struct blk_independent_access_range *iar, char *buf)
+{
+	return sprintf(buf, "%llu\n", iar->nr_sectors);
+}
+
+struct blk_iarange_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct blk_independent_access_range *iar, char *buf);
+};
+
+static struct blk_iarange_sysfs_entry blk_iarange_sector_entry = {
+	.attr = { .name = "sector", .mode = 0444 },
+	.show = blk_iarange_sector_show,
+};
+
+static struct blk_iarange_sysfs_entry blk_iarange_nr_sectors_entry = {
+	.attr = { .name = "nr_sectors", .mode = 0444 },
+	.show = blk_iarange_nr_sectors_show,
+};
+
+static struct attribute *blk_iarange_attrs[] = {
+	&blk_iarange_sector_entry.attr,
+	&blk_iarange_nr_sectors_entry.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(blk_iarange);
+
+static ssize_t blk_iarange_sysfs_show(struct kobject *kobj,
+				      struct attribute *attr, char *buf)
+{
+	struct blk_iarange_sysfs_entry *entry =
+		container_of(attr, struct blk_iarange_sysfs_entry, attr);
+	struct blk_independent_access_range *iar =
+		container_of(kobj, struct blk_independent_access_range, kobj);
+	ssize_t ret;
+
+	mutex_lock(&iar->queue->sysfs_lock);
+	ret = entry->show(iar, buf);
+	mutex_unlock(&iar->queue->sysfs_lock);
+
+	return ret;
+}
+
+static const struct sysfs_ops blk_iarange_sysfs_ops = {
+	.show	= blk_iarange_sysfs_show,
+};
+
+/*
+ * Independent access range entries are not freed individually, but alltogether
+ * with struct blk_independent_access_ranges and its array of range entries.
+ * Since kobject_add() takes a reference on the parent kobject contained in
+ * struct blk_independent_access_ranges, the array of independent access range
+ * entries cannot be freed until kobject_del() is called for all entries.
+ * So we do not need to do anything here, but still need this no-op release
+ * operation to avoid complaints from the kobject code.
+ */
+static void blk_iarange_sysfs_nop_release(struct kobject *kobj)
+{
+}
+
+static struct kobj_type blk_iarange_ktype = {
+	.sysfs_ops	= &blk_iarange_sysfs_ops,
+	.default_groups	= blk_iarange_groups,
+	.release	= blk_iarange_sysfs_nop_release,
+};
+
+/*
+ * This will be executed only after all independent access range entries are
+ * removed with kobject_del(), at which point, it is safe to free everything,
+ * including the array of range entries.
+ */
+static void blk_iaranges_sysfs_release(struct kobject *kobj)
+{
+	struct blk_independent_access_ranges *iars =
+		container_of(kobj, struct blk_independent_access_ranges, kobj);
+
+	kfree(iars);
+}
+
+static struct kobj_type blk_iaranges_ktype = {
+	.release	= blk_iaranges_sysfs_release,
+};
+
+/**
+ * disk_register_iaranges - register with sysfs a set of independent
+ *			    access ranges
+ * @disk:	Target disk
+ * @new_iars:	New set of independent access ranges
+ *
+ * Register with sysfs a set of independent access ranges for @disk.
+ * If @new_iars is not NULL, this set of ranges is registered and the old set
+ * specified by q->iaranges is unregistered. Otherwise, q->iaranges is
+ * registered if it is not already.
+ */
+int disk_register_iaranges(struct gendisk *disk,
+			   struct blk_independent_access_ranges *new_iars)
+{
+	struct request_queue *q = disk->queue;
+	struct blk_independent_access_ranges *iars;
+	int i, ret;
+
+	lockdep_assert_held(&q->sysfs_dir_lock);
+	lockdep_assert_held(&q->sysfs_lock);
+
+	/* If a new range set is specified, unregister the old one */
+	if (new_iars) {
+		if (q->iaranges)
+			disk_unregister_iaranges(disk);
+		q->iaranges = new_iars;
+	}
+
+	iars = q->iaranges;
+	if (!iars)
+		return 0;
+
+	/*
+	 * At this point, iars is the new set of sector access ranges that needs
+	 * to be registered with sysfs.
+	 */
+	WARN_ON(iars->sysfs_registered);
+	ret = kobject_init_and_add(&iars->kobj, &blk_iaranges_ktype,
+				   &q->kobj, "%s", "independent_access_ranges");
+	if (ret) {
+		q->iaranges = NULL;
+		kfree(iars);
+		return ret;
+	}
+
+	for (i = 0; i < iars->nr_iaranges; i++) {
+		iars->iarange[i].queue = q;
+		ret = kobject_init_and_add(&iars->iarange[i].kobj,
+					   &blk_iarange_ktype, &iars->kobj,
+					   "%d", i);
+		if (ret) {
+			while (--i >= 0)
+				kobject_del(&iars->iarange[i].kobj);
+			kobject_del(&iars->kobj);
+			kobject_put(&iars->kobj);
+			return ret;
+		}
+	}
+
+	iars->sysfs_registered = true;
+
+	return 0;
+}
+
+void disk_unregister_iaranges(struct gendisk *disk)
+{
+	struct request_queue *q = disk->queue;
+	struct blk_independent_access_ranges *iars = q->iaranges;
+	int i;
+
+	lockdep_assert_held(&q->sysfs_dir_lock);
+	lockdep_assert_held(&q->sysfs_lock);
+
+	if (!iars)
+		return;
+
+	if (iars->sysfs_registered) {
+		for (i = 0; i < iars->nr_iaranges; i++)
+			kobject_del(&iars->iarange[i].kobj);
+		kobject_del(&iars->kobj);
+		kobject_put(&iars->kobj);
+	} else {
+		kfree(iars);
+	}
+
+	q->iaranges = NULL;
+}
+
+static struct blk_independent_access_range *
+disk_find_iarange(struct blk_independent_access_ranges *iars,
+		  sector_t sector)
+{
+	struct blk_independent_access_range *iar;
+	int i;
+
+	for (i = 0; i < iars->nr_iaranges; i++) {
+		iar = &iars->iarange[i];
+		if (sector >= iar->sector &&
+		    sector < iar->sector + iar->nr_sectors)
+			return iar;
+	}
+
+	return NULL;
+}
+
+static bool disk_check_iaranges(struct gendisk *disk,
+				struct blk_independent_access_ranges *iars)
+{
+	struct blk_independent_access_range *iar, *tmp;
+	sector_t capacity = get_capacity(disk);
+	sector_t sector = 0;
+	int i;
+
+	/*
+	 * While sorting the ranges in increasing LBA order, check that the
+	 * ranges do not overlap, that there are no sector holes and that all
+	 * sectors belong to one range.
+	 */
+	for (i = 0; i < iars->nr_iaranges; i++) {
+		tmp = disk_find_iarange(iars, sector);
+		if (!tmp || tmp->sector != sector) {
+			pr_warn("Invalid non-contiguous independent access ranges\n");
+			return false;
+		}
+
+		iar = &iars->iarange[i];
+		if (tmp != iar) {
+			swap(iar->sector, tmp->sector);
+			swap(iar->nr_sectors, tmp->nr_sectors);
+		}
+
+		sector += iar->nr_sectors;
+	}
+
+	if (sector != capacity) {
+		pr_warn("Independent access ranges do not match disk capacity\n");
+		return false;
+	}
+
+	return true;
+}
+
+static bool disk_iaranges_changed(struct gendisk *disk,
+				  struct blk_independent_access_ranges *new)
+{
+	struct blk_independent_access_ranges *old = disk->queue->iaranges;
+	int i;
+
+	if (!old)
+		return true;
+
+	if (old->nr_iaranges != new->nr_iaranges)
+		return true;
+
+	for (i = 0; i < old->nr_iaranges; i++) {
+		if (new->iarange[i].sector != old->iarange[i].sector ||
+		    new->iarange[i].nr_sectors != old->iarange[i].nr_sectors)
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * disk_alloc_iaranges - Allocate an independent access range structure
+ * @disk:		target disk
+ * @nr_iaranges:	Number of independent access ranges
+ *
+ * Allocate a struct blk_independent_access_ranges structure with @nr_iaranges
+ * access range descriptors.
+ */
+struct blk_independent_access_ranges *disk_alloc_iaranges(struct gendisk *disk,
+							  int nr_iaranges)
+{
+	struct blk_independent_access_ranges *iars;
+
+	iars = kzalloc_node(struct_size(iars, iarange, nr_iaranges),
+			    GFP_KERNEL, disk->queue->node);
+	if (iars)
+		iars->nr_iaranges = nr_iaranges;
+	return iars;
+}
+EXPORT_SYMBOL_GPL(disk_alloc_iaranges);
+
+/**
+ * disk_set_iaranges - Set a disk independent access ranges
+ * @disk:	target disk
+ * @iars:	independent access ranges structure
+ *
+ * Set the independent access ranges information of the request queue
+ * of @disk to @iars. If @iars is NULL and the independent access ranges
+ * structure already set is cleared. If there are no differences between
+ * @iars and the independent access ranges structure already set, @iars
+ * is freed.
+ */
+void disk_set_iaranges(struct gendisk *disk,
+		       struct blk_independent_access_ranges *iars)
+{
+	struct request_queue *q = disk->queue;
+
+	if (WARN_ON_ONCE(iars && !iars->nr_iaranges)) {
+		kfree(iars);
+		iars = NULL;
+	}
+
+	mutex_lock(&q->sysfs_dir_lock);
+	mutex_lock(&q->sysfs_lock);
+
+	if (iars) {
+		if (!disk_check_iaranges(disk, iars)) {
+			kfree(iars);
+			iars = NULL;
+			goto reg;
+		}
+
+		if (!disk_iaranges_changed(disk, iars)) {
+			kfree(iars);
+			goto unlock;
+		}
+	}
+
+	/*
+	 * This may be called for a registered queue. E.g. during a device
+	 * revalidation. If that is the case, we need to unregister the old
+	 * set of independent access ranges and register the new set. If the
+	 * queue is not registered, registration of the device request queue
+	 * will register the independent access ranges, so only swap in the
+	 * new set and free the old one.
+	 */
+reg:
+	if (blk_queue_registered(q)) {
+		disk_register_iaranges(disk, iars);
+	} else {
+		swap(q->iaranges, iars);
+		kfree(iars);
+	}
+
+unlock:
+	mutex_unlock(&q->sysfs_lock);
+	mutex_unlock(&q->sysfs_dir_lock);
+}
+EXPORT_SYMBOL_GPL(disk_set_iaranges);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 614d9d47de36..874b34060efa 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -887,16 +887,15 @@ int blk_register_queue(struct gendisk *disk)
 	}
 
 	mutex_lock(&q->sysfs_lock);
+
+	ret = disk_register_iaranges(disk, NULL);
+	if (ret)
+		goto put_dev;
+
 	if (q->elevator) {
 		ret = elv_register_queue(q, false);
-		if (ret) {
-			mutex_unlock(&q->sysfs_lock);
-			mutex_unlock(&q->sysfs_dir_lock);
-			kobject_del(&q->kobj);
-			blk_trace_remove_sysfs(dev);
-			kobject_put(&dev->kobj);
-			return ret;
-		}
+		if (ret)
+			goto put_dev;
 	}
 
 	blk_queue_flag_set(QUEUE_FLAG_REGISTERED, q);
@@ -927,6 +926,16 @@ int blk_register_queue(struct gendisk *disk)
 		percpu_ref_switch_to_percpu(&q->q_usage_counter);
 	}
 
+	return ret;
+
+put_dev:
+	disk_unregister_iaranges(disk);
+	mutex_unlock(&q->sysfs_lock);
+	mutex_unlock(&q->sysfs_dir_lock);
+	kobject_del(&q->kobj);
+	blk_trace_remove_sysfs(dev);
+	kobject_put(&dev->kobj);
+
 	return ret;
 }
 
@@ -972,6 +981,7 @@ void blk_unregister_queue(struct gendisk *disk)
 	mutex_lock(&q->sysfs_lock);
 	if (q->elevator)
 		elv_unregister_queue(q);
+	disk_unregister_iaranges(disk);
 	mutex_unlock(&q->sysfs_lock);
 	mutex_unlock(&q->sysfs_dir_lock);
 
diff --git a/block/blk.h b/block/blk.h
index 8c96b0c90c48..f87dc441af9c 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -373,4 +373,8 @@ static inline void bio_clear_hipri(struct bio *bio)
 	bio->bi_opf &= ~REQ_HIPRI;
 }
 
+int disk_register_iaranges(struct gendisk *disk,
+			   struct blk_independent_access_ranges *new_iars);
+void disk_unregister_iaranges(struct gendisk *disk);
+
 #endif /* BLK_INTERNAL_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c9cb12483e12..0ef74297c841 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -377,6 +377,34 @@ static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
 
 #endif /* CONFIG_BLK_DEV_ZONED */
 
+/*
+ * Independent access ranges: struct blk_independent_access_range describes
+ * a range of contiguous sectors that can be accessed using device command
+ * execution resources that are independent from the resources used for
+ * other access ranges. This is typically found with single-LUN multi-actuator
+ * HDDs where each access range is served by a different set of heads.
+ * The set of independent ranges supported by the device is defined using
+ * struct blk_independent_access_ranges. The independent ranges must not overlap
+ * and must include all sectors within the disk capacity (no sector holes
+ * allowed).
+ * For a device with multiple ranges, requests targeting sectors in different
+ * ranges can be executed in parallel. A request can straddle an access range
+ * boundary.
+ */
+struct blk_independent_access_range {
+	struct kobject		kobj;
+	struct request_queue	*queue;
+	sector_t		sector;
+	sector_t		nr_sectors;
+};
+
+struct blk_independent_access_ranges {
+	struct kobject				kobj;
+	bool					sysfs_registered;
+	unsigned int				nr_iaranges;
+	struct blk_independent_access_range	iarange[];
+};
+
 struct request_queue {
 	struct request		*last_merge;
 	struct elevator_queue	*elevator;
@@ -569,6 +597,12 @@ struct request_queue {
 
 #define BLK_MAX_WRITE_HINTS	5
 	u64			write_hints[BLK_MAX_WRITE_HINTS];
+
+	/*
+	 * Independent sector access ranges. This is always NULL for
+	 * devices that do not have multiple independent access ranges.
+	 */
+	struct blk_independent_access_ranges *iaranges;
 };
 
 /* Keep blk_queue_flag_name[] in sync with the definitions below */
@@ -1164,6 +1198,11 @@ extern void blk_queue_required_elevator_features(struct request_queue *q,
 extern bool blk_queue_can_use_dma_map_merging(struct request_queue *q,
 					      struct device *dev);
 
+struct blk_independent_access_ranges *disk_alloc_iaranges(struct gendisk *disk,
+							  int nr_iaranges);
+void disk_set_iaranges(struct gendisk *disk,
+		       struct blk_independent_access_ranges *iars);
+
 /*
  * Number of physical segments as sent to the device.
  *
-- 
2.31.1

