Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBCBC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 07:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiGFHEk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 03:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiGFHE1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 03:04:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0667A22288;
        Wed,  6 Jul 2022 00:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=IMHOIAnKHAGrrTSPKy1afvOAZW2c4mK+sFcOyUZMZF4=; b=AiQBbMmgkx8eBZ6WY/htNrRzgC
        078iLVJjmcYY15WKLv62ZbdcvDXs8y3BBZi6A+eY5LqyDTEpE52yZmf6aREhG0nv9CRy6w9uR7wbk
        7NKMub6Po7BflPUDP/iEnoUQj1SwDzL9+B9o4H5y17t9s17E/Hr8gDrZzLP3mF0wWqdEoqUvuFaz8
        5AB2w261A3VHxdgL7dtuGzSyJtoLSrZjM2v/pv1cBenC1yjGhnn4EC+UqVomLfZX7sGUsijCZG1/T
        q75LNs2hAcMlT9XTZ1bhH0BMPD+owyu0upS30kTlqK208fMWkzryEI0K009cQh1zvkONFglOzKjBq
        FnNH9Jvg==;
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8z59-006v79-BF; Wed, 06 Jul 2022 07:04:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 10/16] block: pass a gendisk to blk_queue_max_open_zones and blk_queue_max_active_zones
Date:   Wed,  6 Jul 2022 09:03:44 +0200
Message-Id: <20220706070350.1703384-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
References: <20220706070350.1703384-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch to a gendisk based API in preparation for moving all zone related
fields from the request_queue to the gendisk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/block/null_blk/zoned.c | 4 ++--
 drivers/nvme/host/zns.c        | 4 ++--
 drivers/scsi/sd_zbc.c          | 6 +++---
 include/linux/blkdev.h         | 8 ++++----
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index b47bbd114058d..576ab3ed082a5 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -174,8 +174,8 @@ int null_register_zoned_dev(struct nullb *nullb)
 	}
 
 	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
-	blk_queue_max_open_zones(q, dev->zone_max_open);
-	blk_queue_max_active_zones(q, dev->zone_max_active);
+	disk_set_max_open_zones(nullb->disk, dev->zone_max_open);
+	disk_set_max_active_zones(nullb->disk, dev->zone_max_active);
 
 	return 0;
 }
diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 0ed15c2fd56de..12316ab51bda6 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -111,8 +111,8 @@ int nvme_update_zone_info(struct nvme_ns *ns, unsigned lbaf)
 
 	disk_set_zoned(ns->disk, BLK_ZONED_HM);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
-	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);
-	blk_queue_max_active_zones(q, le32_to_cpu(id->mar) + 1);
+	disk_set_max_open_zones(ns->disk, le32_to_cpu(id->mor) + 1);
+	disk_set_max_active_zones(ns->disk, le32_to_cpu(id->mar) + 1);
 free_data:
 	kfree(id);
 	return status;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 0f5823b674685..b4106f8997342 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -950,10 +950,10 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
 	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
 	if (sdkp->zones_max_open == U32_MAX)
-		blk_queue_max_open_zones(q, 0);
+		disk_set_max_open_zones(disk, 0);
 	else
-		blk_queue_max_open_zones(q, sdkp->zones_max_open);
-	blk_queue_max_active_zones(q, 0);
+		disk_set_max_open_zones(disk, sdkp->zones_max_open);
+	disk_set_max_active_zones(disk, 0);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7d4105d23b0a4..c05e1cc05c265 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -696,16 +696,16 @@ static inline bool blk_queue_zone_is_seq(struct request_queue *q,
 	return !test_bit(blk_queue_zone_no(q, sector), q->conv_zones_bitmap);
 }
 
-static inline void blk_queue_max_open_zones(struct request_queue *q,
+static inline void disk_set_max_open_zones(struct gendisk *disk,
 		unsigned int max_open_zones)
 {
-	q->max_open_zones = max_open_zones;
+	disk->queue->max_open_zones = max_open_zones;
 }
 
-static inline void blk_queue_max_active_zones(struct request_queue *q,
+static inline void disk_set_max_active_zones(struct gendisk *disk,
 		unsigned int max_active_zones)
 {
-	q->max_active_zones = max_active_zones;
+	disk->queue->max_active_zones = max_active_zones;
 }
 
 static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
-- 
2.30.2

