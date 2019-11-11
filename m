Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C319C17442
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0753F206C3
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lM/D7aRD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfKKCjk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Nov 2019 21:39:40 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:52028 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbfKKCjk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Nov 2019 21:39:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573439980; x=1604975980;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=utVEkPZAchArYh5SgdJN1MSWMEStdCpU26QNS2ZuWjM=;
  b=lM/D7aRDkb2Gf48aBjcrOhVaEigypsmE/lL8qwOJ0Ba6i/QUduqJXKAQ
   6zYRD/kbllZkcot3IuohHKA3U4q64gn3Yx4nbBbh7yCnXh66OY8Lo31gN
   3rqxSVq7UGa7eyH7m2qEEj0EzwWfKHMMpHXJ3kw/hhphYJd707Fr2w6rh
   exU/v/OqbkOisgMHcz6FrvZIU9F48g57A1FWhZW1VFDgv+9tiwe78vVBx
   NxlMbJyP1lvOZ55Ahxls/icXkVoS9hk2XFs00pdEkxnA3BUHRHWczR/Pz
   GpLibPpAQ11tQGxwtJnj4sd6uHfJ5+H7WWcshNPvCdb7WFchSuGwV+qzb
   A==;
IronPort-SDR: u16xRvzWAvaofsT3A0JN0Q6lnAkUTE2037c3vH/W5gCFc6hqR0IKGB+3WmoJMAvaNr9iTw0ZjR
 om6bbg9rz4qovfFw2nb2Pwr5ioNa18BH+tSULm6kw8L2i/togrT3Cf7YHUovgdEviO43aghYR5
 34vqwf8T2i1FHNiNPS2ld75S79wiNj6lJxA5uuH/4CceXqnaMFoMBwZvD6ni6SvnBesj0Oh262
 k0pT1PXnBiSEOIckUkplIt8Ahz0Sh+HJ21i55rzj5f3W3186VmNeXwTg0bsrdFFbT/EdQyimMT
 QaU=
X-IronPort-AV: E=Sophos;i="5.68,291,1569254400"; 
   d="scan'208";a="127062970"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2019 10:39:39 +0800
IronPort-SDR: ljLiyE6q5riFRHjRTHK2rVI0KLW6ST5WnGlIxmtPkLCkBKuIeqKQBVsVji3KUqnY7DU1s1BWhV
 qZfyraWy2BHfVl6ty4S7FWwDEcNFcxO1kS7w8pSynkDN78WZ5z6vwuo1lw7F/eq0K9n374gBq1
 xtMoTIkPr1NADFxTyvSSE0d1ekEJaWSSyKkRbhUQUemyKwjxZHcQnrZBStpIOD1dblQhBir7p+
 HAyJcFH6jnIifxIkc3X9RiWb169CGoyuDpmLbQXwssC7sXVBxmb1lb2PH3QFJLE39FHsDrouGy
 8jd4bSlewa14KcX8CJ0Q1/qj
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2019 18:34:44 -0800
IronPort-SDR: pgSL4c208LsPbdHz9kRxJ+gjIMzeJC3XDYb0C7Na268ScNYQssVyNtAUsehnv07gO8dERFDYUj
 kFnXniFyP/q4BbmiSvMJ6xJLdFIip3NYYfFTOHCfJy2/iwhcXwKsD6CQ4XuFTqcMmhEZNxvltn
 2QC6rznjs1+XBx1QmAursOrsOchyCUvTzkLG4NiBIfKfdL/d5o1MI/IWjDXe74NsQTGgSNpDyX
 EyxE7Y5kbjwFIIkDVc7HCLcIvuTlhDP/P78YtSJeA0+u8FgeXyKza/XU+9aoOVpwuF3X4FBU1Z
 uPA=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 10 Nov 2019 18:39:39 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH v2 4/9] block: Remove partition support for zoned block devices
Date:   Mon, 11 Nov 2019 11:39:25 +0900
Message-Id: <20191111023930.638129-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191111023930.638129-1-damien.lemoal@wdc.com>
References: <20191111023930.638129-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No known partitioning tool supports zoned block devices, especially the
host managed flavor with strong sequential write constraints.
Furthermore, there are also no known user nor use cases for partitioned
zoned block devices.

This patch removes partition device creation for zoned block devices,
which allows simplifying the processing of zone commands for zoned
block devices. A warning is added if a partition table is found on the
device.

For report zones operations no zone sector information remapping is
necessary anymore, simplifying the code. Of note is that remapping of
zone reports for DM targets is still necessary as done by
dm_remap_zone_report().

Similarly, remaping of a zone reset bio is not necessary anymore.
Testing for the applicability of the zone reset all request also becomes
simpler and only needs to check that the number of sectors of the
requested zone range is equal to the disk capacity.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c          |  6 +---
 block/blk-zoned.c         | 62 ++++++--------------------------
 block/partition-generic.c | 74 +++++----------------------------------
 drivers/md/dm.c           |  3 --
 4 files changed, 21 insertions(+), 124 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3306a3c5bed6..df6b70476187 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -851,11 +851,7 @@ static inline int blk_partition_remap(struct bio *bio)
 	if (unlikely(bio_check_ro(bio, p)))
 		goto out;
 
-	/*
-	 * Zone management bios do not have a sector count but they do have
-	 * a start sector filled out and need to be remapped.
-	 */
-	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio))) {
+	if (bio_sectors(bio)) {
 		if (bio_check_eod(bio, part_nr_sects_read(p)))
 			goto out;
 		bio->bi_iter.bi_sector += p->start_sect;
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index ea4e086ba00e..ae665e490858 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -93,32 +93,10 @@ unsigned int blkdev_nr_zones(struct block_device *bdev)
 	if (!blk_queue_is_zoned(q))
 		return 0;
 
-	return __blkdev_nr_zones(q, bdev->bd_part->nr_sects);
+	return __blkdev_nr_zones(q, get_capacity(bdev->bd_disk));
 }
 EXPORT_SYMBOL_GPL(blkdev_nr_zones);
 
-/*
- * Check that a zone report belongs to this partition, and if yes, fix its start
- * sector and write pointer and return true. Return false otherwise.
- */
-static bool blkdev_report_zone(struct block_device *bdev, struct blk_zone *rep)
-{
-	sector_t offset = get_start_sect(bdev);
-
-	if (rep->start < offset)
-		return false;
-
-	rep->start -= offset;
-	if (rep->start + rep->len > bdev->bd_part->nr_sects)
-		return false;
-
-	if (rep->type == BLK_ZONE_TYPE_CONVENTIONAL)
-		rep->wp = rep->start + rep->len;
-	else
-		rep->wp -= offset;
-	return true;
-}
-
 /**
  * blkdev_report_zones - Get zones information
  * @bdev:	Target block device
@@ -140,8 +118,7 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 	struct gendisk *disk = bdev->bd_disk;
-	unsigned int i, nrz;
-	int ret;
+	sector_t capacity = get_capacity(disk);
 
 	if (!blk_queue_is_zoned(q))
 		return -EOPNOTSUPP;
@@ -154,27 +131,14 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 	if (WARN_ON_ONCE(!disk->fops->report_zones))
 		return -EOPNOTSUPP;
 
-	if (!*nr_zones || sector >= bdev->bd_part->nr_sects) {
+	if (!*nr_zones || sector >= capacity) {
 		*nr_zones = 0;
 		return 0;
 	}
 
-	nrz = min(*nr_zones,
-		  __blkdev_nr_zones(q, bdev->bd_part->nr_sects - sector));
-	ret = disk->fops->report_zones(disk, get_start_sect(bdev) + sector,
-				       zones, &nrz);
-	if (ret)
-		return ret;
+	*nr_zones = min(*nr_zones, __blkdev_nr_zones(q, capacity - sector));
 
-	for (i = 0; i < nrz; i++) {
-		if (!blkdev_report_zone(bdev, zones))
-			break;
-		zones++;
-	}
-
-	*nr_zones = i;
-
-	return 0;
+	return disk->fops->report_zones(disk, sector, zones, nr_zones);
 }
 EXPORT_SYMBOL_GPL(blkdev_report_zones);
 
@@ -185,15 +149,11 @@ static inline bool blkdev_allow_reset_all_zones(struct block_device *bdev,
 	if (!blk_queue_zone_resetall(bdev_get_queue(bdev)))
 		return false;
 
-	if (sector || nr_sectors != part_nr_sects_read(bdev->bd_part))
-		return false;
 	/*
-	 * REQ_OP_ZONE_RESET_ALL can be executed only if the block device is
-	 * the entire disk, that is, if the blocks device start offset is 0 and
-	 * its capacity is the same as the entire disk.
+	 * REQ_OP_ZONE_RESET_ALL can be executed only if the number of sectors
+	 * of the applicable zone range is the entire disk.
 	 */
-	return get_start_sect(bdev) == 0 &&
-	       part_nr_sects_read(bdev->bd_part) == get_capacity(bdev->bd_disk);
+	return !sector && nr_sectors == get_capacity(bdev->bd_disk);
 }
 
 /**
@@ -218,6 +178,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 	sector_t zone_sectors = blk_queue_zone_sectors(q);
+	sector_t capacity = get_capacity(bdev->bd_disk);
 	sector_t end_sector = sector + nr_sectors;
 	struct bio *bio = NULL;
 	int ret;
@@ -231,7 +192,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 	if (!op_is_zone_mgmt(op))
 		return -EOPNOTSUPP;
 
-	if (!nr_sectors || end_sector > bdev->bd_part->nr_sects)
+	if (!nr_sectors || end_sector > capacity)
 		/* Out of range */
 		return -EINVAL;
 
@@ -239,8 +200,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 	if (sector & (zone_sectors - 1))
 		return -EINVAL;
 
-	if ((nr_sectors & (zone_sectors - 1)) &&
-	    end_sector != bdev->bd_part->nr_sects)
+	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
 		return -EINVAL;
 
 	while (sector < end_sector) {
diff --git a/block/partition-generic.c b/block/partition-generic.c
index aee643ce13d1..31bff3fb28af 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -459,56 +459,6 @@ static int drop_partitions(struct gendisk *disk, struct block_device *bdev)
 	return 0;
 }
 
-static bool part_zone_aligned(struct gendisk *disk,
-			      struct block_device *bdev,
-			      sector_t from, sector_t size)
-{
-	unsigned int zone_sectors = bdev_zone_sectors(bdev);
-
-	/*
-	 * If this function is called, then the disk is a zoned block device
-	 * (host-aware or host-managed). This can be detected even if the
-	 * zoned block device support is disabled (CONFIG_BLK_DEV_ZONED not
-	 * set). In this case, however, only host-aware devices will be seen
-	 * as a block device is not created for host-managed devices. Without
-	 * zoned block device support, host-aware drives can still be used as
-	 * regular block devices (no zone operation) and their zone size will
-	 * be reported as 0. Allow this case.
-	 */
-	if (!zone_sectors)
-		return true;
-
-	/*
-	 * Check partition start and size alignement. If the drive has a
-	 * smaller last runt zone, ignore it and allow the partition to
-	 * use it. Check the zone size too: it should be a power of 2 number
-	 * of sectors.
-	 */
-	if (WARN_ON_ONCE(!is_power_of_2(zone_sectors))) {
-		u32 rem;
-
-		div_u64_rem(from, zone_sectors, &rem);
-		if (rem)
-			return false;
-		if ((from + size) < get_capacity(disk)) {
-			div_u64_rem(size, zone_sectors, &rem);
-			if (rem)
-				return false;
-		}
-
-	} else {
-
-		if (from & (zone_sectors - 1))
-			return false;
-		if ((from + size) < get_capacity(disk) &&
-		    (size & (zone_sectors - 1)))
-			return false;
-
-	}
-
-	return true;
-}
-
 int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 {
 	struct parsed_partitions *state = NULL;
@@ -544,6 +494,14 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 		}
 		return -EIO;
 	}
+
+	/* Partitions are not supported on zoned block devices */
+	if (bdev_is_zoned(bdev)) {
+		pr_warn("%s: ignoring partition table on zoned block device\n",
+			disk->disk_name);
+		goto out;
+	}
+
 	/*
 	 * If any partition code tried to read beyond EOD, try
 	 * unlocking native capacity even if partition table is
@@ -607,21 +565,6 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 			}
 		}
 
-		/*
-		 * On a zoned block device, partitions should be aligned on the
-		 * device zone size (i.e. zone boundary crossing not allowed).
-		 * Otherwise, resetting the write pointer of the last zone of
-		 * one partition may impact the following partition.
-		 */
-		if (bdev_is_zoned(bdev) &&
-		    !part_zone_aligned(disk, bdev, from, size)) {
-			printk(KERN_WARNING
-			       "%s: p%d start %llu+%llu is not zone aligned\n",
-			       disk->disk_name, p, (unsigned long long) from,
-			       (unsigned long long) size);
-			continue;
-		}
-
 		part = add_partition(disk, p, from, size,
 				     state->parts[p].flags,
 				     &state->parts[p].info);
@@ -635,6 +578,7 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 			md_autodetect_dev(part_to_dev(part)->devt);
 #endif
 	}
+out:
 	free_partitions(state);
 	return 0;
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 89189c29438f..76f4cfdd6b41 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1211,9 +1211,6 @@ EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
  * The zone descriptors obtained with a zone report indicate
  * zone positions within the underlying device of the target. The zone
  * descriptors must be remapped to match their position within the dm device.
- * The caller target should obtain the zones information using
- * blkdev_report_zones() to ensure that remapping for partition offset is
- * already handled.
  */
 void dm_remap_zone_report(struct dm_target *ti, sector_t start,
 			  struct blk_zone *zones, unsigned int *nr_zones)
-- 
2.23.0

