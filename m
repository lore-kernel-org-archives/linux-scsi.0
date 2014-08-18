From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v3 01/13] hpsa: Fallback to MSI rather than to INTx if MSI-X failed
Date: Mon, 18 Aug 2014 08:01:41 +0200
Message-ID: <16baf29bf7cd9d45de63a4192a9ef9e87ba12936.1408335523.git.agordeev@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1408335523.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently the driver falls back to INTx mode when MSI-X
initialization failed. This is a suboptimal behaviour
for chips that also support MSI. This update changes that
behaviour and falls back to MSI mode in case MSI-X mode
initialization failed.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/hpsa.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6b35d0d..a9c4c9f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6176,7 +6176,6 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
 			       err);
 			h->msix_vector = 0;
-			goto default_int_mode;
 		}
 	}
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
-- 
1.9.3
