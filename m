From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/27] block: implement splitting of
	REQ_OP_WRITE_ZEROES bios
Date: Wed,  5 Apr 2017 19:21:01 +0200
Message-ID: <20170405172125.22600-4-hch@lst.de>
References: <20170405172125.22600-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170405172125.22600-1-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

Copy and past the REQ_OP_WRITE_SAME code to prepare to implementations
that limit the write zeroes size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
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
