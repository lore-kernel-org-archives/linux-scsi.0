From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] cciss: fix scsi_dma_map failure handiling
Date: Wed, 17 Oct 2007 15:36:56 +0900
Message-ID: <20071017153656R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:56096 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbXJQGhG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 02:37:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, Mike.Miller@hp.com
Cc: linux-scsi@vger.kernel.org, tomof@acm.org

This fixes the scsi_dma_map failure path, which could lead to data
corruption.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/block/cciss_scsi.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 4aca7dd..9d9aa53 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1185,7 +1185,7 @@ cciss_scsi_proc_info(struct Scsi_Host *sh,
    dma mapping  and fills in the scatter gather entries of the 
    cciss command, cp. */
 
-static void
+static int
 cciss_scatter_gather(struct pci_dev *pdev, 
 		CommandList_struct *cp,	
 		struct scsi_cmnd *cmd)
@@ -1198,7 +1198,9 @@ cciss_scatter_gather(struct pci_dev *pdev,
 	BUG_ON(scsi_sg_count(cmd) > MAXSGENTRIES);
 
 	use_sg = scsi_dma_map(cmd);
-	if (use_sg) {	/* not too many addrs? */
+	if (use_sg < 0)
+		return use_sg;
+	else if (use_sg) {	/* not too many addrs? */
 		scsi_for_each_sg(cmd, sg, use_sg, i) {
 			addr64 = (__u64) sg_dma_address(sg);
 			len  = sg_dma_len(sg);
@@ -1213,7 +1215,7 @@ cciss_scatter_gather(struct pci_dev *pdev,
 
 	cp->Header.SGList = (__u8) use_sg;   /* no. SGs contig in this cmd */
 	cp->Header.SGTotal = (__u16) use_sg; /* total sgs in this cmd list */
-	return;
+	return 0;
 }
 
 
@@ -1311,7 +1313,14 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 		break;
 	}
 
-	cciss_scatter_gather((*c)->pdev, cp, cmd); // Fill the SG list
+	rc = cciss_scatter_gather((*c)->pdev, cp, cmd); // Fill the SG list
+	if (rc < 0) {
+		spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
+		scsi_cmd_free(*c, cp);
+		spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
+
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	/* Put the request on the tail of the request queue */
 
-- 
1.5.2.4

