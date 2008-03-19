From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 11/13] dm: reject bad table load
Date: Wed, 19 Mar 2008 18:11:37 -0500 (EST)
Message-ID: <20080319.181137.131914054.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu, hare@suse.de, agk@redhat.com, linux-kernel@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch rejects bad table load for request-based dm.

The following table loadings are rejected:
  - including non request stackable device
  - shrinking the current restrictions

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-table.c         |   48 ++++++++++++++++++++++++++++++++++++++++--
 drivers/md/dm.c               |    5 ++++
 include/linux/device-mapper.h |    2 +
 3 files changed, 53 insertions(+), 2 deletions(-)

Index: 2.6.25-rc5/drivers/md/dm-table.c
===================================================================
--- 2.6.25-rc5.orig/drivers/md/dm-table.c
+++ 2.6.25-rc5/drivers/md/dm-table.c
@@ -108,6 +108,8 @@ static void combine_restrictions_low(str
 	lhs->bounce_pfn = min_not_zero(lhs->bounce_pfn, rhs->bounce_pfn);
 
 	lhs->no_cluster |= rhs->no_cluster;
+
+	lhs->no_request_stacking |= rhs->no_request_stacking;
 }
 
 /*
@@ -578,6 +580,9 @@ void dm_set_device_limits(struct dm_targ
 	rs->bounce_pfn = min_not_zero(rs->bounce_pfn, q->bounce_pfn);
 
 	rs->no_cluster |= !test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
+
+	if (!q->request_fn)
+		rs->no_request_stacking = 1;
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);
 
@@ -704,8 +709,12 @@ int dm_split_args(int *argc, char ***arg
 	return 0;
 }
 
-static void check_for_valid_limits(struct io_restrictions *rs)
+static int check_for_valid_limits(struct io_restrictions *rs,
+				  struct mapped_device *md)
 {
+	int r = 0;
+	struct dm_table *t;
+
 	if (!rs->max_sectors)
 		rs->max_sectors = SAFE_MAX_SECTORS;
 	if (!rs->max_hw_sectors)
@@ -722,6 +731,39 @@ static void check_for_valid_limits(struc
 		rs->seg_boundary_mask = -1;
 	if (!rs->bounce_pfn)
 		rs->bounce_pfn = -1;
+
+	if (!dm_request_based(md))
+		return 0;
+
+	/* Allows to load only request stackable tables */
+	if (rs->no_request_stacking) {
+		DMERR("table load rejected: including non-request-stackable "
+		      "devices");
+		return -EINVAL;
+	}
+
+	t = dm_get_table(md);
+
+	/* Initial table loading must be allowed */
+	if (!t)
+		return 0;
+
+	if ((rs->max_sectors < t->limits.max_sectors) ||
+	    (rs->max_hw_sectors < t->limits.max_hw_sectors) ||
+	    (rs->max_phys_segments < t->limits.max_phys_segments) ||
+	    (rs->max_hw_segments < t->limits.max_hw_segments) ||
+	    (rs->hardsect_size > t->limits.hardsect_size) ||
+	    (rs->max_segment_size < t->limits.max_segment_size) ||
+	    (rs->seg_boundary_mask < t->limits.seg_boundary_mask) ||
+	    (rs->bounce_pfn < t->limits.bounce_pfn) ||
+	    (rs->no_cluster && !t->limits.no_cluster)) {
+		DMERR("table load rejected: shrinking current restriction");
+		r = -EINVAL;
+	}
+
+	dm_table_put(t);
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
Index: 2.6.25-rc5/drivers/md/dm.c
===================================================================
--- 2.6.25-rc5.orig/drivers/md/dm.c
+++ 2.6.25-rc5/drivers/md/dm.c
@@ -2302,6 +2302,11 @@ int dm_suspended(struct mapped_device *m
 	return test_bit(DMF_SUSPENDED, &md->flags);
 }
 
+int dm_request_based(struct mapped_device *md)
+{
+	return test_bit(DMF_REQUEST_BASED, &md->flags);
+}
+
 int dm_noflush_suspending(struct dm_target *ti)
 {
 	struct mapped_device *md = dm_table_get_md(ti->table);
Index: 2.6.25-rc5/include/linux/device-mapper.h
===================================================================
--- 2.6.25-rc5.orig/include/linux/device-mapper.h
+++ 2.6.25-rc5/include/linux/device-mapper.h
@@ -131,6 +131,7 @@ struct io_restrictions {
 	unsigned short max_hw_segments;
 	unsigned short max_phys_segments;
 	unsigned char no_cluster; /* inverted so that 0 is default */
+	unsigned char no_request_stacking; /* inverted so that 0 is default */
 };
 
 struct dm_target {
@@ -207,6 +208,7 @@ const char *dm_device_name(struct mapped
 int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid);
 struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct mapped_device *md);
+int dm_request_based(struct mapped_device *md);
 int dm_noflush_suspending(struct dm_target *ti);
 
 /*
