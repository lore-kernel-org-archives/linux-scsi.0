Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699F5C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 12:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbiGDMpJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 08:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbiGDMpI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 08:45:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C35A9FC2;
        Mon,  4 Jul 2022 05:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=oQD+mOqL6r+jT5orCkf7PrZbOnIL7ZFFfq1K5aS9U9k=; b=xJB41yAIgWE6LnCUi9gvWcR6cR
        7a7HfFY8OgJpp8ZqXNZMz29Hi045p65JTftqIgxKnsVYN5CbyNGYHZ9ahQZ2sRtjxbFJYBbLQujPu
        AdQE8m+5CVufLKla1P2hSTqxM6pr1rZcA/TC8t550izRnwFAuLp2FGf9MU+j97Hg/uZj0e2gB4seZ
        0llzYy08KaBC46UDEnCua5VbvLNwj7KcmZulSt0p7ZeZQox1dhvmKxZ1Vz9YaeE9bvs3e2Cy9UWOT
        AwC5qYnX9eWDgb7Xhj+aCMn+e807oKwBI5F9hRawitssdz3wpWquSzAft86HPFIiGLuAWPbHQShCo
        hoVp1idg==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LRo-008s9p-Rd; Mon, 04 Jul 2022 12:45:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 01/17] block: remove a superflous ifdef in blkdev.h
Date:   Mon,  4 Jul 2022 14:44:44 +0200
Message-Id: <20220704124500.155247-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220704124500.155247-1-hch@lst.de>
References: <20220704124500.155247-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It doesn't hurt to lways have the blk_zone_cond_str prototype, and the
two inlines can also be defined unconditionally.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

