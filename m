From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v3 13/13] pmcraid: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Mon, 18 Aug 2014 08:01:53 +0200
Message-ID: <0f19a7660054e85da9f2137d21d198fbe7ddd71c.1408335523.git.agordeev@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p50936449.dip0.t-ipconnect.de ([80.147.100.73]:30499 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751862AbaHRIzU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2014 04:55:20 -0400
In-Reply-To: <cover.1408335523.git.agordeev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/pmcraid.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 6e575ed..bcb64eb 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4698,19 +4698,10 @@ pmcraid_register_interrupt_handler(struct pmcraid_instance *pinstance)
 		for (i = 0; i < PMCRAID_NUM_MSIX_VECTORS; i++)
 			entries[i].entry = i;
 
-		rc = pci_enable_msix(pdev, entries, num_hrrq);
-		if (rc < 0)
+		num_hrrq = pci_enable_msix_range(pdev, entries, 1, num_hrrq);
+		if (num_hrrq < 0)
 			goto pmcraid_isr_legacy;
 
-		/* Check how many MSIX vectors are allocated and register
-		 * msi-x handlers for each of them giving appropriate buffer
-		 */
-		if (rc > 0) {
-			num_hrrq = rc;
-			if (pci_enable_msix(pdev, entries, num_hrrq))
-				goto pmcraid_isr_legacy;
-		}
-
 		for (i = 0; i < num_hrrq; i++) {
 			pinstance->hrrq_vector[i].hrrq_id = i;
 			pinstance->hrrq_vector[i].drv_inst = pinstance;
-- 
1.9.3

