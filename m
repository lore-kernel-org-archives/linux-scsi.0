Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC86C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 07:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiGFHEP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 03:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiGFHEJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 03:04:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD38B2636;
        Wed,  6 Jul 2022 00:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nZi1kfn57Y1hhMnabWrMJiw6rFdnP+pNl/S/lqre+18=; b=yszetCI9YDR431bQ9pVrdi9g42
        jv7vxw/M342QzcR9y43wzcynjwXPDSMUN8FulbhneqllmTCty32/KQd8MEE86cFFiHTpk1AjQtJqr
        7EJsxqxr/aiHNagLm61jzqk00jK692jjDQyQrz5MgM2cmTNQXd6z63Hj9HkvAwOEHn1co69BqXw7b
        G5643YudH0coaOP3aNEEGNROk6bMQ/Ijn3Jle50hCEZwQ0xQbiU3q+ZkJQgAhmZPREKGWY1Kh26Yc
        obkUKGmXdUuFwOrjPI4s9d+yvjb59d1Y1X8KOvxo4pTPIDX1euXMnvdfokdPkBj9wLqbCsHeveysG
        83wep9nQ==;
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8z4q-006usR-Sk; Wed, 06 Jul 2022 07:04:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 03/16] block: use bdev_is_zoned instead of open coding it
Date:   Wed,  6 Jul 2022 09:03:37 +0200
Message-Id: <20220706070350.1703384-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
References: <20220706070350.1703384-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use bdev_is_zoned in all places where a block_device is available instead
of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/bio.c           | 2 +-
 block/blk-core.c      | 6 +++---
 block/blk-mq.h        | 2 +-
 block/blk-zoned.c     | 9 ++++-----
 drivers/md/dm-table.c | 2 +-
 drivers/md/dm-zone.c  | 2 +-
 drivers/md/dm.c       | 2 +-
 7 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 933ea32109547..888ee81ea3034 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1033,7 +1033,7 @@ int bio_add_zone_append_page(struct bio *bio, struct page *page,
 	if (WARN_ON_ONCE(bio_op(bio) != REQ_OP_ZONE_APPEND))
 		return 0;
 
-	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
+	if (WARN_ON_ONCE(!bdev_is_zoned(bio->bi_bdev)))
 		return 0;
 
 	return bio_add_hw_page(q, bio, page, len, offset,
diff --git a/block/blk-core.c b/block/blk-core.c
index 5ad7bd93077c8..6bcca0b686de4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -569,7 +569,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 	int nr_sectors = bio_sectors(bio);
 
 	/* Only applicable to zoned block devices */
-	if (!blk_queue_is_zoned(q))
+	if (!bdev_is_zoned(bio->bi_bdev))
 		return BLK_STS_NOTSUPP;
 
 	/* The bio sector must point to the start of a sequential zone */
@@ -775,11 +775,11 @@ void submit_bio_noacct(struct bio *bio)
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
 	case REQ_OP_ZONE_FINISH:
-		if (!blk_queue_is_zoned(q))
+		if (!bdev_is_zoned(bio->bi_bdev))
 			goto not_supported;
 		break;
 	case REQ_OP_ZONE_RESET_ALL:
-		if (!blk_queue_is_zoned(q) || !blk_queue_zone_resetall(q))
+		if (!bdev_is_zoned(bio->bi_bdev) || !blk_queue_zone_resetall(q))
 			goto not_supported;
 		break;
 	case REQ_OP_WRITE_ZEROES:
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 54e20edf0da30..31d75a83a562d 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -317,7 +317,7 @@ static inline struct blk_plug *blk_mq_plug(struct request_queue *q,
 	 * For regular block devices or read operations, use the context plug
 	 * which may be NULL if blk_start_plug() was not executed.
 	 */
-	if (!blk_queue_is_zoned(q) || !op_is_write(bio_op(bio)))
+	if (!bdev_is_zoned(bio->bi_bdev) || !op_is_write(bio_op(bio)))
 		return current->plug;
 
 	/* Zoned block device write operation case: do not plug the BIO */
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 38cd840d88387..90a5c9cc80ab3 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -149,8 +149,7 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 	struct gendisk *disk = bdev->bd_disk;
 	sector_t capacity = get_capacity(disk);
 
-	if (!blk_queue_is_zoned(bdev_get_queue(bdev)) ||
-	    WARN_ON_ONCE(!disk->fops->report_zones))
+	if (!bdev_is_zoned(bdev) || WARN_ON_ONCE(!disk->fops->report_zones))
 		return -EOPNOTSUPP;
 
 	if (!nr_zones || sector >= capacity)
@@ -268,7 +267,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 	struct bio *bio = NULL;
 	int ret = 0;
 
-	if (!blk_queue_is_zoned(q))
+	if (!bdev_is_zoned(bdev))
 		return -EOPNOTSUPP;
 
 	if (bdev_read_only(bdev))
@@ -350,7 +349,7 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
 	if (!q)
 		return -ENXIO;
 
-	if (!blk_queue_is_zoned(q))
+	if (!bdev_is_zoned(bdev))
 		return -ENOTTY;
 
 	if (copy_from_user(&rep, argp, sizeof(struct blk_zone_report)))
@@ -408,7 +407,7 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 	if (!q)
 		return -ENXIO;
 
-	if (!blk_queue_is_zoned(q))
+	if (!bdev_is_zoned(bdev))
 		return -ENOTTY;
 
 	if (!(mode & FMODE_WRITE))
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index bd539afbfe88f..b36b528e56cff 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1623,7 +1623,7 @@ static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 	unsigned int *zone_sectors = data;
 
-	if (!blk_queue_is_zoned(q))
+	if (!bdev_is_zoned(dev->bdev))
 		return 0;
 
 	return blk_queue_zone_sectors(q) != *zone_sectors;
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 3e7b1fe1580b9..ae616b87c91ae 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -270,7 +270,7 @@ static int device_not_zone_append_capable(struct dm_target *ti,
 					  struct dm_dev *dev, sector_t start,
 					  sector_t len, void *data)
 {
-	return !blk_queue_is_zoned(bdev_get_queue(dev->bdev));
+	return !bdev_is_zoned(dev->bdev);
 }
 
 static bool dm_table_supports_zone_append(struct dm_table *t)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8872f9c636889..33d3799bb66ec 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1033,7 +1033,7 @@ static void clone_endio(struct bio *bio)
 	}
 
 	if (static_branch_unlikely(&zoned_enabled) &&
-	    unlikely(blk_queue_is_zoned(bdev_get_queue(bio->bi_bdev))))
+	    unlikely(bdev_is_zoned(bio->bi_bdev)))
 		dm_zone_endio(io, bio);
 
 	if (endio) {
-- 
2.30.2

