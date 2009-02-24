From: Ke Wei <kewei@marvell.com>
Subject: [PATCH 4/5] mvsas : redesign the mvsas driver architecture.
Date: Tue, 24 Feb 2009 17:42:45 +0800
Message-ID: <49A3C115.5010808@marvell.com>
Reply-To: kewei@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:28396 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754070AbZBXJn7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2009 04:43:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jeff@garzik.org, james.bottomley@hansenpartnership.com, qzhao@marvell.com, qswang@marvell.com, jfeng@marvell.com, kewei@marvell.com, jasonchu@marvell.com

Added main handling routine. This layer which is chip independence supports SSP,
SMP, and STP(SATA) protocols.

Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas/mv_defs.h |  496 ++++++++++
 drivers/scsi/mvsas/mv_sas.c  | 2088 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/mvsas/mv_sas.h  |  354 +++++++
 drivers/scsi/mvsas/mv_spi.c  |   42 +
 drivers/scsi/mvsas/mv_spi.h  |   35 +
 5 files changed, 3015 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
new file mode 100644
index 0000000..f3e8749
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -0,0 +1,496 @@
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
+#ifndef _MV_DEFS_H_
+#define _MV_DEFS_H_
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
+	MVS_SLOT_BUF_SZ		= 8192, /* cmd tbl + IU + status + PRD */
+	MVS_SSP_CMD_SZ		= 64,	/* SSP command table buffer size */
+	MVS_ATA_CMD_SZ		= 96,	/* SATA command table buffer size */
+	MVS_OAF_SZ		= 64,	/* Open address frame buffer size */
+	MVS_QUEUE_SIZE		= 30,	/* Support Queue depth */
+	MVS_CAN_QUEUE		= MVS_SLOTS - 1,	/* SCSI Queue depth */
+	MVS_SOC_CAN_QUEUE	= MVS_SOC_SLOTS - 1,
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
+	TWSI_RDY		= (1U << 7),	/* EEPROM interface ready */
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
+	SATA_TARGET		= (1U << 16),	/* port0 SATA target enable */
+	MODE_AUTO_DET_PORT7 = (1U << 15),	/* port0 SAS/SATA autodetect */
+	MODE_AUTO_DET_PORT6 = (1U << 14),
+	MODE_AUTO_DET_PORT5 = (1U << 13),
+	MODE_AUTO_DET_PORT4 = (1U << 12),
+	MODE_AUTO_DET_PORT3 = (1U << 11),
+	MODE_AUTO_DET_PORT2 = (1U << 10),
+	MODE_AUTO_DET_PORT1 = (1U << 9),
+	MODE_AUTO_DET_PORT0 = (1U << 8),
+	MODE_AUTO_DET_EN    =	MODE_AUTO_DET_PORT0 | MODE_AUTO_DET_PORT1 |
+				MODE_AUTO_DET_PORT2 | MODE_AUTO_DET_PORT3 |
+				MODE_AUTO_DET_PORT4 | MODE_AUTO_DET_PORT5 |
+				MODE_AUTO_DET_PORT6 | MODE_AUTO_DET_PORT7,
+	MODE_SAS_PORT7_MASK = (1U << 7),  /* port0 SAS(1), SATA(0) mode */
+	MODE_SAS_PORT6_MASK = (1U << 6),
+	MODE_SAS_PORT5_MASK = (1U << 5),
+	MODE_SAS_PORT4_MASK = (1U << 4),
+	MODE_SAS_PORT3_MASK = (1U << 3),
+	MODE_SAS_PORT2_MASK = (1U << 2),
+	MODE_SAS_PORT1_MASK = (1U << 1),
+	MODE_SAS_PORT0_MASK = (1U << 0),
+	MODE_SAS_SATA	=	MODE_SAS_PORT0_MASK | MODE_SAS_PORT1_MASK |
+				MODE_SAS_PORT2_MASK | MODE_SAS_PORT3_MASK |
+				MODE_SAS_PORT4_MASK | MODE_SAS_PORT5_MASK |
+				MODE_SAS_PORT6_MASK | MODE_SAS_PORT7_MASK,
+
+				/* SAS_MODE value may be
+				 * dictated (in hw) by values
+				 * of SATA_TARGET & AUTO_DET
+				 */
+
+	/* MVS_TX_CFG */
+	TX_EN			= (1U << 16),	/* Enable TX */
+	TX_RING_SZ_MASK		= 0xfff,	/* TX ring size, bits 11:0 */
+
+	/* MVS_RX_CFG */
+	RX_EN			= (1U << 16),	/* Enable RX */
+	RX_RING_SZ_MASK		= 0xfff,	/* RX ring size, bits 11:0 */
+
+	/* MVS_INT_COAL */
+	COAL_EN			= (1U << 16),	/* Enable int coalescing */
+
+	/* MVS_INT_STAT, MVS_INT_MASK */
+	CINT_I2C		= (1U << 31),	/* I2C event */
+	CINT_SW0		= (1U << 30),	/* software event 0 */
+	CINT_SW1		= (1U << 29),	/* software event 1 */
+	CINT_PRD_BC		= (1U << 28),	/* PRD BC err for read cmd */
+	CINT_DMA_PCIE		= (1U << 27),	/* DMA to PCIE timeout */
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
+	TXQ_CMD_SSP_FREE_LIST	= 4,		/* add to SSP targ free list */
+	TXQ_CMD_SLOT_RESET	= 7,		/* reset command slot */
+	TXQ_MODE_I		= (1U << 28),	/* mode: 0=target,1=initiator */
+	TXQ_MODE_TARGET 	= 0,
+	TXQ_MODE_INITIATOR	= 1,
+	TXQ_PRIO_HI		= (1U << 27),	/* priority: 0=normal, 1=high */
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
+	RXQ_SLOT_RESET		= (1U << 21),	/* Slot reset complete */
+	RXQ_CMD_RX		= (1U << 20),	/* target cmd received */
+	RXQ_ATTN		= (1U << 19),	/* attention */
+	RXQ_RSP			= (1U << 18),	/* response frame xfer'd */
+	RXQ_ERR			= (1U << 17),	/* err info rec xfer'd */
+	RXQ_DONE		= (1U << 16),	/* cmd complete */
+	RXQ_SLOT_MASK		= 0xfff,	/* slot number */
+
+	/* mvs_cmd_hdr bits */
+	MCH_PRD_LEN_SHIFT	= 16,		/* 16-bit PRD table len */
+	MCH_SSP_FR_TYPE_SHIFT	= 13,		/* SSP frame type */
+
+						/* SSP initiator only */
+	MCH_SSP_FR_CMD		= 0x0,		/* COMMAND frame */
+
+						/* SSP initiator or target */
+	MCH_SSP_FR_TASK		= 0x1,		/* TASK frame */
+
+						/* SSP target only */
+	MCH_SSP_FR_XFER_RDY	= 0x4,		/* XFER_RDY frame */
+	MCH_SSP_FR_RESP		= 0x5,		/* RESPONSE frame */
+	MCH_SSP_FR_READ		= 0x6,		/* Read DATA frame(s) */
+	MCH_SSP_FR_READ_RESP	= 0x7,		/* ditto, plus RESPONSE */
+
+	MCH_SSP_MODE_PASSTHRU	= 1,
+	MCH_SSP_MODE_NORMAL	= 0,
+	MCH_PASSTHRU		= (1U << 12),	/* pass-through (SSP) */
+	MCH_FBURST		= (1U << 11),	/* first burst (SSP) */
+	MCH_CHK_LEN		= (1U << 10),	/* chk xfer len (SSP) */
+	MCH_RETRY		= (1U << 9),	/* tport layer retry (SSP) */
+	MCH_PROTECTION		= (1U << 8),	/* protection info rec (SSP) */
+	MCH_RESET		= (1U << 7),	/* Reset (STP/SATA) */
+	MCH_FPDMA		= (1U << 6),	/* First party DMA (STP/SATA) */
+	MCH_ATAPI		= (1U << 5),	/* ATAPI (STP/SATA) */
+	MCH_BIST		= (1U << 4),	/* BIST activate (STP/SATA) */
+	MCH_PMP_MASK		= 0xf,		/* PMP from cmd FIS (STP/SATA)*/
+
+	CCTL_RST		= (1U << 5),	/* port logic reset */
+
+						/* 0(LSB first), 1(MSB first) */
+	CCTL_ENDIAN_DATA	= (1U << 3),	/* PRD data */
+	CCTL_ENDIAN_RSP		= (1U << 2),	/* response frame */
+	CCTL_ENDIAN_OPEN	= (1U << 1),	/* open address frame */
+	CCTL_ENDIAN_CMD		= (1U << 0),	/* command table */
+
+	/* MVS_Px_SER_CTLSTAT (per-phy control) */
+	PHY_SSP_RST		= (1U << 3),	/* reset SSP link layer */
+	PHY_BCAST_CHG		= (1U << 2),	/* broadcast(change) notif */
+	PHY_RST_HARD		= (1U << 1),	/* hard reset + phy reset */
+	PHY_RST			= (1U << 0),	/* phy reset */
+	PHY_READY_MASK		= (1U << 20),
+
+	/* MVS_Px_INT_STAT, MVS_Px_INT_MASK (per-phy events) */
+	PHYEV_DEC_ERR		= (1U << 24),	/* Phy Decoding Error */
+	PHYEV_DCDR_ERR		= (1U << 23),	/* STP Deocder Error */
+	PHYEV_CRC_ERR		= (1U << 22),	/* STP CRC Error */
+	PHYEV_UNASSOC_FIS	= (1U << 19),	/* unassociated FIS rx'd */
+	PHYEV_AN		= (1U << 18),	/* SATA async notification */
+	PHYEV_BIST_ACT		= (1U << 17),	/* BIST activate FIS */
+	PHYEV_SIG_FIS		= (1U << 16),	/* signature FIS */
+	PHYEV_POOF		= (1U << 12),	/* phy ready from 1 -> 0 */
+	PHYEV_IU_BIG		= (1U << 11),	/* IU too long err */
+	PHYEV_IU_SMALL		= (1U << 10),	/* IU too short err */
+	PHYEV_UNK_TAG		= (1U << 9),	/* unknown tag */
+	PHYEV_BROAD_CH		= (1U << 8),	/* broadcast(CHANGE) */
+	PHYEV_COMWAKE		= (1U << 7),	/* COMWAKE rx'd */
+	PHYEV_PORT_SEL		= (1U << 6),	/* port selector present */
+	PHYEV_HARD_RST		= (1U << 5),	/* hard reset rx'd */
+	PHYEV_ID_TMOUT		= (1U << 4),	/* identify timeout */
+	PHYEV_ID_FAIL		= (1U << 3),	/* identify failed */
+	PHYEV_ID_DONE		= (1U << 2),	/* identify done */
+	PHYEV_HARD_RST_DONE	= (1U << 1),	/* hard reset done */
+	PHYEV_RDY_CH		= (1U << 0),	/* phy ready changed state */
+
+	/* MVS_PCS */
+	PCS_EN_SATA_REG_SHIFT	= (16),		/* Enable SATA Register Set */
+	PCS_EN_PORT_XMT_SHIFT	= (12),		/* Enable Port Transmit */
+	PCS_EN_PORT_XMT_SHIFT2	= (8),		/* For 6485 */
+	PCS_SATA_RETRY		= (1U << 8),	/* retry ctl FIS on R_ERR */
+	PCS_RSP_RX_EN		= (1U << 7),	/* raw response rx */
+	PCS_SATA_RETRY_2	= (1U << 6),	/* For 9180 */
+	PCS_SELF_CLEAR		= (1U << 5),	/* self-clearing int mode */
+	PCS_FIS_RX_EN		= (1U << 4),	/* FIS rx enable */
+	PCS_CMD_STOP_ERR	= (1U << 3),	/* cmd stop-on-err enable */
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
+	PHY_MODE6_FC_ORDER	= (1U << 26),	/* Fibre Channel Mode Order*/
+	PHY_MODE6_MUCNT_EN	= (1U << 24),	/* u Count Enable */
+	PHY_MODE6_SEL_MUCNT_LEN	= (1U << 22),	/* Training Length Select */
+	PHY_MODE6_SELMUPI	= (1U << 20),	/* Phase Multi Select (init) */
+	PHY_MODE6_SELMUPF	= (1U << 18),	/* Phase Multi Select (final) */
+	PHY_MODE6_SELMUFF	= (1U << 16),	/* Freq Loop Multi Sel(final) */
+	PHY_MODE6_SELMUFI	= (1U << 14),	/* Freq Loop Multi Sel(init) */
+	PHY_MODE6_FREEZE_LOOP	= (1U << 12),	/* Freeze Rx CDR Loop */
+	PHY_MODE6_INT_RXFOFFS	= (1U << 3),	/* Rx CDR Freq Loop Enable */
+	PHY_MODE6_FRC_RXFOFFS	= (1U << 2),	/* Initial Rx CDR Offset */
+	PHY_MODE6_STAU_0D8	= (1U << 1),	/* Rx CDR Freq Loop Saturate */
+	PHY_MODE6_RXSAT_DIS	= (1U << 0),	/* Saturate Ctl */
+};
+
+/* SAS/SATA configuration port registers, aka phy registers */
+enum sas_sata_config_port_regs {
+	PHYR_IDENTIFY		= 0x00,	/* info for IDENTIFY frame */
+	PHYR_ADDR_LO		= 0x04,	/* my SAS address (low) */
+	PHYR_ADDR_HI		= 0x08,	/* my SAS address (high) */
+	PHYR_ATT_DEV_INFO	= 0x0C,	/* attached device info */
+	PHYR_ATT_ADDR_LO	= 0x10,	/* attached dev SAS addr (low) */
+	PHYR_ATT_ADDR_HI	= 0x14,	/* attached dev SAS addr (high) */
+	PHYR_SATA_CTL		= 0x18,	/* SATA control */
+	PHYR_PHY_STAT		= 0x1C,	/* PHY status */
+	PHYR_SATA_SIG0		= 0x20,	/*port SATA signature FIS(Byte 0-3) */
+	PHYR_SATA_SIG1		= 0x24,	/*port SATA signature FIS(Byte 4-7) */
+	PHYR_SATA_SIG2		= 0x28,	/*port SATA signature FIS(Byte 8-11) */
+	PHYR_SATA_SIG3		= 0x2c,	/*port SATA signature FIS(Byte 12-15) */
+	PHYR_R_ERR_COUNT	= 0x30, /* port R_ERR count register */
+	PHYR_CRC_ERR_COUNT	= 0x34, /* port CRC error count register */
+	PHYR_WIDE_PORT		= 0x38,	/* wide port participating */
+	PHYR_CURRENT0		= 0x80,	/* current connection info 0 */
+	PHYR_CURRENT1		= 0x84,	/* current connection info 1 */
+	PHYR_CURRENT2		= 0x88,	/* current connection info 2 */
+	CONFIG_ID_FRAME0       = 0x100, /* Port device ID frame register 0 */
+	CONFIG_ID_FRAME1       = 0x104, /* Port device ID frame register 1 */
+	CONFIG_ID_FRAME2       = 0x108, /* Port device ID frame register 2 */
+	CONFIG_ID_FRAME3       = 0x10c, /* Port device ID frame register 3 */
+	CONFIG_ID_FRAME4       = 0x110, /* Port device ID frame register 4 */
+	CONFIG_ID_FRAME5       = 0x114, /* Port device ID frame register 5 */
+	CONFIG_ID_FRAME6       = 0x118, /* Port device ID frame register 6 */
+	CONFIG_ATT_ID_FRAME0   = 0x11c, /* attached device ID frame register 0 */
+	CONFIG_ATT_ID_FRAME1   = 0x120, /* attached device ID frame register 1 */
+	CONFIG_ATT_ID_FRAME2   = 0x124, /* attached device ID frame register 2 */
+	CONFIG_ATT_ID_FRAME3   = 0x128, /* attached device ID frame register 3 */
+	CONFIG_ATT_ID_FRAME4   = 0x12c, /* attached device ID frame register 4 */
+	CONFIG_ATT_ID_FRAME5   = 0x130, /* attached device ID frame register 5 */
+	CONFIG_ATT_ID_FRAME6   = 0x134, /* attached device ID frame register 6 */
+};
+
+enum sas_cmd_port_registers {
+	CMD_CMRST_OOB_DET	= 0x100, /* COMRESET OOB detect register */
+	CMD_CMWK_OOB_DET	= 0x104, /* COMWAKE OOB detect register */
+	CMD_CMSAS_OOB_DET	= 0x108, /* COMSAS OOB detect register */
+	CMD_BRST_OOB_DET	= 0x10c, /* burst OOB detect register */
+	CMD_OOB_SPACE		= 0x110, /* OOB space control register */
+	CMD_OOB_BURST		= 0x114, /* OOB burst control register */
+	CMD_PHY_TIMER		= 0x118, /* PHY timer control register */
+	CMD_PHY_CONFIG0		= 0x11c, /* PHY config register 0 */
+	CMD_PHY_CONFIG1		= 0x120, /* PHY config register 1 */
+	CMD_SAS_CTL0		= 0x124, /* SAS control register 0 */
+	CMD_SAS_CTL1		= 0x128, /* SAS control register 1 */
+	CMD_SAS_CTL2		= 0x12c, /* SAS control register 2 */
+	CMD_SAS_CTL3		= 0x130, /* SAS control register 3 */
+	CMD_ID_TEST		= 0x134, /* ID test register */
+	CMD_PL_TIMER		= 0x138, /* PL timer register */
+	CMD_WD_TIMER		= 0x13c, /* WD timer register */
+	CMD_PORT_SEL_COUNT	= 0x140, /* port selector count register */
+	CMD_APP_MEM_CTL		= 0x144, /* Application Memory Control */
+	CMD_XOR_MEM_CTL		= 0x148, /* XOR Block Memory Control */
+	CMD_DMA_MEM_CTL		= 0x14c, /* DMA Block Memory Control */
+	CMD_PORT_MEM_CTL0	= 0x150, /* Port Memory Control 0 */
+	CMD_PORT_MEM_CTL1	= 0x154, /* Port Memory Control 1 */
+	CMD_SATA_PORT_MEM_CTL0	= 0x158, /* SATA Port Memory Control 0 */
+	CMD_SATA_PORT_MEM_CTL1	= 0x15c, /* SATA Port Memory Control 1 */
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
+	CMD_APP_ERR_CONFIG	= 0x1A4, /* Application Error Configuration */
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
+	MVF_FLAG_SOC		= (1U << 2),	/* SoC integrated controllers */
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
+	CMD_PI_ERR	= (1U << 30),	/* Protection info error.  see flags2 */
+	RSP_OVER	= (1U << 29),	/* rsp buffer overflow */
+	RETRY_LIM	= (1U << 28),	/* FIS/frame retry limit exceeded */
+	UNK_FIS 	= (1U << 27),	/* unknown FIS */
+	DMA_TERM	= (1U << 26),	/* DMA terminate primitive rx'd */
+	SYNC_ERR	= (1U << 25),	/* SYNC rx'd during frame xmit */
+	TFILE_ERR	= (1U << 24),	/* SATA taskfile Error bit set */
+	R_ERR		= (1U << 23),	/* SATA returned R_ERR prim */
+	RD_OFS		= (1U << 20),	/* Read DATA frame invalid offset */
+	XFER_RDY_OFS	= (1U << 19),	/* XFER_RDY offset error */
+	UNEXP_XFER_RDY	= (1U << 18),	/* unexpected XFER_RDY error */
+	DATA_OVER_UNDER = (1U << 16),	/* data overflow/underflow */
+	INTERLOCK	= (1U << 15),	/* interlock error */
+	NAK		= (1U << 14),	/* NAK rx'd */
+	ACK_NAK_TO	= (1U << 13),	/* ACK/NAK timeout */
+	CXN_CLOSED	= (1U << 12),	/* cxn closed w/out ack/nak */
+	OPEN_TO 	= (1U << 11),	/* I_T nexus lost, open cxn timeout */
+	PATH_BLOCKED	= (1U << 10),	/* I_T nexus lost, pathway blocked */
+	NO_DEST 	= (1U << 9),	/* I_T nexus lost, no destination */
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
+#endif
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
new file mode 100644
index 0000000..5d6503f
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -0,0 +1,2088 @@
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
+
+static int mvs_find_tag(struct mvs_info *mvi, struct sas_task *task, u32 *tag)
+{
+	if (task->lldd_task) {
+		struct mvs_slot_info *slot;
+		slot = (struct mvs_slot_info *) task->lldd_task;
+		*tag = slot->slot_tag;
+		return 1;
+	}
+	return 0;
+}
+
+void mvs_tag_clear(struct mvs_info *mvi, u32 tag)
+{
+	void *bitmap = (void *) &mvi->tags;
+	clear_bit(tag, bitmap);
+}
+
+void mvs_tag_free(struct mvs_info *mvi, u32 tag)
+{
+	mvs_tag_clear(mvi, tag);
+}
+
+void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
+{
+	void *bitmap = (void *) &mvi->tags;
+	set_bit(tag, bitmap);
+}
+
+inline int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
+{
+	unsigned int index, tag;
+	void *bitmap = (void *) &mvi->tags;
+
+	index = find_first_zero_bit(bitmap, mvi->tags_num);
+	tag = index;
+	if (tag >= mvi->tags_num)
+		return -SAS_QUEUE_FULL;
+	mvs_tag_set(mvi, tag);
+	*tag_out = tag;
+	return 0;
+}
+
+void mvs_tag_init(struct mvs_info *mvi)
+{
+	int i;
+	for (i = 0; i < mvi->tags_num; ++i)
+		mvs_tag_clear(mvi, i);
+}
+
+void mvs_hexdump(u32 size, u8 *data, u32 baseaddr)
+{
+	u32 i;
+	u32 run;
+	u32 offset;
+
+	offset = 0;
+	while (size) {
+		printk("%08X : ", baseaddr + offset);
+		if (size >= 16)
+			run = 16;
+		else
+			run = size;
+		size -= run;
+		for (i = 0; i < 16; i++) {
+			if (i < run)
+				printk("%02X ", (u32)data[i]);
+			else
+				printk("   ");
+		}
+		printk(": ");
+		for (i = 0; i < run; i++)
+			printk("%c", isalnum(data[i]) ? data[i] : '.');
+		printk("\n");
+		data = &data[16];
+		offset += run;
+	}
+	printk("\n");
+}
+
+#if (_MV_DUMP > 1)
+static void mvs_hba_sb_dump(struct mvs_info *mvi, u32 tag,
+				   enum sas_protocol proto)
+{
+	u32 offset;
+	struct mvs_slot_info *slot = &mvi->slot_info[tag];
+
+	offset = slot->cmd_size + MVS_OAF_SZ +
+	    MVS_CHIP_DISP->prd_size() * slot->n_elem;
+	dev_printk(KERN_DEBUG, mvi->dev, "+---->Status buffer[%d] :\n",
+			tag);
+	mvs_hexdump(32, (u8 *) slot->response,
+		    (u32) slot->buf_dma + offset);
+}
+#endif
+
+static void mvs_hba_memory_dump(struct mvs_info *mvi, u32 tag,
+				enum sas_protocol proto)
+{
+#if (_MV_DUMP > 1)
+	u32 sz, w_ptr;
+	u64 addr;
+	struct mvs_slot_info *slot = &mvi->slot_info[tag];
+
+	/*Delivery Queue */
+	sz = MVS_CHIP_SLOT_SZ;
+	w_ptr = slot->tx;
+	addr = mvi->tx_dma;
+	dev_printk(KERN_DEBUG, mvi->dev,
+		"Delivery Queue Size=%04d , WRT_PTR=%04X\n", sz, w_ptr);
+	dev_printk(KERN_DEBUG, mvi->dev,
+		"Delivery Queue Base Address=0x%llX (PA)"
+		"(tx_dma=0x%llX), Entry=%04d\n",
+		addr, (unsigned long long)mvi->tx_dma, w_ptr);
+	mvs_hexdump(sizeof(u32), (u8 *)(&mvi->tx[mvi->tx_prod]),
+			(u32) mvi->tx_dma + sizeof(u32) * w_ptr);
+	/*Command List */
+	addr = mvi->slot_dma;
+	dev_printk(KERN_DEBUG, mvi->dev,
+		"Command List Base Address=0x%llX (PA)"
+		"(slot_dma=0x%llX), Header=%03d\n",
+		addr, (unsigned long long)slot->buf_dma, tag);
+	dev_printk(KERN_DEBUG, mvi->dev, "Command Header[%03d]:\n", tag);
+	/*mvs_cmd_hdr */
+	mvs_hexdump(sizeof(struct mvs_cmd_hdr), (u8 *)(&mvi->slot[tag]),
+		(u32) mvi->slot_dma + tag * sizeof(struct mvs_cmd_hdr));
+	/*1.command table area */
+	dev_printk(KERN_DEBUG, mvi->dev, "+---->Command Table :\n");
+	mvs_hexdump(slot->cmd_size, (u8 *) slot->buf, (u32) slot->buf_dma);
+	/*2.open address frame area */
+	dev_printk(KERN_DEBUG, mvi->dev, "+---->Open Address Frame :\n");
+	mvs_hexdump(MVS_OAF_SZ, (u8 *) slot->buf + slot->cmd_size,
+				(u32) slot->buf_dma + slot->cmd_size);
+	/*3.status buffer */
+	mvs_hba_sb_dump(mvi, tag, proto);
+	/*4.PRD table */
+	dev_printk(KERN_DEBUG, mvi->dev, "+---->PRD table :\n");
+	mvs_hexdump(MVS_CHIP_DISP->prd_size() * slot->n_elem,
+		(u8 *) slot->buf + slot->cmd_size + MVS_OAF_SZ,
+		(u32) slot->buf_dma + slot->cmd_size + MVS_OAF_SZ);
+#endif
+}
+
+static void mvs_hba_cq_dump(struct mvs_info *mvi)
+{
+#if (_MV_DUMP > 2)
+	u64 addr;
+	void __iomem *regs = mvi->regs;
+	u32 entry = mvi->rx_cons + 1;
+	u32 rx_desc = le32_to_cpu(mvi->rx[entry]);
+
+	/*Completion Queue */
+	addr = mr32(RX_HI) << 16 << 16 | mr32(RX_LO);
+	dev_printk(KERN_DEBUG, mvi->dev, "Completion Task = 0x%p\n",
+		   mvi->slot_info[rx_desc & RXQ_SLOT_MASK].task);
+	dev_printk(KERN_DEBUG, mvi->dev,
+		"Completion List Base Address=0x%llX (PA), "
+		"CQ_Entry=%04d, CQ_WP=0x%08X\n",
+		addr, entry - 1, mvi->rx[0]);
+	mvs_hexdump(sizeof(u32), (u8 *)(&rx_desc),
+		    mvi->rx_dma + sizeof(u32) * entry);
+#endif
+}
+
+void mvs_get_sas_addr(void *buf, u32 buflen)
+{
+	/* memcpy(buf, "\x50\x05\x04\x30\x11\xab\x64\x40", 8); */
+}
+
+struct mvs_info * mvs_find_dev_mvi(struct domain_device *dev)
+{
+	unsigned long i = 0, j = 0;
+	struct sas_ha_struct * sha = dev->port->ha;
+	struct mvs_info *mvi=NULL;
+
+	while(sha->sas_port[i]){
+		if(sha->sas_port[i] == dev->port){
+			struct asd_sas_phy * phy =  container_of(sha->sas_port[i]->phy_list.next,
struct asd_sas_phy, port_phy_el);
+			j = 0;
+			while(sha->sas_phy[j]){
+				if(sha->sas_phy[j] == phy)
+					break;
+				j++;
+			}
+			break;
+		}
+		i++;
+	}
+	mvi = ((struct mvs_info **)(sha->lldd_ha))[j/((unsigned long
*)sha->lldd_ha)[1] + 2];
+
+	return mvi;
+
+}
+
+
+static void mvs_free_reg_set(struct mvs_info *mvi, struct mvs_device *dev)
+{
+	if(!dev){
+		mv_printk("device has been free.\n");
+		return;
+	}
+	if (dev->taskfileset == MVS_ID_NOT_MAPPED)
+		return;
+	MVS_CHIP_DISP->free_reg_set(mvi, &dev->taskfileset);
+}
+
+static u8 mvs_assign_reg_set(struct mvs_info *mvi, struct mvs_device *dev)
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
+	u32 tmp,i=0;
+	unsigned long flags;
+	struct sas_ha_struct * sha = sas_phy->ha;
+	struct mvs_info *mvi = NULL;
+
+	while(sha->sas_phy[i]){
+		if(sha->sas_phy[i]== sas_phy)
+			break;
+		i++;
+	}
+	mvi = ((struct mvs_info **)(sha->lldd_ha))[i/((unsigned long
*)sha->lldd_ha)[1]+ 2];
+
+	spin_lock_irqsave(&mvi->lock, flags);
+	switch (func) {
+	case PHY_FUNC_SET_LINK_RATE:
+		MVS_CHIP_DISP->phy_set_link_rate(mvi, phy_id, funcdata);
+		break;
+
+	case PHY_FUNC_HARD_RESET:
+		tmp = MVS_CHIP_DISP->read_phy_ctl(mvi, phy_id);
+		if (tmp & PHY_RST_HARD)
+			break;
+		MVS_CHIP_DISP->phy_reset(mvi, phy_id, 1);
+		break;
+
+	case PHY_FUNC_LINK_RESET:
+		MVS_CHIP_DISP->phy_enable(mvi, phy_id);
+		MVS_CHIP_DISP->phy_reset(mvi, phy_id, 0);
+		break;
+
+	case PHY_FUNC_DISABLE:
+		MVS_CHIP_DISP->phy_disable(mvi, phy_id);
+		break;
+	case PHY_FUNC_RELEASE_SPINUP_HOLD:
+	default:
+		rc = -EOPNOTSUPP;
+	}
+	spin_unlock_irqrestore(&mvi->lock, flags);
+	msleep(200);
+	return rc;
+}
+
+void __devinit mvs_set_sas_addr(struct mvs_info *mvi, int port_id,
+				u32 off_lo, u32 off_hi, u64 sas_addr)
+{
+	u32 lo = (u32)sas_addr;		/* Got from SPI flash. */
+	u32 hi = (u32)(sas_addr>>32);
+
+	MVS_CHIP_DISP->write_port_cfg_addr(mvi, port_id, off_lo);
+	MVS_CHIP_DISP->write_port_cfg_data(mvi, port_id, lo);
+	MVS_CHIP_DISP->write_port_cfg_addr(mvi, port_id, off_hi);
+	MVS_CHIP_DISP->write_port_cfg_data(mvi, port_id, hi);
+}
+
+static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
+{
+	struct mvs_phy *phy = &mvi->phy[i];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct sas_ha_struct *sas_ha;
+	if (!phy->phy_attached)
+		return;
+
+	if(!(phy->att_dev_info & PORT_DEV_TRGT_MASK)
+		&& phy->phy_type & PORT_TYPE_SAS){
+		return;
+	}
+
+	sas_ha = mvi->sas;
+	sas_ha->notify_phy_event(sas_phy, PHYE_OOB_DONE);
+
+	if (sas_phy->phy) {
+		struct sas_phy *sphy = sas_phy->phy;
+
+		sphy->negotiated_linkrate = sas_phy->linkrate;
+		sphy->minimum_linkrate = phy->minimum_linkrate;
+		sphy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
+		sphy->maximum_linkrate = phy->maximum_linkrate;
+		sphy->maximum_linkrate_hw = MVS_CHIP_DISP->phy_max_link_rate();
+	}
+
+	if (phy->phy_type & PORT_TYPE_SAS) {
+		struct sas_identify_frame *id;
+
+		id = (struct sas_identify_frame *)phy->frame_rcvd;
+		id->dev_type = phy->identify.device_type;
+		id->initiator_bits = SAS_PROTOCOL_ALL;
+		id->target_bits = phy->identify.target_port_protocols;
+	} else if (phy->phy_type & PORT_TYPE_SATA) {
+		/* TODO */
+	}
+	mv_dprintk("phy %d byte dmaded.\n",i+ mvi->id * mvi->chip->n_phy);
+
+	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
+
+	mvi->sas->notify_port_event(sas_phy,
+				   PORTE_BYTES_DMAED);
+}
+
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
+int mvs_slave_configure(struct scsi_device *sdev)
+{
+	struct domain_device *dev = sdev_to_domain_dev(sdev);
+	int ret = sas_slave_configure(sdev);
+
+	if (ret)
+		return ret;
+
+	if (dev_is_sata(dev)) {
+		/* may set PIO mode */
+#ifdef MV_DISABLE_NCQ
+		struct ata_port *ap = dev->sata_dev.ap;
+		struct ata_device *adev = ap->link.device;
+		adev->flags |= (ATA_DFLAG_NCQ_OFF);
+#endif
+		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, 1);
+	}
+	return 0;
+}
+
+void mvs_scan_start(struct Scsi_Host *shost)
+{
+	int i,j;
+	unsigned short core_nr;
+	struct mvs_info *mvi;
+	struct sas_ha_struct * sha = SHOST_TO_SAS_HA(shost);
+
+	core_nr = ((unsigned long *)sha->lldd_ha)[0] >> 16;
+
+	for(j =0; j< core_nr; j++){
+		mvi = ((struct mvs_info **)sha->lldd_ha)[j+2];
+		for (i = 0; i < mvi->chip->n_phy; ++i) {
+			mvs_bytes_dmaed(mvi, i);
+		}
+	}
+}
+
+int mvs_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	/* give the phy enabling interrupt event time to come in (1s
+	 * is empirically about all it takes) */
+	if (time < HZ)
+		return 0;
+	/* Wait for discovery to finish */
+	scsi_flush_work(shost);
+	return 1;
+}
+
+#if 0
+static void mvs_slot_reset(struct mvs_info *mvi, struct sas_task *task,
+				u32 slot_idx, struct completion *completion)
+{
+	struct domain_device *dev = task->dev;
+	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
+	struct asd_sas_port *sas_port = dev->port;
+	struct mvs_port *port = mvi->slot_info[slot_idx].port;
+	u32 reg_set, phy_mask;
+
+	BUG_ON(port != &mvi->port[sas_port->id]);
+	BUG_ON(port == NULL);
+	mvi->slot_info[slot_idx].slot_completion = completion;
+	if (!sas_protocol_ata(task->task_proto)) {
+		reg_set = 0;
+		phy_mask = (port->wide_port_phymap) ? port->wide_port_phymap :
+				sas_port->phy_mask;
+	} else {
+		phy_mask = sas_port->phy_mask;
+		reg_set = mvi_dev->taskfileset;
+		MVS_CHIP_DISP->command_active(mvi, slot_idx);
+	}
+	mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | slot_idx |
+					(TXQ_CMD_SLOT_RESET << TXQ_CMD_SHIFT) |
+					(phy_mask << TXQ_PHY_SHIFT) |
+					(reg_set << TXQ_SRS_SHIFT));
+
+	MVS_CHIP_DISP->start_delivery(mvi, mvi->tx_prod);
+	mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_CHIP_SLOT_SZ - 1);
+}
+#endif
+
+static int mvs_task_prep_smp(struct mvs_info *mvi,
+			     struct mvs_task_exec_info *tei)
+{
+	int elem, rc, i;
+	struct sas_task *task = tei->task;
+	struct mvs_cmd_hdr *hdr = tei->hdr;
+	struct domain_device *dev = task->dev;
+	struct asd_sas_port *sas_port = dev->port;
+	struct scatterlist *sg_req, *sg_resp;
+	u32 req_len, resp_len, tag = tei->tag;
+	void *buf_tmp;
+	u8 *buf_oaf;
+	dma_addr_t buf_tmp_dma;
+	void *buf_prd;
+	struct mvs_slot_info *slot = &mvi->slot_info[tag];
+	u32 flags = (tei->n_elem << MCH_PRD_LEN_SHIFT);
+#if _MV_DUMP
+	u8 *buf_cmd;
+	void *from;
+#endif
+	/*
+	 * DMA-map SMP request, response buffers
+	 */
+	sg_req = &task->smp_task.smp_req;
+	elem = dma_map_sg(mvi->dev, sg_req, 1, PCI_DMA_TODEVICE);
+	if (!elem)
+		return -ENOMEM;
+	req_len = sg_dma_len(sg_req);
+
+	sg_resp = &task->smp_task.smp_resp;
+	elem = dma_map_sg(mvi->dev, sg_resp, 1, PCI_DMA_FROMDEVICE);
+	if (!elem) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+	resp_len = SB_RFB_MAX;
+
+	/* must be in dwords */
+	if ((req_len & 0x3) || (resp_len & 0x3)) {
+		rc = -EINVAL;
+		goto err_out_2;
+	}
+
+	/*
+	 * arrange MVS_SLOT_BUF_SZ-sized DMA buffer according to our needs
+	 */
+
+	/* region 1: command table area (MVS_SSP_CMD_SZ bytes) ************** */
+	buf_tmp = slot->buf;
+	buf_tmp_dma = slot->buf_dma;
+
+#if _MV_DUMP
+	buf_cmd = buf_tmp;
+	hdr->cmd_tbl = cpu_to_le64(buf_tmp_dma);
+	buf_tmp += req_len;
+	buf_tmp_dma += req_len;
+	slot->cmd_size = req_len;
+#else
+	hdr->cmd_tbl = cpu_to_le64(sg_dma_address(sg_req));
+#endif
+
+	/* region 2: open address frame area (MVS_OAF_SZ bytes) ********* */
+	buf_oaf = buf_tmp;
+	hdr->open_frame = cpu_to_le64(buf_tmp_dma);
+
+	buf_tmp += MVS_OAF_SZ;
+	buf_tmp_dma += MVS_OAF_SZ;
+
+	/* region 3: PRD table ********************************************* */
+	buf_prd = buf_tmp;
+	if (tei->n_elem)
+		hdr->prd_tbl = cpu_to_le64(buf_tmp_dma);
+	else
+		hdr->prd_tbl = 0;
+
+	i = MVS_CHIP_DISP->prd_size() * tei->n_elem;
+	buf_tmp += i;
+	buf_tmp_dma += i;
+
+	/* region 4: status buffer (larger the PRD, smaller this buf) ****** */
+	slot->response = buf_tmp;
+	hdr->status_buf = cpu_to_le64(buf_tmp_dma);
+	if (mvi->flags & MVF_FLAG_SOC)
+		hdr->reserved[0] = 0;
+
+	/*
+	 * Fill in TX ring and command slot header
+	 */
+	slot->tx = mvi->tx_prod;
+	mvi->tx[mvi->tx_prod] = cpu_to_le32((TXQ_CMD_SMP << TXQ_CMD_SHIFT) |
+					TXQ_MODE_I | tag |
+					(sas_port->phy_mask << TXQ_PHY_SHIFT));
+
+	hdr->flags |= flags;
+	hdr->lens = cpu_to_le32(((resp_len / 4) << 16) | ((req_len - 4) / 4));
+	hdr->tags = cpu_to_le32(tag);
+	hdr->data_len = 0;
+
+	/* generate open address frame hdr (first 12 bytes) */
+	/* initiator, SMP, ftype 1h */
+	buf_oaf[0] = (1 << 7) | (PROTOCOL_SMP << 4) | 0x01;
+	buf_oaf[1] = dev->linkrate & 0xf;
+	*(u16 *)(buf_oaf + 2) = 0xFFFF;		/* SAS SPEC */
+	memcpy(buf_oaf + 4, dev->sas_addr, SAS_ADDR_SIZE);
+
+	/* fill in PRD (scatter/gather) table, if any */
+	MVS_CHIP_DISP->make_prd(task->scatter, tei->n_elem, buf_prd);
+
+#if _MV_DUMP
+	/* copy cmd table */
+	from = kmap_atomic(sg_page(sg_req), KM_IRQ0);
+	memcpy(buf_cmd, from + sg_req->offset, req_len);
+	kunmap_atomic(from, KM_IRQ0);
+#endif
+	return 0;
+
+err_out_2:
+	dma_unmap_sg(mvi->dev, &tei->task->smp_task.smp_resp, 1,
+		     PCI_DMA_FROMDEVICE);
+err_out:
+	dma_unmap_sg(mvi->dev, &tei->task->smp_task.smp_req, 1,
+		     PCI_DMA_TODEVICE);
+	return rc;
+}
+
+static u32 mvs_get_ncq_tag(struct sas_task *task, u32 *tag)
+{
+	struct ata_queued_cmd *qc = task->uldd_task;
+
+	if (qc) {
+		if (qc->tf.command == ATA_CMD_FPDMA_WRITE ||
+			qc->tf.command == ATA_CMD_FPDMA_READ) {
+			*tag = qc->tag;
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int mvs_task_prep_ata(struct mvs_info *mvi,
+			     struct mvs_task_exec_info *tei)
+{
+	struct sas_task *task = tei->task;
+	struct domain_device *dev = task->dev;
+	struct mvs_device *mvi_dev =
+		(struct mvs_device *)dev->lldd_dev;
+	struct mvs_cmd_hdr *hdr = tei->hdr;
+	struct asd_sas_port *sas_port = dev->port;
+	struct mvs_slot_info *slot;
+	void *buf_prd;
+	u32 tag = tei->tag, hdr_tag;
+	u32 flags;
+	void *buf_tmp;
+	u8 *buf_cmd, *buf_oaf;
+	dma_addr_t buf_tmp_dma;
+	u32 i, req_len, resp_len;
+	const u32 max_resp_len = SB_RFB_MAX;
+
+	if (mvs_assign_reg_set(mvi, mvi_dev) == MVS_ID_NOT_MAPPED){
+		mv_dprintk("Have not enough regiset for dev %d.\n",mvi_dev->device_id);
+		return -EBUSY;
+	}
+	slot = &mvi->slot_info[tag];
+	slot->tx = mvi->tx_prod;
+	mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | tag |
+					(TXQ_CMD_STP << TXQ_CMD_SHIFT) |
+					(sas_port->phy_mask << TXQ_PHY_SHIFT) |
+					(mvi_dev->taskfileset << TXQ_SRS_SHIFT));
+
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	if (task->data_dir == DMA_FROM_DEVICE)
+		flags = (MVS_CHIP_DISP->prd_count() << MCH_PRD_LEN_SHIFT);
+	else
+		flags = (tei->n_elem << MCH_PRD_LEN_SHIFT);
+#else
+	flags = (tei->n_elem << MCH_PRD_LEN_SHIFT);
+#endif
+	if (task->ata_task.use_ncq)
+		flags |= MCH_FPDMA;
+	if (dev->sata_dev.command_set == ATAPI_COMMAND_SET) {
+		if (task->ata_task.fis.command != ATA_CMD_ID_ATAPI)
+			flags |= MCH_ATAPI;
+	}
+
+#if 0
+	printk("ata_cmd = 0x%X\n", task->ata_task.fis.command);
+	if (task->ata_task.fis.command == ATA_CMD_ID_ATAPI) {
+		struct ata_port *ap = dev->sata_dev.ap;
+		struct ata_device *adev = ap->link.device;
+		WARN_ON(1);
+		return -EIO;
+	}
+#endif
+	/* FIXME: fill in port multiplier number */
+
+	hdr->flags = cpu_to_le32(flags);
+
+	/* FIXME: the low order order 5 bits for the TAG if enable NCQ */
+	if (task->ata_task.use_ncq && mvs_get_ncq_tag(task, &hdr_tag))
+		task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
+	else
+		hdr_tag = tag;
+	hdr->tags = cpu_to_le32(hdr_tag);
+
+	hdr->data_len = cpu_to_le32(task->total_xfer_len);
+
+	/*
+	 * arrange MVS_SLOT_BUF_SZ-sized DMA buffer according to our needs
+	 */
+
+	/* region 1: command table area (MVS_ATA_CMD_SZ bytes) ************** */
+	buf_cmd = buf_tmp = slot->buf;
+	buf_tmp_dma = slot->buf_dma;
+
+	hdr->cmd_tbl = cpu_to_le64(buf_tmp_dma);
+
+	buf_tmp += MVS_ATA_CMD_SZ;
+	buf_tmp_dma += MVS_ATA_CMD_SZ;
+#if _MV_DUMP
+	slot->cmd_size = MVS_ATA_CMD_SZ;
+#endif
+
+	/* region 2: open address frame area (MVS_OAF_SZ bytes) ********* */
+	/* used for STP.  unused for SATA? */
+	buf_oaf = buf_tmp;
+	hdr->open_frame = cpu_to_le64(buf_tmp_dma);
+
+	buf_tmp += MVS_OAF_SZ;
+	buf_tmp_dma += MVS_OAF_SZ;
+
+	/* region 3: PRD table ********************************************* */
+	buf_prd = buf_tmp;
+
+	if (tei->n_elem)
+		hdr->prd_tbl = cpu_to_le64(buf_tmp_dma);
+	else
+		hdr->prd_tbl = 0;
+	i = MVS_CHIP_DISP->prd_size() * MVS_CHIP_DISP->prd_count();
+
+	buf_tmp += i;
+	buf_tmp_dma += i;
+
+	/* region 4: status buffer (larger the PRD, smaller this buf) ****** */
+	/* FIXME: probably unused, for SATA.  kept here just in case
+	 * we get a STP/SATA error information record
+	 */
+	slot->response = buf_tmp;
+	hdr->status_buf = cpu_to_le64(buf_tmp_dma);
+	if (mvi->flags & MVF_FLAG_SOC)
+		hdr->reserved[0] = 0;
+
+	req_len = sizeof(struct host_to_dev_fis);
+	resp_len = MVS_SLOT_BUF_SZ - MVS_ATA_CMD_SZ -
+	    sizeof(struct mvs_err_info) - i;
+
+	/* request, response lengths */
+	resp_len = min(resp_len, max_resp_len);
+	hdr->lens = cpu_to_le32(((resp_len / 4) << 16) | (req_len / 4));
+
+	if (likely(!task->ata_task.device_control_reg_update))
+		task->ata_task.fis.flags |= 0x80; /* C=1: update ATA cmd reg */
+	/* fill in command FIS and ATAPI CDB */
+	memcpy(buf_cmd, &task->ata_task.fis, sizeof(struct host_to_dev_fis));
+	if (dev->sata_dev.command_set == ATAPI_COMMAND_SET)
+		memcpy(buf_cmd + STP_ATAPI_CMD,
+			task->ata_task.atapi_packet, 16);
+
+	/* generate open address frame hdr (first 12 bytes) */
+	/* initiator, STP, ftype 1h */
+	buf_oaf[0] = (1 << 7) | (PROTOCOL_STP << 4) | 0x1;
+	buf_oaf[1] = dev->linkrate & 0xf;
+	*(u16 *)(buf_oaf + 2) = cpu_to_be16(mvi_dev->device_id + 1);
+	memcpy(buf_oaf + 4, dev->sas_addr, SAS_ADDR_SIZE);
+
+	/* fill in PRD (scatter/gather) table, if any */
+	MVS_CHIP_DISP->make_prd(task->scatter, tei->n_elem, buf_prd);
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	if (task->data_dir == DMA_FROM_DEVICE)
+		MVS_CHIP_DISP->dma_fix(mvi->bulk_buffer_dma,
+				TRASH_BUCKET_SIZE, tei->n_elem, buf_prd);
+#endif
+	return 0;
+}
+
+static int mvs_task_prep_ssp(struct mvs_info *mvi,
+			     struct mvs_task_exec_info *tei)
+{
+	struct sas_task *task = tei->task;
+	struct mvs_cmd_hdr *hdr = tei->hdr;
+	struct mvs_port *port = tei->port;
+	struct domain_device *dev = task->dev;
+	struct mvs_device *mvi_dev =
+		(struct mvs_device *)dev->lldd_dev;
+	struct asd_sas_port *sas_port = dev->port;
+	struct mvs_slot_info *slot;
+	void *buf_prd;
+	struct ssp_frame_hdr *ssp_hdr;
+	void *buf_tmp;
+	u8 *buf_cmd, *buf_oaf, fburst = 0;
+	dma_addr_t buf_tmp_dma;
+	u32 flags;
+	u32 resp_len, req_len, i, tag = tei->tag;
+	const u32 max_resp_len = SB_RFB_MAX;
+	u32 phy_mask;
+
+	slot = &mvi->slot_info[tag];
+
+	phy_mask = ((port->wide_port_phymap) ? port->wide_port_phymap :
+		sas_port->phy_mask) & TXQ_PHY_MASK;
+
+	slot->tx = mvi->tx_prod;
+	mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | tag |
+				(TXQ_CMD_SSP << TXQ_CMD_SHIFT) |
+				(phy_mask << TXQ_PHY_SHIFT));
+
+	flags = MCH_RETRY;
+	if (task->ssp_task.enable_first_burst) {
+		flags |= MCH_FBURST;
+		fburst = (1 << 7);
+	}
+	hdr->flags = cpu_to_le32(flags |
+				 (tei->n_elem << MCH_PRD_LEN_SHIFT) |
+				 (MCH_SSP_FR_CMD << MCH_SSP_FR_TYPE_SHIFT));
+	hdr->tags = cpu_to_le32(tag);
+	hdr->data_len = cpu_to_le32(task->total_xfer_len);
+
+	/*
+	 * arrange MVS_SLOT_BUF_SZ-sized DMA buffer according to our needs
+	 */
+
+	/* region 1: command table area (MVS_SSP_CMD_SZ bytes) ************** */
+	buf_cmd = buf_tmp = slot->buf;
+	buf_tmp_dma = slot->buf_dma;
+
+	hdr->cmd_tbl = cpu_to_le64(buf_tmp_dma);
+
+	buf_tmp += MVS_SSP_CMD_SZ;
+	buf_tmp_dma += MVS_SSP_CMD_SZ;
+#if _MV_DUMP
+	slot->cmd_size = MVS_SSP_CMD_SZ;
+#endif
+
+	/* region 2: open address frame area (MVS_OAF_SZ bytes) ********* */
+	buf_oaf = buf_tmp;
+	hdr->open_frame = cpu_to_le64(buf_tmp_dma);
+
+	buf_tmp += MVS_OAF_SZ;
+	buf_tmp_dma += MVS_OAF_SZ;
+
+	/* region 3: PRD table ********************************************* */
+	buf_prd = buf_tmp;
+	if (tei->n_elem)
+		hdr->prd_tbl = cpu_to_le64(buf_tmp_dma);
+	else
+		hdr->prd_tbl = 0;
+
+	i = MVS_CHIP_DISP->prd_size() * tei->n_elem;
+	buf_tmp += i;
+	buf_tmp_dma += i;
+
+	/* region 4: status buffer (larger the PRD, smaller this buf) ****** */
+	slot->response = buf_tmp;
+	hdr->status_buf = cpu_to_le64(buf_tmp_dma);
+	if (mvi->flags & MVF_FLAG_SOC)
+		hdr->reserved[0] = 0;
+
+	resp_len = MVS_SLOT_BUF_SZ - MVS_SSP_CMD_SZ - MVS_OAF_SZ -
+	    sizeof(struct mvs_err_info) - i;
+	resp_len = min(resp_len, max_resp_len);
+
+	req_len = sizeof(struct ssp_frame_hdr) + 28;
+
+	/* request, response lengths */
+	hdr->lens = cpu_to_le32(((resp_len / 4) << 16) | (req_len / 4));
+
+	/* generate open address frame hdr (first 12 bytes) */
+	/* initiator, SSP, ftype 1h */
+	buf_oaf[0] = (1 << 7) | (PROTOCOL_SSP << 4) | 0x1;
+	buf_oaf[1] = dev->linkrate & 0xf;
+	*(u16 *)(buf_oaf + 2) = cpu_to_be16(mvi_dev->device_id + 1);
+	memcpy(buf_oaf + 4, dev->sas_addr, SAS_ADDR_SIZE);
+
+	/* fill in SSP frame header (Command Table.SSP frame header) */
+	ssp_hdr = (struct ssp_frame_hdr *)buf_cmd;
+	ssp_hdr->frame_type = SSP_COMMAND;
+	memcpy(ssp_hdr->hashed_dest_addr, dev->hashed_sas_addr,
+	       HASHED_SAS_ADDR_SIZE);
+	memcpy(ssp_hdr->hashed_src_addr,
+	       dev->hashed_sas_addr, HASHED_SAS_ADDR_SIZE);
+	ssp_hdr->tag = cpu_to_be16(tag);
+
+	/* fill in command frame IU */
+	buf_cmd += sizeof(*ssp_hdr);
+	memcpy(buf_cmd, &task->ssp_task.LUN, 8);
+	buf_cmd[9] = fburst | task->ssp_task.task_attr |
+			(task->ssp_task.task_prio << 3);
+	memcpy(buf_cmd + 12, &task->ssp_task.cdb, 16);
+
+	/* fill in PRD (scatter/gather) table, if any */
+	MVS_CHIP_DISP->make_prd(task->scatter, tei->n_elem, buf_prd);
+	return 0;
+}
+#define	DEV_IS_GONE(mvi_dev)	((!mvi_dev || (mvi_dev->dev_type == NO_DEVICE)))
+static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
+				struct completion *completion, int lock)
+{
+	struct domain_device *dev = task->dev;
+	struct mvs_info *mvi;
+	struct mvs_device *mvi_dev;
+	struct mvs_task_exec_info tei;
+	struct sas_task *t = task;
+	struct mvs_slot_info *slot;
+	u32 tag = 0xdeadbeef, rc, n_elem = 0;
+	unsigned long flags=0;
+	u32 n = num, pass = 0;
+
+#if 0
+	if(task->uldd_task){
+		cmd = (struct scsi_cmnd *)task->uldd_task;
+		printk("\n");
+		for(i=0; i< 16; i++){
+			printk("%02x ",cmd->cmnd[i]);
+		}
+		printk("\n");
+	}
+#endif
+
+	mvi = mvs_find_dev_mvi(task->dev);
+
+	if(lock)
+	spin_lock_irqsave(&mvi->lock, flags);
+	do {
+		dev = t->dev;
+		mvi_dev = (struct mvs_device *)dev->lldd_dev;
+		if(DEV_IS_GONE(mvi_dev)) {
+			if (mvi_dev)
+				mv_dprintk("device %d not ready.\n", mvi_dev->device_id);
+			else
+				mv_dprintk("device %016llx not ready.\n", SAS_ADDR(dev->sas_addr));
+
+			rc = SAS_PHY_DOWN;
+			goto out_done;
+		}
+
+		if(dev->port->id >= mvi->chip->n_phy )
+			tei.port = &mvi->port[dev->port->id - mvi->chip->n_phy];
+		else
+			tei.port = &mvi->port[dev->port->id];
+
+		if (!tei.port->port_attached) {
+			if (sas_protocol_ata(t->task_proto)) {
+				mv_dprintk("port %d does not attached device.\n",dev->port->id);
+				rc = SAS_PHY_DOWN;
+				goto out_done;
+			} else {
+				struct task_status_struct *ts = &t->task_status;
+				ts->resp = SAS_TASK_UNDELIVERED;
+				ts->stat = SAS_PHY_DOWN;
+				t->task_done(t);
+				if (n > 1)
+					t = list_entry(t->list.next,
+							struct sas_task, list);
+				continue;
+			}
+		}
+
+		if (!sas_protocol_ata(t->task_proto)) {
+			if (t->num_scatter) {
+				n_elem = dma_map_sg(mvi->dev,
+						    t->scatter,
+						    t->num_scatter,
+						    t->data_dir);
+				if (!n_elem) {
+					rc = -ENOMEM;
+					goto err_out;
+				}
+			}
+		} else {
+			n_elem = t->num_scatter;
+		}
+
+		rc = mvs_tag_alloc(mvi, &tag);
+		if (rc)
+			goto err_out;
+
+		slot = &mvi->slot_info[tag];
+		t->lldd_task = NULL;
+		slot->n_elem = n_elem;
+		slot->slot_tag = tag;
+		memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
+		slot->slot_completion = completion;
+
+		tei.task = t;
+		tei.hdr = &mvi->slot[tag];
+		tei.tag = tag;
+		tei.n_elem = n_elem;
+		switch (t->task_proto) {
+		case SAS_PROTOCOL_SMP:
+			rc = mvs_task_prep_smp(mvi, &tei);
+			break;
+		case SAS_PROTOCOL_SSP:
+			rc = mvs_task_prep_ssp(mvi, &tei);
+			break;
+		case SAS_PROTOCOL_SATA:
+		case SAS_PROTOCOL_STP:
+		case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+			rc = mvs_task_prep_ata(mvi, &tei);
+			break;
+		default:
+			dev_printk(KERN_ERR, mvi->dev,
+				"unknown sas_task proto: 0x%x\n",
+				t->task_proto);
+			rc = -EINVAL;
+			break;
+		}
+
+		if (rc){
+			printk("rc is %x\n",rc);
+			goto err_out_tag;
+		}
+		slot->task = t;
+		slot->port = tei.port;
+		t->lldd_task = (void *) slot;
+		list_add_tail(&slot->entry, &tei.port->list);
+		/* TODO: select normal or high priority */
+		spin_lock(&t->task_state_lock);
+		t->task_state_flags |= SAS_TASK_AT_INITIATOR;
+		spin_unlock(&t->task_state_lock);
+
+		mvs_hba_memory_dump(mvi, tag, t->task_proto);
+
+		++pass;
+		mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_CHIP_SLOT_SZ - 1);
+		if (n > 1)
+			t = list_entry(t->list.next, struct sas_task, list);
+	} while (--n);
+	rc = 0;
+	goto out_done;
+
+err_out_tag:
+	mvs_tag_free(mvi, tag);
+err_out:
+
+	dev_printk(KERN_ERR,mvi->dev, "mvsas exec failed[%d]!\n", rc);
+	if (!sas_protocol_ata(t->task_proto))
+		if (n_elem)
+			dma_unmap_sg(mvi->dev, t->scatter, n_elem,
+				     t->data_dir);
+out_done:
+	if (likely(pass))
+		MVS_CHIP_DISP->start_delivery(mvi,
+			(mvi->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
+#if 0
+	if (t->uldd_task && !completion) {
+		struct scsi_cmnd *scmd;
+		extern int scsi_delete_timer(struct scsi_cmnd *scmd);
+		extern void scsi_add_timer(struct scsi_cmnd *scmd, int timeout,
+		    void (*complete)(struct scsi_cmnd *));
+		extern void scsi_times_out(struct scsi_cmnd *scmd);
+		if (dev_is_sata(dev)) {
+			struct ata_queued_cmd *qc = task->uldd_task;
+			scmd = qc->scsicmd;
+		} else
+			scmd = (struct scsi_cmnd *)t->uldd_task;
+		if (scmd) {
+			scsi_delete_timer(scmd);
+			scsi_add_timer(scmd, 0, scsi_times_out);
+		}
+	}
+#endif
+	if(lock)
+		spin_unlock_irqrestore(&mvi->lock, flags);
+	return rc;
+}
+
+int mvs_queue_command(struct sas_task *task, const int num,
+			gfp_t gfp_flags)
+{
+	return mvs_task_exec(task, num, gfp_flags, NULL, 1);
+}
+
+static void mvs_slot_free(struct mvs_info *mvi, u32 rx_desc)
+{
+	u32 slot_idx = rx_desc & RXQ_SLOT_MASK;
+	mvs_tag_clear(mvi, slot_idx);
+}
+
+static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
+			  struct mvs_slot_info *slot, u32 slot_idx)
+{
+	if (!slot->task)
+		return;
+	if (!sas_protocol_ata(task->task_proto))
+		if (slot->n_elem)
+			dma_unmap_sg(mvi->dev, task->scatter,
+				     slot->n_elem, task->data_dir);
+
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SMP:
+		dma_unmap_sg(mvi->dev, &task->smp_task.smp_resp, 1,
+			     PCI_DMA_FROMDEVICE);
+		dma_unmap_sg(mvi->dev, &task->smp_task.smp_req, 1,
+			     PCI_DMA_TODEVICE);
+		break;
+
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SSP:
+	default:
+		/* do nothing */
+		break;
+	}
+	list_del(&slot->entry);
+	task->lldd_task = NULL;
+	slot->task = NULL;
+	slot->port = NULL;
+	slot->slot_tag = 0xFFFFFFFF;
+	mvs_slot_free(mvi, slot_idx);
+}
+
+int mvs_task_abort(struct sas_task *task)
+{
+	int rc = TMF_RESP_FUNC_FAILED;
+	unsigned long flags;
+	struct mvs_info *mvi = NULL;
+	int tag;
+	struct mvs_device *mvi_dev = (struct mvs_device *)task->dev->lldd_dev;
+
+	DECLARE_COMPLETION_ONSTACK(cmd_completion);
+	DECLARE_COMPLETION_ONSTACK(reset_completion);
+
+	mvi = mvs_find_dev_mvi(task->dev);
+
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
+		rc = TMF_RESP_FUNC_COMPLETE;
+		spin_unlock_irqrestore(&task->task_state_lock, flags);
+		goto out_done;
+	}
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
+	if(!DEV_IS_GONE(mvi_dev))
+		mv_dprintk("dev[%d:%x] is aborting.\n", mvi_dev->device_id, mvi_dev->dev_type);
+	else
+		mv_dprintk("device has gone before abort.\n");
+
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SMP:
+		mv_dprintk( "SMP Abort! \n");
+		break;
+	case SAS_PROTOCOL_SSP:
+		mv_dprintk("SSP[%016llx] Abort!\n",(u64)(*(u64 *) task->ssp_task.cdb));
+		break;
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:{
+		mv_dprintk("STP[%016llx] Abort!\n",(u64)(*(u64 *)&task->ata_task.fis));
+#if _MV_DUMP
+		mv_dprintk("Dump H2D FIS: \n");
+		mvs_hexdump(sizeof(struct host_to_dev_fis),
+				(void *)&task->ata_task.fis, 0);
+		mv_dprintk("Dump ATAPI Cmd : \n");
+		mvs_hexdump(16, task->ata_task.atapi_packet, 0);
+#endif
+		spin_lock_irqsave(&task->task_state_lock, flags);
+		if (task->task_state_flags & SAS_TASK_NEED_DEV_RESET) {
+			/* TODO */
+			;
+		}
+		spin_unlock_irqrestore(&task->task_state_lock, flags);
+		task->ata_task.use_ncq = 0;
+		break;
+	}
+	default:
+		break;
+	}
+
+	spin_lock_irqsave(&mvi->lock, flags);
+	if (mvs_find_tag(mvi, task, &tag)) {
+		MVS_CHIP_DISP->command_active(mvi, tag);
+		if (sas_protocol_ata(task->task_proto)){
+			mvs_free_reg_set(mvi, mvi_dev);
+		}
+	}
+	spin_unlock_irqrestore(&mvi->lock, flags);
+
+	if (!mvs_task_exec(task, 1, GFP_ATOMIC, &cmd_completion, 1)) {
+		mv_dprintk("Retry command.\n");
+		if (!wait_for_completion_timeout(&cmd_completion, 15 * HZ)) {
+			mv_printk("retry timeout..\n");
+			rc = TMF_RESP_FUNC_FAILED;
+			if (sas_protocol_ata(task->task_proto)){
+				mvs_free_reg_set(mvi, mvi_dev);
+			}
+			goto out_done;
+		}
+		spin_lock_irqsave(&task->task_state_lock, flags);
+		if (task->task_state_flags & SAS_TASK_STATE_DONE) {
+			rc = TMF_RESP_FUNC_COMPLETE;
+			mv_dprintk("Retry command finished.\n");
+		}
+		spin_unlock_irqrestore(&task->task_state_lock, flags);
+	} else
+		rc = TMF_RESP_FUNC_FAILED;
+out_done:
+	return rc;
+}
+
+static void mvs_update_wideport(struct mvs_info *mvi, int i)
+{
+	struct mvs_phy *phy = &mvi->phy[i];
+	struct mvs_port *port = phy->port;
+	int j, no;
+
+	for_each_phy(port->wide_port_phymap, j, no) {
+		if (j & 1) {
+			MVS_CHIP_DISP->write_port_cfg_addr(mvi, no,
+						PHYR_WIDE_PORT);
+			MVS_CHIP_DISP->write_port_cfg_data(mvi, no,
+						port->wide_port_phymap);
+		} else {
+			MVS_CHIP_DISP->write_port_cfg_addr(mvi, no,
+						PHYR_WIDE_PORT);
+			MVS_CHIP_DISP->write_port_cfg_data(mvi, no,
+						0);
+		}
+	}
+}
+
+static u32 mvs_is_phy_ready(struct mvs_info *mvi, int i)
+{
+	u32 tmp;
+	struct mvs_phy *phy = &mvi->phy[i];
+	struct mvs_port *port = phy->port;
+
+	tmp = MVS_CHIP_DISP->read_phy_ctl(mvi, i);
+	if ((tmp & PHY_READY_MASK) && !(phy->irq_status & PHYEV_POOF)) {
+		if (!port)
+			phy->phy_attached = 1;
+		return tmp;
+	}
+
+	if (port) {
+		if (phy->phy_type & PORT_TYPE_SAS) {
+			port->wide_port_phymap &= ~(1U << i);
+			if (!port->wide_port_phymap)
+				port->port_attached = 0;
+			mvs_update_wideport(mvi, i);
+		} else if (phy->phy_type & PORT_TYPE_SATA)
+			port->port_attached = 0;
+		phy->port = NULL;
+		phy->phy_attached = 0;
+		phy->phy_type &= ~(PORT_TYPE_SAS | PORT_TYPE_SATA);
+	}
+	return 0;
+}
+
+static void *mvs_get_d2h_reg(struct mvs_info *mvi, int i, void *buf)
+{
+	u32 *s = (u32 *) buf;
+
+	if (!s)
+		return NULL;
+
+	MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG3);
+	s[3] = MVS_CHIP_DISP->read_port_cfg_data(mvi, i);
+
+	MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG2);
+	s[2] = MVS_CHIP_DISP->read_port_cfg_data(mvi, i);
+
+	MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG1);
+	s[1] = MVS_CHIP_DISP->read_port_cfg_data(mvi, i);
+
+	MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG0);
+	s[0] = MVS_CHIP_DISP->read_port_cfg_data(mvi, i);
+
+	/* Workaround: take some ATAPI devices for ATA */
+	if (((s[1] & 0x00FFFFFF) == 0x00EB1401) && (*(u8 *)&s[3] == 0x01))
+		s[1] = 0x00EB1401 | (*((u8 *)&s[1] + 3) & 0x10);
+
+	return (void *)s;
+}
+
+static u32 mvs_is_sig_fis_received(u32 irq_status)
+{
+	return irq_status & PHYEV_SIG_FIS;
+}
+
+void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st)
+{
+	struct mvs_phy *phy = &mvi->phy[i];
+	struct sas_identify_frame *id;
+
+	id = (struct sas_identify_frame *)phy->frame_rcvd;
+
+	if (get_st) {
+		phy->irq_status = MVS_CHIP_DISP->read_port_irq_stat(mvi, i);
+		phy->phy_status = mvs_is_phy_ready(mvi, i);
+	}
+	mv_dprintk("port %d phy status=0x%x.\n", i + mvi->id * mvi->chip->n_phy,
phy->phy_status);
+	if (phy->phy_status) {
+		int oob_done = 0;
+		struct asd_sas_phy * sas_phy = &mvi->phy[i].sas_phy;
+
+		oob_done = MVS_CHIP_DISP->oob_done(mvi, i);
+
+		MVS_CHIP_DISP->fix_phy_info(mvi, i, id);
+		if (phy->phy_type & PORT_TYPE_SAS
+			|| phy->att_dev_info & PORT_SSP_INIT_MASK) {
+			phy->phy_attached = 1;
+			phy->identify.device_type =
+				phy->att_dev_info & PORT_DEV_TYPE_MASK;
+
+			if (phy->identify.device_type == SAS_END_DEV)
+				phy->identify.target_port_protocols =
+							SAS_PROTOCOL_SSP;
+			else if (phy->identify.device_type != NO_DEVICE)
+				phy->identify.target_port_protocols =
+							SAS_PROTOCOL_SMP;
+			if (oob_done)
+				sas_phy->oob_mode = SAS_OOB_MODE;
+			phy->frame_rcvd_size =
+			    sizeof(struct sas_identify_frame);
+		} else if (phy->phy_type & PORT_TYPE_SATA) {
+			phy->identify.target_port_protocols = SAS_PROTOCOL_STP;
+			if (mvs_is_sig_fis_received(phy->irq_status)) {
+				phy->phy_attached = 1;
+				phy->att_dev_sas_addr = i + mvi->id * mvi->chip->n_phy;
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
+		}
+		memcpy(sas_phy->attached_sas_addr, &phy->att_dev_sas_addr, SAS_ADDR_SIZE);
+
+		if (MVS_CHIP_DISP->phy_work_around)
+			MVS_CHIP_DISP->phy_work_around(mvi, i);
+	}
+	mv_dprintk("port %d attach dev info is %x\n", i + mvi->id *mvi->chip->n_phy ,
phy->att_dev_info);
+	mv_dprintk("port %d attach sas addr is %llx\n", i + mvi->id *mvi->chip->n_phy,
phy->att_dev_sas_addr);
+out_done:
+	if (get_st)
+		MVS_CHIP_DISP->write_port_irq_stat(mvi, i, phy->irq_status);
+}
+
+static void mvs_port_notify_formed(struct asd_sas_phy *sas_phy, int lock)
+{
+	struct sas_ha_struct *sas_ha = sas_phy->ha;
+	struct mvs_info *mvi = NULL; int i=0;
+	struct mvs_phy *phy = sas_phy->lldd_phy;
+	struct asd_sas_port *sas_port = sas_phy->port;
+	struct mvs_port *port;
+	unsigned long flags = 0;
+	if (!sas_port)
+		return;
+
+	while(sas_ha->sas_phy[i]){
+		if(sas_ha->sas_phy[i]== sas_phy)
+			break;
+		i++;
+	}
+	mvi = ((struct mvs_info **)(sas_ha->lldd_ha))[i/((unsigned long
*)sas_ha->lldd_ha)[1] + 2];
+	if(sas_port->id >= mvi->chip->n_phy)
+		port = &mvi->port[sas_port->id -mvi->chip->n_phy];
+	else
+		port = &mvi->port[sas_port->id];
+	if (lock)
+		spin_lock_irqsave(&mvi->lock, flags);
+	port->port_attached = 1;
+	phy->port = port;
+	if (phy->phy_type & PORT_TYPE_SAS) {
+		port->wide_port_phymap = sas_port->phy_mask;
+		mv_printk("set wide port phy map %x\n", sas_port->phy_mask);
+		mvs_update_wideport(mvi, sas_phy->id);
+	}
+	if (lock)
+		spin_unlock_irqrestore(&mvi->lock, flags);
+}
+
+static void mvs_port_notify_deformed(struct asd_sas_phy *sas_phy, int lock)
+{
+	/* TBD */
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
+struct mvs_device * mvs_alloc_dev(struct mvs_info *mvi)
+{
+	u32 dev;
+	for(dev=0; dev<MVS_MAX_DEVICES; dev++){
+		if(mvi->devices[dev].dev_type == NO_DEVICE){
+			mvi->devices[dev].device_id = dev;
+			return &mvi->devices[dev];
+		}
+	}
+
+	if(dev == MVS_MAX_DEVICES){
+		mv_printk("max support %d devices, ignore ..\n",MVS_MAX_DEVICES);
+	}
+
+	return NULL;
+}
+
+void mvs_free_dev(struct mvs_device *mvi_dev)
+{
+	u32 id = mvi_dev->device_id;
+	memset(mvi_dev, 0, sizeof(* mvi_dev));
+	mvi_dev->device_id = id;
+	mvi_dev->dev_type = NO_DEVICE;
+	mvi_dev->taskfileset = MVS_ID_NOT_MAPPED;
+}
+
+#define DEV_IS_EXPANDER(type)		((type == EDGE_DEV) || (type == FANOUT_DEV))
+
+int mvs_dev_found_notify(struct domain_device *dev, int lock)
+{
+	unsigned long flags=0;
+	int res = 0;
+	struct mvs_info *mvi = NULL;
+	struct domain_device * parent_dev = dev->parent;
+	struct mvs_device *mvi_device;
+
+	mvi = mvs_find_dev_mvi(dev);
+
+	if(lock)
+	spin_lock_irqsave(&mvi->lock, flags);
+
+	mvi_device = mvs_alloc_dev(mvi);
+	if(!mvi_device){
+		res = -1;
+		goto found_out;
+	}
+	dev->lldd_dev = (void *)mvi_device;
+	mvi_device->dev_type = dev->dev_type;
+
+	/* find attached phy id. */
+	if(parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type) ){
+		int phy_id;
+		struct ex_phy *phy;
+		for(phy_id=0; phy_id<parent_dev->ex_dev.num_phys; phy_id++){
+			phy = &parent_dev->ex_dev.ex_phy[phy_id];
+			if(SAS_ADDR(phy->attached_sas_addr) == SAS_ADDR(dev->sas_addr)){
+		#if 0
+				mv_dprintk("device[%d:%x] at ex:%016llx phy%d.\n",
+					mvi_device->device_id, mvi_device->dev_type,
+					SAS_ADDR(parent_dev->sas_addr),
+					phy_id);
+		#endif
+				mvi_device->attached_phy = phy_id;
+				break;
+			}
+		}
+
+		if(phy_id == parent_dev->ex_dev.num_phys){
+			mv_printk("Error: no attached dev:%016llx at ex:%016llx.\n",
+				SAS_ADDR(dev->sas_addr), SAS_ADDR(parent_dev->sas_addr));
+			res = -1;
+		}
+	}
+
+
+found_out:
+	if(lock)
+	spin_unlock_irqrestore(&mvi->lock, flags);
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
+	unsigned long flags=0;
+	struct mvs_info *mvi;
+	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
+
+	mvi = mvs_find_dev_mvi(dev);
+
+	if(lock)
+		spin_lock_irqsave(&mvi->lock, flags);
+
+	if(mvi_dev){
+		mv_dprintk("found dev[%d:%x] is gone.\n",mvi_dev->device_id,mvi_dev->dev_type);
+		mvs_free_reg_set(mvi, mvi_dev);
+		mvs_free_dev(mvi_dev);
+	#if 0
+		if(parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type) ){
+			struct expander_device *ex = &parent_dev->ex_dev;
+			struct ex_phy *changed_phy = &ex->ex_phy[mvi_dev->attached_phy];
+			memset(changed_phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
+		}
+	#endif
+	}else {
+		mv_dprintk("found dev has gone.\n");
+	}
+	dev->lldd_dev = NULL;
+
+	if(lock)
+		spin_unlock_irqrestore(&mvi->lock, flags);
+}
+
+
+void mvs_dev_gone(struct domain_device *dev)
+{
+	mvs_dev_gone_notify(dev, 1);
+}
+#if 0
+static  struct sas_task *mvs_alloc_task(void)
+{
+	struct sas_task *task = kzalloc( sizeof(struct sas_task), GFP_KERNEL);
+
+	if (task) {
+		INIT_LIST_HEAD(&task->list);
+		spin_lock_init(&task->task_state_lock);
+		task->task_state_flags = SAS_TASK_STATE_PENDING;
+		init_timer(&task->timer);
+		init_completion(&task->completion);
+	}
+
+	return task;
+}
+
+
+static  void mvs_free_task(struct sas_task *task)
+{
+	if (task) {
+		BUG_ON(!list_empty(&task->list));
+		kfree( task);
+	}
+}
+
+
+
+static void mvs_task_done(struct sas_task *task)
+{
+	if (!del_timer(&task->timer))
+		return;
+	complete(&task->completion);
+}
+
+static void mvs_task_timedout(unsigned long _task)
+{
+	struct sas_task *task = (void *) _task;
+	unsigned long flags;
+
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (!(task->task_state_flags & SAS_TASK_STATE_DONE))
+		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
+
+	complete(&task->completion);
+}
+
+#define MVS_TASK_TIMEOUT 10
+static int mvs_execute_blocked_task(struct domain_device *dev, void *parameter,
u32 para_len)
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
+		task->timer.function = mvs_task_timedout;
+		task->timer.expires = jiffies + MVS_TASK_TIMEOUT*HZ;
+		add_timer(&task->timer);
+
+		res = mvs_task_exec(task, 1, GFP_KERNEL, NULL, 0);
+
+		if (res) {
+			del_timer(&task->timer);
+			mv_printk("executing internel task failed:%d\n", res);
+			goto ex_err;
+		}
+
+		wait_for_completion(&task->completion);
+		res = -ECOMM;
+		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
+			mv_dprintk("task timed out or aborted\n");
+			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
+				mv_printk("task aborted and not done\n");
+				goto ex_err;
+			}
+		}
+		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		    task->task_status.stat == SAM_GOOD) {
+			mv_dprintk("blocked task ok.\n");
+			res = 0;
+			break;
+		} if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		      task->task_status.stat == SAS_DATA_UNDERRUN) {
+			/* no error, but return the number of bytes of
+			 * underrun */
+			res = task->task_status.residual;
+			break;
+		} if (task->task_status.resp == SAS_TASK_COMPLETE &&
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
+		}
+	}
+ex_err:
+	BUG_ON(retry == 3 && task != NULL);
+	if (task != NULL) {
+		mvs_free_task(task);
+	}
+	return res;
+}
+
+#define MVS_PC_REQ_SIZE  44
+#define MVS_PC_RESP_SIZE 8
+
+int mvs_smp_phy_control(struct domain_device *dev, int phy_id,
+			enum phy_func phy_func,
+			struct sas_phy_linkrates *rates)
+{
+	u8 *pc_req;
+	u8 *pc_resp;
+	int res;
+	struct sas_smp_task smp_task;
+	struct mvs_device *mvi_dev =
+		(struct mvs_device *)dev->lldd_dev;
+	mv_dprintk("smp phy control for dev %d.\n", mvi_dev->device_id);
+	pc_req = kzalloc(MVS_PC_REQ_SIZE, GFP_KERNEL);
+	if (!pc_req)
+		return -ENOMEM;
+
+	pc_resp = kzalloc(MVS_PC_RESP_SIZE, GFP_KERNEL);
+	if (!pc_resp) {
+		kfree(pc_req);
+		return -ENOMEM;
+	}
+
+	sg_init_one(&smp_task.smp_req, pc_req, MVS_PC_REQ_SIZE);
+	sg_init_one(&smp_task.smp_resp, pc_resp, MVS_PC_RESP_SIZE);
+
+	pc_req[0] = SMP_REQUEST;
+	pc_req[1] = SMP_PHY_CONTROL;
+	pc_req[9] = phy_id;
+	pc_req[10]= phy_func;
+	if (rates) {
+		pc_req[32] = rates->minimum_linkrate << 4;
+		pc_req[33] = rates->maximum_linkrate << 4;
+	}
+
+	res = mvs_execute_blocked_task(dev, (void *)&smp_task, sizeof(smp_task));
+
+	kfree(pc_resp);
+	kfree(pc_req);
+	return res;
+}
+
+
+
+int mvs_reset_device(struct domain_device *dev)
+{
+	int rc = TMF_RESP_FUNC_FAILED;
+	struct mvs_info *mvi =dev->port->ha->lldd_ha;
+	struct domain_device * parent_dev = dev->parent;
+	struct mvs_device *mvi_dev =
+		(struct mvs_device *)dev->lldd_dev;
+
+	mv_dprintk("reset device[%d:%x].\n",mvi_dev->device_id, mvi_dev->dev_type);
+	if(parent_dev && DEV_IS_EXPANDER(parent_dev ->dev_type) ){
+		mv_dprintk("reset device%d at ex:%016llx.\n",mvi_dev->device_id,
+			SAS_ADDR(parent_dev->sas_addr));
+		if(mvs_smp_phy_control(parent_dev, mvi_dev->attached_phy,
PHY_FUNC_HARD_RESET, NULL)){
+			mv_dprintk("smp phy reset failed for dev%d.\n",mvi_dev->device_id);
+			rc = TMF_RESP_FUNC_COMPLETE;
+		}
+	} else {
+		mvs_phys_reset(mvi, dev->port->phy_mask, 1);
+		rc = TMF_RESP_FUNC_COMPLETE;
+	}
+
+	return rc;
+
+}
+#endif
+int mvs_lu_reset(struct domain_device *dev, u8 *lun)
+{
+	return TMF_RESP_FUNC_FAILED;
+}
+
+int mvs_I_T_nexus_reset(struct domain_device *dev)
+{
+	return TMF_RESP_FUNC_COMPLETE;
+}
+
+int mvs_query_task(struct sas_task *task)
+{
+	return TMF_RESP_FUNC_FAILED;
+}
+
+static int mvs_sata_done(struct mvs_info *mvi, struct sas_task *task,
+			u32 slot_idx, int err)
+{
+	struct mvs_device *mvi_dev = (struct mvs_device *)task->dev->lldd_dev;
+	struct task_status_struct *tstat = &task->task_status;
+	struct ata_task_resp *resp = (struct ata_task_resp *)tstat->buf;
+	int stat = SAM_GOOD;
+
+
+	resp->frame_len = sizeof(struct dev_to_host_fis);
+	memcpy(&resp->ending_fis[0],
+	       SATA_RECEIVED_D2H_FIS(mvi_dev->taskfileset),
+	       sizeof(struct dev_to_host_fis));
+	tstat->buf_valid_size = sizeof(*resp);
+	if (unlikely(err)) {
+		stat = SAS_PROTO_RESPONSE;
+	}
+	return stat;
+}
+
+static int mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
+			 u32 slot_idx)
+{
+	struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
+	int stat;
+	u32 err_dw0 = le32_to_cpu(*(u32 *) (slot->response));
+	u32 tfs = 0;
+	enum mvs_port_type type = PORT_TYPE_SAS;
+
+	if (err_dw0 & CMD_ISS_STPD)
+		MVS_CHIP_DISP->issue_stop(mvi, type, tfs);
+
+	MVS_CHIP_DISP->command_active(mvi, slot_idx);
+
+	stat = SAM_CHECK_COND;
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SSP:
+		stat = SAS_ABORTED_TASK;
+		break;
+	case SAS_PROTOCOL_SMP:
+		stat = SAM_CHECK_COND;
+		break;
+
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+	{
+		struct mvs_device *mvi_dev = (struct mvs_device *)task->dev->lldd_dev;
+		struct dev_to_host_fis *d2h_fis =
+			(struct dev_to_host_fis *)SATA_RECEIVED_D2H_FIS(mvi_dev->taskfileset);
+
+		if(err_dw0 == 0x80400002){
+			mv_printk("find reserved error, why?\n");
+			d2h_fis->status = 0x01;
+			d2h_fis->error  = 0x61;
+		}
+
+		task->ata_task.use_ncq = 0;
+		stat = SAS_PROTO_RESPONSE;
+		mvs_sata_done(mvi, task, slot_idx, 1);
+
+	}
+		break;
+	default:
+		break;
+	}
+
+	return stat;
+}
+static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
+{
+	u32 slot_idx = rx_desc & RXQ_SLOT_MASK;
+	struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
+	struct sas_task *task = slot->task;
+	struct mvs_device *mvi_dev=NULL;
+	struct task_status_struct *tstat;
+	struct mvs_port *port;
+	bool aborted;
+	void *to;
+	enum exec_status sts;
+
+	if (unlikely(!task || !task->lldd_task))
+		return -1;
+
+	tstat = &task->task_status;
+
+
+	mvs_hba_cq_dump(mvi);
+
+	if(!task->dev->lldd_dev){
+		mv_dprintk("device has gone.\n");
+		tstat->stat = SAS_ABORTED_TASK;
+		goto out2;
+	}
+	mvi_dev = (struct mvs_device *)slot->task->dev->lldd_dev;
+
+	spin_lock(&task->task_state_lock);
+	task->task_state_flags &=
+		~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
+	task->task_state_flags |= SAS_TASK_STATE_DONE;
+	aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
+	spin_unlock(&task->task_state_lock);
+	if (unlikely(aborted)) {
+		if (sas_protocol_ata(task->task_proto))
+			mvs_free_reg_set(mvi, mvi_dev);
+		mvs_slot_task_free(mvi, task, slot, slot_idx);
+		if (!flags && slot->slot_completion)
+			complete(slot->slot_completion);
+		return -1;
+	}
+
+	port = slot->port;
+	memset(tstat, 0, sizeof(*tstat));
+	tstat->resp = SAS_TASK_COMPLETE;
+
+	if (unlikely(!port->port_attached || flags)) {
+		mv_dprintk("port has not device.\n");
+		tstat->stat = SAS_ABORTED_TASK;
+		goto out;
+	}
+
+
+	if (unlikely((rx_desc & RXQ_ERR) || (*(u64 *) slot->response))) {
+		mv_dprintk("Find device[%016llx] RXQ_ERR %X,err info:%016llx\n",
SAS_ADDR(task->dev->sas_addr),rx_desc,(u64)(*(u64 *) slot->response));
+	}
+
+	/* error info record present */
+	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
+		tstat->stat = mvs_slot_err(mvi, task, slot_idx);
+		goto out;
+	}
+
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SSP:
+		/* hw says status == 0, datapres == 0 */
+		if (rx_desc & RXQ_GOOD) {
+			tstat->stat = SAM_GOOD;
+			tstat->resp = SAS_TASK_COMPLETE;
+		}
+		/* response frame present */
+		else if (rx_desc & RXQ_RSP) {
+			struct ssp_response_iu *iu =
+			    slot->response + sizeof(struct mvs_err_info);
+			sas_ssp_task_response(mvi->dev, task, iu);
+		}
+
+		/* should never happen? */
+		else
+			tstat->stat = SAM_CHECK_COND;
+		break;
+
+	case SAS_PROTOCOL_SMP: {
+			struct scatterlist *sg_resp = &task->smp_task.smp_resp;
+			tstat->stat = SAM_GOOD;
+			to = kmap_atomic(sg_page(sg_resp), KM_IRQ0);
+			memcpy(to + sg_resp->offset,
+				slot->response + sizeof(struct mvs_err_info),
+				sg_dma_len(sg_resp));
+			kunmap_atomic(to, KM_IRQ0);
+			break;
+		}
+
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP: {
+			tstat->stat = mvs_sata_done(mvi, task, slot_idx, 0);
+			break;
+		}
+
+	default:
+		tstat->stat = SAM_CHECK_COND;
+		break;
+	}
+
+out:
+
+	if (sas_protocol_ata(task->task_proto))
+		mvs_free_reg_set(mvi, mvi_dev);
+out2:
+	mvs_slot_task_free(mvi, task, slot, slot_idx);
+
+	sts = tstat->stat;
+	spin_unlock(&mvi->lock);
+	if(task->task_done){
+		task->task_done(task);
+	} else {
+		mv_dprintk("why has not task_done.\n");
+	}
+	spin_lock(&mvi->lock);
+	return sts;
+}
+
+static void mvs_release_task(struct mvs_info *mvi, int phy_no)
+{
+	struct mvs_slot_info *slot, *slot2;
+	struct mvs_phy *phy = &mvi->phy[phy_no];
+	struct mvs_port *port = phy->port;
+	u32 slot_idx;
+
+	if (!port)
+		return;
+	list_for_each_entry_safe(slot, slot2, &port->list, entry) {
+		slot_idx = (u32) (slot - mvi->slot_info);
+		mvs_slot_complete(mvi, slot_idx, 1);
+		mv_dprintk("Release %d task %p\n", slot_idx, slot2);
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
+		} else if (phy->phy_event & PHY_PLUG_IN) {
+		}
+
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
+void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
+{
+	u32 tmp;
+	struct sas_ha_struct *sas_ha = mvi->sas;
+	struct mvs_phy *phy = &mvi->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+
+	phy->irq_status = MVS_CHIP_DISP->read_port_irq_stat(mvi, phy_no);
+
+	/*
+	* events is port event now ,
+	* we need check the interrupt status which belongs to per port.
+	*/
+	if (phy->irq_status & PHYEV_DEC_ERR) {
+		/* mv_dprintk("port %d phy decoding error.\n",phy_no); */
+	}
+
+	if (phy->irq_status & PHYEV_UNASSOC_FIS) {
+	}
+
+	if (phy->irq_status & PHYEV_POOF) {
+		if (!(phy->phy_event & PHY_PLUG_OUT)) {
+			int dev_sata = phy->phy_type & PORT_TYPE_SATA;
+			int ready;
+			mvs_release_task(mvi, phy_no);
+			phy->phy_event |= PHY_PLUG_OUT;
+			mvs_handle_event(mvi,
+				(void *)(unsigned long)phy_no,
+				PHY_PLUG_EVENT);
+			ready = mvs_is_phy_ready(mvi, phy_no);
+			if (!ready)
+				mv_dprintk("phy%d Unplug Notice\n",
+					phy_no);
+			if (ready || dev_sata) {
+				if (MVS_CHIP_DISP->stp_reset)
+					MVS_CHIP_DISP->stp_reset(mvi, phy_no);
+				else
+					MVS_CHIP_DISP->phy_reset(mvi, phy_no, 0);
+				return;
+			}
+		}
+	}
+	if (!(phy->irq_status & PHYEV_DEC_ERR))
+	{
+		if (phy->irq_status & PHYEV_COMWAKE) {
+			tmp = MVS_CHIP_DISP->read_port_irq_mask(mvi, phy_no);
+			MVS_CHIP_DISP->write_port_irq_mask(mvi, phy_no,
+						tmp | PHYEV_SIG_FIS);
+		}
+		if (phy->irq_status & (PHYEV_SIG_FIS | PHYEV_ID_DONE)) {
+			phy->phy_status = mvs_is_phy_ready(mvi, phy_no);
+			mv_dprintk("notify plug in on phy[%d]\n",phy_no);
+			if (phy->phy_status){
+				mdelay(10);
+				MVS_CHIP_DISP->detect_porttype(mvi, phy_no);
+				if (phy->phy_type & PORT_TYPE_SATA) {
+					tmp = MVS_CHIP_DISP->read_port_irq_mask(
+							mvi, phy_no);
+					tmp &= ~PHYEV_SIG_FIS;
+					MVS_CHIP_DISP->write_port_irq_mask(mvi,
+								phy_no, tmp);
+				}
+				mvs_update_phyinfo(mvi, phy_no, 0);
+				mvs_bytes_dmaed(mvi, phy_no);
+				/* whether driver is going to handle hot plug */
+				if (phy->phy_event & PHY_PLUG_OUT)
+				{
+					mvs_port_notify_formed(sas_phy, 0);
+					phy->phy_event &= ~PHY_PLUG_OUT;
+				}
+			} else {
+				mv_dprintk("plugin interrupt but phy%d is gone\n",phy_no);
+			}
+		} else if (phy->irq_status & PHYEV_BROAD_CH) {
+			mv_dprintk("port %d broadcast change.\n",phy_no);
+			sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		}
+	}
+	MVS_CHIP_DISP->write_port_irq_stat(mvi, phy_no, phy->irq_status);
+}
+
+int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
+{
+	u32 rx_prod_idx, rx_desc;
+	bool attn = false;
+
+	/* the first dword in the RX ring is special: it contains
+	 * a mirror of the hardware's RX producer index, so that
+	 * we don't have to stall the CPU reading that register.
+	 * The actual RX ring is offset by one dword, due to this.
+	 */
+	rx_prod_idx = mvi->rx_cons;
+	mvi->rx_cons = le32_to_cpu(mvi->rx[0]);
+	if (mvi->rx_cons == 0xfff)	/* h/w hasn't touched RX ring yet */
+		return 0;
+
+	/* The CMPL_Q may come late, read from register and try again
+	* note: if coalescing is enabled,
+	* it will need to read from register every time for sure
+	*/
+	if (unlikely(mvi->rx_cons == rx_prod_idx))
+		mvi->rx_cons = MVS_CHIP_DISP->rx_update(mvi) & RX_RING_SZ_MASK;
+
+	if (mvi->rx_cons == rx_prod_idx)
+		return 0;
+
+	while (mvi->rx_cons != rx_prod_idx) {
+
+		/* increment our internal RX consumer pointer */
+		rx_prod_idx = (rx_prod_idx + 1) & (MVS_RX_RING_SZ - 1);
+
+		rx_desc = le32_to_cpu(mvi->rx[rx_prod_idx + 1]);
+
+		if (likely(rx_desc & RXQ_DONE))
+			mvs_slot_complete(mvi, rx_desc, 0);
+
+		if (rx_desc & RXQ_ATTN) {
+			attn = true;
+		} else if (rx_desc & RXQ_ERR) {
+			if (!(rx_desc & RXQ_DONE))
+				mvs_slot_complete(mvi, rx_desc, 0);
+		} else if (rx_desc & RXQ_SLOT_RESET) {
+			mvs_slot_free(mvi, rx_desc);
+		}
+	}
+
+	if (attn && self_clear)
+		MVS_CHIP_DISP->int_full(mvi);
+	return 0;
+}
+
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
new file mode 100644
index 0000000..7b13e4a
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -0,0 +1,354 @@
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
+#ifndef _MV_SAS_H_
+#define _MV_SAS_H_
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/types.h>
+#include <linux/ctype.h>
+#include <linux/dma-mapping.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/vmalloc.h>
+#include <scsi/libsas.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/sas_ata.h>
+#include "mv_defs.h"
+
+#define DRV_NAME		"mvsas"
+#define DRV_VERSION		"0.7.9a"
+#define _MV_DUMP		0
+#define MVS_ID_NOT_MAPPED	0x7f
+/* #define DISABLE_HOTPLUG_DMA_FIX */
+
+/* #define MV_DISABLE_NCQ	1 */
+#define mv_printk(fmt, arg ...)	\
+	printk("%s %d:" fmt, __FILE__, __LINE__, ## arg)
+#ifdef MV_DEBUG
+#define mv_dprintk(format, arg...) \
+	printk("%s %d:" format, __FILE__, __LINE__, ## arg)
+#else
+#define mv_dprintk(format, arg...)
+#endif
+
+#define MV_MAX_U32			0xffffffff
+
+#define for_each_phy(__lseq_mask, __mc, __lseq)			\
+	for ((__mc) = (__lseq_mask), (__lseq) = 0;		\
+					(__mc) != 0 ;		\
+					(++__lseq), (__mc) >>= 1)
+
+#define MV_INIT_DELAYED_WORK(w, f, d)	INIT_DELAYED_WORK(w, f)
+
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
+					   	u8       cmd,
+					    	u8       read,
+					    	u8       length,
+					    	u32      addr
+					    	);
+	int (* spi_issuecmd)(struct mvs_info *mvi, u32 cmd);
+	int (* spi_waitdataready)(struct mvs_info *mvi, u32 timeout);
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	void (*dma_fix)(dma_addr_t buf_dma, int buf_len, int from, void *prd);
+#endif
+
+};
+
+struct mvs_chip_info {
+	u32		n_host;
+	u32		n_phy;
+	u32		fis_offs;
+	u32		fis_count;
+	u32		srs_sz;
+	u32		slot_width;
+	const struct mvs_dispatch *dispatch;
+};
+
+#define MVS_CHIP_SLOT_SZ	(1U << mvi->chip->slot_width)
+#define MVS_RX_FISL_SZ		\
+	(mvi->chip->fis_offs + (mvi->chip->fis_count * 0x100))
+#define MVS_CHIP_DISP		mvi->chip->dispatch
+
+struct mvs_err_info {
+	__le32			flags;
+	__le32			flags2;
+};
+
+struct mvs_cmd_hdr {
+	__le32			flags;		/* PRD tbl len; SAS, SATA ctl */
+	__le32			lens;		/* cmd, max resp frame len */
+	__le32			tags;		/* targ port xfer tag; tag */
+	__le32			data_len;	/* data xfer len */
+	__le64			cmd_tbl;	/* command table address */
+	__le64			open_frame;	/* open addr frame address */
+	__le64			status_buf;	/* status buffer address */
+	__le64			prd_tbl;	/* PRD tbl address */
+	__le32			reserved[4];
+};
+
+struct mvs_port {
+	struct asd_sas_port	sas_port;
+	u8			port_attached;
+	u8			wide_port_phymap;
+	struct list_head	list;
+};
+
+struct mvs_phy {
+	struct mvs_port		*port;
+	struct asd_sas_phy	sas_phy;
+	struct sas_identify	identify;
+	struct scsi_device	*sdev;
+	u64		dev_sas_addr;
+	u64		att_dev_sas_addr;
+	u32		att_dev_info;
+	u32		dev_info;
+	u32		phy_type;
+	u32		phy_status;
+	u32		irq_status;
+	u32		frame_rcvd_size;
+	u8		frame_rcvd[32];
+	u8		phy_attached;
+	u8		phy_mode;
+	u8		reserved[2];
+	u32		phy_event;
+	enum sas_linkrate	minimum_linkrate;
+	enum sas_linkrate	maximum_linkrate;
+};
+
+struct mvs_device {
+        enum sas_dev_type dev_type;
+        struct domain_device *sas_device;
+        u32 attached_phy;
+        u32 device_id;
+        u8			taskfileset;
+       struct list_head		dev_entry;
+
+};
+
+struct mvs_slot_info {
+	struct list_head	entry;
+	union {
+		struct sas_task	*task;
+		void 		*tdata;
+	};
+	u32			n_elem;
+	u32			tx;
+	u32 			slot_tag;
+
+	/* DMA buffer for storing cmd tbl, open addr frame, status buffer,
+	 * and PRD table
+	 */
+	void			*buf;
+	dma_addr_t		buf_dma;
+#if _MV_DUMP
+	u32			cmd_size;
+#endif
+	void			*response;
+	struct mvs_port		*port;
+	struct mvs_device		*device;
+	struct completion	*slot_completion;
+	void			*open_frame;
+};
+
+struct mvs_info {
+	unsigned long		flags;
+
+	spinlock_t		lock;		/* host-wide lock */
+	struct pci_dev		*pdev;		/* our device */
+	struct device		*dev;
+	void __iomem		*regs;		/* enhanced mode registers */
+	void __iomem		*regs_ex;	/* peripheral or soc registers */
+	u8			sas_addr[SAS_ADDR_SIZE];
+	struct sas_ha_struct	*sas;		/* SCSI/SAS glue */
+	struct Scsi_Host	*shost;
+
+	__le32			*tx;		/* TX (delivery) DMA ring */
+	dma_addr_t		tx_dma;
+	u32			tx_prod;	/* cached next-producer idx */
+
+	__le32			*rx;		/* RX (completion) DMA ring */
+	dma_addr_t		rx_dma;
+	u32			rx_cons;	/* RX consumer idx */
+
+	__le32			*rx_fis;	/* RX'd FIS area */
+	dma_addr_t		rx_fis_dma;
+
+	struct mvs_cmd_hdr	*slot;	/* DMA command header slots */
+	dma_addr_t		slot_dma;
+
+	u32			chip_id;
+	const struct mvs_chip_info *chip;
+
+	int			tags_num;
+	u8			tags[MVS_SLOTS >> 3];
+				/* further per-slot information */
+	struct mvs_phy		phy[MVS_MAX_PHYS];
+	struct mvs_port		port[MVS_MAX_PHYS];
+	u32			irq;
+	u32			id;
+	struct list_head	*hba_list;
+	struct list_head	soc_entry;
+	struct list_head	wq_list;
+	unsigned long		instance;
+	u16			flashid;
+	u32			flashsize;
+	u32			flashsectSize;
+
+	void			*addon;
+	struct mvs_device	devices[MVS_MAX_DEVICES];
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	void			*bulk_buffer;
+	dma_addr_t		bulk_buffer_dma;
+#define TRASH_BUCKET_SIZE    	0x20000
+#endif
+	struct mvs_slot_info	slot_info[0];
+};
+
+struct mvs_wq {
+	struct delayed_work work_q;
+	struct mvs_info *mvi;
+	void *data;
+	int handler;
+	struct list_head entry;
+};
+
+struct mvs_task_exec_info {
+	struct sas_task *task;
+	struct mvs_cmd_hdr *hdr;
+	struct mvs_port *port;
+	u32 tag;
+	int n_elem;
+};
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
+int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
+			void *funcdata);
+void __devinit mvs_set_sas_addr(struct mvs_info *mvi, int port_id,
+				u32 off_lo, u32 off_hi, u64 sas_addr);
+int mvs_slave_alloc(struct scsi_device *scsi_dev);
+int mvs_slave_configure(struct scsi_device *sdev);
+void mvs_scan_start(struct Scsi_Host *shost);
+int mvs_scan_finished(struct Scsi_Host *shost, unsigned long time);
+int mvs_queue_command(struct sas_task *task, const int num,
+			gfp_t gfp_flags);
+int mvs_task_abort(struct sas_task *task);
+void mvs_port_formed(struct asd_sas_phy *sas_phy);
+void mvs_port_deformed(struct asd_sas_phy *sas_phy);
+int mvs_dev_found(struct domain_device *dev);
+void mvs_dev_gone(struct domain_device *dev);
+int mvs_lu_reset(struct domain_device *dev, u8 *lun);
+int mvs_I_T_nexus_reset(struct domain_device *dev);
+int mvs_query_task(struct sas_task *task);
+void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events);
+void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st);
+int mvs_int_rx(struct mvs_info *mvi, bool self_clear);
+void mvs_hexdump(u32 size, u8 *data, u32 baseaddr);
+
+#endif
diff --git a/drivers/scsi/mvsas/mv_spi.c b/drivers/scsi/mvsas/mv_spi.c
new file mode 100644
index 0000000..e287afd
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_spi.c
@@ -0,0 +1,42 @@
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
+#include "mv_spi.h"
+
+u8 mv_spi_init(struct mvs_info *mvi, struct hba_info_main *hba_info_para)
+{
+	int i;
+	for(i = 0; i < mvi->chip->n_phy; i++) {
+		mvi->phy[i].dev_sas_addr = 0x5005043011ab0000ULL;
+		mvi->phy[i].dev_sas_addr =
+			cpu_to_be64((u64)(*(u64 *)&mvi->phy[i].dev_sas_addr));
+		mv_dprintk("Phy %d SAS ADDRESS %016llx\n", i,
+			SAS_ADDR(&mvi->phy[i].dev_sas_addr));
+	}
+	memcpy(mvi->sas_addr, &mvi->phy[0].dev_sas_addr, SAS_ADDR_SIZE);
+	return 0;
+}
+
+
diff --git a/drivers/scsi/mvsas/mv_spi.h b/drivers/scsi/mvsas/mv_spi.h
new file mode 100644
index 0000000..7f045d0
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_spi.h
@@ -0,0 +1,35 @@
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
+#ifndef _MV_SPI_H_
+#define _MV_SPI_H_
+
+struct hba_info_main {
+	u64 sas_address[8];
+};
+
+u8 mv_spi_init(struct mvs_info *mvi, struct hba_info_main *hba_info_para);
+
+#endif
+
-- 
1.5.4.3




