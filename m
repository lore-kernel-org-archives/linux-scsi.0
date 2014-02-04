From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 17/22] pm8001: Use pci_enable_msix_range()
Date: Tue,  4 Feb 2014 12:17:03 +0100
Message-ID: <b6ab9b0f70327c1a394dd8923576dfcae571a5b3.1391512266.git.agordeev@redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbaBDLQD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Feb 2014 06:16:03 -0500
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, xjtuwjp@gmail.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: xjtuwjp@gmail.com
Cc: lindar_liu@usish.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/pm8001/pm8001_init.c |   47 +++++++++++++++++++------------------
 1 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index efffbb9..2d4b06e 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -724,34 +724,35 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 		sizeof(pm8001_ha->msix_entries[0]);
 	for (i = 0; i < max_entry ; i++)
 		pm8001_ha->msix_entries[i].entry = i;
-	rc = pci_enable_msix(pm8001_ha->pdev, pm8001_ha->msix_entries,
-		number_of_intr);
+	rc = pci_enable_msix_range(pm8001_ha->pdev, pm8001_ha->msix_entries,
+		number_of_intr, number_of_intr);
 	pm8001_ha->number_of_intr = number_of_intr;
-	if (!rc) {
-		PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
-			"pci_enable_msix request ret:%d no of intr %d\n",
-					rc, pm8001_ha->number_of_intr));
-
-
-		for (i = 0; i < number_of_intr; i++) {
-			snprintf(intr_drvname[i], sizeof(intr_drvname[0]),
-					DRV_NAME"%d", i);
-			pm8001_ha->irq_vector[i].irq_id = i;
-			pm8001_ha->irq_vector[i].drv_inst = pm8001_ha;
-
-			rc = request_irq(pm8001_ha->msix_entries[i].vector,
-				pm8001_interrupt_handler_msix, flag,
-				intr_drvname[i], &(pm8001_ha->irq_vector[i]));
-			if (rc) {
-				for (j = 0; j < i; j++)
-					free_irq(
-					pm8001_ha->msix_entries[j].vector,
+	if (rc < 0)
+		return rc;
+
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
+		"pci_enable_msix request ret:%d no of intr %d\n",
+				rc, pm8001_ha->number_of_intr));
+
+	for (i = 0; i < number_of_intr; i++) {
+		snprintf(intr_drvname[i], sizeof(intr_drvname[0]),
+				DRV_NAME"%d", i);
+		pm8001_ha->irq_vector[i].irq_id = i;
+		pm8001_ha->irq_vector[i].drv_inst = pm8001_ha;
+
+		rc = request_irq(pm8001_ha->msix_entries[i].vector,
+			pm8001_interrupt_handler_msix, flag,
+			intr_drvname[i], &(pm8001_ha->irq_vector[i]));
+		if (rc) {
+			for (j = 0; j < i; j++) {
+				free_irq(pm8001_ha->msix_entries[j].vector,
 					&(pm8001_ha->irq_vector[i]));
-				pci_disable_msix(pm8001_ha->pdev);
-				break;
 			}
+			pci_disable_msix(pm8001_ha->pdev);
+			break;
 		}
 	}
+
 	return rc;
 }
 #endif
-- 
1.7.7.6

