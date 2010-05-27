From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 03/24] hpsa: factor out hpsa_board_disabled
Date: Thu, 27 May 2010 15:12:57 -0500
Message-ID: <20100527201257.3116.15309.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:26742 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab0E0UIR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:08:17 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: factor out hpsa_board_disabled

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0d6a088..eb4fb56 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3286,9 +3286,16 @@ static int __devinit hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 	return ARRAY_SIZE(products) - 1; /* generic unknown smart array */
 }
 
+static inline bool hpsa_board_disabled(struct pci_dev *pdev)
+{
+	u16 command;
+
+	(void) pci_read_config_word(pdev, PCI_COMMAND, &command);
+	return ((command & PCI_COMMAND_MEMORY) == 0);
+}
+
 static int __devinit hpsa_pci_init(struct ctlr_info *h)
 {
-	ushort command;
 	u32 scratchpad = 0;
 	u64 cfg_offset;
 	u32 cfg_base_addr;
@@ -3302,15 +3309,10 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 	h->product_name = products[prod_index].product_name;
 	h->access = *(products[prod_index].access);
 
-	/* check to see if controller has been disabled
-	 * BEFORE trying to enable it
-	 */
-	(void)pci_read_config_word(h->pdev, PCI_COMMAND, &command);
-	if (!(command & 0x02)) {
+	if (hpsa_board_disabled(h->pdev)) {
 		dev_warn(&h->pdev->dev, "controller appears to be disabled\n");
 		return -ENODEV;
 	}
-
 	err = pci_enable_device(h->pdev);
 	if (err) {
 		dev_warn(&h->pdev->dev, "unable to enable PCI device\n");

