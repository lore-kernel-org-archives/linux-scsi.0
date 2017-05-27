From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: cxgb4i,libcxgbi: in error case RST tcp conn
Date: Sat, 27 May 2017 20:22:51 +0530
Message-ID: <1495896771-21910-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:17307 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751209AbdE0OxG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 May 2017 10:53:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com

If logout response is not received and ->ep_disconnect()
is called then close tcp conn by RST instead of FIN to
cleanup conn resources immediately.

Also move ->csk_push_tx_frames() above 'done:' to avoid
calling ->csk_push_tx_frames() in error cases.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |  1 -
 drivers/scsi/cxgbi/libcxgbi.c      | 29 ++++++++++++++++++++++-------
 drivers/scsi/cxgbi/libcxgbi.h      |  1 +
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 1076c15..0aae094 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1595,7 +1595,6 @@ static void release_offload_resources(struct cxgbi_sock *csk)
 		cxgbi_sock_put(csk);
 	}
 	csk->dst = NULL;
-	csk->cdev = NULL;
 }
 
 static int init_act_open(struct cxgbi_sock *csk)
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index fb06974..e4c83b7 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -867,7 +867,8 @@ static void need_active_close(struct cxgbi_sock *csk)
 	log_debug(1 << CXGBI_DBG_SOCK, "csk 0x%p,%u,0x%lx,%u.\n",
 		csk, (csk)->state, (csk)->flags, (csk)->tid);
 	spin_lock_bh(&csk->lock);
-	dst_confirm(csk->dst);
+	if (csk->dst)
+		dst_confirm(csk->dst);
 	data_lost = skb_queue_len(&csk->receive_queue);
 	__skb_queue_purge(&csk->receive_queue);
 
@@ -882,7 +883,8 @@ static void need_active_close(struct cxgbi_sock *csk)
 	}
 
 	if (close_req) {
-		if (data_lost)
+		if (!cxgbi_sock_flag(csk, CTPF_LOGOUT_RSP_RCVD) ||
+		    data_lost)
 			csk->cdev->csk_send_abort_req(csk);
 		else
 			csk->cdev->csk_send_close_req(csk);
@@ -1186,9 +1188,10 @@ static int cxgbi_sock_send_pdus(struct cxgbi_sock *csk, struct sk_buff *skb)
 				cxgbi_ulp_extra_len(cxgbi_skcb_ulp_mode(skb));
 		skb = next;
 	}
-done:
+
 	if (likely(skb_queue_len(&csk->write_queue)))
 		cdev->csk_push_tx_frames(csk, 1);
+done:
 	spin_unlock_bh(&csk->lock);
 	return copied;
 
@@ -1568,9 +1571,12 @@ static inline int read_pdu_skb(struct iscsi_conn *conn,
 	}
 }
 
-static int skb_read_pdu_bhs(struct iscsi_conn *conn, struct sk_buff *skb)
+static int
+skb_read_pdu_bhs(struct cxgbi_sock *csk, struct iscsi_conn *conn,
+		 struct sk_buff *skb)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	int err;
 
 	log_debug(1 << CXGBI_DBG_PDU_RX,
 		"conn 0x%p, skb 0x%p, len %u, flag 0x%lx.\n",
@@ -1608,7 +1614,16 @@ static int skb_read_pdu_bhs(struct iscsi_conn *conn, struct sk_buff *skb)
 		}
 	}
 
-	return read_pdu_skb(conn, skb, 0, 0);
+	err = read_pdu_skb(conn, skb, 0, 0);
+	if (likely(err >= 0)) {
+		struct iscsi_hdr *hdr = (struct iscsi_hdr *)skb->data;
+		u8 opcode = hdr->opcode & ISCSI_OPCODE_MASK;
+
+		if (unlikely(opcode == ISCSI_OP_LOGOUT_RSP))
+			cxgbi_sock_set_flag(csk, CTPF_LOGOUT_RSP_RCVD);
+	}
+
+	return err;
 }
 
 static int skb_read_pdu_data(struct iscsi_conn *conn, struct sk_buff *lskb,
@@ -1713,7 +1728,7 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 			cxgbi_skcb_rx_pdulen(skb));
 
 		if (cxgbi_skcb_test_flag(skb, SKCBF_RX_COALESCED)) {
-			err = skb_read_pdu_bhs(conn, skb);
+			err = skb_read_pdu_bhs(csk, conn, skb);
 			if (err < 0) {
 				pr_err("coalesced bhs, csk 0x%p, skb 0x%p,%u, "
 					"f 0x%lx, plen %u.\n",
@@ -1731,7 +1746,7 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 					cxgbi_skcb_flags(skb),
 					cxgbi_skcb_rx_pdulen(skb));
 		} else {
-			err = skb_read_pdu_bhs(conn, skb);
+			err = skb_read_pdu_bhs(csk, conn, skb);
 			if (err < 0) {
 				pr_err("bhs, csk 0x%p, skb 0x%p,%u, "
 					"f 0x%lx, plen %u.\n",
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 239462a..37f07aa 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -187,6 +187,7 @@ enum cxgbi_sock_flags {
 	CTPF_HAS_ATID,		/* reserved atid */
 	CTPF_HAS_TID,		/* reserved hw tid */
 	CTPF_OFFLOAD_DOWN,	/* offload function off */
+	CTPF_LOGOUT_RSP_RCVD,   /* received logout response */
 };
 
 struct cxgbi_skb_rx_cb {
-- 
2.0.2
