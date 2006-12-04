From: akpm@osdl.org
Subject: [patch 2/2] aic94xx: Don't call pci_map_sg for already-mapped scatterlists
Date: Mon, 04 Dec 2006 15:21:03 -0800
Message-ID: <200612042322.kB4NMCb4009034@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57257 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758878AbWLDXWU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 18:22:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, djwong@us.ibm.com

From: "Darrick J. Wong" <djwong@us.ibm.com>

It turns out that libata has already dma_map_sg'd the scatterlist entries
that go with an ata_queued_cmd by the time it calls sas_ata_qc_issue. 
sas_ata_qc_issue passes this scatterlist to aic94xx.  Unfortunately,
aic94xx assumes that any scatterlist passed to it needs to be
pci_map_sg'd...  which blows away the mapping that libata created!  This
causes (on a x260) Calgary IOMMU table leaks and duplicate frees when
aic94xx and libata try to {pci,dma}_unmap_sg the scatterlist.

Since dma_map_sg and pci_map_sg are fed the same struct device, I think
it's safe to add a flag to sas_task that tells aic94xx that it need not map
the scatterlist.  It didn't break anything on the x260, though I don't have
any SATAPI devices to test with.  Is this the correct approach to fixing
this problem?

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic94xx/aic94xx_task.c |   17 +++++++++++------
 drivers/scsi/libsas/sas_ata.c       |    1 +
 include/scsi/libsas.h               |    3 +--
 3 files changed, 13 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/aic94xx/aic94xx_task.c~aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists drivers/scsi/aic94xx/aic94xx_task.c
--- a/drivers/scsi/aic94xx/aic94xx_task.c~aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists
+++ a/drivers/scsi/aic94xx/aic94xx_task.c
@@ -74,8 +74,11 @@ static inline int asd_map_scatterlist(st
 		return 0;
 	}
 
-	num_sg = pci_map_sg(asd_ha->pcidev, task->scatter, task->num_scatter,
-			    task->data_dir);
+	if (task->external_sg)
+		num_sg = task->num_scatter;
+	else
+		num_sg = pci_map_sg(asd_ha->pcidev, task->scatter,
+				    task->num_scatter, task->data_dir);
 	if (num_sg == 0)
 		return -ENOMEM;
 
@@ -120,8 +123,9 @@ static inline int asd_map_scatterlist(st
 
 	return 0;
 err_unmap:
-	pci_unmap_sg(asd_ha->pcidev, task->scatter, task->num_scatter,
-		     task->data_dir);
+	if (!task->external_sg)
+		pci_unmap_sg(asd_ha->pcidev, task->scatter, task->num_scatter,
+			     task->data_dir);
 	return res;
 }
 
@@ -142,8 +146,9 @@ static inline void asd_unmap_scatterlist
 	}
 
 	asd_free_coherent(asd_ha, ascb->sg_arr);
-	pci_unmap_sg(asd_ha->pcidev, task->scatter, task->num_scatter,
-		     task->data_dir);
+	if (!task->external_sg)
+		pci_unmap_sg(asd_ha->pcidev, task->scatter, task->num_scatter,
+			     task->data_dir);
 }
 
 /* ---------- Task complete tasklet ---------- */
diff -puN drivers/scsi/libsas/sas_ata.c~aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists drivers/scsi/libsas/sas_ata.c
--- a/drivers/scsi/libsas/sas_ata.c~aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists
+++ a/drivers/scsi/libsas/sas_ata.c
@@ -158,6 +158,7 @@ static unsigned int sas_ata_qc_issue(str
 		task->num_scatter = num;
 	}
 
+	task->external_sg = 1;
 	task->data_dir = qc->dma_dir;
 	task->scatter = qc->__sg;
 	task->ata_task.retry_count = 1;
diff -puN include/scsi/libsas.h~aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists include/scsi/libsas.h
--- a/include/scsi/libsas.h~aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists
+++ a/include/scsi/libsas.h
@@ -537,12 +537,11 @@ struct sas_task {
 
 	void   *lldd_task;	  /* for use by LLDDs */
 	void   *uldd_task;
+	int    external_sg;
 
 	struct work_struct abort_work;
 };
 
-
-
 #define SAS_TASK_STATE_PENDING      1
 #define SAS_TASK_STATE_DONE         2
 #define SAS_TASK_STATE_ABORTED      4
_
