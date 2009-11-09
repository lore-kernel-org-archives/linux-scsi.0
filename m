From: Andy Yan <ayan@marvell.com>
Subject: [PATCH 6/7]MVSAS: Enhanced hot plug handling
Date: Mon, 9 Nov 2009 20:27:13 +0800
Message-ID: <20091109122713.GE32336@Andy.marvell.com>
Reply-To: ayan@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:56414 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbZKIDag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2009 22:30:36 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, jeff@garzik.org, linux-scsi@vger.kernel.org
Cc: qswang@marvell.com, jfeng@marvell.com


>From 894361e5503f4ddc9a073173e2e3942fd7f40905 Mon Sep 17 00:00:00 2001
From: Andy <ayan@marvell.com>
Date: Fri, 6 Nov 2009 17:33:49 +0800
Subject: [PATCH 6/7] bug fix with hot plug.
  Add code to make the disk IO more stable when hot plug disk,
  and refined some code with usage of HW resource,enhanced error
  checking.

Signed-off-by: Andy <ayan@marvell.com>
Signed-off-by: Jacky <jfeng@marvell.com>
Signed-off-by: Ke <kewei@marvell.com>
---
 drivers/scsi/mvsas/mv_64xx.c |   27 ++++-
 drivers/scsi/mvsas/mv_94xx.c |  146 +++++++++++++++----
 drivers/scsi/mvsas/mv_init.c |   28 +++-
 drivers/scsi/mvsas/mv_sas.c  |  320 ++++++++++++++++++++++++++++-------------
 drivers/scsi/mvsas/mv_sas.h  |   14 ++-
 5 files changed, 389 insertions(+), 146 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
index 4c005fa..f0097d9 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -132,9 +132,9 @@ static void mvs_64xx_phy_reset(struct mvs_info *mvi, u32 phy_id, int hard)
 	tmp &= ~PHYEV_RDY_CH;
 	mvs_write_port_irq_stat(mvi, phy_id, tmp);
 	tmp = mvs_read_phy_ctl(mvi, phy_id);
-	if (hard)
+	if (hard == 1)
 		tmp |= PHY_RST_HARD;
-	else
+	else if (hard == 0)
 		tmp |= PHY_RST;
 	mvs_write_phy_ctl(mvi, phy_id, tmp);
 	if (hard) {
@@ -487,6 +487,28 @@ static void mvs_64xx_command_active(struct mvs_info *mvi, u32 slot_idx)
 	} while (tmp & 1 << (slot_idx % 32));
 }
 
+void mvs_64xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set, u8 clear_all)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+
+	if (clear_all) {
+		tmp = mr32(MVS_INT_STAT_SRS_0);
+		if (tmp) {
+			mv_printk("check SRS 0 %08X.\n", tmp);
+			mw32(MVS_INT_STAT_SRS_0, tmp);
+		}
+	} else {
+		tmp = mr32(MVS_INT_STAT_SRS_0);
+		if (tmp &  (1 << (reg_set % 32))) {
+			mv_printk("register set 0x%x was stopped.\n", reg_set);
+			mw32(MVS_INT_STAT_SRS_0, 1 << (reg_set % 32));
+		}
+	}
+}
+
+
 static void mvs_64xx_issue_stop(struct mvs_info *mvi, enum mvs_port_type type,
 				u32 tfs)
 {
@@ -769,6 +791,7 @@ const struct mvs_dispatch mvs_64xx_dispatch = {
 	mvs_write_port_irq_mask,
 	mvs_get_sas_addr,
 	mvs_64xx_command_active,
+	mvs_64xx_clear_srs_irq,
 	mvs_64xx_issue_stop,
 	mvs_start_delivery,
 	mvs_rx_update,
diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index bb1026d..cfec794 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -60,7 +60,14 @@ static void __devinit mvs_94xx_enable_xmt(struct mvs_info *mvi, int phy_id)
 static void mvs_94xx_phy_reset(struct mvs_info *mvi, u32 phy_id, int hard)
 {
 	u32 tmp;
-
+	u32 delay = 5000;
+	if (hard == 2) {
+		mvs_write_port_cfg_addr(mvi, phy_id, PHYR_SATA_CTL);
+		tmp = mvs_read_port_cfg_data(mvi, phy_id);
+		mvs_write_port_cfg_data(mvi, phy_id, tmp|0x20000000);
+		mvs_write_port_cfg_data(mvi, phy_id, tmp|0x100000);
+		return;
+	}
 	tmp = mvs_read_port_irq_stat(mvi, phy_id);
 	tmp &= ~PHYEV_RDY_CH;
 	mvs_write_port_irq_stat(mvi, phy_id, tmp);
@@ -70,7 +77,12 @@ static void mvs_94xx_phy_reset(struct mvs_info *mvi, u32 phy_id, int hard)
 		mvs_write_phy_ctl(mvi, phy_id, tmp);
 		do {
 			tmp = mvs_read_phy_ctl(mvi, phy_id);
-		} while (tmp & PHY_RST_HARD);
+			udelay(10);
+			delay--;
+		} while ((tmp & PHY_RST_HARD) && delay);
+
+		if (!delay)
+			mv_dprintk("phy hard reset failed.\n");
 	} else {
 		mvs_write_port_vsr_addr(mvi, phy_id, VSR_PHY_STAT);
 		tmp = mvs_read_port_vsr_data(mvi, phy_id);
@@ -89,12 +101,23 @@ static void mvs_94xx_phy_disable(struct mvs_info *mvi, u32 phy_id)
 
 static void mvs_94xx_phy_enable(struct mvs_info *mvi, u32 phy_id)
 {
-	mvs_write_port_vsr_addr(mvi, phy_id, 0x1B4);
-	mvs_write_port_vsr_data(mvi, phy_id, 0x8300ffc1);
-	mvs_write_port_vsr_addr(mvi, phy_id, 0x104);
-	mvs_write_port_vsr_data(mvi, phy_id, 0x00018080);
-	mvs_write_port_vsr_addr(mvi, phy_id, VSR_PHY_MODE2);
-	mvs_write_port_vsr_data(mvi, phy_id, 0x00207fff);
+	u32 tmp;
+	u8 revision = 0;
+
+	revision = mvi->pdev->revision;
+	if (revision == 0xa0) {
+		mvs_write_port_vsr_addr(mvi, phy_id, 0x000001b4);
+		mvs_write_port_vsr_data(mvi, phy_id, 0x8300ffc1);
+	}
+	if (revision == 0x01) {
+		mvs_write_port_vsr_addr(mvi, phy_id, 0x00000144);
+		mvs_write_port_vsr_data(mvi, phy_id, 0x08001006);
+		mvs_write_port_vsr_addr(mvi, phy_id, 0x000001b4);
+		mvs_write_port_vsr_data(mvi, phy_id, 0x0000705f);
+	}
+	mvs_write_port_vsr_addr(mvi, phy_id, 0x00000008);
+	tmp = 0x0084d4ff;
+	mvs_write_port_vsr_data(mvi, phy_id, tmp & 0xfd7fffff);
 }
 
 static int __devinit mvs_94xx_init(struct mvs_info *mvi)
@@ -359,23 +382,63 @@ static irqreturn_t mvs_94xx_isr(struct mvs_info *mvi, int irq, u32 stat)
 static void mvs_94xx_command_active(struct mvs_info *mvi, u32 slot_idx)
 {
 	u32 tmp;
-	mvs_cw32(mvi, 0x300 + (slot_idx >> 3), 1 << (slot_idx % 32));
-	do {
-		tmp = mvs_cr32(mvi, 0x300 + (slot_idx >> 3));
-	} while (tmp & 1 << (slot_idx % 32));
+	tmp = mvs_cr32(mvi, MVS_COMMAND_ACTIVE+(slot_idx >> 3));
+	if (tmp && 1 << (slot_idx % 32)) {
+		mv_printk("command active %08X,  slot [%x].\n", tmp, slot_idx);
+		mvs_cw32(mvi, MVS_COMMAND_ACTIVE +
+			(slot_idx >> 3), 1 << (slot_idx % 32));
+		do {
+			tmp = mvs_cr32(mvi,
+				MVS_COMMAND_ACTIVE + (slot_idx >> 3));
+		} while (tmp & 1 << (slot_idx % 32));
+	}
+
+}
+
+void mvs_94xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set, u8 clear_all)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+
+	if (clear_all) {
+		tmp = mr32(MVS_INT_STAT_SRS_0);
+		if (tmp) {
+			mv_printk("check SRS 0 %08X.\n", tmp);
+			mw32(MVS_INT_STAT_SRS_0, tmp);
+		}
+		tmp = mr32(MVS_INT_STAT_SRS_1);
+		if (tmp) {
+			mv_printk("check SRS 1 %08X.\n", tmp);
+			mw32(MVS_INT_STAT_SRS_1, tmp);
+		}
+	} else {
+		if (reg_set > 31)
+			tmp = mr32(MVS_INT_STAT_SRS_1);
+		else
+			tmp = mr32(MVS_INT_STAT_SRS_0);
+
+		if (tmp &  (1 << (reg_set % 32))) {
+			mv_printk("register set 0x%x was stopped.\n", reg_set);
+			if (reg_set > 31)
+				mw32(MVS_INT_STAT_SRS_1, 1 << (reg_set % 32));
+			else
+				mw32(MVS_INT_STAT_SRS_0, 1 << (reg_set % 32));
+
+		}
+	}
 }
 
+
 static void mvs_94xx_issue_stop(struct mvs_info *mvi, enum mvs_port_type type,
 				u32 tfs)
 {
 	void __iomem *regs = mvi->regs;
 	u32 tmp;
+	mvs_94xx_clear_srs_irq(mvi, 0, 1);
 
-	if (type == PORT_TYPE_SATA) {
-		tmp = mr32(MVS_INT_STAT_SRS_0) | (1U << tfs);
-		mw32(MVS_INT_STAT_SRS_0, tmp);
-	}
-	mw32(MVS_INT_STAT, CINT_CI_STOP);
+	tmp = mr32(MVS_INT_STAT);
+	mw32(MVS_INT_STAT, tmp | CINT_CI_STOP);
 	tmp = mr32(MVS_PCS) | 0xFF00;
 	mw32(MVS_PCS, tmp);
 }
@@ -383,24 +446,16 @@ static void mvs_94xx_issue_stop(struct mvs_info *mvi, enum mvs_port_type type,
 static void mvs_94xx_free_reg_set(struct mvs_info *mvi, u8 *tfs)
 {
 	void __iomem *regs = mvi->regs;
-	u32 tmp;
 	u8 reg_set = *tfs;
 
 	if (*tfs == MVS_ID_NOT_MAPPED)
 		return;
 
 	mvi->sata_reg_set &= ~bit(reg_set);
-	if (reg_set < 32) {
+	if (reg_set < 32)
 		w_reg_set_enable(reg_set, (u32)mvi->sata_reg_set);
-		tmp = mr32(MVS_INT_STAT_SRS_0) & (u32)mvi->sata_reg_set;
-		if (tmp)
-			mw32(MVS_INT_STAT_SRS_0, tmp);
-	} else {
-		w_reg_set_enable(reg_set, mvi->sata_reg_set);
-		tmp = mr32(MVS_INT_STAT_SRS_1) & mvi->sata_reg_set;
-		if (tmp)
-			mw32(MVS_INT_STAT_SRS_1, tmp);
-	}
+	else
+		w_reg_set_enable(reg_set, (u32)(mvi->sata_reg_set >> 32));
 
 	*tfs = MVS_ID_NOT_MAPPED;
 
@@ -416,7 +471,7 @@ static u8 mvs_94xx_assign_reg_set(struct mvs_info *mvi, u8 *tfs)
 		return 0;
 
 	i = mv_ffc64(mvi->sata_reg_set);
-	if (i > 32) {
+	if (i >= 32) {
 		mvi->sata_reg_set |= bit(i);
 		w_reg_set_enable(i, (u32)(mvi->sata_reg_set >> 32));
 		*tfs = i;
@@ -540,10 +595,38 @@ static void mvs_94xx_fix_phy_info(struct mvs_info *mvi, int i,
 
 }
 
+static void mvs_94xx_phy_work_around(struct mvs_info *mvi, int i)
+{
+	u32 tmp;
+	struct mvs_phy *phy = &mvi->phy[i];
+	/* workaround for HW phy decoding error on 1.5g disk drive */
+	mvs_write_port_vsr_addr(mvi, i, VSR_PHY_MODE6);
+	tmp = mvs_read_port_vsr_data(mvi, i);
+	if (((phy->phy_status & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
+	     PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET) ==
+		SAS_LINK_RATE_1_5_GBPS)
+		tmp &= ~PHY_MODE6_LATECLK;
+	else
+		tmp |= PHY_MODE6_LATECLK;
+	mvs_write_port_vsr_data(mvi, i, tmp);
+}
+
+
 void mvs_94xx_phy_set_link_rate(struct mvs_info *mvi, u32 phy_id,
 			struct sas_phy_linkrates *rates)
 {
-	/* TODO */
+	u32 lrmax = 0;
+	u32 tmp;
+
+	tmp = mvs_read_phy_ctl(mvi, phy_id);
+	lrmax = (rates->maximum_linkrate - SAS_LINK_RATE_1_5_GBPS) << 12;
+
+	if (lrmax) {
+		tmp &= ~(0x3 << 12);
+		tmp |= lrmax;
+	}
+	mvs_write_phy_ctl(mvi, phy_id, tmp);
+	mvs_94xx_phy_reset(mvi, phy_id, 1);
 }
 
 static void mvs_94xx_clear_active_cmds(struct mvs_info *mvi)
@@ -668,6 +751,7 @@ const struct mvs_dispatch mvs_94xx_dispatch = {
 	mvs_write_port_irq_mask,
 	mvs_get_sas_addr,
 	mvs_94xx_command_active,
+	mvs_94xx_clear_srs_irq,
 	mvs_94xx_issue_stop,
 	mvs_start_delivery,
 	mvs_rx_update,
@@ -680,7 +764,7 @@ const struct mvs_dispatch mvs_94xx_dispatch = {
 	mvs_94xx_detect_porttype,
 	mvs_94xx_oob_done,
 	mvs_94xx_fix_phy_info,
-	NULL,
+	mvs_94xx_phy_work_around,
 	mvs_94xx_phy_set_link_rate,
 	mvs_hw_max_link_rate,
 	mvs_94xx_phy_disable,
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index fb1bee0..0ecb6b6 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -82,7 +82,7 @@ static struct sas_domain_function_template mvs_transport_ops = {
 	.lldd_abort_task	= mvs_abort_task,
 	.lldd_abort_task_set    = mvs_abort_task_set,
 	.lldd_clear_aca         = mvs_clear_aca,
-       .lldd_clear_task_set    = mvs_clear_task_set,
+	.lldd_clear_task_set    = mvs_clear_task_set,
 	.lldd_I_T_nexus_reset	= mvs_I_T_nexus_reset,
 	.lldd_lu_reset 		= mvs_lu_reset,
 	.lldd_query_task	= mvs_query_task,
@@ -190,9 +190,9 @@ static void mvs_tasklet(unsigned long opaque)
 
 	for (i = 0; i < core_nr; i++) {
 		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[i];
-		stat = MVS_CHIP_DISP->isr_status(mvi, mvi->irq);
+		stat = MVS_CHIP_DISP->isr_status(mvi, mvi->pdev->irq);
 		if (stat)
-			MVS_CHIP_DISP->isr(mvi, mvi->irq, stat);
+			MVS_CHIP_DISP->isr(mvi, mvi->pdev->irq, stat);
 	}
 
 }
@@ -252,7 +252,11 @@ static irqreturn_t mvs_interrupt(int irq, void *opaque)
 
 static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 {
-	int i, slot_nr;
+	int i = 0, j = 0, slot_nr;
+	unsigned long buf_size;
+	void *buf;
+	dma_addr_t buf_dma;
+	struct mvs_slot_info *slot = 0;
 
 	if (mvi->flags & MVF_FLAG_SOC)
 		slot_nr = MVS_SOC_SLOTS;
@@ -266,11 +270,13 @@ static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 		mvi->port[i].port_attached = 0;
 		INIT_LIST_HEAD(&mvi->port[i].list);
 	}
+
 	for (i = 0; i < MVS_MAX_DEVICES; i++) {
 		mvi->devices[i].taskfileset = MVS_ID_NOT_MAPPED;
 		mvi->devices[i].dev_type = NO_DEVICE;
 		mvi->devices[i].device_id = i;
 		mvi->devices[i].dev_status = MVS_DEV_NORMAL;
+		init_timer(&mvi->devices[i].timer);
 	}
 
 	/*
@@ -279,11 +285,13 @@ static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 	mvi->tx = dma_alloc_coherent(mvi->dev,
 				     sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ,
 				     &mvi->tx_dma, GFP_KERNEL);
+
 	if (!mvi->tx)
 		goto err_out;
 	memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ);
 	mvi->rx_fis = dma_alloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
 					 &mvi->rx_fis_dma, GFP_KERNEL);
+
 	if (!mvi->rx_fis)
 		goto err_out;
 	memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
@@ -291,6 +299,7 @@ static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 	mvi->rx = dma_alloc_coherent(mvi->dev,
 				     sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
 				     &mvi->rx_dma, GFP_KERNEL);
+
 	if (!mvi->rx)
 		goto err_out;
 	memset(mvi->rx, 0, sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1));
@@ -300,6 +309,7 @@ static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 	mvi->slot = dma_alloc_coherent(mvi->dev,
 				       sizeof(*mvi->slot) * slot_nr,
 				       &mvi->slot_dma, GFP_KERNEL);
+
 	if (!mvi->slot)
 		goto err_out;
 	memset(mvi->slot, 0, sizeof(*mvi->slot) * slot_nr);
@@ -421,7 +431,6 @@ static struct mvs_info *__devinit mvs_pci_alloc(struct pci_dev *pdev,
 	mvi->chip_id = ent->driver_data;
 	mvi->chip = &mvs_chips[mvi->chip_id];
 	INIT_LIST_HEAD(&mvi->wq_list);
-	mvi->irq = pdev->irq;
 
 	((struct mvs_prv_info *)sha->lldd_ha)->mvi[id] = mvi;
 	((struct mvs_prv_info *)sha->lldd_ha)->n_phy = mvi->chip->n_phy;
@@ -496,6 +505,7 @@ static int __devinit mvs_prep_sas_ha_init(struct Scsi_Host *shost,
 
 	sha->sas_phy = arr_phy;
 	sha->sas_port = arr_port;
+	sha->core.shost = shost;
 
 	sha->lldd_ha = kzalloc(sizeof(struct mvs_prv_info), GFP_KERNEL);
 	if (!sha->lldd_ha)
@@ -504,7 +514,7 @@ static int __devinit mvs_prep_sas_ha_init(struct Scsi_Host *shost,
 	((struct mvs_prv_info *)sha->lldd_ha)->n_host = core_nr;
 
 	shost->transportt = mvs_stt;
-	shost->max_id = 128;
+	shost->max_id = MVS_MAX_DEVICES;
 	shost->max_lun = ~0;
 	shost->max_channel = 1;
 	shost->max_cmd_len = 16;
@@ -639,6 +649,10 @@ static int __devinit mvs_pci_init(struct pci_dev *pdev,
 		}
 		nhost++;
 	} while (nhost < chip->n_host);
+#ifdef MVS_USE_TASKLET
+	tasklet_init(&mv_tasklet, mvs_tasklet,
+		(unsigned long)SHOST_TO_SAS_HA(shost));
+#endif
 
 	mvs_post_sas_ha_init(shost, chip);
 
@@ -699,7 +713,7 @@ static void __devexit mvs_pci_remove(struct pci_dev *pdev)
 	scsi_remove_host(mvi->shost);
 
 	MVS_CHIP_DISP->interrupt_disable(mvi);
-	free_irq(mvi->irq, sha);
+	free_irq(mvi->pdev->irq, sha);
 	if (mvi->flags & MVF_MSI) {
 		mvs_disable_msi(mvi);
 		pci_disable_msi(pdev);
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 09023d7..7ced157 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -259,8 +259,6 @@ static inline void mvs_free_reg_set(struct mvs_info *mvi,
 		mv_printk("device has been free.\n");
 		return;
 	}
-	if (dev->runing_req != 0)
-		return;
 	if (dev->taskfileset == MVS_ID_NOT_MAPPED)
 		return;
 	MVS_CHIP_DISP->free_reg_set(mvi, &dev->taskfileset);
@@ -599,7 +597,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 	struct mvs_slot_info *slot;
 	void *buf_prd;
 	u32 tag = tei->tag, hdr_tag;
-	u32 flags, del_q;
+	u32 flags, del_q, phy_mask;
 	void *buf_tmp;
 	u8 *buf_cmd, *buf_oaf;
 	dma_addr_t buf_tmp_dma;
@@ -767,8 +765,6 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 	}
 	if (is_tmf)
 		flags |= (MCH_SSP_FR_TASK << MCH_SSP_FR_TYPE_SHIFT);
-	else
-		flags |= (MCH_SSP_FR_CMD << MCH_SSP_FR_TYPE_SHIFT);
 	hdr->flags = cpu_to_le32(flags | (tei->n_elem << MCH_PRD_LEN_SHIFT));
 	hdr->tags = cpu_to_le32(tag);
 	hdr->data_len = cpu_to_le32(task->total_xfer_len);
@@ -872,25 +868,26 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 
 #define	DEV_IS_GONE(mvi_dev)	((!mvi_dev || (mvi_dev->dev_type == NO_DEVICE)))
 static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
-				struct completion *completion,int is_tmf,
+				struct completion *completion, int is_tmf,
 				struct mvs_tmf_task *tmf)
 {
 	struct domain_device *dev = task->dev;
-	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
+	struct mvs_device *mvi_dev = dev->lldd_dev;
 	struct mvs_info *mvi = mvi_dev->mvi_info;
 	struct mvs_task_exec_info tei;
 	struct sas_task *t = task;
 	struct mvs_slot_info *slot;
 	u32 tag = 0xdeadbeef, rc, n_elem = 0;
 	u32 n = num, pass = 0;
-	unsigned long flags = 0;
+	unsigned long flags = 0, flags_libsas = 0;
 
 	if (!dev->port) {
 		struct task_status_struct *tsm = &t->task_status;
 
 		tsm->resp = SAS_TASK_UNDELIVERED;
 		tsm->stat = SAS_PHY_DOWN;
-		t->task_done(t);
+		if (dev->dev_type != SATA_DEV)
+			t->task_done(t);
 		return 0;
 	}
 
@@ -914,13 +911,22 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 			tei.port = &mvi->port[dev->port->id - mvi->chip->n_phy];
 		else
 			tei.port = &mvi->port[dev->port->id];
-
-		if (!tei.port->port_attached) {
+		if (tei.port && !tei.port->port_attached) {
 			if (sas_protocol_ata(t->task_proto)) {
-				mv_dprintk("port %d does not"
-					"attached device.\n", dev->port->id);
-				rc = SAS_PHY_DOWN;
-				goto out_done;
+				struct task_status_struct *ts = &t->task_status;
+				ts->stat = SAS_PROTO_RESPONSE;
+				ts->stat = SAS_PHY_DOWN;
+				spin_unlock_irqrestore(dev->sata_dev.ap->lock,
+						flags_libsas);
+				spin_unlock_irqrestore(&mvi->lock, flags);
+				t->task_done(t);
+				spin_lock_irqsave(&mvi->lock, flags);
+				spin_lock_irqsave(dev->sata_dev.ap->lock,
+					flags_libsas);
+				if (n > 1)
+					t = list_entry(t->list.next,
+							struct sas_task, list);
+				continue;
 			} else {
 				struct task_status_struct *ts = &t->task_status;
 				ts->resp = SAS_TASK_UNDELIVERED;
@@ -998,11 +1004,16 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 		spin_unlock(&t->task_state_lock);
 
 		mvs_hba_memory_dump(mvi, tag, t->task_proto);
-		mvi_dev->runing_req++;
+		mvi_dev->running_req++;
 		++pass;
 		mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_CHIP_SLOT_SZ - 1);
 		if (n > 1)
 			t = list_entry(t->list.next, struct sas_task, list);
+		if (likely(pass)) {
+			MVS_CHIP_DISP->start_delivery(mvi,
+				(mvi->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
+		}
+
 	} while (--n);
 	rc = 0;
 	goto out_done;
@@ -1017,10 +1028,6 @@ err_out:
 			dma_unmap_sg(mvi->dev, t->scatter, n_elem,
 				     t->data_dir);
 out_done:
-	if (likely(pass)) {
-		MVS_CHIP_DISP->start_delivery(mvi,
-			(mvi->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
-	}
 	spin_unlock_irqrestore(&mvi->lock, flags);
 	return rc;
 }
@@ -1070,9 +1077,9 @@ static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
 	mvs_slot_free(mvi, slot_idx);
 }
 
-static void mvs_update_wideport(struct mvs_info *mvi, int i)
+static void mvs_update_wideport(struct mvs_info *mvi, int phy_no)
 {
-	struct mvs_phy *phy = &mvi->phy[i];
+	struct mvs_phy *phy = &mvi->phy[phy_no];
 	struct mvs_port *port = phy->port;
 	int j, no;
 
@@ -1257,7 +1264,19 @@ static void mvs_port_notify_formed(struct asd_sas_phy *sas_phy, int lock)
 
 static void mvs_port_notify_deformed(struct asd_sas_phy *sas_phy, int lock)
 {
-	/*Nothing*/
+	struct domain_device *dev;
+	struct mvs_phy *phy = sas_phy->lldd_phy;
+	struct mvs_info *mvi = phy->mvi;
+	struct asd_sas_port *port = sas_phy->port;
+	int phy_no = 0;
+
+	while (phy != &mvi->phy[phy_no]) {
+		phy_no++;
+		if (phy_no >= MVS_MAX_PHYS)
+			return;
+	}
+	list_for_each_entry(dev, &port->dev_list, dev_list_node)
+		mvs_do_release_task(phy->mvi, phy_no, NULL);
 }
 
 
@@ -1317,6 +1336,7 @@ int mvs_dev_found_notify(struct domain_device *dev, int lock)
 		goto found_out;
 	}
 	dev->lldd_dev = mvi_device;
+	mvi_device->dev_status = MVS_DEV_NORMAL;
 	mvi_device->dev_type = dev->dev_type;
 	mvi_device->mvi_info = mvi;
 	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type)) {
@@ -1352,18 +1372,18 @@ int mvs_dev_found(struct domain_device *dev)
 	return mvs_dev_found_notify(dev, 1);
 }
 
-void mvs_dev_gone_notify(struct domain_device *dev, int lock)
+void mvs_dev_gone_notify(struct domain_device *dev)
 {
 	unsigned long flags = 0;
 	struct mvs_device *mvi_dev = dev->lldd_dev;
 	struct mvs_info *mvi = mvi_dev->mvi_info;
 
-	if (lock)
-		spin_lock_irqsave(&mvi->lock, flags);
+	spin_lock_irqsave(&mvi->lock, flags);
 
 	if (mvi_dev) {
 		mv_dprintk("found dev[%d:%x] is gone.\n",
 			mvi_dev->device_id, mvi_dev->dev_type);
+		mvs_release_task(mvi, dev);
 		mvs_free_reg_set(mvi, mvi_dev);
 		mvs_free_dev(mvi_dev);
 	} else {
@@ -1371,14 +1391,13 @@ void mvs_dev_gone_notify(struct domain_device *dev, int lock)
 	}
 	dev->lldd_dev = NULL;
 
-	if (lock)
-		spin_unlock_irqrestore(&mvi->lock, flags);
+	spin_unlock_irqrestore(&mvi->lock, flags);
 }
 
 
 void mvs_dev_gone(struct domain_device *dev)
 {
-	mvs_dev_gone_notify(dev, 1);
+	mvs_dev_gone_notify(dev);
 }
 
 static  struct sas_task *mvs_alloc_task(void)
@@ -1501,7 +1520,6 @@ static int mvs_debug_issue_ssp_tmf(struct domain_device *dev,
 				u8 *lun, struct mvs_tmf_task *tmf)
 {
 	struct sas_ssp_task ssp_task;
-	DECLARE_COMPLETION_ONSTACK(completion);
 	if (!(dev->tproto & SAS_PROTOCOL_SSP))
 		return TMF_RESP_FUNC_ESUPP;
 
@@ -1529,19 +1547,17 @@ static int mvs_debug_I_T_nexus_reset(struct domain_device *dev)
 int mvs_lu_reset(struct domain_device *dev, u8 *lun)
 {
 	unsigned long flags;
-	int i, phyno[WIDE_PORT_MAX_PHY], num , rc = TMF_RESP_FUNC_FAILED;
+	int rc = TMF_RESP_FUNC_FAILED;
 	struct mvs_tmf_task tmf_task;
-	struct mvs_device * mvi_dev = dev->lldd_dev;
+	struct mvs_device *mvi_dev = dev->lldd_dev;
 	struct mvs_info *mvi = mvi_dev->mvi_info;
 
 	tmf_task.tmf = TMF_LU_RESET;
 	mvi_dev->dev_status = MVS_DEV_EH;
 	rc = mvs_debug_issue_ssp_tmf(dev, lun, &tmf_task);
 	if (rc == TMF_RESP_FUNC_COMPLETE) {
-		num = mvs_find_dev_phyno(dev, phyno);
 		spin_lock_irqsave(&mvi->lock, flags);
-		for (i = 0; i < num; i++)
-			mvs_release_task(mvi, phyno[i], dev);
+		mvs_release_task(mvi, dev);
 		spin_unlock_irqrestore(&mvi->lock, flags);
 	}
 	/* If failed, fall-through I_T_Nexus reset */
@@ -1553,25 +1569,25 @@ int mvs_lu_reset(struct domain_device *dev, u8 *lun)
 int mvs_I_T_nexus_reset(struct domain_device *dev)
 {
 	unsigned long flags;
-	int i, phyno[WIDE_PORT_MAX_PHY], num , rc = TMF_RESP_FUNC_FAILED;
-	struct mvs_device * mvi_dev = (struct mvs_device *)dev->lldd_dev;
+	int rc = TMF_RESP_FUNC_FAILED;
+	struct mvs_device *mvi_dev = dev->lldd_dev;
 	struct mvs_info *mvi = mvi_dev->mvi_info;
 
 	if (mvi_dev->dev_status != MVS_DEV_EH)
 		return TMF_RESP_FUNC_COMPLETE;
+	else
+		mvi_dev->dev_status = MVS_DEV_NORMAL;
 	rc = mvs_debug_I_T_nexus_reset(dev);
 	mv_printk("%s for device[%x]:rc= %d\n",
 		__func__, mvi_dev->device_id, rc);
 
-	/* housekeeper */
-	num = mvs_find_dev_phyno(dev, phyno);
 	spin_lock_irqsave(&mvi->lock, flags);
-	for (i = 0; i < num; i++)
-		mvs_release_task(mvi, phyno[i], dev);
+	mvs_release_task(mvi, dev);
 	spin_unlock_irqrestore(&mvi->lock, flags);
 
 	return rc;
 }
+
 /* optional SAM-3 */
 int mvs_query_task(struct sas_task *task)
 {
@@ -1583,7 +1599,7 @@ int mvs_query_task(struct sas_task *task)
 	if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SSP) {
 		struct scsi_cmnd * cmnd = (struct scsi_cmnd *)task->uldd_task;
 		struct domain_device *dev = task->dev;
-		struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
+		struct mvs_device *mvi_dev = dev->lldd_dev;
 		struct mvs_info *mvi = mvi_dev->mvi_info;
 
 		int_to_scsilun(cmnd->device->lun, &lun);
@@ -1616,21 +1632,25 @@ int mvs_abort_task(struct sas_task *task)
 	struct scsi_lun lun;
 	struct mvs_tmf_task tmf_task;
 	struct domain_device *dev = task->dev;
-	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
-	struct mvs_info *mvi = mvi_dev->mvi_info;
+	struct mvs_device *mvi_dev = dev->lldd_dev;
+	struct mvs_info *mvi;
 	int rc = TMF_RESP_FUNC_FAILED;
-	unsigned long flags;
 	u32 tag;
 
-	if (mvi->exp_req)
-		mvi->exp_req--;
-	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (!mvi_dev) {
+		mv_printk("Device has removed\n");
+		return TMF_RESP_FUNC_FAILED;
+
+	}
+
+	mvi = mvi_dev->mvi_info;
+
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
-		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		rc = TMF_RESP_FUNC_COMPLETE;
 		goto out;
 	}
-	spin_unlock_irqrestore(&task->task_state_lock, flags);
+
+	mvi_dev->dev_status = MVS_DEV_EH;
 	if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SSP) {
 		struct scsi_cmnd * cmnd = (struct scsi_cmnd *)task->uldd_task;
 
@@ -1641,7 +1661,6 @@ int mvs_abort_task(struct sas_task *task)
 			rc = TMF_RESP_FUNC_FAILED;
 			return rc;
 		}
-
 		tmf_task.tmf = TMF_ABORT_TASK;
 		tmf_task.tag_of_task_to_be_managed = cpu_to_le16(tag);
 
@@ -1651,19 +1670,32 @@ int mvs_abort_task(struct sas_task *task)
 		if (rc == TMF_RESP_FUNC_COMPLETE) {
 			u32 slot_no;
 			struct mvs_slot_info *slot;
-
+			unsigned long flags;
 			if (task->lldd_task) {
 				slot = task->lldd_task;
 				slot_no = (u32) (slot - mvi->slot_info);
+				spin_lock_irqsave(&mvi->lock, flags);
 				mvs_slot_complete(mvi, slot_no, 1);
+				spin_unlock_irqrestore(&mvi->lock, flags);
 			}
 		}
 	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
 		task->task_proto & SAS_PROTOCOL_STP) {
-		/* to do free register_set */
+
+		if (SATA_DEV == dev->dev_type) {
+			struct mvs_slot_info *slot = task->lldd_task;
+			u32    slot_idx =    (u32)(slot - mvi->slot_info);
+
+			printk(KERN_DEBUG "mvs_abort_task() mvi=%p task=%p \
+				slot=%p slot_idx=x%x\n",
+				mvi, task, slot, slot_idx);
+			mvs_tmf_timedout((unsigned long)task);
+			mvs_slot_task_free(mvi, task, slot, slot_idx);
+			rc = TMF_RESP_FUNC_COMPLETE;
+			goto out;
+		}
 	} else {
 		/* SMP */
-
 	}
 out:
 	if (rc != TMF_RESP_FUNC_COMPLETE)
@@ -1671,6 +1703,7 @@ out:
 	return rc;
 }
 
+
 int mvs_abort_task_set(struct domain_device *dev, u8 *lun)
 {
 	int rc = TMF_RESP_FUNC_FAILED;
@@ -1718,17 +1751,33 @@ static int mvs_sata_done(struct mvs_info *mvi, struct sas_task *task,
 	       SATA_RECEIVED_D2H_FIS(mvi_dev->taskfileset),
 	       sizeof(struct dev_to_host_fis));
 	tstat->buf_valid_size = sizeof(*resp);
-	if (unlikely(err))
-		stat = SAS_PROTO_RESPONSE;
+	if (unlikely(err)) {
+		if (unlikely(err & CMD_ISS_STPD))
+			stat = SAS_OPEN_REJECT;
+		else
+			stat = SAS_PROTO_RESPONSE;
+	}
 	return stat;
 }
 
+void mvs_fill_ssp_resp_iu(struct ssp_response_iu *iu,
+				u8 key, u8 asc, u8 asc_q)
+{
+	iu->datapres = 2;
+	iu->response_data_len = 0;
+	iu->sense_data_len = 17;
+	iu->status = 02;
+	mvs_set_sense(iu->sense_data, 17, 0,
+			key, asc, asc_q);
+}
+
 static int mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
 			 u32 slot_idx)
 {
 	struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
 	int stat;
 	u32 err_dw0 = le32_to_cpu(*(u32 *) (slot->response));
+	u32 err_dw1 = le32_to_cpu(*((u32 *)slot->response+1));
 	u32 tfs = 0;
 	enum mvs_port_type type = PORT_TYPE_SAS;
 
@@ -1740,8 +1789,19 @@ static int mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
 	stat = SAM_CHECK_COND;
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SSP:
+	{
 		stat = SAS_ABORTED_TASK;
+		if ((err_dw0 & NO_DEST) || err_dw1 & bit(31)) {
+			struct ssp_response_iu *iu = slot->response +
+						sizeof(struct mvs_err_info);
+			mvs_fill_ssp_resp_iu(iu, NOT_READY, 0x04, 01);
+			sas_ssp_task_response(mvi->dev, task, iu);
+			stat = SAM_CHECK_COND;
+		}
+		if (err_dw1 & bit(31))
+			mv_printk("reuse same slot, retry command.\n");
 		break;
+	}
 	case SAS_PROTOCOL_SMP:
 		stat = SAM_CHECK_COND;
 		break;
@@ -1755,8 +1815,7 @@ static int mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
 
 		task->ata_task.use_ncq = 0;
 		stat = SAS_PROTO_RESPONSE;
-		mvs_sata_done(mvi, task, slot_idx, 1);
-
+		mvs_sata_done(mvi, task, slot_idx, err_dw0);
 	}
 		break;
 	default:
@@ -1765,6 +1824,45 @@ static int mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
 
 	return stat;
 }
+void mvs_set_sense(u8 *buffer, int len, int d_sense,
+		int key, int asc, int ascq)
+{
+	memset(buffer, 0, len);
+
+	if (d_sense) {
+		/* Descriptor format */
+		if (len < 4) {
+			mv_printk("Length %d of sense buffer too small to "
+				"fit sense %x:%x:%x", len, key, asc, ascq);
+		}
+
+		buffer[0] = 0x72;		/* Response Code	*/
+		if (len > 1)
+			buffer[1] = key;	/* Sense Key */
+		if (len > 2)
+			buffer[2] = asc;	/* ASC	*/
+		if (len > 3)
+			buffer[3] = ascq;	/* ASCQ	*/
+	} else {
+		/* Fixed format */
+		if (len < 14) {
+			mv_printk("Length %d of sense buffer too small to "
+				"fit sense %x:%x:%x", len, key, asc, ascq);
+		}
+
+		buffer[0] = 0x70;		/* Response Code	*/
+		if (len > 2)
+			buffer[2] = key;	/* Sense Key */
+		if (len > 7)
+			buffer[7] = 0x0a;	/* Additional Sense Length */
+		if (len > 12)
+			buffer[12] = asc;	/* ASC */
+		if (len > 13)
+			buffer[13] = ascq; /* ASCQ */
+	}
+
+	return;
+}
 
 int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 {
@@ -1773,19 +1871,17 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 	struct sas_task *task = slot->task;
 	struct mvs_device *mvi_dev = NULL;
 	struct task_status_struct *tstat;
-
-	bool aborted;
+	struct domain_device *dev;
+	u32 aborted;
 	void *to;
 	enum exec_status sts;
 
-	if (mvi->exp_req)
-		mvi->exp_req--;
-	if (unlikely(!task || !task->lldd_task))
+	if (unlikely(!task || !task->lldd_task || !task->dev))
 		return -1;
 
 	tstat = &task->task_status;
-	mvi_dev = task->dev->lldd_dev;
-
+	dev = task->dev;
+	mvi_dev = dev->lldd_dev;
 	mvs_hba_cq_dump(mvi);
 
 	spin_lock(&task->task_state_lock);
@@ -1801,33 +1897,25 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 
 	if (unlikely(aborted)) {
 		tstat->stat = SAS_ABORTED_TASK;
-		if (mvi_dev)
-			mvi_dev->runing_req--;
+		if (mvi_dev && mvi_dev->running_req)
+			mvi_dev->running_req--;
 		if (sas_protocol_ata(task->task_proto))
 			mvs_free_reg_set(mvi, mvi_dev);
 
 		mvs_slot_task_free(mvi, task, slot, slot_idx);
 		return -1;
 	}
-
-	if (unlikely(!mvi_dev || !slot->port->port_attached || flags)) {
-		mv_dprintk("port has not device.\n");
+	if (unlikely(!mvi_dev || flags)) {
+		if (!mvi_dev)
+			mv_dprintk("port has not device.\n");
 		tstat->stat = SAS_PHY_DOWN;
 		goto out;
 	}
 
-	/*
-	if (unlikely((rx_desc & RXQ_ERR) || (*(u64 *) slot->response))) {
-		 mv_dprintk("Find device[%016llx] RXQ_ERR %X,
-		 err info:%016llx\n",
-		 SAS_ADDR(task->dev->sas_addr),
-		 rx_desc, (u64)(*(u64 *) slot->response));
-	}
-	*/
-
 	/* error info record present */
 	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
 		tstat->stat = mvs_slot_err(mvi, task, slot_idx);
+		tstat->resp = SAS_TASK_COMPLETE;
 		goto out;
 	}
 
@@ -1854,6 +1942,10 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 			memcpy(to + sg_resp->offset,
 				slot->response + sizeof(struct mvs_err_info),
 				sg_dma_len(sg_resp));
+			memcpy(to + sg_resp->offset,
+				slot->response + sizeof(struct mvs_err_info),
+				sg_resp->length);
+
 			kunmap_atomic(to, KM_IRQ0);
 			break;
 		}
@@ -1869,11 +1961,14 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 		tstat->stat = SAM_CHECK_COND;
 		break;
 	}
-
+	if (!slot->port->port_attached) {
+		mv_dprintk("port %d has removed.\n", slot->port->sas_port.id);
+		tstat->stat = SAS_PHY_DOWN;
+	}
 out:
-	if (mvi_dev) {
-		mvi_dev->runing_req--;
-		if (sas_protocol_ata(task->task_proto))
+	if (mvi_dev && mvi_dev->running_req) {
+		mvi_dev->running_req--;
+		if (sas_protocol_ata(task->task_proto) && !mvi_dev->running_req)
 			mvs_free_reg_set(mvi, mvi_dev);
 	}
 	mvs_slot_task_free(mvi, task, slot, slot_idx);
@@ -1889,10 +1984,10 @@ out:
 	return sts;
 }
 
-void mvs_release_task(struct mvs_info *mvi,
+void mvs_do_release_task(struct mvs_info *mvi,
 		int phy_no, struct domain_device *dev)
 {
-	int i = 0; u32 slot_idx;
+	u32 slot_idx;
 	struct mvs_phy *phy;
 	struct mvs_port *port;
 	struct mvs_slot_info *slot, *slot2;
@@ -1902,6 +1997,9 @@ void mvs_release_task(struct mvs_info *mvi,
 	if (!port)
 		return;
 
+	/* clean cmpl queue in case request is already finished */
+	mvs_int_rx(mvi, false);
+
 	list_for_each_entry_safe(slot, slot2, &port->list, entry) {
 		struct sas_task *task;
 		slot_idx = (u32) (slot - mvi->slot_info);
@@ -1912,18 +2010,24 @@ void mvs_release_task(struct mvs_info *mvi,
 
 		mv_printk("Release slot [%x] tag[%x], task [%p]:\n",
 			slot_idx, slot->slot_tag, task);
-
-		if (task->task_proto & SAS_PROTOCOL_SSP) {
-			mv_printk("attached with SSP task CDB[");
-			for (i = 0; i < 16; i++)
-				mv_printk(" %02x", task->ssp_task.cdb[i]);
-			mv_printk(" ]\n");
-		}
+		MVS_CHIP_DISP->command_active(mvi, slot_idx);
 
 		mvs_slot_complete(mvi, slot_idx, 1);
 	}
 }
 
+
+void mvs_release_task(struct mvs_info *mvi,
+			struct domain_device *dev)
+{
+	int i, phyno[WIDE_PORT_MAX_PHY], num;
+	/* housekeeper */
+	num = mvs_find_dev_phyno(dev, phyno);
+	for (i = 0; i < num; i++)
+		mvs_do_release_task(mvi, phyno[i], dev);
+}
+
+
 static void mvs_phy_disconnected(struct mvs_phy *phy)
 {
 	phy->phy_attached = 0;
@@ -1937,10 +2041,10 @@ static void mvs_work_queue(struct work_struct *work)
 	struct mvs_wq *mwq = container_of(dw, struct mvs_wq, work_q);
 	struct mvs_info *mvi = mwq->mvi;
 
-		u32 phy_no = (unsigned long) mwq->data;
-		struct sas_ha_struct *sas_ha = mvi->sas;
-		struct mvs_phy *phy = &mvi->phy[phy_no];
-		struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	u32 phy_no = (unsigned long) mwq->data;
+	struct sas_ha_struct *sas_ha = mvi->sas;
+	struct mvs_phy *phy = &mvi->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	unsigned long flags;
 
 	spin_lock_irqsave(&mvi->lock, flags);
@@ -2034,24 +2138,30 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
 	* we need check the interrupt status which belongs to per port.
 	*/
 
-	if (phy->irq_status & PHYEV_DCDR_ERR)
-		mv_dprintk("port %d STP decoding error.\n",
-		phy_no+mvi->id*mvi->chip->n_phy);
+	if (phy->irq_status & PHYEV_DCDR_ERR) {
+		mv_dprintk("phy %d STP decoding error.\n",
+		phy_no + mvi->id*mvi->chip->n_phy);
+	}
 
 	if (phy->irq_status & PHYEV_POOF) {
+		mdelay(500);
+		{
 		if (!(phy->phy_event & PHY_PLUG_OUT)) {
 			int dev_sata = phy->phy_type & PORT_TYPE_SATA;
 			int ready;
-			mvs_release_task(mvi, phy_no, NULL);
+			mvs_do_release_task(mvi, phy_no, NULL);
 			phy->phy_event |= PHY_PLUG_OUT;
+				MVS_CHIP_DISP->clear_srs_irq(mvi, 0, 1);
 			mvs_handle_event(mvi,
 				(void *)(unsigned long)phy_no,
 				PHY_PLUG_EVENT);
 			ready = mvs_is_phy_ready(mvi, phy_no);
 			if (!ready)
-				mv_dprintk("phy%d Unplug Notice\n",
+				mv_dprintk("Port %d, phy%d Unplug Notice\n",
+					sas_phy->port->id,
 					phy_no +
 					mvi->id * mvi->chip->n_phy);
+
 			if (ready || dev_sata) {
 				if (MVS_CHIP_DISP->stp_reset)
 					MVS_CHIP_DISP->stp_reset(mvi,
@@ -2060,6 +2170,7 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
 					MVS_CHIP_DISP->phy_reset(mvi,
 							phy_no, 0);
 				return;
+				}
 			}
 		}
 	}
@@ -2078,7 +2189,8 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
 	if (phy->irq_status & (PHYEV_SIG_FIS | PHYEV_ID_DONE)) {
 		phy->phy_status = mvs_is_phy_ready(mvi, phy_no);
 		mvs_sig_remove_timer(phy);
-		mv_dprintk("notify plug in on phy[%d]\n", phy_no);
+		mv_dprintk("notify plug in on phy[%d] with\n", phy_no);
+
 		if (phy->phy_status) {
 			mdelay(10);
 			MVS_CHIP_DISP->detect_porttype(mvi, phy_no);
@@ -2090,6 +2202,10 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
 							phy_no, tmp);
 			}
 			mvs_update_phyinfo(mvi, phy_no, 0);
+			if (phy->phy_type & PORT_TYPE_SAS) {
+				MVS_CHIP_DISP->phy_reset(mvi, phy_no, 2);
+				mdelay(100);
+			}
 			mvs_bytes_dmaed(mvi, phy_no);
 			/* whether driver is going to handle hot plug */
 			if (phy->phy_event & PHY_PLUG_OUT) {
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index b0f43e7..e0ba1f1 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -38,17 +38,17 @@
 #include <linux/irq.h>
 #include <linux/vmalloc.h>
 #include <scsi/libsas.h>
+#include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/sas_ata.h>
 #include <linux/version.h>
 #include "mv_defs.h"
 
 #define DRV_NAME		"mvsas"
-#define DRV_VERSION		"0.8.2"
+#define DRV_VERSION		"0.8.9"
 #define _MV_DUMP		0
 #define MVS_ID_NOT_MAPPED	0x7f
 /* #define DISABLE_HOTPLUG_DMA_FIX */
-#define MAX_EXP_RUNNING_REQ	2
 #define WIDE_PORT_MAX_PHY		4
 #define	MV_DISABLE_NCQ	0
 #define mv_printk(fmt, arg ...)	\
@@ -130,6 +130,7 @@ struct mvs_dispatch {
 
 	void (*get_sas_addr)(void *buf, u32 buflen);
 	void (*command_active)(struct mvs_info *mvi, u32 slot_idx);
+	void (*clear_srs_irq)(struct mvs_info *mvi, u8 reg_set, u8 clear_all);
 	void (*issue_stop)(struct mvs_info *mvi, enum mvs_port_type type,
 				u32 tfs);
 	void (*start_delivery)(struct mvs_info *mvi, u32 tx);
@@ -240,9 +241,10 @@ struct mvs_device {
 	enum sas_dev_type dev_type;
 	struct mvs_info *mvi_info;
 	struct domain_device *sas_device;
+	struct timer_list timer;
 	u32 attached_phy;
 	u32 device_id;
-	u32 runing_req;
+	u32 running_req;
 	u8 taskfileset;
 	u8 dev_status;
 	u16 reserved;
@@ -391,6 +393,8 @@ void mvs_scan_start(struct Scsi_Host *shost);
 int mvs_scan_finished(struct Scsi_Host *shost, unsigned long time);
 int mvs_queue_command(struct sas_task *task, const int num,
 			gfp_t gfp_flags);
+void mvs_set_sense(u8 *buffer, int len, int d_sense,
+		int key, int asc, int ascq);
 int mvs_abort_task(struct sas_task *task);
 int mvs_abort_task_set(struct domain_device *dev, u8 *lun);
 int mvs_clear_aca(struct domain_device *dev, u8 *lun);
@@ -403,7 +407,9 @@ int mvs_lu_reset(struct domain_device *dev, u8 *lun);
 int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags);
 int mvs_I_T_nexus_reset(struct domain_device *dev);
 int mvs_query_task(struct sas_task *task);
-void mvs_release_task(struct mvs_info *mvi, int phy_no,
+void mvs_do_release_task(struct mvs_info *mvi,
+		int phy_no, struct domain_device *dev);
+void mvs_release_task(struct mvs_info *mvi,
 			struct domain_device *dev);
 void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events);
 void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st);
-- 
1.6.2.2

