From: kxie@chelsio.com
Subject: [PATCH 1/1]: fixed cxgb3i to always use negative errno in case of error
Date: Wed, 09 Dec 2009 21:25:36 -0800
Message-ID: <200912100525.nBA5PaUn000384@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932777AbZLJFOr@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: rakesh@chelsio.com, kxie@chelsio.com, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[PATCH 1/1]: fixed cxgb3i to always use negative errno in case of error

From: Karen Xie <kxie@chelsio.com>

Fixed cxgb3i to use negative errno in case of error.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgb3i/cxgb3i_offload.c |   24 ++++++++++++------------
 drivers/scsi/cxgb3i/cxgb3i_pdu.c     |    4 ++--
 2 files changed, 14 insertions(+), 14 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index c1d5be4..26ffdcd 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -291,7 +291,7 @@ static void act_open_req_arp_failure(struct t3cdev *dev, struct sk_buff *skb)
 	c3cn_hold(c3cn);
 	spin_lock_bh(&c3cn->lock);
 	if (c3cn->state == C3CN_STATE_CONNECTING)
-		fail_act_open(c3cn, EHOSTUNREACH);
+		fail_act_open(c3cn, -EHOSTUNREACH);
 	spin_unlock_bh(&c3cn->lock);
 	c3cn_put(c3cn);
 	__kfree_skb(skb);
@@ -792,18 +792,18 @@ static int act_open_rpl_status_to_errno(int status)
 {
 	switch (status) {
 	case CPL_ERR_CONN_RESET:
-		return ECONNREFUSED;
+		return -ECONNREFUSED;
 	case CPL_ERR_ARP_MISS:
-		return EHOSTUNREACH;
+		return -EHOSTUNREACH;
 	case CPL_ERR_CONN_TIMEDOUT:
-		return ETIMEDOUT;
+		return -ETIMEDOUT;
 	case CPL_ERR_TCAM_FULL:
-		return ENOMEM;
+		return -ENOMEM;
 	case CPL_ERR_CONN_EXIST:
 		cxgb3i_log_error("ACTIVE_OPEN_RPL: 4-tuple in use\n");
-		return EADDRINUSE;
+		return -EADDRINUSE;
 	default:
-		return EIO;
+		return -EIO;
 	}
 }
 
@@ -817,7 +817,7 @@ static void act_open_retry_timer(unsigned long data)
 	spin_lock_bh(&c3cn->lock);
 	skb = alloc_skb(sizeof(struct cpl_act_open_req), GFP_ATOMIC);
 	if (!skb)
-		fail_act_open(c3cn, ENOMEM);
+		fail_act_open(c3cn, -ENOMEM);
 	else {
 		skb->sk = (struct sock *)c3cn;
 		set_arp_failure_handler(skb, act_open_req_arp_failure);
@@ -966,14 +966,14 @@ static int abort_status_to_errno(struct s3_conn *c3cn, int abort_reason,
 	case CPL_ERR_BAD_SYN: /* fall through */
 	case CPL_ERR_CONN_RESET:
 		return c3cn->state > C3CN_STATE_ESTABLISHED ?
-			EPIPE : ECONNRESET;
+			-EPIPE : -ECONNRESET;
 	case CPL_ERR_XMIT_TIMEDOUT:
 	case CPL_ERR_PERSIST_TIMEDOUT:
 	case CPL_ERR_FINWAIT2_TIMEDOUT:
 	case CPL_ERR_KEEPALIVE_TIMEDOUT:
-		return ETIMEDOUT;
+		return -ETIMEDOUT;
 	default:
-		return EIO;
+		return -EIO;
 	}
 }
 
@@ -1563,7 +1563,7 @@ free_tid:
 	s3_free_atid(cdev, c3cn->tid);
 	c3cn->tid = 0;
 out_err:
-	return -1;
+	return -EINVAL;
 }
 
 
diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
index 7091050..1fe3b0f 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -388,8 +388,8 @@ int cxgb3i_conn_xmit_pdu(struct iscsi_task *task)
 	if (err > 0) {
 		int pdulen = err;
 
-	cxgb3i_tx_debug("task 0x%p, skb 0x%p, len %u/%u, rv %d.\n",
-			task, skb, skb->len, skb->data_len, err);
+		cxgb3i_tx_debug("task 0x%p, skb 0x%p, len %u/%u, rv %d.\n",
+				task, skb, skb->len, skb->data_len, err);
 
 		if (task->conn->hdrdgst_en)
 			pdulen += ISCSI_DIGEST_SIZE;
