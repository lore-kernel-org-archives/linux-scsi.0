From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 08/43] hpsa: make function names consistent
Date: Sat, 21 Feb 2015 16:18:15 -0600
Message-ID: <20150221221815.21954.65706.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55774 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbbBUWTe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:19:34 -0500
Received: from g5t1625.atlanta.hp.com (g5t1625.atlanta.hp.com [15.192.137.8])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id CDE871F4
	for <linux-scsi@vger.kernel.org>; Sat, 21 Feb 2015 22:19:33 +0000 (UTC)
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

make function names more consistent and meaningful

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 287ad38..ac0f992 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6833,7 +6833,7 @@ out_disable:
 	return rc;
 }
 
-static int hpsa_allocate_cmd_pool(struct ctlr_info *h)
+static int hpsa_alloc_cmd_pool(struct ctlr_info *h)
 {
 	h->cmd_pool_bits = kzalloc(
 		DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG) *
@@ -7363,7 +7363,7 @@ reinit_after_soft_reset:
 	dev_info(&pdev->dev, "%s: <0x%x> at IRQ %d%s using DAC\n",
 	       h->devname, pdev->device,
 	       h->intr[h->intr_mode], dac ? "" : " not");
-	rc = hpsa_allocate_cmd_pool(h);
+	rc = hpsa_alloc_cmd_pool(h);
 	if (rc)
 		goto clean2_and_free_irqs;
 	if (hpsa_allocate_sg_chain_blocks(h))
@@ -7810,7 +7810,8 @@ static int hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 	return 0;
 }
 
-static int hpsa_alloc_ioaccel_cmd_and_bft(struct ctlr_info *h)
+/* Allocate ioaccel1 mode command blocks and block fetch table */
+static int hpsa_alloc_ioaccel1_cmd_and_bft(struct ctlr_info *h)
 {
 	h->ioaccel_maxsg =
 		readl(&(h->cfgtable->io_accel_max_embedded_sg_count));
@@ -7849,7 +7850,8 @@ clean_up:
 	return 1;
 }
 
-static int ioaccel2_alloc_cmds_and_bft(struct ctlr_info *h)
+/* Allocate ioaccel2 mode command blocks and block fetch table */
+static int hpsa_alloc_ioaccel2_cmd_and_bft(struct ctlr_info *h)
 {
 	/* Allocate ioaccel2 mode command blocks and block fetch table */
 
@@ -7904,13 +7906,13 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	if (trans_support & CFGTBL_Trans_io_accel1) {
 		transMethod |= CFGTBL_Trans_io_accel1 |
 				CFGTBL_Trans_enable_directed_msix;
-		if (hpsa_alloc_ioaccel_cmd_and_bft(h))
+		if (hpsa_alloc_ioaccel1_cmd_and_bft(h))
 			goto clean_up;
 	} else {
 		if (trans_support & CFGTBL_Trans_io_accel2) {
 				transMethod |= CFGTBL_Trans_io_accel2 |
 				CFGTBL_Trans_enable_directed_msix;
-		if (ioaccel2_alloc_cmds_and_bft(h))
+		if (hpsa_alloc_ioaccel2_cmd_and_bft(h))
 			goto clean_up;
 		}
 	}

