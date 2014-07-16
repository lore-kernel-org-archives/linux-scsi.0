From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 RESEND 02/23] bfa: Do not call pci_enable_msix() after it failed once
Date: Wed, 16 Jul 2014 20:05:06 +0200
Message-ID: <c32fcabee664518b9aeff8bb319aa6980a1bcb38.1405533479.git.agordeev@redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1405533479.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Function pci_enable_msix() should not be called in case
it threw a negative errno from a previous call.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
---
 drivers/scsi/bfa/bfad.c |   48 ++++++++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 7593b7c..bb93180 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1235,33 +1235,31 @@ bfad_setup_intr(struct bfad_s *bfad)
 	   (bfa_asic_id_cb(pdev->device) && !msix_disable_cb)) {
 
 		error = pci_enable_msix(bfad->pcidev, msix_entries, bfad->nvec);
-		if (error) {
-			/* In CT1 & CT2, try to allocate just one vector */
-			if (bfa_asic_id_ctc(pdev->device)) {
-				printk(KERN_WARNING "bfa %s: trying one msix "
-				       "vector failed to allocate %d[%d]\n",
-				       bfad->pci_name, bfad->nvec, error);
-				bfad->nvec = 1;
-				error = pci_enable_msix(bfad->pcidev,
+		/* In CT1 & CT2, try to allocate just one vector */
+		if (error > 0 && bfa_asic_id_ctc(pdev->device)) {
+			printk(KERN_WARNING "bfa %s: trying one msix "
+			       "vector failed to allocate %d[%d]\n",
+			       bfad->pci_name, bfad->nvec, error);
+			bfad->nvec = 1;
+			error = pci_enable_msix(bfad->pcidev,
 						msix_entries, bfad->nvec);
-			}
+		}
 
-			/*
-			 * Only error number of vector is available.
-			 * We don't have a mechanism to map multiple
-			 * interrupts into one vector, so even if we
-			 * can try to request less vectors, we don't
-			 * know how to associate interrupt events to
-			 *  vectors. Linux doesn't duplicate vectors
-			 * in the MSIX table for this case.
-			 */
-			if (error) {
-				printk(KERN_WARNING "bfad%d: "
-				       "pci_enable_msix failed (%d), "
-				       "use line based.\n",
-					bfad->inst_no, error);
-				goto line_based;
-			}
+		/*
+		 * Only error number of vector is available.
+		 * We don't have a mechanism to map multiple
+		 * interrupts into one vector, so even if we
+		 * can try to request less vectors, we don't
+		 * know how to associate interrupt events to
+		 *  vectors. Linux doesn't duplicate vectors
+		 * in the MSIX table for this case.
+		 */
+		if (error) {
+			printk(KERN_WARNING "bfad%d: "
+			       "pci_enable_msix failed (%d), "
+			       "use line based.\n",
+				bfad->inst_no, error);
+			goto line_based;
 		}
 
 		/* Disable INTX in MSI-X mode */
-- 
1.7.7.6
