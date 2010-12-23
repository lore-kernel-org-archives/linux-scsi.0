From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 8/8] IB/srp: consolidate hot-path variables into cache lines
Date: Thu, 23 Dec 2010 16:31:33 -0500
Message-ID: <1293139893-11678-9-git-send-email-dillowda@ornl.gov>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293139893-11678-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Put the variables accessed together in the hot-path into common
cachelines, and separate them by RW vs RO to avoid false dirtying.
We keep a local copy of the lkey and rkey in the target to avoid
traversing pointers (and associated cache lines) to find them.
---
 drivers/infiniband/ulp/srp/ib_srp.c |   12 +++++++-----
 drivers/infiniband/ulp/srp/ib_srp.h |   31 +++++++++++++++++++------------
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index fff72c8..cef6191 100644
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
@@ -1953,6 +1953,8 @@ static ssize_t srp_create_target(struct device *dev,
 	target->io_class   = SRP_REV16A_IB_IO_CLASS;
 	target->scsi_host  = target_host;
 	target->srp_host   = host;
+	target->lkey	   = host->srp_dev->mr->lkey;
+	target->rkey	   = host->srp_dev->mr->rkey;
 
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index c4699ea..43f9129 100644
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
+	struct ib_cq	       *send_cq ____cacheline_aligned;
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
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
