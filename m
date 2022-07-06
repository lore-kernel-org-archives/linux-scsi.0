Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9ECC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 07:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiGFHEb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 03:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbiGFHEU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 03:04:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9123B20BDC;
        Wed,  6 Jul 2022 00:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=BMSKltgti8wB9dwtOAjLWAbeE/YUcsITT2h3tQ+s1Yg=; b=cXNoc6QwPRom1uq3aIwwF7k84m
        +sCzRSITvVtkpUV/5VSr3HlqIya7ePxoWj4cni6WRANiTq8qZKlqTLDCwqK6WTNtL75EKCHCvKFED
        RhS1YL7dYKJ0Xdu5/wvb/cjnmqn/LZUyJDT+gaYCkTaR30PpjDI9nyIMaFYSHMTNTxhzefouFgdWZ
        7aaddcvx26Tmomh8GAbFK1i+WWSrPjosh3XTd0Syyuahg/zUobpnGZfXeC1khH9f2xuazhvOrx1OV
        qNy7R9gk9FSsMnuRNrdva6Zbv9icS17lslmeNIHwYC6toak+eApM3uTowC5NjHW+Pfxeu9DqsUoOo
        /5xDNynA==;
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8z56-006v47-O9; Wed, 06 Jul 2022 07:04:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 09/16] block: remove queue_max_open_zones and queue_max_active_zones
Date:   Wed,  6 Jul 2022 09:03:43 +0200
Message-Id: <20220706070350.1703384-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
References: <20220706070350.1703384-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Always use the bdev based helpers instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-sysfs.c      |  4 ++--
 include/linux/blkdev.h | 37 ++++++++++---------------------------
 2 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 7590810cf13fc..5ce72345ac666 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -330,12 +330,12 @@ static ssize_t queue_nr_zones_show(struct request_queue *q, char *page)
 
 static ssize_t queue_max_open_zones_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(queue_max_open_zones(q), page);
+	return queue_var_show(bdev_max_open_zones(q->disk->part0), page);
 }
 
 static ssize_t queue_max_active_zones_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(queue_max_active_zones(q), page);
+	return queue_var_show(bdev_max_active_zones(q->disk->part0), page);
 }
 
 static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 416faa0137820..7d4105d23b0a4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -702,21 +702,22 @@ static inline void blk_queue_max_open_zones(struct request_queue *q,
 	q->max_open_zones = max_open_zones;
 }
 
-static inline unsigned int queue_max_open_zones(const struct request_queue *q)
-{
-	return q->max_open_zones;
-}
-
 static inline void blk_queue_max_active_zones(struct request_queue *q,
 		unsigned int max_active_zones)
 {
 	q->max_active_zones = max_active_zones;
 }
 
-static inline unsigned int queue_max_active_zones(const struct request_queue *q)
+static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
+{
+	return bdev->bd_disk->queue->max_open_zones;
+}
+
+static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
 {
-	return q->max_active_zones;
+	return bdev->bd_disk->queue->max_active_zones;
 }
+
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
 {
@@ -732,11 +733,11 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
 {
 	return 0;
 }
-static inline unsigned int queue_max_open_zones(const struct request_queue *q)
+static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
 {
 	return 0;
 }
-static inline unsigned int queue_max_active_zones(const struct request_queue *q)
+static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
 {
 	return 0;
 }
@@ -1314,24 +1315,6 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 	return 0;
 }
 
-static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
-{
-	struct request_queue *q = bdev_get_queue(bdev);
-
-	if (q)
-		return queue_max_open_zones(q);
-	return 0;
-}
-
-static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
-{
-	struct request_queue *q = bdev_get_queue(bdev);
-
-	if (q)
-		return queue_max_active_zones(q);
-	return 0;
-}
-
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
-- 
2.30.2

