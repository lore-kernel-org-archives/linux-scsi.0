From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/23] virtio: fix spelling of virtblk_scsi_request_done
Date: Thu, 20 Apr 2017 16:02:59 +0200
Message-ID: <20170420140316.6546-7-hch@lst.de>
References: <20170420140316.6546-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57935 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032028AbdDTODm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 10:03:42 -0400
In-Reply-To: <20170420140316.6546-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>
---
 drivers/block/virtio_blk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index eaf99022bdc6..dbc4e80680b1 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -111,7 +111,7 @@ static int virtblk_add_req_scsi(struct virtqueue *vq, struct virtblk_req *vbr,
 	return virtqueue_add_sgs(vq, sgs, num_out, num_in, vbr, GFP_ATOMIC);
 }
 
-static inline void virtblk_scsi_reques_done(struct request *req)
+static inline void virtblk_scsi_request_done(struct request *req)
 {
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 	struct virtio_blk *vblk = req->q->queuedata;
@@ -144,7 +144,7 @@ static inline int virtblk_add_req_scsi(struct virtqueue *vq,
 {
 	return -EIO;
 }
-static inline void virtblk_scsi_reques_done(struct request *req)
+static inline void virtblk_scsi_request_done(struct request *req)
 {
 }
 #define virtblk_ioctl	NULL
@@ -180,7 +180,7 @@ static inline void virtblk_request_done(struct request *req)
 	switch (req_op(req)) {
 	case REQ_OP_SCSI_IN:
 	case REQ_OP_SCSI_OUT:
-		virtblk_scsi_reques_done(req);
+		virtblk_scsi_request_done(req);
 		break;
 	case REQ_OP_DRV_IN:
 		req->errors = (error != 0);
-- 
2.11.0
