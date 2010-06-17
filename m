From: kxie@chelsio.com
Subject: [PATCH] cxgb3i: zero out reserved or un-used cpl message fields
Date: Wed, 16 Jun 2010 17:10:37 -0700
Message-ID: <201006170010.o5H0AbuU023969@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:21063 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab0FQALL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 20:11:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: rranjan@chelsio.com, kxie@chelsio.com, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

[PATCH] cxgb3i: zero out reserved or un-used fields.

From: Karen Xie <kxie@chelsio.com>

Zero out the reserved or un-used CPL message fields to prevent any garbage
value.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgb3i/cxgb3i_ddp.c     |    2 ++
 drivers/scsi/cxgb3i/cxgb3i_offload.c |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index b58d913..be0e230 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -499,6 +499,7 @@ static int setup_conn_pgidx(struct t3cdev *tdev, unsigned int tid, int pg_idx,
 	/* set up ulp submode and page size */
 	req = (struct cpl_set_tcb_field *)skb_put(skb, sizeof(*req));
 	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
+	req->wr.wr_lo = 0;
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, tid));
 	req->reply = V_NO_REPLY(reply ? 0 : 1);
 	req->cpu_idx = 0;
@@ -564,6 +565,7 @@ int cxgb3i_setup_conn_digest(struct t3cdev *tdev, unsigned int tid,
 	/* set up ulp submode and page size */
 	req = (struct cpl_set_tcb_field *)skb_put(skb, sizeof(*req));
 	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
+	req->wr.wr_lo = 0;
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, tid));
 	req->reply = V_NO_REPLY(reply ? 0 : 1);
 	req->cpu_idx = 0;
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index a175be9..246a6c2 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -264,6 +264,7 @@ static void make_act_open_req(struct s3_conn *c3cn, struct sk_buff *skb,
 	skb->priority = CPL_PRIORITY_SETUP;
 	req = (struct cpl_act_open_req *)__skb_put(skb, sizeof(*req));
 	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
+	req->wr.wr_lo = 0;
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_ACT_OPEN_REQ, atid));
 	req->local_port = c3cn->saddr.sin_port;
 	req->peer_port = c3cn->daddr.sin_port;
@@ -273,6 +274,7 @@ static void make_act_open_req(struct s3_conn *c3cn, struct sk_buff *skb,
 			   V_TX_CHANNEL(e->smt_idx));
 	req->opt0l = htonl(calc_opt0l(c3cn));
 	req->params = 0;
+	req->opt2 = 0;
 }
 
 static void fail_act_open(struct s3_conn *c3cn, int errno)
@@ -379,6 +381,7 @@ static void send_abort_req(struct s3_conn *c3cn)
 
 	c3cn->cpl_abort_req = NULL;
 	req = (struct cpl_abort_req *)skb->head;
+	memset(req, 0, sizeof(*req));
 
 	skb->priority = CPL_PRIORITY_DATA;
 	set_arp_failure_handler(skb, abort_arp_failure);
@@ -406,6 +409,7 @@ static void send_abort_rpl(struct s3_conn *c3cn, int rst_status)
 	c3cn->cpl_abort_rpl = NULL;
 
 	skb->priority = CPL_PRIORITY_DATA;
+	memset(rpl, 0, sizeof(*rpl));
 	rpl->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_OFLD_HOST_ABORT_CON_RPL));
 	rpl->wr.wr_lo = htonl(V_WR_TID(c3cn->tid));
 	OPCODE_TID(rpl) = htonl(MK_OPCODE_TID(CPL_ABORT_RPL, c3cn->tid));
@@ -430,6 +434,7 @@ static u32 send_rx_credits(struct s3_conn *c3cn, u32 credits, u32 dack)
 
 	req = (struct cpl_rx_data_ack *)__skb_put(skb, sizeof(*req));
 	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
+	req->wr.wr_lo = 0;
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_RX_DATA_ACK, c3cn->tid));
 	req->credit_dack = htonl(dack | V_RX_CREDITS(credits));
 	skb->priority = CPL_PRIORITY_ACK;
