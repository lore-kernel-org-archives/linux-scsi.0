From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [APPENDIX PATCH 11/13] dm: reject bad table load
Date: Fri, 15 Feb 2008 17:33:06 -0500 (EST)
Message-ID: <20080215.173306.99203686.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762779AbYBOWdA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 17:33:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch rejects bad table load for request-based dm.

The following table loadings are rejected:
  - including non-stackable device
  - shrinking the current restrictions

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-table.c         |   48 ++++++++++++++++++++++++++++++++++++++++--
 drivers/md/dm.c               |   25 +++++++++++++++++++++
 include/linux/device-mapper.h |    9 +++++++
 3 files changed, 80 insertions(+), 2 deletions(-)

Index: 2.6.25-rc1/drivers/md/dm-table.c
===================================================================
--- 2.6.25-rc1.orig/drivers/md/dm-table.c
+++ 2.6.25-rc1/drivers/md/dm-table.c
@@ -108,6 +108,8 @@ static void combine_restrictions_low(str
 	lhs->bounce_pfn = min_not_zero(lhs->bounce_pfn, rhs->bounce_pfn);
 
 	lhs->no_cluster |= rhs->no_cluster;
+
+	lhs->no_stack |= rhs->no_stack;
 }
 
 /*
@@ -578,6 +580,8 @@ void dm_set_device_limits(struct dm_targ
 	rs->bounce_pfn = min_not_zero(rs->bounce_pfn, q->bounce_pfn);
 
 	rs->no_cluster |= !test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
+
+	rs->no_stack |= !blk_queue_stackable(q);
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);
 
@@ -704,8 +708,13 @@ int dm_split_args(int *argc, char ***arg
 	return 0;
 }
 
-static void check_for_valid_limits(struct io_restrictions *rs)
+static int check_for_valid_limits(struct io_restrictions *rs,
+				  struct mapped_device *md)
 {
+	int r = 0;
+	struct request_queue *q;
+
+	/* Set maximum value if no restriction */
 	if (!rs->max_sectors)
 		rs->max_sectors = SAFE_MAX_SECTORS;
 	if (!rs->max_hw_sectors)
@@ -722,6 +731,39 @@ static void check_for_valid_limits(struc
 		rs->seg_boundary_mask = -1;
 	if (!rs->bounce_pfn)
 		rs->bounce_pfn = -1;
+
+	/* Request-based dm allows to load only request stackable tables */
+	if (dm_request_based(md) && rs->no_stack) {
+		DMERR("table load rejected: including non-stackable devices");
+		return -EINVAL;
+	}
+
+	/* First table loading must be allowed */
+	if (!dm_request_based(md) || !dm_bound_table(md))
+		return 0;
+
+	q  = dm_get_queue(md);
+	if (!q) {
+		DMERR("can't get queue from the mapped device");
+		return -EINVAL;
+	}
+
+	if ((rs->max_sectors < q->max_sectors) ||
+	    (rs->max_hw_sectors < q->max_hw_sectors) ||
+	    (rs->max_phys_segments < q->max_phys_segments) ||
+	    (rs->max_hw_segments < q->max_hw_segments) ||
+	    (rs->hardsect_size > q->hardsect_size) ||
+	    (rs->max_segment_size < q->max_segment_size) ||
+	    (rs->seg_boundary_mask < q->seg_boundary_mask) ||
+	    (rs->bounce_pfn < q->bounce_pfn) ||
+	    (rs->no_cluster && test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags))) {
+		DMERR("table load rejected: shrinking current restriction");
+		r = -EINVAL;
+	}
+
+	dm_put_queue(q);
+
+	return r;
 }
 
 int dm_table_add_target(struct dm_table *t, const char *type,
@@ -875,7 +917,9 @@ int dm_table_complete(struct dm_table *t
 	if (r)
 		return r;
 
-	check_for_valid_limits(&t->limits);
+	r = check_for_valid_limits(&t->limits, t->md);
+	if (r)
+		return r;
 
 	/* how many indexes will the btree have ? */
 	leaf_nodes = dm_div_up(t->num_targets, KEYS_PER_NODE);
Index: 2.6.25-rc1/drivers/md/dm.c
===================================================================
--- 2.6.25-rc1.orig/drivers/md/dm.c
+++ 2.6.25-rc1/drivers/md/dm.c
@@ -96,6 +96,7 @@ EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
 #define DMF_NOFLUSH_SUSPENDING 5
 #define DMF_REQUEST_BASED 6
 #define DMF_BIO_BASED 7
+#define DMF_BOUND_TABLE 8
 
 /*
  * Work processed by per-device workqueue.
@@ -1672,6 +1673,7 @@ static int __bind(struct mapped_device *
 	write_lock(&md->map_lock);
 	md->map = t;
 	dm_table_set_restrictions(t, q);
+	set_bit(DMF_BOUND_TABLE, &md->flags);
 	write_unlock(&md->map_lock);
 
 	return 0;
@@ -1912,6 +1914,19 @@ static void start_queue(struct request_q
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
+struct request_queue *dm_get_queue(struct mapped_device *md)
+{
+	if (blk_get_queue(md->queue))
+		return NULL;
+
+	return md->queue;
+}
+
+void dm_put_queue(struct request_queue *q)
+{
+	blk_put_queue(q);
+}
+
 /*
  * Functions to lock and unlock any filesystem running on the
  * device.
@@ -2174,6 +2189,16 @@ int dm_suspended(struct mapped_device *m
 	return test_bit(DMF_SUSPENDED, &md->flags);
 }
 
+int dm_request_based(struct mapped_device *md)
+{
+	return test_bit(DMF_REQUEST_BASED, &md->flags);
+}
+
+int dm_bound_table(struct mapped_device *md)
+{
+	return test_bit(DMF_BOUND_TABLE, &md->flags);
+}
+
 int dm_noflush_suspending(struct dm_target *ti)
 {
 	struct mapped_device *md = dm_table_get_md(ti->table);
Index: 2.6.25-rc1/include/linux/device-mapper.h
===================================================================
--- 2.6.25-rc1.orig/include/linux/device-mapper.h
+++ 2.6.25-rc1/include/linux/device-mapper.h
@@ -142,6 +142,7 @@ struct io_restrictions {
 	unsigned short max_hw_segments;
 	unsigned short max_phys_segments;
 	unsigned char no_cluster; /* inverted so that 0 is default */
+	unsigned char no_stack; /* inverted so that 0 is default */
 };
 
 struct dm_target {
@@ -218,6 +219,8 @@ const char *dm_device_name(struct mapped
 int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid);
 struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct mapped_device *md);
+int dm_request_based(struct mapped_device *md);
+int dm_bound_table(struct mapped_device *md);
 int dm_noflush_suspending(struct dm_target *ti);
 
 /*
@@ -256,6 +259,12 @@ void dm_table_get(struct dm_table *t);
 void dm_table_put(struct dm_table *t);
 
 /*
+ * Queue reference counting.
+ */
+struct request_queue *dm_get_queue(struct mapped_device *md);
+void dm_put_queue(struct request_queue *q);
+
+/*
  * Queries
  */
 sector_t dm_table_get_size(struct dm_table *t);
