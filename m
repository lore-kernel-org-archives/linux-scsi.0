From: "Andy Yan" <ayan@marvell.com>
Subject: [PATCH 3/3] ASIC specific
Date: Thu, 19 Mar 2009 01:50:32 -0700
Message-ID: <FE3F06125A99254E8D92161AA4569C6F0693DCEA@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:25490 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758559AbZCSIug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 04:50:36 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, jeff@garzik.org, Tejun Heo <tj@kernel.org>
Cc: linux-scsi@vger.kernel.org, Michael Wang <qswang@marvell.com>, Jacky Feng <jfeng@marvell.com>, Ying Chu <jasonchu@marvell.com>, Ke Wei <kewei@marvell.com>

>From 75c9c4347bee8ce71f39cc3b5e5eaccfae82eb22 Mon Sep 17 00:00:00 2001
From: Andy Yan <ayan@marvell.com>
Date: Thu, 19 Mar 2009 21:50:36 +0800
Subject: [PATCH 3/3] ASIC specific
This patch adds the specific code for ASIC type, file name shows the
type of ASIC, mv_defs.h gives the common inline function, mv_chips.h
gives the commom structure and const all ASIC shares.

 Signed-off-by: Andy Yan <ayan@marvell.com>
 Signed-off-by: Ke Wei <kewei@marvell.com>
 Signed-off-by: Ying Chu <jasonchu@marvell.com>
---
 drivers/scsi/mvsas/mv_64xx.c  |  770
+++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/mvsas/mv_64xx.h  |  128 +++++++
 drivers/scsi/mvsas/mv_94xx.c  |  651 ++++++++++++++++++++++++++++++++++
 drivers/scsi/mvsas/mv_94xx.h  |  196 +++++++++++
 drivers/scsi/mvsas/mv_chips.h |  249 +++++++++++++
 drivers/scsi/mvsas/mv_defs.h  |  478 +++++++++++++++++++++++++
 6 files changed, 2472 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/mvsas/mv_64xx.c
 create mode 100644 drivers/scsi/mvsas/mv_64xx.h
 create mode 100644 drivers/scsi/mvsas/mv_94xx.c
 create mode 100644 drivers/scsi/mvsas/mv_94xx.h
 create mode 100644 drivers/scsi/mvsas/mv_chips.h
 create mode 100644 drivers/scsi/mvsas/mv_defs.h

diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
new file mode 100644
index 0000000..09074f6
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -0,0 +1,770 @@
+#include "mv_sas.h"
+#include "mv_64xx.h"
+#include "mv_chips.h"
+
+static void mvs_64xx_detect_porttype(struct mvs_info *mvi, int i)
+{
+	void __iomem *regs = mvi->regs;
+	u32 reg;
+	struct mvs_phy *phy = &mvi->phy[i];
+
+	/* TODO check & save device type */
+	reg = mr32(MVS_GBL_PORT_TYPE);
+	phy->phy_type &= ~(PORT_TYPE_SAS | PORT_TYPE_SATA);
+	if (reg & MODE_SAS_SATA & (1 << i))
+		phy->phy_type |= PORT_TYPE_SAS;
+	else
+		phy->phy_type |= PORT_TYPE_SATA;
+}
+
+static void __devinit mvs_64xx_enable_xmt(struct mvs_info *mvi, int
phy_id)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+	tmp = mr32(MVS_PCS);
+	if (mvi->chip->n_phy <= 4)
+		tmp |= 1 << (phy_id + PCS_EN_PORT_XMT_SHIFT);
+	else
+		tmp |= 1 << (phy_id + PCS_EN_PORT_XMT_SHIFT2);
+	mw32(MVS_PCS, tmp);
+}
+
+static void __devinit mvs_64xx_phy_hacks(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+
+	mvs_phy_hacks(mvi);
+
+	if (!(mvi->flags & MVF_FLAG_SOC)) {
+		/* TEST - for phy decoding error, adjust voltage levels
*/
+		mw32(MVS_P0_VSR_ADDR + 0, 0x8);
+		mw32(MVS_P0_VSR_DATA + 0, 0x2F0);
+
+		mw32(MVS_P0_VSR_ADDR + 8, 0x8);
+		mw32(MVS_P0_VSR_DATA + 8, 0x2F0);
+
+		mw32(MVS_P0_VSR_ADDR + 16, 0x8);
+		mw32(MVS_P0_VSR_DATA + 16, 0x2F0);
+
+		mw32(MVS_P0_VSR_ADDR + 24, 0x8);
+		mw32(MVS_P0_VSR_DATA + 24, 0x2F0);
+	} else {
+		int i;
+		/* disable auto port detection */
+		mw32(MVS_GBL_PORT_TYPE, 0);
+		for (i = 0; i < mvi->chip->n_phy; i++) {
+			mvs_write_port_vsr_addr(mvi, i, VSR_PHY_MODE7);
+			mvs_write_port_vsr_data(mvi, i, 0x90000000);
+			mvs_write_port_vsr_addr(mvi, i, VSR_PHY_MODE9);
+			mvs_write_port_vsr_data(mvi, i, 0x50f2);
+			mvs_write_port_vsr_addr(mvi, i, VSR_PHY_MODE11);
+			mvs_write_port_vsr_data(mvi, i, 0x0e);
+		}
+	}
+}
+
+static void mvs_64xx_stp_reset(struct mvs_info *mvi, u32 phy_id)
+{
+	void __iomem *regs = mvi->regs;
+	u32 reg, tmp;
+
+	if (!(mvi->flags & MVF_FLAG_SOC)) {
+		if (phy_id < 4)
+			pci_read_config_dword(mvi->pdev, PCR_PHY_CTL,
&reg);
+		else
+			pci_read_config_dword(mvi->pdev, PCR_PHY_CTL2,
&reg);
+
+	} else
+		reg = mr32(MVS_PHY_CTL);
+
+	tmp = reg;
+	if (phy_id < 4)
+		tmp |= (1U << phy_id) << PCTL_LINK_OFFS;
+	else
+		tmp |= (1U << (phy_id - 4)) << PCTL_LINK_OFFS;
+
+	if (!(mvi->flags & MVF_FLAG_SOC)) {
+		if (phy_id < 4) {
+			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL,
tmp);
+			mdelay(10);
+			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL,
reg);
+		} else {
+			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL2,
tmp);
+			mdelay(10);
+			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL2,
reg);
+		}
+	} else {
+		mw32(MVS_PHY_CTL, tmp);
+		mdelay(10);
+		mw32(MVS_PHY_CTL, reg);
+	}
+}
+
+static void mvs_64xx_phy_reset(struct mvs_info *mvi, u32 phy_id, int
hard)
+{
+	u32 tmp;
+	tmp = mvs_read_port_irq_stat(mvi, phy_id);
+	tmp &= ~PHYEV_RDY_CH;
+	mvs_write_port_irq_stat(mvi, phy_id, tmp);
+	tmp = mvs_read_phy_ctl(mvi, phy_id);
+	if (hard)
+		tmp |= PHY_RST_HARD;
+	else
+		tmp |= PHY_RST;
+	mvs_write_phy_ctl(mvi, phy_id, tmp);
+	if (hard) {
+		do {
+			tmp = mvs_read_phy_ctl(mvi, phy_id);
+		} while (tmp & PHY_RST_HARD);
+	}
+}
+
+static int __devinit mvs_64xx_chip_reset(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+	int i;
+
+	/* make sure interrupts are masked immediately (paranoia) */
+	mw32(MVS_GBL_CTL, 0);
+	tmp = mr32(MVS_GBL_CTL);
+
+	/* Reset Controller */
+	if (!(tmp & HBA_RST)) {
+		if (mvi->flags & MVF_PHY_PWR_FIX) {
+			pci_read_config_dword(mvi->pdev, PCR_PHY_CTL,
&tmp);
+			tmp &= ~PCTL_PWR_OFF;
+			tmp |= PCTL_PHY_DSBL;
+			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL,
tmp);
+
+			pci_read_config_dword(mvi->pdev, PCR_PHY_CTL2,
&tmp);
+			tmp &= ~PCTL_PWR_OFF;
+			tmp |= PCTL_PHY_DSBL;
+			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL2,
tmp);
+		}
+	}
+
+	/* make sure interrupts are masked immediately (paranoia) */
+	mw32(MVS_GBL_CTL, 0);
+	tmp = mr32(MVS_GBL_CTL);
+
+	/* Reset Controller */
+	if (!(tmp & HBA_RST)) {
+		/* global reset, incl. COMRESET/H_RESET_N
(self-clearing) */
+		mw32_f(MVS_GBL_CTL, HBA_RST);
+	}
+
+	/* wait for reset to finish; timeout is just a guess */
+	i = 1000;
+	while (i-- > 0) {
+		msleep(10);
+
+		if (!(mr32(MVS_GBL_CTL) & HBA_RST))
+			break;
+	}
+	if (mr32(MVS_GBL_CTL) & HBA_RST) {
+		dev_printk(KERN_ERR, mvi->dev, "HBA reset failed\n");
+		return -EBUSY;
+	}
+	return 0;
+}
+
+static void mvs_64xx_phy_disable(struct mvs_info *mvi, u32 phy_id)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+	if (!(mvi->flags & MVF_FLAG_SOC)) {
+		u32 offs;
+		if (phy_id < 4)
+			offs = PCR_PHY_CTL;
+		else {
+			offs = PCR_PHY_CTL2;
+			phy_id -= 4;
+		}
+		pci_read_config_dword(mvi->pdev, offs, &tmp);
+		tmp |= 1U << (PCTL_PHY_DSBL_OFFS + phy_id);
+		pci_write_config_dword(mvi->pdev, offs, tmp);
+	} else {
+		tmp = mr32(MVS_PHY_CTL);
+		tmp |= 1U << (PCTL_PHY_DSBL_OFFS + phy_id);
+		mw32(MVS_PHY_CTL, tmp);
+	}
+}
+
+static void mvs_64xx_phy_enable(struct mvs_info *mvi, u32 phy_id)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+	if (!(mvi->flags & MVF_FLAG_SOC)) {
+		u32 offs;
+		if (phy_id < 4)
+			offs = PCR_PHY_CTL;
+		else {
+			offs = PCR_PHY_CTL2;
+			phy_id -= 4;
+		}
+		pci_read_config_dword(mvi->pdev, offs, &tmp);
+		tmp &= ~(1U << (PCTL_PHY_DSBL_OFFS + phy_id));
+		pci_write_config_dword(mvi->pdev, offs, tmp);
+	} else {
+		tmp = mr32(MVS_PHY_CTL);
+		tmp &= ~(1U << (PCTL_PHY_DSBL_OFFS + phy_id));
+		mw32(MVS_PHY_CTL, tmp);
+	}
+}
+
+static int __devinit mvs_64xx_init(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+	int i;
+	u32 tmp, cctl;
+
+	if (mvi->pdev && mvi->pdev->revision == 0)
+		mvi->flags |= MVF_PHY_PWR_FIX;
+	if (!(mvi->flags & MVF_FLAG_SOC)) {
+		mvs_show_pcie_usage(mvi);
+		tmp = mvs_64xx_chip_reset(mvi);
+		if (tmp)
+			return tmp;
+	} else {
+		tmp = mr32(MVS_PHY_CTL);
+		tmp &= ~PCTL_PWR_OFF;
+		tmp |= PCTL_PHY_DSBL;
+		mw32(MVS_PHY_CTL, tmp);
+	}
+
+	/* Init Chip */
+	/* make sure RST is set; HBA_RST /should/ have done that for us
*/
+	cctl = mr32(MVS_CTL) & 0xFFFF;
+	if (cctl & CCTL_RST)
+		cctl &= ~CCTL_RST;
+	else
+		mw32_f(MVS_CTL, cctl | CCTL_RST);
+
+	if (!(mvi->flags & MVF_FLAG_SOC)) {
+		/* write to device control _AND_ device status register
*/
+		pci_read_config_dword(mvi->pdev, PCR_DEV_CTRL, &tmp);
+		tmp &= ~PRD_REQ_MASK;
+		tmp |= PRD_REQ_SIZE;
+		pci_write_config_dword(mvi->pdev, PCR_DEV_CTRL, tmp);
+
+		pci_read_config_dword(mvi->pdev, PCR_PHY_CTL, &tmp);
+		tmp &= ~PCTL_PWR_OFF;
+		tmp &= ~PCTL_PHY_DSBL;
+		pci_write_config_dword(mvi->pdev, PCR_PHY_CTL, tmp);
+
+		pci_read_config_dword(mvi->pdev, PCR_PHY_CTL2, &tmp);
+		tmp &= PCTL_PWR_OFF;
+		tmp &= ~PCTL_PHY_DSBL;
+		pci_write_config_dword(mvi->pdev, PCR_PHY_CTL2, tmp);
+	} else {
+		tmp = mr32(MVS_PHY_CTL);
+		tmp &= ~PCTL_PWR_OFF;
+		tmp |= PCTL_COM_ON;
+		tmp &= ~PCTL_PHY_DSBL;
+		tmp |= PCTL_LINK_RST;
+		mw32(MVS_PHY_CTL, tmp);
+		msleep(100);
+		tmp &= ~PCTL_LINK_RST;
+		mw32(MVS_PHY_CTL, tmp);
+		msleep(100);
+	}
+
+	/* reset control */
+	mw32(MVS_PCS, 0);		/* MVS_PCS */
+	/* init phys */
+	mvs_64xx_phy_hacks(mvi);
+
+	/* enable auto port detection */
+	mw32(MVS_GBL_PORT_TYPE, MODE_AUTO_DET_EN);
+
+	mw32(MVS_CMD_LIST_LO, mvi->slot_dma);
+	mw32(MVS_CMD_LIST_HI, (mvi->slot_dma >> 16) >> 16);
+
+	mw32(MVS_RX_FIS_LO, mvi->rx_fis_dma);
+	mw32(MVS_RX_FIS_HI, (mvi->rx_fis_dma >> 16) >> 16);
+
+	mw32(MVS_TX_CFG, MVS_CHIP_SLOT_SZ);
+	mw32(MVS_TX_LO, mvi->tx_dma);
+	mw32(MVS_TX_HI, (mvi->tx_dma >> 16) >> 16);
+
+	mw32(MVS_RX_CFG, MVS_RX_RING_SZ);
+	mw32(MVS_RX_LO, mvi->rx_dma);
+	mw32(MVS_RX_HI, (mvi->rx_dma >> 16) >> 16);
+
+	for (i = 0; i < mvi->chip->n_phy; i++) {
+		/* set phy local SAS address */
+		/* should set little endian SAS address to 64xx chip */
+		mvs_set_sas_addr(mvi, i, PHYR_ADDR_LO, PHYR_ADDR_HI,
+
cpu_to_be64(mvi->phy[i].dev_sas_addr));
+
+		mvs_64xx_enable_xmt(mvi, i);
+
+		mvs_64xx_phy_reset(mvi, i, 1);
+		msleep(500);
+		mvs_64xx_detect_porttype(mvi, i);
+	}
+	if (mvi->flags & MVF_FLAG_SOC) {
+		/* set select registers */
+		writel(0x0E008000, regs + 0x000);
+		writel(0x59000008, regs + 0x004);
+		writel(0x20, regs + 0x008);
+		writel(0x20, regs + 0x00c);
+		writel(0x20, regs + 0x010);
+		writel(0x20, regs + 0x014);
+		writel(0x20, regs + 0x018);
+		writel(0x20, regs + 0x01c);
+	}
+	for (i = 0; i < mvi->chip->n_phy; i++) {
+		/* clear phy int status */
+		tmp = mvs_read_port_irq_stat(mvi, i);
+		tmp &= ~PHYEV_SIG_FIS;
+		mvs_write_port_irq_stat(mvi, i, tmp);
+
+		/* set phy int mask */
+		tmp = PHYEV_RDY_CH | PHYEV_BROAD_CH | PHYEV_UNASSOC_FIS
|
+			PHYEV_ID_DONE | PHYEV_DCDR_ERR | PHYEV_CRC_ERR |
+			PHYEV_DEC_ERR;
+		mvs_write_port_irq_mask(mvi, i, tmp);
+
+		msleep(100);
+		mvs_update_phyinfo(mvi, i, 1);
+	}
+
+	/* FIXME: update wide port bitmaps */
+
+	/* little endian for open address and command table, etc. */
+	/*
+	 * it seems that ( from the spec ) turning on big-endian won't
+	 * do us any good on big-endian machines, need further
confirmation
+	 */
+	cctl = mr32(MVS_CTL);
+	cctl |= CCTL_ENDIAN_CMD;
+	cctl |= CCTL_ENDIAN_DATA;
+	cctl &= ~CCTL_ENDIAN_OPEN;
+	cctl |= CCTL_ENDIAN_RSP;
+	mw32_f(MVS_CTL, cctl);
+
+	/* reset CMD queue */
+	tmp = mr32(MVS_PCS);
+	tmp |= PCS_CMD_RST;
+	mw32(MVS_PCS, tmp);
+	/* interrupt coalescing may cause missing HW interrput in some
case,
+	 * and the max count is 0x1ff, while our max slot is 0x200,
+	 * it will make count 0.
+	 */
+	tmp = 0;
+	mw32(MVS_INT_COAL, tmp);
+
+	tmp = 0x100;
+	mw32(MVS_INT_COAL_TMOUT, tmp);
+
+	/* ladies and gentlemen, start your engines */
+	mw32(MVS_TX_CFG, 0);
+	mw32(MVS_TX_CFG, MVS_CHIP_SLOT_SZ | TX_EN);
+	mw32(MVS_RX_CFG, MVS_RX_RING_SZ | RX_EN);
+	/* enable CMD/CMPL_Q/RESP mode */
+	mw32(MVS_PCS, PCS_SATA_RETRY | PCS_FIS_RX_EN |
+		PCS_CMD_EN | PCS_CMD_STOP_ERR);
+
+	/* enable completion queue interrupt */
+	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM | CINT_SRS |
CINT_CI_STOP |
+		CINT_DMA_PCIE);
+
+	mw32(MVS_INT_MASK, tmp);
+
+	/* Enable SRS interrupt */
+	mw32(MVS_INT_MASK_SRS_0, 0xFFFF);
+
+	return 0;
+}
+
+static int mvs_64xx_ioremap(struct mvs_info *mvi)
+{
+	if (!mvs_ioremap(mvi, 4, 2))
+		return 0;
+	return -1;
+}
+
+static void mvs_64xx_iounmap(struct mvs_info *mvi)
+{
+	mvs_iounmap(mvi->regs);
+	mvs_iounmap(mvi->regs_ex);
+}
+
+static void mvs_64xx_interrupt_enable(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+	tmp = mr32(MVS_GBL_CTL);
+	mw32(MVS_GBL_CTL, tmp | INT_EN);
+}
+
+static void mvs_64xx_interrupt_disable(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+	tmp = mr32(MVS_GBL_CTL);
+	mw32(MVS_GBL_CTL, tmp & ~INT_EN);
+}
+
+static u32 mvs_64xx_isr_status(struct mvs_info *mvi, int irq)
+{
+	void __iomem *regs = mvi->regs;
+	u32 stat;
+
+	if (!(mvi->flags & MVF_FLAG_SOC)) {
+		stat = mr32(MVS_GBL_INT_STAT);
+
+		if (stat == 0 || stat == 0xffffffff)
+			return 0;
+	} else
+		stat = 1;
+	return stat;
+}
+
+static irqreturn_t mvs_64xx_isr(struct mvs_info *mvi, int irq, u32
stat)
+{
+	void __iomem *regs = mvi->regs;
+
+	/* clear CMD_CMPLT ASAP */
+	mw32_f(MVS_INT_STAT, CINT_DONE);
+#ifndef MVS_USE_TASKLET
+	spin_lock(&mvi->lock);
+#endif
+	mvs_int_full(mvi);
+#ifndef MVS_USE_TASKLET
+	spin_unlock(&mvi->lock);
+#endif
+	return IRQ_HANDLED;
+}
+
+static void mvs_64xx_command_active(struct mvs_info *mvi, u32 slot_idx)
+{
+	u32 tmp;
+	mvs_cw32(mvi, 0x40 + (slot_idx >> 3), 1 << (slot_idx % 32));
+	mvs_cw32(mvi, 0x00 + (slot_idx >> 3), 1 << (slot_idx % 32));
+	do {
+		tmp = mvs_cr32(mvi, 0x00 + (slot_idx >> 3));
+	} while (tmp & 1 << (slot_idx % 32));
+	do {
+		tmp = mvs_cr32(mvi, 0x40 + (slot_idx >> 3));
+	} while (tmp & 1 << (slot_idx % 32));
+}
+
+static void mvs_64xx_issue_stop(struct mvs_info *mvi, enum
mvs_port_type type,
+				u32 tfs)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+	if (type == PORT_TYPE_SATA) {
+		tmp = mr32(MVS_INT_STAT_SRS_0) | (1U << tfs);
+		mw32(MVS_INT_STAT_SRS_0, tmp);
+	}
+	mw32(MVS_INT_STAT, CINT_CI_STOP);
+	tmp = mr32(MVS_PCS) | 0xFF00;
+	mw32(MVS_PCS, tmp);
+}
+
+static void mvs_64xx_free_reg_set(struct mvs_info *mvi, u8 *tfs)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp, offs;
+
+	if (*tfs == MVS_ID_NOT_MAPPED)
+		return;
+
+	offs = 1U << ((*tfs & 0x0f) + PCS_EN_SATA_REG_SHIFT);
+	if (*tfs < 16) {
+		tmp = mr32(MVS_PCS);
+		mw32(MVS_PCS, tmp & ~offs);
+	} else {
+		tmp = mr32(MVS_CTL);
+		mw32(MVS_CTL, tmp & ~offs);
+	}
+
+	tmp = mr32(MVS_INT_STAT_SRS_0) & (1U << *tfs);
+	if (tmp)
+		mw32(MVS_INT_STAT_SRS_0, tmp);
+
+	*tfs = MVS_ID_NOT_MAPPED;
+	return;
+}
+
+static u8 mvs_64xx_assign_reg_set(struct mvs_info *mvi, u8 *tfs)
+{
+	int i;
+	u32 tmp, offs;
+	void __iomem *regs = mvi->regs;
+
+	if (*tfs != MVS_ID_NOT_MAPPED)
+		return 0;
+
+	tmp = mr32(MVS_PCS);
+
+	for (i = 0; i < mvi->chip->srs_sz; i++) {
+		if (i == 16)
+			tmp = mr32(MVS_CTL);
+		offs = 1U << ((i & 0x0f) + PCS_EN_SATA_REG_SHIFT);
+		if (!(tmp & offs)) {
+			*tfs = i;
+
+			if (i < 16)
+				mw32(MVS_PCS, tmp | offs);
+			else
+				mw32(MVS_CTL, tmp | offs);
+			tmp = mr32(MVS_INT_STAT_SRS_0) & (1U << i);
+			if (tmp)
+				mw32(MVS_INT_STAT_SRS_0, tmp);
+			return 0;
+		}
+	}
+	return MVS_ID_NOT_MAPPED;
+}
+
+void mvs_64xx_make_prd(struct scatterlist *scatter, int nr, void *prd)
+{
+	int i;
+	struct scatterlist *sg;
+	struct mvs_prd *buf_prd = prd;
+	for_each_sg(scatter, sg, nr, i) {
+		buf_prd->addr = cpu_to_le64(sg_dma_address(sg));
+		buf_prd->len = cpu_to_le32(sg_dma_len(sg));
+		buf_prd++;
+	}
+}
+
+static int mvs_64xx_oob_done(struct mvs_info *mvi, int i)
+{
+	u32 phy_st;
+	mvs_write_port_cfg_addr(mvi, i,
+			PHYR_PHY_STAT);
+	phy_st = mvs_read_port_cfg_data(mvi, i);
+	if (phy_st & PHY_OOB_DTCTD)
+		return 1;
+	return 0;
+}
+
+static void mvs_64xx_fix_phy_info(struct mvs_info *mvi, int i,
+				struct sas_identify_frame *id)
+
+{
+	struct mvs_phy *phy = &mvi->phy[i];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+
+	sas_phy->linkrate =
+		(phy->phy_status & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
+			PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET;
+
+	phy->minimum_linkrate =
+		(phy->phy_status &
+			PHY_MIN_SPP_PHYS_LINK_RATE_MASK) >> 8;
+	phy->maximum_linkrate =
+		(phy->phy_status &
+			PHY_MAX_SPP_PHYS_LINK_RATE_MASK) >> 12;
+
+	mvs_write_port_cfg_addr(mvi, i, PHYR_IDENTIFY);
+	phy->dev_info = mvs_read_port_cfg_data(mvi, i);
+
+	mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_DEV_INFO);
+	phy->att_dev_info = mvs_read_port_cfg_data(mvi, i);
+
+	mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_HI);
+	phy->att_dev_sas_addr =
+	     (u64) mvs_read_port_cfg_data(mvi, i) << 32;
+	mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_LO);
+	phy->att_dev_sas_addr |= mvs_read_port_cfg_data(mvi, i);
+	phy->att_dev_sas_addr = SAS_ADDR(&phy->att_dev_sas_addr);
+}
+
+static void mvs_64xx_phy_work_around(struct mvs_info *mvi, int i)
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
+void mvs_64xx_phy_set_link_rate(struct mvs_info *mvi, u32 phy_id,
+			struct sas_phy_linkrates *rates)
+{
+	u32 lrmin = 0, lrmax = 0;
+	u32 tmp;
+
+	tmp = mvs_read_phy_ctl(mvi, phy_id);
+	lrmin = (rates->minimum_linkrate << 8);
+	lrmax = (rates->maximum_linkrate << 12);
+
+	if (lrmin) {
+		tmp &= ~(0xf << 8);
+		tmp |= lrmin;
+	}
+	if (lrmax) {
+		tmp &= ~(0xf << 12);
+		tmp |= lrmax;
+	}
+	mvs_write_phy_ctl(mvi, phy_id, tmp);
+	mvs_64xx_phy_reset(mvi, phy_id, 1);
+}
+
+static void mvs_64xx_clear_active_cmds(struct mvs_info *mvi)
+{
+	u32 tmp;
+	void __iomem *regs = mvi->regs;
+	tmp = mr32(MVS_PCS);
+	mw32(MVS_PCS, tmp & 0xFFFF);
+	mw32(MVS_PCS, tmp);
+	tmp = mr32(MVS_CTL);
+	mw32(MVS_CTL, tmp & 0xFFFF);
+	mw32(MVS_CTL, tmp);
+}
+
+
+u32 mvs_64xx_spi_read_data(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs_ex;
+	return ior32(SPI_DATA_REG_64XX);
+}
+
+void mvs_64xx_spi_write_data(struct mvs_info *mvi, u32 data)
+{
+	void __iomem *regs = mvi->regs_ex;
+	 iow32(SPI_DATA_REG_64XX, data);
+}
+
+
+int mvs_64xx_spi_buildcmd(struct mvs_info *mvi,
+						u32 *dwCmd,
+					   	u8 cmd,
+					    	u8 read,
+					    	u8 length,
+					    	u32 addr
+					    	)
+{
+    u32  dwTmp;
+
+    dwTmp = ( ( u32 )cmd << 24 )|( (u32)length << 19 );
+    if( read ){
+        dwTmp|= 1U<<23;
+    }
+
+    if (addr != MV_MAX_U32){
+	    dwTmp|= 1U<<22;
+	    dwTmp|= ( addr & 0x0003FFFF );
+    }
+
+    *dwCmd = dwTmp;
+    return 0;
+}
+
+
+int mvs_64xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
+{
+	void __iomem *regs = mvi->regs_ex;
+	int     retry;
+
+	for( retry=0; retry<1; retry++ ){
+	    iow32(SPI_CTRL_REG_64XX, SPI_CTRL_VENDOR_ENABLE);
+	    iow32(SPI_CMD_REG_64XX, cmd );
+	    iow32(SPI_CTRL_REG_64XX, SPI_CTRL_VENDOR_ENABLE |
SPI_CTRL_SPISTART);
+	}
+
+	return 0;
+}
+
+int mvs_64xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
+{
+	void __iomem *regs = mvi->regs_ex;
+	u32   i, dwTmp;
+
+	for( i=0; i<timeout; i++ ){
+		dwTmp = ior32(SPI_CTRL_REG_64XX);
+		if( !( dwTmp & SPI_CTRL_SPISTART) ){
+			return 0;
+		}
+		msleep( 10 );
+	}
+
+	return -1;
+}
+
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+void mvs_64xx_fix_dma(dma_addr_t buf_dma, int buf_len, int from, void
*prd)
+{
+	int i;
+	struct mvs_prd *buf_prd = prd;
+	buf_prd	+= from;
+	for (i = 0; i < MAX_SG_ENTRY - from; i++) {
+		buf_prd->addr = cpu_to_le64(buf_dma);
+		buf_prd->len = cpu_to_le32(buf_len);
+		++buf_prd;
+	}
+}
+#endif
+
+const struct mvs_dispatch mvs_64xx_dispatch = {
+	"mv64xx",
+	mvs_64xx_init,
+	NULL,
+	mvs_64xx_ioremap,
+	mvs_64xx_iounmap,
+	mvs_64xx_isr,
+	mvs_64xx_isr_status,
+	mvs_64xx_interrupt_enable,
+	mvs_64xx_interrupt_disable,
+	mvs_read_phy_ctl,
+	mvs_write_phy_ctl,
+	mvs_read_port_cfg_data,
+	mvs_write_port_cfg_data,
+	mvs_write_port_cfg_addr,
+	mvs_read_port_vsr_data,
+	mvs_write_port_vsr_data,
+	mvs_write_port_vsr_addr,
+	mvs_read_port_irq_stat,
+	mvs_write_port_irq_stat,
+	mvs_read_port_irq_mask,
+	mvs_write_port_irq_mask,
+	mvs_get_sas_addr,
+	mvs_64xx_command_active,
+	mvs_64xx_issue_stop,
+	mvs_start_delivery,
+	mvs_rx_update,
+	mvs_int_full,
+	mvs_64xx_assign_reg_set,
+	mvs_64xx_free_reg_set,
+	mvs_get_prd_size,
+	mvs_get_prd_count,
+	mvs_64xx_make_prd,
+	mvs_64xx_detect_porttype,
+	mvs_64xx_oob_done,
+	mvs_64xx_fix_phy_info,
+	mvs_64xx_phy_work_around,
+	mvs_64xx_phy_set_link_rate,
+	mvs_hw_max_link_rate,
+	mvs_64xx_phy_disable,
+	mvs_64xx_phy_enable,
+	mvs_64xx_phy_reset,
+	mvs_64xx_stp_reset,
+	mvs_64xx_clear_active_cmds,
+	mvs_64xx_spi_read_data,
+	mvs_64xx_spi_write_data,
+	mvs_64xx_spi_buildcmd,
+	mvs_64xx_spi_issuecmd,
+	mvs_64xx_spi_waitdataready,
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	mvs_64xx_fix_dma,
+#endif
+};
+
diff --git a/drivers/scsi/mvsas/mv_64xx.h b/drivers/scsi/mvsas/mv_64xx.h
new file mode 100644
index 0000000..573ec6d
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_64xx.h
@@ -0,0 +1,128 @@
+#ifndef _MVS64XX_REG_H_
+#define _MVS64XX_REG_H_
+
+#include <linux/types.h>
+
+#define MAX_LINK_RATE		SAS_LINK_RATE_3_0_GBPS
+
+/* enhanced mode registers (BAR4) */
+enum hw_registers {
+	MVS_GBL_CTL		= 0x04,  /* global control */
+	MVS_GBL_INT_STAT	= 0x08,  /* global irq status */
+	MVS_GBL_PI		= 0x0C,  /* ports implemented bitmask */
+
+	MVS_PHY_CTL		= 0x40,  /* SOC PHY Control */
+	MVS_PORTS_IMP		= 0x9C,  /* SOC Port Implemented */
+
+	MVS_GBL_PORT_TYPE	= 0xa0,  /* port type */
+
+	MVS_CTL			= 0x100, /* SAS/SATA port configuration
*/
+	MVS_PCS			= 0x104, /* SAS/SATA port control/status
*/
+	MVS_CMD_LIST_LO		= 0x108, /* cmd list addr */
+	MVS_CMD_LIST_HI		= 0x10C,
+	MVS_RX_FIS_LO		= 0x110, /* RX FIS list addr */
+	MVS_RX_FIS_HI		= 0x114,
+
+	MVS_TX_CFG		= 0x120, /* TX configuration */
+	MVS_TX_LO		= 0x124, /* TX (delivery) ring addr */
+	MVS_TX_HI		= 0x128,
+
+	MVS_TX_PROD_IDX		= 0x12C, /* TX producer pointer */
+	MVS_TX_CONS_IDX		= 0x130, /* TX consumer pointer (RO) */
+	MVS_RX_CFG		= 0x134, /* RX configuration */
+	MVS_RX_LO		= 0x138, /* RX (completion) ring addr */
+	MVS_RX_HI		= 0x13C,
+	MVS_RX_CONS_IDX		= 0x140, /* RX consumer pointer (RO) */
+
+	MVS_INT_COAL		= 0x148, /* Int coalescing config */
+	MVS_INT_COAL_TMOUT	= 0x14C, /* Int coalescing timeout */
+	MVS_INT_STAT		= 0x150, /* Central int status */
+	MVS_INT_MASK		= 0x154, /* Central int enable */
+	MVS_INT_STAT_SRS_0	= 0x158, /* SATA register set status */
+	MVS_INT_MASK_SRS_0	= 0x15C,
+
+					 /* ports 1-3 follow after this
*/
+	MVS_P0_INT_STAT		= 0x160, /* port0 interrupt status */
+	MVS_P0_INT_MASK		= 0x164, /* port0 interrupt mask */
+					 /* ports 5-7 follow after this
*/
+	MVS_P4_INT_STAT		= 0x200, /* Port4 interrupt status */
+	MVS_P4_INT_MASK		= 0x204, /* Port4 interrupt enable mask
*/
+
+					 /* ports 1-3 follow after this
*/
+	MVS_P0_SER_CTLSTAT	= 0x180, /* port0 serial control/status
*/
+					 /* ports 5-7 follow after this
*/
+	MVS_P4_SER_CTLSTAT	= 0x220, /* port4 serial control/status
*/
+
+	MVS_CMD_ADDR		= 0x1B8, /* Command register port (addr)
*/
+	MVS_CMD_DATA		= 0x1BC, /* Command register port (data)
*/
+
+					 /* ports 1-3 follow after this
*/
+	MVS_P0_CFG_ADDR		= 0x1C0, /* port0 phy register address
*/
+	MVS_P0_CFG_DATA		= 0x1C4, /* port0 phy register data */
+					 /* ports 5-7 follow after this
*/
+	MVS_P4_CFG_ADDR		= 0x230, /* Port4 config address */
+	MVS_P4_CFG_DATA		= 0x234, /* Port4 config data */
+
+					 /* ports 1-3 follow after this
*/
+	MVS_P0_VSR_ADDR		= 0x1E0, /* port0 VSR address */
+	MVS_P0_VSR_DATA		= 0x1E4, /* port0 VSR data */
+					 /* ports 5-7 follow after this
*/
+	MVS_P4_VSR_ADDR		= 0x250, /* port4 VSR addr */
+	MVS_P4_VSR_DATA		= 0x254, /* port4 VSR data */
+};
+
+enum pci_cfg_registers {
+	PCR_PHY_CTL		= 0x40,
+	PCR_PHY_CTL2		= 0x90,
+	PCR_DEV_CTRL		= 0xE8,
+	PCR_LINK_STAT		= 0xF2,
+};
+
+/*  SAS/SATA Vendor Specific Port Registers */
+enum sas_sata_vsp_regs {
+	VSR_PHY_STAT		= 0x00, /* Phy Status */
+	VSR_PHY_MODE1		= 0x01, /* phy tx */
+	VSR_PHY_MODE2		= 0x02, /* tx scc */
+	VSR_PHY_MODE3		= 0x03, /* pll */
+	VSR_PHY_MODE4		= 0x04, /* VCO */
+	VSR_PHY_MODE5		= 0x05, /* Rx */
+	VSR_PHY_MODE6		= 0x06, /* CDR */
+	VSR_PHY_MODE7		= 0x07, /* Impedance */
+	VSR_PHY_MODE8		= 0x08, /* Voltage */
+	VSR_PHY_MODE9		= 0x09, /* Test */
+	VSR_PHY_MODE10		= 0x0A, /* Power */
+	VSR_PHY_MODE11		= 0x0B, /* Phy Mode */
+	VSR_PHY_VS0		= 0x0C, /* Vednor Specific 0 */
+	VSR_PHY_VS1		= 0x0D, /* Vednor Specific 1 */
+};
+
+enum chip_register_bits {
+	PHY_MIN_SPP_PHYS_LINK_RATE_MASK = (0xF << 8),
+	PHY_MAX_SPP_PHYS_LINK_RATE_MASK = (0xF << 12),
+	PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET = (16),
+	PHY_NEG_SPP_PHYS_LINK_RATE_MASK =
+			(0xF << PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET),
+};
+
+#define MAX_SG_ENTRY		64
+
+struct mvs_prd {
+	__le64			addr;		/* 64-bit buffer address
*/
+	__le32			reserved;
+	__le32			len;		/* 16-bit length */
+};
+
+#define SPI_CTRL_REG				0xc0
+#define SPI_CTRL_VENDOR_ENABLE		1U<<29
+#define SPI_CTRL_SPIRDY         		1U<<22
+#define SPI_CTRL_SPISTART			1U<<20
+
+#define SPI_CMD_REG		0xc4
+#define SPI_DATA_REG		0xc8
+
+#define SPI_CTRL_REG_64XX		0x10
+#define SPI_CMD_REG_64XX		0x14
+#define SPI_DATA_REG_64XX		0x18
+
+#endif
+
diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
new file mode 100644
index 0000000..d6e33fd
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -0,0 +1,651 @@
+#include "mv_sas.h"
+#include "mv_94xx.h"
+#include "mv_chips.h"
+
+static void mvs_94xx_detect_porttype(struct mvs_info *mvi, int i)
+{
+	u32 reg;
+	struct mvs_phy *phy = &mvi->phy[i];
+	u32 phy_status;
+
+	mvs_write_port_vsr_addr(mvi, i, VSR_PHY_MODE3);
+	reg = mvs_read_port_vsr_data(mvi, i);
+	phy_status = ((reg & 0x3f0000) >> 16) & 0xff;
+	phy->phy_type &= ~(PORT_TYPE_SAS | PORT_TYPE_SATA);
+	switch(phy_status)
+	{
+	case 0x10:
+		phy->phy_type |= PORT_TYPE_SAS;
+		break;
+	case 0x1d:
+	default:
+		phy->phy_type |= PORT_TYPE_SATA;
+		break;
+	}
+}
+
+static void __devinit mvs_94xx_enable_xmt(struct mvs_info *mvi, int
phy_id)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+	tmp = mr32(MVS_PCS);
+	tmp |= 1 << (phy_id + PCS_EN_PORT_XMT_SHIFT2);
+	mw32(MVS_PCS, tmp);
+}
+
+static void mvs_94xx_phy_reset(struct mvs_info *mvi, u32 phy_id, int
hard)
+{
+	u32 tmp;
+
+	tmp = mvs_read_port_irq_stat(mvi, phy_id);
+	tmp &= ~PHYEV_RDY_CH;
+	mvs_write_port_irq_stat(mvi, phy_id, tmp);
+	if (hard) {
+		tmp = mvs_read_phy_ctl(mvi, phy_id);
+		tmp |= PHY_RST_HARD;
+		mvs_write_phy_ctl(mvi, phy_id, tmp);
+		do {
+			tmp = mvs_read_phy_ctl(mvi, phy_id);
+		} while (tmp & PHY_RST_HARD);
+	}
+	else {
+		mvs_write_port_vsr_addr(mvi, phy_id, VSR_PHY_STAT);
+		tmp = mvs_read_port_vsr_data(mvi, phy_id);
+		tmp |= PHY_RST;
+		mvs_write_port_vsr_data(mvi, phy_id, tmp);
+	}
+}
+
+static void mvs_94xx_phy_disable(struct mvs_info *mvi, u32 phy_id)
+{
+	u32 tmp;
+	mvs_write_port_vsr_addr(mvi, phy_id, VSR_PHY_MODE2);
+	tmp = mvs_read_port_vsr_data(mvi, phy_id);
+	mvs_write_port_vsr_data(mvi, phy_id, tmp | 0x00800000);
+}
+
+static void mvs_94xx_phy_enable(struct mvs_info *mvi, u32 phy_id)
+{
+	mvs_write_port_vsr_addr(mvi, phy_id, 0x1B4);
+	mvs_write_port_vsr_data(mvi, phy_id, 0x8300ffc1);
+	mvs_write_port_vsr_addr(mvi, phy_id, 0x104);
+	mvs_write_port_vsr_data(mvi, phy_id, 0x00018080);
+	mvs_write_port_vsr_addr(mvi, phy_id, VSR_PHY_MODE2);
+	mvs_write_port_vsr_data(mvi, phy_id, 0x00207fff);
+}
+
+static int __devinit mvs_94xx_init(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+	int i;
+	u32 tmp, cctl;
+
+	mvs_show_pcie_usage(mvi);
+	if (mvi->flags & MVF_FLAG_SOC) {
+		tmp = mr32(MVS_PHY_CTL);
+		tmp &= ~PCTL_PWR_OFF;
+		tmp |= PCTL_PHY_DSBL;
+		mw32(MVS_PHY_CTL, tmp);
+	}
+
+	/* Init Chip */
+	/* make sure RST is set; HBA_RST /should/ have done that for us
*/
+	cctl = mr32(MVS_CTL) & 0xFFFF;
+	if (cctl & CCTL_RST)
+		cctl &= ~CCTL_RST;
+	else
+		mw32_f(MVS_CTL, cctl | CCTL_RST);
+
+	if (mvi->flags & MVF_FLAG_SOC) {
+		tmp = mr32(MVS_PHY_CTL);
+		tmp &= ~PCTL_PWR_OFF;
+		tmp |= PCTL_COM_ON;
+		tmp &= ~PCTL_PHY_DSBL;
+		tmp |= PCTL_LINK_RST;
+		mw32(MVS_PHY_CTL, tmp);
+		msleep(100);
+		tmp &= ~PCTL_LINK_RST;
+		mw32(MVS_PHY_CTL, tmp);
+		msleep(100);
+	}
+
+	/* reset control */
+	mw32(MVS_PCS, 0);		/* MVS_PCS */
+	mw32(MVS_STP_REG_SET_0, 0);
+	mw32(MVS_STP_REG_SET_1, 0);
+
+	/* init phys */
+	mvs_phy_hacks(mvi);
+
+	/* disable Multiplexing, enable phy implemented */
+	mw32(MVS_PORTS_IMP, 0xFF);
+
+
+	mw32(MVS_PA_VSR_ADDR, 0x00000104);
+	mw32(MVS_PA_VSR_PORT, 0x00018080);
+	mw32(MVS_PA_VSR_ADDR, VSR_PHY_MODE8);
+	mw32(MVS_PA_VSR_PORT, 0x0084ffff);
+
+	/* set LED blink when IO*/
+	mw32(MVS_PA_VSR_ADDR, 0x00000030);
+	tmp = mr32(MVS_PA_VSR_PORT);
+	tmp &= 0xFFFF00FF;
+	tmp |= 0x00003300;
+	mw32(MVS_PA_VSR_PORT, tmp);
+
+	mw32(MVS_CMD_LIST_LO, mvi->slot_dma);
+	mw32(MVS_CMD_LIST_HI, (mvi->slot_dma >> 16) >> 16);
+
+	mw32(MVS_RX_FIS_LO, mvi->rx_fis_dma);
+	mw32(MVS_RX_FIS_HI, (mvi->rx_fis_dma >> 16) >> 16);
+
+	mw32(MVS_TX_CFG, MVS_CHIP_SLOT_SZ);
+	mw32(MVS_TX_LO, mvi->tx_dma);
+	mw32(MVS_TX_HI, (mvi->tx_dma >> 16) >> 16);
+
+	mw32(MVS_RX_CFG, MVS_RX_RING_SZ);
+	mw32(MVS_RX_LO, mvi->rx_dma);
+	mw32(MVS_RX_HI, (mvi->rx_dma >> 16) >> 16);
+
+	for (i = 0; i < mvi->chip->n_phy; i++) {
+		mvs_94xx_phy_disable(mvi, i);
+		/* set phy local SAS address */
+		mvs_set_sas_addr(mvi, i, CONFIG_ID_FRAME3,
CONFIG_ID_FRAME4,
+
(mvi->phy[i].dev_sas_addr));
+
+		mvs_94xx_enable_xmt(mvi, i);
+		mvs_94xx_phy_enable(mvi, i);
+
+		mvs_94xx_phy_reset(mvi, i, 1);
+		msleep(500);
+		mvs_94xx_detect_porttype(mvi, i);
+	}
+
+	if (mvi->flags & MVF_FLAG_SOC) {
+		/* set select registers */
+		writel(0x0E008000, regs + 0x000);
+		writel(0x59000008, regs + 0x004);
+		writel(0x20, regs + 0x008);
+		writel(0x20, regs + 0x00c);
+		writel(0x20, regs + 0x010);
+		writel(0x20, regs + 0x014);
+		writel(0x20, regs + 0x018);
+		writel(0x20, regs + 0x01c);
+	}
+	for (i = 0; i < mvi->chip->n_phy; i++) {
+		/* clear phy int status */
+		tmp = mvs_read_port_irq_stat(mvi, i);
+		tmp &= ~PHYEV_SIG_FIS;
+		mvs_write_port_irq_stat(mvi, i, tmp);
+
+		/* set phy int mask */
+		tmp = PHYEV_RDY_CH | PHYEV_BROAD_CH |
+			PHYEV_ID_DONE  | PHYEV_DCDR_ERR | PHYEV_CRC_ERR
;
+		mvs_write_port_irq_mask(mvi, i, tmp);
+
+		msleep(100);
+		mvs_update_phyinfo(mvi, i, 1);
+	}
+
+	/* FIXME: update wide port bitmaps */
+
+	/* little endian for open address and command table, etc. */
+	/*
+	 * it seems that ( from the spec ) turning on big-endian won't
+	 * do us any good on big-endian machines, need further
confirmation
+	 */
+	cctl = mr32(MVS_CTL);
+	cctl |= CCTL_ENDIAN_CMD;
+	cctl |= CCTL_ENDIAN_DATA;
+	cctl &= ~CCTL_ENDIAN_OPEN;
+	cctl |= CCTL_ENDIAN_RSP;
+	mw32_f(MVS_CTL, cctl);
+
+	/* reset CMD queue */
+	tmp = mr32(MVS_PCS);
+	tmp |= PCS_CMD_RST;
+	mw32(MVS_PCS, tmp);
+	/* interrupt coalescing may cause missing HW interrput in some
case,
+	 * and the max count is 0x1ff, while our max slot is 0x200,
+	 * it will make count 0.
+	 */
+	tmp = 0;
+	mw32(MVS_INT_COAL, tmp);
+
+	tmp = 0x100;
+	mw32(MVS_INT_COAL_TMOUT, tmp);
+
+	/* ladies and gentlemen, start your engines */
+	mw32(MVS_TX_CFG, 0);
+	mw32(MVS_TX_CFG, MVS_CHIP_SLOT_SZ | TX_EN);
+	mw32(MVS_RX_CFG, MVS_RX_RING_SZ | RX_EN);
+	/* enable CMD/CMPL_Q/RESP mode */
+	mw32(MVS_PCS, PCS_SATA_RETRY_2 | PCS_FIS_RX_EN |
+		PCS_CMD_EN | PCS_CMD_STOP_ERR);
+
+	/* enable completion queue interrupt */
+	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM | CINT_SRS |
CINT_CI_STOP |
+		CINT_DMA_PCIE);
+	tmp |= CINT_PHY_MASK;
+	mw32(MVS_INT_MASK, tmp);
+
+	/* Enable SRS interrupt */
+	mw32(MVS_INT_MASK_SRS_0, 0xFFFF);
+
+	return 0;
+}
+
+static int mvs_94xx_ioremap(struct mvs_info *mvi)
+{
+	if (!mvs_ioremap(mvi, 2, -1)) {
+		mvi->regs_ex = mvi->regs + 0x10200;
+		mvi->regs += 0x20000;
+		if (mvi->id == 1)
+			mvi->regs += 0x4000;
+		return 0;
+	}
+	return -1;
+}
+
+static void mvs_94xx_iounmap(struct mvs_info *mvi)
+{
+	if (mvi->regs) {
+		mvi->regs -= 0x20000;
+		if (mvi->id == 1)
+			mvi->regs -= 0x4000;
+		mvs_iounmap(mvi->regs);
+	}
+}
+
+static void mvs_94xx_interrupt_enable(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs_ex;
+	u32 tmp;
+
+	tmp = mr32(MVS_GBL_CTL);
+	tmp |= (IRQ_SAS_A | IRQ_SAS_B);
+	mw32(MVS_GBL_INT_STAT, tmp);
+	writel(tmp, regs + 0x0C);
+	writel(tmp, regs + 0x10);
+	writel(tmp, regs + 0x14);
+	writel(tmp, regs + 0x18);
+	mw32(MVS_GBL_CTL, tmp);
+}
+
+static void mvs_94xx_interrupt_disable(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs_ex;
+	u32 tmp;
+
+	tmp = mr32(MVS_GBL_CTL);
+
+	tmp &= ~(IRQ_SAS_A | IRQ_SAS_B);
+	mw32(MVS_GBL_INT_STAT, tmp);
+	writel(tmp, regs + 0x0C);
+	writel(tmp, regs + 0x10);
+	writel(tmp, regs + 0x14);
+	writel(tmp, regs + 0x18);
+	mw32(MVS_GBL_CTL, tmp);
+}
+
+static u32 mvs_94xx_isr_status(struct mvs_info *mvi, int irq)
+{
+	void __iomem *regs = mvi->regs_ex;
+	u32 stat = 0;
+	if (!(mvi->flags & MVF_FLAG_SOC)) {
+		stat = mr32(MVS_GBL_INT_STAT);
+
+		if (!(stat & (IRQ_SAS_A | IRQ_SAS_B)))
+			return 0;
+	}
+	return stat;
+}
+
+static irqreturn_t mvs_94xx_isr(struct mvs_info *mvi, int irq, u32
stat)
+{
+	void __iomem *regs = mvi->regs;
+
+	if (((stat & IRQ_SAS_A) && mvi->id == 0) ||
+			((stat & IRQ_SAS_B) && mvi->id == 1)) {
+		mw32_f(MVS_INT_STAT, CINT_DONE);
+	#ifndef MVS_USE_TASKLET
+		spin_lock(&mvi->lock);
+	#endif
+		mvs_int_full(mvi);
+	#ifndef MVS_USE_TASKLET
+		spin_unlock(&mvi->lock);
+	#endif
+	}
+	return IRQ_HANDLED;
+}
+
+static void mvs_94xx_command_active(struct mvs_info *mvi, u32 slot_idx)
+{
+	u32 tmp;
+	mvs_cw32(mvi, 0x300 + (slot_idx >> 3), 1 << (slot_idx % 32));
+	do {
+		tmp = mvs_cr32(mvi, 0x300 + (slot_idx >> 3));
+	} while (tmp & 1 << (slot_idx % 32));
+}
+
+static void mvs_94xx_issue_stop(struct mvs_info *mvi, enum
mvs_port_type type,
+				u32 tfs)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+	if (type == PORT_TYPE_SATA) {
+		tmp = mr32(MVS_INT_STAT_SRS_0) | (1U << tfs);
+		mw32(MVS_INT_STAT_SRS_0, tmp);
+	}
+	mw32(MVS_INT_STAT, CINT_CI_STOP);
+	tmp = mr32(MVS_PCS) | 0xFF00;
+	mw32(MVS_PCS, tmp);
+}
+
+static void mvs_94xx_free_reg_set(struct mvs_info *mvi, u8 *tfs)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+	u8 reg_set = *tfs;
+
+	if (*tfs == MVS_ID_NOT_MAPPED)
+		return;
+
+	mvi->sata_reg_set &= ~bit(reg_set);
+	if(reg_set < 32){
+		w_reg_set_enable(reg_set, (u32)mvi->sata_reg_set);
+		tmp = mr32(MVS_INT_STAT_SRS_0) & (u32)mvi->sata_reg_set;
+		if (tmp)
+			mw32(MVS_INT_STAT_SRS_0, tmp);
+	}else{
+		w_reg_set_enable(reg_set, mvi->sata_reg_set);
+		tmp = mr32(MVS_INT_STAT_SRS_1) & mvi->sata_reg_set;
+		if (tmp)
+			mw32(MVS_INT_STAT_SRS_1, tmp);
+	}
+
+	*tfs = MVS_ID_NOT_MAPPED;
+
+	return;
+}
+
+static u8 mvs_94xx_assign_reg_set(struct mvs_info *mvi, u8 *tfs)
+{
+	int i;
+	void __iomem *regs = mvi->regs;
+
+	if (*tfs != MVS_ID_NOT_MAPPED)
+		return 0;
+
+	i = mv_ffc64(mvi->sata_reg_set);
+	if (i > 32) {
+		mvi->sata_reg_set |= bit(i);
+		w_reg_set_enable(i, (u32)(mvi->sata_reg_set >> 32));
+		*tfs = i;
+		return 0;
+	}else if(i >= 0){
+		mvi->sata_reg_set |= bit(i);
+		w_reg_set_enable(i, (u32)mvi->sata_reg_set);
+		*tfs = i;
+		return 0;
+	}
+	return MVS_ID_NOT_MAPPED;
+}
+
+static void mvs_94xx_make_prd(struct scatterlist *scatter, int nr, void
*prd)
+{
+	int i;
+	struct scatterlist *sg;
+	struct mvs_prd *buf_prd = prd;
+	for_each_sg(scatter, sg, nr, i) {
+		buf_prd->addr = cpu_to_le64(sg_dma_address(sg));
+		buf_prd->im_len.len = cpu_to_le32(sg_dma_len(sg));
+		buf_prd++;
+	}
+}
+
+static int mvs_94xx_oob_done(struct mvs_info *mvi, int i)
+{
+	u32 phy_st;
+	phy_st = mvs_read_phy_ctl(mvi, i);
+	if (phy_st & PHY_READY_MASK)	/* phy ready */
+		return 1;
+	return 0;
+}
+
+static void mvs_94xx_get_dev_identify_frame(struct mvs_info *mvi, int
port_id,
+					struct sas_identify_frame *id)
+{
+	int i;
+	u32 id_frame[7];
+
+	for (i = 0; i < 7; i++) {
+		mvs_write_port_cfg_addr(mvi, port_id,
+					CONFIG_ID_FRAME0 + i * 4);
+		id_frame[i] = mvs_read_port_cfg_data(mvi, port_id);
+	}
+	memcpy(id, id_frame, 28);
+}
+
+static void mvs_94xx_get_att_identify_frame(struct mvs_info *mvi, int
port_id,
+					struct sas_identify_frame *id)
+{
+	int i;
+	u32 id_frame[7];
+
+	/* mvs_hexdump(28, (u8 *)id_frame, 0); */
+	for (i = 0; i < 7; i++) {
+		mvs_write_port_cfg_addr(mvi, port_id,
+					CONFIG_ATT_ID_FRAME0 + i * 4);
+		id_frame[i] = mvs_read_port_cfg_data(mvi, port_id);
+		mv_dprintk("94xx phy %d atta frame %d %x.\n",port_id+
mvi->id * mvi->chip->n_phy, i, id_frame[i]);
+	}
+	/* mvs_hexdump(28, (u8 *)id_frame, 0); */
+	memcpy(id, id_frame, 28);
+}
+
+static u32 mvs_94xx_make_dev_info(struct sas_identify_frame *id)
+{
+	u32 att_dev_info=0;
+
+	att_dev_info |= id->dev_type;
+	if(id->stp_iport)
+		att_dev_info |= PORT_DEV_STP_INIT;
+	if(id->smp_iport)
+		att_dev_info |= PORT_DEV_SMP_INIT;
+	if(id->ssp_iport)
+		att_dev_info |= PORT_DEV_SSP_INIT;
+	if(id->stp_tport)
+		att_dev_info |= PORT_DEV_STP_TRGT;
+	if(id->smp_tport)
+		att_dev_info |= PORT_DEV_SMP_TRGT;
+	if(id->ssp_tport)
+		att_dev_info |= PORT_DEV_SSP_TRGT;
+
+	att_dev_info |= (u32)id->phy_id<<24;
+	return att_dev_info;
+}
+
+static u32 mvs_94xx_make_att_info(struct sas_identify_frame *id)
+{
+	return mvs_94xx_make_dev_info(id);
+}
+
+static void mvs_94xx_fix_phy_info(struct mvs_info *mvi, int i,
+				struct sas_identify_frame *id)
+{
+	struct mvs_phy *phy = &mvi->phy[i];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	mv_dprintk("get all reg link rate is 0x%x\n", phy->phy_status);
+	sas_phy->linkrate =
+		(phy->phy_status & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
+			PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET;
+	sas_phy->linkrate += 0x8;
+	mv_dprintk("get link rate is %d\n", sas_phy->linkrate);
+	phy->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+	phy->maximum_linkrate = SAS_LINK_RATE_6_0_GBPS;
+	mvs_94xx_get_dev_identify_frame(mvi, i, id);
+	phy->dev_info = mvs_94xx_make_dev_info(id);
+
+	if(phy->phy_type & PORT_TYPE_SAS){
+		mvs_94xx_get_att_identify_frame(mvi, i, id);
+		phy->att_dev_info = mvs_94xx_make_att_info(id);
+		phy->att_dev_sas_addr = *(u64 *)id->sas_addr;
+	} else {
+		phy->att_dev_info = PORT_DEV_STP_TRGT | 1;	//end
device
+	}
+
+}
+
+void mvs_94xx_phy_set_link_rate(struct mvs_info *mvi, u32 phy_id,
+			struct sas_phy_linkrates *rates)
+{
+	/* TODO */
+}
+
+static void mvs_94xx_clear_active_cmds(struct mvs_info *mvi)
+{
+	u32 tmp;
+	void __iomem *regs = mvi->regs;
+	tmp = mr32(MVS_STP_REG_SET_0);
+	mw32(MVS_STP_REG_SET_0, 0);
+	mw32(MVS_STP_REG_SET_0, tmp);
+	tmp = mr32(MVS_STP_REG_SET_1);
+	mw32(MVS_STP_REG_SET_1, 0);
+	mw32(MVS_STP_REG_SET_1, tmp);
+}
+
+
+u32 mvs_94xx_spi_read_data(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs_ex - 0x10200;
+	return mr32(SPI_RD_DATA_REG_94XX);
+}
+
+void mvs_94xx_spi_write_data(struct mvs_info *mvi, u32 data)
+{
+	void __iomem *regs = mvi->regs_ex - 0x10200;
+	 mw32(SPI_RD_DATA_REG_94XX, data);
+}
+
+
+int mvs_94xx_spi_buildcmd(struct mvs_info *mvi,
+						u32      *dwCmd,
+					   	u8       cmd,
+					    	u8       read,
+					    	u8       length,
+					    	u32      addr
+					    	)
+{
+   void __iomem *regs = mvi->regs_ex - 0x10200;
+    u32  dwTmp;
+
+    dwTmp = ( ( u32 )cmd << 8 )|( (u32)length << 4 );
+    if( read ){
+        dwTmp|= SPI_CTRL_READ_94XX;
+    }
+
+    if (addr != MV_MAX_U32){
+	    mw32(SPI_ADDR_REG_94XX, (addr & 0x0003FFFFL));
+	    dwTmp|= SPI_ADDR_VLD_94XX;
+    }
+
+    *dwCmd = dwTmp;
+    return 0;
+}
+
+
+int mvs_94xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
+{
+	void __iomem *regs = mvi->regs_ex - 0x10200;
+	mw32(SPI_CTRL_REG_94XX, cmd | SPI_CTRL_SpiStart_94XX );
+
+	return 0;
+}
+
+int mvs_94xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
+{
+	void __iomem *regs = mvi->regs_ex - 0x10200;
+	u32   i, dwTmp;
+
+	for( i=0; i<timeout; i++ ){
+		dwTmp = mr32(SPI_CTRL_REG_94XX);
+		if( !( dwTmp & SPI_CTRL_SpiStart_94XX) ){
+			return 0;
+		}
+		msleep( 10 );
+	}
+
+	return -1;
+}
+
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+void mvs_94xx_fix_dma(dma_addr_t buf_dma, int buf_len, int from, void
*prd)
+{
+	int i;
+	struct mvs_prd *buf_prd = prd;
+	buf_prd	+= from;
+	for (i = 0; i < MAX_SG_ENTRY - from; i++) {
+		buf_prd->addr = cpu_to_le64(buf_dma);
+		buf_prd->im_len.len = cpu_to_le32(buf_len);
+		++buf_prd;
+	}
+}
+#endif
+
+const struct mvs_dispatch mvs_94xx_dispatch = {
+	"mv94xx",
+	mvs_94xx_init,
+	NULL,
+	mvs_94xx_ioremap,
+	mvs_94xx_iounmap,
+	mvs_94xx_isr,
+	mvs_94xx_isr_status,
+	mvs_94xx_interrupt_enable,
+	mvs_94xx_interrupt_disable,
+	mvs_read_phy_ctl,
+	mvs_write_phy_ctl,
+	mvs_read_port_cfg_data,
+	mvs_write_port_cfg_data,
+	mvs_write_port_cfg_addr,
+	mvs_read_port_vsr_data,
+	mvs_write_port_vsr_data,
+	mvs_write_port_vsr_addr,
+	mvs_read_port_irq_stat,
+	mvs_write_port_irq_stat,
+	mvs_read_port_irq_mask,
+	mvs_write_port_irq_mask,
+	mvs_get_sas_addr,
+	mvs_94xx_command_active,
+	mvs_94xx_issue_stop,
+	mvs_start_delivery,
+	mvs_rx_update,
+	mvs_int_full,
+	mvs_94xx_assign_reg_set,
+	mvs_94xx_free_reg_set,
+	mvs_get_prd_size,
+	mvs_get_prd_count,
+	mvs_94xx_make_prd,
+	mvs_94xx_detect_porttype,
+	mvs_94xx_oob_done,
+	mvs_94xx_fix_phy_info,
+	NULL,
+	mvs_94xx_phy_set_link_rate,
+	mvs_hw_max_link_rate,
+	mvs_94xx_phy_disable,
+	mvs_94xx_phy_enable,
+	mvs_94xx_phy_reset,
+	NULL,
+	mvs_94xx_clear_active_cmds,
+	mvs_94xx_spi_read_data,
+	mvs_94xx_spi_write_data,
+	mvs_94xx_spi_buildcmd,
+	mvs_94xx_spi_issuecmd,
+	mvs_94xx_spi_waitdataready,
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	mvs_94xx_fix_dma,
+#endif
+};
+
diff --git a/drivers/scsi/mvsas/mv_94xx.h b/drivers/scsi/mvsas/mv_94xx.h
new file mode 100644
index 0000000..2ba2655
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_94xx.h
@@ -0,0 +1,196 @@
+#ifndef _MVS94XX_REG_H_
+#define _MVS94XX_REG_H_
+
+#include <linux/types.h>
+
+#define MAX_LINK_RATE		SAS_LINK_RATE_6_0_GBPS
+
+enum hw_registers {
+	MVS_GBL_CTL		= 0x04,  /* global control */
+	MVS_GBL_INT_STAT	= 0x00,  /* global irq status */
+	MVS_GBL_PI		= 0x0C,  /* ports implemented bitmask */
+
+	MVS_PHY_CTL		= 0x40,  /* SOC PHY Control */
+	MVS_PORTS_IMP		= 0x9C,  /* SOC Port Implemented */
+
+	MVS_GBL_PORT_TYPE	= 0xa0,  /* port type */
+
+	MVS_CTL			= 0x100, /* SAS/SATA port configuration
*/
+	MVS_PCS			= 0x104, /* SAS/SATA port control/status
*/
+	MVS_CMD_LIST_LO		= 0x108, /* cmd list addr */
+	MVS_CMD_LIST_HI		= 0x10C,
+	MVS_RX_FIS_LO		= 0x110, /* RX FIS list addr */
+	MVS_RX_FIS_HI		= 0x114,
+	MVS_STP_REG_SET_0	= 0x118, /* STP/SATA Register Set Enable
*/
+	MVS_STP_REG_SET_1	= 0x11C,
+	MVS_TX_CFG		= 0x120, /* TX configuration */
+	MVS_TX_LO		= 0x124, /* TX (delivery) ring addr */
+	MVS_TX_HI		= 0x128,
+
+	MVS_TX_PROD_IDX		= 0x12C, /* TX producer pointer */
+	MVS_TX_CONS_IDX		= 0x130, /* TX consumer pointer (RO) */
+	MVS_RX_CFG		= 0x134, /* RX configuration */
+	MVS_RX_LO		= 0x138, /* RX (completion) ring addr */
+	MVS_RX_HI		= 0x13C,
+	MVS_RX_CONS_IDX		= 0x140, /* RX consumer pointer (RO) */
+
+	MVS_INT_COAL		= 0x148, /* Int coalescing config */
+	MVS_INT_COAL_TMOUT	= 0x14C, /* Int coalescing timeout */
+	MVS_INT_STAT		= 0x150, /* Central int status */
+	MVS_INT_MASK		= 0x154, /* Central int enable */
+	MVS_INT_STAT_SRS_0	= 0x158, /* SATA register set status */
+	MVS_INT_MASK_SRS_0	= 0x15C,
+	MVS_INT_STAT_SRS_1	= 0x160,
+	MVS_INT_MASK_SRS_1	= 0x164,
+	MVS_NON_NCQ_ERR_0	= 0x168, /* SRS Non-specific NCQ Error
*/
+	MVS_NON_NCQ_ERR_1	= 0x16C,
+	MVS_CMD_ADDR		= 0x170, /* Command register port (addr)
*/
+	MVS_CMD_DATA		= 0x174, /* Command register port (data)
*/
+	MVS_MEM_PARITY_ERR	= 0x178, /* Memory parity error */
+
+					 /* ports 1-3 follow after this
*/
+	MVS_P0_INT_STAT		= 0x180, /* port0 interrupt status */
+	MVS_P0_INT_MASK		= 0x184, /* port0 interrupt mask */
+					 /* ports 5-7 follow after this
*/
+	MVS_P4_INT_STAT		= 0x1A0, /* Port4 interrupt status */
+	MVS_P4_INT_MASK		= 0x1A4, /* Port4 interrupt enable mask
*/
+
+					 /* ports 1-3 follow after this
*/
+	MVS_P0_SER_CTLSTAT	= 0x1D0, /* port0 serial control/status
*/
+					 /* ports 5-7 follow after this
*/
+	MVS_P4_SER_CTLSTAT	= 0x1E0, /* port4 serial control/status
*/
+
+					 /* ports 1-3 follow after this
*/
+	MVS_P0_CFG_ADDR		= 0x200, /* port0 phy register address
*/
+	MVS_P0_CFG_DATA		= 0x204, /* port0 phy register data */
+					 /* ports 5-7 follow after this
*/
+	MVS_P4_CFG_ADDR		= 0x220, /* Port4 config address */
+	MVS_P4_CFG_DATA		= 0x224, /* Port4 config data */
+
+					 /* phys 1-3 follow after this
*/
+	MVS_P0_VSR_ADDR		= 0x250, /* phy0 VSR address */
+	MVS_P0_VSR_DATA		= 0x254, /* phy0 VSR data */
+					 /* phys 1-3 follow after this
*/
+					 /* multiplexing */
+	MVS_P4_VSR_ADDR 	= 0x250, /* phy4 VSR address */
+	MVS_P4_VSR_DATA 	= 0x254, /* phy4 VSR data */
+	MVS_PA_VSR_ADDR		= 0x290, /* All port VSR addr */
+	MVS_PA_VSR_PORT		= 0x294, /* All port VSR data */
+};
+
+enum pci_cfg_registers {
+	PCR_PHY_CTL		= 0x40,
+	PCR_PHY_CTL2		= 0x90,
+	PCR_DEV_CTRL		= 0x78,
+	PCR_LINK_STAT		= 0x82,
+};
+
+/*  SAS/SATA Vendor Specific Port Registers */
+enum sas_sata_vsp_regs {
+	VSR_PHY_STAT		= 0x00 * 4, /* Phy Status */
+	VSR_PHY_MODE1		= 0x01 * 4, /* phy tx */
+	VSR_PHY_MODE2		= 0x02 * 4, /* tx scc */
+	VSR_PHY_MODE3		= 0x03 * 4, /* pll */
+	VSR_PHY_MODE4		= 0x04 * 4, /* VCO */
+	VSR_PHY_MODE5		= 0x05 * 4, /* Rx */
+	VSR_PHY_MODE6		= 0x06 * 4, /* CDR */
+	VSR_PHY_MODE7		= 0x07 * 4, /* Impedance */
+	VSR_PHY_MODE8		= 0x08 * 4, /* Voltage */
+	VSR_PHY_MODE9		= 0x09 * 4, /* Test */
+	VSR_PHY_MODE10		= 0x0A * 4, /* Power */
+	VSR_PHY_MODE11		= 0x0B * 4, /* Phy Mode */
+	VSR_PHY_VS0		= 0x0C * 4, /* Vednor Specific 0 */
+	VSR_PHY_VS1		= 0x0D * 4, /* Vednor Specific 1 */
+};
+
+enum chip_register_bits {
+	PHY_MIN_SPP_PHYS_LINK_RATE_MASK = (0x7 << 8),
+	PHY_MAX_SPP_PHYS_LINK_RATE_MASK = (0x7 << 8),
+	PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET = (12),
+	PHY_NEG_SPP_PHYS_LINK_RATE_MASK =
+			(0x3 << PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET),
+};
+
+enum pci_interrupt_cause {
+	/*  MAIN_IRQ_CAUSE (R10200) Bits*/
+	IRQ_COM_IN_I2O_IOP0            = (1 << 0),
+	IRQ_COM_IN_I2O_IOP1            = (1 << 1),
+	IRQ_COM_IN_I2O_IOP2            = (1 << 2),
+	IRQ_COM_IN_I2O_IOP3            = (1 << 3),
+	IRQ_COM_OUT_I2O_HOS0           = (1 << 4),
+	IRQ_COM_OUT_I2O_HOS1           = (1 << 5),
+	IRQ_COM_OUT_I2O_HOS2           = (1 << 6),
+	IRQ_COM_OUT_I2O_HOS3           = (1 << 7),
+	IRQ_PCIF_TO_CPU_DRBL0          = (1 << 8),
+	IRQ_PCIF_TO_CPU_DRBL1          = (1 << 9),
+	IRQ_PCIF_TO_CPU_DRBL2          = (1 << 10),
+	IRQ_PCIF_TO_CPU_DRBL3          = (1 << 11),
+	IRQ_PCIF_DRBL0                 = (1 << 12),
+	IRQ_PCIF_DRBL1                 = (1 << 13),
+	IRQ_PCIF_DRBL2                 = (1 << 14),
+	IRQ_PCIF_DRBL3                 = (1 << 15),
+	IRQ_XOR_A                      = (1 << 16),
+	IRQ_XOR_B                      = (1 << 17),
+	IRQ_SAS_A                      = (1 << 18),
+	IRQ_SAS_B                      = (1 << 19),
+	IRQ_CPU_CNTRL                  = (1 << 20),
+	IRQ_GPIO                       = (1 << 21),
+	IRQ_UART                       = (1 << 22),
+	IRQ_SPI                        = (1 << 23),
+	IRQ_I2C                        = (1 << 24),
+	IRQ_SGPIO                      = (1 << 25),
+	IRQ_COM_ERR                    = (1 << 29),
+	IRQ_I2O_ERR                    = (1 << 30),
+	IRQ_PCIE_ERR                   = (1 << 31),
+};
+
+#define MAX_SG_ENTRY		255
+
+struct mvs_prd_imt {
+	__le32			len:22;
+	u8			_r_a:2;
+	u8			misc_ctl:4;
+	u8			inter_sel:4;
+};
+
+struct mvs_prd {
+	__le64			addr;		/* 64-bit buffer address
*/
+	struct mvs_prd_imt	im_len;		/* 22-bit length */
+} __attribute__ ((packed));
+
+#define SPI_CTRL_REG_94XX           	0xc800
+#define SPI_ADDR_REG_94XX            	0xc804
+#define SPI_WR_DATA_REG_94XX         0xc808
+#define SPI_RD_DATA_REG_94XX         	0xc80c
+#define SPI_CTRL_READ_94XX         	(1U << 2)
+#define SPI_ADDR_VLD_94XX         	(1U << 1)
+#define SPI_CTRL_SpiStart_94XX     	(1U << 0)
+
+// ffs: find first set, returns the position of the LSB set to 1
+#define mv_ffc(x)   ffz(x)
+
+__inline int
+mv_ffc64(u64 v)
+{
+    int i;
+
+    if ((i = mv_ffc((u32)v)) >= 0) {
+        return i;
+    }
+
+    if ((i = mv_ffc((u32)(v>>32))) != 0) {
+        return 32 + i;
+    }
+
+	return -1;
+}
+
+#define r_reg_set_enable(i) \
+	(((i) > 31) ? mr32(MVS_STP_REG_SET_1) : \
+	mr32(MVS_STP_REG_SET_0))
+
+#define w_reg_set_enable(i, tmp) \
+	(((i) > 31) ? mw32(MVS_STP_REG_SET_1, tmp) : \
+	mw32(MVS_STP_REG_SET_0, tmp))
+
+#endif
diff --git a/drivers/scsi/mvsas/mv_chips.h
b/drivers/scsi/mvsas/mv_chips.h
new file mode 100644
index 0000000..1fe1240
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_chips.h
@@ -0,0 +1,249 @@
+#ifndef _MV_CHIPS_H_
+#define _MV_CHIPS_H_
+
+#define mr32(reg)	readl(regs + reg)
+#define mw32(reg,val)	writel((val), regs + reg)
+#define mw32_f(reg,val)	do {			\
+		mw32(reg, val);			\
+		mr32(reg);			\
+	} while (0)
+
+#define iow32(reg, val) 	outl(val, (unsigned long)(regs + reg))
+#define ior32(reg) 		inl((unsigned long)(regs + reg))
+#define iow16(reg, val) 	outw((unsigned long)(val, regs + reg))
+#define ior16(reg) 		inw((unsigned long)(regs + reg))
+#define iow8(reg, val) 		outb((unsigned long)(val, regs +
reg))
+#define ior8(reg) 		inb((unsigned long)(regs + reg))
+
+static inline u32 mvs_cr32(struct mvs_info *mvi, u32 addr)
+{
+	void __iomem *regs = mvi->regs;
+	mw32(MVS_CMD_ADDR, addr);
+	return mr32(MVS_CMD_DATA);
+}
+
+static inline void mvs_cw32(struct mvs_info *mvi, u32 addr, u32 val)
+{
+	void __iomem *regs = mvi->regs;
+	mw32(MVS_CMD_ADDR, addr);
+	mw32(MVS_CMD_DATA, val);
+}
+
+static inline u32 mvs_read_phy_ctl(struct mvs_info *mvi, u32 port)
+{
+	void __iomem *regs = mvi->regs;
+	return (port < 4)?mr32(MVS_P0_SER_CTLSTAT + port * 4):
+		mr32(MVS_P4_SER_CTLSTAT + (port - 4) * 4);
+}
+
+static inline void mvs_write_phy_ctl(struct mvs_info *mvi, u32 port,
u32 val)
+{
+	void __iomem *regs = mvi->regs;
+	if (port < 4)
+		mw32(MVS_P0_SER_CTLSTAT + port * 4, val);
+	else
+		mw32(MVS_P4_SER_CTLSTAT + (port - 4) * 4, val);
+}
+
+static inline u32 mvs_read_port(struct mvs_info *mvi, u32 off, u32
off2, u32 port)
+{
+	void __iomem *regs = mvi->regs + off;
+	void __iomem *regs2 = mvi->regs + off2;
+	return (port < 4)?readl(regs + port * 8):
+		readl(regs2 + (port - 4) * 8);
+}
+
+static inline void mvs_write_port(struct mvs_info *mvi, u32 off, u32
off2,
+				u32 port, u32 val)
+{
+	void __iomem *regs = mvi->regs + off;
+	void __iomem *regs2 = mvi->regs + off2;
+	if (port < 4)
+		writel(val, regs + port * 8);
+	else
+		writel(val, regs2 + (port - 4) * 8);
+}
+
+static inline u32 mvs_read_port_cfg_data(struct mvs_info *mvi, u32
port)
+{
+	return mvs_read_port(mvi, MVS_P0_CFG_DATA,
+			MVS_P4_CFG_DATA, port);
+}
+
+static inline void mvs_write_port_cfg_data(struct mvs_info *mvi, u32
port, u32 val)
+{
+	mvs_write_port(mvi, MVS_P0_CFG_DATA,
+			MVS_P4_CFG_DATA, port, val);
+}
+
+static inline void mvs_write_port_cfg_addr(struct mvs_info *mvi, u32
port, u32 addr)
+{
+	mvs_write_port(mvi, MVS_P0_CFG_ADDR,
+			MVS_P4_CFG_ADDR, port, addr);
+	mdelay(10);
+}
+
+static inline u32 mvs_read_port_vsr_data(struct mvs_info *mvi, u32
port)
+{
+	return mvs_read_port(mvi, MVS_P0_VSR_DATA,
+			MVS_P4_VSR_DATA, port);
+}
+
+static inline void mvs_write_port_vsr_data(struct mvs_info *mvi, u32
port, u32 val)
+{
+	mvs_write_port(mvi, MVS_P0_VSR_DATA,
+			MVS_P4_VSR_DATA, port, val);
+}
+
+static inline void mvs_write_port_vsr_addr(struct mvs_info *mvi, u32
port, u32 addr)
+{
+	mvs_write_port(mvi, MVS_P0_VSR_ADDR,
+			MVS_P4_VSR_ADDR, port, addr);
+	mdelay(10);
+}
+
+static inline u32 mvs_read_port_irq_stat(struct mvs_info *mvi, u32
port)
+{
+	return mvs_read_port(mvi, MVS_P0_INT_STAT,
+			MVS_P4_INT_STAT, port);
+}
+
+static inline void mvs_write_port_irq_stat(struct mvs_info *mvi, u32
port, u32 val)
+{
+	mvs_write_port(mvi, MVS_P0_INT_STAT,
+			MVS_P4_INT_STAT, port, val);
+}
+
+static inline u32 mvs_read_port_irq_mask(struct mvs_info *mvi, u32
port)
+{
+	return mvs_read_port(mvi, MVS_P0_INT_MASK,
+			MVS_P4_INT_MASK, port);
+
+}
+
+static inline void mvs_write_port_irq_mask(struct mvs_info *mvi, u32
port, u32 val)
+{
+	mvs_write_port(mvi, MVS_P0_INT_MASK,
+			MVS_P4_INT_MASK, port, val);
+}
+
+static inline void __devinit mvs_phy_hacks(struct mvs_info *mvi)
+{
+	u32 tmp;
+
+	/* workaround for SATA R-ERR, to ignore phy glitch */
+	tmp = mvs_cr32(mvi, CMD_PHY_TIMER);
+	tmp &= ~(1 << 9);
+	tmp |= (1 << 10);
+	mvs_cw32(mvi, CMD_PHY_TIMER, tmp);
+
+	/* enable retry 127 times */
+	mvs_cw32(mvi, CMD_SAS_CTL1, 0x7f7f);
+
+	/* extend open frame timeout to max */
+	tmp = mvs_cr32(mvi, CMD_SAS_CTL0);
+	tmp &= ~0xffff;
+	tmp |= 0x3fff;
+	mvs_cw32(mvi, CMD_SAS_CTL0, tmp);
+
+	/* workaround for WDTIMEOUT , set to 550 ms */
+	//mvs_cw32(mvi, CMD_WD_TIMER, 0x86470);
+	mvs_cw32(mvi, CMD_WD_TIMER, 0x7a0000);
+
+	/* not to halt for different port op during wideport link change
*/
+	mvs_cw32(mvi, CMD_APP_ERR_CONFIG, 0xffefbf7d);
+
+	/* workaround for Seagate disk not-found OOB sequence, recv
+	 * COMINIT before sending out COMWAKE */
+	tmp = mvs_cr32(mvi, CMD_PHY_MODE_21);
+	tmp &= 0x0000ffff;
+	tmp |= 0x00fa0000;
+	mvs_cw32(mvi, CMD_PHY_MODE_21, tmp);
+
+	tmp = mvs_cr32(mvi, CMD_PHY_TIMER);
+	tmp &= 0x1fffffff;
+	tmp |= (2U << 29);	/* 8 ms retry */
+	mvs_cw32(mvi, CMD_PHY_TIMER, tmp);
+}
+
+static inline void mvs_int_sata(struct mvs_info *mvi)
+{
+	u32 tmp;
+	void __iomem *regs = mvi->regs;
+	tmp = mr32(MVS_INT_STAT_SRS_0);
+	if (tmp)
+		mw32(MVS_INT_STAT_SRS_0, tmp);
+	MVS_CHIP_DISP->clear_active_cmds(mvi);
+}
+
+static inline void mvs_int_full(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp, stat;
+	int i;
+
+	stat = mr32(MVS_INT_STAT);
+	mvs_int_rx(mvi, false);
+
+	for (i = 0; i < mvi->chip->n_phy; i++) {
+		tmp = (stat >> i) & (CINT_PORT | CINT_PORT_STOPPED);
+		if (tmp)
+			mvs_int_port(mvi, i, tmp);
+	}
+
+	if (stat & CINT_SRS)
+		mvs_int_sata(mvi);
+
+	mw32(MVS_INT_STAT, stat);
+}
+
+static inline void mvs_start_delivery(struct mvs_info *mvi, u32 tx)
+{
+	void __iomem *regs = mvi->regs;
+	mw32(MVS_TX_PROD_IDX, tx);
+}
+
+static inline u32 mvs_rx_update(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+	return mr32(MVS_RX_CONS_IDX);
+}
+
+static inline u32 mvs_get_prd_size(void)
+{
+	return sizeof(struct mvs_prd);
+}
+
+static inline u32 mvs_get_prd_count(void)
+{
+	return MAX_SG_ENTRY;
+}
+
+static inline void mvs_show_pcie_usage(struct mvs_info *mvi)
+{
+	u16 link_stat, link_spd;
+	const char *spd[] = {
+		"UnKnown",
+		"2.5",
+		"5.0",
+	};
+	if (mvi->flags & MVF_FLAG_SOC || mvi->id > 0)
+		return;
+
+	pci_read_config_word(mvi->pdev, PCR_LINK_STAT, &link_stat);
+	link_spd = (link_stat & PLS_LINK_SPD) >> PLS_LINK_SPD_OFFS;
+	if (link_spd >= 3)
+		link_spd = 0;
+	dev_printk(KERN_INFO, mvi->dev,
+		"mvsas: PCI-E x%u, Bandwidth Usage: %s Gbps\n",
+	       (link_stat & PLS_NEG_LINK_WD) >> PLS_NEG_LINK_WD_OFFS,
+	       spd[link_spd]);
+}
+
+static inline u32 mvs_hw_max_link_rate(void)
+{
+	return MAX_LINK_RATE;
+}
+
+#endif  /* _MV_CHIPS_H_ */
+
diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
new file mode 100644
index 0000000..d69518d
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -0,0 +1,478 @@
+#ifndef _MV_DEFS_H_
+#define _MV_DEFS_H_
+
+
+enum chip_flavors {
+	chip_6320,
+	chip_6440,
+	chip_6485,
+	chip_9480,
+	chip_9180,
+};
+
+/* driver compile-time configuration */
+enum driver_configuration {
+	MVS_SLOTS		= 512,	/* command slots */
+	MVS_TX_RING_SZ		= 1024,	/* TX ring size (12-bit) */
+	MVS_RX_RING_SZ		= 1024, /* RX ring size (12-bit) */
+					/* software requires power-of-2
+					   ring size */
+	MVS_SOC_SLOTS		= 64,
+	MVS_SOC_TX_RING_SZ	= MVS_SOC_SLOTS * 2,
+	MVS_SOC_RX_RING_SZ	= MVS_SOC_SLOTS * 2,
+
+	MVS_SLOT_BUF_SZ		= 8192, /* cmd tbl + IU + status + PRD
*/
+	MVS_SSP_CMD_SZ		= 64,	/* SSP command table buffer size
*/
+	MVS_ATA_CMD_SZ		= 96,	/* SATA command table buffer
size */
+	MVS_OAF_SZ		= 64,	/* Open address frame buffer
size */
+	MVS_QUEUE_SIZE	= 32,	/* Support Queue depth */
+	MVS_CAN_QUEUE		= MVS_SLOTS - 2,	/* SCSI Queue
depth */
+	MVS_SOC_CAN_QUEUE	= MVS_SOC_SLOTS - 2,
+};
+
+/* unchangeable hardware details */
+enum hardware_details {
+	MVS_MAX_PHYS		= 8,	/* max. possible phys */
+	MVS_MAX_PORTS		= 8,	/* max. possible ports */
+	MVS_SOC_PHYS		= 4,	/* soc phys */
+	MVS_SOC_PORTS		= 4,	/* soc phys */
+	MVS_MAX_DEVICES	= 1024,	/* max supported device */
+};
+
+/* peripheral registers (BAR2) */
+enum peripheral_registers {
+	SPI_CTL			= 0x10,	/* EEPROM control */
+	SPI_CMD			= 0x14,	/* EEPROM command */
+	SPI_DATA		= 0x18, /* EEPROM data */
+};
+
+enum peripheral_register_bits {
+	TWSI_RDY		= (1U << 7),	/* EEPROM interface
ready */
+	TWSI_RD			= (1U << 4),	/* EEPROM read access */
+
+	SPI_ADDR_MASK		= 0x3ffff,	/* bits 17:0 */
+};
+
+enum hw_register_bits {
+	/* MVS_GBL_CTL */
+	INT_EN			= (1U << 1),	/* Global int enable */
+	HBA_RST			= (1U << 0),	/* HBA reset */
+
+	/* MVS_GBL_INT_STAT */
+	INT_XOR			= (1U << 4),	/* XOR engine event */
+	INT_SAS_SATA		= (1U << 0),	/* SAS/SATA event */
+
+	/* MVS_GBL_PORT_TYPE */			/* shl for ports 1-3 */
+	SATA_TARGET		= (1U << 16),	/* port0 SATA target
enable */
+	MODE_AUTO_DET_PORT7 = (1U << 15),	/* port0 SAS/SATA
autodetect */
+	MODE_AUTO_DET_PORT6 = (1U << 14),
+	MODE_AUTO_DET_PORT5 = (1U << 13),
+	MODE_AUTO_DET_PORT4 = (1U << 12),
+	MODE_AUTO_DET_PORT3 = (1U << 11),
+	MODE_AUTO_DET_PORT2 = (1U << 10),
+	MODE_AUTO_DET_PORT1 = (1U << 9),
+	MODE_AUTO_DET_PORT0 = (1U << 8),
+	MODE_AUTO_DET_EN    =	MODE_AUTO_DET_PORT0 |
MODE_AUTO_DET_PORT1 |
+				MODE_AUTO_DET_PORT2 |
MODE_AUTO_DET_PORT3 |
+				MODE_AUTO_DET_PORT4 |
MODE_AUTO_DET_PORT5 |
+				MODE_AUTO_DET_PORT6 |
MODE_AUTO_DET_PORT7,
+	MODE_SAS_PORT7_MASK = (1U << 7),  /* port0 SAS(1), SATA(0) mode
*/
+	MODE_SAS_PORT6_MASK = (1U << 6),
+	MODE_SAS_PORT5_MASK = (1U << 5),
+	MODE_SAS_PORT4_MASK = (1U << 4),
+	MODE_SAS_PORT3_MASK = (1U << 3),
+	MODE_SAS_PORT2_MASK = (1U << 2),
+	MODE_SAS_PORT1_MASK = (1U << 1),
+	MODE_SAS_PORT0_MASK = (1U << 0),
+	MODE_SAS_SATA	=	MODE_SAS_PORT0_MASK |
MODE_SAS_PORT1_MASK |
+				MODE_SAS_PORT2_MASK |
MODE_SAS_PORT3_MASK |
+				MODE_SAS_PORT4_MASK |
MODE_SAS_PORT5_MASK |
+				MODE_SAS_PORT6_MASK |
MODE_SAS_PORT7_MASK,
+
+				/* SAS_MODE value may be
+				 * dictated (in hw) by values
+				 * of SATA_TARGET & AUTO_DET
+				 */
+
+	/* MVS_TX_CFG */
+	TX_EN			= (1U << 16),	/* Enable TX */
+	TX_RING_SZ_MASK		= 0xfff,	/* TX ring size, bits
11:0 */
+
+	/* MVS_RX_CFG */
+	RX_EN			= (1U << 16),	/* Enable RX */
+	RX_RING_SZ_MASK		= 0xfff,	/* RX ring size, bits
11:0 */
+
+	/* MVS_INT_COAL */
+	COAL_EN			= (1U << 16),	/* Enable int coalescing
*/
+
+	/* MVS_INT_STAT, MVS_INT_MASK */
+	CINT_I2C		= (1U << 31),	/* I2C event */
+	CINT_SW0		= (1U << 30),	/* software event 0 */
+	CINT_SW1		= (1U << 29),	/* software event 1 */
+	CINT_PRD_BC		= (1U << 28),	/* PRD BC err for read
cmd */
+	CINT_DMA_PCIE		= (1U << 27),	/* DMA to PCIE timeout
*/
+	CINT_MEM		= (1U << 26),	/* int mem parity err */
+	CINT_I2C_SLAVE		= (1U << 25),	/* slave I2C event */
+	CINT_SRS		= (1U << 3),	/* SRS event */
+	CINT_CI_STOP		= (1U << 1),	/* cmd issue stopped */
+	CINT_DONE		= (1U << 0),	/* cmd completion */
+
+						/* shl for ports 1-3 */
+	CINT_PORT_STOPPED	= (1U << 16),	/* port0 stopped */
+	CINT_PORT		= (1U << 8),	/* port0 event */
+	CINT_PORT_MASK_OFFSET	= 8,
+	CINT_PORT_MASK		= (0xFF << CINT_PORT_MASK_OFFSET),
+	CINT_PHY_MASK_OFFSET	= 4,
+	CINT_PHY_MASK		= (0x0F << CINT_PHY_MASK_OFFSET),
+
+	/* TX (delivery) ring bits */
+	TXQ_CMD_SHIFT		= 29,
+	TXQ_CMD_SSP		= 1,		/* SSP protocol */
+	TXQ_CMD_SMP		= 2,		/* SMP protocol */
+	TXQ_CMD_STP		= 3,		/* STP/SATA protocol */
+	TXQ_CMD_SSP_FREE_LIST	= 4,		/* add to SSP targ free
list */
+	TXQ_CMD_SLOT_RESET	= 7,		/* reset command slot */
+	TXQ_MODE_I		= (1U << 28),	/* mode:
0=target,1=initiator */
+	TXQ_MODE_TARGET 	= 0,
+	TXQ_MODE_INITIATOR	= 1,
+	TXQ_PRIO_HI		= (1U << 27),	/* priority: 0=normal,
1=high */
+	TXQ_PRI_NORMAL		= 0,
+	TXQ_PRI_HIGH		= 1,
+	TXQ_SRS_SHIFT		= 20,		/* SATA register set */
+	TXQ_SRS_MASK		= 0x7f,
+	TXQ_PHY_SHIFT		= 12,		/* PHY bitmap */
+	TXQ_PHY_MASK		= 0xff,
+	TXQ_SLOT_MASK		= 0xfff,	/* slot number */
+
+	/* RX (completion) ring bits */
+	RXQ_GOOD		= (1U << 23),	/* Response good */
+	RXQ_SLOT_RESET		= (1U << 21),	/* Slot reset complete
*/
+	RXQ_CMD_RX		= (1U << 20),	/* target cmd received
*/
+	RXQ_ATTN		= (1U << 19),	/* attention */
+	RXQ_RSP			= (1U << 18),	/* response frame xfer'd
*/
+	RXQ_ERR			= (1U << 17),	/* err info rec xfer'd
*/
+	RXQ_DONE		= (1U << 16),	/* cmd complete */
+	RXQ_SLOT_MASK		= 0xfff,	/* slot number */
+
+	/* mvs_cmd_hdr bits */
+	MCH_PRD_LEN_SHIFT	= 16,		/* 16-bit PRD table len
*/
+	MCH_SSP_FR_TYPE_SHIFT	= 13,		/* SSP frame type */
+
+						/* SSP initiator only */
+	MCH_SSP_FR_CMD		= 0x0,		/* COMMAND frame */
+
+						/* SSP initiator or
target */
+	MCH_SSP_FR_TASK		= 0x1,		/* TASK frame */
+
+						/* SSP target only */
+	MCH_SSP_FR_XFER_RDY	= 0x4,		/* XFER_RDY frame */
+	MCH_SSP_FR_RESP		= 0x5,		/* RESPONSE frame */
+	MCH_SSP_FR_READ		= 0x6,		/* Read DATA frame(s) */
+	MCH_SSP_FR_READ_RESP	= 0x7,		/* ditto, plus RESPONSE
*/
+
+	MCH_SSP_MODE_PASSTHRU	= 1,
+	MCH_SSP_MODE_NORMAL	= 0,
+	MCH_PASSTHRU		= (1U << 12),	/* pass-through (SSP) */
+	MCH_FBURST		= (1U << 11),	/* first burst (SSP) */
+	MCH_CHK_LEN		= (1U << 10),	/* chk xfer len (SSP) */
+	MCH_RETRY		= (1U << 9),	/* tport layer retry
(SSP) */
+	MCH_PROTECTION		= (1U << 8),	/* protection info rec
(SSP) */
+	MCH_RESET		= (1U << 7),	/* Reset (STP/SATA) */
+	MCH_FPDMA		= (1U << 6),	/* First party DMA
(STP/SATA) */
+	MCH_ATAPI		= (1U << 5),	/* ATAPI (STP/SATA) */
+	MCH_BIST		= (1U << 4),	/* BIST activate
(STP/SATA) */
+	MCH_PMP_MASK		= 0xf,		/* PMP from cmd FIS
(STP/SATA)*/
+
+	CCTL_RST		= (1U << 5),	/* port logic reset */
+
+						/* 0(LSB first), 1(MSB
first) */
+	CCTL_ENDIAN_DATA	= (1U << 3),	/* PRD data */
+	CCTL_ENDIAN_RSP		= (1U << 2),	/* response frame */
+	CCTL_ENDIAN_OPEN	= (1U << 1),	/* open address frame */
+	CCTL_ENDIAN_CMD		= (1U << 0),	/* command table */
+
+	/* MVS_Px_SER_CTLSTAT (per-phy control) */
+	PHY_SSP_RST		= (1U << 3),	/* reset SSP link layer
*/
+	PHY_BCAST_CHG		= (1U << 2),	/* broadcast(change)
notif */
+	PHY_RST_HARD		= (1U << 1),	/* hard reset + phy
reset */
+	PHY_RST			= (1U << 0),	/* phy reset */
+	PHY_READY_MASK		= (1U << 20),
+
+	/* MVS_Px_INT_STAT, MVS_Px_INT_MASK (per-phy events) */
+	PHYEV_DEC_ERR		= (1U << 24),	/* Phy Decoding Error */
+	PHYEV_DCDR_ERR		= (1U << 23),	/* STP Deocder Error */
+	PHYEV_CRC_ERR		= (1U << 22),	/* STP CRC Error */
+	PHYEV_UNASSOC_FIS	= (1U << 19),	/* unassociated FIS rx'd
*/
+	PHYEV_AN		= (1U << 18),	/* SATA async
notification */
+	PHYEV_BIST_ACT		= (1U << 17),	/* BIST activate FIS */
+	PHYEV_SIG_FIS		= (1U << 16),	/* signature FIS */
+	PHYEV_POOF		= (1U << 12),	/* phy ready from 1 -> 0
*/
+	PHYEV_IU_BIG		= (1U << 11),	/* IU too long err */
+	PHYEV_IU_SMALL		= (1U << 10),	/* IU too short err */
+	PHYEV_UNK_TAG		= (1U << 9),	/* unknown tag */
+	PHYEV_BROAD_CH		= (1U << 8),	/* broadcast(CHANGE) */
+	PHYEV_COMWAKE		= (1U << 7),	/* COMWAKE rx'd */
+	PHYEV_PORT_SEL		= (1U << 6),	/* port selector present
*/
+	PHYEV_HARD_RST		= (1U << 5),	/* hard reset rx'd */
+	PHYEV_ID_TMOUT		= (1U << 4),	/* identify timeout */
+	PHYEV_ID_FAIL		= (1U << 3),	/* identify failed */
+	PHYEV_ID_DONE		= (1U << 2),	/* identify done */
+	PHYEV_HARD_RST_DONE	= (1U << 1),	/* hard reset done */
+	PHYEV_RDY_CH		= (1U << 0),	/* phy ready changed
state */
+
+	/* MVS_PCS */
+	PCS_EN_SATA_REG_SHIFT	= (16),		/* Enable SATA Register
Set */
+	PCS_EN_PORT_XMT_SHIFT	= (12),		/* Enable Port Transmit
*/
+	PCS_EN_PORT_XMT_SHIFT2	= (8),		/* For 6485 */
+	PCS_SATA_RETRY		= (1U << 8),	/* retry ctl FIS on
R_ERR */
+	PCS_RSP_RX_EN		= (1U << 7),	/* raw response rx */
+	PCS_SATA_RETRY_2	= (1U << 6),	/* For 9180 */
+	PCS_SELF_CLEAR		= (1U << 5),	/* self-clearing int
mode */
+	PCS_FIS_RX_EN		= (1U << 4),	/* FIS rx enable */
+	PCS_CMD_STOP_ERR	= (1U << 3),	/* cmd stop-on-err
enable */
+	PCS_CMD_RST		= (1U << 1),	/* reset cmd issue */
+	PCS_CMD_EN		= (1U << 0),	/* enable cmd issue */
+
+	/* Port n Attached Device Info */
+	PORT_DEV_SSP_TRGT	= (1U << 19),
+	PORT_DEV_SMP_TRGT	= (1U << 18),
+	PORT_DEV_STP_TRGT	= (1U << 17),
+	PORT_DEV_SSP_INIT	= (1U << 11),
+	PORT_DEV_SMP_INIT	= (1U << 10),
+	PORT_DEV_STP_INIT	= (1U << 9),
+	PORT_PHY_ID_MASK	= (0xFFU << 24),
+	PORT_SSP_TRGT_MASK	= (0x1U << 19),
+	PORT_SSP_INIT_MASK	= (0x1U << 11),
+	PORT_DEV_TRGT_MASK	= (0x7U << 17),
+	PORT_DEV_INIT_MASK	= (0x7U << 9),
+	PORT_DEV_TYPE_MASK	= (0x7U << 0),
+
+	/* Port n PHY Status */
+	PHY_RDY			= (1U << 2),
+	PHY_DW_SYNC		= (1U << 1),
+	PHY_OOB_DTCTD		= (1U << 0),
+
+	/* VSR */
+	/* PHYMODE 6 (CDB) */
+	PHY_MODE6_LATECLK	= (1U << 29),	/* Lock Clock */
+	PHY_MODE6_DTL_SPEED	= (1U << 27),	/* Digital Loop Speed */
+	PHY_MODE6_FC_ORDER	= (1U << 26),	/* Fibre Channel Mode
Order*/
+	PHY_MODE6_MUCNT_EN	= (1U << 24),	/* u Count Enable */
+	PHY_MODE6_SEL_MUCNT_LEN	= (1U << 22),	/* Training Length
Select */
+	PHY_MODE6_SELMUPI	= (1U << 20),	/* Phase Multi Select
(init) */
+	PHY_MODE6_SELMUPF	= (1U << 18),	/* Phase Multi Select
(final) */
+	PHY_MODE6_SELMUFF	= (1U << 16),	/* Freq Loop Multi
Sel(final) */
+	PHY_MODE6_SELMUFI	= (1U << 14),	/* Freq Loop Multi
Sel(init) */
+	PHY_MODE6_FREEZE_LOOP	= (1U << 12),	/* Freeze Rx CDR Loop */
+	PHY_MODE6_INT_RXFOFFS	= (1U << 3),	/* Rx CDR Freq Loop
Enable */
+	PHY_MODE6_FRC_RXFOFFS	= (1U << 2),	/* Initial Rx CDR Offset
*/
+	PHY_MODE6_STAU_0D8	= (1U << 1),	/* Rx CDR Freq Loop
Saturate */
+	PHY_MODE6_RXSAT_DIS	= (1U << 0),	/* Saturate Ctl */
+};
+
+/* SAS/SATA configuration port registers, aka phy registers */
+enum sas_sata_config_port_regs {
+	PHYR_IDENTIFY		= 0x00,	/* info for IDENTIFY frame */
+	PHYR_ADDR_LO		= 0x04,	/* my SAS address (low) */
+	PHYR_ADDR_HI		= 0x08,	/* my SAS address (high) */
+	PHYR_ATT_DEV_INFO	= 0x0C,	/* attached device info */
+	PHYR_ATT_ADDR_LO	= 0x10,	/* attached dev SAS addr (low)
*/
+	PHYR_ATT_ADDR_HI	= 0x14,	/* attached dev SAS addr (high)
*/
+	PHYR_SATA_CTL		= 0x18,	/* SATA control */
+	PHYR_PHY_STAT		= 0x1C,	/* PHY status */
+	PHYR_SATA_SIG0		= 0x20,	/*port SATA signature FIS(Byte
0-3) */
+	PHYR_SATA_SIG1		= 0x24,	/*port SATA signature FIS(Byte
4-7) */
+	PHYR_SATA_SIG2		= 0x28,	/*port SATA signature FIS(Byte
8-11) */
+	PHYR_SATA_SIG3		= 0x2c,	/*port SATA signature FIS(Byte
12-15) */
+	PHYR_R_ERR_COUNT	= 0x30, /* port R_ERR count register */
+	PHYR_CRC_ERR_COUNT	= 0x34, /* port CRC error count register
*/
+	PHYR_WIDE_PORT		= 0x38,	/* wide port participating */
+	PHYR_CURRENT0		= 0x80,	/* current connection info 0 */
+	PHYR_CURRENT1		= 0x84,	/* current connection info 1 */
+	PHYR_CURRENT2		= 0x88,	/* current connection info 2 */
+	CONFIG_ID_FRAME0       = 0x100, /* Port device ID frame register
0 */
+	CONFIG_ID_FRAME1       = 0x104, /* Port device ID frame register
1 */
+	CONFIG_ID_FRAME2       = 0x108, /* Port device ID frame register
2 */
+	CONFIG_ID_FRAME3       = 0x10c, /* Port device ID frame register
3 */
+	CONFIG_ID_FRAME4       = 0x110, /* Port device ID frame register
4 */
+	CONFIG_ID_FRAME5       = 0x114, /* Port device ID frame register
5 */
+	CONFIG_ID_FRAME6       = 0x118, /* Port device ID frame register
6 */
+	CONFIG_ATT_ID_FRAME0   = 0x11c, /* attached device ID frame
register 0 */
+	CONFIG_ATT_ID_FRAME1   = 0x120, /* attached device ID frame
register 1 */
+	CONFIG_ATT_ID_FRAME2   = 0x124, /* attached device ID frame
register 2 */
+	CONFIG_ATT_ID_FRAME3   = 0x128, /* attached device ID frame
register 3 */
+	CONFIG_ATT_ID_FRAME4   = 0x12c, /* attached device ID frame
register 4 */
+	CONFIG_ATT_ID_FRAME5   = 0x130, /* attached device ID frame
register 5 */
+	CONFIG_ATT_ID_FRAME6   = 0x134, /* attached device ID frame
register 6 */
+};
+
+enum sas_cmd_port_registers {
+	CMD_CMRST_OOB_DET	= 0x100, /* COMRESET OOB detect register
*/
+	CMD_CMWK_OOB_DET	= 0x104, /* COMWAKE OOB detect register
*/
+	CMD_CMSAS_OOB_DET	= 0x108, /* COMSAS OOB detect register
*/
+	CMD_BRST_OOB_DET	= 0x10c, /* burst OOB detect register */
+	CMD_OOB_SPACE		= 0x110, /* OOB space control register
*/
+	CMD_OOB_BURST		= 0x114, /* OOB burst control register
*/
+	CMD_PHY_TIMER		= 0x118, /* PHY timer control register
*/
+	CMD_PHY_CONFIG0		= 0x11c, /* PHY config register 0 */
+	CMD_PHY_CONFIG1		= 0x120, /* PHY config register 1 */
+	CMD_SAS_CTL0		= 0x124, /* SAS control register 0 */
+	CMD_SAS_CTL1		= 0x128, /* SAS control register 1 */
+	CMD_SAS_CTL2		= 0x12c, /* SAS control register 2 */
+	CMD_SAS_CTL3		= 0x130, /* SAS control register 3 */
+	CMD_ID_TEST		= 0x134, /* ID test register */
+	CMD_PL_TIMER		= 0x138, /* PL timer register */
+	CMD_WD_TIMER		= 0x13c, /* WD timer register */
+	CMD_PORT_SEL_COUNT	= 0x140, /* port selector count register
*/
+	CMD_APP_MEM_CTL		= 0x144, /* Application Memory Control
*/
+	CMD_XOR_MEM_CTL		= 0x148, /* XOR Block Memory Control */
+	CMD_DMA_MEM_CTL		= 0x14c, /* DMA Block Memory Control */
+	CMD_PORT_MEM_CTL0	= 0x150, /* Port Memory Control 0 */
+	CMD_PORT_MEM_CTL1	= 0x154, /* Port Memory Control 1 */
+	CMD_SATA_PORT_MEM_CTL0	= 0x158, /* SATA Port Memory Control 0
*/
+	CMD_SATA_PORT_MEM_CTL1	= 0x15c, /* SATA Port Memory Control 1
*/
+	CMD_XOR_MEM_BIST_CTL	= 0x160, /* XOR Memory BIST Control */
+	CMD_XOR_MEM_BIST_STAT	= 0x164, /* XOR Memroy BIST Status */
+	CMD_DMA_MEM_BIST_CTL	= 0x168, /* DMA Memory BIST Control */
+	CMD_DMA_MEM_BIST_STAT	= 0x16c, /* DMA Memory BIST Status */
+	CMD_PORT_MEM_BIST_CTL	= 0x170, /* Port Memory BIST Control */
+	CMD_PORT_MEM_BIST_STAT0 = 0x174, /* Port Memory BIST Status 0 */
+	CMD_PORT_MEM_BIST_STAT1 = 0x178, /* Port Memory BIST Status 1 */
+	CMD_STP_MEM_BIST_CTL	= 0x17c, /* STP Memory BIST Control */
+	CMD_STP_MEM_BIST_STAT0	= 0x180, /* STP Memory BIST Status 0 */
+	CMD_STP_MEM_BIST_STAT1	= 0x184, /* STP Memory BIST Status 1 */
+	CMD_RESET_COUNT		= 0x188, /* Reset Count */
+	CMD_MONTR_DATA_SEL	= 0x18C, /* Monitor Data/Select */
+	CMD_PLL_PHY_CONFIG	= 0x190, /* PLL/PHY Configuration */
+	CMD_PHY_CTL		= 0x194, /* PHY Control and Status */
+	CMD_PHY_TEST_COUNT0	= 0x198, /* Phy Test Count 0 */
+	CMD_PHY_TEST_COUNT1	= 0x19C, /* Phy Test Count 1 */
+	CMD_PHY_TEST_COUNT2	= 0x1A0, /* Phy Test Count 2 */
+	CMD_APP_ERR_CONFIG	= 0x1A4, /* Application Error
Configuration */
+	CMD_PND_FIFO_CTL0	= 0x1A8, /* Pending FIFO Control 0 */
+	CMD_HOST_CTL		= 0x1AC, /* Host Control Status */
+	CMD_HOST_WR_DATA	= 0x1B0, /* Host Write Data */
+	CMD_HOST_RD_DATA	= 0x1B4, /* Host Read Data */
+	CMD_PHY_MODE_21		= 0x1B8, /* Phy Mode 21 */
+	CMD_SL_MODE0		= 0x1BC, /* SL Mode 0 */
+	CMD_SL_MODE1		= 0x1C0, /* SL Mode 1 */
+	CMD_PND_FIFO_CTL1	= 0x1C4, /* Pending FIFO Control 1 */
+};
+
+enum mvs_info_flags {
+	MVF_MSI			= (1U << 0),	/* MSI is enabled */
+	MVF_PHY_PWR_FIX		= (1U << 1),	/* bug workaround */
+	MVF_FLAG_SOC		= (1U << 2),	/* SoC integrated
controllers */
+};
+
+enum mvs_event_flags {
+	PHY_PLUG_EVENT		= (3U),
+	PHY_PLUG_IN		= (1U << 0),	/* phy plug in */
+	PHY_PLUG_OUT		= (1U << 1),	/* phy plug out */
+};
+
+enum mvs_port_type {
+	PORT_TGT_MASK	=  (1U << 5),
+	PORT_INIT_PORT	=  (1U << 4),
+	PORT_TGT_PORT	=  (1U << 3),
+	PORT_INIT_TGT_PORT = (PORT_INIT_PORT | PORT_TGT_PORT),
+	PORT_TYPE_SAS	=  (1U << 1),
+	PORT_TYPE_SATA	=  (1U << 0),
+};
+
+/* Command Table Format */
+enum ct_format {
+	/* SSP */
+	SSP_F_H		=  0x00,
+	SSP_F_IU	=  0x18,
+	SSP_F_MAX	=  0x4D,
+	/* STP */
+	STP_CMD_FIS	=  0x00,
+	STP_ATAPI_CMD	=  0x40,
+	STP_F_MAX	=  0x10,
+	/* SMP */
+	SMP_F_T		=  0x00,
+	SMP_F_DEP	=  0x01,
+	SMP_F_MAX	=  0x101,
+};
+
+enum status_buffer {
+	SB_EIR_OFF	=  0x00,	/* Error Information Record */
+	SB_RFB_OFF	=  0x08,	/* Response Frame Buffer */
+	SB_RFB_MAX	=  0x400,	/* RFB size*/
+};
+
+enum error_info_rec {
+	CMD_ISS_STPD	= (1U << 31),	/* Cmd Issue Stopped */
+	CMD_PI_ERR	= (1U << 30),	/* Protection info error.  see
flags2 */
+	RSP_OVER	= (1U << 29),	/* rsp buffer overflow */
+	RETRY_LIM	= (1U << 28),	/* FIS/frame retry limit
exceeded */
+	UNK_FIS 	= (1U << 27),	/* unknown FIS */
+	DMA_TERM	= (1U << 26),	/* DMA terminate primitive rx'd
*/
+	SYNC_ERR	= (1U << 25),	/* SYNC rx'd during frame xmit
*/
+	TFILE_ERR	= (1U << 24),	/* SATA taskfile Error bit set
*/
+	R_ERR		= (1U << 23),	/* SATA returned R_ERR prim */
+	RD_OFS		= (1U << 20),	/* Read DATA frame invalid
offset */
+	XFER_RDY_OFS	= (1U << 19),	/* XFER_RDY offset error */
+	UNEXP_XFER_RDY	= (1U << 18),	/* unexpected XFER_RDY error */
+	DATA_OVER_UNDER = (1U << 16),	/* data overflow/underflow */
+	INTERLOCK	= (1U << 15),	/* interlock error */
+	NAK		= (1U << 14),	/* NAK rx'd */
+	ACK_NAK_TO	= (1U << 13),	/* ACK/NAK timeout */
+	CXN_CLOSED	= (1U << 12),	/* cxn closed w/out ack/nak */
+	OPEN_TO 	= (1U << 11),	/* I_T nexus lost, open cxn
timeout */
+	PATH_BLOCKED	= (1U << 10),	/* I_T nexus lost, pathway
blocked */
+	NO_DEST 	= (1U << 9),	/* I_T nexus lost, no
destination */
+	STP_RES_BSY	= (1U << 8),	/* STP resources busy */
+	BREAK		= (1U << 7),	/* break received */
+	BAD_DEST	= (1U << 6),	/* bad destination */
+	BAD_PROTO	= (1U << 5),	/* protocol not supported */
+	BAD_RATE	= (1U << 4),	/* cxn rate not supported */
+	WRONG_DEST	= (1U << 3),	/* wrong destination error */
+	CREDIT_TO	= (1U << 2),	/* credit timeout */
+	WDOG_TO 	= (1U << 1),	/* watchdog timeout */
+	BUF_PAR 	= (1U << 0),	/* buffer parity error */
+};
+
+enum error_info_rec_2 {
+	SLOT_BSY_ERR	= (1U << 31),	/* Slot Busy Error */
+	GRD_CHK_ERR	= (1U << 14),	/* Guard Check Error */
+	APP_CHK_ERR	= (1U << 13),	/* Application Check error */
+	REF_CHK_ERR	= (1U << 12),	/* Reference Check Error */
+	USR_BLK_NM	= (1U << 0),	/* User Block Number */
+};
+
+enum pci_cfg_register_bits {
+	PCTL_PWR_OFF	= (0xFU << 24),
+	PCTL_COM_ON	= (0xFU << 20),
+	PCTL_LINK_RST	= (0xFU << 16),
+	PCTL_LINK_OFFS	= (16),
+	PCTL_PHY_DSBL	= (0xFU << 12),
+	PCTL_PHY_DSBL_OFFS	= (12),
+	PRD_REQ_SIZE	= (0x4000),
+	PRD_REQ_MASK	= (0x00007000),
+	PLS_NEG_LINK_WD		= (0x3FU << 4),
+	PLS_NEG_LINK_WD_OFFS	= 4,
+	PLS_LINK_SPD		= (0x0FU << 0),
+	PLS_LINK_SPD_OFFS	= 0,
+};
+
+enum open_frame_protocol {
+	PROTOCOL_SMP	= 0x0,
+	PROTOCOL_SSP	= 0x1,
+	PROTOCOL_STP	= 0x2,
+};
+
+/* define for response frame datapres field */
+enum datapres_field {
+	NO_DATA		= 0,
+	RESPONSE_DATA	= 1,
+	SENSE_DATA	= 2,
+};
+
+/* define task management IU */
+struct mvs_tmf_task{
+	u8 tmf;
+	u16 tag_of_task_to_be_managed;
+};
+#endif
-- 
1.6.2.1
