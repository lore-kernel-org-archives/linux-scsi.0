From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 14/14] ib_srpt: Convert to percpu_ida tag allocation
Date: Fri, 11 Mar 2016 06:30:10 +0000
Message-ID: <1457677810-2478-15-git-send-email-nab@daterainc.com>
References: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Felipe Balbi <felipe.balbi@linux.intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Vu Pham <vu@mellanox.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts ib_srpt to use existing percpu_ida tag
pre-allocation for struct srpt_send_ioctx.

This allows ib_srpt to drop it's internal pre-allocation
mechanisms with the extra spin_lock_irqsave, and use
percpu_ida common code for doing this.

Cc: Vu Pham <vu@mellanox.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 55 +++++++++++------------------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 --
 2 files changed, 17 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 72a671e..b0707a7 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1261,40 +1261,26 @@ free_mem:
  */
 static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 {
+	struct se_session *se_sess;
 	struct srpt_send_ioctx *ioctx;
-	unsigned long flags;
+	int tag;
 
 	BUG_ON(!ch);
+	se_sess = ch->sess;
 
-	ioctx = NULL;
-	spin_lock_irqsave(&ch->spinlock, flags);
-	if (!list_empty(&ch->free_list)) {
-		ioctx = list_first_entry(&ch->free_list,
-					 struct srpt_send_ioctx, free_list);
-		list_del(&ioctx->free_list);
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	if (tag < 0) {
+		pr_err("Unable to obtain tag for srpt_send_ioctx\n");
+		return NULL;
 	}
-	spin_unlock_irqrestore(&ch->spinlock, flags);
-
-	if (!ioctx)
-		return ioctx;
-
-	BUG_ON(ioctx->ch != ch);
+	ioctx = &((struct srpt_send_ioctx *)se_sess->sess_cmd_map)[tag];
+	memset(ioctx, 0, sizeof(struct srpt_send_ioctx));
+	ioctx->ch = ch;
 	spin_lock_init(&ioctx->spinlock);
 	ioctx->state = SRPT_STATE_NEW;
-	ioctx->n_rbuf = 0;
-	ioctx->rbufs = NULL;
-	ioctx->n_rdma = 0;
-	ioctx->n_rdma_wrs = 0;
-	ioctx->rdma_wrs = NULL;
-	ioctx->mapped_sg_count = 0;
 	init_completion(&ioctx->tx_done);
-	ioctx->queue_status_only = false;
-	/*
-	 * transport_init_se_cmd() does not initialize all fields, so do it
-	 * here.
-	 */
-	memset(&ioctx->cmd, 0, sizeof(ioctx->cmd));
-	memset(&ioctx->sense_data, 0, sizeof(ioctx->sense_data));
+
+	ioctx->cmd.map_tag = tag;
 
 	return ioctx;
 }
@@ -2241,7 +2227,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	struct ib_cm_rep_param *rep_param;
 	struct srpt_rdma_ch *ch, *tmp_ch;
 	u32 it_iu_len;
-	int i, ret = 0;
+	int ret = 0;
 	unsigned char *p;
 
 	WARN_ON_ONCE(irqs_disabled());
@@ -2370,12 +2356,6 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	if (!ch->ioctx_ring)
 		goto free_ch;
 
-	INIT_LIST_HEAD(&ch->free_list);
-	for (i = 0; i < ch->rq_size; i++) {
-		ch->ioctx_ring[i]->ch = ch;
-		list_add_tail(&ch->ioctx_ring[i]->free_list, &ch->free_list);
-	}
-
 	ret = srpt_create_ch_ib(ch);
 	if (ret) {
 		rej->reason = cpu_to_be32(
@@ -2406,7 +2386,8 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	p = &ch->sess_name[0];
 
 try_again:
-	ch->sess = target_alloc_session(&sport->port_tpg_1, 0, 0,
+	ch->sess = target_alloc_session(&sport->port_tpg_1, ch->rq_size,
+					sizeof(struct srpt_send_ioctx),
 					TARGET_PROT_NORMAL, p, ch, NULL);
 	if (IS_ERR(ch->sess)) {
 		pr_info("Rejected login because no ACL has been"
@@ -3194,7 +3175,7 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 	struct srpt_send_ioctx *ioctx = container_of(se_cmd,
 				struct srpt_send_ioctx, cmd);
 	struct srpt_rdma_ch *ch = ioctx->ch;
-	unsigned long flags;
+	struct se_session *se_sess = ch->sess;
 
 	WARN_ON(ioctx->state != SRPT_STATE_DONE);
 	WARN_ON(ioctx->mapped_sg_count != 0);
@@ -3205,9 +3186,7 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 		ioctx->n_rbuf = 0;
 	}
 
-	spin_lock_irqsave(&ch->spinlock, flags);
-	list_add(&ioctx->free_list, &ch->free_list);
-	spin_unlock_irqrestore(&ch->spinlock, flags);
+	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
 }
 
 /**
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 09037f2..6fbb6e7 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -179,7 +179,6 @@ struct srpt_recv_ioctx {
  * struct srpt_send_ioctx - SRPT send I/O context.
  * @ioctx:       See above.
  * @ch:          Channel pointer.
- * @free_list:   Node in srpt_rdma_ch.free_list.
  * @n_rbuf:      Number of data buffers in the received SRP command.
  * @rbufs:       Pointer to SRP data buffer array.
  * @single_rbuf: SRP data buffer if the command has only a single buffer.
@@ -202,7 +201,6 @@ struct srpt_send_ioctx {
 	struct srp_direct_buf	*rbufs;
 	struct srp_direct_buf	single_rbuf;
 	struct scatterlist	*sg;
-	struct list_head	free_list;
 	spinlock_t		spinlock;
 	enum srpt_command_state	state;
 	struct se_cmd		cmd;
-- 
1.9.1
