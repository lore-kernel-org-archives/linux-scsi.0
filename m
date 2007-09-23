From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] Broadcom 8603 SAS/SATA driver, rough draft
Date: Sun, 23 Sep 2007 00:04:37 -0400
Message-ID: <20070923040437.GA30170@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754383AbXIWEEx@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Rather than sitting on this for far too long, I wanted to go ahead and
get this out there.  I heard some chips might be trickling out into
public hands.

This is a bare bones Broadcom 8603 SAS+SATA driver, attempting to use
the vaunted libsas.  Notes:

* A quick glance at the FIXMEs will tell you obviously doesn't work.

* The hardware is quite simple and straightforward and easy to program
  in an efficient way:  each SAS port has a command queue (DMA ring) and
  a response queue (DMA ring).  Or if in SATA mode, just a command
  queue.

* The SAS/SATA negotiation is largely out of our hands.  The silicon
  does its thing, and then tells us what type of device connected.  We
  are then expected to switch the port to either SAS mode or SATA mode,
  accordingly.

* There is no firmware or anything.  Just DMA and register bitbanging.
  We have plenty of low-level control.

* The state of SAS/SATA integration is perpetually pathetic.  Updates
  in this area are likely.  There's a rumor Brian King @ IBM may look
  into this area too.

* This driver pretty much completely lacks exception handling.


As an aside, I am also writing a driver for Marvell chips that behave
quite similarly to this chip.  It seems the future of storage might look
like these Broadcom and Marvell SAS+SATA DMA ring interfaces, in the
volume marketspace at least.



The 'broadsas' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git broadsas

contains the following updates:

 drivers/scsi/Kconfig    |   10 +
 drivers/scsi/Makefile   |    1 +
 drivers/scsi/broadsas.c |  997 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1008 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/broadsas.c

Jeff Garzik (1):
      Add rough draft Broadcom 8603 SAS/SATA driver.

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 6f2c71e..44fa3a9 100644
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
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 86a7ba7..8f052c9 100644
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
diff --git a/drivers/scsi/broadsas.c b/drivers/scsi/broadsas.c
new file mode 100644
index 0000000..a4276ec
--- /dev/null
+++ b/drivers/scsi/broadsas.c
@@ -0,0 +1,997 @@
+/*
+ *  broadsas.c - Broadcom 8603 SAS/SATA support
+ *
+ *  Copyright 2007 Red Hat, Inc.
+ *
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
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
+struct bs_port;
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
+	BS_CMDQ_SZ		= 128,	/* OK: 2, 4, 8, 16, 32, 64, 128, 256 */
+	BS_RSPQ_SZ		= 128,	/* OK: 2, 4, 8, 16, 32, 64, 128, 256 */
+	BS_MAX_PRD		= 256,	/* S/G per slot; my arbitrary guess */
+	BS_RSP_BUF_SZ		= 512,  /* Response buffer size; OK: 0-64k */
+};
+
+/* unchangeable hardware details */
+enum hardware_details {
+	BS_PORTS		= 8,	/* number of ports */
+	BS_CMD_SZ		= 32,	/* command descriptor size */
+	BS_RSP_SZ		= 16,	/* response descriptor size */
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
+/* per-port registers common to SAS and SATA (though some bits differ) */
+enum common_port_registers {
+	BS_QDMA_ADDR_LO		= 0xA0,		/* cmdq addr lo, hi */
+	BS_QDMA_ADDR_HI		= 0xA4,
+	BS_QDMA_PROD_IDX	= 0xA8,		/* cmdq producer index */
+	BS_QDMA_CONS_IDX	= 0xAC,		/* cmdq consumer index (RO) */
+
+	BS_QDMA_CTL		= 0xB0,		/* QDMA control */
+	BS_QDMA_Q_DEPTH		= 0xB4,		/* QDMA ring sizing */
+	BS_QDMA_STAT		= 0xB8,		/* QDMA status */
+	BS_QDMA_INT_MASK	= 0xBC,		/* QDMA interrupt mask */
+};
+
+/* SAS per-port registers (replaces SATA register space, in SAS mode) */
+enum sas_port_registers {
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
+	BS_SAS_RSP_ADDR_LO	= 0xC0,		/* rspq addr lo, hi */
+	BS_SAS_RSP_ADDR_HI	= 0xC4,
+	BS_SAS_RSP_PROD_IDX	= 0xC8,		/* rspq producer index (RO) */
+	BS_SAS_RSP_CONS_IDX	= 0xCC,		/* rspq consumer index */
+
+	BS_SAS_RSP_IU_MAX_SZ	= 0xD0,		/* response IU max size */
+
+	BS_SAS_IDX_ADDR		= 0xE0,		/* index address */
+	BS_SAS_IDX_DATA		= 0xE4,		/* index data */
+
+	BS_SAS_DBG_TXDMA	= 0xE8,		/* TXDMA debug */
+	BS_SAS_DBG_RXDMA	= 0xEC,		/* RXDMA debug */
+	BS_SAS_DBG_IUDMA	= 0xF0,		/* IUDMA debug */
+	BS_SAS_DBG_TXFRAME	= 0xF4,		/* TXFRAME debug */
+	BS_SAS_DBG_RXFRAME	= 0xF8,		/* RXFRAME debug */
+};
+
+/* BS_SAS_ERR_STAT bits */
+enum sas_err_stat_bits {
+	BS_SAS_ERR_XPRIM_OVER	= (1U << 4),	/* SSP xmit primitive overflw */
+	BS_SAS_ERR_NAK		= (1U << 3),	/* NAK detected */
+	BS_SAS_ERR_ACKNAK_TIMO	= (1U << 2),	/* ACK/NAK timeout */
+	BS_SAS_ERR_PHYRDY	= (1U << 1),	/* PhyRdy changed */
+	BS_SAS_ERR_SATA		= (1U << 0),	/* SATA device detected */
+};
+
+/* BS_SAS_DBG_IUDMA bits */
+enum sas_dbg_iudma_bits {
+	BS_SAS_SAS_REGS		= 0,		/* Select SAS registers */
+	BS_SAS_SATA_REGS	= (1U << 16),	/* Select SATA registers */
+	BS_SAS_SATA_FORCE	= (1U << 8),	/* Force SATA mode */
+	BS_SAS_SATA_ACTIVE	= (1U << 0),	/* SATA activated (read-only) */
+};
+
+enum qdma_queue_depth_bits {
+	QDEPTH_CMD_SZ_SHIFT	= 0,		/* cmdq ring size */
+	QDEPTH_RSP_SZ_SHIFT	= 8,		/* rspq ring size */
+	QDEPTH_CMD_ISSUE_WINDOW_SHIFT = 16,	/* max cmds dev can queue */
+};
+
+enum qdma_int_mask_bits {
+	QINT_ALL_SATA		= 0x3f,
+	QINT_ALL_SAS		= 0x1ffff,
+};
+
+/* SAS version of BS_QDMA_CTL */
+enum sas_qdma_control_bits {
+	QCTL_XFER_RDY_SKIP_CHK	= (1U << 23),	/* skip XR cmd desc err chk */
+	QCTL_CMD_DESC_DATA_END	= (1U << 22),	/* mark data-end in cmd desc */
+	QCTL_RXDMA_RST		= (1U << 19),	/* RXDMA soft reset */
+	QCTL_RXDMA_ERR_REP	= (1U << 18),	/* RXDMA report error */
+	QCTL_RXDMA_NO_HANG	= (1U << 17),	/* 1==continue rx on error */
+	QCTL_RXDMA_EN		= (1U << 16),	/* RXDMA enable */
+	QCTL_TXDMA_RST		= (1U << 8),	/* TXDMA soft reset */
+	QCTL_PORT_RST		= (1U << 3),	/* port reset (in SAS?) */
+	QCTL_PAUSE		= (1U << 1),	/* QDMA pause */
+	QCTL_EN			= (1U << 0),	/* QDMA enable */
+};
+
+/* SAS version of BS_QDMA_STAT */
+enum sas_qdma_status_bits {
+	QSTAT_RSP_INACT		= (1U << 31), /* inactive RSP frame tag */
+	QSTAT_XR_INACT		= (1U << 30), /* XFER_RDY: inact. frame tag */
+	QSTAT_XR_SIZE		= (1U << 29), /* XFER_RDY: wrong size */
+	QSTAT_XR_NON_DATA	= (1U << 28), /* XFER_RDY: non-data cmd */
+	QSTAT_XR_TAG_MISMATCH	= (1U << 27), /* XFER_RDY: tag mismatch */
+	QSTAT_DATA_INACT	= (1U << 26), /* inactive DATA frame */
+	QSTAT_DATA_CMD_DESC	= (1U << 25), /* DATA: bad cmd desc type */
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
+	QSTAT_CMD_KILLED	= (1U << 4),  /* internal/software cmd abort */
+	QSTAT_RXDMA_OK		= (1U << 3),  /* RXDMA non-error int */
+	QSTAT_DMA_ABORTED	= (1U << 2),  /* QDMA abort acknowledge */
+	QSTAT_DMA_PAUSED	= (1U << 1),  /* QDMA pause acknowledge */
+	QSTAT_DONE		= (1U << 0),  /* cmd/prd done, CLOSE, etc. */
+};
+
+enum bs_cmd_flag_bits {
+	SAS_CTL_NO_DATA		= (1U << 8), /* Command with no data */
+	SAS_CTL_SATA		= 0,	     /* Connection type: SATA */
+	SAS_CTL_SSP		= (1U << 5), /* Connection type: SSP */
+	SAS_CTL_STP		= (1U << 6), /* Connection type: STP */
+	SAS_CTL_SMP		= (3U << 5), /* Connection type: SMP */
+	SAS_CTL_SKIP		= (1U << 4), /* Skip this entry */
+	SAS_CTL_FIRST_BURST	= (1U << 2), /* Frst brst active 4 cur wr cmd */
+	SAS_CTL_DIR_READ	= (1U << 1),/* Data direction (1==dev to mem) */
+	SAS_CTL_EIN		= (1U << 0), /* INT upon response frame */
+};
+
+struct bs_cmd {
+	__le32			word[8];
+};
+
+struct bs_sas_cmd {
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
+enum bs_rsp_flag_bits {
+	RSPD_DA			= (1U << 7),	/* data available */
+
+	RSP_TYPE_MASK		= 0x7,
+};
+
+struct bs_rsp_desc {
+	__le32			tag_flags;
+	__le32			reserved;
+	__le64			buf_addr;
+};
+
+struct bs_slot {
+	struct bs_prd		*prd;
+	dma_addr_t		prd_dma;
+};
+
+struct bs_rsp_slot {
+	void			*rbuf;
+	dma_addr_t		rbuf_dma;
+};
+
+struct bs_tag_info {
+	struct bs_port		*port;
+	struct sas_task		*task;
+};
+
+struct bs_port {
+	struct bs_info		*bsi;
+	int			port_no;
+
+	void __iomem		*regs;		/* this port's registers */
+
+	struct bs_cmd		*cmd;		/* command queue */
+	dma_addr_t		cmd_dma;
+	u32			cmd_prod;	/* cached producer idx */
+
+	struct bs_rsp_desc	*rsp;		/* response queue (SAS only) */
+	dma_addr_t		rsp_dma;
+
+	unsigned long		tags[(BS_CMDQ_SZ / sizeof(unsigned long)) + 1];
+	struct bs_tag_info	tag_info[BS_CMDQ_SZ];
+
+	struct bs_slot		slot[BS_CMDQ_SZ]; /* per-cmdq-slot info */
+	struct bs_rsp_slot	rsp_slot[BS_RSPQ_SZ]; /* per-rspq-slot info */
+};
+
+struct bs_info {
+	spinlock_t		lock;
+	struct pci_dev		*pdev;
+	void __iomem		*regs;
+	struct sas_ha_struct	sas;
+	struct Scsi_Host	*shost;
+	struct bs_port		port[BS_PORTS];
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
+static void __iomem *bs_port_regs(struct bs_info *bsi, int port_no)
+{
+	return bsi->regs + (0x100 * port_no);
+}
+
+static bool bs_sata_active(void __iomem *regs)
+{
+	return br32(SAS_DBG_IUDMA) & BS_SAS_SATA_ACTIVE;
+}
+
+static void bs_tag_clear(struct bs_port *port, unsigned int tag)
+{
+	port->tags[tag / sizeof(unsigned long)] &=
+		~(1UL << (tag % sizeof(unsigned long)));
+}
+
+static void bs_tag_set(struct bs_port *port, unsigned int tag)
+{
+	port->tags[tag / sizeof(unsigned long)] |=
+		(1UL << (tag % sizeof(unsigned long)));
+}
+
+static bool bs_tag_test(struct bs_port *port, unsigned int tag)
+{
+	return port->tags[tag / sizeof(unsigned long)] &
+		(1UL << (tag % sizeof(unsigned long)));
+}
+
+static int bs_tag_alloc(struct bs_port *port, unsigned int *tag_out)
+{
+	unsigned int i;
+
+	for (i = 0; i < BS_CMDQ_SZ; i++)
+		if (!bs_tag_test(port, i)) {
+			bs_tag_set(port, i);
+			*tag_out = i;
+			return 0;
+		}
+
+	return -EBUSY;
+}
+
+static void bs_port_int_sata(struct bs_port *port)
+{
+	void __iomem *regs = port->regs;
+	u32 dma_stat;
+
+	/* FIXME / TODO */
+
+	dev_printk(KERN_ERR, &port->bsi->pdev->dev, "unexpected SATA int\n");
+
+	dma_stat = br32(QDMA_STAT);
+	if (dma_stat)
+		bw32(QDMA_STAT, dma_stat);
+}
+
+static void bs_port_rsp_chk(struct bs_port *port)
+{
+	void __iomem *regs = port->regs;
+	u32 prod_idx, cons_idx, tag, rdtype, flags, status = 0;
+	struct bs_rsp_desc *rsp;
+	bool worked = false;
+
+	prod_idx = br32(SAS_RSP_PROD_IDX);
+	cons_idx = br32(SAS_RSP_CONS_IDX);
+
+	while (prod_idx != cons_idx) {
+		rsp = &port->rsp[cons_idx];
+
+		flags = le32_to_cpu(rsp->tag_flags);
+		tag = flags >> 16;
+		if (!(flags & RSPD_DA))
+			status = (flags >> 8) & 0xff;
+		flags &= 0xff;
+
+		rdtype = flags & RSP_TYPE_MASK;
+
+		/* rdtype 0 == normal RSP frame */
+		if (!rdtype && bs_tag_test(port, tag)) {
+			struct bs_tag_info *bti = &port->tag_info[tag];
+
+			bti->task->task_done(bti->task);
+			bs_tag_clear(port, tag);
+		}
+
+		worked = true;
+		cons_idx = (cons_idx + 1) & (BS_RSPQ_SZ - 1);
+	}
+
+	if (worked)
+		bw32(SAS_RSP_CONS_IDX, cons_idx);
+}
+
+static void bs_port_int_sas(struct bs_port *port)
+{
+	void __iomem *regs = port->regs;
+	u32 sas_err, dma_stat;
+
+	sas_err = br32(SAS_ERR_STAT);
+	if (sas_err)
+		bw32(SAS_ERR_STAT, sas_err);
+
+	dma_stat = br32(QDMA_STAT);
+	if (dma_stat) {
+		bw32(QDMA_STAT, dma_stat);
+
+		if (dma_stat & QSTAT_DONE)
+			bs_port_rsp_chk(port);
+	}
+}
+
+static void bs_port_int(struct bs_port *port)
+{
+	if (bs_sata_active(port->regs))
+		bs_port_int_sata(port);
+	else
+		bs_port_int_sas(port);
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
+	for (i = 0; i < BS_PORTS; i++)
+		if (stat & (1U << i))
+			bs_port_int(&bsi->port[i]);
+
+	spin_unlock(&bsi->lock);
+
+	return IRQ_HANDLED;
+}
+
+static int bs_task_exec_sata(struct bs_port *port,
+			     struct sas_task *task, unsigned int tag,
+			     const int num, gfp_t gfp_flags)
+{
+	return -EINVAL;
+}
+
+static int bs_task_exec_sas(struct bs_port *port,
+			    struct sas_task *task, unsigned int tag,
+			    const int num, gfp_t gfp_flags)
+{
+	u32 slot_idx = port->cmd_prod;
+	struct bs_sas_cmd *cmd = (struct bs_sas_cmd *) &port->cmd[slot_idx];
+	struct bs_slot *slot = &port->slot[slot_idx];
+	void __iomem *regs = port->regs;
+	u32 ctl_flags = SAS_CTL_EIN;
+	const u32 cdb_len = 16;
+	struct scatterlist *sg;
+	unsigned int i, n_elem = 0;
+
+	if (task->num_scatter) {
+		n_elem = pci_map_sg(port->bsi->pdev, task->scatter,
+				    task->num_scatter, task->data_dir);
+		if (!n_elem)
+			return -ENOMEM;
+	}
+
+	if (task->data_dir == DMA_NONE)
+		ctl_flags |= SAS_CTL_NO_DATA;
+	if (task->data_dir == DMA_FROM_DEVICE)
+		ctl_flags |= SAS_CTL_DIR_READ;
+
+	switch (task->task_proto) {
+
+	case SAS_PROTO_STP:
+		ctl_flags |= SAS_CTL_STP;
+		return -EINVAL;		/* not supported? */
+	case SAS_PROTO_SMP:
+		ctl_flags |= SAS_CTL_SMP;
+		return -EINVAL;		/* not supported? */
+	case SAS_PROTO_SSP:
+		ctl_flags |= SAS_CTL_SSP;
+		break;
+
+	case SATA_PROTO:		/* SAS_CTL_SATA */
+	default:
+		BUG();
+		break;
+	}
+
+	cmd->flag_type = cpu_to_le32(
+		0x10 | /* FIXME: what is this descriptor type?
+			  values range from 0x10 - 0x17 */
+		(ctl_flags << 8));
+	cmd->tag_len = cpu_to_le32((tag << 16) | cdb_len);
+
+	/* FIXME: fill in frame/IU address (CDB) */
+
+	if (n_elem > 1)
+		cmd->next_sg = cpu_to_le64(slot->prd_dma);
+	else
+		cmd->next_sg = 0;
+
+	sg = task->scatter;
+	for (i = 0; i < n_elem; i++) {
+		if (i == 0) {
+			cmd->data_lo = cpu_to_le32(sg_dma_address(sg));
+			cmd->data_hi = cpu_to_le32(
+				((((u64)sg_dma_address(sg)) >> 32) & 0xffff) |
+				(sg_dma_len(sg) << 16));
+		} else {
+			struct bs_prd *prd;
+
+			prd = &slot->prd[i - 1];
+
+			prd->addr_lo = cpu_to_le32(sg_dma_address(sg));
+			prd->addr_hi_flags = cpu_to_le32(
+			      ((((u64)sg_dma_address(sg)) >> 16) & 0x7fff0000) |
+			      sg_dma_len(sg));
+		}
+
+		sg++;
+	}
+
+	port->cmd_prod =
+	slot_idx = (slot_idx + 1) & (BS_CMDQ_SZ - 1);
+	bw32(QDMA_PROD_IDX, slot_idx);
+
+	return 0;
+}
+
+static int bs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
+{
+	struct bs_info *bsi = task->dev->port->ha->lldd_ha;
+	struct bs_port *port = &bsi->port[0];		/* FIXME FIXME FIXME */
+	int rc;
+	unsigned int tag = 0xdeadbeef;
+	unsigned long flags;
+	bool sata;
+
+	sata = bs_sata_active(port->regs);
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
+	rc = bs_tag_alloc(port, &tag);
+	if (rc)
+		goto out;
+
+	if (sata)
+		rc = bs_task_exec_sata(port, task, tag, num, gfp_flags);
+	else
+		rc = bs_task_exec_sas(port, task, tag, num, gfp_flags);
+
+	if (rc)
+		goto err_out;
+
+	port->tag_info[tag].port = port;
+	port->tag_info[tag].task = task;
+
+out:
+	spin_unlock_irqrestore(&bsi->lock, flags);
+	return rc;
+
+err_out:
+	bs_tag_clear(port, tag);
+	goto out;
+}
+
+static void bs_free_port(struct bs_port *port)
+{
+	struct bs_info *bsi = port->bsi;
+	int i;
+
+	if (port->cmd)
+		dma_free_coherent(&bsi->pdev->dev, BS_CMD_SZ * BS_CMDQ_SZ,
+				  port->cmd, port->cmd_dma);
+	if (port->rsp)
+		dma_free_coherent(&bsi->pdev->dev, BS_RSP_SZ * BS_RSPQ_SZ,
+				  port->rsp, port->rsp_dma);
+
+	for (i = 0; i < BS_CMDQ_SZ; i++) {
+		struct bs_slot *slot = &port->slot[i];
+
+		if (slot->prd) {
+			dma_free_coherent(&bsi->pdev->dev,
+					BS_MAX_PRD * sizeof(struct bs_prd),
+					slot->prd, slot->prd_dma);
+		}
+	}
+
+	for (i = 0; i < BS_RSPQ_SZ; i++) {
+		struct bs_rsp_slot *slot = &port->rsp_slot[i];
+
+		if (slot->rbuf) {
+			dma_free_coherent(&bsi->pdev->dev, BS_RSP_BUF_SZ,
+					slot->rbuf, slot->rbuf_dma);
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
+	for (i = 0; i < BS_PORTS; i++)
+		bs_free_port(&bsi->port[i]);
+
+	if (bsi->regs)
+		iounmap(bsi->regs);
+	if (bsi->shost)
+		scsi_host_put(bsi->shost);
+	kfree(bsi);
+}
+
+static int __devinit bs_alloc_port(struct bs_info *bsi, int port_no)
+{
+	struct bs_port *port = &bsi->port[port_no];
+	int i;
+
+	port->bsi = bsi;
+	port->port_no = port_no;
+	port->regs = bs_port_regs(bsi, port_no);
+	bs_tag_set(port, BS_CMDQ_SZ - 1);
+
+	port->cmd = dma_alloc_coherent(&bsi->pdev->dev, BS_CMD_SZ * BS_CMDQ_SZ,
+				       &port->cmd_dma, GFP_KERNEL);
+	if (!port->cmd)
+		return -ENOMEM;
+
+	port->rsp = dma_alloc_coherent(&bsi->pdev->dev, BS_RSP_SZ * BS_RSPQ_SZ,
+				       &port->rsp_dma, GFP_KERNEL);
+	if (!port->rsp)
+		return -ENOMEM;
+
+	for (i = 0; i < BS_CMDQ_SZ; i++) {
+		struct bs_slot *slot = &port->slot[i];
+
+		slot->prd = dma_alloc_coherent(&bsi->pdev->dev,
+					BS_MAX_PRD * sizeof(struct bs_prd),
+					&slot->prd_dma, GFP_KERNEL);
+		if (!slot->prd)
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < BS_RSPQ_SZ; i++) {
+		struct bs_rsp_slot *slot = &port->rsp_slot[i];
+
+		slot->rbuf = dma_alloc_coherent(&bsi->pdev->dev, BS_RSP_BUF_SZ,
+					&slot->rbuf_dma, GFP_KERNEL);
+		if (!slot->rbuf)
+			return -ENOMEM;
+
+		port->rsp[i].tag_flags = cpu_to_le32(RSPD_DA);
+		port->rsp[i].buf_addr = cpu_to_le64(slot->rbuf_dma);
+	}
+
+	return 0;
+}
+
+static struct bs_info * __devinit bs_alloc(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	struct bs_info *bsi;
+	unsigned long res_start, res_len;
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
+	SHOST_TO_SAS_HA(bsi->shost) = &bsi->sas;
+	bsi->shost->transportt = bs_stt;
+	bsi->shost->max_id = ~0;
+	bsi->shost->max_lun = ~0;
+	bsi->shost->max_cmd_len = ~0;
+
+	bsi->sas.sas_ha_name = DRV_NAME;
+	bsi->sas.dev = &pdev->dev;
+	bsi->sas.lldd_module = THIS_MODULE;
+	/* FIXME: fill in bsi->sas.sas_addr */
+	/* FIXME: fill in bsi->sas.sas_phy */
+	/* FIXME: fill in bsi->sas.sas_port */
+	bsi->sas.num_phys = BS_PORTS;
+	bsi->sas.lldd_max_execute_num = BS_CMDQ_SZ;	/* FIXME: correct? */
+	bsi->sas.lldd_queue_size = BS_CMDQ_SZ;		/* FIXME: correct? */
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
+	for (i = 0; i < BS_PORTS; i++)
+		if (bs_alloc_port(bsi, i))
+			goto err_out;
+
+	return bsi;
+
+err_out:
+	bs_free(bsi);
+	return NULL;
+}
+
+static void __devinit bs_port_clear(struct bs_port *port, bool sata)
+{
+	void __iomem *regs = port->regs;
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
+static void __devinit bs_port_init(struct bs_port *port)
+{
+	void __iomem *regs = port->regs;
+	u32 tmp;
+	bool sata;
+
+	/*
+	 * first, make sure things are quiet
+	 */
+
+	bw32_f(QDMA_CTL, 0);
+	sata = bs_sata_active(regs);
+	bs_port_clear(port, sata);
+
+	/*
+	 * next, reset the port
+	 */
+
+	tmp = QCTL_PORT_RST;		/* FIXME: needed, on SAS ports? */
+	if (!sata)
+		tmp |= QCTL_RXDMA_RST | QCTL_TXDMA_RST;
+	bw32_f(QDMA_CTL, tmp);
+
+	/* FIXME: are the bits self-clearing? who knows... */
+	udelay(250);
+
+	bw32_f(QDMA_CTL, 0);
+
+	/* paranoia: did/would this change? */
+	sata = bs_sata_active(regs);
+
+	/*
+	 * configure SAS/SATA command queue
+	 */
+
+	bw32(QDMA_ADDR_LO, port->cmd_dma);
+	bw32(QDMA_ADDR_HI, (port->cmd_dma >> 16) >> 16);
+	port->cmd_prod = br32(QDMA_CONS_IDX);
+	bw32(QDMA_PROD_IDX, port->cmd_prod);		/* == empty */
+
+	tmp = BS_CMDQ_SZ - 1;
+	if (!sata) {
+		tmp |= (BS_RSPQ_SZ << QDEPTH_RSP_SZ_SHIFT);
+		tmp |= (BS_CMDQ_SZ << QDEPTH_CMD_ISSUE_WINDOW_SHIFT);
+	}
+	bw32(QDMA_Q_DEPTH, tmp);
+
+	/* all interrupt sources are palatable; turn them all on */
+	if (sata)
+		bw32(QDMA_INT_MASK, QINT_ALL_SATA);
+	else
+		bw32(QDMA_INT_MASK, QINT_ALL_SAS);
+
+	/*
+	 * configure SAS response queue
+	 */
+	if (!sata) {
+		bw32(SAS_RSP_ADDR_LO, port->rsp_dma);
+		bw32(SAS_RSP_ADDR_HI, (port->rsp_dma >> 16) >> 16);
+		bw32(SAS_RSP_CONS_IDX, br32(SAS_RSP_PROD_IDX));	/* == empty */
+		bw32(SAS_RSP_IU_MAX_SZ, BS_RSP_BUF_SZ);
+	}
+}
+
+static void __devinit bs_port_enable(struct bs_port *port)
+{
+	void __iomem *regs = port->regs;
+	bool sata = bs_sata_active(regs);
+	u32 tmp;
+
+	tmp = QCTL_EN;
+	if (!sata)
+		tmp |= QCTL_RXDMA_EN;
+	bw32_f(QDMA_CTL, tmp);
+
+	bs_port_clear(port, sata);
+}
+
+static void __devinit bs_hw_init(struct bs_info *bsi)
+{
+	int i;
+
+	/* first, make sure interrupts are masked */
+	writel(0, bsi->regs + GBL_INT_MASK);
+
+	/* reset and init ports */
+	for (i = 0; i < BS_PORTS; i++)
+		bs_port_init(&bsi->port[i]);
+
+	/* enable port DMA engines */
+	for (i = 0; i < BS_PORTS; i++)
+		bs_port_enable(&bsi->port[i]);
+
+	/* enable ints for ports 0-7 */
+	writel(0xff, bsi->regs + GBL_INT_MASK);
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
+	rc = request_irq(pdev->irq, bs_interrupt, IRQF_SHARED, DRV_NAME, bsi);
+	if (rc)
+		goto err_out_bsi;
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
+	return 0;
+
+err_out_shost:
+	scsi_remove_host(bsi->shost);
+err_out_irq:
+	free_irq(pdev->irq, bsi);
+err_out_bsi:
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
+	bs_free(bsi);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static struct sas_domain_function_template bs_transport_ops = {
+	.lldd_execute_task	= bs_task_exec,
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
