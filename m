From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 3/3] [SCSI] mvsas: add support for 94xx; layout change; bug fixes
Date: Fri, 8 May 2009 17:46:40 -0400
Message-ID: <b1b1a854fe26ace0a326484d0db24c8c67fce7c7.1241819334.git.jgarzik@redhat.com>
References: <2a29d6a8d79b9723cfb1aaddfd0e1725c15dab6e.1241819334.git.jgarzik@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:58339 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbZEHWEx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 May 2009 18:04:53 -0400
In-Reply-To: <2a29d6a8d79b9723cfb1aaddfd0e1725c15dab6e.1241819334.git.jgarzik@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jasonchu@marvell.com, ayan@marvell.com, kewei@marvell.com

From: Andy Yan <ayan@marvell.com>

This version contains following main changes
  - Switch to new layout to support more types of ASIC.
  - SSP TMF supported and related Error Handing enhanced.
  - Support flash feature with delay 2*HZ when PHY changed.
  - Support Marvell 94xx series ASIC for 6G SAS/SATA, which has 2
88SE64xx chips but any different register description.
  - Support SPI flash for HBA-related configuration info.
  - Other patch enhanced from kernel side such as increasing PHY type

[jejb: fold back in DMA_BIT_MASK changes]
Signed-off-by: Ying Chu <jasonchu@marvell.com>
Signed-off-by: Andy Yan <ayan@marvell.com>
Signed-off-by: Ke Wei <kewei@marvell.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/mvsas/Kconfig    |   23 +-
 drivers/scsi/mvsas/Makefile   |    9 +-
 drivers/scsi/mvsas/mv_64xx.c  |  785 ++++++++++++++--
 drivers/scsi/mvsas/mv_64xx.h  |   75 ++-
 drivers/scsi/mvsas/mv_94xx.c  |  672 +++++++++++++
 drivers/scsi/mvsas/mv_94xx.h  |  222 +++++
 drivers/scsi/mvsas/mv_chips.h |  212 ++++-
 drivers/scsi/mvsas/mv_defs.h  |  197 +++--
 drivers/scsi/mvsas/mv_init.c  |  639 ++++++++-----
 drivers/scsi/mvsas/mv_sas.c   | 2117 ++++++++++++++++++++++++-----------------
 drivers/scsi/mvsas/mv_sas.h   |  329 +++++--
 11 files changed, 3898 insertions(+), 1382 deletions(-)
 create mode 100644 drivers/scsi/mvsas/mv_94xx.c
 create mode 100644 drivers/scsi/mvsas/mv_94xx.h

diff --git a/drivers/scsi/mvsas/Kconfig b/drivers/scsi/mvsas/Kconfig
index f83f368..6de7af2 100644
--- a/drivers/scsi/mvsas/Kconfig
+++ b/drivers/scsi/mvsas/Kconfig
@@ -1,35 +1,42 @@
 #
-# Kernel configuration file for 88SE64XX SAS/SATA driver.
+# Kernel configuration file for 88SE64XX/88SE94XX SAS/SATA driver.
 #
 # Copyright 2007 Red Hat, Inc.
 # Copyright 2008 Marvell. <kewei@marvell.com>
 #
 # This file is licensed under GPLv2.
 #
-# This file is part of the 88SE64XX driver.
+# This file is part of the 88SE64XX/88SE94XX driver.
 #
-# The 88SE64XX driver is free software; you can redistribute
+# The 88SE64XX/88SE94XX driver is free software; you can redistribute
 # it and/or modify it under the terms of the GNU General Public License
 # as published by the Free Software Foundation; version 2 of the
 # License.
 #
-# The 88SE64XX driver is distributed in the hope that it will be
+# The 88SE64XX/88SE94XX driver is distributed in the hope that it will be
 # useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
-# along with 88SE64XX Driver; if not, write to the Free Software
+# along with 88SE64XX/88SE94XX Driver; if not, write to the Free Software
 # Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
 #
 
 config SCSI_MVSAS
-	tristate "Marvell 88SE64XX SAS/SATA support"
+	tristate "Marvell 88SE64XX/88SE94XX SAS/SATA support"
 	depends on PCI
 	select SCSI_SAS_LIBSAS
 	select FW_LOADER
 	help
-		This driver supports Marvell's SAS/SATA 3Gb/s PCI-E 88SE64XX
-		chip based host adapters.
+		This driver supports Marvell's SAS/SATA 3Gb/s PCI-E 88SE64XX and 6Gb/s
+		PCI-E 88SE94XX chip based host adapters.
 
+config SCSI_MVSAS_DEBUG
+	bool "Compile in debug mode"
+	default y
+	depends on SCSI_MVSAS
+	help
+		Compiles the 88SE64XX/88SE94XX driver in debug mode.  In debug mode,
+		the driver prints some messages to the console.
diff --git a/drivers/scsi/mvsas/Makefile b/drivers/scsi/mvsas/Makefile
index a1ca681..52ac426 100644
--- a/drivers/scsi/mvsas/Makefile
+++ b/drivers/scsi/mvsas/Makefile
@@ -1,5 +1,5 @@
 #
-# Makefile for Marvell 88SE64xx SAS/SATA driver.
+# Makefile for Marvell 88SE64xx/88SE84xx SAS/SATA driver.
 #
 # Copyright 2007 Red Hat, Inc.
 # Copyright 2008 Marvell. <kewei@marvell.com>
@@ -21,7 +21,12 @@
 # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 # USA
 
+ifeq ($(CONFIG_SCSI_MVSAS_DEBUG),y)
+	EXTRA_CFLAGS += -DMV_DEBUG
+endif
+
 obj-$(CONFIG_SCSI_MVSAS) += mvsas.o
 mvsas-y +=  mv_init.o  \
            mv_sas.o   \
-           mv_64xx.o
+           mv_64xx.o  \
+           mv_94xx.o
diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
index 697806c..10a5077 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -1,184 +1,793 @@
 /*
-	mv_64xx.c - Marvell 88SE6440 SAS/SATA support
-
-	Copyright 2007 Red Hat, Inc.
-	Copyright 2008 Marvell. <kewei@marvell.com>
-
-	This program is free software; you can redistribute it and/or
-	modify it under the terms of the GNU General Public License as
-	published by the Free Software Foundation; either version 2,
-	or (at your option) any later version.
-
-	This program is distributed in the hope that it will be useful,
-	but WITHOUT ANY WARRANTY; without even the implied warranty
-	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-	See the GNU General Public License for more details.
-
-	You should have received a copy of the GNU General Public
-	License along with this program; see the file COPYING.	If not,
-	write to the Free Software Foundation, 675 Mass Ave, Cambridge,
-	MA 02139, USA.
-
- */
+ * Marvell 88SE64xx hardware specific
+ *
+ * Copyright 2007 Red Hat, Inc.
+ * Copyright 2008 Marvell. <kewei@marvell.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 of the
+ * License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+*/
 
 #include "mv_sas.h"
 #include "mv_64xx.h"
 #include "mv_chips.h"
 
-void mvs_detect_porttype(struct mvs_info *mvi, int i)
+static void mvs_64xx_detect_porttype(struct mvs_info *mvi, int i)
 {
 	void __iomem *regs = mvi->regs;
 	u32 reg;
 	struct mvs_phy *phy = &mvi->phy[i];
 
 	/* TODO check & save device type */
-	reg = mr32(GBL_PORT_TYPE);
-
+	reg = mr32(MVS_GBL_PORT_TYPE);
+	phy->phy_type &= ~(PORT_TYPE_SAS | PORT_TYPE_SATA);
 	if (reg & MODE_SAS_SATA & (1 << i))
 		phy->phy_type |= PORT_TYPE_SAS;
 	else
 		phy->phy_type |= PORT_TYPE_SATA;
 }
 
-void mvs_enable_xmt(struct mvs_info *mvi, int PhyId)
+static void __devinit mvs_64xx_enable_xmt(struct mvs_info *mvi, int phy_id)
 {
 	void __iomem *regs = mvi->regs;
 	u32 tmp;
 
-	tmp = mr32(PCS);
+	tmp = mr32(MVS_PCS);
 	if (mvi->chip->n_phy <= 4)
-		tmp |= 1 << (PhyId + PCS_EN_PORT_XMT_SHIFT);
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
 	else
-		tmp |= 1 << (PhyId + PCS_EN_PORT_XMT_SHIFT2);
-	mw32(PCS, tmp);
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
 }
 
-void __devinit mvs_phy_hacks(struct mvs_info *mvi)
+static void mvs_64xx_phy_disable(struct mvs_info *mvi, u32 phy_id)
 {
 	void __iomem *regs = mvi->regs;
 	u32 tmp;
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
 
-	/* workaround for SATA R-ERR, to ignore phy glitch */
-	tmp = mvs_cr32(regs, CMD_PHY_TIMER);
-	tmp &= ~(1 << 9);
-	tmp |= (1 << 10);
-	mvs_cw32(regs, CMD_PHY_TIMER, tmp);
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
 
-	/* enable retry 127 times */
-	mvs_cw32(regs, CMD_SAS_CTL1, 0x7f7f);
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
 
-	/* extend open frame timeout to max */
-	tmp = mvs_cr32(regs, CMD_SAS_CTL0);
-	tmp &= ~0xffff;
-	tmp |= 0x3fff;
-	mvs_cw32(regs, CMD_SAS_CTL0, tmp);
+	/* reset control */
+	mw32(MVS_PCS, 0);		/* MVS_PCS */
+	/* init phys */
+	mvs_64xx_phy_hacks(mvi);
 
-	/* workaround for WDTIMEOUT , set to 550 ms */
-	mvs_cw32(regs, CMD_WD_TIMER, 0x86470);
+	/* enable auto port detection */
+	mw32(MVS_GBL_PORT_TYPE, MODE_AUTO_DET_EN);
 
-	/* not to halt for different port op during wideport link change */
-	mvs_cw32(regs, CMD_APP_ERR_CONFIG, 0xffefbf7d);
+	mw32(MVS_CMD_LIST_LO, mvi->slot_dma);
+	mw32(MVS_CMD_LIST_HI, (mvi->slot_dma >> 16) >> 16);
 
-	/* workaround for Seagate disk not-found OOB sequence, recv
-	 * COMINIT before sending out COMWAKE */
-	tmp = mvs_cr32(regs, CMD_PHY_MODE_21);
-	tmp &= 0x0000ffff;
-	tmp |= 0x00fa0000;
-	mvs_cw32(regs, CMD_PHY_MODE_21, tmp);
+	mw32(MVS_RX_FIS_LO, mvi->rx_fis_dma);
+	mw32(MVS_RX_FIS_HI, (mvi->rx_fis_dma >> 16) >> 16);
 
-	tmp = mvs_cr32(regs, CMD_PHY_TIMER);
-	tmp &= 0x1fffffff;
-	tmp |= (2U << 29);	/* 8 ms retry */
-	mvs_cw32(regs, CMD_PHY_TIMER, tmp);
+	mw32(MVS_TX_CFG, MVS_CHIP_SLOT_SZ);
+	mw32(MVS_TX_LO, mvi->tx_dma);
+	mw32(MVS_TX_HI, (mvi->tx_dma >> 16) >> 16);
 
-	/* TEST - for phy decoding error, adjust voltage levels */
-	mw32(P0_VSR_ADDR + 0, 0x8);
-	mw32(P0_VSR_DATA + 0, 0x2F0);
+	mw32(MVS_RX_CFG, MVS_RX_RING_SZ);
+	mw32(MVS_RX_LO, mvi->rx_dma);
+	mw32(MVS_RX_HI, (mvi->rx_dma >> 16) >> 16);
 
-	mw32(P0_VSR_ADDR + 8, 0x8);
-	mw32(P0_VSR_DATA + 8, 0x2F0);
+	for (i = 0; i < mvi->chip->n_phy; i++) {
+		/* set phy local SAS address */
+		/* should set little endian SAS address to 64xx chip */
+		mvs_set_sas_addr(mvi, i, PHYR_ADDR_LO, PHYR_ADDR_HI,
+				cpu_to_be64(mvi->phy[i].dev_sas_addr));
 
-	mw32(P0_VSR_ADDR + 16, 0x8);
-	mw32(P0_VSR_DATA + 16, 0x2F0);
+		mvs_64xx_enable_xmt(mvi, i);
 
-	mw32(P0_VSR_ADDR + 24, 0x8);
-	mw32(P0_VSR_DATA + 24, 0x2F0);
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
 }
 
-void mvs_hba_interrupt_enable(struct mvs_info *mvi)
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
 {
 	void __iomem *regs = mvi->regs;
 	u32 tmp;
 
-	tmp = mr32(GBL_CTL);
+	tmp = mr32(MVS_GBL_CTL);
+	mw32(MVS_GBL_CTL, tmp | INT_EN);
+}
 
-	mw32(GBL_CTL, tmp | INT_EN);
+static void mvs_64xx_interrupt_disable(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+	tmp = mr32(MVS_GBL_CTL);
+	mw32(MVS_GBL_CTL, tmp & ~INT_EN);
 }
 
-void mvs_hba_interrupt_disable(struct mvs_info *mvi)
+static u32 mvs_64xx_isr_status(struct mvs_info *mvi, int irq)
 {
 	void __iomem *regs = mvi->regs;
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
 	u32 tmp;
+	mvs_cw32(mvi, 0x40 + (slot_idx >> 3), 1 << (slot_idx % 32));
+	mvs_cw32(mvi, 0x00 + (slot_idx >> 3), 1 << (slot_idx % 32));
+	do {
+		tmp = mvs_cr32(mvi, 0x00 + (slot_idx >> 3));
+	} while (tmp & 1 << (slot_idx % 32));
+	do {
+		tmp = mvs_cr32(mvi, 0x40 + (slot_idx >> 3));
+	} while (tmp & 1 << (slot_idx % 32));
+}
 
-	tmp = mr32(GBL_CTL);
+static void mvs_64xx_issue_stop(struct mvs_info *mvi, enum mvs_port_type type,
+				u32 tfs)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
 
-	mw32(GBL_CTL, tmp & ~INT_EN);
+	if (type == PORT_TYPE_SATA) {
+		tmp = mr32(MVS_INT_STAT_SRS_0) | (1U << tfs);
+		mw32(MVS_INT_STAT_SRS_0, tmp);
+	}
+	mw32(MVS_INT_STAT, CINT_CI_STOP);
+	tmp = mr32(MVS_PCS) | 0xFF00;
+	mw32(MVS_PCS, tmp);
 }
 
-void mvs_free_reg_set(struct mvs_info *mvi, struct mvs_port *port)
+static void mvs_64xx_free_reg_set(struct mvs_info *mvi, u8 *tfs)
 {
 	void __iomem *regs = mvi->regs;
 	u32 tmp, offs;
-	u8 *tfs = &port->taskfileset;
 
 	if (*tfs == MVS_ID_NOT_MAPPED)
 		return;
 
 	offs = 1U << ((*tfs & 0x0f) + PCS_EN_SATA_REG_SHIFT);
 	if (*tfs < 16) {
-		tmp = mr32(PCS);
-		mw32(PCS, tmp & ~offs);
+		tmp = mr32(MVS_PCS);
+		mw32(MVS_PCS, tmp & ~offs);
 	} else {
-		tmp = mr32(CTL);
-		mw32(CTL, tmp & ~offs);
+		tmp = mr32(MVS_CTL);
+		mw32(MVS_CTL, tmp & ~offs);
 	}
 
-	tmp = mr32(INT_STAT_SRS) & (1U << *tfs);
+	tmp = mr32(MVS_INT_STAT_SRS_0) & (1U << *tfs);
 	if (tmp)
-		mw32(INT_STAT_SRS, tmp);
+		mw32(MVS_INT_STAT_SRS_0, tmp);
 
 	*tfs = MVS_ID_NOT_MAPPED;
+	return;
 }
 
-u8 mvs_assign_reg_set(struct mvs_info *mvi, struct mvs_port *port)
+static u8 mvs_64xx_assign_reg_set(struct mvs_info *mvi, u8 *tfs)
 {
 	int i;
 	u32 tmp, offs;
 	void __iomem *regs = mvi->regs;
 
-	if (port->taskfileset != MVS_ID_NOT_MAPPED)
+	if (*tfs != MVS_ID_NOT_MAPPED)
 		return 0;
 
-	tmp = mr32(PCS);
+	tmp = mr32(MVS_PCS);
 
 	for (i = 0; i < mvi->chip->srs_sz; i++) {
 		if (i == 16)
-			tmp = mr32(CTL);
+			tmp = mr32(MVS_CTL);
 		offs = 1U << ((i & 0x0f) + PCS_EN_SATA_REG_SHIFT);
 		if (!(tmp & offs)) {
-			port->taskfileset = i;
+			*tfs = i;
 
 			if (i < 16)
-				mw32(PCS, tmp | offs);
+				mw32(MVS_PCS, tmp | offs);
 			else
-				mw32(CTL, tmp | offs);
-			tmp = mr32(INT_STAT_SRS) & (1U << i);
+				mw32(MVS_CTL, tmp | offs);
+			tmp = mr32(MVS_INT_STAT_SRS_0) & (1U << i);
 			if (tmp)
-				mw32(INT_STAT_SRS, tmp);
+				mw32(MVS_INT_STAT_SRS_0, tmp);
 			return 0;
 		}
 	}
 	return MVS_ID_NOT_MAPPED;
 }
 
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
+			u32      *dwCmd,
+			u8       cmd,
+			u8       read,
+			u8       length,
+			u32      addr
+			)
+{
+	u32  dwTmp;
+
+	dwTmp = ((u32)cmd << 24) | ((u32)length << 19);
+	if (read)
+		dwTmp |= 1U<<23;
+
+	if (addr != MV_MAX_U32) {
+		dwTmp |= 1U<<22;
+		dwTmp |= (addr & 0x0003FFFF);
+	}
+
+	*dwCmd = dwTmp;
+	return 0;
+}
+
+
+int mvs_64xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
+{
+	void __iomem *regs = mvi->regs_ex;
+	int     retry;
+
+	for (retry = 0; retry < 1; retry++) {
+		iow32(SPI_CTRL_REG_64XX, SPI_CTRL_VENDOR_ENABLE);
+		iow32(SPI_CMD_REG_64XX, cmd);
+		iow32(SPI_CTRL_REG_64XX,
+			SPI_CTRL_VENDOR_ENABLE | SPI_CTRL_SPISTART);
+	}
+
+	return 0;
+}
+
+int mvs_64xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
+{
+	void __iomem *regs = mvi->regs_ex;
+	u32 i, dwTmp;
+
+	for (i = 0; i < timeout; i++) {
+		dwTmp = ior32(SPI_CTRL_REG_64XX);
+		if (!(dwTmp & SPI_CTRL_SPISTART))
+			return 0;
+		msleep(10);
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
index c9f399e..42e947d 100644
--- a/drivers/scsi/mvsas/mv_64xx.h
+++ b/drivers/scsi/mvsas/mv_64xx.h
@@ -1,11 +1,43 @@
+/*
+ * Marvell 88SE64xx hardware specific head file
+ *
+ * Copyright 2007 Red Hat, Inc.
+ * Copyright 2008 Marvell. <kewei@marvell.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 of the
+ * License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+*/
+
 #ifndef _MVS64XX_REG_H_
 #define _MVS64XX_REG_H_
 
+#include <linux/types.h>
+
+#define MAX_LINK_RATE		SAS_LINK_RATE_3_0_GBPS
+
 /* enhanced mode registers (BAR4) */
 enum hw_registers {
 	MVS_GBL_CTL		= 0x04,  /* global control */
 	MVS_GBL_INT_STAT	= 0x08,  /* global irq status */
 	MVS_GBL_PI		= 0x0C,  /* ports implemented bitmask */
+
+	MVS_PHY_CTL		= 0x40,  /* SOC PHY Control */
+	MVS_PORTS_IMP		= 0x9C,  /* SOC Port Implemented */
+
 	MVS_GBL_PORT_TYPE	= 0xa0,  /* port type */
 
 	MVS_CTL			= 0x100, /* SAS/SATA port configuration */
@@ -30,17 +62,19 @@ enum hw_registers {
 	MVS_INT_COAL_TMOUT	= 0x14C, /* Int coalescing timeout */
 	MVS_INT_STAT		= 0x150, /* Central int status */
 	MVS_INT_MASK		= 0x154, /* Central int enable */
-	MVS_INT_STAT_SRS	= 0x158, /* SATA register set status */
-	MVS_INT_MASK_SRS	= 0x15C,
+	MVS_INT_STAT_SRS_0	= 0x158, /* SATA register set status */
+	MVS_INT_MASK_SRS_0	= 0x15C,
 
 					 /* ports 1-3 follow after this */
 	MVS_P0_INT_STAT		= 0x160, /* port0 interrupt status */
 	MVS_P0_INT_MASK		= 0x164, /* port0 interrupt mask */
-	MVS_P4_INT_STAT		= 0x200, /* Port 4 interrupt status */
-	MVS_P4_INT_MASK		= 0x204, /* Port 4 interrupt enable mask */
+					 /* ports 5-7 follow after this */
+	MVS_P4_INT_STAT		= 0x200, /* Port4 interrupt status */
+	MVS_P4_INT_MASK		= 0x204, /* Port4 interrupt enable mask */
 
 					 /* ports 1-3 follow after this */
 	MVS_P0_SER_CTLSTAT	= 0x180, /* port0 serial control/status */
+					 /* ports 5-7 follow after this */
 	MVS_P4_SER_CTLSTAT	= 0x220, /* port4 serial control/status */
 
 	MVS_CMD_ADDR		= 0x1B8, /* Command register port (addr) */
@@ -49,20 +83,23 @@ enum hw_registers {
 					 /* ports 1-3 follow after this */
 	MVS_P0_CFG_ADDR		= 0x1C0, /* port0 phy register address */
 	MVS_P0_CFG_DATA		= 0x1C4, /* port0 phy register data */
-	MVS_P4_CFG_ADDR		= 0x230, /* Port 4 config address */
-	MVS_P4_CFG_DATA		= 0x234, /* Port 4 config data */
+					 /* ports 5-7 follow after this */
+	MVS_P4_CFG_ADDR		= 0x230, /* Port4 config address */
+	MVS_P4_CFG_DATA		= 0x234, /* Port4 config data */
 
 					 /* ports 1-3 follow after this */
 	MVS_P0_VSR_ADDR		= 0x1E0, /* port0 VSR address */
 	MVS_P0_VSR_DATA		= 0x1E4, /* port0 VSR data */
-	MVS_P4_VSR_ADDR		= 0x250, /* port 4 VSR addr */
-	MVS_P4_VSR_DATA		= 0x254, /* port 4 VSR data */
+					 /* ports 5-7 follow after this */
+	MVS_P4_VSR_ADDR		= 0x250, /* port4 VSR addr */
+	MVS_P4_VSR_DATA		= 0x254, /* port4 VSR data */
 };
 
 enum pci_cfg_registers {
 	PCR_PHY_CTL		= 0x40,
 	PCR_PHY_CTL2		= 0x90,
 	PCR_DEV_CTRL		= 0xE8,
+	PCR_LINK_STAT		= 0xF2,
 };
 
 /*  SAS/SATA Vendor Specific Port Registers */
@@ -83,10 +120,32 @@ enum sas_sata_vsp_regs {
 	VSR_PHY_VS1		= 0x0D, /* Vednor Specific 1 */
 };
 
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
 struct mvs_prd {
 	__le64			addr;		/* 64-bit buffer address */
 	__le32			reserved;
 	__le32			len;		/* 16-bit length */
 };
 
+#define SPI_CTRL_REG				0xc0
+#define SPI_CTRL_VENDOR_ENABLE		(1U<<29)
+#define SPI_CTRL_SPIRDY         		(1U<<22)
+#define SPI_CTRL_SPISTART			(1U<<20)
+
+#define SPI_CMD_REG		0xc4
+#define SPI_DATA_REG		0xc8
+
+#define SPI_CTRL_REG_64XX		0x10
+#define SPI_CMD_REG_64XX		0x14
+#define SPI_DATA_REG_64XX		0x18
+
 #endif
diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
new file mode 100644
index 0000000..0940fae
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -0,0 +1,672 @@
+/*
+ * Marvell 88SE94xx hardware specific
+ *
+ * Copyright 2007 Red Hat, Inc.
+ * Copyright 2008 Marvell. <kewei@marvell.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 of the
+ * License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+*/
+
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
+	switch (phy_status) {
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
+static void __devinit mvs_94xx_enable_xmt(struct mvs_info *mvi, int phy_id)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+	tmp = mr32(MVS_PCS);
+	tmp |= 1 << (phy_id + PCS_EN_PORT_XMT_SHIFT2);
+	mw32(MVS_PCS, tmp);
+}
+
+static void mvs_94xx_phy_reset(struct mvs_info *mvi, u32 phy_id, int hard)
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
+	} else {
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
+		mvs_set_sas_addr(mvi, i, CONFIG_ID_FRAME3, CONFIG_ID_FRAME4,
+						(mvi->phy[i].dev_sas_addr));
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
+			PHYEV_ID_DONE  | PHYEV_DCDR_ERR | PHYEV_CRC_ERR ;
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
+static irqreturn_t mvs_94xx_isr(struct mvs_info *mvi, int irq, u32 stat)
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
+static void mvs_94xx_issue_stop(struct mvs_info *mvi, enum mvs_port_type type,
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
+	if (reg_set < 32) {
+		w_reg_set_enable(reg_set, (u32)mvi->sata_reg_set);
+		tmp = mr32(MVS_INT_STAT_SRS_0) & (u32)mvi->sata_reg_set;
+		if (tmp)
+			mw32(MVS_INT_STAT_SRS_0, tmp);
+	} else {
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
+	} else if (i >= 0) {
+		mvi->sata_reg_set |= bit(i);
+		w_reg_set_enable(i, (u32)mvi->sata_reg_set);
+		*tfs = i;
+		return 0;
+	}
+	return MVS_ID_NOT_MAPPED;
+}
+
+static void mvs_94xx_make_prd(struct scatterlist *scatter, int nr, void *prd)
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
+static void mvs_94xx_get_dev_identify_frame(struct mvs_info *mvi, int port_id,
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
+static void mvs_94xx_get_att_identify_frame(struct mvs_info *mvi, int port_id,
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
+		mv_dprintk("94xx phy %d atta frame %d %x.\n",
+			port_id + mvi->id * mvi->chip->n_phy, i, id_frame[i]);
+	}
+	/* mvs_hexdump(28, (u8 *)id_frame, 0); */
+	memcpy(id, id_frame, 28);
+}
+
+static u32 mvs_94xx_make_dev_info(struct sas_identify_frame *id)
+{
+	u32 att_dev_info = 0;
+
+	att_dev_info |= id->dev_type;
+	if (id->stp_iport)
+		att_dev_info |= PORT_DEV_STP_INIT;
+	if (id->smp_iport)
+		att_dev_info |= PORT_DEV_SMP_INIT;
+	if (id->ssp_iport)
+		att_dev_info |= PORT_DEV_SSP_INIT;
+	if (id->stp_tport)
+		att_dev_info |= PORT_DEV_STP_TRGT;
+	if (id->smp_tport)
+		att_dev_info |= PORT_DEV_SMP_TRGT;
+	if (id->ssp_tport)
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
+	if (phy->phy_type & PORT_TYPE_SAS) {
+		mvs_94xx_get_att_identify_frame(mvi, i, id);
+		phy->att_dev_info = mvs_94xx_make_att_info(id);
+		phy->att_dev_sas_addr = *(u64 *)id->sas_addr;
+	} else {
+		phy->att_dev_info = PORT_DEV_STP_TRGT | 1;
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
+				u32      *dwCmd,
+				u8       cmd,
+				u8       read,
+				u8       length,
+				u32      addr
+				)
+{
+	void __iomem *regs = mvi->regs_ex - 0x10200;
+	u32  dwTmp;
+
+	dwTmp = ((u32)cmd << 8) | ((u32)length << 4);
+	if (read)
+		dwTmp |= SPI_CTRL_READ_94XX;
+
+	if (addr != MV_MAX_U32) {
+		mw32(SPI_ADDR_REG_94XX, (addr & 0x0003FFFFL));
+		dwTmp |= SPI_ADDR_VLD_94XX;
+	}
+
+	*dwCmd = dwTmp;
+	return 0;
+}
+
+
+int mvs_94xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
+{
+	void __iomem *regs = mvi->regs_ex - 0x10200;
+	mw32(SPI_CTRL_REG_94XX, cmd | SPI_CTRL_SpiStart_94XX);
+
+	return 0;
+}
+
+int mvs_94xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
+{
+	void __iomem *regs = mvi->regs_ex - 0x10200;
+	u32   i, dwTmp;
+
+	for (i = 0; i < timeout; i++) {
+		dwTmp = mr32(SPI_CTRL_REG_94XX);
+		if (!(dwTmp & SPI_CTRL_SpiStart_94XX))
+			return 0;
+		msleep(10);
+	}
+
+	return -1;
+}
+
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+void mvs_94xx_fix_dma(dma_addr_t buf_dma, int buf_len, int from, void *prd)
+{
+	int i;
+	struct mvs_prd *buf_prd = prd;
+	buf_prd += from;
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
index 0000000..23ed9b1
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_94xx.h
@@ -0,0 +1,222 @@
+/*
+ * Marvell 88SE94xx hardware specific head file
+ *
+ * Copyright 2007 Red Hat, Inc.
+ * Copyright 2008 Marvell. <kewei@marvell.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 of the
+ * License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+*/
+
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
+	/* 64-bit buffer address */
+	__le64			addr;
+	/* 22-bit length */
+	struct mvs_prd_imt	im_len;
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
+#define mv_ffc(x)   ffz(x)
+
+static inline int
+mv_ffc64(u64 v)
+{
+	int i;
+	i = mv_ffc((u32)v);
+	if (i >= 0)
+		return i;
+	i = mv_ffc((u32)(v>>32));
+
+	if (i != 0)
+		return 32 + i;
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
+extern const struct mvs_dispatch mvs_94xx_dispatch;
+#endif
+
diff --git a/drivers/scsi/mvsas/mv_chips.h b/drivers/scsi/mvsas/mv_chips.h
index cf74b7a..a67e1c4 100644
--- a/drivers/scsi/mvsas/mv_chips.h
+++ b/drivers/scsi/mvsas/mv_chips.h
@@ -1,46 +1,81 @@
+/*
+ * Marvell 88SE64xx/88SE94xx register IO interface
+ *
+ * Copyright 2007 Red Hat, Inc.
+ * Copyright 2008 Marvell. <kewei@marvell.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 of the
+ * License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+*/
+
+
 #ifndef _MV_CHIPS_H_
 #define _MV_CHIPS_H_
 
-#define mr32(reg)	readl(regs + MVS_##reg)
-#define mw32(reg,val)	writel((val), regs + MVS_##reg)
-#define mw32_f(reg,val)	do {			\
-	writel((val), regs + MVS_##reg);	\
-	readl(regs + MVS_##reg);		\
-	} while (0)
+#define mr32(reg)	readl(regs + reg)
+#define mw32(reg, val)	writel((val), regs + reg)
+#define mw32_f(reg, val)	do {			\
+				mw32(reg, val);	\
+				mr32(reg);	\
+			} while (0)
 
-static inline u32 mvs_cr32(void __iomem *regs, u32 addr)
+#define iow32(reg, val) 	outl(val, (unsigned long)(regs + reg))
+#define ior32(reg) 		inl((unsigned long)(regs + reg))
+#define iow16(reg, val) 	outw((unsigned long)(val, regs + reg))
+#define ior16(reg) 		inw((unsigned long)(regs + reg))
+#define iow8(reg, val) 		outb((unsigned long)(val, regs + reg))
+#define ior8(reg) 		inb((unsigned long)(regs + reg))
+
+static inline u32 mvs_cr32(struct mvs_info *mvi, u32 addr)
 {
-	mw32(CMD_ADDR, addr);
-	return mr32(CMD_DATA);
+	void __iomem *regs = mvi->regs;
+	mw32(MVS_CMD_ADDR, addr);
+	return mr32(MVS_CMD_DATA);
 }
 
-static inline void mvs_cw32(void __iomem *regs, u32 addr, u32 val)
+static inline void mvs_cw32(struct mvs_info *mvi, u32 addr, u32 val)
 {
-	mw32(CMD_ADDR, addr);
-	mw32(CMD_DATA, val);
+	void __iomem *regs = mvi->regs;
+	mw32(MVS_CMD_ADDR, addr);
+	mw32(MVS_CMD_DATA, val);
 }
 
 static inline u32 mvs_read_phy_ctl(struct mvs_info *mvi, u32 port)
 {
 	void __iomem *regs = mvi->regs;
-	return (port < 4)?mr32(P0_SER_CTLSTAT + port * 4):
-		mr32(P4_SER_CTLSTAT + (port - 4) * 4);
+	return (port < 4) ? mr32(MVS_P0_SER_CTLSTAT + port * 4) :
+		mr32(MVS_P4_SER_CTLSTAT + (port - 4) * 4);
 }
 
 static inline void mvs_write_phy_ctl(struct mvs_info *mvi, u32 port, u32 val)
 {
 	void __iomem *regs = mvi->regs;
 	if (port < 4)
-		mw32(P0_SER_CTLSTAT + port * 4, val);
+		mw32(MVS_P0_SER_CTLSTAT + port * 4, val);
 	else
-		mw32(P4_SER_CTLSTAT + (port - 4) * 4, val);
+		mw32(MVS_P4_SER_CTLSTAT + (port - 4) * 4, val);
 }
 
-static inline u32 mvs_read_port(struct mvs_info *mvi, u32 off, u32 off2, u32 port)
+static inline u32 mvs_read_port(struct mvs_info *mvi, u32 off,
+				u32 off2, u32 port)
 {
 	void __iomem *regs = mvi->regs + off;
 	void __iomem *regs2 = mvi->regs + off2;
-	return (port < 4)?readl(regs + port * 8):
+	return (port < 4) ? readl(regs + port * 8) :
 		readl(regs2 + (port - 4) * 8);
 }
 
@@ -61,16 +96,19 @@ static inline u32 mvs_read_port_cfg_data(struct mvs_info *mvi, u32 port)
 			MVS_P4_CFG_DATA, port);
 }
 
-static inline void mvs_write_port_cfg_data(struct mvs_info *mvi, u32 port, u32 val)
+static inline void mvs_write_port_cfg_data(struct mvs_info *mvi,
+						u32 port, u32 val)
 {
 	mvs_write_port(mvi, MVS_P0_CFG_DATA,
 			MVS_P4_CFG_DATA, port, val);
 }
 
-static inline void mvs_write_port_cfg_addr(struct mvs_info *mvi, u32 port, u32 addr)
+static inline void mvs_write_port_cfg_addr(struct mvs_info *mvi,
+						u32 port, u32 addr)
 {
 	mvs_write_port(mvi, MVS_P0_CFG_ADDR,
 			MVS_P4_CFG_ADDR, port, addr);
+	mdelay(10);
 }
 
 static inline u32 mvs_read_port_vsr_data(struct mvs_info *mvi, u32 port)
@@ -79,16 +117,19 @@ static inline u32 mvs_read_port_vsr_data(struct mvs_info *mvi, u32 port)
 			MVS_P4_VSR_DATA, port);
 }
 
-static inline void mvs_write_port_vsr_data(struct mvs_info *mvi, u32 port, u32 val)
+static inline void mvs_write_port_vsr_data(struct mvs_info *mvi,
+						u32 port, u32 val)
 {
 	mvs_write_port(mvi, MVS_P0_VSR_DATA,
 			MVS_P4_VSR_DATA, port, val);
 }
 
-static inline void mvs_write_port_vsr_addr(struct mvs_info *mvi, u32 port, u32 addr)
+static inline void mvs_write_port_vsr_addr(struct mvs_info *mvi,
+						u32 port, u32 addr)
 {
 	mvs_write_port(mvi, MVS_P0_VSR_ADDR,
 			MVS_P4_VSR_ADDR, port, addr);
+	mdelay(10);
 }
 
 static inline u32 mvs_read_port_irq_stat(struct mvs_info *mvi, u32 port)
@@ -97,7 +138,8 @@ static inline u32 mvs_read_port_irq_stat(struct mvs_info *mvi, u32 port)
 			MVS_P4_INT_STAT, port);
 }
 
-static inline void mvs_write_port_irq_stat(struct mvs_info *mvi, u32 port, u32 val)
+static inline void mvs_write_port_irq_stat(struct mvs_info *mvi,
+						u32 port, u32 val)
 {
 	mvs_write_port(mvi, MVS_P0_INT_STAT,
 			MVS_P4_INT_STAT, port, val);
@@ -107,12 +149,132 @@ static inline u32 mvs_read_port_irq_mask(struct mvs_info *mvi, u32 port)
 {
 	return mvs_read_port(mvi, MVS_P0_INT_MASK,
 			MVS_P4_INT_MASK, port);
+
 }
 
-static inline void mvs_write_port_irq_mask(struct mvs_info *mvi, u32 port, u32 val)
+static inline void mvs_write_port_irq_mask(struct mvs_info *mvi,
+						u32 port, u32 val)
 {
 	mvs_write_port(mvi, MVS_P0_INT_MASK,
 			MVS_P4_INT_MASK, port, val);
 }
 
-#endif
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
index d8e96a3..f8cb9de 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -1,53 +1,66 @@
 /*
-	mv_defs.h - Marvell 88SE6440 SAS/SATA support
-
-	Copyright 2007 Red Hat, Inc.
-	Copyright 2008 Marvell. <kewei@marvell.com>
-
-	This program is free software; you can redistribute it and/or
-	modify it under the terms of the GNU General Public License as
-	published by the Free Software Foundation; either version 2,
-	or (at your option) any later version.
-
-	This program is distributed in the hope that it will be useful,
-	but WITHOUT ANY WARRANTY; without even the implied warranty
-	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-	See the GNU General Public License for more details.
-
-	You should have received a copy of the GNU General Public
-	License along with this program; see the file COPYING.	If not,
-	write to the Free Software Foundation, 675 Mass Ave, Cambridge,
-	MA 02139, USA.
-
- */
+ * Marvell 88SE64xx/88SE94xx const head file
+ *
+ * Copyright 2007 Red Hat, Inc.
+ * Copyright 2008 Marvell. <kewei@marvell.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 of the
+ * License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+*/
 
 #ifndef _MV_DEFS_H_
 #define _MV_DEFS_H_
 
+
+enum chip_flavors {
+	chip_6320,
+	chip_6440,
+	chip_6485,
+	chip_9480,
+	chip_9180,
+};
+
 /* driver compile-time configuration */
 enum driver_configuration {
+	MVS_SLOTS		= 512,	/* command slots */
 	MVS_TX_RING_SZ		= 1024,	/* TX ring size (12-bit) */
 	MVS_RX_RING_SZ		= 1024, /* RX ring size (12-bit) */
 					/* software requires power-of-2
 					   ring size */
+	MVS_SOC_SLOTS		= 64,
+	MVS_SOC_TX_RING_SZ	= MVS_SOC_SLOTS * 2,
+	MVS_SOC_RX_RING_SZ	= MVS_SOC_SLOTS * 2,
 
-	MVS_SLOTS		= 512,	/* command slots */
 	MVS_SLOT_BUF_SZ		= 8192, /* cmd tbl + IU + status + PRD */
 	MVS_SSP_CMD_SZ		= 64,	/* SSP command table buffer size */
 	MVS_ATA_CMD_SZ		= 96,	/* SATA command table buffer size */
 	MVS_OAF_SZ		= 64,	/* Open address frame buffer size */
-
-	MVS_RX_FIS_COUNT	= 17,	/* Optional rx'd FISs (max 17) */
-
-	MVS_QUEUE_SIZE		= 30,	/* Support Queue depth */
-	MVS_CAN_QUEUE		= MVS_SLOTS - 1,	/* SCSI Queue depth */
+	MVS_QUEUE_SIZE	= 32,	/* Support Queue depth */
+	MVS_CAN_QUEUE		= MVS_SLOTS - 2,	/* SCSI Queue depth */
+	MVS_SOC_CAN_QUEUE	= MVS_SOC_SLOTS - 2,
 };
 
 /* unchangeable hardware details */
 enum hardware_details {
 	MVS_MAX_PHYS		= 8,	/* max. possible phys */
 	MVS_MAX_PORTS		= 8,	/* max. possible ports */
-	MVS_RX_FISL_SZ		= 0x400 + (MVS_RX_FIS_COUNT * 0x100),
+	MVS_SOC_PHYS		= 4,	/* soc phys */
+	MVS_SOC_PORTS		= 4,	/* soc phys */
+	MVS_MAX_DEVICES	= 1024,	/* max supported device */
 };
 
 /* peripheral registers (BAR2) */
@@ -133,6 +146,8 @@ enum hw_register_bits {
 	CINT_PORT		= (1U << 8),	/* port0 event */
 	CINT_PORT_MASK_OFFSET	= 8,
 	CINT_PORT_MASK		= (0xFF << CINT_PORT_MASK_OFFSET),
+	CINT_PHY_MASK_OFFSET	= 4,
+	CINT_PHY_MASK		= (0x0F << CINT_PHY_MASK_OFFSET),
 
 	/* TX (delivery) ring bits */
 	TXQ_CMD_SHIFT		= 29,
@@ -142,7 +157,11 @@ enum hw_register_bits {
 	TXQ_CMD_SSP_FREE_LIST	= 4,		/* add to SSP targ free list */
 	TXQ_CMD_SLOT_RESET	= 7,		/* reset command slot */
 	TXQ_MODE_I		= (1U << 28),	/* mode: 0=target,1=initiator */
+	TXQ_MODE_TARGET 	= 0,
+	TXQ_MODE_INITIATOR	= 1,
 	TXQ_PRIO_HI		= (1U << 27),	/* priority: 0=normal, 1=high */
+	TXQ_PRI_NORMAL		= 0,
+	TXQ_PRI_HIGH		= 1,
 	TXQ_SRS_SHIFT		= 20,		/* SATA register set */
 	TXQ_SRS_MASK		= 0x7f,
 	TXQ_PHY_SHIFT		= 12,		/* PHY bitmap */
@@ -175,6 +194,8 @@ enum hw_register_bits {
 	MCH_SSP_FR_READ		= 0x6,		/* Read DATA frame(s) */
 	MCH_SSP_FR_READ_RESP	= 0x7,		/* ditto, plus RESPONSE */
 
+	MCH_SSP_MODE_PASSTHRU	= 1,
+	MCH_SSP_MODE_NORMAL	= 0,
 	MCH_PASSTHRU		= (1U << 12),	/* pass-through (SSP) */
 	MCH_FBURST		= (1U << 11),	/* first burst (SSP) */
 	MCH_CHK_LEN		= (1U << 10),	/* chk xfer len (SSP) */
@@ -199,15 +220,12 @@ enum hw_register_bits {
 	PHY_BCAST_CHG		= (1U << 2),	/* broadcast(change) notif */
 	PHY_RST_HARD		= (1U << 1),	/* hard reset + phy reset */
 	PHY_RST			= (1U << 0),	/* phy reset */
-	PHY_MIN_SPP_PHYS_LINK_RATE_MASK = (0xF << 8),
-	PHY_MAX_SPP_PHYS_LINK_RATE_MASK = (0xF << 12),
-	PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET = (16),
-	PHY_NEG_SPP_PHYS_LINK_RATE_MASK =
-			(0xF << PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET),
 	PHY_READY_MASK		= (1U << 20),
 
 	/* MVS_Px_INT_STAT, MVS_Px_INT_MASK (per-phy events) */
 	PHYEV_DEC_ERR		= (1U << 24),	/* Phy Decoding Error */
+	PHYEV_DCDR_ERR		= (1U << 23),	/* STP Deocder Error */
+	PHYEV_CRC_ERR		= (1U << 22),	/* STP CRC Error */
 	PHYEV_UNASSOC_FIS	= (1U << 19),	/* unassociated FIS rx'd */
 	PHYEV_AN		= (1U << 18),	/* SATA async notification */
 	PHYEV_BIST_ACT		= (1U << 17),	/* BIST activate FIS */
@@ -229,9 +247,10 @@ enum hw_register_bits {
 	/* MVS_PCS */
 	PCS_EN_SATA_REG_SHIFT	= (16),		/* Enable SATA Register Set */
 	PCS_EN_PORT_XMT_SHIFT	= (12),		/* Enable Port Transmit */
-	PCS_EN_PORT_XMT_SHIFT2	= (8),		/* For 6480 */
+	PCS_EN_PORT_XMT_SHIFT2	= (8),		/* For 6485 */
 	PCS_SATA_RETRY		= (1U << 8),	/* retry ctl FIS on R_ERR */
 	PCS_RSP_RX_EN		= (1U << 7),	/* raw response rx */
+	PCS_SATA_RETRY_2	= (1U << 6),	/* For 9180 */
 	PCS_SELF_CLEAR		= (1U << 5),	/* self-clearing int mode */
 	PCS_FIS_RX_EN		= (1U << 4),	/* FIS rx enable */
 	PCS_CMD_STOP_ERR	= (1U << 3),	/* cmd stop-on-err enable */
@@ -246,6 +265,8 @@ enum hw_register_bits {
 	PORT_DEV_SMP_INIT	= (1U << 10),
 	PORT_DEV_STP_INIT	= (1U << 9),
 	PORT_PHY_ID_MASK	= (0xFFU << 24),
+	PORT_SSP_TRGT_MASK	= (0x1U << 19),
+	PORT_SSP_INIT_MASK	= (0x1U << 11),
 	PORT_DEV_TRGT_MASK	= (0x7U << 17),
 	PORT_DEV_INIT_MASK	= (0x7U << 9),
 	PORT_DEV_TYPE_MASK	= (0x7U << 0),
@@ -283,21 +304,30 @@ enum sas_sata_config_port_regs {
 	PHYR_ATT_ADDR_HI	= 0x14,	/* attached dev SAS addr (high) */
 	PHYR_SATA_CTL		= 0x18,	/* SATA control */
 	PHYR_PHY_STAT		= 0x1C,	/* PHY status */
-	PHYR_SATA_SIG0		= 0x20,	/*port SATA signature FIS(Byte 0-3) */
-	PHYR_SATA_SIG1		= 0x24,	/*port SATA signature FIS(Byte 4-7) */
-	PHYR_SATA_SIG2		= 0x28,	/*port SATA signature FIS(Byte 8-11) */
-	PHYR_SATA_SIG3		= 0x2c,	/*port SATA signature FIS(Byte 12-15) */
+	PHYR_SATA_SIG0	= 0x20,	/*port SATA signature FIS(Byte 0-3) */
+	PHYR_SATA_SIG1	= 0x24,	/*port SATA signature FIS(Byte 4-7) */
+	PHYR_SATA_SIG2	= 0x28,	/*port SATA signature FIS(Byte 8-11) */
+	PHYR_SATA_SIG3	= 0x2c,	/*port SATA signature FIS(Byte 12-15) */
 	PHYR_R_ERR_COUNT	= 0x30, /* port R_ERR count register */
 	PHYR_CRC_ERR_COUNT	= 0x34, /* port CRC error count register */
-	PHYR_WIDE_PORT		= 0x38,	/* wide port participating */
+	PHYR_WIDE_PORT	= 0x38,	/* wide port participating */
 	PHYR_CURRENT0		= 0x80,	/* current connection info 0 */
 	PHYR_CURRENT1		= 0x84,	/* current connection info 1 */
 	PHYR_CURRENT2		= 0x88,	/* current connection info 2 */
-};
-
-enum mvs_info_flags {
-	MVF_MSI			= (1U << 0),	/* MSI is enabled */
-	MVF_PHY_PWR_FIX		= (1U << 1),	/* bug workaround */
+	CONFIG_ID_FRAME0       = 0x100, /* Port device ID frame register 0 */
+	CONFIG_ID_FRAME1       = 0x104, /* Port device ID frame register 1 */
+	CONFIG_ID_FRAME2       = 0x108, /* Port device ID frame register 2 */
+	CONFIG_ID_FRAME3       = 0x10c, /* Port device ID frame register 3 */
+	CONFIG_ID_FRAME4       = 0x110, /* Port device ID frame register 4 */
+	CONFIG_ID_FRAME5       = 0x114, /* Port device ID frame register 5 */
+	CONFIG_ID_FRAME6       = 0x118, /* Port device ID frame register 6 */
+	CONFIG_ATT_ID_FRAME0   = 0x11c, /* attached ID frame register 0 */
+	CONFIG_ATT_ID_FRAME1   = 0x120, /* attached ID frame register 1 */
+	CONFIG_ATT_ID_FRAME2   = 0x124, /* attached ID frame register 2 */
+	CONFIG_ATT_ID_FRAME3   = 0x128, /* attached ID frame register 3 */
+	CONFIG_ATT_ID_FRAME4   = 0x12c, /* attached ID frame register 4 */
+	CONFIG_ATT_ID_FRAME5   = 0x130, /* attached ID frame register 5 */
+	CONFIG_ATT_ID_FRAME6   = 0x134, /* attached ID frame register 6 */
 };
 
 enum sas_cmd_port_registers {
@@ -305,11 +335,11 @@ enum sas_cmd_port_registers {
 	CMD_CMWK_OOB_DET	= 0x104, /* COMWAKE OOB detect register */
 	CMD_CMSAS_OOB_DET	= 0x108, /* COMSAS OOB detect register */
 	CMD_BRST_OOB_DET	= 0x10c, /* burst OOB detect register */
-	CMD_OOB_SPACE		= 0x110, /* OOB space control register */
-	CMD_OOB_BURST		= 0x114, /* OOB burst control register */
+	CMD_OOB_SPACE	= 0x110, /* OOB space control register */
+	CMD_OOB_BURST	= 0x114, /* OOB burst control register */
 	CMD_PHY_TIMER		= 0x118, /* PHY timer control register */
-	CMD_PHY_CONFIG0		= 0x11c, /* PHY config register 0 */
-	CMD_PHY_CONFIG1		= 0x120, /* PHY config register 1 */
+	CMD_PHY_CONFIG0	= 0x11c, /* PHY config register 0 */
+	CMD_PHY_CONFIG1	= 0x120, /* PHY config register 1 */
 	CMD_SAS_CTL0		= 0x124, /* SAS control register 0 */
 	CMD_SAS_CTL1		= 0x128, /* SAS control register 1 */
 	CMD_SAS_CTL2		= 0x12c, /* SAS control register 2 */
@@ -318,9 +348,9 @@ enum sas_cmd_port_registers {
 	CMD_PL_TIMER		= 0x138, /* PL timer register */
 	CMD_WD_TIMER		= 0x13c, /* WD timer register */
 	CMD_PORT_SEL_COUNT	= 0x140, /* port selector count register */
-	CMD_APP_MEM_CTL		= 0x144, /* Application Memory Control */
-	CMD_XOR_MEM_CTL		= 0x148, /* XOR Block Memory Control */
-	CMD_DMA_MEM_CTL		= 0x14c, /* DMA Block Memory Control */
+	CMD_APP_MEM_CTL	= 0x144, /* Application Memory Control */
+	CMD_XOR_MEM_CTL	= 0x148, /* XOR Block Memory Control */
+	CMD_DMA_MEM_CTL	= 0x14c, /* DMA Block Memory Control */
 	CMD_PORT_MEM_CTL0	= 0x150, /* Port Memory Control 0 */
 	CMD_PORT_MEM_CTL1	= 0x154, /* Port Memory Control 1 */
 	CMD_SATA_PORT_MEM_CTL0	= 0x158, /* SATA Port Memory Control 0 */
@@ -353,27 +383,25 @@ enum sas_cmd_port_registers {
 	CMD_PND_FIFO_CTL1	= 0x1C4, /* Pending FIFO Control 1 */
 };
 
-enum pci_cfg_register_bits {
-	PCTL_PWR_ON	= (0xFU << 24),
-	PCTL_OFF	= (0xFU << 12),
-	PRD_REQ_SIZE	= (0x4000),
-	PRD_REQ_MASK	= (0x00007000),
+enum mvs_info_flags {
+	MVF_MSI		= (1U << 0),	/* MSI is enabled */
+	MVF_PHY_PWR_FIX	= (1U << 1),	/* bug workaround */
+	MVF_FLAG_SOC		= (1U << 2),	/* SoC integrated controllers */
 };
 
-enum nvram_layout_offsets {
-	NVR_SIG		= 0x00,		/* 0xAA, 0x55 */
-	NVR_SAS_ADDR	= 0x02,		/* 8-byte SAS address */
+enum mvs_event_flags {
+	PHY_PLUG_EVENT	= (3U),
+	PHY_PLUG_IN		= (1U << 0),	/* phy plug in */
+	PHY_PLUG_OUT		= (1U << 1),	/* phy plug out */
 };
 
-enum chip_flavors {
-	chip_6320,
-	chip_6440,
-	chip_6480,
-};
-
-enum port_type {
-	PORT_TYPE_SAS	=  (1L << 1),
-	PORT_TYPE_SATA	=  (1L << 0),
+enum mvs_port_type {
+	PORT_TGT_MASK	=  (1U << 5),
+	PORT_INIT_PORT	=  (1U << 4),
+	PORT_TGT_PORT	=  (1U << 3),
+	PORT_INIT_TGT_PORT = (PORT_INIT_PORT | PORT_TGT_PORT),
+	PORT_TYPE_SAS	=  (1U << 1),
+	PORT_TYPE_SATA	=  (1U << 0),
 };
 
 /* Command Table Format */
@@ -438,4 +466,37 @@ enum error_info_rec_2 {
 	USR_BLK_NM	= (1U << 0),	/* User Block Number */
 };
 
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
 #endif
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 258a1a9..ac5a74f 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -1,38 +1,41 @@
 /*
-	mv_init.c - Marvell 88SE6440 SAS/SATA init support
+ * Marvell 88SE64xx/88SE94xx pci init
+ *
+ * Copyright 2007 Red Hat, Inc.
+ * Copyright 2008 Marvell. <kewei@marvell.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 of the
+ * License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+*/
 
-	Copyright 2007 Red Hat, Inc.
-	Copyright 2008 Marvell. <kewei@marvell.com>
-
-	This program is free software; you can redistribute it and/or
-	modify it under the terms of the GNU General Public License as
-	published by the Free Software Foundation; either version 2,
-	or (at your option) any later version.
-
-	This program is distributed in the hope that it will be useful,
-	but WITHOUT ANY WARRANTY; without even the implied warranty
-	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-	See the GNU General Public License for more details.
-
-	You should have received a copy of the GNU General Public
-	License along with this program; see the file COPYING.	If not,
-	write to the Free Software Foundation, 675 Mass Ave, Cambridge,
-	MA 02139, USA.
-
- */
 
 #include "mv_sas.h"
-#include "mv_64xx.h"
-#include "mv_chips.h"
 
 static struct scsi_transport_template *mvs_stt;
-
 static const struct mvs_chip_info mvs_chips[] = {
-	[chip_6320] =		{ 2, 16, 9  },
-	[chip_6440] =		{ 4, 16, 9  },
-	[chip_6480] =		{ 8, 32, 10 },
+	[chip_6320] =	{ 1, 2, 0x400, 17, 16,  9, &mvs_64xx_dispatch, },
+	[chip_6440] =	{ 1, 4, 0x400, 17, 16,  9, &mvs_64xx_dispatch, },
+	[chip_6485] =	{ 1, 8, 0x800, 33, 32, 10, &mvs_64xx_dispatch, },
+	[chip_9180] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
+	[chip_9480] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
 };
 
+#define SOC_SAS_NUM 2
+
 static struct scsi_host_template mvs_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -53,17 +56,29 @@ static struct scsi_host_template mvs_sht = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_device_reset_handler	= sas_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
-	.slave_alloc		= sas_slave_alloc,
+	.slave_alloc		= mvs_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 };
 
 static struct sas_domain_function_template mvs_transport_ops = {
-	.lldd_execute_task	= mvs_task_exec,
+	.lldd_dev_found 	= mvs_dev_found,
+	.lldd_dev_gone	= mvs_dev_gone,
+
+	.lldd_execute_task	= mvs_queue_command,
 	.lldd_control_phy	= mvs_phy_control,
-	.lldd_abort_task	= mvs_task_abort,
-	.lldd_port_formed	= mvs_port_formed,
+
+	.lldd_abort_task	= mvs_abort_task,
+	.lldd_abort_task_set    = mvs_abort_task_set,
+	.lldd_clear_aca         = mvs_clear_aca,
+       .lldd_clear_task_set    = mvs_clear_task_set,
 	.lldd_I_T_nexus_reset	= mvs_I_T_nexus_reset,
+	.lldd_lu_reset 		= mvs_lu_reset,
+	.lldd_query_task	= mvs_query_task,
+
+	.lldd_port_formed	= mvs_port_formed,
+	.lldd_port_deformed     = mvs_port_deformed,
+
 };
 
 static void __devinit mvs_phy_init(struct mvs_info *mvi, int phy_id)
@@ -71,6 +86,8 @@ static void __devinit mvs_phy_init(struct mvs_info *mvi, int phy_id)
 	struct mvs_phy *phy = &mvi->phy[phy_id];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 
+	phy->mvi = mvi;
+	init_timer(&phy->timer);
 	sas_phy->enabled = (phy_id < mvi->chip->n_phy) ? 1 : 0;
 	sas_phy->class = SAS;
 	sas_phy->iproto = SAS_PROTOCOL_ALL;
@@ -83,248 +100,283 @@ static void __devinit mvs_phy_init(struct mvs_info *mvi, int phy_id)
 	sas_phy->id = phy_id;
 	sas_phy->sas_addr = &mvi->sas_addr[0];
 	sas_phy->frame_rcvd = &phy->frame_rcvd[0];
-	sas_phy->ha = &mvi->sas;
+	sas_phy->ha = (struct sas_ha_struct *)mvi->shost->hostdata;
 	sas_phy->lldd_phy = phy;
 }
 
 static void mvs_free(struct mvs_info *mvi)
 {
 	int i;
+	struct mvs_wq *mwq;
+	int slot_nr;
 
 	if (!mvi)
 		return;
 
-	for (i = 0; i < MVS_SLOTS; i++) {
-		struct mvs_slot_info *slot = &mvi->slot_info[i];
+	if (mvi->flags & MVF_FLAG_SOC)
+		slot_nr = MVS_SOC_SLOTS;
+	else
+		slot_nr = MVS_SLOTS;
 
+	for (i = 0; i < mvi->tags_num; i++) {
+		struct mvs_slot_info *slot = &mvi->slot_info[i];
 		if (slot->buf)
-			dma_free_coherent(&mvi->pdev->dev, MVS_SLOT_BUF_SZ,
+			dma_free_coherent(mvi->dev, MVS_SLOT_BUF_SZ,
 					  slot->buf, slot->buf_dma);
 	}
 
 	if (mvi->tx)
-		dma_free_coherent(&mvi->pdev->dev,
+		dma_free_coherent(mvi->dev,
 				  sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ,
 				  mvi->tx, mvi->tx_dma);
 	if (mvi->rx_fis)
-		dma_free_coherent(&mvi->pdev->dev, MVS_RX_FISL_SZ,
+		dma_free_coherent(mvi->dev, MVS_RX_FISL_SZ,
 				  mvi->rx_fis, mvi->rx_fis_dma);
 	if (mvi->rx)
-		dma_free_coherent(&mvi->pdev->dev,
+		dma_free_coherent(mvi->dev,
 				  sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
 				  mvi->rx, mvi->rx_dma);
 	if (mvi->slot)
-		dma_free_coherent(&mvi->pdev->dev,
-				  sizeof(*mvi->slot) * MVS_SLOTS,
+		dma_free_coherent(mvi->dev,
+				  sizeof(*mvi->slot) * slot_nr,
 				  mvi->slot, mvi->slot_dma);
-#ifdef MVS_ENABLE_PERI
-	if (mvi->peri_regs)
-		iounmap(mvi->peri_regs);
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	if (mvi->bulk_buffer)
+		dma_free_coherent(mvi->dev, TRASH_BUCKET_SIZE,
+				  mvi->bulk_buffer, mvi->bulk_buffer_dma);
 #endif
-	if (mvi->regs)
-		iounmap(mvi->regs);
+
+	MVS_CHIP_DISP->chip_iounmap(mvi);
 	if (mvi->shost)
 		scsi_host_put(mvi->shost);
-	kfree(mvi->sas.sas_port);
-	kfree(mvi->sas.sas_phy);
+	list_for_each_entry(mwq, &mvi->wq_list, entry)
+		cancel_delayed_work(&mwq->work_q);
 	kfree(mvi);
 }
 
 #ifdef MVS_USE_TASKLET
-static void mvs_tasklet(unsigned long data)
+struct tasklet_struct	mv_tasklet;
+static void mvs_tasklet(unsigned long opaque)
 {
-	struct mvs_info *mvi = (struct mvs_info *) data;
 	unsigned long flags;
+	u32 stat;
+	u16 core_nr, i = 0;
 
-	spin_lock_irqsave(&mvi->lock, flags);
+	struct mvs_info *mvi;
+	struct sas_ha_struct *sha = (struct sas_ha_struct *)opaque;
+
+	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
+	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
+
+	if (unlikely(!mvi))
+		BUG_ON(1);
+
+	for (i = 0; i < core_nr; i++) {
+		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[i];
+		stat = MVS_CHIP_DISP->isr_status(mvi, mvi->irq);
+		if (stat)
+			MVS_CHIP_DISP->isr(mvi, mvi->irq, stat);
+	}
 
-#ifdef MVS_DISABLE_MSI
-	mvs_int_full(mvi);
-#else
-	mvs_int_rx(mvi, true);
-#endif
-	spin_unlock_irqrestore(&mvi->lock, flags);
 }
 #endif
 
 static irqreturn_t mvs_interrupt(int irq, void *opaque)
 {
-	struct mvs_info *mvi = opaque;
-	void __iomem *regs = mvi->regs;
+	u32 core_nr, i = 0;
 	u32 stat;
+	struct mvs_info *mvi;
+	struct sas_ha_struct *sha = opaque;
 
-	stat = mr32(GBL_INT_STAT);
+	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
+	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
 
-	if (stat == 0 || stat == 0xffffffff)
+	if (unlikely(!mvi))
 		return IRQ_NONE;
 
-	/* clear CMD_CMPLT ASAP */
-	mw32_f(INT_STAT, CINT_DONE);
-
-#ifndef MVS_USE_TASKLET
-	spin_lock(&mvi->lock);
-
-	mvs_int_full(mvi);
+	stat = MVS_CHIP_DISP->isr_status(mvi, irq);
+	if (!stat)
+		return IRQ_NONE;
 
-	spin_unlock(&mvi->lock);
+#ifdef MVS_USE_TASKLET
+	tasklet_schedule(&mv_tasklet);
 #else
-	tasklet_schedule(&mvi->tasklet);
+	for (i = 0; i < core_nr; i++) {
+		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[i];
+		MVS_CHIP_DISP->isr(mvi, irq, stat);
+	}
 #endif
 	return IRQ_HANDLED;
 }
 
-static struct mvs_info *__devinit mvs_alloc(struct pci_dev *pdev,
-					    const struct pci_device_id *ent)
+static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 {
-	struct mvs_info *mvi;
-	unsigned long res_start, res_len, res_flag;
-	struct asd_sas_phy **arr_phy;
-	struct asd_sas_port **arr_port;
-	const struct mvs_chip_info *chip = &mvs_chips[ent->driver_data];
-	int i;
+	int i, slot_nr;
 
-	/*
-	 * alloc and init our per-HBA mvs_info struct
-	 */
-
-	mvi = kzalloc(sizeof(*mvi), GFP_KERNEL);
-	if (!mvi)
-		return NULL;
+	if (mvi->flags & MVF_FLAG_SOC)
+		slot_nr = MVS_SOC_SLOTS;
+	else
+		slot_nr = MVS_SLOTS;
 
 	spin_lock_init(&mvi->lock);
-#ifdef MVS_USE_TASKLET
-	tasklet_init(&mvi->tasklet, mvs_tasklet, (unsigned long)mvi);
-#endif
-	mvi->pdev = pdev;
-	mvi->chip = chip;
-
-	if (pdev->device == 0x6440 && pdev->revision == 0)
-		mvi->flags |= MVF_PHY_PWR_FIX;
-
-	/*
-	 * alloc and init SCSI, SAS glue
-	 */
-
-	mvi->shost = scsi_host_alloc(&mvs_sht, sizeof(void *));
-	if (!mvi->shost)
-		goto err_out;
-
-	arr_phy = kcalloc(MVS_MAX_PHYS, sizeof(void *), GFP_KERNEL);
-	arr_port = kcalloc(MVS_MAX_PHYS, sizeof(void *), GFP_KERNEL);
-	if (!arr_phy || !arr_port)
-		goto err_out;
-
-	for (i = 0; i < MVS_MAX_PHYS; i++) {
+	for (i = 0; i < mvi->chip->n_phy; i++) {
 		mvs_phy_init(mvi, i);
-		arr_phy[i] = &mvi->phy[i].sas_phy;
-		arr_port[i] = &mvi->port[i].sas_port;
-		mvi->port[i].taskfileset = MVS_ID_NOT_MAPPED;
 		mvi->port[i].wide_port_phymap = 0;
 		mvi->port[i].port_attached = 0;
 		INIT_LIST_HEAD(&mvi->port[i].list);
 	}
-
-	SHOST_TO_SAS_HA(mvi->shost) = &mvi->sas;
-	mvi->shost->transportt = mvs_stt;
-	mvi->shost->max_id = 21;
-	mvi->shost->max_lun = ~0;
-	mvi->shost->max_channel = 0;
-	mvi->shost->max_cmd_len = 16;
-
-	mvi->sas.sas_ha_name = DRV_NAME;
-	mvi->sas.dev = &pdev->dev;
-	mvi->sas.lldd_module = THIS_MODULE;
-	mvi->sas.sas_addr = &mvi->sas_addr[0];
-	mvi->sas.sas_phy = arr_phy;
-	mvi->sas.sas_port = arr_port;
-	mvi->sas.num_phys = chip->n_phy;
-	mvi->sas.lldd_max_execute_num = 1;
-	mvi->sas.lldd_queue_size = MVS_QUEUE_SIZE;
-	mvi->shost->can_queue = MVS_CAN_QUEUE;
-	mvi->shost->cmd_per_lun = MVS_SLOTS / mvi->sas.num_phys;
-	mvi->sas.lldd_ha = mvi;
-	mvi->sas.core.shost = mvi->shost;
-
-	mvs_tag_init(mvi);
-
-	/*
-	 * ioremap main and peripheral registers
-	 */
-
-#ifdef MVS_ENABLE_PERI
-	res_start = pci_resource_start(pdev, 2);
-	res_len = pci_resource_len(pdev, 2);
-	if (!res_start || !res_len)
-		goto err_out;
-
-	mvi->peri_regs = ioremap_nocache(res_start, res_len);
-	if (!mvi->peri_regs)
-		goto err_out;
-#endif
-
-	res_start = pci_resource_start(pdev, 4);
-	res_len = pci_resource_len(pdev, 4);
-	if (!res_start || !res_len)
-		goto err_out;
-
-	res_flag = pci_resource_flags(pdev, 4);
-	if (res_flag & IORESOURCE_CACHEABLE)
-		mvi->regs = ioremap(res_start, res_len);
-	else
-		mvi->regs = ioremap_nocache(res_start, res_len);
-
-	if (!mvi->regs)
-		goto err_out;
+	for (i = 0; i < MVS_MAX_DEVICES; i++) {
+		mvi->devices[i].taskfileset = MVS_ID_NOT_MAPPED;
+		mvi->devices[i].dev_type = NO_DEVICE;
+		mvi->devices[i].device_id = i;
+		mvi->devices[i].dev_status = MVS_DEV_NORMAL;
+	}
 
 	/*
 	 * alloc and init our DMA areas
 	 */
-
-	mvi->tx = dma_alloc_coherent(&pdev->dev,
+	mvi->tx = dma_alloc_coherent(mvi->dev,
 				     sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ,
 				     &mvi->tx_dma, GFP_KERNEL);
 	if (!mvi->tx)
 		goto err_out;
 	memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ);
-
-	mvi->rx_fis = dma_alloc_coherent(&pdev->dev, MVS_RX_FISL_SZ,
+	mvi->rx_fis = dma_alloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
 					 &mvi->rx_fis_dma, GFP_KERNEL);
 	if (!mvi->rx_fis)
 		goto err_out;
 	memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
 
-	mvi->rx = dma_alloc_coherent(&pdev->dev,
+	mvi->rx = dma_alloc_coherent(mvi->dev,
 				     sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
 				     &mvi->rx_dma, GFP_KERNEL);
 	if (!mvi->rx)
 		goto err_out;
 	memset(mvi->rx, 0, sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1));
-
 	mvi->rx[0] = cpu_to_le32(0xfff);
 	mvi->rx_cons = 0xfff;
 
-	mvi->slot = dma_alloc_coherent(&pdev->dev,
-				       sizeof(*mvi->slot) * MVS_SLOTS,
+	mvi->slot = dma_alloc_coherent(mvi->dev,
+				       sizeof(*mvi->slot) * slot_nr,
 				       &mvi->slot_dma, GFP_KERNEL);
 	if (!mvi->slot)
 		goto err_out;
-	memset(mvi->slot, 0, sizeof(*mvi->slot) * MVS_SLOTS);
+	memset(mvi->slot, 0, sizeof(*mvi->slot) * slot_nr);
 
-	for (i = 0; i < MVS_SLOTS; i++) {
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	mvi->bulk_buffer = dma_alloc_coherent(mvi->dev,
+				       TRASH_BUCKET_SIZE,
+				       &mvi->bulk_buffer_dma, GFP_KERNEL);
+	if (!mvi->bulk_buffer)
+		goto err_out;
+#endif
+	for (i = 0; i < slot_nr; i++) {
 		struct mvs_slot_info *slot = &mvi->slot_info[i];
 
-		slot->buf = dma_alloc_coherent(&pdev->dev, MVS_SLOT_BUF_SZ,
+		slot->buf = dma_alloc_coherent(mvi->dev, MVS_SLOT_BUF_SZ,
 					       &slot->buf_dma, GFP_KERNEL);
-		if (!slot->buf)
+		if (!slot->buf) {
+			printk(KERN_DEBUG"failed to allocate slot->buf.\n");
 			goto err_out;
+		}
 		memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
+		++mvi->tags_num;
 	}
+	/* Initialize tags */
+	mvs_tag_init(mvi);
+	return 0;
+err_out:
+	return 1;
+}
+
 
-	/* finally, read NVRAM to get our SAS address */
-	if (mvs_nvram_read(mvi, NVR_SAS_ADDR, &mvi->sas_addr, 8))
+int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex)
+{
+	unsigned long res_start, res_len, res_flag, res_flag_ex = 0;
+	struct pci_dev *pdev = mvi->pdev;
+	if (bar_ex != -1) {
+		/*
+		 * ioremap main and peripheral registers
+		 */
+		res_start = pci_resource_start(pdev, bar_ex);
+		res_len = pci_resource_len(pdev, bar_ex);
+		if (!res_start || !res_len)
+			goto err_out;
+
+		res_flag_ex = pci_resource_flags(pdev, bar_ex);
+		if (res_flag_ex & IORESOURCE_MEM) {
+			if (res_flag_ex & IORESOURCE_CACHEABLE)
+				mvi->regs_ex = ioremap(res_start, res_len);
+			else
+				mvi->regs_ex = ioremap_nocache(res_start,
+						res_len);
+		} else
+			mvi->regs_ex = (void *)res_start;
+		if (!mvi->regs_ex)
+			goto err_out;
+	}
+
+	res_start = pci_resource_start(pdev, bar);
+	res_len = pci_resource_len(pdev, bar);
+	if (!res_start || !res_len)
+		goto err_out;
+
+	res_flag = pci_resource_flags(pdev, bar);
+	if (res_flag & IORESOURCE_CACHEABLE)
+		mvi->regs = ioremap(res_start, res_len);
+	else
+		mvi->regs = ioremap_nocache(res_start, res_len);
+
+	if (!mvi->regs) {
+		if (mvi->regs_ex && (res_flag_ex & IORESOURCE_MEM))
+			iounmap(mvi->regs_ex);
+		mvi->regs_ex = NULL;
 		goto err_out;
-	return mvi;
+	}
+
+	return 0;
+err_out:
+	return -1;
+}
+
+void mvs_iounmap(void __iomem *regs)
+{
+	iounmap(regs);
+}
+
+static struct mvs_info *__devinit mvs_pci_alloc(struct pci_dev *pdev,
+				const struct pci_device_id *ent,
+				struct Scsi_Host *shost, unsigned int id)
+{
+	struct mvs_info *mvi;
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+
+	mvi = kzalloc(sizeof(*mvi) + MVS_SLOTS * sizeof(struct mvs_slot_info),
+			GFP_KERNEL);
+	if (!mvi)
+		return NULL;
 
+	mvi->pdev = pdev;
+	mvi->dev = &pdev->dev;
+	mvi->chip_id = ent->driver_data;
+	mvi->chip = &mvs_chips[mvi->chip_id];
+	INIT_LIST_HEAD(&mvi->wq_list);
+	mvi->irq = pdev->irq;
+
+	((struct mvs_prv_info *)sha->lldd_ha)->mvi[id] = mvi;
+	((struct mvs_prv_info *)sha->lldd_ha)->n_phy = mvi->chip->n_phy;
+
+	mvi->id = id;
+	mvi->sas = sha;
+	mvi->shost = shost;
+#ifdef MVS_USE_TASKLET
+	tasklet_init(&mv_tasklet, mvs_tasklet, (unsigned long)sha);
+#endif
+
+	if (MVS_CHIP_DISP->chip_ioremap(mvi))
+		goto err_out;
+	if (!mvs_alloc(mvi, shost))
+		return mvi;
 err_out:
 	mvs_free(mvi);
 	return NULL;
@@ -335,10 +387,10 @@ static int pci_go_64(struct pci_dev *pdev)
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
@@ -346,13 +398,13 @@ static int pci_go_64(struct pci_dev *pdev)
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
@@ -363,16 +415,111 @@ static int pci_go_64(struct pci_dev *pdev)
 	return rc;
 }
 
+static int __devinit mvs_prep_sas_ha_init(struct Scsi_Host *shost,
+				const struct mvs_chip_info *chip_info)
+{
+	int phy_nr, port_nr; unsigned short core_nr;
+	struct asd_sas_phy **arr_phy;
+	struct asd_sas_port **arr_port;
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+
+	core_nr = chip_info->n_host;
+	phy_nr  = core_nr * chip_info->n_phy;
+	port_nr = phy_nr;
+
+	memset(sha, 0x00, sizeof(struct sas_ha_struct));
+	arr_phy  = kcalloc(phy_nr, sizeof(void *), GFP_KERNEL);
+	arr_port = kcalloc(port_nr, sizeof(void *), GFP_KERNEL);
+	if (!arr_phy || !arr_port)
+		goto exit_free;
+
+	sha->sas_phy = arr_phy;
+	sha->sas_port = arr_port;
+
+	sha->lldd_ha = kzalloc(sizeof(struct mvs_prv_info), GFP_KERNEL);
+	if (!sha->lldd_ha)
+		goto exit_free;
+
+	((struct mvs_prv_info *)sha->lldd_ha)->n_host = core_nr;
+
+	shost->transportt = mvs_stt;
+	shost->max_id = 128;
+	shost->max_lun = ~0;
+	shost->max_channel = 1;
+	shost->max_cmd_len = 16;
+
+	return 0;
+exit_free:
+	kfree(arr_phy);
+	kfree(arr_port);
+	return -1;
+
+}
+
+static void  __devinit mvs_post_sas_ha_init(struct Scsi_Host *shost,
+			const struct mvs_chip_info *chip_info)
+{
+	int can_queue, i = 0, j = 0;
+	struct mvs_info *mvi = NULL;
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	unsigned short nr_core = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
+
+	for (j = 0; j < nr_core; j++) {
+		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[j];
+		for (i = 0; i < chip_info->n_phy; i++) {
+			sha->sas_phy[j * chip_info->n_phy  + i] =
+				&mvi->phy[i].sas_phy;
+			sha->sas_port[j * chip_info->n_phy + i] =
+				&mvi->port[i].sas_port;
+		}
+	}
+
+	sha->sas_ha_name = DRV_NAME;
+	sha->dev = mvi->dev;
+	sha->lldd_module = THIS_MODULE;
+	sha->sas_addr = &mvi->sas_addr[0];
+
+	sha->num_phys = nr_core * chip_info->n_phy;
+
+	sha->lldd_max_execute_num = 1;
+
+	if (mvi->flags & MVF_FLAG_SOC)
+		can_queue = MVS_SOC_CAN_QUEUE;
+	else
+		can_queue = MVS_CAN_QUEUE;
+
+	sha->lldd_queue_size = can_queue;
+	shost->can_queue = can_queue;
+	mvi->shost->cmd_per_lun = MVS_SLOTS/sha->num_phys;
+	sha->core.shost = mvi->shost;
+}
+
+static void mvs_init_sas_add(struct mvs_info *mvi)
+{
+	u8 i;
+	for (i = 0; i < mvi->chip->n_phy; i++) {
+		mvi->phy[i].dev_sas_addr = 0x5005043011ab0000ULL;
+		mvi->phy[i].dev_sas_addr =
+			cpu_to_be64((u64)(*(u64 *)&mvi->phy[i].dev_sas_addr));
+	}
+
+	memcpy(mvi->sas_addr, &mvi->phy[0].dev_sas_addr, SAS_ADDR_SIZE);
+}
+
 static int __devinit mvs_pci_init(struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
 {
-	int rc;
+	unsigned int rc, nhost = 0;
 	struct mvs_info *mvi;
 	irq_handler_t irq_handler = mvs_interrupt;
+	struct Scsi_Host *shost = NULL;
+	const struct mvs_chip_info *chip;
 
+	dev_printk(KERN_INFO, &pdev->dev,
+		"mvsas: driver version %s\n", DRV_VERSION);
 	rc = pci_enable_device(pdev);
 	if (rc)
-		return rc;
+		goto err_out_enable;
 
 	pci_set_master(pdev);
 
@@ -384,84 +531,110 @@ static int __devinit mvs_pci_init(struct pci_dev *pdev,
 	if (rc)
 		goto err_out_regions;
 
-	mvi = mvs_alloc(pdev, ent);
-	if (!mvi) {
+	shost = scsi_host_alloc(&mvs_sht, sizeof(void *));
+	if (!shost) {
 		rc = -ENOMEM;
 		goto err_out_regions;
 	}
 
-	rc = mvs_hw_init(mvi);
-	if (rc)
-		goto err_out_mvi;
-
-#ifndef MVS_DISABLE_MSI
-	if (!pci_enable_msi(pdev)) {
-		u32 tmp;
-		void __iomem *regs = mvi->regs;
-		mvi->flags |= MVF_MSI;
-		irq_handler = mvs_msi_interrupt;
-		tmp = mr32(PCS);
-		mw32(PCS, tmp | PCS_SELF_CLEAR);
+	chip = &mvs_chips[ent->driver_data];
+	SHOST_TO_SAS_HA(shost) =
+		kcalloc(1, sizeof(struct sas_ha_struct), GFP_KERNEL);
+	if (!SHOST_TO_SAS_HA(shost)) {
+		kfree(shost);
+		rc = -ENOMEM;
+		goto err_out_regions;
 	}
-#endif
 
-	rc = request_irq(pdev->irq, irq_handler, IRQF_SHARED, DRV_NAME, mvi);
-	if (rc)
-		goto err_out_msi;
+	rc = mvs_prep_sas_ha_init(shost, chip);
+	if (rc) {
+		kfree(shost);
+		rc = -ENOMEM;
+		goto err_out_regions;
+	}
 
-	rc = scsi_add_host(mvi->shost, &pdev->dev);
-	if (rc)
-		goto err_out_irq;
+	pci_set_drvdata(pdev, SHOST_TO_SAS_HA(shost));
 
-	rc = sas_register_ha(&mvi->sas);
+	do {
+		mvi = mvs_pci_alloc(pdev, ent, shost, nhost);
+		if (!mvi) {
+			rc = -ENOMEM;
+			goto err_out_regions;
+		}
+
+		mvs_init_sas_add(mvi);
+
+		mvi->instance = nhost;
+		rc = MVS_CHIP_DISP->chip_init(mvi);
+		if (rc) {
+			mvs_free(mvi);
+			goto err_out_regions;
+		}
+		nhost++;
+	} while (nhost < chip->n_host);
+
+	mvs_post_sas_ha_init(shost, chip);
+
+	rc = scsi_add_host(shost, &pdev->dev);
 	if (rc)
 		goto err_out_shost;
 
-	pci_set_drvdata(pdev, mvi);
-
-	mvs_print_info(mvi);
+	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
+	if (rc)
+		goto err_out_shost;
+	rc = request_irq(pdev->irq, irq_handler, IRQF_SHARED,
+		DRV_NAME, SHOST_TO_SAS_HA(shost));
+	if (rc)
+		goto err_not_sas;
 
-	mvs_hba_interrupt_enable(mvi);
+	MVS_CHIP_DISP->interrupt_enable(mvi);
 
 	scsi_scan_host(mvi->shost);
 
 	return 0;
 
+err_not_sas:
+	sas_unregister_ha(SHOST_TO_SAS_HA(shost));
 err_out_shost:
 	scsi_remove_host(mvi->shost);
-err_out_irq:
-	free_irq(pdev->irq, mvi);
-err_out_msi:
-	if (mvi->flags |= MVF_MSI)
-		pci_disable_msi(pdev);
-err_out_mvi:
-	mvs_free(mvi);
 err_out_regions:
 	pci_release_regions(pdev);
 err_out_disable:
 	pci_disable_device(pdev);
+err_out_enable:
 	return rc;
 }
 
 static void __devexit mvs_pci_remove(struct pci_dev *pdev)
 {
-	struct mvs_info *mvi = pci_get_drvdata(pdev);
+	unsigned short core_nr, i = 0;
+	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
+	struct mvs_info *mvi = NULL;
 
-	pci_set_drvdata(pdev, NULL);
+	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
+	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
 
-	if (mvi) {
-		sas_unregister_ha(&mvi->sas);
-		mvs_hba_interrupt_disable(mvi);
-		sas_remove_host(mvi->shost);
-		scsi_remove_host(mvi->shost);
+#ifdef MVS_USE_TASKLET
+	tasklet_kill(&mv_tasklet);
+#endif
 
-		free_irq(pdev->irq, mvi);
-		if (mvi->flags & MVF_MSI)
-			pci_disable_msi(pdev);
+	pci_set_drvdata(pdev, NULL);
+	sas_unregister_ha(sha);
+	sas_remove_host(mvi->shost);
+	scsi_remove_host(mvi->shost);
+
+	MVS_CHIP_DISP->interrupt_disable(mvi);
+	free_irq(mvi->irq, sha);
+	for (i = 0; i < core_nr; i++) {
+		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[i];
 		mvs_free(mvi);
-		pci_release_regions(pdev);
 	}
+	kfree(sha->sas_phy);
+	kfree(sha->sas_port);
+	kfree(sha);
+	pci_release_regions(pdev);
 	pci_disable_device(pdev);
+	return;
 }
 
 static struct pci_device_id __devinitdata mvs_pci_table[] = {
@@ -474,10 +647,12 @@ static struct pci_device_id __devinitdata mvs_pci_table[] = {
 		.subdevice	= 0x6480,
 		.class		= 0,
 		.class_mask	= 0,
-		.driver_data	= chip_6480,
+		.driver_data	= chip_6485,
 	},
 	{ PCI_VDEVICE(MARVELL, 0x6440), chip_6440 },
-	{ PCI_VDEVICE(MARVELL, 0x6480), chip_6480 },
+	{ PCI_VDEVICE(MARVELL, 0x6485), chip_6485 },
+	{ PCI_VDEVICE(MARVELL, 0x9480), chip_9480 },
+	{ PCI_VDEVICE(MARVELL, 0x9180), chip_9180 },
 
 	{ }	/* terminate list */
 };
@@ -489,15 +664,17 @@ static struct pci_driver mvs_pci_driver = {
 	.remove		= __devexit_p(mvs_pci_remove),
 };
 
+/* task handler */
+struct task_struct *mvs_th;
 static int __init mvs_init(void)
 {
 	int rc;
-
 	mvs_stt = sas_domain_attach_transport(&mvs_transport_ops);
 	if (!mvs_stt)
 		return -ENOMEM;
 
 	rc = pci_register_driver(&mvs_pci_driver);
+
 	if (rc)
 		goto err_out;
 
@@ -521,4 +698,6 @@ MODULE_AUTHOR("Jeff Garzik <jgarzik@pobox.com>");
 MODULE_DESCRIPTION("Marvell 88SE6440 SAS/SATA controller driver");
 MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
+#ifdef CONFIG_PCI
 MODULE_DEVICE_TABLE(pci, mvs_pci_table);
+#endif
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 6a583c1..d79ac17 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1,97 +1,65 @@
 /*
-	mv_sas.c - Marvell 88SE6440 SAS/SATA support
-
-	Copyright 2007 Red Hat, Inc.
-	Copyright 2008 Marvell. <kewei@marvell.com>
-
-	This program is free software; you can redistribute it and/or
-	modify it under the terms of the GNU General Public License as
-	published by the Free Software Foundation; either version 2,
-	or (at your option) any later version.
-
-	This program is distributed in the hope that it will be useful,
-	but WITHOUT ANY WARRANTY; without even the implied warranty
-	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-	See the GNU General Public License for more details.
-
-	You should have received a copy of the GNU General Public
-	License along with this program; see the file COPYING.	If not,
-	write to the Free Software Foundation, 675 Mass Ave, Cambridge,
-	MA 02139, USA.
-
-	---------------------------------------------------------------
-
-	Random notes:
-	* hardware supports controlling the endian-ness of data
-	  structures.  this permits elimination of all the le32_to_cpu()
-	  and cpu_to_le32() conversions.
-
- */
+ * Marvell 88SE64xx/88SE94xx main function
+ *
+ * Copyright 2007 Red Hat, Inc.
+ * Copyright 2008 Marvell. <kewei@marvell.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 of the
+ * License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+*/
 
 #include "mv_sas.h"
-#include "mv_64xx.h"
-#include "mv_chips.h"
-
-/* offset for D2H FIS in the Received FIS List Structure */
-#define SATA_RECEIVED_D2H_FIS(reg_set)	\
-	((void *) mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x40)
-#define SATA_RECEIVED_PIO_FIS(reg_set)	\
-	((void *) mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x20)
-#define UNASSOC_D2H_FIS(id)		\
-	((void *) mvi->rx_fis + 0x100 * id)
-
-struct mvs_task_exec_info {
-	struct sas_task *task;
-	struct mvs_cmd_hdr *hdr;
-	struct mvs_port *port;
-	u32 tag;
-	int n_elem;
-};
-
-static void mvs_release_task(struct mvs_info *mvi, int phy_no);
-static u32 mvs_is_phy_ready(struct mvs_info *mvi, int i);
-static void mvs_update_phyinfo(struct mvs_info *mvi, int i,
-					int get_st);
-static int mvs_int_rx(struct mvs_info *mvi, bool self_clear);
-static void mvs_slot_reset(struct mvs_info *mvi, struct sas_task *task,
-				u32 slot_idx);
 
 static int mvs_find_tag(struct mvs_info *mvi, struct sas_task *task, u32 *tag)
 {
 	if (task->lldd_task) {
 		struct mvs_slot_info *slot;
 		slot = (struct mvs_slot_info *) task->lldd_task;
-		*tag = slot - mvi->slot_info;
+		*tag = slot->slot_tag;
 		return 1;
 	}
 	return 0;
 }
 
-static void mvs_tag_clear(struct mvs_info *mvi, u32 tag)
+void mvs_tag_clear(struct mvs_info *mvi, u32 tag)
 {
 	void *bitmap = (void *) &mvi->tags;
 	clear_bit(tag, bitmap);
 }
 
-static void mvs_tag_free(struct mvs_info *mvi, u32 tag)
+void mvs_tag_free(struct mvs_info *mvi, u32 tag)
 {
 	mvs_tag_clear(mvi, tag);
 }
 
-static void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
+void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
 {
 	void *bitmap = (void *) &mvi->tags;
 	set_bit(tag, bitmap);
 }
 
-static int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
+inline int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
 {
 	unsigned int index, tag;
 	void *bitmap = (void *) &mvi->tags;
 
-	index = find_first_zero_bit(bitmap, MVS_SLOTS);
+	index = find_first_zero_bit(bitmap, mvi->tags_num);
 	tag = index;
-	if (tag >= MVS_SLOTS)
+	if (tag >= mvi->tags_num)
 		return -SAS_QUEUE_FULL;
 	mvs_tag_set(mvi, tag);
 	*tag_out = tag;
@@ -101,11 +69,11 @@ static int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
 void mvs_tag_init(struct mvs_info *mvi)
 {
 	int i;
-	for (i = 0; i < MVS_SLOTS; ++i)
+	for (i = 0; i < mvi->tags_num; ++i)
 		mvs_tag_clear(mvi, i);
 }
 
-static void mvs_hexdump(u32 size, u8 *data, u32 baseaddr)
+void mvs_hexdump(u32 size, u8 *data, u32 baseaddr)
 {
 	u32 i;
 	u32 run;
@@ -113,7 +81,7 @@ static void mvs_hexdump(u32 size, u8 *data, u32 baseaddr)
 
 	offset = 0;
 	while (size) {
-		printk("%08X : ", baseaddr + offset);
+		printk(KERN_DEBUG"%08X : ", baseaddr + offset);
 		if (size >= 16)
 			run = 16;
 		else
@@ -121,31 +89,31 @@ static void mvs_hexdump(u32 size, u8 *data, u32 baseaddr)
 		size -= run;
 		for (i = 0; i < 16; i++) {
 			if (i < run)
-				printk("%02X ", (u32)data[i]);
+				printk(KERN_DEBUG"%02X ", (u32)data[i]);
 			else
-				printk("   ");
+				printk(KERN_DEBUG"   ");
 		}
-		printk(": ");
+		printk(KERN_DEBUG": ");
 		for (i = 0; i < run; i++)
-			printk("%c", isalnum(data[i]) ? data[i] : '.');
-		printk("\n");
+			printk(KERN_DEBUG"%c",
+				isalnum(data[i]) ? data[i] : '.');
+		printk(KERN_DEBUG"\n");
 		data = &data[16];
 		offset += run;
 	}
-	printk("\n");
+	printk(KERN_DEBUG"\n");
 }
 
-#if _MV_DUMP
+#if (_MV_DUMP > 1)
 static void mvs_hba_sb_dump(struct mvs_info *mvi, u32 tag,
 				   enum sas_protocol proto)
 {
 	u32 offset;
-	struct pci_dev *pdev = mvi->pdev;
 	struct mvs_slot_info *slot = &mvi->slot_info[tag];
 
 	offset = slot->cmd_size + MVS_OAF_SZ +
-	    sizeof(struct mvs_prd) * slot->n_elem;
-	dev_printk(KERN_DEBUG, &pdev->dev, "+---->Status buffer[%d] :\n",
+	    MVS_CHIP_DISP->prd_size() * slot->n_elem;
+	dev_printk(KERN_DEBUG, mvi->dev, "+---->Status buffer[%d] :\n",
 			tag);
 	mvs_hexdump(32, (u8 *) slot->response,
 		    (u32) slot->buf_dma + offset);
@@ -155,47 +123,45 @@ static void mvs_hba_sb_dump(struct mvs_info *mvi, u32 tag,
 static void mvs_hba_memory_dump(struct mvs_info *mvi, u32 tag,
 				enum sas_protocol proto)
 {
-#if _MV_DUMP
+#if (_MV_DUMP > 1)
 	u32 sz, w_ptr;
 	u64 addr;
-	void __iomem *regs = mvi->regs;
-	struct pci_dev *pdev = mvi->pdev;
 	struct mvs_slot_info *slot = &mvi->slot_info[tag];
 
 	/*Delivery Queue */
-	sz = mr32(TX_CFG) & TX_RING_SZ_MASK;
+	sz = MVS_CHIP_SLOT_SZ;
 	w_ptr = slot->tx;
-	addr = mr32(TX_HI) << 16 << 16 | mr32(TX_LO);
-	dev_printk(KERN_DEBUG, &pdev->dev,
+	addr = mvi->tx_dma;
+	dev_printk(KERN_DEBUG, mvi->dev,
 		"Delivery Queue Size=%04d , WRT_PTR=%04X\n", sz, w_ptr);
-	dev_printk(KERN_DEBUG, &pdev->dev,
+	dev_printk(KERN_DEBUG, mvi->dev,
 		"Delivery Queue Base Address=0x%llX (PA)"
 		"(tx_dma=0x%llX), Entry=%04d\n",
-		addr, mvi->tx_dma, w_ptr);
+		addr, (unsigned long long)mvi->tx_dma, w_ptr);
 	mvs_hexdump(sizeof(u32), (u8 *)(&mvi->tx[mvi->tx_prod]),
 			(u32) mvi->tx_dma + sizeof(u32) * w_ptr);
 	/*Command List */
 	addr = mvi->slot_dma;
-	dev_printk(KERN_DEBUG, &pdev->dev,
+	dev_printk(KERN_DEBUG, mvi->dev,
 		"Command List Base Address=0x%llX (PA)"
 		"(slot_dma=0x%llX), Header=%03d\n",
-		addr, slot->buf_dma, tag);
-	dev_printk(KERN_DEBUG, &pdev->dev, "Command Header[%03d]:\n", tag);
+		addr, (unsigned long long)slot->buf_dma, tag);
+	dev_printk(KERN_DEBUG, mvi->dev, "Command Header[%03d]:\n", tag);
 	/*mvs_cmd_hdr */
 	mvs_hexdump(sizeof(struct mvs_cmd_hdr), (u8 *)(&mvi->slot[tag]),
 		(u32) mvi->slot_dma + tag * sizeof(struct mvs_cmd_hdr));
 	/*1.command table area */
-	dev_printk(KERN_DEBUG, &pdev->dev, "+---->Command Table :\n");
+	dev_printk(KERN_DEBUG, mvi->dev, "+---->Command Table :\n");
 	mvs_hexdump(slot->cmd_size, (u8 *) slot->buf, (u32) slot->buf_dma);
 	/*2.open address frame area */
-	dev_printk(KERN_DEBUG, &pdev->dev, "+---->Open Address Frame :\n");
+	dev_printk(KERN_DEBUG, mvi->dev, "+---->Open Address Frame :\n");
 	mvs_hexdump(MVS_OAF_SZ, (u8 *) slot->buf + slot->cmd_size,
 				(u32) slot->buf_dma + slot->cmd_size);
 	/*3.status buffer */
 	mvs_hba_sb_dump(mvi, tag, proto);
 	/*4.PRD table */
-	dev_printk(KERN_DEBUG, &pdev->dev, "+---->PRD table :\n");
-	mvs_hexdump(sizeof(struct mvs_prd) * slot->n_elem,
+	dev_printk(KERN_DEBUG, mvi->dev, "+---->PRD table :\n");
+	mvs_hexdump(MVS_CHIP_DISP->prd_size() * slot->n_elem,
 		(u8 *) slot->buf + slot->cmd_size + MVS_OAF_SZ,
 		(u32) slot->buf_dma + slot->cmd_size + MVS_OAF_SZ);
 #endif
@@ -206,15 +172,14 @@ static void mvs_hba_cq_dump(struct mvs_info *mvi)
 #if (_MV_DUMP > 2)
 	u64 addr;
 	void __iomem *regs = mvi->regs;
-	struct pci_dev *pdev = mvi->pdev;
 	u32 entry = mvi->rx_cons + 1;
 	u32 rx_desc = le32_to_cpu(mvi->rx[entry]);
 
 	/*Completion Queue */
 	addr = mr32(RX_HI) << 16 << 16 | mr32(RX_LO);
-	dev_printk(KERN_DEBUG, &pdev->dev, "Completion Task = 0x%p\n",
+	dev_printk(KERN_DEBUG, mvi->dev, "Completion Task = 0x%p\n",
 		   mvi->slot_info[rx_desc & RXQ_SLOT_MASK].task);
-	dev_printk(KERN_DEBUG, &pdev->dev,
+	dev_printk(KERN_DEBUG, mvi->dev,
 		"Completion List Base Address=0x%llX (PA), "
 		"CQ_Entry=%04d, CQ_WP=0x%08X\n",
 		addr, entry - 1, mvi->rx[0]);
@@ -223,62 +188,174 @@ static void mvs_hba_cq_dump(struct mvs_info *mvi)
 #endif
 }
 
-/* FIXME: locking? */
-int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func, void *funcdata)
+void mvs_get_sas_addr(void *buf, u32 buflen)
 {
-	struct mvs_info *mvi = sas_phy->ha->lldd_ha;
-	int rc = 0, phy_id = sas_phy->id;
-	u32 tmp;
+	/*memcpy(buf, "\x50\x05\x04\x30\x11\xab\x64\x40", 8);*/
+}
 
-	tmp = mvs_read_phy_ctl(mvi, phy_id);
+struct mvs_info *mvs_find_dev_mvi(struct domain_device *dev)
+{
+	unsigned long i = 0, j = 0, hi = 0;
+	struct sas_ha_struct *sha = dev->port->ha;
+	struct mvs_info *mvi = NULL;
+	struct asd_sas_phy *phy;
+
+	while (sha->sas_port[i]) {
+		if (sha->sas_port[i] == dev->port) {
+			phy =  container_of(sha->sas_port[i]->phy_list.next,
+				struct asd_sas_phy, port_phy_el);
+			j = 0;
+			while (sha->sas_phy[j]) {
+				if (sha->sas_phy[j] == phy)
+					break;
+				j++;
+			}
+			break;
+		}
+		i++;
+	}
+	hi = j/((struct mvs_prv_info *)sha->lldd_ha)->n_phy;
+	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[hi];
 
-	switch (func) {
-	case PHY_FUNC_SET_LINK_RATE:{
-			struct sas_phy_linkrates *rates = funcdata;
-			u32 lrmin = 0, lrmax = 0;
+	return mvi;
 
-			lrmin = (rates->minimum_linkrate << 8);
-			lrmax = (rates->maximum_linkrate << 12);
+}
 
-			if (lrmin) {
-				tmp &= ~(0xf << 8);
-				tmp |= lrmin;
-			}
-			if (lrmax) {
-				tmp &= ~(0xf << 12);
-				tmp |= lrmax;
+/* FIXME */
+int mvs_find_dev_phyno(struct domain_device *dev, int *phyno)
+{
+	unsigned long i = 0, j = 0, n = 0, num = 0;
+	struct mvs_info *mvi = mvs_find_dev_mvi(dev);
+	struct sas_ha_struct *sha = dev->port->ha;
+
+	while (sha->sas_port[i]) {
+		if (sha->sas_port[i] == dev->port) {
+			struct asd_sas_phy *phy;
+			list_for_each_entry(phy,
+				&sha->sas_port[i]->phy_list, port_phy_el) {
+				j = 0;
+				while (sha->sas_phy[j]) {
+					if (sha->sas_phy[j] == phy)
+						break;
+					j++;
+				}
+				phyno[n] = (j >= mvi->chip->n_phy) ?
+					(j - mvi->chip->n_phy) : j;
+				num++;
+				n++;
 			}
-			mvs_write_phy_ctl(mvi, phy_id, tmp);
 			break;
 		}
+		i++;
+	}
+	return num;
+}
+
+static inline void mvs_free_reg_set(struct mvs_info *mvi,
+				struct mvs_device *dev)
+{
+	if (!dev) {
+		mv_printk("device has been free.\n");
+		return;
+	}
+	if (dev->runing_req != 0)
+		return;
+	if (dev->taskfileset == MVS_ID_NOT_MAPPED)
+		return;
+	MVS_CHIP_DISP->free_reg_set(mvi, &dev->taskfileset);
+}
+
+static inline u8 mvs_assign_reg_set(struct mvs_info *mvi,
+				struct mvs_device *dev)
+{
+	if (dev->taskfileset != MVS_ID_NOT_MAPPED)
+		return 0;
+	return MVS_CHIP_DISP->assign_reg_set(mvi, &dev->taskfileset);
+}
+
+void mvs_phys_reset(struct mvs_info *mvi, u32 phy_mask, int hard)
+{
+	u32 no;
+	for_each_phy(phy_mask, phy_mask, no) {
+		if (!(phy_mask & 1))
+			continue;
+		MVS_CHIP_DISP->phy_reset(mvi, no, hard);
+	}
+}
+
+/* FIXME: locking? */
+int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
+			void *funcdata)
+{
+	int rc = 0, phy_id = sas_phy->id;
+	u32 tmp, i = 0, hi;
+	struct sas_ha_struct *sha = sas_phy->ha;
+	struct mvs_info *mvi = NULL;
+
+	while (sha->sas_phy[i]) {
+		if (sha->sas_phy[i] == sas_phy)
+			break;
+		i++;
+	}
+	hi = i/((struct mvs_prv_info *)sha->lldd_ha)->n_phy;
+	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[hi];
+
+	switch (func) {
+	case PHY_FUNC_SET_LINK_RATE:
+		MVS_CHIP_DISP->phy_set_link_rate(mvi, phy_id, funcdata);
+		break;
 
 	case PHY_FUNC_HARD_RESET:
+		tmp = MVS_CHIP_DISP->read_phy_ctl(mvi, phy_id);
 		if (tmp & PHY_RST_HARD)
 			break;
-		mvs_write_phy_ctl(mvi, phy_id, tmp | PHY_RST_HARD);
+		MVS_CHIP_DISP->phy_reset(mvi, phy_id, 1);
 		break;
 
 	case PHY_FUNC_LINK_RESET:
-		mvs_write_phy_ctl(mvi, phy_id, tmp | PHY_RST);
+		MVS_CHIP_DISP->phy_enable(mvi, phy_id);
+		MVS_CHIP_DISP->phy_reset(mvi, phy_id, 0);
 		break;
 
 	case PHY_FUNC_DISABLE:
+		MVS_CHIP_DISP->phy_disable(mvi, phy_id);
+		break;
 	case PHY_FUNC_RELEASE_SPINUP_HOLD:
 	default:
 		rc = -EOPNOTSUPP;
 	}
-
+	msleep(200);
 	return rc;
 }
 
+void __devinit mvs_set_sas_addr(struct mvs_info *mvi, int port_id,
+				u32 off_lo, u32 off_hi, u64 sas_addr)
+{
+	u32 lo = (u32)sas_addr;
+	u32 hi = (u32)(sas_addr>>32);
+
+	MVS_CHIP_DISP->write_port_cfg_addr(mvi, port_id, off_lo);
+	MVS_CHIP_DISP->write_port_cfg_data(mvi, port_id, lo);
+	MVS_CHIP_DISP->write_port_cfg_addr(mvi, port_id, off_hi);
+	MVS_CHIP_DISP->write_port_cfg_data(mvi, port_id, hi);
+}
+
 static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 {
 	struct mvs_phy *phy = &mvi->phy[i];
-	struct asd_sas_phy *sas_phy = mvi->sas.sas_phy[i];
-
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct sas_ha_struct *sas_ha;
 	if (!phy->phy_attached)
 		return;
 
+	if (!(phy->att_dev_info & PORT_DEV_TRGT_MASK)
+		&& phy->phy_type & PORT_TYPE_SAS) {
+		return;
+	}
+
+	sas_ha = mvi->sas;
+	sas_ha->notify_phy_event(sas_phy, PHYE_OOB_DONE);
+
 	if (sas_phy->phy) {
 		struct sas_phy *sphy = sas_phy->phy;
 
@@ -286,7 +363,7 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 		sphy->minimum_linkrate = phy->minimum_linkrate;
 		sphy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
 		sphy->maximum_linkrate = phy->maximum_linkrate;
-		sphy->maximum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
+		sphy->maximum_linkrate_hw = MVS_CHIP_DISP->phy_max_link_rate();
 	}
 
 	if (phy->phy_type & PORT_TYPE_SAS) {
@@ -297,13 +374,31 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 		id->initiator_bits = SAS_PROTOCOL_ALL;
 		id->target_bits = phy->identify.target_port_protocols;
 	} else if (phy->phy_type & PORT_TYPE_SATA) {
-		/* TODO */
+		/*Nothing*/
 	}
-	mvi->sas.sas_phy[i]->frame_rcvd_size = phy->frame_rcvd_size;
-	mvi->sas.notify_port_event(mvi->sas.sas_phy[i],
+	mv_dprintk("phy %d byte dmaded.\n", i + mvi->id * mvi->chip->n_phy);
+
+	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
+
+	mvi->sas->notify_port_event(sas_phy,
 				   PORTE_BYTES_DMAED);
 }
 
+int mvs_slave_alloc(struct scsi_device *scsi_dev)
+{
+	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
+	if (dev_is_sata(dev)) {
+		/* We don't need to rescan targets
+		 * if REPORT_LUNS request is failed
+		 */
+		if (scsi_dev->lun > 0)
+			return -ENXIO;
+		scsi_dev->tagged_supported = 1;
+	}
+
+	return sas_slave_alloc(scsi_dev);
+}
+
 int mvs_slave_configure(struct scsi_device *sdev)
 {
 	struct domain_device *dev = sdev_to_domain_dev(sdev);
@@ -311,25 +406,31 @@ int mvs_slave_configure(struct scsi_device *sdev)
 
 	if (ret)
 		return ret;
-
 	if (dev_is_sata(dev)) {
-		/* struct ata_port *ap = dev->sata_dev.ap; */
-		/* struct ata_device *adev = ap->link.device; */
-
-		/* clamp at no NCQ for the time being */
-		/* adev->flags |= ATA_DFLAG_NCQ_OFF; */
+		/* may set PIO mode */
+	#if MV_DISABLE_NCQ
+		struct ata_port *ap = dev->sata_dev.ap;
+		struct ata_device *adev = ap->link.device;
+		adev->flags |= ATA_DFLAG_NCQ_OFF;
 		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, 1);
+	#endif
 	}
 	return 0;
 }
 
 void mvs_scan_start(struct Scsi_Host *shost)
 {
-	int i;
-	struct mvs_info *mvi = SHOST_TO_SAS_HA(shost)->lldd_ha;
+	int i, j;
+	unsigned short core_nr;
+	struct mvs_info *mvi;
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 
-	for (i = 0; i < mvi->chip->n_phy; ++i) {
-		mvs_bytes_dmaed(mvi, i);
+	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
+
+	for (j = 0; j < core_nr; j++) {
+		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[j];
+		for (i = 0; i < mvi->chip->n_phy; ++i)
+			mvs_bytes_dmaed(mvi, i);
 	}
 }
 
@@ -350,15 +451,15 @@ static int mvs_task_prep_smp(struct mvs_info *mvi,
 	int elem, rc, i;
 	struct sas_task *task = tei->task;
 	struct mvs_cmd_hdr *hdr = tei->hdr;
+	struct domain_device *dev = task->dev;
+	struct asd_sas_port *sas_port = dev->port;
 	struct scatterlist *sg_req, *sg_resp;
 	u32 req_len, resp_len, tag = tei->tag;
 	void *buf_tmp;
 	u8 *buf_oaf;
 	dma_addr_t buf_tmp_dma;
-	struct mvs_prd *buf_prd;
-	struct scatterlist *sg;
+	void *buf_prd;
 	struct mvs_slot_info *slot = &mvi->slot_info[tag];
-	struct asd_sas_port *sas_port = task->dev->port;
 	u32 flags = (tei->n_elem << MCH_PRD_LEN_SHIFT);
 #if _MV_DUMP
 	u8 *buf_cmd;
@@ -368,18 +469,18 @@ static int mvs_task_prep_smp(struct mvs_info *mvi,
 	 * DMA-map SMP request, response buffers
 	 */
 	sg_req = &task->smp_task.smp_req;
-	elem = pci_map_sg(mvi->pdev, sg_req, 1, PCI_DMA_TODEVICE);
+	elem = dma_map_sg(mvi->dev, sg_req, 1, PCI_DMA_TODEVICE);
 	if (!elem)
 		return -ENOMEM;
 	req_len = sg_dma_len(sg_req);
 
 	sg_resp = &task->smp_task.smp_resp;
-	elem = pci_map_sg(mvi->pdev, sg_resp, 1, PCI_DMA_FROMDEVICE);
+	elem = dma_map_sg(mvi->dev, sg_resp, 1, PCI_DMA_FROMDEVICE);
 	if (!elem) {
 		rc = -ENOMEM;
 		goto err_out;
 	}
-	resp_len = sg_dma_len(sg_resp);
+	resp_len = SB_RFB_MAX;
 
 	/* must be in dwords */
 	if ((req_len & 0x3) || (resp_len & 0x3)) {
@@ -391,7 +492,7 @@ static int mvs_task_prep_smp(struct mvs_info *mvi,
 	 * arrange MVS_SLOT_BUF_SZ-sized DMA buffer according to our needs
 	 */
 
-	/* region 1: command table area (MVS_SSP_CMD_SZ bytes) ************** */
+	/* region 1: command table area (MVS_SSP_CMD_SZ bytes) ***** */
 	buf_tmp = slot->buf;
 	buf_tmp_dma = slot->buf_dma;
 
@@ -412,20 +513,22 @@ static int mvs_task_prep_smp(struct mvs_info *mvi,
 	buf_tmp += MVS_OAF_SZ;
 	buf_tmp_dma += MVS_OAF_SZ;
 
-	/* region 3: PRD table ********************************************* */
+	/* region 3: PRD table *********************************** */
 	buf_prd = buf_tmp;
 	if (tei->n_elem)
 		hdr->prd_tbl = cpu_to_le64(buf_tmp_dma);
 	else
 		hdr->prd_tbl = 0;
 
-	i = sizeof(struct mvs_prd) * tei->n_elem;
+	i = MVS_CHIP_DISP->prd_size() * tei->n_elem;
 	buf_tmp += i;
 	buf_tmp_dma += i;
 
 	/* region 4: status buffer (larger the PRD, smaller this buf) ****** */
 	slot->response = buf_tmp;
 	hdr->status_buf = cpu_to_le64(buf_tmp_dma);
+	if (mvi->flags & MVF_FLAG_SOC)
+		hdr->reserved[0] = 0;
 
 	/*
 	 * Fill in TX ring and command slot header
@@ -441,17 +544,14 @@ static int mvs_task_prep_smp(struct mvs_info *mvi,
 	hdr->data_len = 0;
 
 	/* generate open address frame hdr (first 12 bytes) */
-	buf_oaf[0] = (1 << 7) | (0 << 4) | 0x01; /* initiator, SMP, ftype 1h */
-	buf_oaf[1] = task->dev->linkrate & 0xf;
+	/* initiator, SMP, ftype 1h */
+	buf_oaf[0] = (1 << 7) | (PROTOCOL_SMP << 4) | 0x01;
+	buf_oaf[1] = dev->linkrate & 0xf;
 	*(u16 *)(buf_oaf + 2) = 0xFFFF;		/* SAS SPEC */
-	memcpy(buf_oaf + 4, task->dev->sas_addr, SAS_ADDR_SIZE);
+	memcpy(buf_oaf + 4, dev->sas_addr, SAS_ADDR_SIZE);
 
 	/* fill in PRD (scatter/gather) table, if any */
-	for_each_sg(task->scatter, sg, tei->n_elem, i) {
-		buf_prd->addr = cpu_to_le64(sg_dma_address(sg));
-		buf_prd->len = cpu_to_le32(sg_dma_len(sg));
-		buf_prd++;
-	}
+	MVS_CHIP_DISP->make_prd(task->scatter, tei->n_elem, buf_prd);
 
 #if _MV_DUMP
 	/* copy cmd table */
@@ -462,10 +562,10 @@ static int mvs_task_prep_smp(struct mvs_info *mvi,
 	return 0;
 
 err_out_2:
-	pci_unmap_sg(mvi->pdev, &tei->task->smp_task.smp_resp, 1,
+	dma_unmap_sg(mvi->dev, &tei->task->smp_task.smp_resp, 1,
 		     PCI_DMA_FROMDEVICE);
 err_out:
-	pci_unmap_sg(mvi->pdev, &tei->task->smp_task.smp_req, 1,
+	dma_unmap_sg(mvi->dev, &tei->task->smp_task.smp_req, 1,
 		     PCI_DMA_TODEVICE);
 	return rc;
 }
@@ -490,30 +590,41 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 {
 	struct sas_task *task = tei->task;
 	struct domain_device *dev = task->dev;
+	struct mvs_device *mvi_dev =
+		(struct mvs_device *)dev->lldd_dev;
 	struct mvs_cmd_hdr *hdr = tei->hdr;
 	struct asd_sas_port *sas_port = dev->port;
 	struct mvs_slot_info *slot;
-	struct scatterlist *sg;
-	struct mvs_prd *buf_prd;
-	struct mvs_port *port = tei->port;
-	u32 tag = tei->tag;
-	u32 flags = (tei->n_elem << MCH_PRD_LEN_SHIFT);
+	void *buf_prd;
+	u32 tag = tei->tag, hdr_tag;
+	u32 flags, del_q;
 	void *buf_tmp;
 	u8 *buf_cmd, *buf_oaf;
 	dma_addr_t buf_tmp_dma;
 	u32 i, req_len, resp_len;
 	const u32 max_resp_len = SB_RFB_MAX;
 
-	if (mvs_assign_reg_set(mvi, port) == MVS_ID_NOT_MAPPED)
+	if (mvs_assign_reg_set(mvi, mvi_dev) == MVS_ID_NOT_MAPPED) {
+		mv_dprintk("Have not enough regiset for dev %d.\n",
+			mvi_dev->device_id);
 		return -EBUSY;
-
+	}
 	slot = &mvi->slot_info[tag];
 	slot->tx = mvi->tx_prod;
-	mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | tag |
-					(TXQ_CMD_STP << TXQ_CMD_SHIFT) |
-					(sas_port->phy_mask << TXQ_PHY_SHIFT) |
-					(port->taskfileset << TXQ_SRS_SHIFT));
-
+	del_q = TXQ_MODE_I | tag |
+		(TXQ_CMD_STP << TXQ_CMD_SHIFT) |
+		(sas_port->phy_mask << TXQ_PHY_SHIFT) |
+		(mvi_dev->taskfileset << TXQ_SRS_SHIFT);
+	mvi->tx[mvi->tx_prod] = cpu_to_le32(del_q);
+
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	if (task->data_dir == DMA_FROM_DEVICE)
+		flags = (MVS_CHIP_DISP->prd_count() << MCH_PRD_LEN_SHIFT);
+	else
+		flags = (tei->n_elem << MCH_PRD_LEN_SHIFT);
+#else
+	flags = (tei->n_elem << MCH_PRD_LEN_SHIFT);
+#endif
 	if (task->ata_task.use_ncq)
 		flags |= MCH_FPDMA;
 	if (dev->sata_dev.command_set == ATAPI_COMMAND_SET) {
@@ -526,10 +637,13 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 	hdr->flags = cpu_to_le32(flags);
 
 	/* FIXME: the low order order 5 bits for the TAG if enable NCQ */
-	if (task->ata_task.use_ncq && mvs_get_ncq_tag(task, &hdr->tags))
-		task->ata_task.fis.sector_count |= hdr->tags << 3;
+	if (task->ata_task.use_ncq && mvs_get_ncq_tag(task, &hdr_tag))
+		task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
 	else
-		hdr->tags = cpu_to_le32(tag);
+		hdr_tag = tag;
+
+	hdr->tags = cpu_to_le32(hdr_tag);
+
 	hdr->data_len = cpu_to_le32(task->total_xfer_len);
 
 	/*
@@ -558,12 +672,13 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 
 	/* region 3: PRD table ********************************************* */
 	buf_prd = buf_tmp;
+
 	if (tei->n_elem)
 		hdr->prd_tbl = cpu_to_le64(buf_tmp_dma);
 	else
 		hdr->prd_tbl = 0;
+	i = MVS_CHIP_DISP->prd_size() * MVS_CHIP_DISP->prd_count();
 
-	i = sizeof(struct mvs_prd) * tei->n_elem;
 	buf_tmp += i;
 	buf_tmp_dma += i;
 
@@ -573,6 +688,8 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 	 */
 	slot->response = buf_tmp;
 	hdr->status_buf = cpu_to_le64(buf_tmp_dma);
+	if (mvi->flags & MVF_FLAG_SOC)
+		hdr->reserved[0] = 0;
 
 	req_len = sizeof(struct host_to_dev_fis);
 	resp_len = MVS_SLOT_BUF_SZ - MVS_ATA_CMD_SZ -
@@ -582,7 +699,8 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 	resp_len = min(resp_len, max_resp_len);
 	hdr->lens = cpu_to_le32(((resp_len / 4) << 16) | (req_len / 4));
 
-	task->ata_task.fis.flags |= 0x80; /* C=1: update ATA cmd reg */
+	if (likely(!task->ata_task.device_control_reg_update))
+		task->ata_task.fis.flags |= 0x80; /* C=1: update ATA cmd reg */
 	/* fill in command FIS and ATAPI CDB */
 	memcpy(buf_cmd, &task->ata_task.fis, sizeof(struct host_to_dev_fis));
 	if (dev->sata_dev.command_set == ATAPI_COMMAND_SET)
@@ -590,30 +708,35 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 			task->ata_task.atapi_packet, 16);
 
 	/* generate open address frame hdr (first 12 bytes) */
-	buf_oaf[0] = (1 << 7) | (2 << 4) | 0x1;	/* initiator, STP, ftype 1h */
-	buf_oaf[1] = task->dev->linkrate & 0xf;
-	*(u16 *)(buf_oaf + 2) = cpu_to_be16(tag);
-	memcpy(buf_oaf + 4, task->dev->sas_addr, SAS_ADDR_SIZE);
+	/* initiator, STP, ftype 1h */
+	buf_oaf[0] = (1 << 7) | (PROTOCOL_STP << 4) | 0x1;
+	buf_oaf[1] = dev->linkrate & 0xf;
+	*(u16 *)(buf_oaf + 2) = cpu_to_be16(mvi_dev->device_id + 1);
+	memcpy(buf_oaf + 4, dev->sas_addr, SAS_ADDR_SIZE);
 
 	/* fill in PRD (scatter/gather) table, if any */
-	for_each_sg(task->scatter, sg, tei->n_elem, i) {
-		buf_prd->addr = cpu_to_le64(sg_dma_address(sg));
-		buf_prd->len = cpu_to_le32(sg_dma_len(sg));
-		buf_prd++;
-	}
-
+	MVS_CHIP_DISP->make_prd(task->scatter, tei->n_elem, buf_prd);
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	if (task->data_dir == DMA_FROM_DEVICE)
+		MVS_CHIP_DISP->dma_fix(mvi->bulk_buffer_dma,
+				TRASH_BUCKET_SIZE, tei->n_elem, buf_prd);
+#endif
 	return 0;
 }
 
 static int mvs_task_prep_ssp(struct mvs_info *mvi,
-			     struct mvs_task_exec_info *tei)
+			     struct mvs_task_exec_info *tei, int is_tmf,
+			     struct mvs_tmf_task *tmf)
 {
 	struct sas_task *task = tei->task;
 	struct mvs_cmd_hdr *hdr = tei->hdr;
 	struct mvs_port *port = tei->port;
+	struct domain_device *dev = task->dev;
+	struct mvs_device *mvi_dev =
+		(struct mvs_device *)dev->lldd_dev;
+	struct asd_sas_port *sas_port = dev->port;
 	struct mvs_slot_info *slot;
-	struct scatterlist *sg;
-	struct mvs_prd *buf_prd;
+	void *buf_prd;
 	struct ssp_frame_hdr *ssp_hdr;
 	void *buf_tmp;
 	u8 *buf_cmd, *buf_oaf, fburst = 0;
@@ -621,12 +744,13 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 	u32 flags;
 	u32 resp_len, req_len, i, tag = tei->tag;
 	const u32 max_resp_len = SB_RFB_MAX;
-	u8 phy_mask;
+	u32 phy_mask;
 
 	slot = &mvi->slot_info[tag];
 
-	phy_mask = (port->wide_port_phymap) ? port->wide_port_phymap :
-		task->dev->port->phy_mask;
+	phy_mask = ((port->wide_port_phymap) ? port->wide_port_phymap :
+		sas_port->phy_mask) & TXQ_PHY_MASK;
+
 	slot->tx = mvi->tx_prod;
 	mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | tag |
 				(TXQ_CMD_SSP << TXQ_CMD_SHIFT) |
@@ -640,7 +764,6 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 	hdr->flags = cpu_to_le32(flags |
 				 (tei->n_elem << MCH_PRD_LEN_SHIFT) |
 				 (MCH_SSP_FR_CMD << MCH_SSP_FR_TYPE_SHIFT));
-
 	hdr->tags = cpu_to_le32(tag);
 	hdr->data_len = cpu_to_le32(task->total_xfer_len);
 
@@ -674,13 +797,15 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 	else
 		hdr->prd_tbl = 0;
 
-	i = sizeof(struct mvs_prd) * tei->n_elem;
+	i = MVS_CHIP_DISP->prd_size() * tei->n_elem;
 	buf_tmp += i;
 	buf_tmp_dma += i;
 
 	/* region 4: status buffer (larger the PRD, smaller this buf) ****** */
 	slot->response = buf_tmp;
 	hdr->status_buf = cpu_to_le64(buf_tmp_dma);
+	if (mvi->flags & MVF_FLAG_SOC)
+		hdr->reserved[0] = 0;
 
 	resp_len = MVS_SLOT_BUF_SZ - MVS_SSP_CMD_SZ - MVS_OAF_SZ -
 	    sizeof(struct mvs_err_info) - i;
@@ -692,57 +817,105 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 	hdr->lens = cpu_to_le32(((resp_len / 4) << 16) | (req_len / 4));
 
 	/* generate open address frame hdr (first 12 bytes) */
-	buf_oaf[0] = (1 << 7) | (1 << 4) | 0x1;	/* initiator, SSP, ftype 1h */
-	buf_oaf[1] = task->dev->linkrate & 0xf;
-	*(u16 *)(buf_oaf + 2) = cpu_to_be16(tag);
-	memcpy(buf_oaf + 4, task->dev->sas_addr, SAS_ADDR_SIZE);
+	/* initiator, SSP, ftype 1h */
+	buf_oaf[0] = (1 << 7) | (PROTOCOL_SSP << 4) | 0x1;
+	buf_oaf[1] = dev->linkrate & 0xf;
+	*(u16 *)(buf_oaf + 2) = cpu_to_be16(mvi_dev->device_id + 1);
+	memcpy(buf_oaf + 4, dev->sas_addr, SAS_ADDR_SIZE);
 
 	/* fill in SSP frame header (Command Table.SSP frame header) */
 	ssp_hdr = (struct ssp_frame_hdr *)buf_cmd;
-	ssp_hdr->frame_type = SSP_COMMAND;
-	memcpy(ssp_hdr->hashed_dest_addr, task->dev->hashed_sas_addr,
+
+	if (is_tmf)
+		ssp_hdr->frame_type = SSP_TASK;
+	else
+		ssp_hdr->frame_type = SSP_COMMAND;
+
+	memcpy(ssp_hdr->hashed_dest_addr, dev->hashed_sas_addr,
 	       HASHED_SAS_ADDR_SIZE);
 	memcpy(ssp_hdr->hashed_src_addr,
-	       task->dev->port->ha->hashed_sas_addr, HASHED_SAS_ADDR_SIZE);
+	       dev->hashed_sas_addr, HASHED_SAS_ADDR_SIZE);
 	ssp_hdr->tag = cpu_to_be16(tag);
 
-	/* fill in command frame IU */
+	/* fill in IU for TASK and Command Frame */
 	buf_cmd += sizeof(*ssp_hdr);
 	memcpy(buf_cmd, &task->ssp_task.LUN, 8);
-	buf_cmd[9] = fburst | task->ssp_task.task_attr |
-			(task->ssp_task.task_prio << 3);
-	memcpy(buf_cmd + 12, &task->ssp_task.cdb, 16);
 
-	/* fill in PRD (scatter/gather) table, if any */
-	for_each_sg(task->scatter, sg, tei->n_elem, i) {
-		buf_prd->addr = cpu_to_le64(sg_dma_address(sg));
-		buf_prd->len = cpu_to_le32(sg_dma_len(sg));
-		buf_prd++;
+	if (ssp_hdr->frame_type != SSP_TASK) {
+		buf_cmd[9] = fburst | task->ssp_task.task_attr |
+				(task->ssp_task.task_prio << 3);
+		memcpy(buf_cmd + 12, &task->ssp_task.cdb, 16);
+	} else{
+		buf_cmd[10] = tmf->tmf;
+		switch (tmf->tmf) {
+		case TMF_ABORT_TASK:
+		case TMF_QUERY_TASK:
+			buf_cmd[12] =
+				(tmf->tag_of_task_to_be_managed >> 8) & 0xff;
+			buf_cmd[13] =
+				tmf->tag_of_task_to_be_managed & 0xff;
+			break;
+		default:
+			break;
+		}
 	}
-
+	/* fill in PRD (scatter/gather) table, if any */
+	MVS_CHIP_DISP->make_prd(task->scatter, tei->n_elem, buf_prd);
 	return 0;
 }
 
-int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
+#define	DEV_IS_GONE(mvi_dev)	((!mvi_dev || (mvi_dev->dev_type == NO_DEVICE)))
+static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
+				struct completion *completion, int lock,
+				int is_tmf, struct mvs_tmf_task *tmf)
 {
 	struct domain_device *dev = task->dev;
-	struct mvs_info *mvi = dev->port->ha->lldd_ha;
-	struct pci_dev *pdev = mvi->pdev;
-	void __iomem *regs = mvi->regs;
+	struct mvs_info *mvi;
+	struct mvs_device *mvi_dev;
 	struct mvs_task_exec_info tei;
 	struct sas_task *t = task;
 	struct mvs_slot_info *slot;
 	u32 tag = 0xdeadbeef, rc, n_elem = 0;
-	unsigned long flags;
 	u32 n = num, pass = 0;
+	unsigned long flags = 0;
 
-	spin_lock_irqsave(&mvi->lock, flags);
+	if (!dev->port) {
+		struct task_status_struct *tsm = &t->task_status;
+
+		tsm->resp = SAS_TASK_UNDELIVERED;
+		tsm->stat = SAS_PHY_DOWN;
+		t->task_done(t);
+		return 0;
+	}
+
+	mvi = mvs_find_dev_mvi(task->dev);
+
+	if (lock)
+		spin_lock_irqsave(&mvi->lock, flags);
 	do {
 		dev = t->dev;
-		tei.port = &mvi->port[dev->port->id];
+		mvi_dev = (struct mvs_device *)dev->lldd_dev;
+		if (DEV_IS_GONE(mvi_dev)) {
+			if (mvi_dev)
+				mv_dprintk("device %d not ready.\n",
+					mvi_dev->device_id);
+			else
+				mv_dprintk("device %016llx not ready.\n",
+					SAS_ADDR(dev->sas_addr));
+
+			rc = SAS_PHY_DOWN;
+			goto out_done;
+		}
+
+		if (dev->port->id >= mvi->chip->n_phy)
+			tei.port = &mvi->port[dev->port->id - mvi->chip->n_phy];
+		else
+			tei.port = &mvi->port[dev->port->id];
 
 		if (!tei.port->port_attached) {
 			if (sas_protocol_ata(t->task_proto)) {
+				mv_dprintk("port %d does not"
+					"attached device.\n", dev->port->id);
 				rc = SAS_PHY_DOWN;
 				goto out_done;
 			} else {
@@ -759,7 +932,8 @@ int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
 
 		if (!sas_protocol_ata(t->task_proto)) {
 			if (t->num_scatter) {
-				n_elem = pci_map_sg(mvi->pdev, t->scatter,
+				n_elem = dma_map_sg(mvi->dev,
+						    t->scatter,
 						    t->num_scatter,
 						    t->data_dir);
 				if (!n_elem) {
@@ -776,20 +950,23 @@ int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
 			goto err_out;
 
 		slot = &mvi->slot_info[tag];
+
+
 		t->lldd_task = NULL;
 		slot->n_elem = n_elem;
+		slot->slot_tag = tag;
 		memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
+
 		tei.task = t;
 		tei.hdr = &mvi->slot[tag];
 		tei.tag = tag;
 		tei.n_elem = n_elem;
-
 		switch (t->task_proto) {
 		case SAS_PROTOCOL_SMP:
 			rc = mvs_task_prep_smp(mvi, &tei);
 			break;
 		case SAS_PROTOCOL_SSP:
-			rc = mvs_task_prep_ssp(mvi, &tei);
+			rc = mvs_task_prep_ssp(mvi, &tei, is_tmf, tmf);
 			break;
 		case SAS_PROTOCOL_SATA:
 		case SAS_PROTOCOL_STP:
@@ -797,52 +974,61 @@ int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
 			rc = mvs_task_prep_ata(mvi, &tei);
 			break;
 		default:
-			dev_printk(KERN_ERR, &pdev->dev,
+			dev_printk(KERN_ERR, mvi->dev,
 				"unknown sas_task proto: 0x%x\n",
 				t->task_proto);
 			rc = -EINVAL;
 			break;
 		}
 
-		if (rc)
+		if (rc) {
+			mv_dprintk("rc is %x\n", rc);
 			goto err_out_tag;
-
+		}
 		slot->task = t;
 		slot->port = tei.port;
 		t->lldd_task = (void *) slot;
-		list_add_tail(&slot->list, &slot->port->list);
+		list_add_tail(&slot->entry, &tei.port->list);
 		/* TODO: select normal or high priority */
-
 		spin_lock(&t->task_state_lock);
 		t->task_state_flags |= SAS_TASK_AT_INITIATOR;
 		spin_unlock(&t->task_state_lock);
 
 		mvs_hba_memory_dump(mvi, tag, t->task_proto);
-
+		mvi_dev->runing_req++;
 		++pass;
 		mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_CHIP_SLOT_SZ - 1);
 		if (n > 1)
 			t = list_entry(t->list.next, struct sas_task, list);
 	} while (--n);
-
 	rc = 0;
 	goto out_done;
 
 err_out_tag:
 	mvs_tag_free(mvi, tag);
 err_out:
-	dev_printk(KERN_ERR, &pdev->dev, "mvsas exec failed[%d]!\n", rc);
+
+	dev_printk(KERN_ERR, mvi->dev, "mvsas exec failed[%d]!\n", rc);
 	if (!sas_protocol_ata(t->task_proto))
 		if (n_elem)
-			pci_unmap_sg(mvi->pdev, t->scatter, n_elem,
+			dma_unmap_sg(mvi->dev, t->scatter, n_elem,
 				     t->data_dir);
 out_done:
-	if (pass)
-		mw32(TX_PROD_IDX, (mvi->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
-	spin_unlock_irqrestore(&mvi->lock, flags);
+	if (likely(pass)) {
+		MVS_CHIP_DISP->start_delivery(mvi,
+			(mvi->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
+	}
+	if (lock)
+		spin_unlock_irqrestore(&mvi->lock, flags);
 	return rc;
 }
 
+int mvs_queue_command(struct sas_task *task, const int num,
+			gfp_t gfp_flags)
+{
+	return mvs_task_exec(task, num, gfp_flags, NULL, 1, 0, NULL);
+}
+
 static void mvs_slot_free(struct mvs_info *mvi, u32 rx_desc)
 {
 	u32 slot_idx = rx_desc & RXQ_SLOT_MASK;
@@ -852,16 +1038,18 @@ static void mvs_slot_free(struct mvs_info *mvi, u32 rx_desc)
 static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
 			  struct mvs_slot_info *slot, u32 slot_idx)
 {
+	if (!slot->task)
+		return;
 	if (!sas_protocol_ata(task->task_proto))
 		if (slot->n_elem)
-			pci_unmap_sg(mvi->pdev, task->scatter,
+			dma_unmap_sg(mvi->dev, task->scatter,
 				     slot->n_elem, task->data_dir);
 
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SMP:
-		pci_unmap_sg(mvi->pdev, &task->smp_task.smp_resp, 1,
+		dma_unmap_sg(mvi->dev, &task->smp_task.smp_resp, 1,
 			     PCI_DMA_FROMDEVICE);
-		pci_unmap_sg(mvi->pdev, &task->smp_task.smp_req, 1,
+		dma_unmap_sg(mvi->dev, &task->smp_task.smp_req, 1,
 			     PCI_DMA_TODEVICE);
 		break;
 
@@ -872,10 +1060,12 @@ static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
 		/* do nothing */
 		break;
 	}
-	list_del(&slot->list);
+	list_del_init(&slot->entry);
 	task->lldd_task = NULL;
 	slot->task = NULL;
 	slot->port = NULL;
+	slot->slot_tag = 0xFFFFFFFF;
+	mvs_slot_free(mvi, slot_idx);
 }
 
 static void mvs_update_wideport(struct mvs_info *mvi, int i)
@@ -884,25 +1074,28 @@ static void mvs_update_wideport(struct mvs_info *mvi, int i)
 	struct mvs_port *port = phy->port;
 	int j, no;
 
-	for_each_phy(port->wide_port_phymap, no, j, mvi->chip->n_phy)
-		if (no & 1) {
-			mvs_write_port_cfg_addr(mvi, no, PHYR_WIDE_PORT);
-			mvs_write_port_cfg_data(mvi, no,
+	for_each_phy(port->wide_port_phymap, j, no) {
+		if (j & 1) {
+			MVS_CHIP_DISP->write_port_cfg_addr(mvi, no,
+						PHYR_WIDE_PORT);
+			MVS_CHIP_DISP->write_port_cfg_data(mvi, no,
 						port->wide_port_phymap);
 		} else {
-			mvs_write_port_cfg_addr(mvi, no, PHYR_WIDE_PORT);
-			mvs_write_port_cfg_data(mvi, no, 0);
+			MVS_CHIP_DISP->write_port_cfg_addr(mvi, no,
+						PHYR_WIDE_PORT);
+			MVS_CHIP_DISP->write_port_cfg_data(mvi, no,
+						0);
 		}
+	}
 }
 
 static u32 mvs_is_phy_ready(struct mvs_info *mvi, int i)
 {
 	u32 tmp;
 	struct mvs_phy *phy = &mvi->phy[i];
-	struct mvs_port *port = phy->port;;
-
-	tmp = mvs_read_phy_ctl(mvi, i);
+	struct mvs_port *port = phy->port;
 
+	tmp = MVS_CHIP_DISP->read_phy_ctl(mvi, i);
 	if ((tmp & PHY_READY_MASK) && !(phy->irq_status & PHYEV_POOF)) {
 		if (!port)
 			phy->phy_attached = 1;
@@ -917,7 +1110,6 @@ static u32 mvs_is_phy_ready(struct mvs_info *mvi, int i)
 			mvs_update_wideport(mvi, i);
 		} else if (phy->phy_type & PORT_TYPE_SATA)
 			port->port_attached = 0;
-		mvs_free_reg_set(mvi, phy->port);
 		phy->port = NULL;
 		phy->phy_attached = 0;
 		phy->phy_type &= ~(PORT_TYPE_SAS | PORT_TYPE_SATA);
@@ -932,17 +1124,21 @@ static void *mvs_get_d2h_reg(struct mvs_info *mvi, int i, void *buf)
 	if (!s)
 		return NULL;
 
-	mvs_write_port_cfg_addr(mvi, i, PHYR_SATA_SIG3);
-	s[3] = mvs_read_port_cfg_data(mvi, i);
+	MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG3);
+	s[3] = MVS_CHIP_DISP->read_port_cfg_data(mvi, i);
+
+	MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG2);
+	s[2] = MVS_CHIP_DISP->read_port_cfg_data(mvi, i);
 
-	mvs_write_port_cfg_addr(mvi, i, PHYR_SATA_SIG2);
-	s[2] = mvs_read_port_cfg_data(mvi, i);
+	MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG1);
+	s[1] = MVS_CHIP_DISP->read_port_cfg_data(mvi, i);
 
-	mvs_write_port_cfg_addr(mvi, i, PHYR_SATA_SIG1);
-	s[1] = mvs_read_port_cfg_data(mvi, i);
+	MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG0);
+	s[0] = MVS_CHIP_DISP->read_port_cfg_data(mvi, i);
 
-	mvs_write_port_cfg_addr(mvi, i, PHYR_SATA_SIG0);
-	s[0] = mvs_read_port_cfg_data(mvi, i);
+	/* Workaround: take some ATAPI devices for ATA */
+	if (((s[1] & 0x00FFFFFF) == 0x00EB1401) && (*(u8 *)&s[3] == 0x01))
+		s[1] = 0x00EB1401 | (*((u8 *)&s[1] + 3) & 0x10);
 
 	return (void *)s;
 }
@@ -952,56 +1148,53 @@ static u32 mvs_is_sig_fis_received(u32 irq_status)
 	return irq_status & PHYEV_SIG_FIS;
 }
 
-static void mvs_update_phyinfo(struct mvs_info *mvi, int i,
-					int get_st)
+void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st)
 {
 	struct mvs_phy *phy = &mvi->phy[i];
-	struct pci_dev *pdev = mvi->pdev;
-	u32 tmp;
-	u64 tmp64;
-
-	mvs_write_port_cfg_addr(mvi, i, PHYR_IDENTIFY);
-	phy->dev_info = mvs_read_port_cfg_data(mvi, i);
-
-	mvs_write_port_cfg_addr(mvi, i, PHYR_ADDR_HI);
-	phy->dev_sas_addr = (u64) mvs_read_port_cfg_data(mvi, i) << 32;
+	struct sas_identify_frame *id;
 
-	mvs_write_port_cfg_addr(mvi, i, PHYR_ADDR_LO);
-	phy->dev_sas_addr |= mvs_read_port_cfg_data(mvi, i);
+	id = (struct sas_identify_frame *)phy->frame_rcvd;
 
 	if (get_st) {
-		phy->irq_status = mvs_read_port_irq_stat(mvi, i);
+		phy->irq_status = MVS_CHIP_DISP->read_port_irq_stat(mvi, i);
 		phy->phy_status = mvs_is_phy_ready(mvi, i);
 	}
 
 	if (phy->phy_status) {
-		u32 phy_st;
-		struct asd_sas_phy *sas_phy = mvi->sas.sas_phy[i];
-
-		mvs_write_port_cfg_addr(mvi, i, PHYR_PHY_STAT);
-		phy_st = mvs_read_port_cfg_data(mvi, i);
-
-		sas_phy->linkrate =
-			(phy->phy_status & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
-				PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET;
-		phy->minimum_linkrate =
-			(phy->phy_status &
-				PHY_MIN_SPP_PHYS_LINK_RATE_MASK) >> 8;
-		phy->maximum_linkrate =
-			(phy->phy_status &
-				PHY_MAX_SPP_PHYS_LINK_RATE_MASK) >> 12;
+		int oob_done = 0;
+		struct asd_sas_phy *sas_phy = &mvi->phy[i].sas_phy;
 
-		if (phy->phy_type & PORT_TYPE_SAS) {
-			/* Updated attached_sas_addr */
-			mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_HI);
-			phy->att_dev_sas_addr =
-				(u64) mvs_read_port_cfg_data(mvi, i) << 32;
-			mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_LO);
-			phy->att_dev_sas_addr |= mvs_read_port_cfg_data(mvi, i);
-			mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_DEV_INFO);
-			phy->att_dev_info = mvs_read_port_cfg_data(mvi, i);
+		oob_done = MVS_CHIP_DISP->oob_done(mvi, i);
+
+		MVS_CHIP_DISP->fix_phy_info(mvi, i, id);
+		if (phy->phy_type & PORT_TYPE_SATA) {
+			phy->identify.target_port_protocols = SAS_PROTOCOL_STP;
+			if (mvs_is_sig_fis_received(phy->irq_status)) {
+				phy->phy_attached = 1;
+				phy->att_dev_sas_addr =
+					i + mvi->id * mvi->chip->n_phy;
+				if (oob_done)
+					sas_phy->oob_mode = SATA_OOB_MODE;
+				phy->frame_rcvd_size =
+				    sizeof(struct dev_to_host_fis);
+				mvs_get_d2h_reg(mvi, i, (void *)id);
+			} else {
+				u32 tmp;
+				dev_printk(KERN_DEBUG, mvi->dev,
+					"Phy%d : No sig fis\n", i);
+				tmp = MVS_CHIP_DISP->read_port_irq_mask(mvi, i);
+				MVS_CHIP_DISP->write_port_irq_mask(mvi, i,
+						tmp | PHYEV_SIG_FIS);
+				phy->phy_attached = 0;
+				phy->phy_type &= ~PORT_TYPE_SATA;
+				MVS_CHIP_DISP->phy_reset(mvi, i, 0);
+				goto out_done;
+			}
+		}		else if (phy->phy_type & PORT_TYPE_SAS
+			|| phy->att_dev_info & PORT_SSP_INIT_MASK) {
+			phy->phy_attached = 1;
 			phy->identify.device_type =
-			    phy->att_dev_info & PORT_DEV_TYPE_MASK;
+				phy->att_dev_info & PORT_DEV_TYPE_MASK;
 
 			if (phy->identify.device_type == SAS_END_DEV)
 				phy->identify.target_port_protocols =
@@ -1009,93 +1202,522 @@ static void mvs_update_phyinfo(struct mvs_info *mvi, int i,
 			else if (phy->identify.device_type != NO_DEVICE)
 				phy->identify.target_port_protocols =
 							SAS_PROTOCOL_SMP;
-			if (phy_st & PHY_OOB_DTCTD)
+			if (oob_done)
 				sas_phy->oob_mode = SAS_OOB_MODE;
 			phy->frame_rcvd_size =
 			    sizeof(struct sas_identify_frame);
-		} else if (phy->phy_type & PORT_TYPE_SATA) {
-			phy->identify.target_port_protocols = SAS_PROTOCOL_STP;
-			if (mvs_is_sig_fis_received(phy->irq_status)) {
-				phy->att_dev_sas_addr = i;	/* temp */
-				if (phy_st & PHY_OOB_DTCTD)
-					sas_phy->oob_mode = SATA_OOB_MODE;
-				phy->frame_rcvd_size =
-				    sizeof(struct dev_to_host_fis);
-				mvs_get_d2h_reg(mvi, i,
-						(void *)sas_phy->frame_rcvd);
-			} else {
-				dev_printk(KERN_DEBUG, &pdev->dev,
-					"No sig fis\n");
-				phy->phy_type &= ~(PORT_TYPE_SATA);
-				goto out_done;
-			}
 		}
-		tmp64 = cpu_to_be64(phy->att_dev_sas_addr);
-		memcpy(sas_phy->attached_sas_addr, &tmp64, SAS_ADDR_SIZE);
-
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			"phy[%d] Get Attached Address 0x%llX ,"
-			" SAS Address 0x%llX\n",
-			i,
-			(unsigned long long)phy->att_dev_sas_addr,
-			(unsigned long long)phy->dev_sas_addr);
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			"Rate = %x , type = %d\n",
-			sas_phy->linkrate, phy->phy_type);
-
-		/* workaround for HW phy decoding error on 1.5g disk drive */
-		mvs_write_port_vsr_addr(mvi, i, VSR_PHY_MODE6);
-		tmp = mvs_read_port_vsr_data(mvi, i);
-		if (((phy->phy_status & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
-		     PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET) ==
-			SAS_LINK_RATE_1_5_GBPS)
-			tmp &= ~PHY_MODE6_LATECLK;
-		else
-			tmp |= PHY_MODE6_LATECLK;
-		mvs_write_port_vsr_data(mvi, i, tmp);
+		memcpy(sas_phy->attached_sas_addr,
+			&phy->att_dev_sas_addr, SAS_ADDR_SIZE);
 
+		if (MVS_CHIP_DISP->phy_work_around)
+			MVS_CHIP_DISP->phy_work_around(mvi, i);
 	}
+	mv_dprintk("port %d attach dev info is %x\n",
+		i + mvi->id * mvi->chip->n_phy, phy->att_dev_info);
+	mv_dprintk("port %d attach sas addr is %llx\n",
+		i + mvi->id * mvi->chip->n_phy, phy->att_dev_sas_addr);
 out_done:
 	if (get_st)
-		mvs_write_port_irq_stat(mvi, i, phy->irq_status);
+		MVS_CHIP_DISP->write_port_irq_stat(mvi, i, phy->irq_status);
 }
 
-void mvs_port_formed(struct asd_sas_phy *sas_phy)
+static void mvs_port_notify_formed(struct asd_sas_phy *sas_phy, int lock)
 {
 	struct sas_ha_struct *sas_ha = sas_phy->ha;
-	struct mvs_info *mvi = sas_ha->lldd_ha;
-	struct asd_sas_port *sas_port = sas_phy->port;
+	struct mvs_info *mvi = NULL; int i = 0, hi;
 	struct mvs_phy *phy = sas_phy->lldd_phy;
-	struct mvs_port *port = &mvi->port[sas_port->id];
-	unsigned long flags;
+	struct asd_sas_port *sas_port = sas_phy->port;
+	struct mvs_port *port;
+	unsigned long flags = 0;
+	if (!sas_port)
+		return;
 
-	spin_lock_irqsave(&mvi->lock, flags);
+	while (sas_ha->sas_phy[i]) {
+		if (sas_ha->sas_phy[i] == sas_phy)
+			break;
+		i++;
+	}
+	hi = i/((struct mvs_prv_info *)sas_ha->lldd_ha)->n_phy;
+	mvi = ((struct mvs_prv_info *)sas_ha->lldd_ha)->mvi[hi];
+	if (sas_port->id >= mvi->chip->n_phy)
+		port = &mvi->port[sas_port->id - mvi->chip->n_phy];
+	else
+		port = &mvi->port[sas_port->id];
+	if (lock)
+		spin_lock_irqsave(&mvi->lock, flags);
 	port->port_attached = 1;
 	phy->port = port;
-	port->taskfileset = MVS_ID_NOT_MAPPED;
 	if (phy->phy_type & PORT_TYPE_SAS) {
 		port->wide_port_phymap = sas_port->phy_mask;
+		mv_printk("set wide port phy map %x\n", sas_port->phy_mask);
 		mvs_update_wideport(mvi, sas_phy->id);
 	}
-	spin_unlock_irqrestore(&mvi->lock, flags);
+	if (lock)
+		spin_unlock_irqrestore(&mvi->lock, flags);
+}
+
+static void mvs_port_notify_deformed(struct asd_sas_phy *sas_phy, int lock)
+{
+	/*Nothing*/
+}
+
+
+void mvs_port_formed(struct asd_sas_phy *sas_phy)
+{
+	mvs_port_notify_formed(sas_phy, 1);
+}
+
+void mvs_port_deformed(struct asd_sas_phy *sas_phy)
+{
+	mvs_port_notify_deformed(sas_phy, 1);
+}
+
+struct mvs_device *mvs_alloc_dev(struct mvs_info *mvi)
+{
+	u32 dev;
+	for (dev = 0; dev < MVS_MAX_DEVICES; dev++) {
+		if (mvi->devices[dev].dev_type == NO_DEVICE) {
+			mvi->devices[dev].device_id = dev;
+			return &mvi->devices[dev];
+		}
+	}
+
+	if (dev == MVS_MAX_DEVICES)
+		mv_printk("max support %d devices, ignore ..\n",
+			MVS_MAX_DEVICES);
+
+	return NULL;
+}
+
+void mvs_free_dev(struct mvs_device *mvi_dev)
+{
+	u32 id = mvi_dev->device_id;
+	memset(mvi_dev, 0, sizeof(*mvi_dev));
+	mvi_dev->device_id = id;
+	mvi_dev->dev_type = NO_DEVICE;
+	mvi_dev->dev_status = MVS_DEV_NORMAL;
+	mvi_dev->taskfileset = MVS_ID_NOT_MAPPED;
+}
+
+int mvs_dev_found_notify(struct domain_device *dev, int lock)
+{
+	unsigned long flags = 0;
+	int res = 0;
+	struct mvs_info *mvi = NULL;
+	struct domain_device *parent_dev = dev->parent;
+	struct mvs_device *mvi_device;
+
+	mvi = mvs_find_dev_mvi(dev);
+
+	if (lock)
+		spin_lock_irqsave(&mvi->lock, flags);
+
+	mvi_device = mvs_alloc_dev(mvi);
+	if (!mvi_device) {
+		res = -1;
+		goto found_out;
+	}
+	dev->lldd_dev = (void *)mvi_device;
+	mvi_device->dev_type = dev->dev_type;
+
+	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type)) {
+		int phy_id;
+		u8 phy_num = parent_dev->ex_dev.num_phys;
+		struct ex_phy *phy;
+		for (phy_id = 0; phy_id < phy_num; phy_id++) {
+			phy = &parent_dev->ex_dev.ex_phy[phy_id];
+			if (SAS_ADDR(phy->attached_sas_addr) ==
+				SAS_ADDR(dev->sas_addr)) {
+				mvi_device->attached_phy = phy_id;
+				break;
+			}
+		}
+
+		if (phy_id == phy_num) {
+			mv_printk("Error: no attached dev:%016llx"
+				"at ex:%016llx.\n",
+				SAS_ADDR(dev->sas_addr),
+				SAS_ADDR(parent_dev->sas_addr));
+			res = -1;
+		}
+	}
+
+found_out:
+	if (lock)
+		spin_unlock_irqrestore(&mvi->lock, flags);
+	return res;
+}
+
+int mvs_dev_found(struct domain_device *dev)
+{
+	return mvs_dev_found_notify(dev, 1);
+}
+
+void mvs_dev_gone_notify(struct domain_device *dev, int lock)
+{
+	unsigned long flags = 0;
+	struct mvs_info *mvi;
+	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
+
+	mvi = mvs_find_dev_mvi(dev);
+
+	if (lock)
+		spin_lock_irqsave(&mvi->lock, flags);
+
+	if (mvi_dev) {
+		mv_dprintk("found dev[%d:%x] is gone.\n",
+			mvi_dev->device_id, mvi_dev->dev_type);
+		mvs_free_reg_set(mvi, mvi_dev);
+		mvs_free_dev(mvi_dev);
+	} else {
+		mv_dprintk("found dev has gone.\n");
+	}
+	dev->lldd_dev = NULL;
+
+	if (lock)
+		spin_unlock_irqrestore(&mvi->lock, flags);
+}
+
+
+void mvs_dev_gone(struct domain_device *dev)
+{
+	mvs_dev_gone_notify(dev, 1);
+}
+
+static  struct sas_task *mvs_alloc_task(void)
+{
+	struct sas_task *task = kzalloc(sizeof(struct sas_task), GFP_KERNEL);
+
+	if (task) {
+		INIT_LIST_HEAD(&task->list);
+		spin_lock_init(&task->task_state_lock);
+		task->task_state_flags = SAS_TASK_STATE_PENDING;
+		init_timer(&task->timer);
+		init_completion(&task->completion);
+	}
+	return task;
+}
+
+static  void mvs_free_task(struct sas_task *task)
+{
+	if (task) {
+		BUG_ON(!list_empty(&task->list));
+		kfree(task);
+	}
+}
+
+static void mvs_task_done(struct sas_task *task)
+{
+	if (!del_timer(&task->timer))
+		return;
+	complete(&task->completion);
+}
+
+static void mvs_tmf_timedout(unsigned long data)
+{
+	struct sas_task *task = (struct sas_task *)data;
+
+	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+	complete(&task->completion);
+}
+
+/* XXX */
+#define MVS_TASK_TIMEOUT 20
+static int mvs_exec_internal_tmf_task(struct domain_device *dev,
+			void *parameter, u32 para_len, struct mvs_tmf_task *tmf)
+{
+	int res, retry;
+	struct sas_task *task = NULL;
+
+	for (retry = 0; retry < 3; retry++) {
+		task = mvs_alloc_task();
+		if (!task)
+			return -ENOMEM;
+
+		task->dev = dev;
+		task->task_proto = dev->tproto;
+
+		memcpy(&task->ssp_task, parameter, para_len);
+		task->task_done = mvs_task_done;
+
+		task->timer.data = (unsigned long) task;
+		task->timer.function = mvs_tmf_timedout;
+		task->timer.expires = jiffies + MVS_TASK_TIMEOUT*HZ;
+		add_timer(&task->timer);
+
+		res = mvs_task_exec(task, 1, GFP_KERNEL, NULL, 0, 1, tmf);
+
+		if (res) {
+			del_timer(&task->timer);
+			mv_printk("executing internel task failed:%d\n", res);
+			goto ex_err;
+		}
+
+		wait_for_completion(&task->completion);
+		res = -TMF_RESP_FUNC_FAILED;
+		/* Even TMF timed out, return direct. */
+		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
+			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
+				mv_printk("TMF task[%x] timeout.\n", tmf->tmf);
+				goto ex_err;
+			}
+		}
+
+		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		    task->task_status.stat == SAM_GOOD) {
+			res = TMF_RESP_FUNC_COMPLETE;
+			break;
+		}
+
+		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		      task->task_status.stat == SAS_DATA_UNDERRUN) {
+			/* no error, but return the number of bytes of
+			 * underrun */
+			res = task->task_status.residual;
+			break;
+		}
+
+		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		      task->task_status.stat == SAS_DATA_OVERRUN) {
+			mv_dprintk("blocked task error.\n");
+			res = -EMSGSIZE;
+			break;
+		} else {
+			mv_dprintk(" task to dev %016llx response: 0x%x "
+				    "status 0x%x\n",
+				    SAS_ADDR(dev->sas_addr),
+				    task->task_status.resp,
+				    task->task_status.stat);
+			mvs_free_task(task);
+			task = NULL;
+
+		}
+	}
+ex_err:
+	BUG_ON(retry == 3 && task != NULL);
+	if (task != NULL)
+		mvs_free_task(task);
+	return res;
+}
+
+static int mvs_debug_issue_ssp_tmf(struct domain_device *dev,
+				u8 *lun, struct mvs_tmf_task *tmf)
+{
+	struct sas_ssp_task ssp_task;
+	DECLARE_COMPLETION_ONSTACK(completion);
+	if (!(dev->tproto & SAS_PROTOCOL_SSP))
+		return TMF_RESP_FUNC_ESUPP;
+
+	strncpy((u8 *)&ssp_task.LUN, lun, 8);
+
+	return mvs_exec_internal_tmf_task(dev, &ssp_task,
+				sizeof(ssp_task), tmf);
+}
+
+
+/*  Standard mandates link reset for ATA  (type 0)
+    and hard reset for SSP (type 1) , only for RECOVERY */
+static int mvs_debug_I_T_nexus_reset(struct domain_device *dev)
+{
+	int rc;
+	struct sas_phy *phy = sas_find_local_phy(dev);
+	int reset_type = (dev->dev_type == SATA_DEV ||
+			(dev->tproto & SAS_PROTOCOL_STP)) ? 0 : 1;
+	rc = sas_phy_reset(phy, reset_type);
+	msleep(2000);
+	return rc;
+}
+
+/* mandatory SAM-3 */
+int mvs_lu_reset(struct domain_device *dev, u8 *lun)
+{
+	unsigned long flags;
+	int i, phyno[WIDE_PORT_MAX_PHY], num , rc = TMF_RESP_FUNC_FAILED;
+	struct mvs_tmf_task tmf_task;
+	struct mvs_info *mvi = mvs_find_dev_mvi(dev);
+	struct mvs_device * mvi_dev = (struct mvs_device *)dev->lldd_dev;
+
+	tmf_task.tmf = TMF_LU_RESET;
+	mvi_dev->dev_status = MVS_DEV_EH;
+	rc = mvs_debug_issue_ssp_tmf(dev, lun, &tmf_task);
+	if (rc == TMF_RESP_FUNC_COMPLETE) {
+		num = mvs_find_dev_phyno(dev, phyno);
+		spin_lock_irqsave(&mvi->lock, flags);
+		for (i = 0; i < num; i++)
+			mvs_release_task(mvi, phyno[i], dev);
+		spin_unlock_irqrestore(&mvi->lock, flags);
+	}
+	/* If failed, fall-through I_T_Nexus reset */
+	mv_printk("%s for device[%x]:rc= %d\n", __func__,
+			mvi_dev->device_id, rc);
+	return rc;
 }
 
 int mvs_I_T_nexus_reset(struct domain_device *dev)
 {
-	return TMF_RESP_FUNC_FAILED;
+	unsigned long flags;
+	int i, phyno[WIDE_PORT_MAX_PHY], num , rc = TMF_RESP_FUNC_FAILED;
+	struct mvs_info *mvi = mvs_find_dev_mvi(dev);
+	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
+
+	if (mvi_dev->dev_status != MVS_DEV_EH)
+		return TMF_RESP_FUNC_COMPLETE;
+	rc = mvs_debug_I_T_nexus_reset(dev);
+	mv_printk("%s for device[%x]:rc= %d\n",
+		__func__, mvi_dev->device_id, rc);
+
+	/* housekeeper */
+	num = mvs_find_dev_phyno(dev, phyno);
+	spin_lock_irqsave(&mvi->lock, flags);
+	for (i = 0; i < num; i++)
+		mvs_release_task(mvi, phyno[i], dev);
+	spin_unlock_irqrestore(&mvi->lock, flags);
+
+	return rc;
+}
+/* optional SAM-3 */
+int mvs_query_task(struct sas_task *task)
+{
+	u32 tag;
+	struct scsi_lun lun;
+	struct mvs_tmf_task tmf_task;
+	int rc = TMF_RESP_FUNC_FAILED;
+
+	if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SSP) {
+		struct scsi_cmnd * cmnd = (struct scsi_cmnd *)task->uldd_task;
+		struct domain_device *dev = task->dev;
+		struct mvs_info *mvi = mvs_find_dev_mvi(dev);
+
+		int_to_scsilun(cmnd->device->lun, &lun);
+		rc = mvs_find_tag(mvi, task, &tag);
+		if (rc == 0) {
+			rc = TMF_RESP_FUNC_FAILED;
+			return rc;
+		}
+
+		tmf_task.tmf = TMF_QUERY_TASK;
+		tmf_task.tag_of_task_to_be_managed = cpu_to_le16(tag);
+
+		rc = mvs_debug_issue_ssp_tmf(dev, lun.scsi_lun, &tmf_task);
+		switch (rc) {
+		/* The task is still in Lun, release it then */
+		case TMF_RESP_FUNC_SUCC:
+		/* The task is not in Lun or failed, reset the phy */
+		case TMF_RESP_FUNC_FAILED:
+		case TMF_RESP_FUNC_COMPLETE:
+			break;
+		}
+	}
+	mv_printk("%s:rc= %d\n", __func__, rc);
+	return rc;
+}
+
+/*  mandatory SAM-3, still need free task/slot info */
+int mvs_abort_task(struct sas_task *task)
+{
+	struct scsi_lun lun;
+	struct mvs_tmf_task tmf_task;
+	struct domain_device *dev = task->dev;
+	struct mvs_info *mvi = mvs_find_dev_mvi(dev);
+	int rc = TMF_RESP_FUNC_FAILED;
+	unsigned long flags;
+	u32 tag;
+	if (mvi->exp_req)
+		mvi->exp_req--;
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
+		spin_unlock_irqrestore(&task->task_state_lock, flags);
+		rc = TMF_RESP_FUNC_COMPLETE;
+		goto out;
+	}
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
+	if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SSP) {
+		struct scsi_cmnd * cmnd = (struct scsi_cmnd *)task->uldd_task;
+
+		int_to_scsilun(cmnd->device->lun, &lun);
+		rc = mvs_find_tag(mvi, task, &tag);
+		if (rc == 0) {
+			mv_printk("No such tag in %s\n", __func__);
+			rc = TMF_RESP_FUNC_FAILED;
+			return rc;
+		}
+
+		tmf_task.tmf = TMF_ABORT_TASK;
+		tmf_task.tag_of_task_to_be_managed = cpu_to_le16(tag);
+
+		rc = mvs_debug_issue_ssp_tmf(dev, lun.scsi_lun, &tmf_task);
+
+		/* if successful, clear the task and callback forwards.*/
+		if (rc == TMF_RESP_FUNC_COMPLETE) {
+			u32 slot_no;
+			struct mvs_slot_info *slot;
+			struct mvs_info *mvi = mvs_find_dev_mvi(dev);
+
+			if (task->lldd_task) {
+				slot = (struct mvs_slot_info *)task->lldd_task;
+				slot_no = (u32) (slot - mvi->slot_info);
+				mvs_slot_complete(mvi, slot_no, 1);
+			}
+		}
+	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
+		task->task_proto & SAS_PROTOCOL_STP) {
+		/* to do free register_set */
+	} else {
+		/* SMP */
+
+	}
+out:
+	if (rc != TMF_RESP_FUNC_COMPLETE)
+		mv_printk("%s:rc= %d\n", __func__, rc);
+	return rc;
+}
+
+int mvs_abort_task_set(struct domain_device *dev, u8 *lun)
+{
+	int rc = TMF_RESP_FUNC_FAILED;
+	struct mvs_tmf_task tmf_task;
+
+	tmf_task.tmf = TMF_ABORT_TASK_SET;
+	rc = mvs_debug_issue_ssp_tmf(dev, lun, &tmf_task);
+
+	return rc;
+}
+
+int mvs_clear_aca(struct domain_device *dev, u8 *lun)
+{
+	int rc = TMF_RESP_FUNC_FAILED;
+	struct mvs_tmf_task tmf_task;
+
+	tmf_task.tmf = TMF_CLEAR_ACA;
+	rc = mvs_debug_issue_ssp_tmf(dev, lun, &tmf_task);
+
+	return rc;
+}
+
+int mvs_clear_task_set(struct domain_device *dev, u8 *lun)
+{
+	int rc = TMF_RESP_FUNC_FAILED;
+	struct mvs_tmf_task tmf_task;
+
+	tmf_task.tmf = TMF_CLEAR_TASK_SET;
+	rc = mvs_debug_issue_ssp_tmf(dev, lun, &tmf_task);
+
+	return rc;
 }
 
 static int mvs_sata_done(struct mvs_info *mvi, struct sas_task *task,
 			u32 slot_idx, int err)
 {
-	struct mvs_port *port = mvi->slot_info[slot_idx].port;
+	struct mvs_device *mvi_dev = (struct mvs_device *)task->dev->lldd_dev;
 	struct task_status_struct *tstat = &task->task_status;
 	struct ata_task_resp *resp = (struct ata_task_resp *)tstat->buf;
 	int stat = SAM_GOOD;
 
+
 	resp->frame_len = sizeof(struct dev_to_host_fis);
 	memcpy(&resp->ending_fis[0],
-	       SATA_RECEIVED_D2H_FIS(port->taskfileset),
+	       SATA_RECEIVED_D2H_FIS(mvi_dev->taskfileset),
 	       sizeof(struct dev_to_host_fis));
 	tstat->buf_valid_size = sizeof(*resp);
 	if (unlikely(err))
@@ -1107,75 +1729,104 @@ static int mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
 			 u32 slot_idx)
 {
 	struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
+	int stat;
 	u32 err_dw0 = le32_to_cpu(*(u32 *) (slot->response));
-	u32 err_dw1 = le32_to_cpu(*(u32 *) (slot->response + 4));
-	int stat = SAM_CHECK_COND;
+	u32 tfs = 0;
+	enum mvs_port_type type = PORT_TYPE_SAS;
 
-	if (err_dw1 & SLOT_BSY_ERR) {
-		stat = SAS_QUEUE_FULL;
-		mvs_slot_reset(mvi, task, slot_idx);
-	}
+	if (err_dw0 & CMD_ISS_STPD)
+		MVS_CHIP_DISP->issue_stop(mvi, type, tfs);
+
+	MVS_CHIP_DISP->command_active(mvi, slot_idx);
+
+	stat = SAM_CHECK_COND;
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SSP:
+		stat = SAS_ABORTED_TASK;
 		break;
 	case SAS_PROTOCOL_SMP:
+		stat = SAM_CHECK_COND;
 		break;
+
 	case SAS_PROTOCOL_SATA:
 	case SAS_PROTOCOL_STP:
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
-		if (err_dw0 & TFILE_ERR)
-			stat = mvs_sata_done(mvi, task, slot_idx, 1);
+	{
+		if (err_dw0 == 0x80400002)
+			mv_printk("find reserved error, why?\n");
+
+		task->ata_task.use_ncq = 0;
+		stat = SAS_PROTO_RESPONSE;
+		mvs_sata_done(mvi, task, slot_idx, 1);
+
+	}
 		break;
 	default:
 		break;
 	}
 
-	mvs_hexdump(16, (u8 *) slot->response, 0);
 	return stat;
 }
 
-static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
+int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 {
 	u32 slot_idx = rx_desc & RXQ_SLOT_MASK;
 	struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
 	struct sas_task *task = slot->task;
+	struct mvs_device *mvi_dev = NULL;
 	struct task_status_struct *tstat;
-	struct mvs_port *port;
+
 	bool aborted;
 	void *to;
+	enum exec_status sts;
 
+	if (mvi->exp_req)
+		mvi->exp_req--;
 	if (unlikely(!task || !task->lldd_task))
 		return -1;
 
+	tstat = &task->task_status;
+	mvi_dev = (struct mvs_device *)task->dev->lldd_dev;
+
 	mvs_hba_cq_dump(mvi);
 
 	spin_lock(&task->task_state_lock);
+	task->task_state_flags &=
+		~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
+	task->task_state_flags |= SAS_TASK_STATE_DONE;
+	/* race condition*/
 	aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
-	if (!aborted) {
-		task->task_state_flags &=
-		    ~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
-		task->task_state_flags |= SAS_TASK_STATE_DONE;
-	}
 	spin_unlock(&task->task_state_lock);
 
-	if (aborted) {
+	memset(tstat, 0, sizeof(*tstat));
+	tstat->resp = SAS_TASK_COMPLETE;
+
+	if (unlikely(aborted)) {
+		tstat->stat = SAS_ABORTED_TASK;
+		if (mvi_dev)
+			mvi_dev->runing_req--;
+		if (sas_protocol_ata(task->task_proto))
+			mvs_free_reg_set(mvi, mvi_dev);
+
 		mvs_slot_task_free(mvi, task, slot, slot_idx);
-		mvs_slot_free(mvi, rx_desc);
 		return -1;
 	}
 
-	port = slot->port;
-	tstat = &task->task_status;
-	memset(tstat, 0, sizeof(*tstat));
-	tstat->resp = SAS_TASK_COMPLETE;
-
-	if (unlikely(!port->port_attached || flags)) {
-		mvs_slot_err(mvi, task, slot_idx);
-		if (!sas_protocol_ata(task->task_proto))
-			tstat->stat = SAS_PHY_DOWN;
+	if (unlikely(!mvi_dev || !slot->port->port_attached || flags)) {
+		mv_dprintk("port has not device.\n");
+		tstat->stat = SAS_PHY_DOWN;
 		goto out;
 	}
 
+	/*
+	if (unlikely((rx_desc & RXQ_ERR) || (*(u64 *) slot->response))) {
+		 mv_dprintk("Find device[%016llx] RXQ_ERR %X,
+		 err info:%016llx\n",
+		 SAS_ADDR(task->dev->sas_addr),
+		 rx_desc, (u64)(*(u64 *) slot->response));
+	}
+	*/
+
 	/* error info record present */
 	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
 		tstat->stat = mvs_slot_err(mvi, task, slot_idx);
@@ -1191,13 +1842,10 @@ static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 		}
 		/* response frame present */
 		else if (rx_desc & RXQ_RSP) {
-			struct ssp_response_iu *iu =
-			    slot->response + sizeof(struct mvs_err_info);
-			sas_ssp_task_response(&mvi->pdev->dev, task, iu);
-		}
-
-		/* should never happen? */
-		else
+			struct ssp_response_iu *iu = slot->response +
+						sizeof(struct mvs_err_info);
+			sas_ssp_task_response(mvi->dev, task, iu);
+		} else
 			tstat->stat = SAM_CHECK_COND;
 		break;
 
@@ -1225,105 +1873,245 @@ static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 	}
 
 out:
+	if (mvi_dev)
+		mvi_dev->runing_req--;
+	if (sas_protocol_ata(task->task_proto))
+		mvs_free_reg_set(mvi, mvi_dev);
+
 	mvs_slot_task_free(mvi, task, slot, slot_idx);
-	if (unlikely(tstat->stat != SAS_QUEUE_FULL))
-		mvs_slot_free(mvi, rx_desc);
+	sts = tstat->stat;
 
 	spin_unlock(&mvi->lock);
-	task->task_done(task);
+	if (task->task_done)
+		task->task_done(task);
+	else
+		mv_dprintk("why has not task_done.\n");
 	spin_lock(&mvi->lock);
-	return tstat->stat;
+
+	return sts;
 }
 
-static void mvs_release_task(struct mvs_info *mvi, int phy_no)
+void mvs_release_task(struct mvs_info *mvi,
+		int phy_no, struct domain_device *dev)
 {
-	struct list_head *pos, *n;
-	struct mvs_slot_info *slot;
-	struct mvs_phy *phy = &mvi->phy[phy_no];
-	struct mvs_port *port = phy->port;
-	u32 rx_desc;
+	int i = 0; u32 slot_idx;
+	struct mvs_phy *phy;
+	struct mvs_port *port;
+	struct mvs_slot_info *slot, *slot2;
 
+	phy = &mvi->phy[phy_no];
+	port = phy->port;
 	if (!port)
 		return;
 
-	list_for_each_safe(pos, n, &port->list) {
-		slot = container_of(pos, struct mvs_slot_info, list);
-		rx_desc = (u32) (slot - mvi->slot_info);
-		mvs_slot_complete(mvi, rx_desc, 1);
+	list_for_each_entry_safe(slot, slot2, &port->list, entry) {
+		struct sas_task *task;
+		slot_idx = (u32) (slot - mvi->slot_info);
+		task = slot->task;
+
+		if (dev && task->dev != dev)
+			continue;
+
+		mv_printk("Release slot [%x] tag[%x], task [%p]:\n",
+			slot_idx, slot->slot_tag, task);
+
+		if (task->task_proto & SAS_PROTOCOL_SSP) {
+			mv_printk("attached with SSP task CDB[");
+			for (i = 0; i < 16; i++)
+				mv_printk(" %02x", task->ssp_task.cdb[i]);
+			mv_printk(" ]\n");
+		}
+
+		mvs_slot_complete(mvi, slot_idx, 1);
+	}
+}
+
+static void mvs_phy_disconnected(struct mvs_phy *phy)
+{
+	phy->phy_attached = 0;
+	phy->att_dev_info = 0;
+	phy->att_dev_sas_addr = 0;
+}
+
+static void mvs_work_queue(struct work_struct *work)
+{
+	struct delayed_work *dw = container_of(work, struct delayed_work, work);
+	struct mvs_wq *mwq = container_of(dw, struct mvs_wq, work_q);
+	struct mvs_info *mvi = mwq->mvi;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mvi->lock, flags);
+	if (mwq->handler & PHY_PLUG_EVENT) {
+		u32 phy_no = (unsigned long) mwq->data;
+		struct sas_ha_struct *sas_ha = mvi->sas;
+		struct mvs_phy *phy = &mvi->phy[phy_no];
+		struct asd_sas_phy *sas_phy = &phy->sas_phy;
+
+		if (phy->phy_event & PHY_PLUG_OUT) {
+			u32 tmp;
+			struct sas_identify_frame *id;
+			id = (struct sas_identify_frame *)phy->frame_rcvd;
+			tmp = MVS_CHIP_DISP->read_phy_ctl(mvi, phy_no);
+			phy->phy_event &= ~PHY_PLUG_OUT;
+			if (!(tmp & PHY_READY_MASK)) {
+				sas_phy_disconnected(sas_phy);
+				mvs_phy_disconnected(phy);
+				sas_ha->notify_phy_event(sas_phy,
+					PHYE_LOSS_OF_SIGNAL);
+				mv_dprintk("phy%d Removed Device\n", phy_no);
+			} else {
+				MVS_CHIP_DISP->detect_porttype(mvi, phy_no);
+				mvs_update_phyinfo(mvi, phy_no, 1);
+				mvs_bytes_dmaed(mvi, phy_no);
+				mvs_port_notify_formed(sas_phy, 0);
+				mv_dprintk("phy%d Attached Device\n", phy_no);
+			}
+		}
+	}
+	list_del(&mwq->entry);
+	spin_unlock_irqrestore(&mvi->lock, flags);
+	kfree(mwq);
+}
+
+static int mvs_handle_event(struct mvs_info *mvi, void *data, int handler)
+{
+	struct mvs_wq *mwq;
+	int ret = 0;
+
+	mwq = kmalloc(sizeof(struct mvs_wq), GFP_ATOMIC);
+	if (mwq) {
+		mwq->mvi = mvi;
+		mwq->data = data;
+		mwq->handler = handler;
+		MV_INIT_DELAYED_WORK(&mwq->work_q, mvs_work_queue, mwq);
+		list_add_tail(&mwq->entry, &mvi->wq_list);
+		schedule_delayed_work(&mwq->work_q, HZ * 2);
+	} else
+		ret = -ENOMEM;
+
+	return ret;
+}
+
+static void mvs_sig_time_out(unsigned long tphy)
+{
+	struct mvs_phy *phy = (struct mvs_phy *)tphy;
+	struct mvs_info *mvi = phy->mvi;
+	u8 phy_no;
+
+	for (phy_no = 0; phy_no < mvi->chip->n_phy; phy_no++) {
+		if (&mvi->phy[phy_no] == phy) {
+			mv_dprintk("Get signature time out, reset phy %d\n",
+				phy_no+mvi->id*mvi->chip->n_phy);
+			MVS_CHIP_DISP->phy_reset(mvi, phy_no, 1);
+		}
 	}
 }
 
-static void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
+static void mvs_sig_remove_timer(struct mvs_phy *phy)
 {
-	struct pci_dev *pdev = mvi->pdev;
-	struct sas_ha_struct *sas_ha = &mvi->sas;
+	if (phy->timer.function)
+		del_timer(&phy->timer);
+	phy->timer.function = NULL;
+}
+
+void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
+{
+	u32 tmp;
+	struct sas_ha_struct *sas_ha = mvi->sas;
 	struct mvs_phy *phy = &mvi->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 
-	phy->irq_status = mvs_read_port_irq_stat(mvi, phy_no);
+	phy->irq_status = MVS_CHIP_DISP->read_port_irq_stat(mvi, phy_no);
+	mv_dprintk("port %d ctrl sts=0x%X.\n", phy_no+mvi->id*mvi->chip->n_phy,
+		MVS_CHIP_DISP->read_phy_ctl(mvi, phy_no));
+	mv_dprintk("Port %d irq sts = 0x%X\n", phy_no+mvi->id*mvi->chip->n_phy,
+		phy->irq_status);
+
 	/*
 	* events is port event now ,
 	* we need check the interrupt status which belongs to per port.
 	*/
-	dev_printk(KERN_DEBUG, &pdev->dev,
-		"Port %d Event = %X\n",
-		phy_no, phy->irq_status);
-
-	if (phy->irq_status & (PHYEV_POOF | PHYEV_DEC_ERR)) {
-		mvs_release_task(mvi, phy_no);
-		if (!mvs_is_phy_ready(mvi, phy_no)) {
-			sas_phy_disconnected(sas_phy);
-			sas_ha->notify_phy_event(sas_phy, PHYE_LOSS_OF_SIGNAL);
-			dev_printk(KERN_INFO, &pdev->dev,
-				"Port %d Unplug Notice\n", phy_no);
 
-		} else
-			mvs_phy_control(sas_phy, PHY_FUNC_LINK_RESET, NULL);
-	}
-	if (!(phy->irq_status & PHYEV_DEC_ERR)) {
-		if (phy->irq_status & PHYEV_COMWAKE) {
-			u32 tmp = mvs_read_port_irq_mask(mvi, phy_no);
-			mvs_write_port_irq_mask(mvi, phy_no,
-						tmp | PHYEV_SIG_FIS);
+	if (phy->irq_status & PHYEV_DCDR_ERR)
+		mv_dprintk("port %d STP decoding error.\n",
+		phy_no+mvi->id*mvi->chip->n_phy);
+
+	if (phy->irq_status & PHYEV_POOF) {
+		if (!(phy->phy_event & PHY_PLUG_OUT)) {
+			int dev_sata = phy->phy_type & PORT_TYPE_SATA;
+			int ready;
+			mvs_release_task(mvi, phy_no, NULL);
+			phy->phy_event |= PHY_PLUG_OUT;
+			mvs_handle_event(mvi,
+				(void *)(unsigned long)phy_no,
+				PHY_PLUG_EVENT);
+			ready = mvs_is_phy_ready(mvi, phy_no);
+			if (!ready)
+				mv_dprintk("phy%d Unplug Notice\n",
+					phy_no +
+					mvi->id * mvi->chip->n_phy);
+			if (ready || dev_sata) {
+				if (MVS_CHIP_DISP->stp_reset)
+					MVS_CHIP_DISP->stp_reset(mvi,
+							phy_no);
+				else
+					MVS_CHIP_DISP->phy_reset(mvi,
+							phy_no, 0);
+				return;
+			}
 		}
-		if (phy->irq_status & (PHYEV_SIG_FIS | PHYEV_ID_DONE)) {
-			phy->phy_status = mvs_is_phy_ready(mvi, phy_no);
-			if (phy->phy_status) {
-				mvs_detect_porttype(mvi, phy_no);
-
-				if (phy->phy_type & PORT_TYPE_SATA) {
-					u32 tmp = mvs_read_port_irq_mask(mvi,
-								phy_no);
-					tmp &= ~PHYEV_SIG_FIS;
-					mvs_write_port_irq_mask(mvi,
-								phy_no, tmp);
-				}
+	}
 
-				mvs_update_phyinfo(mvi, phy_no, 0);
-				sas_ha->notify_phy_event(sas_phy,
-							PHYE_OOB_DONE);
-				mvs_bytes_dmaed(mvi, phy_no);
-			} else {
-				dev_printk(KERN_DEBUG, &pdev->dev,
-					"plugin interrupt but phy is gone\n");
-				mvs_phy_control(sas_phy, PHY_FUNC_LINK_RESET,
-							NULL);
+	if (phy->irq_status & PHYEV_COMWAKE) {
+		tmp = MVS_CHIP_DISP->read_port_irq_mask(mvi, phy_no);
+		MVS_CHIP_DISP->write_port_irq_mask(mvi, phy_no,
+					tmp | PHYEV_SIG_FIS);
+		if (phy->timer.function == NULL) {
+			phy->timer.data = (unsigned long)phy;
+			phy->timer.function = mvs_sig_time_out;
+			phy->timer.expires = jiffies + 10*HZ;
+			add_timer(&phy->timer);
+		}
+	}
+	if (phy->irq_status & (PHYEV_SIG_FIS | PHYEV_ID_DONE)) {
+		phy->phy_status = mvs_is_phy_ready(mvi, phy_no);
+		mvs_sig_remove_timer(phy);
+		mv_dprintk("notify plug in on phy[%d]\n", phy_no);
+		if (phy->phy_status) {
+			mdelay(10);
+			MVS_CHIP_DISP->detect_porttype(mvi, phy_no);
+			if (phy->phy_type & PORT_TYPE_SATA) {
+				tmp = MVS_CHIP_DISP->read_port_irq_mask(
+						mvi, phy_no);
+				tmp &= ~PHYEV_SIG_FIS;
+				MVS_CHIP_DISP->write_port_irq_mask(mvi,
+							phy_no, tmp);
+			}
+			mvs_update_phyinfo(mvi, phy_no, 0);
+			mvs_bytes_dmaed(mvi, phy_no);
+			/* whether driver is going to handle hot plug */
+			if (phy->phy_event & PHY_PLUG_OUT) {
+				mvs_port_notify_formed(sas_phy, 0);
+				phy->phy_event &= ~PHY_PLUG_OUT;
 			}
-		} else if (phy->irq_status & PHYEV_BROAD_CH) {
-			mvs_release_task(mvi, phy_no);
-			sas_ha->notify_port_event(sas_phy,
-						PORTE_BROADCAST_RCVD);
+		} else {
+			mv_dprintk("plugin interrupt but phy%d is gone\n",
+				phy_no + mvi->id*mvi->chip->n_phy);
 		}
+	} else if (phy->irq_status & PHYEV_BROAD_CH) {
+		mv_dprintk("port %d broadcast change.\n",
+			phy_no + mvi->id*mvi->chip->n_phy);
+		/* exception for Samsung disk drive*/
+		mdelay(1000);
+		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 	}
-	mvs_write_port_irq_stat(mvi, phy_no, phy->irq_status);
+	MVS_CHIP_DISP->write_port_irq_stat(mvi, phy_no, phy->irq_status);
 }
 
-static int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
+int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
 {
-	void __iomem *regs = mvi->regs;
 	u32 rx_prod_idx, rx_desc;
 	bool attn = false;
-	struct pci_dev *pdev = mvi->pdev;
 
 	/* the first dword in the RX ring is special: it contains
 	 * a mirror of the hardware's RX producer index, so that
@@ -1339,480 +2127,31 @@ static int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
 	* note: if coalescing is enabled,
 	* it will need to read from register every time for sure
 	*/
-	if (mvi->rx_cons == rx_prod_idx)
-		mvi->rx_cons = mr32(RX_CONS_IDX) & RX_RING_SZ_MASK;
+	if (unlikely(mvi->rx_cons == rx_prod_idx))
+		mvi->rx_cons = MVS_CHIP_DISP->rx_update(mvi) & RX_RING_SZ_MASK;
 
 	if (mvi->rx_cons == rx_prod_idx)
 		return 0;
 
 	while (mvi->rx_cons != rx_prod_idx) {
-
 		/* increment our internal RX consumer pointer */
 		rx_prod_idx = (rx_prod_idx + 1) & (MVS_RX_RING_SZ - 1);
-
 		rx_desc = le32_to_cpu(mvi->rx[rx_prod_idx + 1]);
 
 		if (likely(rx_desc & RXQ_DONE))
 			mvs_slot_complete(mvi, rx_desc, 0);
 		if (rx_desc & RXQ_ATTN) {
 			attn = true;
-			dev_printk(KERN_DEBUG, &pdev->dev, "ATTN %X\n",
-				rx_desc);
 		} else if (rx_desc & RXQ_ERR) {
 			if (!(rx_desc & RXQ_DONE))
 				mvs_slot_complete(mvi, rx_desc, 0);
-			dev_printk(KERN_DEBUG, &pdev->dev, "RXQ_ERR %X\n",
-				rx_desc);
 		} else if (rx_desc & RXQ_SLOT_RESET) {
-			dev_printk(KERN_DEBUG, &pdev->dev, "Slot reset[%X]\n",
-				rx_desc);
 			mvs_slot_free(mvi, rx_desc);
 		}
 	}
 
 	if (attn && self_clear)
-		mvs_int_full(mvi);
-
+		MVS_CHIP_DISP->int_full(mvi);
 	return 0;
 }
 
-#ifndef MVS_DISABLE_NVRAM
-static int mvs_eep_read(void __iomem *regs, u32 addr, u32 *data)
-{
-	int timeout = 1000;
-
-	if (addr & ~SPI_ADDR_MASK)
-		return -EINVAL;
-
-	writel(addr, regs + SPI_CMD);
-	writel(TWSI_RD, regs + SPI_CTL);
-
-	while (timeout-- > 0) {
-		if (readl(regs + SPI_CTL) & TWSI_RDY) {
-			*data = readl(regs + SPI_DATA);
-			return 0;
-		}
-
-		udelay(10);
-	}
-
-	return -EBUSY;
-}
-
-static int mvs_eep_read_buf(void __iomem *regs, u32 addr,
-			    void *buf, u32 buflen)
-{
-	u32 addr_end, tmp_addr, i, j;
-	u32 tmp = 0;
-	int rc;
-	u8 *tmp8, *buf8 = buf;
-
-	addr_end = addr + buflen;
-	tmp_addr = ALIGN(addr, 4);
-	if (addr > 0xff)
-		return -EINVAL;
-
-	j = addr & 0x3;
-	if (j) {
-		rc = mvs_eep_read(regs, tmp_addr, &tmp);
-		if (rc)
-			return rc;
-
-		tmp8 = (u8 *)&tmp;
-		for (i = j; i < 4; i++)
-			*buf8++ = tmp8[i];
-
-		tmp_addr += 4;
-	}
-
-	for (j = ALIGN(addr_end, 4); tmp_addr < j; tmp_addr += 4) {
-		rc = mvs_eep_read(regs, tmp_addr, &tmp);
-		if (rc)
-			return rc;
-
-		memcpy(buf8, &tmp, 4);
-		buf8 += 4;
-	}
-
-	if (tmp_addr < addr_end) {
-		rc = mvs_eep_read(regs, tmp_addr, &tmp);
-		if (rc)
-			return rc;
-
-		tmp8 = (u8 *)&tmp;
-		j = addr_end - tmp_addr;
-		for (i = 0; i < j; i++)
-			*buf8++ = tmp8[i];
-
-		tmp_addr += 4;
-	}
-
-	return 0;
-}
-#endif
-
-int mvs_nvram_read(struct mvs_info *mvi, u32 addr, void *buf, u32 buflen)
-{
-#ifndef MVS_DISABLE_NVRAM
-	void __iomem *regs = mvi->regs;
-	int rc, i;
-	u32 sum;
-	u8 hdr[2], *tmp;
-	const char *msg;
-
-	rc = mvs_eep_read_buf(regs, addr, &hdr, 2);
-	if (rc) {
-		msg = "nvram hdr read failed";
-		goto err_out;
-	}
-	rc = mvs_eep_read_buf(regs, addr + 2, buf, buflen);
-	if (rc) {
-		msg = "nvram read failed";
-		goto err_out;
-	}
-
-	if (hdr[0] != 0x5A) {
-		/* entry id */
-		msg = "invalid nvram entry id";
-		rc = -ENOENT;
-		goto err_out;
-	}
-
-	tmp = buf;
-	sum = ((u32)hdr[0]) + ((u32)hdr[1]);
-	for (i = 0; i < buflen; i++)
-		sum += ((u32)tmp[i]);
-
-	if (sum) {
-		msg = "nvram checksum failure";
-		rc = -EILSEQ;
-		goto err_out;
-	}
-
-	return 0;
-
-err_out:
-	dev_printk(KERN_ERR, &mvi->pdev->dev, "%s", msg);
-	return rc;
-#else
-	/* FIXME , For SAS target mode */
-	memcpy(buf, "\x50\x05\x04\x30\x11\xab\x00\x00", 8);
-	return 0;
-#endif
-}
-
-static void mvs_int_sata(struct mvs_info *mvi)
-{
-	u32 tmp;
-	void __iomem *regs = mvi->regs;
-	tmp = mr32(INT_STAT_SRS);
-	mw32(INT_STAT_SRS, tmp & 0xFFFF);
-}
-
-static void mvs_slot_reset(struct mvs_info *mvi, struct sas_task *task,
-				u32 slot_idx)
-{
-	void __iomem *regs = mvi->regs;
-	struct domain_device *dev = task->dev;
-	struct asd_sas_port *sas_port = dev->port;
-	struct mvs_port *port = mvi->slot_info[slot_idx].port;
-	u32 reg_set, phy_mask;
-
-	if (!sas_protocol_ata(task->task_proto)) {
-		reg_set = 0;
-		phy_mask = (port->wide_port_phymap) ? port->wide_port_phymap :
-				sas_port->phy_mask;
-	} else {
-		reg_set = port->taskfileset;
-		phy_mask = sas_port->phy_mask;
-	}
-	mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | slot_idx |
-					(TXQ_CMD_SLOT_RESET << TXQ_CMD_SHIFT) |
-					(phy_mask << TXQ_PHY_SHIFT) |
-					(reg_set << TXQ_SRS_SHIFT));
-
-	mw32(TX_PROD_IDX, mvi->tx_prod);
-	mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_CHIP_SLOT_SZ - 1);
-}
-
-void mvs_int_full(struct mvs_info *mvi)
-{
-	void __iomem *regs = mvi->regs;
-	u32 tmp, stat;
-	int i;
-
-	stat = mr32(INT_STAT);
-
-	mvs_int_rx(mvi, false);
-
-	for (i = 0; i < MVS_MAX_PORTS; i++) {
-		tmp = (stat >> i) & (CINT_PORT | CINT_PORT_STOPPED);
-		if (tmp)
-			mvs_int_port(mvi, i, tmp);
-	}
-
-	if (stat & CINT_SRS)
-		mvs_int_sata(mvi);
-
-	mw32(INT_STAT, stat);
-}
-
-#ifndef MVS_DISABLE_MSI
-static irqreturn_t mvs_msi_interrupt(int irq, void *opaque)
-{
-	struct mvs_info *mvi = opaque;
-
-#ifndef MVS_USE_TASKLET
-	spin_lock(&mvi->lock);
-
-	mvs_int_rx(mvi, true);
-
-	spin_unlock(&mvi->lock);
-#else
-	tasklet_schedule(&mvi->tasklet);
-#endif
-	return IRQ_HANDLED;
-}
-#endif
-
-int mvs_task_abort(struct sas_task *task)
-{
-	int rc;
-	unsigned long flags;
-	struct mvs_info *mvi = task->dev->port->ha->lldd_ha;
-	struct pci_dev *pdev = mvi->pdev;
-	int tag;
-
-	spin_lock_irqsave(&task->task_state_lock, flags);
-	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
-		rc = TMF_RESP_FUNC_COMPLETE;
-		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		goto out_done;
-	}
-	spin_unlock_irqrestore(&task->task_state_lock, flags);
-
-	switch (task->task_proto) {
-	case SAS_PROTOCOL_SMP:
-		dev_printk(KERN_DEBUG, &pdev->dev, "SMP Abort! \n");
-		break;
-	case SAS_PROTOCOL_SSP:
-		dev_printk(KERN_DEBUG, &pdev->dev, "SSP Abort! \n");
-		break;
-	case SAS_PROTOCOL_SATA:
-	case SAS_PROTOCOL_STP:
-	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:{
-		dev_printk(KERN_DEBUG, &pdev->dev, "STP Abort! \n");
-#if _MV_DUMP
-		dev_printk(KERN_DEBUG, &pdev->dev, "Dump D2H FIS: \n");
-		mvs_hexdump(sizeof(struct host_to_dev_fis),
-				(void *)&task->ata_task.fis, 0);
-		dev_printk(KERN_DEBUG, &pdev->dev, "Dump ATAPI Cmd : \n");
-		mvs_hexdump(16, task->ata_task.atapi_packet, 0);
-#endif
-		spin_lock_irqsave(&task->task_state_lock, flags);
-		if (task->task_state_flags & SAS_TASK_NEED_DEV_RESET) {
-			/* TODO */
-			;
-		}
-		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		break;
-	}
-	default:
-		break;
-	}
-
-	if (mvs_find_tag(mvi, task, &tag)) {
-		spin_lock_irqsave(&mvi->lock, flags);
-		mvs_slot_task_free(mvi, task, &mvi->slot_info[tag], tag);
-		spin_unlock_irqrestore(&mvi->lock, flags);
-	}
-	if (!mvs_task_exec(task, 1, GFP_ATOMIC))
-		rc = TMF_RESP_FUNC_COMPLETE;
-	else
-		rc = TMF_RESP_FUNC_FAILED;
-out_done:
-	return rc;
-}
-
-int __devinit mvs_hw_init(struct mvs_info *mvi)
-{
-	void __iomem *regs = mvi->regs;
-	int i;
-	u32 tmp, cctl;
-
-	/* make sure interrupts are masked immediately (paranoia) */
-	mw32(GBL_CTL, 0);
-	tmp = mr32(GBL_CTL);
-
-	/* Reset Controller */
-	if (!(tmp & HBA_RST)) {
-		if (mvi->flags & MVF_PHY_PWR_FIX) {
-			pci_read_config_dword(mvi->pdev, PCR_PHY_CTL, &tmp);
-			tmp &= ~PCTL_PWR_ON;
-			tmp |= PCTL_OFF;
-			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL, tmp);
-
-			pci_read_config_dword(mvi->pdev, PCR_PHY_CTL2, &tmp);
-			tmp &= ~PCTL_PWR_ON;
-			tmp |= PCTL_OFF;
-			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL2, tmp);
-		}
-
-		/* global reset, incl. COMRESET/H_RESET_N (self-clearing) */
-		mw32_f(GBL_CTL, HBA_RST);
-	}
-
-	/* wait for reset to finish; timeout is just a guess */
-	i = 1000;
-	while (i-- > 0) {
-		msleep(10);
-
-		if (!(mr32(GBL_CTL) & HBA_RST))
-			break;
-	}
-	if (mr32(GBL_CTL) & HBA_RST) {
-		dev_printk(KERN_ERR, &mvi->pdev->dev, "HBA reset failed\n");
-		return -EBUSY;
-	}
-
-	/* Init Chip */
-	/* make sure RST is set; HBA_RST /should/ have done that for us */
-	cctl = mr32(CTL);
-	if (cctl & CCTL_RST)
-		cctl &= ~CCTL_RST;
-	else
-		mw32_f(CTL, cctl | CCTL_RST);
-
-	/* write to device control _AND_ device status register? - A.C. */
-	pci_read_config_dword(mvi->pdev, PCR_DEV_CTRL, &tmp);
-	tmp &= ~PRD_REQ_MASK;
-	tmp |= PRD_REQ_SIZE;
-	pci_write_config_dword(mvi->pdev, PCR_DEV_CTRL, tmp);
-
-	pci_read_config_dword(mvi->pdev, PCR_PHY_CTL, &tmp);
-	tmp |= PCTL_PWR_ON;
-	tmp &= ~PCTL_OFF;
-	pci_write_config_dword(mvi->pdev, PCR_PHY_CTL, tmp);
-
-	pci_read_config_dword(mvi->pdev, PCR_PHY_CTL2, &tmp);
-	tmp |= PCTL_PWR_ON;
-	tmp &= ~PCTL_OFF;
-	pci_write_config_dword(mvi->pdev, PCR_PHY_CTL2, tmp);
-
-	mw32_f(CTL, cctl);
-
-	/* reset control */
-	mw32(PCS, 0);		/*MVS_PCS */
-
-	mvs_phy_hacks(mvi);
-
-	mw32(CMD_LIST_LO, mvi->slot_dma);
-	mw32(CMD_LIST_HI, (mvi->slot_dma >> 16) >> 16);
-
-	mw32(RX_FIS_LO, mvi->rx_fis_dma);
-	mw32(RX_FIS_HI, (mvi->rx_fis_dma >> 16) >> 16);
-
-	mw32(TX_CFG, MVS_CHIP_SLOT_SZ);
-	mw32(TX_LO, mvi->tx_dma);
-	mw32(TX_HI, (mvi->tx_dma >> 16) >> 16);
-
-	mw32(RX_CFG, MVS_RX_RING_SZ);
-	mw32(RX_LO, mvi->rx_dma);
-	mw32(RX_HI, (mvi->rx_dma >> 16) >> 16);
-
-	/* enable auto port detection */
-	mw32(GBL_PORT_TYPE, MODE_AUTO_DET_EN);
-	msleep(1100);
-	/* init and reset phys */
-	for (i = 0; i < mvi->chip->n_phy; i++) {
-		u32 lo = be32_to_cpu(*(u32 *)&mvi->sas_addr[4]);
-		u32 hi = be32_to_cpu(*(u32 *)&mvi->sas_addr[0]);
-
-		mvs_detect_porttype(mvi, i);
-
-		/* set phy local SAS address */
-		mvs_write_port_cfg_addr(mvi, i, PHYR_ADDR_LO);
-		mvs_write_port_cfg_data(mvi, i, lo);
-		mvs_write_port_cfg_addr(mvi, i, PHYR_ADDR_HI);
-		mvs_write_port_cfg_data(mvi, i, hi);
-
-		/* reset phy */
-		tmp = mvs_read_phy_ctl(mvi, i);
-		tmp |= PHY_RST;
-		mvs_write_phy_ctl(mvi, i, tmp);
-	}
-
-	msleep(100);
-
-	for (i = 0; i < mvi->chip->n_phy; i++) {
-		/* clear phy int status */
-		tmp = mvs_read_port_irq_stat(mvi, i);
-		tmp &= ~PHYEV_SIG_FIS;
-		mvs_write_port_irq_stat(mvi, i, tmp);
-
-		/* set phy int mask */
-		tmp = PHYEV_RDY_CH | PHYEV_BROAD_CH | PHYEV_UNASSOC_FIS |
-			PHYEV_ID_DONE | PHYEV_DEC_ERR;
-		mvs_write_port_irq_mask(mvi, i, tmp);
-
-		msleep(100);
-		mvs_update_phyinfo(mvi, i, 1);
-		mvs_enable_xmt(mvi, i);
-	}
-
-	/* FIXME: update wide port bitmaps */
-
-	/* little endian for open address and command table, etc. */
-	/* A.C.
-	 * it seems that ( from the spec ) turning on big-endian won't
-	 * do us any good on big-endian machines, need further confirmation
-	 */
-	cctl = mr32(CTL);
-	cctl |= CCTL_ENDIAN_CMD;
-	cctl |= CCTL_ENDIAN_DATA;
-	cctl &= ~CCTL_ENDIAN_OPEN;
-	cctl |= CCTL_ENDIAN_RSP;
-	mw32_f(CTL, cctl);
-
-	/* reset CMD queue */
-	tmp = mr32(PCS);
-	tmp |= PCS_CMD_RST;
-	mw32(PCS, tmp);
-	/* interrupt coalescing may cause missing HW interrput in some case,
-	 * and the max count is 0x1ff, while our max slot is 0x200,
-	 * it will make count 0.
-	 */
-	tmp = 0;
-	mw32(INT_COAL, tmp);
-
-	tmp = 0x100;
-	mw32(INT_COAL_TMOUT, tmp);
-
-	/* ladies and gentlemen, start your engines */
-	mw32(TX_CFG, 0);
-	mw32(TX_CFG, MVS_CHIP_SLOT_SZ | TX_EN);
-	mw32(RX_CFG, MVS_RX_RING_SZ | RX_EN);
-	/* enable CMD/CMPL_Q/RESP mode */
-	mw32(PCS, PCS_SATA_RETRY | PCS_FIS_RX_EN | PCS_CMD_EN);
-
-	/* enable completion queue interrupt */
-	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM | CINT_SRS);
-	mw32(INT_MASK, tmp);
-
-	/* Enable SRS interrupt */
-	mw32(INT_MASK_SRS, 0xFF);
-	return 0;
-}
-
-void __devinit mvs_print_info(struct mvs_info *mvi)
-{
-	struct pci_dev *pdev = mvi->pdev;
-	static int printed_version;
-
-	if (!printed_version++)
-		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
-
-	dev_printk(KERN_INFO, &pdev->dev, "%u phys, addr %llx\n",
-		   mvi->chip->n_phy, SAS_ADDR(mvi->sas_addr));
-}
-
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 7a954a9..75b9748 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -1,25 +1,26 @@
 /*
-	mv_sas.h - Marvell 88SE6440 SAS/SATA support
-
-	Copyright 2007 Red Hat, Inc.
-	Copyright 2008 Marvell. <kewei@marvell.com>
-
-	This program is free software; you can redistribute it and/or
-	modify it under the terms of the GNU General Public License as
-	published by the Free Software Foundation; either version 2,
-	or (at your option) any later version.
-
-	This program is distributed in the hope that it will be useful,
-	but WITHOUT ANY WARRANTY; without even the implied warranty
-	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-	See the GNU General Public License for more details.
-
-	You should have received a copy of the GNU General Public
-	License along with this program; see the file COPYING.	If not,
-	write to the Free Software Foundation, 675 Mass Ave, Cambridge,
-	MA 02139, USA.
-
- */
+ * Marvell 88SE64xx/88SE94xx main function head file
+ *
+ * Copyright 2007 Red Hat, Inc.
+ * Copyright 2008 Marvell. <kewei@marvell.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 of the
+ * License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+*/
 
 #ifndef _MV_SAS_H_
 #define _MV_SAS_H_
@@ -42,25 +43,144 @@
 #include <linux/version.h>
 #include "mv_defs.h"
 
-#define DRV_NAME	"mvsas"
-#define DRV_VERSION	"0.5.2"
-#define _MV_DUMP	0
-#define MVS_DISABLE_NVRAM
-#define MVS_DISABLE_MSI
-
+#define DRV_NAME		"mvsas"
+#define DRV_VERSION		"0.8.2"
+#define _MV_DUMP		0
 #define MVS_ID_NOT_MAPPED	0x7f
-#define MVS_CHIP_SLOT_SZ	(1U << mvi->chip->slot_width)
+/* #define DISABLE_HOTPLUG_DMA_FIX */
+#define MAX_EXP_RUNNING_REQ	2
+#define WIDE_PORT_MAX_PHY		4
+#define	MV_DISABLE_NCQ	0
+#define mv_printk(fmt, arg ...)	\
+	printk(KERN_DEBUG"%s %d:" fmt, __FILE__, __LINE__, ## arg)
+#ifdef MV_DEBUG
+#define mv_dprintk(format, arg...)	\
+	printk(KERN_DEBUG"%s %d:" format, __FILE__, __LINE__, ## arg)
+#else
+#define mv_dprintk(format, arg...)
+#endif
+#define MV_MAX_U32			0xffffffff
+
+extern struct mvs_tgt_initiator mvs_tgt;
+extern struct mvs_info *tgt_mvi;
+extern const struct mvs_dispatch mvs_64xx_dispatch;
+extern const struct mvs_dispatch mvs_94xx_dispatch;
+
+#define DEV_IS_EXPANDER(type)	\
+	((type == EDGE_DEV) || (type == FANOUT_DEV))
 
-#define for_each_phy(__lseq_mask, __mc, __lseq, __rest)			\
-	for ((__mc) = (__lseq_mask), (__lseq) = 0;			\
-					(__mc) != 0 && __rest;		\
+#define bit(n) ((u32)1 << n)
+
+#define for_each_phy(__lseq_mask, __mc, __lseq)			\
+	for ((__mc) = (__lseq_mask), (__lseq) = 0;		\
+					(__mc) != 0 ;		\
 					(++__lseq), (__mc) >>= 1)
 
+#define MV_INIT_DELAYED_WORK(w, f, d)	INIT_DELAYED_WORK(w, f)
+#define UNASSOC_D2H_FIS(id)		\
+	((void *) mvi->rx_fis + 0x100 * id)
+#define SATA_RECEIVED_FIS_LIST(reg_set)	\
+	((void *) mvi->rx_fis + mvi->chip->fis_offs + 0x100 * reg_set)
+#define SATA_RECEIVED_SDB_FIS(reg_set)	\
+	(SATA_RECEIVED_FIS_LIST(reg_set) + 0x58)
+#define SATA_RECEIVED_D2H_FIS(reg_set)	\
+	(SATA_RECEIVED_FIS_LIST(reg_set) + 0x40)
+#define SATA_RECEIVED_PIO_FIS(reg_set)	\
+	(SATA_RECEIVED_FIS_LIST(reg_set) + 0x20)
+#define SATA_RECEIVED_DMA_FIS(reg_set)	\
+	(SATA_RECEIVED_FIS_LIST(reg_set) + 0x00)
+
+enum dev_status {
+	MVS_DEV_NORMAL = 0x0,
+	MVS_DEV_EH	= 0x1,
+};
+
+
+struct mvs_info;
+
+struct mvs_dispatch {
+	char *name;
+	int (*chip_init)(struct mvs_info *mvi);
+	int (*spi_init)(struct mvs_info *mvi);
+	int (*chip_ioremap)(struct mvs_info *mvi);
+	void (*chip_iounmap)(struct mvs_info *mvi);
+	irqreturn_t (*isr)(struct mvs_info *mvi, int irq, u32 stat);
+	u32 (*isr_status)(struct mvs_info *mvi, int irq);
+	void (*interrupt_enable)(struct mvs_info *mvi);
+	void (*interrupt_disable)(struct mvs_info *mvi);
+
+	u32 (*read_phy_ctl)(struct mvs_info *mvi, u32 port);
+	void (*write_phy_ctl)(struct mvs_info *mvi, u32 port, u32 val);
+
+	u32 (*read_port_cfg_data)(struct mvs_info *mvi, u32 port);
+	void (*write_port_cfg_data)(struct mvs_info *mvi, u32 port, u32 val);
+	void (*write_port_cfg_addr)(struct mvs_info *mvi, u32 port, u32 addr);
+
+	u32 (*read_port_vsr_data)(struct mvs_info *mvi, u32 port);
+	void (*write_port_vsr_data)(struct mvs_info *mvi, u32 port, u32 val);
+	void (*write_port_vsr_addr)(struct mvs_info *mvi, u32 port, u32 addr);
+
+	u32 (*read_port_irq_stat)(struct mvs_info *mvi, u32 port);
+	void (*write_port_irq_stat)(struct mvs_info *mvi, u32 port, u32 val);
+
+	u32 (*read_port_irq_mask)(struct mvs_info *mvi, u32 port);
+	void (*write_port_irq_mask)(struct mvs_info *mvi, u32 port, u32 val);
+
+	void (*get_sas_addr)(void *buf, u32 buflen);
+	void (*command_active)(struct mvs_info *mvi, u32 slot_idx);
+	void (*issue_stop)(struct mvs_info *mvi, enum mvs_port_type type,
+				u32 tfs);
+	void (*start_delivery)(struct mvs_info *mvi, u32 tx);
+	u32 (*rx_update)(struct mvs_info *mvi);
+	void (*int_full)(struct mvs_info *mvi);
+	u8 (*assign_reg_set)(struct mvs_info *mvi, u8 *tfs);
+	void (*free_reg_set)(struct mvs_info *mvi, u8 *tfs);
+	u32 (*prd_size)(void);
+	u32 (*prd_count)(void);
+	void (*make_prd)(struct scatterlist *scatter, int nr, void *prd);
+	void (*detect_porttype)(struct mvs_info *mvi, int i);
+	int (*oob_done)(struct mvs_info *mvi, int i);
+	void (*fix_phy_info)(struct mvs_info *mvi, int i,
+				struct sas_identify_frame *id);
+	void (*phy_work_around)(struct mvs_info *mvi, int i);
+	void (*phy_set_link_rate)(struct mvs_info *mvi, u32 phy_id,
+				struct sas_phy_linkrates *rates);
+	u32 (*phy_max_link_rate)(void);
+	void (*phy_disable)(struct mvs_info *mvi, u32 phy_id);
+	void (*phy_enable)(struct mvs_info *mvi, u32 phy_id);
+	void (*phy_reset)(struct mvs_info *mvi, u32 phy_id, int hard);
+	void (*stp_reset)(struct mvs_info *mvi, u32 phy_id);
+	void (*clear_active_cmds)(struct mvs_info *mvi);
+	u32 (*spi_read_data)(struct mvs_info *mvi);
+	void (*spi_write_data)(struct mvs_info *mvi, u32 data);
+	int (*spi_buildcmd)(struct mvs_info *mvi,
+						u32      *dwCmd,
+						u8       cmd,
+						u8       read,
+						u8       length,
+						u32      addr
+						);
+	int (*spi_issuecmd)(struct mvs_info *mvi, u32 cmd);
+	int (*spi_waitdataready)(struct mvs_info *mvi, u32 timeout);
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	void (*dma_fix)(dma_addr_t buf_dma, int buf_len, int from, void *prd);
+#endif
+
+};
+
 struct mvs_chip_info {
-	u32		n_phy;
-	u32		srs_sz;
-	u32		slot_width;
+	u32 		n_host;
+	u32 		n_phy;
+	u32 		fis_offs;
+	u32 		fis_count;
+	u32 		srs_sz;
+	u32 		slot_width;
+	const struct mvs_dispatch *dispatch;
 };
+#define MVS_CHIP_SLOT_SZ	(1U << mvi->chip->slot_width)
+#define MVS_RX_FISL_SZ		\
+	(mvi->chip->fis_offs + (mvi->chip->fis_count * 0x100))
+#define MVS_CHIP_DISP		(mvi->chip->dispatch)
 
 struct mvs_err_info {
 	__le32			flags;
@@ -72,7 +192,7 @@ struct mvs_cmd_hdr {
 	__le32			lens;	/* cmd, max resp frame len */
 	__le32			tags;	/* targ port xfer tag; tag */
 	__le32			data_len;	/* data xfer len */
-	__le64			cmd_tbl;	/* command table address */
+	__le64			cmd_tbl;  	/* command table address */
 	__le64			open_frame;	/* open addr frame address */
 	__le64			status_buf;	/* status buffer address */
 	__le64			prd_tbl;		/* PRD tbl address */
@@ -82,16 +202,17 @@ struct mvs_cmd_hdr {
 struct mvs_port {
 	struct asd_sas_port	sas_port;
 	u8			port_attached;
-	u8			taskfileset;
 	u8			wide_port_phymap;
 	struct list_head	list;
 };
 
 struct mvs_phy {
+	struct mvs_info 		*mvi;
 	struct mvs_port		*port;
 	struct asd_sas_phy	sas_phy;
 	struct sas_identify	identify;
 	struct scsi_device	*sdev;
+	struct timer_list timer;
 	u64		dev_sas_addr;
 	u64		att_dev_sas_addr;
 	u32		att_dev_info;
@@ -102,15 +223,34 @@ struct mvs_phy {
 	u32		frame_rcvd_size;
 	u8		frame_rcvd[32];
 	u8		phy_attached;
+	u8		phy_mode;
+	u8		reserved[2];
+	u32		phy_event;
 	enum sas_linkrate	minimum_linkrate;
 	enum sas_linkrate	maximum_linkrate;
 };
 
+struct mvs_device {
+	enum sas_dev_type dev_type;
+	struct domain_device *sas_device;
+	u32 attached_phy;
+	u32 device_id;
+	u32 runing_req;
+	u8 taskfileset;
+	u8 dev_status;
+	u16 reserved;
+	struct list_head		dev_entry;
+};
+
 struct mvs_slot_info {
-	struct list_head list;
-	struct sas_task *task;
+	struct list_head entry;
+	union {
+		struct sas_task *task;
+		void *tdata;
+	};
 	u32 n_elem;
 	u32 tx;
+	u32 slot_tag;
 
 	/* DMA buffer for storing cmd tbl, open addr frame, status buffer,
 	 * and PRD table
@@ -120,9 +260,10 @@ struct mvs_slot_info {
 #if _MV_DUMP
 	u32 cmd_size;
 #endif
-
 	void *response;
 	struct mvs_port *port;
+	struct mvs_device	*device;
+	void *open_frame;
 };
 
 struct mvs_info {
@@ -133,17 +274,17 @@ struct mvs_info {
 
 	/* our device */
 	struct pci_dev *pdev;
+	struct device *dev;
 
 	/* enhanced mode registers */
 	void __iomem *regs;
 
-	/* peripheral registers */
-	void __iomem *peri_regs;
-
+	/* peripheral or soc registers */
+	void __iomem *regs_ex;
 	u8 sas_addr[SAS_ADDR_SIZE];
 
 	/* SCSI/SAS glue */
-	struct sas_ha_struct sas;
+	struct sas_ha_struct *sas;
 	struct Scsi_Host *shost;
 
 	/* TX (delivery) DMA ring */
@@ -154,7 +295,7 @@ struct mvs_info {
 	u32 tx_prod;
 
 	/* RX (completion) DMA ring */
-	__le32 *rx;
+	__le32	*rx;
 	dma_addr_t rx_dma;
 
 	/* RX consumer idx */
@@ -168,38 +309,98 @@ struct mvs_info {
 	struct mvs_cmd_hdr *slot;
 	dma_addr_t slot_dma;
 
+	u32 chip_id;
 	const struct mvs_chip_info *chip;
 
-	u8 tags[MVS_SLOTS];
-	struct mvs_slot_info slot_info[MVS_SLOTS];
-				/* further per-slot information */
+	int tags_num;
+	u8 tags[MVS_SLOTS >> 3];
+
+	/* further per-slot information */
 	struct mvs_phy phy[MVS_MAX_PHYS];
 	struct mvs_port port[MVS_MAX_PHYS];
-#ifdef MVS_USE_TASKLET
-	struct tasklet_struct tasklet;
+	u32 irq;
+	u32 exp_req;
+	u32 id;
+	u64 sata_reg_set;
+	struct list_head *hba_list;
+	struct list_head soc_entry;
+	struct list_head wq_list;
+	unsigned long instance;
+	u16 flashid;
+	u32 flashsize;
+	u32 flashsectSize;
+
+	void *addon;
+	struct mvs_device	devices[MVS_MAX_DEVICES];
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	void *bulk_buffer;
+	dma_addr_t bulk_buffer_dma;
+#define TRASH_BUCKET_SIZE    	0x20000
 #endif
+	struct mvs_slot_info slot_info[0];
+};
+
+struct mvs_prv_info{
+	u8 n_host;
+	u8 n_phy;
+	u16 reserve;
+	struct mvs_info *mvi[2];
+};
+
+struct mvs_wq {
+	struct delayed_work work_q;
+	struct mvs_info *mvi;
+	void *data;
+	int handler;
+	struct list_head entry;
 };
 
+struct mvs_task_exec_info {
+	struct sas_task *task;
+	struct mvs_cmd_hdr *hdr;
+	struct mvs_port *port;
+	u32 tag;
+	int n_elem;
+};
+
+
+/******************** function prototype *********************/
+void mvs_get_sas_addr(void *buf, u32 buflen);
+void mvs_tag_clear(struct mvs_info *mvi, u32 tag);
+void mvs_tag_free(struct mvs_info *mvi, u32 tag);
+void mvs_tag_set(struct mvs_info *mvi, unsigned int tag);
+int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out);
+void mvs_tag_init(struct mvs_info *mvi);
+void mvs_iounmap(void __iomem *regs);
+int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex);
+void mvs_phys_reset(struct mvs_info *mvi, u32 phy_mask, int hard);
 int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 			void *funcdata);
+void __devinit mvs_set_sas_addr(struct mvs_info *mvi, int port_id,
+				u32 off_lo, u32 off_hi, u64 sas_addr);
+int mvs_slave_alloc(struct scsi_device *scsi_dev);
 int mvs_slave_configure(struct scsi_device *sdev);
 void mvs_scan_start(struct Scsi_Host *shost);
 int mvs_scan_finished(struct Scsi_Host *shost, unsigned long time);
-int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags);
-int mvs_task_abort(struct sas_task *task);
+int mvs_queue_command(struct sas_task *task, const int num,
+			gfp_t gfp_flags);
+int mvs_abort_task(struct sas_task *task);
+int mvs_abort_task_set(struct domain_device *dev, u8 *lun);
+int mvs_clear_aca(struct domain_device *dev, u8 *lun);
+int mvs_clear_task_set(struct domain_device *dev, u8 * lun);
 void mvs_port_formed(struct asd_sas_phy *sas_phy);
+void mvs_port_deformed(struct asd_sas_phy *sas_phy);
+int mvs_dev_found(struct domain_device *dev);
+void mvs_dev_gone(struct domain_device *dev);
+int mvs_lu_reset(struct domain_device *dev, u8 *lun);
+int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags);
 int mvs_I_T_nexus_reset(struct domain_device *dev);
-void mvs_int_full(struct mvs_info *mvi);
-void mvs_tag_init(struct mvs_info *mvi);
-int mvs_nvram_read(struct mvs_info *mvi, u32 addr, void *buf, u32 buflen);
-int __devinit mvs_hw_init(struct mvs_info *mvi);
-void __devinit mvs_print_info(struct mvs_info *mvi);
-void mvs_hba_interrupt_enable(struct mvs_info *mvi);
-void mvs_hba_interrupt_disable(struct mvs_info *mvi);
-void mvs_detect_porttype(struct mvs_info *mvi, int i);
-u8 mvs_assign_reg_set(struct mvs_info *mvi, struct mvs_port *port);
-void mvs_enable_xmt(struct mvs_info *mvi, int PhyId);
-void __devinit mvs_phy_hacks(struct mvs_info *mvi);
-void mvs_free_reg_set(struct mvs_info *mvi, struct mvs_port *port);
-
+int mvs_query_task(struct sas_task *task);
+void mvs_release_task(struct mvs_info *mvi, int phy_no,
+			struct domain_device *dev);
+void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events);
+void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st);
+int mvs_int_rx(struct mvs_info *mvi, bool self_clear);
+void mvs_hexdump(u32 size, u8 *data, u32 baseaddr);
 #endif
+
-- 
1.6.0.6

