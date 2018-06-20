From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH 5/5] nvme: use __blk_mq_complete_request in timeout path
Date: Wed, 20 Jun 2018 21:22:44 +0800
Message-ID: <1529500964-28429-6-git-send-email-jianchao.w.wang@oracle.com>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com, keith.busch@intel.com, josef@toxicpanda.com, ulf.hansson@linaro.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

To regain the capability to prevent normal completion path from
entering a timeout request, blk_mq_mark_rq_complete is introduced
in blk_mq_complete_request. Have to use __blk_mq_complete_request
in timeout path to complete a timeout request.

nvme_cancel_request uses blk_mq_complete_request, it won't do
anything on the timeout request, so add __blk_mq_complete_request
before return BLK_EH_DONE.

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
---
 drivers/nvme/host/pci.c    | 8 ++++++++
 drivers/nvme/host/rdma.c   | 1 +
 drivers/nvme/target/loop.c | 1 +
 3 files changed, 10 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 73a97fc..2a161f6 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1203,6 +1203,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 		nvme_warn_reset(dev, csts);
 		nvme_dev_disable(dev, false);
 		nvme_reset_ctrl(&dev->ctrl);
+		__blk_mq_complete_request(req);
 		return BLK_EH_DONE;
 	}
 
@@ -1213,6 +1214,11 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 		dev_warn(dev->ctrl.device,
 			 "I/O %d QID %d timeout, completion polled\n",
 			 req->tag, nvmeq->qid);
+		/*
+		 * nvme_end_request will invoke blk_mq_complete_request,
+		 * it will do nothing for this timed out request.
+		 */
+		__blk_mq_complete_request(req);
 		return BLK_EH_DONE;
 	}
 
@@ -1230,6 +1236,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 			 req->tag, nvmeq->qid);
 		nvme_dev_disable(dev, false);
 		nvme_req(req)->flags |= NVME_REQ_CANCELLED;
+		__blk_mq_complete_request(req);
 		return BLK_EH_DONE;
 	default:
 		break;
@@ -1248,6 +1255,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 		nvme_reset_ctrl(&dev->ctrl);
 
 		nvme_req(req)->flags |= NVME_REQ_CANCELLED;
+		__blk_mq_complete_request(req);
 		return BLK_EH_DONE;
 	}
 
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index c9424da..287eecd 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1617,6 +1617,7 @@ nvme_rdma_timeout(struct request *rq, bool reserved)
 	/* fail with DNR on cmd timeout */
 	nvme_req(rq)->status = NVME_SC_ABORT_REQ | NVME_SC_DNR;
 
+	__blk_mq_complete_request(rq);
 	return BLK_EH_DONE;
 }
 
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index d8d91f0..627fbb0 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -148,6 +148,7 @@ nvme_loop_timeout(struct request *rq, bool reserved)
 	/* fail with DNR on admin cmd timeout */
 	nvme_req(rq)->status = NVME_SC_ABORT_REQ | NVME_SC_DNR;
 
+	__blk_mq_complete_request(rq);
 	return BLK_EH_DONE;
 }
 
-- 
2.7.4
