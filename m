From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 1/5] block: update bio according to DMA alignment padding
Date: Tue,  5 Feb 2008 16:53:01 +0900
Message-ID: <12021979863012-git-send-email-htejun@gmail.com>
References: <12021979851743-git-send-email-htejun@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <12021979851743-git-send-email-htejun@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, Jens.Axboe@oracle.com
Cc: Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

DMA start address and transfer size alignment for PC requests are
achieved using bio_copy_user() instead of bio_map_user().  This works
because bio_copy_user() always uses full pages and block DMA alignment
isn't allowed to go over PAGE_SIZE.

However, the implementation didn't update the last bio of the request
to make this padding visible to lower layers.  This patch makes
blk_rq_map_user() extend the last bio such that it includes the
padding area and the size of area pointed to by the request is
properly aligned.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/blk-map.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 955d75c..103b1df 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -139,6 +139,23 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 		ubuf += ret;
 	}
 
+	/*
+	 * __blk_rq_map_user() copies the buffers if starting address
+	 * or length isn't aligned.  As the copied buffer is always
+	 * page aligned, we know that there's enough room for padding.
+	 * Extend the last bio and update rq->data_len accordingly.
+	 *
+	 * On unmap, bio_uncopy_user() will use unmodified
+	 * bio_map_data pointed to by bio->bi_private.
+	 */
+	if (len & queue_dma_alignment(q)) {
+		unsigned int pad_len = (queue_dma_alignment(q) & ~len) + 1;
+		struct bio *bio = rq->biotail;
+
+		bio->bi_io_vec[bio->bi_vcnt - 1].bv_len += pad_len;
+		bio->bi_size += pad_len;
+	}
+
 	rq->buffer = rq->data = NULL;
 	return 0;
 unmap_rq:
-- 
1.5.2.4

