From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 10/12] IB/srp: Use block layer tags
Date: Tue, 07 Oct 2014 15:06:31 +0200
Message-ID: <5433E557.3010505@acm.org>
References: <5433E43D.3010107@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:52481 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaJGNGc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2014 09:06:32 -0400
In-Reply-To: <5433E43D.3010107@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

Since the block layer already contains functionality to assign
a tag to each request, use that functionality instead of
reimplementing that functionality in the SRP initiator driver.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 30 +++++++++++++++++++++++++-----
 drivers/infiniband/ulp/srp/ib_srp.h |  1 -
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index cc0bf83b..224ef25 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -853,7 +853,6 @@ static int srp_alloc_req_data(struct srp_rdma_ch *ch)
 			goto out;
 
 		req->indirect_dma_addr = dma_addr;
-		req->index = i;
 		list_add_tail(&req->list, &ch->free_reqs);
 	}
 	ret = 0;
@@ -1648,8 +1647,11 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 			ch->tsk_mgmt_status = rsp->data[3];
 		complete(&ch->tsk_mgmt_done);
 	} else {
-		req = &ch->req_ring[rsp->tag];
-		scmnd = srp_claim_req(ch, req, NULL, NULL);
+		scmnd = scsi_host_find_tag(target->scsi_host, rsp->tag);
+		if (scmnd) {
+			req = (void *)scmnd->host_scribble;
+			scmnd = srp_claim_req(ch, req, NULL, scmnd);
+		}
 		if (!scmnd) {
 			shost_printk(KERN_ERR, target->scsi_host,
 				     "Null scmnd for RSP w/tag %016llx\n",
@@ -1889,6 +1891,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	struct srp_cmd *cmd;
 	struct ib_device *dev;
 	unsigned long flags;
+	u32 tag;
 	int len, ret;
 	const bool in_scsi_eh = !in_interrupt() && current == shost->ehandler;
 
@@ -1905,6 +1908,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	if (unlikely(scmnd->result))
 		goto err;
 
+	tag = blk_mq_unique_tag(scmnd->request);
 	ch = &target->ch;
 
 	spin_lock_irqsave(&ch->lock, flags);
@@ -1927,7 +1931,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	cmd->opcode = SRP_CMD;
 	cmd->lun    = cpu_to_be64((u64) scmnd->device->lun << 48);
-	cmd->tag    = req->index;
+	cmd->tag    = tag;
 	memcpy(cmd->cdb, scmnd->cmnd, scmnd->cmd_len);
 
 	req->scmnd    = scmnd;
@@ -2409,6 +2413,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
 	struct srp_request *req = (struct srp_request *) scmnd->host_scribble;
+	u32 tag;
 	struct srp_rdma_ch *ch;
 	int ret;
 
@@ -2417,7 +2422,8 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	ch = &target->ch;
 	if (!req || !srp_claim_req(ch, req, NULL, scmnd))
 		return SUCCESS;
-	if (srp_send_tsk_mgmt(ch, req->index, scmnd->device->lun,
+	tag = blk_mq_unique_tag(scmnd->request);
+	if (srp_send_tsk_mgmt(ch, tag, scmnd->device->lun,
 			      SRP_TSK_ABORT_TASK) == 0)
 		ret = SUCCESS;
 	else if (target->rport->state == SRP_RPORT_LOST)
@@ -2463,6 +2469,15 @@ static int srp_reset_host(struct scsi_cmnd *scmnd)
 	return srp_reconnect_rport(target->rport) == 0 ? SUCCESS : FAILED;
 }
 
+static int srp_slave_alloc(struct scsi_device *sdev)
+{
+	sdev->tagged_supported = 1;
+
+	scsi_activate_tcq(sdev, sdev->queue_depth);
+
+	return 0;
+}
+
 static int srp_slave_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -2641,6 +2656,7 @@ static struct scsi_host_template srp_template = {
 	.module				= THIS_MODULE,
 	.name				= "InfiniBand SRP initiator",
 	.proc_name			= DRV_NAME,
+	.slave_alloc			= srp_slave_alloc,
 	.slave_configure		= srp_slave_configure,
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
@@ -3076,6 +3092,10 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err;
 
+	ret = scsi_init_shared_tag_map(target_host, target_host->can_queue);
+	if (ret)
+		goto err;
+
 	target->req_ring_size = target->queue_size - SRP_TSK_MGMT_SQ_SIZE;
 
 	if (!srp_conn_unique(target->srp_host, target)) {
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 74530d9..75e8f36 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -127,7 +127,6 @@ struct srp_request {
 	struct srp_direct_buf  *indirect_desc;
 	dma_addr_t		indirect_dma_addr;
 	short			nmdesc;
-	short			index;
 };
 
 /**
-- 
1.8.4.5

