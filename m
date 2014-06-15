From: Joe Perches <joe@perches.com>
Subject: [PATCH -next 19/26] lpfc: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:48 -0700
Message-ID: <a442398ba7fd22971ffc7ee95db3ca3ebcf2a887.1402863905.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c  |  5 ++---
 drivers/scsi/lpfc/lpfc_init.c | 22 +++++++---------------
 drivers/scsi/lpfc/lpfc_mbox.c |  6 +++---
 drivers/scsi/lpfc/lpfc_sli.c  | 14 +++++---------
 4 files changed, 17 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 5b5c825..c8ad7fe 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2693,14 +2693,13 @@ lpfc_bsg_dma_page_alloc(struct lpfc_hba *phba)
 	INIT_LIST_HEAD(&dmabuf->list);
 
 	/* now, allocate dma buffer */
-	dmabuf->virt = dma_alloc_coherent(&pcidev->dev, BSG_MBOX_SIZE,
-					  &(dmabuf->phys), GFP_KERNEL);
+	dmabuf->virt = dma_zalloc_coherent(&pcidev->dev, BSG_MBOX_SIZE,
+					   &(dmabuf->phys), GFP_KERNEL);
 
 	if (!dmabuf->virt) {
 		kfree(dmabuf);
 		return NULL;
 	}
-	memset((uint8_t *)dmabuf->virt, 0, BSG_MBOX_SIZE);
 
 	return dmabuf;
 }
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 06f9a5b..6fd761b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5848,16 +5848,14 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba *phba)
 	if (!dmabuf)
 		return NULL;
 
-	dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
-					  LPFC_HDR_TEMPLATE_SIZE,
-					  &dmabuf->phys,
-					  GFP_KERNEL);
+	dmabuf->virt = dma_zalloc_coherent(&phba->pcidev->dev,
+					   LPFC_HDR_TEMPLATE_SIZE,
+					   &dmabuf->phys, GFP_KERNEL);
 	if (!dmabuf->virt) {
 		rpi_hdr = NULL;
 		goto err_free_dmabuf;
 	}
 
-	memset(dmabuf->virt, 0, LPFC_HDR_TEMPLATE_SIZE);
 	if (!IS_ALIGNED(dmabuf->phys, LPFC_HDR_TEMPLATE_SIZE)) {
 		rpi_hdr = NULL;
 		goto err_free_coherent;
@@ -6246,14 +6244,11 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *phba)
 	}
 
 	/* Allocate memory for SLI-2 structures */
-	phba->slim2p.virt = dma_alloc_coherent(&pdev->dev,
-					       SLI2_SLIM_SIZE,
-					       &phba->slim2p.phys,
-					       GFP_KERNEL);
+	phba->slim2p.virt = dma_zalloc_coherent(&pdev->dev, SLI2_SLIM_SIZE,
+						&phba->slim2p.phys, GFP_KERNEL);
 	if (!phba->slim2p.virt)
 		goto out_iounmap;
 
-	memset(phba->slim2p.virt, 0, SLI2_SLIM_SIZE);
 	phba->mbox = phba->slim2p.virt + offsetof(struct lpfc_sli2_slim, mbx);
 	phba->mbox_ext = (phba->slim2p.virt +
 		offsetof(struct lpfc_sli2_slim, mbx_ext_words));
@@ -6618,15 +6613,12 @@ lpfc_create_bootstrap_mbox(struct lpfc_hba *phba)
 	 * plus an alignment restriction of 16 bytes.
 	 */
 	bmbx_size = sizeof(struct lpfc_bmbx_create) + (LPFC_ALIGN_16_BYTE - 1);
-	dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
-					  bmbx_size,
-					  &dmabuf->phys,
-					  GFP_KERNEL);
+	dmabuf->virt = dma_zalloc_coherent(&phba->pcidev->dev, bmbx_size,
+					   &dmabuf->phys, GFP_KERNEL);
 	if (!dmabuf->virt) {
 		kfree(dmabuf);
 		return -ENOMEM;
 	}
-	memset(dmabuf->virt, 0, bmbx_size);
 
 	/*
 	 * Initialize the bootstrap mailbox pointers now so that the register
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 1f292e2..06241f5 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1811,12 +1811,12 @@ lpfc_sli4_config(struct lpfc_hba *phba, struct lpfcMboxq *mbox,
 		 * page, this is used as a priori size of SLI4_PAGE_SIZE for
 		 * the later DMA memory free.
 		 */
-		viraddr = dma_alloc_coherent(&phba->pcidev->dev, SLI4_PAGE_SIZE,
-					     &phyaddr, GFP_KERNEL);
+		viraddr = dma_zalloc_coherent(&phba->pcidev->dev,
+					      SLI4_PAGE_SIZE, &phyaddr,
+					      GFP_KERNEL);
 		/* In case of malloc fails, proceed with whatever we have */
 		if (!viraddr)
 			break;
-		memset(viraddr, 0, SLI4_PAGE_SIZE);
 		mbox->sge_array->addr[pagen] = viraddr;
 		/* Keep the first page for later sub-header construction */
 		if (pagen == 0)
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 32ada05..a418a04 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4864,15 +4864,12 @@ lpfc_sli4_read_rev(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 	 * mailbox command.
 	 */
 	dma_size = *vpd_size;
-	dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
-					  dma_size,
-					  &dmabuf->phys,
-					  GFP_KERNEL);
+	dmabuf->virt = dma_zalloc_coherent(&phba->pcidev->dev, dma_size,
+					   &dmabuf->phys, GFP_KERNEL);
 	if (!dmabuf->virt) {
 		kfree(dmabuf);
 		return -ENOMEM;
 	}
-	memset(dmabuf->virt, 0, dma_size);
 
 	/*
 	 * The SLI4 implementation of READ_REV conflicts at word1,
@@ -12760,14 +12757,13 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t entry_size,
 		dmabuf = kzalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 		if (!dmabuf)
 			goto out_fail;
-		dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
-						  hw_page_size, &dmabuf->phys,
-						  GFP_KERNEL);
+		dmabuf->virt = dma_zalloc_coherent(&phba->pcidev->dev,
+						   hw_page_size, &dmabuf->phys,
+						   GFP_KERNEL);
 		if (!dmabuf->virt) {
 			kfree(dmabuf);
 			goto out_fail;
 		}
-		memset(dmabuf->virt, 0, hw_page_size);
 		dmabuf->buffer_tag = x;
 		list_add_tail(&dmabuf->list, &queue->page_list);
 		/* initialize queue's entry array */
-- 
1.8.1.2.459.gbcd45b4.dirty
