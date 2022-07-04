Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6913CCCA482
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 12:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiGDMpa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 08:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbiGDMpX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 08:45:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AEAF5A8;
        Mon,  4 Jul 2022 05:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ujjyOtxKDT4Pk2zuL4xPJGwZz+SVr+2tgIYrxee6Mi4=; b=OtlBabr730mfskFLI2ku1VHFGQ
        VjOX/zc82U//0uwqEmwb4IckFPRNAbzS0inB0h5Y0YucTD60rIfdSGO4Uk97NHsp4OK6Ld448XSr5
        WCn8B4Lmi4HwDPyUlMvv0+1MJfQc61VlsJYshHxvDPqcbf4049iFmNh1fSDZPHIrTW4xE8LIG3ZTR
        07lriSfgP6zGlhckOkXikcKeTptCrUXVWrqQbYMwYPBSIQq0PY2fBjKL5rH84twWKfOlUdNpnKWCB
        yxP5kM0uxyX70mxrqMEhGC1+9Q9TFGCvqPBjDNONa0WXnN7zmhEPBo7r4ysFCy7ubuPNiwe9+jHry
        SiZG51Fw==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LRz-008sFG-MP; Mon, 04 Jul 2022 12:45:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 05/17] block: export blkdev_zone_mgmt_all
Date:   Mon,  4 Jul 2022 14:44:48 +0200
Message-Id: <20220704124500.155247-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220704124500.155247-1-hch@lst.de>
References: <20220704124500.155247-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Export blkdev_zone_mgmt_all so that the nvme target can use it instead
of duplicating the functionality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-zoned.c      | 10 +++++-----
 include/linux/blkdev.h |  2 ++
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 90a5c9cc80ab3..7fbe395fa51fc 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -185,8 +185,8 @@ static int blk_zone_need_reset_cb(struct blk_zone *zone, unsigned int idx,
 	}
 }
 
-static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
-					  gfp_t gfp_mask)
+int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
+			 gfp_t gfp_mask)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 	sector_t capacity = get_capacity(bdev->bd_disk);
@@ -213,8 +213,7 @@ static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
 			continue;
 		}
 
-		bio = blk_next_bio(bio, bdev, 0, REQ_OP_ZONE_RESET | REQ_SYNC,
-				   gfp_mask);
+		bio = blk_next_bio(bio, bdev, 0, op | REQ_SYNC, gfp_mask);
 		bio->bi_iter.bi_sector = sector;
 		sector += zone_sectors;
 
@@ -231,6 +230,7 @@ static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
 	kfree(need_reset);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(blkdev_zone_mgmt_all);
 
 static int blkdev_zone_reset_all(struct block_device *bdev, gfp_t gfp_mask)
 {
@@ -295,7 +295,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 	 */
 	if (op == REQ_OP_ZONE_RESET && sector == 0 && nr_sectors == capacity) {
 		if (!blk_queue_zone_resetall(q))
-			return blkdev_zone_reset_all_emulated(bdev, gfp_mask);
+			return blkdev_zone_mgmt_all(bdev, op, gfp_mask);
 		return blkdev_zone_reset_all(bdev, gfp_mask);
 	}
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 270cd0c552924..b9baee910b825 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -302,6 +302,8 @@ unsigned int blkdev_nr_zones(struct gendisk *disk);
 extern int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 			    sector_t sectors, sector_t nr_sectors,
 			    gfp_t gfp_mask);
+int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
+			 gfp_t gfp_mask);
 int blk_revalidate_disk_zones(struct gendisk *disk,
 			      void (*update_driver_data)(struct gendisk *disk));
 
-- 
2.30.2

