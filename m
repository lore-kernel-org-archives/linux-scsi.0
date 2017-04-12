From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/8] block: remove bio_no_advance_iter
Date: Wed, 12 Apr 2017 10:48:08 +0200
Message-ID: <20170412084809.8245-8-hch@lst.de>
References: <20170412084809.8245-1-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170412084809.8245-1-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, target-devel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Now that we don't have to support the odd Write Same special case
we can simply increment the iter if the bio has data, else just
manipulate bi_size directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/bio.h | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 96a20afb8575..7a24a1a24967 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -83,13 +83,6 @@ static inline bool bio_has_data(struct bio *bio)
 	return false;
 }
 
-static inline bool bio_no_advance_iter(struct bio *bio)
-{
-	return bio_op(bio) == REQ_OP_DISCARD ||
-	       bio_op(bio) == REQ_OP_SECURE_ERASE ||
-	       bio_op(bio) == REQ_OP_WRITE_ZEROES;
-}
-
 static inline bool bio_mergeable(struct bio *bio)
 {
 	if (bio->bi_opf & REQ_NOMERGE_FLAGS)
@@ -165,10 +158,10 @@ static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 {
 	iter->bi_sector += bytes >> 9;
 
-	if (bio_no_advance_iter(bio))
-		iter->bi_size -= bytes;
-	else
+	if (bio_has_data(bio))
 		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
+	else
+		iter->bi_size -= bytes;
 }
 
 #define __bio_for_each_segment(bvl, bio, iter, start)			\
-- 
2.11.0
