Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DD9CCA480
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 07:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiGFHER (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 03:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiGFHEN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 03:04:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DA020F75;
        Wed,  6 Jul 2022 00:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Bip3iAl8JhwETwL7n/7XazTZVp+vXf4V6KMw3HUT+xM=; b=pxG2PPARX2KeJtjeHzfEzU3tZQ
        Swsw2emwSsjx46MxQNdvpTEd5QovyJ6hsdyIujz6irsn1DVybCkK+LYDUQ3eZdUzHBOeijbsq4eiv
        fZbkHSBEDGvq5Qe+fM7wTGLnjceW99bP9L6nRpXkr8ToKqvw2GrTVo8HRvlGBl9MZ2aFK+Ybnsblh
        gVrWlsxdOC8CODPP4yGFqxAZV+yguzqM62u2t4bZsANFwPNjRgayeAfsXgT7QEX0+dreP24qdC/Cw
        Emd0R9j5zLdaOOFAa2PbIRGdEAcbdgzTw+fPBLsl6Jr3jZJDRcr+cbB0d//ngvCoVLVX5r3z3mVHD
        Nuh3XwWg==;
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8z4w-006uvm-45; Wed, 06 Jul 2022 07:04:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 05/16] block: simplify blk_check_zone_append
Date:   Wed,  6 Jul 2022 09:03:39 +0200
Message-Id: <20220706070350.1703384-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
References: <20220706070350.1703384-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the bdev based helpers instead of open coding them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

