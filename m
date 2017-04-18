From: Christoph Hellwig <hch@bombadil.infradead.org>
Subject: virtio: fix spelling of virtblk_scsi_request_done
Date: Tue, 18 Apr 2017 08:52:11 -0700
Message-ID: <20170418155229.5977-6-hch@bombadil.infradead.org>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170418155229.5977-1-hch@bombadil.infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

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
