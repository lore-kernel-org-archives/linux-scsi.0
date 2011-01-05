From: David Dillow <dillowda@ornl.gov>
Subject: [PATCH v2 8/8] IB/srp: consolidate hot-path variables into cache lines
Date: Wed,  5 Jan 2011 15:35:16 -0500
Message-ID: <1294259716-30706-9-git-send-email-dillowda@ornl.gov>
References: <1294259716-30706-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from amavis-outgoing2.knology.net ([24.214.64.231]:50726 "EHLO
	amavis-outgoing2.knology.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802Ab1AEUfY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2011 15:35:24 -0500
In-Reply-To: <1294259716-30706-1-git-send-email-dillowda@ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org

Put the variables accessed together in the hot-path into common
cachelines, and separate them by RW vs RO to avoid false dirtying.
We keep a local copy of the lkey and rkey in the target to avoid
traversing pointers (and associated cache lines) to find them.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: David Dillow <dillowda@ornl.gov>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   12 +++++++-----
 drivers/infiniband/ulp/srp/ib_srp.h |   31 +++++++++++++++++++------------
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2f62367..7dcefe4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -768,7 +768,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 		struct srp_direct_buf *buf = (void *) cmd->add_data;
 
 		buf->va  = cpu_to_be64(ib_sg_dma_address(ibdev, scat));
-		buf->key = cpu_to_be32(dev->mr->rkey);
+		buf->key = cpu_to_be32(target->rkey);
 		buf->len = cpu_to_be32(ib_sg_dma_len(ibdev, scat));
 	} else if (srp_map_fmr(target, scat, count, req,
 			       (void *) cmd->add_data)) {
@@ -793,7 +793,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 			buf->desc_list[i].va  =
 				cpu_to_be64(ib_sg_dma_address(ibdev, sg));
 			buf->desc_list[i].key =
-				cpu_to_be32(dev->mr->rkey);
+				cpu_to_be32(target->rkey);
 			buf->desc_list[i].len = cpu_to_be32(dma_len);
 			datalen += dma_len;
 		}
@@ -806,7 +806,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 		buf->table_desc.va  =
 			cpu_to_be64(req->cmd->dma + sizeof *cmd + sizeof *buf);
 		buf->table_desc.key =
-			cpu_to_be32(target->srp_host->srp_dev->mr->rkey);
+			cpu_to_be32(target->rkey);
 		buf->table_desc.len =
 			cpu_to_be32(count * sizeof (struct srp_direct_buf));
 
@@ -883,7 +883,7 @@ static int srp_post_send(struct srp_target_port *target,
 
 	list.addr   = iu->dma;
 	list.length = len;
-	list.lkey   = target->srp_host->srp_dev->mr->lkey;
+	list.lkey   = target->lkey;
 
 	wr.next       = NULL;
 	wr.wr_id      = (uintptr_t) iu;
@@ -902,7 +902,7 @@ static int srp_post_recv(struct srp_target_port *target, struct srp_iu *iu)
 
 	list.addr   = iu->dma;
 	list.length = iu->size;
-	list.lkey   = target->srp_host->srp_dev->mr->lkey;
+	list.lkey   = target->lkey;
 
 	wr.next     = NULL;
 	wr.wr_id    = (uintptr_t) iu;
@@ -1955,6 +1955,8 @@ static ssize_t srp_create_target(struct device *dev,
 	target->io_class   = SRP_REV16A_IB_IO_CLASS;
 	target->scsi_host  = target_host;
 	target->srp_host   = host;
+	target->lkey	   = host->srp_dev->mr->lkey;
+	target->rkey	   = host->srp_dev->mr->rkey;
 
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index acb435d..9dc6fc3 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -117,6 +117,24 @@ struct srp_request {
 };
 
 struct srp_target_port {
+	/* These are RW in the hot path, and commonly used together */
+	struct list_head	free_tx;
+	struct list_head	free_reqs;
+	spinlock_t		lock;
+	s32			req_lim;
+
+	/* These are read-only in the hot path */
+	struct ib_cq	       *send_cq ____cacheline_aligned_in_smp;
+	struct ib_cq	       *recv_cq;
+	struct ib_qp	       *qp;
+	u32			lkey;
+	u32			rkey;
+	enum srp_target_state	state;
+
+	/* Everything above this point is used in the hot path of
+	 * command processing. Try to keep them packed into cachelines.
+	 */
+
 	__be64			id_ext;
 	__be64			ioc_guid;
 	__be64			service_id;
@@ -133,23 +151,13 @@ struct srp_target_port {
 	int			path_query_id;
 
 	struct ib_cm_id	       *cm_id;
-	struct ib_cq	       *recv_cq;
-	struct ib_cq	       *send_cq;
-	struct ib_qp	       *qp;
 
 	int			max_ti_iu_len;
-	s32			req_lim;
 
 	int			zero_req_lim;
 
-	struct srp_iu	       *rx_ring[SRP_RQ_SIZE];
-
-	spinlock_t		lock;
-
-	struct list_head	free_tx;
 	struct srp_iu	       *tx_ring[SRP_SQ_SIZE];
-
-	struct list_head	free_reqs;
+	struct srp_iu	       *rx_ring[SRP_RQ_SIZE];
 	struct srp_request	req_ring[SRP_CMD_SQ_SIZE];
 
 	struct work_struct	work;
@@ -157,7 +165,6 @@ struct srp_target_port {
 	struct list_head	list;
 	struct completion	done;
 	int			status;
-	enum srp_target_state	state;
 	int			qp_in_error;
 
 	struct completion	tsk_mgmt_done;
-- 
1.7.3.4

