Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F5CC07E9B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 088BA61242
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239197AbhGUKEE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 06:04:04 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:53609 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238997AbhGUKBn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 06:01:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626864137; x=1658400137;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=CU+e4sS6gth+Cfnm1xAN4p/coEJ7DQfiO8rP00tgzFw=;
  b=Nodx+hPrW0anGBLeNsRwLwonVTQ2j5YhhQ7gx71cLyJ8DedMLX4JoZmJ
   zow3WaBJl5zN7sj56MSYBIutMVJNn1/Oq0Ipijg7szolZQWi8gisNC7MR
   OxxA30o3ANSoVBu4Ns0FOqK0/vNXCDp5IEE0RBwYqiFpQsG+xhkbWIx0o
   LigjbbrcG2ZXdw0DNMLAH0/F5U97sdYcMviwqoJS8EOBrkrg6gb2NIh0R
   ckXyAoGkqJPVENT1DK4OiyPjGgHaUlwyj2LDhFsU6PeJ7kwtHlABBDup0
   NKdVAzrDJDQB4vNS1AkobXgmSAFoU0BnnZ7dt/ibzWsK/hPMYot+WWBN5
   w==;
X-IronPort-AV: E=Sophos;i="5.84,257,1620662400"; 
   d="scan'208";a="179944861"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2021 18:42:09 +0800
IronPort-SDR: GJbu9cF8ULx+kYp+WqiRUjFAu+q+4hFYeUHELK4WeN+QwmE2QkcXVPlKl8vbdhtuXtqCkjuGXw
 /xbSBA2DgiXa5r7jyqR/6+5RznPFP/3o6STNiELoEE3d47+ZnRUZakfs0vYfaGcgQyzhPVJbtj
 PWSHndEsA3ktOZjJwOLbg8ch6DthJxx3cHWuiQk0oaaes37nqghWmKLSGNzy+/dTkz/Pl8ySlj
 6BQdbQjr0zrRZaHp7qCGWL0MgSTCQKYCD3GWkju9E7WW/IQIKMmh+m117UlLAe1E+dGf1L2zdC
 qqWnF8stkGA53cLDQBn0LHu6
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 03:20:03 -0700
IronPort-SDR: UVCKnDUWFypa5SMMMeOK0jJ1RUiH8b5CxsoFhdhkLKW/dWxcatZRTwmxzmROZB2D7wYmxiyfxP
 YexGrr3kELoOFGr/AWlSjTvNTBblhKxAcDnjsmhGerqRDnhPMEFBuY/t38b66lU+c8KVK8Gmf2
 iQY2OKBI320rpT+oVQD+2FYD08yRcsJmTaIcdQhhUhRG0Y8Hy317H0HF/eU3aDvKqM1FjpybBt
 jF5SBeCeicUmfW7HOjgBZsffGCXaLDjA3KrdBucAB3Bh7Kbg/HKwiejql7RBsGgi0q6I2cjzag
 2uY=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Jul 2021 03:42:09 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
Subject: [PATCH 1/4] block: Add concurrent positioning ranges support
Date:   Wed, 21 Jul 2021 19:42:02 +0900
Message-Id: <20210721104205.885115-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210721104205.885115-1-damien.lemoal@wdc.com>
References: <20210721104205.885115-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The Concurrent Positioning Ranges VPD page (for SCSI) and Log (for ATA)
contain parameters describing the number of sets of contiguous LBAs that
can be served independently by a single LUN multi-actuator disk. This
patch provides the blk_queue_set_cranges() function allowing a device
driver to signal to the block layer that a disk has multiple actuators,
each one serving a contiguous range of sectors. To describe the set
of sector ranges representing the different actuators of a device, the
data type struct blk_cranges is introduced.

For a device with multiple actuators, a struct blk_cranges is attached
to the device request queue by the blk_queue_set_cranges() function. The
function blk_alloc_cranges() is provided for drivers to allocate this
structure.

The blk_cranges structure contains kobjects (struct kobject) to register
with sysfs the set of sector ranges defined by a device. On initial
device scan, this registration is done from blk_register_queue() using
the block layer internal function blk_register_cranges(). If a driver
calls blk_queue_set_cranges() for a registered queue, e.g. when a device
is revalidated, blk_queue_set_cranges() will execute
blk_register_cranges() to update the queue sysfs attribute files.

The sysfs file structure created starts from the cranges sub-directory
and contains the start sector and number of sectors served by an
actuator, with the information for each actuator grouped in one
directory per actuator. E.g. for a dual actuator drive, we have:

$ tree /sys/block/sdk/queue/cranges/
/sys/block/sdk/queue/cranges/
|-- 0
|   |-- nr_sectors
|   `-- sector
`-- 1
    |-- nr_sectors
    `-- sector

For a regular single actuator device, the cranges directory does not
exist.

Device revalidation may lead to changes to this structure and to the
attribute values. When manipulated, the queue sysfs_lock and
sysfs_dir_lock are held for atomicity, similarly to how the blk-mq and
elevator sysfs queue sub-directories are protected.

The code related to the management of cranges is added in the new
file block/blk-cranges.c.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/Makefile            |   2 +-
 block/blk-cranges.c       | 286 ++++++++++++++++++++++++++++++++++++++
 block/blk-sysfs.c         |  13 ++
 block/blk.h               |   3 +
 drivers/ata/libata-scsi.c |   1 +
 include/linux/blkdev.h    |  29 ++++
 6 files changed, 333 insertions(+), 1 deletion(-)
 create mode 100644 block/blk-cranges.c

diff --git a/block/Makefile b/block/Makefile
index bfbe4e13ca1e..e477e6ca9ea6 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_BLOCK) := bio.o elevator.o blk-core.o blk-sysfs.o \
 			blk-lib.o blk-mq.o blk-mq-tag.o blk-stat.o \
 			blk-mq-sysfs.o blk-mq-cpumap.o blk-mq-sched.o ioctl.o \
 			genhd.o ioprio.o badblocks.o partitions/ blk-rq-qos.o \
-			disk-events.o
+			disk-events.o blk-cranges.o
 
 obj-$(CONFIG_BOUNCE)		+= bounce.o
 obj-$(CONFIG_BLK_SCSI_REQUEST)	+= scsi_ioctl.o
diff --git a/block/blk-cranges.c b/block/blk-cranges.c
new file mode 100644
index 000000000000..e8ff0d40a5c9
--- /dev/null
+++ b/block/blk-cranges.c
@@ -0,0 +1,286 @@
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
+static ssize_t blk_crange_sector_show(struct blk_crange *cr, char *page)
+{
+	return sprintf(page, "%llu\n", cr->sector);
+}
+
+static ssize_t blk_crange_nr_sectors_show(struct blk_crange *cr, char *page)
+{
+	return sprintf(page, "%llu\n", cr->nr_sectors);
+}
+
+struct blk_crange_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct blk_crange *cr, char *page);
+};
+
+static struct blk_crange_sysfs_entry blk_crange_sector_entry = {
+	.attr = { .name = "sector", .mode = 0444 },
+	.show = blk_crange_sector_show,
+};
+
+static struct blk_crange_sysfs_entry blk_crange_nr_sectors_entry = {
+	.attr = { .name = "nr_sectors", .mode = 0444 },
+	.show = blk_crange_nr_sectors_show,
+};
+
+static struct attribute *blk_crange_attrs[] = {
+	&blk_crange_sector_entry.attr,
+	&blk_crange_nr_sectors_entry.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(blk_crange);
+
+static ssize_t blk_crange_sysfs_show(struct kobject *kobj,
+				     struct attribute *attr, char *page)
+{
+	struct blk_crange_sysfs_entry *entry;
+	struct blk_crange *cr;
+	struct request_queue *q;
+	ssize_t ret;
+
+	entry = container_of(attr, struct blk_crange_sysfs_entry, attr);
+	cr = container_of(kobj, struct blk_crange, kobj);
+	q = cr->queue;
+
+	mutex_lock(&q->sysfs_lock);
+	ret = entry->show(cr, page);
+	mutex_unlock(&q->sysfs_lock);
+
+	return ret;
+}
+
+static const struct sysfs_ops blk_crange_sysfs_ops = {
+	.show	= blk_crange_sysfs_show,
+};
+
+/*
+ * Dummy release function to make kobj happy.
+ */
+static void blk_cranges_sysfs_nop_release(struct kobject *kobj)
+{
+}
+
+static struct kobj_type blk_crange_ktype = {
+	.sysfs_ops	= &blk_crange_sysfs_ops,
+	.default_groups	= blk_crange_groups,
+	.release	= blk_cranges_sysfs_nop_release,
+};
+
+static struct kobj_type blk_cranges_ktype = {
+	.release	= blk_cranges_sysfs_nop_release,
+};
+
+/**
+ * blk_register_cranges - register with sysfs a set of concurrent ranges
+ * @disk:		Target disk
+ * @new_cranges:	New set of concurrent ranges
+ *
+ * Register with sysfs a set of concurrent ranges for @disk. If @new_cranges
+ * is not NULL, this set of concurrent ranges is registered and the
+ * old set specified by q->cranges is unregistered. Otherwise, q->cranges
+ * is registered if it is not already.
+ */
+int blk_register_cranges(struct gendisk *disk, struct blk_cranges *new_cranges)
+{
+	struct request_queue *q = disk->queue;
+	struct blk_cranges *cranges;
+	int i, ret;
+
+	lockdep_assert_held(&q->sysfs_dir_lock);
+	lockdep_assert_held(&q->sysfs_lock);
+
+	/* If a new range set is specified, unregister the old one */
+	if (new_cranges) {
+		if (q->cranges)
+			blk_unregister_cranges(disk);
+		q->cranges = new_cranges;
+	}
+
+	cranges = q->cranges;
+	if (!cranges)
+		return 0;
+
+	/*
+	 * At this point, q->cranges is the new set of sector ranges that needs
+	 * to be registered with sysfs.
+	 */
+	WARN_ON(cranges->sysfs_registered);
+	ret = kobject_init_and_add(&cranges->kobj, &blk_cranges_ktype,
+				   &q->kobj, "%s", "cranges");
+	if (ret)
+		goto free;
+
+	for (i = 0; i < cranges->nr_ranges; i++) {
+		cranges->ranges[i].queue = q;
+		ret = kobject_init_and_add(&cranges->ranges[i].kobj,
+					   &blk_crange_ktype, &cranges->kobj,
+					   "%d", i);
+		if (ret)
+			goto delete_obj;
+	}
+
+	cranges->sysfs_registered = true;
+
+	return 0;
+
+delete_obj:
+	while (--i >= 0)
+		kobject_del(&cranges->ranges[i].kobj);
+	kobject_del(&cranges->kobj);
+free:
+	kfree(cranges);
+	q->cranges = NULL;
+	return ret;
+}
+
+void blk_unregister_cranges(struct gendisk *disk)
+{
+	struct request_queue *q = disk->queue;
+	struct blk_cranges *cranges = q->cranges;
+	int i;
+
+	lockdep_assert_held(&q->sysfs_dir_lock);
+	lockdep_assert_held(&q->sysfs_lock);
+
+	if (!cranges)
+		return;
+
+	if (cranges->sysfs_registered) {
+		for (i = 0; i < cranges->nr_ranges; i++)
+			kobject_del(&cranges->ranges[i].kobj);
+		kobject_del(&cranges->kobj);
+	}
+
+	kfree(cranges);
+	q->cranges = NULL;
+}
+
+static bool blk_check_ranges(struct gendisk *disk, struct blk_cranges *cr)
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
+	for (i = 0; i < cr->nr_ranges; i++) {
+		min_sector = min(min_sector, cr->ranges[i].sector);
+		max_sector = max(max_sector, cr->ranges[i].sector +
+					     cr->ranges[i].nr_sectors);
+	}
+
+	if (min_sector != 0 || max_sector < capacity) {
+		pr_warn("Invalid concurrent ranges: missing sectors\n");
+		return false;
+	}
+
+	if (max_sector > capacity) {
+		pr_warn("Invalid concurrent ranges: beyond capacity\n");
+		return false;
+	}
+
+	return true;
+}
+
+static bool blk_cranges_changed(struct gendisk *disk, struct blk_cranges *new)
+{
+	struct blk_cranges *old = disk->queue->cranges;
+	int i;
+
+	if (!old || old->nr_ranges != new->nr_ranges)
+		return true;
+
+	for (i = 0; i < new->nr_ranges; i++) {
+		if (old->ranges[i].sector != new->ranges[i].sector ||
+		    old->ranges[i].nr_sectors != new->ranges[i].nr_sectors)
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * blk_alloc_cranges - Allocate a concurrent positioning range structure
+ * @disk:	target disk
+ * @nr_ranges:	Number of concurrent ranges
+ *
+ * Allocate a struct blk_cranges structure with @nr_ranges range descriptors.
+ */
+struct blk_cranges *blk_alloc_cranges(struct gendisk *disk, int nr_ranges)
+{
+	struct blk_cranges *cr;
+
+	cr = kzalloc_node(struct_size(cr, ranges, nr_ranges), GFP_KERNEL,
+			  disk->queue->node);
+	if (cr)
+		cr->nr_ranges = nr_ranges;
+	return cr;
+}
+EXPORT_SYMBOL_GPL(blk_alloc_cranges);
+
+/**
+ * blk_queue_set_cranges - Set a disk concurrent positioning ranges
+ * @disk:	target disk
+ * @cr:		concurrent ranges structure
+ *
+ * Set the concurrant positioning ranges information of the request queue
+ * of @disk to @cr. If @cr is NULL and the concurrent ranges structure
+ * already set, if any, is cleared. If there are no differences between
+ * @cr and the concurrent ranges structure already set, @cr is freed.
+ */
+void blk_queue_set_cranges(struct gendisk *disk, struct blk_cranges *cr)
+{
+	struct request_queue *q = disk->queue;
+
+	if (WARN_ON_ONCE(cr && !cr->nr_ranges)) {
+		kfree(cr);
+		cr = NULL;
+	}
+
+	mutex_lock(&q->sysfs_dir_lock);
+	mutex_lock(&q->sysfs_lock);
+
+	if (cr && !blk_check_ranges(disk, cr)) {
+		kfree(cr);
+		cr = NULL;
+	}
+
+	if (!blk_cranges_changed(disk, cr)) {
+		kfree(cr);
+		goto unlock;
+	}
+
+	/*
+	 * This may be called for a registered queue. E.g. during a device
+	 * revalidation. If that is the case, we need to register the new set
+	 * of concurrent ranges. If the queue is not already registered, the
+	 * device request queue registration will register the ranges.
+	 */
+	if (blk_queue_registered(q)) {
+		blk_register_cranges(disk, cr);
+	} else {
+		swap(q->cranges, cr);
+		kfree(cr);
+	}
+
+unlock:
+	mutex_unlock(&q->sysfs_lock);
+	mutex_unlock(&q->sysfs_dir_lock);
+}
+EXPORT_SYMBOL_GPL(blk_queue_set_cranges);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 370d83c18057..aeac98ecc5a0 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -899,9 +899,21 @@ int blk_register_queue(struct gendisk *disk)
 	}
 
 	mutex_lock(&q->sysfs_lock);
+
+	ret = blk_register_cranges(disk, NULL);
+	if (ret) {
+		mutex_unlock(&q->sysfs_lock);
+		mutex_unlock(&q->sysfs_dir_lock);
+		kobject_del(&q->kobj);
+		blk_trace_remove_sysfs(dev);
+		kobject_put(&dev->kobj);
+		return ret;
+	}
+
 	if (q->elevator) {
 		ret = elv_register_queue(q, false);
 		if (ret) {
+			blk_unregister_cranges(disk);
 			mutex_unlock(&q->sysfs_lock);
 			mutex_unlock(&q->sysfs_dir_lock);
 			kobject_del(&q->kobj);
@@ -985,6 +997,7 @@ void blk_unregister_queue(struct gendisk *disk)
 	mutex_lock(&q->sysfs_lock);
 	if (q->elevator)
 		elv_unregister_queue(q);
+	blk_unregister_cranges(disk);
 	mutex_unlock(&q->sysfs_lock);
 	mutex_unlock(&q->sysfs_dir_lock);
 
diff --git a/block/blk.h b/block/blk.h
index 4b885c0f6708..650c0d87987c 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -368,4 +368,7 @@ extern struct device_attribute dev_attr_events;
 extern struct device_attribute dev_attr_events_async;
 extern struct device_attribute dev_attr_events_poll_msecs;
 
+int blk_register_cranges(struct gendisk *disk, struct blk_cranges *new_cranges);
+void blk_unregister_cranges(struct gendisk *disk);
+
 #endif /* BLK_INTERNAL_H */
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9588c52815d..144e8cac44ba 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1947,6 +1947,7 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 		0xb1,	/* page 0xb1, block device characteristics page */
 		0xb2,	/* page 0xb2, thin provisioning page */
 		0xb6,	/* page 0xb6, zoned block device characteristics */
+		0xb9,	/* page 0xb9, concurrent positioning ranges */
 	};
 
 	num_pages = sizeof(pages);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3177181c4326..cd58aa1090a3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -378,6 +378,29 @@ static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
 
 #endif /* CONFIG_BLK_DEV_ZONED */
 
+/*
+ * Concurrent sector ranges: struct blk_crange describes range of
+ * contiguous sectors that can be served by independent resources on the
+ * device. The set of ranges defined in struct blk_cranges must overall
+ * include all sectors within the device capacity.
+ * For a device with multiple ranges, e.g. a single LUN multi-actuator HDD,
+ * requests targeting sectors in different ranges can be executed in parallel.
+ * A request can straddle a range boundary.
+ */
+struct blk_crange {
+	struct kobject		kobj;
+	struct request_queue	*queue;
+	sector_t		sector;
+	sector_t		nr_sectors;
+};
+
+struct blk_cranges {
+	struct kobject		kobj;
+	bool			sysfs_registered;
+	unsigned int		nr_ranges;
+	struct blk_crange	ranges[];
+};
+
 struct request_queue {
 	struct request		*last_merge;
 	struct elevator_queue	*elevator;
@@ -570,6 +593,9 @@ struct request_queue {
 
 #define BLK_MAX_WRITE_HINTS	5
 	u64			write_hints[BLK_MAX_WRITE_HINTS];
+
+	/* Concurrent sector ranges */
+	struct blk_cranges	*cranges;
 };
 
 /* Keep blk_queue_flag_name[] in sync with the definitions below */
@@ -1163,6 +1189,9 @@ extern void blk_queue_required_elevator_features(struct request_queue *q,
 extern bool blk_queue_can_use_dma_map_merging(struct request_queue *q,
 					      struct device *dev);
 
+struct blk_cranges *blk_alloc_cranges(struct gendisk *disk, int nr_ranges);
+void blk_queue_set_cranges(struct gendisk *disk, struct blk_cranges *cr);
+
 /*
  * Number of physical segments as sent to the device.
  *
-- 
2.31.1

