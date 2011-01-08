From: Jeff Garzik <jeff@garzik.org>
Subject: [git patches] libata updates for 2.6.38
Date: Sat, 8 Jan 2011 15:25:06 -0500
Message-ID: <20110108202506.GA7073@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Zero big ticket items for this merge window.

* An existing AHCI variant finally has its own driver, bringing the
  libahci user count to 3: ahci, ahci_platform and acard-ahci.

  I need to dust off Marvell AHCI driver (mv-ahci) and push that
  upstream for 2.6.39, to finally end the annoyances with pata_marvell.

* simplifications thanks to new SCSI ->queuecommand

* minor cleanups and bugfixes

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig                 |   28 ++-
 drivers/ata/Makefile                |    1 +
 drivers/ata/acard-ahci.c            |  528 +++++++++++++++++++++++++++++++++++
 drivers/ata/ahci.h                  |    3 +
 drivers/ata/libahci.c               |   11 +-
 drivers/ata/libata-scsi.c           |   60 ++---
 drivers/ata/pata_hpt366.c           |   51 ++--
 drivers/ata/pata_hpt37x.c           |  236 ++++++++++------
 drivers/ata/pata_hpt3x2n.c          |  150 +++++++----
 drivers/scsi/ipr.c                  |    2 +-
 drivers/scsi/libsas/sas_scsi_host.c |    3 +-
 include/linux/libata.h              |    6 +-
 12 files changed, 860 insertions(+), 219 deletions(-)
 create mode 100644 drivers/ata/acard-ahci.c

David Milburn (1):
      [libata] new driver acard_ahci, for ATP8620 host controller

Jeff Garzik (1):
      [libata] avoid needlessly passing around ptr to SCSI completion func

Nick Bowler (1):
      pata_platform: Remove CONFIG_HAVE_PATA_PLATFORM's dependencies.

Sergei Shtylyov (7):
      pata_hpt{37x|3x2n}: SATA mode filtering
      pata_hpt3x2n: clarify about HPT371N support
      pata_hpt3x2n: calculate average f_CNT
      pata_hpt366: coding style cleanup
      pata_hpt37x: coding style cleanup
      pata_hpt3x2n: coding style cleanup
      pata_hpt37x: actually limit HPT370 to UltraDMA/66

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 36e2319..c6b298d 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -2,6 +2,14 @@
 # SATA/PATA driver configuration
 #
 
+config HAVE_PATA_PLATFORM
+	bool
+	help
+	  This is an internal configuration node for any machine that
+	  uses pata-platform driver to enable the relevant driver in the
+	  configuration structure without having to submit endless patches
+	  to update the PATA_PLATFORM entry.
+
 menuconfig ATA
 	tristate "Serial ATA and Parallel ATA drivers"
 	depends on HAS_IOMEM
@@ -90,6 +98,14 @@ config SATA_INIC162X
 	help
 	  This option enables support for Initio 162x Serial ATA.
 
+config SATA_ACARD_AHCI
+	tristate "ACard AHCI variant (ATP 8620)"
+	depends on PCI
+	help
+	  This option enables support for Acard.
+
+	  If unsure, say N.
+
 config SATA_SIL24
 	tristate "Silicon Image 3124/3132 SATA support"
 	depends on PCI
@@ -400,11 +416,11 @@ config PATA_HPT37X
 	  If unsure, say N.
 
 config PATA_HPT3X2N
-	tristate "HPT 372N/302N PATA support"
+	tristate "HPT 371N/372N/302N PATA support"
 	depends on PCI
 	help
 	  This option enables support for the N variant HPT PATA
-	  controllers via the new ATA layer
+	  controllers via the new ATA layer.
 
 	  If unsure, say N.
 
@@ -765,14 +781,6 @@ config PATA_PCMCIA
 
 	  If unsure, say N.
 
-config HAVE_PATA_PLATFORM
-	bool
-	help
-	  This is an internal configuration node for any machine that
-	  uses pata-platform driver to enable the relevant driver in the
-	  configuration structure without having to submit endless patches
-	  to update the PATA_PLATFORM entry.
-
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
 	depends on EMBEDDED || PPC || HAVE_PATA_PLATFORM
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 2b67c90..27291aa 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_ATA)		+= libata.o
 
 # non-SFF interface
 obj-$(CONFIG_SATA_AHCI)		+= ahci.o libahci.o
+obj-$(CONFIG_SATA_ACARD_AHCI)	+= acard-ahci.o libahci.o
 obj-$(CONFIG_SATA_AHCI_PLATFORM) += ahci_platform.o libahci.o
 obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
 obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
new file mode 100644
index 0000000..339c210
--- /dev/null
+++ b/drivers/ata/acard-ahci.c
@@ -0,0 +1,528 @@
+
+/*
+ *  acard-ahci.c - ACard AHCI SATA support
+ *
+ *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *		    Please ALWAYS copy linux-ide@vger.kernel.org
+ *		    on emails.
+ *
+ *  Copyright 2010 Red Hat, Inc.
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
+ *
+ * libata documentation is available via 'make {ps|pdf}docs',
+ * as Documentation/DocBook/libata.*
+ *
+ * AHCI hardware documentation:
+ * http://www.intel.com/technology/serialata/pdf/rev1_0.pdf
+ * http://www.intel.com/technology/serialata/pdf/rev1_1.pdf
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include <linux/device.h>
+#include <linux/dmi.h>
+#include <linux/gfp.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_cmnd.h>
+#include <linux/libata.h>
+#include "ahci.h"
+
+#define DRV_NAME	"acard-ahci"
+#define DRV_VERSION	"1.0"
+
+/*
+  Received FIS structure limited to 80h.
+*/
+
+#define ACARD_AHCI_RX_FIS_SZ 128
+
+enum {
+	AHCI_PCI_BAR		= 5,
+};
+
+enum board_ids {
+	board_acard_ahci,
+};
+
+struct acard_sg {
+	__le32			addr;
+	__le32			addr_hi;
+	__le32			reserved;
+	__le32			size;	 /* bit 31 (EOT) max==0x10000 (64k) */
+};
+
+static void acard_ahci_qc_prep(struct ata_queued_cmd *qc);
+static bool acard_ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
+static int acard_ahci_port_start(struct ata_port *ap);
+static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
+
+#ifdef CONFIG_PM
+static int acard_ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
+static int acard_ahci_pci_device_resume(struct pci_dev *pdev);
+#endif
+
+static struct scsi_host_template acard_ahci_sht = {
+	AHCI_SHT("acard-ahci"),
+};
+
+static struct ata_port_operations acard_ops = {
+	.inherits		= &ahci_ops,
+	.qc_prep		= acard_ahci_qc_prep,
+	.qc_fill_rtf		= acard_ahci_qc_fill_rtf,
+	.port_start             = acard_ahci_port_start,
+};
+
+#define AHCI_HFLAGS(flags)	.private_data	= (void *)(flags)
+
+static const struct ata_port_info acard_ahci_port_info[] = {
+	[board_acard_ahci] =
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &acard_ops,
+	},
+};
+
+static const struct pci_device_id acard_ahci_pci_tbl[] = {
+	/* ACard */
+	{ PCI_VDEVICE(ARTOP, 0x000d), board_acard_ahci }, /* ATP8620 */
+
+	{ }    /* terminate list */
+};
+
+static struct pci_driver acard_ahci_pci_driver = {
+	.name			= DRV_NAME,
+	.id_table		= acard_ahci_pci_tbl,
+	.probe			= acard_ahci_init_one,
+	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= acard_ahci_pci_device_suspend,
+	.resume			= acard_ahci_pci_device_resume,
+#endif
+};
+
+#ifdef CONFIG_PM
+static int acard_ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	u32 ctl;
+
+	if (mesg.event & PM_EVENT_SUSPEND &&
+	    hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "BIOS update required for suspend/resume\n");
+		return -EIO;
+	}
+
+	if (mesg.event & PM_EVENT_SLEEP) {
+		/* AHCI spec rev1.1 section 8.3.3:
+		 * Software must disable interrupts prior to requesting a
+		 * transition of the HBA to D3 state.
+		 */
+		ctl = readl(mmio + HOST_CTL);
+		ctl &= ~HOST_IRQ_EN;
+		writel(ctl, mmio + HOST_CTL);
+		readl(mmio + HOST_CTL); /* flush */
+	}
+
+	return ata_pci_device_suspend(pdev, mesg);
+}
+
+static int acard_ahci_pci_device_resume(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
+		rc = ahci_reset_controller(host);
+		if (rc)
+			return rc;
+
+		ahci_init_controller(host);
+	}
+
+	ata_host_resume(host);
+
+	return 0;
+}
+#endif
+
+static int acard_ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
+{
+	int rc;
+
+	if (using_dac &&
+	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+		if (rc) {
+			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+			if (rc) {
+				dev_printk(KERN_ERR, &pdev->dev,
+					   "64-bit DMA enable failed\n");
+				return rc;
+			}
+		}
+	} else {
+		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (rc) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "32-bit DMA enable failed\n");
+			return rc;
+		}
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (rc) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "32-bit consistent DMA enable failed\n");
+			return rc;
+		}
+	}
+	return 0;
+}
+
+static void acard_ahci_pci_print_info(struct ata_host *host)
+{
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	u16 cc;
+	const char *scc_s;
+
+	pci_read_config_word(pdev, 0x0a, &cc);
+	if (cc == PCI_CLASS_STORAGE_IDE)
+		scc_s = "IDE";
+	else if (cc == PCI_CLASS_STORAGE_SATA)
+		scc_s = "SATA";
+	else if (cc == PCI_CLASS_STORAGE_RAID)
+		scc_s = "RAID";
+	else
+		scc_s = "unknown";
+
+	ahci_print_info(host, scc_s);
+}
+
+static unsigned int acard_ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
+{
+	struct scatterlist *sg;
+	struct acard_sg *acard_sg = cmd_tbl + AHCI_CMD_TBL_HDR_SZ;
+	unsigned int si, last_si = 0;
+
+	VPRINTK("ENTER\n");
+
+	/*
+	 * Next, the S/G list.
+	 */
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		dma_addr_t addr = sg_dma_address(sg);
+		u32 sg_len = sg_dma_len(sg);
+
+		/*
+		 * ACard note:
+		 * We must set an end-of-table (EOT) bit,
+		 * and the segment cannot exceed 64k (0x10000)
+		 */
+		acard_sg[si].addr = cpu_to_le32(addr & 0xffffffff);
+		acard_sg[si].addr_hi = cpu_to_le32((addr >> 16) >> 16);
+		acard_sg[si].size = cpu_to_le32(sg_len);
+		last_si = si;
+	}
+
+	acard_sg[last_si].size |= cpu_to_le32(1 << 31);	/* set EOT */
+
+	return si;
+}
+
+static void acard_ahci_qc_prep(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	int is_atapi = ata_is_atapi(qc->tf.protocol);
+	void *cmd_tbl;
+	u32 opts;
+	const u32 cmd_fis_len = 5; /* five dwords */
+	unsigned int n_elem;
+
+	/*
+	 * Fill in command table information.  First, the header,
+	 * a SATA Register - Host to Device command FIS.
+	 */
+	cmd_tbl = pp->cmd_tbl + qc->tag * AHCI_CMD_TBL_SZ;
+
+	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, cmd_tbl);
+	if (is_atapi) {
+		memset(cmd_tbl + AHCI_CMD_TBL_CDB, 0, 32);
+		memcpy(cmd_tbl + AHCI_CMD_TBL_CDB, qc->cdb, qc->dev->cdb_len);
+	}
+
+	n_elem = 0;
+	if (qc->flags & ATA_QCFLAG_DMAMAP)
+		n_elem = acard_ahci_fill_sg(qc, cmd_tbl);
+
+	/*
+	 * Fill in command slot information.
+	 *
+	 * ACard note: prd table length not filled in
+	 */
+	opts = cmd_fis_len | (qc->dev->link->pmp << 12);
+	if (qc->tf.flags & ATA_TFLAG_WRITE)
+		opts |= AHCI_CMD_WRITE;
+	if (is_atapi)
+		opts |= AHCI_CMD_ATAPI | AHCI_CMD_PREFETCH;
+
+	ahci_fill_cmd_slot(pp, qc->tag, opts);
+}
+
+static bool acard_ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
+{
+	struct ahci_port_priv *pp = qc->ap->private_data;
+	u8 *rx_fis = pp->rx_fis;
+
+	if (pp->fbs_enabled)
+		rx_fis += qc->dev->link->pmp * ACARD_AHCI_RX_FIS_SZ;
+
+	/*
+	 * After a successful execution of an ATA PIO data-in command,
+	 * the device doesn't send D2H Reg FIS to update the TF and
+	 * the host should take TF and E_Status from the preceding PIO
+	 * Setup FIS.
+	 */
+	if (qc->tf.protocol == ATA_PROT_PIO && qc->dma_dir == DMA_FROM_DEVICE &&
+	    !(qc->flags & ATA_QCFLAG_FAILED)) {
+		ata_tf_from_fis(rx_fis + RX_FIS_PIO_SETUP, &qc->result_tf);
+		qc->result_tf.command = (rx_fis + RX_FIS_PIO_SETUP)[15];
+	} else
+		ata_tf_from_fis(rx_fis + RX_FIS_D2H_REG, &qc->result_tf);
+
+	return true;
+}
+
+static int acard_ahci_port_start(struct ata_port *ap)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct device *dev = ap->host->dev;
+	struct ahci_port_priv *pp;
+	void *mem;
+	dma_addr_t mem_dma;
+	size_t dma_sz, rx_fis_sz;
+
+	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
+	if (!pp)
+		return -ENOMEM;
+
+	/* check FBS capability */
+	if ((hpriv->cap & HOST_CAP_FBS) && sata_pmp_supported(ap)) {
+		void __iomem *port_mmio = ahci_port_base(ap);
+		u32 cmd = readl(port_mmio + PORT_CMD);
+		if (cmd & PORT_CMD_FBSCP)
+			pp->fbs_supported = true;
+		else if (hpriv->flags & AHCI_HFLAG_YES_FBS) {
+			dev_printk(KERN_INFO, dev,
+				   "port %d can do FBS, forcing FBSCP\n",
+				   ap->port_no);
+			pp->fbs_supported = true;
+		} else
+			dev_printk(KERN_WARNING, dev,
+				   "port %d is not capable of FBS\n",
+				   ap->port_no);
+	}
+
+	if (pp->fbs_supported) {
+		dma_sz = AHCI_PORT_PRIV_FBS_DMA_SZ;
+		rx_fis_sz = ACARD_AHCI_RX_FIS_SZ * 16;
+	} else {
+		dma_sz = AHCI_PORT_PRIV_DMA_SZ;
+		rx_fis_sz = ACARD_AHCI_RX_FIS_SZ;
+	}
+
+	mem = dmam_alloc_coherent(dev, dma_sz, &mem_dma, GFP_KERNEL);
+	if (!mem)
+		return -ENOMEM;
+	memset(mem, 0, dma_sz);
+
+	/*
+	 * First item in chunk of DMA memory: 32-slot command table,
+	 * 32 bytes each in size
+	 */
+	pp->cmd_slot = mem;
+	pp->cmd_slot_dma = mem_dma;
+
+	mem += AHCI_CMD_SLOT_SZ;
+	mem_dma += AHCI_CMD_SLOT_SZ;
+
+	/*
+	 * Second item: Received-FIS area
+	 */
+	pp->rx_fis = mem;
+	pp->rx_fis_dma = mem_dma;
+
+	mem += rx_fis_sz;
+	mem_dma += rx_fis_sz;
+
+	/*
+	 * Third item: data area for storing a single command
+	 * and its scatter-gather table
+	 */
+	pp->cmd_tbl = mem;
+	pp->cmd_tbl_dma = mem_dma;
+
+	/*
+	 * Save off initial list of interrupts to be enabled.
+	 * This could be changed later
+	 */
+	pp->intr_mask = DEF_PORT_IRQ;
+
+	ap->private_data = pp;
+
+	/* engage engines, captain */
+	return ahci_port_resume(ap);
+}
+
+static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	static int printed_version;
+	unsigned int board_id = ent->driver_data;
+	struct ata_port_info pi = acard_ahci_port_info[board_id];
+	const struct ata_port_info *ppi[] = { &pi, NULL };
+	struct device *dev = &pdev->dev;
+	struct ahci_host_priv *hpriv;
+	struct ata_host *host;
+	int n_ports, i, rc;
+
+	VPRINTK("ENTER\n");
+
+	WARN_ON(ATA_MAX_QUEUE > AHCI_MAX_CMDS);
+
+	if (!printed_version++)
+		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+
+	/* acquire resources */
+	rc = pcim_enable_device(pdev);
+	if (rc)
+		return rc;
+
+	/* AHCI controllers often implement SFF compatible interface.
+	 * Grab all PCI BARs just in case.
+	 */
+	rc = pcim_iomap_regions_request_all(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
+	if (rc == -EBUSY)
+		pcim_pin_device(pdev);
+	if (rc)
+		return rc;
+
+	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
+	if (!hpriv)
+		return -ENOMEM;
+	hpriv->flags |= (unsigned long)pi.private_data;
+
+	if (!(hpriv->flags & AHCI_HFLAG_NO_MSI))
+		pci_enable_msi(pdev);
+
+	hpriv->mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
+
+	/* save initial config */
+	ahci_save_initial_config(&pdev->dev, hpriv, 0, 0);
+
+	/* prepare host */
+	if (hpriv->cap & HOST_CAP_NCQ)
+		pi.flags |= ATA_FLAG_NCQ;
+
+	if (hpriv->cap & HOST_CAP_PMP)
+		pi.flags |= ATA_FLAG_PMP;
+
+	ahci_set_em_messages(hpriv, &pi);
+
+	/* CAP.NP sometimes indicate the index of the last enabled
+	 * port, at other times, that of the last possible port, so
+	 * determining the maximum port number requires looking at
+	 * both CAP.NP and port_map.
+	 */
+	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
+
+	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
+	if (!host)
+		return -ENOMEM;
+	host->private_data = hpriv;
+
+	if (!(hpriv->cap & HOST_CAP_SSS) || ahci_ignore_sss)
+		host->flags |= ATA_HOST_PARALLEL_SCAN;
+	else
+		printk(KERN_INFO "ahci: SSS flag set, parallel bus scan disabled\n");
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		ata_port_pbar_desc(ap, AHCI_PCI_BAR, -1, "abar");
+		ata_port_pbar_desc(ap, AHCI_PCI_BAR,
+				   0x100 + ap->port_no * 0x80, "port");
+
+		/* set initial link pm policy */
+		/*
+		ap->pm_policy = NOT_AVAILABLE;
+		*/
+		/* disabled/not-implemented port */
+		if (!(hpriv->port_map & (1 << i)))
+			ap->ops = &ata_dummy_port_ops;
+	}
+
+	/* initialize adapter */
+	rc = acard_ahci_configure_dma_masks(pdev, hpriv->cap & HOST_CAP_64);
+	if (rc)
+		return rc;
+
+	rc = ahci_reset_controller(host);
+	if (rc)
+		return rc;
+
+	ahci_init_controller(host);
+	acard_ahci_pci_print_info(host);
+
+	pci_set_master(pdev);
+	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
+				 &acard_ahci_sht);
+}
+
+static int __init acard_ahci_init(void)
+{
+	return pci_register_driver(&acard_ahci_pci_driver);
+}
+
+static void __exit acard_ahci_exit(void)
+{
+	pci_unregister_driver(&acard_ahci_pci_driver);
+}
+
+MODULE_AUTHOR("Jeff Garzik");
+MODULE_DESCRIPTION("ACard AHCI SATA low-level driver");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, acard_ahci_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
+
+module_init(acard_ahci_init);
+module_exit(acard_ahci_exit);
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 329cbbb..3e606c3 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -311,6 +311,8 @@ extern struct device_attribute *ahci_sdev_attrs[];
 
 extern struct ata_port_operations ahci_ops;
 
+void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
+			u32 opts);
 void ahci_save_initial_config(struct device *dev,
 			      struct ahci_host_priv *hpriv,
 			      unsigned int force_port_map,
@@ -326,6 +328,7 @@ int ahci_stop_engine(struct ata_port *ap);
 void ahci_start_engine(struct ata_port *ap);
 int ahci_check_ready(struct ata_link *link);
 int ahci_kick_engine(struct ata_port *ap);
+int ahci_port_resume(struct ata_port *ap);
 void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 			  struct ata_port_info *pi);
 int ahci_reset_em(struct ata_host *host);
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index ebc08d6..26d4523 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -87,10 +87,7 @@ static int ahci_hardreset(struct ata_link *link, unsigned int *class,
 static void ahci_postreset(struct ata_link *link, unsigned int *class);
 static void ahci_error_handler(struct ata_port *ap);
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
-static int ahci_port_resume(struct ata_port *ap);
 static void ahci_dev_config(struct ata_device *dev);
-static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
-			       u32 opts);
 #ifdef CONFIG_PM
 static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
 #endif
@@ -1133,8 +1130,8 @@ static unsigned int ahci_dev_classify(struct ata_port *ap)
 	return ata_dev_classify(&tf);
 }
 
-static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
-			       u32 opts)
+void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
+			u32 opts)
 {
 	dma_addr_t cmd_tbl_dma;
 
@@ -1145,6 +1142,7 @@ static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 	pp->cmd_slot[tag].tbl_addr = cpu_to_le32(cmd_tbl_dma & 0xffffffff);
 	pp->cmd_slot[tag].tbl_addr_hi = cpu_to_le32((cmd_tbl_dma >> 16) >> 16);
 }
+EXPORT_SYMBOL_GPL(ahci_fill_cmd_slot);
 
 int ahci_kick_engine(struct ata_port *ap)
 {
@@ -1918,7 +1916,7 @@ static void ahci_pmp_detach(struct ata_port *ap)
 	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
 }
 
-static int ahci_port_resume(struct ata_port *ap)
+int ahci_port_resume(struct ata_port *ap)
 {
 	ahci_power_up(ap);
 	ahci_start_port(ap);
@@ -1930,6 +1928,7 @@ static int ahci_port_resume(struct ata_port *ap)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ahci_port_resume);
 
 #ifdef CONFIG_PM
 static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 66aa4be..5defc74 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -346,12 +346,11 @@ struct device_attribute *ata_common_sdev_attrs[] = {
 };
 EXPORT_SYMBOL_GPL(ata_common_sdev_attrs);
 
-static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
-				   void (*done)(struct scsi_cmnd *))
+static void ata_scsi_invalid_field(struct scsi_cmnd *cmd)
 {
 	ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x24, 0x0);
 	/* "Invalid field in cbd" */
-	done(cmd);
+	cmd->scsi_done(cmd);
 }
 
 /**
@@ -719,7 +718,6 @@ EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
  *	ata_scsi_qc_new - acquire new ata_queued_cmd reference
  *	@dev: ATA device to which the new command is attached
  *	@cmd: SCSI command that originated this ATA command
- *	@done: SCSI command completion function
  *
  *	Obtain a reference to an unused ata_queued_cmd structure,
  *	which is the basic libata structure representing a single
@@ -736,21 +734,20 @@ EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
  *	Command allocated, or %NULL if none available.
  */
 static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
-					      struct scsi_cmnd *cmd,
-					      void (*done)(struct scsi_cmnd *))
+					      struct scsi_cmnd *cmd)
 {
 	struct ata_queued_cmd *qc;
 
 	qc = ata_qc_new_init(dev);
 	if (qc) {
 		qc->scsicmd = cmd;
-		qc->scsidone = done;
+		qc->scsidone = cmd->scsi_done;
 
 		qc->sg = scsi_sglist(cmd);
 		qc->n_elem = scsi_sg_count(cmd);
 	} else {
 		cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
-		done(cmd);
+		cmd->scsi_done(cmd);
 	}
 
 	return qc;
@@ -1735,7 +1732,6 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
  *	ata_scsi_translate - Translate then issue SCSI command to ATA device
  *	@dev: ATA device to which the command is addressed
  *	@cmd: SCSI command to execute
- *	@done: SCSI command completion function
  *	@xlat_func: Actor which translates @cmd to an ATA taskfile
  *
  *	Our ->queuecommand() function has decided that the SCSI
@@ -1759,7 +1755,6 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
  *	needs to be deferred.
  */
 static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
-			      void (*done)(struct scsi_cmnd *),
 			      ata_xlat_func_t xlat_func)
 {
 	struct ata_port *ap = dev->link->ap;
@@ -1768,7 +1763,7 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 
 	VPRINTK("ENTER\n");
 
-	qc = ata_scsi_qc_new(dev, cmd, done);
+	qc = ata_scsi_qc_new(dev, cmd);
 	if (!qc)
 		goto err_mem;
 
@@ -1804,14 +1799,14 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 
 early_finish:
 	ata_qc_free(qc);
-	qc->scsidone(cmd);
+	cmd->scsi_done(cmd);
 	DPRINTK("EXIT - early finish (good or error)\n");
 	return 0;
 
 err_did:
 	ata_qc_free(qc);
 	cmd->result = (DID_ERROR << 16);
-	qc->scsidone(cmd);
+	cmd->scsi_done(cmd);
 err_mem:
 	DPRINTK("EXIT - internal\n");
 	return 0;
@@ -3116,7 +3111,6 @@ static inline void ata_scsi_dump_cdb(struct ata_port *ap,
 }
 
 static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
-				      void (*done)(struct scsi_cmnd *),
 				      struct ata_device *dev)
 {
 	u8 scsi_op = scmd->cmnd[0];
@@ -3150,9 +3144,9 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 	}
 
 	if (xlat_func)
-		rc = ata_scsi_translate(dev, scmd, done, xlat_func);
+		rc = ata_scsi_translate(dev, scmd, xlat_func);
 	else
-		ata_scsi_simulate(dev, scmd, done);
+		ata_scsi_simulate(dev, scmd);
 
 	return rc;
 
@@ -3160,7 +3154,7 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 	DPRINTK("bad CDB len=%u, scsi_op=0x%02x, max=%u\n",
 		scmd->cmd_len, scsi_op, dev->cdb_len);
 	scmd->result = DID_ERROR << 16;
-	done(scmd);
+	scmd->scsi_done(scmd);
 	return 0;
 }
 
@@ -3199,7 +3193,7 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 
 	dev = ata_scsi_find_dev(ap, scsidev);
 	if (likely(dev))
-		rc = __ata_scsi_queuecmd(cmd, cmd->scsi_done, dev);
+		rc = __ata_scsi_queuecmd(cmd, dev);
 	else {
 		cmd->result = (DID_BAD_TARGET << 16);
 		cmd->scsi_done(cmd);
@@ -3214,7 +3208,6 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
  *	ata_scsi_simulate - simulate SCSI command on ATA device
  *	@dev: the target device
  *	@cmd: SCSI command being sent to device.
- *	@done: SCSI command completion function.
  *
  *	Interprets and directly executes a select list of SCSI commands
  *	that can be handled internally.
@@ -3223,8 +3216,7 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
  *	spin_lock_irqsave(host lock)
  */
 
-void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
-		      void (*done)(struct scsi_cmnd *))
+void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 {
 	struct ata_scsi_args args;
 	const u8 *scsicmd = cmd->cmnd;
@@ -3233,17 +3225,17 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	args.dev = dev;
 	args.id = dev->id;
 	args.cmd = cmd;
-	args.done = done;
+	args.done = cmd->scsi_done;
 
 	switch(scsicmd[0]) {
 	/* TODO: worth improving? */
 	case FORMAT_UNIT:
-		ata_scsi_invalid_field(cmd, done);
+		ata_scsi_invalid_field(cmd);
 		break;
 
 	case INQUIRY:
 		if (scsicmd[1] & 2)	           /* is CmdDt set?  */
-			ata_scsi_invalid_field(cmd, done);
+			ata_scsi_invalid_field(cmd);
 		else if ((scsicmd[1] & 1) == 0)    /* is EVPD clear? */
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_std);
 		else switch (scsicmd[2]) {
@@ -3269,7 +3261,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b2);
 			break;
 		default:
-			ata_scsi_invalid_field(cmd, done);
+			ata_scsi_invalid_field(cmd);
 			break;
 		}
 		break;
@@ -3281,7 +3273,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 
 	case MODE_SELECT:	/* unconditionally return */
 	case MODE_SELECT_10:	/* bad-field-in-cdb */
-		ata_scsi_invalid_field(cmd, done);
+		ata_scsi_invalid_field(cmd);
 		break;
 
 	case READ_CAPACITY:
@@ -3292,7 +3284,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 		if ((scsicmd[1] & 0x1f) == SAI_READ_CAPACITY_16)
 			ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
 		else
-			ata_scsi_invalid_field(cmd, done);
+			ata_scsi_invalid_field(cmd);
 		break;
 
 	case REPORT_LUNS:
@@ -3302,7 +3294,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	case REQUEST_SENSE:
 		ata_scsi_set_sense(cmd, 0, 0, 0);
 		cmd->result = (DRIVER_SENSE << 24);
-		done(cmd);
+		cmd->scsi_done(cmd);
 		break;
 
 	/* if we reach this, then writeback caching is disabled,
@@ -3324,14 +3316,14 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 		if ((tmp8 == 0x4) && (!scsicmd[3]) && (!scsicmd[4]))
 			ata_scsi_rbuf_fill(&args, ata_scsiop_noop);
 		else
-			ata_scsi_invalid_field(cmd, done);
+			ata_scsi_invalid_field(cmd);
 		break;
 
 	/* all other commands */
 	default:
 		ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x20, 0x0);
 		/* "Invalid command operation code" */
-		done(cmd);
+		cmd->scsi_done(cmd);
 		break;
 	}
 }
@@ -3858,7 +3850,6 @@ EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
 /**
  *	ata_sas_queuecmd - Issue SCSI cdb to libata-managed device
  *	@cmd: SCSI command to be sent
- *	@done: Completion function, called when command is complete
  *	@ap:	ATA port to which the command is being sent
  *
  *	RETURNS:
@@ -3866,18 +3857,17 @@ EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
  *	0 otherwise.
  */
 
-int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
-		     struct ata_port *ap)
+int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap)
 {
 	int rc = 0;
 
 	ata_scsi_dump_cdb(ap, cmd);
 
 	if (likely(ata_dev_enabled(ap->link.device)))
-		rc = __ata_scsi_queuecmd(cmd, done, ap->link.device);
+		rc = __ata_scsi_queuecmd(cmd, ap->link.device);
 	else {
 		cmd->result = (DID_BAD_TARGET << 16);
-		done(cmd);
+		cmd->scsi_done(cmd);
 	}
 	return rc;
 }
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 7688868..d7e57db 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt366"
-#define DRV_VERSION	"0.6.8"
+#define DRV_VERSION	"0.6.9"
 
 struct hpt_clock {
 	u8	xfer_mode;
@@ -110,18 +110,23 @@ static const struct hpt_clock hpt366_25[] = {
 	{	0,		0x01208585	}
 };
 
-static const char *bad_ata33[] = {
-	"Maxtor 92720U8", "Maxtor 92040U6", "Maxtor 91360U4", "Maxtor 91020U3", "Maxtor 90845U3", "Maxtor 90650U2",
-	"Maxtor 91360D8", "Maxtor 91190D7", "Maxtor 91020D6", "Maxtor 90845D5", "Maxtor 90680D4", "Maxtor 90510D3", "Maxtor 90340D2",
-	"Maxtor 91152D8", "Maxtor 91008D7", "Maxtor 90845D6", "Maxtor 90840D6", "Maxtor 90720D5", "Maxtor 90648D5", "Maxtor 90576D4",
+static const char * const bad_ata33[] = {
+	"Maxtor 92720U8", "Maxtor 92040U6", "Maxtor 91360U4", "Maxtor 91020U3",
+	"Maxtor 90845U3", "Maxtor 90650U2",
+	"Maxtor 91360D8", "Maxtor 91190D7", "Maxtor 91020D6", "Maxtor 90845D5",
+	"Maxtor 90680D4", "Maxtor 90510D3", "Maxtor 90340D2",
+	"Maxtor 91152D8", "Maxtor 91008D7", "Maxtor 90845D6", "Maxtor 90840D6",
+	"Maxtor 90720D5", "Maxtor 90648D5", "Maxtor 90576D4",
 	"Maxtor 90510D4",
 	"Maxtor 90432D3", "Maxtor 90288D2", "Maxtor 90256D2",
-	"Maxtor 91000D8", "Maxtor 90910D8", "Maxtor 90875D7", "Maxtor 90840D7", "Maxtor 90750D6", "Maxtor 90625D5", "Maxtor 90500D4",
-	"Maxtor 91728D8", "Maxtor 91512D7", "Maxtor 91303D6", "Maxtor 91080D5", "Maxtor 90845D4", "Maxtor 90680D4", "Maxtor 90648D3", "Maxtor 90432D2",
+	"Maxtor 91000D8", "Maxtor 90910D8", "Maxtor 90875D7", "Maxtor 90840D7",
+	"Maxtor 90750D6", "Maxtor 90625D5", "Maxtor 90500D4",
+	"Maxtor 91728D8", "Maxtor 91512D7", "Maxtor 91303D6", "Maxtor 91080D5",
+	"Maxtor 90845D4", "Maxtor 90680D4", "Maxtor 90648D3", "Maxtor 90432D2",
 	NULL
 };
 
-static const char *bad_ata66_4[] = {
+static const char * const bad_ata66_4[] = {
 	"IBM-DTLA-307075",
 	"IBM-DTLA-307060",
 	"IBM-DTLA-307045",
@@ -140,12 +145,13 @@ static const char *bad_ata66_4[] = {
 	NULL
 };
 
-static const char *bad_ata66_3[] = {
+static const char * const bad_ata66_3[] = {
 	"WDC AC310200R",
 	NULL
 };
 
-static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr, const char *list[])
+static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr,
+			       const char * const list[])
 {
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
 	int i = 0;
@@ -288,6 +294,7 @@ static struct ata_port_operations hpt366_port_ops = {
 static void hpt36x_init_chipset(struct pci_dev *dev)
 {
 	u8 drive_fast;
+
 	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, (L1_CACHE_BYTES / 4));
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x78);
 	pci_write_config_byte(dev, PCI_MIN_GNT, 0x08);
@@ -349,16 +356,16 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 
 	/* PCI clocking determines the ATA timing values to use */
 	/* info_hpt366 is safe against re-entry so we can scribble on it */
-	switch((reg1 & 0x700) >> 8) {
-		case 9:
-			hpriv = &hpt366_40;
-			break;
-		case 5:
-			hpriv = &hpt366_25;
-			break;
-		default:
-			hpriv = &hpt366_33;
-			break;
+	switch ((reg1 & 0x700) >> 8) {
+	case 9:
+		hpriv = &hpt366_40;
+		break;
+	case 5:
+		hpriv = &hpt366_25;
+		break;
+	default:
+		hpriv = &hpt366_33;
+		break;
 	}
 	/* Now kick off ATA set up */
 	return ata_pci_bmdma_init_one(dev, ppi, &hpt36x_sht, hpriv, 0);
@@ -385,9 +392,9 @@ static const struct pci_device_id hpt36x[] = {
 };
 
 static struct pci_driver hpt36x_pci_driver = {
-	.name 		= DRV_NAME,
+	.name		= DRV_NAME,
 	.id_table	= hpt36x,
-	.probe 		= hpt36x_init_one,
+	.probe		= hpt36x_init_one,
 	.remove		= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 9ae4c08..efdd18b 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -8,7 +8,7 @@
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
- * Portions Copyright (C) 2005-2009	MontaVista Software, Inc.
+ * Portions Copyright (C) 2005-2010	MontaVista Software, Inc.
  *
  * TODO
  *	Look into engine reset on timeout errors. Should not be	required.
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.15"
+#define DRV_VERSION	"0.6.18"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -210,7 +210,7 @@ static u32 hpt37x_find_mode(struct ata_port *ap, int speed)
 {
 	struct hpt_clock *clocks = ap->host->private_data;
 
-	while(clocks->xfer_speed) {
+	while (clocks->xfer_speed) {
 		if (clocks->xfer_speed == speed)
 			return clocks->timing;
 		clocks++;
@@ -219,7 +219,8 @@ static u32 hpt37x_find_mode(struct ata_port *ap, int speed)
 	return 0xffffffffU;	/* silence compiler warning */
 }
 
-static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr, const char *list[])
+static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr,
+			       const char * const list[])
 {
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
 	int i = 0;
@@ -237,18 +238,23 @@ static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr, cons
 	return 0;
 }
 
-static const char *bad_ata33[] = {
-	"Maxtor 92720U8", "Maxtor 92040U6", "Maxtor 91360U4", "Maxtor 91020U3", "Maxtor 90845U3", "Maxtor 90650U2",
-	"Maxtor 91360D8", "Maxtor 91190D7", "Maxtor 91020D6", "Maxtor 90845D5", "Maxtor 90680D4", "Maxtor 90510D3", "Maxtor 90340D2",
-	"Maxtor 91152D8", "Maxtor 91008D7", "Maxtor 90845D6", "Maxtor 90840D6", "Maxtor 90720D5", "Maxtor 90648D5", "Maxtor 90576D4",
+static const char * const bad_ata33[] = {
+	"Maxtor 92720U8", "Maxtor 92040U6", "Maxtor 91360U4", "Maxtor 91020U3",
+	"Maxtor 90845U3", "Maxtor 90650U2",
+	"Maxtor 91360D8", "Maxtor 91190D7", "Maxtor 91020D6", "Maxtor 90845D5",
+	"Maxtor 90680D4", "Maxtor 90510D3", "Maxtor 90340D2",
+	"Maxtor 91152D8", "Maxtor 91008D7", "Maxtor 90845D6", "Maxtor 90840D6",
+	"Maxtor 90720D5", "Maxtor 90648D5", "Maxtor 90576D4",
 	"Maxtor 90510D4",
 	"Maxtor 90432D3", "Maxtor 90288D2", "Maxtor 90256D2",
-	"Maxtor 91000D8", "Maxtor 90910D8", "Maxtor 90875D7", "Maxtor 90840D7", "Maxtor 90750D6", "Maxtor 90625D5", "Maxtor 90500D4",
-	"Maxtor 91728D8", "Maxtor 91512D7", "Maxtor 91303D6", "Maxtor 91080D5", "Maxtor 90845D4", "Maxtor 90680D4", "Maxtor 90648D3", "Maxtor 90432D2",
+	"Maxtor 91000D8", "Maxtor 90910D8", "Maxtor 90875D7", "Maxtor 90840D7",
+	"Maxtor 90750D6", "Maxtor 90625D5", "Maxtor 90500D4",
+	"Maxtor 91728D8", "Maxtor 91512D7", "Maxtor 91303D6", "Maxtor 91080D5",
+	"Maxtor 90845D4", "Maxtor 90680D4", "Maxtor 90648D3", "Maxtor 90432D2",
 	NULL
 };
 
-static const char *bad_ata100_5[] = {
+static const char * const bad_ata100_5[] = {
 	"IBM-DTLA-307075",
 	"IBM-DTLA-307060",
 	"IBM-DTLA-307045",
@@ -302,6 +308,22 @@ static unsigned long hpt370a_filter(struct ata_device *adev, unsigned long mask)
 }
 
 /**
+ *	hpt372_filter	-	mode selection filter
+ *	@adev: ATA device
+ *	@mask: mode mask
+ *
+ *	The Marvell bridge chips used on the HighPoint SATA cards do not seem
+ *	to support the UltraDMA modes 1, 2, and 3 as well as any MWDMA modes...
+ */
+static unsigned long hpt372_filter(struct ata_device *adev, unsigned long mask)
+{
+	if (ata_id_is_sata(adev->id))
+		mask &= ~((0xE << ATA_SHIFT_UDMA) | ATA_MASK_MWDMA);
+
+	return mask;
+}
+
+/**
  *	hpt37x_cable_detect	-	Detect the cable type
  *	@ap: ATA port to detect on
  *
@@ -373,6 +395,7 @@ static int hpt37x_pre_reset(struct ata_link *link, unsigned long deadline)
 		{ 0x50, 1, 0x04, 0x04 },
 		{ 0x54, 1, 0x04, 0x04 }
 	};
+
 	if (!pci_test_config_bits(pdev, &hpt37x_enable_bits[ap->port_no]))
 		return -ENOENT;
 
@@ -586,11 +609,11 @@ static struct ata_port_operations hpt370a_port_ops = {
 };
 
 /*
- *	Configuration for HPT372, HPT371, HPT302. Slightly different PIO
- *	and DMA mode setting functionality.
+ *	Configuration for HPT371 and HPT302. Slightly different PIO and DMA
+ *	mode setting functionality.
  */
 
-static struct ata_port_operations hpt372_port_ops = {
+static struct ata_port_operations hpt302_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 
 	.bmdma_stop	= hpt37x_bmdma_stop,
@@ -602,7 +625,17 @@ static struct ata_port_operations hpt372_port_ops = {
 };
 
 /*
- *	Configuration for HPT374. Mode setting works like 372 and friends
+ *	Configuration for HPT372. Mode setting works like 371 and 302
+ *	but we have a mode filter.
+ */
+
+static struct ata_port_operations hpt372_port_ops = {
+	.inherits	= &hpt302_port_ops,
+	.mode_filter	= hpt372_filter,
+};
+
+/*
+ *	Configuration for HPT374. Mode setting and filtering works like 372
  *	but we have a different cable detection procedure for function 1.
  */
 
@@ -647,12 +680,12 @@ static int hpt37x_calibrate_dpll(struct pci_dev *dev)
 	u32 reg5c;
 	int tries;
 
-	for(tries = 0; tries < 0x5000; tries++) {
+	for (tries = 0; tries < 0x5000; tries++) {
 		udelay(50);
 		pci_read_config_byte(dev, 0x5b, &reg5b);
 		if (reg5b & 0x80) {
 			/* See if it stays set */
-			for(tries = 0; tries < 0x1000; tries ++) {
+			for (tries = 0; tries < 0x1000; tries++) {
 				pci_read_config_byte(dev, 0x5b, &reg5b);
 				/* Failed ? */
 				if ((reg5b & 0x80) == 0)
@@ -660,7 +693,7 @@ static int hpt37x_calibrate_dpll(struct pci_dev *dev)
 			}
 			/* Turn off tuning, we have the DPLL set */
 			pci_read_config_dword(dev, 0x5c, &reg5c);
-			pci_write_config_dword(dev, 0x5c, reg5c & ~ 0x100);
+			pci_write_config_dword(dev, 0x5c, reg5c & ~0x100);
 			return 1;
 		}
 	}
@@ -672,6 +705,7 @@ static u32 hpt374_read_freq(struct pci_dev *pdev)
 {
 	u32 freq;
 	unsigned long io_base = pci_resource_start(pdev, 4);
+
 	if (PCI_FUNC(pdev->devfn) & 1) {
 		struct pci_dev *pdev_0;
 
@@ -737,23 +771,23 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt370a_port_ops
 	};
-	/* HPT370 - UDMA100 */
+	/* HPT370 - UDMA66 */
 	static const struct ata_port_info info_hpt370_33 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = ATA_PIO4,
 		.mwdma_mask = ATA_MWDMA2,
-		.udma_mask = ATA_UDMA5,
+		.udma_mask = ATA_UDMA4,
 		.port_ops = &hpt370_port_ops
 	};
-	/* HPT370A - UDMA100 */
+	/* HPT370A - UDMA66 */
 	static const struct ata_port_info info_hpt370a_33 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = ATA_PIO4,
 		.mwdma_mask = ATA_MWDMA2,
-		.udma_mask = ATA_UDMA5,
+		.udma_mask = ATA_UDMA4,
 		.port_ops = &hpt370a_port_ops
 	};
-	/* HPT371, 372 and friends - UDMA133 */
+	/* HPT372 - UDMA133 */
 	static const struct ata_port_info info_hpt372 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = ATA_PIO4,
@@ -761,6 +795,14 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = ATA_UDMA6,
 		.port_ops = &hpt372_port_ops
 	};
+	/* HPT371, 302 - UDMA133 */
+	static const struct ata_port_info info_hpt302 = {
+		.flags = ATA_FLAG_SLAVE_POSS,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
+		.udma_mask = ATA_UDMA6,
+		.port_ops = &hpt302_port_ops
+	};
 	/* HPT374 - UDMA100, function 1 uses different prereset method */
 	static const struct ata_port_info info_hpt374_fn0 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
@@ -805,64 +847,68 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		if (rev == 6)
 			return -ENODEV;
 
-		switch(rev) {
-			case 3:
-				ppi[0] = &info_hpt370;
-				chip_table = &hpt370;
-				prefer_dpll = 0;
-				break;
-			case 4:
-				ppi[0] = &info_hpt370a;
-				chip_table = &hpt370a;
-				prefer_dpll = 0;
-				break;
-			case 5:
-				ppi[0] = &info_hpt372;
-				chip_table = &hpt372;
-				break;
-			default:
-				printk(KERN_ERR "pata_hpt37x: Unknown HPT366 "
-				       "subtype, please report (%d).\n", rev);
-				return -ENODEV;
+		switch (rev) {
+		case 3:
+			ppi[0] = &info_hpt370;
+			chip_table = &hpt370;
+			prefer_dpll = 0;
+			break;
+		case 4:
+			ppi[0] = &info_hpt370a;
+			chip_table = &hpt370a;
+			prefer_dpll = 0;
+			break;
+		case 5:
+			ppi[0] = &info_hpt372;
+			chip_table = &hpt372;
+			break;
+		default:
+			printk(KERN_ERR "pata_hpt37x: Unknown HPT366 subtype, "
+			       "please report (%d).\n", rev);
+			return -ENODEV;
 		}
 	} else {
-		switch(dev->device) {
-			case PCI_DEVICE_ID_TTI_HPT372:
-				/* 372N if rev >= 2*/
-				if (rev >= 2)
-					return -ENODEV;
-				ppi[0] = &info_hpt372;
-				chip_table = &hpt372a;
-				break;
-			case PCI_DEVICE_ID_TTI_HPT302:
-				/* 302N if rev > 1 */
-				if (rev > 1)
-					return -ENODEV;
-				ppi[0] = &info_hpt372;
-				/* Check this */
-				chip_table = &hpt302;
-				break;
-			case PCI_DEVICE_ID_TTI_HPT371:
-				if (rev > 1)
-					return -ENODEV;
-				ppi[0] = &info_hpt372;
-				chip_table = &hpt371;
-				/* Single channel device, master is not present
-				   but the BIOS (or us for non x86) must mark it
-				   absent */
-				pci_read_config_byte(dev, 0x50, &mcr1);
-				mcr1 &= ~0x04;
-				pci_write_config_byte(dev, 0x50, mcr1);
-				break;
-			case PCI_DEVICE_ID_TTI_HPT374:
-				chip_table = &hpt374;
-				if (!(PCI_FUNC(dev->devfn) & 1))
-					*ppi = &info_hpt374_fn0;
-				else
-					*ppi = &info_hpt374_fn1;
-				break;
-			default:
-				printk(KERN_ERR "pata_hpt37x: PCI table is bogus please report (%d).\n", dev->device);
+		switch (dev->device) {
+		case PCI_DEVICE_ID_TTI_HPT372:
+			/* 372N if rev >= 2 */
+			if (rev >= 2)
+				return -ENODEV;
+			ppi[0] = &info_hpt372;
+			chip_table = &hpt372a;
+			break;
+		case PCI_DEVICE_ID_TTI_HPT302:
+			/* 302N if rev > 1 */
+			if (rev > 1)
+				return -ENODEV;
+			ppi[0] = &info_hpt302;
+			/* Check this */
+			chip_table = &hpt302;
+			break;
+		case PCI_DEVICE_ID_TTI_HPT371:
+			if (rev > 1)
+				return -ENODEV;
+			ppi[0] = &info_hpt302;
+			chip_table = &hpt371;
+			/*
+			 * Single channel device, master is not present
+			 * but the BIOS (or us for non x86) must mark it
+			 * absent
+			 */
+			pci_read_config_byte(dev, 0x50, &mcr1);
+			mcr1 &= ~0x04;
+			pci_write_config_byte(dev, 0x50, mcr1);
+			break;
+		case PCI_DEVICE_ID_TTI_HPT374:
+			chip_table = &hpt374;
+			if (!(PCI_FUNC(dev->devfn) & 1))
+				*ppi = &info_hpt374_fn0;
+			else
+				*ppi = &info_hpt374_fn1;
+			break;
+		default:
+			printk(KERN_ERR
+			       "pata_hpt37x: PCI table is bogus, please report (%d).\n",
+			       dev->device);
 				return -ENODEV;
 		}
 	}
@@ -893,9 +939,11 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (chip_table == &hpt372a)
 		outb(0x0e, iobase + 0x9c);
 
-	/* Some devices do not let this value be accessed via PCI space
-	   according to the old driver. In addition we must use the value
-	   from FN 0 on the HPT374 */
+	/*
+	 * Some devices do not let this value be accessed via PCI space
+	 * according to the old driver. In addition we must use the value
+	 * from FN 0 on the HPT374.
+	 */
 
 	if (chip_table == &hpt374) {
 		freq = hpt374_read_freq(dev);
@@ -909,10 +957,11 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		u8 sr;
 		u32 total = 0;
 
-		printk(KERN_WARNING "pata_hpt37x: BIOS has not set timing clocks.\n");
+		printk(KERN_WARNING
+		       "pata_hpt37x: BIOS has not set timing clocks.\n");
 
 		/* This is the process the HPT371 BIOS is reported to use */
-		for(i = 0; i < 128; i++) {
+		for (i = 0; i < 128; i++) {
 			pci_read_config_byte(dev, 0x78, &sr);
 			total += sr & 0x1FF;
 			udelay(15);
@@ -947,17 +996,22 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 
 		/* Select the DPLL clock. */
 		pci_write_config_byte(dev, 0x5b, 0x21);
-		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low | 0x100);
+		pci_write_config_dword(dev, 0x5C,
+				       (f_high << 16) | f_low | 0x100);
 
-		for(adjust = 0; adjust < 8; adjust++) {
+		for (adjust = 0; adjust < 8; adjust++) {
 			if (hpt37x_calibrate_dpll(dev))
 				break;
-			/* See if it'll settle at a fractionally different clock */
+			/*
+			 * See if it'll settle at a fractionally
+			 * different clock
+			 */
 			if (adjust & 1)
 				f_low -= adjust >> 1;
 			else
 				f_high += adjust >> 1;
-			pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low | 0x100);
+			pci_write_config_dword(dev, 0x5C,
+					       (f_high << 16) | f_low | 0x100);
 		}
 		if (adjust == 8) {
 			printk(KERN_ERR "pata_hpt37x: DPLL did not stabilize!\n");
@@ -976,7 +1030,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		 *	Perform a final fixup. Note that we will have used the
 		 *	DPLL on the HPT372 which means we don't have to worry
 		 *	about lack of UDMA133 support on lower clocks
- 		 */
+		 */
 
 		if (clock_slot < 2 && ppi[0] == &info_hpt370)
 			ppi[0] = &info_hpt370_33;
@@ -1001,9 +1055,9 @@ static const struct pci_device_id hpt37x[] = {
 };
 
 static struct pci_driver hpt37x_pci_driver = {
-	.name 		= DRV_NAME,
+	.name		= DRV_NAME,
 	.id_table	= hpt37x,
-	.probe 		= hpt37x_init_one,
+	.probe		= hpt37x_init_one,
 	.remove		= ata_pci_remove_one
 };
 
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 32f3463..d2239bb 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -1,5 +1,5 @@
 /*
- * Libata driver for the highpoint 372N and 302N UDMA66 ATA controllers.
+ * Libata driver for the HighPoint 371N, 372N, and 302N UDMA66 ATA controllers.
  *
  * This driver is heavily based upon:
  *
@@ -8,7 +8,7 @@
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
- * Portions Copyright (C) 2005-2009	MontaVista Software, Inc.
+ * Portions Copyright (C) 2005-2010	MontaVista Software, Inc.
  *
  *
  * TODO
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x2n"
-#define DRV_VERSION	"0.3.10"
+#define DRV_VERSION	"0.3.13"
 
 enum {
 	HPT_PCI_FAST	=	(1 << 31),
@@ -103,7 +103,7 @@ static u32 hpt3x2n_find_mode(struct ata_port *ap, int speed)
 {
 	struct hpt_clock *clocks = hpt3x2n_clocks;
 
-	while(clocks->xfer_speed) {
+	while (clocks->xfer_speed) {
 		if (clocks->xfer_speed == speed)
 			return clocks->timing;
 		clocks++;
@@ -113,6 +113,22 @@ static u32 hpt3x2n_find_mode(struct ata_port *ap, int speed)
 }
 
 /**
+ *	hpt372n_filter	-	mode selection filter
+ *	@adev: ATA device
+ *	@mask: mode mask
+ *
+ *	The Marvell bridge chips used on the HighPoint SATA cards do not seem
+ *	to support the UltraDMA modes 1, 2, and 3 as well as any MWDMA modes...
+ */
+static unsigned long hpt372n_filter(struct ata_device *adev, unsigned long mask)
+{
+	if (ata_id_is_sata(adev->id))
+		mask &= ~((0xE << ATA_SHIFT_UDMA) | ATA_MASK_MWDMA);
+
+	return mask;
+}
+
+/**
  *	hpt3x2n_cable_detect	-	Detect the cable type
  *	@ap: ATA port to detect on
  *
@@ -153,6 +169,7 @@ static int hpt3x2n_pre_reset(struct ata_link *link, unsigned long deadline)
 {
 	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
 	/* Reset the state machine */
 	pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
 	udelay(100);
@@ -328,10 +345,10 @@ static struct scsi_host_template hpt3x2n_sht = {
 };
 
 /*
- *	Configuration for HPT3x2n.
+ *	Configuration for HPT302N/371N.
  */
 
-static struct ata_port_operations hpt3x2n_port_ops = {
+static struct ata_port_operations hpt3xxn_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 
 	.bmdma_stop	= hpt3x2n_bmdma_stop,
@@ -345,6 +362,15 @@ static struct ata_port_operations hpt3x2n_port_ops = {
 	.prereset	= hpt3x2n_pre_reset,
 };
 
+/*
+ *	Configuration for HPT372N. Same as 302N/371N but we have a mode filter.
+ */
+
+static struct ata_port_operations hpt372n_port_ops = {
+	.inherits	= &hpt3xxn_port_ops,
+	.mode_filter	= &hpt372n_filter,
+};
+
 /**
  *	hpt3xn_calibrate_dpll		-	Calibrate the DPLL loop
  *	@dev: PCI device
@@ -359,12 +385,12 @@ static int hpt3xn_calibrate_dpll(struct pci_dev *dev)
 	u32 reg5c;
 	int tries;
 
-	for(tries = 0; tries < 0x5000; tries++) {
+	for (tries = 0; tries < 0x5000; tries++) {
 		udelay(50);
 		pci_read_config_byte(dev, 0x5b, &reg5b);
 		if (reg5b & 0x80) {
 			/* See if it stays set */
-			for(tries = 0; tries < 0x1000; tries ++) {
+			for (tries = 0; tries < 0x1000; tries++) {
 				pci_read_config_byte(dev, 0x5b, &reg5b);
 				/* Failed ? */
 				if ((reg5b & 0x80) == 0)
@@ -372,7 +398,7 @@ static int hpt3xn_calibrate_dpll(struct pci_dev *dev)
 			}
 			/* Turn off tuning, we have the DPLL set */
 			pci_read_config_dword(dev, 0x5c, &reg5c);
-			pci_write_config_dword(dev, 0x5c, reg5c & ~ 0x100);
+			pci_write_config_dword(dev, 0x5c, reg5c & ~0x100);
 			return 1;
 		}
 	}
@@ -388,8 +414,19 @@ static int hpt3x2n_pci_clock(struct pci_dev *pdev)
 
 	fcnt = inl(iobase + 0x90);	/* Not PCI readable for some chips */
 	if ((fcnt >> 12) != 0xABCDE) {
-		printk(KERN_WARNING "hpt3xn: BIOS clock data not set.\n");
-		return 33;	/* Not BIOS set */
+		int i;
+		u16 sr;
+		u32 total = 0;
+
+		printk(KERN_WARNING "pata_hpt3x2n: BIOS clock data not set.\n");
+
+		/* This is the process the HPT371 BIOS is reported to use */
+		for (i = 0; i < 128; i++) {
+			pci_read_config_word(pdev, 0x78, &sr);
+			total += sr & 0x1FF;
+			udelay(15);
+		}
+		fcnt = total / 128;
 	}
 	fcnt &= 0x1FF;
 
@@ -431,21 +468,27 @@ static int hpt3x2n_pci_clock(struct pci_dev *pdev)
  *	HPT372N			9 (HPT372N)	*	UDMA133
  *
  *	(1) UDMA133 support depends on the bus clock
- *
- *	To pin down		HPT371N
  */
 
 static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	/* HPT372N and friends - UDMA133 */
-	static const struct ata_port_info info = {
+	/* HPT372N - UDMA133 */
+	static const struct ata_port_info info_hpt372n = {
+		.flags = ATA_FLAG_SLAVE_POSS,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
+		.udma_mask = ATA_UDMA6,
+		.port_ops = &hpt372n_port_ops
+	};
+	/* HPT302N and HPT371N - UDMA133 */
+	static const struct ata_port_info info_hpt3xxn = {
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = ATA_PIO4,
 		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA6,
-		.port_ops = &hpt3x2n_port_ops
+		.port_ops = &hpt3xxn_port_ops
 	};
-	const struct ata_port_info *ppi[] = { &info, NULL };
+	const struct ata_port_info *ppi[] = { &info_hpt3xxn, NULL };
 	u8 rev = dev->revision;
 	u8 irqmask;
 	unsigned int pci_mhz;
@@ -459,30 +502,36 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
-	switch(dev->device) {
-		case PCI_DEVICE_ID_TTI_HPT366:
-			if (rev < 6)
-				return -ENODEV;
-			break;
-		case PCI_DEVICE_ID_TTI_HPT371:
-			if (rev < 2)
-				return -ENODEV;
-			/* 371N if rev > 1 */
-			break;
-		case PCI_DEVICE_ID_TTI_HPT372:
-			/* 372N if rev >= 2*/
-			if (rev < 2)
-				return -ENODEV;
-			break;
-		case PCI_DEVICE_ID_TTI_HPT302:
-			if (rev < 2)
-				return -ENODEV;
-			break;
-		case PCI_DEVICE_ID_TTI_HPT372N:
-			break;
-		default:
-			printk(KERN_ERR "pata_hpt3x2n: PCI table is bogus please report (%d).\n", dev->device);
+	switch (dev->device) {
+	case PCI_DEVICE_ID_TTI_HPT366:
+		/* 372N if rev >= 6 */
+		if (rev < 6)
 			return -ENODEV;
+		goto hpt372n;
+	case PCI_DEVICE_ID_TTI_HPT371:
+		/* 371N if rev >= 2 */
+		if (rev < 2)
+			return -ENODEV;
+		break;
+	case PCI_DEVICE_ID_TTI_HPT372:
+		/* 372N if rev >= 2 */
+		if (rev < 2)
+			return -ENODEV;
+		goto hpt372n;
+	case PCI_DEVICE_ID_TTI_HPT302:
+		/* 302N if rev >= 2 */
+		if (rev < 2)
+			return -ENODEV;
+		break;
+	case PCI_DEVICE_ID_TTI_HPT372N:
+hpt372n:
+		ppi[0] = &info_hpt372n;
+		break;
+	default:
+		printk(KERN_ERR
+		       "pata_hpt3x2n: PCI table is bogus please report (%d).\n",
+		       dev->device);
+		return -ENODEV;
 	}
 
 	/* Ok so this is a chip we support */
@@ -509,8 +558,10 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		pci_write_config_byte(dev, 0x50, mcr1);
 	}
 
-	/* Tune the PLL. HPT recommend using 75 for SATA, 66 for UDMA133 or
-	   50 for UDMA100. Right now we always use 66 */
+	/*
+	 * Tune the PLL. HPT recommend using 75 for SATA, 66 for UDMA133 or
+	 * 50 for UDMA100. Right now we always use 66
+	 */
 
 	pci_mhz = hpt3x2n_pci_clock(dev);
 
@@ -522,7 +573,7 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	pci_write_config_byte(dev, 0x5B, 0x21);
 
 	/* Unlike the 37x we don't try jiggling the frequency */
-	for(adjust = 0; adjust < 8; adjust++) {
+	for (adjust = 0; adjust < 8; adjust++) {
 		if (hpt3xn_calibrate_dpll(dev))
 			break;
 		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low);
@@ -534,8 +585,11 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 
 	printk(KERN_INFO "pata_hpt37x: bus clock %dMHz, using 66MHz DPLL.\n",
 	       pci_mhz);
-	/* Set our private data up. We only need a few flags so we use
-	   it directly */
+
+	/*
+	 * Set our private data up. We only need a few flags
+	 * so we use it directly.
+	 */
 	if (pci_mhz > 60)
 		hpriv = (void *)(PCI66 | USE_DPLL);
 
@@ -562,9 +616,9 @@ static const struct pci_device_id hpt3x2n[] = {
 };
 
 static struct pci_driver hpt3x2n_pci_driver = {
-	.name 		= DRV_NAME,
+	.name		= DRV_NAME,
 	.id_table	= hpt3x2n,
-	.probe 		= hpt3x2n_init_one,
+	.probe		= hpt3x2n_init_one,
 	.remove		= ata_pci_remove_one
 };
 
@@ -579,7 +633,7 @@ static void __exit hpt3x2n_exit(void)
 }
 
 MODULE_AUTHOR("Alan Cox");
-MODULE_DESCRIPTION("low-level driver for the Highpoint HPT3x2n/30x");
+MODULE_DESCRIPTION("low-level driver for the Highpoint HPT3xxN");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, hpt3x2n);
 MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5bbaee5..2c71927 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5743,7 +5743,7 @@ static int ipr_queuecommand_lck(struct scsi_cmnd *scsi_cmd,
 	}
 
 	if (ipr_is_gata(res) && res->sata_port)
-		return ata_sas_queuecmd(scsi_cmd, done, res->sata_port->ap);
+		return ata_sas_queuecmd(scsi_cmd, res->sata_port->ap);
 
 	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ioarcb = &ipr_cmd->ioarcb;
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 29251fa..5815cbe 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -211,8 +211,7 @@ static int sas_queuecommand_lck(struct scsi_cmnd *cmd,
 			unsigned long flags;
 
 			spin_lock_irqsave(dev->sata_dev.ap->lock, flags);
-			res = ata_sas_queuecmd(cmd, scsi_done,
-					       dev->sata_dev.ap);
+			res = ata_sas_queuecmd(cmd, dev->sata_dev.ap);
 			spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags);
 			goto out;
 		}
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d947b12..c9c5d7a 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -996,8 +996,7 @@ extern int ata_sas_port_init(struct ata_port *);
 extern int ata_sas_port_start(struct ata_port *ap);
 extern void ata_sas_port_stop(struct ata_port *ap);
 extern int ata_sas_slave_configure(struct scsi_device *, struct ata_port *);
-extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
-			    struct ata_port *ap);
+extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap);
 extern int sata_scr_valid(struct ata_link *link);
 extern int sata_scr_read(struct ata_link *link, int reg, u32 *val);
 extern int sata_scr_write(struct ata_link *link, int reg, u32 val);
@@ -1040,8 +1039,7 @@ extern unsigned int ata_do_dev_read_id(struct ata_device *dev,
 					struct ata_taskfile *tf, u16 *id);
 extern void ata_qc_complete(struct ata_queued_cmd *qc);
 extern int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active);
-extern void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
-			      void (*done)(struct scsi_cmnd *));
+extern void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd);
 extern int ata_std_bios_param(struct scsi_device *sdev,
 			      struct block_device *bdev,
 			      sector_t capacity, int geom[]);
