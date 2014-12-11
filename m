From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH net v9 5/7] cxgb4i: handle non-pdu-aligned rx data
Date: Thu, 11 Dec 2014 07:25:52 -0800
Message-ID: <201412111525.sBBFPqes012951@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:16954 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964999AbaLKP1Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2014 10:27:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, netdev@vger.kernel.org
Cc: kxie@chelsio.com, hariprasad@chelsio.com, anish@chelsio.com, hch@infradead.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, davem@davemloft.net

From: Karen Xie <kxie@chelsio.com>

Abort the connection upon receiving of cpl_rx_data, which means the pdu cannot
be recovered from the tcp stream. This generally is due to pdu header 
corruption.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 2880f200..dff7345 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1034,6 +1034,27 @@ rel_skb:
 	__kfree_skb(skb);
 }
 
+static void do_rx_data(struct cxgbi_device *cdev, struct sk_buff *skb)
+{
+	struct cxgbi_sock *csk;
+	struct cpl_rx_data *cpl = (struct cpl_rx_data *)skb->data;
+	unsigned int tid = GET_TID(cpl);
+	struct cxgb4_lld_info *lldi = cxgbi_cdev_priv(cdev);
+	struct tid_info *t = lldi->tids;
+
+	csk = lookup_tid(t, tid);
+	if (!csk) {
+		pr_err("can't find connection for tid %u.\n", tid);
+	} else {
+		/* not expecting this, reset the connection. */
+		pr_err("csk 0x%p, tid %u, rcv cpl_rx_data.\n", csk, tid);
+		spin_lock_bh(&csk->lock);
+		send_abort_req(csk);
+		spin_unlock_bh(&csk->lock);
+	}
+	__kfree_skb(skb);
+}
+
 static void do_rx_iscsi_hdr(struct cxgbi_device *cdev, struct sk_buff *skb)
 {
 	struct cxgbi_sock *csk;
@@ -1453,6 +1474,7 @@ cxgb4i_cplhandler_func cxgb4i_cplhandlers[NUM_CPL_CMDS] = {
 	[CPL_SET_TCB_RPL] = do_set_tcb_rpl,
 	[CPL_RX_DATA_DDP] = do_rx_data_ddp,
 	[CPL_RX_ISCSI_DDP] = do_rx_data_ddp,
+	[CPL_RX_DATA] = do_rx_data,
 };
 
 int cxgb4i_ofld_init(struct cxgbi_device *cdev)
