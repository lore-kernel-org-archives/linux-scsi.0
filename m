From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] cxgb4i: a couple invalid dereference bugs
Date: Thu, 28 Feb 2013 00:33:58 +0300
Message-ID: <20130227213358.GB11300@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17751 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3B0VgG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2013 16:36:06 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org

"tid" and "opc" come from skb->data so Smatch complains that the
bounds checking is inadequate.  If "tid" is out of bounds it would
lead to a NULL dereference when debugging is enabled.  If "opc" is
invalid we would dereference a bogus function pointer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 3fecf35..4facd10 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1047,8 +1047,11 @@ static void do_set_tcb_rpl(struct cxgbi_device *cdev, struct sk_buff *skb)
 	struct cxgbi_sock *csk;
 
 	csk = lookup_tid(t, tid);
-	if (!csk)
+	if (!csk) {
 		pr_err("can't find conn. for tid %u.\n", tid);
+		__kfree_skb(skb);
+		return;
+	}
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
 		"csk 0x%p,%u,%lx,%u, status 0x%x.\n",
@@ -1534,7 +1537,7 @@ static int t4_uld_rx_handler(void *handle, const __be64 *rsp,
 	log_debug(1 << CXGBI_DBG_TOE,
 		"cdev %p, opcode 0x%x(0x%x,0x%x), skb %p.\n",
 		 cdev, opc, rpl->ot.opcode_tid, ntohl(rpl->ot.opcode_tid), skb);
-	if (cxgb4i_cplhandlers[opc])
+	if (opc < ARRAY_SIZE(cxgb4i_cplhandlers) && cxgb4i_cplhandlers[opc])
 		cxgb4i_cplhandlers[opc](cdev, skb);
 	else {
 		pr_err("No handler for opcode 0x%x.\n", opc);
