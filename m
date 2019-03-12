From: Aditya Pakki <pakki001@umn.edu>
Subject: [PATCH] scsi: cxgb4i: Fix potential NULL pointer dereference
Date: Tue, 12 Mar 2019 11:47:58 -0500
Message-ID: <20190312164758.4540-1-pakki001@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: pakki001@umn.edu
Cc: kjlu@umn.edu, Karen Xie <kxie@chelsio.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

alloc_wr may fail and return NULL. The patch checks for such a
scenario and avoids it.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index d44914e5e415..b4f1e00b9250 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -617,6 +617,8 @@ static inline int send_tx_flowc_wr(struct cxgbi_sock *csk)
 #endif
 	flowclen16 = tx_flowc_wr_credits(&nparams, &flowclen);
 	skb = alloc_wr(flowclen, 0, GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
 	flowc = (struct fw_flowc_wr *)skb->head;
 	flowc->op_to_nparams =
 		htonl(FW_WR_OP_V(FW_FLOWC_WR) | FW_FLOWC_WR_NPARAMS_V(nparams));
-- 
2.17.1
