From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v5 08/42] hpsa: make function names consistent
Date: Thu, 23 Apr 2015 09:32:27 -0500
Message-ID: <20150423143227.18832.47653.stgit@brunhilda>
References: <20150423141637.18832.35621.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5008.houston.hp.com ([15.240.92.66]:33431 "EHLO
	g9t5008.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934082AbbDWOde (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 10:33:34 -0400
In-Reply-To: <20150423141637.18832.35621.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

make function names more consistent and meaningful

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@Suse.de>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 26e5988..427dbd5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6772,7 +6772,7 @@ out_disable:
 	return rc;
 }
 
-static int hpsa_allocate_cmd_pool(struct ctlr_info *h)
+static int hpsa_alloc_cmd_pool(struct ctlr_info *h)
 {
 	h->cmd_pool_bits = kzalloc(
 		DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG) *
@@ -7301,7 +7301,7 @@ reinit_after_soft_reset:
 	dev_info(&pdev->dev, "%s: <0x%x> at IRQ %d%s using DAC\n",
 	       h->devname, pdev->device,
 	       h->intr[h->intr_mode], dac ? "" : " not");
-	rc = hpsa_allocate_cmd_pool(h);
+	rc = hpsa_alloc_cmd_pool(h);
 	if (rc)
 		goto clean2_and_free_irqs;
 	if (hpsa_allocate_sg_chain_blocks(h))
@@ -7748,7 +7748,8 @@ static int hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 	return 0;
 }
 
-static int hpsa_alloc_ioaccel_cmd_and_bft(struct ctlr_info *h)
+/* Allocate ioaccel1 mode command blocks and block fetch table */
+static int hpsa_alloc_ioaccel1_cmd_and_bft(struct ctlr_info *h)
 {
 	h->ioaccel_maxsg =
 		readl(&(h->cfgtable->io_accel_max_embedded_sg_count));
@@ -7787,7 +7788,8 @@ clean_up:
 	return 1;
 }
 
-static int ioaccel2_alloc_cmds_and_bft(struct ctlr_info *h)
+/* Allocate ioaccel2 mode command blocks and block fetch table */
+static int hpsa_alloc_ioaccel2_cmd_and_bft(struct ctlr_info *h)
 {
 	/* Allocate ioaccel2 mode command blocks and block fetch table */
 
@@ -7842,13 +7844,13 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
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

