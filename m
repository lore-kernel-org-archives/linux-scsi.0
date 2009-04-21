From: michaelc@cs.wisc.edu
Subject: [PATCH 4/5] cxgb3i: fix cpu use abuse during writes
Date: Tue, 21 Apr 2009 15:32:34 -0500
Message-ID: <12403459572736-git-send-email-michaelc@cs.wisc.edu>
References: <1240345955183-git-send-email-michaelc@cs.wisc.edu>
 <1240345956764-git-send-email-michaelc@cs.wisc.edu>
 <1240345956886-git-send-email-michaelc@cs.wisc.edu>
 <12403459572661-git-send-email-michaelc@cs.wisc.edu>
 <12403459572541-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35818 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818AbZDUUcm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 16:32:42 -0400
In-Reply-To: <12403459572541-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

When doing a lot (128) of large writes (256K) we can hit the cxgb3_snd_win
check pretty easily. The driver's xmit thread then takes 100% of the cpu.

The driver should not be returning -EAGAIN for this problem. It should
be returing -ENOBUFS, then when the window is opened again it should
queue the xmit thread (it already wakes the xmit thread).

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgb3i/cxgb3i_offload.c |    4 +++-
 drivers/scsi/cxgb3i/cxgb3i_pdu.c     |   19 ++++++++++---------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index 4d8654c..e11c9c1 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -1737,7 +1737,7 @@ int cxgb3i_c3cn_send_pdus(struct s3_conn *c3cn, struct sk_buff *skb)
 		c3cn_tx_debug("c3cn 0x%p, snd %u - %u > %u.\n",
 				c3cn, c3cn->write_seq, c3cn->snd_una,
 				cxgb3_snd_win);
-		err = -EAGAIN;
+		err = -ENOBUFS;
 		goto out_err;
 	}
 
@@ -1775,6 +1775,8 @@ done:
 out_err:
 	if (copied == 0 && err == -EPIPE)
 		copied = c3cn->err ? c3cn->err : -EPIPE;
+	else
+		copied = err;
 	goto done;
 }
 
diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
index 7eebc9a..7091050 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -400,17 +400,18 @@ int cxgb3i_conn_xmit_pdu(struct iscsi_task *task)
 		return 0;
 	}
 
-	if (err < 0 && err != -EAGAIN) {
-		kfree_skb(skb);
-		cxgb3i_tx_debug("itt 0x%x, skb 0x%p, len %u/%u, xmit err %d.\n",
-				task->itt, skb, skb->len, skb->data_len, err);
-		iscsi_conn_printk(KERN_ERR, task->conn, "xmit err %d.\n", err);
-		iscsi_conn_failure(task->conn, ISCSI_ERR_XMIT_FAILED);
+	if (err == -EAGAIN || err == -ENOBUFS) {
+		/* reset skb to send when we are called again */
+		tdata->skb = skb;
 		return err;
 	}
-	/* reset skb to send when we are called again */
-	tdata->skb = skb;
-	return -EAGAIN;
+
+	kfree_skb(skb);
+	cxgb3i_tx_debug("itt 0x%x, skb 0x%p, len %u/%u, xmit err %d.\n",
+			task->itt, skb, skb->len, skb->data_len, err);
+	iscsi_conn_printk(KERN_ERR, task->conn, "xmit err %d.\n", err);
+	iscsi_conn_failure(task->conn, ISCSI_ERR_XMIT_FAILED);
+	return err;
 }
 
 int cxgb3i_pdu_init(void)
-- 
1.6.0.6

