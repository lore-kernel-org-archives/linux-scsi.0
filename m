From: Christoph Hellwig <hch@bombadil.infradead.org>
Subject: nvme: split nvme status from block req->errors
Date: Tue, 18 Apr 2017 08:52:09 -0700
Message-ID: <20170418155229.5977-4-hch@bombadil.infradead.org>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170418155229.5977-1-hch@bombadil.infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

We want our own clearly defined error field for NVMe passthrough commands,
and the request errors field is going away in its current form.

Just store the status and result field in the nvme_request field from
hardirq completion context (using a new helper) and then generate a
Linux errno for the block layer only when we actually need it.

Because we can't overload the status value with a negative error code
for cancelled command we now have a flags filed in struct nvme_request
that contains a bit for this condition.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/nvme/host/core.c     | 50 +++++++++++++++++++++++++++-----------------
 drivers/nvme/host/fc.c       | 10 ++++-----
 drivers/nvme/host/lightnvm.c |  9 +++++---
 drivers/nvme/host/nvme.h     | 33 +++++++++++++----------------
 drivers/nvme/host/pci.c      | 11 +++++-----
 drivers/nvme/host/rdma.c     |  5 ++---
 drivers/nvme/target/loop.c   |  7 ++-----
 7 files changed, 65 insertions(+), 60 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d33f829c3ab7..c6f256d74b6b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -66,11 +66,24 @@ static DEFINE_SPINLOCK(dev_list_lock);
 
 static struct class *nvme_class;
 
+int nvme_error_status(struct request *req)
+{
+	switch (nvme_req(req)->status & 0x7ff) {
+	case NVME_SC_SUCCESS:
+		return 0;
+	case NVME_SC_CAP_EXCEEDED:
+		return -ENOSPC;
+	default:
+		return -EIO;
+	}
+}
+EXPORT_SYMBOL_GPL(nvme_error_status);
+
 static inline bool nvme_req_needs_retry(struct request *req)
 {
 	if (blk_noretry_request(req))
 		return false;
-	if (req->errors & NVME_SC_DNR)
+	if (nvme_req(req)->status & NVME_SC_DNR)
 		return false;
 	if (jiffies - req->start_time >= req->timeout)
 		return false;
@@ -81,23 +94,13 @@ static inline bool nvme_req_needs_retry(struct request *req)
 
 void nvme_complete_rq(struct request *req)
 {
-	int error = 0;
-
-	if (unlikely(req->errors)) {
-		if (nvme_req_needs_retry(req)) {
-			nvme_req(req)->retries++;
-			blk_mq_requeue_request(req,
-					!blk_mq_queue_stopped(req->q));
-			return;
-		}
-
-		if (blk_rq_is_passthrough(req))
-			error = req->errors;
-		else
-			error = nvme_error_status(req->errors);
+	if (unlikely(nvme_req(req)->status && nvme_req_needs_retry(req))) {
+		nvme_req(req)->retries++;
+		blk_mq_requeue_request(req, !blk_mq_queue_stopped(req->q));
+		return;
 	}
 
-	blk_mq_end_request(req, error);
+	blk_mq_end_request(req, nvme_error_status(req));
 }
 EXPORT_SYMBOL_GPL(nvme_complete_rq);
 
@@ -114,7 +117,9 @@ void nvme_cancel_request(struct request *req, void *data, bool reserved)
 	status = NVME_SC_ABORT_REQ;
 	if (blk_queue_dying(req->q))
 		status |= NVME_SC_DNR;
-	blk_mq_complete_request(req, status);
+	nvme_req(req)->status = status;
+	blk_mq_complete_request(req, 0);
+
 }
 EXPORT_SYMBOL_GPL(nvme_cancel_request);
 
@@ -357,6 +362,7 @@ int nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 
 	if (!(req->rq_flags & RQF_DONTPREP)) {
 		nvme_req(req)->retries = 0;
+		nvme_req(req)->flags = 0;
 		req->rq_flags |= RQF_DONTPREP;
 	}
 
@@ -413,7 +419,10 @@ int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 	blk_execute_rq(req->q, NULL, req, at_head);
 	if (result)
 		*result = nvme_req(req)->result;
-	ret = req->errors;
+	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
+		ret = -EINTR;
+	else
+		ret = nvme_req(req)->status;
  out:
 	blk_mq_free_request(req);
 	return ret;
@@ -498,7 +507,10 @@ int __nvme_submit_user_cmd(struct request_queue *q, struct nvme_command *cmd,
 	}
  submit:
 	blk_execute_rq(req->q, disk, req, 0);
-	ret = req->errors;
+	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
+		ret = -EINTR;
+	else
+		ret = nvme_req(req)->status;
 	if (result)
 		*result = le32_to_cpu(nvme_req(req)->result.u32);
 	if (meta && !ret && !write) {
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index aad7f9c0be32..450733c8cd24 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1148,6 +1148,7 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 	struct nvme_fc_queue *queue = op->queue;
 	struct nvme_completion *cqe = &op->rsp_iu.cqe;
 	__le16 status = cpu_to_le16(NVME_SC_SUCCESS << 1);
+	union nvme_result result;
 
 	/*
 	 * WARNING:
@@ -1215,7 +1216,7 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 			status = cpu_to_le16(NVME_SC_FC_TRANSPORT_ERROR << 1);
 			goto done;
 		}
-		op->nreq.result.u64 = 0;
+		result.u64 = 0;
 		break;
 
 	case sizeof(struct nvme_fc_ersp_iu):
@@ -1232,7 +1233,7 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 			status = cpu_to_le16(NVME_SC_FC_TRANSPORT_ERROR << 1);
 			goto done;
 		}
-		op->nreq.result = cqe->result;
+		result = cqe->result;
 		status = cqe->status;
 		break;
 
@@ -1243,13 +1244,12 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 
 done:
 	if (!queue->qnum && op->rqno >= AEN_CMDID_BASE) {
-		nvme_complete_async_event(&queue->ctrl->ctrl, status,
-					&op->nreq.result);
+		nvme_complete_async_event(&queue->ctrl->ctrl, status, &result);
 		nvme_fc_ctrl_put(ctrl);
 		return;
 	}
 
-	blk_mq_complete_request(rq, le16_to_cpu(status) >> 1);
+	nvme_end_request(rq, status, result);
 }
 
 static int
diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.c
index 4b78090518e1..f85e6e57d641 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -484,7 +484,7 @@ static void nvme_nvm_end_io(struct request *rq, int error)
 	struct nvm_rq *rqd = rq->end_io_data;
 
 	rqd->ppa_status = nvme_req(rq)->result.u64;
-	rqd->error = error;
+	rqd->error = nvme_req(rq)->status;
 	nvm_end_io(rqd);
 
 	kfree(nvme_req(rq)->cmd);
@@ -669,9 +669,12 @@ static int nvme_nvm_submit_user_cmd(struct request_queue *q,
 
 	wait_for_completion_io(&wait);
 
-	ret = nvme_error_status(rq->errors);
+	if (nvme_req(rq)->flags & NVME_REQ_CANCELLED)
+		ret = -EINTR;
+	else
+		ret = nvme_error_status(rq);
 	if (result)
-		*result = rq->errors & 0x7ff;
+		*result = nvme_req(rq)->status & 0x7ff;
 	if (status)
 		*status = le64_to_cpu(nvme_req(rq)->result.u64);
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index a317461c21d3..d7330f75632d 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -21,16 +21,6 @@
 #include <linux/lightnvm.h>
 #include <linux/sed-opal.h>
 
-enum {
-	/*
-	 * Driver internal status code for commands that were cancelled due
-	 * to timeouts or controller shutdown.  The value is negative so
-	 * that it a) doesn't overlap with the unsigned hardware error codes,
-	 * and b) can easily be tested for.
-	 */
-	NVME_SC_CANCELLED		= -EINTR,
-};
-
 extern unsigned char nvme_io_timeout;
 #define NVME_IO_TIMEOUT	(nvme_io_timeout * HZ)
 
@@ -91,6 +81,12 @@ struct nvme_request {
 	struct nvme_command	*cmd;
 	union nvme_result	result;
 	u8			retries;
+	u8			flags;
+	u16			status;
+};
+
+enum {
+	NVME_REQ_CANCELLED		= (1 << 0),
 };
 
 static inline struct nvme_request *nvme_req(struct request *req)
@@ -248,18 +244,17 @@ static inline void nvme_cleanup_cmd(struct request *req)
 	}
 }
 
-static inline int nvme_error_status(u16 status)
+static inline void nvme_end_request(struct request *req, __le16 status,
+		union nvme_result result)
 {
-	switch (status & 0x7ff) {
-	case NVME_SC_SUCCESS:
-		return 0;
-	case NVME_SC_CAP_EXCEEDED:
-		return -ENOSPC;
-	default:
-		return -EIO;
-	}
+	struct nvme_request *rq = nvme_req(req);
+
+	rq->status = le16_to_cpu(status) >> 1;
+	rq->result = result;
+	blk_mq_complete_request(req, 0);
 }
 
+int nvme_error_status(struct request *req);
 void nvme_complete_rq(struct request *req);
 void nvme_cancel_request(struct request *req, void *data, bool reserved);
 bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index f7a9f3fb5fdb..d9e2bd07ed56 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -679,8 +679,7 @@ static void __nvme_process_cq(struct nvme_queue *nvmeq, unsigned int *tag)
 		}
 
 		req = blk_mq_tag_to_rq(*nvmeq->tags, cqe.command_id);
-		nvme_req(req)->result = cqe.result;
-		blk_mq_complete_request(req, le16_to_cpu(cqe.status) >> 1);
+		nvme_end_request(req, cqe.status, cqe.result);
 	}
 
 	if (head == nvmeq->cq_head && phase == nvmeq->cq_phase)
@@ -817,9 +816,9 @@ static void abort_endio(struct request *req, int error)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 	struct nvme_queue *nvmeq = iod->nvmeq;
-	u16 status = req->errors;
 
-	dev_warn(nvmeq->dev->ctrl.device, "Abort status: 0x%x", status);
+	dev_warn(nvmeq->dev->ctrl.device,
+		 "Abort status: 0x%x", nvme_req(req)->status);
 	atomic_inc(&nvmeq->dev->ctrl.abort_limit);
 	blk_mq_free_request(req);
 }
@@ -843,7 +842,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 			 "I/O %d QID %d timeout, disable controller\n",
 			 req->tag, nvmeq->qid);
 		nvme_dev_disable(dev, false);
-		req->errors = NVME_SC_CANCELLED;
+		nvme_req(req)->flags |= NVME_REQ_CANCELLED;
 		return BLK_EH_HANDLED;
 	}
 
@@ -863,7 +862,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 		 * Mark the request as handled, since the inline shutdown
 		 * forces all outstanding requests to complete.
 		 */
-		req->errors = NVME_SC_CANCELLED;
+		nvme_req(req)->flags |= NVME_REQ_CANCELLED;
 		return BLK_EH_HANDLED;
 	}
 
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 4aae363943e3..53b611f9ba5d 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1178,8 +1178,7 @@ static int nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 	    wc->ex.invalidate_rkey == req->mr->rkey)
 		req->mr->need_inval = false;
 
-	req->req.result = cqe->result;
-	blk_mq_complete_request(rq, le16_to_cpu(cqe->status) >> 1);
+	nvme_end_request(rq, cqe->status, cqe->result);
 	return ret;
 }
 
@@ -1416,7 +1415,7 @@ nvme_rdma_timeout(struct request *rq, bool reserved)
 	nvme_rdma_error_recovery(req->queue->ctrl);
 
 	/* fail with DNR on cmd timeout */
-	rq->errors = NVME_SC_ABORT_REQ | NVME_SC_DNR;
+	nvme_req(rq)->status = NVME_SC_ABORT_REQ | NVME_SC_DNR;
 
 	return BLK_EH_HANDLED;
 }
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 33b431e4eec3..8260ee1f8e48 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -124,7 +124,6 @@ static void nvme_loop_queue_response(struct nvmet_req *req)
 				&cqe->result);
 	} else {
 		struct request *rq;
-		struct nvme_loop_iod *iod;
 
 		rq = blk_mq_tag_to_rq(nvme_loop_tagset(queue), cqe->command_id);
 		if (!rq) {
@@ -134,9 +133,7 @@ static void nvme_loop_queue_response(struct nvmet_req *req)
 			return;
 		}
 
-		iod = blk_mq_rq_to_pdu(rq);
-		iod->nvme_req.result = cqe->result;
-		blk_mq_complete_request(rq, le16_to_cpu(cqe->status) >> 1);
+		nvme_end_request(rq, cqe->status, cqe->result);
 	}
 }
 
@@ -157,7 +154,7 @@ nvme_loop_timeout(struct request *rq, bool reserved)
 	schedule_work(&iod->queue->ctrl->reset_work);
 
 	/* fail with DNR on admin cmd timeout */
-	rq->errors = NVME_SC_ABORT_REQ | NVME_SC_DNR;
+	nvme_req(rq)->status = NVME_SC_ABORT_REQ | NVME_SC_DNR;
 
 	return BLK_EH_HANDLED;
 }
-- 
2.11.0
