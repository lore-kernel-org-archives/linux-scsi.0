From: Christoph Hellwig <hch@bombadil.infradead.org>
Subject: virtio_blk: don't use req->errors
Date: Tue, 18 Apr 2017 08:52:12 -0700
Message-ID: <20170418155229.5977-7-hch@bombadil.infradead.org>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170418155229.5977-1-hch@bombadil.infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Remove passing req->errors (which at that point is always 0) to
blk_mq_complete_request, and rely on the virtio status code for the
serial number passthrough request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/block/virtio_blk.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index dbc4e80680b1..8378ad480f77 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -175,19 +175,15 @@ static int virtblk_add_req(struct virtqueue *vq, struct virtblk_req *vbr,
 static inline void virtblk_request_done(struct request *req)
 {
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
-	int error = virtblk_result(vbr);
 
 	switch (req_op(req)) {
 	case REQ_OP_SCSI_IN:
 	case REQ_OP_SCSI_OUT:
 		virtblk_scsi_request_done(req);
 		break;
-	case REQ_OP_DRV_IN:
-		req->errors = (error != 0);
-		break;
 	}
 
-	blk_mq_end_request(req, error);
+	blk_mq_end_request(req, virtblk_result(vbr));
 }
 
 static void virtblk_done(struct virtqueue *vq)
@@ -205,7 +201,7 @@ static void virtblk_done(struct virtqueue *vq)
 		while ((vbr = virtqueue_get_buf(vblk->vqs[qid].vq, &len)) != NULL) {
 			struct request *req = blk_mq_rq_from_pdu(vbr);
 
-			blk_mq_complete_request(req, req->errors);
+			blk_mq_complete_request(req, 0);
 			req_done = true;
 		}
 		if (unlikely(virtqueue_is_broken(vq)))
@@ -311,7 +307,7 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 		goto out;
 
 	blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
-	err = req->errors ? -EIO : 0;
+	err = virtblk_result(blk_mq_rq_to_pdu(req));
 out:
 	blk_put_request(req);
 	return err;
-- 
2.11.0
