Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B565DC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 07:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiGFHFD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 03:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbiGFHEj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 03:04:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066D5222BD;
        Wed,  6 Jul 2022 00:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4VSfcLnPjPfU7j//JLAYFJ37MiZvdmoWhgvI49ISqsc=; b=c4emuxCCMYrX/9sHS92r5OfQX3
        YEJjRFsVWLDs9i2qpUHlRr6yNZiLgtWjeczCsuYU/sLfGFvoYQo3jQWpUJj8ffobF9KctwyhwY0LB
        +s9VvLxsO7g7i5cDZK0Z+LFmCjvm2cYRcN1+LIN1Kx9jUCGrYVYf7XbyR2NxnTjqsWxirHB3zz78G
        Wya3s/j/zaD05sIRZBHO0v1F/32TbietbNJyKHqyP51niqsHLzN4amKbv9hsVMZg5UQoD5cmQsiQ8
        MqhG3JsppU5WyFfKCOIElVsoI3Zs06cS2156XP5ibj7Ye8Uz2tVc1WfF1vRDkq12ySmyOLhwb0MYX
        RpS+bUiQ==;
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8z5M-006vJc-JN; Wed, 06 Jul 2022 07:04:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 15/16] block: remove blk_queue_zone_sectors
Date:   Wed,  6 Jul 2022 09:03:49 +0200
Message-Id: <20220706070350.1703384-16-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
References: <20220706070350.1703384-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Always use bdev_zone_sectors instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/dm-table.c  |  4 +---
 drivers/md/dm-zone.c   | 10 ++++++----
 include/linux/blkdev.h | 11 +++--------
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index b36b528e56cff..df904b7e95ce3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1620,13 +1620,11 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
 static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
 					   sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
 	unsigned int *zone_sectors = data;
 
 	if (!bdev_is_zoned(dev->bdev))
 		return 0;
-
-	return blk_queue_zone_sectors(q) != *zone_sectors;
+	return bdev_zone_sectors(dev->bdev) != *zone_sectors;
 }
 
 /*
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 6d105abe12415..842c31019b513 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -334,7 +334,7 @@ static int dm_update_zone_wp_offset_cb(struct blk_zone *zone, unsigned int idx,
 static int dm_update_zone_wp_offset(struct mapped_device *md, unsigned int zno,
 				    unsigned int *wp_ofst)
 {
-	sector_t sector = zno * blk_queue_zone_sectors(md->queue);
+	sector_t sector = zno * bdev_zone_sectors(md->disk->part0);
 	unsigned int noio_flag;
 	struct dm_table *t;
 	int srcu_idx, ret;
@@ -373,7 +373,7 @@ struct orig_bio_details {
 static bool dm_zone_map_bio_begin(struct mapped_device *md,
 				  unsigned int zno, struct bio *clone)
 {
-	sector_t zsectors = blk_queue_zone_sectors(md->queue);
+	sector_t zsectors = bdev_zone_sectors(md->disk->part0);
 	unsigned int zwp_offset = READ_ONCE(md->zwp_offset[zno]);
 
 	/*
@@ -443,7 +443,7 @@ static blk_status_t dm_zone_map_bio_end(struct mapped_device *md, unsigned int z
 		return BLK_STS_OK;
 	case REQ_OP_ZONE_FINISH:
 		WRITE_ONCE(md->zwp_offset[zno],
-			   blk_queue_zone_sectors(md->queue));
+			   bdev_zone_sectors(md->disk->part0));
 		return BLK_STS_OK;
 	case REQ_OP_WRITE_ZEROES:
 	case REQ_OP_WRITE:
@@ -593,6 +593,7 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
 {
 	struct mapped_device *md = io->md;
 	struct request_queue *q = md->queue;
+	struct gendisk *disk = md->disk;
 	struct bio *orig_bio = io->orig_bio;
 	unsigned int zwp_offset;
 	unsigned int zno;
@@ -608,7 +609,8 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
 		 */
 		if (clone->bi_status == BLK_STS_OK &&
 		    bio_op(clone) == REQ_OP_ZONE_APPEND) {
-			sector_t mask = (sector_t)blk_queue_zone_sectors(q) - 1;
+			sector_t mask =
+				(sector_t)bdev_zone_sectors(disk->part0) - 1;
 
 			orig_bio->bi_iter.bi_sector +=
 				clone->bi_iter.bi_sector & mask;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index fa2757ef4a846..21b97f7115dcb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -667,11 +667,6 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
 	}
 }
 
-static inline sector_t blk_queue_zone_sectors(struct request_queue *q)
-{
-	return blk_queue_is_zoned(q) ? q->limits.chunk_sectors : 0;
-}
-
 #ifdef CONFIG_BLK_DEV_ZONED
 static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
 {
@@ -1310,9 +1305,9 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 
-	if (q)
-		return blk_queue_zone_sectors(q);
-	return 0;
+	if (!blk_queue_is_zoned(q))
+		return 0;
+	return q->limits.chunk_sectors;
 }
 
 static inline int queue_dma_alignment(const struct request_queue *q)
-- 
2.30.2

