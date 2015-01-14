From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 15/48] hpsa: trivial message and comment clean ups
Date: Wed, 14 Jan 2015 16:00:55 -0600
Message-ID: <20150114220055.21325.56942.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55234 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbbANWBm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:01:42 -0500
Received: from g6t1525.atlanta.hp.com (g6t1525.atlanta.hp.com [15.193.200.68])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 8F45452B8
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 22:01:42 +0000 (UTC)
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

Cleanup comments to be more specific. Make messages more
informational.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 08d96a9..5973018 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5863,8 +5863,8 @@ static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	} else {
 		use_doorbell = misc_fw_support & MISC_FW_DOORBELL_RESET;
 		if (use_doorbell) {
-			dev_warn(&pdev->dev, "Soft reset not supported. "
-				"Firmware update is required.\n");
+			dev_warn(&pdev->dev,
+				"Soft reset not supported. Firmware update is required.\n");
 			rc = -ENOTSUPP; /* try soft reset */
 			goto unmap_cfgtable;
 		}
@@ -5884,8 +5884,7 @@ static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	rc = hpsa_wait_for_board_state(pdev, vaddr, BOARD_READY);
 	if (rc) {
 		dev_warn(&pdev->dev,
-			"failed waiting for board to become ready "
-			"after hard reset\n");
+			"Failed waiting for board to become ready after hard reset\n");
 		goto unmap_cfgtable;
 	}
 
@@ -5984,7 +5983,7 @@ static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
 }
 
 /* If MSI/MSI-X is supported by the kernel we will try to enable it on
- * controllers that are capable. If not, we use IO-APIC mode.
+ * controllers that are capable. If not, we use legacy INTx mode.
  */
 
 static void hpsa_interrupt_mode(struct ctlr_info *h)
@@ -6003,7 +6002,7 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 	    (h->board_id == 0x40820E11) || (h->board_id == 0x40830E11))
 		goto default_int_mode;
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
-		dev_info(&h->pdev->dev, "MSIX\n");
+		dev_info(&h->pdev->dev, "MSI-X capable controller\n");
 		h->msix_vector = MAX_REPLY_QUEUES;
 		if (h->msix_vector > num_online_cpus())
 			h->msix_vector = num_online_cpus();
@@ -6024,7 +6023,7 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 	}
 single_msi_mode:
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
-		dev_info(&h->pdev->dev, "MSI\n");
+		dev_info(&h->pdev->dev, "MSI capable controller\n");
 		if (!pci_enable_msi(h->pdev))
 			h->msi_vector = 1;
 		else
@@ -6209,7 +6208,7 @@ static void hpsa_find_board_params(struct ctlr_info *h)
 static inline bool hpsa_CISS_signature_present(struct ctlr_info *h)
 {
 	if (!check_signature(h->cfgtable->Signature, "CISS", 4)) {
-		dev_warn(&h->pdev->dev, "not a valid CISS config table\n");
+		dev_err(&h->pdev->dev, "not a valid CISS config table\n");
 		return false;
 	}
 	return true;
@@ -6301,7 +6300,7 @@ static int hpsa_enter_simple_mode(struct ctlr_info *h)
 	h->transMethod = CFGTBL_Trans_Simple;
 	return 0;
 error:
-	dev_warn(&h->pdev->dev, "unable to get board into simple mode\n");
+	dev_err(&h->pdev->dev, "failed to enter simple mode\n");
 	return -ENODEV;
 }
 
@@ -7282,8 +7281,8 @@ static void hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 	hpsa_wait_for_mode_change_ack(h);
 	register_value = readl(&(h->cfgtable->TransportActive));
 	if (!(register_value & CFGTBL_Trans_Performant)) {
-		dev_warn(&h->pdev->dev, "unable to get board into"
-					" performant mode\n");
+		dev_err(&h->pdev->dev,
+			"performant mode problem - transport not active\n");
 		return;
 	}
 	/* Change the access methods to the performant access methods */

