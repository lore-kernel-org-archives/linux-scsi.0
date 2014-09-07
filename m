From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 4/6] virtio-blk: implement init_flush_rq
Date: Sun,  7 Sep 2014 16:39:20 +0800
Message-ID: <1410079162-9872-5-git-send-email-ming.lei@canonical.com>
References: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-scsi@vger.kernel.org

Now we use init_flush_rq callback to initialize pdu of
flush req.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/virtio_blk.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0a58140..f478ec8 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -177,7 +177,6 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 
 	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
 
-	vbr->req = req;
 	if (req->cmd_flags & REQ_FLUSH) {
 		vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
 		vbr->out_hdr.sector = 0;
@@ -556,6 +555,19 @@ static int virtblk_init_request(void *data, struct request *rq,
 	struct virtio_blk *vblk = data;
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
 
+	vbr->req = rq;
+	sg_init_table(vbr->sg, vblk->sg_elems);
+	return 0;
+}
+
+static int virtblk_init_flush_rq(struct request_queue *q,
+		struct request *rq)
+{
+	/* q->queuedata isn't setup yet */
+	struct virtio_blk *vblk = q->tag_set->driver_data;
+	struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
+
+	vbr->req = rq;
 	sg_init_table(vbr->sg, vblk->sg_elems);
 	return 0;
 }
@@ -565,6 +577,7 @@ static struct blk_mq_ops virtio_mq_ops = {
 	.map_queue	= blk_mq_map_queue,
 	.complete	= virtblk_request_done,
 	.init_request	= virtblk_init_request,
+	.init_flush_rq	= virtblk_init_flush_rq,
 };
 
 static unsigned int virtblk_queue_depth;
-- 
1.7.9.5
