From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 11/11] IB/srp: Fix a race condition triggered by destroying
 a queue pair
Date: Thu, 30 Oct 2014 14:50:03 +0100
Message-ID: <5452420B.2070206@acm.org>
References: <545240AE.6060009@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:46699 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468AbaJ3NuE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 09:50:04 -0400
In-Reply-To: <545240AE.6060009@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

At least LID reassignment can trigger a race condition in the SRP
initiator driver, namely the receive completion handler trying to
post a request on a QP during or after QP destruction and before
the CQ's have been destroyed. Avoid this race by modifying a QP
into the error state and by waiting until all receive completions
have been processed before destroying a QP.

Reported-by: Max Gurtuvoy <maxg@mellanox.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 59 +++++++++++++++++++++++++++++++------
 drivers/infiniband/ulp/srp/ib_srp.h |  2 ++
 2 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index c8b84a2..d3a5abe 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -453,6 +453,41 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
 				  dev->max_pages_per_mr);
 }
 
+/**
+ * srp_destroy_qp() - destroy an RDMA queue pair
+ * @ch: SRP RDMA channel.
+ *
+ * Change a queue pair into the error state and wait until all receive
+ * completions have been processed before destroying it. This avoids that
+ * the receive completion handler can access the queue pair while it is
+ * being destroyed.
+ */
+static void srp_destroy_qp(struct srp_rdma_ch *ch)
+{
+	struct srp_target_port *target = ch->target;
+	static struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
+	static struct ib_recv_wr wr = { .wr_id = SRP_LAST_WR_ID };
+	struct ib_recv_wr *bad_wr;
+	int ret;
+
+	/* Destroying a QP and reusing ch->done is only safe if not connected */
+	WARN_ON_ONCE(target->connected);
+
+	ret = ib_modify_qp(ch->qp, &attr, IB_QP_STATE);
+	WARN_ONCE(ret, "ib_cm_init_qp_attr() returned %d\n", ret);
+	if (ret)
+		goto out;
+
+	init_completion(&ch->done);
+	ret = ib_post_recv(ch->qp, &wr, &bad_wr);
+	WARN_ONCE(ret, "ib_post_recv() returned %d\n", ret);
+	if (ret == 0)
+		wait_for_completion(&ch->done);
+
+out:
+	ib_destroy_qp(ch->qp);
+}
+
 static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 {
 	struct srp_target_port *target = ch->target;
@@ -469,8 +504,9 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	if (!init_attr)
 		return -ENOMEM;
 
+	/* + 1 for SRP_LAST_WR_ID */
 	recv_cq = ib_create_cq(dev->dev, srp_recv_completion, NULL, ch,
-			       target->queue_size, ch->comp_vector);
+			       target->queue_size + 1, ch->comp_vector);
 	if (IS_ERR(recv_cq)) {
 		ret = PTR_ERR(recv_cq);
 		goto err;
@@ -487,7 +523,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 
 	init_attr->event_handler       = srp_qp_event;
 	init_attr->cap.max_send_wr     = m * target->queue_size;
-	init_attr->cap.max_recv_wr     = target->queue_size;
+	init_attr->cap.max_recv_wr     = target->queue_size + 1;
 	init_attr->cap.max_recv_sge    = 1;
 	init_attr->cap.max_send_sge    = 1;
 	init_attr->sq_sig_type         = IB_SIGNAL_REQ_WR;
@@ -530,7 +566,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	}
 
 	if (ch->qp)
-		ib_destroy_qp(ch->qp);
+		srp_destroy_qp(ch);
 	if (ch->recv_cq)
 		ib_destroy_cq(ch->recv_cq);
 	if (ch->send_cq)
@@ -586,7 +622,7 @@ static void srp_free_ch_ib(struct srp_target_port *target,
 		if (ch->fmr_pool)
 			ib_destroy_fmr_pool(ch->fmr_pool);
 	}
-	ib_destroy_qp(ch->qp);
+	srp_destroy_qp(ch);
 	ib_destroy_cq(ch->send_cq);
 	ib_destroy_cq(ch->recv_cq);
 
@@ -1883,8 +1919,15 @@ static void srp_tl_err_work(struct work_struct *work)
 }
 
 static void srp_handle_qp_err(u64 wr_id, enum ib_wc_status wc_status,
-			      bool send_err, struct srp_target_port *target)
+			      bool send_err, struct srp_rdma_ch *ch)
 {
+	struct srp_target_port *target = ch->target;
+
+	if (wr_id == SRP_LAST_WR_ID) {
+		complete(&ch->done);
+		return;
+	}
+
 	if (target->connected && !target->qp_in_error) {
 		if (wr_id & LOCAL_INV_WR_ID_MASK) {
 			shost_printk(KERN_ERR, target->scsi_host, PFX
@@ -1915,8 +1958,7 @@ static void srp_recv_completion(struct ib_cq *cq, void *ch_ptr)
 		if (likely(wc.status == IB_WC_SUCCESS)) {
 			srp_handle_recv(ch, &wc);
 		} else {
-			srp_handle_qp_err(wc.wr_id, wc.status, false,
-					  ch->target);
+			srp_handle_qp_err(wc.wr_id, wc.status, false, ch);
 		}
 	}
 }
@@ -1932,8 +1974,7 @@ static void srp_send_completion(struct ib_cq *cq, void *ch_ptr)
 			iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
 			list_add(&iu->list, &ch->free_tx);
 		} else {
-			srp_handle_qp_err(wc.wr_id, wc.status, true,
-					  ch->target);
+			srp_handle_qp_err(wc.wr_id, wc.status, true, ch);
 		}
 	}
 }
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index ca7c6f0..a611556 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -70,6 +70,8 @@ enum {
 
 	LOCAL_INV_WR_ID_MASK	= 1,
 	FAST_REG_WR_ID_MASK	= 2,
+
+	SRP_LAST_WR_ID		= 0xfffffffcU,
 };
 
 enum srp_target_state {
-- 
1.8.4.5

