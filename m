From: kxie@chelsio.com
Subject: [PATCH] cxgb4i: ignore informational act-open-rpl message
Date: Sat, 16 Oct 2010 22:09:05 -0700
Message-ID: <201010170509.o9H595xq019898@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:30478 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0JQFJR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Oct 2010 01:09:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: rranjan@chelsio.com, kxie@chelsio.com, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

[PATCH] cxgb4i: ignore informational act-open-rpl message 

From: Karen Xie <kxie@chelsio.com>

Ignore active open reply with status negative advice. This is an informational message. 

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 99f2b8c..8c04fad 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -692,6 +692,9 @@ static void do_act_open_rpl(struct cxgbi_device *cdev, struct sk_buff *skb)
 		&csk->daddr.sin_addr.s_addr, ntohs(csk->daddr.sin_port),
 		atid, tid, status, csk, csk->state, csk->flags);
 
+	if (status == CPL_ERR_RTX_NEG_ADVICE)
+		goto rel_skb;
+
 	if (status && status != CPL_ERR_TCAM_FULL &&
 	    status != CPL_ERR_CONN_EXIST &&
 	    status != CPL_ERR_ARP_MISS)
