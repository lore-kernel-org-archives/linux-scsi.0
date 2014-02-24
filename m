From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 09/23] hpsa: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Mon, 24 Feb 2014 09:02:09 +0100
Message-ID: <e490be11a3b734f9c024e8542274ccc495ac3bd2.1393191330.git.agordeev@redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1393191330.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
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
 drivers/scsi/hpsa.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 52cfd19..523a60e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4169,7 +4169,7 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 		goto default_int_mode;
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
 		dev_info(&h->pdev->dev, "MSIX\n");
-		err = pci_enable_msix(h->pdev, hpsa_msix_entries,
+		err = pci_enable_msix_exact(h->pdev, hpsa_msix_entries,
 						MAX_REPLY_QUEUES);
 		if (!err) {
 			for (i = 0; i < MAX_REPLY_QUEUES; i++)
@@ -4177,13 +4177,7 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 			h->msix_vector = 1;
 			return;
 		}
-		if (err > 0) {
-			dev_warn(&h->pdev->dev, "only %d MSI-X vectors "
-			       "available\n", err);
-		} else {
-			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
-			       err);
-		}
+		dev_warn(&h->pdev->dev, "MSI-X init failed %d\n", err);
 	}
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
 		dev_info(&h->pdev->dev, "MSI\n");
-- 
1.7.7.6
