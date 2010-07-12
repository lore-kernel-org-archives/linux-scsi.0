From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 08/20] be2iscsi: Fix to handle request_irq failure
Date: Mon, 12 Jul 2010 23:23:17 +0530
Message-ID: <20100712175304.GA11541@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:32623 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753467Ab0GLRxN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 13:53:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

 This patch handles request_irq failures  by properly cleaning up

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 89fe7e4..d7bfa5e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -616,7 +616,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 	struct pci_dev *pcidev = phba->pcidev;
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
-	int ret, msix_vec, i = 0;
+	int ret, msix_vec, i, j;
 	char desc[32];
 
 	phwi_ctrlr = phba->phwi_ctrlr;
@@ -628,10 +628,24 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 			msix_vec = phba->msix_entries[i].vector;
 			ret = request_irq(msix_vec, be_isr_msix, 0, desc,
 					  &phwi_context->be_eq[i]);
+			if (ret) {
+				shost_printk(KERN_ERR, phba->shost,
+					     "beiscsi_init_irqs-Failed to"
+					     "register msix for i = %d\n", i);
+				if (!i)
+					return ret;
+				goto free_msix_irqs;
+			}
 		}
 		msix_vec = phba->msix_entries[i].vector;
 		ret = request_irq(msix_vec, be_isr_mcc, 0, "beiscsi_msix_mcc",
 				  &phwi_context->be_eq[i]);
+		if (ret) {
+			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs-"
+				     "Failed to register beiscsi_msix_mcc\n");
+			goto free_msix_irqs;
+		}
+
 	} else {
 		ret = request_irq(pcidev->irq, be_isr, IRQF_SHARED,
 				  "beiscsi", phba);
@@ -642,6 +656,10 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 		}
 	}
 	return 0;
+free_msix_irqs:
+	for (j = i; j == 0; j++)
+		free_irq(msix_vec, &phwi_context->be_eq[j]);
+	return ret;
 }
 
 static void hwi_ring_cq_db(struct beiscsi_hba *phba,
-- 
1.6.5.2

