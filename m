From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 14/17] hpsa: factor out hpsa_free_irqs_and_disable_msix
Date: Tue, 01 May 2012 11:43:21 -0500
Message-ID: <20120501164321.11705.96536.stgit@beardog.cce.hp.com>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index cf2f60e..1351ddf 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4490,15 +4490,23 @@ static void free_irqs(struct ctlr_info *h)
 		free_irq(h->intr[i], &h->q[i]);
 }
 
-static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
+static void hpsa_free_irqs_and_disable_msix(struct ctlr_info *h)
 {
 	free_irqs(h);
 #ifdef CONFIG_PCI_MSI
-	if (h->msix_vector)
-		pci_disable_msix(h->pdev);
-	else if (h->msi_vector)
-		pci_disable_msi(h->pdev);
+	if (h->msix_vector) {
+		if (h->pdev->msix_enabled)
+			pci_disable_msix(h->pdev);
+	} else if (h->msi_vector) {
+		if (h->pdev->msi_enabled)
+			pci_disable_msi(h->pdev);
+	}
 #endif /* CONFIG_PCI_MSI */
+}
+
+static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
+{
+	hpsa_free_irqs_and_disable_msix(h);
 	hpsa_free_sg_chain_blocks(h);
 	hpsa_free_cmd_pool(h);
 	kfree(h->blockFetchTable);
@@ -4853,13 +4861,7 @@ static void hpsa_shutdown(struct pci_dev *pdev)
 	 */
 	hpsa_flush_cache(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-	free_irqs(h);
-#ifdef CONFIG_PCI_MSI
-	if (h->msix_vector)
-		pci_disable_msix(h->pdev);
-	else if (h->msi_vector)
-		pci_disable_msi(h->pdev);
-#endif				/* CONFIG_PCI_MSI */
+	hpsa_free_irqs_and_disable_msix(h);
 }
 
 static void __devexit hpsa_free_device_info(struct ctlr_info *h)
