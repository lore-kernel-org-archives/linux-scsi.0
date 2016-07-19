From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] dm-zoned: New device mapper target for zoned block devices
Date: Tue, 19 Jul 2016 16:02:58 +0200
Message-ID: <1468936978-9124-4-git-send-email-hare@suse.de>
References: <1468936978-9124-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbcGSODG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 10:03:06 -0400
In-Reply-To: <1468936978-9124-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel-redhat.com@suse.de, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.com>

From: Damien Le Moal <damien.lemoal@hgst.com>

dm-zoned presents a regular block device fully randomly writeable,
hiding write constraints of host-managed zoned block devices and
mitigating potential performance degradation of host-aware devices.

Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 Documentation/device-mapper/dm-zoned.txt |  147 +++
 drivers/md/Kconfig                       |   14 +
 drivers/md/Makefile                      |    2 +
 drivers/md/dm-zoned-io.c                 | 1186 ++++++++++++++++++
 drivers/md/dm-zoned-meta.c               | 1950 ++++++++++++++++++++++++++++++
 drivers/md/dm-zoned-reclaim.c            |  770 ++++++++++++
 drivers/md/dm-zoned.h                    |  687 +++++++++++
 7 files changed, 4756 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-zoned.txt
 create mode 100644 drivers/md/dm-zoned-io.c
 create mode 100644 drivers/md/dm-zoned-meta.c
 create mode 100644 drivers/md/dm-zoned-reclaim.c
 create mode 100644 drivers/md/dm-zoned.h

diff --git a/Documentation/device-mapper/dm-zoned.txt b/Documentation/device-mapper/dm-zoned.txt
new file mode 100644
index 0000000..28595ef
--- /dev/null
+++ b/Documentation/device-mapper/dm-zoned.txt
@@ -0,0 +1,147 @@
+dm-zoned
+========
+
+The dm-zoned device mapper target provides transparent write access to
+zoned block devices (ZBC and ZAC compliant devices). It hides to the
+device user (a file system or an application doing raw block device
+accesses) any sequential write constraint on host-managed devices and
+can mitigate potential device performance degradation with host-aware
+zoned devices.
+
+For a more detailed description of the zoned block device models and
+constraints see (for SCSI devices):
+
+http://www.t10.org/drafts.htm#ZBC_Family
+
+And (for ATA devices):
+
+http://www.t13.org/Documents/UploadedDocuments/docs2015/di537r05-Zoned_Device_ATA_Command_Set_ZAC.pdf
+
+
+Algorithm
+=========
+
+The zones of the device are separated into 3 sets:
+1) Metadata zones: these are randomly writeable zones used to store metadata.
+Randomly writeable zones may be conventional zones or sequential write preferred
+zones (host-aware devices only). These zones have a fixed mapping and must be
+available at the beginning of the device address space (from LBA 0).
+2) Buffer zones: these are randomly writeable zones used to temporarily
+buffer unaligned writes to data zones. Buffer zones zones may be conventional
+zones or sequential write preferred zones (host-aware devivces only) and any
+random zone in the device address space can be used as a buffer zone (there
+are no constraint on these zones location).
+3) Data zones: all remaining zones. Most will likely be sequential zones,
+either sequiential write required zones (host-managed devices) or sequential
+write preferred zones (host-aware devices). Conventional zones unused as
+metadata zone or buffer zone will be part of the set of data zones. dm-zoned
+tries to efficiently allocate and map these zones to limit the performance
+impact of buffering random writes for chunks of the logical device that are
+being heavily randomly written.
+
+dm-zoned exposes a logical device with a sector size of 4096 bytes, irespectively
+of the physical sector size of the backend device being used.  This allows
+reducing the amount of metadata needed to manage valid blocks (blocks written)
+and buffering of random writes. In more detail, the on-disk metadata format
+is as follows:
+1) Block 0 contains the super block which describes the amount of metadata
+blocks used, the number of buffer zones reserved, their position on disk and
+the data zones being buffered.
+2) Following block 0, a set of blocks is used to describe the mapping to data
+zones of the logical chunks of the logical device (the size of a logical chunk
+is equal to the device zone size).
+3) A set of blocks used to store bitmaps indicating the validity of blocks in
+the buffer zones and data zones. A valid block is a block that was writen and
+not discarded. For a buffered data zone, a block can be valid only in the data
+zone or in the buffer zone.
+
+For a logical chunk mapped to a conventional data zone, all write operations are
+processed by directly writing the data zone. If the mapping zone is a sequential
+zone, the write operation is processed directly only and only if the write offset
+within the logical chunk equals the write pointer offset within the data zone
+(i.e. the write operation is aligned on the zone write pointer).
+
+Otherwise, write operations are processed indirectly using a buffer zone: a buffer
+zone is allocated and assigned to the data zone being accessed and data written to
+the buffer zone. This results in the invalidation of the written block in the data
+zone and validation in the buffer zone.
+
+Read operations are processed according to the block validity information provided
+by the bitmaps: valid blocks are read either from the data zone or, if the data
+zone is buffered, from the buffer zone assigned to the data zone.
+
+After some time, the limited number of buffer zones available may be exhausted and
+unaligned writes to unbuffered zones become impossible. To avoid such situation, a
+reclaim process regularly scan used buffer zones and try to "reclaim" them by
+rewriting (sequentially) the buffered data blocks and the valid blocks in the data
+zone being buffered into a new data zone. This "merge" operation completes with the
+remapping of the data zone chunk to the newly writen data zone and the release of
+the buffer zone.
+
+This reclaim process is optimized to try to detect data zones that are being
+heavily randomly written and try to do the merge operation into a conventional
+data zone (if available).
+
+Usage
+=====
+
+Parameters: <zoned device path> [Options]
+Options:
+	debug             : Enable debug messages
+	format            : Reset and format the device metadata. This will
+	                    invalidate all blocks of the device and trigger
+			    a reset write pointer of all zones, causing the
+			    loss of all previously written data.
+	num_bzones=<num>  : If the format option is specified, change the
+			    default number of buffer zones from 64 to <num>.
+			    If <num> is too large and cannot be accomodated
+			    with the number of available random zones, the
+			    maximum possible number of buffer zones is used.
+	align_wp=<blocks> : Use write same command to move an SMR zone write
+			    pointer position to the offset of a write request,
+			    limiting the write same operation to at most
+			    <blocks>. This can reduce the use of buffer zones,
+			    but can also significantly decrease the disk
+			    useable throughput. Set to 0 (default) to disable
+			    this feature. The maximum allowed is half the
+			    disk zone size.
+
+Example scripts
+===============
+
+[[
+#!/bin/sh
+
+if [ $# -lt 1 ]; then
+	echo "Usage: $0 <Zoned device path> [Options]"
+	echo "Options:"
+	echo "    debug             : Enable debug messages"
+	echo "    format            : Reset and format the device metadata. This will"
+	echo "                        invalidate all blocks of the device and trigger"
+	echo "                        a reset write pointer of all zones, causing the"
+	echo "                        loss of all previously written data."
+	echo "    num_bzones=<num>  : If the format option is specified, change the"
+	echo "                        default number of buffer zones from 64 to <num>."
+	echo "                        If <num> is too large and cannot be accomodated"
+	echo "                        with the number of available random zones, the"
+	echo "                        maximum possible number of buffer zones is used."
+	echo "    align_wp=<blocks> : Use write same command to move an SMR zone write"
+	echo "                        pointer position to the offset of a write request,"
+	echo "		              limiting the write same operation to at most"
+	echo "		              <blocks>. This can reduce the use of buffer zones,"
+	echo "                        but can also significantly decrease the disk"
+	echo "                        useable throughput. Set to 0 (default) to disable"
+	echo "                        this feature. The maximum allowed is half the"
+	echo "                        disk zone size."
+	exit 1
+fi
+
+dev="${1}"
+shift
+options="$@"
+
+modprobe dm-zoned
+
+echo "0 `blockdev --getsize ${dev}` dm-zoned ${dev} ${options}" | dmsetup create zoned-`basename ${dev}`
+]]
+
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 02a5345..4f31863 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -500,4 +500,18 @@ config DM_LOG_WRITES
 
 	  If unsure, say N.
 
+config DM_ZONED
+	tristate "Zoned block device cache write target support (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && BLK_DEV_ZONED
+	default n
+	---help---
+	  This device-mapper target implements an on-disk caching layer for
+	  zoned block devices (ZBC), doing so hiding random write constraints
+	  of the backend device.
+
+	  To compile this code as a module, choose M here: the module will
+	  be called dm-zoned.
+
+	  If unsure, say N.
+
 endif # MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 52ba8dd..2d61be5 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -18,6 +18,7 @@ dm-era-y	+= dm-era-target.o
 dm-verity-y	+= dm-verity-target.o
 md-mod-y	+= md.o bitmap.o
 raid456-y	+= raid5.o raid5-cache.o
+dm-zoned-y      += dm-zoned-io.o dm-zoned-meta.o dm-zoned-reclaim.o
 
 # Note: link order is important.  All raid personalities
 # and must come before md.o, as they each initialise 
@@ -58,6 +59,7 @@ obj-$(CONFIG_DM_CACHE_SMQ)	+= dm-cache-smq.o
 obj-$(CONFIG_DM_CACHE_CLEANER)	+= dm-cache-cleaner.o
 obj-$(CONFIG_DM_ERA)		+= dm-era.o
 obj-$(CONFIG_DM_LOG_WRITES)	+= dm-log-writes.o
+obj-$(CONFIG_DM_ZONED)          += dm-zoned.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
diff --git a/drivers/md/dm-zoned-io.c b/drivers/md/dm-zoned-io.c
new file mode 100644
index 0000000..347510a
--- /dev/null
+++ b/drivers/md/dm-zoned-io.c
@@ -0,0 +1,1186 @@
+/*
+ * (C) Copyright 2016 Western Digital.
+ *
+ * This software is distributed under the terms of the GNU Lesser General
+ * Public License version 2, or any later version, "as is," without technical
+ * support, and WITHOUT ANY WARRANTY, without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Author: Damien Le Moal <damien.lemoal@hgst.com>
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/version.h>
+
+#include "dm-zoned.h"
+
+/**
+ * Target BIO completion.
+ */
+static inline void
+dm_zoned_bio_end(struct bio *bio, int err)
+{
+	struct dm_zoned_bioctx *bioctx
+		= dm_per_bio_data(bio, sizeof(struct dm_zoned_bioctx));
+
+	if (err)
+		bioctx->error = err;
+
+	if (atomic_dec_and_test(&bioctx->ref)) {
+		/* I/O Completed */
+		if (bioctx->dzone)
+			dm_zoned_put_dzone(bioctx->target, bioctx->dzone);
+		bio->bi_error = bioctx->error;
+		bio_endio(bio);
+	}
+}
+
+/**
+ * I/O request completion callback. This terminates
+ * the target BIO when there are no more references
+ * on the BIO context.
+ */
+static void
+dm_zoned_bio_end_io(struct bio *bio)
+{
+	struct dm_zoned_bioctx *bioctx = bio->bi_private;
+	struct dm_zoned_zone *dzone = bioctx->dzone;
+	int err = bio->bi_error;
+	unsigned long flags;
+
+	dm_zoned_lock_zone(dzone, flags);
+	dm_zoned_assert(dzone->zwork);
+	if (atomic_dec_and_test(&dzone->zwork->bio_count)) {
+		clear_bit_unlock(DM_ZONE_ACTIVE_BIO, &dzone->flags);
+		smp_mb__after_atomic();
+		wake_up_bit(&dzone->flags, DM_ZONE_ACTIVE_BIO);
+	}
+	dm_zoned_unlock_zone(dzone, flags);
+
+	dm_zoned_bio_end(bioctx->bio, err);
+
+	bio_put(bio);
+
+}
+
+/**
+ * Issue a request to process a BIO.
+ * Processing of the BIO may be partial.
+ */
+static int
+dm_zoned_submit_zone_bio(struct dm_zoned_target *dzt,
+			 struct dm_zoned_zone *zone,
+			 struct bio *dzt_bio,
+			 sector_t chunk_block,
+			 unsigned int nr_blocks)
+{
+	struct dm_zoned_bioctx *bioctx
+		= dm_per_bio_data(dzt_bio, sizeof(struct dm_zoned_bioctx));
+	unsigned int nr_sectors = dm_zoned_block_to_sector(nr_blocks);
+	unsigned int size = nr_sectors << SECTOR_SHIFT;
+	struct dm_zoned_zone *dzone = bioctx->dzone;
+	unsigned long flags;
+	struct bio *clone;
+
+	dm_zoned_dev_assert(dzt, size != 0);
+	dm_zoned_dev_assert(dzt, size <= dzt_bio->bi_iter.bi_size);
+
+	clone = bio_clone_fast(dzt_bio, GFP_NOIO, dzt->bio_set);
+	if (!clone)
+		return -ENOMEM;
+
+	/* Setup the clone */
+	clone->bi_bdev = dzt->zbd;
+	clone->bi_rw = dzt_bio->bi_rw;
+	clone->bi_iter.bi_sector = dm_zoned_zone_start_sector(zone)
+		+ dm_zoned_block_to_sector(chunk_block);
+	clone->bi_iter.bi_size = size;
+	clone->bi_end_io = dm_zoned_bio_end_io;
+	clone->bi_private = bioctx;
+
+	bio_advance(dzt_bio, size);
+
+	/* Submit the clone */
+	dm_zoned_lock_zone(dzone, flags);
+	if (atomic_inc_return(&dzone->zwork->bio_count) == 1)
+		set_bit(DM_ZONE_ACTIVE_BIO, &dzone->flags);
+	atomic_inc(&bioctx->ref);
+	dm_zoned_unlock_zone(dzone, flags);
+	generic_make_request(clone);
+
+	return 0;
+}
+
+/**
+ * Zero out blocks of a read BIO buffers.
+ */
+static void
+dm_zoned_handle_read_zero(struct dm_zoned_target *dzt,
+			  struct dm_zoned_zone *zone,
+			  struct bio *bio,
+			  sector_t chunk_block,
+			  unsigned int nr_blocks)
+{
+	unsigned int size = nr_blocks << DM_ZONED_BLOCK_SHIFT;
+
+#ifdef __DM_ZONED_DEBUG
+	if (zone)
+		dm_zoned_dev_debug(dzt, "=> ZERO READ chunk %zu -> zone %lu, block %zu, %u blocks\n",
+				 dm_zoned_bio_chunk(dzt, bio),
+				 zone->id,
+				 chunk_block,
+				 nr_blocks);
+	else
+		dm_zoned_dev_debug(dzt, "=> ZERO READ unmapped chunk %zu, block %zu, %u blocks\n",
+				 dm_zoned_bio_chunk(dzt, bio),
+				 chunk_block,
+				 nr_blocks);
+#endif
+
+	dm_zoned_dev_assert(dzt, size != 0);
+	dm_zoned_dev_assert(dzt, size <= bio->bi_iter.bi_size);
+	dm_zoned_dev_assert(dzt, bio_data_dir(bio) == READ);
+
+	/* Clear nr_blocks */
+	swap(bio->bi_iter.bi_size, size);
+	zero_fill_bio(bio);
+	swap(bio->bi_iter.bi_size, size);
+
+	bio_advance(bio, size);
+}
+
+/**
+ * Issue a read request or zero out blocks buffers
+ * to process an entire or part of a read BIO.
+ */
+static int
+dm_zoned_handle_read_bio(struct dm_zoned_target *dzt,
+			 struct dm_zoned_zone *zone,
+			 struct bio *bio,
+			 sector_t chunk_block,
+			 unsigned int nr_blocks)
+{
+
+	dm_zoned_dev_debug(dzt, "=> %s READ zone %lu, block %zu, %u blocks\n",
+			 (dm_zoned_zone_buf(zone) ? "BUF" : "SMR"),
+			 zone->id,
+			 chunk_block,
+			 nr_blocks);
+
+	if (!nr_blocks)
+		return -EIO;
+
+	/* Submit read */
+	return dm_zoned_submit_zone_bio(dzt, zone, bio, chunk_block, nr_blocks);
+}
+
+/**
+ * Process a read BIO.
+ */
+static int
+dm_zoned_handle_read(struct dm_zoned_target *dzt,
+		     struct dm_zoned_zone *zone,
+		     struct bio *bio)
+{
+	struct dm_zoned_zone *bzone;
+	sector_t chunk_block = dm_zoned_bio_chunk_block(dzt, bio);
+	unsigned int nr_blocks = dm_zoned_bio_blocks(bio);
+	sector_t end_block = chunk_block + nr_blocks;
+	int ret = -EIO;
+
+	/* Read into unmapped chunks need only zeroing the BIO buffer */
+	if (!zone) {
+		dm_zoned_handle_read_zero(dzt, NULL, bio, chunk_block, nr_blocks);
+		return 0;
+	}
+
+	/* If this is an empty SMR zone that is also not */
+	/* buffered, all its blocks are invalid.         */
+	bzone = zone->bzone;
+	if (!bzone && dm_zoned_zone_is_smr(zone) && dm_zoned_zone_empty(zone)) {
+		dm_zoned_handle_read_zero(dzt, zone, bio, chunk_block, nr_blocks);
+		return 0;
+	}
+
+	/* Check block validity to determine the read location  */
+	while (chunk_block < end_block) {
+
+		if (dm_zoned_zone_is_cmr(zone)
+		    || chunk_block < zone->wp_block) {
+			/* Test block validity in the data zone */
+			ret = dm_zoned_block_valid(dzt, zone, chunk_block);
+			if (ret < 0)
+				return ret;
+			if (ret > 0) {
+				/* Read data zone blocks */
+				nr_blocks = min_t(unsigned int, ret,
+						  end_block - chunk_block);
+				ret = dm_zoned_handle_read_bio(dzt, zone, bio,
+							       chunk_block,
+							       nr_blocks);
+				if (ret < 0)
+					return ret;
+				chunk_block += nr_blocks;
+				continue;
+			}
+		}
+
+		/* Check the buffer zone, if there is one */
+		if (bzone) {
+			ret = dm_zoned_block_valid(dzt, bzone, chunk_block);
+			if (ret < 0)
+				return ret;
+			if (ret > 0) {
+				/* Read buffer zone blocks */
+				nr_blocks = min_t(unsigned int, ret,
+						  end_block - chunk_block);
+				ret = dm_zoned_handle_read_bio(dzt, bzone, bio,
+							       chunk_block,
+							       nr_blocks);
+				if (ret < 0)
+					return ret;
+				chunk_block += nr_blocks;
+				continue;
+			}
+		}
+
+		/* No valid block: zeroout the block in the BIO */
+		dm_zoned_handle_read_zero(dzt, zone, bio, chunk_block, 1);
+		chunk_block++;
+
+	}
+
+	return 0;
+}
+
+/**
+ * Write blocks in the buffer zone of @zone.
+ * If no buffer zone is assigned yet, get one.
+ * Called with @zone write locked.
+ */
+static int
+dm_zoned_handle_buffered_write(struct dm_zoned_target *dzt,
+			       struct dm_zoned_zone *zone,
+			       struct bio *bio,
+			       sector_t chunk_block,
+			       unsigned int nr_blocks)
+{
+	struct dm_zoned_zone *bzone;
+	int ret;
+
+	/* Make sure we have a buffer zone */
+	bzone = dm_zoned_alloc_bzone(dzt, zone);
+	if (!bzone)
+		return -EBUSY;
+
+	dm_zoned_dev_debug(dzt, "=> WRITE BUF zone %lu, block %zu, %u blocks\n",
+			 bzone->id,
+			 chunk_block,
+			 nr_blocks);
+
+	/* Submit write */
+	ret = dm_zoned_submit_zone_bio(dzt, bzone, bio, chunk_block, nr_blocks);
+	if (ret)
+		return -EIO;
+
+	/* Stats */
+	zone->mtime = jiffies;
+	zone->wr_buf_blocks += nr_blocks;
+
+	/* Validate the blocks in the buffer zone */
+	/* and invalidate in the data zone.       */
+	ret = dm_zoned_validate_blocks(dzt, bzone, chunk_block, nr_blocks);
+	if (ret == 0 && chunk_block < zone->wp_block)
+		ret = dm_zoned_invalidate_blocks(dzt, zone,
+						 chunk_block, nr_blocks);
+
+	return ret;
+}
+
+/**
+ * Write blocks directly in a data zone, at the write pointer.
+ * If a buffer zone is assigned, invalidate the blocks written
+ * in place.
+ */
+static int
+dm_zoned_handle_direct_write(struct dm_zoned_target *dzt,
+			     struct dm_zoned_zone *zone,
+			     struct bio *bio,
+			     sector_t chunk_block,
+			     unsigned int nr_blocks)
+{
+	struct dm_zoned_zone *bzone = zone->bzone;
+	int ret;
+
+	dm_zoned_dev_debug(dzt, "=> WRITE %s zone %lu, block %zu, %u blocks\n",
+			 (dm_zoned_zone_is_cmr(zone) ? "CMR" : "SMR"),
+			 zone->id,
+			 chunk_block,
+			 nr_blocks);
+
+	/* Submit write */
+	ret = dm_zoned_submit_zone_bio(dzt, zone, bio, chunk_block, nr_blocks);
+	if (ret)
+		return -EIO;
+
+	if (dm_zoned_zone_is_smr(zone))
+		zone->wp_block += nr_blocks;
+
+	/* Stats */
+	zone->mtime = jiffies;
+	zone->wr_dir_blocks += nr_blocks;
+
+	/* Validate the blocks in the data zone */
+	/* and invalidate in the buffer zone.   */
+	ret = dm_zoned_validate_blocks(dzt, zone, chunk_block, nr_blocks);
+	if (ret == 0 && bzone) {
+		dm_zoned_dev_assert(dzt, dm_zoned_zone_is_smr(zone));
+		ret = dm_zoned_invalidate_blocks(dzt, bzone,
+						 chunk_block, nr_blocks);
+	}
+
+	return ret;
+}
+
+/**
+ * Determine if an unaligned write in an SMR zone can be aligned.
+ * If yes, advance the zone write pointer.
+ */
+static int
+dm_zoned_align_write(struct dm_zoned_target *dzt,
+		     struct dm_zoned_zone *dzone,
+		     sector_t chunk_block)
+{
+	sector_t hole_blocks;
+
+	if (!test_bit(DM_ZONED_ALIGN_WP, &dzt->flags))
+		return 0;
+
+	hole_blocks = chunk_block - dzone->wp_block;
+	if (dzone->bzone || hole_blocks > dzt->align_wp_max_blocks)
+		return 0;
+
+	return dm_zoned_advance_zone_wp(dzt, dzone, hole_blocks) == 0;
+}
+
+/**
+ * Process a write BIO.
+ */
+static int
+dm_zoned_handle_write(struct dm_zoned_target *dzt,
+		      struct dm_zoned_zone *dzone,
+		      struct bio *bio)
+{
+	unsigned int nr_blocks = dm_zoned_bio_blocks(bio);
+	sector_t chunk_block = dm_zoned_bio_chunk_block(dzt, bio);
+	int ret;
+
+	/* Write into unmapped chunks happen   */
+	/* only if we ran out of data zones... */
+	if (!dzone) {
+		dm_zoned_dev_debug(dzt, "WRITE unmapped chunk %zu, block %zu, %u blocks\n",
+				 dm_zoned_bio_chunk(dzt, bio),
+				 chunk_block,
+				 nr_blocks);
+		return -ENOSPC;
+	}
+
+	dm_zoned_dev_debug(dzt, "WRITE chunk %zu -> zone %lu, block %zu, %u blocks (wp block %zu)\n",
+			 dm_zoned_bio_chunk(dzt, bio),
+			 dzone->id,
+			 chunk_block,
+			 nr_blocks,
+			 dzone->wp_block);
+
+	if (dm_zoned_zone_readonly(dzone)) {
+		dm_zoned_dev_error(dzt, "Write to readonly zone %lu\n",
+				 dzone->id);
+		return -EROFS;
+	}
+
+	/* Write in CMR zone ? */
+	if (dm_zoned_zone_is_cmr(dzone))
+		return dm_zoned_handle_direct_write(dzt, dzone, bio,
+						    chunk_block, nr_blocks);
+
+	/* Writing to an SMR zone: direct write the part of the BIO */
+	/* that aligns with the zone write pointer and buffer write */
+	/* what cannot, which may be the entire BIO.                */
+	if (chunk_block < dzone->wp_block) {
+		unsigned int wblocks = min(nr_blocks,
+			(unsigned int)(dzone->wp_block - chunk_block));
+		ret = dm_zoned_handle_buffered_write(dzt, dzone, bio,
+						     chunk_block, wblocks);
+		if (ret)
+			goto out;
+		nr_blocks -= wblocks;
+		chunk_block += wblocks;
+	}
+
+	if (nr_blocks) {
+		if (chunk_block == dzone->wp_block)
+			ret = dm_zoned_handle_direct_write(dzt, dzone, bio,
+							   chunk_block,
+							   nr_blocks);
+		else {
+			/*
+			 * Writing after the write pointer: try to align
+			 * the write if the zone is not already buffered.
+			 * If that fails, fallback to buffered write.
+			 */
+			if (dm_zoned_align_write(dzt, dzone, chunk_block)) {
+				ret = dm_zoned_handle_direct_write(dzt, dzone,
+								   bio,
+								   chunk_block,
+								   nr_blocks);
+				if (ret == 0)
+					goto out;
+			}
+			ret = dm_zoned_handle_buffered_write(dzt, dzone, bio,
+							     chunk_block,
+							     nr_blocks);
+		}
+	}
+
+out:
+	dm_zoned_validate_bzone(dzt, dzone);
+
+	return ret;
+}
+
+static int
+dm_zoned_handle_discard(struct dm_zoned_target *dzt,
+			struct dm_zoned_zone *zone,
+			struct bio *bio)
+{
+	struct dm_zoned_zone *bzone;
+	unsigned int nr_blocks = dm_zoned_bio_blocks(bio);
+	sector_t chunk_block = dm_zoned_bio_chunk_block(dzt, bio);
+	int ret;
+
+	/* For discard into unmapped chunks, there is nothing to do */
+	if (!zone) {
+		dm_zoned_dev_debug(dzt, "DISCARD unmapped chunk %zu, block %zu, %u blocks\n",
+				 dm_zoned_bio_chunk(dzt, bio),
+				 chunk_block,
+				 nr_blocks);
+		return 0;
+	}
+
+	dm_zoned_dev_debug(dzt, "DISCARD chunk %zu -> zone %lu, block %zu, %u blocks\n",
+			 dm_zoned_bio_chunk(dzt, bio),
+			 zone->id,
+			 chunk_block,
+			 nr_blocks);
+
+	if (dm_zoned_zone_readonly(zone)) {
+		dm_zoned_dev_error(dzt, "Discard in readonly zone %lu\n",
+				 zone->id);
+		return -EROFS;
+	}
+
+	/* Wait for all ongoing write I/Os to complete */
+	dm_zoned_wait_for_stable_zone(zone);
+
+	/* Invalidate blocks in the data zone. If a */
+	/* buffer zone is assigned, do the same.    */
+	/* The data zone write pointer may be reset */
+	bzone = zone->bzone;
+	if (bzone) {
+		ret = dm_zoned_invalidate_blocks(dzt, bzone,
+						 chunk_block, nr_blocks);
+		if (ret)
+			goto out;
+	}
+
+	/* If this is an empty SMR zone, there is nothing to do */
+	if (!dm_zoned_zone_is_smr(zone) ||
+	    !dm_zoned_zone_empty(zone))
+		ret = dm_zoned_invalidate_blocks(dzt, zone,
+						 chunk_block, nr_blocks);
+
+out:
+	dm_zoned_validate_bzone(dzt, zone);
+	dm_zoned_validate_dzone(dzt, zone);
+
+	return ret;
+}
+
+/**
+ * Process a data zone IO.
+ * Return 1 if the BIO was processed.
+ */
+static void
+dm_zoned_handle_zone_bio(struct dm_zoned_target *dzt,
+			 struct dm_zoned_zone *dzone,
+			 struct bio *bio)
+{
+	int ret;
+
+	/* Process the BIO */
+	if (bio_data_dir(bio) == READ)
+		ret = dm_zoned_handle_read(dzt, dzone, bio);
+	else if (bio->bi_rw & REQ_DISCARD)
+		ret = dm_zoned_handle_discard(dzt, dzone, bio);
+	else if (bio->bi_rw & REQ_WRITE)
+		ret = dm_zoned_handle_write(dzt, dzone, bio);
+	else {
+		dm_zoned_dev_error(dzt, "Unknown BIO type 0x%lx\n",
+				 bio->bi_rw);
+		ret = -EIO;
+	}
+
+	if (ret != -EBUSY)
+		dm_zoned_bio_end(bio, ret);
+
+	return;
+}
+
+/**
+ * Zone I/O work function.
+ */
+void
+dm_zoned_zone_work(struct work_struct *work)
+{
+	struct dm_zoned_zwork *zwork =
+		container_of(work, struct dm_zoned_zwork, work);
+	struct dm_zoned_zone *dzone = zwork->dzone;
+	struct dm_zoned_target *dzt = zwork->target;
+	int n = DM_ZONE_WORK_MAX_BIO;
+	unsigned long flags;
+	struct bio *bio;
+
+	dm_zoned_lock_zone(dzone, flags);
+
+	dm_zoned_dev_assert(dzt, dzone->zwork == zwork);
+
+	while (n && bio_list_peek(&zwork->bio_list)) {
+
+		/* Process the first BIO in the list */
+		bio = bio_list_pop(&zwork->bio_list);
+		dm_zoned_unlock_zone(dzone, flags);
+
+		dm_zoned_handle_zone_bio(dzt, dzone, bio);
+
+		dm_zoned_lock_zone(dzone, flags);
+		if (test_bit(DM_ZONE_ACTIVE_WAIT, &dzone->flags)) {
+			bio_list_add_head(&zwork->bio_list, bio);
+			break;
+		}
+
+		n--;
+
+	}
+
+	dm_zoned_run_dzone(dzt, dzone);
+
+	dm_zoned_unlock_zone(dzone, flags);
+
+	dm_zoned_put_dzone(dzt, dzone);
+}
+
+/**
+ * Process a flush request. Device mapper core
+ * ensures that no other I/O is in flight. So just
+ * propagate the flush to the backend and sync metadata.
+ */
+static void
+dm_zoned_handle_flush(struct dm_zoned_target *dzt,
+		      struct bio *bio)
+{
+
+	dm_zoned_dev_debug(dzt, "FLUSH (%d active zones, %d wait active zones)\n",
+			 atomic_read(&dzt->dz_nr_active),
+			 atomic_read(&dzt->dz_nr_active_wait));
+
+	dm_zoned_bio_end(bio, dm_zoned_flush(dzt));
+}
+
+/**
+ * Flush work.
+ */
+static void
+dm_zoned_flush_work(struct work_struct *work)
+{
+	struct dm_zoned_target *dzt =
+		container_of(work, struct dm_zoned_target, flush_work);
+	struct bio *bio;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dzt->flush_lock, flags);
+	while ((bio = bio_list_pop(&dzt->flush_list))) {
+		spin_unlock_irqrestore(&dzt->flush_lock, flags);
+		dm_zoned_handle_flush(dzt, bio);
+		spin_lock_irqsave(&dzt->flush_lock, flags);
+	}
+	spin_unlock_irqrestore(&dzt->flush_lock, flags);
+}
+
+/*
+ * Process a new BIO.
+ * Return values:
+ *  DM_MAPIO_SUBMITTED : The target has submitted the bio request.
+ *  DM_MAPIO_REMAPPED  : Bio request is remapped, device mapper should submit bio.
+ *  DM_MAPIO_REQUEUE   : Request that the BIO be submitted again.
+ */
+static int
+dm_zoned_map(struct dm_target *ti,
+	     struct bio *bio)
+{
+	struct dm_zoned_target *dzt = ti->private;
+	struct dm_zoned_bioctx *bioctx
+		= dm_per_bio_data(bio, sizeof(struct dm_zoned_bioctx));
+	unsigned int nr_sectors = dm_zoned_bio_sectors(bio);
+	struct dm_zoned_zone *dzone;
+	sector_t chunk_sector;
+	unsigned long flags;
+
+	bio->bi_bdev = dzt->zbd;
+	if (!nr_sectors && !(bio->bi_rw & REQ_FLUSH)) {
+		bio->bi_bdev = dzt->zbd;
+		return DM_MAPIO_REMAPPED;
+	}
+
+	/* The BIO should be block aligned */
+	if ((nr_sectors & DM_ZONED_BLOCK_SECTORS_MASK) ||
+	    (dm_zoned_bio_sector(bio) & DM_ZONED_BLOCK_SECTORS_MASK)) {
+		dm_zoned_dev_error(dzt, "Unaligned BIO sector %zu, len %u\n",
+				 dm_zoned_bio_sector(bio),
+				 nr_sectors);
+		return -EIO;
+	}
+
+	dzt->last_bio_time = jiffies;
+
+	/* Initialize the IO context */
+	bioctx->target = dzt;
+	bioctx->dzone = NULL;
+	bioctx->bio = bio;
+	atomic_set(&bioctx->ref, 1);
+	bioctx->error = 0;
+
+	/* Set the BIO pending in the flush list */
+	if (bio->bi_rw & REQ_FLUSH) {
+		spin_lock_irqsave(&dzt->flush_lock, flags);
+		bio_list_add(&dzt->flush_list, bio);
+		spin_unlock_irqrestore(&dzt->flush_lock, flags);
+		queue_work(dzt->flush_wq, &dzt->flush_work);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	/* Split zone BIOs to fit entirely into a zone */
+	chunk_sector = dm_zoned_bio_chunk_sector(dzt, bio);
+	if (chunk_sector + nr_sectors > dzt->zone_nr_sectors)
+		dm_accept_partial_bio(bio, dzt->zone_nr_sectors - chunk_sector);
+
+	dm_zoned_dev_debug(dzt, "BIO sector %zu, len %u -> chunk %zu\n",
+			 dm_zoned_bio_sector(bio),
+			 dm_zoned_bio_sectors(bio),
+			 dm_zoned_bio_chunk(dzt, bio));
+
+	/* Get the zone mapping the chunk the BIO belongs to. */
+	/* If the chunk is unmapped, process the BIO directly */
+	/* without going through the zone work.               */
+	dzone = dm_zoned_bio_map(dzt, bio);
+	if (IS_ERR(dzone))
+		return PTR_ERR(dzone);
+	if (!dzone)
+		dm_zoned_handle_zone_bio(dzt, NULL, bio);
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+/**
+ * Parse dmsetup arguments.
+ */
+static int
+dm_zoned_parse_args(struct dm_target *ti,
+		    struct dm_arg_set *as,
+		    struct dm_zoned_target_config *conf)
+{
+	const char *arg;
+	int ret = 0;
+
+	/* Check arguments */
+	if (as->argc < 1) {
+		ti->error = "No target device specified";
+		return -EINVAL;
+	}
+
+	/* Set defaults */
+	conf->dev_path = (char *) dm_shift_arg(as);
+	conf->format = 0;
+	conf->nr_buf_zones = DM_ZONED_NR_BZONES;
+	conf->align_wp = DM_ZONED_ALIGN_WP_MAX_BLOCK;
+	conf->debug = 0;
+
+	while (as->argc) {
+
+		arg = dm_shift_arg(as);
+
+		if (strcmp(arg, "debug") == 0) {
+#ifdef __DM_ZONED_DEBUG
+			dm_zoned_info("Debug messages enabled\n");
+			conf->debug = 1;
+#else
+			dm_zoned_info("Debug message support not enabled: ignoring option \"debug\"\n");
+#endif
+			continue;
+		}
+
+		if (strcmp(arg, "format") == 0) {
+			conf->format = 1;
+			continue;
+		}
+
+		if (strncmp(arg, "num_bzones=", 11) == 0) {
+			if (kstrtoul(arg + 11, 0, &conf->nr_buf_zones) < 0) {
+				ti->error = "Invalid number of buffer zones";
+				break;
+			}
+			continue;
+		}
+
+		if (strncmp(arg, "align_wp=", 9) == 0) {
+			if (kstrtoul(arg + 9, 0, &conf->align_wp) < 0) {
+				ti->error = "Invalid number of blocks";
+				break;
+			}
+			continue;
+		}
+
+		ti->error = "Unknown argument";
+		return -EINVAL;
+
+	}
+
+	return ret;
+
+}
+
+/**
+ * Setup target.
+ */
+static int
+dm_zoned_ctr(struct dm_target *ti,
+	     unsigned int argc,
+	     char **argv)
+{
+	struct dm_zoned_target_config conf;
+	struct dm_zoned_target *dzt;
+	struct dm_arg_set as;
+	char wq_name[32];
+	int ret;
+
+	/* Parse arguments */
+	as.argc = argc;
+	as.argv = argv;
+	ret = dm_zoned_parse_args(ti, &as, &conf);
+	if (ret)
+		return ret;
+
+	dm_zoned_info("Intializing device %s\n", conf.dev_path);
+
+	/* Allocate and initialize the target descriptor */
+	dzt = kzalloc(sizeof(struct dm_zoned_target), GFP_KERNEL);
+	if (!dzt) {
+		ti->error = "Allocate target descriptor failed";
+		return -ENOMEM;
+	}
+	dm_zoned_account_mem(dzt, sizeof(struct dm_zoned_target));
+
+	/* Get the target device */
+	ret = dm_get_device(ti, conf.dev_path, dm_table_get_mode(ti->table),
+			    &dzt->ddev);
+	if (ret != 0) {
+		ti->error = "Get target device failed";
+		goto err;
+	}
+
+	dzt->zbd = dzt->ddev->bdev;
+	dzt->zbd_capacity = i_size_read(dzt->zbd->bd_inode) >> SECTOR_SHIFT;
+	if (ti->begin ||
+	    (ti->len != dzt->zbd_capacity)) {
+		ti->error = "Partial mapping not supported";
+		ret = -EINVAL;
+		goto err;
+	}
+
+	(void)bdevname(dzt->zbd, dzt->zbd_name);
+	dzt->zbdq = bdev_get_queue(dzt->zbd);
+	dzt->zbd_metablk_shift = DM_ZONED_BLOCK_SHIFT -
+		dzt->zbd->bd_inode->i_sb->s_blocksize_bits;
+	if (conf.debug)
+		set_bit(DM_ZONED_DEBUG, &dzt->flags);
+
+	mutex_init(&dzt->map_lock);
+	INIT_LIST_HEAD(&dzt->bz_lru_list);
+	INIT_LIST_HEAD(&dzt->bz_free_list);
+	INIT_LIST_HEAD(&dzt->bz_wait_list);
+	INIT_LIST_HEAD(&dzt->dz_unmap_smr_list);
+	INIT_LIST_HEAD(&dzt->dz_unmap_cmr_list);
+	INIT_LIST_HEAD(&dzt->dz_map_cmr_list);
+	INIT_LIST_HEAD(&dzt->dz_empty_list);
+	atomic_set(&dzt->dz_nr_active, 0);
+	atomic_set(&dzt->dz_nr_active_wait, 0);
+
+	dm_zoned_dev_info(dzt, "Initializing device %s\n",
+			dzt->zbd_name);
+
+	ret = dm_zoned_init_meta(dzt, &conf);
+	if (ret != 0) {
+		ti->error = "Metadata initialization failed";
+		goto err;
+	}
+
+	/* Set target (no write same support) */
+	ti->private = dzt;
+	ti->max_io_len = dzt->zone_nr_sectors << 9;
+	ti->num_flush_bios = 1;
+	ti->num_discard_bios = 1;
+	ti->num_write_same_bios = 0;
+	ti->per_io_data_size = sizeof(struct dm_zoned_bioctx);
+	ti->flush_supported = true;
+	ti->discards_supported = true;
+	ti->split_discard_bios = true;
+	ti->discard_zeroes_data_unsupported = true;
+	ti->len = dzt->zone_nr_sectors * dzt->nr_data_zones;
+
+	if (conf.align_wp) {
+		set_bit(DM_ZONED_ALIGN_WP, &dzt->flags);
+		dzt->align_wp_max_blocks = min_t(unsigned int, conf.align_wp,
+						 dzt->zone_nr_blocks > 1);
+	}
+
+	/* BIO set */
+	dzt->bio_set = bioset_create(DM_ZONED_MIN_BIOS, 0);
+	if (!dzt->bio_set) {
+		ti->error = "Create BIO set failed";
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* Zone I/O work queue */
+	snprintf(wq_name, sizeof(wq_name), "dm_zoned_zwq_%s", dzt->zbd_name);
+	dzt->zone_wq = create_workqueue(wq_name);
+	if (!dzt->zone_wq) {
+		ti->error = "Create zone workqueue failed";
+		ret = -ENOMEM;
+		goto err;
+	}
+	dm_zoned_dev_info(dzt, "Allowing at most %d zone workers\n",
+			  min_t(int, dzt->nr_buf_zones * 2, DM_ZONE_WORK_MAX));
+	workqueue_set_max_active(dzt->zone_wq,
+				 min_t(int, dzt->nr_buf_zones * 2,
+				       DM_ZONE_WORK_MAX));
+
+	/* Flush work */
+	spin_lock_init(&dzt->flush_lock);
+	bio_list_init(&dzt->flush_list);
+	INIT_WORK(&dzt->flush_work, dm_zoned_flush_work);
+	snprintf(wq_name, sizeof(wq_name), "dm_zoned_fwq_%s", dzt->zbd_name);
+	dzt->flush_wq = create_singlethread_workqueue(wq_name);
+	if (!dzt->flush_wq) {
+		ti->error = "Create flush workqueue failed";
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* Buffer zones reclaim work */
+	dzt->reclaim_client = dm_io_client_create();
+	if (IS_ERR(dzt->reclaim_client)) {
+		ti->error = "Create GC I/O client failed";
+		ret = PTR_ERR(dzt->reclaim_client);
+		dzt->reclaim_client = NULL;
+		goto err;
+	}
+	INIT_DELAYED_WORK(&dzt->reclaim_work, dm_zoned_reclaim_work);
+	snprintf(wq_name, sizeof(wq_name), "dm_zoned_rwq_%s", dzt->zbd_name);
+	dzt->reclaim_wq = create_singlethread_workqueue(wq_name);
+	if (!dzt->reclaim_wq) {
+		ti->error = "Create reclaim workqueue failed";
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	snprintf(wq_name, sizeof(wq_name), "dm_zoned_rzwq_%s", dzt->zbd_name);
+	dzt->reclaim_zwq = create_workqueue(wq_name);
+	if (!dzt->reclaim_zwq) {
+		ti->error = "Create reclaim zone workqueue failed";
+		ret = -ENOMEM;
+		goto err;
+	}
+	workqueue_set_max_active(dzt->reclaim_zwq,
+				 DM_ZONED_RECLAIM_MAX_WORKERS);
+
+	dm_zoned_dev_info(dzt,
+			  "Target device: %zu 512-byte logical sectors (%zu blocks)\n",
+			  ti->len,
+			  dm_zoned_sector_to_block(ti->len));
+
+	dzt->last_bio_time = jiffies;
+	dm_zoned_trigger_reclaim(dzt);
+
+	return 0;
+
+err:
+
+	if (dzt->ddev) {
+		if (dzt->reclaim_wq)
+			destroy_workqueue(dzt->reclaim_wq);
+		if (dzt->reclaim_client)
+			dm_io_client_destroy(dzt->reclaim_client);
+		if (dzt->flush_wq)
+			destroy_workqueue(dzt->flush_wq);
+		if (dzt->zone_wq)
+			destroy_workqueue(dzt->zone_wq);
+		if (dzt->bio_set)
+			bioset_free(dzt->bio_set);
+		dm_zoned_cleanup_meta(dzt);
+		dm_put_device(ti, dzt->ddev);
+	}
+
+	kfree(dzt);
+
+	return ret;
+
+}
+
+/**
+ * Cleanup target.
+ */
+static void
+dm_zoned_dtr(struct dm_target *ti)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	dm_zoned_dev_info(dzt, "Removing target device\n");
+
+	dm_zoned_flush(dzt);
+
+	flush_workqueue(dzt->zone_wq);
+	destroy_workqueue(dzt->zone_wq);
+
+	flush_workqueue(dzt->reclaim_zwq);
+	cancel_delayed_work_sync(&dzt->reclaim_work);
+	destroy_workqueue(dzt->reclaim_zwq);
+	destroy_workqueue(dzt->reclaim_wq);
+	dm_io_client_destroy(dzt->reclaim_client);
+
+	flush_workqueue(dzt->flush_wq);
+	destroy_workqueue(dzt->flush_wq);
+
+	bioset_free(dzt->bio_set);
+
+	dm_zoned_cleanup_meta(dzt);
+
+	dm_put_device(ti, dzt->ddev);
+
+	kfree(dzt);
+}
+
+/**
+ * Setup target request queue limits.
+ */
+static void
+dm_zoned_io_hints(struct dm_target *ti,
+		  struct queue_limits *limits)
+{
+	struct dm_zoned_target *dzt = ti->private;
+	unsigned int chunk_sectors = dzt->zone_nr_sectors;
+
+	BUG_ON(!is_power_of_2(chunk_sectors));
+
+	/* Align to zone size */
+	limits->chunk_sectors = chunk_sectors;
+	limits->max_sectors = chunk_sectors;
+
+	blk_limits_io_min(limits, DM_ZONED_BLOCK_SIZE);
+	blk_limits_io_opt(limits, DM_ZONED_BLOCK_SIZE);
+
+	limits->logical_block_size = DM_ZONED_BLOCK_SIZE;
+	limits->physical_block_size = DM_ZONED_BLOCK_SIZE;
+
+	limits->discard_alignment = DM_ZONED_BLOCK_SIZE;
+	limits->discard_granularity = DM_ZONED_BLOCK_SIZE;
+	limits->max_discard_sectors = chunk_sectors;
+	limits->max_hw_discard_sectors = chunk_sectors;
+	limits->discard_zeroes_data = true;
+
+}
+
+/**
+ * Pass on ioctl to the backend device.
+ */
+static int
+dm_zoned_prepare_ioctl(struct dm_target *ti,
+		       struct block_device **bdev,
+		       fmode_t *mode)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	*bdev = dzt->zbd;
+
+	return 0;
+}
+
+/**
+ * Stop reclaim before suspend.
+ */
+static void
+dm_zoned_presuspend(struct dm_target *ti)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	dm_zoned_dev_debug(dzt, "Pre-suspend\n");
+
+	/* Enter suspend state */
+	set_bit(DM_ZONED_SUSPENDED, &dzt->flags);
+	smp_mb__after_atomic();
+
+	/* Stop reclaim */
+	cancel_delayed_work_sync(&dzt->reclaim_work);
+}
+
+/**
+ * Restart reclaim if suspend failed.
+ */
+static void
+dm_zoned_presuspend_undo(struct dm_target *ti)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	dm_zoned_dev_debug(dzt, "Pre-suspend undo\n");
+
+	/* Clear suspend state */
+	clear_bit_unlock(DM_ZONED_SUSPENDED, &dzt->flags);
+	smp_mb__after_atomic();
+
+	/* Restart reclaim */
+	mod_delayed_work(dzt->reclaim_wq, &dzt->reclaim_work, 0);
+}
+
+/**
+ * Stop works and flush on suspend.
+ */
+static void
+dm_zoned_postsuspend(struct dm_target *ti)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	dm_zoned_dev_debug(dzt, "Post-suspend\n");
+
+	/* Stop works and flush */
+	flush_workqueue(dzt->zone_wq);
+	flush_workqueue(dzt->flush_wq);
+
+	dm_zoned_flush(dzt);
+}
+
+/**
+ * Refresh zone information before resuming.
+ */
+static int
+dm_zoned_preresume(struct dm_target *ti)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	if (!test_bit(DM_ZONED_SUSPENDED, &dzt->flags))
+		return 0;
+
+	dm_zoned_dev_debug(dzt, "Pre-resume\n");
+
+	/* Refresh zone information */
+	return dm_zoned_resume_meta(dzt);
+}
+
+/**
+ * Resume.
+ */
+static void
+dm_zoned_resume(struct dm_target *ti)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	if (!test_bit(DM_ZONED_SUSPENDED, &dzt->flags))
+		return;
+
+	dm_zoned_dev_debug(dzt, "Resume\n");
+
+	/* Clear suspend state */
+	clear_bit_unlock(DM_ZONED_SUSPENDED, &dzt->flags);
+	smp_mb__after_atomic();
+
+	/* Restart reclaim */
+	mod_delayed_work(dzt->reclaim_wq, &dzt->reclaim_work, 0);
+
+}
+
+static int
+dm_zoned_iterate_devices(struct dm_target *ti,
+			 iterate_devices_callout_fn fn,
+			 void *data)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	return fn(ti, dzt->ddev, dzt->nr_meta_zones * dzt->zone_nr_sectors,
+		  ti->len, data);
+}
+
+/**
+ * Module definition.
+ */
+static struct target_type dm_zoned_type = {
+	.name		 = "dm-zoned",
+	.version	 = {1, 0, 0},
+	.module		 = THIS_MODULE,
+	.ctr		 = dm_zoned_ctr,
+	.dtr		 = dm_zoned_dtr,
+	.map		 = dm_zoned_map,
+	.io_hints	 = dm_zoned_io_hints,
+	.prepare_ioctl	 = dm_zoned_prepare_ioctl,
+	.presuspend	 = dm_zoned_presuspend,
+	.presuspend_undo = dm_zoned_presuspend_undo,
+	.postsuspend	 = dm_zoned_postsuspend,
+	.preresume	 = dm_zoned_preresume,
+	.resume		 = dm_zoned_resume,
+	.iterate_devices = dm_zoned_iterate_devices,
+};
+
+struct kmem_cache *dm_zoned_zone_cache;
+
+static int __init dm_zoned_init(void)
+{
+	int ret;
+
+	dm_zoned_info("Version %d.%d, (C) Western Digital\n",
+		    DM_ZONED_VER_MAJ,
+		    DM_ZONED_VER_MIN);
+
+	dm_zoned_zone_cache = KMEM_CACHE(dm_zoned_zone, 0);
+	if (!dm_zoned_zone_cache)
+		return -ENOMEM;
+
+	ret = dm_register_target(&dm_zoned_type);
+	if (ret != 0) {
+		dm_zoned_error("Register dm-zoned target failed %d\n", ret);
+		kmem_cache_destroy(dm_zoned_zone_cache);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit dm_zoned_exit(void)
+{
+	dm_unregister_target(&dm_zoned_type);
+	kmem_cache_destroy(dm_zoned_zone_cache);
+}
+
+module_init(dm_zoned_init);
+module_exit(dm_zoned_exit);
+
+MODULE_DESCRIPTION(DM_NAME " target for ZBC/ZAC devices (host-managed and host-aware)");
+MODULE_AUTHOR("Damien Le Moal <damien.lemoal@hgst.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/md/dm-zoned-meta.c b/drivers/md/dm-zoned-meta.c
new file mode 100644
index 0000000..b9e5161
--- /dev/null
+++ b/drivers/md/dm-zoned-meta.c
@@ -0,0 +1,1950 @@
+/*
+ * (C) Copyright 2016 Western Digital.
+ *
+ * This software is distributed under the terms of the GNU Lesser General
+ * Public License version 2, or any later version, "as is," without technical
+ * support, and WITHOUT ANY WARRANTY, without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Author: Damien Le Moal <damien.lemoal@hgst.com>
+ */
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/slab.h>
+
+#include "dm-zoned.h"
+
+/**
+ * Free zones descriptors.
+ */
+static void
+dm_zoned_drop_zones(struct dm_zoned_target *dzt)
+{
+	struct blk_zone *blkz;
+	sector_t sector = 0;
+
+	/* Allocate and initialize zone descriptors */
+	while (sector < dzt->zbd_capacity) {
+		blkz = blk_lookup_zone(dzt->zbdq, sector);
+		if (blkz && blkz->private_data) {
+			kmem_cache_free(dm_zoned_zone_cache,
+					blkz->private_data);
+			blkz->private_data = NULL;
+		}
+		sector = blkz->start + blkz->len;
+	}
+}
+
+/**
+ * Allocate and initialize zone descriptors
+ * using the zone information from disk.
+ */
+static int
+dm_zoned_init_zones(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_zone *zone, *last_meta_zone = NULL;
+	struct blk_zone *blkz;
+	sector_t sector = 0;
+	int ret = -ENXIO;
+
+	/* Allocate and initialize zone descriptors */
+	while (sector < dzt->zbd_capacity) {
+
+		blkz = blk_lookup_zone(dzt->zbdq, sector);
+		if (!blkz) {
+			dm_zoned_dev_error(dzt,
+				"Unable to get zone at sector %zu\n",
+				sector);
+			goto out;
+		}
+
+		zone = kmem_cache_alloc(dm_zoned_zone_cache, GFP_KERNEL);
+		if (!zone) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		dm_zoned_account_mem(dzt, sizeof(struct dm_zoned_zone));
+
+		/* Assume at this stage that all zones are unmapped */
+		/* data zones. This will be corrected later using   */
+		/* the buffer and data zone mapping tables.         */
+		blkz->private_data = zone;
+		INIT_LIST_HEAD(&zone->link);
+		INIT_LIST_HEAD(&zone->elink);
+		zone->id = dzt->nr_zones;
+		zone->blkz = blkz;
+		zone->flags = DM_ZONE_DATA;
+		zone->zwork = NULL;
+		zone->map = DM_ZONED_MAP_UNMAPPED;
+		zone->bzone = NULL;
+
+		if (!dzt->nr_zones)
+			dzt->zone_nr_sectors = blkz->len;
+
+		if (dm_zoned_zone_is_smr(zone)) {
+			zone->wp_block = dm_zoned_sector_to_block(blkz->wp)
+				- dm_zoned_zone_start_block(zone);
+			list_add_tail(&zone->link, &dzt->dz_unmap_smr_list);
+			dzt->nr_smr_zones++;
+		} else {
+			zone->wp_block = 0;
+			list_add_tail(&zone->link, &dzt->dz_unmap_cmr_list);
+			dzt->nr_cmr_zones++;
+		}
+
+		dm_zoned_zone_reset_stats(zone);
+
+		if (dm_zoned_zone_is_rnd(zone)) {
+			dzt->nr_rnd_zones++;
+			if ((!last_meta_zone) ||
+			    dm_zoned_zone_next_sector(last_meta_zone) ==
+			    sector) {
+				dzt->nr_meta_zones++;
+				last_meta_zone = zone;
+			}
+		}
+
+		dzt->nr_zones++;
+		sector = dm_zoned_zone_next_sector(zone);
+
+	}
+
+	if (!dzt->nr_zones) {
+		dm_zoned_dev_error(dzt, "No zones information\n");
+		goto out;
+	}
+
+	if (!dzt->nr_rnd_zones) {
+		dm_zoned_dev_error(dzt, "No randomly writable zones found\n");
+		goto out;
+	}
+
+	if (!dzt->nr_meta_zones) {
+		dm_zoned_dev_error(dzt, "No metadata zones found\n");
+		goto out;
+	}
+
+	/* Temporaray ? We can make it work for any zone size... */
+	if (!is_power_of_2(dzt->zone_nr_sectors)) {
+		dm_zoned_dev_error(dzt,
+			"Sectors per zone %zu is not a power of 2\n",
+			dzt->zone_nr_sectors);
+		goto out;
+	}
+
+	dzt->zone_nr_sectors_shift = ilog2(dzt->zone_nr_sectors);
+	dzt->zone_nr_sectors_mask = dzt->zone_nr_sectors - 1;
+
+	dzt->zone_nr_blocks = dm_zoned_sector_to_block(dzt->zone_nr_sectors);
+	dzt->zone_nr_blocks_shift = ilog2(dzt->zone_nr_blocks);
+	dzt->zone_nr_blocks_mask = dzt->zone_nr_blocks - 1;
+
+	dzt->zone_bitmap_size = dzt->zone_nr_blocks >> 3;
+	dzt->zone_nr_bitmap_blocks = dzt->zone_bitmap_size >>
+		DM_ZONED_BLOCK_SHIFT;
+
+	ret = 0;
+
+out:
+
+	if (ret != 0)
+		dm_zoned_drop_zones(dzt);
+
+	return ret;
+}
+
+/**
+ * Check zone information after a resume.
+ */
+static int
+dm_zoned_check_zones(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_zone *zone;
+	struct blk_zone *blkz;
+	sector_t sector = 0;
+	sector_t wp_block;
+
+	/* Allocate and initialize zone descriptors */
+	while (sector < dzt->zbd_capacity) {
+
+		blkz = blk_lookup_zone(dzt->zbdq, sector);
+		if (!blkz) {
+			dm_zoned_dev_error(dzt,
+				"Unable to get zone at sector %zu\n", sector);
+			return -EIO;
+		}
+
+		zone = blkz->private_data;
+		if (!zone) {
+			dm_zoned_dev_error(dzt,
+				"Lost private data of zone at sector %zu\n",
+				sector);
+			return -EIO;
+		}
+
+		if (zone->blkz != blkz) {
+			dm_zoned_dev_error(dzt,
+				"Inconsistent private data of zone at sector %zu\n",
+				sector);
+			return -EIO;
+		}
+
+		wp_block = dm_zoned_sector_to_block(blkz->wp) -
+			dm_zoned_zone_start_block(zone);
+		if (!dm_zoned_zone_is_smr(zone))
+			zone->wp_block = 0;
+		else if (zone->wp_block != wp_block) {
+			dm_zoned_dev_error(dzt,
+				"Zone %lu: Inconsistent write pointer position (%zu / %zu)\n",
+				zone->id, zone->wp_block, wp_block);
+			zone->wp_block = wp_block;
+			dm_zoned_invalidate_blocks(dzt, zone, zone->wp_block,
+				dzt->zone_nr_blocks - zone->wp_block);
+			dm_zoned_validate_dzone(dzt, zone);
+		}
+
+		sector = dm_zoned_zone_next_sector(zone);
+
+	}
+
+	return 0;
+}
+
+/**
+ * Lookup a zone containing the specified sector.
+ */
+static inline struct dm_zoned_zone *
+dm_zoned_lookup_zone(struct dm_zoned_target *dzt,
+		     sector_t sector)
+{
+	struct blk_zone *blkz = blk_lookup_zone(dzt->zbdq, sector);
+
+	return blkz ? blkz->private_data : NULL;
+}
+
+/**
+ * Lookup a zone using a zone ID.
+ */
+static inline struct dm_zoned_zone *
+dm_zoned_lookup_zone_by_id(struct dm_zoned_target *dzt,
+			   unsigned int zone_id)
+{
+	return dm_zoned_lookup_zone(dzt, (sector_t)zone_id <<
+				    dzt->zone_nr_sectors_shift);
+}
+
+/**
+ * Set a zone write pointer.
+ */
+int
+dm_zoned_advance_zone_wp(struct dm_zoned_target *dzt,
+			 struct dm_zoned_zone *zone,
+			 sector_t nr_blocks)
+{
+	int ret;
+
+	if (!dm_zoned_zone_is_smr(zone) ||
+	    zone->wp_block + nr_blocks > dm_zoned_zone_next_block(zone))
+		return -EIO;
+
+	/* Zeroout the space between the write */
+	/* pointer and the requested position. */
+	ret = blkdev_issue_zeroout(dzt->zbd,
+		dm_zoned_block_to_sector(dm_zoned_zone_start_block(zone) +
+					 zone->wp_block),
+		dm_zoned_block_to_sector(nr_blocks), GFP_KERNEL, false);
+	if (ret) {
+		dm_zoned_dev_error(dzt,
+			"Advance zone %lu wp block %zu by %zu blocks failed %d\n",
+			zone->id, zone->wp_block, nr_blocks, ret);
+		return ret;
+	}
+
+	zone->wp_block += nr_blocks;
+
+	return 0;
+}
+
+/**
+ * Reset a zone write pointer.
+ */
+int
+dm_zoned_reset_zone_wp(struct dm_zoned_target *dzt,
+		       struct dm_zoned_zone *zone)
+{
+	int ret;
+
+	/* Ignore offline zones, read only zones, */
+	/* CMR zones and empty SMR zones.         */
+	if (dm_zoned_zone_offline(zone)
+	    || dm_zoned_zone_readonly(zone)
+	    || dm_zoned_zone_is_cmr(zone)
+	    || dm_zoned_zone_empty(zone))
+		return 0;
+
+	/* Discard the zone */
+	ret = blkdev_issue_discard(dzt->zbd,
+				   dm_zoned_zone_start_sector(zone),
+				   dm_zoned_zone_sectors(zone),
+				   GFP_KERNEL, 0);
+	if (ret) {
+		dm_zoned_dev_error(dzt, "Reset zone %lu failed %d\n",
+				 zone->id, ret);
+		return ret;
+	}
+
+	/* Rewind */
+	zone->wp_block = 0;
+
+	return 0;
+}
+
+/**
+ * Reset all zones write pointer.
+ */
+static int
+dm_zoned_reset_zones(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_zone *zone;
+	sector_t sector = 0;
+	int ret = 0;
+
+	dm_zoned_dev_debug(dzt, "Resetting all zones\n");
+
+	while ((zone = dm_zoned_lookup_zone(dzt, sector))) {
+		ret = dm_zoned_reset_zone_wp(dzt, zone);
+		if (ret)
+			return ret;
+		sector = dm_zoned_zone_next_sector(zone);
+	}
+
+	return 0;
+}
+
+/**
+ * Get from cache or read from disk a metadata block.
+ */
+static struct buffer_head *
+dm_zoned_get_meta(struct dm_zoned_target *dzt,
+		  sector_t block)
+{
+	struct buffer_head *bh;
+
+	/* Get block */
+	bh = __bread(dzt->zbd,
+		     block << dzt->zbd_metablk_shift,
+		     DM_ZONED_BLOCK_SIZE);
+	if (!bh) {
+		dm_zoned_dev_error(dzt, "Read block %zu failed\n",
+				 block);
+		return ERR_PTR(-EIO);
+	}
+
+	return bh;
+}
+
+/**
+ * Mark a metadata block dirty.
+ */
+static inline void
+dm_zoned_dirty_meta(struct dm_zoned_target *dzt,
+		    struct buffer_head *bh)
+{
+	mark_buffer_dirty_inode(bh, dzt->zbd->bd_inode);
+}
+
+/**
+ * Zero fill a metadata block.
+ */
+static int
+dm_zoned_zero_meta(struct dm_zoned_target *dzt,
+		   sector_t block)
+{
+	struct buffer_head *bh = dm_zoned_get_meta(dzt, block);
+
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
+
+	memset(bh->b_data, 0, DM_ZONED_BLOCK_SIZE);
+	dm_zoned_dirty_meta(dzt, bh);
+	__brelse(bh);
+
+	return 0;
+}
+
+/**
+ * Flush dirty meta-data.
+ */
+int
+dm_zoned_flush(struct dm_zoned_target *dzt)
+{
+	int ret;
+
+	/* Sync meta-data */
+	ret = sync_mapping_buffers(dzt->zbd->bd_inode->i_mapping);
+	if (ret) {
+		dm_zoned_dev_error(dzt, "Sync metadata failed %d\n", ret);
+		return ret;
+	}
+
+	/* Flush drive cache (this will also sync data) */
+	return blkdev_issue_flush(dzt->zbd, GFP_KERNEL, NULL);
+}
+
+/**
+ * Format buffer zone mapping.
+ */
+static int
+dm_zoned_format_bzone_mapping(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_super *sb =
+		(struct dm_zoned_super *) dzt->sb_bh->b_data;
+	struct dm_zoned_zone *zone;
+	int z, b = 0;
+
+	/* Set buffer zones mapping entries */
+	dzt->bz_map = sb->bz_map;
+	for (z = dzt->nr_meta_zones;
+	     (z < dzt->nr_zones) && (b < dzt->nr_buf_zones); z++) {
+		zone = dm_zoned_lookup_zone_by_id(dzt, z);
+		if (!zone)
+			return -ENXIO;
+		if (dm_zoned_zone_is_rnd(zone)) {
+			dzt->bz_map[b].bzone_id = cpu_to_le32(zone->id);
+			dzt->bz_map[b].dzone_id =
+				cpu_to_le32(DM_ZONED_MAP_UNMAPPED);
+			b++;
+		}
+	}
+
+	if (b < dzt->nr_buf_zones) {
+		dm_zoned_dev_error(dzt,
+			"Broken format: %d/%u buffer zones set\n",
+			b, dzt->nr_buf_zones);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+/**
+ * Initialize buffer zone mapping.
+ */
+static int
+dm_zoned_load_bzone_mapping(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_super *sb =
+		(struct dm_zoned_super *) dzt->sb_bh->b_data;
+	struct dm_zoned_zone *bzone, *dzone;
+	unsigned long bzone_id, dzone_id;
+	int i, b = 0;
+
+	/* Process buffer zones mapping entries */
+	dzt->bz_map = sb->bz_map;
+	for (i = 0; i < dzt->nr_buf_zones; i++) {
+
+		bzone_id = le32_to_cpu(dzt->bz_map[i].bzone_id);
+		if (!bzone_id || bzone_id >= dzt->nr_zones) {
+			dm_zoned_dev_error(dzt,
+				"Invalid buffer zone %lu in mapping table entry %d\n",
+				bzone_id, i);
+			return -ENXIO;
+		}
+
+		bzone = dm_zoned_lookup_zone_by_id(dzt, bzone_id);
+		if (!bzone) {
+			dm_zoned_dev_error(dzt, "Buffer zone %lu not found\n",
+					   bzone_id);
+			return -ENXIO;
+		}
+
+		/* Fix the zone type */
+		bzone->flags = DM_ZONE_BUF;
+		list_del_init(&bzone->link);
+		bzone->map = i;
+
+		dzone_id = le32_to_cpu(dzt->bz_map[i].dzone_id);
+		if (dzone_id != DM_ZONED_MAP_UNMAPPED) {
+			if (dzone_id >= dzt->nr_zones) {
+				dm_zoned_dev_error(dzt,
+					"Invalid data zone %lu in mapping table entry %d\n",
+					dzone_id, i);
+				return -ENXIO;
+			}
+			dzone = dm_zoned_lookup_zone_by_id(dzt, dzone_id);
+			if (!dzone) {
+				dm_zoned_dev_error(dzt,
+					"Data zone %lu not found\n", dzone_id);
+				return -ENXIO;
+			}
+		} else
+			dzone = NULL;
+
+		if (dzone) {
+			dm_zoned_dev_debug(dzt,
+				"Zone %lu is buffering zone %lu\n",
+				bzone->id, dzone->id);
+			dzone->bzone = bzone;
+			bzone->bzone = dzone;
+			list_add_tail(&bzone->link, &dzt->bz_lru_list);
+		} else {
+			list_add_tail(&bzone->link, &dzt->bz_free_list);
+			atomic_inc(&dzt->bz_nr_free);
+		}
+
+		b++;
+
+	}
+
+	if (b != dzt->nr_buf_zones) {
+		dm_zoned_dev_error(dzt,
+			"Invalid buffer zone mapping (%d / %u valid entries)\n",
+			b, dzt->nr_buf_zones);
+		return -ENXIO;
+	}
+
+	dzt->bz_nr_free_low = dzt->nr_buf_zones * DM_ZONED_NR_BZONES_LOW / 100;
+	if (dzt->bz_nr_free_low < DM_ZONED_NR_BZONES_LOW_MIN)
+		dzt->bz_nr_free_low = DM_ZONED_NR_BZONES_LOW_MIN;
+
+	return 0;
+}
+
+/**
+ * Set a buffer zone mapping.
+ */
+static void
+dm_zoned_set_bzone_mapping(struct dm_zoned_target *dzt,
+			   struct dm_zoned_zone *bzone,
+			   unsigned int dzone_id)
+{
+	struct dm_zoned_bz_map *bz_map = &dzt->bz_map[bzone->map];
+
+	dm_zoned_dev_assert(dzt, le32_to_cpu(bz_map->bzone_id) == bzone->id);
+
+	lock_buffer(dzt->sb_bh);
+	bz_map->dzone_id = cpu_to_le32(dzone_id);
+	dm_zoned_dirty_meta(dzt, dzt->sb_bh);
+	unlock_buffer(dzt->sb_bh);
+}
+
+/**
+ * Change a buffer zone mapping.
+ */
+static void
+dm_zoned_change_bzone_mapping(struct dm_zoned_target *dzt,
+			      struct dm_zoned_zone *bzone,
+			      struct dm_zoned_zone *new_bzone,
+			      unsigned int dzone_id)
+{
+	struct dm_zoned_bz_map *bz_map = &dzt->bz_map[bzone->map];
+
+	new_bzone->map = bzone->map;
+	bzone->map = DM_ZONED_MAP_UNMAPPED;
+
+	lock_buffer(dzt->sb_bh);
+	bz_map->bzone_id = cpu_to_le32(new_bzone->id);
+	bz_map->dzone_id = cpu_to_le32(dzone_id);
+	dm_zoned_dirty_meta(dzt, dzt->sb_bh);
+	unlock_buffer(dzt->sb_bh);
+}
+
+/**
+ * Get an unused buffer zone and associate it
+ * with @zone.
+ */
+struct dm_zoned_zone *
+dm_zoned_alloc_bzone(struct dm_zoned_target *dzt,
+		     struct dm_zoned_zone *dzone)
+{
+	struct dm_zoned_zone *bzone;
+
+	dm_zoned_map_lock(dzt);
+
+	/* If the data zone already has a buffer */
+	/* zone assigned, keep using it.         */
+	dm_zoned_dev_assert(dzt, dm_zoned_zone_data(dzone));
+	bzone = dzone->bzone;
+	if (bzone)
+		goto out;
+
+	/* If there is no free buffer zone, put the zone to wait */
+	if (!atomic_read(&dzt->bz_nr_free)) {
+		unsigned long flags;
+		dm_zoned_lock_zone(dzone, flags);
+		dm_zoned_dev_assert(dzt, test_bit(DM_ZONE_ACTIVE,
+						  &dzone->flags));
+		dm_zoned_dev_assert(dzt, dzone->zwork);
+		if (!test_and_set_bit(DM_ZONE_ACTIVE_WAIT, &dzone->flags)) {
+			list_add_tail(&dzone->zwork->link, &dzt->bz_wait_list);
+			atomic_inc(&dzt->dz_nr_active_wait);
+		}
+		dm_zoned_unlock_zone(dzone, flags);
+		dm_zoned_trigger_reclaim(dzt);
+		goto out;
+	}
+
+	/* Otherwise, get a free buffer zone */
+	bzone = list_first_entry(&dzt->bz_free_list,
+				 struct dm_zoned_zone, link);
+	list_del_init(&bzone->link);
+	list_add_tail(&bzone->link, &dzt->bz_lru_list);
+	atomic_dec(&dzt->bz_nr_free);
+	dm_zoned_schedule_reclaim(dzt, DM_ZONED_RECLAIM_PERIOD);
+
+	/* Assign the buffer zone to the data zone */
+	bzone->bzone = dzone;
+	dm_zoned_set_bzone_mapping(dzt, bzone, dzone->id);
+
+	dzone->bzone = bzone;
+	smp_mb__before_atomic();
+	set_bit(DM_ZONE_BUFFERED, &dzone->flags);
+	smp_mb__after_atomic();
+
+	dm_zoned_dev_debug(dzt, "Buffer zone %lu assigned to zone %lu\n",
+			   bzone->id, dzone->id);
+
+out:
+
+	dm_zoned_map_unlock(dzt);
+
+	return bzone;
+}
+
+/**
+ * Wake up buffer zone waiter.
+ */
+static void
+dm_zoned_wake_bzone_waiter(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_zwork *zwork;
+	struct dm_zoned_zone *dzone;
+	unsigned long flags;
+
+	if (list_empty(&dzt->bz_wait_list))
+		return;
+
+	/* Wake up the first buffer waiting zone */
+	zwork = list_first_entry(&dzt->bz_wait_list,
+				 struct dm_zoned_zwork, link);
+	list_del_init(&zwork->link);
+	dzone = zwork->dzone;
+	dm_zoned_lock_zone(dzone, flags);
+	clear_bit_unlock(DM_ZONE_ACTIVE_WAIT, &dzone->flags);
+	atomic_dec(&dzt->dz_nr_active_wait);
+	smp_mb__after_atomic();
+	dm_zoned_run_dzone(dzt, dzone);
+	dm_zoned_unlock_zone(dzone, flags);
+}
+
+/**
+ * Unmap and free the buffer zone of a data zone.
+ */
+void
+dm_zoned_free_bzone(struct dm_zoned_target *dzt,
+		    struct dm_zoned_zone *bzone)
+{
+	struct dm_zoned_zone *dzone = bzone->bzone;
+
+	dm_zoned_map_lock(dzt);
+
+	dm_zoned_dev_assert(dzt, dm_zoned_zone_buf(bzone));
+	dm_zoned_dev_assert(dzt, dzone);
+	dm_zoned_dev_assert(dzt, dm_zoned_zone_data(dzone));
+
+	/* Return the buffer zone into the free list */
+	smp_mb__before_atomic();
+	clear_bit(DM_ZONE_DIRTY, &bzone->flags);
+	clear_bit(DM_ZONE_BUFFERED, &dzone->flags);
+	smp_mb__after_atomic();
+
+	bzone->bzone = NULL;
+
+	dzone->bzone = NULL;
+	dzone->wr_buf_blocks = 0;
+
+	list_del_init(&bzone->link);
+	list_add_tail(&bzone->link, &dzt->bz_free_list);
+	atomic_inc(&dzt->bz_nr_free);
+	dm_zoned_set_bzone_mapping(dzt, bzone, DM_ZONED_MAP_UNMAPPED);
+	dm_zoned_wake_bzone_waiter(dzt);
+
+	dm_zoned_dev_debug(dzt, "Freed buffer zone %lu\n", bzone->id);
+
+	dm_zoned_map_unlock(dzt);
+}
+
+/**
+ * After a write or a discard, the buffer zone of
+ * a data zone may become entirely invalid and can be freed.
+ * Check this here.
+ */
+void
+dm_zoned_validate_bzone(struct dm_zoned_target *dzt,
+			struct dm_zoned_zone *dzone)
+{
+	struct dm_zoned_zone *bzone = dzone->bzone;
+
+	dm_zoned_dev_assert(dzt, dm_zoned_zone_data(dzone));
+	dm_zoned_dev_assert(dzt, test_bit(DM_ZONE_ACTIVE, &dzone->flags));
+
+	if (!bzone || !test_and_clear_bit(DM_ZONE_DIRTY, &bzone->flags))
+		return;
+
+	/* If all blocks are invalid, free it */
+	if (dm_zoned_zone_weight(dzt, bzone) == 0) {
+		dm_zoned_free_bzone(dzt, bzone);
+		return;
+	}
+
+	/* LRU update the list of buffered data zones */
+	dm_zoned_map_lock(dzt);
+	list_del_init(&bzone->link);
+	list_add_tail(&bzone->link, &dzt->bz_lru_list);
+	dm_zoned_map_unlock(dzt);
+}
+
+/**
+ * Format data zone mapping.
+ */
+static int
+dm_zoned_format_dzone_mapping(struct dm_zoned_target *dzt)
+{
+	struct buffer_head *map_bh;
+	unsigned int *map;
+	int i, j;
+
+	/* Zero fill the data zone mapping table */
+	for (i = 0; i < dzt->nr_map_blocks; i++) {
+		map_bh = dm_zoned_get_meta(dzt, i + 1);
+		if (IS_ERR(map_bh))
+			return PTR_ERR(map_bh);
+		map = (unsigned int *) map_bh->b_data;
+		lock_buffer(map_bh);
+		for (j = 0; j < DM_ZONED_MAP_ENTRIES_PER_BLOCK; j++)
+			map[j] = cpu_to_le32(DM_ZONED_MAP_UNMAPPED);
+		dm_zoned_dirty_meta(dzt, map_bh);
+		unlock_buffer(map_bh);
+		__brelse(map_bh);
+	}
+
+	return 0;
+}
+
+/**
+ * Cleanup resources used for the data zone mapping table.
+ */
+static void
+dm_zoned_cleanup_dzone_mapping(struct dm_zoned_target *dzt)
+{
+	int i;
+
+	/* Cleanup zone mapping resources */
+	if (!dzt->dz_map_bh)
+		return;
+
+	for (i = 0; i < dzt->nr_map_blocks; i++)
+		brelse(dzt->dz_map_bh[i]);
+
+	kfree(dzt->dz_map_bh);
+}
+
+/**
+ * Initialize data zone mapping.
+ */
+static int
+dm_zoned_load_dzone_mapping(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_zone *zone;
+	struct buffer_head *map_bh;
+	unsigned int *map;
+	unsigned long dzone_id;
+	int i, j, chunk = 0;
+	int ret = 0;
+
+	/* Data zone mapping table blocks array */
+	dzt->dz_map_bh = kzalloc(sizeof(struct buffer_head *) *
+				 dzt->nr_map_blocks, GFP_KERNEL);
+	if (!dzt->dz_map_bh)
+		return -ENOMEM;
+	dm_zoned_account_mem(dzt, sizeof(struct buffer_head *) *
+			     dzt->nr_map_blocks);
+
+	/* Get data zone mapping blocks and initialize zone mapping */
+	for (i = 0; i < dzt->nr_map_blocks; i++) {
+
+		/* Get mapping block */
+		map_bh = dm_zoned_get_meta(dzt, i + 1);
+		if (IS_ERR(map_bh)) {
+			ret = PTR_ERR(map_bh);
+			goto out;
+		}
+		dzt->dz_map_bh[i] = map_bh;
+		dm_zoned_account_mem(dzt, DM_ZONED_BLOCK_SIZE);
+
+		/* Process entries */
+		map = (unsigned int *) map_bh->b_data;
+		j = 0;
+		for (j = 0; j < DM_ZONED_MAP_ENTRIES_PER_BLOCK &&
+			    chunk < dzt->nr_data_zones; j++) {
+			dzone_id = le32_to_cpu(map[j]);
+			if (dzone_id != DM_ZONED_MAP_UNMAPPED) {
+				zone = dm_zoned_lookup_zone_by_id(dzt,
+								  dzone_id);
+				if (!zone) {
+					dm_zoned_dev_error(dzt,
+						"Mapping entry %d: zone %lu not found\n",
+						chunk, dzone_id);
+					map[j] = DM_ZONED_MAP_UNMAPPED;
+					dm_zoned_dirty_meta(dzt, map_bh);
+				} else {
+					zone->map = chunk;
+					dzt->dz_nr_unmap--;
+					list_del_init(&zone->link);
+					if (dm_zoned_zone_is_cmr(zone))
+						list_add_tail(&zone->link,
+							&dzt->dz_map_cmr_list);
+				}
+			}
+			chunk++;
+		}
+
+	}
+
+out:
+	if (ret)
+		dm_zoned_cleanup_dzone_mapping(dzt);
+
+	return ret;
+}
+
+/**
+ * Set the data zone mapping entry for a chunk of the logical disk.
+ */
+static void
+dm_zoned_set_dzone_mapping(struct dm_zoned_target *dzt,
+			   unsigned int chunk,
+			   unsigned int dzone_id)
+{
+	struct buffer_head *map_bh =
+		dzt->dz_map_bh[chunk >> DM_ZONED_MAP_ENTRIES_SHIFT];
+	unsigned int *map = (unsigned int *) map_bh->b_data;
+
+	lock_buffer(map_bh);
+	map[chunk & DM_ZONED_MAP_ENTRIES_MASK] = cpu_to_le32(dzone_id);
+	dm_zoned_dirty_meta(dzt, map_bh);
+	unlock_buffer(map_bh);
+}
+
+/**
+ * Get the data zone mapping of a chunk of the logical disk.
+ */
+static unsigned int
+dm_zoned_get_dzone_mapping(struct dm_zoned_target *dzt,
+			   unsigned int chunk)
+{
+	struct buffer_head *map_bh =
+		dzt->dz_map_bh[chunk >> DM_ZONED_MAP_ENTRIES_SHIFT];
+	unsigned int *map = (unsigned int *) map_bh->b_data;
+
+	return le32_to_cpu(map[chunk & DM_ZONED_MAP_ENTRIES_MASK]);
+}
+
+/**
+ * Get an unmapped data zone and map it to chunk.
+ * This must be called with the mapping lock held.
+ */
+struct dm_zoned_zone *
+dm_zoned_alloc_dzone(struct dm_zoned_target *dzt,
+		     unsigned int chunk,
+		     unsigned int type_hint)
+{
+	struct dm_zoned_zone *dzone = NULL;
+
+again:
+
+	/* Get an unmapped data zone: if asked to, try to get */
+	/* an unmapped randomly writtable zone. Otherwise,    */
+	/* get a sequential zone.                             */
+	switch (type_hint) {
+	case DM_DZONE_CMR:
+		dzone = list_first_entry_or_null(&dzt->dz_unmap_cmr_list,
+						 struct dm_zoned_zone, link);
+		if (dzone)
+			break;
+	case DM_DZONE_SMR:
+	default:
+		dzone = list_first_entry_or_null(&dzt->dz_unmap_smr_list,
+						 struct dm_zoned_zone, link);
+		if (dzone)
+			break;
+		dzone = list_first_entry_or_null(&dzt->dz_unmap_cmr_list,
+						 struct dm_zoned_zone, link);
+		break;
+	}
+
+	if (dzone) {
+		list_del_init(&dzone->link);
+		dzt->dz_nr_unmap--;
+		if (dm_zoned_zone_offline(dzone)) {
+			dm_zoned_dev_error(dzt, "Ignoring offline dzone %lu\n",
+					   dzone->id);
+			goto again;
+		}
+
+		dm_zoned_dev_debug(dzt, "Allocated %s dzone %lu\n",
+				 dm_zoned_zone_is_cmr(dzone) ? "CMR" : "SMR",
+				 dzone->id);
+
+		/* Set the zone chunk mapping */
+		if (chunk != DM_ZONED_MAP_UNMAPPED) {
+			dm_zoned_set_dzone_mapping(dzt, chunk, dzone->id);
+			dzone->map = chunk;
+			if (dm_zoned_zone_is_cmr(dzone))
+				list_add_tail(&dzone->link,
+					      &dzt->dz_map_cmr_list);
+		}
+
+	}
+
+	return dzone;
+}
+
+/**
+ * Unmap and free a chunk data zone.
+ * This must be called with the mapping lock held.
+ */
+void
+dm_zoned_free_dzone(struct dm_zoned_target *dzt,
+		    struct dm_zoned_zone *dzone)
+{
+
+	dm_zoned_dev_assert(dzt, dm_zoned_zone_data(dzone));
+	dm_zoned_dev_assert(dzt, !test_bit(DM_ZONE_BUFFERED, &dzone->flags));
+
+	/* Reset the zone */
+	dm_zoned_wait_for_stable_zone(dzone);
+	dm_zoned_reset_zone_wp(dzt, dzone);
+	dm_zoned_zone_reset_stats(dzone);
+
+	dm_zoned_map_lock(dzt);
+
+	/* Clear the zone chunk mapping */
+	if (dzone->map != DM_ZONED_MAP_UNMAPPED) {
+		dm_zoned_set_dzone_mapping(dzt, dzone->map,
+					   DM_ZONED_MAP_UNMAPPED);
+		dzone->map = DM_ZONED_MAP_UNMAPPED;
+	}
+
+	/* If the zone was already marked as empty after */
+	/* a discard, remove it from the empty list.     */
+	if (test_and_clear_bit(DM_ZONE_EMPTY, &dzone->flags))
+		list_del_init(&dzone->elink);
+
+	/* Return the zone to the unmap list */
+	smp_mb__before_atomic();
+	clear_bit(DM_ZONE_DIRTY, &dzone->flags);
+	smp_mb__after_atomic();
+	if (dm_zoned_zone_is_cmr(dzone)) {
+		list_del_init(&dzone->link);
+		list_add_tail(&dzone->link, &dzt->dz_unmap_cmr_list);
+	} else
+		list_add_tail(&dzone->link, &dzt->dz_unmap_smr_list);
+	dzt->dz_nr_unmap++;
+
+	dm_zoned_dev_debug(dzt, "Freed data zone %lu\n", dzone->id);
+
+	dm_zoned_map_unlock(dzt);
+}
+
+/**
+ * After a failed write or a discard, a data zone may become
+ * entirely invalid and can be freed. Check this here.
+ */
+void
+dm_zoned_validate_dzone(struct dm_zoned_target *dzt,
+			struct dm_zoned_zone *dzone)
+{
+	int dweight;
+
+	dm_zoned_dev_assert(dzt, dm_zoned_zone_data(dzone));
+
+	if (dzone->bzone ||
+	    !test_and_clear_bit(DM_ZONE_DIRTY, &dzone->flags))
+		return;
+
+	dweight = dm_zoned_zone_weight(dzt, dzone);
+	dm_zoned_map_lock(dzt);
+	if (dweight == 0 &&
+	    !test_and_set_bit_lock(DM_ZONE_EMPTY, &dzone->flags)) {
+		list_add_tail(&dzone->elink, &dzt->dz_empty_list);
+		dm_zoned_schedule_reclaim(dzt, DM_ZONED_RECLAIM_PERIOD);
+	}
+	dm_zoned_map_unlock(dzt);
+}
+
+/**
+ * Change the mapping of the chunk served by @from_dzone
+ * to @to_dzone (used by GC). This implies that @from_dzone
+ * is invalidated, unmapped and freed.
+ */
+void
+dm_zoned_remap_dzone(struct dm_zoned_target *dzt,
+		     struct dm_zoned_zone *from_dzone,
+		     struct dm_zoned_zone *to_dzone)
+{
+	unsigned int chunk = from_dzone->map;
+
+	dm_zoned_map_lock(dzt);
+
+	dm_zoned_dev_assert(dzt, dm_zoned_zone_data(from_dzone));
+	dm_zoned_dev_assert(dzt, chunk != DM_ZONED_MAP_UNMAPPED);
+	dm_zoned_dev_assert(dzt, dm_zoned_zone_data(to_dzone));
+	dm_zoned_dev_assert(dzt, to_dzone->map == DM_ZONED_MAP_UNMAPPED);
+
+	from_dzone->map = DM_ZONED_MAP_UNMAPPED;
+	if (dm_zoned_zone_is_cmr(from_dzone))
+		list_del_init(&from_dzone->link);
+
+	dm_zoned_set_dzone_mapping(dzt, chunk, to_dzone->id);
+	to_dzone->map = chunk;
+	if (dm_zoned_zone_is_cmr(to_dzone))
+		list_add_tail(&to_dzone->link, &dzt->dz_map_cmr_list);
+
+	dm_zoned_map_unlock(dzt);
+}
+
+/**
+ * Change the type of @bzone to data zone and map it
+ * to the chunk being mapped by its current data zone.
+ * In the buffer zone mapping table, replace @bzone
+ * with @new_bzone.
+ */
+void
+dm_zoned_remap_bzone(struct dm_zoned_target *dzt,
+		     struct dm_zoned_zone *bzone,
+		     struct dm_zoned_zone *new_bzone)
+{
+	struct dm_zoned_zone *dzone = bzone->bzone;
+	unsigned int chunk = dzone->map;
+
+	dm_zoned_map_lock(dzt);
+
+	dm_zoned_dev_assert(dzt, dm_zoned_zone_buf(bzone));
+	dm_zoned_dev_assert(dzt, dm_zoned_zone_data(new_bzone));
+	dm_zoned_dev_assert(dzt, chunk != DM_ZONED_MAP_UNMAPPED);
+	dm_zoned_dev_assert(dzt, new_bzone->map == DM_ZONED_MAP_UNMAPPED);
+
+	/* Cleanup dzone */
+	smp_mb__before_atomic();
+	clear_bit(DM_ZONE_BUFFERED, &dzone->flags);
+	smp_mb__after_atomic();
+	dzone->bzone = NULL;
+	dzone->map = DM_ZONED_MAP_UNMAPPED;
+
+	/* new_bzone becomes a free buffer zone */
+	new_bzone->flags = DM_ZONE_BUF;
+	smp_mb__before_atomic();
+	set_bit(DM_ZONE_RECLAIM, &new_bzone->flags);
+	smp_mb__after_atomic();
+	dm_zoned_change_bzone_mapping(dzt, bzone, new_bzone,
+				    DM_ZONED_MAP_UNMAPPED);
+	list_add_tail(&new_bzone->link, &dzt->bz_free_list);
+	atomic_inc(&dzt->bz_nr_free);
+	dm_zoned_wake_bzone_waiter(dzt);
+
+	/* bzone becomes a mapped data zone */
+	bzone->bzone = NULL;
+	list_del_init(&bzone->link);
+	bzone->flags = DM_ZONE_DATA;
+	smp_mb__before_atomic();
+	set_bit(DM_ZONE_DIRTY, &bzone->flags);
+	set_bit(DM_ZONE_RECLAIM, &bzone->flags);
+	smp_mb__after_atomic();
+	bzone->map = chunk;
+	dm_zoned_set_dzone_mapping(dzt, chunk, bzone->id);
+	list_add_tail(&bzone->link, &dzt->dz_map_cmr_list);
+
+	dm_zoned_map_unlock(dzt);
+}
+
+/**
+ * Get the data zone mapping the chunk of the BIO.
+ * There may be no mapping.
+ */
+struct dm_zoned_zone *
+dm_zoned_bio_map(struct dm_zoned_target *dzt,
+		 struct bio *bio)
+{
+	struct dm_zoned_bioctx *bioctx =
+		dm_per_bio_data(bio, sizeof(struct dm_zoned_bioctx));
+	struct dm_zoned_zwork *zwork;
+	struct dm_zoned_zone *dzone;
+	unsigned long flags;
+	unsigned int dzone_id;
+	unsigned int chunk;
+
+	/* Get a work to activate the mapping zone if needed. */
+	zwork = kmalloc(sizeof(struct dm_zoned_zwork), GFP_KERNEL);
+	if (unlikely(!zwork))
+		return ERR_PTR(-ENOMEM);
+
+again:
+	dzone = NULL;
+	dm_zoned_map_lock(dzt);
+
+	chunk = bio->bi_iter.bi_sector >> dzt->zone_nr_sectors_shift;
+	dzone_id = dm_zoned_get_dzone_mapping(dzt, chunk);
+
+	/* For write to unmapped chunks, try */
+	/* to allocate an unused data zone.  */
+	if (dzone_id != DM_ZONED_MAP_UNMAPPED)
+		dzone = dm_zoned_lookup_zone_by_id(dzt, dzone_id);
+	else if ((bio->bi_rw & REQ_WRITE) &&
+		 (!(bio->bi_rw & REQ_DISCARD)))
+		dzone = dm_zoned_alloc_dzone(dzt, chunk, DM_DZONE_ANY);
+
+	if (!dzone)
+		/* No mapping: no work needed */
+		goto out;
+
+	dm_zoned_lock_zone(dzone, flags);
+
+	/* If the zone buffer is being reclaimed, wait */
+	if (test_bit(DM_ZONE_RECLAIM, &dzone->flags)) {
+		dm_zoned_dev_debug(dzt, "Wait for zone %lu reclaim (%lx)\n",
+				 dzone->id,
+				 dzone->flags);
+		dm_zoned_unlock_zone(dzone, flags);
+		dm_zoned_map_unlock(dzt);
+		wait_on_bit_io(&dzone->flags, DM_ZONE_RECLAIM,
+			       TASK_UNINTERRUPTIBLE);
+		goto again;
+	}
+
+	if (test_and_clear_bit(DM_ZONE_EMPTY, &dzone->flags))
+		list_del_init(&dzone->elink);
+
+	/* Got the mapping zone: set it active */
+	if (!test_and_set_bit(DM_ZONE_ACTIVE, &dzone->flags)) {
+		INIT_WORK(&zwork->work, dm_zoned_zone_work);
+		zwork->target = dzt;
+		zwork->dzone = dzone;
+		INIT_LIST_HEAD(&zwork->link);
+		atomic_set(&zwork->ref, 0);
+		bio_list_init(&zwork->bio_list);
+		atomic_set(&zwork->bio_count, 0);
+		dzone->zwork = zwork;
+		atomic_inc(&dzt->dz_nr_active);
+	} else {
+		kfree(zwork);
+		zwork = dzone->zwork;
+		dm_zoned_dev_assert(dzt, zwork);
+	}
+
+	bioctx->dzone = dzone;
+	atomic_inc(&zwork->ref);
+	bio_list_add(&zwork->bio_list, bio);
+
+	dm_zoned_run_dzone(dzt, dzone);
+	zwork = NULL;
+
+	dm_zoned_unlock_zone(dzone, flags);
+
+out:
+	dm_zoned_map_unlock(dzt);
+
+	if (zwork)
+		kfree(zwork);
+
+	return dzone;
+}
+
+/**
+ * If needed and possible, queue an active zone work.
+ */
+void
+dm_zoned_run_dzone(struct dm_zoned_target *dzt,
+		   struct dm_zoned_zone *dzone)
+{
+	struct dm_zoned_zwork *zwork = dzone->zwork;
+
+	dm_zoned_dev_assert(dzt, test_bit(DM_ZONE_ACTIVE, &dzone->flags));
+	dm_zoned_dev_assert(dzt, zwork != NULL);
+	dm_zoned_dev_assert(dzt, atomic_read(&zwork->ref) > 0);
+
+	if (bio_list_peek(&zwork->bio_list) &&
+	    !test_bit(DM_ZONE_ACTIVE_WAIT, &dzone->flags)) {
+		if (queue_work(dzt->zone_wq, &zwork->work))
+			atomic_inc(&zwork->ref);
+	}
+}
+
+/**
+ * Release an active data zone: the last put will
+ * deactivate the zone and free its work struct.
+ */
+void
+dm_zoned_put_dzone(struct dm_zoned_target *dzt,
+		   struct dm_zoned_zone *dzone)
+{
+	struct dm_zoned_zwork *zwork = dzone->zwork;
+	unsigned long flags;
+
+	dm_zoned_dev_assert(dzt, test_bit(DM_ZONE_ACTIVE, &dzone->flags));
+	dm_zoned_dev_assert(dzt, zwork != NULL);
+	dm_zoned_dev_assert(dzt, atomic_read(&zwork->ref) > 0);
+
+	dm_zoned_lock_zone(dzone, flags);
+
+	if (atomic_dec_and_test(&zwork->ref)) {
+		kfree(zwork);
+		dzone->zwork = NULL;
+		clear_bit_unlock(DM_ZONE_ACTIVE, &dzone->flags);
+		smp_mb__after_atomic();
+		atomic_dec(&dzt->dz_nr_active);
+		wake_up_bit(&dzone->flags, DM_ZONE_ACTIVE);
+	}
+
+	dm_zoned_unlock_zone(dzone, flags);
+}
+
+/**
+ * Determine metadata format.
+ */
+static int
+dm_zoned_format(struct dm_zoned_target *dzt,
+		struct dm_zoned_target_config *conf)
+{
+	unsigned int nr_meta_blocks, nr_meta_zones = 1;
+	unsigned int nr_buf_zones, nr_data_zones;
+	unsigned int nr_bitmap_blocks, nr_map_blocks;
+
+	dm_zoned_dev_info(dzt, "Formatting device with %lu buffer zones\n",
+			conf->nr_buf_zones);
+
+	if (conf->nr_buf_zones < DM_ZONED_NR_BZONES_MIN) {
+		conf->nr_buf_zones = DM_ZONED_NR_BZONES_MIN;
+		dm_zoned_dev_info(dzt,
+			"    Number of buffer zones too low: using %lu\n",
+			conf->nr_buf_zones);
+	}
+
+	if (conf->nr_buf_zones > DM_ZONED_NR_BZONES_MAX) {
+		conf->nr_buf_zones = DM_ZONED_NR_BZONES_MAX;
+		dm_zoned_dev_info(dzt,
+			"    Number of buffer zones too large: using %lu\n",
+			conf->nr_buf_zones);
+	}
+
+	nr_buf_zones = conf->nr_buf_zones;
+
+again:
+
+	nr_data_zones = dzt->nr_zones - nr_buf_zones - nr_meta_zones;
+	nr_map_blocks = nr_data_zones >> DM_ZONED_MAP_ENTRIES_SHIFT;
+	if (nr_data_zones & DM_ZONED_MAP_ENTRIES_MASK)
+		nr_map_blocks++;
+	nr_bitmap_blocks = (dzt->nr_zones - nr_meta_zones) *
+		dzt->zone_nr_bitmap_blocks;
+	nr_meta_blocks = 1 + nr_map_blocks + nr_bitmap_blocks;
+	nr_meta_zones = (nr_meta_blocks + dzt->zone_nr_blocks_mask) >>
+		dzt->zone_nr_blocks_shift;
+
+	if (nr_meta_zones > dzt->nr_meta_zones) {
+		dm_zoned_dev_error(dzt,
+			"Insufficient random write space for metadata (need %u zones, have %u)\n",
+			nr_meta_zones, dzt->nr_meta_zones);
+		return -ENXIO;
+	}
+
+	if ((nr_meta_zones + nr_buf_zones) > dzt->nr_rnd_zones) {
+		nr_buf_zones = dzt->nr_rnd_zones - nr_meta_zones;
+		dm_zoned_dev_info(dzt,
+			"Insufficient random zones: retrying with %u buffer zones\n",
+			nr_buf_zones);
+		goto again;
+	}
+
+	/* Fixup everything */
+	dzt->nr_meta_zones = nr_meta_zones;
+	dzt->nr_buf_zones = nr_buf_zones;
+	dzt->nr_data_zones = dzt->nr_zones - nr_buf_zones - nr_meta_zones;
+	dzt->nr_map_blocks = dzt->nr_data_zones >> DM_ZONED_MAP_ENTRIES_SHIFT;
+	if (dzt->nr_data_zones & DM_ZONED_MAP_ENTRIES_MASK)
+		dzt->nr_map_blocks++;
+	dzt->nr_bitmap_blocks = (dzt->nr_buf_zones + dzt->nr_data_zones) *
+		dzt->zone_nr_bitmap_blocks;
+	dzt->bitmap_block = 1 + dzt->nr_map_blocks;
+
+	return 0;
+}
+
+/**
+ * Format the target device metadata.
+ */
+static int
+dm_zoned_format_meta(struct dm_zoned_target *dzt,
+		     struct dm_zoned_target_config *conf)
+{
+	struct dm_zoned_super *sb;
+	int b, ret;
+
+	/* Reset all zones */
+	ret = dm_zoned_reset_zones(dzt);
+	if (ret)
+		return ret;
+
+	/* Initialize the super block data */
+	ret = dm_zoned_format(dzt, conf);
+	if (ret)
+		return ret;
+
+	/* Format buffer zones mapping */
+	ret = dm_zoned_format_bzone_mapping(dzt);
+	if (ret)
+		return ret;
+
+	/* Format data zones mapping */
+	ret = dm_zoned_format_dzone_mapping(dzt);
+	if (ret)
+		return ret;
+
+	/* Clear bitmaps */
+	for (b = 0; b < dzt->nr_bitmap_blocks; b++) {
+		ret = dm_zoned_zero_meta(dzt, dzt->bitmap_block + b);
+		if (ret)
+			return ret;
+	}
+
+	/* Finally, write super block */
+	sb = (struct dm_zoned_super *) dzt->sb_bh->b_data;
+	lock_buffer(dzt->sb_bh);
+	sb->magic = cpu_to_le32(DM_ZONED_MAGIC);
+	sb->version = cpu_to_le32(DM_ZONED_META_VER);
+	sb->nr_map_blocks = cpu_to_le32(dzt->nr_map_blocks);
+	sb->nr_bitmap_blocks = cpu_to_le32(dzt->nr_bitmap_blocks);
+	sb->nr_buf_zones = cpu_to_le32(dzt->nr_buf_zones);
+	sb->nr_data_zones = cpu_to_le32(dzt->nr_data_zones);
+	dm_zoned_dirty_meta(dzt, dzt->sb_bh);
+	unlock_buffer(dzt->sb_bh);
+
+	return dm_zoned_flush(dzt);
+}
+
+/**
+ * Count zones in a list.
+ */
+static int
+dm_zoned_zone_count(struct list_head *list)
+{
+	struct dm_zoned_zone *zone;
+	int n = 0;
+
+	list_for_each_entry(zone, list, link) {
+		n++;
+	}
+
+	return n;
+}
+
+/**
+ * Shuffle data zone list: file systems tend to distribute
+ * accesses accross a disk to achieve stable performance
+ * over time. Allocating and mapping these spread accessing
+ * to contiguous data zones in LBA order would achieve the
+ * opposite result (fast accesses initially, slower later).
+ * So make sure this does not happen by shuffling the initially
+ * LBA ordered list of SMR data zones.
+ * Shuffling: LBA ordered zone list 0,1,2,3,4,5,6,7 [...] is
+ * reorganized as: 0,4,1,5,2,6,3,7 [...]
+ */
+static void
+dm_zoned_shuffle_dzones(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_zone *dzone;
+	struct list_head tmp1;
+	struct list_head tmp2;
+	int n = 0;
+
+	INIT_LIST_HEAD(&tmp1);
+	INIT_LIST_HEAD(&tmp2);
+
+	while (!list_empty(&dzt->dz_unmap_smr_list) &&
+	      n < dzt->nr_smr_data_zones / 2) {
+		dzone = list_first_entry(&dzt->dz_unmap_smr_list,
+					 struct dm_zoned_zone, link);
+		list_del_init(&dzone->link);
+		list_add_tail(&dzone->link, &tmp1);
+		n++;
+	}
+	while (!list_empty(&dzt->dz_unmap_smr_list)) {
+		dzone = list_first_entry(&dzt->dz_unmap_smr_list,
+					 struct dm_zoned_zone, link);
+		list_del_init(&dzone->link);
+		list_add_tail(&dzone->link, &tmp2);
+	}
+	while (!list_empty(&tmp1) && !list_empty(&tmp2)) {
+		dzone = list_first_entry_or_null(&tmp1,
+						 struct dm_zoned_zone, link);
+		if (dzone) {
+			list_del_init(&dzone->link);
+			list_add_tail(&dzone->link, &dzt->dz_unmap_smr_list);
+		}
+		dzone = list_first_entry_or_null(&tmp2,
+						 struct dm_zoned_zone, link);
+		if (dzone) {
+			list_del_init(&dzone->link);
+			list_add_tail(&dzone->link, &dzt->dz_unmap_smr_list);
+		}
+	}
+}
+
+/**
+ * Load meta data from disk.
+ */
+static int
+dm_zoned_load_meta(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_super *sb =
+		(struct dm_zoned_super *) dzt->sb_bh->b_data;
+	struct dm_zoned_zone *zone;
+	int i, ret;
+
+	/* Check super block */
+	if (le32_to_cpu(sb->magic) != DM_ZONED_MAGIC) {
+		dm_zoned_dev_error(dzt, "Invalid meta magic "
+				   "(need 0x%08x, got 0x%08x)\n",
+				   DM_ZONED_MAGIC, le32_to_cpu(sb->magic));
+		return -ENXIO;
+	}
+	if (le32_to_cpu(sb->version) != DM_ZONED_META_VER) {
+		dm_zoned_dev_error(dzt, "Invalid meta version "
+				   "(need %d, got %d)\n",
+				   DM_ZONED_META_VER, le32_to_cpu(sb->version));
+		return -ENXIO;
+	}
+
+	dzt->nr_buf_zones = le32_to_cpu(sb->nr_buf_zones);
+	dzt->nr_data_zones = le32_to_cpu(sb->nr_data_zones);
+	if ((dzt->nr_buf_zones + dzt->nr_data_zones) > dzt->nr_zones) {
+		dm_zoned_dev_error(dzt, "Invalid format: %u buffer zones "
+				   "+ %u data zones > %u zones\n",
+				   dzt->nr_buf_zones,
+				   dzt->nr_data_zones,
+				   dzt->nr_zones);
+		return -ENXIO;
+	}
+	dzt->nr_meta_zones = dzt->nr_zones -
+		(dzt->nr_buf_zones + dzt->nr_data_zones);
+	dzt->nr_map_blocks = le32_to_cpu(sb->nr_map_blocks);
+	dzt->nr_bitmap_blocks = le32_to_cpu(sb->nr_bitmap_blocks);
+	dzt->nr_data_zones = le32_to_cpu(sb->nr_data_zones);
+	dzt->bitmap_block = dzt->nr_map_blocks + 1;
+	dzt->dz_nr_unmap = dzt->nr_data_zones;
+
+	/* Load the buffer zones mapping table */
+	ret = dm_zoned_load_bzone_mapping(dzt);
+	if (ret) {
+		dm_zoned_dev_error(dzt, "Load buffer zone mapping failed %d\n",
+				 ret);
+		return ret;
+	}
+
+	/* Load the data zone mapping table */
+	ret = dm_zoned_load_dzone_mapping(dzt);
+	if (ret) {
+		dm_zoned_dev_error(dzt, "Load data zone mapping failed %d\n",
+				 ret);
+		return ret;
+	}
+
+	/* The first nr_meta_zones are still marked */
+	/* as unmapped data zones: fix this         */
+	for (i = 0; i < dzt->nr_meta_zones; i++) {
+		zone = dm_zoned_lookup_zone_by_id(dzt, i);
+		if (!zone) {
+			dm_zoned_dev_error(dzt, "Meta zone %d not found\n", i);
+			return -ENXIO;
+		}
+		zone->flags = DM_ZONE_META;
+		list_del_init(&zone->link);
+	}
+	dzt->nr_cmr_data_zones = dm_zoned_zone_count(&dzt->dz_map_cmr_list) +
+		dm_zoned_zone_count(&dzt->dz_unmap_cmr_list);
+	dzt->nr_smr_data_zones = dzt->nr_data_zones - dzt->nr_cmr_data_zones;
+
+	dm_zoned_shuffle_dzones(dzt);
+
+	dm_zoned_dev_info(dzt, "Backend device:\n");
+	dm_zoned_dev_info(dzt,
+		"    %zu 512-byte logical sectors\n",
+		(sector_t)dzt->nr_zones << dzt->zone_nr_sectors_shift);
+	dm_zoned_dev_info(dzt,
+		"    %u zones of %zu 512-byte logical sectors\n",
+		dzt->nr_zones, dzt->zone_nr_sectors);
+	dm_zoned_dev_info(dzt,
+		"    %u CMR zones, %u SMR zones (%u random write zones)\n",
+		dzt->nr_cmr_zones,
+		dzt->nr_smr_zones,
+		dzt->nr_rnd_zones);
+	dm_zoned_dev_info(dzt,
+		"    %u metadata zones\n", dzt->nr_meta_zones);
+	dm_zoned_dev_info(dzt,
+		"    %u buffer zones (%d free zones, %u low threshold)\n",
+		dzt->nr_buf_zones,  atomic_read(&dzt->bz_nr_free),
+		dzt->bz_nr_free_low);
+	dm_zoned_dev_info(dzt,
+		"    %u data zones (%u SMR zones, %u CMR zones), %u unmapped zones\n",
+		dzt->nr_data_zones, dzt->nr_smr_data_zones,
+		dzt->nr_cmr_data_zones, dzt->dz_nr_unmap);
+
+#ifdef __DM_ZONED_DEBUG
+	dm_zoned_dev_info(dzt, "Format:\n");
+	dm_zoned_dev_info(dzt,
+		"        %u data zone mapping blocks from block 1\n",
+		dzt->nr_map_blocks);
+	dm_zoned_dev_info(dzt,
+		"        %u bitmap blocks from block %zu (%u blocks per zone)\n",
+		dzt->nr_bitmap_blocks, dzt->bitmap_block,
+		dzt->zone_nr_bitmap_blocks);
+	dm_zoned_dev_info(dzt,
+		"Using %zu KiB of memory\n", dzt->used_mem >> 10);
+#endif
+
+	return 0;
+}
+
+/**
+ * Initialize the target metadata.
+ */
+int
+dm_zoned_init_meta(struct dm_zoned_target *dzt,
+		   struct dm_zoned_target_config *conf)
+{
+	int ret;
+
+	/* Flush the target device */
+	blkdev_issue_flush(dzt->zbd, GFP_NOFS, NULL);
+
+	/* Initialize zone descriptors */
+	ret = dm_zoned_init_zones(dzt);
+	if (ret)
+		goto out;
+
+	/* Get super block */
+	dzt->sb_bh = dm_zoned_get_meta(dzt, 0);
+	if (IS_ERR(dzt->sb_bh)) {
+		ret = PTR_ERR(dzt->sb_bh);
+		dzt->sb_bh = NULL;
+		dm_zoned_dev_error(dzt, "Read super block failed %d\n", ret);
+		goto out;
+	}
+	dm_zoned_account_mem(dzt, DM_ZONED_BLOCK_SIZE);
+
+	/* If asked to reformat */
+	if (conf->format) {
+		ret = dm_zoned_format_meta(dzt, conf);
+		if (ret)
+			goto out;
+	}
+
+	/* Load meta-data */
+	ret = dm_zoned_load_meta(dzt);
+	if (ret)
+		goto out;
+
+out:
+	if (ret)
+		dm_zoned_cleanup_meta(dzt);
+
+	return ret;
+}
+
+/**
+ * Check metadata on resume.
+ */
+int
+dm_zoned_resume_meta(struct dm_zoned_target *dzt)
+{
+	return dm_zoned_check_zones(dzt);
+}
+
+/**
+ * Cleanup the target metadata resources.
+ */
+void
+dm_zoned_cleanup_meta(struct dm_zoned_target *dzt)
+{
+
+	dm_zoned_cleanup_dzone_mapping(dzt);
+	brelse(dzt->sb_bh);
+	dm_zoned_drop_zones(dzt);
+}
+
+/**
+ * Set @nr_bits bits in @bitmap starting from @bit.
+ * Return the number of bits changed from 0 to 1.
+ */
+static unsigned int
+dm_zoned_set_bits(unsigned long *bitmap,
+		  unsigned int bit,
+		  unsigned int nr_bits)
+{
+	unsigned long *addr;
+	unsigned int end = bit + nr_bits;
+	unsigned int n = 0;
+
+	while (bit < end) {
+
+		if (((bit & (BITS_PER_LONG - 1)) == 0) &&
+		    ((end - bit) >= BITS_PER_LONG)) {
+			/* Try to set the whole word at once */
+			addr = bitmap + BIT_WORD(bit);
+			if (*addr == 0) {
+				*addr = ULONG_MAX;
+				n += BITS_PER_LONG;
+				bit += BITS_PER_LONG;
+				continue;
+			}
+		}
+
+		if (!test_and_set_bit(bit, bitmap))
+			n++;
+		bit++;
+	}
+
+	return n;
+
+}
+
+/**
+ * Get the bitmap block storing the bit for @chunk_block
+ * in @zone.
+ */
+static struct buffer_head *
+dm_zoned_get_bitmap(struct dm_zoned_target *dzt,
+		    struct dm_zoned_zone *zone,
+		    sector_t chunk_block)
+{
+	sector_t bitmap_block = dzt->bitmap_block
+		+ ((sector_t)(zone->id - dzt->nr_meta_zones)
+		   * dzt->zone_nr_bitmap_blocks)
+		+ (chunk_block >> DM_ZONED_BLOCK_SHIFT_BITS);
+
+	return dm_zoned_get_meta(dzt, bitmap_block);
+}
+
+/**
+ * Validate (set bit) all the blocks in
+ * the range [@block..@block+@nr_blocks-1].
+ */
+int
+dm_zoned_validate_blocks(struct dm_zoned_target *dzt,
+			 struct dm_zoned_zone *zone,
+			 sector_t chunk_block,
+			 unsigned int nr_blocks)
+{
+	unsigned int count, bit, nr_bits;
+	struct buffer_head *bh;
+
+	dm_zoned_dev_debug(dzt, "=> VALIDATE zone %lu, block %zu, %u blocks\n",
+			 zone->id,
+			 chunk_block,
+			 nr_blocks);
+
+	dm_zoned_dev_assert(dzt, !dm_zoned_zone_meta(zone));
+	dm_zoned_dev_assert(dzt,
+			    (chunk_block + nr_blocks) <= dzt->zone_nr_blocks);
+
+	while (nr_blocks) {
+
+		/* Get bitmap block */
+		bh = dm_zoned_get_bitmap(dzt, zone, chunk_block);
+		if (IS_ERR(bh))
+			return PTR_ERR(bh);
+
+		/* Set bits */
+		bit = chunk_block & DM_ZONED_BLOCK_MASK_BITS;
+		nr_bits = min(nr_blocks, DM_ZONED_BLOCK_SIZE_BITS - bit);
+
+		lock_buffer(bh);
+		count = dm_zoned_set_bits((unsigned long *) bh->b_data,
+					bit, nr_bits);
+		if (count) {
+			dm_zoned_dirty_meta(dzt, bh);
+			set_bit(DM_ZONE_DIRTY, &zone->flags);
+		}
+		unlock_buffer(bh);
+		__brelse(bh);
+
+		nr_blocks -= nr_bits;
+		chunk_block += nr_bits;
+
+	}
+
+	return 0;
+}
+
+/**
+ * Clear @nr_bits bits in @bitmap starting from @bit.
+ * Return the number of bits changed from 1 to 0.
+ */
+static int
+dm_zoned_clear_bits(unsigned long *bitmap,
+		    int bit,
+		    int nr_bits)
+{
+	unsigned long *addr;
+	int end = bit + nr_bits;
+	int n = 0;
+
+	while (bit < end) {
+
+		if (((bit & (BITS_PER_LONG - 1)) == 0) &&
+		    ((end - bit) >= BITS_PER_LONG)) {
+			/* Try to clear whole word at once */
+			addr = bitmap + BIT_WORD(bit);
+			if (*addr == ULONG_MAX) {
+				*addr = 0;
+				n += BITS_PER_LONG;
+				bit += BITS_PER_LONG;
+				continue;
+			}
+		}
+
+		if (test_and_clear_bit(bit, bitmap))
+			n++;
+		bit++;
+	}
+
+	return n;
+
+}
+
+/**
+ * Invalidate (clear bit) all the blocks in
+ * the range [@block..@block+@nr_blocks-1].
+ */
+int
+dm_zoned_invalidate_blocks(struct dm_zoned_target *dzt,
+			   struct dm_zoned_zone *zone,
+			   sector_t chunk_block,
+			   unsigned int nr_blocks)
+{
+	unsigned int count, bit, nr_bits;
+	struct buffer_head *bh;
+
+	dm_zoned_dev_debug(dzt, "INVALIDATE zone %lu, block %zu, %u blocks\n",
+			 zone->id,
+			 chunk_block,
+			 nr_blocks);
+
+	dm_zoned_dev_assert(dzt, !dm_zoned_zone_meta(zone));
+	dm_zoned_dev_assert(dzt,
+			    (chunk_block + nr_blocks) <= dzt->zone_nr_blocks);
+
+	while (nr_blocks) {
+
+		/* Get bitmap block */
+		bh = dm_zoned_get_bitmap(dzt, zone, chunk_block);
+		if (IS_ERR(bh))
+			return PTR_ERR(bh);
+
+		/* Clear bits */
+		bit = chunk_block & DM_ZONED_BLOCK_MASK_BITS;
+		nr_bits = min(nr_blocks, DM_ZONED_BLOCK_SIZE_BITS - bit);
+
+		lock_buffer(bh);
+		count = dm_zoned_clear_bits((unsigned long *) bh->b_data,
+					  bit, nr_bits);
+		if (count) {
+			dm_zoned_dirty_meta(dzt, bh);
+			set_bit(DM_ZONE_DIRTY, &zone->flags);
+		}
+		unlock_buffer(bh);
+		__brelse(bh);
+
+		nr_blocks -= nr_bits;
+		chunk_block += nr_bits;
+
+	}
+
+	return 0;
+}
+
+/**
+ * Get a block bit value.
+ */
+static int
+dm_zoned_test_block(struct dm_zoned_target *dzt,
+		    struct dm_zoned_zone *zone,
+		    sector_t chunk_block)
+{
+	struct buffer_head *bh;
+	int ret;
+
+	/* Get bitmap block */
+	bh = dm_zoned_get_bitmap(dzt, zone, chunk_block);
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
+
+	/* Get offset */
+	ret = test_bit(chunk_block & DM_ZONED_BLOCK_MASK_BITS,
+		       (unsigned long *) bh->b_data) != 0;
+
+	__brelse(bh);
+
+	return ret;
+}
+
+/**
+ * Return the offset from @block to the first block
+ * with a bit value set to @set. Search at most @nr_blocks
+ * blocks from @block.
+ */
+static int
+dm_zoned_offset_to_block(struct dm_zoned_target *dzt,
+			 struct dm_zoned_zone *zone,
+			 sector_t chunk_block,
+			 unsigned int nr_blocks,
+			 int set)
+{
+	struct buffer_head *bh;
+	unsigned int bit, set_bit, nr_bits;
+	unsigned long *bitmap;
+	int n = 0;
+
+	while (nr_blocks) {
+
+		/* Get bitmap block */
+		bh = dm_zoned_get_bitmap(dzt, zone, chunk_block);
+		if (IS_ERR(bh))
+			return PTR_ERR(bh);
+
+		/* Get offset */
+		bitmap = (unsigned long *) bh->b_data;
+		bit = chunk_block & DM_ZONED_BLOCK_MASK_BITS;
+		nr_bits = min(nr_blocks, DM_ZONED_BLOCK_SIZE_BITS - bit);
+		if (set)
+			set_bit = find_next_bit(bitmap,
+				DM_ZONED_BLOCK_SIZE_BITS, bit);
+		else
+			set_bit = find_next_zero_bit(bitmap,
+				DM_ZONED_BLOCK_SIZE_BITS, bit);
+		__brelse(bh);
+
+		n += set_bit - bit;
+		if (set_bit < DM_ZONED_BLOCK_SIZE_BITS)
+			break;
+
+		nr_blocks -= nr_bits;
+		chunk_block += nr_bits;
+
+	}
+
+	return n;
+}
+
+/**
+ * Test if @block is valid. If it is, the number of consecutive
+ * valid blocks from @block will be returned at the address
+ * indicated by @nr_blocks;
+ */
+int
+dm_zoned_block_valid(struct dm_zoned_target *dzt,
+		     struct dm_zoned_zone *zone,
+		     sector_t chunk_block)
+{
+	int valid;
+
+	dm_zoned_dev_assert(dzt, !dm_zoned_zone_meta(zone));
+	dm_zoned_dev_assert(dzt, chunk_block < dzt->zone_nr_blocks);
+
+	/* Test block */
+	valid = dm_zoned_test_block(dzt, zone, chunk_block);
+	if (valid <= 0)
+		return valid;
+
+	/* The block is valid: get the number of valid blocks from block */
+	return dm_zoned_offset_to_block(dzt, zone, chunk_block,
+				      dzt->zone_nr_blocks - chunk_block,
+				      0);
+}
+
+/**
+ * Count the number of bits set starting from @bit
+ * up to @bit + @nr_bits - 1.
+ */
+static int
+dm_zoned_count_bits(void *bitmap,
+		    int bit,
+		    int nr_bits)
+{
+	unsigned long *addr;
+	int end = bit + nr_bits;
+	int n = 0;
+
+	while (bit < end) {
+
+		if (((bit & (BITS_PER_LONG - 1)) == 0) &&
+		    ((end - bit) >= BITS_PER_LONG)) {
+			addr = (unsigned long *)bitmap + BIT_WORD(bit);
+			if (*addr == ULONG_MAX) {
+				n += BITS_PER_LONG;
+				bit += BITS_PER_LONG;
+				continue;
+			}
+		}
+
+		if (test_bit(bit, bitmap))
+			n++;
+		bit++;
+	}
+
+	return n;
+
+}
+
+/**
+ * Return the number of valid blocks in the range
+ * of blocks [@block..@block+@nr_blocks-1].
+ */
+int
+dm_zoned_valid_blocks(struct dm_zoned_target *dzt,
+		      struct dm_zoned_zone *zone,
+		      sector_t chunk_block,
+		      unsigned int nr_blocks)
+{
+	struct buffer_head *bh;
+	unsigned int bit, nr_bits;
+	void *bitmap;
+	int n = 0;
+
+	dm_zoned_dev_assert(dzt, !dm_zoned_zone_meta(zone));
+	dm_zoned_dev_assert(dzt,
+			    (chunk_block + nr_blocks) <= dzt->zone_nr_blocks);
+
+	while (nr_blocks) {
+
+		/* Get bitmap block */
+		bh = dm_zoned_get_bitmap(dzt, zone, chunk_block);
+		if (IS_ERR(bh))
+			return PTR_ERR(bh);
+
+		/* Count bits in this block */
+		bitmap = bh->b_data;
+		bit = chunk_block & DM_ZONED_BLOCK_MASK_BITS;
+		nr_bits = min(nr_blocks, DM_ZONED_BLOCK_SIZE_BITS - bit);
+		n += dm_zoned_count_bits(bitmap, bit, nr_bits);
+
+		__brelse(bh);
+
+		nr_blocks -= nr_bits;
+		chunk_block += nr_bits;
+
+	}
+
+	return n;
+}
diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
new file mode 100644
index 0000000..3b6cfa5
--- /dev/null
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -0,0 +1,770 @@
+/*
+ * (C) Copyright 2016 Western Digital.
+ *
+ * This software is distributed under the terms of the GNU Lesser General
+ * Public License version 2, or any later version, "as is," without technical
+ * support, and WITHOUT ANY WARRANTY, without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Author: Damien Le Moal <damien.lemoal@hgst.com>
+ */
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/slab.h>
+
+#include "dm-zoned.h"
+
+/**
+ * Free a page list.
+ */
+static void
+dm_zoned_reclaim_free_page_list(struct dm_zoned_target *dzt,
+				struct page_list *pl,
+				unsigned int nr_blocks)
+{
+	unsigned int nr_pages;
+	int i;
+
+	nr_pages = ((nr_blocks << DM_ZONED_BLOCK_SHIFT) +
+		    PAGE_SIZE - 1) >> PAGE_SHIFT;
+	for (i = 0; i < nr_pages; i++) {
+		if (pl[i].page)
+			put_page(pl[i].page);
+	}
+	kfree(pl);
+}
+
+/**
+ * Allocate a page list.
+ */
+static struct page_list *
+dm_zoned_reclaim_alloc_page_list(struct dm_zoned_target *dzt,
+				 unsigned int nr_blocks)
+{
+	struct page_list *pl;
+	unsigned int nr_pages;
+	int i;
+
+	/* Get a page list */
+	nr_pages = ((nr_blocks << DM_ZONED_BLOCK_SHIFT) +
+		    PAGE_SIZE - 1) >> PAGE_SHIFT;
+	pl = kzalloc(sizeof(struct page_list) * nr_pages, GFP_KERNEL);
+	if (!pl)
+		return NULL;
+
+	/* Get pages */
+	for (i = 0; i < nr_pages; i++) {
+		pl[i].page = alloc_page(GFP_KERNEL);
+		if (!pl[i].page) {
+			dm_zoned_reclaim_free_page_list(dzt, pl, i);
+			return NULL;
+		}
+		if (i > 0)
+			pl[i - 1].next = &pl[i];
+	}
+
+	return pl;
+}
+
+/**
+ * Read blocks.
+ */
+static int
+dm_zoned_reclaim_read(struct dm_zoned_target *dzt,
+		      struct dm_zoned_zone *zone,
+		      sector_t chunk_block,
+		      unsigned int nr_blocks,
+		      struct page_list *pl)
+{
+	struct dm_io_request ioreq;
+	struct dm_io_region ioreg;
+	int ret;
+
+	dm_zoned_dev_debug(dzt, "Reclaim: Read %s zone %lu, "
+			   "block %zu, %u blocks\n",
+			   dm_zoned_zone_is_cmr(zone) ? "CMR" : "SMR",
+			   zone->id, chunk_block, nr_blocks);
+
+	/* Setup I/O request and region */
+	ioreq.bi_rw = READ;
+	ioreq.mem.type = DM_IO_PAGE_LIST;
+	ioreq.mem.offset = 0;
+	ioreq.mem.ptr.pl = pl;
+	ioreq.notify.fn = NULL;
+	ioreq.notify.context = NULL;
+	ioreq.client = dzt->reclaim_client;
+	ioreg.bdev = dzt->zbd;
+	ioreg.sector = dm_zoned_block_to_sector(dm_zoned_zone_start_block(zone)
+						+ chunk_block);
+	ioreg.count = dm_zoned_block_to_sector(nr_blocks);
+
+	/* Do read */
+	ret = dm_io(&ioreq, 1, &ioreg, NULL);
+	if (ret) {
+		dm_zoned_dev_error(dzt, "Reclaim: Read %s zone %lu, "
+				   "block %zu, %u blocks failed %d\n",
+				   dm_zoned_zone_is_cmr(zone) ? "CMR" : "SMR",
+				   zone->id, chunk_block, nr_blocks, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * Write blocks.
+ */
+static int
+dm_zoned_reclaim_write(struct dm_zoned_target *dzt,
+		       struct dm_zoned_zone *zone,
+		       sector_t chunk_block,
+		       unsigned int nr_blocks,
+		       struct page_list *pl)
+{
+	struct dm_io_request ioreq;
+	struct dm_io_region ioreg;
+	int ret;
+
+	dm_zoned_dev_debug(dzt, "Reclaim: Write %s zone %lu, block %zu, %u blocks\n",
+			 dm_zoned_zone_is_cmr(zone) ? "CMR" : "SMR",
+			 zone->id,
+			 chunk_block,
+			 nr_blocks);
+
+	/* Fill holes between writes */
+	if (dm_zoned_zone_is_smr(zone) && chunk_block > zone->wp_block) {
+		ret = dm_zoned_advance_zone_wp(dzt, zone, chunk_block - zone->wp_block);
+		if (ret)
+			return ret;
+	}
+
+	/* Setup I/O request and region */
+	ioreq.bi_rw = REQ_WRITE;
+	ioreq.mem.type = DM_IO_PAGE_LIST;
+	ioreq.mem.offset = 0;
+	ioreq.mem.ptr.pl = pl;
+	ioreq.notify.fn = NULL;
+	ioreq.notify.context = NULL;
+	ioreq.client = dzt->reclaim_client;
+	ioreg.bdev = dzt->zbd;
+	ioreg.sector = dm_zoned_block_to_sector(dm_zoned_zone_start_block(zone) + chunk_block);
+	ioreg.count = dm_zoned_block_to_sector(nr_blocks);
+
+	/* Do write */
+	ret = dm_io(&ioreq, 1, &ioreg, NULL);
+	if (ret) {
+		dm_zoned_dev_error(dzt, "Reclaim: Write %s zone %lu, block %zu, %u blocks failed %d\n",
+				 dm_zoned_zone_is_cmr(zone) ? "CMR" : "SMR",
+				 zone->id,
+				 chunk_block,
+				 nr_blocks,
+				 ret);
+		return ret;
+	}
+
+	if (dm_zoned_zone_is_smr(zone))
+		zone->wp_block += nr_blocks;
+
+	return 0;
+}
+
+/**
+ * Copy blocks between zones.
+ */
+static int
+dm_zoned_reclaim_copy(struct dm_zoned_target *dzt,
+		      struct dm_zoned_zone *from_zone,
+		      struct dm_zoned_zone *to_zone,
+		      sector_t chunk_block,
+		      unsigned int nr_blocks)
+{
+	struct page_list *pl;
+	sector_t block = chunk_block;
+	unsigned int blocks = nr_blocks;
+	unsigned int count, max_count;
+	int ret;
+
+	/* Get a page list */
+	max_count = min_t(unsigned int, nr_blocks, DM_ZONED_RECLAIM_MAX_BLOCKS);
+	pl = dm_zoned_reclaim_alloc_page_list(dzt, max_count);
+	if (!pl) {
+		dm_zoned_dev_error(dzt, "Reclaim: Allocate %u pages failed\n",
+				 max_count);
+		return -ENOMEM;
+	}
+
+	while (blocks) {
+
+		/* Read blocks */
+		count = min_t(unsigned int, blocks, max_count);
+		ret = dm_zoned_reclaim_read(dzt, from_zone, block, count, pl);
+		if (ret)
+			goto out;
+
+		/* Write blocks */
+		ret = dm_zoned_reclaim_write(dzt, to_zone, block, count, pl);
+		if (ret)
+			goto out;
+
+		block += count;
+		blocks -= count;
+
+	}
+
+	/* Validate written blocks */
+	ret = dm_zoned_validate_blocks(dzt, to_zone, chunk_block, nr_blocks);
+
+out:
+	dm_zoned_reclaim_free_page_list(dzt, pl, max_count);
+
+	return ret;
+}
+
+/**
+ * Get a zone for reclaim.
+ */
+static inline int
+dm_zoned_reclaim_lock(struct dm_zoned_target *dzt,
+		      struct dm_zoned_zone *dzone)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	/* Skip active zones */
+	dm_zoned_lock_zone(dzone, flags);
+	if (!test_bit(DM_ZONE_ACTIVE, &dzone->flags)
+	    && !test_and_set_bit(DM_ZONE_RECLAIM, &dzone->flags))
+		ret = 1;
+	dm_zoned_unlock_zone(dzone, flags);
+
+	return ret;
+}
+
+/**
+ * Clear a zone reclaim flag.
+ */
+static inline void
+dm_zoned_reclaim_unlock(struct dm_zoned_target *dzt,
+			struct dm_zoned_zone *dzone)
+{
+	unsigned long flags;
+
+	dm_zoned_lock_zone(dzone, flags);
+	clear_bit_unlock(DM_ZONE_RECLAIM, &dzone->flags);
+	smp_mb__after_atomic();
+	wake_up_bit(&dzone->flags, DM_ZONE_RECLAIM);
+	dm_zoned_unlock_zone(dzone, flags);
+}
+
+/**
+ * Write valid blocks of @dzone into its buffer zone
+ * and swap the buffer zone with with @wzone.
+ */
+static void
+dm_zoned_reclaim_remap_buffer(struct dm_zoned_target *dzt,
+			      struct dm_zoned_zone *dzone,
+			      struct dm_zoned_zone *wzone)
+{
+	struct dm_zoned_zone *bzone = dzone->bzone;
+	struct dm_zoned_zone *rzone;
+	unsigned int nr_blocks;
+	sector_t chunk_block = 0;
+	int ret = 0;
+
+	dm_zoned_dev_debug(dzt, "Reclaim: Remap bzone %lu as dzone "
+			   "(new bzone %lu, %s dzone %lu)\n",
+			   bzone->id,
+			   wzone->id,
+			   dm_zoned_zone_is_cmr(dzone) ? "CMR" : "SMR",
+			   dzone->id);
+
+	while (chunk_block < dzt->zone_nr_blocks) {
+
+		/* Test block validity in the data zone */
+		rzone = dzone;
+		if (chunk_block < dzone->wp_block) {
+			ret = dm_zoned_block_valid(dzt, dzone, chunk_block);
+			if (ret < 0)
+				break;
+		}
+		if (!ret) {
+			chunk_block++;
+			continue;
+		}
+
+		/* Copy and validate blocks */
+		nr_blocks = ret;
+		ret = dm_zoned_reclaim_copy(dzt, dzone, bzone, chunk_block, nr_blocks);
+		if (ret)
+			break;
+
+		chunk_block += nr_blocks;
+
+	}
+
+	if (ret) {
+		/* Free the target data zone */
+		dm_zoned_invalidate_zone(dzt, wzone);
+		dm_zoned_free_dzone(dzt, wzone);
+		goto out;
+	}
+
+	/* Remap bzone to dzone chunk and set wzone as a buffer zone */
+	dm_zoned_reclaim_lock(dzt, bzone);
+	dm_zoned_remap_bzone(dzt, bzone, wzone);
+
+	/* Invalidate all blocks in the data zone and free it */
+	dm_zoned_invalidate_zone(dzt, dzone);
+	dm_zoned_free_dzone(dzt, dzone);
+
+out:
+	dm_zoned_reclaim_unlock(dzt, bzone);
+	dm_zoned_reclaim_unlock(dzt, wzone);
+}
+
+/**
+ * Merge valid blocks of @dzone and of its buffer zone into @wzone.
+ */
+static void
+dm_zoned_reclaim_merge_buffer(struct dm_zoned_target *dzt,
+			      struct dm_zoned_zone *dzone,
+			      struct dm_zoned_zone *wzone)
+{
+	struct dm_zoned_zone *bzone = dzone->bzone;
+	struct dm_zoned_zone *rzone;
+	unsigned int nr_blocks;
+	sector_t chunk_block = 0;
+	int ret = 0;
+
+	dm_zoned_dev_debug(dzt, "Reclaim: Merge zones %lu and %lu into %s dzone %lu\n",
+			   bzone->id,
+			   dzone->id,
+			   dm_zoned_zone_is_cmr(wzone) ? "CMR" : "SMR",
+			   wzone->id);
+
+	while (chunk_block < dzt->zone_nr_blocks) {
+
+		/* Test block validity in the data zone */
+		rzone = dzone;
+		if (chunk_block < dzone->wp_block) {
+			ret = dm_zoned_block_valid(dzt, dzone, chunk_block);
+			if (ret < 0)
+				break;
+		}
+		if (!ret) {
+			/* Check the buffer zone */
+			rzone = bzone;
+			ret = dm_zoned_block_valid(dzt, bzone, chunk_block);
+			if (ret < 0)
+				break;
+			if (!ret) {
+				chunk_block++;
+				continue;
+			}
+		}
+
+		/* Copy and validate blocks */
+		nr_blocks = ret;
+		ret = dm_zoned_reclaim_copy(dzt, rzone, wzone, chunk_block, nr_blocks);
+		if (ret)
+			break;
+
+		chunk_block += nr_blocks;
+
+	}
+
+	if (ret) {
+		/* Free the target data zone */
+		dm_zoned_invalidate_zone(dzt, wzone);
+		dm_zoned_free_dzone(dzt, wzone);
+		goto out;
+	}
+
+	/* Invalidate all blocks of the buffer zone and free it */
+	dm_zoned_invalidate_zone(dzt, bzone);
+	dm_zoned_free_bzone(dzt, bzone);
+
+	/* Finally, remap dzone to wzone */
+	dm_zoned_remap_dzone(dzt, dzone, wzone);
+	dm_zoned_invalidate_zone(dzt, dzone);
+	dm_zoned_free_dzone(dzt, dzone);
+
+out:
+	dm_zoned_reclaim_unlock(dzt, wzone);
+}
+
+/**
+ * Move valid blocks of the buffer zone into the data zone.
+ */
+static void
+dm_zoned_reclaim_flush_buffer(struct dm_zoned_target *dzt,
+			      struct dm_zoned_zone *dzone)
+{
+	struct dm_zoned_zone *bzone = dzone->bzone;
+	unsigned int nr_blocks;
+	sector_t chunk_block = 0;
+	int ret = 0;
+
+	dm_zoned_dev_debug(dzt, "Reclaim: Flush buffer zone %lu into %s dzone %lu\n",
+			   bzone->id,
+			   dm_zoned_zone_is_cmr(dzone) ? "CMR" : "SMR",
+			   dzone->id);
+
+	/* The data zone may be empty due to discard after writes. */
+	/* So reset it before writing the buffer zone blocks.      */
+	dm_zoned_reset_zone_wp(dzt, dzone);
+
+	while (chunk_block < dzt->zone_nr_blocks) {
+
+		/* Test block validity */
+		ret = dm_zoned_block_valid(dzt, bzone, chunk_block);
+		if (ret < 0)
+			break;
+		if (!ret) {
+			chunk_block++;
+			continue;
+		}
+
+		/* Copy and validate blocks */
+		nr_blocks = ret;
+		ret = dm_zoned_reclaim_copy(dzt, bzone, dzone, chunk_block, nr_blocks);
+		if (ret)
+			break;
+
+		chunk_block += nr_blocks;
+
+	}
+
+	if (ret) {
+		/* Cleanup the data zone */
+		dm_zoned_invalidate_zone(dzt, dzone);
+		dm_zoned_reset_zone_wp(dzt, dzone);
+		return;
+	}
+
+	/* Invalidate all blocks of the buffer zone and free it */
+	dm_zoned_invalidate_zone(dzt, bzone);
+	dm_zoned_free_bzone(dzt, bzone);
+}
+
+/**
+ * Free empty data zone and buffer zone.
+ */
+static void
+dm_zoned_reclaim_empty(struct dm_zoned_target *dzt,
+		       struct dm_zoned_zone *dzone)
+{
+
+	dm_zoned_dev_debug(dzt, "Reclaim: Chunk %zu, free empty dzone %lu\n",
+			   dzone->map,
+			   dzone->id);
+
+	if (dzone->bzone)
+		dm_zoned_free_bzone(dzt, dzone->bzone);
+	dm_zoned_free_dzone(dzt, dzone);
+}
+
+/**
+ * Choose a reclaim zone target for merging/flushing a buffer zone.
+ */
+static struct dm_zoned_zone *
+dm_zoned_reclaim_target(struct dm_zoned_target *dzt,
+			struct dm_zoned_zone *dzone)
+{
+	struct dm_zoned_zone *wzone;
+	unsigned int blocks = dzone->wr_dir_blocks + dzone->wr_buf_blocks;
+	int type = DM_DZONE_ANY;
+
+	dm_zoned_dev_debug(dzt, "Reclaim: Zone %lu, %lu%% buffered blocks\n",
+			   dzone->id,
+			   (blocks ? dzone->wr_buf_blocks * 100 / blocks : 0));
+
+	/* Over 75 % of random write blocks -> cmr */
+	if (!dzone->wr_dir_blocks
+	    || (blocks &&
+		(dzone->wr_buf_blocks * 100 / blocks) >= 75))
+		type = DM_DZONE_CMR;
+
+	/* Get a data zone for merging */
+	dm_zoned_map_lock(dzt);
+	wzone = dm_zoned_alloc_dzone(dzt, DM_ZONED_MAP_UNMAPPED, type);
+	if (wzone) {
+		/*
+		 * When the merge zone will be remapped, it may
+		 * be accessed right away. Mark it as reclaim
+		 * in order to properly cleanup the source data
+		 * zone before any access.
+		 */
+		dm_zoned_reclaim_lock(dzt, wzone);
+	}
+	dm_zoned_map_unlock(dzt);
+
+	dm_zoned_zone_reset_stats(dzone);
+
+	return wzone;
+}
+
+/**
+ * Reclaim the buffer zone of @dzone.
+ */
+static void
+dm_zoned_reclaim_bzone(struct dm_zoned_target *dzt,
+		       struct dm_zoned_zone *bzone)
+{
+	struct dm_zoned_zone *dzone = bzone->bzone;
+	struct dm_zoned_zone *wzone;
+	int bweight, dweight;
+
+	/* Paranoia checks */
+	dm_zoned_dev_assert(dzt, dzone != NULL);
+	dm_zoned_dev_assert(dzt, dzone->bzone == bzone);
+	dm_zoned_dev_assert(dzt, !test_bit(DM_ZONE_ACTIVE, &dzone->flags));
+
+	dweight = dm_zoned_zone_weight(dzt, dzone);
+	bweight = dm_zoned_zone_weight(dzt, bzone);
+	dm_zoned_dev_debug(dzt, "Reclaim: Chunk %zu, dzone %lu (weight %d), "
+			   "bzone %lu (weight %d)\n",
+			   dzone->map, dzone->id, dweight,
+			   bzone->id, bweight);
+
+	/* If everything is invalid, free the zones */
+	if (!dweight && !bweight) {
+		dm_zoned_reclaim_empty(dzt, dzone);
+		goto out;
+	}
+
+	/* If all valid blocks are in the buffer zone, */
+	/* move them directly into the data zone.      */
+	if (!dweight) {
+		dm_zoned_reclaim_flush_buffer(dzt, dzone);
+		goto out;
+	}
+
+	/* Buffer zone and data zone need to be merged in a a new data zone */
+	wzone = dm_zoned_reclaim_target(dzt, dzone);
+	if (!wzone) {
+		dm_zoned_dev_error(dzt, "Reclaim: No target zone available "
+				   "for merge reclaim\n");
+		goto out;
+	}
+
+	/* If the target zone is CMR, write valid blocks of the data zone  */
+	/* into the buffer zone and swap the buffer zone and new data zone */
+	/* But do this only if it is less costly (less blocks to move)     */
+	/* than a regular merge.                                           */
+	if (dm_zoned_zone_is_cmr(wzone) && bweight > dweight) {
+		dm_zoned_reclaim_remap_buffer(dzt, dzone, wzone);
+		goto out;
+	}
+
+	/* Otherwise, merge the valid blocks of the buffer zone and data   */
+	/* zone into an newly allocated SMR data zone. On success, the new */
+	/* data zone is remapped to the chunk of the original data zone    */
+	dm_zoned_reclaim_merge_buffer(dzt, dzone, wzone);
+
+out:
+	dm_zoned_reclaim_unlock(dzt, dzone);
+}
+
+/**
+ * Reclaim buffer zone work.
+ */
+static void
+dm_zoned_reclaim_bzone_work(struct work_struct *work)
+{
+	struct dm_zoned_reclaim_zwork *rzwork = container_of(work,
+					struct dm_zoned_reclaim_zwork, work);
+	struct dm_zoned_target *dzt = rzwork->target;
+
+	dm_zoned_reclaim_bzone(dzt, rzwork->bzone);
+
+	kfree(rzwork);
+}
+
+/**
+ * Select a buffer zone candidate for reclaim.
+ */
+static struct dm_zoned_zone *
+dm_zoned_reclaim_bzone_candidate(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_zone *bzone;
+
+	/* Search for a buffer zone candidate to reclaim */
+	dm_zoned_map_lock(dzt);
+
+	if (list_empty(&dzt->bz_lru_list))
+		goto out;
+
+	bzone = list_first_entry(&dzt->bz_lru_list, struct dm_zoned_zone, link);
+	while (bzone) {
+		if (dm_zoned_reclaim_lock(dzt, bzone->bzone)) {
+			dm_zoned_map_unlock(dzt);
+			return bzone;
+		}
+		if (list_is_last(&bzone->link, &dzt->bz_lru_list))
+			break;
+		bzone = list_next_entry(bzone, link);
+	}
+
+out:
+	dm_zoned_map_unlock(dzt);
+
+	return NULL;
+
+}
+
+/**
+ * Start reclaim workers.
+ */
+static int
+dm_zoned_reclaim_bzones(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_zone *bzone = NULL;
+	struct dm_zoned_reclaim_zwork *rzwork;
+	unsigned int max_workers = 0, nr_free;
+	unsigned long start;
+	int n = 0;
+
+	/* Try reclaim if there are used buffer zones AND the disk */
+	/* is idle, or, the number of free buffer zones is low.    */
+	nr_free = atomic_read(&dzt->bz_nr_free);
+	if (nr_free < dzt->bz_nr_free_low)
+		max_workers = dzt->bz_nr_free_low - nr_free;
+	else if (atomic_read(&dzt->dz_nr_active_wait))
+		max_workers = atomic_read(&dzt->dz_nr_active_wait);
+	else if (dm_zoned_idle(dzt))
+		max_workers = 1;
+	max_workers = min(max_workers, (unsigned int)DM_ZONED_RECLAIM_MAX_WORKERS);
+
+	start = jiffies;
+	while (n < max_workers) {
+
+		bzone = dm_zoned_reclaim_bzone_candidate(dzt);
+		if (!bzone)
+			break;
+
+		if (max_workers == 1) {
+			/* Do it in this context */
+			dm_zoned_reclaim_bzone(dzt, bzone);
+		} else {
+			/* Start a zone reclaim work */
+			rzwork = kmalloc(sizeof(struct dm_zoned_reclaim_zwork), GFP_KERNEL);
+			if (unlikely(!rzwork))
+				break;
+			INIT_WORK(&rzwork->work, dm_zoned_reclaim_bzone_work);
+			rzwork->target = dzt;
+			rzwork->bzone = bzone;
+			queue_work(dzt->reclaim_zwq, &rzwork->work);
+		}
+
+		n++;
+
+	}
+
+	if (n) {
+		flush_workqueue(dzt->reclaim_zwq);
+		dm_zoned_flush(dzt);
+		dm_zoned_dev_debug(dzt, "Reclaim: %d bzones reclaimed in %u msecs\n",
+				   n,
+				   jiffies_to_msecs(jiffies - start));
+	}
+
+	return n;
+}
+
+/**
+ * Reclaim unbuffered data zones marked as empty.
+ */
+static int
+dm_zoned_reclaim_dzones(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_zone *dz, *dzone;
+	int ret;
+
+	dm_zoned_map_lock(dzt);
+
+	/* If not idle, do only CMR zones */
+	while (!list_empty(&dzt->dz_empty_list)) {
+
+		/* Search for a candidate to reclaim */
+		dzone = NULL;
+		list_for_each_entry(dz, &dzt->dz_empty_list, elink) {
+			if (!dm_zoned_idle(dzt) && !dm_zoned_zone_is_cmr(dz))
+				continue;
+			dzone = dz;
+			break;
+		}
+
+		if (!dzone || !dm_zoned_reclaim_lock(dzt, dzone))
+			break;
+
+		clear_bit_unlock(DM_ZONE_EMPTY, &dzone->flags);
+		smp_mb__after_atomic();
+		list_del_init(&dzone->elink);
+
+		dm_zoned_map_unlock(dzt);
+
+		if (dm_zoned_zone_weight(dzt, dzone) == 0)
+			dm_zoned_reclaim_empty(dzt, dzone);
+		dm_zoned_reclaim_unlock(dzt, dzone);
+
+		dm_zoned_map_lock(dzt);
+
+	}
+
+	ret = !list_empty(&dzt->dz_empty_list);
+
+	dm_zoned_map_unlock(dzt);
+
+	return ret;
+}
+
+/**
+ * Buffer zone reclaim work.
+ */
+void
+dm_zoned_reclaim_work(struct work_struct *work)
+{
+	struct dm_zoned_target *dzt = container_of(work,
+		struct dm_zoned_target, reclaim_work.work);
+	int have_empty_dzones;
+	int reclaimed_bzones;
+	unsigned long delay;
+
+	/* Try to reclaim buffer zones */
+	set_bit(DM_ZONED_RECLAIM_ACTIVE, &dzt->flags);
+	smp_mb__after_atomic();
+
+	dm_zoned_dev_debug(dzt, "Reclaim: %u/%u free bzones, disk %s, %d active zones (%d waiting)\n",
+			   atomic_read(&dzt->bz_nr_free),
+			   dzt->nr_buf_zones,
+			   (dm_zoned_idle(dzt) ? "idle" : "busy"),
+			   atomic_read(&dzt->dz_nr_active),
+			   atomic_read(&dzt->dz_nr_active_wait));
+
+	/* Reclaim empty data zones */
+	have_empty_dzones = dm_zoned_reclaim_dzones(dzt);
+
+	/* Reclaim buffer zones */
+	reclaimed_bzones = dm_zoned_reclaim_bzones(dzt);
+
+	if (atomic_read(&dzt->bz_nr_free) < dzt->nr_buf_zones ||
+	    have_empty_dzones) {
+		if (dm_zoned_idle(dzt)) {
+			delay = 0;
+		} else if (atomic_read(&dzt->dz_nr_active_wait) ||
+			 (atomic_read(&dzt->bz_nr_free) < dzt->bz_nr_free_low)) {
+			if (reclaimed_bzones)
+				delay = 0;
+			else
+				delay = HZ / 2;
+		} else
+			delay = DM_ZONED_RECLAIM_PERIOD;
+		dm_zoned_schedule_reclaim(dzt, delay);
+	}
+
+	clear_bit_unlock(DM_ZONED_RECLAIM_ACTIVE, &dzt->flags);
+	smp_mb__after_atomic();
+}
+
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
new file mode 100644
index 0000000..ea0ee92
--- /dev/null
+++ b/drivers/md/dm-zoned.h
@@ -0,0 +1,687 @@
+/*
+ * (C) Copyright 2016 Western Digital.
+ *
+ * This software is distributed under the terms of the GNU Lesser General
+ * Public License version 2, or any later version, "as is," without technical
+ * support, and WITHOUT ANY WARRANTY, without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Author: Damien Le Moal <damien.lemoal@hgst.com>
+ */
+#include <linux/types.h>
+#include <linux/blkdev.h>
+#include <linux/device-mapper.h>
+#include <linux/dm-io.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/rwsem.h>
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
+#include <linux/buffer_head.h>
+
+/**
+ * Enable to get debug messages support.
+ */
+#undef __DM_ZONED_DEBUG
+
+/**
+ * Version.
+ */
+#define DM_ZONED_VER_MAJ			0
+#define DM_ZONED_VER_MIN			1
+
+/**
+ * Zone type (high 4 bits of zone flags).
+ */
+#define DM_ZONE_META		0x10000000
+#define DM_ZONE_BUF		0x20000000
+#define DM_ZONE_DATA		0x30000000
+#define DM_ZONE_TYPE_MASK	0xF0000000
+
+/**
+ * Zone flags.
+ */
+enum {
+	DM_ZONE_ACTIVE,
+	DM_ZONE_ACTIVE_BIO,
+	DM_ZONE_ACTIVE_WAIT,
+	DM_ZONE_BUFFERED,
+	DM_ZONE_DIRTY,
+	DM_ZONE_EMPTY,
+	DM_ZONE_RECLAIM,
+};
+
+/**
+ * dm device emulates 4K blocks.
+ */
+#define DM_ZONED_BLOCK_SHIFT		12
+#define DM_ZONED_BLOCK_SIZE		(1 << DM_ZONED_BLOCK_SHIFT)
+#define DM_ZONED_BLOCK_MASK		(DM_ZONED_BLOCK_SIZE - 1)
+
+#define DM_ZONED_BLOCK_SHIFT_BITS	(DM_ZONED_BLOCK_SHIFT + 3)
+#define DM_ZONED_BLOCK_SIZE_BITS	(DM_ZONED_BLOCK_SIZE << 3)
+#define DM_ZONED_BLOCK_MASK_BITS	(DM_ZONED_BLOCK_SIZE_BITS - 1)
+
+#define DM_ZONED_BLOCK_SECTORS		(DM_ZONED_BLOCK_SIZE >> SECTOR_SHIFT)
+#define DM_ZONED_BLOCK_SECTORS_MASK	(DM_ZONED_BLOCK_SECTORS - 1)
+
+#define dm_zoned_block_to_sector(b) \
+	((b) << (DM_ZONED_BLOCK_SHIFT - SECTOR_SHIFT))
+#define dm_zoned_sector_to_block(s) \
+	((s) >> (DM_ZONED_BLOCK_SHIFT - SECTOR_SHIFT))
+
+#define DM_ZONED_MIN_BIOS		128
+
+/**
+ * On-disk super block (sector 0 of the target device).
+ */
+#define DM_ZONED_MAGIC	((((unsigned int)('D')) << 24) | \
+			 (((unsigned int)('S')) << 16) | \
+			 (((unsigned int)('M')) <<  8) | \
+			 ((unsigned int)('R')))
+#define DM_ZONED_META_VER		1
+
+/**
+ * On disk metadata:
+ *    - Block 0 stores the super block.
+ *    - From block 1, nr_map_blocks blocks of data zone mapping entries
+ *    - From block nr_map_blocks+1, nr_bitmap_blocks blocks of zone
+ *      block bitmap.
+ */
+
+/**
+ * Buffer zones mapping entry: each entry allows to first identify
+ * the zones of the backen device that are used as buffer zones
+ * (using bzone_id), and second, the number of the zone being buffered.
+ * For unused buffer zones, the data zone ID is set to 0.
+ */
+struct dm_zoned_bz_map {
+	__le32			bzone_id;			/*    4 */
+	__le32			dzone_id;			/*    8 */
+};
+
+#define DM_ZONED_NR_BZONES		32
+#define DM_ZONED_NR_BZONES_MIN		4
+#define DM_ZONED_NR_BZONES_LOW		25
+#define DM_ZONED_NR_BZONES_LOW_MIN	2
+
+/**
+ * Buffer zones mapping entries are stored in the super block.
+ * At most DM_ZONED_NR_BZONES_MAX fit (= 496).
+ */
+#define DM_ZONED_NR_BZONES_MAX	((4096 - 104) / sizeof(struct dm_zoned_bz_map))
+
+struct dm_zoned_super {
+
+	__le32			magic;				/*    4 */
+	__le32			version;			/*    8 */
+
+	__le32			nr_buf_zones;			/*   12 */
+	__le32			nr_data_zones;			/*   16 */
+	__le32			nr_map_blocks;			/*   20 */
+	__le32			nr_bitmap_blocks;		/*   24 */
+
+	u8			reserved[104];			/*  128 */
+
+	struct dm_zoned_bz_map	bz_map[DM_ZONED_NR_BZONES_MAX];	/* 4096 */
+
+};
+
+/**
+ * Zone mapping table metadata.
+ */
+#define DM_ZONED_MAP_ENTRIES_PER_BLOCK	(DM_ZONED_BLOCK_SIZE / sizeof(u32))
+#define DM_ZONED_MAP_ENTRIES_SHIFT	(ilog2(DM_ZONED_MAP_ENTRIES_PER_BLOCK))
+#define DM_ZONED_MAP_ENTRIES_MASK	(DM_ZONED_MAP_ENTRIES_PER_BLOCK - 1)
+#define DM_ZONED_MAP_UNMAPPED		UINT_MAX
+
+#define DM_ZONE_WORK_MAX	128
+#define DM_ZONE_WORK_MAX_BIO	64
+
+struct dm_zoned_target;
+struct dm_zoned_zone;
+
+/**
+ * Zone work descriptor: this exists only
+ * for active zones.
+ */
+struct dm_zoned_zwork {
+	struct work_struct	work;
+
+	struct dm_zoned_target	*target;
+	struct dm_zoned_zone	*dzone;
+
+	struct list_head	link;
+
+	/* ref counts the number of BIOs pending   */
+	/* and executing, as well as, the queueing */
+	/* status of the work_struct.              */
+	atomic_t		ref;
+	atomic_t		bio_count;
+	struct bio_list		bio_list;
+
+};
+
+/**
+ * Zone descriptor.
+ */
+struct dm_zoned_zone {
+	struct list_head	link;
+	struct list_head	elink;
+	struct blk_zone		*blkz;
+	struct dm_zoned_zwork	*zwork;
+	unsigned long		flags;
+	unsigned long		id;
+
+	/* For data zones, pointer to a write buffer zone (may be NULL)    */
+	/* For write buffer zones, pointer to the data zone being buffered */
+	struct dm_zoned_zone	*bzone;
+
+	/* For data zones: the logical chunk mapped, which */
+	/* is also the index of the entry for the zone in  */
+	/* the data zone mapping table.                    */
+	/* For buffer zones: the index of the entry for    */
+	/* zone in the buffer zone mapping table stored in */
+	/* the super block.                                */
+	sector_t		map;
+
+	/* The position of the zone write pointer,  */
+	/* relative to the first block of the zone. */
+	sector_t		wp_block;
+
+	/* Stats (to determine access pattern for reclaim) */
+	unsigned long		mtime;
+	unsigned long		wr_dir_blocks;
+	unsigned long		wr_buf_blocks;
+
+};
+
+extern struct kmem_cache *dm_zoned_zone_cache;
+
+#define dm_zoned_lock_zone(zone, flags) \
+	spin_lock_irqsave(&(zone)->blkz->lock, flags)
+#define dm_zoned_unlock_zone(zone, flags) \
+	spin_unlock_irqrestore(&(zone)->blkz->lock, flags)
+#define dm_zoned_zone_is_cmr(z) \
+	blk_zone_is_cmr((z)->blkz)
+#define dm_zoned_zone_is_smr(z) \
+	blk_zone_is_smr((z)->blkz)
+#define dm_zoned_zone_is_seqreq(z) \
+	((z)->blkz->type == BLK_ZONE_TYPE_SEQWRITE_REQ)
+#define dm_zoned_zone_is_seqpref(z) \
+	((z)->blkz->type == BLK_ZONE_TYPE_SEQWRITE_PREF)
+#define dm_zoned_zone_is_seq(z) \
+	(dm_zoned_zone_is_seqreq(z) || dm_zoned_zone_is_seqpref(z))
+#define dm_zoned_zone_is_rnd(z) \
+	(dm_zoned_zone_is_cmr(z) || dm_zoned_zone_is_seqpref(z))
+
+#define dm_zoned_zone_offline(z) \
+	((z)->blkz->state == BLK_ZONE_OFFLINE)
+#define dm_zoned_zone_readonly(z) \
+	((z)->blkz->state == BLK_ZONE_READONLY)
+
+#define dm_zoned_zone_start_sector(z) \
+	((z)->blkz->start)
+#define dm_zoned_zone_sectors(z) \
+	((z)->blkz->len)
+#define dm_zoned_zone_next_sector(z) \
+	(dm_zoned_zone_start_sector(z) + dm_zoned_zone_sectors(z))
+#define dm_zoned_zone_start_block(z) \
+	dm_zoned_sector_to_block(dm_zoned_zone_start_sector(z))
+#define dm_zoned_zone_next_block(z) \
+	dm_zoned_sector_to_block(dm_zoned_zone_next_sector(z))
+#define dm_zoned_zone_empty(z) \
+	((z)->wp_block == dm_zoned_zone_start_block(z))
+
+#define dm_zoned_chunk_sector(dzt, s) \
+	((s) & (dzt)->zone_nr_sectors_mask)
+#define dm_zoned_chunk_block(dzt, b) \
+	((b) & (dzt)->zone_nr_blocks_mask)
+
+#define dm_zoned_zone_type(z) \
+	((z)->flags & DM_ZONE_TYPE_MASK)
+#define dm_zoned_zone_meta(z) \
+	(dm_zoned_zone_type(z) == DM_ZONE_META)
+#define dm_zoned_zone_buf(z) \
+	(dm_zoned_zone_type(z) == DM_ZONE_BUF)
+#define dm_zoned_zone_data(z) \
+	(dm_zoned_zone_type(z) == DM_ZONE_DATA)
+
+#define dm_zoned_bio_sector(bio) \
+	((bio)->bi_iter.bi_sector)
+#define dm_zoned_bio_chunk_sector(dzt, bio) \
+	dm_zoned_chunk_sector((dzt), dm_zoned_bio_sector(bio))
+#define dm_zoned_bio_sectors(bio) \
+	bio_sectors(bio)
+#define dm_zoned_bio_block(bio) \
+	dm_zoned_sector_to_block(dm_zoned_bio_sector(bio))
+#define dm_zoned_bio_blocks(bio) \
+	dm_zoned_sector_to_block(dm_zoned_bio_sectors(bio))
+#define dm_zoned_bio_chunk(dzt, bio) \
+	(dm_zoned_bio_sector(bio) >> (dzt)->zone_nr_sectors_shift)
+#define dm_zoned_bio_chunk_block(dzt, bio) \
+	dm_zoned_chunk_block((dzt), dm_zoned_bio_block(bio))
+
+/**
+ * Reset a zone stats.
+ */
+static inline void
+dm_zoned_zone_reset_stats(struct dm_zoned_zone *zone)
+{
+	zone->mtime = 0;
+	zone->wr_dir_blocks = 0;
+	zone->wr_buf_blocks = 0;
+}
+
+/**
+ * For buffer zone reclaim.
+ */
+#define DM_ZONED_RECLAIM_PERIOD_SECS	1UL /* Reclaim check period (seconds) */
+#define DM_ZONED_RECLAIM_PERIOD		(DM_ZONED_RECLAIM_PERIOD_SECS * HZ)
+#define DM_ZONED_RECLAIM_MAX_BLOCKS	1024 /* Max 4 KB blocks per reclaim I/O */
+#define DM_ZONED_RECLAIM_MAX_WORKERS	4 /* Maximum number of buffer zone reclaim works */
+
+struct dm_zoned_reclaim_zwork {
+	struct work_struct	work;
+	struct dm_zoned_target	*target;
+	struct dm_zoned_zone	*bzone;
+};
+
+/**
+ * Default maximum number of blocks for
+ * an SMR zone WP alignment with WRITE SAME.
+ * (0 => disable align wp)
+ */
+#define DM_ZONED_ALIGN_WP_MAX_BLOCK	0
+
+/**
+ * Target flags.
+ */
+enum {
+	DM_ZONED_DEBUG,
+	DM_ZONED_ALIGN_WP,
+	DM_ZONED_SUSPENDED,
+	DM_ZONED_RECLAIM_ACTIVE,
+};
+
+/**
+ * Target descriptor.
+ */
+struct dm_zoned_target {
+	struct dm_dev		*ddev;
+
+	/* Target zoned device information */
+	char			zbd_name[BDEVNAME_SIZE];
+	struct block_device	*zbd;
+	sector_t		zbd_capacity;
+	struct request_queue	*zbdq;
+	unsigned int		zbd_metablk_shift;
+	unsigned long		flags;
+	struct buffer_head	*sb_bh;
+
+	unsigned int		nr_zones;
+	unsigned int		nr_cmr_zones;
+	unsigned int		nr_smr_zones;
+	unsigned int		nr_rnd_zones;
+	unsigned int		nr_meta_zones;
+	unsigned int		nr_buf_zones;
+	unsigned int		nr_data_zones;
+	unsigned int		nr_cmr_data_zones;
+	unsigned int		nr_smr_data_zones;
+
+#ifdef __DM_ZONED_DEBUG
+	size_t			used_mem;
+#endif
+
+	sector_t		zone_nr_sectors;
+	unsigned int		zone_nr_sectors_shift;
+	sector_t		zone_nr_sectors_mask;
+
+	sector_t		zone_nr_blocks;
+	sector_t		zone_nr_blocks_shift;
+	sector_t		zone_nr_blocks_mask;
+	sector_t		zone_bitmap_size;
+	unsigned int		zone_nr_bitmap_blocks;
+
+	/* Zone mapping management lock */
+	struct mutex		map_lock;
+
+	/* Zone bitmaps */
+	sector_t		bitmap_block;
+	unsigned int		nr_bitmap_blocks;
+
+	/* Buffer zones */
+	struct dm_zoned_bz_map	*bz_map;
+	atomic_t		bz_nr_free;
+	unsigned int		bz_nr_free_low;
+	struct list_head	bz_free_list;
+	struct list_head	bz_lru_list;
+	struct list_head	bz_wait_list;
+
+	/* Data zones */
+	unsigned int		nr_map_blocks;
+	unsigned int		align_wp_max_blocks;
+	struct buffer_head	**dz_map_bh;
+	atomic_t		dz_nr_active;
+	atomic_t		dz_nr_active_wait;
+	unsigned int		dz_nr_unmap;
+	struct list_head	dz_unmap_cmr_list;
+	struct list_head	dz_map_cmr_list;
+	struct list_head	dz_unmap_smr_list;
+	struct list_head	dz_empty_list;
+
+	/* Internal I/Os */
+	struct bio_set		*bio_set;
+	struct workqueue_struct *zone_wq;
+	unsigned long		last_bio_time;
+
+	/* For flush */
+	spinlock_t		flush_lock;
+	struct bio_list		flush_list;
+	struct work_struct	flush_work;
+	struct workqueue_struct *flush_wq;
+
+	/* For reclaim */
+	struct dm_io_client	*reclaim_client;
+	struct delayed_work	reclaim_work;
+	struct workqueue_struct *reclaim_wq;
+	struct workqueue_struct *reclaim_zwq;
+
+};
+
+#define dm_zoned_map_lock(dzt)		mutex_lock(&(dzt)->map_lock)
+#define dm_zoned_map_unlock(dzt)	mutex_unlock(&(dzt)->map_lock)
+
+/**
+ * Number of seconds without BIO to consider
+ * the device idle.
+ */
+#define DM_ZONED_IDLE_SECS		2UL
+
+/**
+ * Test if the target device is idle.
+ */
+static inline int
+dm_zoned_idle(struct dm_zoned_target *dzt)
+{
+	return atomic_read(&(dzt)->dz_nr_active) == 0 &&
+		time_is_before_jiffies(dzt->last_bio_time
+				       + DM_ZONED_IDLE_SECS * HZ);
+}
+
+/**
+ * Target config passed as dmsetup arguments.
+ */
+struct dm_zoned_target_config {
+	char			*dev_path;
+	int			debug;
+	int			format;
+	unsigned long		align_wp;
+	unsigned long		nr_buf_zones;
+};
+
+/**
+ * Zone BIO context.
+ */
+struct dm_zoned_bioctx {
+	struct dm_zoned_target	*target;
+	struct dm_zoned_zone	*dzone;
+	struct bio		*bio;
+	atomic_t		ref;
+	int			error;
+};
+
+#define dm_zoned_info(format, args...)			\
+	printk(KERN_INFO "dm-zoned: " format, ## args)
+
+#define dm_zoned_dev_info(target, format, args...)	\
+	dm_zoned_info("(%s) " format,			\
+		      (dzt)->zbd_name, ## args)
+
+#define dm_zoned_error(format, args...)			\
+	printk(KERN_ERR	"dm-zoned: " format, ## args)
+
+#define dm_zoned_dev_error(dzt, format, args...)	\
+	dm_zoned_error("(%s) " format,			\
+		       (dzt)->zbd_name, ## args)
+
+#define dm_zoned_warning(format, args...)		\
+	printk(KERN_ALERT				\
+	       "dm-zoned: " format, ## args)
+
+#define dm_zoned_dev_warning(dzt, format, args...)	\
+	dm_zoned_warning("(%s) " format,		\
+			 (dzt)->zbd_name, ## args)
+
+#define dm_zoned_dump_stack()				\
+	do {						\
+		dm_zoned_warning("Start stack dump\n");	\
+		dump_stack();				\
+		dm_zoned_warning("End stack dump\n");	\
+	} while (0)
+
+#define dm_zoned_oops(format, args...)			\
+	do {						\
+		dm_zoned_warning(format, ## args);	\
+		dm_zoned_dump_stack();			\
+		BUG();					\
+	} while (0)
+
+#define dm_zoned_dev_oops(dzt, format, args...)			\
+	do {							\
+		dm_zoned_dev_warning(dzt, format, ## args);	\
+		dm_zoned_dump_stack();				\
+		BUG();						\
+	} while (0)
+
+#define dm_zoned_assert_cond(cond)	(unlikely(!(cond)))
+#define dm_zoned_assert(cond)					\
+	do {							\
+		if (dm_zoned_assert_cond(cond)) {		\
+			dm_zoned_oops("(%s/%d) "		\
+				      "Condition %s failed\n",	\
+				      __func__, __LINE__,	\
+				      # cond);			\
+		}						\
+	} while (0)
+
+#define dm_zoned_dev_assert(dzt, cond)					\
+	do {								\
+		if (dm_zoned_assert_cond(cond)) {			\
+			dm_zoned_dev_oops(dzt, "(%s/%d) "		\
+					  "Condition %s failed\n",	\
+					  __func__, __LINE__,		\
+					  # cond);			\
+		}							\
+	} while (0)
+
+#ifdef __DM_ZONED_DEBUG
+
+#define dm_zoned_dev_debug(dzt, format, args...)		\
+	do {							\
+		if (test_bit(DM_ZONED_DEBUG, &(dzt)->flags)) {	\
+			printk(KERN_INFO			\
+			       "dm-zoned: (%s) " format,	\
+			       (dzt)->zbd_name,	## args);	\
+		}						\
+	} while (0)
+
+
+#else
+
+#define dm_zoned_dev_debug(dzt, format, args...) \
+	do { } while (0)
+
+#endif /* __DM_ZONED_DEBUG */
+
+extern int
+dm_zoned_init_meta(struct dm_zoned_target *dzt,
+		   struct dm_zoned_target_config *conf);
+
+extern int
+dm_zoned_resume_meta(struct dm_zoned_target *dzt);
+
+extern void
+dm_zoned_cleanup_meta(struct dm_zoned_target *dzt);
+
+extern int
+dm_zoned_flush(struct dm_zoned_target *dzt);
+
+extern int
+dm_zoned_advance_zone_wp(struct dm_zoned_target *dzt,
+			 struct dm_zoned_zone *zone,
+			 sector_t nr_blocks);
+
+extern int
+dm_zoned_reset_zone_wp(struct dm_zoned_target *dzt,
+		       struct dm_zoned_zone *zone);
+
+extern struct dm_zoned_zone *
+dm_zoned_alloc_bzone(struct dm_zoned_target *dzt,
+		     struct dm_zoned_zone *dzone);
+
+extern void
+dm_zoned_free_bzone(struct dm_zoned_target *dzt,
+		    struct dm_zoned_zone *bzone);
+
+extern void
+dm_zoned_validate_bzone(struct dm_zoned_target *dzt,
+			struct dm_zoned_zone *dzone);
+
+/**
+ * Data zone allocation type hint.
+ */
+enum {
+	DM_DZONE_ANY,
+	DM_DZONE_SMR,
+	DM_DZONE_CMR
+};
+
+extern struct dm_zoned_zone *
+dm_zoned_alloc_dzone(struct dm_zoned_target *dzt,
+		     unsigned int chunk,
+		     unsigned int type_hint);
+
+extern void
+dm_zoned_free_dzone(struct dm_zoned_target *dzt,
+		    struct dm_zoned_zone *dzone);
+
+extern void
+dm_zoned_validate_dzone(struct dm_zoned_target *dzt,
+			struct dm_zoned_zone *dzone);
+
+extern void
+dm_zoned_remap_dzone(struct dm_zoned_target *dzt,
+		     struct dm_zoned_zone *from_dzone,
+		     struct dm_zoned_zone *to_dzone);
+
+extern void
+dm_zoned_remap_bzone(struct dm_zoned_target *dzt,
+		     struct dm_zoned_zone *bzone,
+		     struct dm_zoned_zone *new_bzone);
+
+extern struct dm_zoned_zone *
+dm_zoned_bio_map(struct dm_zoned_target *dzt,
+		 struct bio *bio);
+
+extern void
+dm_zoned_run_dzone(struct dm_zoned_target *dzt,
+		   struct dm_zoned_zone *dzone);
+
+extern void
+dm_zoned_put_dzone(struct dm_zoned_target *dzt,
+		   struct dm_zoned_zone *dzone);
+
+extern int
+dm_zoned_validate_blocks(struct dm_zoned_target *dzt,
+			 struct dm_zoned_zone *zone,
+			 sector_t chunk_block,
+			 unsigned int nr_blocks);
+
+extern int
+dm_zoned_invalidate_blocks(struct dm_zoned_target *dzt,
+			   struct dm_zoned_zone *zone,
+			   sector_t chunk_block,
+			   unsigned int nr_blocks);
+
+static inline int
+dm_zoned_invalidate_zone(struct dm_zoned_target *dzt,
+			 struct dm_zoned_zone *zone)
+{
+	return dm_zoned_invalidate_blocks(dzt, zone,
+					0, dzt->zone_nr_blocks);
+}
+
+extern int
+dm_zoned_block_valid(struct dm_zoned_target *dzt,
+		     struct dm_zoned_zone *zone,
+		     sector_t chunk_block);
+
+extern int
+dm_zoned_valid_blocks(struct dm_zoned_target *dzt,
+		      struct dm_zoned_zone *zone,
+		      sector_t chunk_block,
+		      unsigned int nr_blocks);
+
+static inline int
+dm_zoned_zone_weight(struct dm_zoned_target *dzt,
+		     struct dm_zoned_zone *zone)
+{
+	if (dm_zoned_zone_is_seqreq(zone)) {
+		if (dm_zoned_zone_empty(zone))
+			return 0;
+		return dm_zoned_valid_blocks(dzt, zone,
+				   0, zone->wp_block);
+	}
+
+	return dm_zoned_valid_blocks(dzt, zone,
+				   0, dzt->zone_nr_blocks);
+}
+
+/**
+ * Wait for a zone write BIOs to complete.
+ */
+static inline void
+dm_zoned_wait_for_stable_zone(struct dm_zoned_zone *zone)
+{
+	if (test_bit(DM_ZONE_ACTIVE_BIO, &zone->flags))
+		wait_on_bit_io(&zone->flags, DM_ZONE_ACTIVE_BIO,
+			       TASK_UNINTERRUPTIBLE);
+}
+
+extern void
+dm_zoned_zone_work(struct work_struct *work);
+
+extern void
+dm_zoned_reclaim_work(struct work_struct *work);
+
+/**
+ * Schedule reclaim (delay in jiffies).
+ */
+static inline void
+dm_zoned_schedule_reclaim(struct dm_zoned_target *dzt,
+			  unsigned long delay)
+{
+	mod_delayed_work(dzt->reclaim_wq, &dzt->reclaim_work, delay);
+}
+
+/**
+ * Trigger reclaim.
+ */
+static inline void
+dm_zoned_trigger_reclaim(struct dm_zoned_target *dzt)
+{
+	dm_zoned_schedule_reclaim(dzt, 0);
+}
+
+#ifdef __DM_ZONED_DEBUG
+static inline void
+dm_zoned_account_mem(struct dm_zoned_target *dzt,
+		     size_t bytes)
+{
+	dzt->used_mem += bytes;
+}
+#else
+#define dm_zoned_account_mem(dzt, bytes) do { } while (0)
+#endif
-- 
1.8.5.6

