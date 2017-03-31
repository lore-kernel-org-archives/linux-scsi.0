From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/25] block: implement splitting of REQ_OP_WRITE_ZEROES bios
Date: Fri, 31 Mar 2017 18:32:51 +0200
Message-ID: <20170331163313.31821-4-hch@lst.de>
References: <20170331163313.31821-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39818 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933217AbdCaQd3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2017 12:33:29 -0400
In-Reply-To: <20170331163313.31821-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org

Copy and past the REQ_OP_WRITE_SAME code to prepare to implementations
that limit the write zeroes size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2afa262425d1..3990ae406341 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -54,6 +54,20 @@ static struct bio *blk_bio_discard_split(struct request_queue *q,
 	return bio_split(bio, split_sectors, GFP_NOIO, bs);
 }
 
+static struct bio *blk_bio_write_zeroes_split(struct request_queue *q,
+		struct bio *bio, struct bio_set *bs, unsigned *nsegs)
+{
+	*nsegs = 1;
+
+	if (!q->limits.max_write_zeroes_sectors)
+		return NULL;
+
+	if (bio_sectors(bio) <= q->limits.max_write_zeroes_sectors)
+		return NULL;
+
+	return bio_split(bio, q->limits.max_write_zeroes_sectors, GFP_NOIO, bs);
+}
+
 static struct bio *blk_bio_write_same_split(struct request_queue *q,
 					    struct bio *bio,
 					    struct bio_set *bs,
@@ -200,8 +214,7 @@ void blk_queue_split(struct request_queue *q, struct bio **bio,
 		split = blk_bio_discard_split(q, *bio, bs, &nsegs);
 		break;
 	case REQ_OP_WRITE_ZEROES:
-		split = NULL;
-		nsegs = (*bio)->bi_phys_segments;
+		split = blk_bio_write_zeroes_split(q, *bio, bs, &nsegs);
 		break;
 	case REQ_OP_WRITE_SAME:
 		split = blk_bio_write_same_split(q, *bio, bs, &nsegs);
-- 
2.11.0
