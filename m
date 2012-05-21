From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH] srp: convert SRP_RQ_SHIFT into a module parameter
Date: Mon, 21 May 2012 17:49:38 +0200
Message-ID: <4FBA6412.7040505@itwm.fraunhofer.de>
References: <4FB39D78.9020300@itwm.fraunhofer.de>  <1337177200.2985.71.camel@dabdike.int.hansenpartnership.com>  <4FB3B9DE.1050903@itwm.fraunhofer.de> <4FB3C75F.3070903@cs.wisc.edu>  <4FB3CDC5.9040608@itwm.fraunhofer.de> <1337187813.21009.14.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:33599 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2EUPtn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2012 11:49:43 -0400
In-Reply-To: <1337187813.21009.14.camel@frustration.ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>

On 05/16/2012 07:03 PM, David Dillow wrote:
> On Wed, 2012-05-16 at 11:54 -0400, Bernd Schubert wrote:
>> 2) Low SRP command queues. Is there a reason why
>> SRP_RQ_SHIFT/SRP_RQ_SIZE and their depend values such as SRP_RQ_SIZE are
>> so small?
> 
> That's a decision that has been around since the beginning of the driver
> as far as I can tell. It looks to be a balance between device needs and
> memory usage, and it can certainly be raised -- I've run locally with
> SRP_RQ_SHIFT set to 7 (shost.can_queue 126) and I'm sure 8 would be no
> problem, either. I didn't see a performance improvement on my workload,
> but may you will.
> 
> Because we take the minimum of our initiator queue depth and the initial
> credits from the target (each req consumes a credit), going higher than
> 8 doesn't buy us much, as I don't know off-hand of any target that gives
> out more than 256 credits.
> 
> The memory used for the command ring will vary depending on the value of
> SRP_RQ_SHIFT and the number of s/g entries allows to be put in the
> command. 255 s/g entries requires an 8 KB allocation for each request
> (~4200 bytes), so we currently require 512 KB of buffers for the send
> queue for each target. Going to 8 will require 2 MB max per target,
> which probably isn't a real issue.
> 
> There's also a response ring with an allocation size that depends on the
> target, but those should be pretty small buffers, say 1 KB * (1<<
> SRP_RQ_SHIFT).
> 

David, below is a first version to convert SRP_RQ_SHIFT into a new 
module option "srp_rq_size". I already tested it, but I also need to 
re-read it myself.

Author: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Date:   Mon May 21 10:25:01 2012 +0200

    infiniband/srp: convert SRP_RQ_SHIFT into a module parameter
    
    When SRP_RQ_SHIFT is a fix parameter the optimal value is unclear.
    The current value of 6 might be too small for several storage systems
    and larger values might take too much memory for other systems.
    So make it a parameter and let the admin decide.
    
    Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0bfa545..67fa47f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -62,6 +62,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 static unsigned int srp_sg_tablesize;
 static unsigned int cmd_sg_entries;
 static unsigned int indirect_sg_entries;
+static unsigned int srp_rq_size, srp_sq_size, srp_cmd_sq_size;
 static bool allow_ext_sg;
 static int topspin_workarounds = 1;
 
@@ -76,6 +77,9 @@ module_param(indirect_sg_entries, uint, 0444);
 MODULE_PARM_DESC(indirect_sg_entries,
 		 "Default max number of gather/scatter entries (default is 12, max is " __stringify(SCSI_MAX_SG_CHAIN_SEGMENTS) ")");
 
+module_param(srp_rq_size, uint, 0444);
+MODULE_PARM_DESC(srp_sg_tablesize, "Request queue size (default is 64, max is " __stringify(SRP_RQ_MAX) ")");
+
 module_param(allow_ext_sg, bool, 0444);
 MODULE_PARM_DESC(allow_ext_sg,
 		  "Default behavior when there are more than cmd_sg_entries S/G entries after mapping; fails the request when false (default false)");
@@ -227,14 +231,14 @@ static int srp_create_target_ib(struct srp_target_port *target)
 		return -ENOMEM;
 
 	target->recv_cq = ib_create_cq(target->srp_host->srp_dev->dev,
-				       srp_recv_completion, NULL, target, SRP_RQ_SIZE, 0);
+				       srp_recv_completion, NULL, target, srp_rq_size, 0);
 	if (IS_ERR(target->recv_cq)) {
 		ret = PTR_ERR(target->recv_cq);
 		goto err;
 	}
 
 	target->send_cq = ib_create_cq(target->srp_host->srp_dev->dev,
-				       srp_send_completion, NULL, target, SRP_SQ_SIZE, 0);
+				       srp_send_completion, NULL, target, srp_sq_size, 0);
 	if (IS_ERR(target->send_cq)) {
 		ret = PTR_ERR(target->send_cq);
 		goto err_recv_cq;
@@ -243,8 +247,8 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	ib_req_notify_cq(target->recv_cq, IB_CQ_NEXT_COMP);
 
 	init_attr->event_handler       = srp_qp_event;
-	init_attr->cap.max_send_wr     = SRP_SQ_SIZE;
-	init_attr->cap.max_recv_wr     = SRP_RQ_SIZE;
+	init_attr->cap.max_send_wr     = srp_sq_size;
+	init_attr->cap.max_recv_wr     = srp_rq_size;
 	init_attr->cap.max_recv_sge    = 1;
 	init_attr->cap.max_send_sge    = 1;
 	init_attr->sq_sig_type         = IB_SIGNAL_ALL_WR;
@@ -287,9 +291,9 @@ static void srp_free_target_ib(struct srp_target_port *target)
 	ib_destroy_cq(target->send_cq);
 	ib_destroy_cq(target->recv_cq);
 
-	for (i = 0; i < SRP_RQ_SIZE; ++i)
+	for (i = 0; i < srp_rq_size; ++i)
 		srp_free_iu(target->srp_host, target->rx_ring[i]);
-	for (i = 0; i < SRP_SQ_SIZE; ++i)
+	for (i = 0; i < srp_sq_size; ++i)
 		srp_free_iu(target->srp_host, target->tx_ring[i]);
 }
 
@@ -460,7 +464,7 @@ static void srp_free_req_data(struct srp_target_port *target)
 	struct srp_request *req;
 	int i;
 
-	for (i = 0, req = target->req_ring; i < SRP_CMD_SQ_SIZE; ++i, ++req) {
+	for (i = 0, req = target->req_ring; i < srp_cmd_sq_size; ++i, ++req) {
 		kfree(req->fmr_list);
 		kfree(req->map_page);
 		if (req->indirect_dma_addr) {
@@ -472,6 +476,41 @@ static void srp_free_req_data(struct srp_target_port *target)
 	}
 }
 
+/**
+ * Free target rings
+ */
+static void srp_free_target_rings(struct srp_target_port *target)
+{
+	kfree(target->tx_ring);
+	kfree(target->rx_ring);
+	kfree(target->req_ring);
+}
+
+/**
+ * Target ring allocations with a size depending on module options
+ */
+static int srp_alloc_target_rings(struct srp_target_port *target)
+{
+	target->tx_ring = kzalloc(srp_sq_size * sizeof(**(target->tx_ring)), GFP_KERNEL);
+	if (!target->tx_ring)
+		return -ENOMEM;
+
+	target->rx_ring = kzalloc(srp_rq_size * sizeof(**(target->rx_ring)), GFP_KERNEL);
+	if (!target->rx_ring) {
+		kfree(target->tx_ring);
+		return -ENOMEM;
+	}
+
+	target->req_ring = kzalloc(srp_cmd_sq_size * sizeof(*(target->req_ring)), GFP_KERNEL);
+	if (!target->req_ring) {
+		kfree(target->tx_ring);
+		kfree(target->rx_ring);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static void srp_remove_work(struct work_struct *work)
 {
 	struct srp_target_port *target =
@@ -489,6 +528,7 @@ static void srp_remove_work(struct work_struct *work)
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
 	srp_free_req_data(target);
+	srp_free_target_rings(target);
 	scsi_host_put(target->scsi_host);
 }
 
@@ -620,14 +660,14 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	while (ib_poll_cq(target->send_cq, 1, &wc) > 0)
 		; /* nothing */
 
-	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
+	for (i = 0; i < srp_cmd_sq_size; ++i) {
 		struct srp_request *req = &target->req_ring[i];
 		if (req->scmnd)
 			srp_reset_req(target, req);
 	}
 
 	INIT_LIST_HEAD(&target->free_tx);
-	for (i = 0; i < SRP_SQ_SIZE; ++i)
+	for (i = 0; i < srp_sq_size; ++i)
 		list_add(&target->tx_ring[i]->list, &target->free_tx);
 
 	target->qp_in_error = 0;
@@ -969,7 +1009,7 @@ static void srp_put_tx_iu(struct srp_target_port *target, struct srp_iu *iu,
  * Note:
  * An upper limit for the number of allocated information units for each
  * request type is:
- * - SRP_IU_CMD: SRP_CMD_SQ_SIZE, since the SCSI mid-layer never queues
+ * - SRP_IU_CMD: srp_cmd_sq_size, since the SCSI mid-layer never queues
  *   more than Scsi_Host.can_queue requests.
  * - SRP_IU_TSK_MGMT: SRP_TSK_MGMT_SQ_SIZE.
  * - SRP_IU_RSP: 1, since a conforming SRP target never sends more than
@@ -1320,7 +1360,7 @@ static int srp_alloc_iu_bufs(struct srp_target_port *target)
 {
 	int i;
 
-	for (i = 0; i < SRP_RQ_SIZE; ++i) {
+	for (i = 0; i < srp_rq_size; ++i) {
 		target->rx_ring[i] = srp_alloc_iu(target->srp_host,
 						  target->max_ti_iu_len,
 						  GFP_KERNEL, DMA_FROM_DEVICE);
@@ -1328,7 +1368,7 @@ static int srp_alloc_iu_bufs(struct srp_target_port *target)
 			goto err;
 	}
 
-	for (i = 0; i < SRP_SQ_SIZE; ++i) {
+	for (i = 0; i < srp_sq_size; ++i) {
 		target->tx_ring[i] = srp_alloc_iu(target->srp_host,
 						  target->max_iu_len,
 						  GFP_KERNEL, DMA_TO_DEVICE);
@@ -1341,12 +1381,12 @@ static int srp_alloc_iu_bufs(struct srp_target_port *target)
 	return 0;
 
 err:
-	for (i = 0; i < SRP_RQ_SIZE; ++i) {
+	for (i = 0; i < srp_rq_size; ++i) {
 		srp_free_iu(target->srp_host, target->rx_ring[i]);
 		target->rx_ring[i] = NULL;
 	}
 
-	for (i = 0; i < SRP_SQ_SIZE; ++i) {
+	for (i = 0; i < srp_sq_size; ++i) {
 		srp_free_iu(target->srp_host, target->tx_ring[i]);
 		target->tx_ring[i] = NULL;
 	}
@@ -1401,7 +1441,7 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 	if (ret)
 		goto error_free;
 
-	for (i = 0; i < SRP_RQ_SIZE; i++) {
+	for (i = 0; i < srp_rq_size; i++) {
 		struct srp_iu *iu = target->rx_ring[i];
 		ret = srp_post_recv(target, iu);
 		if (ret)
@@ -1649,7 +1689,7 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 	if (target->tsk_mgmt_status)
 		return FAILED;
 
-	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
+	for (i = 0; i < srp_cmd_sq_size; ++i) {
 		struct srp_request *req = &target->req_ring[i];
 		if (req->scmnd && req->scmnd->device == scmnd->device)
 			srp_reset_req(target, req);
@@ -1841,9 +1881,9 @@ static struct scsi_host_template srp_template = {
 	.eh_device_reset_handler	= srp_reset_device,
 	.eh_host_reset_handler		= srp_reset_host,
 	.sg_tablesize			= SRP_DEF_SG_TABLESIZE,
-	.can_queue			= SRP_CMD_SQ_SIZE,
+	.can_queue			= SRP_CMD_SQ_DEF_SIZE,
 	.this_id			= -1,
-	.cmd_per_lun			= SRP_CMD_SQ_SIZE,
+	.cmd_per_lun			= SRP_CMD_SQ_DEF_SIZE,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= srp_host_attrs
 };
@@ -2034,7 +2074,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 				printk(KERN_WARNING PFX "bad max cmd_per_lun parameter '%s'\n", p);
 				goto out;
 			}
-			target->scsi_host->cmd_per_lun = min(token, SRP_CMD_SQ_SIZE);
+			target->scsi_host->cmd_per_lun = min_t(unsigned, token, srp_cmd_sq_size);
 			break;
 
 		case SRP_OPT_IO_CLASS:
@@ -2131,9 +2171,15 @@ static ssize_t srp_create_target(struct device *dev,
 	target_host->max_id      = 1;
 	target_host->max_lun     = SRP_MAX_LUN;
 	target_host->max_cmd_len = sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
+	target_host->can_queue   = srp_cmd_sq_size;
+	target_host->cmd_per_lun = srp_cmd_sq_size;
 
 	target = host_to_target(target_host);
 
+	ret = srp_alloc_target_rings(target);
+	if (ret)
+		goto err;
+
 	target->io_class	= SRP_REV16A_IB_IO_CLASS;
 	target->scsi_host	= target_host;
 	target->srp_host	= host;
@@ -2163,7 +2209,7 @@ static ssize_t srp_create_target(struct device *dev,
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
 	INIT_LIST_HEAD(&target->free_reqs);
-	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
+	for (i = 0; i < srp_cmd_sq_size; ++i) {
 		struct srp_request *req = &target->req_ring[i];
 
 		req->fmr_list = kmalloc(target->cmd_sg_cnt * sizeof (void *),
@@ -2435,6 +2481,7 @@ static void srp_remove_one(struct ib_device *device)
 			ib_destroy_cm_id(target->cm_id);
 			srp_free_target_ib(target);
 			srp_free_req_data(target);
+			srp_free_target_rings(target);
 			scsi_host_put(target->scsi_host);
 		}
 
@@ -2479,6 +2526,17 @@ static int __init srp_init_module(void)
 		indirect_sg_entries = cmd_sg_entries;
 	}
 
+	if (!srp_rq_size)
+		srp_rq_size = SRP_RQ_DEF_SIZE;
+
+	if (srp_rq_size > SRP_RQ_MAX) {
+		printk(KERN_WARNING PFX "Clamping srp_rq_size to %d\n", SRP_RQ_MAX);
+		srp_rq_size = SRP_RQ_MAX;
+	}
+
+	srp_sq_size     = srp_rq_size;
+	srp_cmd_sq_size = srp_sq_size - SRP_RSP_SQ_SIZE - SRP_TSK_MGMT_SQ_SIZE;
+
 	ib_srp_transport_template =
 		srp_attach_transport(&ib_srp_transport_functions);
 	if (!ib_srp_transport_template)
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 020caf0..f2195fd 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -57,14 +57,13 @@ enum {
 	SRP_MAX_LUN		= 512,
 	SRP_DEF_SG_TABLESIZE	= 12,
 
-	SRP_RQ_SHIFT    	= 6,
-	SRP_RQ_SIZE		= 1 << SRP_RQ_SHIFT,
+	SRP_RQ_DEF_SIZE		= 64,
+	SRP_SQ_DEF_SIZE		= SRP_RQ_DEF_SIZE,
+	SRP_RQ_MAX		= 1024,
 
-	SRP_SQ_SIZE		= SRP_RQ_SIZE,
 	SRP_RSP_SQ_SIZE		= 1,
-	SRP_REQ_SQ_SIZE		= SRP_SQ_SIZE - SRP_RSP_SQ_SIZE,
 	SRP_TSK_MGMT_SQ_SIZE	= 1,
-	SRP_CMD_SQ_SIZE		= SRP_REQ_SQ_SIZE - SRP_TSK_MGMT_SQ_SIZE,
+	SRP_CMD_SQ_DEF_SIZE     = SRP_SQ_DEF_SIZE - SRP_RSP_SQ_SIZE - SRP_TSK_MGMT_SQ_SIZE,
 
 	SRP_TAG_NO_REQ		= ~0U,
 	SRP_TAG_TSK_MGMT	= 1U << 31,
@@ -169,9 +168,9 @@ struct srp_target_port {
 
 	int			zero_req_lim;
 
-	struct srp_iu	       *tx_ring[SRP_SQ_SIZE];
-	struct srp_iu	       *rx_ring[SRP_RQ_SIZE];
-	struct srp_request	req_ring[SRP_CMD_SQ_SIZE];
+	struct srp_iu	      **tx_ring;  /* table of srp_sq_size */
+	struct srp_iu	      **rx_ring;  /* table of srp_rq_size */
+	struct srp_request     *req_ring; /* table of srp_cmd_sq_size */
 
 	struct work_struct	work;
 
