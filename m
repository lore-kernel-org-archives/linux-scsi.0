From: yxlraid@gmail.com
Subject: [PATCH 9/9] [SCSI] mvsas: Add support for interrupt tasklet
Date: Thu, 30 Jun 2011 22:27:36 +0800
Message-ID: <1309444056-29277-1-git-send-email-yxlraid@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43779 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1F3O2n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2011 10:28:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: James.Bottomley@suse.de, jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, yuxiangl@marvell.com, jfeng@marvell.com

From: Xiangliang Yu <yuxiangl@marvell.com>

-- Add support for interrupt tasklet, which will improve performance.
-- Correct spelling of "20011"

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/Kconfig   |    9 ++++++++-
 drivers/scsi/mvsas/Makefile  |    1 +
 drivers/scsi/mvsas/mv_64xx.c |    6 ++----
 drivers/scsi/mvsas/mv_94xx.c |    5 +----
 drivers/scsi/mvsas/mv_init.c |   32 ++++++++++++++++++++------------
 drivers/scsi/mvsas/mv_sas.h  |    1 +
 6 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/mvsas/Kconfig b/drivers/scsi/mvsas/Kconfig
index c82b012..78f7e20 100644
--- a/drivers/scsi/mvsas/Kconfig
+++ b/drivers/scsi/mvsas/Kconfig
@@ -3,7 +3,7 @@
 #
 # Copyright 2007 Red Hat, Inc.
 # Copyright 2008 Marvell. <kewei@marvell.com>
-# Copyright 2009-20011 Marvell. <yuxiangl@marvell.com>
+# Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
 #
 # This file is licensed under GPLv2.
 #
@@ -41,3 +41,10 @@ config SCSI_MVSAS_DEBUG
 	help
 		Compiles the 88SE64XX/88SE94XX driver in debug mode.  In debug mode,
 		the driver prints some messages to the console.
+config SCSI_MVSAS_TASKLET
+	bool "Support for interrupt tasklet"
+	default n
+	depends on SCSI_MVSAS
+	help
+		Compiles the 88SE64xx/88SE94xx driver in interrupt tasklet mode.In this mode,
+		the interrupt will schedule a tasklet.
diff --git a/drivers/scsi/mvsas/Makefile b/drivers/scsi/mvsas/Makefile
index 87b231a..40aae8a 100644
--- a/drivers/scsi/mvsas/Makefile
+++ b/drivers/scsi/mvsas/Makefile
@@ -23,6 +23,7 @@
 # USA
 
 ccflags-$(CONFIG_SCSI_MVSAS_DEBUG) := -DMV_DEBUG
+ccflags-$(CONFIG_SCSI_MVSAS_TASKLET) := -DMVS_USE_TASKLET
 
 obj-$(CONFIG_SCSI_MVSAS) += mvsas.o
 mvsas-y +=  mv_init.o  \
diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
index dec5f96..8ba4722 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -471,13 +471,11 @@ static irqreturn_t mvs_64xx_isr(struct mvs_info *mvi, int irq, u32 stat)
 
 	/* clear CMD_CMPLT ASAP */
 	mw32_f(MVS_INT_STAT, CINT_DONE);
-#ifndef MVS_USE_TASKLET
+
 	spin_lock(&mvi->lock);
-#endif
 	mvs_int_full(mvi);
-#ifndef MVS_USE_TASKLET
 	spin_unlock(&mvi->lock);
-#endif
+
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index f4a995c..3501291 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -579,13 +579,10 @@ static irqreturn_t mvs_94xx_isr(struct mvs_info *mvi, int irq, u32 stat)
 	if (((stat & IRQ_SAS_A) && mvi->id == 0) ||
 			((stat & IRQ_SAS_B) && mvi->id == 1)) {
 		mw32_f(MVS_INT_STAT, CINT_DONE);
-	#ifndef MVS_USE_TASKLET
+
 		spin_lock(&mvi->lock);
-	#endif
 		mvs_int_full(mvi);
-	#ifndef MVS_USE_TASKLET
 		spin_unlock(&mvi->lock);
-	#endif
 	}
 	return IRQ_HANDLED;
 }
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index cf4aaa9..77dea68 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -171,10 +171,8 @@ static void mvs_free(struct mvs_info *mvi)
 }
 
 #ifdef MVS_USE_TASKLET
-struct tasklet_struct	mv_tasklet;
 static void mvs_tasklet(unsigned long opaque)
 {
-	unsigned long flags;
 	u32 stat;
 	u16 core_nr, i = 0;
 
@@ -187,12 +185,16 @@ static void mvs_tasklet(unsigned long opaque)
 	if (unlikely(!mvi))
 		BUG_ON(1);
 
+	stat = MVS_CHIP_DISP->isr_status(mvi, mvi->pdev->irq);
+	if (!stat)
+		goto out;
+
 	for (i = 0; i < core_nr; i++) {
 		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[i];
-		stat = MVS_CHIP_DISP->isr_status(mvi, mvi->irq);
-		if (stat)
-			MVS_CHIP_DISP->isr(mvi, mvi->irq, stat);
+		MVS_CHIP_DISP->isr(mvi, mvi->pdev->irq, stat);
 	}
+out:
+	MVS_CHIP_DISP->interrupt_enable(mvi);
 
 }
 #endif
@@ -209,13 +211,20 @@ static irqreturn_t mvs_interrupt(int irq, void *opaque)
 
 	if (unlikely(!mvi))
 		return IRQ_NONE;
+#ifdef MVS_USE_TASKLET
+	MVS_CHIP_DISP->interrupt_disable(mvi);
+#endif
 
 	stat = MVS_CHIP_DISP->isr_status(mvi, irq);
-	if (!stat)
+	if (!stat) {
+	#ifdef MVS_USE_TASKLET
+		MVS_CHIP_DISP->interrupt_enable(mvi);
+	#endif
 		return IRQ_NONE;
+	}
 
 #ifdef MVS_USE_TASKLET
-	tasklet_schedule(&mv_tasklet);
+	tasklet_schedule(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
 #else
 	for (i = 0; i < core_nr; i++) {
 		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[i];
@@ -388,9 +397,6 @@ static struct mvs_info *__devinit mvs_pci_alloc(struct pci_dev *pdev,
 	mvi->id = id;
 	mvi->sas = sha;
 	mvi->shost = shost;
-#ifdef MVS_USE_TASKLET
-	tasklet_init(&mv_tasklet, mvs_tasklet, (unsigned long)sha);
-#endif
 
 	mvi->tags = kzalloc(MVS_CHIP_SLOT_SZ>>3, GFP_KERNEL);
 	if (!mvi->tags)
@@ -535,6 +541,7 @@ static int __devinit mvs_pci_init(struct pci_dev *pdev,
 {
 	unsigned int rc, nhost = 0;
 	struct mvs_info *mvi;
+	struct mvs_prv_info *mpi;
 	irq_handler_t irq_handler = mvs_interrupt;
 	struct Scsi_Host *shost = NULL;
 	const struct mvs_chip_info *chip;
@@ -599,8 +606,9 @@ static int __devinit mvs_pci_init(struct pci_dev *pdev,
 		}
 		nhost++;
 	} while (nhost < chip->n_host);
+	mpi = (struct mvs_prv_info *)(SHOST_TO_SAS_HA(shost)->lldd_ha);
 #ifdef MVS_USE_TASKLET
-	tasklet_init(&mv_tasklet, mvs_tasklet,
+	tasklet_init(&(mpi->mv_tasklet), mvs_tasklet,
 		     (unsigned long)SHOST_TO_SAS_HA(shost));
 #endif
 
@@ -646,7 +654,7 @@ static void __devexit mvs_pci_remove(struct pci_dev *pdev)
 	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
 
 #ifdef MVS_USE_TASKLET
-	tasklet_kill(&mv_tasklet);
+	tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
 #endif
 
 	pci_set_drvdata(pdev, NULL);
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 56ece2e..37d23a3 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -420,6 +420,7 @@ struct mvs_prv_info{
 	u8 scan_finished;
 	u8 reserve;
 	struct mvs_info *mvi[2];
+	struct tasklet_struct mv_tasklet;
 };
 
 struct mvs_wq {
-- 
1.7.4.4

