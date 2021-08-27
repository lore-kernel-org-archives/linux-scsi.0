Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4009C43216
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D889160FD8
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244395AbhH0Hvn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 03:51:43 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:42478 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244526AbhH0Hvh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 03:51:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630050648; x=1661586648;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ecL1cTq5qzW9fwzQ+RZ0Ul1M8AxnpwjBwYswKenT5XA=;
  b=DRgkl3uKFCjRYX7J03qYhbWUnxRUMDvFrvdbis5TTH9wE5NW/NUmbuHW
   Eyemq+zubtMHouS+AwFnjXShqTrn6QDVFzDIGti/GpbvpGQgHaYi2kKQk
   2VX/HbDEx+3oOcehEfyvVgEIFgXcIugtCkx7S3a2nijJHtwTG9ZRbbUW8
   kz2XMFNRyDekhLuo3CezXIpAMolFXdPUlozvXIdq1681+vek9zWCySGOz
   VlT54d9Zx9fRs59rSxcUUFG42t01a7vTSgpVRZao4oR6x/UfUlEuafO/W
   2rN/WM4tlGRVea2REV6vJHr/DN498+O8aCCyg+7TFcffjIN09t6wJeeFy
   w==;
X-IronPort-AV: E=Sophos;i="5.84,356,1620662400"; 
   d="scan'208";a="183342786"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2021 15:50:47 +0800
IronPort-SDR: YKReJYtWwAjAVa+T8q6i6A6MoDCZfbzfgh92csE440M1DUR6TYzSrKF+Vzk9LRdziYOa2iqVoF
 t+rzRF+B8Gbe60BcKRYajf54dapQgpSJSQNzcDOGnwN3+HwK3mza7Q/MxxlCwSyWtm7eepqooW
 k+ei+oWcVbgfeB7JGKWqnCjtpCpXfMBbP7nbkaTvJyd0Ub6p4RtBSJnyaiEv6MxWjqlhLXagiA
 5zBV9Xtb+xVabVXhgEhBJCqoJHmyO5ykTy2pXpLWgOWIczCpqw3d9ROuWMNEzHzZTba97giMZ7
 LGb0XuFWDsdCb0mSRioMsZdG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:26:00 -0700
IronPort-SDR: lXSxZJ96A6xJB1FPbWtLqFdSt3GLZWfhQ4JFvSJ6wlN9dCvDROumc4gz97V0GJpw2IOEQhItfo
 baietFxpmZtonEllRBVSR6m7aj6mN5I5TKQkngeNyLiy09J8hI2xt+nSpmFTGgoG8NZEOs16lt
 STAQZFQqjE9gqB8IncEcY57IAsfDVCVHd3s9GXhPJ43hucYxeiMqIo1S4A4CXLrLfqv3bad88Y
 WZNhxRgSiQSc5Z7EbTh3dNSBorI8A2xg7sFiRcDusPNPjCm+iXF/smCYlGvxMZTFl+F6negakj
 0SI=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Aug 2021 00:50:47 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v6 1/5] block: Add independent access ranges support
Date:   Fri, 27 Aug 2021 16:50:40 +0900
Message-Id: <20210827075045.642269-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827075045.642269-1-damien.lemoal@wdc.com>
References: <20210827075045.642269-1-damien.lemoal@wdc.com>
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
in parallel. A dm-linear device aggregating 2 block devices togewther is
an example.

This patch implement support for exposing this information to the
user to allow optimizing device accesses to increase performance.

To describe the set of independent sector ranges of a device (actuators
of a multi-actuator HDDs or table entries of a dm-linear device),
The type struct blk_independent_access_ranges is introduced. This
structure describes each sector range using an array of
struct blk_independent_access_range structures. This range structure
defines the start sector and number of sectors of the access range.

The function disk_set_iaranges() allows a device driver to signal to
the block layer that a device has multiple independent access ranges.
struct blk_independent_access_ranges is attached to the device request
queue by the disk_set_iaranges() function. The function
disk_alloc_iaranges() is provided for drivers to allocate this
structure.

The blk_independent_access_ranges structure contains kobjects
(struct kobject) to expose to the user through sysfs the set of
independent access ranges supported by a device. When the device is
initialized, sysfs registration of the range information is done from
blk_register_queue() using the block layer internal function
disk_register_iaranges(). If a driver calls disk_set_iaranges() for a
registered queue, e.g. when a device is revalidated, disk_set_iaranges()
will execute disk_register_iaranges() to update the queue sysfs
attribute files.

The sysfs file structure created starts from the
independent_access_ranges sub-directory and contains the start sector
and number of sectors of each range, with the information for each
range grouped in sub-directories.

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
sysfs_dir_lock are held for atomicity, similarly to how the blk-mq and
elevator sysfs queue sub-directories are protected.

The code related to the management of independent access rages is
added in the new file block/blk-iaranges.c.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/Makefile         |   2 +-
 block/blk-iaranges.c   | 322 +++++++++++++++++++++++++++++++++++++++++
 block/blk-sysfs.c      |  26 +++-
 block/blk.h            |   4 +
 include/linux/blkdev.h |  34 +++++
 5 files changed, 379 insertions(+), 9 deletions(-)
 create mode 100644 block/blk-iaranges.c

diff --git a/block/Makefile b/block/Makefile
index 0d951adce796..8e45fced0bb8 100644
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
index 000000000000..bdecdf095f6a
--- /dev/null
+++ b/block/blk-iaranges.c
@@ -0,0 +1,322 @@
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
+static bool disk_check_iaranges(struct gendisk *disk,
+				struct blk_independent_access_ranges *iars)
+{
+	sector_t capacity = get_capacity(disk);
+	sector_t min_sector = (sector_t)-1;
+	sector_t max_sector = 0;
+	int i;
+
+	/*
+	 * Sector ranges may overlap but should overall contain all sectors
+	 * within the disk capacity.
+	 */
+	for (i = 0; i < iars->nr_iaranges; i++) {
+		min_sector = min(min_sector, iars->iarange[i].sector);
+		max_sector = max(max_sector, iars->iarange[i].sector +
+					     iars->iarange[i].nr_sectors);
+	}
+
+	if (min_sector != 0 || max_sector < capacity) {
+		pr_warn("Invalid independent access ranges: missing sectors\n");
+		return false;
+	}
+
+	if (max_sector > capacity) {
+		pr_warn("Invalid independent access ranges: beyond capacity\n");
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
index bbbcc1a64a2d..2aab4a936c4e 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -370,4 +370,8 @@ extern struct device_attribute dev_attr_events;
 extern struct device_attribute dev_attr_events_async;
 extern struct device_attribute dev_attr_events_poll_msecs;
 
+int disk_register_iaranges(struct gendisk *disk,
+			   struct blk_independent_access_ranges *new_iars);
+void disk_unregister_iaranges(struct gendisk *disk);
+
 #endif /* BLK_INTERNAL_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c9cb12483e12..62cebeec6699 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -377,6 +377,32 @@ static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
 
 #endif /* CONFIG_BLK_DEV_ZONED */
 
+/*
+ * Independent access ranges: struct blk_independent_access_range describes
+ * a range of contiguous sectors that can be accessed using device command
+ * execution resources that are independent form the resources used for
+ * other access ranges. This is typically found with multi-actuator HDDs where
+ * each access range is served by a different set of heads.
+ * The set of ranges defined in struct blk_independent_access_ranges must
+ * overall include all sectors within the device capacity.
+ * For a device with multiple ranges, e.g. a single LUN multi-actuator HDD,
+ * requests targeting sectors in different ranges can be executed in parallel.
+ * A request can straddle an access range boundary.
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
@@ -569,6 +595,9 @@ struct request_queue {
 
 #define BLK_MAX_WRITE_HINTS	5
 	u64			write_hints[BLK_MAX_WRITE_HINTS];
+
+	/* Independent sector ranges */
+	struct blk_independent_access_ranges *iaranges;
 };
 
 /* Keep blk_queue_flag_name[] in sync with the definitions below */
@@ -1164,6 +1193,11 @@ extern void blk_queue_required_elevator_features(struct request_queue *q,
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

