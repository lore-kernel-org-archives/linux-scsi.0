From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 RESEND 10/23] hpsa: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Mon, 14 Apr 2014 10:05:34 +0200
Message-ID: <6e17ab33b0ddbe49f72bf0d9c5fd3019acf6d6ca.1397461652.git.agordeev@redhat.com>
References: <cover.1397461652.git.agordeev@redhat.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <cover.1397461652.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/hpsa.c |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3284edb..36bb1e4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6144,26 +6144,23 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 		goto default_int_mode;
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
 		dev_info(&h->pdev->dev, "MSIX\n");
-		h->msix_vector = MAX_REPLY_QUEUES;
-		err = pci_enable_msix(h->pdev, hpsa_msix_entries,
-				      h->msix_vector);
-		if (err > 0) {
+		err = pci_enable_msix_range(h->pdev, hpsa_msix_entries,
+					    1, MAX_REPLY_QUEUES);
+		if (err < 0) {
+			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n", err);
+			h->msix_vector = 0;
+			goto single_msi_mode;
+		} else if (err < MAX_REPLY_QUEUES) {
 			dev_warn(&h->pdev->dev, "only %d MSI-X vectors "
 			       "available\n", err);
-			h->msix_vector = err;
-			err = pci_enable_msix(h->pdev, hpsa_msix_entries,
-					      h->msix_vector);
-		}
-		if (!err) {
-			for (i = 0; i < h->msix_vector; i++)
-				h->intr[i] = hpsa_msix_entries[i].vector;
-			return;
-		} else {
-			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
-			       err);
-			h->msix_vector = 0;
 		}
+
+		h->msix_vector = err;
+		for (i = 0; i < h->msix_vector; i++)
+			h->intr[i] = hpsa_msix_entries[i].vector;
+		return;
 	}
+single_msi_mode:
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
 		dev_info(&h->pdev->dev, "MSI\n");
 		if (!pci_enable_msi(h->pdev))
-- 
1.7.7.6
