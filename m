From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 08/23] hpsa: Fallback to MSI rather than to INTx if MSI-X failed
Date: Mon, 24 Feb 2014 09:02:08 +0100
Message-ID: <86ea36942166dad4c641425c1e9508a7b5d76836.1393191330.git.agordeev@redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1393191330.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
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
 drivers/scsi/hpsa.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 868318a..52cfd19 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4180,11 +4180,9 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 		if (err > 0) {
 			dev_warn(&h->pdev->dev, "only %d MSI-X vectors "
 			       "available\n", err);
-			goto default_int_mode;
 		} else {
 			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
 			       err);
-			goto default_int_mode;
 		}
 	}
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
-- 
1.7.7.6
