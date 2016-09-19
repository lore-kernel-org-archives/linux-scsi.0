From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: [PATCH 5/9] block: Implement support for zoned block devices
Date: Tue, 20 Sep 2016 06:27:30 +0900
Message-ID: <1474320454-5264-6-git-send-email-damien.lemoal@hgst.com>
References: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20108 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932580AbcISV2y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 17:28:54 -0400
In-Reply-To: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: martin.petersen@oracle.com, axboe@kernel.dk, hare@suse.de, shaun.tancheff@seagate.com, Damien Le Moal <damien.lemoal@hgst.com>

From: Hannes Reinecke <hare@suse.de>

Implement a RB-Tree holding a zoned block device zone information
(struct blk_zone) and add support functions for maintaining the
RB-Tree and manipulating zone structs. The block layer support does
not differentiate between host-aware and host-managed devices. The
different constraints for these different zone models are handled
by the generic SCSI layer sd driver down the stack.

Signed-off-by: Hannes Reinecke <hare@suse.de>

Changelog (Damien):
* Changed struct blk_zone to be more compact (64B)
* Changed zone locking to use bit_spin_lock in place of a regular
  spinlock
* Request zone operations to the underlying block device driver
  through BIO operations with the operation codes REQ_OP_ZONE_*.

Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
---
 block/Kconfig          |   8 ++
 block/Makefile         |   1 +
 block/blk-core.c       |   4 +
 block/blk-zoned.c      | 338 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h | 113 +++++++++++++++++
 5 files changed, 464 insertions(+)
 create mode 100644 block/blk-zoned.c

diff --git a/block/Kconfig b/block/Kconfig
index 161491d..c3a18f0 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -88,6 +88,14 @@ config BLK_DEV_INTEGRITY
 	T10/SCSI Data Integrity Field or the T13/ATA External Path
 	Protection.  If in doubt, say N.
 
+config BLK_DEV_ZONED
+	bool "Zoned block device support"
+	---help---
+	Block layer zoned block device support. This option enables
+	support for ZAC/ZBC host-managed and host-aware zoned block devices.
+
+	Say yes here if you have a ZAC or ZBC storage device.
+
 config BLK_DEV_THROTTLING
 	bool "Block layer bio throttling support"
 	depends on BLK_CGROUP=y
diff --git a/block/Makefile b/block/Makefile
index 9eda232..aee67fa 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -22,4 +22,5 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_CMDLINE_PARSER)	+= cmdline-parser.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o blk-integrity.o t10-pi.o
+obj-$(CONFIG_BLK_DEV_ZONED)	+= blk-zoned.o
 
diff --git a/block/blk-core.c b/block/blk-core.c
index 4a7f7ba..2c5d069d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -590,6 +590,8 @@ void blk_cleanup_queue(struct request_queue *q)
 		blk_mq_free_queue(q);
 	percpu_ref_exit(&q->q_usage_counter);
 
+	blk_drop_zones(q);
+
 	spin_lock_irq(lock);
 	if (q->queue_lock != &q->__queue_lock)
 		q->queue_lock = &q->__queue_lock;
@@ -728,6 +730,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 #endif
 	INIT_DELAYED_WORK(&q->delay_work, blk_delay_work);
 
+	blk_init_zones(q);
+
 	kobject_init(&q->kobj, &blk_queue_ktype);
 
 	mutex_init(&q->sysfs_lock);
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
new file mode 100644
index 0000000..a107940
--- /dev/null
+++ b/block/blk-zoned.c
@@ -0,0 +1,338 @@
+/*
+ * Zoned block device handling
+ *
+ * Copyright (c) 2015, Hannes Reinecke
+ * Copyright (c) 2015, SUSE Linux GmbH
+ *
+ * Copyright (c) 2016, Damien Le Moal
+ * Copyright (c) 2016, Western Digital
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rbtree.h>
+#include <linux/blkdev.h>
+
+void blk_init_zones(struct request_queue *q)
+{
+	spin_lock_init(&q->zones_lock);
+	q->zones = RB_ROOT;
+}
+
+/**
+ * blk_drop_zones - Empty a zoned device zone tree.
+ * @q: queue of the zoned device to operate on
+ *
+ * Free all zone descriptors added to the queue zone tree.
+ */
+void blk_drop_zones(struct request_queue *q)
+{
+	struct rb_root *root = &q->zones;
+	struct blk_zone *zone, *next;
+
+	rbtree_postorder_for_each_entry_safe(zone, next, root, node)
+		kfree(zone);
+	q->zones = RB_ROOT;
+}
+EXPORT_SYMBOL_GPL(blk_drop_zones);
+
+/**
+ * blk_insert_zone - Add a new zone struct to the queue RB-tree.
+ * @q: queue of the zoned device to operate on
+ * @new_zone: The zone struct to add
+ *
+ * If @new_zone is not already added to the zone tree, add it.
+ * Otherwise, return the existing entry.
+ */
+struct blk_zone *blk_insert_zone(struct request_queue *q,
+				 struct blk_zone *new_zone)
+{
+	struct rb_root *root = &q->zones;
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	struct blk_zone *zone = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->zones_lock, flags);
+
+	/* Figure out where to put new node */
+	while (*new) {
+		zone = container_of(*new, struct blk_zone, node);
+		parent = *new;
+		if (new_zone->start + new_zone->len <= zone->start)
+			new = &((*new)->rb_left);
+		else if (new_zone->start >= zone->start + zone->len)
+			new = &((*new)->rb_right);
+		else
+			/* Return existing zone */
+			break;
+		zone = NULL;
+	}
+
+	if (!zone) {
+		/* No existing zone: add new node and rebalance tree */
+		rb_link_node(&new_zone->node, parent, new);
+		rb_insert_color(&new_zone->node, root);
+	}
+
+	spin_unlock_irqrestore(&q->zones_lock, flags);
+
+	return zone;
+}
+EXPORT_SYMBOL_GPL(blk_insert_zone);
+
+/**
+ * blk_lookup_zone - Search a zone in a zoned device zone tree.
+ * @q: queue of the zoned device tree to search
+ * @sector: A sector within the zone to search for
+ *
+ * Search the zone containing @sector in the zone tree owned
+ * by @q. NULL is returned if the zone is not found. Since this
+ * can be called concurrently with blk_insert_zone during device
+ * initialization, the tree traversal is protected using the
+ * zones_lock of the queue.
+ */
+struct blk_zone *blk_lookup_zone(struct request_queue *q, sector_t sector)
+{
+	struct rb_root *root = &q->zones;
+	struct rb_node *node = root->rb_node;
+	struct blk_zone *zone = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->zones_lock, flags);
+
+	while (node) {
+		zone = container_of(node, struct blk_zone, node);
+		if (sector < zone->start)
+			node = node->rb_left;
+		else if (sector >= zone->start + zone->len)
+			node = node->rb_right;
+		else
+			break;
+		zone = NULL;
+	}
+
+	spin_unlock_irqrestore(&q->zones_lock, flags);
+
+	return zone;
+}
+EXPORT_SYMBOL_GPL(blk_lookup_zone);
+
+/**
+ * Execute a zone operation (REQ_OP_ZONE*)
+ */
+static int blkdev_issue_zone_operation(struct block_device *bdev,
+				       unsigned int op,
+				       sector_t sector, sector_t nr_sects,
+				       gfp_t gfp_mask)
+{
+	struct bio *bio;
+	int ret;
+
+	if (!bdev_zoned(bdev))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Make sure bi_size does not overflow because
+	 * of some weird very large zone size.
+	 */
+	if (nr_sects && (unsigned long long)nr_sects << 9 > UINT_MAX)
+		return -EINVAL;
+
+	bio = bio_alloc(gfp_mask, 1);
+	if (!bio)
+		return -ENOMEM;
+
+	bio->bi_iter.bi_sector = sector;
+	bio->bi_iter.bi_size = nr_sects << 9;
+	bio->bi_vcnt = 0;
+	bio->bi_bdev = bdev;
+	bio_set_op_attrs(bio, op, 0);
+
+	ret = submit_bio_wait(bio);
+
+	bio_put(bio);
+
+	return ret;
+}
+
+/**
+ * blkdev_update_zones - Force an update of a device zone information
+ * @bdev:	Target block device
+ *
+ * Force an update of all zones information of @bdev. This call does not
+ * block waiting for the update to complete. On return, all zones are only
+ * marked as "in-update". Waiting on the zone update to complete can be done
+ * on a per zone basis using the function blk_wait_for_zone_update.
+ */
+int blkdev_update_zones(struct block_device *bdev,
+			gfp_t gfp_mask)
+{
+	return blkdev_issue_zone_operation(bdev, REQ_OP_ZONE_REPORT,
+					   0, 0, gfp_mask);
+}
+
+/*
+ * Wait for a zone update to complete.
+ */
+static void __blk_wait_for_zone_update(struct blk_zone *zone)
+{
+	might_sleep();
+	if (test_bit(BLK_ZONE_IN_UPDATE, &zone->flags))
+		wait_on_bit_io(&zone->flags, BLK_ZONE_IN_UPDATE,
+			       TASK_UNINTERRUPTIBLE);
+}
+
+/**
+ * blk_wait_for_zone_update - Wait for a zone information update
+ * @zone: The zone to wait for
+ *
+ * This must be called with the zone lock held. If @zone is not
+ * under update, returns immediately. Otherwise, wait for the
+ * update flag to be cleared on completion of the zone information
+ * update by the device driver.
+ */
+void blk_wait_for_zone_update(struct blk_zone *zone)
+{
+	WARN_ON_ONCE(!test_bit(BLK_ZONE_LOCKED, &zone->flags));
+	while (test_bit(BLK_ZONE_IN_UPDATE, &zone->flags)) {
+		blk_unlock_zone(zone);
+		__blk_wait_for_zone_update(zone);
+		blk_lock_zone(zone);
+	}
+}
+
+/**
+ * blkdev_report_zone - Get a zone information
+ * @bdev:	Target block device
+ * @sector:	A sector of the zone to report
+ * @update:	Force an update of the zone information
+ * @gfp_mask:	Memory allocation flags (for bio_alloc)
+ *
+ * Get a zone from the zone cache. And return it.
+ * If update is requested, issue a report zone operation
+ * and wait for the zone information to be updated.
+ */
+struct blk_zone *blkdev_report_zone(struct block_device *bdev,
+				    sector_t sector,
+				    bool update,
+				    gfp_t gfp_mask)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct blk_zone *zone;
+	int ret;
+
+	zone = blk_lookup_zone(q, sector);
+	if (!zone)
+		return ERR_PTR(-ENXIO);
+
+	if (update) {
+		ret = blkdev_issue_zone_operation(bdev, REQ_OP_ZONE_REPORT,
+						  zone->start, zone->len,
+						  gfp_mask);
+		if (ret)
+			return ERR_PTR(ret);
+		__blk_wait_for_zone_update(zone);
+	}
+
+	return zone;
+}
+
+/**
+ * Execute a zone action (open, close, reset or finish).
+ */
+static int blkdev_issue_zone_action(struct block_device *bdev,
+				    sector_t sector, unsigned int op,
+				    gfp_t gfp_mask)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct blk_zone *zone;
+	sector_t nr_sects;
+	int ret;
+
+	if (!blk_queue_zoned(q))
+		return -EOPNOTSUPP;
+
+	if (sector == ~0ULL) {
+		/* All zones */
+		sector = 0;
+		nr_sects = 0;
+	} else {
+		/* This zone */
+		zone = blk_lookup_zone(q, sector);
+		if (!zone)
+			return -ENXIO;
+		sector = zone->start;
+		nr_sects = zone->len;
+	}
+
+	ret = blkdev_issue_zone_operation(bdev, op, sector,
+					  nr_sects, gfp_mask);
+	if (ret == 0 && !nr_sects)
+		blkdev_update_zones(bdev, gfp_mask);
+
+	return ret;
+}
+
+/**
+ * blkdev_reset_zone - Reset a zone write pointer
+ * @bdev:	target block device
+ * @sector:	A sector of the zone to reset or ~0ul for all zones.
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Reset a zone or all zones write pointer.
+ */
+int blkdev_reset_zone(struct block_device *bdev,
+		      sector_t sector, gfp_t gfp_mask)
+{
+	return blkdev_issue_zone_action(bdev, sector, REQ_OP_ZONE_RESET,
+					gfp_mask);
+}
+
+/**
+ * blkdev_open_zone - Explicitely open a zone
+ * @bdev:	target block device
+ * @sector:	A sector of the zone to open or ~0ul for all zones.
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Open a zone or all possible zones.
+ */
+int blkdev_open_zone(struct block_device *bdev,
+		     sector_t sector, gfp_t gfp_mask)
+{
+	return blkdev_issue_zone_action(bdev, sector, REQ_OP_ZONE_OPEN,
+					gfp_mask);
+}
+
+/**
+ * blkdev_close_zone - Close an open zone
+ * @bdev:	target block device
+ * @sector:	A sector of the zone to close or ~0ul for all zones.
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Close a zone or all open zones.
+ */
+int blkdev_close_zone(struct block_device *bdev,
+		      sector_t sector, gfp_t gfp_mask)
+{
+	return blkdev_issue_zone_action(bdev, sector, REQ_OP_ZONE_CLOSE,
+					gfp_mask);
+}
+
+/**
+ * blkdev_finish_zone - Finish a zone (make it full)
+ * @bdev:	target block device
+ * @sector:	A sector of the zone to close or ~0ul for all zones.
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Finish one zone or all possible zones.
+ */
+int blkdev_finish_zone(struct block_device *bdev,
+		       sector_t sector, gfp_t gfp_mask)
+{
+	return blkdev_issue_zone_action(bdev, sector, REQ_OP_ZONE_FINISH,
+					gfp_mask);
+}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1c74b19..1165594 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -24,6 +24,7 @@
 #include <linux/rcupdate.h>
 #include <linux/percpu-refcount.h>
 #include <linux/scatterlist.h>
+#include <linux/bit_spinlock.h>
 
 struct module;
 struct scsi_ioctl_command;
@@ -302,6 +303,113 @@ struct queue_limits {
 	unsigned char		zoned;
 };
 
+#ifdef CONFIG_BLK_DEV_ZONED
+
+enum blk_zone_type {
+	BLK_ZONE_TYPE_UNKNOWN,
+	BLK_ZONE_TYPE_CONVENTIONAL,
+	BLK_ZONE_TYPE_SEQWRITE_REQ,
+	BLK_ZONE_TYPE_SEQWRITE_PREF,
+};
+
+enum blk_zone_cond {
+	BLK_ZONE_COND_NO_WP,
+	BLK_ZONE_COND_EMPTY,
+	BLK_ZONE_COND_IMP_OPEN,
+	BLK_ZONE_COND_EXP_OPEN,
+	BLK_ZONE_COND_CLOSED,
+	BLK_ZONE_COND_READONLY = 0xd,
+	BLK_ZONE_COND_FULL,
+	BLK_ZONE_COND_OFFLINE,
+};
+
+enum blk_zone_flags {
+	BLK_ZONE_LOCKED,
+	BLK_ZONE_WRITE_LOCKED,
+	BLK_ZONE_IN_UPDATE,
+};
+
+/**
+ * Zone descriptor. On 64-bits architectures,
+ * this will align on sizeof(long), i.e. 64 B,
+ * and use 64 B.
+ */
+struct blk_zone {
+	struct rb_node	node;
+	unsigned long 	flags;
+	sector_t	len;
+	sector_t 	start;
+	sector_t 	wp;
+	unsigned int 	type : 4;
+	unsigned int	cond : 4;
+	unsigned int	non_seq : 1;
+	unsigned int	reset : 1;
+};
+
+#define blk_zone_is_seq_req(z)	((z)->type == BLK_ZONE_TYPE_SEQWRITE_REQ)
+#define blk_zone_is_seq_pref(z)	((z)->type == BLK_ZONE_TYPE_SEQWRITE_PREF)
+#define blk_zone_is_seq(z)	(blk_zone_is_seq_req(z) || blk_zone_is_seq_pref(z))
+#define blk_zone_is_conv(z) 	((z)->type == BLK_ZONE_TYPE_CONVENTIONAL)
+
+#define blk_zone_is_readonly(z)	((z)->cond == BLK_ZONE_COND_READONLY)
+#define blk_zone_is_offline(z) 	((z)->cond == BLK_ZONE_COND_OFFLINE)
+#define blk_zone_is_full(z)	((z)->cond == BLK_ZONE_COND_FULL)
+#define blk_zone_is_empty(z)	((z)->cond == BLK_ZONE_COND_EMPTY)
+#define blk_zone_is_open(z)	((z)->cond == BLK_ZONE_COND_EXP_OPEN)
+
+static inline void blk_lock_zone(struct blk_zone *zone)
+{
+	bit_spin_lock(BLK_ZONE_LOCKED, &zone->flags);
+}
+
+static inline int blk_trylock_zone(struct blk_zone *zone)
+{
+	return bit_spin_trylock(BLK_ZONE_LOCKED, &zone->flags);
+}
+
+static inline void blk_unlock_zone(struct blk_zone *zone)
+{
+	bit_spin_unlock(BLK_ZONE_LOCKED, &zone->flags);
+}
+
+static inline int blk_try_write_lock_zone(struct blk_zone *zone)
+{
+	return !test_and_set_bit(BLK_ZONE_WRITE_LOCKED, &zone->flags);
+}
+
+static inline void blk_write_unlock_zone(struct blk_zone *zone)
+{
+	clear_bit_unlock(BLK_ZONE_WRITE_LOCKED, &zone->flags);
+	smp_mb__after_atomic();
+}
+
+extern void blk_init_zones(struct request_queue *);
+extern void blk_drop_zones(struct request_queue *);
+extern struct blk_zone *blk_insert_zone(struct request_queue *,
+					struct blk_zone *);
+extern struct blk_zone *blk_lookup_zone(struct request_queue *, sector_t);
+
+extern int blkdev_update_zones(struct block_device *, gfp_t);
+extern void blk_wait_for_zone_update(struct blk_zone *);
+#define blk_zone_in_update(z)	test_bit(BLK_ZONE_IN_UPDATE, &(z)->flags)
+static inline void blk_clear_zone_update(struct blk_zone *zone)
+{
+	clear_bit_unlock(BLK_ZONE_IN_UPDATE, &zone->flags);
+	smp_mb__after_atomic();
+	wake_up_bit(&zone->flags, BLK_ZONE_IN_UPDATE);
+}
+
+extern struct blk_zone *blkdev_report_zone(struct block_device *,
+					   sector_t, bool, gfp_t);
+extern int blkdev_reset_zone(struct block_device *, sector_t, gfp_t);
+extern int blkdev_open_zone(struct block_device *, sector_t, gfp_t);
+extern int blkdev_close_zone(struct block_device *, sector_t, gfp_t);
+extern int blkdev_finish_zone(struct block_device *, sector_t, gfp_t);
+#else /* CONFIG_BLK_DEV_ZONED */
+static inline void blk_init_zones(struct request_queue *q) { };
+static inline void blk_drop_zones(struct request_queue *q) { };
+#endif /* CONFIG_BLK_DEV_ZONED */
+
 struct request_queue {
 	/*
 	 * Together with queue_head for cacheline sharing
@@ -404,6 +512,11 @@ struct request_queue {
 	unsigned int		nr_pending;
 #endif
 
+#ifdef CONFIG_BLK_DEV_ZONED
+	spinlock_t		zones_lock;
+	struct rb_root		zones;
+#endif
+
 	/*
 	 * queue settings
 	 */
-- 
2.7.4

