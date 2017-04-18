From: Christoph Hellwig <hch@bombadil.infradead.org>
Subject: nvme: make nvme_error_status private
Date: Tue, 18 Apr 2017 08:52:10 -0700
Message-ID: <20170418155229.5977-5-hch@bombadil.infradead.org>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49475 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753138AbdDRPwp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 11:52:45 -0400
In-Reply-To: <20170418155229.5977-1-hch@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

Currently it's used by the lighnvm passthrough ioctl, but we'd like to make
it private in preparation of block layer specific error code.  Lighnvm already
returns the real NVMe status anyway, so I think we can just limit it to
returning -EIO for any status set.

This will need a careful audit from the lightnvm folks, though.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c     | 3 +--
 drivers/nvme/host/lightnvm.c | 6 +++---
 drivers/nvme/host/nvme.h     | 1 -
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index c6f256d74b6b..805f250315ec 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -66,7 +66,7 @@ static DEFINE_SPINLOCK(dev_list_lock);
 
 static struct class *nvme_class;
 
-int nvme_error_status(struct request *req)
+static int nvme_error_status(struct request *req)
 {
 	switch (nvme_req(req)->status & 0x7ff) {
 	case NVME_SC_SUCCESS:
@@ -77,7 +77,6 @@ int nvme_error_status(struct request *req)
 		return -EIO;
 	}
 }
-EXPORT_SYMBOL_GPL(nvme_error_status);
 
 static inline bool nvme_req_needs_retry(struct request *req)
 {
diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.c
index f85e6e57d641..7f407d5f0095 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -599,7 +599,7 @@ static int nvme_nvm_submit_user_cmd(struct request_queue *q,
 	__le64 *metadata = NULL;
 	dma_addr_t metadata_dma;
 	DECLARE_COMPLETION_ONSTACK(wait);
-	int ret;
+	int ret = 0;
 
 	rq = nvme_alloc_request(q, (struct nvme_command *)vcmd, 0,
 			NVME_QID_ANY);
@@ -671,8 +671,8 @@ static int nvme_nvm_submit_user_cmd(struct request_queue *q,
 
 	if (nvme_req(rq)->flags & NVME_REQ_CANCELLED)
 		ret = -EINTR;
-	else
-		ret = nvme_error_status(rq);
+	else if (nvme_req(rq)->status & 0x7ff)
+		ret = -EIO;
 	if (result)
 		*result = nvme_req(rq)->status & 0x7ff;
 	if (status)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index d7330f75632d..550037f5efea 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -254,7 +254,6 @@ static inline void nvme_end_request(struct request *req, __le16 status,
 	blk_mq_complete_request(req, 0);
 }
 
-int nvme_error_status(struct request *req);
 void nvme_complete_rq(struct request *req);
 void nvme_cancel_request(struct request *req, void *data, bool reserved);
 bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
-- 
2.11.0
