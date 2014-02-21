From: Loc Ho <lho@apm.com>
Subject: [PATCH v12 2/3] ata: Add APM X-Gene SoC AHCI SATA host controller driver
Date: Fri, 21 Feb 2014 10:47:32 -0700
Message-ID: <1393004853-25994-3-git-send-email-lho@apm.com>
References: <1393004853-25994-1-git-send-email-lho@apm.com>
 <1393004853-25994-2-git-send-email-lho@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1393004853-25994-2-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds support for the APM X-Gene SoC AHCI SATA host controller
driver. It requires the corresponding APM X-Gene SoC PHY driver.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/Kconfig      |    8 +
 drivers/ata/Makefile     |    1 +
 drivers/ata/ahci_xgene.c |  540 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 549 insertions(+), 0 deletions(-)
 create mode 100644 drivers/ata/ahci_xgene.c

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index cc67cc0..174e398 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -115,6 +115,14 @@ config AHCI_SUNXI
 
 	  If unsure, say N.
 
+config AHCI_XGENE
+	tristate "APM X-Gene 6.0Gbps AHCI SATA host controller support"
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
index 246050b..72b423b 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
 obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
 obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o
 obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o
+obj-$(CONFIG_AHCI_XGENE)	+= ahci_xgene.o
 
 # SFF w/ custom DMA
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
new file mode 100644
index 0000000..be0c4fc
--- /dev/null
+++ b/drivers/ata/ahci_xgene.c
@@ -0,0 +1,540 @@
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
+#include <linux/ahci_platform.h>
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
+#define pdata_to_ctx(x) container_of(x, struct xgene_ahci_context, plat_data)
+
+struct xgene_ahci_context {
+	struct ahci_platform_data plat_data;
+	struct ahci_host_priv *hpriv;
+	struct device *dev;
+	void __iomem *csr_base;		/* CSR base address of IP */
+	struct phy *phy;
+};
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
+/**
+ * Custom Query ID command
+ *
+ * Due to HW errata, we must stop and re-start the port state machine after
+ * read ID command. Also disable support for DEVSLP as hardware don't support
+ * it.
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
+	/*
+	 * Mask reserved area. Bit78 spec of Link Power Management
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
+	/* Restart the port if required due to HW errata */
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
+	void __iomem *mmio = ctx->hpriv->mmio;
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
+	void __iomem *mmio = ctx->hpriv->mmio;
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
+	struct ahci_host_priv *hpriv = port->host->private_data;
+	struct xgene_ahci_context *ctx = pdata_to_ctx(hpriv->plat_data);
+
+	xgene_ahci_force_phy_rdy(ctx, port->port_no, 1);
+	xgene_ahci_force_phy_rdy(ctx, port->port_no, 0);
+	return 0;
+}
+
+static int xgene_ahci_do_hardreset(struct ata_link *link,
+				   unsigned long deadline, bool *online)
+{
+	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
+	struct ata_port *ap = link->ap;
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct xgene_ahci_context *ctx = pdata_to_ctx(hpriv->plat_data);
+	struct ahci_port_priv *pp = ap->private_data;
+	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ata_taskfile tf;
+	int first_time = 1;
+	int rc;
+	u32 val;
+	int i;
+
+hardreset_retry:
+	/* clear D2H reception area to properly wait for D2H FIS */
+	ata_tf_init(link->device, &tf);
+	tf.command = ATA_BUSY;
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
+				/*
+				 * For Gen2/1 and first time, let's check again
+				 * with Gen2/1 PHY to ensure actual Gen2/1 disk.
+				 */
+				phy_set_speed(ctx->phy, ap->port_no,
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
+			xgene_ahci_force_phy_rdy(ctx, ap->port_no, 1);
+			/* Reset the PHY Rx path */
+			phy_set_speed(ctx->phy, ap->port_no, 0);
+			xgene_ahci_force_phy_rdy(ctx, ap->port_no, 0);
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
+        struct ahci_host_priv *hpriv = ap->host->private_data;
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
+	hpriv->start_engine(ap);
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
+static const struct ata_port_info xgene_ahci_port_info = {
+	AHCI_HFLAGS(AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ),
+	.flags = AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
+	.pio_mask = ATA_PIO4,
+	.udma_mask = ATA_UDMA6,
+	.port_ops = &xgene_ahci_ops,
+};
+
+static int xgene_ahci_hw_init(struct ahci_host_priv *hpriv)
+{
+	struct xgene_ahci_context *ctx = pdata_to_ctx(hpriv->plat_data);
+	int i;
+	int rc;
+	u32 val;
+
+	/* Remove IP RAM out of shutdown */
+	rc = xgene_ahci_init_memram(ctx);
+	if (rc)
+		return rc;
+
+	for (i = 0; i < MAX_AHCI_CHN_PERCTR; i++)
+		xgene_ahci_set_phy_cfg(ctx, i);
+
+	/* AXI disable Mask */
+	writel(0xffffffff, hpriv->mmio + HOST_IRQ_STAT);
+	readl(hpriv->mmio + HOST_IRQ_STAT); /* Force a barrier */
+	writel(0, ctx->csr_base + INTSTATUSMASK);
+	readl(ctx->csr_base + INTSTATUSMASK); /* Force a barrier */
+	dev_dbg(ctx->dev, "top level interrupt mask 0x%X value 0x%08X\n",
+		INTSTATUSMASK, val);
+
+	writel(0x0, ctx->csr_base + ERRINTSTATUSMASK);
+	readl(ctx->csr_base + ERRINTSTATUSMASK); /* Force a barrier */
+	writel(0x0, ctx->csr_base + SATA_SHIM_OFFSET + INT_SLV_TMOMASK);
+	readl(ctx->csr_base + SATA_SHIM_OFFSET + INT_SLV_TMOMASK);
+
+	/* Enable AXI Interrupt */
+	writel(0xffffffff, ctx->csr_base + SLVRDERRATTRIBUTES);
+	writel(0xffffffff, ctx->csr_base + SLVWRERRATTRIBUTES);
+	writel(0xffffffff, ctx->csr_base + MSTRDERRATTRIBUTES);
+	writel(0xffffffff, ctx->csr_base + MSTWRERRATTRIBUTES);
+
+	/* Enable coherency */
+	val = readl(ctx->csr_base + BUSCTLREG);
+	val &= ~0x00000002;     /* Enable write coherency */
+	val &= ~0x00000001;     /* Enable read coherency */
+	writel(val, ctx->csr_base + BUSCTLREG);
+
+	val = readl(ctx->csr_base + IOFMSTRWAUX);
+	val |= (1 << 3);        /* Enable read coherency */
+	val |= (1 << 9);        /* Enable write coherency */
+	writel(val, ctx->csr_base + IOFMSTRWAUX);
+	val = readl(ctx->csr_base + IOFMSTRWAUX);
+	dev_dbg(ctx->dev, "coherency 0x%X value 0x%08X\n",
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
+	struct ahci_host_priv *hpriv;
+	struct xgene_ahci_context *hplat_data;
+	struct resource *res;
+	int rc;
+
+	hpriv = ahci_platform_get_resources(pdev);
+	if (IS_ERR(hpriv))
+		return PTR_ERR(hpriv);
+
+	hplat_data = devm_kzalloc(dev, sizeof(*hplat_data), GFP_KERNEL);
+	if (!hplat_data) {
+		dev_err(dev, "can't allocate host context\n");
+		return -ENOMEM;
+	}
+	hpriv->plat_data = hplat_data;
+	hplat_data->hpriv = hpriv;
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
+	hplat_data->csr_base = devm_ioremap(dev, res->start,
+					    resource_size(res));
+	if (!hplat_data->csr_base) {
+		dev_err(dev, "can't map %pR\n", res);
+		return -ENOMEM;
+	}
+
+	dev_dbg(dev, "VAddr 0x%p Mmio VAddr 0x%p\n", hplat_data->csr_base,
+		hpriv->mmio);
+
+	/* Select ATA */
+	if (of_device_is_compatible(pdev->dev.of_node,
+		XGENE_AHCI_SGMII_DTS)) {
+		if (xgene_ahci_mux_select(hplat_data)) {
+			dev_err(dev, "SATA mux selection failed\n");
+			return -ENODEV;
+		}
+	}
+
+	rc = ahci_platform_enable_resources(hpriv);
+	if (rc)
+		goto put_resources;
+
+	/* HW requires toggle of the clock */
+	ahci_platform_disable_clks(hpriv);
+	rc = ahci_platform_enable_clks(hpriv);
+	if (rc)
+		goto put_resources;
+
+	/* Configure the PHY */
+	hplat_data->phy = devm_phy_get(dev, "sata-6g");
+	if (!hplat_data->phy) {
+		dev_err(dev, "no PHY available\n");
+		rc = -ENODEV;
+		goto disable_resources;
+	}
+
+	rc = phy_init(hplat_data->phy);
+	if (rc) {
+		dev_err(dev, "PHY initialize failed %d\n", rc);
+		goto disable_resources;
+	}
+
+	/* Configure the host controller */
+	xgene_ahci_hw_init(hpriv);
+
+	/* Setup DMA mask - 32 for 32-bit system and 64 for 64-bit system */
+	rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(8*sizeof(void *)));
+	if (rc) {
+		dev_err(dev, "Unable to set dma mask\n");
+		goto disable_resources;
+	}
+
+	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info, 0, 0);
+	if (rc)
+		goto disable_resources;
+
+	dev_dbg(dev, "X-Gene SATA host controller initialized\n");
+	return 0;
+
+disable_resources:
+	ahci_platform_disable_resources(hpriv);
+put_resources:
+	ahci_platform_put_resources(hpriv);
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
+		.name = "xgene-ahci",
+		.owner = THIS_MODULE,
+		.of_match_table = xgene_ahci_of_match,
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

