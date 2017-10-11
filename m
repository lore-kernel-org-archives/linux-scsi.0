From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: libcxgbi: simplify task->hdr allocation for mgmt cmds
Date: Wed, 11 Oct 2017 19:33:21 +0530
Message-ID: <1507730601-6702-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:48410 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751924AbdJKODd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Oct 2017 10:03:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com

In case of mgmt cmds task->hdr is dereferenced after
transmitting the pdu in iscsi_tcp_task_xmit()
to handle this case current code increments the Tx skb
reference count and frees the skb in cxgbi_cleanup_task(),
in some error cases this results in skb leak.

To fix this in case of mgmt cmds allocate a separate
buffer for iSCSI hdr and free this buffer in
cxgbi_cleanup_task().

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 43 ++++++++++++++++++++++++++++---------------
 drivers/scsi/cxgbi/libcxgbi.h |  1 -
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 8503ac9..7e81bf8 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1889,16 +1889,13 @@ int cxgbi_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct cxgbi_task_data *tdata = iscsi_task_cxgbi_data(task);
 	struct scsi_cmnd *sc = task->sc;
+	struct cxgbi_sock *csk = cconn->cep->csk;
+	struct net_device *ndev = cdev->ports[csk->port_id];
 	int headroom = SKB_TX_ISCSI_PDU_HEADER_MAX;
 
 	tcp_task->dd_data = tdata;
 	task->hdr = NULL;
 
-	if (tdata->skb) {
-		kfree_skb(tdata->skb);
-		tdata->skb = NULL;
-	}
-
 	if (SKB_MAX_HEAD(cdev->skb_tx_rsvd) > (512 * MAX_SKB_FRAGS) &&
 	    (opcode == ISCSI_OP_SCSI_DATA_OUT ||
 	     (opcode == ISCSI_OP_SCSI_CMD &&
@@ -1910,15 +1907,23 @@ int cxgbi_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 
 	tdata->skb = alloc_skb(cdev->skb_tx_rsvd + headroom, GFP_ATOMIC);
 	if (!tdata->skb) {
-		struct cxgbi_sock *csk = cconn->cep->csk;
-		struct net_device *ndev = cdev->ports[csk->port_id];
 		ndev->stats.tx_dropped++;
 		return -ENOMEM;
 	}
 
-	skb_get(tdata->skb);
 	skb_reserve(tdata->skb, cdev->skb_tx_rsvd);
-	task->hdr = (struct iscsi_hdr *)tdata->skb->data;
+
+	if (task->sc) {
+		task->hdr = (struct iscsi_hdr *)tdata->skb->data;
+	} else {
+		task->hdr = kzalloc(SKB_TX_ISCSI_PDU_HEADER_MAX, GFP_KERNEL);
+		if (!task->hdr) {
+			__kfree_skb(tdata->skb);
+			tdata->skb = NULL;
+			ndev->stats.tx_dropped++;
+			return -ENOMEM;
+		}
+	}
 	task->hdr_max = SKB_TX_ISCSI_PDU_HEADER_MAX; /* BHS + AHS */
 
 	/* data_out uses scsi_cmd's itt */
@@ -2062,9 +2067,9 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 	unsigned int datalen;
 	int err;
 
-	if (!skb || cxgbi_skcb_test_flag(skb, SKCBF_TX_DONE)) {
+	if (!skb) {
 		log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_PDU_TX,
-			"task 0x%p, skb 0x%p\n", task, skb);
+			"task 0x%p\n", task);
 		return 0;
 	}
 
@@ -2076,6 +2081,7 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 		return -EPIPE;
 	}
 
+	tdata->skb = NULL;
 	datalen = skb->data_len;
 
 	/* write ppod first if using ofldq to write ppod */
@@ -2089,6 +2095,9 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 			/* continue. Let fl get the data */
 	}
 
+	if (!task->sc)
+		memcpy(skb->data, task->hdr, SKB_TX_ISCSI_PDU_HEADER_MAX);
+
 	err = cxgbi_sock_send_pdus(cconn->cep->csk, skb);
 	if (err > 0) {
 		int pdulen = err;
@@ -2104,7 +2113,6 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 			pdulen += ISCSI_DIGEST_SIZE;
 
 		task->conn->txdata_octets += pdulen;
-		cxgbi_skcb_set_flag(skb, SKCBF_TX_DONE);
 		return 0;
 	}
 
@@ -2113,6 +2121,7 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 			"task 0x%p, skb 0x%p, len %u/%u, %d EAGAIN.\n",
 			task, skb, skb->len, skb->data_len, err);
 		/* reset skb to send when we are called again */
+		tdata->skb = skb;
 		return err;
 	}
 
@@ -2120,8 +2129,7 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 		"itt 0x%x, skb 0x%p, len %u/%u, xmit err %d.\n",
 		task->itt, skb, skb->len, skb->data_len, err);
 
-	__kfree_skb(tdata->skb);
-	tdata->skb = NULL;
+	__kfree_skb(skb);
 
 	iscsi_conn_printk(KERN_ERR, task->conn, "xmit err %d.\n", err);
 	iscsi_conn_failure(task->conn, ISCSI_ERR_XMIT_FAILED);
@@ -2146,9 +2154,14 @@ void cxgbi_cleanup_task(struct iscsi_task *task)
 		task, tdata->skb, task->hdr_itt);
 
 	tcp_task->dd_data = NULL;
+
+	if (!task->sc)
+		kfree(task->hdr);
+	task->hdr = NULL;
+
 	/*  never reached the xmit task callout */
 	if (tdata->skb) {
-		kfree_skb(tdata->skb);
+		__kfree_skb(tdata->skb);
 		tdata->skb = NULL;
 	}
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 31a5816..dcb190e 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -205,7 +205,6 @@ enum cxgbi_skcb_flags {
 	SKCBF_TX_NEED_HDR,	/* packet needs a header */
 	SKCBF_TX_MEM_WRITE,     /* memory write */
 	SKCBF_TX_FLAG_COMPL,    /* wr completion flag */
-	SKCBF_TX_DONE,		/* skb tx done */
 	SKCBF_RX_COALESCED,	/* received whole pdu */
 	SKCBF_RX_HDR,		/* received pdu header */
 	SKCBF_RX_DATA,		/* received pdu payload */
-- 
2.0.2
