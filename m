From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] nvme: move ->retries setup to nvme_setup_cmd
Date: Wed,  5 Apr 2017 16:18:52 +0200
Message-ID: <20170405141856.1862-2-hch@lst.de>
References: <20170405141856.1862-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37718 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753254AbdDEOTO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 10:19:14 -0400
In-Reply-To: <20170405141856.1862-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>
Cc: linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

This way we get the behavior right for the non-PCIe transports.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 5 +++++
 drivers/nvme/host/pci.c  | 4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 3c908e1bc903..0437f44d00f9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -350,6 +350,11 @@ int nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 {
 	int ret = BLK_MQ_RQ_QUEUE_OK;
 
+	if (!(req->rq_flags & RQF_DONTPREP)) {
+		req->retries = 0;
+		req->rq_flags |= RQF_DONTPREP;
+	}
+
 	switch (req_op(req)) {
 	case REQ_OP_DRV_IN:
 	case REQ_OP_DRV_OUT:
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 9e686a67d93b..3818ab15a26e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -326,10 +326,6 @@ static int nvme_init_iod(struct request *rq, struct nvme_dev *dev)
 	iod->nents = 0;
 	iod->length = size;
 
-	if (!(rq->rq_flags & RQF_DONTPREP)) {
-		rq->retries = 0;
-		rq->rq_flags |= RQF_DONTPREP;
-	}
 	return BLK_MQ_RQ_QUEUE_OK;
 }
 
-- 
2.11.0
