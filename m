Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1BFCCA473
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 07:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiGFHEI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 03:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiGFHEG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 03:04:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717996312;
        Wed,  6 Jul 2022 00:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Q99xwmZ516+YqR7K1z4qPxcfNQ29PzHNUl8eoY+y9Tc=; b=j7a4xNT/EjShuyQwe9vF1CGTYa
        ykeZuKvKA82oeIK8bcFfOpjGiMwZsOMokw2arF8LfrcjzVMSGIqTv/z0G/2NWlb1gQBWkfiupPJmo
        Fg/Nh0693GVBTCREaFTYpK6/4kjpC74NDK6Qwr2Os+SwxLJm4nG56hs8OqE/oEkhif/ThCu9pmP0H
        QjSOgvtpnsRB1hslOjgmFYAm1teUK8sYcj4VvoWd/+YbgJ3gfk5RPoY0VCJmz1OioB5Pw8w8bDFk2
        piuQ4i7Hf/ydCL0g4VjEClckVIfsxc5mHT70+9Dq0V3MP0ieiWzYcdlJ0+3E+vW8tsiRS4jsZAkmv
        HMN9M7Ng==;
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8z4t-006uty-J4; Wed, 06 Jul 2022 07:04:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 04/16] block: simplify blk_mq_plug
Date:   Wed,  6 Jul 2022 09:03:38 +0200
Message-Id: <20220706070350.1703384-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
References: <20220706070350.1703384-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drop the unused q argument, and invert the check to move the exception
into a branch and the regular path as the normal return.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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
index 31d75a83a562d..e694ec67d646a 100644
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
+ * ignoring the plug state of a BIO issuing context if it is for a zoned block
+ * device and the BIO to plug is a write operation.
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

