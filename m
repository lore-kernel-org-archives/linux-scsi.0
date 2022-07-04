Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE16CCA479
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 12:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbiGDMpc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 08:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234390AbiGDMpX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 08:45:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1BCFD05;
        Mon,  4 Jul 2022 05:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=BgcBAlW8kpoNWrI2qSfc2h94aoc6Kt3RliANNqAJEac=; b=wG0b/h7LrjP8n8SZCbn3HeQlbb
        8f4OUntmcEhWJQMW8O5jE32ibz9E8B45sejD38GWeIUybg82LMHdj95s30zlZK/i0DrRFFbq9Y5VV
        TYMfKz0Ky8vn+HcIDSmpyzCZ9QAo8pb5N3E9TPOiUDarHSA+oqfAUbf7T1ZwNx+491uxAi4TLD5Ft
        T8rNcdBJjLOnrum5Og7fIFCQRODgeiBvCa7KdveadG+V334jXUz/yBB664yvf8E6W0bg8hIqVsv46
        Vvn2H4yG7Dr9ycEHE0kX3feUeu8AUHSH33pRyM4AYH8Hj5nmBUv9yex5oTm99/jcR8qRFbCQUAwt+
        g7X6N1EA==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LS5-008sIX-3z; Mon, 04 Jul 2022 12:45:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 07/17] block: simplify blk_check_zone_append
Date:   Mon,  4 Jul 2022 14:44:50 +0200
Message-Id: <20220704124500.155247-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220704124500.155247-1-hch@lst.de>
References: <20220704124500.155247-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the bdev based helpers instead of open coding them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bc16e9bae2dc4..b530ce7b370c4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -565,7 +565,6 @@ static int blk_partition_remap(struct bio *bio)
 static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 						 struct bio *bio)
 {
-	sector_t pos = bio->bi_iter.bi_sector;
 	int nr_sectors = bio_sectors(bio);
 
 	/* Only applicable to zoned block devices */
@@ -573,8 +572,8 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 		return BLK_STS_NOTSUPP;
 
 	/* The bio sector must point to the start of a sequential zone */
-	if (pos & (blk_queue_zone_sectors(q) - 1) ||
-	    !blk_queue_zone_is_seq(q, pos))
+	if (bio->bi_iter.bi_sector & (bdev_zone_sectors(bio->bi_bdev) - 1) ||
+	    !bio_zone_is_seq(bio))
 		return BLK_STS_IOERR;
 
 	/*
-- 
2.30.2

