Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4339CCCA473
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 07:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiGFHEB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 03:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiGFHD6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 03:03:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76A2F42;
        Wed,  6 Jul 2022 00:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=59GwLk/57mAU/aV+lYrkyA68Pm/XES/YiUDw0OaPmaE=; b=dFQEjkjoqiNTKENSL1bHP/b6ip
        t0SKB/cQYl4+dzr7NGpkOMOGui0vtblJoKnFcpK4howCelI5N5EZtAcGEtCs3XmyEy/ZKt+cuzIRF
        7CzOSdsqGVz8F41/Av91QO8pJDXByE/g699GrjIhYamNrllQyfUKNIrGcHwW9IFpkQZcNYC1fYhwv
        b0lI9e1XfL+3BZhoxhuKw/RIPaAqRppWQ+EHN7OmDA1TUIIcLgLFcu+khBw5QJJLUWzAWMbX2T/RJ
        nFxh81i+JVPfqqvN0G/ZEVzMZvDQEDINvJybJd7w5Xbs2s586EpqSedGW5Qr0C//sPOIZEo0BbGPG
        zXACS3vA==;
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8z4l-006upM-J0; Wed, 06 Jul 2022 07:03:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 01/16] block: remove a superflous ifdef in blkdev.h
Date:   Wed,  6 Jul 2022 09:03:35 +0200
Message-Id: <20220706070350.1703384-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
References: <20220706070350.1703384-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It doesn't hurt to always have the blk_zone_cond_str prototype, and the
two inlines can also be defined unconditionally.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 include/linux/blkdev.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b9a94c53c6cd3..270cd0c552924 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -899,8 +899,6 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 	return bdev->bd_queue;	/* this is never NULL */
 }
 
-#ifdef CONFIG_BLK_DEV_ZONED
-
 /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */
 const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);
 
@@ -915,7 +913,6 @@ static inline unsigned int bio_zone_is_seq(struct bio *bio)
 	return blk_queue_zone_is_seq(bdev_get_queue(bio->bi_bdev),
 				     bio->bi_iter.bi_sector);
 }
-#endif /* CONFIG_BLK_DEV_ZONED */
 
 /*
  * Return how much of the chunk is left to be used for I/O at a given offset.
-- 
2.30.2

