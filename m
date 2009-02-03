From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 2.6.29 1/1] cxgb3i - more transmit work-request checks
Date: Tue, 3 Feb 2009 15:40:43 -0800
Message-ID: <200902032340.n13Neh7e029867@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:6978 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZBCXj2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2009 18:39:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH 2.6.29 1/1] cxgb3i - more transmit work-request checks

From: Karen Xie <kxie@chelsio.com>

- added more checkings for transmit work-request.
- reserve one work-request for credit return.
- stop queueing up the outgoing pdus if transmit window is full.
- split the skb cb into tx and rx portion

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgb3i/cxgb3i_ddp.h     |    2 +
 drivers/scsi/cxgb3i/cxgb3i_offload.c |  132 ++++++++++++++++++++++++----------
 drivers/scsi/cxgb3i/cxgb3i_offload.h |   28 +++++--
 drivers/scsi/cxgb3i/cxgb3i_pdu.c     |    2 -
 4 files changed, 114 insertions(+), 50 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.h b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
index 5c7c4d9..f675807 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
@@ -13,6 +13,8 @@
 #ifndef __CXGB3I_ULP2_DDP_H__
 #define __CXGB3I_ULP2_DDP_H__
 
+#include <linux/vmalloc.h>
+
 /**
  * struct cxgb3i_tag_format - cxgb3i ulp tag format for an iscsi entity
  *
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index a865f1f..faa7a36 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -23,19 +23,19 @@
 #include "cxgb3i_ddp.h"
 
 #ifdef __DEBUG_C3CN_CONN__
-#define c3cn_conn_debug         cxgb3i_log_info
+#define c3cn_conn_debug		cxgb3i_log_debug
 #else
 #define c3cn_conn_debug(fmt...)
 #endif
 
 #ifdef __DEBUG_C3CN_TX__
-#define c3cn_tx_debug         cxgb3i_log_debug
+#define c3cn_tx_debug		cxgb3i_log_debug
 #else
 #define c3cn_tx_debug(fmt...)
 #endif
 
 #ifdef __DEBUG_C3CN_RX__
-#define c3cn_rx_debug         cxgb3i_log_debug
+#define c3cn_rx_debug		cxgb3i_log_debug
 #else
 #define c3cn_rx_debug(fmt...)
 #endif
@@ -301,8 +301,8 @@ static void act_open_req_arp_failure(struct t3cdev *dev, struct sk_buff *skb)
 static void skb_entail(struct s3_conn *c3cn, struct sk_buff *skb,
 		       int flags)
 {
-	CXGB3_SKB_CB(skb)->seq = c3cn->write_seq;
-	CXGB3_SKB_CB(skb)->flags = flags;
+	skb_tcp_seq(skb) = c3cn->write_seq;
+	skb_flags(skb) = flags;
 	__skb_queue_tail(&c3cn->write_queue, skb);
 }
 
@@ -457,12 +457,9 @@ static unsigned int wrlen __read_mostly;
  * The number of WRs needed for an skb depends on the number of fragments
  * in the skb and whether it has any payload in its main body.  This maps the
  * length of the gather list represented by an skb into the # of necessary WRs.
- *
- * The max. length of an skb is controlled by the max pdu size which is ~16K.
- * Also, assume the min. fragment length is the sector size (512), then add
- * extra fragment counts for iscsi bhs and payload padding.
+ * The extra two fragments are for iscsi bhs and payload padding.
  */
-#define SKB_WR_LIST_SIZE	(16384/512 + 3)
+#define SKB_WR_LIST_SIZE	(MAX_SKB_FRAGS + 2)
 static unsigned int skb_wrs[SKB_WR_LIST_SIZE] __read_mostly;
 
 static void s3_init_wr_tab(unsigned int wr_len)
@@ -485,7 +482,7 @@ static void s3_init_wr_tab(unsigned int wr_len)
 
 static inline void reset_wr_list(struct s3_conn *c3cn)
 {
-	c3cn->wr_pending_head = NULL;
+	c3cn->wr_pending_head = c3cn->wr_pending_tail = NULL;
 }
 
 /*
@@ -496,7 +493,7 @@ static inline void reset_wr_list(struct s3_conn *c3cn)
 static inline void enqueue_wr(struct s3_conn *c3cn,
 			      struct sk_buff *skb)
 {
-	skb_wr_data(skb) = NULL;
+	skb_tx_wr_next(skb) = NULL;
 
 	/*
 	 * We want to take an extra reference since both us and the driver
@@ -509,10 +506,22 @@ static inline void enqueue_wr(struct s3_conn *c3cn,
 	if (!c3cn->wr_pending_head)
 		c3cn->wr_pending_head = skb;
 	else
-		skb_wr_data(skb) = skb;
+		skb_tx_wr_next(c3cn->wr_pending_tail) = skb;
 	c3cn->wr_pending_tail = skb;
 }
 
+static int count_pending_wrs(struct s3_conn *c3cn)
+{
+	int n = 0;
+	const struct sk_buff *skb = c3cn->wr_pending_head;
+
+	while (skb) {
+		n += skb->csum;
+		skb = skb_tx_wr_next(skb);
+	}
+	return n;
+}
+
 static inline struct sk_buff *peek_wr(const struct s3_conn *c3cn)
 {
 	return c3cn->wr_pending_head;
@@ -529,8 +538,8 @@ static inline struct sk_buff *dequeue_wr(struct s3_conn *c3cn)
 
 	if (likely(skb)) {
 		/* Don't bother clearing the tail */
-		c3cn->wr_pending_head = skb_wr_data(skb);
-		skb_wr_data(skb) = NULL;
+		c3cn->wr_pending_head = skb_tx_wr_next(skb);
+		skb_tx_wr_next(skb) = NULL;
 	}
 	return skb;
 }
@@ -543,13 +552,14 @@ static void purge_wr_queue(struct s3_conn *c3cn)
 }
 
 static inline void make_tx_data_wr(struct s3_conn *c3cn, struct sk_buff *skb,
-				   int len)
+				   int len, int req_completion)
 {
 	struct tx_data_wr *req;
 
 	skb_reset_transport_header(skb);
 	req = (struct tx_data_wr *)__skb_push(skb, sizeof(*req));
-	req->wr_hi = htonl(V_WR_OP(FW_WROPCODE_OFLD_TX_DATA));
+	req->wr_hi = htonl(V_WR_OP(FW_WROPCODE_OFLD_TX_DATA) |
+			(req_completion ? F_WR_COMPL : 0));
 	req->wr_lo = htonl(V_WR_TID(c3cn->tid));
 	req->sndseq = htonl(c3cn->snd_nxt);
 	/* len includes the length of any HW ULP additions */
@@ -592,7 +602,7 @@ static int c3cn_push_tx_frames(struct s3_conn *c3cn, int req_completion)
 
 	if (unlikely(c3cn->state == C3CN_STATE_CONNECTING ||
 		     c3cn->state == C3CN_STATE_CLOSE_WAIT_1 ||
-		     c3cn->state == C3CN_STATE_ABORTING)) {
+		     c3cn->state >= C3CN_STATE_ABORTING)) {
 		c3cn_tx_debug("c3cn 0x%p, in closing state %u.\n",
 			      c3cn, c3cn->state);
 		return 0;
@@ -615,7 +625,7 @@ static int c3cn_push_tx_frames(struct s3_conn *c3cn, int req_completion)
 		if (c3cn->wr_avail < wrs_needed) {
 			c3cn_tx_debug("c3cn 0x%p, skb len %u/%u, frag %u, "
 				      "wr %d < %u.\n",
-				      c3cn, skb->len, skb->datalen, frags,
+				      c3cn, skb->len, skb->data_len, frags,
 				      wrs_needed, c3cn->wr_avail);
 			break;
 		}
@@ -627,20 +637,24 @@ static int c3cn_push_tx_frames(struct s3_conn *c3cn, int req_completion)
 		c3cn->wr_unacked += wrs_needed;
 		enqueue_wr(c3cn, skb);
 
-		if (likely(CXGB3_SKB_CB(skb)->flags & C3CB_FLAG_NEED_HDR)) {
-			len += ulp_extra_len(skb);
-			make_tx_data_wr(c3cn, skb, len);
-			c3cn->snd_nxt += len;
-			if ((req_completion
-			     && c3cn->wr_unacked == wrs_needed)
-			    || (CXGB3_SKB_CB(skb)->flags & C3CB_FLAG_COMPL)
-			    || c3cn->wr_unacked >= c3cn->wr_max / 2) {
-				struct work_request_hdr *wr = cplhdr(skb);
+		c3cn_tx_debug("c3cn 0x%p, enqueue, skb len %u/%u, frag %u, "
+				"wr %d, left %u, unack %u.\n",
+				c3cn, skb->len, skb->data_len, frags,
+				wrs_needed, c3cn->wr_avail, c3cn->wr_unacked);
 
-				wr->wr_hi |= htonl(F_WR_COMPL);
+
+		if (likely(skb_flags(skb) & C3CB_FLAG_NEED_HDR)) {
+			if ((req_completion &&
+				c3cn->wr_unacked == wrs_needed) ||
+			    (skb_flags(skb) & C3CB_FLAG_COMPL) ||
+			    c3cn->wr_unacked >= c3cn->wr_max / 2) {
+				req_completion = 1;
 				c3cn->wr_unacked = 0;
 			}
-			CXGB3_SKB_CB(skb)->flags &= ~C3CB_FLAG_NEED_HDR;
+			len += ulp_extra_len(skb);
+			make_tx_data_wr(c3cn, skb, len, req_completion);
+			c3cn->snd_nxt += len;
+			skb_flags(skb) &= ~C3CB_FLAG_NEED_HDR;
 		}
 
 		total_size += skb->truesize;
@@ -1082,8 +1096,8 @@ static void process_rx_iscsi_hdr(struct s3_conn *c3cn, struct sk_buff *skb)
 		return;
 	}
 
-	CXGB3_SKB_CB(skb)->seq = ntohl(hdr_cpl->seq);
-	CXGB3_SKB_CB(skb)->flags = 0;
+	skb_tcp_seq(skb) = ntohl(hdr_cpl->seq);
+	skb_flags(skb) = 0;
 
 	skb_reset_transport_header(skb);
 	__skb_pull(skb, sizeof(struct cpl_iscsi_hdr));
@@ -1103,12 +1117,12 @@ static void process_rx_iscsi_hdr(struct s3_conn *c3cn, struct sk_buff *skb)
 		goto abort_conn;
 
 	skb_ulp_mode(skb) = ULP2_FLAG_DATA_READY;
-	skb_ulp_pdulen(skb) = ntohs(ddp_cpl.len);
-	skb_ulp_ddigest(skb) = ntohl(ddp_cpl.ulp_crc);
+	skb_rx_pdulen(skb) = ntohs(ddp_cpl.len);
+	skb_rx_ddigest(skb) = ntohl(ddp_cpl.ulp_crc);
 	status = ntohl(ddp_cpl.ddp_status);
 
 	c3cn_rx_debug("rx skb 0x%p, len %u, pdulen %u, ddp status 0x%x.\n",
-		      skb, skb->len, skb_ulp_pdulen(skb), status);
+		      skb, skb->len, skb_rx_pdulen(skb), status);
 
 	if (status & (1 << RX_DDP_STATUS_HCRC_SHIFT))
 		skb_ulp_mode(skb) |= ULP2_FLAG_HCRC_ERROR;
@@ -1126,7 +1140,7 @@ static void process_rx_iscsi_hdr(struct s3_conn *c3cn, struct sk_buff *skb)
 	} else if (status & (1 << RX_DDP_STATUS_DDP_SHIFT))
 		skb_ulp_mode(skb) |= ULP2_FLAG_DATA_DDPED;
 
-	c3cn->rcv_nxt = ntohl(ddp_cpl.seq) + skb_ulp_pdulen(skb);
+	c3cn->rcv_nxt = ntohl(ddp_cpl.seq) + skb_rx_pdulen(skb);
 	__pskb_trim(skb, len);
 	__skb_queue_tail(&c3cn->receive_queue, skb);
 	cxgb3i_conn_pdu_ready(c3cn);
@@ -1151,12 +1165,27 @@ static int do_iscsi_hdr(struct t3cdev *t3dev, struct sk_buff *skb, void *ctx)
  * Process an acknowledgment of WR completion.  Advance snd_una and send the
  * next batch of work requests from the write queue.
  */
+static void check_wr_invariants(struct s3_conn *c3cn)
+{
+	int pending = count_pending_wrs(c3cn);
+
+	if (unlikely(c3cn->wr_avail + pending != c3cn->wr_max))
+		cxgb3i_log_error("TID %u: credit imbalance: avail %u, "
+				"pending %u, total should be %u\n",
+				c3cn->tid, c3cn->wr_avail, pending,
+				c3cn->wr_max);
+}
+
 static void process_wr_ack(struct s3_conn *c3cn, struct sk_buff *skb)
 {
 	struct cpl_wr_ack *hdr = cplhdr(skb);
 	unsigned int credits = ntohs(hdr->credits);
 	u32 snd_una = ntohl(hdr->snd_una);
 
+	c3cn_tx_debug("%u WR credits, avail %u, unack %u, TID %u, state %u.\n",
+			credits, c3cn->wr_avail, c3cn->wr_unacked,
+			c3cn->tid, c3cn->state);
+
 	c3cn->wr_avail += credits;
 	if (c3cn->wr_unacked > c3cn->wr_max - c3cn->wr_avail)
 		c3cn->wr_unacked = c3cn->wr_max - c3cn->wr_avail;
@@ -1171,6 +1200,17 @@ static void process_wr_ack(struct s3_conn *c3cn, struct sk_buff *skb)
 			break;
 		}
 		if (unlikely(credits < p->csum)) {
+			struct tx_data_wr *w = cplhdr(p);
+			cxgb3i_log_error("TID %u got %u WR credits need %u, "
+					 "len %u, main body %u, frags %u, "
+					 "seq # %u, ACK una %u, ACK nxt %u, "
+					 "WR_AVAIL %u, WRs pending %u\n",
+					 c3cn->tid, credits, p->csum, p->len,
+					 p->len - p->data_len,
+					 skb_shinfo(p)->nr_frags,
+					 ntohl(w->sndseq), snd_una,
+					 ntohl(hdr->snd_nxt), c3cn->wr_avail,
+					 count_pending_wrs(c3cn) - credits);
 			p->csum -= credits;
 			break;
 		} else {
@@ -1180,8 +1220,14 @@ static void process_wr_ack(struct s3_conn *c3cn, struct sk_buff *skb)
 		}
 	}
 
-	if (unlikely(before(snd_una, c3cn->snd_una)))
+	check_wr_invariants(c3cn);
+
+	if (unlikely(before(snd_una, c3cn->snd_una))) {
+		cxgb3i_log_error("TID %u, unexpected sequence # %u in WR_ACK "
+				 "snd_una %u\n",
+				 c3cn->tid, snd_una, c3cn->snd_una);
 		goto out_free;
+	}
 
 	if (c3cn->snd_una != snd_una) {
 		c3cn->snd_una = snd_una;
@@ -1452,7 +1498,7 @@ static void init_offload_conn(struct s3_conn *c3cn,
 			      struct dst_entry *dst)
 {
 	BUG_ON(c3cn->cdev != cdev);
-	c3cn->wr_max = c3cn->wr_avail = T3C_DATA(cdev)->max_wrs;
+	c3cn->wr_max = c3cn->wr_avail = T3C_DATA(cdev)->max_wrs - 1;
 	c3cn->wr_unacked = 0;
 	c3cn->mss_idx = select_mss(c3cn, dst_mtu(dst));
 
@@ -1671,9 +1717,17 @@ int cxgb3i_c3cn_send_pdus(struct s3_conn *c3cn, struct sk_buff *skb)
 		goto out_err;
 	}
 
-	err = -EPIPE;
 	if (c3cn->err) {
 		c3cn_tx_debug("c3cn 0x%p, err %d.\n", c3cn, c3cn->err);
+		err = -EPIPE;
+		goto out_err;
+	}
+
+	if (c3cn->write_seq - c3cn->snd_una >= cxgb3_snd_win) {
+		c3cn_tx_debug("c3cn 0x%p, snd %u - %u > %u.\n",
+				c3cn, c3cn->write_seq, c3cn->snd_una,
+				cxgb3_snd_win);
+		err = -EAGAIN;
 		goto out_err;
 	}
 
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
index d231569..df1eae0 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
@@ -178,25 +178,33 @@ void cxgb3i_c3cn_release(struct s3_conn *);
  * @flag:	see C3CB_FLAG_* below
  * @ulp_mode:	ULP mode/submode of sk_buff
  * @seq:	tcp sequence number
- * @ddigest:	pdu data digest
- * @pdulen:	recovered pdu length
- * @wr_data:	scratch area for tx wr
  */
+struct cxgb3_skb_rx_cb {
+	__u32 ddigest;			/* data digest */
+	__u32 pdulen;			/* recovered pdu length */
+};
+
+struct cxgb3_skb_tx_cb {
+	struct sk_buff *wr_next;	/* next wr */
+};
+
 struct cxgb3_skb_cb {
 	__u8 flags;
 	__u8 ulp_mode;
 	__u32 seq;
-	__u32 ddigest;
-	__u32 pdulen;
-	struct sk_buff *wr_data;
+	union {
+		struct cxgb3_skb_rx_cb rx;
+		struct cxgb3_skb_tx_cb tx;
+	};
 };
 
 #define CXGB3_SKB_CB(skb)	((struct cxgb3_skb_cb *)&((skb)->cb[0]))
-
+#define skb_flags(skb)		(CXGB3_SKB_CB(skb)->flags)
 #define skb_ulp_mode(skb)	(CXGB3_SKB_CB(skb)->ulp_mode)
-#define skb_ulp_ddigest(skb)	(CXGB3_SKB_CB(skb)->ddigest)
-#define skb_ulp_pdulen(skb)	(CXGB3_SKB_CB(skb)->pdulen)
-#define skb_wr_data(skb)	(CXGB3_SKB_CB(skb)->wr_data)
+#define skb_tcp_seq(skb)	(CXGB3_SKB_CB(skb)->seq)
+#define skb_rx_ddigest(skb)	(CXGB3_SKB_CB(skb)->rx.ddigest)
+#define skb_rx_pdulen(skb)	(CXGB3_SKB_CB(skb)->rx.pdulen)
+#define skb_tx_wr_next(skb)	(CXGB3_SKB_CB(skb)->tx.wr_next)
 
 enum c3cb_flags {
 	C3CB_FLAG_NEED_HDR = 1 << 0,	/* packet needs a TX_DATA_WR header */
diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
index ce7ce8c..eac7813 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -366,7 +366,7 @@ void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn)
 	skb = skb_peek(&c3cn->receive_queue);
 	while (!err && skb) {
 		__skb_unlink(skb, &c3cn->receive_queue);
-		read += skb_ulp_pdulen(skb);
+		read += skb_rx_pdulen(skb);
 		err = cxgb3i_conn_read_pdu_skb(conn, skb);
 		__kfree_skb(skb);
 		skb = skb_peek(&c3cn->receive_queue);
