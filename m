From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/9] ib_srpt: Avoid failed multipart RDMA transfers
Date: Mon, 24 Oct 2011 05:33:35 +0000
Message-ID: <1319434422-15354-3-git-send-email-nab@linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59565 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab1JXFfU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2011 01:35:20 -0400
In-Reply-To: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Bart Van Assche <bvanassche@acm.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Bart Van Assche <bvanassche@acm.org>

Multipart RDMA transfers can fail after one or more but not all RDMA
transfers have been initiated because either an IB cable has been pulled
or the ib_srpt kernel module has been unloaded while an RDMA transfer is
being setup.

This is a bugfix port from SCST svn r3632 as recommended by Bart Van
Assche.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |  101 +++++++++++++++++++++-----------
 drivers/infiniband/ulp/srpt/ib_srpt.h |   26 +++++++-
 2 files changed, 88 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 383994d..6aba709 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -807,7 +807,7 @@ static int srpt_post_recv(struct srpt_device *sdev,
 	struct ib_recv_wr wr, *bad_wr;
 
 	BUG_ON(!sdev);
-	wr.wr_id = encode_wr_id(IB_WC_RECV, ioctx->ioctx.index);
+	wr.wr_id = encode_wr_id(SRPT_RECV, ioctx->ioctx.index);
 
 	list.addr = ioctx->ioctx.dma;
 	list.length = srp_max_req_size;
@@ -849,7 +849,7 @@ static int srpt_post_send(struct srpt_rdma_ch *ch,
 	list.lkey = sdev->mr->lkey;
 
 	wr.next = NULL;
-	wr.wr_id = encode_wr_id(IB_WC_SEND, ioctx->ioctx.index);
+	wr.wr_id = encode_wr_id(SRPT_SEND, ioctx->ioctx.index);
 	wr.sg_list = &list;
 	wr.num_sge = 1;
 	wr.opcode = IB_WR_SEND;
@@ -1494,17 +1494,26 @@ static void srpt_handle_send_comp(struct srpt_rdma_ch *ch,
  * check_stop_free() callback.
  */
 static void srpt_handle_rdma_comp(struct srpt_rdma_ch *ch,
-				  struct srpt_send_ioctx *ioctx)
+				  struct srpt_send_ioctx *ioctx,
+				  enum srpt_opcode opcode)
 {
 	WARN_ON(ioctx->n_rdma <= 0);
 	atomic_add(ioctx->n_rdma, &ch->sq_wr_avail);
 
-	if (srpt_test_and_set_cmd_state(ioctx, SRPT_STATE_NEED_DATA,
-					SRPT_STATE_DATA_IN))
-		transport_generic_handle_data(&ioctx->cmd);
-	else
-		printk(KERN_ERR "%s[%d]: wrong state = %d\n", __func__,
-		       __LINE__, srpt_get_cmd_state(ioctx));
+	if (opcode == SRPT_RDMA_READ_LAST) {
+		if (srpt_test_and_set_cmd_state(ioctx, SRPT_STATE_NEED_DATA,
+						SRPT_STATE_DATA_IN))
+			transport_generic_handle_data(&ioctx->cmd);
+		else
+			printk(KERN_ERR "%s[%d]: wrong state = %d\n", __func__,
+			       __LINE__, srpt_get_cmd_state(ioctx));
+	} else if (opcode == SRPT_RDMA_ABORT) {
+		ioctx->rdma_aborted = true;
+	} else {
+		WARN_ON(opcode != SRPT_RDMA_READ_LAST);
+		printk(KERN_ERR "%s[%d]: scmnd == NULL (opcode %d)", __func__,
+				__LINE__, opcode);
+	}
 }
 
 /**
@@ -1512,7 +1521,7 @@ static void srpt_handle_rdma_comp(struct srpt_rdma_ch *ch,
  */
 static void srpt_handle_rdma_err_comp(struct srpt_rdma_ch *ch,
 				      struct srpt_send_ioctx *ioctx,
-				      u8 opcode)
+				      enum srpt_opcode opcode)
 {
 	struct se_cmd *cmd;
 	enum srpt_command_state state;
@@ -1520,7 +1529,7 @@ static void srpt_handle_rdma_err_comp(struct srpt_rdma_ch *ch,
 	cmd = &ioctx->cmd;
 	state = srpt_get_cmd_state(ioctx);
 	switch (opcode) {
-	case IB_WC_RDMA_READ:
+	case SRPT_RDMA_READ_LAST:
 		if (ioctx->n_rdma <= 0) {
 			printk(KERN_ERR "Received invalid RDMA read"
 			       " error completion with idx %d\n",
@@ -1534,9 +1543,8 @@ static void srpt_handle_rdma_err_comp(struct srpt_rdma_ch *ch,
 			printk(KERN_ERR "%s[%d]: wrong state = %d\n",
 			       __func__, __LINE__, state);
 		break;
-	case IB_WC_RDMA_WRITE:
-		atomic_set(&ioctx->cmd.transport_lun_stop,
-			   1);
+	case SRPT_RDMA_WRITE_LAST:
+		atomic_set(&ioctx->cmd.transport_lun_stop, 1);
 		break;
 	default:
 		printk(KERN_ERR "%s[%d]: opcode = %u\n", __func__,
@@ -2041,33 +2049,32 @@ static void srpt_process_send_completion(struct ib_cq *cq,
 {
 	struct srpt_send_ioctx *send_ioctx;
 	uint32_t index;
-	u8 opcode;
+	enum srpt_opcode opcode;
 
 	index = idx_from_wr_id(wc->wr_id);
 	opcode = opcode_from_wr_id(wc->wr_id);
 	send_ioctx = ch->ioctx_ring[index];
 	if (wc->status == IB_WC_SUCCESS) {
-		if (opcode == IB_WC_SEND)
+		if (opcode == SRPT_SEND)
 			srpt_handle_send_comp(ch, send_ioctx);
 		else {
-			WARN_ON(wc->opcode != IB_WC_RDMA_READ);
-			srpt_handle_rdma_comp(ch, send_ioctx);
+			WARN_ON(opcode != SRPT_RDMA_ABORT &&
+				wc->opcode != IB_WC_RDMA_READ);
+			srpt_handle_rdma_comp(ch, send_ioctx, opcode);
 		}
 	} else {
-		if (opcode == IB_WC_SEND) {
+		if (opcode == SRPT_SEND) {
 			printk(KERN_INFO "sending response for idx %u failed"
 			       " with status %d\n", index, wc->status);
 			srpt_handle_send_err_comp(ch, wc->wr_id);
-		} else {
-			printk(KERN_INFO "RDMA %s for idx %u failed with status"
-			       " %d\n", opcode == IB_WC_RDMA_READ ? "read"
-			       : opcode == IB_WC_RDMA_WRITE ? "write"
-			       : "???", index, wc->status);
+		} else if (opcode != SRPT_RDMA_MID) {
+			printk(KERN_INFO "RDMA t %d for idx %u failed with"
+				" status %d", opcode, index, wc->status);
 			srpt_handle_rdma_err_comp(ch, send_ioctx, opcode);
 		}
 	}
 
-	while (unlikely(opcode == IB_WC_SEND
+	while (unlikely(opcode == SRPT_SEND
 			&& !list_empty(&ch->cmd_wait_list)
 			&& srpt_get_ch_state(ch) == CH_LIVE
 			&& (send_ioctx = srpt_get_send_ioctx(ch)) != NULL)) {
@@ -2091,7 +2098,7 @@ static void srpt_process_completion(struct ib_cq *cq, struct srpt_rdma_ch *ch)
 	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 	while ((n = ib_poll_cq(cq, ARRAY_SIZE(ch->wc), wc)) > 0) {
 		for (i = 0; i < n; i++) {
-			if (opcode_from_wr_id(wc[i].wr_id) & IB_WC_RECV)
+			if (opcode_from_wr_id(wc[i].wr_id) == SRPT_RECV)
 				srpt_process_rcv_completion(cq, ch, &wc[i]);
 			else
 				srpt_process_send_completion(cq, ch, &wc[i]);
@@ -2882,32 +2889,37 @@ static int srpt_perform_rdmas(struct srpt_rdma_ch *ch,
 	int ret;
 	int sq_wr_avail;
 	enum dma_data_direction dir;
+	const int n_rdma = ioctx->n_rdma;
 
 	dir = ioctx->cmd.data_direction;
 	if (dir == DMA_TO_DEVICE) {
 		/* write */
 		ret = -ENOMEM;
-		sq_wr_avail = atomic_sub_return(ioctx->n_rdma,
-						 &ch->sq_wr_avail);
+		sq_wr_avail = atomic_sub_return(n_rdma, &ch->sq_wr_avail);
 		if (sq_wr_avail < 0) {
 			printk(KERN_WARNING "IB send queue full (needed %d)\n",
-			       ioctx->n_rdma);
+			       n_rdma);
 			goto out;
 		}
 	}
 
+	ioctx->rdma_aborted = false;
 	ret = 0;
 	riu = ioctx->rdma_ius;
 	memset(&wr, 0, sizeof wr);
 
-	for (i = 0; i < ioctx->n_rdma; ++i, ++riu) {
+	for (i = 0; i < n_rdma; ++i, ++riu) {
 		if (dir == DMA_FROM_DEVICE) {
 			wr.opcode = IB_WR_RDMA_WRITE;
-			wr.wr_id = encode_wr_id(IB_WC_RDMA_WRITE,
+			wr.wr_id = encode_wr_id(i == n_rdma - 1 ?
+						SRPT_RDMA_WRITE_LAST :
+						SRPT_RDMA_MID,
 						ioctx->ioctx.index);
 		} else {
 			wr.opcode = IB_WR_RDMA_READ;
-			wr.wr_id = encode_wr_id(IB_WC_RDMA_READ,
+			wr.wr_id = encode_wr_id(i == n_rdma - 1 ?
+						SRPT_RDMA_READ_LAST :
+						SRPT_RDMA_MID,
 						ioctx->ioctx.index);
 		}
 		wr.next = NULL;
@@ -2917,17 +2929,36 @@ static int srpt_perform_rdmas(struct srpt_rdma_ch *ch,
 		wr.sg_list = riu->sge;
 
 		/* only get completion event for the last rdma write */
-		if (i == (ioctx->n_rdma - 1) && dir == DMA_TO_DEVICE)
+		if (i == (n_rdma - 1) && dir == DMA_TO_DEVICE)
 			wr.send_flags = IB_SEND_SIGNALED;
 
 		ret = ib_post_send(ch->qp, &wr, &bad_wr);
 		if (ret)
-			goto out;
+			break;
 	}
 
+	if (ret)
+		printk(KERN_ERR "%s[%d]: ib_post_send() returned %d for %d/%d",
+				 __func__, __LINE__, ret, i, n_rdma);
+	if (ret && i > 0) {
+		wr.num_sge = 0;
+		wr.wr_id = encode_wr_id(SRPT_RDMA_ABORT, ioctx->ioctx.index);
+		wr.send_flags = IB_SEND_SIGNALED;
+		while (ch->state == CH_LIVE &&
+			ib_post_send(ch->qp, &wr, &bad_wr) != 0) {
+			printk(KERN_INFO "Trying to abort failed RDMA transfer [%d]",
+				ioctx->ioctx.index);
+			msleep(1000);
+		}
+		while (ch->state != CH_RELEASING && !ioctx->rdma_aborted) {
+			printk(KERN_INFO "Waiting until RDMA abort finished [%d]",
+				ioctx->ioctx.index);
+			msleep(1000);
+		}
+	}
 out:
 	if (unlikely(dir == DMA_TO_DEVICE && ret < 0))
-		atomic_add(ioctx->n_rdma, &ch->sq_wr_avail);
+		atomic_add(n_rdma, &ch->sq_wr_avail);
 	return ret;
 }
 
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 045fb7b..59ee2d7 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -127,12 +127,27 @@ enum {
 	DEFAULT_MAX_RDMA_SIZE = 65536,
 };
 
+enum srpt_opcode {
+	SRPT_RECV,
+	SRPT_SEND,
+	SRPT_RDMA_MID,
+	SRPT_RDMA_ABORT,
+	SRPT_RDMA_READ_LAST,
+	SRPT_RDMA_WRITE_LAST,
+};
+
 static inline u64 encode_wr_id(u8 opcode, u32 idx)
-{ return ((u64)opcode << 32) | idx; }
-static inline u8 opcode_from_wr_id(u64 wr_id)
-{ return wr_id >> 32; }
+{
+	return ((u64)opcode << 32) | idx;
+}
+static inline enum srpt_opcode opcode_from_wr_id(u64 wr_id)
+{
+	return wr_id >> 32;
+}
 static inline u32 idx_from_wr_id(u64 wr_id)
-{ return (u32)wr_id; }
+{
+	return (u32)wr_id;
+}
 
 struct rdma_iu {
 	u64		raddr;
@@ -204,6 +219,8 @@ struct srpt_recv_ioctx {
  * @tag:         Tag of the received SRP information unit.
  * @spinlock:    Protects 'state'.
  * @state:       I/O context state.
+ * @rdma_aborted: If initiating a multipart RDMA transfer failed, whether
+ * 		 the already initiated transfers have finished.
  * @cmd:         Target core command data structure.
  * @sense_data:  SCSI sense data.
  */
@@ -218,6 +235,7 @@ struct srpt_send_ioctx {
 	struct list_head	free_list;
 	spinlock_t		spinlock;
 	enum srpt_command_state	state;
+	bool			rdma_aborted;
 	struct se_cmd		cmd;
 	struct completion	tx_done;
 	u64			tag;
-- 
1.7.2.5

