From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 05/12] be2iscsi: Cleanup of load failure
Date: Wed, 30 Jun 2010 05:29:30 +0530
Message-ID: <20100629235920.GA20234@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:35302 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753330Ab0F3AHf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2010 20:07:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

   This patch reorganizes cleanup incase the driver failed during insmod

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 811a788..8f3e4b9 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3726,8 +3726,6 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 		SE_DEBUG(DBG_LVL_1, " scsi_dma_map Failed\n")
 		return num_sg;
 	}
-	SE_DEBUG(DBG_LVL_4, "xferlen=0x%08x scmd=%p num_sg=%d sernum=%lu\n",
-		  (scsi_bufflen(sc)), sc, num_sg, sc->serial_number);
 	xferlen = scsi_bufflen(sc);
 	sg = scsi_sglist(sc);
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
@@ -3961,10 +3959,10 @@ free_intr:
 			msix_vec = phba->msix_entries[i].vector;
 			free_irq(msix_vec, &phwi_context->be_eq[i]);
 		}
-	} else
+	} else {
 		if (phba->pcidev->irq)
 			free_irq(phba->pcidev->irq, phba);
-	pci_disable_msix(phba->pcidev);
+	}
 free_blkenbld:
 	destroy_workqueue(phba->wq);
 	if (blk_iopoll_enabled)
@@ -3984,13 +3982,14 @@ free_port:
 		value &= 0xfffeffff;
 		writel(value, (void *)real_offset);
 	}
-
 	pci_free_consistent(phba->pcidev,
 			    phba->ctrl.mbox_mem_alloced.size,
 			    phba->ctrl.mbox_mem_alloced.va,
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

