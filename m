From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v3 02/13] hpsa: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Mon, 18 Aug 2014 08:01:42 +0200
Message-ID: <ad815b18d123f49d95fba82bedd209193e5d4d4e.1408335523.git.agordeev@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p50936449.dip0.t-ipconnect.de ([80.147.100.73]:30499 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752371AbaHRIzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2014 04:55:22 -0400
In-Reply-To: <cover.1408335523.git.agordeev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/hpsa.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a9c4c9f..8c17c43 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6159,25 +6159,22 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 		h->msix_vector = MAX_REPLY_QUEUES;
 		if (h->msix_vector > num_online_cpus())
 			h->msix_vector = num_online_cpus();
-		err = pci_enable_msix(h->pdev, hpsa_msix_entries,
-				      h->msix_vector);
-		if (err > 0) {
+		err = pci_enable_msix_range(h->pdev, hpsa_msix_entries,
+					    1, h->msix_vector);
+		if (err < 0) {
+			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n", err);
+			h->msix_vector = 0;
+			goto single_msi_mode;
+		} else if (err < h->msix_vector) {
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
1.9.3

