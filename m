From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi: cxgb4i: potential array overflow in t4_uld_rx_handler()
Date: Wed, 29 Nov 2017 14:42:20 +0300
Message-ID: <20171129114220.3qbwryxjnol6zmsk@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>, Dimitris Michailidis <dm@chelsio.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The story is that Smatch marks skb->data as untrusted and so it
complains about this code:

	drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:2111 t4_uld_rx_handler()
	error: buffer overflow 'cxgb4i_cplhandlers' 239 <= 255.

I don't know the code very well, but it looks like a reasonable warning
message.  Let's address it by adding a sanity check to make sure "opc"
is within bounds.

Fixes: bbc02c7e9d34 ("cxgb4: Add register, message, and FW definitions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 266eddf17a99..94b2d5660a07 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -2108,12 +2108,12 @@ static int t4_uld_rx_handler(void *handle, const __be64 *rsp,
 	log_debug(1 << CXGBI_DBG_TOE,
 		"cdev %p, opcode 0x%x(0x%x,0x%x), skb %p.\n",
 		 cdev, opc, rpl->ot.opcode_tid, ntohl(rpl->ot.opcode_tid), skb);
-	if (cxgb4i_cplhandlers[opc])
-		cxgb4i_cplhandlers[opc](cdev, skb);
-	else {
+	if (opc >= ARRAY_SIZE(cxgb4i_cplhandlers) || !cxgb4i_cplhandlers[opc]) {
 		pr_err("No handler for opcode 0x%x.\n", opc);
 		__kfree_skb(skb);
+		return 0;
 	}
+	cxgb4i_cplhandlers[opc](cdev, skb);
 	return 0;
 nomem:
 	log_debug(1 << CXGBI_DBG_TOE, "OOM bailing out.\n");
