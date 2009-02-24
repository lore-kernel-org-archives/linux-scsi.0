From: Ke Wei <kewei@marvell.com>
Subject: [PATCH 5/5] mvsas : redesign the mvsas driver architecture.
Date: Tue, 24 Feb 2009 17:42:51 +0800
Message-ID: <49A3C11B.3020107@marvell.com>
Reply-To: kewei@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:28401 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751991AbZBXJn7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2009 04:43:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jeff@garzik.org, james.bottomley@hansenpartnership.com, qzhao@marvell.com, qswang@marvell.com, jfeng@marvell.com, kewei@marvell.com, jasonchu@marvell.com

Added support for mv64xx and mv94xx chips. They have specific register operations.

Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas/mv_64xx.c  |  796 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/mvsas/mv_64xx.h  |  151 ++++++++
 drivers/scsi/mvsas/mv_91xx.c  |  680 +++++++++++++++++++++++++++++++++++
 drivers/scsi/mvsas/mv_91xx.h  |  193 ++++++++++
 drivers/scsi/mvsas/mv_chips.h |  266 ++++++++++++++
 5 files changed, 2086 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
new file mode 100644
index 0000000..807344b
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -0,0 +1,796 @@
+/*
+	mvsas.c - Marvell 88SE6440/88SE9480 SAS/SATA support
+
+	Copyright 2007 Red Hat, Inc.
+	Copyright 2008-2009 Marvell
+
+	This program is free software; you can redistribute it and/or
+	modify it under the terms of the GNU General Public License as
+	published by the Free Software Foundation; either version 2,
+	or (at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty
+	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+	See the GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public
+	License along with this program; see the file COPYING.	If not,
+	write to the Free Software Foundation, 675 Mass Ave, Cambridge,
+	MA 02139, USA.
+
+	---------------------------------------------------------------
+ */
+
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
+static void __devinit mvs_64xx_enable_xmt(struct mvs_info *mvi, int phy_id)
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
+		/* TEST - for phy decoding error, adjust voltage levels */
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
+			pci_read_config_dword(mvi->pdev, PCR_PHY_CTL, &reg);
+		else
+			pci_read_config_dword(mvi->pdev, PCR_PHY_CTL2, &reg);
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
+			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL, tmp);
+			mdelay(10);
+			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL, reg);
+		} else {
+			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL2, tmp);
+			mdelay(10);
+			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL2, reg);
+		}
+	} else {
+		mw32(MVS_PHY_CTL, tmp);
+		mdelay(10);
+		mw32(MVS_PHY_CTL, reg);
+	}
+}
+
+static void mvs_64xx_phy_reset(struct mvs_info *mvi, u32 phy_id, int hard)
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
+			pci_read_config_dword(mvi->pdev, PCR_PHY_CTL, &tmp);
+			tmp &= ~PCTL_PWR_OFF;
+			tmp |= PCTL_PHY_DSBL;
+			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL, tmp);
+
+			pci_read_config_dword(mvi->pdev, PCR_PHY_CTL2, &tmp);
+			tmp &= ~PCTL_PWR_OFF;
+			tmp |= PCTL_PHY_DSBL;
+			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL2, tmp);
+		}
+	}
+
+	/* make sure interrupts are masked immediately (paranoia) */
+	mw32(MVS_GBL_CTL, 0);
+	tmp = mr32(MVS_GBL_CTL);
+
+	/* Reset Controller */
+	if (!(tmp & HBA_RST)) {
+		/* global reset, incl. COMRESET/H_RESET_N (self-clearing) */
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
+	/* make sure RST is set; HBA_RST /should/ have done that for us */
+	cctl = mr32(MVS_CTL) & 0xFFFF;
+	if (cctl & CCTL_RST)
+		cctl &= ~CCTL_RST;
+	else
+		mw32_f(MVS_CTL, cctl | CCTL_RST);
+
+	if (!(mvi->flags & MVF_FLAG_SOC)) {
+		/* write to device control _AND_ device status register */
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
+		/* should set little endian SAS address to Odin chip */
+		mvs_set_sas_addr(mvi, i, PHYR_ADDR_LO, PHYR_ADDR_HI,
+						cpu_to_be64(mvi->phy[i].dev_sas_addr));
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
+		tmp = PHYEV_RDY_CH | PHYEV_BROAD_CH | PHYEV_UNASSOC_FIS |
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
+	 * do us any good on big-endian machines, need further confirmation
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
+	/* interrupt coalescing may cause missing HW interrput in some case,
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
+	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM | CINT_SRS | CINT_CI_STOP |
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
+static irqreturn_t mvs_64xx_isr(struct mvs_info *mvi, int irq, u32 stat)
+{
+	void __iomem *regs = mvi->regs;
+
+	/* clear CMD_CMPLT ASAP */
+	mw32_f(MVS_INT_STAT, CINT_DONE);
+
+	spin_lock(&mvi->lock);
+	mvs_int_full(mvi);
+	spin_unlock(&mvi->lock);
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
+static void mvs_64xx_issue_stop(struct mvs_info *mvi, enum mvs_port_type type,
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
+	//mvs_write_port_cfg_addr(mvi, i, PHYR_ADDR_HI);
+	//phy->dev_sas_addr = (u64) mvs_read_port_cfg_data(mvi, i) << 32;
+
+	//mvs_write_port_cfg_addr(mvi, i, PHYR_ADDR_LO);
+	//phy->dev_sas_addr |= mvs_read_port_cfg_data(mvi, i);
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
+u32 mvs_64xx_spi_read_data(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs_ex;
+	return ior32(ODIN_SPI_DATA_REG);
+}
+
+void mvs_64xx_spi_write_data(struct mvs_info *mvi, u32 data)
+{
+	void __iomem *regs = mvi->regs_ex;
+	 iow32(ODIN_SPI_DATA_REG, data);
+}
+
+
+int mvs_64xx_spi_buildcmd(struct mvs_info *mvi,
+						u32      *dwCmd,
+					   	u8       cmd,
+					    	u8       read,
+					    	u8       length,
+					    	u32      addr
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
+	    iow32(ODIN_SPI_CTRL_REG, SPI_CTRL_VENDOR_ENABLE);
+	    iow32(ODIN_SPI_CMD_REG, cmd );
+	    iow32(ODIN_SPI_CTRL_REG, SPI_CTRL_VENDOR_ENABLE | SPI_CTRL_SPISTART);
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
+		dwTmp = ior32(ODIN_SPI_CTRL_REG);
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
+void mvs_64xx_fix_dma(dma_addr_t buf_dma, int buf_len, int from, void *prd)
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
index 0000000..0798cc6
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_64xx.h
@@ -0,0 +1,151 @@
+/*
+	mvsas.c - Marvell 88SE6440/88SE9480 SAS/SATA support
+
+	Copyright 2007 Red Hat, Inc.
+	Copyright 2008-2009 Marvell
+
+	This program is free software; you can redistribute it and/or
+	modify it under the terms of the GNU General Public License as
+	published by the Free Software Foundation; either version 2,
+	or (at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty
+	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+	See the GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public
+	License along with this program; see the file COPYING.	If not,
+	write to the Free Software Foundation, 675 Mass Ave, Cambridge,
+	MA 02139, USA.
+
+	---------------------------------------------------------------
+ */
+
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
+	MVS_CTL			= 0x100, /* SAS/SATA port configuration */
+	MVS_PCS			= 0x104, /* SAS/SATA port control/status */
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
+					 /* ports 1-3 follow after this */
+	MVS_P0_INT_STAT		= 0x160, /* port0 interrupt status */
+	MVS_P0_INT_MASK		= 0x164, /* port0 interrupt mask */
+					 /* ports 5-7 follow after this */
+	MVS_P4_INT_STAT		= 0x200, /* Port4 interrupt status */
+	MVS_P4_INT_MASK		= 0x204, /* Port4 interrupt enable mask */
+
+					 /* ports 1-3 follow after this */
+	MVS_P0_SER_CTLSTAT	= 0x180, /* port0 serial control/status */
+					 /* ports 5-7 follow after this */
+	MVS_P4_SER_CTLSTAT	= 0x220, /* port4 serial control/status */
+
+	MVS_CMD_ADDR		= 0x1B8, /* Command register port (addr) */
+	MVS_CMD_DATA		= 0x1BC, /* Command register port (data) */
+
+					 /* ports 1-3 follow after this */
+	MVS_P0_CFG_ADDR		= 0x1C0, /* port0 phy register address */
+	MVS_P0_CFG_DATA		= 0x1C4, /* port0 phy register data */
+					 /* ports 5-7 follow after this */
+	MVS_P4_CFG_ADDR		= 0x230, /* Port4 config address */
+	MVS_P4_CFG_DATA		= 0x234, /* Port4 config data */
+
+					 /* ports 1-3 follow after this */
+	MVS_P0_VSR_ADDR		= 0x1E0, /* port0 VSR address */
+	MVS_P0_VSR_DATA		= 0x1E4, /* port0 VSR data */
+					 /* ports 5-7 follow after this */
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
+	__le64			addr;		/* 64-bit buffer address */
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
+#define ODIN_SPI_CTRL_REG		0x10
+#define ODIN_SPI_CMD_REG			0x14
+#define ODIN_SPI_DATA_REG		0x18
+
+#endif
diff --git a/drivers/scsi/mvsas/mv_91xx.c b/drivers/scsi/mvsas/mv_91xx.c
new file mode 100644
index 0000000..f64b0b7
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_91xx.c
@@ -0,0 +1,680 @@
+/*
+	mvsas.c - Marvell 88SE6440/88SE9480 SAS/SATA support
+
+	Copyright 2007 Red Hat, Inc.
+	Copyright 2008-2009 Marvell
+
+	This program is free software; you can redistribute it and/or
+	modify it under the terms of the GNU General Public License as
+	published by the Free Software Foundation; either version 2,
+	or (at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty
+	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+	See the GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public
+	License along with this program; see the file COPYING.	If not,
+	write to the Free Software Foundation, 675 Mass Ave, Cambridge,
+	MA 02139, USA.
+
+	---------------------------------------------------------------
+ */
+
+#include "mv_sas.h"
+#include "mv_91xx.h"
+#include "mv_chips.h"
+
+static void mvs_91xx_detect_porttype(struct mvs_info *mvi, int i)
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
+static void __devinit mvs_91xx_enable_xmt(struct mvs_info *mvi, int phy_id)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+	tmp = mr32(MVS_PCS);
+	tmp |= 1 << (phy_id + PCS_EN_PORT_XMT_SHIFT2);
+	mw32(MVS_PCS, tmp);
+}
+
+static void mvs_91xx_phy_reset(struct mvs_info *mvi, u32 phy_id, int hard)
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
+static void mvs_91xx_phy_disable(struct mvs_info *mvi, u32 phy_id)
+{
+	u32 tmp;
+	mvs_write_port_vsr_addr(mvi, phy_id, VSR_PHY_MODE2);
+	tmp = mvs_read_port_vsr_data(mvi, phy_id);
+	mvs_write_port_vsr_data(mvi, phy_id, tmp | 0x00800000);
+}
+
+static void mvs_91xx_phy_enable(struct mvs_info *mvi, u32 phy_id)
+{
+        mvs_write_port_vsr_addr(mvi, phy_id, 0x1B4);
+        mvs_write_port_vsr_data(mvi, phy_id, 0x8300ffc1);
+        mvs_write_port_vsr_addr(mvi, phy_id, 0x104);
+        mvs_write_port_vsr_data(mvi, phy_id, 0x00018080);
+	mvs_write_port_vsr_addr(mvi, phy_id, VSR_PHY_MODE2);
+	mvs_write_port_vsr_data(mvi, phy_id, 0x00207fff);
+}
+
+static int __devinit mvs_91xx_init(struct mvs_info *mvi)
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
+	/* make sure RST is set; HBA_RST /should/ have done that for us */
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
+		mvs_91xx_phy_disable(mvi, i);
+		/* set phy local SAS address */
+		mvs_set_sas_addr(mvi, i, CONFIG_ID_FRAME3, CONFIG_ID_FRAME4,
+						(mvi->phy[i].dev_sas_addr));
+
+		mvs_91xx_enable_xmt(mvi, i);
+		mvs_91xx_phy_enable(mvi, i);
+
+		mvs_91xx_phy_reset(mvi, i, 1);
+		msleep(500);
+		mvs_91xx_detect_porttype(mvi, i);
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
+			PHYEV_ID_DONE  | PHYEV_DCDR_ERR | PHYEV_CRC_ERR ;
+			//PHYEV_UNASSOC_FIS | PHYEV_DEC_ERR; //Disable phy decoding error.
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
+	 * do us any good on big-endian machines, need further confirmation
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
+	/* interrupt coalescing may cause missing HW interrput in some case,
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
+	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM | CINT_SRS | CINT_CI_STOP |
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
+static int mvs_91xx_ioremap(struct mvs_info *mvi)
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
+static void mvs_91xx_iounmap(struct mvs_info *mvi)
+{
+	if (mvi->regs) {
+		mvi->regs -= 0x20000;
+		if (mvi->id == 1)
+			mvi->regs -= 0x4000;
+		mvs_iounmap(mvi->regs);
+	}
+}
+
+static void mvs_91xx_interrupt_enable(struct mvs_info *mvi)
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
+static void mvs_91xx_interrupt_disable(struct mvs_info *mvi)
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
+static u32 mvs_91xx_isr_status(struct mvs_info *mvi, int irq)
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
+static irqreturn_t mvs_91xx_isr(struct mvs_info *mvi, int irq, u32 stat)
+{
+	void __iomem *regs = mvi->regs;
+
+	if (((stat & IRQ_SAS_A) && mvi->id == 0) ||
+			((stat & IRQ_SAS_B) && mvi->id == 1)) {
+		mw32_f(MVS_INT_STAT, CINT_DONE);
+		spin_lock(&mvi->lock);
+		mvs_int_full(mvi);
+		spin_unlock(&mvi->lock);
+	}
+	return IRQ_HANDLED;
+}
+
+static void mvs_91xx_command_active(struct mvs_info *mvi, u32 slot_idx)
+{
+	u32 tmp;
+	mvs_cw32(mvi, 0x300 + (slot_idx >> 3), 1 << (slot_idx % 32));
+	do {
+		tmp = mvs_cr32(mvi, 0x300 + (slot_idx >> 3));
+	} while (tmp & 1 << (slot_idx % 32));
+}
+
+static void mvs_91xx_issue_stop(struct mvs_info *mvi, enum mvs_port_type type,
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
+static void mvs_91xx_free_reg_set(struct mvs_info *mvi, u8 *tfs)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp, offs;
+
+	if (*tfs == MVS_ID_NOT_MAPPED)
+		return;
+
+	if (*tfs < 32) {
+		tmp = mr32(MVS_STP_REG_SET_0);
+		offs = 1U << *tfs;
+		mw32(MVS_STP_REG_SET_0, tmp & ~offs);
+		tmp = mr32(MVS_INT_STAT_SRS_0) & offs;
+		if (tmp)
+			mw32(MVS_INT_STAT_SRS_0, tmp);
+	} else {
+		tmp = mr32(MVS_STP_REG_SET_1);
+		offs = 1U << (*tfs - 32);
+		mw32(MVS_STP_REG_SET_1, tmp & ~offs);
+		tmp = mr32(MVS_INT_STAT_SRS_1) & offs;
+		if (tmp)
+			mw32(MVS_INT_STAT_SRS_1, tmp);
+	}
+
+	*tfs = MVS_ID_NOT_MAPPED;
+	return;
+}
+
+static u8 mvs_91xx_assign_reg_set(struct mvs_info *mvi, u8 *tfs)
+{
+	int i;
+	u32 tmp, offs;
+	void __iomem *regs = mvi->regs;
+
+	if (*tfs != MVS_ID_NOT_MAPPED)
+		return 0;
+
+	tmp = mr32(MVS_STP_REG_SET_0);
+	for (i = 0; i < 32; i++) {
+		offs = 1U << i;
+		if (!(tmp & offs)) {
+			*tfs = i;
+			mw32(MVS_STP_REG_SET_0, tmp | offs);
+			tmp = mr32(MVS_INT_STAT_SRS_0) & offs;
+			if (tmp)
+				mw32(MVS_INT_STAT_SRS_0, tmp);
+			return 0;
+		}
+	}
+	tmp = mr32(MVS_STP_REG_SET_1);
+	for (i = 0; i < 32; i++) {
+		offs = 1U << i;
+		if (!(tmp & offs)) {
+			*tfs = i + 32;
+			mw32(MVS_STP_REG_SET_1, tmp | offs);
+			tmp = mr32(MVS_INT_STAT_SRS_1) & offs;
+			if (tmp)
+				mw32(MVS_INT_STAT_SRS_1, tmp);
+			return 0;
+		}
+	}
+	return MVS_ID_NOT_MAPPED;
+}
+
+static void mvs_91xx_make_prd(struct scatterlist *scatter, int nr, void *prd)
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
+static int mvs_91xx_oob_done(struct mvs_info *mvi, int i)
+{
+	u32 phy_st;
+	mvs_write_port_vsr_addr(mvi, i, VSR_PHY_STAT);
+	phy_st = mvs_read_port_vsr_data(mvi, i);
+	if (phy_st & 0x2)	/* phy ready */
+		return 1;
+	return 0;
+}
+
+static void mvs_91xx_get_dev_identify_frame(struct mvs_info *mvi, int port_id,
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
+static void mvs_91xx_get_att_identify_frame(struct mvs_info *mvi, int port_id,
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
+		mv_dprintk("91xx phy %d atta frame %d %x.\n",port_id+ mvi->id *
mvi->chip->n_phy, i, id_frame[i]);
+	}
+	/* mvs_hexdump(28, (u8 *)id_frame, 0); */
+	memcpy(id, id_frame, 28);
+}
+
+static u32 mvs_91xx_make_dev_info(struct sas_identify_frame *id)
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
+static u32 mvs_91xx_make_att_info(struct sas_identify_frame *id)
+{
+	return mvs_91xx_make_dev_info(id);
+}
+
+static void mvs_91xx_fix_phy_info(struct mvs_info *mvi, int i,
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
+	mvs_91xx_get_dev_identify_frame(mvi, i, id);
+	phy->dev_info = mvs_91xx_make_dev_info(id);
+
+	if(phy->phy_type & PORT_TYPE_SAS){
+		mvs_91xx_get_att_identify_frame(mvi, i, id);
+		phy->att_dev_info = mvs_91xx_make_att_info(id);
+		phy->att_dev_sas_addr = *(u64 *)id->sas_addr;
+	} else {
+		phy->att_dev_info = PORT_DEV_STP_TRGT | 1;	//end device
+	}
+
+}
+
+void mvs_91xx_phy_set_link_rate(struct mvs_info *mvi, u32 phy_id,
+			struct sas_phy_linkrates *rates)
+{
+	/* TODO */
+}
+
+static void mvs_91xx_clear_active_cmds(struct mvs_info *mvi)
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
+u32 mvs_91xx_spi_read_data(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs_ex - 0x10200;
+	return mr32(SPI_RD_DATA_REG_VANIR);
+}
+
+void mvs_91xx_spi_write_data(struct mvs_info *mvi, u32 data)
+{
+	void __iomem *regs = mvi->regs_ex - 0x10200;
+	 mw32(SPI_RD_DATA_REG_VANIR, data);
+}
+
+
+int mvs_91xx_spi_buildcmd(struct mvs_info *mvi,
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
+        dwTmp|= SPI_CTRL_READ_VANIR;
+    }
+
+    if (addr != MV_MAX_U32){
+	    mw32(SPI_ADDR_REG_VANIR, (addr & 0x0003FFFFL));
+	    dwTmp|= SPI_ADDR_VLD_VANIR;
+    }
+
+    *dwCmd = dwTmp;
+    return 0;
+}
+
+
+int mvs_91xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
+{
+	void __iomem *regs = mvi->regs_ex - 0x10200;
+	mw32(SPI_CTRL_REG_VANIR, cmd | SPI_CTRL_SpiStart_VANIR );
+
+	return 0;
+}
+
+int mvs_91xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
+{
+	void __iomem *regs = mvi->regs_ex - 0x10200;
+	u32   i, dwTmp;
+
+	for( i=0; i<timeout; i++ ){
+		dwTmp = mr32(SPI_CTRL_REG_VANIR);
+		if( !( dwTmp & SPI_CTRL_SpiStart_VANIR) ){
+			return 0;
+		}
+		msleep( 10 );
+	}
+
+	return -1;
+}
+
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+void mvs_91xx_fix_dma(dma_addr_t buf_dma, int buf_len, int from, void *prd)
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
+const struct mvs_dispatch mvs_91xx_dispatch = {
+	"mv91xx",
+	mvs_91xx_init,
+	NULL,
+	mvs_91xx_ioremap,
+	mvs_91xx_iounmap,
+	mvs_91xx_isr,
+	mvs_91xx_isr_status,
+	mvs_91xx_interrupt_enable,
+	mvs_91xx_interrupt_disable,
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
+	mvs_91xx_command_active,
+	mvs_91xx_issue_stop,
+	mvs_start_delivery,
+	mvs_rx_update,
+	mvs_int_full,
+	mvs_91xx_assign_reg_set,
+	mvs_91xx_free_reg_set,
+	mvs_get_prd_size,
+	mvs_get_prd_count,
+	mvs_91xx_make_prd,
+	mvs_91xx_detect_porttype,
+	mvs_91xx_oob_done,
+	mvs_91xx_fix_phy_info,
+	NULL,
+	mvs_91xx_phy_set_link_rate,
+	mvs_hw_max_link_rate,
+	mvs_91xx_phy_disable,
+	mvs_91xx_phy_enable,
+	mvs_91xx_phy_reset,
+	NULL,
+	mvs_91xx_clear_active_cmds,
+	mvs_91xx_spi_read_data,
+	mvs_91xx_spi_write_data,
+	mvs_91xx_spi_buildcmd,
+	mvs_91xx_spi_issuecmd,
+	mvs_91xx_spi_waitdataready,
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	mvs_91xx_fix_dma,
+#endif
+};
+
diff --git a/drivers/scsi/mvsas/mv_91xx.h b/drivers/scsi/mvsas/mv_91xx.h
new file mode 100644
index 0000000..d183d89
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_91xx.h
@@ -0,0 +1,193 @@
+/*
+	mvsas.c - Marvell 88SE6440/88SE9480 SAS/SATA support
+
+	Copyright 2007 Red Hat, Inc.
+	Copyright 2008-2009 Marvell
+
+	This program is free software; you can redistribute it and/or
+	modify it under the terms of the GNU General Public License as
+	published by the Free Software Foundation; either version 2,
+	or (at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty
+	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+	See the GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public
+	License along with this program; see the file COPYING.	If not,
+	write to the Free Software Foundation, 675 Mass Ave, Cambridge,
+	MA 02139, USA.
+
+	---------------------------------------------------------------
+ */
+
+#ifndef _MVS91XX_REG_H_
+#define _MVS91XX_REG_H_
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
+	MVS_CTL			= 0x100, /* SAS/SATA port configuration */
+	MVS_PCS			= 0x104, /* SAS/SATA port control/status */
+	MVS_CMD_LIST_LO		= 0x108, /* cmd list addr */
+	MVS_CMD_LIST_HI		= 0x10C,
+	MVS_RX_FIS_LO		= 0x110, /* RX FIS list addr */
+	MVS_RX_FIS_HI		= 0x114,
+	MVS_STP_REG_SET_0	= 0x118, /* STP/SATA Register Set Enable */
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
+	MVS_NON_NCQ_ERR_0	= 0x168, /* SRS Non-specific NCQ Error */
+	MVS_NON_NCQ_ERR_1	= 0x16C,
+	MVS_CMD_ADDR		= 0x170, /* Command register port (addr) */
+	MVS_CMD_DATA		= 0x174, /* Command register port (data) */
+	MVS_MEM_PARITY_ERR	= 0x178, /* Memory parity error */
+
+					 /* ports 1-3 follow after this */
+	MVS_P0_INT_STAT		= 0x180, /* port0 interrupt status */
+	MVS_P0_INT_MASK		= 0x184, /* port0 interrupt mask */
+					 /* ports 5-7 follow after this */
+	MVS_P4_INT_STAT		= 0x1A0, /* Port4 interrupt status */
+	MVS_P4_INT_MASK		= 0x1A4, /* Port4 interrupt enable mask */
+
+					 /* ports 1-3 follow after this */
+	MVS_P0_SER_CTLSTAT	= 0x1D0, /* port0 serial control/status */
+					 /* ports 5-7 follow after this */
+	MVS_P4_SER_CTLSTAT	= 0x1E0, /* port4 serial control/status */
+
+					 /* ports 1-3 follow after this */
+	MVS_P0_CFG_ADDR		= 0x200, /* port0 phy register address */
+	MVS_P0_CFG_DATA		= 0x204, /* port0 phy register data */
+					 /* ports 5-7 follow after this */
+	MVS_P4_CFG_ADDR		= 0x220, /* Port4 config address */
+	MVS_P4_CFG_DATA		= 0x224, /* Port4 config data */
+
+					 /* phys 1-3 follow after this */
+	MVS_P0_VSR_ADDR		= 0x250, /* phy0 VSR address */
+	MVS_P0_VSR_DATA		= 0x254, /* phy0 VSR data */
+					 /* phys 1-3 follow after this */
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
+	__le64			addr;		/* 64-bit buffer address */
+	struct mvs_prd_imt	im_len;		/* 22-bit length */
+} __attribute__ ((packed));
+
+#define SPI_CTRL_REG_VANIR           	0xc800
+#define SPI_ADDR_REG_VANIR            	0xc804
+#define SPI_WR_DATA_REG_VANIR         0xc808
+#define SPI_RD_DATA_REG_VANIR         	0xc80c
+#define SPI_CTRL_READ_VANIR         	(1U << 2)
+#define SPI_ADDR_VLD_VANIR         	(1U << 1)
+#define SPI_CTRL_SpiStart_VANIR     	(1U << 0)
+
+#endif
diff --git a/drivers/scsi/mvsas/mv_chips.h b/drivers/scsi/mvsas/mv_chips.h
new file mode 100644
index 0000000..3d08040
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_chips.h
@@ -0,0 +1,266 @@
+/*
+	mvsas.c - Marvell 88SE6440/88SE9480 SAS/SATA support
+
+	Copyright 2007 Red Hat, Inc.
+	Copyright 2008-2009 Marvell
+
+	This program is free software; you can redistribute it and/or
+	modify it under the terms of the GNU General Public License as
+	published by the Free Software Foundation; either version 2,
+	or (at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty
+	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+	See the GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public
+	License along with this program; see the file COPYING.	If not,
+	write to the Free Software Foundation, 675 Mass Ave, Cambridge,
+	MA 02139, USA.
+
+	---------------------------------------------------------------
+ */
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
+#define iow8(reg, val) 		outb((unsigned long)(val, regs + reg))
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
+static inline void mvs_write_phy_ctl(struct mvs_info *mvi, u32 port, u32 val)
+{
+	void __iomem *regs = mvi->regs;
+	if (port < 4)
+		mw32(MVS_P0_SER_CTLSTAT + port * 4, val);
+	else
+		mw32(MVS_P4_SER_CTLSTAT + (port - 4) * 4, val);
+}
+
+static inline u32 mvs_read_port(struct mvs_info *mvi, u32 off, u32 off2, u32 port)
+{
+	void __iomem *regs = mvi->regs + off;
+	void __iomem *regs2 = mvi->regs + off2;
+	return (port < 4)?readl(regs + port * 8):
+		readl(regs2 + (port - 4) * 8);
+}
+
+static inline void mvs_write_port(struct mvs_info *mvi, u32 off, u32 off2,
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
+static inline u32 mvs_read_port_cfg_data(struct mvs_info *mvi, u32 port)
+{
+	return mvs_read_port(mvi, MVS_P0_CFG_DATA,
+			MVS_P4_CFG_DATA, port);
+}
+
+static inline void mvs_write_port_cfg_data(struct mvs_info *mvi, u32 port, u32 val)
+{
+	mvs_write_port(mvi, MVS_P0_CFG_DATA,
+			MVS_P4_CFG_DATA, port, val);
+}
+
+static inline void mvs_write_port_cfg_addr(struct mvs_info *mvi, u32 port, u32
addr)
+{
+	mvs_write_port(mvi, MVS_P0_CFG_ADDR,
+			MVS_P4_CFG_ADDR, port, addr);
+	mdelay(10);
+}
+
+static inline u32 mvs_read_port_vsr_data(struct mvs_info *mvi, u32 port)
+{
+	return mvs_read_port(mvi, MVS_P0_VSR_DATA,
+			MVS_P4_VSR_DATA, port);
+}
+
+static inline void mvs_write_port_vsr_data(struct mvs_info *mvi, u32 port, u32 val)
+{
+	mvs_write_port(mvi, MVS_P0_VSR_DATA,
+			MVS_P4_VSR_DATA, port, val);
+}
+
+static inline void mvs_write_port_vsr_addr(struct mvs_info *mvi, u32 port, u32
addr)
+{
+	mvs_write_port(mvi, MVS_P0_VSR_ADDR,
+			MVS_P4_VSR_ADDR, port, addr);
+	mdelay(10);
+}
+
+static inline u32 mvs_read_port_irq_stat(struct mvs_info *mvi, u32 port)
+{
+	return mvs_read_port(mvi, MVS_P0_INT_STAT,
+			MVS_P4_INT_STAT, port);
+}
+
+static inline void mvs_write_port_irq_stat(struct mvs_info *mvi, u32 port, u32 val)
+{
+	mvs_write_port(mvi, MVS_P0_INT_STAT,
+			MVS_P4_INT_STAT, port, val);
+}
+
+static inline u32 mvs_read_port_irq_mask(struct mvs_info *mvi, u32 port)
+{
+	return mvs_read_port(mvi, MVS_P0_INT_MASK,
+			MVS_P4_INT_MASK, port);
+
+}
+
+static inline void mvs_write_port_irq_mask(struct mvs_info *mvi, u32 port, u32 val)
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
+	/* not to halt for different port op during wideport link change */
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
+	if (mvi->flags & MVF_FLAG_SOC)
+		return;
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
-- 
1.5.4.3





