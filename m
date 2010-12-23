From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 3/8] IB/srp: allow lockless work posting
Date: Thu, 23 Dec 2010 16:31:28 -0500
Message-ID: <1293139893-11678-4-git-send-email-dillowda@ornl.gov>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293139893-11678-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Only one CPU at a time will own an RX IU, so using the address of the IU
as the work request cookie allows us to avoid taking a lock. We can
similarly prepare the TX path for lockless posting by moving the free TX
IUs to a list. This also removes the requirement that the queue sizes be
a power of 2.

This is a break-out of Bart Van Assche's work, modified to avoid needing
an extra field in the IU.
---
 drivers/infiniband/ulp/srp/ib_srp.c |   66 ++++++++++++++--------------------
 drivers/infiniband/ulp/srp/ib_srp.h |    7 +---
 2 files changed, 29 insertions(+), 44 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a14975b..6d98217 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -568,7 +568,7 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	struct ib_qp_attr qp_attr;
 	struct srp_request *req, *tmp;
 	struct ib_wc wc;
-	int ret;
+	int i, ret;
 
 	if (!srp_change_state(target, SRP_TARGET_LIVE, SRP_TARGET_CONNECTING))
 		return -EAGAIN;
@@ -601,9 +601,9 @@ static int srp_reconnect_target(struct srp_target_port *target)
 		srp_reset_req(target, req);
 	spin_unlock_irq(target->scsi_host->host_lock);
 
-	target->rx_head	 = 0;
-	target->tx_head	 = 0;
-	target->tx_tail  = 0;
+	list_del_init(&target->free_tx);
+	for (i = 0; i < SRP_SQ_SIZE; ++i)
+		list_move(&target->tx_ring[i]->list, &target->free_tx);
 
 	target->qp_in_error = 0;
 	ret = srp_connect_target(target);
@@ -817,7 +817,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 
 /*
  * Must be called with target->scsi_host->host_lock held to protect
- * req_lim and tx_head.  Lock cannot be dropped between call here and
+ * req_lim and free_tx.  Lock cannot be dropped between call here and
  * call to __srp_post_send().
  *
  * Note:
@@ -837,7 +837,7 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 
 	srp_send_completion(target->send_cq, target);
 
-	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
+	if (list_empty(&target->free_tx))
 		return NULL;
 
 	/* Initiator responses to target requests do not consume credits */
@@ -846,14 +846,14 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 		return NULL;
 	}
 
-	iu = target->tx_ring[target->tx_head & SRP_SQ_MASK];
+	iu = list_first_entry(&target->free_tx, struct srp_iu, list);
 	iu->type = iu_type;
 	return iu;
 }
 
 /*
  * Must be called with target->scsi_host->host_lock held to protect
- * req_lim and tx_head.
+ * req_lim and free_tx.
  */
 static int __srp_post_send(struct srp_target_port *target,
 			   struct srp_iu *iu, int len)
@@ -867,7 +867,7 @@ static int __srp_post_send(struct srp_target_port *target,
 	list.lkey   = target->srp_host->srp_dev->mr->lkey;
 
 	wr.next       = NULL;
-	wr.wr_id      = target->tx_head & SRP_SQ_MASK;
+	wr.wr_id      = (uintptr_t) iu;
 	wr.sg_list    = &list;
 	wr.num_sge    = 1;
 	wr.opcode     = IB_WR_SEND;
@@ -876,7 +876,7 @@ static int __srp_post_send(struct srp_target_port *target,
 	ret = ib_post_send(target->qp, &wr, &bad_wr);
 
 	if (!ret) {
-		++target->tx_head;
+		list_del_init(&iu->list);
 		if (iu->type != SRP_IU_RSP)
 			--target->req_lim;
 	}
@@ -884,36 +884,21 @@ static int __srp_post_send(struct srp_target_port *target,
 	return ret;
 }
 
-static int srp_post_recv(struct srp_target_port *target)
+static int srp_post_recv(struct srp_target_port *target, struct srp_iu *iu)
 {
-	unsigned long flags;
-	struct srp_iu *iu;
-	struct ib_sge list;
 	struct ib_recv_wr wr, *bad_wr;
-	unsigned int next;
-	int ret;
-
-	spin_lock_irqsave(target->scsi_host->host_lock, flags);
-
-	next	 = target->rx_head & SRP_RQ_MASK;
-	wr.wr_id = next;
-	iu	 = target->rx_ring[next];
+	struct ib_sge list;
 
 	list.addr   = iu->dma;
 	list.length = iu->size;
 	list.lkey   = target->srp_host->srp_dev->mr->lkey;
 
 	wr.next     = NULL;
+	wr.wr_id    = (uintptr_t) iu;
 	wr.sg_list  = &list;
 	wr.num_sge  = 1;
 
-	ret = ib_post_recv(target->qp, &wr, &bad_wr);
-	if (!ret)
-		++target->rx_head;
-
-	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
-
-	return ret;
+	return ib_post_recv(target->qp, &wr, &bad_wr);
 }
 
 static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
@@ -1030,14 +1015,11 @@ static void srp_process_aer_req(struct srp_target_port *target,
 
 static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 {
-	struct ib_device *dev;
-	struct srp_iu *iu;
+	struct ib_device *dev = target->srp_host->srp_dev->dev;
+	struct srp_iu *iu = (struct srp_iu *) wc->wr_id;
 	int res;
 	u8 opcode;
 
-	iu = target->rx_ring[wc->wr_id];
-
-	dev = target->srp_host->srp_dev->dev;
 	ib_dma_sync_single_for_cpu(dev, iu->dma, target->max_ti_iu_len,
 				   DMA_FROM_DEVICE);
 
@@ -1078,7 +1060,7 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 	ib_dma_sync_single_for_device(dev, iu->dma, target->max_ti_iu_len,
 				      DMA_FROM_DEVICE);
 
-	res = srp_post_recv(target);
+	res = srp_post_recv(target, iu);
 	if (res != 0)
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "Recv failed with error code %d\n", res);
@@ -1107,6 +1089,7 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 {
 	struct srp_target_port *target = target_ptr;
 	struct ib_wc wc;
+	struct srp_iu *iu;
 
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
 		if (wc.status) {
@@ -1117,7 +1100,8 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 			break;
 		}
 
-		++target->tx_tail;
+		iu = (struct srp_iu *) wc.wr_id;
+		list_add(&iu->list, &target->free_tx);
 	}
 }
 
@@ -1212,6 +1196,9 @@ static int srp_alloc_iu_bufs(struct srp_target_port *target)
 						  GFP_KERNEL, DMA_TO_DEVICE);
 		if (!target->tx_ring[i])
 			goto err;
+
+		INIT_LIST_HEAD(&target->tx_ring[i]->list);
+		list_add(&target->tx_ring[i]->list, &target->free_tx);
 	}
 
 	return 0;
@@ -1373,7 +1360,8 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 			break;
 
 		for (i = 0; i < SRP_RQ_SIZE; i++) {
-			target->status = srp_post_recv(target);
+			struct srp_iu *iu = target->rx_ring[i];
+			target->status = srp_post_recv(target, iu);
 			if (target->status)
 				break;
 		}
@@ -1965,6 +1953,7 @@ static ssize_t srp_create_target(struct device *dev,
 	target->scsi_host  = target_host;
 	target->srp_host   = host;
 
+	INIT_LIST_HEAD(&target->free_tx);
 	INIT_LIST_HEAD(&target->free_reqs);
 	INIT_LIST_HEAD(&target->req_queue);
 	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
@@ -2235,8 +2224,7 @@ static int __init srp_init_module(void)
 {
 	int ret;
 
-	BUILD_BUG_ON_NOT_POWER_OF_2(SRP_SQ_SIZE);
-	BUILD_BUG_ON_NOT_POWER_OF_2(SRP_RQ_SIZE);
+	BUILD_BUG_ON(FIELD_SIZEOF(struct ib_wc, wr_id) < sizeof(void *));
 
 	if (srp_sg_tablesize > 255) {
 		printk(KERN_WARNING PFX "Clamping srp_sg_tablesize to 255\n");
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index c923731..0db525e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -59,10 +59,8 @@ enum {
 
 	SRP_RQ_SHIFT    	= 6,
 	SRP_RQ_SIZE		= 1 << SRP_RQ_SHIFT,
-	SRP_RQ_MASK		= SRP_RQ_SIZE - 1,
 
 	SRP_SQ_SIZE		= SRP_RQ_SIZE,
-	SRP_SQ_MASK		= SRP_SQ_SIZE - 1,
 	SRP_RSP_SQ_SIZE		= 1,
 	SRP_REQ_SQ_SIZE		= SRP_SQ_SIZE - SRP_RSP_SQ_SIZE,
 	SRP_TSK_MGMT_SQ_SIZE	= 1,
@@ -144,11 +142,9 @@ struct srp_target_port {
 
 	int			zero_req_lim;
 
-	unsigned		rx_head;
 	struct srp_iu	       *rx_ring[SRP_RQ_SIZE];
 
-	unsigned		tx_head;
-	unsigned		tx_tail;
+	struct list_head	free_tx;
 	struct srp_iu	       *tx_ring[SRP_SQ_SIZE];
 
 	struct list_head	free_reqs;
@@ -168,6 +164,7 @@ struct srp_target_port {
 };
 
 struct srp_iu {
+	struct list_head	list;
 	u64			dma;
 	void		       *buf;
 	size_t			size;
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
