From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 12/18] dm: implement copy
Date: Wed, 22 Oct 2014 09:30:42 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1410220930110.31351@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch implements basic copy support for device mapper core.
Individual targets can enable copy support by setting ti->copy_supported.

Device mapper device advertises copy support if at least one target
supports copy and for this target, at least one underlying device supports
copy.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c         |    9 +++++++++
 drivers/md/dm.c               |   42 +++++++++++++++++++++++++++++++++++++++---
 include/linux/device-mapper.h |    5 +++++
 3 files changed, 53 insertions(+), 3 deletions(-)

Index: linux-3.18-rc1/drivers/md/dm.c
===================================================================
--- linux-3.18-rc1.orig/drivers/md/dm.c	2014-10-21 00:46:30.000000000 +0200
+++ linux-3.18-rc1/drivers/md/dm.c	2014-10-21 00:49:09.000000000 +0200
@@ -1559,6 +1559,31 @@ static int __send_write_same(struct clon
 	return __send_changing_extent_only(ci, get_num_write_same_bios, NULL);
 }
 
+static int __send_copy(struct clone_info *ci)
+{
+	struct dm_target *ti;
+	sector_t bound;
+
+	ti = dm_table_find_target(ci->map, ci->sector);
+	if (!dm_target_is_valid(ti))
+		return -EIO;
+
+	if (!ti->copy_supported)
+		return -EOPNOTSUPP;
+
+	bound = max_io_len(ci->sector, ti);
+
+	if (unlikely(ci->sector_count > bound))
+		return -EOPNOTSUPP;
+
+	__clone_and_map_simple_bio(ci, ti, 0, NULL, NULL);
+
+	ci->sector += ci->sector_count;
+	ci->sector_count = 0;
+
+	return 0;
+}
+
 /*
  * Select the correct strategy for processing a non-flush bio.
  */
@@ -1572,6 +1597,8 @@ static int __split_and_process_non_flush
 		return __send_discard(ci);
 	else if (unlikely(bio->bi_rw & REQ_WRITE_SAME))
 		return __send_write_same(ci);
+	else if (unlikely(bio->bi_rw & REQ_COPY))
+		return __send_copy(ci);
 
 	ti = dm_table_find_target(ci->map, ci->sector);
 	if (!dm_target_is_valid(ti))
@@ -1656,6 +1683,11 @@ static int dm_merge_bvec(struct request_
 	if (!dm_target_is_valid(ti))
 		goto out;
 
+	if (unlikely((bvm->bi_rw & REQ_COPY) != 0)) {
+		if (!ti->copy_supported)
+			goto out_ret_max_size;
+	}
+
 	/*
 	 * Find maximum amount of I/O that won't need splitting
 	 */
@@ -1679,17 +1711,21 @@ static int dm_merge_bvec(struct request_
 	 * entries.  So always set max_size to 0, and the code below allows
 	 * just one page.
 	 */
-	else if (queue_max_hw_sectors(q) <= PAGE_SIZE >> 9)
+	else if (likely(!(bvm->bi_rw & REQ_COPY)) &&
+		 queue_max_hw_sectors(q) <= PAGE_SIZE >> 9)
 		max_size = 0;
 
 out:
-	dm_put_live_table_fast(md);
 	/*
 	 * Always allow an entire first page
 	 */
-	if (max_size <= biovec->bv_len && !(bvm->bi_size >> SECTOR_SHIFT))
+	if (likely(!(bvm->bi_rw & REQ_COPY)) &&
+	    max_size <= biovec->bv_len && !(bvm->bi_size >> SECTOR_SHIFT))
 		max_size = biovec->bv_len;
 
+out_ret_max_size:
+	dm_put_live_table_fast(md);
+
 	return max_size;
 }
 
Index: linux-3.18-rc1/include/linux/device-mapper.h
===================================================================
--- linux-3.18-rc1.orig/include/linux/device-mapper.h	2014-10-21 00:42:40.000000000 +0200
+++ linux-3.18-rc1/include/linux/device-mapper.h	2014-10-21 00:49:09.000000000 +0200
@@ -251,6 +251,11 @@ struct dm_target {
 	 * Set if this target does not return zeroes on discarded blocks.
 	 */
 	bool discard_zeroes_data_unsupported:1;
+
+	/*
+	 * Set if the target supports XCOPY.
+	 */
+	bool copy_supported:1;
 };
 
 /* Each target can link one of these into the table */
Index: linux-3.18-rc1/drivers/md/dm-table.c
===================================================================
--- linux-3.18-rc1.orig/drivers/md/dm-table.c	2014-10-21 00:34:45.000000000 +0200
+++ linux-3.18-rc1/drivers/md/dm-table.c	2014-10-21 00:49:09.000000000 +0200
@@ -443,6 +443,11 @@ static int dm_set_device_limits(struct d
 		       q->limits.alignment_offset,
 		       (unsigned long long) start << SECTOR_SHIFT);
 
+	if (ti->copy_supported)
+		limits->max_copy_sectors =
+			min_not_zero(limits->max_copy_sectors,
+				bdev_get_queue(bdev)->limits.max_copy_sectors);
+
 	/*
 	 * Check if merge fn is supported.
 	 * If not we'll force DM to use PAGE_SIZE or
@@ -1264,6 +1269,10 @@ combine_limits:
 			       dm_device_name(table->md),
 			       (unsigned long long) ti->begin,
 			       (unsigned long long) ti->len);
+
+		limits->max_copy_sectors =
+					min_not_zero(limits->max_copy_sectors,
+					ti_limits.max_copy_sectors);
 	}
 
 	return validate_hardware_logical_block_alignment(table, limits);
