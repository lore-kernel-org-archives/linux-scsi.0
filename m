From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 RESEND 08/23] hpsa: Fallback to MSI rather than to INTx if MSI-X failed
Date: Wed, 16 Jul 2014 20:05:12 +0200
Message-ID: <3ca64c251518a2db8810534b4e63ec696bcfeefd.1405533479.git.agordeev@redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <cover.1405533479.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently the driver falls back to INTx mode when MSI-X
initialization failed. This is a suboptimal behaviour
for chips that also support MSI. This update changes that
behaviour and falls back to MSI mode in case MSI-X mode
initialization failed.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/hpsa.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 31184b3..648dec2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6177,7 +6177,6 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
 			       err);
 			h->msix_vector = 0;
-			goto default_int_mode;
 		}
 	}
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
-- 
1.7.7.6
