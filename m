From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 1/1] cxgb3i - remove use of skb->sp
Date: Mon, 29 Dec 2008 21:43:25 -0800
Message-ID: <200812300543.mBU5hPcb020725@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:22697 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYL3FjM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Dec 2008 00:39:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-next@vger.kernel.org, sfr@canb.auug.org.au, kxie@chelsio.com

[PATCH 1/1] cxgb3i - remove use of skb->sp

From: Karen Xie <kxie@chelsio.com>

The cxgb3i was using skb->sp pointer for some internal book-keeping which is not related to the secure path. Changed it to use skb->cb[] instead.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgb3i/cxgb3i_offload.c |    8 ++++----
 drivers/scsi/cxgb3i/cxgb3i_offload.h |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index 5f16081..a865f1f 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -496,7 +496,7 @@ static inline void reset_wr_list(struct s3_conn *c3cn)
 static inline void enqueue_wr(struct s3_conn *c3cn,
 			      struct sk_buff *skb)
 {
-	skb->sp = NULL;
+	skb_wr_data(skb) = NULL;
 
 	/*
 	 * We want to take an extra reference since both us and the driver
@@ -509,7 +509,7 @@ static inline void enqueue_wr(struct s3_conn *c3cn,
 	if (!c3cn->wr_pending_head)
 		c3cn->wr_pending_head = skb;
 	else
-		c3cn->wr_pending_tail->sp = (void *)skb;
+		skb_wr_data(skb) = skb;
 	c3cn->wr_pending_tail = skb;
 }
 
@@ -529,8 +529,8 @@ static inline struct sk_buff *dequeue_wr(struct s3_conn *c3cn)
 
 	if (likely(skb)) {
 		/* Don't bother clearing the tail */
-		c3cn->wr_pending_head = (struct sk_buff *)skb->sp;
-		skb->sp = NULL;
+		c3cn->wr_pending_head = skb_wr_data(skb);
+		skb_wr_data(skb) = NULL;
 	}
 	return skb;
 }
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
index 5b93d62..d231569 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
@@ -180,7 +180,7 @@ void cxgb3i_c3cn_release(struct s3_conn *);
  * @seq:	tcp sequence number
  * @ddigest:	pdu data digest
  * @pdulen:	recovered pdu length
- * @ulp_data:	scratch area for ULP
+ * @wr_data:	scratch area for tx wr
  */
 struct cxgb3_skb_cb {
 	__u8 flags;
@@ -188,7 +188,7 @@ struct cxgb3_skb_cb {
 	__u32 seq;
 	__u32 ddigest;
 	__u32 pdulen;
-	__u8 ulp_data[16];
+	struct sk_buff *wr_data;
 };
 
 #define CXGB3_SKB_CB(skb)	((struct cxgb3_skb_cb *)&((skb)->cb[0]))
@@ -196,7 +196,7 @@ struct cxgb3_skb_cb {
 #define skb_ulp_mode(skb)	(CXGB3_SKB_CB(skb)->ulp_mode)
 #define skb_ulp_ddigest(skb)	(CXGB3_SKB_CB(skb)->ddigest)
 #define skb_ulp_pdulen(skb)	(CXGB3_SKB_CB(skb)->pdulen)
-#define skb_ulp_data(skb)	(CXGB3_SKB_CB(skb)->ulp_data)
+#define skb_wr_data(skb)	(CXGB3_SKB_CB(skb)->wr_data)
 
 enum c3cb_flags {
 	C3CB_FLAG_NEED_HDR = 1 << 0,	/* packet needs a TX_DATA_WR header */
