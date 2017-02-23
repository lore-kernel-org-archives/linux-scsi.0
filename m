From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH] cciss: correct check map error.
Date: Thu, 23 Feb 2017 08:57:20 -0600
Message-ID: <148786184061.27650.6500371273219073720.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0064.outbound.protection.outlook.com ([104.47.42.64]:44448
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751041AbdBWO5Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Feb 2017 09:57:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@microsemi.com
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org

remove device driver failed to check map error messages

Reported-by: Johnny Bieren <jbieren@redhat.com>
Tested-by: Johnny Bieren <jbieren@redhat.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/block/cciss.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 3a44438..9c0a34b 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -347,7 +347,7 @@ static void cciss_unmap_sg_chain_block(ctlr_info_t *h, CommandList_struct *c)
 	pci_unmap_single(h->pdev, temp64.val, chain_sg->Len, PCI_DMA_TODEVICE);
 }
 
-static void cciss_map_sg_chain_block(ctlr_info_t *h, CommandList_struct *c,
+static int cciss_map_sg_chain_block(ctlr_info_t *h, CommandList_struct *c,
 	SGDescriptor_struct *chain_block, int len)
 {
 	SGDescriptor_struct *chain_sg;
@@ -358,8 +358,16 @@ static void cciss_map_sg_chain_block(ctlr_info_t *h, CommandList_struct *c,
 	chain_sg->Len = len;
 	temp64.val = pci_map_single(h->pdev, chain_block, len,
 				PCI_DMA_TODEVICE);
+	if (dma_mapping_error(&h->pdev->dev, temp64.val)) {
+		dev_warn(&h->pdev->dev,
+			"%s: error mapping chain block for DMA\n",
+			__func__);
+		return -1;
+	}
 	chain_sg->Addr.lower = temp64.val32.lower;
 	chain_sg->Addr.upper = temp64.val32.upper;
+
+	return 0;
 }
 
 #include "cciss_scsi.c"		/* For SCSI tape support */
@@ -3370,15 +3378,31 @@ static void do_cciss_request(struct request_queue *q)
 		temp64.val = (__u64) pci_map_page(h->pdev, sg_page(&tmp_sg[i]),
 						tmp_sg[i].offset,
 						tmp_sg[i].length, dir);
+		if (dma_mapping_error(&h->pdev->dev, temp64.val)) {
+			dev_warn(&h->pdev->dev,
+				"%s: error mapping page for DMA\n", __func__);
+			creq->errors = make_status_bytes(SAM_STAT_GOOD,
+							0, DRIVER_OK,
+							DID_SOFT_ERROR);
+			cmd_free(h, c);
+			return;
+		}
 		curr_sg[sg_index].Addr.lower = temp64.val32.lower;
 		curr_sg[sg_index].Addr.upper = temp64.val32.upper;
 		curr_sg[sg_index].Ext = 0;  /* we are not chaining */
 		++sg_index;
 	}
-	if (chained)
-		cciss_map_sg_chain_block(h, c, h->cmd_sg_list[c->cmdindex],
+	if (chained) {
+		if (cciss_map_sg_chain_block(h, c, h->cmd_sg_list[c->cmdindex],
 			(seg - (h->max_cmd_sgentries - 1)) *
-				sizeof(SGDescriptor_struct));
+				sizeof(SGDescriptor_struct))) {
+			creq->errors = make_status_bytes(SAM_STAT_GOOD,
+							0, DRIVER_OK,
+							DID_SOFT_ERROR);
+			cmd_free(h, c);
+			return;
+		}
+	}
 
 	/* track how many SG entries we are using */
 	if (seg > h->maxSG)
