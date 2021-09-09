Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A712C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 02:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32F6A6101A
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 02:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236191AbhIICg6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 22:36:58 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:42516 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbhIICg5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 22:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631154949; x=1662690949;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=43i0QSckSxHEDAvLL9GdwzJ8xOxZWauuFIMSS/Taejo=;
  b=XnVKPkvrC1Yjgymll3fEZaSfYqMfZNjGDQbIzWee8oAc5o64S+NqqVPQ
   MesXSScMv7UiuJhAGh6HdP3A1xJW8tXRpi3QAbhOgxUSJ39oFp0TLTzB9
   p3Ztj9QqhDqgXUgyeky8ZSrTmIBlXvr2zR6uGqAGseRYtTPcMmw/wLkXS
   Pzg9Cpe9FmXr+c/REG4sNExHXadY5wCw58m2voXHywG+ArZcOLN39fO60
   m4fAdnbJUaJ93JDmJtNWgH4sW9iTz8nhzcbnscn39nfrlwLl7muf9A3vr
   /YP95AZbacEZ67HW55tvdf5sK2clmJS0UFP6ALjmG/hGowdPmasV+OlMZ
   A==;
X-IronPort-AV: E=Sophos;i="5.85,279,1624291200"; 
   d="scan'208";a="180062206"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Sep 2021 10:35:49 +0800
IronPort-SDR: rXsNCYpL+jFW4hfUL6cDDfIXR9go6YaJZ2CR3YebM907cxghQT0iymt7JlwksJsROqUx0iDajJ
 5ZsQpJVEF+X4HAbHnrzbxr6W5oizHRiKorkDYNKDeKdm4SVtYjL9LdVofWvB5me3Kf2INwA7gr
 TgLkUtx84Js8hdOE7htcBI49qwuEn3kA9oImCoABiU7KbytrLhKc0kzmztU0ToCF7ZWgsUewTO
 z6758535n3nm+dIgEUJCNsyde6F/WcoVfPQzANzkLUEpM7jceodISQv1i/7TOLV6f7W5HXOjRa
 fUKQVW4ebucTLqfFxEX9PBcH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 19:12:23 -0700
IronPort-SDR: 70AfsP/q25Z69FOLalEkWnZEgO2jwmGO8T5kw9iKEN7HD+leem0wx8EqcMMB8cSZooQ94XQfSx
 VaiblP1LBXRPZjXCbDqtZKkDjzbstMPnv1AgfSq3FG2fLoD48FvbZVC5LbHm2cLEnr278NVChz
 ZGnOwwGX0HHKaExb9VSe0jgQFp+GTTGrmAh/18+LUiRrGGPf8Le5F6al6nZRzZRMsttCXebbXh
 rvdKwnF/b3YjYTyDWR5x0Kj1ZkXXPgW3Wrub2nwObe7Pw3oD0miwtUBOJDo+sYTDGtu48Vvg/A
 UQQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Sep 2021 19:35:47 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v8 1/5] block: Add independent access ranges support
Date:   Thu,  9 Sep 2021 11:35:41 +0900
Message-Id: <20210909023545.1101672-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210909023545.1101672-1-damien.lemoal@wdc.com>
References: <20210909023545.1101672-1-damien.lemoal@wdc.com>
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

The function disk_set_independent_access_ranges() allows a device
driver to signal to the block layer that a device has multiple
independent access ranges.  In this case, a struct
blk_independent_access_ranges is attached to the device request queue
by the function disk_set_independent_access_ranges(). The function
disk_alloc_independent_access_ranges() is provided for drivers to
allocate this structure.

struct blk_independent_access_ranges contains kobjects (struct kobject)
to expose to the user through sysfs the set of independent access ranges
supported by a device. When the device is initialized, sysfs
registration of the ranges information is done from blk_register_queue()
using the block layer internal function
disk_register_independent_access_ranges(). If a driver calls
disk_set_independent_access_ranges() for a registered queue, e.g. when a
device is revalidated, disk_set_independent_access_ranges() will execute
disk_register_independent_access_ranges() to update the sysfs attribute
files.  The sysfs file structure created starts from the
independent_access_ranges sub-directory and contains the start sector
and number of sectors of each range, with the information for each range
grouped in numbered sub-directories.

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
added in the new file block/blk-ia-ranges.c.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/Makefile         |   2 +-
 block/blk-ia-ranges.c  | 348 +++++++++++++++++++++++++++++++++++++++++
 block/blk-sysfs.c      |  26 ++-
 block/blk.h            |   4 +
 include/linux/blkdev.h |  39 +++++
 5 files changed, 410 insertions(+), 9 deletions(-)
 create mode 100644 block/blk-ia-ranges.c

diff --git a/block/Makefile b/block/Makefile
index c03b92d8a4bc..36ccea55619f 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_BLOCK) := bdev.o fops.o bio.o elevator.o blk-core.o blk-sysfs.o \
 			blk-lib.o blk-mq.o blk-mq-tag.o blk-stat.o \
 			blk-mq-sysfs.o blk-mq-cpumap.o blk-mq-sched.o ioctl.o \
 			genhd.o ioprio.o badblocks.o partitions/ blk-rq-qos.o \
-			disk-events.o
+			disk-events.o blk-ia-ranges.o
 
 obj-$(CONFIG_BOUNCE)		+= bounce.o
 obj-$(CONFIG_BLK_SCSI_REQUEST)	+= scsi_ioctl.o
diff --git a/block/blk-ia-ranges.c b/block/blk-ia-ranges.c
new file mode 100644
index 000000000000..c246c425d0d7
--- /dev/null
+++ b/block/blk-ia-ranges.c
@@ -0,0 +1,348 @@
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
+blk_ia_range_sector_show(struct blk_independent_access_range *iar,
+			 char *buf)
+{
+	return sprintf(buf, "%llu\n", iar->sector);
+}
+
+static ssize_t
+blk_ia_range_nr_sectors_show(struct blk_independent_access_range *iar,
+			     char *buf)
+{
+	return sprintf(buf, "%llu\n", iar->nr_sectors);
+}
+
+struct blk_ia_range_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct blk_independent_access_range *iar, char *buf);
+};
+
+static struct blk_ia_range_sysfs_entry blk_ia_range_sector_entry = {
+	.attr = { .name = "sector", .mode = 0444 },
+	.show = blk_ia_range_sector_show,
+};
+
+static struct blk_ia_range_sysfs_entry blk_ia_range_nr_sectors_entry = {
+	.attr = { .name = "nr_sectors", .mode = 0444 },
+	.show = blk_ia_range_nr_sectors_show,
+};
+
+static struct attribute *blk_ia_range_attrs[] = {
+	&blk_ia_range_sector_entry.attr,
+	&blk_ia_range_nr_sectors_entry.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(blk_ia_range);
+
+static ssize_t blk_ia_range_sysfs_show(struct kobject *kobj,
+				      struct attribute *attr, char *buf)
+{
+	struct blk_ia_range_sysfs_entry *entry =
+		container_of(attr, struct blk_ia_range_sysfs_entry, attr);
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
+static const struct sysfs_ops blk_ia_range_sysfs_ops = {
+	.show	= blk_ia_range_sysfs_show,
+};
+
+/*
+ * Independent access range entries are not freed individually, but alltogether
+ * with struct blk_independent_access_ranges and its array of ranges. Since
+ * kobject_add() takes a reference on the parent kobject contained in
+ * struct blk_independent_access_ranges, the array of independent access range
+ * entries cannot be freed until kobject_del() is called for all entries.
+ * So we do not need to do anything here, but still need this no-op release
+ * operation to avoid complaints from the kobject code.
+ */
+static void blk_ia_range_sysfs_nop_release(struct kobject *kobj)
+{
+}
+
+static struct kobj_type blk_ia_range_ktype = {
+	.sysfs_ops	= &blk_ia_range_sysfs_ops,
+	.default_groups	= blk_ia_range_groups,
+	.release	= blk_ia_range_sysfs_nop_release,
+};
+
+/*
+ * This will be executed only after all independent access range entries are
+ * removed with kobject_del(), at which point, it is safe to free everything,
+ * including the array of ranges.
+ */
+static void blk_ia_ranges_sysfs_release(struct kobject *kobj)
+{
+	struct blk_independent_access_ranges *iars =
+		container_of(kobj, struct blk_independent_access_ranges, kobj);
+
+	kfree(iars);
+}
+
+static struct kobj_type blk_ia_ranges_ktype = {
+	.release	= blk_ia_ranges_sysfs_release,
+};
+
+/**
+ * disk_register_ia_ranges - register with sysfs a set of independent
+ *			    access ranges
+ * @disk:	Target disk
+ * @new_iars:	New set of independent access ranges
+ *
+ * Register with sysfs a set of independent access ranges for @disk.
+ * If @new_iars is not NULL, this set of ranges is registered and the old set
+ * specified by q->ia_ranges is unregistered. Otherwise, q->ia_ranges is
+ * registered if it is not already.
+ */
+int disk_register_independent_access_ranges(struct gendisk *disk,
+				struct blk_independent_access_ranges *new_iars)
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
+		if (q->ia_ranges)
+			disk_unregister_independent_access_ranges(disk);
+		q->ia_ranges = new_iars;
+	}
+
+	iars = q->ia_ranges;
+	if (!iars)
+		return 0;
+
+	/*
+	 * At this point, iars is the new set of sector access ranges that needs
+	 * to be registered with sysfs.
+	 */
+	WARN_ON(iars->sysfs_registered);
+	ret = kobject_init_and_add(&iars->kobj, &blk_ia_ranges_ktype,
+				   &q->kobj, "%s", "independent_access_ranges");
+	if (ret) {
+		q->ia_ranges = NULL;
+		kfree(iars);
+		return ret;
+	}
+
+	for (i = 0; i < iars->nr_ia_ranges; i++) {
+		iars->ia_range[i].queue = q;
+		ret = kobject_init_and_add(&iars->ia_range[i].kobj,
+					   &blk_ia_range_ktype, &iars->kobj,
+					   "%d", i);
+		if (ret) {
+			while (--i >= 0)
+				kobject_del(&iars->ia_range[i].kobj);
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
+void disk_unregister_independent_access_ranges(struct gendisk *disk)
+{
+	struct request_queue *q = disk->queue;
+	struct blk_independent_access_ranges *iars = q->ia_ranges;
+	int i;
+
+	lockdep_assert_held(&q->sysfs_dir_lock);
+	lockdep_assert_held(&q->sysfs_lock);
+
+	if (!iars)
+		return;
+
+	if (iars->sysfs_registered) {
+		for (i = 0; i < iars->nr_ia_ranges; i++)
+			kobject_del(&iars->ia_range[i].kobj);
+		kobject_del(&iars->kobj);
+		kobject_put(&iars->kobj);
+	} else {
+		kfree(iars);
+	}
+
+	q->ia_ranges = NULL;
+}
+
+static struct blk_independent_access_range *
+disk_find_ia_range(struct blk_independent_access_ranges *iars,
+		  sector_t sector)
+{
+	struct blk_independent_access_range *iar;
+	int i;
+
+	for (i = 0; i < iars->nr_ia_ranges; i++) {
+		iar = &iars->ia_range[i];
+		if (sector >= iar->sector &&
+		    sector < iar->sector + iar->nr_sectors)
+			return iar;
+	}
+
+	return NULL;
+}
+
+static bool disk_check_ia_ranges(struct gendisk *disk,
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
+	for (i = 0; i < iars->nr_ia_ranges; i++) {
+		tmp = disk_find_ia_range(iars, sector);
+		if (!tmp || tmp->sector != sector) {
+			pr_warn("Invalid non-contiguous independent access ranges\n");
+			return false;
+		}
+
+		iar = &iars->ia_range[i];
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
+static bool disk_ia_ranges_changed(struct gendisk *disk,
+				   struct blk_independent_access_ranges *new)
+{
+	struct blk_independent_access_ranges *old = disk->queue->ia_ranges;
+	int i;
+
+	if (!old)
+		return true;
+
+	if (old->nr_ia_ranges != new->nr_ia_ranges)
+		return true;
+
+	for (i = 0; i < old->nr_ia_ranges; i++) {
+		if (new->ia_range[i].sector != old->ia_range[i].sector ||
+		    new->ia_range[i].nr_sectors != old->ia_range[i].nr_sectors)
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * disk_alloc_independent_access_ranges - Allocate an independent access ranges
+ *                                        data structure
+ * @disk:		target disk
+ * @nr_ia_ranges:	Number of independent access ranges
+ *
+ * Allocate a struct blk_independent_access_ranges structure with @nr_ia_ranges
+ * access range descriptors.
+ */
+struct blk_independent_access_ranges *
+disk_alloc_independent_access_ranges(struct gendisk *disk, int nr_ia_ranges)
+{
+	struct blk_independent_access_ranges *iars;
+
+	iars = kzalloc_node(struct_size(iars, ia_range, nr_ia_ranges),
+			    GFP_KERNEL, disk->queue->node);
+	if (iars)
+		iars->nr_ia_ranges = nr_ia_ranges;
+	return iars;
+}
+EXPORT_SYMBOL_GPL(disk_alloc_independent_access_ranges);
+
+/**
+ * disk_set_independent_access_ranges - Set a disk independent access ranges
+ * @disk:	target disk
+ * @iars:	independent access ranges structure
+ *
+ * Set the independent access ranges information of the request queue
+ * of @disk to @iars. If @iars is NULL and the independent access ranges
+ * structure already set is cleared. If there are no differences between
+ * @iars and the independent access ranges structure already set, @iars
+ * is freed.
+ */
+void disk_set_independent_access_ranges(struct gendisk *disk,
+				struct blk_independent_access_ranges *iars)
+{
+	struct request_queue *q = disk->queue;
+
+	if (WARN_ON_ONCE(iars && !iars->nr_ia_ranges)) {
+		kfree(iars);
+		iars = NULL;
+	}
+
+	mutex_lock(&q->sysfs_dir_lock);
+	mutex_lock(&q->sysfs_lock);
+
+	if (iars) {
+		if (!disk_check_ia_ranges(disk, iars)) {
+			kfree(iars);
+			iars = NULL;
+			goto reg;
+		}
+
+		if (!disk_ia_ranges_changed(disk, iars)) {
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
+		disk_register_independent_access_ranges(disk, iars);
+	} else {
+		swap(q->ia_ranges, iars);
+		kfree(iars);
+	}
+
+unlock:
+	mutex_unlock(&q->sysfs_lock);
+	mutex_unlock(&q->sysfs_dir_lock);
+}
+EXPORT_SYMBOL_GPL(disk_set_independent_access_ranges);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 614d9d47de36..1f932cd6c037 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -887,16 +887,15 @@ int blk_register_queue(struct gendisk *disk)
 	}
 
 	mutex_lock(&q->sysfs_lock);
+
+	ret = disk_register_independent_access_ranges(disk, NULL);
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
+	disk_unregister_independent_access_ranges(disk);
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
+	disk_unregister_independent_access_ranges(disk);
 	mutex_unlock(&q->sysfs_lock);
 	mutex_unlock(&q->sysfs_dir_lock);
 
diff --git a/block/blk.h b/block/blk.h
index 7d2a0ba7ed21..fa19ab9cd6b7 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -375,4 +375,8 @@ static inline void bio_clear_hipri(struct bio *bio)
 
 extern const struct address_space_operations def_blk_aops;
 
+int disk_register_independent_access_ranges(struct gendisk *disk,
+				struct blk_independent_access_ranges *new_iars);
+void disk_unregister_independent_access_ranges(struct gendisk *disk);
+
 #endif /* BLK_INTERNAL_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c9cb12483e12..2c754f01a7ae 100644
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
+	unsigned int				nr_ia_ranges;
+	struct blk_independent_access_range	ia_range[];
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
+	struct blk_independent_access_ranges *ia_ranges;
 };
 
 /* Keep blk_queue_flag_name[] in sync with the definitions below */
@@ -1164,6 +1198,11 @@ extern void blk_queue_required_elevator_features(struct request_queue *q,
 extern bool blk_queue_can_use_dma_map_merging(struct request_queue *q,
 					      struct device *dev);
 
+struct blk_independent_access_ranges *
+disk_alloc_independent_access_ranges(struct gendisk *disk, int nr_ia_ranges);
+void disk_set_independent_access_ranges(struct gendisk *disk,
+				struct blk_independent_access_ranges *iars);
+
 /*
  * Number of physical segments as sent to the device.
  *
-- 
2.31.1

