From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 07/20] be2iscsi: No return value for hwi_enable_intr
Date: Mon, 12 Jul 2010 23:22:44 +0530
Message-ID: <20100712175234.GA11516@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:32168 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756460Ab0GLRwk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 13:52:40 -0400
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
index 3ad3b59..89fe7e4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3171,7 +3171,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 	return 0;
 }
 
-static unsigned char hwi_enable_intr(struct beiscsi_hba *phba)
+static void hwi_enable_intr(struct beiscsi_hba *phba)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct hwi_controller *phwi_ctrlr;
@@ -3206,7 +3206,6 @@ static unsigned char hwi_enable_intr(struct beiscsi_hba *phba)
 			}
 		}
 	}
-	return true;
 }
 
 static void hwi_disable_intr(struct beiscsi_hba *phba)
@@ -3772,7 +3771,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
 	struct be_eq_obj *pbe_eq;
-	int ret, msix_vec, num_cpus, i;
+	int ret, num_cpus, i;
 
 	ret = beiscsi_enable_pci(pcidev);
 	if (ret < 0) {
@@ -3873,25 +3872,10 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
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
@@ -3909,6 +3893,8 @@ free_port:
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

