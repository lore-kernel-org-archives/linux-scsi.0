From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: mvsas DMA consistent memory requirements
Date: Tue, 20 Apr 2010 16:13:20 +0200
Message-ID: <20100420141320.GN4586@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58879 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab0DTOca (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2010 10:32:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Yan <ayan@marvell.com>, Ke Wei <kewei@marvell.com>, Ying Chu <jasonchu@marvell.com>
Cc: linux-scsi@vger.kernel.org

On non-SoC adapters, mvsas will try to allocate 512 chunks of DMA
consistent memory of 8 KiB each, while on SoC adapters, it will only
allocate 64.

This lower number for SoC adapters is likely because ARM has a default
system-wide limit of 2 MiB of DMA consistent memory, and allocating
512 * 8 KiB = 4 MiB won't fit.

The implemented solution doesn't work, though, as you can stick a
PCIe mvsas adapter in an ARM box, which will then not be treated as
a SoC adapter, and mvs_pci_init() will try to allocate 4 MiB of DMA
consistent memory and fail (where the only error message ("failed to
allocate slot->buf.\n") is printk'd at KERN_DEBUG severity so that
it won't end up in your logs..)

Rather than checking whether a SoC adapter is being instantiated or
not, shouldn't the check be whether we're building for ARM or not?
E.g. something like the below?


diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
index 1849da1..654d4cd 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -40,14 +40,16 @@ enum chip_flavors {
 
 /* driver compile-time configuration */
 enum driver_configuration {
+#ifndef __arm__
 	MVS_SLOTS		= 512,	/* command slots */
-	MVS_TX_RING_SZ		= 1024,	/* TX ring size (12-bit) */
-	MVS_RX_RING_SZ		= 1024, /* RX ring size (12-bit) */
-					/* software requires power-of-2
-					   ring size */
-	MVS_SOC_SLOTS		= 64,
-	MVS_SOC_TX_RING_SZ	= MVS_SOC_SLOTS * 2,
-	MVS_SOC_RX_RING_SZ	= MVS_SOC_SLOTS * 2,
+#else
+	MVS_SLOTS		= 64,	/* command slots */
+#endif
+
+	MVS_TX_RING_SZ		= MVS_SLOTS * 2, /* TX ring size (12-bit) */
+	MVS_RX_RING_SZ		= MVS_SLOTS * 2, /* RX ring size (12-bit) */
+						 /* software requires
+						    power-of-2 ring size */
 
 	MVS_SLOT_BUF_SZ		= 8192, /* cmd tbl + IU + status + PRD */
 	MVS_SSP_CMD_SZ		= 64,	/* SSP command table buffer size */
@@ -55,7 +57,6 @@ enum driver_configuration {
 	MVS_OAF_SZ		= 64,	/* Open address frame buffer size */
 	MVS_QUEUE_SIZE	= 32,	/* Support Queue depth */
 	MVS_CAN_QUEUE		= MVS_SLOTS - 2,	/* SCSI Queue depth */
-	MVS_SOC_CAN_QUEUE	= MVS_SOC_SLOTS - 2,
 };
 
 /* unchangeable hardware details */
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index cae6b2c..3318ff6 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -110,16 +110,10 @@ static void mvs_free(struct mvs_info *mvi)
 {
 	int i;
 	struct mvs_wq *mwq;
-	int slot_nr;
 
 	if (!mvi)
 		return;
 
-	if (mvi->flags & MVF_FLAG_SOC)
-		slot_nr = MVS_SOC_SLOTS;
-	else
-		slot_nr = MVS_SLOTS;
-
 	for (i = 0; i < mvi->tags_num; i++) {
 		struct mvs_slot_info *slot = &mvi->slot_info[i];
 		if (slot->buf)
@@ -140,7 +134,7 @@ static void mvs_free(struct mvs_info *mvi)
 				  mvi->rx, mvi->rx_dma);
 	if (mvi->slot)
 		dma_free_coherent(mvi->dev,
-				  sizeof(*mvi->slot) * slot_nr,
+				  sizeof(*mvi->slot) * MVS_SLOTS,
 				  mvi->slot, mvi->slot_dma);
 #ifndef DISABLE_HOTPLUG_DMA_FIX
 	if (mvi->bulk_buffer)
@@ -213,12 +207,7 @@ static irqreturn_t mvs_interrupt(int irq, void *opaque)
 
 static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 {
-	int i, slot_nr;
-
-	if (mvi->flags & MVF_FLAG_SOC)
-		slot_nr = MVS_SOC_SLOTS;
-	else
-		slot_nr = MVS_SLOTS;
+	int i;
 
 	spin_lock_init(&mvi->lock);
 	for (i = 0; i < mvi->chip->n_phy; i++) {
@@ -259,11 +248,11 @@ static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 	mvi->rx_cons = 0xfff;
 
 	mvi->slot = dma_alloc_coherent(mvi->dev,
-				       sizeof(*mvi->slot) * slot_nr,
+				       sizeof(*mvi->slot) * MVS_SLOTS,
 				       &mvi->slot_dma, GFP_KERNEL);
 	if (!mvi->slot)
 		goto err_out;
-	memset(mvi->slot, 0, sizeof(*mvi->slot) * slot_nr);
+	memset(mvi->slot, 0, sizeof(*mvi->slot) * MVS_SLOTS);
 
 #ifndef DISABLE_HOTPLUG_DMA_FIX
 	mvi->bulk_buffer = dma_alloc_coherent(mvi->dev,
@@ -272,7 +261,7 @@ static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 	if (!mvi->bulk_buffer)
 		goto err_out;
 #endif
-	for (i = 0; i < slot_nr; i++) {
+	for (i = 0; i < MVS_SLOTS; i++) {
 		struct mvs_slot_info *slot = &mvi->slot_info[i];
 
 		slot->buf = dma_alloc_coherent(mvi->dev, MVS_SLOT_BUF_SZ,
@@ -461,7 +450,7 @@ exit_free:
 static void  __devinit mvs_post_sas_ha_init(struct Scsi_Host *shost,
 			const struct mvs_chip_info *chip_info)
 {
-	int can_queue, i = 0, j = 0;
+	int i = 0, j = 0;
 	struct mvs_info *mvi = NULL;
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 	unsigned short nr_core = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
@@ -485,13 +474,8 @@ static void  __devinit mvs_post_sas_ha_init(struct Scsi_Host *shost,
 
 	sha->lldd_max_execute_num = 1;
 
-	if (mvi->flags & MVF_FLAG_SOC)
-		can_queue = MVS_SOC_CAN_QUEUE;
-	else
-		can_queue = MVS_CAN_QUEUE;
-
-	sha->lldd_queue_size = can_queue;
-	shost->can_queue = can_queue;
+	sha->lldd_queue_size = MVS_CAN_QUEUE;
+	shost->can_queue = MVS_CAN_QUEUE;
 	mvi->shost->cmd_per_lun = MVS_SLOTS/sha->num_phys;
 	sha->core.shost = mvi->shost;
 }
