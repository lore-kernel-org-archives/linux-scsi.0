From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/23] nvme-fc: fix status code handling in nvme_fc_fcpio_done
Date: Wed, 19 Apr 2017 21:26:48 +0200
Message-ID: <20170419192708.22098-4-hch@lst.de>
References: <20170419192708.22098-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47207 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934133AbdDST10 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 15:27:26 -0400
In-Reply-To: <20170419192708.22098-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

nvme_complete_async_event expects the little endian status code
including the phase bit, and a new completion handler I plan to
introduce will do so as well.

Change the status variable into the little endian format with the
phase bit used in the NVMe CQE to fix / enable this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/nvme/host/fc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index fc42172c796a..aad7f9c0be32 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1147,7 +1147,7 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 	struct nvme_fc_ctrl *ctrl = op->ctrl;
 	struct nvme_fc_queue *queue = op->queue;
 	struct nvme_completion *cqe = &op->rsp_iu.cqe;
-	u16 status = NVME_SC_SUCCESS;
+	__le16 status = cpu_to_le16(NVME_SC_SUCCESS << 1);
 
 	/*
 	 * WARNING:
@@ -1182,9 +1182,9 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 				sizeof(op->rsp_iu), DMA_FROM_DEVICE);
 
 	if (atomic_read(&op->state) == FCPOP_STATE_ABORTED)
-		status = NVME_SC_ABORT_REQ | NVME_SC_DNR;
+		status = cpu_to_le16((NVME_SC_ABORT_REQ | NVME_SC_DNR) << 1);
 	else if (freq->status)
-		status = NVME_SC_FC_TRANSPORT_ERROR;
+		status = cpu_to_le16(NVME_SC_FC_TRANSPORT_ERROR << 1);
 
 	/*
 	 * For the linux implementation, if we have an unsuccesful
@@ -1212,7 +1212,7 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 		 */
 		if (freq->transferred_length !=
 			be32_to_cpu(op->cmd_iu.data_len)) {
-			status = NVME_SC_FC_TRANSPORT_ERROR;
+			status = cpu_to_le16(NVME_SC_FC_TRANSPORT_ERROR << 1);
 			goto done;
 		}
 		op->nreq.result.u64 = 0;
@@ -1229,15 +1229,15 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 					freq->transferred_length ||
 			     op->rsp_iu.status_code ||
 			     op->rqno != le16_to_cpu(cqe->command_id))) {
-			status = NVME_SC_FC_TRANSPORT_ERROR;
+			status = cpu_to_le16(NVME_SC_FC_TRANSPORT_ERROR << 1);
 			goto done;
 		}
 		op->nreq.result = cqe->result;
-		status = le16_to_cpu(cqe->status) >> 1;
+		status = cqe->status;
 		break;
 
 	default:
-		status = NVME_SC_FC_TRANSPORT_ERROR;
+		status = cpu_to_le16(NVME_SC_FC_TRANSPORT_ERROR << 1);
 		goto done;
 	}
 
@@ -1249,7 +1249,7 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 		return;
 	}
 
-	blk_mq_complete_request(rq, status);
+	blk_mq_complete_request(rq, le16_to_cpu(status) >> 1);
 }
 
 static int
-- 
2.11.0
