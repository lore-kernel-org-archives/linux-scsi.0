From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 06/19] be2iscsi: No return value for hwi_enable_intr
Date: Thu, 22 Jul 2010 04:23:22 +0530
Message-ID: <20100721225311.GA9407@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:24384 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755129Ab0GUWxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 18:53:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

 hwi_enable_intr need not return any value. This patch fixes the
that and removes code designed to handle a failure return value

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |   24 +++++-------------------
 1 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 3b54dc7..26ac049 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3172,7 +3172,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 	return 0;
 }
 
-static unsigned char hwi_enable_intr(struct beiscsi_hba *phba)
+static void hwi_enable_intr(struct beiscsi_hba *phba)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct hwi_controller *phwi_ctrlr;
@@ -3207,7 +3207,6 @@ static unsigned char hwi_enable_intr(struct beiscsi_hba *phba)
 			}
 		}
 	}
-	return true;
 }
 
 static void hwi_disable_intr(struct beiscsi_hba *phba)
@@ -3773,7 +3772,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
 	struct be_eq_obj *pbe_eq;
-	int ret, msix_vec, num_cpus, i;
+	int ret, num_cpus, i;
 
 	ret = beiscsi_enable_pci(pcidev);
 	if (ret < 0) {
@@ -3874,25 +3873,10 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 			     "Failed to beiscsi_init_irqs\n");
 		goto free_blkenbld;
 	}
-	ret = hwi_enable_intr(phba);
-	if (ret < 0) {
-		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
-			     "Failed to hwi_enable_intr\n");
-		goto free_ctrlr;
-	}
+	hwi_enable_intr(phba);
 	SE_DEBUG(DBG_LVL_8, "\n\n\n SUCCESS - DRIVER LOADED\n\n\n");
 	return 0;
 
-free_ctrlr:
-	if (phba->msix_enabled) {
-		for (i = 0; i <= phba->num_cpus; i++) {
-			msix_vec = phba->msix_entries[i].vector;
-			free_irq(msix_vec, &phwi_context->be_eq[i]);
-		}
-	} else
-		if (phba->pcidev->irq)
-			free_irq(phba->pcidev->irq, phba);
-	pci_disable_msix(phba->pcidev);
 free_blkenbld:
 	destroy_workqueue(phba->wq);
 	if (blk_iopoll_enabled)
@@ -3910,6 +3894,8 @@ free_port:
 			   phba->ctrl.mbox_mem_alloced.dma);
 	beiscsi_unmap_pci_function(phba);
 hba_free:
+	if (phba->msix_enabled)
+		pci_disable_msix(phba->pcidev);
 	iscsi_host_remove(phba->shost);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
-- 
1.6.5.2

