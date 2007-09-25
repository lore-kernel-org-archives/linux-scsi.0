From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] Marvell 6440 SAS/SATA driver (rough draft)
Date: Tue, 25 Sep 2007 02:04:07 -0400
Message-ID: <20070925060407.GA19417@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:51620 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbXIYGEI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2007 02:04:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>


Same disclaimer as with broadsas...  it's better to go ahead and get
this work-in-progress out there for people to comment on.

The chip:  the 6440 has per-HBA rings for TX (delivery) and RX
(completions, events).  You build a DMA command descriptor describing
the SSP, SMP, STP or SATA command, and let it rip.  Wide ports are
supported (search for "phy_mask" in the code).  Have plenty of control.

SATA is currently unsupported.  The 6440 has some useful internal
buffers "SATA register sets", which permit dynamic associations between
SATA targets and SATA register blocks.

Most error handling, and some phy handling code is notably missing.

The 'sas' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git sas

contains the following updates:

 drivers/scsi/Kconfig    |   20 +
 drivers/scsi/Makefile   |    2 +
 drivers/scsi/broadsas.c | 1025 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/mvsas.c    | 1064 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 2111 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/broadsas.c
 create mode 100644 drivers/scsi/mvsas.c

Jeff Garzik (3):
      Add Broadcom 8603 SAS/SATA driver (rough draft).
      Add Marvell 88SE6440 SAS/SATA driver (rough draft).
      broadsas, mvsas: fill in sas_port, sas_phy arrays

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 6f2c71e..bb041b8 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -486,6 +486,16 @@ config SCSI_AIC7XXX_OLD
 source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
 source "drivers/scsi/aic94xx/Kconfig"
 
+config SCSI_BROADSAS
+	tristate "Broadcom 8603 SAS/SATA support"
+	depends on PCI
+	select SCSI_SAS_LIBSAS
+	help
+	  This driver supports Broadcom SAS/SATA PCI devices.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called broadsas.
+
 # All the I2O code and drivers do not seem to be 64bit safe.
 config SCSI_DPT_I2O
 	tristate "Adaptec I2O RAID support "
@@ -961,6 +971,16 @@ config SCSI_IZIP_SLOW_CTR
 
 	  Generally, saying N is fine.
 
+config SCSI_MVSAS
+	tristate "Marvell 88SE6440 SAS/SATA support"
+	depends on PCI
+	select SCSI_SAS_LIBSAS
+	help
+	  This driver supports Marvell SAS/SATA PCI devices.
+
+	  To compiler this driver as a module, choose M here: the module
+	  will be called mvsas.
+
 config SCSI_NCR53C406A
 	tristate "NCR53c406a SCSI support"
 	depends on ISA && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 86a7ba7..928b6a2 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -72,6 +72,7 @@ obj-$(CONFIG_SCSI_AIC79XX)	+= aic7xxx/
 obj-$(CONFIG_SCSI_AACRAID)	+= aacraid/
 obj-$(CONFIG_SCSI_AIC7XXX_OLD)	+= aic7xxx_old.o
 obj-$(CONFIG_SCSI_AIC94XX)	+= aic94xx/
+obj-$(CONFIG_SCSI_BROADSAS)	+= broadsas.o
 obj-$(CONFIG_SCSI_IPS)		+= ips.o
 obj-$(CONFIG_SCSI_FD_MCS)	+= fd_mcs.o
 obj-$(CONFIG_SCSI_FUTURE_DOMAIN)+= fdomain.o
@@ -132,6 +133,7 @@ obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_IBMVSCSIS)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_HPTIOP)	+= hptiop.o
 obj-$(CONFIG_SCSI_STEX)		+= stex.o
+obj-$(CONFIG_SCSI_MVSAS)	+= mvsas.o
 obj-$(CONFIG_PS3_ROM)		+= ps3rom.o
 
 obj-$(CONFIG_ARM)		+= arm/
diff --git a/drivers/scsi/broadsas.c b/drivers/scsi/broadsas.c
new file mode 100644
index 0000000..eeba635
--- /dev/null
+++ b/drivers/scsi/broadsas.c

[EDITED OUT, POSTED EARLIER]

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
new file mode 100644
index 0000000..6dc518e
--- /dev/null
+++ b/drivers/scsi/mvsas.c
@@ -0,0 +1,1064 @@
+/*
+	mvsas.c - Marvell 88SE6440 SAS/SATA support
+
+	Copyright 2007 Red Hat, Inc.
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
+
+	Random notes:
+	* hardware supports controlling the endian-ness of data
+	  structures.  this permits elimination of all the le32_to_cpu()
+	  and cpu_to_le32() conversions.
+
+	* hardware supports much more efficient interrupt handling
+	  than we current employ.
+
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <scsi/libsas.h>
+#include <asm/io.h>
+
+#define DRV_NAME "mvsas"
+#define DRV_VERSION "0.1"
+
+#define mr32(reg)	readl(regs + MVS_##reg)
+#define mw32(reg,val)	writel((val), regs + MVS_##reg)
+#define mw32_f(reg,val)	do {		\
+	writel((val), regs + MVS_##reg);	\
+	readl(regs + MVS_##reg);		\
+	} while (0)
+
+/* driver compile-time configuration */
+enum driver_configuration {
+	MVS_TX_RING_SZ		= 1024,	/* TX ring size (12-bit) */
+	MVS_RX_RING_SZ		= 1024, /* RX ring size (12-bit) */
+					/* software requires power-of-2
+					   ring size */
+
+	MVS_SLOTS		= 512,	/* command slots */
+	MVS_SLOT_BUF_SZ		= 8192, /* cmd tbl + IU + status + PRD */
+	MVS_SSP_CMD_SZ		= 64,	/* SSP command table size */
+
+	MVS_RX_FIS_COUNT	= 17,	/* Optional rx'd FISs (max 17) */
+};
+
+/* unchangeable hardware details */
+enum hardware_details {
+	MVS_PHYS		= 4,	/* number of phys */
+	MVS_MAX_PORTS		= 4,	/* maximum possible ports */
+	MVS_RX_FISL_SZ		= 0x400 + (MVS_RX_FIS_COUNT * 0x100),
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
+/* enhanced mode registers (BAR4) */
+enum hw_registers {
+	MVS_GBL_CTL		= 0x04,  /* global control */
+	MVS_GBL_INT_STAT	= 0x08,  /* global irq status */
+	MVS_GBL_PI		= 0x0C,  /* ports implemented bitmask */
+	MVS_GBL_PORT_TYPE	= 0x00,  /* port type */
+
+	MVS_CMD_LIST_LO		= 0x108, /* cmd list addr */
+	MVS_CMD_LIST_HI		= 0x10C,
+	MVS_RX_FIS_LO		= 0x110, /* RX FIS list addr */
+	MVS_RX_FIS_HI		= 0x114,
+
+	MVS_TX_CFG		= 0x120, /* TX configuration */
+	MVS_TX_LO		= 0x124, /* TX (delivery) ring addr */
+	MVS_TX_HI		= 0x128,
+
+	MVS_RX_PROD_IDX		= 0x12C, /* RX producer pointer */
+	MVS_RX_CONS_IDX		= 0x130, /* RX consumer pointer (RO) */
+	MVS_RX_CFG		= 0x134, /* RX configuration */
+	MVS_RX_LO		= 0x138, /* RX (completion) ring addr */
+	MVS_RX_HI		= 0x13C,
+
+	MVS_INT_COAL		= 0x148, /* Int coalescing config */
+	MVS_INT_COAL_TMOUT	= 0x14C, /* Int coalescing timeout */
+	MVS_INT_STAT		= 0x150, /* Central int status */
+	MVS_INT_MASK		= 0x154, /* Central int enable */
+	MVS_INT_STAT_SRS	= 0x158, /* SATA register set status */
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
+	AUTO_DET		= (1U << 8),	/* port0 SAS/SATA autodetect */
+	SAS_MODE		= (1U << 0),	/* port0 SAS(1), SATA(0) mode */
+						/* SAS_MODE value may be
+						 * dictated (in hw) by values
+						 * of SATA_TARGET & AUTO_DET
+						 */
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
+	CINT_CI_STOP		= (1U << 10),	/* cmd issue stopped */
+	CINT_DONE		= (1U << 0),	/* cmd completion */
+
+						/* shl for ports 1-3 */
+	CINT_PORT_STOPPED	= (1U << 16),	/* port0 stopped */
+	CINT_PORT		= (1U << 8),	/* port0 event */
+
+	/* TX (delivery) ring bits */
+	TXQ_CMD_SHIFT		= 29,
+	TXQ_CMD_SSP		= 1,		/* SSP protocol */
+	TXQ_CMD_SMP		= 2,		/* SMP protocol */
+	TXQ_CMD_STP		= 3,		/* STP/SATA protocol */
+	TXQ_CMD_SSP_FREE_LIST	= 4,		/* add to SSP targ free list */
+	TXQ_CMD_SLOT_RESET	= 7,		/* reset command slot */
+	TXQ_MODE_I		= (1U << 28),	/* mode: 0=target,1=initiator */
+	TXQ_PRIO_HI		= (1U << 27),	/* priority: 0=normal, 1=high */
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
+						/* SSP initiator only */
+	MCH_SSP_FR_CMD		= 0x0,		/* COMMAND frame */
+						/* SSP initiator or target */
+	MCH_SSP_FR_TASK		= 0x1,		/* TASK frame */
+						/* SSP target only */
+	MCH_SSP_FR_XFER_RDY	= 0x4,		/* XFER_RDY frame */
+	MCH_SSP_FR_RESP		= 0x5,		/* RESPONSE frame */
+	MCH_SSP_FR_READ		= 0x6,		/* Read DATA frame(s) */
+	MCH_SSP_FR_READ_RESP	= 0x7,		/* ditto, plus RESPONSE */
+
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
+};
+
+struct mvs_prd {
+	__le64			addr;		/* 64-bit buffer address */
+	__le32			reserved;
+	__le32			len;		/* 16-bit length */
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
+struct mvs_slot_info {
+	struct sas_task		*task;
+	unsigned int		n_elem;
+
+	/* DMA buffer for storing cmd tbl, open addr frame, status buffer,
+	 * and PRD table
+	 */
+	void			*buf;
+	dma_addr_t		buf_dma;
+};
+
+struct mvs_port {
+	struct asd_sas_port	sas_port;
+};
+
+struct mvs_phy {
+	struct mvs_port		*port;
+	struct asd_sas_phy	sas_phy;
+};
+
+struct mvs_info {
+	spinlock_t		lock;		/* host-wide lock */
+	struct pci_dev		*pdev;		/* our device */
+	void __iomem		*regs;		/* enhanced mode registers */
+	void __iomem		*peri_regs;	/* peripheral registers */
+
+	struct sas_ha_struct	sas;		/* SCSI/SAS glue */
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
+	struct mvs_cmd_hdr	*slot;		/* DMA command header slots */
+	dma_addr_t		slot_dma;
+
+					/* further per-slot information */
+	struct mvs_slot_info	slot_info[MVS_SLOTS];
+	unsigned long		tags[(MVS_SLOTS / sizeof(unsigned long)) + 1];
+
+	struct mvs_phy		phy[MVS_PHYS];
+	struct mvs_port		port[MVS_PHYS];
+};
+
+static struct scsi_transport_template *mvs_stt;
+
+static struct scsi_host_template mvs_sht = {
+	.module			= THIS_MODULE,
+	.name			= DRV_NAME,
+	.queuecommand		= sas_queuecommand,
+	.target_alloc		= sas_target_alloc,
+	.slave_configure	= sas_slave_configure,
+	.slave_destroy		= sas_slave_destroy,
+	.change_queue_depth	= sas_change_queue_depth,
+	.change_queue_type	= sas_change_queue_type,
+	.bios_param		= sas_bios_param,
+	.can_queue		= 1,
+	.cmd_per_lun		= 1,
+	.this_id		= -1,
+	.sg_tablesize		= SG_ALL,
+	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.eh_device_reset_handler= sas_eh_device_reset_handler,
+	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
+	.slave_alloc		= sas_slave_alloc,
+	.target_destroy		= sas_target_destroy,
+	.ioctl			= sas_ioctl,
+};
+
+/* move to PCI layer or libata core? */
+static int pci_go_64(struct pci_dev *pdev)
+{
+	int rc;
+
+	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		if (rc) {
+			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			if (rc) {
+				dev_printk(KERN_ERR, &pdev->dev,
+					   "64-bit DMA enable failed\n");
+				return rc;
+			}
+		}
+	} else {
+		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		if (rc) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "32-bit DMA enable failed\n");
+			return rc;
+		}
+		rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		if (rc) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "32-bit consistent DMA enable failed\n");
+			return rc;
+		}
+	}
+
+	return rc;
+}
+
+static void mvs_tag_clear(struct mvs_info *mvi, unsigned int tag)
+{
+	mvi->tags[tag / sizeof(unsigned long)] &=
+		~(1UL << (tag % sizeof(unsigned long)));
+}
+
+static void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
+{
+	mvi->tags[tag / sizeof(unsigned long)] |=
+		(1UL << (tag % sizeof(unsigned long)));
+}
+
+static bool mvs_tag_test(struct mvs_info *mvi, unsigned int tag)
+{
+	return mvi->tags[tag / sizeof(unsigned long)] &
+		(1UL << (tag % sizeof(unsigned long)));
+}
+
+static int mvs_tag_alloc(struct mvs_info *mvi, unsigned int *tag_out)
+{
+	unsigned int i;
+
+	for (i = 0; i < MVS_SLOTS; i++)
+		if (!mvs_tag_test(mvi, i)) {
+			mvs_tag_set(mvi, i);
+			*tag_out = i;
+			return 0;
+		}
+
+	return -EBUSY;
+}
+
+#if 0
+static int mvs_eep_read(void __iomem *regs, unsigned int addr, u32 *data)
+{
+	int timeout = 1000;
+
+	if (addr & ~SPI_ADDR_MASK)
+		return -EINVAL;
+
+	writel(addr, regs + SPI_CMD);
+	writel(TWSI_RD, regs + SPI_CTL);
+
+	while (timeout-- > 0) {
+		if (readl(regs + SPI_CTL) & TWSI_RDY) {
+			*data = readl(regs + SPI_DATA);
+			return 0;
+		}
+
+		udelay(10);
+	}
+
+	return -EBUSY;
+}
+#endif
+
+static void mvs_int_port(struct mvs_info *mvi, int port_no, u32 events)
+{
+	/* FIXME */
+}
+
+static void mvs_int_sata(struct mvs_info *mvi)
+{
+	/* FIXME */
+}
+
+static void mvs_slot_free(struct mvs_info *mvi, struct sas_task *task,
+			  struct mvs_slot_info *slot, unsigned int slot_idx)
+{
+	if (slot->n_elem)
+		pci_unmap_sg(mvi->pdev, task->scatter,
+			     slot->n_elem, task->data_dir);
+
+	switch (task->task_proto) {
+	case SAS_PROTO_SMP:
+		pci_unmap_sg(mvi->pdev, &task->smp_task.smp_resp, 1,
+			     PCI_DMA_FROMDEVICE);
+		pci_unmap_sg(mvi->pdev, &task->smp_task.smp_req, 1,
+			     PCI_DMA_FROMDEVICE);
+		break;
+
+	case SATA_PROTO:		/* FIXME */
+	case SAS_PROTO_STP:		/* FIXME */
+	case SAS_PROTO_SSP:		/* do nothing */
+	default:			/* do nothing */
+		break;
+	}
+
+	mvs_tag_clear(mvi, slot_idx);
+}
+
+static void mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
+{
+	unsigned int slot_idx = rx_desc & RXQ_SLOT_MASK;
+	struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
+	struct sas_task *task = slot->task;
+	bool aborted;
+
+	spin_lock(&task->task_state_lock);
+	task->task_state_flags &= ~SAS_TASK_STATE_PENDING;
+	task->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
+	task->task_state_flags |= SAS_TASK_STATE_DONE;
+	aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
+	spin_unlock(&task->task_state_lock);
+
+	if (!aborted) {
+		mvs_slot_free(mvi, task, slot, slot_idx);
+		task->task_done(task);
+	}
+}
+
+static void mvs_int_rx(struct mvs_info *mvi)
+{
+	u32 rx_prod_idx, rx_desc;
+
+	/* the first dword in the RX ring is special: it contains
+	 * a mirror of the hardware's RX producer index, so that
+	 * we don't have to stall the CPU reading that register.
+	 * The actual RX ring is offset by one dword, due to this.
+	 */
+	rx_prod_idx = le32_to_cpu(mvi->rx[0]) & 0xfff;
+	if (rx_prod_idx == 0xfff) {	/* h/w hasn't touched RX ring yet */
+		mvi->rx_cons = 0xfff;
+		return;
+	}
+	if (mvi->rx_cons == 0xfff)
+		mvi->rx_cons = MVS_RX_RING_SZ - 1;
+
+	while (mvi->rx_cons != rx_prod_idx) {
+		/* increment our internal RX consumer pointer */
+		mvi->rx_cons = (mvi->rx_cons + 1) & (MVS_RX_RING_SZ - 1);
+
+		/* Read RX descriptor at offset+1, due to above */
+		rx_desc = le32_to_cpu(mvi->rx[mvi->rx_cons + 1]);
+
+		/* RXQ_ATTN is used to signal non-completion events
+		 * in MVS_INT_STAT.  However, we handled those events
+		 * already in mvs_interrupt(), so we can ignore that
+		 * bit here.  We also ignore RXQ_SLOT_RESET and
+		 * RXQ_CMD_RX for obvious reasons.
+		 */
+
+		if (rx_desc & RXQ_DONE)
+			/* we had a completion, error or no */
+			mvs_slot_complete(mvi, rx_desc);
+	}
+}
+
+static irqreturn_t mvs_interrupt(int irq, void *opaque)
+{
+	struct mvs_info *mvi = opaque;
+	void __iomem *regs = mvi->regs;
+	u32 stat, tmp;
+	unsigned int i;
+
+	stat = mr32(GBL_INT_STAT);
+	if (stat == 0 || stat == 0xffffffff)
+		return IRQ_NONE;
+
+	WARN_ON(!(stat & INT_SAS_SATA));
+
+	spin_lock(&mvi->lock);
+
+	stat = mr32(INT_STAT);
+
+	for (i = 0; i < MVS_MAX_PORTS; i++) {
+		tmp = (stat >> i) & (CINT_PORT | CINT_PORT_STOPPED);
+		if (tmp)
+			mvs_int_port(mvi, i, tmp);
+	}
+
+	if (stat & CINT_SRS)
+		mvs_int_sata(mvi);
+
+	if (stat & (CINT_CI_STOP | CINT_DONE))
+		mvs_int_rx(mvi);
+
+	mw32(INT_STAT, stat);
+
+	spin_unlock(&mvi->lock);
+
+	return IRQ_HANDLED;
+}
+
+struct mvs_task_exec_info {
+	struct sas_task		*task;
+	struct mvs_cmd_hdr	*hdr;
+	unsigned int		tag;
+	int			n_elem;
+};
+
+static int mvs_task_prep_smp(struct mvs_info *mvi, struct mvs_task_exec_info *tei)
+{
+	int elem, rc;
+	struct mvs_cmd_hdr *hdr = tei->hdr;
+	struct scatterlist *sg_req, *sg_resp;
+	unsigned int req_len, resp_len, tag = tei->tag;
+
+	/*
+	 * DMA-map SMP request, response buffers
+	 */
+
+	sg_req = &tei->task->smp_task.smp_req;
+	elem = pci_map_sg(mvi->pdev, sg_req, 1, PCI_DMA_FROMDEVICE);
+	if (!elem)
+		return -ENOMEM;
+	req_len = sg_dma_len(sg_req);
+
+	sg_resp = &tei->task->smp_task.smp_resp;
+	elem = pci_map_sg(mvi->pdev, sg_resp, 1, PCI_DMA_FROMDEVICE);
+	if (!elem) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+	resp_len = sg_dma_len(sg_resp);
+
+	/* must be in dwords */
+	if ((req_len & 0x3) || (resp_len & 0x3)) {
+		rc = -EINVAL;
+		goto err_out_2;
+	}
+
+	/*
+	 * Fill in TX ring and command slot header
+	 */
+
+	mvi->tx[tag] = cpu_to_le32(
+		(TXQ_CMD_SMP << TXQ_CMD_SHIFT) | TXQ_MODE_I | tag);
+
+	hdr->flags = 0;
+	hdr->lens = cpu_to_le32(((resp_len / 4) << 16) | (req_len / 4));
+	hdr->tags = cpu_to_le32(tag);
+	hdr->data_len = 0;
+	hdr->cmd_tbl = cpu_to_le64(sg_dma_address(sg_req));
+	hdr->open_frame = 0;
+	hdr->status_buf = cpu_to_le64(sg_dma_address(sg_resp));
+	hdr->prd_tbl = 0;
+
+	return 0;
+
+err_out_2:
+	pci_unmap_sg(mvi->pdev, &tei->task->smp_task.smp_resp, 1,
+		     PCI_DMA_FROMDEVICE);
+err_out:
+	pci_unmap_sg(mvi->pdev, &tei->task->smp_task.smp_req, 1,
+		     PCI_DMA_FROMDEVICE);
+	return rc;
+}
+
+static int mvs_task_prep_ssp(struct mvs_info *mvi,
+			     struct mvs_task_exec_info *tei)
+{
+	struct sas_task *task = tei->task;
+	struct asd_sas_port *sas_port = task->dev->port;
+	struct mvs_cmd_hdr *hdr = tei->hdr;
+	struct mvs_slot_info *slot;
+	struct scatterlist *sg;
+	unsigned int resp_len, req_len, i, tag = tei->tag;
+	struct mvs_prd *buf_prd;
+	void *buf_cmd, *buf_tmp, *buf_status;
+	dma_addr_t buf_tmp_dma;
+	u32 flags;
+
+	slot = &mvi->slot_info[tag];
+
+	mvi->tx[tag] = cpu_to_le32(TXQ_MODE_I | tag |
+		(TXQ_CMD_SSP << TXQ_CMD_SHIFT) | 
+		(sas_port->phy_mask << TXQ_PHY_SHIFT));
+
+	flags = MCH_RETRY;
+	if (task->ssp_task.enable_first_burst)
+		flags |= MCH_FBURST;
+	hdr->flags = cpu_to_le32(flags |
+		(tei->n_elem << MCH_PRD_LEN_SHIFT) |
+		(MCH_SSP_FR_CMD << MCH_SSP_FR_TYPE_SHIFT));
+
+	hdr->tags = cpu_to_le32(tag);
+	hdr->data_len = cpu_to_le32(task->total_xfer_len);
+
+	/* arrange MVS_SLOT_BUF_SZ-sized DMA buffer according to our needs */
+
+	/* 1. command table area (MVS_SSP_CMD_SZ bytes) */
+	buf_cmd =
+	buf_tmp = slot->buf;
+	buf_tmp_dma = slot->buf_dma;
+
+	hdr->cmd_tbl = cpu_to_le64(buf_tmp_dma);
+
+	buf_tmp += MVS_SSP_CMD_SZ;
+	buf_tmp_dma += MVS_SSP_CMD_SZ;
+
+	/* 2. link to open address frame */
+
+	hdr->open_frame = /* FIXME */ 0;
+
+	/* 3. calculate address and size for PRD table */
+
+	buf_prd = buf_tmp;
+	hdr->prd_tbl = cpu_to_le64(buf_tmp_dma);
+
+	i = sizeof(struct mvs_prd) * tei->n_elem;
+	buf_tmp += i;
+	buf_tmp_dma += i;
+
+	/* 4. the remainder is used for the status buffer */
+
+	buf_status = buf_tmp;
+	hdr->status_buf = cpu_to_le64(buf_tmp_dma);
+
+	req_len = 24 /* SSP frame header */ + 16 /* CDB length */ ;
+	resp_len = MVS_SLOT_BUF_SZ - MVS_SSP_CMD_SZ - i;
+
+	hdr->lens = cpu_to_le32(((resp_len / 4) << 16) | (req_len / 4));
+
+	/* fill in SSP command table */
+	/* FIXME: fill in 24-byte SSP frame header */
+	memcpy(buf_cmd + 24, &task->ssp_task.cdb, 16);
+	/* TODO: optional information protection record follows here */
+
+	/* fill in PRD (scatter/gather) table, if any */
+	sg = task->scatter;
+	for (i = 0; i < tei->n_elem; i++) {
+		buf_prd->addr = cpu_to_le64(sg_dma_address(sg));
+		buf_prd->len = cpu_to_le32(sg_dma_len(sg));
+
+		sg++;
+		buf_prd++;
+	}
+
+	return -EINVAL;
+}
+
+static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
+{
+	struct mvs_info *mvi = task->dev->port->ha->lldd_ha;
+	unsigned int tag = 0xdeadbeef, rc, n_elem = 0;
+	void __iomem *regs = mvi->regs;
+	unsigned long flags;
+	struct mvs_task_exec_info tei = { 0, };
+
+	tei.task = task;
+
+	if (task->num_scatter) {
+		n_elem = pci_map_sg(mvi->pdev, task->scatter,
+				    task->num_scatter, task->data_dir);
+		if (!n_elem)
+			return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&mvi->lock, flags);
+
+	rc = mvs_tag_alloc(mvi, &tag);
+	if (rc)
+		goto err_out;
+
+	mvi->slot_info[tag].task = task;
+	mvi->slot_info[tag].n_elem = n_elem;
+	tei.hdr = &mvi->slot[tag];
+	tei.tag = tag;
+	tei.n_elem = n_elem;
+
+	switch (task->task_proto) {
+	case SAS_PROTO_SMP:
+		rc = mvs_task_prep_smp(mvi, &tei);
+		break;
+	case SAS_PROTO_SSP:
+		rc = mvs_task_prep_ssp(mvi, &tei);
+		break;
+	case SATA_PROTO:		/* SATA is handled via libata */
+	case SAS_PROTO_STP:
+	default:
+		rc = -EINVAL;
+		break;
+	}
+
+	if (rc)
+		goto err_out_tag;
+
+	/* FIXME: fill in PHY bitmap */
+	/* TODO: select normal or high priority */
+
+	mw32(RX_PROD_IDX, mvi->tx_prod);
+
+	mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_TX_RING_SZ - 1);
+
+	spin_lock(&task->task_state_lock);
+	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
+	spin_unlock(&task->task_state_lock);
+
+	spin_unlock_irqrestore(&mvi->lock, flags);
+	return 0;
+
+err_out_tag:
+	mvs_tag_clear(mvi, tag);
+err_out:
+	if (n_elem)
+		pci_unmap_sg(mvi->pdev, task->scatter, n_elem, task->data_dir);
+	spin_unlock_irqrestore(&mvi->lock, flags);
+	return rc;
+}
+
+static void mvs_free(struct mvs_info *mvi)
+{
+	int i;
+
+	if (!mvi)
+		return;
+
+	for (i = 0; i < MVS_SLOTS; i++) {
+		struct mvs_slot_info *slot = &mvi->slot_info[i];
+
+		if (slot->buf)
+			dma_free_coherent(&mvi->pdev->dev, MVS_SLOT_BUF_SZ,
+					  slot->buf, slot->buf_dma);
+	}
+
+	if (mvi->tx)
+		dma_free_coherent(&mvi->pdev->dev,
+				  sizeof(*mvi->tx) * MVS_TX_RING_SZ,
+				  mvi->tx, mvi->tx_dma);
+	if (mvi->rx_fis)
+		dma_free_coherent(&mvi->pdev->dev, MVS_RX_FISL_SZ,
+				  mvi->rx_fis, mvi->rx_fis_dma);
+	if (mvi->rx)
+		dma_free_coherent(&mvi->pdev->dev,
+				  sizeof(*mvi->rx) * MVS_RX_RING_SZ,
+				  mvi->rx, mvi->rx_dma);
+	if (mvi->slot)
+		dma_free_coherent(&mvi->pdev->dev,
+				  sizeof(*mvi->slot) * MVS_RX_RING_SZ,
+				  mvi->slot, mvi->slot_dma);
+	if (mvi->peri_regs)
+		iounmap(mvi->peri_regs);
+	if (mvi->regs)
+		iounmap(mvi->regs);
+	if (mvi->shost)
+		scsi_host_put(mvi->shost);
+	kfree(mvi->sas.sas_port);
+	kfree(mvi->sas.sas_phy);
+	kfree(mvi);
+}
+
+static struct mvs_info * __devinit mvs_alloc(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	struct mvs_info *mvi;
+	unsigned long res_start, res_len;
+	struct asd_sas_phy **arr_phy;
+	struct asd_sas_port **arr_port;
+	int i;
+
+	mvi = kzalloc(sizeof(*mvi), GFP_KERNEL);
+	if (!mvi)
+		return NULL;
+
+	spin_lock_init(&mvi->lock);
+	mvi->pdev = pdev;
+
+	mvi->shost = scsi_host_alloc(&mvs_sht, sizeof(void *));
+	if (!mvi->shost)
+		goto err_out;
+
+	arr_phy = kcalloc(MVS_PHYS, sizeof(void *), GFP_KERNEL);
+	arr_port = kcalloc(MVS_PHYS, sizeof(void *), GFP_KERNEL);
+	if (!arr_phy || !arr_port)
+		goto err_out;
+
+	for (i = 0; i < MVS_PHYS; i++) {
+		arr_phy[i] = &mvi->phy[i].sas_phy;
+		arr_port[i] = &mvi->port[i].sas_port;
+	}
+
+	SHOST_TO_SAS_HA(mvi->shost) = &mvi->sas;
+	mvi->shost->transportt = mvs_stt;
+	mvi->shost->max_id = ~0;
+	mvi->shost->max_lun = ~0;
+	mvi->shost->max_cmd_len = ~0;
+
+	mvi->sas.sas_ha_name = DRV_NAME;
+	mvi->sas.dev = &pdev->dev;
+	mvi->sas.lldd_module = THIS_MODULE;
+	/* FIXME: fill in mvi->sas.sas_addr */
+	mvi->sas.sas_phy = arr_phy;
+	mvi->sas.sas_port = arr_port;
+	mvi->sas.num_phys = MVS_PHYS;
+	mvi->sas.lldd_max_execute_num = MVS_TX_RING_SZ - 1;/* FIXME: correct? */
+	mvi->sas.lldd_queue_size = MVS_TX_RING_SZ - 1;	   /* FIXME: correct? */
+	mvi->sas.lldd_ha = mvi;
+	mvi->sas.core.shost = mvi->shost;
+
+	mvs_tag_set(mvi, MVS_TX_RING_SZ - 1);
+
+	res_start = pci_resource_start(pdev, 2);
+	res_len = pci_resource_len(pdev, 2);
+	if (!res_start || !res_len)
+		goto err_out;
+
+	mvi->peri_regs = ioremap_nocache(res_start, res_len);
+	if (!mvi->regs)
+		goto err_out;
+
+	res_start = pci_resource_start(pdev, 4);
+	res_len = pci_resource_len(pdev, 4);
+	if (!res_start || !res_len)
+		goto err_out;
+
+	mvi->regs = ioremap_nocache(res_start, res_len);
+	if (!mvi->regs)
+		goto err_out;
+
+	mvi->tx = dma_alloc_coherent(&pdev->dev,
+				     sizeof(*mvi->tx) * MVS_TX_RING_SZ,
+				     &mvi->tx_dma, GFP_KERNEL);
+	if (!mvi->tx)
+		goto err_out;
+	memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_TX_RING_SZ);
+
+	mvi->rx_fis = dma_alloc_coherent(&pdev->dev, MVS_RX_FISL_SZ,
+				     &mvi->rx_fis_dma, GFP_KERNEL);
+	if (!mvi->rx_fis)
+		goto err_out;
+	memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
+
+	mvi->rx = dma_alloc_coherent(&pdev->dev,
+				     sizeof(*mvi->rx) * MVS_RX_RING_SZ,
+				     &mvi->rx_dma, GFP_KERNEL);
+	if (!mvi->rx)
+		goto err_out;
+	memset(mvi->rx, 0, sizeof(*mvi->rx) * MVS_RX_RING_SZ);
+
+	mvi->rx[0] = cpu_to_le32(0xfff);
+	mvi->rx_cons = 0xfff;
+
+	mvi->slot = dma_alloc_coherent(&pdev->dev,
+				       sizeof(*mvi->slot) * MVS_SLOTS,
+				       &mvi->slot_dma, GFP_KERNEL);
+	if (!mvi->slot)
+		goto err_out;
+	memset(mvi->slot, 0, sizeof(*mvi->slot) * MVS_SLOTS);
+
+	for (i = 0; i < MVS_SLOTS; i++) {
+		struct mvs_slot_info *slot = &mvi->slot_info[i];
+
+		slot->buf = dma_alloc_coherent(&pdev->dev, MVS_SLOT_BUF_SZ,
+				       &slot->buf_dma, GFP_KERNEL);
+		if (!slot->buf)
+			goto err_out;
+		memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
+	}
+
+	return mvi;
+
+err_out:
+	mvs_free(mvi);
+	return NULL;
+}
+
+static int __devinit mvs_hw_init(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+	int i;
+
+	/* make sure interrupts are masked */
+	mw32_f(GBL_CTL, 0);
+
+	/* global reset, incl. COMRESET/H_RESET_N (self-clearing) */
+	mw32_f(GBL_CTL, HBA_RST);
+
+	/* wait for reset to finish; timeout is just a guess */
+	i = 1000;
+	while (i-- > 0) {
+		msleep(10);
+
+		if (!(mr32(GBL_CTL) & HBA_RST))
+			break;
+	}
+	if (mr32(GBL_CTL) & HBA_RST) {
+		dev_printk(KERN_ERR, &mvi->pdev->dev, "HBA reset failed\n");
+		return -EBUSY;
+	}
+
+	mw32(CMD_LIST_LO, mvi->slot_dma);
+	mw32(CMD_LIST_HI, (mvi->slot_dma >> 16) >> 16);
+
+	mw32(RX_FIS_LO, mvi->rx_fis_dma);
+	mw32(RX_FIS_HI, (mvi->rx_fis_dma >> 16) >> 16);
+
+	mw32(TX_CFG, MVS_TX_RING_SZ);
+	mw32(TX_LO, mvi->tx_dma);
+	mw32(TX_HI, (mvi->tx_dma >> 16) >> 16);
+
+	mw32(RX_CFG, MVS_RX_RING_SZ);
+	mw32(RX_LO, mvi->rx_dma);
+	mw32(RX_HI, (mvi->rx_dma >> 16) >> 16);
+
+	/* re-enable interrupts globally */
+	mw32(GBL_CTL, INT_EN);
+
+	return 0;
+}
+
+static int __devinit mvs_pci_init(struct pci_dev *pdev,
+				 const struct pci_device_id *ent)
+{
+	int rc;
+	struct mvs_info *mvi;
+
+	rc = pci_enable_device(pdev);
+	if (rc)
+		return rc;
+
+	pci_set_master(pdev);
+
+	rc = pci_request_regions(pdev, DRV_NAME);
+	if (rc)
+		goto err_out_disable;
+
+	rc = pci_go_64(pdev);
+	if (rc)
+		goto err_out_regions;
+
+	mvi = mvs_alloc(pdev, ent);
+	if (!mvi) {
+		rc = -ENOMEM;
+		goto err_out_regions;
+	}
+
+	rc = mvs_hw_init(mvi);
+	if (rc)
+		goto err_out_mvi;
+
+	rc = request_irq(pdev->irq, mvs_interrupt, IRQF_SHARED, DRV_NAME, mvi);
+	if (rc)
+		goto err_out_mvi;
+
+	rc = scsi_add_host(mvi->shost, &pdev->dev);
+	if (rc)
+		goto err_out_irq;
+
+	rc = sas_register_ha(&mvi->sas);
+	if (rc)
+		goto err_out_shost;
+
+	pci_set_drvdata(pdev, mvi);
+	return 0;
+
+err_out_shost:
+	scsi_remove_host(mvi->shost);
+err_out_irq:
+	free_irq(pdev->irq, mvi);
+err_out_mvi:
+	mvs_free(mvi);
+err_out_regions:
+	pci_release_regions(pdev);
+err_out_disable:
+	pci_disable_device(pdev);
+	return rc;
+}
+
+static void __devexit mvs_pci_remove(struct pci_dev *pdev)
+{
+	struct mvs_info *mvi = pci_get_drvdata(pdev);
+
+	pci_set_drvdata(pdev, NULL);
+
+	sas_unregister_ha(&mvi->sas);
+	sas_remove_host(mvi->shost);
+	scsi_remove_host(mvi->shost);
+
+	free_irq(pdev->irq, mvi);
+	mvs_free(mvi);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static struct sas_domain_function_template mvs_transport_ops = {
+	.lldd_execute_task	= mvs_task_exec,
+};
+
+static struct pci_device_id __devinitdata mvs_pci_table[] = {
+	{ PCI_VDEVICE(MARVELL, 0x6440) },
+
+	{ }	/* terminate list */
+};
+
+static struct pci_driver mvs_pci_driver = {
+	.name		= DRV_NAME,
+	.id_table	= mvs_pci_table,
+	.probe		= mvs_pci_init,
+	.remove		= __devexit_p(mvs_pci_remove),
+};
+
+static int __init mvs_init(void)
+{
+	int rc;
+
+	mvs_stt = sas_domain_attach_transport(&mvs_transport_ops);
+	if (!mvs_stt)
+		return -ENOMEM;
+
+	rc = pci_register_driver(&mvs_pci_driver);
+	if (rc)
+		goto err_out;
+
+	return 0;
+
+err_out:
+	sas_release_transport(mvs_stt);
+	return rc;
+}
+
+static void __exit mvs_exit(void)
+{
+	pci_unregister_driver(&mvs_pci_driver);
+	sas_release_transport(mvs_stt);
+}
+
+module_init(mvs_init);
+module_exit(mvs_exit);
+
+MODULE_AUTHOR("Jeff Garzik <jgarzik@pobox.com>");
+MODULE_DESCRIPTION("Marvell 88SE6440 SAS/SATA controller driver");
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, mvs_pci_table);
+
