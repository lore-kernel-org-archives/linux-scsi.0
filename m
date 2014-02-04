From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 09/22] hpsa: Use pci_enable_msix_range()
Date: Tue,  4 Feb 2014 12:16:55 +0100
Message-ID: <0c2c5eba34a7903d36ac2908d608bc2d47a491a7.1391512266.git.agordeev@redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479AbaBDLQw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Feb 2014 06:16:52 -0500
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/hpsa.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 68eec7a..3323628 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4169,23 +4169,17 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 		goto default_int_mode;
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
 		dev_info(&h->pdev->dev, "MSIX\n");
-		err = pci_enable_msix(h->pdev, hpsa_msix_entries,
-						MAX_REPLY_QUEUES);
-		if (!err) {
-			for (i = 0; i < MAX_REPLY_QUEUES; i++)
-				h->intr[i] = hpsa_msix_entries[i].vector;
-			h->msix_vector = 1;
-			return;
-		}
-		if (err > 0) {
-			dev_warn(&h->pdev->dev, "only %d MSI-X vectors "
-			       "available\n", err);
-			goto single_msi_mode;
-		} else {
+		err = pci_enable_msix_range(h->pdev, hpsa_msix_entries,
+					    MAX_REPLY_QUEUES, MAX_REPLY_QUEUES);
+		if (err < 0) {
 			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
 			       err);
 			goto single_msi_mode;
 		}
+		for (i = 0; i < MAX_REPLY_QUEUES; i++)
+			h->intr[i] = hpsa_msix_entries[i].vector;
+		h->msix_vector = 1;
+		return;
 	}
 single_msi_mode:
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
-- 
1.7.7.6

