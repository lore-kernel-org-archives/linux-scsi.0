From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 9/15] dm: implement copy
Date: Thu, 10 Dec 2015 12:30:49 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1512101213420.25927@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch implements basic copy support for device mapper core.
Individual targets can enable copy support by setting ti->copy_supported.

Device mapper device advertises copy support if at least one target
supports copy and for this target, at least one underlying device supports
copy.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c         |   16 ++++++++++++++++
 drivers/md/dm.c               |   27 +++++++++++++++++++++++++++
 include/linux/device-mapper.h |    5 +++++
 3 files changed, 48 insertions(+)

Index: linux-4.4-rc4/drivers/md/dm.c
===================================================================
--- linux-4.4-rc4.orig/drivers/md/dm.c	2015-12-10 17:04:05.000000000 +0100
+++ linux-4.4-rc4/drivers/md/dm.c	2015-12-10 17:05:48.000000000 +0100
@@ -1679,6 +1679,31 @@ static int __send_write_same(struct clon
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
+	__clone_and_map_simple_bio(ci, ti, 0, NULL);
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
@@ -1692,6 +1717,8 @@ static int __split_and_process_non_flush
 		return __send_discard(ci);
 	else if (unlikely(bio->bi_rw & REQ_WRITE_SAME))
 		return __send_write_same(ci);
+	else if (unlikely(bio->bi_rw & REQ_COPY))
+		return __send_copy(ci);
 
 	ti = dm_table_find_target(ci->map, ci->sector);
 	if (!dm_target_is_valid(ti))
Index: linux-4.4-rc4/include/linux/device-mapper.h
===================================================================
--- linux-4.4-rc4.orig/include/linux/device-mapper.h	2015-12-10 17:04:05.000000000 +0100
+++ linux-4.4-rc4/include/linux/device-mapper.h	2015-12-10 17:04:59.000000000 +0100
@@ -271,6 +271,11 @@ struct dm_target {
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
Index: linux-4.4-rc4/drivers/md/dm-table.c
===================================================================
--- linux-4.4-rc4.orig/drivers/md/dm-table.c	2015-12-10 17:03:51.000000000 +0100
+++ linux-4.4-rc4/drivers/md/dm-table.c	2015-12-10 17:04:59.000000000 +0100
@@ -286,6 +286,11 @@ static int device_area_is_invalid(struct
 		limits->logical_block_size >> SECTOR_SHIFT;
 	char b[BDEVNAME_SIZE];
 
+	if (ti->copy_supported)
+		limits->max_copy_sectors =
+			min_not_zero(limits->max_copy_sectors,
+				bdev_get_queue(bdev)->limits.max_copy_sectors);
+
 	/*
 	 * Some devices exist without request functions,
 	 * such as loop devices not yet bound to backing files.
@@ -1256,6 +1261,13 @@ int dm_calculate_queue_limits(struct dm_
 
 		ti = dm_table_get_target(table, i++);
 
+		if (ti->begin)
+			ti_limits.copy_boundary = min(ti_limits.copy_boundary,
+					(unsigned char)__ffs64(ti->begin));
+		if (ti->max_io_len)
+			ti_limits.copy_boundary = min(ti_limits.copy_boundary,
+					(unsigned char)__ffs(ti->max_io_len));
+
 		if (!ti->type->iterate_devices)
 			goto combine_limits;
 
@@ -1289,6 +1301,10 @@ combine_limits:
 			       dm_device_name(table->md),
 			       (unsigned long long) ti->begin,
 			       (unsigned long long) ti->len);
+
+		limits->max_copy_sectors =
+					min_not_zero(limits->max_copy_sectors,
+					ti_limits.max_copy_sectors);
 	}
 
 	return validate_hardware_logical_block_alignment(table, limits);
