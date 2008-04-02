From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] block: move the padding adjustment to blk_rq_map_sg
Date: Thu,  3 Apr 2008 01:52:59 +0900
Message-ID: <1207155180-8069-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1207155180-8069-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:54104 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbYDBQyb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Apr 2008 12:54:31 -0400
In-Reply-To: <1207155180-8069-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>

blk_rq_map_user adjusts bi_size of the last bio. It breaks the rule
that req->data_len (the true data length) is equal to sum(bio). It
broke the scsi command completion code.

commit e97a294ef6938512b655b1abf17656cf2b26f709 was introduced to fix
the above issue. However, the partial completion code doesn't work
with it. The commit is also a layer violation (scsi mid-layer should
not know about the block layer's padding).

This patch moves the padding adjustment to blk_rq_map_sg (suggested by
James). The padding works like the drain buffer. This patch breaks the
rule that req->data_len is equal to sum(sg), however, the drain buffer
already broke it. So this patch just restores the rule that
req->data_len is equal to sub(bio) without breaking anything new.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-map.c     |   20 --------------------
 block/blk-merge.c   |    7 +++++++
 drivers/scsi/scsi.c |    2 +-
 3 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index c07d9c8..e949969 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -140,26 +140,6 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 		ubuf += ret;
 	}
 
-	/*
-	 * __blk_rq_map_user() copies the buffers if starting address
-	 * or length isn't aligned to dma_pad_mask.  As the copied
-	 * buffer is always page aligned, we know that there's enough
-	 * room for padding.  Extend the last bio and update
-	 * rq->data_len accordingly.
-	 *
-	 * On unmap, bio_uncopy_user() will use unmodified
-	 * bio_map_data pointed to by bio->bi_private.
-	 */
-	if (len & q->dma_pad_mask) {
-		unsigned int pad_len = (q->dma_pad_mask & ~len) + 1;
-		struct bio *tail = rq->biotail;
-
-		tail->bi_io_vec[tail->bi_vcnt - 1].bv_len += pad_len;
-		tail->bi_size += pad_len;
-
-		rq->extra_len += pad_len;
-	}
-
 	rq->buffer = rq->data = NULL;
 	return 0;
 unmap_rq:
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 0f58616..2a81c87 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -220,6 +220,13 @@ new_segment:
 		bvprv = bvec;
 	} /* segments in rq */
 
+	if (sg && (q->dma_pad_mask & rq->data_len)) {
+		unsigned int pad_len = (q->dma_pad_mask & ~rq->data_len) + 1;
+
+		sg->length += pad_len;
+		rq->extra_len += pad_len;
+	}
+
 	if (q->dma_drain_size && q->dma_drain_needed(rq)) {
 		if (rq->cmd_flags & REQ_RW)
 			memset(q->dma_drain_buffer, 0, q->dma_drain_size);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e5c6f6a..fecba05 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -757,7 +757,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 				"Notifying upper driver of completion "
 				"(result %x)\n", cmd->result));
 
-	good_bytes = scsi_bufflen(cmd) + cmd->request->extra_len;
+	good_bytes = scsi_bufflen(cmd);
         if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)
-- 
1.5.3.7

