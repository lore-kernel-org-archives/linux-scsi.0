Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4486FCCA482
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 07:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiGFHEn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 03:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiGFHEa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 03:04:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0222222B8;
        Wed,  6 Jul 2022 00:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=tgyqP1bIhsvdZx95BMoRlFVB6nrmkRZfG/R3FTELfmE=; b=5A2bkAoXUE4Y78693ckSsVBIX9
        dssQpfBTrXb6Hxp7QHEJBiHqhtYnOkwx83MMcDRHAeMfOkHzNnaTrJTyWdupDgDwBd/1IIH3jNVXt
        XPau1WYJrulA57hPzDVAtujGM3TIlXmFB6dEi6C9QN7zszMxcyCO1wm9PpyLyVSCRUXOs+kwmBzoE
        w8h4u8z14aW/23GEh7+khlhTWicW9R9I36JMXpsN4jj+bbVyO7LoHqpJ2u8M2UQzY++FxJa/R/NZs
        Rd9fTq+/Ihw7Q9KOL5G74mMUmaPja/4h+v6WDoZzrywaW6H0OksVreX/MJAVVMG2VqS+M6I2m9pPl
        dJrR93Fw==;
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8z5E-006vBt-Gt; Wed, 06 Jul 2022 07:04:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 12/16] block: use bdev based helpers in blkdev_zone_mgmt{,all}
Date:   Wed,  6 Jul 2022 09:03:46 +0200
Message-Id: <20220706070350.1703384-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
References: <20220706070350.1703384-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the bdev based helpers instead of the queue based ones to clean up
the code a bit and prepare for storing all zone related fields in
struct gendisk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-zoned.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 2dec25d8aa3bd..c2d8a38f449aa 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -190,8 +190,8 @@ static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
 					  gfp_t gfp_mask)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-	sector_t capacity = get_capacity(bdev->bd_disk);
-	sector_t zone_sectors = blk_queue_zone_sectors(q);
+	sector_t capacity = bdev_nr_sectors(bdev);
+	sector_t zone_sectors = bdev_zone_sectors(bdev);
 	unsigned long *need_reset;
 	struct bio *bio = NULL;
 	sector_t sector = 0;
@@ -262,8 +262,8 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 		     gfp_t gfp_mask)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-	sector_t zone_sectors = blk_queue_zone_sectors(q);
-	sector_t capacity = get_capacity(bdev->bd_disk);
+	sector_t zone_sectors = bdev_zone_sectors(bdev);
+	sector_t capacity = bdev_nr_sectors(bdev);
 	sector_t end_sector = sector + nr_sectors;
 	struct bio *bio = NULL;
 	int ret = 0;
-- 
2.30.2

