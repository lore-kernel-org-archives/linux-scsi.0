Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D8BAC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 12:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbiGDMpY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 08:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbiGDMpQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 08:45:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FC8FD05;
        Mon,  4 Jul 2022 05:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=K6Sj8SyA+t2737GsIdcC/iL+luUB9xztUt5207izHJk=; b=vp9Y7zC4mbhpuLrw9LZzM87jn5
        dKxeUTcWHikoo1el9BuHqXE44g3Eu7ro/P4ipvz+YALvpQdCH6PSml6ZXY2BdkpCTLAD39P+Rrd5V
        IdLKDYbksH5YEZcyOq/aagN0cP/k+N73qKW7DnJRplC6uuO2amFlD7FezUhIM88i3fsQR+ti7LbSf
        gnkpD2+i4PaNOM4HtXK7MWieLALXEsfAgncd7F8jrJBWg03Z7odJ+4sTiIRz1Nxs3fY5GmVfo/amQ
        boSD9hhKmcUOGjZi9jQyyz6InHxofCXc7GB1jF2MJw2UeHqThkGUEPuQl/lofGR2UtVYC3vqOnSCI
        BeKCPAag==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LRw-008sDw-Um; Mon, 04 Jul 2022 12:45:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 04/17] block: simplify blk_mq_plug
Date:   Mon,  4 Jul 2022 14:44:47 +0200
Message-Id: <20220704124500.155247-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220704124500.155247-1-hch@lst.de>
References: <20220704124500.155247-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drop the unused q argument, and invert the check to move the exception
into a branch and the regular path as the normal return.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c  |  2 +-
 block/blk-merge.c |  2 +-
 block/blk-mq.c    |  2 +-
 block/blk-mq.h    | 18 ++++++++----------
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 6bcca0b686de4..bc16e9bae2dc4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -719,7 +719,7 @@ void submit_bio_noacct(struct bio *bio)
 
 	might_sleep();
 
-	plug = blk_mq_plug(q, bio);
+	plug = blk_mq_plug(bio);
 	if (plug && plug->nowait)
 		bio->bi_opf |= REQ_NOWAIT;
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 0f5f42ebd0bb0..5abf5aa5a5f0e 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -1051,7 +1051,7 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 	struct blk_plug *plug;
 	struct request *rq;
 
-	plug = blk_mq_plug(q, bio);
+	plug = blk_mq_plug(bio);
 	if (!plug || rq_list_empty(plug->mq_list))
 		return false;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 15c7c5c4ad222..dc714dff73001 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2804,7 +2804,7 @@ static void bio_set_ioprio(struct bio *bio)
 void blk_mq_submit_bio(struct bio *bio)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	struct blk_plug *plug = blk_mq_plug(q, bio);
+	struct blk_plug *plug = blk_mq_plug(bio);
 	const int is_sync = op_is_sync(bio->bi_opf);
 	struct request *rq;
 	unsigned int nr_segs = 1;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 31d75a83a562d..1cc0b17d69229 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -294,7 +294,6 @@ static inline void blk_mq_clear_mq_map(struct blk_mq_queue_map *qmap)
 
 /*
  * blk_mq_plug() - Get caller context plug
- * @q: request queue
  * @bio : the bio being submitted by the caller context
  *
  * Plugging, by design, may delay the insertion of BIOs into the elevator in
@@ -305,23 +304,22 @@ static inline void blk_mq_clear_mq_map(struct blk_mq_queue_map *qmap)
  * order. While this is not a problem with regular block devices, this ordering
  * change can cause write BIO failures with zoned block devices as these
  * require sequential write patterns to zones. Prevent this from happening by
- * ignoring the plug state of a BIO issuing context if the target request queue
- * is for a zoned block device and the BIO to plug is a write operation.
+ * ignoring the plug state of a BIO issuing context if is for a zoned block
+ 8 device and the BIO to plug is a write operation.
  *
  * Return current->plug if the bio can be plugged and NULL otherwise
  */
-static inline struct blk_plug *blk_mq_plug(struct request_queue *q,
-					   struct bio *bio)
+static inline struct blk_plug *blk_mq_plug( struct bio *bio)
 {
+	/* Zoned block device write operation case: do not plug the BIO */
+	if (bdev_is_zoned(bio->bi_bdev) && op_is_write(bio_op(bio)))
+		return NULL;
+
 	/*
 	 * For regular block devices or read operations, use the context plug
 	 * which may be NULL if blk_start_plug() was not executed.
 	 */
-	if (!bdev_is_zoned(bio->bi_bdev) || !op_is_write(bio_op(bio)))
-		return current->plug;
-
-	/* Zoned block device write operation case: do not plug the BIO */
-	return NULL;
+	return current->plug;
 }
 
 /* Free all requests on the list */
-- 
2.30.2

