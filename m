From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 4/4] cxgb4i: set the initial sequence number
Date: Fri, 10 Apr 2015 13:57:21 -0700
Message-ID: <201504102057.t3AKvLNw028778@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:20048 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405AbbDJVAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2015 17:00:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kxie@chelsio.com, hch@infradead.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

set the initial sequence number so the 1st byte of payload is aligned on
the 8-byte boundary.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    8 ++++++--
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.h |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index dc495a4..089110e 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -200,9 +200,9 @@ static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 		SMAC_SEL_V(csk->smac_idx) |
 		ULP_MODE_V(ULP_MODE_ISCSI) |
 		RCV_BUFSIZ_V(csk->rcv_win >> 10);
+
 	opt2 = RX_CHANNEL_V(0) |
 		RSS_QUEUE_VALID_F |
-		(RX_FC_DISABLE_F) |
 		RSS_QUEUE_V(csk->rss_qid);
 
 	if (is_t4(lldi->adapter_type)) {
@@ -231,6 +231,7 @@ static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 	} else {
 		struct cpl_t5_act_open_req *req =
 				(struct cpl_t5_act_open_req *)skb->head;
+		u32 isn = (prandom_u32() & ~7UL) - 1;
 
 		INIT_TP_WR(req, 0);
 		OPCODE_TID(req) = cpu_to_be32(MK_OPCODE_TID(CPL_ACT_OPEN_REQ,
@@ -244,7 +245,10 @@ static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 				cxgb4_select_ntuple(
 					csk->cdev->ports[csk->port_id],
 					csk->l2t)));
-		opt2 |= 1 << 31;
+		req->rsvd = cpu_to_be32(isn);
+		opt2 |= T5_ISS_VALID;
+		opt2 |= T5_OPT_2_VALID_F;
+
 		req->opt2 = cpu_to_be32(opt2);
 
 		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.h b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.h
index 63115bc..22dd8d6 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.h
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.h
@@ -23,6 +23,8 @@
 #define CXGB4I_TX_HEADER_LEN \
 	(sizeof(struct fw_ofld_tx_data_wr) + sizeof(struct sge_opaque_hdr))
 
+#define T5_ISS_VALID		(1 << 18)
+
 struct ulptx_idata {
 	__be32 cmd_more;
 	__be32 len;
