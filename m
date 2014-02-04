From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 08/22] hpsa: Fallback to MSI rather than to INTx if MSI-X failed
Date: Tue,  4 Feb 2014 12:16:54 +0100
Message-ID: <5e62a50e8b663ccca1f362734406f168b6cfdd53.1391512266.git.agordeev@redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/hpsa.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 868318a..68eec7a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4180,13 +4180,14 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 		if (err > 0) {
 			dev_warn(&h->pdev->dev, "only %d MSI-X vectors "
 			       "available\n", err);
-			goto default_int_mode;
+			goto single_msi_mode;
 		} else {
 			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
 			       err);
-			goto default_int_mode;
+			goto single_msi_mode;
 		}
 	}
+single_msi_mode:
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
 		dev_info(&h->pdev->dev, "MSI\n");
 		if (!pci_enable_msi(h->pdev))
-- 
1.7.7.6
