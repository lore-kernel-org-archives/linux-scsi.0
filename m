Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF93CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 12:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbiGDMp6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 08:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbiGDMpq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 08:45:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD89512087;
        Mon,  4 Jul 2022 05:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=7ehkhvfvZyVLLQH3gf1BxHV2unqZSCgNrK3i+9TLyL0=; b=VMIy2+CgQjVOxNX6HLzkMvR2Pe
        g0Q1cjcIjf19uRbs4YEboHSVcCp6AnCTd09/OIjRiIcmBTyUXTUrMhJVHI75c2WFRUEBlsofJHPEL
        lTWxEj1Q8ljRSNZbQ+b0PoMP8jqKoyHrZ0wwWgO0tPuM8VYhbTHoVKznhmN86mnkygASsaZN5UJn5
        7KgxqEWyWHHerMOQqA2zAqi2DSAnJALgZ/mlHkWe5BIgQTeUFr2jE35lD/iyycsebie4v7jzD8xjR
        vSSlYKIX5jTzOEaF62CFxrGXndFOSM9AIcRl/znu8pdKkpN0qSHEOLlfBVdmaFu+6ZVX7+FXgzifs
        DucRMw5g==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LSI-008sRz-IY; Mon, 04 Jul 2022 12:45:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 12/17] block: pass a gendisk to blk_queue_max_open_zones and blk_queue_max_active_zones
Date:   Mon,  4 Jul 2022 14:44:55 +0200
Message-Id: <20220704124500.155247-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220704124500.155247-1-hch@lst.de>
References: <20220704124500.155247-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch to a gendisk based API in preparation for moving all zone related
fields from the request_queue to the gendisk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index a14cc3e46e6ad..e32c147f72868 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -698,16 +698,16 @@ static inline bool blk_queue_zone_is_seq(struct request_queue *q,
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

