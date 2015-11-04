From: mchristi@redhat.com
Subject: [PATCH 17/32] block: add operation field to bio struct
Date: Wed,  4 Nov 2015 16:08:14 -0600
Message-ID: <1446674909-5371-18-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This patch adds field to the bio to store the REQ_OP, and it
has the block layer code set it.

The next patches will modify the other drivers and filesystems
to also set the bi_op. We are still ORing the op into the bi_rw.
When I am done with the conversion, that will be dropped.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/bio.c               | 11 +++++++++--
 block/blk-core.c          |  1 +
 block/blk-map.c           |  4 +++-
 include/linux/blk_types.h |  8 +++++++-
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index ae91ccb..1cf8428 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -582,6 +582,7 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 	bio->bi_bdev = bio_src->bi_bdev;
 	bio_set_flag(bio, BIO_CLONED);
 	bio->bi_rw = bio_src->bi_rw;
+	bio->bi_op = bio_src->bi_op;
 	bio->bi_iter = bio_src->bi_iter;
 	bio->bi_io_vec = bio_src->bi_io_vec;
 }
@@ -664,6 +665,7 @@ struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
 
 	bio->bi_bdev		= bio_src->bi_bdev;
 	bio->bi_rw		= bio_src->bi_rw;
+	bio->bi_op		= bio_src->bi_op;
 	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
 	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
 
@@ -1168,8 +1170,10 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	if (!bio)
 		goto out_bmd;
 
-	if (iter->type & WRITE)
+	if (iter->type & WRITE) {
 		bio->bi_rw |= REQ_WRITE;
+		bio->bi_op = REQ_OP_WRITE;
+	}
 
 	ret = 0;
 
@@ -1338,8 +1342,10 @@ struct bio *bio_map_user_iov(struct request_queue *q,
 	/*
 	 * set data direction, and check if mapped pages need bouncing
 	 */
-	if (iter->type & WRITE)
+	if (iter->type & WRITE) {
 		bio->bi_rw |= REQ_WRITE;
+		bio->bi_op = REQ_OP_WRITE;
+	}
 
 	bio_set_flag(bio, BIO_USER_MAPPED);
 
@@ -1533,6 +1539,7 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 	} else {
 		bio->bi_end_io = bio_copy_kern_endio;
 		bio->bi_rw |= REQ_WRITE;
+		bio->bi_op = REQ_OP_WRITE;
 	}
 
 	return bio;
diff --git a/block/blk-core.c b/block/blk-core.c
index d325ece..c8672f2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1988,6 +1988,7 @@ EXPORT_SYMBOL(generic_make_request);
 void submit_bio(int op, int flags, struct bio *bio)
 {
 	bio->bi_rw |= op | flags;
+	bio->bi_op = op;
 
 	/*
 	 * If it's a regular read/write or a barrier with data attached,
diff --git a/block/blk-map.c b/block/blk-map.c
index f565e11..4a91dc4 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -223,8 +223,10 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	if (!reading)
+	if (!reading) {
 		bio->bi_rw |= REQ_WRITE;
+		bio->bi_op = REQ_OP_WRITE;
+	}
 
 	if (do_copy)
 		rq->cmd_flags |= REQ_COPY_USER;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d7b6009..b974aea 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -48,9 +48,15 @@ struct bio {
 	struct block_device	*bi_bdev;
 	unsigned int		bi_flags;	/* status, command, etc */
 	int			bi_error;
-	unsigned long		bi_rw;		/* bottom bits READ/WRITE,
+	unsigned long		bi_rw;		/* bottom bits rq_flags_bits
 						 * top bits priority
 						 */
+	/*
+	 * this will be a u8 in the next patches and bi_rw can be shrunk to
+	 * a u32. For compat in these transistional patches op is a int here.
+	 */
+	int			bi_op;		/* REQ_OP */
+
 
 	struct bvec_iter	bi_iter;
 
-- 
1.8.3.1
