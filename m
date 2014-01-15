From: Loc Ho <lho@apm.com>
Subject: [PATCH v9 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Wed, 15 Jan 2014 00:11:49 -0700
Message-ID: <1389769910-15505-4-git-send-email-lho@apm.com>
References: <1389769910-15505-1-git-send-email-lho@apm.com>
 <1389769910-15505-2-git-send-email-lho@apm.com>
 <1389769910-15505-3-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:49661 "HELO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750856AbaAOHMU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 02:12:20 -0500
Received: by mail-pa0-f52.google.com with SMTP id kx10so761356pab.39
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2014 23:12:19 -0800 (PST)
In-Reply-To: <1389769910-15505-3-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dmilburn@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

This patch adds support for the APM X-Gene SoC SATA host controller driver.
It requires the corresponding APM X-Gene SoC PHY driver.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/Kconfig      |    8 +
 drivers/ata/Makefile     |    1 +
 drivers/ata/sata_xgene.c |  630 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 639 insertions(+), 0 deletions(-)
 create mode 100644 drivers/ata/sata_xgene.c

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 4e73772..cd1bc3c 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -106,6 +106,14 @@ config AHCI_IMX
 
 	  If unsure, say N.
 
+config SATA_XGENE
+	tristate "APM X-Gene 6.0Gbps SATA host controller support"
+	depends on ARM64 || COMPILE_TEST
+	select SATA_AHCI_PLATFORM
+	select PHY_XGENE
+	help
+	  This option enables support for APM X-Gene SoC SATA host controller.
+
 config SATA_FSL
 	tristate "Freescale 3.0Gbps SATA support"
 	depends on FSL_SOC
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 46518c6..1c0fabe 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
 obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
 obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
 obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o
+obj-$(CONFIG_SATA_XGENE)	+= sata_xgene.o
 
 # SFF w/ custom DMA
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
diff --git a/drivers/ata/sata_xgene.c b/drivers/ata/sata_xgene.c
new file mode 100644
index 0000000..2e9da35
--- /dev/null
+++ b/drivers/ata/sata_xgene.c
@@ -0,0 +1,630 @@
+/*
+ * AppliedMicro X-Gene SoC SATA Host Controller Driver
+ *
+ * Copyright (c) 2014, Applied Micro Circuits Corporation
+ * Author: Loc Ho <lho@apm.com>
+ *         Tuan Phan <tphan@apm.com>
+ *         Suman Tripathi <stripathi@apm.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/phy/phy.h>
+#include "ahci.h"
+
+/* Controller who PHY shared with SGMII Ethernet PHY */
+#define XGENE_AHCI_SGMII_DTS		"apm,xgene-ahci-sgmii"
+
+/* Controller who PHY (internal reference clock macro) shared with PCIe */
+#define XGENE_AHCI_PCIE_DTS		"apm,xgene-ahci-pcie"
+
+/* Max # of disk per a controller */
+#define MAX_AHCI_CHN_PERCTR		2
+
+#define SATA_ENET_MUX_OFFSET		0x00007000
+#define SATA_DIAG_OFFSET		0x0000D000
+#define SATA_GLB_OFFSET			0x0000D850
+#define SATA_SHIM_OFFSET		0x0000E000
+#define SATA_MASTER_OFFSET		0x0000F000
+#define SATA_PORT0_OFFSET		0x00000100
+#define SATA_PORT1_OFFSET		0x00000180
+
+/* MUX CSR */
+#define SATA_ENET_CONFIG_REG		0x00000000
+#define  CFG_SATA_ENET_SELECT_MASK	0x00000001
+
+/* SATA host controller CSR */
+#define SLVRDERRATTRIBUTES		0x00000000
+#define SLVWRERRATTRIBUTES		0x00000004
+#define MSTRDERRATTRIBUTES		0x00000008
+#define MSTWRERRATTRIBUTES		0x0000000c
+#define BUSCTLREG			0x00000014
+#define IOFMSTRWAUX			0x00000018
+#define INTSTATUSMASK			0x0000002c
+#define ERRINTSTATUS			0x00000030
+#define ERRINTSTATUSMASK		0x00000034
+
+/* SATA host AHCI CSR */
+#define PORTCFG				0x000000a4
+#define  PORTADDR_SET(dst, src) \
+		(((dst) & ~0x0000003f) | (((u32)(src)) & 0x0000003f))
+#define PORTPHY1CFG		0x000000a8
+#define PORTPHY1CFG_FRCPHYRDY_SET(dst, src) \
+		(((dst) & ~0x00100000) | (((u32)(src) << 0x14) & 0x00100000))
+#define PORTPHY2CFG			0x000000ac
+#define PORTPHY3CFG			0x000000b0
+#define PORTPHY4CFG			0x000000b4
+#define PORTPHY5CFG			0x000000b8
+#define SCTL0				0x0000012C
+#define PORTPHY5CFG_RTCHG_SET(dst, src) \
+		(((dst) & ~0xfff00000) | (((u32)(src) << 0x14) & 0xfff00000))
+#define PORTAXICFG_EN_CONTEXT_SET(dst, src) \
+		(((dst) & ~0x01000000) | (((u32)(src) << 0x18) & 0x01000000))
+#define PORTAXICFG			0x000000bc
+#define PORTAXICFG_OUTTRANS_SET(dst, src) \
+		(((dst) & ~0x00f00000) | (((u32)(src) << 0x14) & 0x00f00000))
+
+/* SATA host controller slave CSR */
+#define INT_SLV_TMOMASK			0x00000010
+
+/* SATA global diagnostic CSR */
+#define CFG_MEM_RAM_SHUTDOWN		0x00000070
+#define BLOCK_MEM_RDY			0x00000074
+
+struct xgene_ahci_context {
+	struct ahci_host_priv  hpriv;
+	struct device *dev;
+	int irq;
+	void __iomem *csr_base;		/* CSR base address of IP */
+	void __iomem *mmio_base;	/* AHCI I/O base address */
+
+	struct phy *phy;
+};
+
+static int xgene_ahci_get_channel(struct ata_host *host, struct ata_port *port)
+{
+	int i;
+	for (i = 0; i < host->n_ports; i++)
+		if (host->ports[i] == port)
+			return i;
+	return -1;
+}
+
+static int xgene_ahci_init_memram(struct xgene_ahci_context *ctx)
+{
+	void __iomem *diagcsr = ctx->csr_base + SATA_DIAG_OFFSET;
+	int try;
+	u32 val;
+
+	val = readl(diagcsr + CFG_MEM_RAM_SHUTDOWN);
+	if (val == 0) {
+		dev_dbg(ctx->dev, "memory already released from shutdown\n");
+		return 0;
+	}
+	dev_dbg(ctx->dev, "Release memory from shutdown\n");
+	/* SATA controller memory in shutdown. Remove from shutdown. */
+	writel(0x0, diagcsr + CFG_MEM_RAM_SHUTDOWN);
+	readl(diagcsr + CFG_MEM_RAM_SHUTDOWN); /* Force a barrier */
+
+	/* Check for at least ~1ms */
+	try = 1000;
+	do {
+		val = readl(diagcsr + BLOCK_MEM_RDY);
+		if (val != 0xFFFFFFFF)
+			usleep_range(1, 100);
+	} while (val != 0xFFFFFFFF && try-- > 0);
+	if (try <= 0) {
+		dev_err(ctx->dev, "failed to release memory from shutdown\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+
+/*
+ * Custom Query ID command
+ *
+ * Due to HW errata, we must stop and re-start the port state machine after
+ * read ID command.
+ */
+static unsigned int xgene_ahci_read_id(struct ata_device *dev,
+				       struct ata_taskfile *tf, u16 *id)
+{
+	u32 err_mask;
+	void __iomem *port_mmio = ahci_port_base(dev->link->ap);
+
+	err_mask = ata_do_dev_read_id(dev, tf, id);
+	if (err_mask)
+		return err_mask;
+
+	/* Mask reserved area. Bit78 spec of Link Power Management
+	 * bit15-8: reserved
+	 * bit7: NCQ autosence
+	 * bit6: Software settings preservation supported
+	 * bit5: reserved
+	 * bit4: In-order sata delivery supported
+	 * bit3: DIPM requests supported
+	 * bit2: DMA Setup FIS Auto-Activate optimization supported
+	 * bit1: DMA Setup FIX non-Zero buffer offsets supported
+	 * bit0: Reserved
+	 *
+	 * Clear reserved bit (DEVSLP bit) as we don't support DEVSLP
+	 */
+	id[78] &= 0x00FF;
+
+	/* Restart the port if requred due to HW errata */
+	if (!readl(port_mmio + PORT_CMD_ISSUE)) {
+		writel(PORT_CMD_FIS_RX, port_mmio + PORT_CMD);
+		readl(port_mmio + PORT_CMD);	/* Force a barrier */
+		writel(PORT_CMD_FIS_RX | PORT_CMD_START, port_mmio + PORT_CMD);
+		readl(port_mmio + PORT_CMD);	/* Force a barrier */
+	}
+	return 0;
+}
+
+static void xgene_ahci_force_phy_rdy(struct xgene_ahci_context *ctx,
+				     int channel, int force)
+{
+	void __iomem *mmio = ctx->mmio_base;
+	u32 val;
+
+	val = readl(mmio + PORTCFG);
+	val = PORTADDR_SET(val, channel == 0 ? 2 : 3);
+	writel(val, mmio + PORTCFG);
+	readl(mmio + PORTCFG);	/* Force a barrier */
+	val = readl(mmio + PORTPHY1CFG);
+	val = PORTPHY1CFG_FRCPHYRDY_SET(val, force);
+	writel(val, mmio + PORTPHY1CFG);
+}
+
+static void xgene_ahci_set_phy_cfg(struct xgene_ahci_context *ctx, int channel)
+{
+	void __iomem *mmio = ctx->mmio_base;
+	u32 val;
+
+	dev_dbg(ctx->dev, "port configure mmio 0x%p channel %d\n",
+		mmio, channel);
+	val = readl(mmio + PORTCFG);
+	val = PORTADDR_SET(val, channel == 0 ? 2 : 3);
+	writel(val, mmio + PORTCFG);
+	readl(mmio + PORTCFG);  /* Force a barrier */
+	/* Disable fix rate */
+	writel(0x0001fffe, mmio + PORTPHY1CFG);
+	readl(mmio + PORTPHY1CFG); /* Force a barrier */
+	writel(0x5018461c, mmio + PORTPHY2CFG);
+	readl(mmio + PORTPHY2CFG); /* Force a barrier */
+	writel(0x1c081907, mmio + PORTPHY3CFG);
+	readl(mmio + PORTPHY3CFG); /* Force a barrier */
+	writel(0x1c080815, mmio + PORTPHY4CFG);
+	readl(mmio + PORTPHY4CFG); /* Force a barrier */
+	/* Set window negotiation */
+	val = readl(mmio + PORTPHY5CFG);
+	val = PORTPHY5CFG_RTCHG_SET(val, 0x300);
+	writel(val, mmio + PORTPHY5CFG);
+	readl(mmio + PORTPHY5CFG); /* Force a barrier */
+	val = readl(mmio + PORTAXICFG);
+	val = PORTAXICFG_EN_CONTEXT_SET(val, 0x1); /* Enable context mgmt */
+	val = PORTAXICFG_OUTTRANS_SET(val, 0xe); /* Set outstanding */
+	writel(val, mmio + PORTAXICFG);
+	readl(mmio + PORTAXICFG); /* Force a barrier */
+}
+
+static int xgene_ahci_phy_restart(struct ata_link *link)
+{
+	struct ata_port *port = link->ap;
+	struct ata_host *host = port->host;
+	struct xgene_ahci_context *ctx = host->private_data;
+	int channel;
+
+	channel = xgene_ahci_get_channel(host, port);
+	if (channel < 0 || channel >= MAX_AHCI_CHN_PERCTR)
+		return -EINVAL;
+	xgene_ahci_force_phy_rdy(ctx, channel, 1);
+	xgene_ahci_force_phy_rdy(ctx, channel, 0);
+	return 0;
+}
+
+static int xgene_ahci_do_hardreset(struct ata_link *link,
+				   unsigned long deadline, bool *online)
+{
+	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
+	struct ata_port *ap = link->ap;
+	struct xgene_ahci_context *ctx = ap->host->private_data;
+	struct ahci_port_priv *pp = ap->private_data;
+	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ata_taskfile tf;
+	int first_time = 1;
+	int rc;
+	u32 val;
+	int chan;
+	int i;
+
+	chan = xgene_ahci_get_channel(ap->host, ap);
+
+hardreset_retry:
+	/* clear D2H reception area to properly wait for D2H FIS */
+	ata_tf_init(link->device, &tf);
+	tf.command = 0x80;
+	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
+	rc = sata_link_hardreset(link, timing, deadline, online,
+				 ahci_check_ready);
+
+	if (*online) {
+		/* Check to ensure that the disk comes up in matching speed */
+		if (first_time) {
+			u32 gen_speed;
+
+			first_time = 0;
+			sata_scr_read(link, SCR_STATUS, &gen_speed);
+			gen_speed = (gen_speed >> 4) & 0xf;
+			if (gen_speed == 1 || gen_speed == 2) {
+				/* For Gen2/1 and first time, let's check again
+				 * with Gen2/1 PHY to ensure actual Gen2/1 disk.
+				 */
+				phy_set_speed(ctx->phy, chan,
+					      gen_speed == 2 ? 3000000000ULL :
+							       1500000000ULL);
+				xgene_ahci_phy_restart(link);
+				goto hardreset_retry;
+			}
+		}
+
+		/* Clear SER_DISPARITY/SER_10B_8B_ERR if set due to errata */
+		for (i = 0; i < 5; i++) {
+			/* Check if error bit set */
+			val = readl(port_mmio + PORT_SCR_ERR);
+			if (!(val & (SERR_DISPARITY | SERR_10B_8B_ERR)))
+				break;
+			/* Clear any error due to errata */
+			xgene_ahci_force_phy_rdy(ctx, chan, 1);
+			/* Reset the PHY Rx path */
+			phy_set_speed(ctx->phy, chan, 0);
+			xgene_ahci_force_phy_rdy(ctx, chan, 0);
+			/* Clear all errors */
+			val = readl(port_mmio + PORT_SCR_ERR);
+			writel(val, port_mmio + PORT_SCR_ERR);
+		}
+	}
+
+	/* clear all errors if any pending */
+	val = readl(port_mmio + PORT_SCR_ERR);
+	writel(val, port_mmio + PORT_SCR_ERR);
+
+	return rc;
+}
+
+static int xgene_ahci_hardreset(struct ata_link *link, unsigned int *class,
+				unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	bool online;
+	int rc;
+	int portcmd_saved;
+	u32 portclb_saved;
+	u32 portclbhi_saved;
+	u32 portrxfis_saved;
+	u32 portrxfishi_saved;
+
+	/* As hardreset reset these CSR, let save it to restore later */
+	portcmd_saved = readl(port_mmio + PORT_CMD);
+	portclb_saved = readl(port_mmio + PORT_LST_ADDR);
+	portclbhi_saved = readl(port_mmio + PORT_LST_ADDR_HI);
+	portrxfis_saved = readl(port_mmio + PORT_FIS_ADDR);
+	portrxfishi_saved = readl(port_mmio + PORT_FIS_ADDR_HI);
+
+	ahci_stop_engine(ap);
+
+	rc = xgene_ahci_do_hardreset(link, deadline, &online);
+
+	/* As controller hardreset clear them, let restore them */
+	writel(portcmd_saved, port_mmio + PORT_CMD);
+	writel(portclb_saved, port_mmio + PORT_LST_ADDR);
+	writel(portclbhi_saved, port_mmio + PORT_LST_ADDR_HI);
+	writel(portrxfis_saved, port_mmio + PORT_FIS_ADDR);
+	writel(portrxfishi_saved, port_mmio + PORT_FIS_ADDR_HI);
+
+	ahci_start_engine(ap);
+
+	if (online)
+		*class = ahci_dev_classify(ap);
+
+	return rc;
+}
+
+static struct ata_port_operations xgene_ahci_ops = {
+	.inherits = &ahci_ops,
+	.hardreset = xgene_ahci_hardreset,
+	.read_id = xgene_ahci_read_id,
+};
+
+static const struct ata_port_info xgene_ahci_port_info[] = {
+	{
+	 .flags = AHCI_FLAG_COMMON,
+	 .pio_mask = ATA_PIO4,
+	 .udma_mask = ATA_UDMA6,
+	 .port_ops = &xgene_ahci_ops,
+	 },
+};
+
+static struct scsi_host_template xgene_ahci_sht = {
+	AHCI_SHT("XGene-ahci"),
+};
+
+static int xgene_ahci_hw_init(struct xgene_ahci_context *hpriv)
+{
+	int i;
+	int rc;
+	u32 val;
+
+	/* Remove IP RAM out of shutdown */
+	rc = xgene_ahci_init_memram(hpriv);
+	if (rc)
+		return rc;
+
+	for (i = 0; i < MAX_AHCI_CHN_PERCTR; i++)
+		xgene_ahci_set_phy_cfg(hpriv, i);
+
+	/* AXI disable Mask */
+	writel(0xffffffff, hpriv->mmio_base + HOST_IRQ_STAT);
+	readl(hpriv->mmio_base + HOST_IRQ_STAT); /* Force a barrier */
+	writel(0, hpriv->csr_base + INTSTATUSMASK);
+	readl(hpriv->csr_base + INTSTATUSMASK); /* Force a barrier */
+	dev_dbg(hpriv->dev, "top level interrupt mask 0x%X value 0x%08X\n",
+		INTSTATUSMASK, val);
+
+	writel(0x0, hpriv->csr_base + ERRINTSTATUSMASK);
+	readl(hpriv->csr_base + ERRINTSTATUSMASK); /* Force a barrier */
+	writel(0x0, hpriv->csr_base + SATA_SHIM_OFFSET + INT_SLV_TMOMASK);
+	readl(hpriv->csr_base + SATA_SHIM_OFFSET + INT_SLV_TMOMASK);
+
+	/* Enable AXI Interrupt */
+	writel(0xffffffff, hpriv->csr_base + SLVRDERRATTRIBUTES);
+	writel(0xffffffff, hpriv->csr_base + SLVWRERRATTRIBUTES);
+	writel(0xffffffff, hpriv->csr_base + MSTRDERRATTRIBUTES);
+	writel(0xffffffff, hpriv->csr_base + MSTWRERRATTRIBUTES);
+
+	/* Enable coherency */
+	val = readl(hpriv->csr_base + BUSCTLREG);
+	val &= ~0x00000002;     /* Enable write coherency */
+	val &= ~0x00000001;     /* Enable read coherency */
+	writel(val, hpriv->csr_base + BUSCTLREG);
+
+	val = readl(hpriv->csr_base + IOFMSTRWAUX);
+	val |= (1 << 3);        /* Enable read coherency */
+	val |= (1 << 9);        /* Enable write coherency */
+	writel(val, hpriv->csr_base + IOFMSTRWAUX);
+	val = readl(hpriv->csr_base + IOFMSTRWAUX);
+	dev_dbg(hpriv->dev, "coherency 0x%X value 0x%08X\n",
+		IOFMSTRWAUX, val);
+
+	return rc;
+}
+
+static int xgene_ahci_mux_select(struct xgene_ahci_context *ctx)
+{
+	void *mux_csr = ctx->csr_base + SATA_ENET_MUX_OFFSET;
+	u32 val;
+
+	dev_dbg(ctx->dev, "switch the MUX to SATA\n");
+	val = readl(mux_csr + SATA_ENET_CONFIG_REG);
+	val &= ~CFG_SATA_ENET_SELECT_MASK;
+	writel(val, mux_csr + SATA_ENET_CONFIG_REG);
+	val = readl(mux_csr + SATA_ENET_CONFIG_REG);
+	return val & CFG_SATA_ENET_SELECT_MASK ? -1 : 0;
+}
+
+static int xgene_ahci_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct xgene_ahci_context *hpriv;
+	struct ata_port_info pi = xgene_ahci_port_info[0];
+	const struct ata_port_info *ppi[] = { &pi, NULL };
+	struct ata_host *host;
+	struct resource *res;
+	int n_ports;
+	int rc = 0;
+	int i;
+
+	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
+	if (!hpriv) {
+		dev_err(dev, "can't allocate host context\n");
+		return -ENOMEM;
+	}
+
+	hpriv->dev = dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "no MMIO space\n");
+		return -EINVAL;
+	}
+
+	hpriv->mmio_base = devm_ioremap_resource(dev, res);
+	if (!hpriv->mmio_base) {
+		dev_err(dev, "can't map %pR\n", res);
+		return -ENOMEM;
+	}
+
+	hpriv->hpriv.mmio = hpriv->mmio_base;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!res) {
+		dev_err(dev, "no csr space\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Can't use devm_ioremap_resource due to overlapping region.
+	 * 0xYYYY.0000 - host core
+	 * 0xYYYY.7000 - Mux (if applicable)
+	 * 0xYYYY.A000 - PHY indirect access
+	 * 0xYYYY.C000 - Clock
+	 * 0xYYYY.D000 - RAM shutdown removal
+	 * As we map the entire region as one, it overlaps with the PHY driver.
+	 */
+	hpriv->csr_base = devm_ioremap(dev, res->start, resource_size(res));
+	if (!hpriv->csr_base) {
+		dev_err(dev, "can't map %pR\n", res);
+		return -ENOMEM;
+	}
+
+	dev_dbg(dev, "VAddr 0x%p Mmio VAddr 0x%p\n",
+		hpriv->csr_base, hpriv->mmio_base);
+
+	hpriv->irq = platform_get_irq(pdev, 0);
+	if (hpriv->irq <= 0) {
+		dev_err(dev, "no IRQ\n");
+		return -EINVAL;
+	}
+
+	/* Select ATA */
+	if (of_device_is_compatible(pdev->dev.of_node,
+		XGENE_AHCI_SGMII_DTS)) {
+		if (xgene_ahci_mux_select(hpriv)) {
+			dev_err(dev, "SATA mux selection failed\n");
+			return -ENODEV;
+		}
+	}
+
+	hpriv->hpriv.clk = clk_get(dev, NULL);
+	if (IS_ERR(hpriv->hpriv.clk)) {
+		dev_err(dev, "no clock\n");
+	} else {
+		/* HW requires toggle of the clock */
+		clk_prepare_enable(hpriv->hpriv.clk);
+		clk_disable_unprepare(hpriv->hpriv.clk);
+		rc = clk_prepare_enable(hpriv->hpriv.clk);
+		if (rc) {
+			dev_err(dev, "clock prepare enable failed\n");
+			goto error;
+		}
+	}
+
+	/* Configure the PHY */
+	hpriv->phy = devm_phy_get(dev, "sata-6g");
+	if (!hpriv->phy) {
+		dev_err(dev, "no PHY available\n");
+		rc = -ENODEV;
+		goto error;
+	}
+
+	rc = phy_init(hpriv->phy);
+	if (rc) {
+		dev_err(dev, "PHY initialize failed %d\n", rc);
+		goto error;
+	}
+
+	/* Configure the host controller */
+	xgene_ahci_hw_init(hpriv);
+
+	/* Setup AHCI host priv structure */
+	ahci_save_initial_config(dev, &hpriv->hpriv, 0, 0);
+
+	/* prepare host */
+	if (hpriv->hpriv.cap & HOST_CAP_NCQ)
+		pi.flags |= ATA_FLAG_NCQ;
+
+	ahci_set_em_messages(&hpriv->hpriv, &pi);
+
+	/*
+	 * CAP.NP sometimes indicate the index of the last enabled
+	 * port, at other times, that of the last possible port, so
+	 * determining the maximum port number requires looking at
+	 * both CAP.NP and port_map.
+	 */
+	n_ports = max(ahci_nr_ports(hpriv->hpriv.cap),
+		      fls(hpriv->hpriv.port_map));
+
+	host = ata_host_alloc_pinfo(dev, ppi, n_ports);
+	if (!host) {
+		rc = -ENOMEM;
+		goto error;
+	}
+
+	host->private_data = hpriv;
+
+	if (!(hpriv->hpriv.cap & HOST_CAP_SSS) || ahci_ignore_sss)
+		host->flags |= ATA_HOST_PARALLEL_SCAN;
+	else
+		dev_warn(dev, "ahci: SSS flag set, parallel bus scan disabled\n");
+
+	if (pi.flags & ATA_FLAG_EM)
+		ahci_reset_em(host);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		ata_port_desc(ap, "port 0x%x", 0x100 + ap->port_no * 0x80);
+
+		/* set enclosure management message type */
+		if (ap->flags & ATA_FLAG_EM)
+			ap->em_message_type = hpriv->hpriv.em_msg_type;
+
+		/* disabled/not-implemented port */
+		if (!(hpriv->hpriv.port_map & (1 << i)))
+			ap->ops = &ata_dummy_port_ops;
+	}
+
+	rc = ahci_reset_controller(host);
+	if (rc)
+		goto error;
+
+	ahci_init_controller(host);
+
+	/* Setup DMA mask */
+	rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
+	if (rc) {
+		dev_err(dev, "Unable to set dma mask\n");
+		goto error;
+	}
+
+	rc = ata_host_activate(host, hpriv->irq, ahci_interrupt,
+			       IRQF_SHARED, &xgene_ahci_sht);
+	if (rc)
+		goto error;
+
+	dev_dbg(dev, "X-Gene SATA host controller initialized\n");
+	return 0;
+
+error:
+	return rc;
+}
+
+static const struct of_device_id xgene_ahci_of_match[] = {
+	{.compatible = XGENE_AHCI_SGMII_DTS,},
+	{.compatible = XGENE_AHCI_PCIE_DTS,},
+	{},
+};
+MODULE_DEVICE_TABLE(of, xgene_ahci_of_match);
+
+static struct platform_driver xgene_ahci_driver = {
+	.driver = {
+		   .name = "xgene-ahci",
+		   .owner = THIS_MODULE,
+		   .of_match_table = xgene_ahci_of_match,
+	},
+	.probe = xgene_ahci_probe,
+};
+
+module_platform_driver(xgene_ahci_driver);
+
+MODULE_DESCRIPTION("APM X-Gene AHCI SATA driver");
+MODULE_AUTHOR("Loc Ho <lho@apm.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.4");
-- 
1.5.5

