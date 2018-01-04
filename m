From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: libcxgbi: use GFP_ATOMIC in cxgbi_conn_alloc_pdu()
Date: Thu,  4 Jan 2018 21:04:17 +0530
Message-ID: <1515080057-24553-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:16241 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753313AbeADPeh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2018 10:34:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com

For mgmt cmds ->alloc_pdu() can be called from atomic
context so use GFP_ATOMIC instead of GFP_KERNEL.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index ce13364..3f3af5e 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1914,7 +1914,7 @@ int cxgbi_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 	if (task->sc) {
 		task->hdr = (struct iscsi_hdr *)tdata->skb->data;
 	} else {
-		task->hdr = kzalloc(SKB_TX_ISCSI_PDU_HEADER_MAX, GFP_KERNEL);
+		task->hdr = kzalloc(SKB_TX_ISCSI_PDU_HEADER_MAX, GFP_ATOMIC);
 		if (!task->hdr) {
 			__kfree_skb(tdata->skb);
 			tdata->skb = NULL;
-- 
2.0.2
