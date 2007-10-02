From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] Broadcom and Marvell SAS/SATA drivers, draft 2
Date: Tue, 2 Oct 2007 09:18:41 -0400
Message-ID: <20071002131841.GA15524@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:41129 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbXJBNSn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 09:18:43 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Here's another snapshot of the current Broadcom and Marvell SAS work.

Turns out Broadcom doesn't support SMP or STP, so I removed the
guesswork code related to SMP from broadsas.

I'm filling in the SATA bits right now, and hoping to have all this
going in the next few days, in time for 2.6.24.

 drivers/scsi/Kconfig                |   20 
 drivers/scsi/Makefile               |    2 
 drivers/scsi/aic94xx/aic94xx_task.c |   24 
 drivers/scsi/broadsas.c             | 1308 +++++++++++++++++++++++++++
 drivers/scsi/libsas/Makefile        |    3 
 drivers/scsi/libsas/lib.c           |   37 
 drivers/scsi/mvsas.c                | 1711 ++++++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h         |    1 
 include/scsi/libsas.h               |    4 
 9 files changed, 3089 insertions(+), 21 deletions(-)

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
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index d5d8cab..6163f85 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -192,24 +192,8 @@ static void asd_get_response_tasklet(struct asd_ascb *ascb,
 			r + 16 + sizeof(struct ssp_frame_hdr);
 
 		ts->residual = le32_to_cpu(*(__le32 *)r);
-		ts->resp = SAS_TASK_COMPLETE;
-		if (iu->datapres == 0)
-			ts->stat = iu->status;
-		else if (iu->datapres == 1)
-			ts->stat = iu->resp_data[3];
-		else if (iu->datapres == 2) {
-			ts->stat = SAM_CHECK_COND;
-			ts->buf_valid_size = min((u32) SAS_STATUS_BUF_SIZE,
-					 be32_to_cpu(iu->sense_data_len));
-			memcpy(ts->buf, iu->sense_data, ts->buf_valid_size);
-			if (iu->status != SAM_CHECK_COND) {
-				ASD_DPRINTK("device %llx sent sense data, but "
-					    "stat(0x%x) is not CHECK_CONDITION"
-					    "\n",
-					    SAS_ADDR(task->dev->sas_addr),
-					    ts->stat);
-			}
-		}
+
+		ssp_task_response(&asd_ha->pcidev->dev, task, iu);
 	}  else {
 		struct ata_task_resp *resp = (void *) &ts->buf[0];
 
@@ -451,7 +435,7 @@ static int asd_build_smp_ascb(struct asd_ascb *ascb, struct sas_task *task,
 	struct scb *scb;
 
 	pci_map_sg(asd_ha->pcidev, &task->smp_task.smp_req, 1,
-		   PCI_DMA_FROMDEVICE);
+		   PCI_DMA_TODEVICE);
 	pci_map_sg(asd_ha->pcidev, &task->smp_task.smp_resp, 1,
 		   PCI_DMA_FROMDEVICE);
 
@@ -486,7 +470,7 @@ static void asd_unbuild_smp_ascb(struct asd_ascb *a)
 
 	BUG_ON(!task);
 	pci_unmap_sg(a->ha->pcidev, &task->smp_task.smp_req, 1,
-		     PCI_DMA_FROMDEVICE);
+		     PCI_DMA_TODEVICE);
 	pci_unmap_sg(a->ha->pcidev, &task->smp_task.smp_resp, 1,
 		     PCI_DMA_FROMDEVICE);
 }
diff --git a/drivers/scsi/broadsas.c b/drivers/scsi/broadsas.c
new file mode 100644
index 0000000..1912b22
--- /dev/null
+++ b/drivers/scsi/broadsas.c
@@ -0,0 +1,1308 @@
+/*
+	broadsas.c - Broadcom 8603 SAS/SATA support
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
+	Technical notes:
+	* SMP and STP protocols are not supported, despite stuff like
+	SAS_CTL_SMP, which was left over from an earlier chip.
+
+	Random notes:
+	1) investigate whether
+		bw32(SAS_RX_CONS_IDX, br32(SAS_RX_PROD_IDX));
+	will kick the DMA engine into action, even if DMA engine is
+	disabled.
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
+#define DRV_NAME "broadsas"
+#define DRV_VERSION "0.1"
+
+struct bs_info;
+struct bs_phy;
+
+#define br32(reg)	readl(regs + BS_##reg)
+#define bw32(reg,val)	writel((val), regs + BS_##reg)
+#define bw32_f(reg,val)	do {		\
+	writel((val), regs + BS_##reg);	\
+	readl(regs + BS_##reg);		\
+	} while (0)
+
+/* driver compile-time configuration */
+enum driver_configuration {
+	BS_TX_RING_SZ		= 128,	/* OK: 2, 4, 8, 16, 32, 64, 128, 256 */
+	BS_RX_RING_SZ		= 128,	/* OK: 2, 4, 8, 16, 32, 64, 128, 256 */
+	BS_TX_FRAME_SZ		= 1024,	/* max: 24 + 1024 */
+	BS_MAX_PRD		= 256,	/* S/G per slot; my arbitrary guess */
+	BS_RX_BUF_SZ		= 512,  /* Response buffer size; OK: 0-64k */
+};
+
+/* unchangeable hardware details */
+enum hardware_details {
+	BS_PHYS			= 8,	/* number of storage ports / phys */
+	BS_TX_SZ		= 32,	/* TX descriptor size */
+	BS_RX_SZ		= 16,	/* RX descriptor size */
+};
+
+/* global registers */
+enum global_registers {
+	GBL_CTL			= 0x1000,	/* global control */
+	GBL_STAT		= 0x1004,	/* global status */
+	GBL_INT_TIMING		= 0x1014,	/* int coalescing control */
+	GBL_INT_MASK		= 0x1018,	/* global int mask */
+};
+
+enum bs_port_registers {
+	/* per-port registers common to SAS and SATA (though some bits differ)*/
+	BS_TX_ADDR_LO		= 0xA0,		/* tx addr lo, hi */
+	BS_TX_ADDR_HI		= 0xA4,
+	BS_TX_PROD_IDX		= 0xA8,		/* tx producer index */
+	BS_TX_CONS_IDX		= 0xAC,		/* tx consumer index (RO) */
+
+	BS_QDMA_CTL		= 0xB0,		/* QDMA control */
+	BS_QDMA_Q_DEPTH		= 0xB4,		/* QDMA ring sizing */
+	BS_QDMA_STAT		= 0xB8,		/* QDMA status */
+	BS_QDMA_INT_MASK	= 0xBC,		/* QDMA interrupt mask */
+
+	/* SAS per-port registers (replaces SATA register space, in SAS mode) */
+	BS_SAS_STAT0		= 0x40,		/* SAS status 0..1 */
+	BS_SAS_STAT1		= 0x44,
+
+	BS_SAS_CTL0		= 0x48,		/* SAS control 0..5 */
+	BS_SAS_CTL1		= 0x4C,
+	BS_SAS_CTL2		= 0x50,
+	BS_SAS_CTL3		= 0x54,
+	BS_SAS_CTL4		= 0x58,
+	BS_SAS_CTL5		= 0x5C,
+
+	BS_SAS_ERR_TAGS		= 0x70,		/* SAS error tags */
+	BS_SAS_ERR_STAT		= 0x74,		/* SAS error status */
+	BS_SAS_SACT_TAG_CLR	= 0x78,		/* SACTIVE tag to clear */
+
+	BS_SAS_RX_ADDR_LO	= 0xC0,		/* rx addr lo, hi */
+	BS_SAS_RX_ADDR_HI	= 0xC4,
+	BS_SAS_RX_PROD_IDX	= 0xC8,		/* rx producer index (RO) */
+	BS_SAS_RX_CONS_IDX	= 0xCC,		/* rx consumer index */
+
+	BS_SAS_RX_IU_MAX_SZ	= 0xD0,		/* response IU max size */
+
+	BS_SAS_IDX_ADDR		= 0xE0,		/* index address */
+	BS_SAS_IDX_DATA		= 0xE4,		/* index data */
+
+	BS_SAS_DBG_TXDMA	= 0xE8,		/* TXDMA debug */
+	BS_SAS_DBG_RXDMA	= 0xEC,		/* RXDMA debug */
+	BS_SAS_DBG_IUDMA	= 0xF0,		/* IUDMA debug */
+	BS_SAS_DBG_TXFRAME	= 0xF4,		/* TXFRAME debug */
+	BS_SAS_DBG_RXFRAME	= 0xF8,		/* RXFRAME debug */
+
+	/* SATA per-port registers (replaces SAS register space, in SAS mode) */
+	BS_SATA_STAT		= 0x40,		/* standard SATA phy SStatus */
+	BS_SATA_ERR		= 0x44,		/* standard SATA phy SError */
+	BS_SATA_CTL		= 0x48,		/* standard SATA phy SControl */
+};
+
+enum sas_port_register_bits {
+	/* BS_SAS_ERR_STAT */
+	BS_SAS_ERR_XPRIM_OVER	= (1U << 4),	/* SSP xmit primitive overflw */
+	BS_SAS_ERR_NAK		= (1U << 3),	/* NAK detected */
+	BS_SAS_ERR_ACKNAK_TIMO	= (1U << 2),	/* ACK/NAK timeout */
+	BS_SAS_ERR_PHYRDY	= (1U << 1),	/* PhyRdy changed */
+	BS_SAS_ERR_SATA		= (1U << 0),	/* SATA device detected */
+
+	/* BS_SAS_DBG_IUDMA */
+	BS_SAS_SAS_REGS		= 0,		/* Select SAS registers */
+	BS_SAS_SATA_REGS	= (1U << 16),	/* Select SATA registers */
+	BS_SAS_SATA_FORCE	= (1U << 8),	/* Force SATA mode */
+	BS_SAS_SATA_ACTIVE	= (1U << 0),	/* SATA activated (read-only) */
+
+	QDEPTH_TX_SZ_SHIFT	= 0,		/* tx ring size */
+	QDEPTH_RX_SZ_SHIFT	= 8,		/* rx ring size */
+	QDEPTH_CMD_ISSUE_WINDOW_SHIFT = 16,	/* max cmds dev can queue */
+
+	QINT_ALL_SATA		= 0x3f,
+	QINT_ALL_SAS		= 0x1ffff,
+
+	/* SAS version of BS_QDMA_CTL */
+	QCTL_XFER_RDY_SKIP_CHK	= (1U << 23),	/* skip XR cmd desc err chk */
+	QCTL_TX_DESC_DATA_END	= (1U << 22),	/* mark data-end in TX desc */
+	QCTL_RXDMA_RST		= (1U << 19),	/* RXDMA soft reset */
+	QCTL_RXDMA_ERR_REP	= (1U << 18),	/* RXDMA report error */
+	QCTL_RXDMA_NO_HANG	= (1U << 17),	/* 1==continue rx on error */
+	QCTL_RXDMA_EN		= (1U << 16),	/* RXDMA enable */
+	QCTL_TXDMA_RST		= (1U << 8),	/* TXDMA soft reset */
+	QCTL_PORT_RST		= (1U << 3),	/* port reset (in SAS?) */
+	QCTL_PAUSE		= (1U << 1),	/* QDMA pause */
+	QCTL_EN			= (1U << 0),	/* QDMA enable */
+
+	/* SAS version of BS_QDMA_STAT */
+	QSTAT_RSP_INACT		= (1U << 31), /* inactive RSP frame tag */
+	QSTAT_XR_INACT		= (1U << 30), /* XFER_RDY: inact. frame tag */
+	QSTAT_XR_SIZE		= (1U << 29), /* XFER_RDY: wrong size */
+	QSTAT_XR_NON_DATA	= (1U << 28), /* XFER_RDY: non-data cmd */
+	QSTAT_XR_TAG_MISMATCH	= (1U << 27), /* XFER_RDY: tag mismatch */
+	QSTAT_DATA_INACT	= (1U << 26), /* inactive DATA frame */
+	QSTAT_DATA_TX_DESC	= (1U << 25), /* DATA: bad cmd TX type */
+	QSTAT_DATA_NON_DATA	= (1U << 24), /* DATA: non-data cmd */
+	QSTAT_DATA_TAG_MISMATCH	= (1U << 23), /* DATA: tag mismatch */
+	QSTAT_DATA_RUNT		= (1U << 22), /* DATA: frame larger than desc */
+	QSTAT_OPEN		= (1U << 21), /* rx'd OPEN */
+	QSTAT_IDENTIFY		= (1U << 20), /* rx'd IDENTIFY */
+	QSTAT_UNKNOWN		= (1U << 19), /* rx'd unknown frame */
+	QSTAT_RSP_SPECIAL	= (1U << 18), /* rx'd RSP w/ special tag match*/
+	QSTAT_RSP_GOOD		= (1U << 17), /* rx'd good RSP */
+	QSTAT_IUDMA_PARITY	= (1U << 16), /* IUDMA bus parity err */
+	QSTAT_IUDMA_ABORT	= (1U << 15), /* IUDMA bus master abort */
+	QSTAT_PHY		= (1U << 14), /* PHY change detected */
+	QSTAT_SATA		= (1U << 13), /* SATA device detected */
+	QSTAT_PROTOCOL		= (1U << 12), /* SAS proto specific err */
+	QSTAT_RXDMA_ERR		= (1U << 11), /* RXDMA err int */
+	QSTAT_RXDMA_PARITY	= (1U << 10), /* RXDMA bus parity err */
+	QSTAT_RXDMA_ABORT	= (1U << 9),  /* RXDMA bus master abort */
+	QSTAT_CQDMA_ABORT_PARITY= (1U << 8),  /* cqdma? master abrt / par err */
+	QSTAT_TXDMA_UNDER	= (1U << 7),  /* TXDMA underrun */
+	QSTAT_TXDMA_PARITY	= (1U << 6),  /* TXDMA bus parity err */
+	QSTAT_TXDMA_ABORT	= (1U << 5),  /* TXDMA bus master abort */
+	QSTAT_TX_KILLED		= (1U << 4),  /* internal/software TX abort */
+	QSTAT_RXDMA_OK		= (1U << 3),  /* RXDMA non-error int */
+	QSTAT_DMA_ABORTED	= (1U << 2),  /* QDMA abort acknowledge */
+	QSTAT_DMA_PAUSED	= (1U << 1),  /* QDMA pause acknowledge */
+	QSTAT_DONE		= (1U << 0),  /* cmd/prd done, CLOSE, etc. */
+
+	SAS_CTL_NO_DATA		= (1U << 8), /* Command with no data */
+	SAS_CTL_SATA		= 0,	     /* Connection type: SATA */
+	SAS_CTL_SSP		= (1U << 5), /* Connection type: SSP */
+	SAS_CTL_STP		= (1U << 6), /* Connection type: STP */
+	SAS_CTL_SMP		= (3U << 5), /* Connection type: SMP */
+	SAS_CTL_SKIP		= (1U << 4), /* Skip this entry */
+	SAS_CTL_FIRST_BURST	= (1U << 2), /* Frst brst active 4 cur wr cmd */
+	SAS_CTL_DIR_READ	= (1U << 1),/* Data direction (1==dev to mem) */
+	SAS_CTL_EIN		= (1U << 0), /* INT upon response frame */
+
+	/* BS_SAS_CTL0 */
+	CTL0_INIT_LOWER		= (1U << 16), /* initiator SAS addr lower
+						 than target SAS addr */
+	CTL0_CXN_MGMT		= (1U << 14), /* open/close cxn based on
+						 outstanding frames */
+	CTL0_SPINUP		= (1U << 13), /* send notify spinup prim */
+	CTL0_SSP		= (1U << 9),  /* accept SSP */
+	CTL0_HARD_RST		= (1U << 6),  /* hard reset */
+	CTL0_EN			= (1U << 0),  /* phy enable */
+
+	PRD_EOT			= (1U << 31),	/* end of PRD table */
+
+	BSF_MSI			= (1U << 0),	/* PCI MSI active */
+};
+
+enum bs_tx_bits {
+	TX_DESC_SAS		= 0x10,
+};
+
+enum bs_rx_flag_bits {
+	RSPD_DA			= (1U << 7),	/* data available */
+
+	RSP_TYPE_MASK		= 0x7,
+	RSTYPE_NORMAL		= 0,		/* normal RSP frame */
+	RSTYPE_IDENTIFY		= 1,		/* IDENTIFY frame */
+	RSTYPE_OPEN		= 2,		/* OPEN frame */
+	RSTYPE_UNKNOWN		= 3,		/* unknown frame */
+	RSTYPE_XFER_RDY_ERR	= 4,		/* XFER_RDY with error */
+	RSTYPE_DATA_ERR		= 5,		/* DATA with error */
+	RSTYPE_INACT		= 6,		/* RSP frame w/ inactive tag */
+	RSTYPE_SP_TAG		= 7,		/* RSP frame w/ special tag */
+};
+
+struct bs_tx_raw {
+	__le32			word[8];
+};
+
+struct bs_tx_sas {
+	__le32			flag_type;	/* RDE; ctl flag; desc type */
+	__le32			tag_len;	/* tag; IU length */
+	__le64			frame;		/* frame/IU addr */
+	__le64			next_sg;	/* Next SG addr */
+	__le32			data_lo;	/* First data buf addr lo */
+	__le32			data_hi;	/* First data buf addr hi, len*/
+};
+
+struct bs_prd {
+	__le32			addr_lo;	/* buffer address (low) */
+	__le32			addr_hi_flags;	/* addr (hi), len, flags */
+};
+
+struct bs_rx_desc {
+	__le32			tag_flags;
+	__le32			reserved;
+	__le64			buf_addr;
+};
+
+struct bs_tx_slot {
+	struct bs_prd		*prd;
+	dma_addr_t		prd_dma;
+
+	void			*frame_buf;
+	dma_addr_t		frame_dma;
+};
+
+struct bs_rx_slot {
+	void			*rbuf;
+	dma_addr_t		rbuf_dma;
+};
+
+struct bs_tag_info {
+	struct bs_phy		*phy;
+	struct sas_task		*task;
+	unsigned int		n_elem;
+};
+
+struct bs_port {
+	struct asd_sas_port	sas_port;
+};
+
+struct bs_phy {
+	struct bs_info		*bsi;
+	struct bs_port		*port;
+
+	void __iomem		*regs;		/* this phy's registers */
+
+	struct bs_tx_raw	*tx;		/* TX (command) queue */
+	dma_addr_t		tx_dma;
+	u32			tx_prod;	/* cached producer idx */
+
+	struct bs_rx_desc	*rx;		/* RX (response) queue (SAS) */
+	dma_addr_t		rx_dma;
+
+	struct asd_sas_phy	sas_phy;
+
+	unsigned long		tags[(BS_TX_RING_SZ / sizeof(unsigned long))+1];
+	struct bs_tag_info	tag_info[BS_TX_RING_SZ];
+
+	struct bs_tx_slot	tx_slot[BS_TX_RING_SZ]; /* per-tx-slot info */
+	struct bs_rx_slot	rx_slot[BS_RX_RING_SZ]; /* per-rx-slot info */
+
+	u8			frame_rcvd[24 + 1024];
+};
+
+struct bs_info {
+	unsigned long		flags;
+	struct pci_dev		*pdev;
+	void __iomem		*regs;
+
+	spinlock_t		lock;
+
+	u8			sas_addr[SAS_ADDR_SIZE];
+	struct sas_ha_struct	sas;
+
+	struct Scsi_Host	*shost;
+	struct bs_phy		phy[BS_PHYS];
+	struct bs_port		port[BS_PHYS];
+};
+
+static struct scsi_transport_template *bs_stt;
+
+static struct scsi_host_template bs_sht = {
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
+	if (!pci_set_dma_mask(pdev, DMA_47BIT_MASK)) {
+		rc = pci_set_consistent_dma_mask(pdev, DMA_47BIT_MASK);
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
+static void __iomem *bs_phy_regs(struct bs_info *bsi, int phy_no)
+{
+	return bsi->regs + (0x100 * phy_no);
+}
+
+static bool bs_sata_active(void __iomem *regs)
+{
+	return br32(SAS_DBG_IUDMA) & BS_SAS_SATA_ACTIVE;
+}
+
+static void bs_tag_clear(struct bs_phy *phy, unsigned int tag)
+{
+	phy->tags[tag / sizeof(unsigned long)] &=
+		~(1UL << (tag % sizeof(unsigned long)));
+}
+
+static void bs_tag_set(struct bs_phy *phy, unsigned int tag)
+{
+	phy->tags[tag / sizeof(unsigned long)] |=
+		(1UL << (tag % sizeof(unsigned long)));
+}
+
+static bool bs_tag_test(struct bs_phy *phy, unsigned int tag)
+{
+	return phy->tags[tag / sizeof(unsigned long)] &
+		(1UL << (tag % sizeof(unsigned long)));
+}
+
+static int bs_tag_alloc(struct bs_phy *phy, unsigned int *tag_out)
+{
+	unsigned int i;
+
+	for (i = 0; i < BS_TX_RING_SZ; i++)
+		if (!bs_tag_test(phy, i)) {
+			bs_tag_set(phy, i);
+			*tag_out = i;
+			return 0;
+		}
+
+	return -EBUSY;
+}
+
+static void bs_phy_int_sata(struct bs_phy *phy)
+{
+	void __iomem *regs = phy->regs;
+	u32 dma_stat;
+
+	/* FIXME / TODO */
+
+	dev_printk(KERN_ERR, &phy->bsi->pdev->dev, "unexpected SATA int\n");
+
+	dma_stat = br32(QDMA_STAT);
+	if (dma_stat)
+		bw32(QDMA_STAT, dma_stat);
+}
+
+static void bs_slot_free(struct bs_phy *phy, struct bs_tag_info *bti,
+			 struct sas_task *task, unsigned int tag)
+{
+	if (bti->n_elem)
+		pci_unmap_sg(phy->bsi->pdev, task->scatter,
+			     bti->n_elem, task->data_dir);
+
+	bs_tag_clear(phy, tag);
+}
+
+static void bs_slot_complete(struct bs_phy *phy, unsigned int tag,
+			     unsigned int rx_idx, u32 flags)
+{
+	struct bs_tag_info *bti = &phy->tag_info[tag];
+	struct bs_rx_slot *slot = &phy->rx_slot[tag];
+	struct sas_task *task = bti->task;
+	struct task_status_struct *tstat = &task->task_status;
+	bool aborted;
+
+	spin_lock(&task->task_state_lock);
+	aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
+	if (!aborted) {
+		task->task_state_flags &=
+			~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
+		task->task_state_flags |= SAS_TASK_STATE_DONE;
+	}
+	spin_unlock(&task->task_state_lock);
+
+	if (aborted)
+		return;
+
+	memset(tstat, 0, sizeof(*tstat));
+
+	/* defaults */
+	tstat->resp = SAS_TASK_COMPLETE;
+	tstat->stat = SAM_CHECK_COND;
+
+	/* process response based on protocol */
+	switch (task->task_proto) {
+	case SAS_PROTO_SSP:
+		/* response frame returned in our storage buffer */
+		if (flags & RSPD_DA) {
+			struct ssp_response_iu *iu = slot->rbuf;
+			ssp_task_response(&phy->bsi->pdev->dev, task, iu);
+		}
+
+		/* response frame summarized in RX descriptor */
+		else {
+			struct ssp_response_iu iu = {
+				.status = (flags >> 8) & 0xff,
+			};
+			ssp_task_response(&phy->bsi->pdev->dev, task, &iu);
+		}
+		break;
+
+	default:	/* do nothing, fail via tstat defaults above */
+		break;
+	}
+
+	/* re-init RX slot */
+	phy->rx[rx_idx].tag_flags = cpu_to_le32(RSPD_DA);
+
+	bs_slot_free(phy, bti, task, tag);
+	task->task_done(task);
+}
+
+static void bs_sas_rx(struct bs_phy *phy)
+{
+	void __iomem *regs = phy->regs;
+	u32 prod_idx, cons_idx, tag, rdtype, flags;
+	struct bs_rx_desc *rx;
+	bool work_done = false;
+
+	prod_idx = br32(SAS_RX_PROD_IDX);
+	cons_idx = br32(SAS_RX_CONS_IDX);
+
+	while (prod_idx != cons_idx) {
+		rx = &phy->rx[cons_idx];
+
+		flags = le32_to_cpu(rx->tag_flags);
+		tag = flags >> 16;
+		rdtype = flags & RSP_TYPE_MASK;
+
+		switch (rdtype) {
+		case RSTYPE_NORMAL:	/* normal RSP frame */
+			WARN_ON(!bs_tag_test(phy, tag));
+			bs_slot_complete(phy, tag, cons_idx, flags);
+			break;
+
+		default:
+			dev_printk(KERN_WARNING, &phy->bsi->pdev->dev,
+				   "unsupported frame type %d "
+				   "(flags %x, prod %d, cons %d)\n",
+				   rdtype, flags, prod_idx, cons_idx);
+			break;
+		}
+
+		work_done = true;
+		cons_idx = (cons_idx + 1) & (BS_RX_RING_SZ - 1);
+	}
+
+	if (work_done)
+		bw32(SAS_RX_CONS_IDX, cons_idx);
+}
+
+static void bs_phy_int_sas(struct bs_phy *phy)
+{
+	void __iomem *regs = phy->regs;
+	u32 sas_err, dma_stat;
+
+	sas_err = br32(SAS_ERR_STAT);
+	if (sas_err) {
+		bw32(SAS_ERR_STAT, sas_err);
+		dev_printk(KERN_ERR, &phy->bsi->pdev->dev,
+			   "SAS_ERR_STAT 0x%x\n", sas_err);
+	}
+
+	dma_stat = br32(QDMA_STAT);
+	if (dma_stat) {
+		bw32(QDMA_STAT, dma_stat);
+
+		if (dma_stat & QSTAT_DONE)
+			bs_sas_rx(phy);
+	}
+}
+
+static void bs_phy_int(struct bs_phy *phy)
+{
+	if (bs_sata_active(phy->regs))
+		bs_phy_int_sata(phy);
+	else
+		bs_phy_int_sas(phy);
+}
+
+static irqreturn_t bs_interrupt(int irq, void *opaque)
+{
+	struct bs_info *bsi = opaque;
+	int i;
+	u32 stat;
+
+	stat = readl(bsi->regs + GBL_STAT);
+	if (stat == 0 || stat == 0xffffffff)
+		return IRQ_NONE;
+
+	spin_lock(&bsi->lock);
+
+	for (i = 0; i < BS_PHYS; i++)
+		if (stat & (1U << i))
+			bs_phy_int(&bsi->phy[i]);
+
+	spin_unlock(&bsi->lock);
+
+	return IRQ_HANDLED;
+}
+
+static void bs_fill_sg(struct bs_tx_sas *cmd, struct bs_tx_slot *tx_slot,
+		       struct scatterlist *sg, unsigned int n_elem)
+{
+	int i;
+	u32 eot;
+
+	for (i = 0; i < n_elem; i++) {
+		if (i == (n_elem - 1))
+			eot = PRD_EOT;
+		else
+			eot = 0;
+		if (i == 0) {
+			if (eot)
+				eot = (1 << 0);
+			cmd->data_lo = cpu_to_le32(sg_dma_address(sg) | eot);
+			cmd->data_hi = cpu_to_le32(
+				((((u64)sg_dma_address(sg)) >> 32) & 0xffff) |
+				(sg_dma_len(sg) << 16));
+		} else {
+			struct bs_prd *prd;
+
+			prd = &tx_slot->prd[i - 1];
+
+			prd->addr_lo = cpu_to_le32(sg_dma_address(sg));
+			prd->addr_hi_flags = cpu_to_le32(eot |
+			      ((((u64)sg_dma_address(sg)) >> 16) & 0x7fff0000) |
+			      (sg_dma_len(sg) & 0xffff));
+		}
+
+		sg++;
+	}
+}
+
+static int bs_task_exec_sata(struct bs_phy *phy,
+			     struct sas_task *task, unsigned int tag,
+			     const int num, gfp_t gfp_flags)
+{
+	return -EINVAL;
+}
+
+static void bs_task_prep_ssp(struct bs_info *bsi, struct sas_task *task,
+			     struct bs_tx_slot *tx_slot, unsigned int tag,
+			     unsigned int *iu_len)
+{
+	struct ssp_frame_hdr *ssp_hdr;
+	u8 *buf_cmd;
+	u8 fburst = 0;
+
+	if (task->ssp_task.enable_first_burst)
+		fburst = (1 << 7);
+
+	memset(tx_slot->frame_buf, 0, BS_TX_FRAME_SZ);
+	ssp_hdr = tx_slot->frame_buf;
+	ssp_hdr->frame_type = SSP_COMMAND;
+	memcpy(ssp_hdr->hashed_dest_addr, task->dev->hashed_sas_addr,
+	       HASHED_SAS_ADDR_SIZE);
+	memcpy(ssp_hdr->hashed_src_addr,
+	       task->dev->port->ha->hashed_sas_addr, HASHED_SAS_ADDR_SIZE);
+	ssp_hdr->tag = cpu_to_be16(tag);
+
+	/* fill in command frame IU */
+	buf_cmd = tx_slot->frame_buf + sizeof(*ssp_hdr);
+	memcpy(buf_cmd, &task->ssp_task.LUN, 8);
+	buf_cmd[9] = fburst |
+		task->ssp_task.task_attr |
+		(task->ssp_task.task_prio << 3);
+	memcpy(buf_cmd + 12, &task->ssp_task.cdb, 16);
+
+	*iu_len = 28;	/* size of COMMAND frame IU */
+}
+
+static int bs_task_exec_sas(struct bs_phy *phy,
+			    struct sas_task *task, unsigned int tag,
+			    const int num, gfp_t gfp_flags)
+{
+	u32 slot_idx = phy->tx_prod;
+	struct bs_tx_sas *cmd = (struct bs_tx_sas *) &phy->tx[slot_idx];
+	struct bs_tx_slot *tx_slot = &phy->tx_slot[slot_idx];
+	void __iomem *regs = phy->regs;
+	u32 ctl_flags = SAS_CTL_EIN;
+	unsigned int n_elem = 0, iu_len = 0;
+	int rc;
+
+	if (task->num_scatter) {
+		n_elem = pci_map_sg(phy->bsi->pdev, task->scatter,
+				    task->num_scatter, task->data_dir);
+		if (!n_elem)
+			return -ENOMEM;
+	}
+
+	if (task->data_dir == DMA_NONE)
+		ctl_flags |= SAS_CTL_NO_DATA;
+	else if (task->data_dir == DMA_FROM_DEVICE)
+		ctl_flags |= SAS_CTL_DIR_READ;
+
+	switch (task->task_proto) {
+	case SAS_PROTO_SSP:
+		ctl_flags |= SAS_CTL_SSP;
+		bs_task_prep_ssp(phy->bsi, task, tx_slot, tag, &iu_len);
+		break;
+
+	default:
+		WARN_ON(1);
+		/* fall through */
+
+	case SAS_PROTO_STP:
+	case SAS_PROTO_SMP:
+		rc = -EINVAL;
+		goto err_out;
+	}
+
+	cmd->flag_type = cpu_to_le32(TX_DESC_SAS |
+		(ctl_flags << 8));
+	cmd->tag_len = cpu_to_le32((tag << 16) | iu_len);
+	cmd->frame = cpu_to_le64(tx_slot->frame_dma);
+
+	if (n_elem) {
+		cmd->next_sg = cpu_to_le64(tx_slot->prd_dma);
+		bs_fill_sg(cmd, tx_slot, task->scatter, n_elem);
+	} else
+		cmd->next_sg = 0;
+
+	spin_lock(&task->task_state_lock);
+	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
+	spin_unlock(&task->task_state_lock);
+
+	phy->tx_prod =
+	slot_idx = (slot_idx + 1) & (BS_TX_RING_SZ - 1);
+	bw32(TX_PROD_IDX, slot_idx);
+
+	phy->tag_info[tag].n_elem = n_elem;
+	return 0;
+
+err_out:
+	if (n_elem)
+		pci_unmap_sg(phy->bsi->pdev, task->scatter, n_elem,
+			     task->data_dir);
+	return rc;
+}
+
+static int bs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
+{
+	struct bs_info *bsi = task->dev->port->ha->lldd_ha;
+	struct bs_phy *phy = &bsi->phy[0];		/* FIXME FIXME FIXME */
+	int rc;
+	unsigned int tag = 0xdeadbeef;
+	unsigned long flags;
+	bool sata;
+
+	sata = bs_sata_active(phy->regs);
+	if (sata) {
+		if (task->task_proto != SATA_PROTO)
+			return -EINVAL;
+	} else {
+		if (task->task_proto == SATA_PROTO)
+			return -EINVAL;
+	}
+
+	spin_lock_irqsave(&bsi->lock, flags);
+
+	rc = bs_tag_alloc(phy, &tag);
+	if (rc)
+		goto out;
+
+	if (sata)
+		rc = bs_task_exec_sata(phy, task, tag, num, gfp_flags);
+	else
+		rc = bs_task_exec_sas(phy, task, tag, num, gfp_flags);
+
+	if (rc)
+		goto err_out;
+
+	phy->tag_info[tag].phy = phy;
+	phy->tag_info[tag].task = task;
+
+out:
+	spin_unlock_irqrestore(&bsi->lock, flags);
+	return rc;
+
+err_out:
+	bs_tag_clear(phy, tag);
+	goto out;
+}
+
+static void bs_phy_free(struct bs_phy *phy)
+{
+	struct bs_info *bsi = phy->bsi;
+	int i;
+
+	if (phy->tx)
+		dma_free_coherent(&bsi->pdev->dev, BS_TX_SZ * BS_TX_RING_SZ,
+				  phy->tx, phy->tx_dma);
+	if (phy->rx)
+		dma_free_coherent(&bsi->pdev->dev, BS_RX_SZ * BS_RX_RING_SZ,
+				  phy->rx, phy->rx_dma);
+
+	for (i = 0; i < BS_TX_RING_SZ; i++) {
+		struct bs_tx_slot *tx_slot = &phy->tx_slot[i];
+
+		if (tx_slot->prd) {
+			dma_free_coherent(&bsi->pdev->dev,
+					BS_MAX_PRD * sizeof(struct bs_prd),
+					tx_slot->prd, tx_slot->prd_dma);
+		}
+		if (tx_slot->frame_buf) {
+			dma_free_coherent(&bsi->pdev->dev, BS_TX_FRAME_SZ,
+					  tx_slot->frame_buf,
+					  tx_slot->frame_dma);
+		}
+	}
+
+	for (i = 0; i < BS_RX_RING_SZ; i++) {
+		struct bs_rx_slot *rx_slot = &phy->rx_slot[i];
+
+		if (rx_slot->rbuf) {
+			dma_free_coherent(&bsi->pdev->dev, BS_RX_BUF_SZ,
+					  rx_slot->rbuf, rx_slot->rbuf_dma);
+		}
+	}
+}
+
+static void bs_free(struct bs_info *bsi)
+{
+	int i;
+
+	if (!bsi)
+		return;
+
+	for (i = 0; i < BS_PHYS; i++)
+		bs_phy_free(&bsi->phy[i]);
+
+	if (bsi->regs)
+		iounmap(bsi->regs);
+	if (bsi->shost)
+		scsi_host_put(bsi->shost);
+	kfree(bsi->sas.sas_port);
+	kfree(bsi->sas.sas_phy);
+	kfree(bsi);
+}
+
+static int __devinit bs_phy_alloc(struct bs_info *bsi, int phy_no)
+{
+	struct bs_phy *phy = &bsi->phy[phy_no];
+	int i;
+
+	phy->bsi = bsi;
+	phy->regs = bs_phy_regs(bsi, phy_no);
+	bs_tag_set(phy, BS_TX_RING_SZ - 1);
+
+	phy->tx = dma_alloc_coherent(&bsi->pdev->dev, BS_TX_SZ * BS_TX_RING_SZ,
+				       &phy->tx_dma, GFP_KERNEL);
+	if (!phy->tx)
+		return -ENOMEM;
+
+	phy->rx = dma_alloc_coherent(&bsi->pdev->dev, BS_RX_SZ * BS_RX_RING_SZ,
+				       &phy->rx_dma, GFP_KERNEL);
+	if (!phy->rx)
+		return -ENOMEM;
+
+	for (i = 0; i < BS_TX_RING_SZ; i++) {
+		struct bs_tx_slot *tx_slot = &phy->tx_slot[i];
+
+		tx_slot->prd = dma_alloc_coherent(&bsi->pdev->dev,
+					BS_MAX_PRD * sizeof(struct bs_prd),
+					&tx_slot->prd_dma, GFP_KERNEL);
+		if (!tx_slot->prd)
+			return -ENOMEM;
+		tx_slot->frame_buf = dma_alloc_coherent(&bsi->pdev->dev,
+					BS_TX_FRAME_SZ, &tx_slot->frame_dma,
+					GFP_KERNEL);
+		if (!tx_slot->frame_buf)
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < BS_RX_RING_SZ; i++) {
+		struct bs_rx_slot *rx_slot = &phy->rx_slot[i];
+
+		rx_slot->rbuf = dma_alloc_coherent(&bsi->pdev->dev,BS_RX_BUF_SZ,
+					&rx_slot->rbuf_dma, GFP_KERNEL);
+		if (!rx_slot->rbuf)
+			return -ENOMEM;
+
+		phy->rx[i].tag_flags = cpu_to_le32(RSPD_DA);
+		phy->rx[i].buf_addr = cpu_to_le64(rx_slot->rbuf_dma);
+	}
+
+	return 0;
+}
+
+/* FIXME: locking? */
+static int bs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
+			   void *funcdata)
+{
+	struct bs_phy *phy = sas_phy->lldd_phy;
+	void __iomem *regs = phy->regs;
+	int rc;
+	u32 tmp;
+
+	switch (func) {
+	case PHY_FUNC_LINK_RESET:
+		/* FIXME: correct? */
+		tmp = br32(SAS_CTL0);
+		if (!(tmp & CTL0_EN)) {
+			bw32_f(SAS_CTL0, tmp | CTL0_EN);
+			break;
+		}
+
+		/* fall through */
+
+	case PHY_FUNC_HARD_RESET:
+		tmp = br32(SAS_CTL0);
+		if (tmp & CTL0_HARD_RST)
+			tmp &= ~CTL0_HARD_RST;
+		else
+			bw32_f(SAS_CTL0, tmp | CTL0_HARD_RST);
+		udelay(500);
+		bw32_f(SAS_CTL0, tmp);
+		break;
+
+	case PHY_FUNC_DISABLE:
+		tmp = br32(SAS_CTL0);
+		if (tmp & CTL0_EN)
+			bw32_f(SAS_CTL0, tmp & ~CTL0_EN);
+		break;
+
+	case PHY_FUNC_RELEASE_SPINUP_HOLD:
+
+	case PHY_FUNC_SET_LINK_RATE:
+	default:
+		rc = -EOPNOTSUPP;
+	}
+
+	return rc;
+}
+
+static void __devinit bs_phy_init(struct bs_info *bsi, int phy_id)
+{
+	struct bs_phy *phy = &bsi->phy[phy_id];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+
+	sas_phy->enabled = 1;
+	sas_phy->class = SAS;
+	sas_phy->iproto = SAS_PROTO_ALL;
+	sas_phy->tproto = 0;
+	sas_phy->type = PHY_TYPE_PHYSICAL;
+	sas_phy->role = PHY_ROLE_INITIATOR;
+	sas_phy->oob_mode = OOB_NOT_CONNECTED;
+	sas_phy->linkrate = SAS_LINK_RATE_UNKNOWN;
+
+	sas_phy->id = phy_id;
+	sas_phy->sas_addr = &bsi->sas_addr[0];
+	sas_phy->frame_rcvd = &phy->frame_rcvd[0];
+	sas_phy->ha = &bsi->sas;
+	sas_phy->lldd_phy = phy;
+}
+
+static struct bs_info * __devinit bs_alloc(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	struct bs_info *bsi;
+	unsigned long res_start, res_len;
+	struct asd_sas_phy **arr_phy;
+	struct asd_sas_port **arr_port;
+	int i;
+
+	bsi = kzalloc(sizeof(*bsi), GFP_KERNEL);
+	if (!bsi)
+		return NULL;
+
+	spin_lock_init(&bsi->lock);
+	bsi->pdev = pdev;
+
+	bsi->shost = scsi_host_alloc(&bs_sht, sizeof(void *));
+	if (!bsi->shost)
+		goto err_out;
+
+	arr_phy = kcalloc(BS_PHYS, sizeof(void *), GFP_KERNEL);
+	arr_port = kcalloc(BS_PHYS, sizeof(void *), GFP_KERNEL);
+	if (!arr_phy || !arr_port)
+		goto err_out;
+
+	for (i = 0; i < BS_PHYS; i++) {
+		bs_phy_init(bsi, i);
+		arr_phy[i] = &bsi->phy[i].sas_phy;
+		arr_port[i] = &bsi->port[i].sas_port;
+	}
+
+	SHOST_TO_SAS_HA(bsi->shost) = &bsi->sas;
+	bsi->shost->transportt = bs_stt;
+	bsi->shost->max_id = ~0;
+	bsi->shost->max_lun = ~0;
+	bsi->shost->max_cmd_len = ~0;
+
+	bsi->sas.sas_ha_name = DRV_NAME;
+	bsi->sas.dev = &pdev->dev;
+	bsi->sas.lldd_module = THIS_MODULE;
+	bsi->sas.sas_addr = &bsi->sas_addr[0];
+	bsi->sas.sas_phy = arr_phy;
+	bsi->sas.sas_port = arr_port;
+	bsi->sas.num_phys = BS_PHYS;
+	bsi->sas.lldd_max_execute_num = BS_TX_RING_SZ - 1; /* FIXME: correct? */
+	bsi->sas.lldd_queue_size = BS_TX_RING_SZ - 1;	   /* FIXME: correct? */
+	bsi->sas.lldd_ha = bsi;
+	bsi->sas.core.shost = bsi->shost;
+
+	res_start = pci_resource_start(pdev, 2);
+	res_len = pci_resource_len(pdev, 2);
+	if (!res_start || !res_len)
+		goto err_out;
+
+	bsi->regs = ioremap_nocache(res_start, res_len);
+	if (!bsi->regs)
+		goto err_out;
+
+	for (i = 0; i < BS_PHYS; i++)
+		if (bs_phy_alloc(bsi, i))
+			goto err_out;
+
+	/* FIXME: obtain SAS address from somewhere */
+
+	return bsi;
+
+err_out:
+	bs_free(bsi);
+	return NULL;
+}
+
+static void __devinit bs_phy_clear(struct bs_phy *phy, bool sata)
+{
+	void __iomem *regs = phy->regs;
+	u32 tmp;
+
+	tmp = br32(QDMA_STAT);
+	if (tmp)
+		bw32(QDMA_STAT, tmp);
+
+	if (!sata) {
+		tmp = br32(SAS_ERR_STAT);
+		if (tmp)
+			bw32(SAS_ERR_STAT, tmp);
+	}
+}
+
+static void __devinit bs_phy_hw_init(struct bs_phy *phy)
+{
+	void __iomem *regs = phy->regs;
+	u32 tmp;
+	bool sata;
+
+	/*
+	 * first, make sure things are quiet
+	 */
+
+	sata = bs_sata_active(regs);
+	if (sata)					/* quiet phy */
+		bw32(SATA_CTL, 0x3);
+	else
+		bw32(SAS_CTL0, br32(SAS_CTL0) & ~CTL0_EN);
+	bw32_f(QDMA_CTL, 0);				/* quiet DMA engines */
+
+	/*
+	 * reset port machinery
+	 */
+
+	if (sata)
+		tmp = QCTL_PORT_RST;
+	else
+		tmp = QCTL_RXDMA_RST | QCTL_TXDMA_RST;
+	bw32_f(QDMA_CTL, tmp);
+
+	udelay(250);
+
+	bw32_f(QDMA_CTL, 0);
+	bw32(SAS_RX_CONS_IDX, 0);
+
+	/* paranoia: did/would SATA mode change? */
+	sata = bs_sata_active(regs);
+	bs_phy_clear(phy, sata);
+
+	/*
+	 * reset phy
+	 */
+
+	if (sata) {
+		bw32(SATA_CTL, 0x301);		/* initiate phy reset */
+	} else {
+		bw32_f(SAS_CTL0, br32(SAS_CTL0) | CTL0_HARD_RST | CTL0_EN);
+		udelay(500);
+		tmp = br32(SAS_CTL0);
+		if (tmp & CTL0_HARD_RST) {
+			tmp &= ~CTL0_HARD_RST;
+			bw32_f(SAS_CTL0, tmp);
+		}
+	}
+
+	/*
+	 * configure SAS/SATA TX ring
+	 */
+
+	bw32(TX_ADDR_LO, phy->tx_dma);
+	bw32(TX_ADDR_HI, (phy->tx_dma >> 16) >> 16);
+	phy->tx_prod = br32(TX_CONS_IDX);
+	bw32(TX_PROD_IDX, phy->tx_prod);		/* == empty */
+
+	tmp = BS_TX_RING_SZ - 1;
+	if (!sata) {
+		tmp |= (BS_RX_RING_SZ << QDEPTH_RX_SZ_SHIFT);
+		tmp |= (BS_TX_RING_SZ << QDEPTH_CMD_ISSUE_WINDOW_SHIFT);
+	}
+	bw32(QDMA_Q_DEPTH, tmp);
+
+	/*
+	 * configure SAS RX ring
+	 */
+	if (!sata) {
+		bw32(SAS_RX_ADDR_LO, phy->rx_dma);
+		bw32(SAS_RX_ADDR_HI, (phy->rx_dma >> 16) >> 16);
+		bw32(SAS_RX_CONS_IDX, br32(SAS_RX_PROD_IDX));	/* == empty */
+		bw32(SAS_RX_IU_MAX_SZ, BS_RX_BUF_SZ);
+	}
+
+	/* all interrupt sources are palatable; turn them all on */
+	if (sata)
+		bw32(QDMA_INT_MASK, QINT_ALL_SATA);
+	else
+		bw32(QDMA_INT_MASK, QINT_ALL_SAS);
+}
+
+static void __devinit bs_phy_enable(struct bs_phy *phy)
+{
+	void __iomem *regs = phy->regs;
+	bool sata = bs_sata_active(regs);
+	u32 tmp;
+
+	tmp = QCTL_EN;
+	if (!sata)
+		tmp |= QCTL_RXDMA_EN;
+	bw32_f(QDMA_CTL, tmp);
+
+	bs_phy_clear(phy, sata);
+}
+
+static void __devinit bs_hw_init(struct bs_info *bsi)
+{
+	int i;
+
+	/* first, make sure interrupts are masked */
+	writel(0, bsi->regs + GBL_INT_MASK);
+	readl(bsi->regs + GBL_INT_MASK);	/* flush */
+	for (i = 0; i < BS_PHYS; i++) {
+		void __iomem *regs = bsi->phy[i].regs;
+		bw32(QDMA_INT_MASK, 0);
+	}
+
+	/* reset and init phys */
+	for (i = 0; i < BS_PHYS; i++)
+		bs_phy_hw_init(&bsi->phy[i]);
+
+	/* enable phy DMA engines */
+	for (i = 0; i < BS_PHYS; i++)
+		bs_phy_enable(&bsi->phy[i]);
+
+	/* enable ints for phys 0-7 */
+	writel(0xff, bsi->regs + GBL_INT_MASK);
+}
+
+static void __devinit bs_print_info(struct bs_info *bsi)
+{
+	struct pci_dev *pdev = bsi->pdev;
+	static int printed_version;
+
+	if (!printed_version++)
+		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+
+	dev_printk(KERN_INFO, &pdev->dev, "%u phys, addr %llx\n",
+		   BS_PHYS, SAS_ADDR(bsi->sas_addr));
+}
+
+static int __devinit bs_pci_init(struct pci_dev *pdev,
+				 const struct pci_device_id *ent)
+{
+	int rc;
+	struct bs_info *bsi;
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
+	bsi = bs_alloc(pdev, ent);
+	if (!bsi) {
+		rc = -ENOMEM;
+		goto err_out_regions;
+	}
+
+	bs_hw_init(bsi);
+
+	if (!pci_enable_msi(pdev))
+		bsi->flags |= BSF_MSI;
+
+	rc = request_irq(pdev->irq, bs_interrupt, IRQF_SHARED, DRV_NAME, bsi);
+	if (rc)
+		goto err_out_msi;
+
+	rc = scsi_add_host(bsi->shost, &pdev->dev);
+	if (rc)
+		goto err_out_irq;
+
+	rc = sas_register_ha(&bsi->sas);
+	if (rc)
+		goto err_out_shost;
+
+	pci_set_drvdata(pdev, bsi);
+
+	bs_print_info(bsi);
+
+	scsi_scan_host(bsi->shost);
+	return 0;
+
+err_out_shost:
+	scsi_remove_host(bsi->shost);
+err_out_irq:
+	free_irq(pdev->irq, bsi);
+err_out_msi:
+	if (bsi->flags & BSF_MSI)
+		pci_disable_msi(pdev);
+	bs_free(bsi);
+err_out_regions:
+	pci_release_regions(pdev);
+err_out_disable:
+	pci_disable_device(pdev);
+	return rc;
+}
+
+static void __devexit bs_pci_remove(struct pci_dev *pdev)
+{
+	struct bs_info *bsi = pci_get_drvdata(pdev);
+
+	pci_set_drvdata(pdev, NULL);
+
+	sas_unregister_ha(&bsi->sas);
+	sas_remove_host(bsi->shost);
+	scsi_remove_host(bsi->shost);
+
+	free_irq(pdev->irq, bsi);
+	if (bsi->flags & BSF_MSI)
+		pci_disable_msi(pdev);
+	bs_free(bsi);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static struct sas_domain_function_template bs_transport_ops = {
+	.lldd_execute_task	= bs_task_exec,
+	.lldd_control_phy	= bs_phy_control,
+};
+
+static struct pci_device_id __devinitdata bs_pci_table[] = {
+	{ PCI_VDEVICE(BROADCOM, 0x0252) },
+
+	{ }	/* terminate list */
+};
+
+static struct pci_driver bs_pci_driver = {
+	.name		= DRV_NAME,
+	.id_table	= bs_pci_table,
+	.probe		= bs_pci_init,
+	.remove		= __devexit_p(bs_pci_remove),
+};
+
+static int __init bs_init(void)
+{
+	int rc;
+
+	bs_stt = sas_domain_attach_transport(&bs_transport_ops);
+	if (!bs_stt)
+		return -ENOMEM;
+
+	rc = pci_register_driver(&bs_pci_driver);
+	if (rc)
+		goto err_out;
+
+	return 0;
+
+err_out:
+	sas_release_transport(bs_stt);
+	return rc;
+}
+
+static void __exit bs_exit(void)
+{
+	pci_unregister_driver(&bs_pci_driver);
+	sas_release_transport(bs_stt);
+}
+
+module_init(bs_init);
+module_exit(bs_exit);
+
+MODULE_AUTHOR("Jeff Garzik <jgarzik@pobox.com>");
+MODULE_DESCRIPTION("Broadcom 8603 SAS/SATA controller driver");
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, bs_pci_table);
+
diff --git a/drivers/scsi/libsas/Makefile b/drivers/scsi/libsas/Makefile
index fd387b9..cd660cd 100644
--- a/drivers/scsi/libsas/Makefile
+++ b/drivers/scsi/libsas/Makefile
@@ -33,5 +33,6 @@ libsas-y +=  sas_init.o     \
 		sas_dump.o     \
 		sas_discover.o \
 		sas_expander.o \
-		sas_scsi_host.o
+		sas_scsi_host.o \
+		lib.o
 libsas-$(CONFIG_SCSI_SAS_ATA) +=	sas_ata.o
diff --git a/drivers/scsi/libsas/lib.c b/drivers/scsi/libsas/lib.c
new file mode 100644
index 0000000..a8c1a8c
--- /dev/null
+++ b/drivers/scsi/libsas/lib.c
@@ -0,0 +1,37 @@
+#include <linux/kernel.h>
+#include <scsi/sas.h>
+#include <scsi/libsas.h>
+
+/* fill task_status_struct based on SSP response frame */
+void ssp_task_response(struct device *dev, struct sas_task *task,
+		       struct ssp_response_iu *iu)
+{
+	struct task_status_struct *tstat = &task->task_status;
+
+	tstat->resp = SAS_TASK_COMPLETE;
+
+	if (iu->datapres == 0)
+		tstat->stat = iu->status;
+	else if (iu->datapres == 1)
+		tstat->stat = iu->resp_data[3];
+	else if (iu->datapres == 2) {
+		tstat->stat = SAM_CHECK_COND;
+		tstat->buf_valid_size =
+			min_t(int, SAS_STATUS_BUF_SIZE,
+			      be32_to_cpu(iu->sense_data_len));
+		memcpy(tstat->buf, iu->sense_data, tstat->buf_valid_size);
+
+		if (iu->status != SAM_CHECK_COND)
+			dev_printk(KERN_WARNING, dev,
+				   "dev %llx sent sense data, but "
+				   "stat(%x) is not CHECK CONDITION\n",
+				   SAS_ADDR(task->dev->sas_addr),
+				   iu->status);
+	}
+	else
+		/* when datapres contains corrupt/unknown value... */
+		tstat->stat = SAM_CHECK_COND;
+}
+
+EXPORT_SYMBOL_GPL(ssp_task_response);
+
diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
new file mode 100644
index 0000000..c3bad07
--- /dev/null
+++ b/drivers/scsi/mvsas.c
@@ -0,0 +1,1711 @@
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
+	MVS_SSP_CMD_SZ		= 64,	/* SSP command table buffer size */
+	MVS_SSP_OAF_SZ		= 64,	/* Open address frame buffer size */
+
+	MVS_RX_FIS_COUNT	= 17,	/* Optional rx'd FISs (max 17) */
+};
+
+/* unchangeable hardware details */
+enum hardware_details {
+	MVS_MAX_PHYS		= 8,	/* max. possible phys */
+	MVS_MAX_PORTS		= 8,	/* max. possible ports */
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
+
+					 /* ports 1-3 follow after this */
+	MVS_P0_INT_STAT		= 0x160, /* port0 interrupt status */
+	MVS_P0_INT_MASK		= 0x164, /* port0 interrupt mask */
+
+					 /* ports 1-3 follow after this */
+	MVS_P0_SER_CTLSTAT	= 0x180, /* port0 serial control/status */
+
+	MVS_CMD_ADDR		= 0x1B8, /* Command register port (addr) */
+	MVS_CMD_DATA		= 0x1BC, /* Command register port (data) */
+
+					 /* ports 1-3 follow after this */
+	MVS_P0_CFG_ADDR		= 0x1C0, /* port0 phy register address */
+	MVS_P0_CFG_DATA		= 0x1C4, /* port0 phy register data */
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
+
+	/* MVS_Px_INT_STAT, MVS_Px_INT_MASK (per-phy events) */
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
+	PCS_SATA_RETRY		= (1U << 8),	/* retry ctl FIS on R_ERR */
+	PCS_RSP_RX_EN		= (1U << 7),	/* raw response rx */
+	PCS_SELF_CLEAR		= (1U << 5),	/* self-clearing int mode */
+	PCS_FIS_RX_EN		= (1U << 4),	/* FIS rx enable */
+	PCS_CMD_STOP_ERR	= (1U << 3),	/* cmd stop-on-err enable */
+	PCS_CMD_RST		= (1U << 2),	/* reset cmd issue */
+	PCS_CMD_EN		= (1U << 0),	/* enable cmd issue */
+};
+
+enum mvs_info_flags {
+	MVF_MSI			= (1U << 0),	/* MSI is enabled */
+	MVF_PHY_PWR_FIX		= (1U << 1),	/* bug workaround */
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
+/* SAS/SATA configuration port registers, aka phy registers */
+enum sas_sata_config_port_regs {
+	PHYR_IDENTIFY		= 0x0,	/* info for IDENTIFY frame */
+	PHYR_ADDR_LO		= 0x4,	/* my SAS address (low) */
+	PHYR_ADDR_HI		= 0x8,	/* my SAS address (high) */
+	PHYR_ATT_DEV_INFO	= 0xC,	/* attached device info */
+	PHYR_ATT_ADDR_LO	= 0x10,	/* attached dev SAS addr (low) */
+	PHYR_ATT_ADDR_HI	= 0x14,	/* attached dev SAS addr (high) */
+	PHYR_SATA_CTL		= 0x18,	/* SATA control */
+	PHYR_PHY_STAT		= 0x1C,	/* PHY status */
+	PHYR_WIDE_PORT		= 0x38,	/* wide port participating */
+	PHYR_CURRENT0		= 0x80,	/* current connection info 0 */
+	PHYR_CURRENT1		= 0x84,	/* current connection info 1 */
+	PHYR_CURRENT2		= 0x88,	/* current connection info 2 */
+};
+
+enum pci_cfg_registers {
+	PCR_PHY_CTL		= 0x40,
+	PCR_PHY_CTL2		= 0x90,
+};
+
+enum pci_cfg_register_bits {
+	PCTL_PWR_ON		= (0xFU << 24),
+	PCTL_OFF		= (0xFU << 12),
+};
+
+enum nvram_layout_offsets {
+	NVR_SIG			= 0x00,		/* 0xAA, 0x55 */
+	NVR_SAS_ADDR		= 0x02,		/* 8-byte SAS address */
+};
+
+enum chip_flavors {
+	chip_6320,
+	chip_6440,
+	chip_6480,
+};
+
+struct mvs_chip_info {
+	unsigned int		n_phy;
+	unsigned int		srs_sz;
+	unsigned int		slot_width;
+};
+
+struct mvs_err_info {
+	__le32			flags;
+	__le32			flags2;
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
+
+	void			*response;
+};
+
+struct mvs_port {
+	struct asd_sas_port	sas_port;
+};
+
+struct mvs_phy {
+	struct mvs_port		*port;
+	struct asd_sas_phy	sas_phy;
+
+	u8			frame_rcvd[24 + 1024];
+};
+
+struct mvs_info {
+	unsigned long		flags;
+
+	spinlock_t		lock;		/* host-wide lock */
+	struct pci_dev		*pdev;		/* our device */
+	void __iomem		*regs;		/* enhanced mode registers */
+	void __iomem		*peri_regs;	/* peripheral registers */
+
+	u8			sas_addr[SAS_ADDR_SIZE];
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
+	const struct mvs_chip_info *chip;
+
+					/* further per-slot information */
+	struct mvs_slot_info	slot_info[MVS_SLOTS];
+	unsigned long		tags[(MVS_SLOTS / sizeof(unsigned long)) + 1];
+
+	struct mvs_phy		phy[MVS_MAX_PHYS];
+	struct mvs_port		port[MVS_MAX_PHYS];
+};
+
+static struct scsi_transport_template *mvs_stt;
+
+static const struct mvs_chip_info mvs_chips[] = {
+	[chip_6320] =		{ 2, 16, 9 },
+	[chip_6440] =		{ 4, 16, 9 },
+	[chip_6480] =		{ 8, 32, 10 },
+};
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
+static void mvs_int_rx(struct mvs_info *mvi, bool self_clear);
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
+
+static int mvs_eep_read_buf(void __iomem *regs, unsigned int addr,
+			    void *buf, unsigned int buflen)
+{
+	unsigned int addr_end, tmp_addr, i, j;
+	u32 tmp = 0;
+	int rc;
+	u8 *tmp8, *buf8 = buf;
+
+	addr_end = addr + buflen;
+	tmp_addr = ALIGN(addr, 4);
+	if (addr > 0xff)
+		return -EINVAL;
+
+	j = addr & 0x3;
+	if (j) {
+		rc = mvs_eep_read(regs, tmp_addr, &tmp);
+		if (rc)
+			return rc;
+
+		tmp8 = (u8 *) &tmp;
+		for (i = j; i < 4; i++)
+			*buf8++ = tmp8[i];
+
+		tmp_addr += 4;
+	}
+
+	for (j = ALIGN(addr_end, 4); tmp_addr < j; tmp_addr += 4) {
+		rc = mvs_eep_read(regs, tmp_addr, &tmp);
+		if (rc)
+			return rc;
+
+		memcpy(buf8, &tmp, 4);
+		buf8 += 4;
+	}
+
+	if (tmp_addr < addr_end) {
+		rc = mvs_eep_read(regs, tmp_addr, &tmp);
+		if (rc)
+			return rc;
+
+		tmp8 = (u8 *) &tmp;
+		j = addr_end - tmp_addr;
+		for (i = 0; i < j; i++)
+			*buf8++ = tmp8[i];
+
+		tmp_addr += 4;
+	}
+
+	return 0;
+}
+
+static int mvs_nvram_read(struct mvs_info *mvi, unsigned int addr,
+			  void *buf, unsigned int buflen)
+{
+	void __iomem *regs = mvi->regs;
+	int rc, i;
+	unsigned int sum;
+	u8 hdr[2], *tmp;
+	const char *msg;
+
+	rc = mvs_eep_read_buf(regs, addr, &hdr, 2);
+	if (rc) {
+		msg = "nvram hdr read failed";
+		goto err_out;
+	}
+	rc = mvs_eep_read_buf(regs, addr + 2, buf, buflen);
+	if (rc) {
+		msg = "nvram read failed";
+		goto err_out;
+	}
+
+	if (hdr[0] != 0x5A) {		/* entry id */
+		msg = "invalid nvram entry id";
+		rc = -ENOENT;
+		goto err_out;
+	}
+
+	tmp = buf;
+	sum = ((unsigned int)hdr[0]) + ((unsigned int)hdr[1]);
+	for (i = 0; i < buflen; i++)
+		sum += ((unsigned int)tmp[i]);
+
+	if (sum) {
+		msg = "nvram checksum failure";
+		rc = -EILSEQ;
+		goto err_out;
+	}
+
+	return 0;
+
+err_out:
+	dev_printk(KERN_ERR, &mvi->pdev->dev, "%s", msg);
+	return rc;
+}
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
+			     PCI_DMA_TODEVICE);
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
+static void mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
+			 unsigned int slot_idx)
+{
+	/* FIXME */
+}
+
+static void mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
+{
+	unsigned int slot_idx = rx_desc & RXQ_SLOT_MASK;
+	struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
+	struct sas_task *task = slot->task;
+	struct task_status_struct *tstat = &task->task_status;
+	bool aborted;
+
+	spin_lock(&task->task_state_lock);
+	aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
+	if (!aborted) {
+		task->task_state_flags &=
+			~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
+		task->task_state_flags |= SAS_TASK_STATE_DONE;
+	}
+	spin_unlock(&task->task_state_lock);
+
+	if (aborted)
+		return;
+
+	memset(tstat, 0, sizeof(*tstat));
+	tstat->resp = SAS_TASK_COMPLETE;
+
+	/* error info record present */
+	if (rx_desc & RXQ_ERR) {
+		tstat->stat = SAM_CHECK_COND;
+		mvs_slot_err(mvi, task, slot_idx);
+		goto out;
+	}
+
+	switch (task->task_proto) {
+	case SAS_PROTO_SSP:
+		/* hw says status == 0, datapres == 0 */
+		if (rx_desc & RXQ_GOOD)
+			tstat->stat = SAM_GOOD;
+
+		/* response frame present */
+		else if (rx_desc & RXQ_RSP) {
+			struct ssp_response_iu *iu =
+				slot->response + sizeof(struct mvs_err_info);
+			ssp_task_response(&mvi->pdev->dev, task, iu);
+		}
+
+		/* should never happen? */
+		else
+			tstat->stat = SAM_CHECK_COND;
+		break;
+
+	case SAS_PROTO_SMP:
+		tstat->stat = SAM_GOOD;
+		break;
+
+	default:
+		tstat->stat = SAM_CHECK_COND;
+		break;
+	}
+
+out:
+	mvs_slot_free(mvi, task, slot, slot_idx);
+	task->task_done(task);
+}
+
+static void mvs_int_full(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp, stat;
+	int i;
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
+		mvs_int_rx(mvi, false);
+
+	mw32(INT_STAT, stat);
+}
+
+static void mvs_int_rx(struct mvs_info *mvi, bool self_clear)
+{
+	u32 rx_prod_idx, rx_desc;
+	bool attn = false;
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
+		if (rx_desc & RXQ_DONE)
+			/* we had a completion, error or no */
+			mvs_slot_complete(mvi, rx_desc);
+
+		if (rx_desc & RXQ_ATTN)
+			attn = true;
+	}
+
+	if (attn && self_clear)
+		mvs_int_full(mvi);
+
+}
+
+static irqreturn_t mvs_interrupt(int irq, void *opaque)
+{
+	struct mvs_info *mvi = opaque;
+	void __iomem *regs = mvi->regs;
+	u32 stat;
+
+	stat = mr32(GBL_INT_STAT);
+	if (stat == 0 || stat == 0xffffffff)
+		return IRQ_NONE;
+
+	spin_lock(&mvi->lock);
+
+	mvs_int_full(mvi);
+
+	spin_unlock(&mvi->lock);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t mvs_msi_interrupt(int irq, void *opaque)
+{
+	struct mvs_info *mvi = opaque;
+
+	spin_lock(&mvi->lock);
+
+	mvs_int_rx(mvi, true);
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
+	elem = pci_map_sg(mvi->pdev, sg_req, 1, PCI_DMA_TODEVICE);
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
+		     PCI_DMA_TODEVICE);
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
+	struct ssp_frame_hdr *ssp_hdr;
+	void *buf_tmp;
+	u8 *buf_cmd, *buf_oaf, fburst = 0;
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
+	if (task->ssp_task.enable_first_burst) {
+		flags |= MCH_FBURST;
+		fburst = (1 << 7);
+	}
+	hdr->flags = cpu_to_le32(flags |
+		(tei->n_elem << MCH_PRD_LEN_SHIFT) |
+		(MCH_SSP_FR_CMD << MCH_SSP_FR_TYPE_SHIFT));
+
+	hdr->tags = cpu_to_le32(tag);
+	hdr->data_len = cpu_to_le32(task->total_xfer_len);
+
+	/*
+	 * arrange MVS_SLOT_BUF_SZ-sized DMA buffer according to our needs
+	 */
+
+	/* region 1: command table area (MVS_SSP_CMD_SZ bytes) ***************/
+	buf_cmd =
+	buf_tmp = slot->buf;
+	buf_tmp_dma = slot->buf_dma;
+
+	hdr->cmd_tbl = cpu_to_le64(buf_tmp_dma);
+
+	buf_tmp += MVS_SSP_CMD_SZ;
+	buf_tmp_dma += MVS_SSP_CMD_SZ;
+
+	/* region 2: open address frame area (MVS_SSP_OAF_SZ bytes) **********/
+	buf_oaf = buf_tmp;
+	hdr->open_frame = cpu_to_le64(buf_tmp_dma);
+
+	buf_tmp += MVS_SSP_OAF_SZ;
+	buf_tmp_dma += MVS_SSP_OAF_SZ;
+
+	/* region 3: PRD table ***********************************************/
+	buf_prd = buf_tmp;
+	hdr->prd_tbl = cpu_to_le64(buf_tmp_dma);
+
+	i = sizeof(struct mvs_prd) * tei->n_elem;
+	buf_tmp += i;
+	buf_tmp_dma += i;
+
+	/* region 4: status buffer (larger the PRD, smaller this buf) ********/
+	slot->response = buf_tmp;
+	hdr->status_buf = cpu_to_le64(buf_tmp_dma);
+
+	req_len = sizeof(struct ssp_frame_hdr) + 28;
+	resp_len = MVS_SLOT_BUF_SZ - MVS_SSP_CMD_SZ - MVS_SSP_OAF_SZ -
+		   sizeof(struct mvs_err_info) - i;
+
+	/* request, response lengths */
+	hdr->lens = cpu_to_le32(((resp_len / 4) << 16) | (req_len / 4));
+
+	/* generate open address frame hdr (first 12 bytes) */
+	buf_oaf[0] = (1 << 7) | (1 << 4) | 0x1;	/* initiator, SSP, ftype 1h */
+	buf_oaf[1] = task->dev->linkrate & 0xf;
+	buf_oaf[2] = tag >> 8;
+	buf_oaf[3] = tag;
+	memcpy(buf_oaf + 4, task->dev->sas_addr, SAS_ADDR_SIZE);
+
+	/* fill in SSP frame header */
+	memset(buf_cmd, 0, MVS_SSP_CMD_SZ);
+	ssp_hdr = (struct ssp_frame_hdr *) buf_cmd;
+	ssp_hdr->frame_type = SSP_COMMAND;
+	memcpy(ssp_hdr->hashed_dest_addr, task->dev->hashed_sas_addr,
+	       HASHED_SAS_ADDR_SIZE);
+	memcpy(ssp_hdr->hashed_src_addr,
+	       task->dev->port->ha->hashed_sas_addr, HASHED_SAS_ADDR_SIZE);
+	ssp_hdr->tag = cpu_to_be16(tag);
+
+	/* fill in command frame IU */
+	buf_cmd += sizeof(*ssp_hdr);
+	memcpy(buf_cmd, &task->ssp_task.LUN, 8);
+	buf_cmd[9] = fburst |
+		task->ssp_task.task_attr |
+		(task->ssp_task.task_prio << 3);
+	memcpy(buf_cmd + 12, &task->ssp_task.cdb, 16);
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
+	struct mvs_task_exec_info tei;
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
+	tei.task = task;
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
+/* FIXME: locking? */
+static int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
+			   void *funcdata)
+{
+	struct mvs_info *mvi = sas_phy->ha->lldd_ha;
+	void __iomem *reg;
+	int rc = 0, phy_id = sas_phy->id;
+	u32 tmp;
+
+	reg = mvi->regs + MVS_P0_SER_CTLSTAT + (phy_id * 4);
+
+	switch (func) {
+	case PHY_FUNC_SET_LINK_RATE: {
+		struct sas_phy_linkrates *rates = funcdata;
+		u32 lrmin = 0, lrmax = 0;
+
+		lrmin = (rates->minimum_linkrate << 8);
+		lrmax = (rates->maximum_linkrate << 12);
+
+		tmp = readl(reg);
+		if (lrmin) {
+			tmp &= ~(0xf << 8);
+			tmp |= lrmin;
+		}
+		if (lrmax) {
+			tmp &= ~(0xf << 12);
+			tmp |= lrmax;
+		}
+		writel(tmp, reg);
+		break;
+	}
+
+	case PHY_FUNC_HARD_RESET:
+		tmp = readl(reg);
+		if (tmp & PHY_RST_HARD)
+			break;
+		writel(tmp | PHY_RST_HARD, reg);
+		break;
+
+	case PHY_FUNC_LINK_RESET:
+		writel(readl(reg) | PHY_RST, reg);
+		break;
+
+	case PHY_FUNC_DISABLE:
+	case PHY_FUNC_RELEASE_SPINUP_HOLD:
+	default:
+		rc = -EOPNOTSUPP;
+	}
+
+	return rc;
+}
+
+static void __devinit mvs_phy_init(struct mvs_info *mvi, int phy_id)
+{
+	struct mvs_phy *phy = &mvi->phy[phy_id];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+
+	sas_phy->enabled = (phy_id < mvi->chip->n_phy) ? 1 : 0;
+	sas_phy->class = SAS;
+	sas_phy->iproto = SAS_PROTO_ALL;
+	sas_phy->tproto = 0;
+	sas_phy->type = PHY_TYPE_PHYSICAL;
+	sas_phy->role = PHY_ROLE_INITIATOR;
+	sas_phy->oob_mode = OOB_NOT_CONNECTED;
+	sas_phy->linkrate = SAS_LINK_RATE_UNKNOWN;
+
+	sas_phy->id = phy_id;
+	sas_phy->sas_addr = &mvi->sas_addr[0];
+	sas_phy->frame_rcvd = &phy->frame_rcvd[0];
+	sas_phy->ha = &mvi->sas;
+	sas_phy->lldd_phy = phy;
+}
+
+static struct mvs_info * __devinit mvs_alloc(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	struct mvs_info *mvi;
+	unsigned long res_start, res_len;
+	struct asd_sas_phy **arr_phy;
+	struct asd_sas_port **arr_port;
+	const struct mvs_chip_info *chip = &mvs_chips[ent->driver_data];
+	int i;
+
+	/*
+	 * alloc and init our per-HBA mvs_info struct
+	 */
+
+	mvi = kzalloc(sizeof(*mvi), GFP_KERNEL);
+	if (!mvi)
+		return NULL;
+
+	spin_lock_init(&mvi->lock);
+	mvi->pdev = pdev;
+	mvi->chip = chip;
+
+	if (pdev->device == 0x6440 && pdev->revision == 0)
+		mvi->flags |= MVF_PHY_PWR_FIX;
+
+	/*
+	 * alloc and init SCSI, SAS glue
+	 */
+
+	mvi->shost = scsi_host_alloc(&mvs_sht, sizeof(void *));
+	if (!mvi->shost)
+		goto err_out;
+
+	arr_phy = kcalloc(MVS_MAX_PHYS, sizeof(void *), GFP_KERNEL);
+	arr_port = kcalloc(MVS_MAX_PHYS, sizeof(void *), GFP_KERNEL);
+	if (!arr_phy || !arr_port)
+		goto err_out;
+
+	for (i = 0; i < MVS_MAX_PHYS; i++) {
+		mvs_phy_init(mvi, i);
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
+	mvi->sas.sas_addr = &mvi->sas_addr[0];
+	mvi->sas.sas_phy = arr_phy;
+	mvi->sas.sas_port = arr_port;
+	mvi->sas.num_phys = chip->n_phy;
+	mvi->sas.lldd_max_execute_num = MVS_TX_RING_SZ - 1;/* FIXME: correct? */
+	mvi->sas.lldd_queue_size = MVS_TX_RING_SZ - 1;	   /* FIXME: correct? */
+	mvi->sas.lldd_ha = mvi;
+	mvi->sas.core.shost = mvi->shost;
+
+	mvs_tag_set(mvi, MVS_TX_RING_SZ - 1);
+
+	/*
+	 * ioremap main and peripheral registers
+	 */
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
+	/*
+	 * alloc and init our DMA areas
+	 */
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
+	/* finally, read NVRAM to get our SAS address */
+	if (mvs_nvram_read(mvi, NVR_SAS_ADDR, &mvi->sas_addr, 8))
+		goto err_out;
+
+	return mvi;
+
+err_out:
+	mvs_free(mvi);
+	return NULL;
+}
+
+static u32 mvs_cr32(void __iomem *regs, u32 addr)
+{
+	mw32(CMD_ADDR, addr);
+	return mr32(CMD_DATA);
+}
+
+static void mvs_cw32(void __iomem *regs, u32 addr, u32 val)
+{
+	mw32(CMD_ADDR, addr);
+	mw32(CMD_DATA, val);
+}
+
+#if 0
+static u32 mvs_phy_read(struct mvs_info *mvi, unsigned int phy_id, u32 addr)
+{
+	void __iomem *regs = mvi->regs;
+	void __iomem *phy_regs = regs + MVS_P0_CFG_ADDR + (phy_id * 8);
+
+	writel(addr, phy_regs);
+	return readl(phy_regs + 4);
+}
+#endif
+
+static void mvs_phy_write(struct mvs_info *mvi, unsigned int phy_id,
+			  u32 addr, u32 val)
+{
+	void __iomem *regs = mvi->regs;
+	void __iomem *phy_regs = regs + MVS_P0_CFG_ADDR + (phy_id * 8);
+
+	writel(addr, phy_regs);
+	writel(val, phy_regs + 4);
+	readl(phy_regs);	/* flush */
+}
+
+static void __devinit mvs_phy_hacks(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+	/* workaround for SATA R-ERR, to ignore phy glitch */
+	tmp = mvs_cr32(regs, CMD_PHY_TIMER);
+	tmp &= ~(1 << 9);
+	tmp |= (1 << 10);
+	mvs_cw32(regs, CMD_PHY_TIMER, tmp);
+
+	/* enable retry 127 times */
+	mvs_cw32(regs, CMD_SAS_CTL1, 0x7f7f);
+
+	/* extend open frame timeout to max */
+	tmp = mvs_cr32(regs, CMD_SAS_CTL0);
+	tmp &= ~0xffff;
+	tmp |= 0x3fff;
+	mvs_cw32(regs, CMD_SAS_CTL0, tmp);
+
+	/* workaround for WDTIMEOUT , set to 550 ms */
+	mvs_cw32(regs, CMD_WD_TIMER, 0xffffff);
+
+	/* not to halt for different port op during wideport link change */
+	mvs_cw32(regs, CMD_APP_ERR_CONFIG, 0xffefbf7d);
+
+	/* workaround for Seagate disk not-found OOB sequence, recv
+	 * COMINIT before sending out COMWAKE */
+	tmp = mvs_cr32(regs, CMD_PHY_MODE_21);
+	tmp &= 0x0000ffff;
+	tmp |= 0x00fa0000;
+	mvs_cw32(regs, CMD_PHY_MODE_21, tmp);
+
+	tmp = mvs_cr32(regs, CMD_PHY_TIMER);
+	tmp &= 0x1fffffff;
+	tmp |= (2U << 29);	/* 8 ms retry */
+	mvs_cw32(regs, CMD_PHY_TIMER, tmp);
+}
+
+static int __devinit mvs_hw_init(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+	int i;
+	u32 tmp, cctl;
+
+	/* make sure interrupts are masked immediately (paranoia) */
+	mw32(GBL_CTL, 0);
+	tmp = mr32(GBL_CTL);
+
+	if (!(tmp & HBA_RST)) {
+		if (mvi->flags & MVF_PHY_PWR_FIX) {
+			pci_read_config_dword(mvi->pdev, PCR_PHY_CTL, &tmp);
+			tmp &= ~PCTL_PWR_ON;
+			tmp |= PCTL_OFF;
+			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL, tmp);
+
+			pci_read_config_dword(mvi->pdev, PCR_PHY_CTL2, &tmp);
+			tmp &= ~PCTL_PWR_ON;
+			tmp |= PCTL_OFF;
+			pci_write_config_dword(mvi->pdev, PCR_PHY_CTL2, tmp);
+		}
+
+		/* global reset, incl. COMRESET/H_RESET_N (self-clearing) */
+		mw32_f(GBL_CTL, HBA_RST);
+	}
+
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
+	/* make sure RST is set; HBA_RST /should/ have done that for us */
+	cctl = mr32(CTL);
+	if (cctl & CCTL_RST)
+		cctl &= ~CCTL_RST;
+	else
+		mw32_f(CTL, cctl | CCTL_RST);
+
+	pci_read_config_dword(mvi->pdev, PCR_PHY_CTL, &tmp);
+	tmp |= PCTL_PWR_ON;
+	tmp &= ~PCTL_OFF;
+	pci_write_config_dword(mvi->pdev, PCR_PHY_CTL, tmp);
+
+	pci_read_config_dword(mvi->pdev, PCR_PHY_CTL2, &tmp);
+	tmp |= PCTL_PWR_ON;
+	tmp &= ~PCTL_OFF;
+	pci_write_config_dword(mvi->pdev, PCR_PHY_CTL2, tmp);
+
+	mw32_f(CTL, cctl);
+
+	mvs_phy_hacks(mvi);
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
+	/* init and reset phys */
+	for (i = 0; i < mvi->chip->n_phy; i++) {
+		/* FIXME: is this the correct dword order? */
+		u32 lo = *((u32 *) &mvi->sas_addr[0]);
+		u32 hi = *((u32 *) &mvi->sas_addr[4]);
+
+		/* set phy local SAS address */
+		mvs_phy_write(mvi, i, PHYR_ADDR_LO, lo);
+		mvs_phy_write(mvi, i, PHYR_ADDR_HI, hi);
+
+		/* reset phy */
+		tmp = readl(regs + MVS_P0_SER_CTLSTAT + (i * 4));
+		tmp |= PHY_RST;
+		writel(tmp, regs + MVS_P0_SER_CTLSTAT + (i * 4));
+	}
+
+	msleep(100);
+
+	for (i = 0; i < mvi->chip->n_phy; i++) {
+		/* set phy int mask */
+		writel(PHYEV_BROAD_CH | PHYEV_RDY_CH,
+		       regs + MVS_P0_INT_MASK + (i * 8));
+
+		/* clear phy int status */
+		tmp = readl(regs + MVS_P0_INT_STAT + (i * 8));
+		writel(tmp, regs + MVS_P0_INT_STAT + (i * 8));
+	}
+
+	/* FIXME: update wide port bitmaps */
+
+	/* ladies and gentlemen, start your engines */
+	mw32(TX_CFG, MVS_TX_RING_SZ | TX_EN);
+	mw32(RX_CFG, MVS_RX_RING_SZ | RX_EN);
+	mw32(PCS, PCS_SATA_RETRY | PCS_FIS_RX_EN | PCS_CMD_EN |
+	     ((mvi->flags & MVF_MSI) ? PCS_SELF_CLEAR : 0));
+
+	/* re-enable interrupts globally */
+	mw32(GBL_CTL, INT_EN);
+
+	return 0;
+}
+
+static void __devinit mvs_print_info(struct mvs_info *mvi)
+{
+	struct pci_dev *pdev = mvi->pdev;
+	static int printed_version;
+
+	if (!printed_version++)
+		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+
+	dev_printk(KERN_INFO, &pdev->dev, "%u phys, addr %llx\n",
+		   mvi->chip->n_phy, SAS_ADDR(mvi->sas_addr));
+}
+
+static int __devinit mvs_pci_init(struct pci_dev *pdev,
+				 const struct pci_device_id *ent)
+{
+	int rc;
+	struct mvs_info *mvi;
+	irq_handler_t irq_handler = mvs_interrupt;
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
+	if (!pci_enable_msi(pdev)) {
+		mvi->flags |= MVF_MSI;
+		irq_handler = mvs_msi_interrupt;
+	}
+
+	rc = request_irq(pdev->irq, irq_handler, IRQF_SHARED, DRV_NAME, mvi);
+	if (rc)
+		goto err_out_msi;
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
+
+	mvs_print_info(mvi);
+
+	scsi_scan_host(mvi->shost);
+	return 0;
+
+err_out_shost:
+	scsi_remove_host(mvi->shost);
+err_out_irq:
+	free_irq(pdev->irq, mvi);
+err_out_msi:
+	if (mvi->flags |= MVF_MSI)
+		pci_disable_msi(pdev);
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
+	if (mvi->flags & MVF_MSI)
+		pci_disable_msi(pdev);
+	mvs_free(mvi);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static struct sas_domain_function_template mvs_transport_ops = {
+	.lldd_execute_task	= mvs_task_exec,
+	.lldd_control_phy	= mvs_phy_control,
+};
+
+static struct pci_device_id __devinitdata mvs_pci_table[] = {
+	{ PCI_VDEVICE(MARVELL, 0x6320), chip_6320 },
+	{ PCI_VDEVICE(MARVELL, 0x6340), chip_6440 },
+	{ PCI_VDEVICE(MARVELL, 0x6440), chip_6440 },
+	{ PCI_VDEVICE(MARVELL, 0x6480), chip_6480 },
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
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 2dc21cb..f648626 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -15,6 +15,7 @@ enum dma_data_direction {
 
 #define DMA_64BIT_MASK	0xffffffffffffffffULL
 #define DMA_48BIT_MASK	0x0000ffffffffffffULL
+#define DMA_47BIT_MASK	0x00007fffffffffffULL
 #define DMA_40BIT_MASK	0x000000ffffffffffULL
 #define DMA_39BIT_MASK	0x0000007fffffffffULL
 #define DMA_32BIT_MASK	0x00000000ffffffffULL
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 8dda2d6..38b4ca6 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -676,4 +676,8 @@ extern int sas_ioctl(struct scsi_device *sdev, int cmd, void __user *arg);
 
 extern int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 			   struct request *req);
+
+extern void ssp_task_response(struct device *dev, struct sas_task *task,
+		       struct ssp_response_iu *iu);
+
 #endif /* _SASLIB_H_ */
