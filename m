Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFFCC43334
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 12:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbiGDMqG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 08:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbiGDMps (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 08:45:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4597A120A2;
        Mon,  4 Jul 2022 05:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=TYBJahfwkfMLeoVA8quXPBFpQwI12nXD7pTG2SEW+HY=; b=sj+S+6dWlz62vT4b7aCoC5O6Ox
        U/B4wj4ASTuk53ot6a9t0pePbWR6ZIZJ5gNZAr1+LdEG/WpFJzEdtu4EZ7XGZNt9D4pEFkKdiDlvm
        GYSEC4ybe7VgHq17wg1IIJYJw8X4exFdrDAF9DJzUToulMFfh9kNPXS6Qh9hswhq+uQiGk/jCSnSi
        DEOSgMMD6DktM9VF+ZA0aQjo2SErBTy2n2+5ZCmtGrksEu7wIvK36IT6gYtCYZZ1L8WRBTHq04/xo
        TclSMwX2ktBE77oltFXCwrvGlkkWiQAayZhwbtp/cw4uhfNiv/3mJCb25JB8ToH81GHZ0LzcZq4aP
        sCL8zUyA==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LSO-008sVA-3A; Mon, 04 Jul 2022 12:45:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 14/17] block: use bdev based helpers in blkdev_zone_mgmt / blkdev_zone_mgmt_all
Date:   Mon,  4 Jul 2022 14:44:57 +0200
Message-Id: <20220704124500.155247-15-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220704124500.155247-1-hch@lst.de>
References: <20220704124500.155247-1-hch@lst.de>
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
---
 block/blk-zoned.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 836b96ebfdc04..ee8752f083a94 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -190,8 +190,8 @@ int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
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

