From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: libcxgbi: fix skb use after free
Date: Tue, 16 May 2017 19:23:44 +0530
Message-ID: <1494942824-2252-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:2447 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbdEPNyE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2017 09:54:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com

skb->data is assigned to task->hdr in cxgbi_conn_alloc_pdu(),
skb gets freed after tx but task->hdr is still dereferenced
in iscsi_tcp_task_xmit() to avoid this call skb_get() after
allocating skb and free the skb in cxgbi_cleanup_task() or
before allocating new skb in cxgbi_conn_alloc_pdu().

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 25 ++++++++++++++++++-------
 drivers/scsi/cxgbi/libcxgbi.h | 16 ++++++++--------
 2 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index bd7d39e..fb06974 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1873,6 +1873,11 @@ int cxgbi_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 	tcp_task->dd_data = tdata;
 	task->hdr = NULL;
 
+	if (tdata->skb) {
+		kfree_skb(tdata->skb);
+		tdata->skb = NULL;
+	}
+
 	if (SKB_MAX_HEAD(cdev->skb_tx_rsvd) > (512 * MAX_SKB_FRAGS) &&
 	    (opcode == ISCSI_OP_SCSI_DATA_OUT ||
 	     (opcode == ISCSI_OP_SCSI_CMD &&
@@ -1890,6 +1895,7 @@ int cxgbi_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 		return -ENOMEM;
 	}
 
+	skb_get(tdata->skb);
 	skb_reserve(tdata->skb, cdev->skb_tx_rsvd);
 	task->hdr = (struct iscsi_hdr *)tdata->skb->data;
 	task->hdr_max = SKB_TX_ISCSI_PDU_HEADER_MAX; /* BHS + AHS */
@@ -2035,9 +2041,9 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 	unsigned int datalen;
 	int err;
 
-	if (!skb) {
+	if (!skb || cxgbi_skcb_test_flag(skb, SKCBF_TX_DONE)) {
 		log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_PDU_TX,
-			"task 0x%p, skb NULL.\n", task);
+			"task 0x%p, skb 0x%p\n", task, skb);
 		return 0;
 	}
 
@@ -2050,7 +2056,6 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 	}
 
 	datalen = skb->data_len;
-	tdata->skb = NULL;
 
 	/* write ppod first if using ofldq to write ppod */
 	if (ttinfo->flags & CXGBI_PPOD_INFO_FLAG_VALID) {
@@ -2078,6 +2083,7 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 			pdulen += ISCSI_DIGEST_SIZE;
 
 		task->conn->txdata_octets += pdulen;
+		cxgbi_skcb_set_flag(skb, SKCBF_TX_DONE);
 		return 0;
 	}
 
@@ -2086,7 +2092,6 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 			"task 0x%p, skb 0x%p, len %u/%u, %d EAGAIN.\n",
 			task, skb, skb->len, skb->data_len, err);
 		/* reset skb to send when we are called again */
-		tdata->skb = skb;
 		return err;
 	}
 
@@ -2094,7 +2099,8 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 		"itt 0x%x, skb 0x%p, len %u/%u, xmit err %d.\n",
 		task->itt, skb, skb->len, skb->data_len, err);
 
-	kfree_skb(skb);
+	__kfree_skb(tdata->skb);
+	tdata->skb = NULL;
 
 	iscsi_conn_printk(KERN_ERR, task->conn, "xmit err %d.\n", err);
 	iscsi_conn_failure(task->conn, ISCSI_ERR_XMIT_FAILED);
@@ -2113,8 +2119,10 @@ void cxgbi_cleanup_task(struct iscsi_task *task)
 
 	tcp_task->dd_data = NULL;
 	/*  never reached the xmit task callout */
-	if (tdata->skb)
-		__kfree_skb(tdata->skb);
+	if (tdata->skb) {
+		kfree_skb(tdata->skb);
+		tdata->skb = NULL;
+	}
 
 	task_release_itt(task, task->hdr_itt);
 	memset(tdata, 0, sizeof(*tdata));
@@ -2714,6 +2722,9 @@ EXPORT_SYMBOL_GPL(cxgbi_attr_is_visible);
 static int __init libcxgbi_init_module(void)
 {
 	pr_info("%s", version);
+
+	BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, cb) <
+		     sizeof(struct cxgbi_skb_cb));
 	return 0;
 }
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 18e0ea8..239462a 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -195,7 +195,8 @@ struct cxgbi_skb_rx_cb {
 };
 
 struct cxgbi_skb_tx_cb {
-	void *l2t;
+	void *handle;
+	void *arp_err_handler;
 	struct sk_buff *wr_next;
 };
 
@@ -203,6 +204,7 @@ enum cxgbi_skcb_flags {
 	SKCBF_TX_NEED_HDR,	/* packet needs a header */
 	SKCBF_TX_MEM_WRITE,     /* memory write */
 	SKCBF_TX_FLAG_COMPL,    /* wr completion flag */
+	SKCBF_TX_DONE,		/* skb tx done */
 	SKCBF_RX_COALESCED,	/* received whole pdu */
 	SKCBF_RX_HDR,		/* received pdu header */
 	SKCBF_RX_DATA,		/* received pdu payload */
@@ -215,13 +217,13 @@ enum cxgbi_skcb_flags {
 };
 
 struct cxgbi_skb_cb {
-	unsigned char ulp_mode;
-	unsigned long flags;
-	unsigned int seq;
 	union {
 		struct cxgbi_skb_rx_cb rx;
 		struct cxgbi_skb_tx_cb tx;
 	};
+	unsigned char ulp_mode;
+	unsigned long flags;
+	unsigned int seq;
 };
 
 #define CXGBI_SKB_CB(skb)	((struct cxgbi_skb_cb *)&((skb)->cb[0]))
@@ -374,11 +376,9 @@ static inline void cxgbi_sock_enqueue_wr(struct cxgbi_sock *csk,
 	cxgbi_skcb_tx_wr_next(skb) = NULL;
 	/*
 	 * We want to take an extra reference since both us and the driver
-	 * need to free the packet before it's really freed. We know there's
-	 * just one user currently so we use atomic_set rather than skb_get
-	 * to avoid the atomic op.
+	 * need to free the packet before it's really freed.
 	 */
-	atomic_set(&skb->users, 2);
+	skb_get(skb);
 
 	if (!csk->wr_pending_head)
 		csk->wr_pending_head = skb;
-- 
2.0.2
