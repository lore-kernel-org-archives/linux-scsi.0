Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C7AC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 16:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240628AbiCDQFL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 11:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240585AbiCDQFJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 11:05:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910041B7602;
        Fri,  4 Mar 2022 08:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JANkEFHHfjZyPR6miGkscmr3ZdzOwSYp1qXO2PrN6lc=; b=GfVUTSzIROWYnw2T+Fp1wwhnbG
        bYkU9W82+iy3qZrTwKRmsCSVFopBm60/WX38ikdLajf+NRsKqBm6NuFRkKtgayluUMPGfQamPZV/Y
        dOZNbqGd4sWPDEEmMCiOZfG7MytB6CrDFBzt7h+F+CYLk4yMkOWZbW9m00jDDqI3R/4DoG2rz5Lj/
        t78LnxWE9KIn1aal9R/P4LEd2syUuQKnZ81Y+ztMZ3DkfwV9BZYndSnXwBGPLs9MGzgUCx60JXfcT
        5wyDeJBxTL5g7s3H5YBrEqGabeNy3bDytaoJufFWB+okpyXEdGh8rRLyWWlKf4spcl5C/K+UbjRlE
        nJ7xh9+A==;
Received: from [2001:4bb8:180:5296:7360:567:acd5:aaa2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQAPV-00Au6Y-Vp; Fri, 04 Mar 2022 16:04:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 10/14] block: don't remove hctx debugfs dir from blk_mq_exit_queue
Date:   Fri,  4 Mar 2022 17:03:27 +0100
Message-Id: <20220304160331.399757-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220304160331.399757-1-hch@lst.de>
References: <20220304160331.399757-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

The queue's top debugfs dir is removed from blk_release_queue(), so all
hctx's debugfs dirs are removed from there. Given blk_mq_exit_queue()
is only called from blk_cleanup_queue(), it isn't necessary to remove
hctx debugfs from blk_mq_exit_queue().

So remove it from blk_mq_exit_queue().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6fd0b0f652514..b38e125a710c9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3434,7 +3434,6 @@ static void blk_mq_exit_hw_queues(struct request_queue *q,
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (i == nr_queue)
 			break;
-		blk_mq_debugfs_unregister_hctx(hctx);
 		blk_mq_exit_hctx(q, set, hctx, i);
 	}
 }
-- 
2.30.2

