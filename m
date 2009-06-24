From: Abhijeet Joglekar <abjoglek@cisco.com>
Subject: [PATCH] fnic: use DMA_BIT_MASK(nn) instead of deprecated
	DMA_nnBIT_MASK
Date: Wed, 24 Jun 2009 07:42:25 -0700
Message-ID: <20090624144151.9087.71898.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.nuovasystems.com ([67.91.200.194]:6965 "EHLO
	feynman.nuovasystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752468AbZFXP0Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Jun 2009 11:26:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, robert.w.love@intel.com, jeykholt@cisco.com

Robert Love reported warning while building fnic_main.c:
drivers/scsi/fnic/fnic_main.c:478: warning: `DMA_nnBIT_MASK' is deprecated.

Replaced use of DMA_nnBIT_MASK by DMA_BIT_MASK(nn)

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
---
 drivers/scsi/fnic/fnic_main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index a840728..2c266c0 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -473,16 +473,16 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	 * limitation for the device.  Try 40-bit first, and
 	 * fail to 32-bit.
 	 */
-	err = pci_set_dma_mask(pdev, DMA_40BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(40));
 	if (err) {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			shost_printk(KERN_ERR, fnic->lport->host,
 				     "No usable DMA configuration "
 				     "aborting\n");
 			goto err_out_release_regions;
 		}
-		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			shost_printk(KERN_ERR, fnic->lport->host,
 				     "Unable to obtain 32-bit DMA "
@@ -490,7 +490,7 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 			goto err_out_release_regions;
 		}
 	} else {
-		err = pci_set_consistent_dma_mask(pdev, DMA_40BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(40));
 		if (err) {
 			shost_printk(KERN_ERR, fnic->lport->host,
 				     "Unable to obtain 40-bit DMA "


