From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 RESEND 03/23] bfa: Cleanup bfad_setup_intr() function
Date: Mon, 14 Apr 2014 10:05:27 +0200
Message-ID: <29a53def04235be5b589838a851df8f90788247a.1397461652.git.agordeev@redhat.com>
References: <cover.1397461652.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1397461652.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
---
 drivers/scsi/bfa/bfad.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 972ff8d..e7e4774 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1219,7 +1219,7 @@ bfad_install_msix_handler(struct bfad_s *bfad)
 int
 bfad_setup_intr(struct bfad_s *bfad)
 {
-	int error = 0;
+	int error;
 	u32 mask = 0, i, num_bit = 0, max_bit = 0;
 	struct msix_entry msix_entries[MAX_MSIX_ENTRY];
 	struct pci_dev *pdev = bfad->pcidev;
@@ -1279,20 +1279,18 @@ bfad_setup_intr(struct bfad_s *bfad)
 
 		bfad->bfad_flags |= BFAD_MSIX_ON;
 
-		return error;
+		return 0;
 	}
 
 line_based:
-	error = 0;
-	if (request_irq
-	    (bfad->pcidev->irq, (irq_handler_t) bfad_intx, BFAD_IRQ_FLAGS,
-	     BFAD_DRIVER_NAME, bfad) != 0) {
-		/* Enable interrupt handler failed */
-		return 1;
-	}
+	error = request_irq(bfad->pcidev->irq, (irq_handler_t)bfad_intx,
+			    BFAD_IRQ_FLAGS, BFAD_DRIVER_NAME, bfad);
+	if (error)
+		return error;
+
 	bfad->bfad_flags |= BFAD_INTX_ON;
 
-	return error;
+	return 0;
 }
 
 void
-- 
1.7.7.6
