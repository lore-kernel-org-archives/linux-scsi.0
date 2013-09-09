From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 3/9] fnic: On system with >1.1TB RAM, VIC fails multipath after boot up
Date: Mon,  9 Sep 2013 13:31:47 -0700
Message-ID: <1378758713-22443-3-git-send-email-hiralpat@cisco.com>
References: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-2.cisco.com ([173.37.86.73]:56604 "EHLO
	rcdn-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab3IIUgT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2013 16:36:19 -0400
In-Reply-To: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Brian Uchino <buchino@cisco.com>, Hiral Patel <hiralpat@cisco.com>

From: Brian Uchino <buchino@cisco.com>

Issue was seen when SCSI buffer address is more than 40 bits in system
with more than 1.1TB RAM. When SCSI buffer is passed to VIC, it is failing
to map to correct buffer address, as DMA mask is set to 40 bits in driver
initialization. Corrected DMA_MASK from 40-bits to 64-bits to avoid masking
41-64 bits addresses.

Signed-off-by: Brian Uchino <buchino@cisco.com>
Signed-off-by: Hiral Patel <hiralpat@cisco.com>
---
 drivers/scsi/fnic/fnic_main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index b619dab..835a9cd 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -581,10 +581,10 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_master(pdev);
 
 	/* Query PCI controller on system for DMA addressing
-	 * limitation for the device.  Try 40-bit first, and
+	 * limitation for the device.  Try 64-bit first, and
 	 * fail to 32-bit.
 	 */
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(40));
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (err) {
 		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
@@ -601,10 +601,10 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			goto err_out_release_regions;
 		}
 	} else {
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(40));
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (err) {
 			shost_printk(KERN_ERR, fnic->lport->host,
-				     "Unable to obtain 40-bit DMA "
+				     "Unable to obtain 64-bit DMA "
 				     "for consistent allocations, aborting.\n");
 			goto err_out_release_regions;
 		}
-- 
1.7.10.4

