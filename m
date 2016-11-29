From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] dm-zoned: Zoned block device target
Date: Tue, 29 Nov 2016 19:42:10 +0900
Message-ID: <1480416130-1011-1-git-send-email-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:33859 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752161AbcK2KnA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 05:43:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>

The dm-zoned device mapper provides transparent write access to zoned block
devices (ZBC and ZAC compliant devices). dm-zoned hides to the device user
(a file system or an application doing raw block device accesses) any
constraint imposed on write requests by the zoned block device.
Its primary target is host-managed devices but it can also be used with
host-aware models to mitigate potential device-side performance degradation
due to excessive random write.

dm-zoned implementation focus on simplicity and on minimizing overhead
(CPU, memory and storage overhead). For a 10TB host-manmaged disk with
256 MB zones, dm-zoned memory usage per disk instance is at most 4.5 MB
and as little as 5 zones will be used internally for storing metadata and
performaing reclaim operations.

This is a different solution from the zdm target proposed by Shaun.
Whereas zdm implements a full block translation layer to enable a
sequential write pattern to the zoned block device, dm-zoned only
implements zone indirection. This requires on-disk buffering of random
write accesses (using conventional zones), leading to lower write
performance. However, read performance can be maintained (no added
fragmentation) and internal metadata is simplified.

dm-zoned backend devices can be formatted and checked using the dmzadm
utility available at:

https://github.com/hgst/dm-zoned-tools

This patch applies on top of Jens Axboe linux-block tree, branch
for-4.10/block (this branch includes the block layer support for zoned
block devices, on which dm-zoned depends).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Documentation/device-mapper/dm-zoned.txt |  157 +++
 MAINTAINERS                              |    7 +
 drivers/md/Kconfig                       |   16 +
 drivers/md/Makefile                      |    2 +
 drivers/md/dm-zoned-io.c                 | 1106 +++++++++++++++
 drivers/md/dm-zoned-metadata.c           | 2211 ++++++++++++++++++++++++++++++
 drivers/md/dm-zoned-reclaim.c            |  699 ++++++++++
 drivers/md/dm-zoned.h                    |  570 ++++++++
 8 files changed, 4768 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-zoned.txt
 create mode 100644 drivers/md/dm-zoned-io.c
 create mode 100644 drivers/md/dm-zoned-metadata.c
 create mode 100644 drivers/md/dm-zoned-reclaim.c
 create mode 100644 drivers/md/dm-zoned.h

diff --git a/Documentation/device-mapper/dm-zoned.txt b/Documentation/device-mapper/dm-zoned.txt
new file mode 100644
index 0000000..32c8076
--- /dev/null
+++ b/Documentation/device-mapper/dm-zoned.txt
@@ -0,0 +1,157 @@
+dm-zoned
+========
+
+The dm-zoned device mapper provides transparent write access to zoned block
+devices (ZBC and ZAC compliant devices). It hides to the device user (a file
+system or an application doing raw block device accesses) any sequential write
+constraint on host-managed devices and can mitigate potential device-side
+performance degradation with host-aware zoned devices.
+
+For a more detailed description of the zoned block device models and
+their constraints see (for SCSI devices):
+
+http://www.t10.org/drafts.htm#ZBC_Family
+
+and (for ATA devices):
+
+http://www.t13.org/Documents/UploadedDocuments/docs2015/
+di537r05-Zoned_Device_ATA_Command_Set_ZAC.pdf
+
+dm-zoned implementation focused on simplicity and on minimizing overhead (CPU,
+memory and storage overhead). For a 10TB host-manmaged disk with 256 MB zones,
+dm-zoned memory usage per disk instance is at most 4.5 MB and as little as 5
+zones will be used internally for storing metadata and performaing reclaim
+operations.
+
+dm-zoned backend devices can be formatted and checked using the dmzadm utility
+available at:
+
+https://github.com/hgst/dm-zoned-tools
+
+Algorithm
+=========
+
+dm-zoned implements an on-disk buffering scheme to handle non-sequential write
+accesses to a zoned device sequential zones. Conventional zones are used for
+this, as well as for storing internal metadata.
+
+The zones of the device are separated into 2 types:
+
+1) Metadata zones: these are randomly writeable zones used to store metadata.
+Randomly writeable zones may be conventional zones or sequential write
+preferred zones (host-aware devices only). Metadata zones are not reported as
+useable capacity to the user.
+
+2) Data zones: All remaining zones, the majority of which will be sequential
+zones. These are used exclusively to store user data. The conventional zones
+(or part of the sequential write preferred zones on a host-aware device) may
+be used also for buffering user random writes. Data in these zones may be
+permanently mapped to the randomly writeable zone initially used, or moved
+to a sequential zone after some time so that the random zone can be reused for
+buffering new incoming random writes.
+
+dm-zoned exposes a logical device with a sector size of 4096 bytes,
+irrespectively of the physical sector size of the backend zoned device being
+used. This allows reducing the amount of metadata needed to manage valid blocks
+(blocks written). The on-disk metadata format is as follows:
+
+1) The first block of the first randomly writeable zone found contains the
+super block which describes the amount and position on disk of metadata blocks.
+
+2) Following the super block, a set of blocks is used to describe the mapping
+of the logical chunks of the target logical device to data zones. The mapping
+is indexed by logical chunk number and each mapping entry indicates the data
+zone storing the chunk data and optionally the zone number of a random zone
+used to buffer random modification to the chunk data.
+
+3) A set of blocks used to store bitmaps indicating the validity of blocks in
+the data zones follows the mapping table blocks. A valid block is a block that
+was writen and not discarded. For a buffered data zone, a block can be valid
+only in the data zone or in the buffer zone.
+
+For a logical chunk mapped to a random data zone, all write operations are
+processed by directly writing to the data zone. If the mapping zone is to a
+sequential zone, the write operation is processed directly only and only if
+the write offset within the logical chunk is equal to the write pointer offset
+within of the sequential data zone (i.e. the write operation is aligned on the
+zone write pointer). Otherwise, write operations are processed indirectly using
+a buffer zone: a randomly writeable free data zone is allocated and assigned
+to the chunk being accessed in addition to the already mapped sequential data
+zone. Writing block to the buffer zone will invalidate the same blocks in the
+sequential data zone.
+
+Read operations are processed according to the block validity information
+provided by the bitmaps: valid blocks are read either from the data zone or,
+if the data zone is buffered, from the buffer zone assigned to the data zone.
+
+After some time, the limited number of random zones available may be exhausted
+and unaligned writes to unbuffered zones become impossible. To avoid such
+situation, a reclaim process regularly scans used random zones and try to
+"reclaim" them by rewriting (sequentially) the valid blocks of the buffer zone
+to a free sequential zone. Once rewriting completes, the chunk mapping is
+updated to point to the sequential zone and the buffer zone freed for reuse.
+
+To protect internal metadata against corruption in case of sudden power loss or
+system crash, 2 sets of metadata zones are used. One set, the primary set, is
+used as the main metadata repository, while the secondary set is used as a log.
+Modified metadata are first written to the secondary set and the log so created
+validated by writing an updated super block in the secondary set. Once this log
+operation completes, updates in place of metadata blocks can be done in the
+primary metadata set, ensuring that one of the set is always correct.
+Flush operations are used as a commit point: upon reception of a flush
+operation, metadata activity is temporarily stopped, all dirty metadata logged
+and updated and normal operation resumed. This only temporarily delays write and
+discard requests. Read requests can be processed while metadata logging is
+executed.
+
+Usage
+=====
+
+A zoned block device must first be formatted using the dmzadm tool. This will
+analyze the device zone configuration, determine where to place the metadata
+sets and initialize on disk metadata blocks.
+
+Ex:
+
+dmzadm --format /dev/sdxx
+
+For a formatted device, the target can be created normally with the dmsetup
+utility. The following options can be passed to initialize the target.
+
+Parameters: <zoned block device path> [Options]
+Options:
+  rlow=<perc>      : Start reclaiming random zones if the percentage
+		     of free random data zones falls below <perc>.
+  idle_rlow=<perc> : When the disk is idle (no I/O activity), start
+                     reclaiming random zones if the percentage of
+                     free random data zones falls below <perc>.
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
+	echo "  rlow=<perc>      : Start reclaiming random zones if the "
+	echo "                     percentage of free random data zones falls "
+	echo "                     below <perc>."
+	echo "  idle_rlow=<perc> : When the disk is idle (no I/O activity), "
+	echo "                     start reclaiming random zones if the "
+	echo "                     percentage of free random data zones falls "
+	echo "                     below <perc>."
+	exit 1
+fi
+
+dev="${1}"
+shift
+options="$@"
+
+modprobe dm-zoned
+
+echo "0 `blockdev --getsize ${dev}` dm-zoned ${dev} ${options}" | \
+dmsetup create zoned-`basename ${dev}`
+]]
+
diff --git a/MAINTAINERS b/MAINTAINERS
index bbc2b39..cf30c44 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13316,6 +13316,13 @@ L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 F:	drivers/net/wireless/zydas/zd1211rw/
 
+ZONED BLOCK DEVICE DEVICE-MAPPER (dm-zoned)
+M:      Damien Le Moal <damien.lemoal@wdc.com>
+L:	dm-devel@redhat.com
+S:      Maintained
+F:      drivers/md/dm-zoned*
+F:      Documentation/device-mapper/dm-zoned.txt
+
 ZPOOL COMPRESSED PAGE STORAGE API
 M:	Dan Streetman <ddstreet@ieee.org>
 L:	linux-mm@kvack.org
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 02a5345..78945a9 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -500,4 +500,20 @@ config DM_LOG_WRITES
 
 	  If unsure, say N.
 
+config DM_ZONED
+	tristate "Zoned block device target support"
+	depends on BLK_DEV_DM
+	depends on BLK_DEV_ZONED
+	---help---
+	  This device-mapper target takes a zoned block device and expose it as
+	  a regular disk without any write constraint.
+	  This is mainly intended for use with file systems that do not
+	  natively support zoned block devices. Other uses by applications using
+	  raw block devices (for example object stores) is also possible.
+
+	  To compile this code as a module, choose M here: the module will
+	  be called dm-zoned.
+
+	  If unsure, say N.
+
 endif # MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 3cbda1a..f42dfcc 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -19,6 +19,7 @@ dm-era-y	+= dm-era-target.o
 dm-verity-y	+= dm-verity-target.o
 md-mod-y	+= md.o bitmap.o
 raid456-y	+= raid5.o raid5-cache.o
+dm-zoned-y	+= dm-zoned-io.o dm-zoned-metadata.o dm-zoned-reclaim.o
 
 # Note: link order is important.  All raid personalities
 # and must come before md.o, as they each initialise 
@@ -59,6 +60,7 @@ obj-$(CONFIG_DM_CACHE_SMQ)	+= dm-cache-smq.o
 obj-$(CONFIG_DM_CACHE_CLEANER)	+= dm-cache-cleaner.o
 obj-$(CONFIG_DM_ERA)		+= dm-era.o
 obj-$(CONFIG_DM_LOG_WRITES)	+= dm-log-writes.o
+obj-$(CONFIG_DM_ZONED)		+= dm-zoned.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
diff --git a/drivers/md/dm-zoned-io.c b/drivers/md/dm-zoned-io.c
new file mode 100644
index 0000000..f872d10
--- /dev/null
+++ b/drivers/md/dm-zoned-io.c
@@ -0,0 +1,1106 @@
+/*
+ * (C) Copyright 2016 Western Digital.
+ *
+ * This software is distributed under the terms of the GNU Lesser General
+ * Public License version 2, or any later version, "as is," without technical
+ * support, and WITHOUT ANY WARRANTY, without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Author: Damien Le Moal <damien.lemoal@wdc.com>
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/version.h>
+
+#include "dm-zoned.h"
+
+static void dmz_bio_work(struct work_struct *work);
+
+/*
+ * Allocate a zone work.
+ */
+static struct dm_zone_work *dmz_alloc_zwork(struct dm_zoned_target *dzt)
+{
+	struct dm_zone_work *zwork;
+
+	zwork = kmalloc(sizeof(struct dm_zone_work), GFP_NOWAIT);
+	if (!zwork)
+		return NULL;
+
+	INIT_WORK(&zwork->work, dmz_bio_work);
+	kref_init(&zwork->kref);
+	zwork->target = dzt;
+	zwork->zone = NULL;
+	bio_list_init(&zwork->bio_list);
+
+	return zwork;
+}
+
+/*
+ * Free a zone work.
+ */
+static inline void dmz_free_zwork(struct kref *kref)
+{
+	struct dm_zone_work *zwork =
+		container_of(kref, struct dm_zone_work, kref);
+	struct dm_zone *zone = zwork->zone;
+
+	if (zone) {
+		zone->work = NULL;
+		atomic_dec(&zwork->target->nr_active_zones);
+	}
+
+	kfree(zwork);
+}
+
+/*
+ * Decrement a zone work reference count.
+ */
+static void dmz_put_zwork(struct dm_zone_work *zwork)
+{
+	struct dm_zoned_target *dzt;
+	unsigned long flags;
+
+	if (!zwork)
+		return;
+
+	dzt = zwork->target;
+	spin_lock_irqsave(&dzt->zwork_lock, flags);
+	kref_put(&zwork->kref, dmz_free_zwork);
+	spin_unlock_irqrestore(&dzt->zwork_lock, flags);
+}
+
+/*
+ * Target BIO completion.
+ */
+static inline void dmz_bio_end(struct bio *bio, int err)
+{
+	struct dm_zone_bioctx *bioctx
+		= dm_per_bio_data(bio, sizeof(struct dm_zone_bioctx));
+
+	if (atomic_dec_and_test(&bioctx->ref)) {
+		/* User BIO Completed */
+		dmz_put_zwork(bioctx->zwork);
+		atomic_dec(&bioctx->target->bio_count);
+		bio->bi_error = bioctx->error;
+		bio_endio(bio);
+	}
+}
+
+/*
+ * Partial/internal BIO completion callback.
+ * This terminates the user target BIO when there
+ * are no more references to its context.
+ */
+static void dmz_bio_end_io(struct bio *bio)
+{
+	struct dm_zone_bioctx *bioctx = bio->bi_private;
+	int err = bio->bi_error;
+
+	if (err)
+		bioctx->error = err;
+
+	dmz_bio_end(bioctx->bio, err);
+
+	bio_put(bio);
+
+}
+
+/*
+ * Issue a BIO to a zone.
+ * This BIO may only partially process the
+ * issued target BIO.
+ */
+static int dmz_submit_bio(struct dm_zoned_target *dzt,
+			  struct dm_zone *zone, struct bio *dzt_bio,
+			  sector_t chunk_block, unsigned int nr_blocks)
+{
+	struct dm_zone_bioctx *bioctx
+		= dm_per_bio_data(dzt_bio, sizeof(struct dm_zone_bioctx));
+	unsigned int nr_sectors = dmz_blk2sect(nr_blocks);
+	unsigned int size = nr_sectors << SECTOR_SHIFT;
+	struct bio *clone;
+
+	clone = bio_clone_fast(dzt_bio, GFP_NOIO, dzt->bio_set);
+	if (!clone)
+		return -ENOMEM;
+
+	/* Setup the clone */
+	clone->bi_bdev = dzt->zbd;
+	clone->bi_opf = dzt_bio->bi_opf;
+	clone->bi_iter.bi_sector = zone->sector + dmz_blk2sect(chunk_block);
+	clone->bi_iter.bi_size = size;
+	clone->bi_end_io = dmz_bio_end_io;
+	clone->bi_private = bioctx;
+
+	bio_advance(dzt_bio, size);
+
+	/* Submit the clone */
+	atomic_inc(&bioctx->ref);
+	generic_make_request(clone);
+
+	return 0;
+}
+
+/*
+ * Zero out pages of discarded blocks accessed by a read BIO.
+ */
+static void dmz_handle_read_zero(struct dm_zoned_target *dzt,
+				 struct bio *bio,
+				 sector_t chunk_block, unsigned int nr_blocks)
+{
+	unsigned int size = nr_blocks << DMZ_BLOCK_SHIFT;
+
+	dmz_dev_debug(dzt,
+		      "=> ZERO READ chunk %llu -> block %llu, %u blocks\n",
+		      (unsigned long long)dmz_bio_chunk(dzt, bio),
+		      (unsigned long long)chunk_block,
+		      nr_blocks);
+
+	/* Clear nr_blocks */
+	swap(bio->bi_iter.bi_size, size);
+	zero_fill_bio(bio);
+	swap(bio->bi_iter.bi_size, size);
+
+	bio_advance(bio, size);
+}
+
+/*
+ * Process a read BIO.
+ */
+static int dmz_handle_read(struct dm_zoned_target *dzt,
+			   struct dm_zone *dzone, struct bio *bio)
+{
+	sector_t block = dmz_bio_block(bio);
+	unsigned int nr_blocks = dmz_bio_blocks(bio);
+	sector_t chunk_block = dmz_chunk_block(dzt, block);
+	sector_t end_block = chunk_block + nr_blocks;
+	struct dm_zone *rzone, *bzone;
+	int ret;
+
+	/* Read into unmapped chunks need only zeroing the BIO buffer */
+	if (!dzone) {
+		dmz_handle_read_zero(dzt, bio, chunk_block, nr_blocks);
+		return 0;
+	}
+
+	dmz_dev_debug(dzt,
+		      "READ %s zone %u, block %llu, %u blocks\n",
+		      (dmz_is_rnd(dzone) ? "RND" : "SEQ"),
+		      dmz_id(dzt, dzone),
+		      (unsigned long long)chunk_block,
+		      nr_blocks);
+
+	/* Check block validity to determine the read location */
+	bzone = dzone->bzone;
+	while (chunk_block < end_block) {
+
+		nr_blocks = 0;
+		if (dmz_is_rnd(dzone)
+		    || chunk_block < dzone->wp_block) {
+			/* Test block validity in the data zone */
+			ret = dmz_block_valid(dzt, dzone, chunk_block);
+			if (ret < 0)
+				return ret;
+			if (ret > 0) {
+				/* Read data zone blocks */
+				nr_blocks = ret;
+				rzone = dzone;
+			}
+		}
+
+		/*
+		 * No valid blocks found in the data zone.
+		 * Check the buffer zone, if there is one.
+		 */
+		if (!nr_blocks && bzone) {
+			ret = dmz_block_valid(dzt, bzone, chunk_block);
+			if (ret < 0)
+				return ret;
+			if (ret > 0) {
+				/* Read buffer zone blocks */
+				nr_blocks = ret;
+				rzone = bzone;
+			}
+		}
+
+		if (nr_blocks) {
+
+			/* Valid blocks found: read them */
+			nr_blocks = min_t(unsigned int, nr_blocks,
+					  end_block - chunk_block);
+
+			dmz_dev_debug(dzt,
+				"=> %s READ zone %u, block %llu, %u blocks\n",
+				(dmz_is_buf(rzone) ? "BUF" : "DATA"),
+				dmz_id(dzt, rzone),
+				(unsigned long long)chunk_block,
+				nr_blocks);
+
+			ret = dmz_submit_bio(dzt, rzone, bio,
+					     chunk_block, nr_blocks);
+			if (ret)
+				return ret;
+			chunk_block += nr_blocks;
+
+		} else {
+
+			/* No valid block: zeroout the current BIO block */
+			dmz_handle_read_zero(dzt, bio, chunk_block, 1);
+			chunk_block++;
+
+		}
+
+	}
+
+	return 0;
+}
+
+/*
+ * Write blocks directly in a data zone, at the write pointer.
+ * If a buffer zone is assigned, invalidate the blocks written
+ * in place.
+ */
+static int dmz_handle_direct_write(struct dm_zoned_target *dzt,
+				   struct dm_zone *dzone, struct bio *bio,
+				   sector_t chunk_block,
+				   unsigned int nr_blocks)
+{
+	struct dm_zone *bzone = dzone->bzone;
+	int ret;
+
+	dmz_dev_debug(dzt,
+		      "WRITE %s zone %u, block %llu, %u blocks\n",
+		      (dmz_is_rnd(dzone) ? "RND" : "SEQ"),
+		      dmz_id(dzt, dzone),
+		      (unsigned long long)chunk_block,
+		      nr_blocks);
+
+	if (dmz_is_readonly(dzone))
+		return -EROFS;
+
+	/* Submit write */
+	ret = dmz_submit_bio(dzt, dzone, bio,
+			     chunk_block, nr_blocks);
+	if (ret)
+		return -EIO;
+
+	if (dmz_is_seq(dzone))
+		dzone->wp_block += nr_blocks;
+
+	/*
+	 * Validate the blocks in the data zone and invalidate
+	 * in the buffer zone, if there is one.
+	 */
+	ret = dmz_validate_blocks(dzt, dzone,
+				  chunk_block, nr_blocks);
+	if (ret == 0 && bzone)
+		ret = dmz_invalidate_blocks(dzt, bzone,
+					    chunk_block, nr_blocks);
+
+	return ret;
+}
+
+/*
+ * Write blocks in the buffer zone of @zone.
+ * If no buffer zone is assigned yet, get one.
+ * Called with @zone write locked.
+ */
+static int dmz_handle_buffered_write(struct dm_zoned_target *dzt,
+				     struct dm_zone *dzone, struct bio *bio,
+				     sector_t chunk_block,
+				     unsigned int nr_blocks)
+{
+	struct dm_zone *bzone = dzone->bzone;
+	int ret;
+
+	if (!bzone) {
+		/* Get a buffer zone */
+		bzone = dmz_get_chunk_buffer(dzt, dzone);
+		if (!bzone)
+			return -ENOSPC;
+	}
+
+	dmz_dev_debug(dzt,
+		      "WRITE BUF zone %u, block %llu, %u blocks\n",
+		      dmz_id(dzt, bzone),
+		      (unsigned long long)chunk_block,
+		      nr_blocks);
+
+	if (dmz_is_readonly(bzone))
+		return -EROFS;
+
+	/* Submit write */
+	ret = dmz_submit_bio(dzt, bzone, bio,
+			     chunk_block, nr_blocks);
+	if (ret)
+		return -EIO;
+
+	/*
+	 * Validate the blocks in the buffer zone
+	 * and invalidate in the data zone.
+	 */
+	ret = dmz_validate_blocks(dzt, bzone,
+				  chunk_block, nr_blocks);
+	if (ret == 0 && chunk_block < dzone->wp_block)
+		ret = dmz_invalidate_blocks(dzt, dzone,
+					    chunk_block, nr_blocks);
+
+	return ret;
+}
+
+/*
+ * Process a write BIO.
+ */
+static int dmz_handle_write(struct dm_zoned_target *dzt,
+			    struct dm_zone *dzone, struct bio *bio)
+{
+	sector_t block = dmz_bio_block(bio);
+	unsigned int nr_blocks = dmz_bio_blocks(bio);
+	sector_t chunk_block = dmz_chunk_block(dzt, block);
+	int ret;
+
+	if (!dzone)
+		return -ENOSPC;
+
+	if (dmz_is_rnd(dzone) ||
+	    chunk_block == dzone->wp_block)
+		/*
+		 * dzone is a random zone, or it is a sequential zone
+		 * and the BIO is aligned to the zone write pointer:
+		 * direct write the zone.
+		 */
+		ret = dmz_handle_direct_write(dzt, dzone, bio,
+					      chunk_block, nr_blocks);
+	else
+		/*
+		 * This is an unaligned write in a sequential zone:
+		 * use buffered write.
+		 */
+		ret = dmz_handle_buffered_write(dzt, dzone, bio,
+						chunk_block, nr_blocks);
+
+	dmz_validate_zone(dzt, dzone);
+
+	return ret;
+}
+
+/*
+ * Process a discard BIO.
+ */
+static int dmz_handle_discard(struct dm_zoned_target *dzt,
+			      struct dm_zone *dzone, struct bio *bio)
+{
+	sector_t block = dmz_bio_block(bio);
+	unsigned int nr_blocks = dmz_bio_blocks(bio);
+	sector_t chunk_block = dmz_chunk_block(dzt, block);
+	int ret;
+
+	/* For unmapped chunks, there is nothing to do */
+	if (!dzone)
+		return 0;
+
+	if (dmz_is_readonly(dzone))
+		return -EROFS;
+
+	dmz_dev_debug(dzt,
+		"DISCARD chunk %llu -> zone %u, block %llu, %u blocks\n",
+		(unsigned long long)dmz_bio_chunk(dzt, bio),
+		dmz_id(dzt, dzone),
+		(unsigned long long)chunk_block,
+		nr_blocks);
+
+	/*
+	 * Invalidate blocks in the data zone and its
+	 * buffer zone if one is mapped.
+	 */
+	ret = dmz_invalidate_blocks(dzt, dzone,
+				    chunk_block, nr_blocks);
+	if (ret == 0 && dzone->bzone)
+		ret = dmz_invalidate_blocks(dzt, dzone->bzone,
+					    chunk_block, nr_blocks);
+
+	dmz_validate_zone(dzt, dzone);
+
+	return ret;
+}
+
+/*
+ * Process a BIO.
+ */
+static void dmz_handle_bio(struct dm_zoned_target *dzt,
+			   struct dm_zone *zone, struct bio *bio)
+{
+	int is_sync;
+	int ret;
+
+	if (zone)
+		down_read(&dzt->mblk_sem);
+
+	is_sync = (bio_op(bio) != REQ_OP_READ) &&
+		op_is_sync(bio->bi_opf);
+
+	/* Process the BIO */
+	switch (bio_op(bio)) {
+	case REQ_OP_READ:
+		ret = dmz_handle_read(dzt, zone, bio);
+		break;
+	case REQ_OP_WRITE:
+		ret = dmz_handle_write(dzt, zone, bio);
+		break;
+	case REQ_OP_DISCARD:
+		ret = dmz_handle_discard(dzt, zone, bio);
+		break;
+	default:
+		dmz_dev_err(dzt,
+			    "Unknown BIO type 0x%x\n",
+			    bio_op(bio));
+		ret = -EIO;
+		break;
+	}
+
+	if (zone)
+		up_read(&dzt->mblk_sem);
+
+	dmz_bio_end(bio, ret);
+}
+
+/*
+ * Zone BIO work function.
+ */
+static void dmz_bio_work(struct work_struct *work)
+{
+	struct dm_zone_work *zwork =
+		container_of(work, struct dm_zone_work, work);
+	struct dm_zoned_target *dzt = zwork->target;
+	struct dm_zone *zone = zwork->zone;
+	unsigned long flags;
+	struct bio *bio;
+
+	/* Process BIOs */
+	while (1) {
+
+		spin_lock_irqsave(&dzt->zwork_lock, flags);
+		bio = bio_list_pop(&zwork->bio_list);
+		spin_unlock_irqrestore(&dzt->zwork_lock, flags);
+
+		if (!bio)
+			break;
+
+		dmz_handle_bio(dzt, zone, bio);
+
+	}
+
+	dmz_put_zwork(zwork);
+}
+
+/*
+ * Flush work.
+ */
+static void dmz_flush_work(struct work_struct *work)
+{
+	struct dm_zoned_target *dzt =
+		container_of(work, struct dm_zoned_target, flush_work.work);
+	struct bio *bio;
+	int ret;
+
+	/* Do flush */
+	ret = dmz_flush_mblocks(dzt);
+
+	/* Process queued flush requests */
+	while (1) {
+
+		spin_lock(&dzt->flush_lock);
+		bio = bio_list_pop(&dzt->flush_list);
+		spin_unlock(&dzt->flush_lock);
+
+		if (!bio)
+			break;
+
+		dmz_bio_end(bio, ret);
+
+	}
+
+	mod_delayed_work(dzt->flush_wq, &dzt->flush_work,
+			 DMZ_FLUSH_PERIOD);
+}
+
+/*
+ * Find out the zone mapping of a new BIO and process it.
+ * For read and discard BIOs, no mapping may exist. For write BIOs, a mapping
+ * is created (i.e. a zone allocated) is none already existed.
+ */
+static void dmz_map_bio(struct dm_zoned_target *dzt, struct bio *bio)
+{
+	struct dm_zone_bioctx *bioctx =
+		dm_per_bio_data(bio, sizeof(struct dm_zone_bioctx));
+	struct dm_zone_work *zwork;
+	struct dm_zone *zone;
+	unsigned long flags;
+
+	/*
+	 * Get the data zone mapping the chunk that the BIO
+	 * is targeting. If there is no mapping, directly
+	 * process the BIO.
+	 */
+	zone = dmz_get_chunk_mapping(dzt, dmz_bio_chunk(dzt, bio),
+				     bio_op(bio));
+	if (IS_ERR_OR_NULL(zone)) {
+		if (IS_ERR(zone))
+			dmz_bio_end(bio, PTR_ERR(zone));
+		else
+			dmz_handle_bio(dzt, NULL, bio);
+		return;
+	}
+
+	/* Setup the zone work */
+	spin_lock_irqsave(&dzt->zwork_lock, flags);
+
+	WARN_ON(dmz_in_reclaim(zone));
+	zwork = zone->work;
+	if (zwork) {
+		/* Keep current work */
+		kref_get(&zwork->kref);
+	} else {
+		/* Get a new work */
+		zwork = dmz_alloc_zwork(dzt);
+		if (unlikely(!zwork)) {
+			dmz_bio_end(bio, -ENOMEM);
+			goto out;
+		}
+		zwork->zone = zone;
+		zone->work = zwork;
+		atomic_inc(&dzt->nr_active_zones);
+	}
+
+	/* Queue the BIO and the zone work */
+	bioctx->zwork = zwork;
+	bio_list_add(&zwork->bio_list, bio);
+	if (queue_work(dzt->zone_wq, &zwork->work))
+		kref_get(&zwork->kref);
+out:
+	spin_unlock_irqrestore(&dzt->zwork_lock, flags);
+}
+
+/*
+ * Process a new BIO.
+ */
+static int dmz_map(struct dm_target *ti, struct bio *bio)
+{
+	struct dm_zoned_target *dzt = ti->private;
+	struct dm_zone_bioctx *bioctx
+		= dm_per_bio_data(bio, sizeof(struct dm_zone_bioctx));
+	sector_t sector = bio->bi_iter.bi_sector;
+	unsigned int nr_sectors = bio_sectors(bio);
+	sector_t chunk_sector;
+
+	dmz_dev_debug(dzt,
+		"BIO sector %llu + %u => chunk %llu, block %llu, %u blocks\n",
+		(u64)sector, nr_sectors,
+		(u64)dmz_bio_chunk(dzt, bio),
+		(u64)dmz_chunk_block(dzt, dmz_bio_block(bio)),
+		(unsigned int)dmz_bio_blocks(bio));
+
+	bio->bi_bdev = dzt->zbd;
+
+	if (!nr_sectors &&
+	    (bio_op(bio) != REQ_OP_FLUSH) &&
+	    (bio_op(bio) != REQ_OP_WRITE)) {
+		bio->bi_bdev = dzt->zbd;
+		return DM_MAPIO_REMAPPED;
+	}
+
+	/* The BIO should be block aligned */
+	if ((nr_sectors & DMZ_BLOCK_SECTORS_MASK) ||
+	    (sector & DMZ_BLOCK_SECTORS_MASK)) {
+		dmz_dev_err(dzt,
+			    "Unaligned BIO sector %llu, len %u\n",
+			    (u64)sector,
+			    nr_sectors);
+		return -EIO;
+	}
+
+	/* Initialize the BIO context */
+	bioctx->target = dzt;
+	bioctx->zwork = NULL;
+	bioctx->bio = bio;
+	atomic_set(&bioctx->ref, 1);
+	bioctx->error = 0;
+
+	atomic_inc(&dzt->bio_count);
+	dzt->last_bio_time = jiffies;
+
+	/* Set the BIO pending in the flush list */
+	if (bio_op(bio) == REQ_OP_FLUSH ||
+	    (!nr_sectors && bio_op(bio) == REQ_OP_WRITE)) {
+		spin_lock(&dzt->flush_lock);
+		bio_list_add(&dzt->flush_list, bio);
+		spin_unlock(&dzt->flush_lock);
+		dmz_trigger_flush(dzt);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	/* Split zone BIOs to fit entirely into a zone */
+	chunk_sector = dmz_chunk_sector(dzt, sector);
+	if (chunk_sector + nr_sectors > dzt->zone_nr_sectors)
+		dm_accept_partial_bio(bio,
+				      dzt->zone_nr_sectors - chunk_sector);
+
+	/* Now ready to handle this BIO */
+	dmz_map_bio(dzt, bio);
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+/**
+ * Parse dmsetup arguments.
+ */
+static int dmz_parse_args(struct dm_target *ti,
+			  struct dm_arg_set *as,
+			  struct dm_zoned_target_config *conf)
+{
+	const char *arg;
+
+	/* Check arguments */
+	if (as->argc < 1) {
+		ti->error = "No target device specified";
+		return -EINVAL;
+	}
+
+	/* Set defaults */
+	conf->dev_path = (char *) dm_shift_arg(as);
+	conf->flags = 0;
+	conf->reclaim_low = DMZ_RECLAIM_LOW;
+	conf->reclaim_idle_low = DMZ_RECLAIM_IDLE_LOW;
+
+	while (as->argc) {
+
+		arg = dm_shift_arg(as);
+
+		if (strncmp(arg, "idle_rlow=", 9) == 0) {
+			if (kstrtoul(arg + 9, 0, &conf->reclaim_idle_low) < 0 ||
+			    conf->reclaim_idle_low > 100) {
+				ti->error = "Invalid idle_rlow value";
+				return -EINVAL;
+			}
+		} else if (strncmp(arg, "rlow=", 9) == 0) {
+			if (kstrtoul(arg + 9, 0, &conf->reclaim_low) < 0 ||
+			    conf->reclaim_low > 100) {
+				ti->error = "Invalid rlow value";
+				return -EINVAL;
+			}
+		} else {
+			ti->error = "Unknown argument";
+			return -EINVAL;
+		}
+
+	}
+
+	return 0;
+}
+
+/*
+ * Setup target.
+ */
+static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct dm_zoned_target_config conf;
+	struct dm_zoned_target *dzt;
+	struct dm_arg_set as;
+	int ret;
+
+	/* Parse arguments */
+	as.argc = argc;
+	as.argv = argv;
+	ret = dmz_parse_args(ti, &as, &conf);
+	if (ret)
+		return ret;
+
+	/* Allocate and initialize the target descriptor */
+	dzt = kzalloc(sizeof(struct dm_zoned_target), GFP_KERNEL);
+	if (!dzt) {
+		ti->error = "Allocate target descriptor failed";
+		return -ENOMEM;
+	}
+
+	/* Get the target device */
+	ret = dm_get_device(ti, conf.dev_path,
+			    dm_table_get_mode(ti->table), &dzt->ddev);
+	if (ret != 0) {
+		ti->error = "Get target device failed";
+		goto err;
+	}
+
+	dzt->zbd = dzt->ddev->bdev;
+	if (!bdev_is_zoned(dzt->zbd)) {
+		ti->error = "Not a zoned block device";
+		ret = -EINVAL;
+		goto err;
+	}
+
+	dzt->zbd_capacity = i_size_read(dzt->zbd->bd_inode) >> SECTOR_SHIFT;
+	if (ti->begin || (ti->len != dzt->zbd_capacity)) {
+		ti->error = "Partial mapping not supported";
+		ret = -EINVAL;
+		goto err;
+	}
+
+	(void)bdevname(dzt->zbd, dzt->zbd_name);
+	dzt->zbdq = bdev_get_queue(dzt->zbd);
+	dzt->flags = conf.flags;
+
+	dzt->zones = RB_ROOT;
+
+	dzt->mblk_rbtree = RB_ROOT;
+	init_rwsem(&dzt->mblk_sem);
+	spin_lock_init(&dzt->mblk_lock);
+	INIT_LIST_HEAD(&dzt->mblk_lru_list);
+	INIT_LIST_HEAD(&dzt->mblk_dirty_list);
+
+	mutex_init(&dzt->map_lock);
+	atomic_set(&dzt->dz_unmap_nr_rnd, 0);
+	INIT_LIST_HEAD(&dzt->dz_unmap_rnd_list);
+	INIT_LIST_HEAD(&dzt->dz_map_rnd_list);
+
+	atomic_set(&dzt->dz_unmap_nr_seq, 0);
+	INIT_LIST_HEAD(&dzt->dz_unmap_seq_list);
+	INIT_LIST_HEAD(&dzt->dz_map_seq_list);
+
+	init_waitqueue_head(&dzt->dz_free_wq);
+
+	atomic_set(&dzt->nr_active_zones, 0);
+
+	atomic_set(&dzt->nr_reclaim_seq_zones, 0);
+	INIT_LIST_HEAD(&dzt->reclaim_seq_zones_list);
+
+	dmz_dev_info(dzt,
+		     "Target device: host-%s zoned block device %s\n",
+		     bdev_zoned_model(dzt->zbd) == BLK_ZONED_HA ?
+		     "aware" : "managed",
+		     dzt->zbd_name);
+
+	ret = dmz_init_meta(dzt, &conf);
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
+	ti->per_io_data_size = sizeof(struct dm_zone_bioctx);
+	ti->flush_supported = true;
+	ti->discards_supported = true;
+	ti->split_discard_bios = true;
+	ti->discard_zeroes_data_unsupported = false;
+
+	/* The target capacity is the number of chunks that can be mapped */
+	ti->len = dzt->nr_chunks * dzt->zone_nr_sectors;
+
+	/* zone BIO work */
+	atomic_set(&dzt->bio_count, 0);
+	spin_lock_init(&dzt->zwork_lock);
+	dzt->bio_set = bioset_create(DMZ_MIN_BIOS, 0);
+	if (!dzt->bio_set) {
+		ti->error = "Create BIO set failed";
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	dzt->zone_wq = alloc_workqueue("dm_zoned_zwq_%s",
+				       WQ_MEM_RECLAIM | WQ_UNBOUND,
+				       0,
+				       dzt->zbd_name);
+	if (!dzt->zone_wq) {
+		ti->error = "Create zone BIO workqueue failed";
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* Flush work */
+	spin_lock_init(&dzt->flush_lock);
+	bio_list_init(&dzt->flush_list);
+	INIT_DELAYED_WORK(&dzt->flush_work, dmz_flush_work);
+	dzt->flush_wq = alloc_ordered_workqueue("dm_zoned_fwq_%s",
+						WQ_MEM_RECLAIM | WQ_UNBOUND,
+						dzt->zbd_name);
+	if (!dzt->flush_wq) {
+		ti->error = "Create flush workqueue failed";
+		ret = -ENOMEM;
+		goto err;
+	}
+	mod_delayed_work(dzt->flush_wq, &dzt->flush_work, DMZ_FLUSH_PERIOD);
+
+	/* Conventional zone reclaim work */
+	INIT_DELAYED_WORK(&dzt->reclaim_work, dmz_reclaim_work);
+	dzt->reclaim_wq = alloc_ordered_workqueue("dm_zoned_rwq_%s",
+						  WQ_MEM_RECLAIM | WQ_UNBOUND,
+						  dzt->zbd_name);
+	if (!dzt->reclaim_wq) {
+		ti->error = "Create reclaim workqueue failed";
+		ret = -ENOMEM;
+		goto err;
+	}
+	dzt->reclaim_low = conf.reclaim_low;
+	dzt->reclaim_idle_low = conf.reclaim_idle_low;
+	if (dzt->reclaim_low > DMZ_RECLAIM_MAX)
+		dzt->reclaim_low = DMZ_RECLAIM_MAX;
+	if (dzt->reclaim_low < DMZ_RECLAIM_MIN)
+		dzt->reclaim_low = DMZ_RECLAIM_MIN;
+	if (dzt->reclaim_idle_low > DMZ_RECLAIM_IDLE_MAX)
+		dzt->reclaim_idle_low = DMZ_RECLAIM_IDLE_MAX;
+	if (dzt->reclaim_idle_low < dzt->reclaim_low)
+		dzt->reclaim_idle_low = dzt->reclaim_low;
+
+	dmz_dev_info(dzt,
+		"Target device: %llu 512-byte logical sectors (%llu blocks)\n",
+		(unsigned long long)ti->len,
+		(unsigned long long)dmz_sect2blk(ti->len));
+
+	dzt->last_bio_time = jiffies;
+	dmz_trigger_reclaim(dzt);
+
+	return 0;
+
+err:
+	if (dzt->ddev) {
+		if (dzt->reclaim_wq)
+			destroy_workqueue(dzt->reclaim_wq);
+		if (dzt->flush_wq)
+			destroy_workqueue(dzt->flush_wq);
+		if (dzt->zone_wq)
+			destroy_workqueue(dzt->zone_wq);
+		if (dzt->bio_set)
+			bioset_free(dzt->bio_set);
+		dmz_cleanup_meta(dzt);
+		dm_put_device(ti, dzt->ddev);
+	}
+
+	kfree(dzt);
+
+	return ret;
+
+}
+
+/*
+ * Cleanup target.
+ */
+static void dmz_dtr(struct dm_target *ti)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	dmz_dev_info(dzt, "Removing target device\n");
+
+	flush_workqueue(dzt->zone_wq);
+	destroy_workqueue(dzt->zone_wq);
+
+	cancel_delayed_work_sync(&dzt->reclaim_work);
+	destroy_workqueue(dzt->reclaim_wq);
+
+	cancel_delayed_work_sync(&dzt->flush_work);
+	destroy_workqueue(dzt->flush_wq);
+
+	dmz_flush_mblocks(dzt);
+
+	bioset_free(dzt->bio_set);
+
+	dmz_cleanup_meta(dzt);
+
+	dm_put_device(ti, dzt->ddev);
+
+	kfree(dzt);
+}
+
+/*
+ * Setup target request queue limits.
+ */
+static void dmz_io_hints(struct dm_target *ti,
+			 struct queue_limits *limits)
+{
+	struct dm_zoned_target *dzt = ti->private;
+	unsigned int chunk_sectors = dzt->zone_nr_sectors;
+
+	/* Align to zone size */
+	limits->chunk_sectors = chunk_sectors;
+	limits->max_sectors = chunk_sectors;
+
+	blk_limits_io_min(limits, DMZ_BLOCK_SIZE);
+	blk_limits_io_opt(limits, DMZ_BLOCK_SIZE);
+
+	limits->logical_block_size = DMZ_BLOCK_SIZE;
+	limits->physical_block_size = DMZ_BLOCK_SIZE;
+
+	limits->discard_alignment = DMZ_BLOCK_SIZE;
+	limits->discard_granularity = DMZ_BLOCK_SIZE;
+	limits->max_discard_sectors = chunk_sectors;
+	limits->max_hw_discard_sectors = chunk_sectors;
+	limits->discard_zeroes_data = true;
+
+}
+
+/*
+ * Pass on ioctl to the backend device.
+ */
+static int dmz_prepare_ioctl(struct dm_target *ti,
+			     struct block_device **bdev, fmode_t *mode)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	*bdev = dzt->zbd;
+
+	return 0;
+}
+
+/*
+ * Stop reclaim before suspend.
+ */
+static void dmz_presuspend(struct dm_target *ti)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	dmz_dev_debug(dzt, "Pre-suspend\n");
+
+	/* Enter suspend state */
+	set_bit(DMZ_SUSPENDED, &dzt->flags);
+	smp_mb__after_atomic();
+
+	/* Stop reclaim */
+	cancel_delayed_work_sync(&dzt->reclaim_work);
+}
+
+/*
+ * Restart reclaim if suspend failed.
+ */
+static void dmz_presuspend_undo(struct dm_target *ti)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	dmz_dev_debug(dzt, "Pre-suspend undo\n");
+
+	/* Clear suspend state */
+	clear_bit_unlock(DMZ_SUSPENDED, &dzt->flags);
+	smp_mb__after_atomic();
+
+	/* Restart reclaim */
+	mod_delayed_work(dzt->reclaim_wq, &dzt->reclaim_work, 0);
+}
+
+/*
+ * Stop works and flush on suspend.
+ */
+static void dmz_postsuspend(struct dm_target *ti)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	dmz_dev_debug(dzt, "Post-suspend\n");
+
+	/* Stop works */
+	flush_workqueue(dzt->zone_wq);
+	flush_workqueue(dzt->flush_wq);
+}
+
+/*
+ * Refresh zone information before resuming.
+ */
+static int dmz_preresume(struct dm_target *ti)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	if (!test_bit(DMZ_SUSPENDED, &dzt->flags))
+		return 0;
+
+	dmz_dev_debug(dzt, "Pre-resume\n");
+
+	/* Refresh zone information */
+	return dmz_resume_meta(dzt);
+}
+
+/*
+ * Resume.
+ */
+static void dmz_resume(struct dm_target *ti)
+{
+	struct dm_zoned_target *dzt = ti->private;
+
+	if (!test_bit(DMZ_SUSPENDED, &dzt->flags))
+		return;
+
+	dmz_dev_debug(dzt, "Resume\n");
+
+	/* Clear suspend state */
+	clear_bit_unlock(DMZ_SUSPENDED, &dzt->flags);
+	smp_mb__after_atomic();
+
+	/* Restart reclaim */
+	mod_delayed_work(dzt->reclaim_wq, &dzt->reclaim_work, 0);
+
+}
+
+static int
+dmz_iterate_devices(struct dm_target *ti,
+		    iterate_devices_callout_fn fn,
+		    void *data)
+{
+	struct dm_zoned_target *dzt = ti->private;
+	sector_t offset = dzt->zbd_capacity -
+		((sector_t)dzt->nr_chunks * dzt->zone_nr_sectors);
+
+	return fn(ti, dzt->ddev, offset, ti->len, data);
+}
+
+static struct target_type dm_zoned_type = {
+	.name		 = "dm-zoned",
+	.version	 = {1, 0, 0},
+	.module	 = THIS_MODULE,
+	.ctr		 = dmz_ctr,
+	.dtr		 = dmz_dtr,
+	.map		 = dmz_map,
+	.io_hints	 = dmz_io_hints,
+	.prepare_ioctl	 = dmz_prepare_ioctl,
+	.presuspend	 = dmz_presuspend,
+	.presuspend_undo = dmz_presuspend_undo,
+	.postsuspend	 = dmz_postsuspend,
+	.preresume	 = dmz_preresume,
+	.resume		 = dmz_resume,
+	.iterate_devices = dmz_iterate_devices,
+};
+
+struct kmem_cache *dmz_zone_cache;
+
+static int __init dmz_init(void)
+{
+	int ret;
+
+	dmz_info("Version %d.%d, (C) Western Digital\n",
+		 DMZ_VER_MAJ,
+		 DMZ_VER_MIN);
+
+	dmz_zone_cache = KMEM_CACHE(dm_zone, 0);
+	if (!dmz_zone_cache)
+		return -ENOMEM;
+
+	ret = dm_register_target(&dm_zoned_type);
+	if (ret != 0) {
+		kmem_cache_destroy(dmz_zone_cache);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit dmz_exit(void)
+{
+	dm_unregister_target(&dm_zoned_type);
+	kmem_cache_destroy(dmz_zone_cache);
+}
+
+module_init(dmz_init);
+module_exit(dmz_exit);
+
+MODULE_DESCRIPTION(DM_NAME " target for zoned block devices");
+MODULE_AUTHOR("Damien Le Moal <damien.lemoal@wdc.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
new file mode 100644
index 0000000..cbafdf5
--- /dev/null
+++ b/drivers/md/dm-zoned-metadata.c
@@ -0,0 +1,2211 @@
+/*
+ * (C) Copyright 2016 Western Digital.
+ *
+ * This software is distributed under the terms of the GNU Lesser General
+ * Public License version 2, or any later version, "as is," without technical
+ * support, and WITHOUT ANY WARRANTY, without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Author: Damien Le Moal <damien.lemoal@wdc.com>
+ */
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/slab.h>
+
+#include "dm-zoned.h"
+
+/*
+ * Allocate a metadata block.
+ */
+static struct dm_zoned_mblock *dmz_alloc_mblock(struct dm_zoned_target *dzt,
+						sector_t mblk_no)
+{
+	struct dm_zoned_mblock *mblk = NULL;
+	unsigned long flags;
+
+	/* See if we can reuse allocated blocks */
+	if (dzt->max_nr_mblks &&
+	    atomic_read(&dzt->nr_mblks) >= dzt->max_nr_mblks) {
+
+		spin_lock_irqsave(&dzt->mblk_lock, flags);
+		if (list_empty(&dzt->mblk_lru_list)) {
+			/* Cleanup dirty blocks */
+			dmz_trigger_flush(dzt);
+		} else {
+			mblk = list_first_entry(&dzt->mblk_lru_list,
+						struct dm_zoned_mblock, link);
+			list_del_init(&mblk->link);
+			rb_erase(&mblk->node, &dzt->mblk_rbtree);
+			mblk->no = mblk_no;
+		}
+		spin_unlock_irqrestore(&dzt->mblk_lock, flags);
+
+		if (mblk)
+			return mblk;
+	}
+
+	/* Allocate a new block */
+	mblk = kmalloc(sizeof(struct dm_zoned_mblock), GFP_NOIO);
+	if (!mblk)
+		return NULL;
+
+	mblk->page = alloc_page(GFP_NOIO);
+	if (!mblk->page) {
+		kfree(mblk);
+		return NULL;
+	}
+
+	RB_CLEAR_NODE(&mblk->node);
+	INIT_LIST_HEAD(&mblk->link);
+	atomic_set(&mblk->ref, 0);
+	mblk->state = 0;
+	mblk->no = mblk_no;
+	mblk->data = page_address(mblk->page);
+
+	atomic_inc(&dzt->nr_mblks);
+
+	return mblk;
+}
+
+/*
+ * Free a metadata block.
+ */
+static void dmz_free_mblock(struct dm_zoned_target *dzt,
+			    struct dm_zoned_mblock *mblk)
+{
+	__free_pages(mblk->page, 0);
+	kfree(mblk);
+
+	atomic_dec(&dzt->nr_mblks);
+}
+
+/*
+ * Insert a metadata block in the rbtree.
+ */
+static void dmz_insert_mblock(struct dm_zoned_target *dzt,
+			      struct dm_zoned_mblock *mblk)
+{
+	struct rb_root *root = &dzt->mblk_rbtree;
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	struct dm_zoned_mblock *b;
+
+	/* Figure out where to put the new node */
+	while (*new) {
+		b = container_of(*new, struct dm_zoned_mblock, node);
+		parent = *new;
+		new = (b->no < mblk->no) ?
+			&((*new)->rb_left) : &((*new)->rb_right);
+	}
+
+	/* Add new node and rebalance tree */
+	rb_link_node(&mblk->node, parent, new);
+	rb_insert_color(&mblk->node, root);
+}
+
+/*
+ * Insert a metadata block in the rbtree.
+ */
+static struct dm_zoned_mblock *dmz_lookup_mblock(struct dm_zoned_target *dzt,
+						 sector_t mblk_no)
+{
+	struct rb_root *root = &dzt->mblk_rbtree;
+	struct rb_node *node = root->rb_node;
+	struct dm_zoned_mblock *mblk;
+
+	while (node) {
+		mblk = container_of(node, struct dm_zoned_mblock, node);
+		if (mblk->no == mblk_no)
+			return mblk;
+		node = (mblk->no < mblk_no) ? node->rb_left : node->rb_right;
+	}
+
+	return NULL;
+}
+
+/*
+ * Metadata block BIO end callback.
+ */
+static void dmz_mblock_bio_end_io(struct bio *bio)
+{
+	struct dm_zoned_mblock *mblk = bio->bi_private;
+	int flag;
+
+	if (bio->bi_error)
+		set_bit(DMZ_META_ERROR, &mblk->state);
+
+	if (bio_op(bio) == REQ_OP_WRITE)
+		flag = DMZ_META_WRITING;
+	else
+		flag = DMZ_META_READING;
+
+	clear_bit_unlock(flag, &mblk->state);
+	smp_mb__after_atomic();
+	wake_up_bit(&mblk->state, flag);
+
+	bio_put(bio);
+}
+
+/*
+ * Read a metadata block from disk.
+ */
+static struct dm_zoned_mblock *dmz_fetch_mblock(struct dm_zoned_target *dzt,
+						sector_t mblk_no)
+{
+	struct dm_zoned_mblock *mblk;
+	sector_t block = dzt->sb[dzt->mblk_primary].block + mblk_no;
+	unsigned long flags;
+	struct bio *bio;
+
+	/* Get block and insert it */
+	mblk = dmz_alloc_mblock(dzt, mblk_no);
+	if (!mblk)
+		return NULL;
+
+	spin_lock_irqsave(&dzt->mblk_lock, flags);
+	atomic_inc(&mblk->ref);
+	set_bit(DMZ_META_READING, &mblk->state);
+	dmz_insert_mblock(dzt, mblk);
+	spin_unlock_irqrestore(&dzt->mblk_lock, flags);
+
+	bio = bio_alloc(GFP_NOIO, 1);
+	bio->bi_iter.bi_sector = dmz_blk2sect(block);
+	bio->bi_bdev = dzt->zbd;
+	bio->bi_private = mblk;
+	bio->bi_end_io = dmz_mblock_bio_end_io;
+	bio_set_op_attrs(bio, REQ_OP_READ, REQ_META | REQ_PRIO);
+	bio_add_page(bio, mblk->page, DMZ_BLOCK_SIZE, 0);
+	submit_bio(bio);
+
+	return mblk;
+}
+
+/*
+ * Free metadata blocks.
+ */
+static void dmz_shrink_mblock_cache(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_mblock *mblk;
+
+	if (!dzt->max_nr_mblks)
+		return;
+
+	while (atomic_read(&dzt->nr_mblks) > dzt->max_nr_mblks &&
+	       !list_empty(&dzt->mblk_lru_list)) {
+
+		mblk = list_first_entry(&dzt->mblk_lru_list,
+					struct dm_zoned_mblock, link);
+		list_del_init(&mblk->link);
+		rb_erase(&mblk->node, &dzt->mblk_rbtree);
+		dmz_free_mblock(dzt, mblk);
+	}
+}
+
+/*
+ * Release a metadata block.
+ */
+static void dmz_release_mblock(struct dm_zoned_target *dzt,
+			       struct dm_zoned_mblock *mblk)
+{
+	unsigned long flags;
+
+	if (!mblk)
+		return;
+
+	spin_lock_irqsave(&dzt->mblk_lock, flags);
+
+	if (atomic_dec_and_test(&mblk->ref)) {
+		if (test_bit(DMZ_META_ERROR, &mblk->state)) {
+			rb_erase(&mblk->node, &dzt->mblk_rbtree);
+			dmz_free_mblock(dzt, mblk);
+		} else if (!test_bit(DMZ_META_DIRTY, &mblk->state)) {
+			list_add_tail(&mblk->link, &dzt->mblk_lru_list);
+		}
+	}
+
+	dmz_shrink_mblock_cache(dzt);
+
+	spin_unlock_irqrestore(&dzt->mblk_lock, flags);
+}
+
+/*
+ * Get a metadata block from the rbtree. If the block
+ * is not present, read it from disk.
+ */
+static struct dm_zoned_mblock *dmz_get_mblock(struct dm_zoned_target *dzt,
+					      sector_t mblk_no)
+{
+	struct dm_zoned_mblock *mblk;
+	unsigned long flags;
+
+	/* Check rbtree */
+	spin_lock_irqsave(&dzt->mblk_lock, flags);
+	mblk = dmz_lookup_mblock(dzt, mblk_no);
+	if (mblk) {
+		/* Cache hit: remove block from LRU list */
+		if (atomic_inc_return(&mblk->ref) == 1 &&
+		    !test_bit(DMZ_META_DIRTY, &mblk->state))
+			list_del_init(&mblk->link);
+	}
+	spin_unlock_irqrestore(&dzt->mblk_lock, flags);
+
+	if (!mblk) {
+		/* Cache miss: read the block from disk */
+		mblk = dmz_fetch_mblock(dzt, mblk_no);
+		if (!mblk)
+			return ERR_PTR(-ENOMEM);
+	}
+
+	/* Wait for on-going read I/O and check for error */
+	wait_on_bit_io(&mblk->state, DMZ_META_READING,
+		       TASK_UNINTERRUPTIBLE);
+	if (test_bit(DMZ_META_ERROR, &mblk->state)) {
+		dmz_release_mblock(dzt, mblk);
+		return ERR_PTR(-EIO);
+	}
+
+	return mblk;
+}
+
+/*
+ * Mark a metadata block dirty.
+ */
+static void dmz_dirty_mblock(struct dm_zoned_target *dzt,
+			     struct dm_zoned_mblock *mblk)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dzt->mblk_lock, flags);
+
+	if (!test_and_set_bit(DMZ_META_DIRTY, &mblk->state))
+		list_add_tail(&mblk->link, &dzt->mblk_dirty_list);
+
+	spin_unlock_irqrestore(&dzt->mblk_lock, flags);
+}
+
+/*
+ * Issue a metadata block write BIO.
+ */
+static void dmz_write_mblock(struct dm_zoned_target *dzt,
+			     struct dm_zoned_mblock *mblk,
+			     unsigned int set)
+{
+	sector_t block = dzt->sb[set].block + mblk->no;
+	struct bio *bio;
+
+	set_bit(DMZ_META_WRITING, &mblk->state);
+
+	bio = bio_alloc(GFP_NOIO, 1);
+	bio->bi_iter.bi_sector = dmz_blk2sect(block);
+	bio->bi_bdev = dzt->zbd;
+	bio->bi_private = mblk;
+	bio->bi_end_io = dmz_mblock_bio_end_io;
+	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_META | REQ_PRIO);
+	bio_add_page(bio, mblk->page, DMZ_BLOCK_SIZE, 0);
+	submit_bio(bio);
+}
+
+/*
+ * CRC32
+ */
+static u32 dmz_sb_crc32(u32 crc, const void *buf, size_t length)
+{
+	unsigned char *p = (unsigned char *)buf;
+	int i;
+
+#define CRCPOLY_LE 0xedb88320
+
+	while (length--) {
+		crc ^= *p++;
+		for (i = 0; i < 8; i++)
+			crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
+	}
+
+	return crc;
+}
+
+/*
+ * Sync read/write a block.
+ */
+static int dmz_rdwr_block_sync(struct dm_zoned_target *dzt,
+			       int op,
+			       sector_t block,
+			       struct page *page)
+{
+	struct bio *bio;
+	int ret;
+
+	bio = bio_alloc(GFP_NOIO, 1);
+	bio->bi_iter.bi_sector = dmz_blk2sect(block);
+	bio->bi_bdev = dzt->zbd;
+	bio_set_op_attrs(bio, op, REQ_SYNC | REQ_META | REQ_PRIO);
+	bio_add_page(bio, page, DMZ_BLOCK_SIZE, 0);
+	ret = submit_bio_wait(bio);
+	bio_put(bio);
+
+	return ret;
+}
+
+/*
+ * Write super block of the specified metadata set.
+ */
+static int dmz_write_sb(struct dm_zoned_target *dzt,
+			unsigned int set)
+{
+	sector_t block = dzt->sb[set].block;
+	struct dm_zoned_mblock *mblk = dzt->sb[set].mblk;
+	struct dm_zoned_super *sb = dzt->sb[set].sb;
+	u64 sb_gen = dzt->sb_gen + 1;
+	u32 crc;
+	int ret;
+
+	sb->magic = cpu_to_le32(DMZ_MAGIC);
+	sb->version = cpu_to_le32(DMZ_META_VER);
+
+	sb->gen = cpu_to_le64(sb_gen);
+
+	sb->sb_block = cpu_to_le64(block);
+	sb->nr_meta_blocks = cpu_to_le32(dzt->nr_meta_blocks);
+	sb->nr_reserved_seq = cpu_to_le32(dzt->nr_reserved_seq);
+	sb->nr_chunks = cpu_to_le32(dzt->nr_chunks);
+
+	sb->nr_map_blocks = cpu_to_le32(dzt->nr_map_blocks);
+	sb->nr_bitmap_blocks = cpu_to_le32(dzt->nr_bitmap_blocks);
+
+	sb->crc = 0;
+	crc = dmz_sb_crc32(sb_gen, sb, DMZ_BLOCK_SIZE);
+	sb->crc = cpu_to_le32(crc);
+
+	ret = dmz_rdwr_block_sync(dzt, REQ_OP_WRITE, block, mblk->page);
+	if (ret == 0)
+		ret = blkdev_issue_flush(dzt->zbd, GFP_KERNEL, NULL);
+
+	return ret;
+}
+
+/*
+ * Write dirty metadata blocks to the specified set.
+ */
+static int dmz_write_dirty_mblocks(struct dm_zoned_target *dzt,
+				   struct list_head *write_list,
+				   unsigned int set)
+{
+	struct dm_zoned_mblock *mblk;
+	struct blk_plug plug;
+	int ret = 0;
+
+	/* Issue writes */
+	blk_start_plug(&plug);
+	list_for_each_entry(mblk, write_list, link)
+		dmz_write_mblock(dzt, mblk, set);
+	blk_finish_plug(&plug);
+
+	/* Wait for completion */
+	list_for_each_entry(mblk, write_list, link) {
+		wait_on_bit_io(&mblk->state, DMZ_META_WRITING,
+			       TASK_UNINTERRUPTIBLE);
+		if (test_bit(DMZ_META_ERROR, &mblk->state)) {
+			dmz_dev_err(dzt,
+				    "Write metablock %u/%llu failed\n",
+				    set,
+				    (u64)mblk->no);
+			clear_bit(DMZ_META_ERROR, &mblk->state);
+			ret = -EIO;
+		}
+	}
+
+	return ret;
+}
+/*
+ * Log dirty metadata blocks.
+ */
+static int dmz_log_dirty_mblocks(struct dm_zoned_target *dzt,
+				 struct list_head *write_list)
+{
+	unsigned int log_set = dzt->mblk_primary ^ 0x1;
+	int ret;
+
+	/* Write dirty blocks to the log */
+	ret = dmz_write_dirty_mblocks(dzt, write_list, log_set);
+	if (ret)
+		return ret;
+
+	/* Flush drive cache (this will also sync data) */
+	ret = blkdev_issue_flush(dzt->zbd, GFP_KERNEL, NULL);
+	if (ret)
+		return ret;
+
+	/*
+	 * No error so far: now validate the log by updating the
+	 * log index super block generation.
+	 */
+	ret = dmz_write_sb(dzt, log_set);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/*
+ * Flush dirty metadata blocks.
+ */
+int dmz_flush_mblocks(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_mblock *mblk;
+	struct list_head write_list;
+	int ret;
+
+	INIT_LIST_HEAD(&write_list);
+
+	/*
+	 * Prevent all zone works from running. This ensure exclusive access
+	 * to all zones bitmaps. However, the mapping table may still be
+	 * modified by incoming write requests. So also take the map lock.
+	 */
+	down_write(&dzt->mblk_sem);
+	dmz_lock_map(dzt);
+
+	if (list_empty(&dzt->mblk_dirty_list)) {
+		/* Nothing to do */
+		ret = blkdev_issue_flush(dzt->zbd, GFP_KERNEL, NULL);
+		goto out;
+	}
+
+	dmz_dev_debug(dzt, "FLUSH mblock set %u, gen %llu\n",
+		      dzt->mblk_primary ^ 0x1,
+		      dzt->sb_gen + 1);
+
+	/*
+	 * The primary metadata set is still clean. Keep it this way until
+	 * all updates are successful in the secondary set. That is, use
+	 * the secondary set as a log.
+	 */
+	list_splice_init(&dzt->mblk_dirty_list, &write_list);
+
+	ret = dmz_log_dirty_mblocks(dzt, &write_list);
+	if (ret)
+		goto out;
+
+	/*
+	 * The log is on disk. It is now safe to update in place
+	 * in the current set.
+	 */
+	ret = dmz_write_dirty_mblocks(dzt, &write_list, dzt->mblk_primary);
+	if (ret)
+		goto out;
+
+	ret = dmz_write_sb(dzt, dzt->mblk_primary);
+	if (ret)
+		goto out;
+
+	while (!list_empty(&write_list)) {
+		mblk = list_first_entry(&write_list,
+					struct dm_zoned_mblock, link);
+		list_del_init(&mblk->link);
+
+		clear_bit(DMZ_META_DIRTY, &mblk->state);
+		if (atomic_read(&mblk->ref) == 0)
+			list_add_tail(&mblk->link, &dzt->mblk_lru_list);
+
+	}
+
+	dzt->sb_gen++;
+
+out:
+	if (ret && !list_empty(&write_list))
+		list_splice(&write_list, &dzt->mblk_dirty_list);
+
+	dmz_unlock_map(dzt);
+	up_write(&dzt->mblk_sem);
+
+	return ret;
+}
+
+/*
+ * Check super block.
+ */
+static int dmz_check_sb(struct dm_zoned_target *dzt,
+			struct dm_zoned_super *sb)
+{
+	unsigned int nr_meta_zones, nr_data_zones;
+	u32 crc, stored_crc;
+	u64 gen;
+
+	gen = le64_to_cpu(sb->gen);
+	stored_crc = le32_to_cpu(sb->crc);
+	sb->crc = 0;
+	crc = dmz_sb_crc32(gen, sb, DMZ_BLOCK_SIZE);
+	if (crc != stored_crc) {
+		dmz_dev_err(dzt,
+			    "Invalid checksum (needed 0x%08x %08x, got 0x%08x)\n",
+			    crc,
+			    le32_to_cpu(crc),
+			    stored_crc);
+		return -ENXIO;
+	}
+
+	if (le32_to_cpu(sb->magic) != DMZ_MAGIC) {
+		dmz_dev_err(dzt,
+			    "Invalid meta magic (need 0x%08x, got 0x%08x)\n",
+			    DMZ_MAGIC,
+			    le32_to_cpu(sb->magic));
+		return -ENXIO;
+	}
+
+	if (le32_to_cpu(sb->version) != DMZ_META_VER) {
+		dmz_dev_err(dzt,
+			    "Invalid meta version (need %d, got %d)\n",
+			    DMZ_META_VER,
+			    le32_to_cpu(sb->version));
+		return -ENXIO;
+	}
+
+	nr_meta_zones =
+		(le32_to_cpu(sb->nr_meta_blocks) + dzt->zone_nr_blocks - 1)
+		>> dzt->zone_nr_blocks_shift;
+	if (!nr_meta_zones ||
+	    nr_meta_zones >= dzt->nr_rnd_zones) {
+		dmz_dev_err(dzt,
+			    "Invalid number of metadata blocks\n");
+		return -ENXIO;
+	}
+
+	if (!le32_to_cpu(sb->nr_reserved_seq) ||
+	    le32_to_cpu(sb->nr_reserved_seq) >=
+	    (dzt->nr_useable_zones - nr_meta_zones)) {
+		dmz_dev_err(dzt,
+			    "Invalid number of reserved sequential zones\n");
+		return -ENXIO;
+	}
+
+	nr_data_zones = dzt->nr_useable_zones -
+		(nr_meta_zones * 2 + le32_to_cpu(sb->nr_reserved_seq));
+	if (le32_to_cpu(sb->nr_chunks) > nr_data_zones) {
+		dmz_dev_err(dzt,
+			    "Invalid number of chunks %u / %u\n",
+			    le32_to_cpu(sb->nr_chunks),
+			    nr_data_zones);
+		return -ENXIO;
+	}
+
+	/* OK */
+	dzt->nr_meta_blocks = le32_to_cpu(sb->nr_meta_blocks);
+	dzt->nr_reserved_seq = le32_to_cpu(sb->nr_reserved_seq);
+	dzt->nr_chunks = le32_to_cpu(sb->nr_chunks);
+	dzt->nr_map_blocks = le32_to_cpu(sb->nr_map_blocks);
+	dzt->nr_bitmap_blocks = le32_to_cpu(sb->nr_bitmap_blocks);
+	dzt->nr_meta_zones = nr_meta_zones;
+	dzt->nr_data_zones = nr_data_zones;
+
+	return 0;
+}
+
+/*
+ * Read the first or second super block from disk.
+ */
+static int dmz_read_sb(struct dm_zoned_target *dzt, unsigned int set)
+{
+	return dmz_rdwr_block_sync(dzt, REQ_OP_READ,
+				   dzt->sb[set].block,
+				   dzt->sb[set].mblk->page);
+}
+
+/*
+ * Determine the position of the secondary super blocks on disk.
+ * This is used only if a corruption of the primary super block
+ * is detected.
+ */
+static int dmz_lookup_secondary_sb(struct dm_zoned_target *dzt)
+{
+	struct dm_zoned_mblock *mblk;
+	int i;
+
+	/* Allocate a block */
+	mblk = dmz_alloc_mblock(dzt, 0);
+	if (!mblk)
+		return -ENOMEM;
+
+	dzt->sb[1].mblk = mblk;
+	dzt->sb[1].sb = mblk->data;
+
+	/* Bad first super block: search for the second one */
+	dzt->sb[1].block = dzt->sb[0].block + dzt->zone_nr_blocks;
+	for (i = 0; i < dzt->nr_rnd_zones - 1; i++) {
+		if (dmz_read_sb(dzt, 1) != 0)
+			break;
+		if (le32_to_cpu(dzt->sb[1].sb->magic) == DMZ_MAGIC)
+			return 0;
+		dzt->sb[1].block += dzt->zone_nr_blocks;
+	}
+
+	dmz_free_mblock(dzt, mblk);
+	dzt->sb[1].mblk = NULL;
+
+	return -EIO;
+}
+
+/*
+ * Read the first or second super block from disk.
+ */
+static int dmz_get_sb(struct dm_zoned_target *dzt, unsigned int set)
+{
+	struct dm_zoned_mblock *mblk;
+	int ret;
+
+	/* Allocate a block */
+	mblk = dmz_alloc_mblock(dzt, 0);
+	if (!mblk)
+		return -ENOMEM;
+
+	dzt->sb[set].mblk = mblk;
+	dzt->sb[set].sb = mblk->data;
+
+	/* Read super block */
+	ret = dmz_read_sb(dzt, set);
+	if (ret) {
+		dmz_free_mblock(dzt, mblk);
+		dzt->sb[set].mblk = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Recover a metadata set.
+ */
+static int dmz_recover_mblocks(struct dm_zoned_target *dzt,
+			       unsigned int dst_set)
+{
+	unsigned int src_set = dst_set ^ 0x1;
+	struct page *page;
+	int i, ret;
+
+	dmz_dev_warn(dzt,
+		     "Metadata set %u invalid: recovering\n",
+		     dst_set);
+
+	if (dst_set == 0)
+		dzt->sb[0].block = dmz_sect2blk(dzt->sb_zone->sector);
+	else
+		dzt->sb[1].block = dzt->sb[0].block +
+			(dzt->nr_meta_zones * dzt->zone_nr_blocks);
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+
+	/* Copy metadata blocks */
+	for (i = 1; i < dzt->nr_meta_blocks; i++) {
+		ret = dmz_rdwr_block_sync(dzt, REQ_OP_READ,
+					  dzt->sb[src_set].block + i,
+					  page);
+		if (ret)
+			goto out;
+		ret = dmz_rdwr_block_sync(dzt, REQ_OP_WRITE,
+					  dzt->sb[dst_set].block + i,
+					  page);
+		if (ret)
+			goto out;
+	}
+
+	/* Finalize with the super block */
+	if (!dzt->sb[dst_set].mblk) {
+		dzt->sb[dst_set].mblk = dmz_alloc_mblock(dzt, 0);
+		if (!dzt->sb[dst_set].mblk) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		dzt->sb[dst_set].sb = dzt->sb[dst_set].mblk->data;
+	}
+
+	ret = dmz_write_sb(dzt, dst_set);
+
+out:
+	__free_pages(page, 0);
+
+	return ret;
+}
+
+/*
+ * Get super block from disk.
+ */
+static int dmz_load_sb(struct dm_zoned_target *dzt)
+{
+	bool sb_good[2] = {false, false};
+	u64 sb_gen[2] = {0, 0};
+	int ret;
+
+	/* Read and check the primary super block */
+	dzt->sb[0].block = dmz_sect2blk(dzt->sb_zone->sector);
+	ret = dmz_get_sb(dzt, 0);
+	if (ret) {
+		dmz_dev_err(dzt,
+			    "Read primary super block failed\n");
+		return ret;
+	}
+
+	ret = dmz_check_sb(dzt, dzt->sb[0].sb);
+
+	/* Read and check secondary super block */
+	if (ret == 0) {
+		sb_good[0] = true;
+		dzt->sb[1].block = dzt->sb[0].block +
+			(dzt->nr_meta_zones * dzt->zone_nr_blocks);
+		ret = dmz_get_sb(dzt, 1);
+	} else {
+		ret = dmz_lookup_secondary_sb(dzt);
+	}
+	if (ret) {
+		dmz_dev_err(dzt,
+			    "Read secondary super block\n");
+		return ret;
+	}
+
+	ret = dmz_check_sb(dzt, dzt->sb[1].sb);
+	if (ret == 0)
+		sb_good[1] = true;
+
+	/* Use highest generation sb first */
+	if (!sb_good[0] && !sb_good[1]) {
+		dmz_dev_err(dzt,
+			    "No valid super block found\n");
+		return -EIO;
+	}
+
+	if (sb_good[0])
+		sb_gen[0] = le64_to_cpu(dzt->sb[0].sb->gen);
+	else
+		ret = dmz_recover_mblocks(dzt, 0);
+
+	if (sb_good[1])
+		sb_gen[1] = le64_to_cpu(dzt->sb[1].sb->gen);
+	else
+		ret = dmz_recover_mblocks(dzt, 1);
+
+	if (ret) {
+		dmz_dev_err(dzt,
+			    "Recovery failed\n");
+		return -EIO;
+	}
+
+	if (sb_gen[0] >= sb_gen[1]) {
+		dzt->sb_gen = sb_gen[0];
+		dzt->mblk_primary = 0;
+	} else {
+		dzt->sb_gen = sb_gen[1];
+		dzt->mblk_primary = 1;
+	}
+
+	dmz_dev_info(dzt,
+		     "Using super block %u (gen %llu)\n",
+		     dzt->mblk_primary,
+		     dzt->sb_gen);
+
+	return 0;
+}
+
+/*
+ * Allocate, initialize and add a zone descriptor
+ * to the device zone tree.
+ */
+static int dmz_insert_zone(struct dm_zoned_target *dzt,
+			   struct blk_zone *blkz)
+{
+	struct rb_root *root = &dzt->zones;
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	struct dm_zone *zone;
+	int ret = 0;
+
+	/* Runt zone ? If yes, ignore it */
+	if (blkz->len != dzt->zone_nr_sectors) {
+		if (blkz->start + blkz->len == dzt->zbd_capacity)
+			return 0;
+		return -ENXIO;
+	}
+
+	/* Allocate and initialize a zone descriptor */
+	zone = kmem_cache_zalloc(dmz_zone_cache, GFP_KERNEL);
+	if (!zone)
+		return -ENOMEM;
+
+	RB_CLEAR_NODE(&zone->node);
+	INIT_LIST_HEAD(&zone->link);
+	zone->chunk = DMZ_MAP_UNMAPPED;
+
+	if (blkz->type == BLK_ZONE_TYPE_CONVENTIONAL) {
+		set_bit(DMZ_CONV, &zone->flags);
+	} else if (blkz->type == BLK_ZONE_TYPE_SEQWRITE_REQ) {
+		set_bit(DMZ_SEQ_REQ, &zone->flags);
+	} else if (blkz->type == BLK_ZONE_TYPE_SEQWRITE_PREF) {
+		set_bit(DMZ_SEQ_PREF, &zone->flags);
+	} else {
+		ret = -ENXIO;
+		goto out;
+	}
+
+	if (blkz->cond == BLK_ZONE_COND_OFFLINE)
+		set_bit(DMZ_OFFLINE, &zone->flags);
+	else if (blkz->cond == BLK_ZONE_COND_READONLY)
+		set_bit(DMZ_READ_ONLY, &zone->flags);
+
+	zone->sector = blkz->start;
+	if (dmz_is_conv(zone))
+		zone->wp_block = 0;
+	else
+		zone->wp_block = dmz_sect2blk(blkz->wp - blkz->start);
+
+	/* Figure out where to put new node */
+	while (*new) {
+		struct dm_zone *z = container_of(*new, struct dm_zone, node);
+
+		parent = *new;
+		if (zone->sector + dzt->zone_nr_sectors <= z->sector) {
+			new = &((*new)->rb_left);
+		} else if (zone->sector >= z->sector + dzt->zone_nr_sectors) {
+			new = &((*new)->rb_right);
+		} else {
+			dmz_dev_warn(dzt,
+				     "Zone %u already inserted\n",
+				     dmz_id(dzt, zone));
+			ret = -ENXIO;
+			goto out;
+		}
+	}
+
+	/* Add new node and rebalance tree */
+	rb_link_node(&zone->node, parent, new);
+	rb_insert_color(&zone->node, root);
+
+	/* Count zones */
+	dzt->nr_zones++;
+	if (!dmz_is_readonly(zone) &&
+	    !dmz_is_offline(zone))
+		dzt->nr_useable_zones++;
+
+out:
+	if (ret)
+		kfree(zone);
+
+	return ret;
+}
+
+/*
+ * Lookup a zone in the zone rbtree.
+ */
+static struct dm_zone *dmz_lookup_zone(struct dm_zoned_target *dzt,
+				       unsigned int zone_id)
+{
+	struct rb_root *root = &dzt->zones;
+	struct rb_node *node = root->rb_node;
+	struct dm_zone *zone = NULL;
+	sector_t sector = (sector_t)zone_id << dzt->zone_nr_sectors_shift;
+
+	while (node) {
+		zone = container_of(node, struct dm_zone, node);
+		if (sector < zone->sector)
+			node = node->rb_left;
+		else if (sector >= zone->sector + dzt->zone_nr_sectors)
+			node = node->rb_right;
+		else
+			break;
+		zone = NULL;
+	}
+
+	return zone;
+}
+
+/*
+ * Free zones descriptors.
+ */
+static void dmz_drop_zones(struct dm_zoned_target *dzt)
+{
+	struct rb_root *root = &dzt->zones;
+	struct dm_zone *zone, *next;
+
+	/* Free the zone descriptors */
+	rbtree_postorder_for_each_entry_safe(zone, next, root, node)
+		kmem_cache_free(dmz_zone_cache, zone);
+	dzt->zones = RB_ROOT;
+}
+
+/*
+ * Allocate and initialize zone descriptors using the zone
+ * information from disk.
+ */
+static int dmz_init_zones(struct dm_zoned_target *dzt)
+{
+	struct dm_zone *zone;
+	struct blk_zone *blkz;
+	unsigned int nr_blkz;
+	sector_t sector = 0;
+	int i, ret = 0;
+
+	/* Init */
+	dzt->zone_nr_sectors = dzt->zbdq->limits.chunk_sectors;
+	dzt->zone_nr_sectors_shift = ilog2(dzt->zone_nr_sectors);
+
+	dzt->zone_nr_blocks = dmz_sect2blk(dzt->zone_nr_sectors);
+	dzt->zone_nr_blocks_shift = ilog2(dzt->zone_nr_blocks);
+
+	dzt->zone_bitmap_size = dzt->zone_nr_blocks >> 3;
+	dzt->zone_nr_bitmap_blocks =
+		dzt->zone_bitmap_size >> DMZ_BLOCK_SHIFT;
+
+	/* Get zone information */
+	nr_blkz = DMZ_REPORT_NR_ZONES;
+	blkz = kcalloc(nr_blkz, sizeof(struct blk_zone), GFP_KERNEL);
+	if (!blkz) {
+		dmz_dev_err(dzt,
+			    "No memory for report zones\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * Get zone information and initialize zone descriptors.
+	 * At the same time, determine where the super block
+	 * should be: first block of the first randomly writable
+	 * zone.
+	 */
+	while (sector < dzt->zbd_capacity) {
+
+		/* Get zone information */
+		nr_blkz = DMZ_REPORT_NR_ZONES;
+		ret = blkdev_report_zones(dzt->zbd, sector,
+					  blkz, &nr_blkz,
+					  GFP_KERNEL);
+		if (ret) {
+			dmz_dev_err(dzt,
+				    "Report zones failed %d\n",
+				    ret);
+			goto out;
+		}
+
+		/* Process report */
+		for (i = 0; i < nr_blkz; i++) {
+			ret = dmz_insert_zone(dzt, &blkz[i]);
+			if (ret)
+				goto out;
+			sector += dzt->zone_nr_sectors;
+		}
+
+	}
+
+	if (sector < dzt->zbd_capacity) {
+		dmz_dev_err(dzt,
+			    "Failed to get zone information\n");
+		ret = -ENXIO;
+		goto out;
+	}
+
+	/*
+	 * The entire zone configuration of the disk is now known.
+	 * We however need to fix it: remove the last zone if it is
+	 * a smaller runt zone, and determine the actual use (random or
+	 * sequential) of zones. For a host-managed drive, all conventional
+	 * zones are used as random zones. The same applies for host-aware
+	 * drives, but if the number of conventional zones is too low,
+	 * sequential write preferred zones are marked as random zones until
+	 * the total random zones represent 1% of the drive capacity. Since
+	 * zones can be in any order, this is a 2 step process.
+	 */
+
+	/* Step 1: process conventional zones */
+	for (i = 0; i < dzt->nr_zones; i++) {
+		zone = dmz_lookup_zone(dzt, i);
+		if (dmz_is_conv(zone)) {
+			set_bit(DMZ_RND, &zone->flags);
+			dzt->nr_rnd_zones++;
+		}
+	}
+
+	/* Step 2: process sequential zones */
+	for (i = 0; i < dzt->nr_zones; i++) {
+
+		zone = dmz_lookup_zone(dzt, i);
+		if (dmz_is_seqreq(zone)) {
+			set_bit(DMZ_SEQ, &zone->flags);
+		} else if (dmz_is_seqpref(zone)) {
+			if (dzt->nr_rnd_zones < dzt->nr_zones / 100) {
+				set_bit(DMZ_RND, &zone->flags);
+				zone->wp_block = 0;
+				dzt->nr_rnd_zones++;
+			} else {
+				set_bit(DMZ_SEQ, &zone->flags);
+			}
+		}
+		if (!dzt->sb_zone && dmz_is_rnd(zone))
+			/* Super block zone */
+			dzt->sb_zone = zone;
+	}
+
+out:
+	if (ret)
+		dmz_drop_zones(dzt);
+
+	return ret;
+}
+
+/*
+ * Update a zone information.
+ */
+static int dmz_update_zone(struct dm_zoned_target *dzt, struct dm_zone *zone)
+{
+	unsigned int nr_blkz = 1;
+	struct blk_zone blkz;
+	int ret;
+
+	/* Get zone information from disk */
+	ret = blkdev_report_zones(dzt->zbd, zone->sector,
+				  &blkz, &nr_blkz,
+				  GFP_KERNEL);
+	if (ret) {
+		dmz_dev_err(dzt,
+			    "Get zone %u report failed\n",
+			    dmz_id(dzt, zone));
+		return ret;
+	}
+
+	clear_bit(DMZ_OFFLINE, &zone->flags);
+	clear_bit(DMZ_READ_ONLY, &zone->flags);
+	if (blkz.cond == BLK_ZONE_COND_OFFLINE)
+		set_bit(DMZ_OFFLINE, &zone->flags);
+	else if (blkz.cond == BLK_ZONE_COND_READONLY)
+		set_bit(DMZ_READ_ONLY, &zone->flags);
+
+	if (dmz_is_seq(zone))
+		zone->wp_block = dmz_sect2blk(blkz.wp - blkz.start);
+	else
+		zone->wp_block = 0;
+
+	return 0;
+}
+
+/*
+ * Check zone information after a resume.
+ */
+static int dmz_check_zones(struct dm_zoned_target *dzt)
+{
+	struct dm_zone *zone;
+	sector_t wp_block;
+	unsigned int i;
+	int ret;
+
+	/* Check zones */
+	for (i = 0; i < dzt->nr_zones; i++) {
+
+		zone = dmz_lookup_zone(dzt, i);
+		if (!zone) {
+			dmz_dev_err(dzt,
+				    "Unable to get zone %u\n", i);
+			return -EIO;
+		}
+
+		wp_block = zone->wp_block;
+
+		ret = dmz_update_zone(dzt, zone);
+		if (ret) {
+			dmz_dev_err(dzt,
+				    "Broken zone %u\n", i);
+			return ret;
+		}
+
+		if (dmz_is_offline(zone)) {
+			dmz_dev_warn(dzt,
+				     "Zone %u is offline\n", i);
+			continue;
+		}
+
+		/* Check write pointer */
+		if (!dmz_is_seq(zone))
+			zone->wp_block = 0;
+		else if (zone->wp_block != wp_block) {
+			dmz_dev_err(dzt,
+				    "Zone %u: Invalid wp (%llu / %llu)\n",
+				    i,
+				    (u64)zone->wp_block,
+				    (u64)wp_block);
+			zone->wp_block = wp_block;
+			dmz_invalidate_blocks(dzt, zone, zone->wp_block,
+					dzt->zone_nr_blocks - zone->wp_block);
+			dmz_validate_zone(dzt, zone);
+		}
+
+	}
+
+	return 0;
+}
+
+/*
+ * Reset a zone write pointer.
+ */
+int dmz_reset_zone(struct dm_zoned_target *dzt, struct dm_zone *zone)
+{
+	int ret;
+
+	/*
+	 * Ignore offline zones, read only zones,
+	 * conventional zones and empty sequential zones.
+	 */
+	if (dmz_is_offline(zone) ||
+	    dmz_is_readonly(zone) ||
+	    dmz_is_conv(zone) ||
+	    (dmz_is_seqreq(zone) && dmz_is_empty(zone)))
+		return 0;
+
+	ret = blkdev_reset_zones(dzt->zbd,
+				 zone->sector,
+				 dzt->zone_nr_sectors,
+				 GFP_KERNEL);
+	if (ret) {
+		dmz_dev_err(dzt,
+			    "Reset zone %u failed %d\n",
+			    dmz_id(dzt, zone),
+			    ret);
+		return ret;
+	}
+
+	/* Rewind */
+	zone->wp_block = 0;
+
+	return 0;
+}
+
+static void dmz_get_zone_weight(struct dm_zoned_target *dzt,
+				struct dm_zone *zone);
+
+/*
+ * Initialize chunk mapping.
+ */
+static int dmz_load_mapping(struct dm_zoned_target *dzt)
+{
+	struct dm_zone *dzone, *bzone;
+	struct dm_zoned_mblock *dmap_mblk = NULL;
+	struct dm_zoned_map *dmap;
+	unsigned int i = 0, e = 0, chunk = 0;
+	unsigned int dzone_id;
+	unsigned int bzone_id;
+
+	/* Metadata block array for the chunk mapping table */
+	dzt->dz_map_mblk = kcalloc(dzt->nr_map_blocks,
+				   sizeof(struct dm_zoned_mblk *),
+				   GFP_KERNEL);
+	if (!dzt->dz_map_mblk)
+		return -ENOMEM;
+
+	/* Get chunk mapping table blocks and initialize zone mapping */
+	while (chunk < dzt->nr_chunks) {
+
+		if (!dmap_mblk) {
+			/* Get mapping block */
+			dmap_mblk = dmz_get_mblock(dzt, i + 1);
+			if (IS_ERR(dmap_mblk))
+				return PTR_ERR(dmap_mblk);
+			dzt->dz_map_mblk[i] = dmap_mblk;
+			dmap = (struct dm_zoned_map *) dmap_mblk->data;
+			i++;
+			e = 0;
+		}
+
+		/* Check data zone */
+		dzone_id = le32_to_cpu(dmap[e].dzone_id);
+		if (dzone_id == DMZ_MAP_UNMAPPED)
+			goto next;
+
+		dzone = dmz_lookup_zone(dzt, dzone_id);
+		if (!dzone)
+			return -EIO;
+
+		set_bit(DMZ_DATA, &dzone->flags);
+		dzone->chunk = chunk;
+		dmz_get_zone_weight(dzt, dzone);
+
+		if (dmz_is_rnd(dzone))
+			list_add_tail(&dzone->link, &dzt->dz_map_rnd_list);
+		else
+			list_add_tail(&dzone->link, &dzt->dz_map_seq_list);
+
+		/* Check buffer zone */
+		bzone_id = le32_to_cpu(dmap[e].bzone_id);
+		if (bzone_id == DMZ_MAP_UNMAPPED)
+			goto next;
+
+		bzone = dmz_lookup_zone(dzt, bzone_id);
+		if (!bzone || !dmz_is_rnd(bzone))
+			return -EIO;
+
+		set_bit(DMZ_DATA, &bzone->flags);
+		set_bit(DMZ_BUF, &bzone->flags);
+		bzone->chunk = chunk;
+		bzone->bzone = dzone;
+		dzone->bzone = bzone;
+		dmz_get_zone_weight(dzt, bzone);
+		list_add_tail(&bzone->link, &dzt->dz_map_rnd_list);
+
+next:
+		chunk++;
+		e++;
+		if (e >= DMZ_MAP_ENTRIES)
+			dmap_mblk = NULL;
+
+	}
+
+	/*
+	 * At this point, only meta zones and mapped data zones were
+	 * fully initialized. All remaining zones are unmapped data
+	 * zones. Finish initializing those here.
+	 */
+	for (i = 0; i < dzt->nr_zones; i++) {
+
+		dzone = dmz_lookup_zone(dzt, i);
+		if (!dzone)
+			return -EIO;
+
+		if (dmz_is_meta(dzone))
+			continue;
+
+		if (dmz_is_rnd(dzone))
+			dzt->dz_nr_rnd++;
+		else
+			dzt->dz_nr_seq++;
+
+		if (dmz_is_data(dzone))
+			/* Already initialized */
+			continue;
+
+		/* Unmapped data zone */
+		set_bit(DMZ_DATA, &dzone->flags);
+		dzone->chunk = DMZ_MAP_UNMAPPED;
+		if (dmz_is_rnd(dzone)) {
+			list_add_tail(&dzone->link,
+				      &dzt->dz_unmap_rnd_list);
+			atomic_inc(&dzt->dz_unmap_nr_rnd);
+		} else if (atomic_read(&dzt->nr_reclaim_seq_zones) <
+			   dzt->nr_reserved_seq) {
+			list_add_tail(&dzone->link,
+				      &dzt->reclaim_seq_zones_list);
+			atomic_inc(&dzt->nr_reclaim_seq_zones);
+			dzt->dz_nr_seq--;
+		} else {
+			list_add_tail(&dzone->link,
+				      &dzt->dz_unmap_seq_list);
+			atomic_inc(&dzt->dz_unmap_nr_seq);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Set a data chunk mapping.
+ */
+static void dmz_set_chunk_mapping(struct dm_zoned_target *dzt,
+				  unsigned int chunk,
+				  unsigned int dzone_id,
+				  unsigned int bzone_id)
+{
+	struct dm_zoned_mblock *dmap_mblk =
+		dzt->dz_map_mblk[chunk >> DMZ_MAP_ENTRIES_SHIFT];
+	struct dm_zoned_map *dmap = (struct dm_zoned_map *) dmap_mblk->data;
+	int map_idx = chunk & DMZ_MAP_ENTRIES_MASK;
+
+	dmap[map_idx].dzone_id = cpu_to_le32(dzone_id);
+	dmap[map_idx].bzone_id = cpu_to_le32(bzone_id);
+	dmz_dirty_mblock(dzt, dmap_mblk);
+}
+
+/*
+ * The list of mapped zones is maintained in LRU order.
+ * This rotates a zone at the end of its map list.
+ */
+static void __dmz_lru_zone(struct dm_zoned_target *dzt,
+			   struct dm_zone *zone)
+{
+	if (list_empty(&zone->link))
+		return;
+
+	list_del_init(&zone->link);
+	if (dmz_is_seq(zone))
+		/* LRU rotate sequential zone */
+		list_add_tail(&zone->link, &dzt->dz_map_seq_list);
+	else
+		/* LRU rotate random zone */
+		list_add_tail(&zone->link, &dzt->dz_map_rnd_list);
+}
+
+/*
+ * The list of mapped random zones is maintained
+ * in LRU order. This rotates a zone at the end of the list.
+ */
+static void dmz_lru_zone(struct dm_zoned_target *dzt,
+			 struct dm_zone *zone)
+{
+	__dmz_lru_zone(dzt, zone);
+	if (zone->bzone)
+		__dmz_lru_zone(dzt, zone->bzone);
+}
+
+/*
+ * Wait for any zone to be freed.
+ */
+static void dmz_wait_for_free_zones(struct dm_zoned_target *dzt)
+{
+	DEFINE_WAIT(wait);
+
+	dmz_trigger_reclaim(dzt);
+
+	prepare_to_wait(&dzt->dz_free_wq, &wait, TASK_UNINTERRUPTIBLE);
+	dmz_unlock_map(dzt);
+
+	io_schedule_timeout(HZ);
+
+	dmz_lock_map(dzt);
+	finish_wait(&dzt->dz_free_wq, &wait);
+}
+
+/*
+ * Wait for a zone reclaim to complete.
+ */
+static void dmz_wait_for_reclaim(struct dm_zoned_target *dzt,
+				 struct dm_zone *zone)
+{
+	dmz_unlock_map(dzt);
+	wait_on_bit_timeout(&zone->flags, DMZ_RECLAIM,
+			    TASK_UNINTERRUPTIBLE,
+			    HZ);
+	dmz_lock_map(dzt);
+}
+
+/*
+ * Get a data chunk mapping zone.
+ */
+struct dm_zone *dmz_get_chunk_mapping(struct dm_zoned_target *dzt,
+				      unsigned int chunk, int op)
+{
+	struct dm_zoned_mblock *dmap_mblk =
+		dzt->dz_map_mblk[chunk >> DMZ_MAP_ENTRIES_SHIFT];
+	struct dm_zoned_map *dmap = (struct dm_zoned_map *) dmap_mblk->data;
+	int dmap_idx = chunk & DMZ_MAP_ENTRIES_MASK;
+	unsigned int dzone_id;
+	struct dm_zone *dzone = NULL;
+
+	dmz_lock_map(dzt);
+
+again:
+
+	/* Get the chunk mapping */
+	dzone_id = le32_to_cpu(dmap[dmap_idx].dzone_id);
+	if (dzone_id == DMZ_MAP_UNMAPPED) {
+		/*
+		 * Read or discard in unmapped chunks are fine. But for
+		 * writes, we need a mapping, so get one.
+		 */
+		if (op != REQ_OP_WRITE)
+			goto out;
+
+		/* Alloate a random zone */
+		dzone = dmz_alloc_zone(dzt, DMZ_ALLOC_RND);
+		if (!dzone) {
+			dmz_wait_for_free_zones(dzt);
+			goto again;
+		}
+
+		dmz_map_zone(dzt, dzone, chunk);
+
+	} else {
+
+		/* The chunk is already mapped: get the mapping zone */
+		dzone = dmz_lookup_zone(dzt, dzone_id);
+		if (!dzone || dzone->chunk != chunk) {
+			dzone = ERR_PTR(-EIO);
+			goto out;
+		}
+
+	}
+
+	/*
+	 * If the zone is being reclaimed, the chunk mapping may change.
+	 * So wait for reclaim to complete and retry.
+	 */
+	if (dmz_in_reclaim(dzone)) {
+		dmz_wait_for_reclaim(dzt, dzone);
+		goto again;
+	}
+
+	dmz_lru_zone(dzt, dzone);
+
+out:
+	dmz_unlock_map(dzt);
+
+	return dzone;
+}
+
+/*
+ * Allocate and map a random zone to buffer a chunk
+ * already mapped to a sequential zone.
+ */
+struct dm_zone *dmz_get_chunk_buffer(struct dm_zoned_target *dzt,
+				     struct dm_zone *dzone)
+{
+	struct dm_zone *bzone;
+	unsigned int chunk;
+
+	dmz_lock_map(dzt);
+
+	chunk = dzone->chunk;
+
+	/* Alloate a random zone */
+	do {
+		bzone = dmz_alloc_zone(dzt, DMZ_ALLOC_RND);
+		if (!bzone)
+			dmz_wait_for_free_zones(dzt);
+	} while (!bzone);
+
+	if (bzone) {
+
+		if (dmz_is_seqpref(bzone))
+			dmz_reset_zone(dzt, bzone);
+
+		/* Update the chunk mapping */
+		dmz_set_chunk_mapping(dzt, chunk,
+				      dmz_id(dzt, dzone),
+				      dmz_id(dzt, bzone));
+
+		set_bit(DMZ_BUF, &bzone->flags);
+		bzone->chunk = chunk;
+		bzone->bzone = dzone;
+		dzone->bzone = bzone;
+		list_add_tail(&bzone->link, &dzt->dz_map_rnd_list);
+
+	}
+
+	dmz_unlock_map(dzt);
+
+	return bzone;
+}
+
+/*
+ * Get an unmapped (free) zone.
+ * This must be called with the mapping lock held.
+ */
+struct dm_zone *dmz_alloc_zone(struct dm_zoned_target *dzt,
+			       unsigned long flags)
+{
+	struct list_head *list;
+	struct dm_zone *zone;
+
+	if (flags & DMZ_ALLOC_RND)
+		list = &dzt->dz_unmap_rnd_list;
+	else
+		list = &dzt->dz_unmap_seq_list;
+
+	if (list_empty(list)) {
+
+		/*
+		 * No free zone: if this is for reclaim, allow using the
+		 * reserved sequential zones.
+		 */
+		if (!(flags & DMZ_ALLOC_RECLAIM) ||
+		    list_empty(&dzt->reclaim_seq_zones_list))
+			return NULL;
+
+		zone = list_first_entry(&dzt->reclaim_seq_zones_list,
+					struct dm_zone, link);
+		list_del_init(&zone->link);
+		atomic_dec(&dzt->nr_reclaim_seq_zones);
+		return zone;
+
+	}
+
+	zone = list_first_entry(list, struct dm_zone, link);
+	list_del_init(&zone->link);
+
+	if (dmz_is_rnd(zone))
+		atomic_dec(&dzt->dz_unmap_nr_rnd);
+	else
+		atomic_dec(&dzt->dz_unmap_nr_seq);
+
+	if (dmz_is_offline(zone)) {
+		dmz_dev_warn(dzt,
+			     "Zone %u is offline\n",
+			     dmz_id(dzt, zone));
+		zone = NULL;
+	}
+
+	if (dmz_should_reclaim(dzt))
+		dmz_trigger_reclaim(dzt);
+
+	return zone;
+}
+
+/*
+ * Free a zone.
+ * This must be called with the mapping lock held.
+ */
+void dmz_free_zone(struct dm_zoned_target *dzt, struct dm_zone *zone)
+{
+
+	/* Return the zone to its type unmap list */
+	if (dmz_is_rnd(zone)) {
+		list_add_tail(&zone->link, &dzt->dz_unmap_rnd_list);
+		atomic_inc(&dzt->dz_unmap_nr_rnd);
+	} else if (atomic_read(&dzt->nr_reclaim_seq_zones) <
+		   dzt->nr_reserved_seq) {
+		list_add_tail(&zone->link, &dzt->reclaim_seq_zones_list);
+		atomic_inc(&dzt->nr_reclaim_seq_zones);
+	} else {
+		list_add_tail(&zone->link, &dzt->dz_unmap_seq_list);
+		atomic_inc(&dzt->dz_unmap_nr_seq);
+	}
+
+	wake_up_all(&dzt->dz_free_wq);
+}
+
+/*
+ * Map a chunk to a zone.
+ * This must be called with the mapping lock held.
+ */
+void dmz_map_zone(struct dm_zoned_target *dzt,
+		  struct dm_zone *dzone, unsigned int chunk)
+{
+
+	if (dmz_is_seqpref(dzone))
+		dmz_reset_zone(dzt, dzone);
+
+	/* Set the chunk mapping */
+	dmz_set_chunk_mapping(dzt, chunk,
+			      dmz_id(dzt, dzone),
+			      DMZ_MAP_UNMAPPED);
+	dzone->chunk = chunk;
+	if (dmz_is_rnd(dzone))
+		list_add_tail(&dzone->link, &dzt->dz_map_rnd_list);
+	else
+		list_add_tail(&dzone->link, &dzt->dz_map_seq_list);
+}
+
+/*
+ * Unmap a zone.
+ * This must be called with the mapping lock held.
+ */
+void dmz_unmap_zone(struct dm_zoned_target *dzt, struct dm_zone *zone)
+{
+	unsigned int chunk = zone->chunk;
+	unsigned int dzone_id;
+
+	if (chunk == DMZ_MAP_UNMAPPED)
+		/* Already unmapped */
+		return;
+
+	if (test_and_clear_bit(DMZ_BUF, &zone->flags)) {
+
+		/*
+		 * Unmapping buffer zone: clear only
+		 * the chunk buffer mapping
+		 */
+		dzone_id = dmz_id(dzt, zone->bzone);
+		zone->bzone->bzone = NULL;
+		zone->bzone = NULL;
+
+	} else {
+
+		/*
+		 * Unmapping data zone: the zone must
+		 * not be any buffer zone.
+		 */
+		dzone_id = DMZ_MAP_UNMAPPED;
+
+	}
+
+	dmz_set_chunk_mapping(dzt, chunk, dzone_id,
+			      DMZ_MAP_UNMAPPED);
+
+	zone->chunk = DMZ_MAP_UNMAPPED;
+	list_del_init(&zone->link);
+}
+
+/*
+ * Write and discard change the block validity in data
+ * zones and their buffer zones. Check all blocks to see
+ * if those zones can be reclaimed and freed on the fly
+ * (if all blocks are invalid).
+ */
+void dmz_validate_zone(struct dm_zoned_target *dzt, struct dm_zone *dzone)
+{
+	struct dm_zone *bzone;
+
+	dmz_lock_map(dzt);
+
+	bzone = dzone->bzone;
+	if (bzone) {
+		if (!dmz_weight(bzone)) {
+			/* Empty buffer zone: reclaim it */
+			dmz_unmap_zone(dzt, bzone);
+			dmz_free_zone(dzt, bzone);
+			bzone = NULL;
+		} else {
+			dmz_lru_zone(dzt, bzone);
+		}
+	}
+
+	if (!dmz_weight(dzone) && !bzone) {
+		/* Unbuffered empty data zone: reclaim it */
+		dmz_unmap_zone(dzt, dzone);
+		dmz_free_zone(dzt, dzone);
+	} else {
+		dmz_lru_zone(dzt, dzone);
+	}
+
+	dmz_unlock_map(dzt);
+}
+
+/*
+ * Set @nr_bits bits in @bitmap starting from @bit.
+ * Return the number of bits changed from 0 to 1.
+ */
+static unsigned int dmz_set_bits(unsigned long *bitmap,
+				 unsigned int bit, unsigned int nr_bits)
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
+
+	}
+
+	return n;
+
+}
+
+/*
+ * Get the bitmap block storing the bit for chunk_block in zone.
+ */
+static struct dm_zoned_mblock *dmz_get_bitmap(struct dm_zoned_target *dzt,
+					      struct dm_zone *zone,
+					      sector_t chunk_block)
+{
+	sector_t bitmap_block = 1 + dzt->nr_map_blocks
+		+ (sector_t)(dmz_id(dzt, zone)
+			     * dzt->zone_nr_bitmap_blocks)
+		+ (chunk_block >> DMZ_BLOCK_SHIFT_BITS);
+
+	return dmz_get_mblock(dzt, bitmap_block);
+}
+
+/*
+ * Validate all the blocks in the range [block..block+nr_blocks-1].
+ */
+int dmz_validate_blocks(struct dm_zoned_target *dzt,
+			struct dm_zone *zone,
+			sector_t chunk_block, unsigned int nr_blocks)
+{
+	unsigned int count, bit, nr_bits;
+	struct dm_zoned_mblock *mblk;
+	unsigned int n = 0;
+
+	dmz_dev_debug(dzt,
+		      "=> VALIDATE zone %u, block %llu, %u blocks\n",
+		      dmz_id(dzt, zone),
+		      (u64)chunk_block,
+		      nr_blocks);
+
+	WARN_ON(chunk_block + nr_blocks > dzt->zone_nr_blocks);
+
+	while (nr_blocks) {
+
+		/* Get bitmap block */
+		mblk = dmz_get_bitmap(dzt, zone, chunk_block);
+		if (IS_ERR(mblk))
+			return PTR_ERR(mblk);
+
+		/* Set bits */
+		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
+		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
+
+		count = dmz_set_bits((unsigned long *) mblk->data,
+				     bit, nr_bits);
+		if (count) {
+			dmz_dirty_mblock(dzt, mblk);
+			n += count;
+		}
+		dmz_release_mblock(dzt, mblk);
+
+		nr_blocks -= nr_bits;
+		chunk_block += nr_bits;
+
+	}
+
+	if (likely(zone->weight + n <= dzt->zone_nr_blocks)) {
+		zone->weight += n;
+	} else {
+		dmz_dev_warn(dzt,
+			     "Zone %u: weight %u should be <= %llu\n",
+			     dmz_id(dzt, zone),
+			     zone->weight,
+			     (u64)dzt->zone_nr_blocks - n);
+		zone->weight = dzt->zone_nr_blocks;
+	}
+
+	dmz_dev_debug(dzt,
+		      "=> VALIDATE zone %u => weight %u\n",
+		      dmz_id(dzt, zone),
+		      zone->weight);
+
+	return 0;
+}
+
+/*
+ * Clear nr_bits bits in bitmap starting from bit.
+ * Return the number of bits cleared.
+ */
+static int dmz_clear_bits(unsigned long *bitmap,
+			  int bit, int nr_bits)
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
+
+	}
+
+	return n;
+
+}
+
+/*
+ * Invalidate all the blocks in the range [block..block+nr_blocks-1].
+ */
+int dmz_invalidate_blocks(struct dm_zoned_target *dzt,
+			  struct dm_zone *zone,
+			  sector_t chunk_block, unsigned int nr_blocks)
+{
+	unsigned int count, bit, nr_bits;
+	struct dm_zoned_mblock *mblk;
+	unsigned int n = 0;
+
+	dmz_dev_debug(dzt,
+		      "=> INVALIDATE zone %u, block %llu, %u blocks\n",
+		      dmz_id(dzt, zone),
+		      (u64)chunk_block,
+		      nr_blocks);
+
+	WARN_ON(chunk_block + nr_blocks > dzt->zone_nr_blocks);
+
+	while (nr_blocks) {
+
+		/* Get bitmap block */
+		mblk = dmz_get_bitmap(dzt, zone, chunk_block);
+		if (IS_ERR(mblk))
+			return PTR_ERR(mblk);
+
+		/* Clear bits */
+		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
+		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
+
+		count = dmz_clear_bits((unsigned long *) mblk->data,
+				       bit, nr_bits);
+		if (count) {
+			dmz_dirty_mblock(dzt, mblk);
+			n += count;
+		}
+		dmz_release_mblock(dzt, mblk);
+
+		nr_blocks -= nr_bits;
+		chunk_block += nr_bits;
+
+	}
+
+	if (zone->weight >= n) {
+		zone->weight -= n;
+	} else {
+		dmz_dev_warn(dzt,
+			     "Zone %u: weight %u should be >= %u\n",
+			     dmz_id(dzt, zone),
+			     zone->weight,
+			     n);
+		zone->weight = 0;
+	}
+
+	return 0;
+}
+
+/*
+ * Get a block bit value.
+ */
+static int dmz_test_block(struct dm_zoned_target *dzt,
+			  struct dm_zone *zone,
+			  sector_t chunk_block)
+{
+	struct dm_zoned_mblock *mblk;
+	int ret;
+
+	WARN_ON(chunk_block >= dzt->zone_nr_blocks);
+
+	/* Get bitmap block */
+	mblk = dmz_get_bitmap(dzt, zone, chunk_block);
+	if (IS_ERR(mblk))
+		return PTR_ERR(mblk);
+
+	/* Get offset */
+	ret = test_bit(chunk_block & DMZ_BLOCK_MASK_BITS,
+		       (unsigned long *) mblk->data) != 0;
+
+	dmz_release_mblock(dzt, mblk);
+
+	return ret;
+}
+
+/*
+ * Return the number of blocks from chunk_block to the first block with a bit
+ * value specified by set. Search at most nr_blocks blocks from chunk_block.
+ */
+static int dmz_to_next_set_block(struct dm_zoned_target *dzt,
+				 struct dm_zone *zone,
+				 sector_t chunk_block, unsigned int nr_blocks,
+				 int set)
+{
+	struct dm_zoned_mblock *mblk;
+	unsigned int bit, set_bit, nr_bits;
+	unsigned long *bitmap;
+	int n = 0;
+
+	WARN_ON(chunk_block + nr_blocks > dzt->zone_nr_blocks);
+
+	while (nr_blocks) {
+
+		/* Get bitmap block */
+		mblk = dmz_get_bitmap(dzt, zone, chunk_block);
+		if (IS_ERR(mblk))
+			return PTR_ERR(mblk);
+
+		/* Get offset */
+		bitmap = (unsigned long *) mblk->data;
+		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
+		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
+		if (set)
+			set_bit = find_next_bit(bitmap,
+						DMZ_BLOCK_SIZE_BITS,
+						bit);
+		else
+			set_bit = find_next_zero_bit(bitmap,
+						     DMZ_BLOCK_SIZE_BITS,
+						     bit);
+		dmz_release_mblock(dzt, mblk);
+
+		n += set_bit - bit;
+		if (set_bit < DMZ_BLOCK_SIZE_BITS)
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
+/*
+ * Test if chunk_block is valid. If it is, the number of consecutive
+ * valid blocks from chunk_block will be returned.
+ */
+int dmz_block_valid(struct dm_zoned_target *dzt,
+		    struct dm_zone *zone,
+		    sector_t chunk_block)
+{
+	int valid;
+
+	/* Test block */
+	valid = dmz_test_block(dzt, zone, chunk_block);
+	if (valid <= 0)
+		return valid;
+
+	/* The block is valid: get the number of valid blocks from block */
+	return dmz_to_next_set_block(dzt, zone, chunk_block,
+				     dzt->zone_nr_blocks - chunk_block,
+				     0);
+}
+
+/*
+ * Find the first valid block from @chunk_block in @zone.
+ * If such a block is found, its number is returned using
+ * @chunk_block and the total number of valid blocks from @chunk_block
+ * is returned.
+ */
+int dmz_first_valid_block(struct dm_zoned_target *dzt,
+			  struct dm_zone *zone,
+			  sector_t *chunk_block)
+{
+	sector_t start_block = *chunk_block;
+	int ret;
+
+	ret = dmz_to_next_set_block(dzt, zone, start_block,
+				    dzt->zone_nr_blocks - start_block, 1);
+	if (ret < 0)
+		return ret;
+
+	start_block += ret;
+	*chunk_block = start_block;
+
+	return dmz_to_next_set_block(dzt, zone, start_block,
+				     dzt->zone_nr_blocks - start_block, 0);
+}
+
+/*
+ * Count the number of bits set starting from bit up to bit + nr_bits - 1.
+ */
+static int dmz_count_bits(void *bitmap, int bit, int nr_bits)
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
+
+	}
+
+	return n;
+
+}
+
+/*
+ * Get a zone weight.
+ */
+static void dmz_get_zone_weight(struct dm_zoned_target *dzt,
+				struct dm_zone *zone)
+{
+	struct dm_zoned_mblock *mblk;
+	sector_t chunk_block = 0;
+	unsigned int bit, nr_bits;
+	unsigned int nr_blocks = dzt->zone_nr_blocks;
+	void *bitmap;
+	int n = 0;
+
+	while (nr_blocks) {
+
+		/* Get bitmap block */
+		mblk = dmz_get_bitmap(dzt, zone, chunk_block);
+		if (IS_ERR(mblk)) {
+			n = 0;
+			break;
+		}
+
+		/* Count bits in this block */
+		bitmap = mblk->data;
+		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
+		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
+		n += dmz_count_bits(bitmap, bit, nr_bits);
+
+		dmz_release_mblock(dzt, mblk);
+
+		nr_blocks -= nr_bits;
+		chunk_block += nr_bits;
+
+	}
+
+	zone->weight = n;
+}
+
+/*
+ * Initialize the target metadata.
+ */
+int dmz_init_meta(struct dm_zoned_target *dzt,
+		  struct dm_zoned_target_config *conf)
+{
+	unsigned int i, zid;
+	struct dm_zone *zone;
+	int ret;
+
+	/* Initialize zone descriptors */
+	ret = dmz_init_zones(dzt);
+	if (ret)
+		goto out;
+
+	/* Get super block */
+	ret = dmz_load_sb(dzt);
+	if (ret)
+		goto out;
+
+	/* Set metadata zones starting from sb_zone */
+	zid = dmz_id(dzt, dzt->sb_zone);
+	for (i = 0; i < dzt->nr_meta_zones << 1; i++) {
+		zone = dmz_lookup_zone(dzt, zid + i);
+		if (!zone || !dmz_is_rnd(zone))
+			return -ENXIO;
+		set_bit(DMZ_META, &zone->flags);
+	}
+
+	/*
+	 * Maximum allowed size of the cache: we need 2 super blocks,
+	 * the chunk map blocks and enough blocks to be able to cache
+	 * up to 128 zones.
+	 */
+	dzt->max_nr_mblks = 2 + dzt->nr_map_blocks +
+		dzt->zone_nr_bitmap_blocks * 64;
+
+	/* Load mapping table */
+	ret = dmz_load_mapping(dzt);
+	if (ret)
+		goto out;
+
+	dmz_dev_info(dzt,
+		     "Backend device:\n");
+	dmz_dev_info(dzt,
+		     "    %llu 512-byte logical sectors\n",
+		     (u64)dzt->nr_zones
+		     << dzt->zone_nr_sectors_shift);
+	dmz_dev_info(dzt,
+		     "    %u zones of %llu 512-byte logical sectors\n",
+		     dzt->nr_zones,
+		     (u64)dzt->zone_nr_sectors);
+	dmz_dev_info(dzt,
+		     "    %u metadata zones\n",
+		     dzt->nr_meta_zones * 2);
+	dmz_dev_info(dzt,
+		     "    %u data zones for %u chunks\n",
+		     dzt->nr_data_zones,
+		     dzt->nr_chunks);
+	dmz_dev_info(dzt,
+		     "        %u random zones (%u unmapped)\n",
+		     dzt->dz_nr_rnd,
+		     atomic_read(&dzt->dz_unmap_nr_rnd));
+	dmz_dev_info(dzt,
+		     "        %u sequential zones (%u unmapped)\n",
+		     dzt->dz_nr_seq,
+		     atomic_read(&dzt->dz_unmap_nr_seq));
+	dmz_dev_info(dzt,
+		     "    %u reserved sequential data zones\n",
+		     dzt->nr_reserved_seq);
+
+	dmz_dev_debug(dzt,
+		      "Format:\n");
+	dmz_dev_debug(dzt,
+		      "%u metadata blocks per set (%u max cache)\n",
+		      dzt->nr_meta_blocks,
+		      dzt->max_nr_mblks);
+	dmz_dev_debug(dzt,
+		      "    %u data zone mapping blocks\n",
+		      dzt->nr_map_blocks);
+	dmz_dev_debug(dzt,
+		      "    %u bitmap blocks\n",
+		      dzt->nr_bitmap_blocks);
+
+out:
+	if (ret)
+		dmz_cleanup_meta(dzt);
+
+	return ret;
+}
+
+/*
+ * Cleanup the target metadata resources.
+ */
+void dmz_cleanup_meta(struct dm_zoned_target *dzt)
+{
+	struct rb_root *root = &dzt->mblk_rbtree;
+	struct dm_zoned_mblock *mblk, *next;
+	int i;
+
+	/* Release zone mapping resources */
+	if (dzt->dz_map_mblk) {
+		for (i = 0; i < dzt->nr_map_blocks; i++)
+			dmz_release_mblock(dzt, dzt->dz_map_mblk[i]);
+		kfree(dzt->dz_map_mblk);
+		dzt->dz_map_mblk = NULL;
+	}
+
+	/* Release super blocks */
+	for (i = 0; i < 2; i++) {
+		if (dzt->sb[i].mblk) {
+			dmz_free_mblock(dzt, dzt->sb[i].mblk);
+			dzt->sb[i].mblk = NULL;
+		}
+	}
+
+	/* Free cached blocks */
+	while (!list_empty(&dzt->mblk_dirty_list)) {
+		mblk = list_first_entry(&dzt->mblk_dirty_list,
+					struct dm_zoned_mblock, link);
+		dmz_dev_warn(dzt, "mblock %llu still in dirty list (ref %u)\n",
+			     (u64)mblk->no,
+			     atomic_read(&mblk->ref));
+		list_del_init(&mblk->link);
+		rb_erase(&mblk->node, &dzt->mblk_rbtree);
+		dmz_free_mblock(dzt, mblk);
+	}
+
+	while (!list_empty(&dzt->mblk_lru_list)) {
+		mblk = list_first_entry(&dzt->mblk_lru_list,
+					struct dm_zoned_mblock, link);
+		list_del_init(&mblk->link);
+		rb_erase(&mblk->node, &dzt->mblk_rbtree);
+		dmz_free_mblock(dzt, mblk);
+	}
+
+	/* Sanity checks: the mblock rbtree should now be empty */
+	rbtree_postorder_for_each_entry_safe(mblk, next, root, node) {
+		dmz_dev_warn(dzt, "mblock %llu ref %u still in rbtree\n",
+			     (u64)mblk->no,
+			     atomic_read(&mblk->ref));
+		atomic_set(&mblk->ref, 0);
+		dmz_free_mblock(dzt, mblk);
+	}
+
+	/* Free the zone descriptors */
+	dmz_drop_zones(dzt);
+}
+
+/*
+ * Check metadata on resume.
+ */
+int dmz_resume_meta(struct dm_zoned_target *dzt)
+{
+	return dmz_check_zones(dzt);
+}
+
diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
new file mode 100644
index 0000000..cc7c7a2
--- /dev/null
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -0,0 +1,699 @@
+/*
+ * (C) Copyright 2016 Western Digital.
+ *
+ * This software is distributed under the terms of the GNU Lesser General
+ * Public License version 2, or any later version, "as is," without technical
+ * support, and WITHOUT ANY WARRANTY, without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Author: Damien Le Moal <damien.lemoal@wdc.com>
+ */
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/slab.h>
+
+#include "dm-zoned.h"
+
+/*
+ * I/O region BIO completion callback.
+ */
+static void dmz_reclaim_endio(struct bio *bio)
+{
+	struct dm_zoned_ioreg *ioreg = bio->bi_private;
+
+	ioreg->err = bio->bi_error;
+	complete(&ioreg->wait);
+}
+
+/*
+ * Free an I/O region.
+ */
+static void dmz_reclaim_free_ioreg(struct dm_zoned_ioreg *ioreg)
+{
+	int i;
+
+	if (ioreg->bvec) {
+		for (i = 0; i < ioreg->nr_bvecs; i++)
+			__free_page(ioreg->bvec[i].bv_page);
+		kfree(ioreg->bvec);
+	}
+	kfree(ioreg);
+}
+
+/*
+ * Allocate and initialize an I/O region and its BIO.
+ */
+static struct dm_zoned_ioreg *dmz_reclaim_alloc_ioreg(sector_t chunk_block,
+						unsigned int nr_blocks)
+{
+	struct dm_zoned_ioreg *ioreg;
+	unsigned int nr_bvecs;
+	struct bio_vec *bvec, *bv;
+	int i;
+
+	ioreg = kmalloc(sizeof(struct dm_zoned_ioreg), GFP_NOIO | __GFP_ZERO);
+	if (!ioreg)
+		return NULL;
+
+	nr_bvecs = min_t(unsigned int, BIO_MAX_PAGES,
+			 ((nr_blocks << DMZ_BLOCK_SHIFT) + PAGE_SIZE - 1)
+			 >> PAGE_SHIFT);
+	nr_blocks = min_t(unsigned int, nr_blocks,
+			  nr_bvecs << (PAGE_SHIFT - DMZ_BLOCK_SHIFT));
+
+	bvec = kcalloc(nr_bvecs, sizeof(struct bio_vec), GFP_NOIO);
+	if (!bvec)
+		goto err;
+
+	ioreg->chunk_block = chunk_block;
+	ioreg->nr_blocks = nr_blocks;
+	ioreg->nr_bvecs = nr_bvecs;
+	ioreg->bvec = bvec;
+
+	for (i = 0; i < nr_bvecs; i++) {
+
+		bv = &bvec[i];
+
+		bv->bv_offset = 0;
+		bv->bv_len = min_t(unsigned int, PAGE_SIZE,
+				   nr_blocks << DMZ_BLOCK_SHIFT);
+
+		bv->bv_page = alloc_page(GFP_NOIO);
+		if (!bv->bv_page)
+			goto err;
+
+		nr_blocks -= bv->bv_len >> DMZ_BLOCK_SHIFT;
+	}
+
+	return ioreg;
+
+err:
+	dmz_reclaim_free_ioreg(ioreg);
+
+	return NULL;
+}
+
+/*
+ * Submit an I/O region for reading or writing in @zone.
+ */
+static void dmz_reclaim_submit_ioreg(struct dm_zoned_target *dzt,
+				     struct dm_zone *zone,
+				     struct dm_zoned_ioreg *ioreg,
+				     unsigned int op)
+{
+	struct bio *bio = &ioreg->bio;
+
+	init_completion(&ioreg->wait);
+	ioreg->err = 0;
+
+	bio_init(bio, ioreg->bvec, ioreg->nr_bvecs);
+	bio->bi_vcnt = ioreg->nr_bvecs;
+	bio->bi_bdev = dzt->zbd;
+	bio->bi_end_io = dmz_reclaim_endio;
+	bio->bi_private = ioreg;
+	bio->bi_iter.bi_sector = dmz_blk2sect(dmz_sect2blk(zone->sector)
+					      + ioreg->chunk_block);
+	bio->bi_iter.bi_size = ioreg->nr_blocks << DMZ_BLOCK_SHIFT;
+	bio_set_op_attrs(bio, op, 0);
+
+	submit_bio(bio);
+}
+
+/*
+ * Read the next region of valid blocks after @chunk_block
+ * in @zone.
+ */
+static struct dm_zoned_ioreg *dmz_reclaim_read(struct dm_zoned_target *dzt,
+					       struct dm_zone *zone,
+					       sector_t chunk_block)
+{
+	struct dm_zoned_ioreg *ioreg;
+	int ret;
+
+	if (chunk_block >= dzt->zone_nr_blocks)
+		return NULL;
+
+	/* Get valid block range */
+	ret = dmz_first_valid_block(dzt, zone, &chunk_block);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	if (!ret)
+		return NULL;
+
+	/* Build I/O region */
+	ioreg = dmz_reclaim_alloc_ioreg(chunk_block, ret);
+	if (!ioreg)
+		return ERR_PTR(-ENOMEM);
+
+	dmz_dev_debug(dzt,
+		      "Reclaim: Read %s zone %u, block %llu+%u\n",
+		      dmz_is_rnd(zone) ? "RND" : "SEQ",
+		      dmz_id(dzt, zone),
+		      (unsigned long long)chunk_block,
+		      ioreg->nr_blocks);
+
+	dmz_reclaim_submit_ioreg(dzt, zone, ioreg, REQ_OP_READ);
+
+	return ioreg;
+
+}
+
+/*
+ * Align a sequential zone write pointer to chunk_block.
+ */
+static int dmz_reclaim_align_wp(struct dm_zoned_target *dzt,
+				struct dm_zone *zone, sector_t chunk_block)
+{
+	sector_t wp_block = zone->wp_block;
+	unsigned int nr_blocks;
+	int ret;
+
+	if (wp_block > chunk_block)
+		return -EIO;
+
+	/*
+	 * Zeroout the space between the write
+	 * pointer and the requested position.
+	 */
+	nr_blocks = chunk_block - zone->wp_block;
+	if (!nr_blocks)
+		return 0;
+
+	ret = blkdev_issue_zeroout(dzt->zbd,
+				   zone->sector + dmz_blk2sect(wp_block),
+				   dmz_blk2sect(nr_blocks),
+				   GFP_NOIO, false);
+	if (ret) {
+		dmz_dev_err(dzt,
+			    "Align zone %u wp %llu to +%u blocks failed %d\n",
+			    dmz_id(dzt, zone),
+			    (unsigned long long)wp_block,
+			    nr_blocks,
+			    ret);
+		return ret;
+	}
+
+	zone->wp_block += nr_blocks;
+
+	return 0;
+}
+
+/*
+ * Write blocks.
+ */
+static int dmz_reclaim_write(struct dm_zoned_target *dzt,
+			     struct dm_zone *zone,
+			     struct dm_zoned_ioreg **ioregs,
+			     unsigned int nr_ioregs)
+{
+	struct dm_zoned_ioreg *ioreg;
+	sector_t chunk_block;
+	int i, ret = 0;
+
+	for (i = 0; i < nr_ioregs; i++) {
+
+		ioreg = ioregs[i];
+
+		/* Wait for the read I/O to complete */
+		wait_for_completion_io(&ioreg->wait);
+
+		if (ret || ioreg->err) {
+			if (ret == 0)
+				ret = ioreg->err;
+			dmz_reclaim_free_ioreg(ioreg);
+			ioregs[i] = NULL;
+			continue;
+		}
+
+		chunk_block = ioreg->chunk_block;
+
+		dmz_dev_debug(dzt,
+			      "Reclaim: Write %s zone %u, block %llu+%u\n",
+			      dmz_is_rnd(zone) ? "RND" : "SEQ",
+			      dmz_id(dzt, zone),
+			      (unsigned long long)chunk_block,
+			      ioreg->nr_blocks);
+
+		/*
+		 * If we are writing in a sequential zones,
+		 * we must make sure that writes are sequential. So
+		 * fill up any eventual hole between writes.
+		 */
+		if (dmz_is_seq(zone)) {
+			ret = dmz_reclaim_align_wp(dzt, zone, chunk_block);
+			if (ret)
+				break;
+		}
+
+		/* Do write */
+		dmz_reclaim_submit_ioreg(dzt, zone, ioreg, REQ_OP_WRITE);
+		wait_for_completion_io(&ioreg->wait);
+
+		ret = ioreg->err;
+		if (ret) {
+			dmz_dev_err(dzt, "Reclaim: Write failed\n");
+		} else {
+			ret = dmz_validate_blocks(dzt, zone, chunk_block,
+						  ioreg->nr_blocks);
+			if (ret == 0 && dmz_is_seq(zone))
+				zone->wp_block += ioreg->nr_blocks;
+		}
+
+		ioregs[i] = NULL;
+		dmz_reclaim_free_ioreg(ioreg);
+
+	}
+
+	return ret;
+}
+
+/*
+ * Move valid blocks of src_zone into dst_zone.
+ */
+static int dmz_reclaim_copy_zone(struct dm_zoned_target *dzt,
+				 struct dm_zone *src_zone,
+				 struct dm_zone *dst_zone)
+{
+	struct dm_zoned_ioreg *ioregs[DMZ_RECLAIM_MAX_IOREGS];
+	struct dm_zoned_ioreg *ioreg;
+	sector_t chunk_block = 0, end_block;
+	int nr_ioregs = 0, i, ret;
+
+	if (dmz_is_seq(src_zone))
+		end_block = src_zone->wp_block;
+	else
+		end_block = dzt->zone_nr_blocks;
+
+	while (chunk_block < end_block) {
+
+		/* Read valid regions from source zone */
+		nr_ioregs = 0;
+		while (nr_ioregs < DMZ_RECLAIM_MAX_IOREGS &&
+		       chunk_block < end_block) {
+
+			ioreg = dmz_reclaim_read(dzt, src_zone, chunk_block);
+			if (IS_ERR(ioreg)) {
+				ret = PTR_ERR(ioreg);
+				goto err;
+			}
+			if (!ioreg)
+				break;
+
+			chunk_block = ioreg->chunk_block + ioreg->nr_blocks;
+			ioregs[nr_ioregs] = ioreg;
+			nr_ioregs++;
+
+		}
+
+		/* Are we done ? */
+		if (!nr_ioregs)
+			break;
+
+		/* Write in destination zone */
+		ret = dmz_reclaim_write(dzt, dst_zone, ioregs, nr_ioregs);
+		if (ret != 0)
+			goto err;
+
+	}
+
+	return 0;
+
+err:
+	for (i = 0; i < nr_ioregs; i++) {
+		ioreg = ioregs[i];
+		if (ioreg) {
+			wait_for_completion_io(&ioreg->wait);
+			dmz_reclaim_free_ioreg(ioreg);
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * Allocate a sequential zone.
+ */
+static struct dm_zone *dmz_reclaim_alloc_seq_zone(struct dm_zoned_target *dzt)
+{
+	struct dm_zone *zone;
+	int ret;
+
+	dmz_lock_map(dzt);
+	zone = dmz_alloc_zone(dzt, DMZ_ALLOC_RECLAIM);
+	dmz_unlock_map(dzt);
+
+	if (!zone)
+		return NULL;
+
+	ret = dmz_reset_zone(dzt, zone);
+	if (ret != 0) {
+		dmz_lock_map(dzt);
+		dmz_free_zone(dzt, zone);
+		dmz_unlock_map(dzt);
+		return NULL;
+	}
+
+	return zone;
+}
+
+/*
+ * Clear a zone reclaim flag.
+ */
+static inline void dmz_reclaim_put_zone(struct dm_zoned_target *dzt,
+					struct dm_zone *zone)
+{
+	WARN_ON(dmz_is_active(zone));
+	WARN_ON(!dmz_in_reclaim(zone));
+
+	clear_bit_unlock(DMZ_RECLAIM, &zone->flags);
+	smp_mb__after_atomic();
+	wake_up_bit(&zone->flags, DMZ_RECLAIM);
+}
+
+/*
+ * Move valid blocks of dzone buffer zone into dzone
+ * and free the buffer zone.
+ */
+static int dmz_reclaim_buf(struct dm_zoned_target *dzt,
+			   struct dm_zone *dzone)
+{
+	struct dm_zone *bzone = dzone->bzone;
+	int ret;
+
+	dmz_dev_debug(dzt,
+		"Chunk %u, move buf zone %u (weight %u) "
+		"to data zone %u (weight %u)\n",
+		dzone->chunk,
+		dmz_id(dzt, bzone),
+		dmz_weight(bzone),
+		dmz_id(dzt, dzone),
+		dmz_weight(dzone));
+
+	/* Flush data zone into the buffer zone */
+	ret = dmz_reclaim_copy_zone(dzt, bzone, dzone);
+	if (ret < 0)
+		return ret;
+
+	/* Free the buffer zone */
+	dmz_invalidate_zone(dzt, bzone);
+	dmz_lock_map(dzt);
+	dmz_unmap_zone(dzt, bzone);
+	dmz_reclaim_put_zone(dzt, dzone);
+	dmz_free_zone(dzt, bzone);
+	dmz_unlock_map(dzt);
+
+	return 0;
+}
+
+/*
+ * Move valid blocks of dzone into its buffer zone and free dzone.
+ */
+static int dmz_reclaim_seq_data(struct dm_zoned_target *dzt,
+				struct dm_zone *dzone)
+{
+	unsigned int chunk = dzone->chunk;
+	struct dm_zone *bzone = dzone->bzone;
+	int ret = 0;
+
+	dmz_dev_debug(dzt,
+		"Chunk %u, move data zone %u (weight %u) "
+		"to buf zone %u (weight %u)\n",
+		chunk,
+		dmz_id(dzt, dzone),
+		dmz_weight(dzone),
+		dmz_id(dzt, bzone),
+		dmz_weight(bzone));
+
+	/* Flush data zone into the buffer zone */
+	ret = dmz_reclaim_copy_zone(dzt, dzone, bzone);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Free the data zone and remap the chunk to
+	 * the buffer zone.
+	 */
+	dmz_invalidate_zone(dzt, dzone);
+	dmz_lock_map(dzt);
+	dmz_unmap_zone(dzt, bzone);
+	dmz_unmap_zone(dzt, dzone);
+	dmz_reclaim_put_zone(dzt, dzone);
+	dmz_free_zone(dzt, dzone);
+	dmz_map_zone(dzt, bzone, chunk);
+	dmz_unlock_map(dzt);
+
+	return 0;
+}
+
+/*
+ * Move valid blocks of the random data zone dzone into a free sequential data
+ * zone. Once blocks are moved, remap the zone chunk to sequential zone.
+ */
+static int dmz_reclaim_rnd_data(struct dm_zoned_target *dzt,
+				struct dm_zone *dzone)
+{
+	unsigned int chunk = dzone->chunk;
+	struct dm_zone *szone = NULL;
+	int ret;
+
+	if (!dmz_weight(dzone))
+		/* Empty zone: just free it */
+		goto out;
+
+	/* Get a free sequential zone */
+	szone = dmz_reclaim_alloc_seq_zone(dzt);
+	if (!szone)
+		return -ENOSPC;
+
+	dmz_dev_debug(dzt,
+		"Chunk %u, move rnd zone %u (weight %u) to seq zone %u\n",
+		chunk,
+		dmz_id(dzt, dzone),
+		dmz_weight(dzone),
+		dmz_id(dzt, szone));
+
+	/* Flush the random data zone into the sequential zone */
+	ret = dmz_reclaim_copy_zone(dzt, dzone, szone);
+	if (ret) {
+		/* Invalidate the sequential zone and free it */
+		dmz_invalidate_zone(dzt, szone);
+		dmz_lock_map(dzt);
+		dmz_free_zone(dzt, szone);
+		dmz_unlock_map(dzt);
+		return ret;
+	}
+
+	/* Invalidate all blocks in the data zone */
+	dmz_invalidate_zone(dzt, dzone);
+
+out:
+	/* Free the data zone and remap the chunk */
+	dmz_lock_map(dzt);
+	dmz_unmap_zone(dzt, dzone);
+	dmz_reclaim_put_zone(dzt, dzone);
+	dmz_free_zone(dzt, dzone);
+	if (szone)
+		dmz_map_zone(dzt, szone, chunk);
+	dmz_unlock_map(dzt);
+
+	return 0;
+}
+
+/*
+ * Lock a zone for reclaim. Returns 0 if the zone cannot be locked or if it is
+ * already locked and 1 otherwise.
+ */
+static inline int dmz_reclaim_lock_zone(struct dm_zoned_target *dzt,
+					struct dm_zone *zone)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&dzt->zwork_lock, flags);
+
+	/* Active zones cannot be reclaimed */
+	if (!dmz_is_active(zone))
+		ret = !test_and_set_bit(DMZ_RECLAIM, &zone->flags);
+
+	spin_unlock_irqrestore(&dzt->zwork_lock, flags);
+
+	return ret;
+}
+
+/*
+ * Select a random zone for reclaim.
+ */
+static struct dm_zone *dmz_reclaim_get_rnd_zone(struct dm_zoned_target *dzt)
+{
+	struct dm_zone *dzone = NULL;
+	struct dm_zone *zone;
+
+	if (list_empty(&dzt->dz_map_rnd_list))
+		return NULL;
+
+	list_for_each_entry(zone, &dzt->dz_map_rnd_list, link) {
+		if (dmz_is_buf(zone))
+			dzone = zone->bzone;
+		else
+			dzone = zone;
+		if (dmz_reclaim_lock_zone(dzt, dzone))
+			return dzone;
+	}
+
+	return NULL;
+}
+
+/*
+ * Select a buffered sequential zone for reclaim.
+ */
+static struct dm_zone *dmz_reclaim_get_seq_zone(struct dm_zoned_target *dzt)
+{
+	struct dm_zone *zone;
+
+	if (list_empty(&dzt->dz_map_seq_list))
+		return NULL;
+
+	list_for_each_entry(zone, &dzt->dz_map_seq_list, link) {
+		if (!zone->bzone)
+			continue;
+		if (dmz_reclaim_lock_zone(dzt, zone))
+			return zone;
+	}
+
+	return NULL;
+}
+
+/*
+ * Select a zone for reclaim.
+ */
+static struct dm_zone *dmz_reclaim_get_zone(struct dm_zoned_target *dzt)
+{
+	struct dm_zone *zone = NULL;
+
+	/*
+	 * Search for a zone candidate to reclaim: 2 cases are possible.
+	 * (1) There is no free sequential zones. Then a random data zone
+	 *     cannot be reclaimed. So choose a sequential zone to reclaim so
+	 *     that afterward a random zone can be reclaimed.
+	 * (2) At least one free sequential zone is available, then choose
+	 *     the oldest random zone (data or buffer) that can be locked.
+	 */
+	dmz_lock_map(dzt);
+	if (list_empty(&dzt->reclaim_seq_zones_list))
+		zone = dmz_reclaim_get_seq_zone(dzt);
+	else
+		zone = dmz_reclaim_get_rnd_zone(dzt);
+	dmz_unlock_map(dzt);
+
+	return zone;
+}
+
+/*
+ * Find a reclaim candidate zone and reclaim it.
+ */
+static int dmz_reclaim(struct dm_zoned_target *dzt)
+{
+	struct dm_zone *dzone;
+	struct dm_zone *rzone;
+	unsigned long start;
+	int ret;
+
+	dzone = dmz_reclaim_get_zone(dzt);
+	if (!dzone)
+		return 0;
+
+	/*
+	 * Do not run concurrently with flush so that the entire reclaim
+	 * process is treated as a "transaction" similarly to BIO processing.
+	 */
+	down_read(&dzt->mblk_sem);
+
+	start = jiffies;
+
+	if (dmz_is_rnd(dzone)) {
+
+		/*
+		 * Reclaim the random data zone by moving its
+		 * valid data blocks to a free sequential zone.
+		 */
+		ret = dmz_reclaim_rnd_data(dzt, dzone);
+		rzone = dzone;
+
+	} else {
+
+		struct dm_zone *bzone = dzone->bzone;
+		sector_t chunk_block = 0;
+
+		ret = dmz_first_valid_block(dzt, bzone, &chunk_block);
+		if (ret < 0)
+			goto out;
+
+		if (chunk_block >= dzone->wp_block) {
+			/*
+			 * Valid blocks in the buffer zone are after
+			 * the data zone write pointer: copy them there.
+			 */
+			ret = dmz_reclaim_buf(dzt, dzone);
+			rzone = bzone;
+		} else {
+			/*
+			 * Reclaim the data zone by merging it into the
+			 * buffer zone so that the buffer zone itself can
+			 * be later reclaimed.
+			 */
+			ret = dmz_reclaim_seq_data(dzt, dzone);
+			rzone = dzone;
+		}
+
+	}
+
+out:
+	up_read(&dzt->mblk_sem);
+
+	if (ret) {
+		dmz_reclaim_put_zone(dzt, dzone);
+		ret = 0;
+	} else {
+		dmz_dev_debug(dzt,
+			      "Reclaimed zoned %u in %u ms\n",
+			      dmz_id(dzt, rzone),
+			      jiffies_to_msecs(jiffies - start));
+		ret = 1;
+	}
+
+	dmz_trigger_flush(dzt);
+
+	return ret;
+}
+
+/**
+ * Zone reclaim work.
+ */
+void dmz_reclaim_work(struct work_struct *work)
+{
+	struct dm_zoned_target *dzt =
+		container_of(work, struct dm_zoned_target, reclaim_work.work);
+	unsigned long delay = DMZ_RECLAIM_PERIOD;
+	int reclaimed = 0;
+
+	dmz_dev_debug(dzt,
+		      "%s, %u BIOs, %u %% free rzones, %d active zones\n",
+		      (dmz_idle(dzt) ? "idle" : "busy"),
+		      atomic_read(&dzt->bio_count),
+		      atomic_read(&dzt->dz_unmap_nr_rnd) * 100 /
+		      dzt->dz_nr_rnd,
+		      atomic_read(&dzt->nr_active_zones));
+
+	if (dmz_should_reclaim(dzt))
+		reclaimed = dmz_reclaim(dzt);
+
+	if (reclaimed ||
+	    (dmz_should_reclaim(dzt)
+	     && atomic_read(&dzt->nr_reclaim_seq_zones)))
+		/* Some progress and more to expect: run again right away */
+		delay = 0;
+
+	dmz_schedule_reclaim(dzt, delay);
+}
+
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
new file mode 100644
index 0000000..03be1fb
--- /dev/null
+++ b/drivers/md/dm-zoned.h
@@ -0,0 +1,570 @@
+/*
+ * (C) Copyright 2016 Western Digital.
+ *
+ * This software is distributed under the terms of the GNU Lesser General
+ * Public License version 2, or any later version, "as is," without technical
+ * support, and WITHOUT ANY WARRANTY, without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Author: Damien Le Moal <damien.lemoal@wdc.com>
+ */
+#include <linux/types.h>
+#include <linux/blkdev.h>
+#include <linux/device-mapper.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
+#include <linux/rwsem.h>
+#include <linux/rbtree.h>
+#include <linux/kref.h>
+
+#ifndef DM_ZONED_H
+#define DM_ZONED_H
+
+/*
+ * Module version.
+ */
+#define DMZ_VER_MAJ	0
+#define DMZ_VER_MIN	1
+
+/*
+ * Metadata version.
+ */
+#define DMZ_META_VER	1
+
+/*
+ * On-disk super block magic.
+ */
+#define DMZ_MAGIC	((((unsigned int)('D')) << 24) | \
+			 (((unsigned int)('Z')) << 16) | \
+			 (((unsigned int)('B')) <<  8) | \
+			 ((unsigned int)('D')))
+
+/*
+ * On disk super block.
+ * This uses a full 4KB block. This block is followed on disk
+ * by the chunk mapping table to zones and the bitmap blocks
+ * indicating block validity.
+ * The overall resulting metadat format is:
+ *    (1) Super block (1 block)
+ *    (2) Chunk mapping table (nr_map_blocks)
+ *    (3) Bitmap blocks (nr_bitmap_blocks)
+ * with all blocks stored in consecutive random zones starting
+ * from the first random zone found on disk.
+ */
+struct dm_zoned_super {
+
+	/* Magic number */
+	__le32		magic;			/*   4 */
+
+	/* Metadata version number */
+	__le32		version;		/*   8 */
+
+	/* Generation number */
+	__le64		gen;			/*  16 */
+
+	/* This block number */
+	__le64		sb_block;		/*  24 */
+
+	/* The number of metadata blocks, including this super block */
+	__le64		nr_meta_blocks;		/*  32 */
+
+	/* The number of sequential zones reserved for reclaim */
+	__le32		nr_reserved_seq;	/*  36 */
+
+	/* The number of entries in the mapping table */
+	__le32		nr_chunks;		/*  40 */
+
+	/* The number of blocks used for the chunk mapping table */
+	__le32		nr_map_blocks;		/*  44 */
+
+	/* The number of blocks used for the block bitmaps */
+	__le32		nr_bitmap_blocks;	/*  48 */
+
+	/* Checksum */
+	__le32		crc;			/*  52 */
+
+	/* Padding to full 512B sector */
+	u8		reserved[464];		/* 512 */
+
+} __packed;
+
+/*
+ * Chunk mapping entry: entries are indexed by chunk number
+ * and give the zone ID (dzone_id) mapping the chunk. This zone
+ * may be sequential or random. If it is a sequential zone,
+ * a second zone (bzone_id) used as a write buffer may also be
+ * specified. This second zone will always be a random zone.
+ */
+struct dm_zoned_map {
+	__le32			dzone_id;
+	__le32			bzone_id;
+};
+
+/*
+ * dm-zoned creates 4KB block size devices, always.
+ */
+#define DMZ_BLOCK_SHIFT		12
+#define DMZ_BLOCK_SIZE		(1 << DMZ_BLOCK_SHIFT)
+#define DMZ_BLOCK_MASK		(DMZ_BLOCK_SIZE - 1)
+
+#define DMZ_BLOCK_SHIFT_BITS	(DMZ_BLOCK_SHIFT + 3)
+#define DMZ_BLOCK_SIZE_BITS	(1 << DMZ_BLOCK_SHIFT_BITS)
+#define DMZ_BLOCK_MASK_BITS	(DMZ_BLOCK_SIZE_BITS - 1)
+
+#define DMZ_BLOCK_SECTORS_SHIFT	(DMZ_BLOCK_SHIFT - SECTOR_SHIFT)
+#define DMZ_BLOCK_SECTORS	(DMZ_BLOCK_SIZE >> SECTOR_SHIFT)
+#define DMZ_BLOCK_SECTORS_MASK	(DMZ_BLOCK_SECTORS - 1)
+
+/*
+ * Chunk mapping table metadata: 512 8-bytes entries per 4KB block.
+ */
+#define DMZ_MAP_ENTRIES		(DMZ_BLOCK_SIZE \
+				 / sizeof(struct dm_zoned_map))
+#define DMZ_MAP_ENTRIES_SHIFT	(ilog2(DMZ_MAP_ENTRIES))
+#define DMZ_MAP_ENTRIES_MASK	(DMZ_MAP_ENTRIES - 1)
+#define DMZ_MAP_UNMAPPED	UINT_MAX
+
+/*
+ * Block <-> sector conversion.
+ */
+#define dmz_blk2sect(b)		((b) << DMZ_BLOCK_SECTORS_SHIFT)
+#define dmz_sect2blk(s)		((s) >> DMZ_BLOCK_SECTORS_SHIFT)
+
+#define DMZ_MIN_BIOS		4096
+
+#define DMZ_REPORT_NR_ZONES	4096
+
+struct dm_zone_work;
+
+/*
+ * Zone flags.
+ */
+enum {
+
+	/* Zone actual type */
+	DMZ_CONV = 0,
+	DMZ_SEQ_REQ,
+	DMZ_SEQ_PREF,
+
+	/* Zone critical condition */
+	DMZ_OFFLINE,
+	DMZ_READ_ONLY,
+
+	/* Zone use */
+	DMZ_META,
+	DMZ_DATA,
+	DMZ_BUF,
+	DMZ_RND,
+	DMZ_SEQ,
+
+	/* Zone internal state */
+	DMZ_RECLAIM,
+
+};
+
+/*
+ * Zone descriptor.
+ */
+struct dm_zone {
+
+	struct rb_node		node;
+	struct list_head	link;
+
+	unsigned long		flags;
+
+	sector_t		sector;
+	unsigned int		wp_block;
+	unsigned int		weight;
+
+	/* The chunk number that the zone maps */
+	unsigned int		chunk;
+
+	/* The work processing this zone BIOs */
+	struct dm_zone_work	*work;
+
+	/*
+	 * For a sequential data zone, pointer to the random
+	 * zone used as a buffer for processing unaligned write
+	 * requests. For a buffer zone, this points back to the
+	 * data zone.
+	 */
+	struct dm_zone		*bzone;
+
+};
+
+extern struct kmem_cache *dmz_zone_cache;
+
+#define dmz_id(dzt, z)		((unsigned int)((z)->sector >> \
+						(dzt)->zone_nr_sectors_shift))
+#define dmz_is_conv(z)		test_bit(DMZ_CONV, &(z)->flags)
+#define dmz_is_seqreq(z)	test_bit(DMZ_SEQ_REQ, &(z)->flags)
+#define dmz_is_seqpref(z)	test_bit(DMZ_SEQ_PREF, &(z)->flags)
+#define dmz_is_seq(z)		test_bit(DMZ_SEQ, &(z)->flags)
+#define dmz_is_rnd(z)		test_bit(DMZ_RND, &(z)->flags)
+#define dmz_is_empty(z)		((z)->wp_block == 0)
+#define dmz_is_offline(z)	test_bit(DMZ_OFFLINE, &(z)->flags)
+#define dmz_is_readonly(z)	test_bit(DMZ_READ_ONLY, &(z)->flags)
+#define dmz_is_active(z)	((z)->work != NULL)
+#define dmz_in_reclaim(z)	test_bit(DMZ_RECLAIM, &(z)->flags)
+
+#define dmz_is_meta(z)		test_bit(DMZ_META, &(z)->flags)
+#define dmz_is_buf(z)		test_bit(DMZ_BUF, &(z)->flags)
+#define dmz_is_data(z)		test_bit(DMZ_DATA, &(z)->flags)
+
+#define dmz_weight(z)		((z)->weight)
+
+#define dmz_chunk_sector(dzt, s) ((s) & ((dzt)->zone_nr_sectors - 1))
+#define dmz_chunk_block(dzt, b)	((b) & ((dzt)->zone_nr_blocks - 1))
+
+#define dmz_bio_block(bio)	dmz_sect2blk((bio)->bi_iter.bi_sector)
+#define dmz_bio_blocks(bio)	dmz_sect2blk(bio_sectors(bio))
+#define dmz_bio_chunk(dzt, bio)	((bio)->bi_iter.bi_sector >> \
+				 (dzt)->zone_nr_sectors_shift)
+/*
+ * Meta data block descriptor (for cached blocks).
+ */
+struct dm_zoned_mblock {
+
+	struct rb_node		node;
+	struct list_head	link;
+	sector_t		no;
+	atomic_t		ref;
+	unsigned long		state;
+	struct page		*page;
+	void			*data;
+
+};
+
+struct dm_zoned_sb {
+	sector_t		block;
+	struct dm_zoned_mblock	*mblk;
+	struct dm_zoned_super	*sb;
+};
+
+/*
+ * Metadata block flags.
+ */
+enum {
+	DMZ_META_DIRTY,
+	DMZ_META_READING,
+	DMZ_META_WRITING,
+	DMZ_META_ERROR,
+};
+
+/*
+ * Target flags.
+ */
+enum {
+	DMZ_SUSPENDED,
+};
+
+/*
+ * Target descriptor.
+ */
+struct dm_zoned_target {
+
+	struct dm_dev		*ddev;
+
+	/* Target zoned device information */
+	char			zbd_name[BDEVNAME_SIZE];
+	struct block_device	*zbd;
+	sector_t		zbd_capacity;
+	struct request_queue	*zbdq;
+	unsigned long		flags;
+
+	unsigned int		nr_zones;
+	unsigned int		nr_useable_zones;
+	unsigned int		nr_meta_blocks;
+	unsigned int		nr_meta_zones;
+	unsigned int		nr_data_zones;
+	unsigned int		nr_rnd_zones;
+	unsigned int		nr_reserved_seq;
+	unsigned int		nr_chunks;
+
+	sector_t		zone_nr_sectors;
+	unsigned int		zone_nr_sectors_shift;
+
+	sector_t		zone_nr_blocks;
+	sector_t		zone_nr_blocks_shift;
+
+	sector_t		zone_bitmap_size;
+	unsigned int		zone_nr_bitmap_blocks;
+
+	unsigned int		nr_bitmap_blocks;
+	unsigned int		nr_map_blocks;
+
+	/* Zone information tree */
+	struct rb_root		zones;
+
+	/* For metadata handling */
+	struct dm_zone		*sb_zone;
+	struct dm_zoned_sb	sb[2];
+	unsigned int		mblk_primary;
+	u64			sb_gen;
+	unsigned int		max_nr_mblks;
+	atomic_t		nr_mblks;
+	struct rw_semaphore	mblk_sem;
+	spinlock_t		mblk_lock;
+	struct rb_root		mblk_rbtree;
+	struct list_head	mblk_lru_list;
+	struct list_head	mblk_dirty_list;
+
+	/* Zone mapping management lock */
+	struct mutex		map_lock;
+
+	/* Data zones */
+	struct dm_zoned_mblock	**dz_map_mblk;
+
+	unsigned int		dz_nr_rnd;
+	atomic_t		dz_unmap_nr_rnd;
+	struct list_head	dz_unmap_rnd_list;
+	struct list_head	dz_map_rnd_list;
+
+	unsigned int		dz_nr_seq;
+	atomic_t		dz_unmap_nr_seq;
+	struct list_head	dz_unmap_seq_list;
+	struct list_head	dz_map_seq_list;
+
+	wait_queue_head_t	dz_free_wq;
+
+	/* For zone BIOs */
+	struct bio_set		*bio_set;
+	atomic_t		nr_active_zones;
+	atomic_t		bio_count;
+	spinlock_t		zwork_lock;
+	struct workqueue_struct *zone_wq;
+	unsigned long		last_bio_time;
+
+	/* For flush */
+	spinlock_t		flush_lock;
+	struct bio_list		flush_list;
+	struct delayed_work	flush_work;
+	struct workqueue_struct *flush_wq;
+
+	/* For reclaim */
+	unsigned int		reclaim_idle_low;
+	unsigned int		reclaim_low;
+	struct delayed_work	reclaim_work;
+	struct workqueue_struct *reclaim_wq;
+	atomic_t		nr_reclaim_seq_zones;
+	struct list_head	reclaim_seq_zones_list;
+
+};
+
+/*
+ * Zone BIO work descriptor.
+ */
+struct dm_zone_work {
+	struct work_struct	work;
+	struct kref		kref;
+	struct dm_zoned_target	*target;
+	struct dm_zone		*zone;
+	struct bio_list		bio_list;
+};
+
+#define dmz_lock_map(dzt)	mutex_lock(&(dzt)->map_lock)
+#define dmz_unlock_map(dzt)	mutex_unlock(&(dzt)->map_lock)
+
+/*
+ * Flush period (seconds).
+ */
+#define DMZ_FLUSH_PERIOD	(10 * HZ)
+
+/*
+ * Trigger flush.
+ */
+static inline void dmz_trigger_flush(struct dm_zoned_target *dzt)
+{
+	mod_delayed_work(dzt->flush_wq, &dzt->flush_work, 0);
+}
+
+/*
+ * Number of seconds without BIO to consider
+ * the target device idle.
+ */
+#define DMZ_IDLE_SECS		1UL
+
+/*
+ * Zone reclaim check period.
+ */
+#define DMZ_RECLAIM_PERIOD_SECS	DMZ_IDLE_SECS
+#define DMZ_RECLAIM_PERIOD	(DMZ_RECLAIM_PERIOD_SECS * HZ)
+
+/*
+ * Low percentage of unmapped random zones that forces
+ * reclaim to start.
+ */
+#define DMZ_RECLAIM_LOW		50
+#define DMZ_RECLAIM_MIN		10
+#define DMZ_RECLAIM_MAX		90
+
+/*
+ * Low percentage of unmapped randm zones that forces
+ * reclaim to start when the target is idle. The minimum
+ * allowed is set by reclaim_low.
+ */
+#define DMZ_RECLAIM_IDLE_LOW	75
+#define DMZ_RECLAIM_IDLE_MAX	90
+
+/*
+ * Block I/O region for reclaim.
+ */
+struct dm_zoned_ioreg {
+	sector_t		chunk_block;
+	unsigned int		nr_blocks;
+	unsigned int		nr_bvecs;
+	struct bio_vec		*bvec;
+	struct bio		bio;
+	struct completion	wait;
+	int			err;
+};
+
+/*
+ * Maximum number of regions to read in a zones
+ * during reclaim in one run. If more regions need
+ * to be read, reclaim will loop.
+ */
+#define DMZ_RECLAIM_MAX_IOREGS	16
+
+/*
+ * Test if the target device is idle.
+ */
+static inline int dmz_idle(struct dm_zoned_target *dzt)
+{
+	return atomic_read(&(dzt)->bio_count) == 0 &&
+		time_is_before_jiffies(dzt->last_bio_time
+				       + DMZ_IDLE_SECS * HZ);
+}
+
+/*
+ * Test if triggerring reclaim is necessary.
+ */
+static inline bool dmz_should_reclaim(struct dm_zoned_target *dzt)
+{
+	unsigned int ucp;
+
+	/* Percentage of unmappped (free) random zones */
+	ucp = (atomic_read(&dzt->dz_unmap_nr_rnd) * 100)
+		/ dzt->dz_nr_rnd;
+
+	if ((dmz_idle(dzt) && ucp <= dzt->reclaim_idle_low) ||
+	    (!dmz_idle(dzt) && ucp <= dzt->reclaim_low))
+		return true;
+
+	return false;
+}
+
+/*
+ * Schedule reclaim (delay in jiffies).
+ */
+static inline void dmz_schedule_reclaim(struct dm_zoned_target *dzt,
+					unsigned long delay)
+{
+	mod_delayed_work(dzt->reclaim_wq, &dzt->reclaim_work, delay);
+}
+
+/*
+ * Trigger reclaim.
+ */
+static inline void dmz_trigger_reclaim(struct dm_zoned_target *dzt)
+{
+	dmz_schedule_reclaim(dzt, 0);
+}
+
+extern void dmz_reclaim_work(struct work_struct *work);
+
+/*
+ * Target config passed as dmsetup arguments.
+ */
+struct dm_zoned_target_config {
+	char			*dev_path;
+	unsigned long		flags;
+	unsigned long		reclaim_idle_low;
+	unsigned long		reclaim_low;
+};
+
+/*
+ * Zone BIO context.
+ */
+struct dm_zone_bioctx {
+	struct dm_zoned_target	*target;
+	struct dm_zone_work	*zwork;
+	struct bio		*bio;
+	atomic_t		ref;
+	int			error;
+};
+
+#define dmz_info(format, args...)		\
+	pr_info("dm-zoned: " format,		\
+	## args)
+
+#define dmz_dev_info(target, format, args...)	\
+	pr_info("dm-zoned (%s): " format,	\
+	       (dzt)->zbd_name, ## args)
+
+#define dmz_dev_err(dzt, format, args...)	\
+	pr_err("dm-zoned (%s): " format,	\
+	       (dzt)->zbd_name, ## args)
+
+#define dmz_dev_warn(dzt, format, args...)	\
+	pr_warn("dm-zoned (%s): " format,	\
+		(dzt)->zbd_name, ## args)
+
+#define dmz_dev_debug(dzt, format, args...)	\
+	pr_debug("dm-zoned (%s): " format,	\
+		 (dzt)->zbd_name, ## args)
+
+int dmz_init_meta(struct dm_zoned_target *dzt,
+			 struct dm_zoned_target_config *conf);
+int dmz_resume_meta(struct dm_zoned_target *dzt);
+void dmz_cleanup_meta(struct dm_zoned_target *dzt);
+
+int dmz_reset_zone(struct dm_zoned_target *dzt,
+		   struct dm_zone *zone);
+
+int dmz_flush_mblocks(struct dm_zoned_target *dzt);
+
+#define DMZ_ALLOC_RND		0x01
+#define DMZ_ALLOC_RECLAIM	0x02
+
+struct dm_zone *dmz_alloc_zone(struct dm_zoned_target *dzt,
+			       unsigned long flags);
+void dmz_free_zone(struct dm_zoned_target *dzt,
+		   struct dm_zone *zone);
+
+void dmz_map_zone(struct dm_zoned_target *dzt,
+		  struct dm_zone *zone,
+			 unsigned int chunk);
+void dmz_unmap_zone(struct dm_zoned_target *dzt,
+		    struct dm_zone *zone);
+
+void dmz_validate_zone(struct dm_zoned_target *dzt,
+		       struct dm_zone *zone);
+
+struct dm_zone *dmz_get_chunk_mapping(struct dm_zoned_target *dzt,
+				      unsigned int chunk,
+				      int op);
+
+struct dm_zone *dmz_get_chunk_buffer(struct dm_zoned_target *dzt,
+				      struct dm_zone *dzone);
+
+int dmz_validate_blocks(struct dm_zoned_target *dzt, struct dm_zone *zone,
+			sector_t chunk_block, unsigned int nr_blocks);
+int dmz_invalidate_blocks(struct dm_zoned_target *dzt, struct dm_zone *zone,
+			  sector_t chunk_block, unsigned int nr_blocks);
+static inline int dmz_invalidate_zone(struct dm_zoned_target *dzt,
+				      struct dm_zone *zone)
+{
+	return dmz_invalidate_blocks(dzt, zone, 0, dzt->zone_nr_blocks);
+}
+
+int dmz_block_valid(struct dm_zoned_target *dzt, struct dm_zone *zone,
+		    sector_t chunk_block);
+
+int dmz_first_valid_block(struct dm_zoned_target *dzt, struct dm_zone *zone,
+			  sector_t *chunk_block);
+
+#endif /* DM_ZONED_H */
-- 
2.7.4

