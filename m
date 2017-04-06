From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/25] virtio_blk: don't use req->errors
Date: Thu,  6 Apr 2017 17:39:26 +0200
Message-ID: <20170406153944.10058-8-hch@lst.de>
References: <20170406153944.10058-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59019 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933010AbdDFPkP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 11:40:15 -0400
In-Reply-To: <20170406153944.10058-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

Remove passing req->errors (which at that point is always 0) to
blk_mq_complete_requestq, and rely on the virtio status code for the
serial number passthrough request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
