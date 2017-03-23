From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/23] block: implement splitting of REQ_OP_WRITE_ZEROES bios
Date: Thu, 23 Mar 2017 10:33:20 -0400
Message-ID: <20170323143341.31549-3-hch@lst.de>
References: <20170323143341.31549-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170323143341.31549-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Copy and past the REQ_OP_WRITE_SAME code to prepare to implementations
that limit the write zeroes size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index c62a6f0325e0..f9e5a3e0944b 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -63,6 +63,20 @@ static struct bio *blk_bio_discard_split(struct request_queue *q,
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
@@ -209,8 +223,7 @@ void blk_queue_split(struct request_queue *q, struct bio **bio,
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
