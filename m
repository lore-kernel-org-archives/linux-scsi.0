From: Andy Yan <ayan@marvell.com>
Subject: [PATCH 5/7]MVSAS:Optimization for DMA buffer
Date: Mon, 9 Nov 2009 20:19:52 +0800
Message-ID: <20091109121952.GD32336@Andy.marvell.com>
Reply-To: ayan@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:55990 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZKIDXV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2009 22:23:21 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, jeff@garzik.org, linux-scsi@vger.kernel.org
Cc: qswang@marvell.com, jfeng@marvell.com


>From 0b428877eecefb91b7ec7e9f1a087e5ccf2b0445 Mon Sep 17 00:00:00 2001
From: Andy <ayan@marvell.com>
Date: Fri, 6 Nov 2009 17:25:08 +0800
Subject: [PATCH 5/7] optimization for DMA buffer
  optimization for DMA buffer allocation to get 
  better compatbility with different OS distribution

Signed-off-by: Andy <ayan@marvell.com>
Signed-off-by: Jacky <jfeng@marvell.com>
Signed-off-by: Ke <kewei@marvell.com>

---
 drivers/scsi/mvsas/mv_94xx.h |    2 +-
 drivers/scsi/mvsas/mv_defs.h |    7 +++--
 drivers/scsi/mvsas/mv_init.c |   57 +++++++++++++++++++++++++++++------------
 drivers/scsi/mvsas/mv_sas.c  |    9 ++++--
 drivers/scsi/mvsas/mv_sas.h  |    2 +
 5 files changed, 53 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.h b/drivers/scsi/mvsas/mv_94xx.h
index 1df38a9..d0b081a 100644
--- a/drivers/scsi/mvsas/mv_94xx.h
+++ b/drivers/scsi/mvsas/mv_94xx.h
@@ -187,7 +187,7 @@ struct mvs_prd_imt {
 
 struct mvs_prd {
 	/* 64-bit buffer address */
-	__le64			addr;
+	__le64		addr;
 	/* 22-bit length */
 	__le32		im_len;
 } __attribute__ ((packed));
diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
index 5096de8..f39f16a 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -40,7 +40,6 @@ enum chip_flavors {
 
 /* driver compile-time configuration */
 enum driver_configuration {
-	MVS_SLOTS		= 512,	/* command slots */
 	MVS_TX_RING_SZ		= 1024,	/* TX ring size (12-bit) */
 	MVS_RX_RING_SZ		= 1024, /* RX ring size (12-bit) */
 					/* software requires power-of-2
@@ -53,8 +52,8 @@ enum driver_configuration {
 	MVS_SSP_CMD_SZ		= 64,	/* SSP command table buffer size */
 	MVS_ATA_CMD_SZ		= 96,	/* SATA command table buffer size */
 	MVS_OAF_SZ		= 64,	/* Open address frame buffer size */
-	MVS_QUEUE_SIZE	= 32,	/* Support Queue depth */
-	MVS_CAN_QUEUE		= MVS_SLOTS - 2,	/* SCSI Queue depth */
+	MVS_QUEUE_SIZE	= 64,	/* Support Queue depth */
+	MVS_CAN_QUEUE		= MVS_QUEUE_SIZE - 2,	/* SCSI Queue depth */
 	MVS_SOC_CAN_QUEUE	= MVS_SOC_SLOTS - 2,
 };
 
@@ -397,6 +396,7 @@ enum mvs_event_flags {
 	PHY_PLUG_EVENT	= (3U),
 	PHY_PLUG_IN		= (1U << 0),	/* phy plug in */
 	PHY_PLUG_OUT		= (1U << 1),	/* phy plug out */
+	EXP_BRCT_CHG		= (1U << 2),    /* broadcast change */
 };
 
 enum mvs_port_type {
@@ -507,4 +507,5 @@ enum pci_cfg_comm_registers {
 	PCR_CMD		= 0x04,
 	PCR_MSI_CTRL 	= 0x50,
 };
+
 #endif
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index eca335b..fb1bee0 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -156,6 +156,10 @@ static void mvs_free(struct mvs_info *mvi)
 	if (mvi->bulk_buffer)
 		dma_free_coherent(mvi->dev, TRASH_BUCKET_SIZE,
 				  mvi->bulk_buffer, mvi->bulk_buffer_dma);
+	if (mvi->bulk_buffer1)
+		dma_free_coherent(mvi->dev, TRASH_BUCKET_SIZE,
+				  mvi->bulk_buffer1, mvi->bulk_buffer_dma1);
+
 #endif
 
 	MVS_CHIP_DISP->chip_iounmap(mvi);
@@ -304,21 +308,37 @@ static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 	mvi->bulk_buffer = dma_alloc_coherent(mvi->dev,
 				       TRASH_BUCKET_SIZE,
 				       &mvi->bulk_buffer_dma, GFP_KERNEL);
+
+	mvi->bulk_buffer1 = dma_alloc_coherent(mvi->dev,
+				       TRASH_BUCKET_SIZE,
+				       &mvi->bulk_buffer_dma1, GFP_KERNEL);
+
 	if (!mvi->bulk_buffer)
 		goto err_out;
 #endif
-	for (i = 0; i < slot_nr; i++) {
-		struct mvs_slot_info *slot = &mvi->slot_info[i];
-
-		slot->buf = dma_alloc_coherent(mvi->dev, MVS_SLOT_BUF_SZ,
-					       &slot->buf_dma, GFP_KERNEL);
-		if (!slot->buf) {
+	i = 0;
+	while (i < slot_nr) {
+		buf_size = PAGE_SIZE > MVS_SLOT_BUF_SZ ?
+			PAGE_SIZE : MVS_SLOT_BUF_SZ;
+		buf = dma_alloc_coherent(mvi->dev, buf_size,
+				&buf_dma, GFP_KERNEL);
+
+		if (!buf) {
 			printk(KERN_DEBUG"failed to allocate slot->buf.\n");
 			goto err_out;
 		}
-		memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
-		++mvi->tags_num;
+		j = 0;
+		do {
+			slot = &mvi->slot_info[i + j];
+			slot->buf = buf + MVS_SLOT_BUF_SZ * j;
+			slot->buf_dma = buf_dma + MVS_SLOT_BUF_SZ * j;
+			memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
+			++mvi->tags_num;
+			j++;
+		} while (j < PAGE_SIZE/MVS_SLOT_BUF_SZ);
+		i += j;
 	}
+
 	/* Initialize tags */
 	mvs_tag_init(mvi);
 	return 0;
@@ -385,14 +405,17 @@ static struct mvs_info *__devinit mvs_pci_alloc(struct pci_dev *pdev,
 				const struct pci_device_id *ent,
 				struct Scsi_Host *shost, unsigned int id)
 {
-	struct mvs_info *mvi;
+	struct mvs_info *mvi = NULL;
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 
-	mvi = kzalloc(sizeof(*mvi) + MVS_SLOTS * sizeof(struct mvs_slot_info),
-			GFP_KERNEL);
+	mvi = kzalloc(sizeof(*mvi) +
+		(1L << mvs_chips[ent->driver_data].slot_width)
+		* sizeof(struct mvs_slot_info), GFP_KERNEL);
 	if (!mvi)
 		return NULL;
-
+	memset(mvi, 0, sizeof(*mvi)+(1L <<
+		mvs_chips[ent->driver_data].slot_width)
+		* sizeof(struct mvs_slot_info));
 	mvi->pdev = pdev;
 	mvi->dev = &pdev->dev;
 	mvi->chip_id = ent->driver_data;
@@ -425,10 +448,10 @@ static int pci_go_64(struct pci_dev *pdev)
 {
 	int rc;
 
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
 		if (rc) {
-			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 			if (rc) {
 				dev_printk(KERN_ERR, &pdev->dev,
 					   "64-bit DMA enable failed\n");
@@ -436,13 +459,13 @@ static int pci_go_64(struct pci_dev *pdev)
 			}
 		}
 	} else {
-		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 		if (rc) {
 			dev_printk(KERN_ERR, &pdev->dev,
 				   "32-bit DMA enable failed\n");
 			return rc;
 		}
-		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 		if (rc) {
 			dev_printk(KERN_ERR, &pdev->dev,
 				   "32-bit consistent DMA enable failed\n");
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 7423fc9..09023d7 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -719,9 +719,12 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 	/* fill in PRD (scatter/gather) table, if any */
 	MVS_CHIP_DISP->make_prd(task->scatter, tei->n_elem, buf_prd);
 #ifndef DISABLE_HOTPLUG_DMA_FIX
-	if (task->data_dir == DMA_FROM_DEVICE)
-		MVS_CHIP_DISP->dma_fix(mvi->bulk_buffer_dma,
-				TRASH_BUCKET_SIZE, tei->n_elem, buf_prd);
+	if (task->data_dir == DMA_FROM_DEVICE) {
+		dma_addr_t _dmaAddr = ((phy_mask <= 0x08) ?
+			mvi->bulk_buffer_dma : mvi->bulk_buffer_dma1);
+		MVS_CHIP_DISP->dma_fix(_dmaAddr, TRASH_BUCKET_SIZE,
+			tei->n_elem, buf_prd);
+	}
 #endif
 	return 0;
 }
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index ffddace..b0f43e7 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -340,6 +340,8 @@ struct mvs_info {
 #ifndef DISABLE_HOTPLUG_DMA_FIX
 	void *bulk_buffer;
 	dma_addr_t bulk_buffer_dma;
+	void *bulk_buffer1;
+	dma_addr_t bulk_buffer_dma1;
 #define TRASH_BUCKET_SIZE    	0x20000
 #endif
 	struct mvs_slot_info slot_info[0];
-- 
1.6.2.2

