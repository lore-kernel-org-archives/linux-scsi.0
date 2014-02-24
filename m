From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 04/23] bfa: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Mon, 24 Feb 2014 09:02:04 +0100
Message-ID: <0b55d0b643b1fd831a32c17030b1fc11c011a802.1393191330.git.agordeev@redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1393191330.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/bfa/bfad.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index e7e4774..b7b0733 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1234,26 +1234,18 @@ bfad_setup_intr(struct bfad_s *bfad)
 	if ((bfa_asic_id_ctc(pdev->device) && !msix_disable_ct) ||
 	   (bfa_asic_id_cb(pdev->device) && !msix_disable_cb)) {
 
-		error = pci_enable_msix(bfad->pcidev, msix_entries, bfad->nvec);
+		error = pci_enable_msix_exact(bfad->pcidev,
+					      msix_entries, bfad->nvec);
 		/* In CT1 & CT2, try to allocate just one vector */
-		if (error > 0 && bfa_asic_id_ctc(pdev->device)) {
+		if (error == -ENOSPC && bfa_asic_id_ctc(pdev->device)) {
 			printk(KERN_WARNING "bfa %s: trying one msix "
 			       "vector failed to allocate %d[%d]\n",
 			       bfad->pci_name, bfad->nvec, error);
 			bfad->nvec = 1;
-			error = pci_enable_msix(bfad->pcidev,
-						msix_entries, bfad->nvec);
+			error = pci_enable_msix_exact(bfad->pcidev,
+						      msix_entries, 1);
 		}
 
-		/*
-		 * Only error number of vector is available.
-		 * We don't have a mechanism to map multiple
-		 * interrupts into one vector, so even if we
-		 * can try to request less vectors, we don't
-		 * know how to associate interrupt events to
-		 *  vectors. Linux doesn't duplicate vectors
-		 * in the MSIX table for this case.
-		 */
 		if (error) {
 			printk(KERN_WARNING "bfad%d: "
 			       "pci_enable_msix failed (%d), "
-- 
1.7.7.6
