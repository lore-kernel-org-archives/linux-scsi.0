From: Loc Ho <lho@apm.com>
Subject: [PATCH 3/5] ata: Add APM X-Gene SATA driver
Date: Fri,  8 Nov 2013 15:30:36 -0700
Message-ID: <1383949838-25106-4-git-send-email-lho@apm.com>
References: <1383949838-25106-1-git-send-email-lho@apm.com>
 <1383949838-25106-2-git-send-email-lho@apm.com>
 <1383949838-25106-3-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1383949838-25106-3-git-send-email-lho@apm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: tj@kernel.org, linux-scsi@vger.kernel.org
Cc: Suman Tripathi <stripathi@apm.com>, jcm@redhat.com, devicetree-discuss@lists.ozlabs.org, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/Kconfig      |    7 +
 drivers/ata/Makefile     |    2 +
 drivers/ata/sata_xgene.c | 1385 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/sata_xgene.h |  112 ++++
 4 files changed, 1506 insertions(+), 0 deletions(-)
 create mode 100644 drivers/ata/sata_xgene.c
 create mode 100644 drivers/ata/sata_xgene.h

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 4e73772..41b9da3 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -106,6 +106,13 @@ config AHCI_IMX
 
 	  If unsure, say N.
 
+config SATA_XGENE
+	tristate "APM X-Gene 6.0Gbps SATA support"
+	depends on SATA_AHCI_PLATFORM
+	default y if ARM64
+	help
+	  This option enables support for APM X-Gene SoC SATA controller.
+
 config SATA_FSL
 	tristate "Freescale 3.0Gbps SATA support"
 	depends on FSL_SOC
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 46518c6..022f9d1 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -11,6 +11,8 @@ obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
 obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
 obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
 obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o
+sata-xgene-objs := sata_xgene.o sata_xgene_serdes.o
+obj-$(CONFIG_SATA_XGENE)	+= sata-xgene.o
 
 # SFF w/ custom DMA
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
diff --git a/drivers/ata/sata_xgene.c b/drivers/ata/sata_xgene.c
new file mode 100644
index 0000000..93ccf89
--- /dev/null
+++ b/drivers/ata/sata_xgene.c
@@ -0,0 +1,1385 @@
+/*
+ * AppliedMicro X-Gene SoC SATA Driver
+ *
+ * Copyright (c) 2013, Applied Micro Circuits Corporation
+ * Author: Loc Ho <lho@apm.com>
+ *         Tuan Phan <tphan@apm.com>
+ *         Suman Tripathi <stripathi@apm.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
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
+#include <linux/acpi.h>
+#include <linux/efi.h>
+#include "sata_xgene.h"
+
+#undef XGENE_DBG_CSR		/* Enable CSR read/write dumping */
+#ifdef XGENE_DBG_CSR
+#define XGENE_CSRDBG(fmt, args...)	\
+	printk(KERN_INFO "XGENESATA: " fmt "\n", ## args);
+#else
+#define XGENE_CSRDBG(fmt, args...)
+#endif
+
+/* Max # of disk per a controller */
+#define MAX_AHCI_CHN_PERCTR		2
+
+#define SATA_DIAG_OFFSET		0x0000D000
+#define SATA_GLB_OFFSET			0x0000D850
+#define SATA_SHIM_OFFSET		0x0000E000
+#define SATA_MASTER_OFFSET		0x0000F000
+#define SATA_PORT0_OFFSET		0x00000100
+#define SATA_PORT1_OFFSET		0x00000180
+
+/* SATA host controller CSR */
+#define SLVRDERRATTRIBUTES_ADDR		0x00000000
+#define SLVWRERRATTRIBUTES_ADDR		0x00000004
+#define MSTRDERRATTRIBUTES_ADDR		0x00000008
+#define MSTWRERRATTRIBUTES_ADDR		0x0000000c
+#define BUSCTLREG_ADDR			0x00000014
+#define  MSTAWAUX_COHERENT_BYPASS_SET(dst, src) \
+		(((dst) & ~0x00000002) | (((u32)(src)<<1) & 0x00000002))
+#define  MSTARAUX_COHERENT_BYPASS_SET(dst, src) \
+		(((dst) & ~0x00000001) | (((u32)(src)) & 0x00000001))
+#define IOFMSTRWAUX_ADDR		0x00000018
+#define INTSTATUSMASK_ADDR		0x0000002c
+#define ERRINTSTATUS_ADDR		0x00000030
+#define ERRINTSTATUSMASK_ADDR		0x00000034
+
+/* SATA host AHCI CSR */
+#define PORTCFG_ADDR			0x000000a4
+#define  PORTADDR_SET(dst, src) \
+		(((dst) & ~0x0000003f) | (((u32)(src)) & 0x0000003f))
+#define PORTPHY1CFG_ADDR		0x000000a8
+#define PORTPHY1CFG_FRCPHYRDY_SET(dst, src) \
+		(((dst) & ~0x00100000) | (((u32)(src) << 0x14) & 0x00100000))
+#define PORTPHY2CFG_ADDR		0x000000ac
+#define PORTPHY3CFG_ADDR		0x000000b0
+#define PORTPHY4CFG_ADDR		0x000000b4
+#define PORTPHY5CFG_ADDR		0x000000b8
+#define SCTL0_ADDR			0x0000012C
+#define PORTPHY5CFG_RTCHG_SET(dst, src) \
+		(((dst) & ~0xfff00000) | (((u32)(src) << 0x14) & 0xfff00000))
+#define PORTAXICFG_EN_CONTEXT_SET(dst, src) \
+		(((dst) & ~0x01000000) | (((u32)(src) << 0x18) & 0x01000000))
+#define PORTAXICFG_ADDR			0x000000bc
+#define PORTAXICFG_OUTTRANS_SET(dst, src) \
+		(((dst) & ~0x00f00000) | (((u32)(src) << 0x14) & 0x00f00000))
+
+/* SATA host controller slave CSR */
+#define INT_SLV_TMOMASK_ADDR		0x00000010
+
+/* SATA global diagnostic CSR */
+#define REGSPEC_CFG_MEM_RAM_SHUTDOWN_ADDR	0x00000070
+#define REGSPEC_BLOCK_MEM_RDY_ADDR		0x00000074
+
+/* AHBC IOB flush CSR */
+#define CFG_AMA_MODE_ADDR		0x0000e014
+#define  CFG_RD2WR_EN			0x00000002
+
+#define MAX_RETRY_COUNT			3
+#define SATA_RESET_MEM_RAM_TO		100000
+
+void xgene_ahci_in32(void *addr, u32 *val)
+{
+	*val = readl(addr);
+	XGENE_CSRDBG("SATAPHY CSR RD: 0x%p value: 0x%08x", addr, *val);
+}
+
+void xgene_ahci_out32(void *addr, u32 val)
+{
+	writel(val, addr);
+	XGENE_CSRDBG("SATAPHY CSR WR: 0x%p value: 0x%08x", addr, val);
+}
+
+void xgene_ahci_out32_flush(void *addr, u32 val)
+{
+	writel(val, addr);
+	XGENE_CSRDBG("SATAPHY CSR WR: 0x%p value: 0x%08x", addr, val);
+	val = readl(addr);
+}
+
+void xgene_ahci_delayus(unsigned long us)
+{
+	udelay(us);
+}
+
+void xgene_ahci_delayms(unsigned long us)
+{
+	mdelay(us);
+}
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
+int xgene_ahci_init_memram(struct xgene_ahci_context *ctx)
+{
+	void *diagcsr = ctx->csr_base + SATA_DIAG_OFFSET;
+	int timeout;
+	u32 val;
+
+	xgene_ahci_in32(diagcsr + REGSPEC_CFG_MEM_RAM_SHUTDOWN_ADDR, &val);
+	if (val == 0) {
+		dev_dbg(ctx->dev, "already clear memory shutdown\n");
+		return 0;
+	}
+	dev_dbg(ctx->dev, "clear controller %d memory shutdown\n", ctx->cid);
+	/* SATA controller memory in shutdown. Remove from shutdown. */
+	xgene_ahci_out32_flush(diagcsr + REGSPEC_CFG_MEM_RAM_SHUTDOWN_ADDR,
+				0x00);
+	timeout = SATA_RESET_MEM_RAM_TO;
+	do {
+		xgene_ahci_in32(diagcsr + REGSPEC_BLOCK_MEM_RDY_ADDR, &val);
+		if (val != 0xFFFFFFFF)
+			xgene_ahci_delayus(1);
+	} while (val != 0xFFFFFFFF && timeout-- > 0);
+	if (timeout <= 0) {
+		dev_err(ctx->dev, "failed to remove memory from shutdown\n");
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
+	struct ata_taskfile *tf, u16 *id)
+{
+	u32 err_mask;
+	struct ata_port *ap = dev->link->ap;
+	void *port_mmio = ahci_port_base(ap);
+	u32 data32;
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
+	data32 = readl(port_mmio + PORT_CMD_ISSUE);
+	if (data32 == 0x00000000) {
+		writel(PORT_CMD_FIS_RX, port_mmio + PORT_CMD);
+		readl(port_mmio + PORT_CMD);	/* flush */
+		writel(PORT_CMD_FIS_RX | PORT_CMD_START, port_mmio + PORT_CMD);
+		readl(port_mmio + PORT_CMD);	/* flush */
+	}
+	return 0;
+}
+
+static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_port_priv *pp = ap->private_data;
+
+	/* Keep track of the currently active link.  It will be used
+	 * in completion path to determine whether NCQ phase is in
+	 * progress.
+	 */
+	pp->active_link = qc->dev->link;
+
+	if (qc->tf.protocol == ATA_PROT_NCQ)
+		writel(1 << qc->tag, port_mmio + PORT_SCR_ACT);
+
+	if (pp->fbs_enabled && pp->fbs_last_dev != qc->dev->link->pmp) {
+		u32 fbs = readl(port_mmio + PORT_FBS);
+		fbs &= ~(PORT_FBS_DEV_MASK | PORT_FBS_DEC);
+		fbs |= qc->dev->link->pmp << PORT_FBS_DEV_OFFSET;
+		writel(fbs, port_mmio + PORT_FBS);
+		pp->fbs_last_dev = qc->dev->link->pmp;
+	}
+
+	writel(1 << qc->tag, port_mmio + PORT_CMD_ISSUE);
+
+	ahci_sw_activity(qc->dev->link);
+
+	/* For query ID command, restart the port if requred due to HW errata.
+	   This is needed when PMP is attached. */
+	if (qc->dev->link->pmp && qc->tf.command == ATA_CMD_ID_ATA &&
+	    readl(port_mmio + PORT_CMD_ISSUE) == 0x0) {
+		writel(PORT_CMD_FIS_RX, port_mmio + PORT_CMD);
+		readl(port_mmio + PORT_CMD);	/* flush */
+		writel(PORT_CMD_FIS_RX | PORT_CMD_START, port_mmio + PORT_CMD);
+		readl(port_mmio + PORT_CMD);	/* flush */
+	}
+
+	return 0;
+}
+
+static void xgene_ahci_enable_phy(struct xgene_ahci_context *ctx,
+	int channel, int enable)
+{
+	void *mmio = ctx->mmio_base;
+	u32 val;
+
+	xgene_ahci_in32(mmio + PORTCFG_ADDR, &val);
+	val = PORTADDR_SET(val, channel == 0 ? 2 : 3);
+	xgene_ahci_out32_flush(mmio + PORTCFG_ADDR, val);
+	xgene_ahci_in32(mmio + PORTPHY1CFG_ADDR, &val);
+	val = PORTPHY1CFG_FRCPHYRDY_SET(val, enable);
+	xgene_ahci_out32(mmio + PORTPHY1CFG_ADDR, val);
+}
+
+void xgene_ahci_set_phy_cfg(struct xgene_ahci_context *ctx, int channel)
+{
+	void *mmio = ctx->mmio_base;
+	u32 val;
+
+	dev_dbg(ctx->dev, "SATA%d.%d port configure mmio 0x%p channel %d\n",
+		ctx->cid, channel, mmio, channel);
+	xgene_ahci_in32(mmio + PORTCFG_ADDR, &val);
+	val = PORTADDR_SET(val, channel == 0 ? 2 : 3);
+	xgene_ahci_out32_flush(mmio + PORTCFG_ADDR, val);
+	/* Disable fix rate */
+	xgene_ahci_out32_flush(mmio + PORTPHY1CFG_ADDR, 0x0001fffe);
+	xgene_ahci_out32_flush(mmio + PORTPHY2CFG_ADDR, 0x5018461c);
+	xgene_ahci_out32_flush(mmio + PORTPHY3CFG_ADDR, 0x1c081907);
+	xgene_ahci_out32_flush(mmio + PORTPHY4CFG_ADDR, 0x1c080815);
+	xgene_ahci_in32(mmio + PORTPHY5CFG_ADDR, &val);
+	/* Window negotiation 0x800 to 0x400 */
+	val = PORTPHY5CFG_RTCHG_SET(val, 0x300);
+	xgene_ahci_out32(mmio + PORTPHY5CFG_ADDR, val);
+	xgene_ahci_in32(mmio + PORTAXICFG_ADDR, &val);
+	val = PORTAXICFG_EN_CONTEXT_SET(val, 0x1); /* enable context mgmt */
+	val = PORTAXICFG_OUTTRANS_SET(val, 0xe);   /* Outstanding */
+	xgene_ahci_out32_flush(mmio + PORTAXICFG_ADDR, val);
+}
+
+/* Restart the PHY in case of disparity error for Gen2/Gen1 disk only */
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
+	xgene_ahci_enable_phy(ctx, channel, 1);
+	xgene_ahci_enable_phy(ctx, channel, 0);
+	xgene_ahci_delayms(50); /* Allow serdes to get reflected */
+	return 0;
+}
+
+static int xgene_ahci_hardreset(struct ata_link *link, unsigned int *class,
+	unsigned long deadline)
+{
+	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
+	struct ata_taskfile tf;
+	bool online;
+	int rc;
+	struct ata_host *host = ap->host;
+	struct xgene_ahci_context *ctx = host->private_data;
+	int retry = 0;
+	u32 sstatus;
+	int channel;
+	int link_retry = 0;
+	void __iomem *port_mmio;
+	int portcmd_saved;
+	u32 portclb_saved;
+	u32 portclbhi_saved;
+	u32 portrxfis_saved;
+	u32 portrxfishi_saved;
+	u32 val;
+
+	channel = xgene_ahci_get_channel(host, ap);
+	if (channel >= MAX_AHCI_CHN_PERCTR) {
+		*class = ATA_DEV_NONE;
+		return 0;
+	}
+	ata_link_dbg(link, "SATA%d.%d APM hardreset\n", ctx->cid, channel);
+
+	/* As hardreset reset these CSR, let save it to restore later */
+	port_mmio = ahci_port_base(ap);
+	portcmd_saved = readl(port_mmio + PORT_CMD);
+	portclb_saved =  readl(port_mmio + PORT_LST_ADDR);
+	portclbhi_saved = readl(port_mmio + PORT_LST_ADDR_HI);
+	portrxfis_saved = readl(port_mmio + PORT_FIS_ADDR);
+	portrxfishi_saved = readl(port_mmio + PORT_FIS_ADDR_HI);
+	ata_link_dbg(link, "SATA%d.%d PORT_CMD 0x%08X\n", ctx->cid, channel,
+		portcmd_saved);
+
+	ahci_stop_engine(ap);
+
+hardreset_retry:
+	/* clear D2H reception area to properly wait for D2H FIS */
+	ata_tf_init(link->device, &tf);
+	tf.command = 0x80;
+	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
+	if (!xgene_ahci_is_A1())
+		xgene_ahci_serdes_set_pq(ctx, channel, 1);
+	rc = sata_link_hardreset(link, timing, deadline, &online,
+				ahci_check_ready);
+	if (!xgene_ahci_is_A1())
+		xgene_ahci_serdes_set_pq(ctx, channel, 0);
+	/* clear all errors */
+	xgene_ahci_in32(port_mmio + PORT_SCR_ERR, &val);
+	xgene_ahci_out32(port_mmio + PORT_SCR_ERR, val);
+
+	/* Check to ensure that the disk comes up in match speed */
+	if (online) {
+		sata_scr_read(link, SCR_STATUS, &sstatus);
+		if (!retry) {
+			if (((sstatus >> 4) & 0xf) == 2) {
+				/* For Gen2 and first time, let's check again
+				 * with Gen2 serdes to ensure actual Gen2 disk.
+				 */
+				xgene_ahci_serdes_force_gen(ctx, channel,
+					SPD_SEL_GEN2);
+				xgene_ahci_phy_restart(link);
+				++retry;
+				goto hardreset_retry;
+			} else if (((sstatus >> 4) & 0xf) == 1) {
+				/* For Gen1 and first time, let's check again
+				 * with Gen1 serdes to ensure actual Gen1 disk.
+				 */
+				xgene_ahci_serdes_force_gen(ctx, channel,
+					SPD_SEL_GEN1);
+				xgene_ahci_phy_restart(link);
+				++retry;
+				goto hardreset_retry;
+			 }
+		}
+	} else if (link_retry < 4) {
+		link_retry++;
+		goto hardreset_retry;
+	}
+	ata_link_dbg(link, "SATA%d.%d post-hardrest PORT_CMD 0x%08X\n",
+		ctx->cid, channel, readl(port_mmio + PORT_CMD));
+
+	/* As controller hardreset clear them, let restore them */
+	writel(portcmd_saved, port_mmio + PORT_CMD);
+	writel(portclb_saved, port_mmio + PORT_LST_ADDR);
+	writel(portclbhi_saved, port_mmio + PORT_LST_ADDR_HI);
+	writel(portrxfis_saved, port_mmio + PORT_FIS_ADDR);
+	writel(portrxfishi_saved, port_mmio + PORT_FIS_ADDR_HI);
+	ata_link_dbg(link, "SATA%d.%d restore PORT_CMD 0x%08X\n",
+		ctx->cid, channel, readl(port_mmio + PORT_CMD));
+
+	ahci_start_engine(ap);
+
+	if (online)
+		*class = ahci_dev_classify(ap);
+
+	ata_link_dbg(link, "SATA%d.%d APM hardreset EXIT rc %d class %u\n",
+		ctx->cid, channel, rc, *class);
+	return rc;
+}
+
+static const char *xgene_ahci_chip_revision(void)
+{
+	static const char *revision = NULL;
+
+	if (!revision) {
+		#define EFUSE0_SHADOW_VERSION_SHIFT     28
+		#define EFUSE0_SHADOW_VERSION_MASK      0xF
+		void *efuse;
+		void *jtag;
+		u32 efuse0;
+		u32 jtagid;
+
+		/* Part registers are fixed in X-Gene. */
+#if defined(CONFIG_ARCH_MSLIM)
+		/* MSLIM address map uses 0xC000.0000 */
+		efuse = ioremap(0xC054A000ULL, 0x100);
+#else
+		/* Potenza address map uses 0x1000.0000 */
+		efuse = ioremap(0x1054A000ULL, 0x100);
+#endif
+		jtag = ioremap(0x17000004ULL, 0x100);
+		if (efuse == NULL || jtag == NULL) {
+			if (efuse)
+				iounmap(efuse);
+			if (jtag)
+				iounmap(jtag);
+			return revision = "A1";
+		}
+		efuse0 = (readl(efuse) >> EFUSE0_SHADOW_VERSION_SHIFT)
+			& EFUSE0_SHADOW_VERSION_MASK;
+		iounmap(efuse);
+		jtagid = readl(jtag);
+		iounmap(jtag);
+		switch (efuse0) {
+		case 0x00:
+			if (jtagid & 0x10000000)
+				return revision = "A2";
+			else
+				return revision = "A1";
+		case 0x01: /* A2 */
+			return revision = "A2";
+		case 0x02: /* A3 */
+			return revision = "A3";
+		case 0x03: /* B0 */
+			return revision = "B0";
+		default:   /* Unknown */
+			return revision = "Unknown";
+		}
+	}
+	return revision;
+}
+
+int xgene_ahci_is_A1(void)
+{
+	return strcmp(xgene_ahci_chip_revision(), "A1") == 0 ? 1 : 0;
+}
+
+/* Flush the IOB to ensure all SATA controller writes completed before
+   servicing the completed command. */
+static int xgene_ahci_iob_flush(struct xgene_ahci_context *ctx)
+{
+	if (ctx->ahbc_io_base == NULL) {
+		void *ahbc_base;
+		u32 val;
+
+		/* The AHBC address is fixed in X-Gene */
+		ahbc_base = devm_ioremap(ctx->dev, 0x1F2A0000, 0x80000);
+		if (!ahbc_base) {
+			dev_err(ctx->dev, "can't map AHBC resource\n");
+			return -ENODEV;
+		}
+		/* The read to flush addres is fixed in X-Gene */
+		ctx->ahbc_io_base = devm_ioremap(ctx->dev, 0x1C000200, 0x100);
+		if (!ctx->ahbc_io_base) {
+			devm_iounmap(ctx->dev, ahbc_base);
+			dev_err(ctx->dev, "can't map AHBC IO resource\n");
+			return -ENODEV;
+		}
+		/* Enable IOB flush feature */
+		val = readl(ahbc_base + CFG_AMA_MODE_ADDR);
+		val |= CFG_RD2WR_EN;
+		writel(val, ahbc_base + CFG_AMA_MODE_ADDR);
+		devm_iounmap(ctx->dev, ahbc_base);
+	}
+	readl(ctx->ahbc_io_base);
+	return 0;
+}
+
+static unsigned int xgene_ahci_fill_sg(struct ata_queued_cmd *qc,
+	void *cmd_tbl)
+{
+	struct scatterlist *sg;
+	struct ahci_sg *ahci_sg = cmd_tbl + AHCI_CMD_TBL_HDR_SZ;
+	unsigned int si;
+
+	/*
+	 * Next, the S/G list.
+	 */
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		dma_addr_t addr = sg_dma_address(sg);
+		u64 dma_addr = xgene_ahci_to_axi(addr);
+		u32 sg_len = sg_dma_len(sg);
+		ahci_sg[si].addr = cpu_to_le32(dma_addr & 0xffffffff);
+		ahci_sg[si].addr_hi = cpu_to_le32((dma_addr >> 16) >> 16);
+		ahci_sg[si].flags_size = cpu_to_le32(sg_len - 1);
+		xgene_ahci_dflush((void *) __va(addr), sg_len);
+	 }
+	return si;
+}
+
+static void xgene_ahci_qc_prep(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	int is_atapi = ata_is_atapi(qc->tf.protocol);
+	void *cmd_tbl;
+	u32 opts;
+	const u32 cmd_fis_len = 5; /* five dwords */
+	unsigned int n_elem;
+	void *port_mmio = ahci_port_base(ap);
+	u32 fbs;
+
+	/*
+	 * Fill in command table information.  First, the header,
+	 * a SATA Register - Host to Device command FIS.
+	 */
+	cmd_tbl = pp->cmd_tbl + qc->tag * AHCI_CMD_TBL_SZ;
+
+	/* Due to hardware errata for port multipier CBS mode, enable DEV
+	   field of PxFBS in order to clear the PxCI */
+	if (qc->dev->link->pmp) {
+		fbs = readl(port_mmio + 0x40);
+		if ((fbs >> 8) & 0x0000000f) {
+			fbs &= 0xfffff0ff;
+			fbs |= qc->dev->link->pmp << 8;
+			writel(fbs, port_mmio + 0x40);
+		}
+	}
+
+	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, cmd_tbl);
+	if (is_atapi) {
+		memset(cmd_tbl + AHCI_CMD_TBL_CDB, 0, 32);
+		memcpy(cmd_tbl + AHCI_CMD_TBL_CDB, qc->cdb, qc->dev->cdb_len);
+	}
+	n_elem = 0;
+	if (qc->flags & ATA_QCFLAG_DMAMAP)
+		n_elem = xgene_ahci_fill_sg(qc, cmd_tbl);
+
+	/*
+	 * Fill in command slot information.
+	 */
+	opts = cmd_fis_len | n_elem << 16 | (qc->dev->link->pmp << 12);
+	if (qc->tf.flags & ATA_TFLAG_WRITE)
+		opts |= AHCI_CMD_WRITE;
+	if (is_atapi)
+		opts |= AHCI_CMD_ATAPI | AHCI_CMD_PREFETCH;
+
+	xgene_ahci_fill_cmd_slot(pp, qc->tag, opts);
+}
+
+/* Due to HW BUG we are limited to single FIS receive area for FBS
+ * so limiting the FBS FIS area from 16 to 0
+ */
+static bool xgene_ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
+{
+	struct ahci_port_priv *pp = qc->ap->private_data;
+	u8 *rx_fis = pp->rx_fis;
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
+static int xgene_ahci_do_softreset(struct ata_link *link,
+	unsigned int *class, int pmp, unsigned long deadline,
+	int (*check_ready)(struct ata_link *link))
+{
+	struct ata_port *ap = link->ap;
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	const char *reason = NULL;
+	unsigned long now, msecs;
+	struct ata_taskfile tf;
+	int rc;
+
+	ata_link_dbg(link, "ENTER\n");
+
+	/* prepare for SRST (AHCI-1.1 10.4.1) */
+	rc = ahci_kick_engine(ap);
+	if (rc && rc != -EOPNOTSUPP)
+		ata_link_warn(link, "failed to reset engine (errno=%d)\n", rc);
+
+	ata_tf_init(link->device, &tf);
+	/* issue the first D2H Register FIS */
+	msecs = 0;
+	now = jiffies;
+	if (time_after(deadline, now))
+		msecs = jiffies_to_msecs(deadline - now);
+
+	tf.ctl |= ATA_SRST;
+	/* Must call X-Gene version in case it needs to flush the cache for
+	   MSLIM as well as AXI address translation */
+	if (xgene_ahci_exec_polled_cmd(ap, pmp, &tf, 0,
+				 AHCI_CMD_RESET | AHCI_CMD_CLR_BUSY, msecs)) {
+		rc = -EIO;
+		reason = "1st FIS failed";
+		goto fail;
+	}
+
+	/* spec says at least 5us, but be generous and sleep for 1ms */
+	ata_msleep(ap, 1);
+
+	/* issue the second D2H Register FIS */
+	tf.ctl &= ~ATA_SRST;
+	/* HW need AHCI_CMD_RESET and AHCI_CMD_CLR_BUSY */
+	xgene_ahci_exec_polled_cmd(ap, pmp, &tf, 0,
+		AHCI_CMD_RESET | AHCI_CMD_CLR_BUSY, msecs);
+	/* wait for link to become ready */
+	rc = ata_wait_after_reset(link, deadline, check_ready);
+	if (rc == -EBUSY && hpriv->flags & AHCI_HFLAG_SRST_TOUT_IS_OFFLINE) {
+		/*
+		 * Workaround for cases where link online status can't
+		 * be trusted.  Treat device readiness timeout as link
+		 * offline.
+		 */
+		ata_link_info(link, "device not ready, treating as offline\n");
+		*class = ATA_DEV_NONE;
+	} else if (rc) {
+		/* link occupied, -ENODEV too is an error */
+		reason = "device not ready";
+		goto fail;
+	} else {
+		*class = ahci_dev_classify(ap);
+	}
+
+	ata_link_dbg(link, "EXIT, class=%u\n", *class);
+	return 0;
+
+ fail:
+	ata_link_err(link, "softreset failed (%s)\n", reason);
+	return rc;
+}
+
+static int xgene_ahci_softreset(struct ata_link *link, unsigned int *class,
+	unsigned long deadline)
+{
+	int pmp = sata_srst_pmp(link);
+	return xgene_ahci_do_softreset(link, class, pmp, deadline,
+					ahci_check_ready);
+}
+
+static struct ata_port_operations xgene_ahci_ops = {
+	.inherits	= &ahci_ops,
+	.hardreset	= xgene_ahci_hardreset,
+	.read_id	= xgene_ahci_read_id,
+	.qc_prep	= xgene_ahci_qc_prep,
+	.qc_issue	= xgene_ahci_qc_issue,
+#if defined(CONFIG_ARCH_MSLIM)
+	.port_resume	= xgene_ahci_port_resume,
+	.port_start	= xgene_ahci_port_start,
+#endif
+	.softreset	= xgene_ahci_softreset,
+	.pmp_softreset	= xgene_ahci_softreset,
+	.qc_fill_rtf	= xgene_ahci_qc_fill_rtf,
+};
+
+static const struct ata_port_info xgene_ahci_port_info[] = {
+	{
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &xgene_ahci_ops,
+	},
+};
+
+static struct scsi_host_template xgene_ahci_sht = {
+	AHCI_SHT("XGene-ahci"),
+};
+
+static void xgene_ahci_port_intr(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	int resetting = !!(ap->pflags & ATA_PFLAG_RESETTING);
+	u32 status, qc_active = 0;
+	int rc;
+
+	status = readl(port_mmio + PORT_IRQ_STAT);
+	writel(status, port_mmio + PORT_IRQ_STAT);
+
+	/* ignore BAD_PMP while resetting */
+	if (unlikely(resetting))
+		status &= ~PORT_IRQ_BAD_PMP;
+
+	/* if LPM is enabled, PHYRDY doesn't mean anything */
+	if (ap->link.lpm_policy > ATA_LPM_MAX_POWER) {
+		status &= ~PORT_IRQ_PHYRDY;
+		ahci_scr_write(&ap->link, SCR_ERROR, SERR_PHYRDY_CHG);
+	}
+
+	if (unlikely(status & PORT_IRQ_ERROR)) {
+		ahci_error_intr(ap, status);
+		return;
+	}
+
+	if (status & PORT_IRQ_SDB_FIS) {
+		/* If SNotification is available, leave notification
+		 * handling to sata_async_notification().  If not,
+		 * emulate it by snooping SDB FIS RX area.
+		 *
+		 * Snooping FIS RX area is probably cheaper than
+		 * poking SNotification but some constrollers which
+		 * implement SNotification, ICH9 for example, don't
+		 * store AN SDB FIS into receive area.
+		 */
+		if (hpriv->cap & HOST_CAP_SNTF)
+			sata_async_notification(ap);
+		else {
+			/* If the 'N' bit in word 0 of the FIS is set,
+			 * we just received asynchronous notification.
+			 * Tell libata about it.
+			 *
+			 * Lack of SNotification should not appear in
+			 * ahci 1.2, so the workaround is unnecessary
+			 * when FBS is enabled.
+			 */
+			if (pp->fbs_enabled)
+				WARN_ON_ONCE(1);
+			else {
+				const __le32 *f = pp->rx_fis + RX_FIS_SDB;
+				u32 f0 = le32_to_cpu(f[0]);
+				if (f0 & (1 << 15))
+					sata_async_notification(ap);
+			}
+		}
+	}
+
+	/* pp->active_link is not reliable once FBS is enabled, both
+	 * PORT_SCR_ACT and PORT_CMD_ISSUE should be checked because
+	 * NCQ and non-NCQ commands may be in flight at the same time.
+	 */
+	if (pp->fbs_enabled) {
+		if (ap->qc_active) {
+			qc_active = readl(port_mmio + PORT_SCR_ACT);
+			qc_active |= readl(port_mmio + PORT_CMD_ISSUE);
+		}
+	} else {
+		/* pp->active_link is valid iff any command is in flight */
+		if (ap->qc_active && pp->active_link->sactive)
+			qc_active = readl(port_mmio + PORT_SCR_ACT);
+		else
+			qc_active = readl(port_mmio + PORT_CMD_ISSUE);
+	}
+
+	/* Flush the IOB before servicing interrupt to ensure all data
+	   written by the controller appears in DDR */
+	xgene_ahci_iob_flush((struct xgene_ahci_context *) hpriv);
+
+	rc = ata_qc_complete_multiple(ap, qc_active);
+
+	/* while resetting, invalid completions are expected */
+	if (unlikely(rc < 0 && !resetting)) {
+		ehi->err_mask |= AC_ERR_HSM;
+		ehi->action |= ATA_EH_RESET;
+		ata_port_freeze(ap);
+	}
+}
+
+static irqreturn_t xgene_ahci_interrupt(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	struct ahci_host_priv *hpriv;
+	unsigned int i, handled = 0;
+	void __iomem *mmio;
+	u32 irq_stat, irq_masked;
+
+	VPRINTK("ENTER\n");
+
+	hpriv = host->private_data;
+	mmio = hpriv->mmio;
+
+	/* sigh.  0xffffffff is a valid return from h/w */
+	irq_stat = readl(mmio + HOST_IRQ_STAT);
+	if (!irq_stat)
+		return IRQ_NONE;
+
+	irq_masked = irq_stat & hpriv->port_map;
+
+	spin_lock(&host->lock);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap;
+
+		if (!(irq_masked & (1 << i)))
+			continue;
+
+		ap = host->ports[i];
+		if (ap) {
+			xgene_ahci_port_intr(ap);
+			VPRINTK("port %u\n", i);
+		} else {
+			VPRINTK("port %u (no irq)\n", i);
+			if (ata_ratelimit())
+				dev_warn(host->dev,
+					 "interrupt on disabled port %u\n", i);
+		}
+
+		handled = 1;
+	}
+
+	/* HOST_IRQ_STAT behaves as level triggered latch meaning that
+	 * it should be cleared after all the port events are cleared;
+	 * otherwise, it will raise a spurious interrupt after each
+	 * valid one.  Please read section 10.6.2 of ahci 1.1 for more
+	 * information.
+	 *
+	 * Also, use the unmasked value to clear interrupt as spurious
+	 * pending event on a dummy port might cause screaming IRQ.
+	 */
+	writel(irq_stat, mmio + HOST_IRQ_STAT);
+
+	spin_unlock(&host->lock);
+
+	VPRINTK("EXIT\n");
+
+	return IRQ_RETVAL(handled);
+}
+
+static int xgene_ahci_get_irq(struct platform_device *pdev, int index)
+{
+	if (efi_enabled(EFI_BOOT))
+		return platform_get_irq(pdev, index);
+	return irq_of_parse_and_map(pdev->dev.of_node, index);
+}
+
+static int xgene_ahci_get_resource(struct platform_device *pdev, int index,
+	struct resource	*res)
+{
+	struct resource *regs;
+	if (efi_enabled(EFI_BOOT)) {
+		regs = platform_get_resource(pdev, IORESOURCE_MEM, index);
+		if (regs == NULL)
+			return -ENODEV;
+		*res = *regs;
+		return 0;
+	}
+	return of_address_to_resource(pdev->dev.of_node, index, res);
+}
+
+static int xgene_ahci_get_u32_param(struct platform_device *pdev,
+	const char *of_name, char *acpi_name, u32 *param)
+{
+#ifdef CONFIG_ACPI
+	if (efi_enabled(EFI_BOOT)) {
+		unsigned long long value;
+		acpi_status status;
+		if (acpi_name == NULL)
+			return -ENODEV;
+		status = acpi_evaluate_integer(ACPI_HANDLE(&pdev->dev),
+			acpi_name, NULL, &value);
+		if (ACPI_FAILURE(status))
+			return -ENODEV;
+		*param = value;
+		return 0;
+	}
+#endif
+	if (of_name == NULL)
+		return -ENODEV;
+	return of_property_read_u32(pdev->dev.of_node, of_name, param);
+}
+
+static int xgene_ahci_get_str_param(struct platform_device *pdev,
+	const char *of_name, char *acpi_name, char *buf, int len)
+{
+	int rc;
+	const char *param;
+#ifdef CONFIG_ACPI
+	if (efi_enabled(EFI_BOOT)) {
+		acpi_status status;
+		struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+		union acpi_object *acpi_obj;
+
+		if (acpi_name == NULL)
+			return -ENODEV;
+		status = acpi_evaluate_object(ACPI_HANDLE(&pdev->dev),
+				acpi_name, NULL, &buffer);
+		if (ACPI_FAILURE(status))
+			return -ENODEV;
+		acpi_obj = buffer.pointer;
+		if (acpi_obj->type != ACPI_TYPE_STRING) {
+			buf[0] = '\0';
+			kfree(buffer.pointer);
+			return -ENODEV;
+		}
+		if (acpi_obj->string.length < len) {
+			strncpy(buf, acpi_obj->string.pointer,
+				acpi_obj->string.length);
+			buf[acpi_obj->string.length] = '\0';
+		} else {
+			strncpy(buf, acpi_obj->string.pointer, len);
+			buf[len-1] = '\0';
+		}
+		kfree(buffer.pointer);
+		return 0;
+	}
+#endif
+	if (of_name == NULL)
+		return -ENODEV;
+	rc = of_property_read_string(pdev->dev.of_node, of_name, &param);
+	if (rc == 0) {
+		strncpy(buf, param, len);
+		buf[len - 1] = '\0';
+	} else {
+		buf[0] = '\0';
+	}
+	return rc;
+}
+
+static int xgene_ahci_probe(struct platform_device *pdev)
+{
+	struct xgene_ahci_context *hpriv;
+	struct ata_port_info pi = xgene_ahci_port_info[0];
+	const struct ata_port_info *ppi[] = { &pi, NULL };
+	struct ata_host *host;
+	struct resource res;
+	char res_name[30];
+	int n_ports;
+	int rc;
+	int i;
+	u32 val;
+	u32 rxclk_inv;
+	u32 gen_sel;
+	u32 serdes_diff_clk;
+
+	/* When both ACPi and DTS are enabled, custom ACPI built-in ACPI
+	   table, and booting via DTS, we need to skip the probe of the
+	   built-in ACPI table probe. */
+	if (!efi_enabled(EFI_BOOT) && pdev->dev.of_node == NULL)
+		return -ENODEV;
+
+	/* Check if the entry is disabled for OF only */
+	if (!efi_enabled(EFI_BOOT) &&
+		!of_device_is_available(pdev->dev.of_node))
+		return -ENODEV;
+#if defined(CONFIG_ACPI)
+	if (efi_enabled(EFI_BOOT)) {
+		struct acpi_device *device;
+
+		if (acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &device))
+			return -ENODEV;
+
+		if (acpi_bus_get_status(device) || !device->status.present)
+			return -ENODEV;
+	}
+#endif
+
+	hpriv = devm_kzalloc(&pdev->dev, sizeof(*hpriv), GFP_KERNEL);
+	if (!hpriv) {
+		dev_err(&pdev->dev, "can't allocate host context\n");
+		return -ENOMEM;
+	}
+	hpriv->dev = &pdev->dev;
+
+	rc = xgene_ahci_get_resource(pdev, 0, &res);
+	if (rc != 0) {
+		dev_err(&pdev->dev, "no AHCI resource address\n");
+		goto error;
+	}
+	hpriv->mmio_phys = res.start;
+	hpriv->mmio_base = devm_ioremap(&pdev->dev, res.start,
+				resource_size(&res));
+	if (!hpriv->mmio_base) {
+		dev_err(&pdev->dev, "can't map MMIO resource\n");
+		rc  = -ENOMEM;
+		goto error;
+	}
+	hpriv->hpriv.mmio = hpriv->mmio_base;
+
+	rc = xgene_ahci_get_resource(pdev, 1, &res);
+	if (rc != 0) {
+		dev_err(&pdev->dev, "no Serdes resource address\n");
+		goto error;
+	}
+	hpriv->csr_phys = res.start;
+	hpriv->csr_base = devm_ioremap(&pdev->dev, res.start,
+				resource_size(&res));
+	if (!hpriv->csr_base) {
+		dev_err(&pdev->dev, "can't map Serdes CSR resource\n");
+		rc  = -ENOMEM;
+		goto error;
+	}
+
+	rc = xgene_ahci_get_str_param(pdev, "clock-names", "CLNM", res_name,
+		sizeof(res_name));
+	if (rc) {
+		dev_err(&pdev->dev, "no clock name resource\n");
+		goto error;
+	}
+	hpriv->hpriv.clk = clk_get(&pdev->dev, res_name);
+	if (!IS_ERR(hpriv->hpriv.clk)) {
+		rc = clk_prepare_enable(hpriv->hpriv.clk);
+		if (rc) {
+			dev_err(&pdev->dev, "clock prepare enable failed\n");
+			goto error;
+		}
+	} else {
+		dev_warn(&pdev->dev, "no clock\n");
+	}
+	if (strcmp(res_name, "eth01clk") == 0)
+		hpriv->cid = 0;
+	else if (strcmp(res_name, "eth23clk") == 0)
+		hpriv->cid = 1;
+	else
+		hpriv->cid = 2;
+
+	if (hpriv->cid == 2) {
+		rc = xgene_ahci_get_resource(pdev, 2, &res);
+		if (rc != 0) {
+			dev_err(&pdev->dev, "no SATA/PCIE resource address\n");
+			goto error;
+		}
+		hpriv->pcie_base = devm_ioremap(&pdev->dev, res.start,
+					resource_size(&res));
+		if (!hpriv->pcie_base) {
+			dev_err(&pdev->dev, "can't map SATA/PCIe resource\n");
+			rc  = -ENOMEM;
+			goto error;
+		}
+	}
+
+	/* Map in the IOB register */
+	rc = xgene_ahci_iob_flush(hpriv);
+	if (rc)
+		goto error;
+
+	dev_dbg(&pdev->dev, "SATA%d PHY PAddr 0x%016LX VAddr 0x%p Mmio PAddr 0x%016LX VAddr 0x%p\n",
+		hpriv->cid, hpriv->csr_phys, hpriv->csr_base,
+		hpriv->mmio_phys, hpriv->mmio_base);
+
+	/* Custom Serdes override paraemter */
+	rc = xgene_ahci_get_u32_param(pdev, "gen-sel", "GENS", &gen_sel);
+	if (rc != 0)
+		gen_sel = 3;	/* Default to Gen3 */
+	rc = xgene_ahci_get_u32_param(pdev, "serdes-diff-clk", "SDCL",
+		&serdes_diff_clk);
+	if (rc != 0)
+		serdes_diff_clk = SATA_CLK_EXT_DIFF; /* Default to external */
+	rc = xgene_ahci_get_u32_param(pdev, "EQA1", "EQA1", &hpriv->ctrl_eq_A1);
+	if (rc != 0)
+		hpriv->ctrl_eq_A1 = CTLE_EQ;
+	rc = xgene_ahci_get_u32_param(pdev, "EQ", "EQ00", &hpriv->ctrl_eq);
+	if (rc != 0)
+		hpriv->ctrl_eq = CTLE_EQ_A2;
+	dev_dbg(&pdev->dev, "SATA%d ctrl_eq %u %u\n", hpriv->cid,
+		hpriv->ctrl_eq_A1, hpriv->ctrl_eq);
+	rc = xgene_ahci_get_u32_param(pdev, "GENAVG", "GAVG",
+		&hpriv->use_gen_avg);
+	if (rc != 0)
+		hpriv->use_gen_avg = xgene_ahci_is_A1() ? 0 : 1;
+	dev_dbg(&pdev->dev, "SATA%d use avg %u\n", hpriv->cid,
+		hpriv->use_gen_avg);
+	rc = xgene_ahci_get_u32_param(pdev, "LBA1", "LBA1",
+		&hpriv->loopback_buf_en_A1);
+	if (rc != 0)
+		hpriv->loopback_buf_en_A1 = 1;
+	rc = xgene_ahci_get_u32_param(pdev, "LB", "LB00",
+		&hpriv->loopback_buf_en);
+	if (rc != 0)
+		hpriv->loopback_buf_en = 0;
+	dev_dbg(&pdev->dev, "SATA%d loopback_buf_en %u %u\n", hpriv->cid,
+		hpriv->loopback_buf_en_A1, hpriv->loopback_buf_en);
+	rc = xgene_ahci_get_u32_param(pdev, "LCA1", "LCA1",
+		&hpriv->loopback_ena_ctle_A1);
+	if (rc != 0)
+		hpriv->loopback_ena_ctle_A1 = 1;
+	rc = xgene_ahci_get_u32_param(pdev, "LC", "LC00",
+		&hpriv->loopback_ena_ctle);
+	if (rc != 0)
+		hpriv->loopback_ena_ctle = 0;
+	dev_dbg(&pdev->dev, "SATA%d loopback_ena_ctle %u %u\n", hpriv->cid,
+		hpriv->loopback_ena_ctle_A1, hpriv->loopback_ena_ctle);
+	rc = xgene_ahci_get_u32_param(pdev, "CDRA1", "CDR1",
+		&hpriv->spd_sel_cdr_A1);
+	if (rc != 0)
+		hpriv->spd_sel_cdr_A1 = SPD_SEL;
+	rc = xgene_ahci_get_u32_param(pdev, "CDR", "CDR0",
+		&hpriv->spd_sel_cdr);
+	if (rc != 0)
+		hpriv->spd_sel_cdr = SPD_SEL;
+	dev_dbg(&pdev->dev, "SATA%d spd_sel_cdr %u %u\n", hpriv->cid,
+		hpriv->spd_sel_cdr_A1, hpriv->spd_sel_cdr);
+	rc = xgene_ahci_get_u32_param(pdev, "PQA1", "PQA1", &hpriv->pq_A1);
+	if (rc != 0)
+		hpriv->pq_A1 = PQ_REG;
+	rc = xgene_ahci_get_u32_param(pdev, "PQ", "PQ00", &hpriv->pq);
+	if (rc != 0)
+		hpriv->pq = PQ_REG_A2;
+	hpriv->pq_sign = 0x1;
+	dev_dbg(&pdev->dev, "SATA%d pq %u %u %d\n", hpriv->cid, hpriv->pq_A1,
+		hpriv->pq, hpriv->pq_sign);
+	rc = xgene_ahci_get_u32_param(pdev, "coherent", "COHT",
+		&hpriv->coherent);
+	if (rc != 0)
+		hpriv->coherent = 1;	/* Default to coherent IO */
+
+	hpriv->irq = xgene_ahci_get_irq(pdev, 0);
+	if (hpriv->irq <= 0) {
+		dev_err(&pdev->dev, "no IRQ resource\n");
+		rc  = -ENODEV;
+		goto error;
+	}
+
+	rxclk_inv = xgene_ahci_is_A1() ? 1 : 0;
+	rc = xgene_ahci_serdes_init(hpriv, gen_sel, serdes_diff_clk, rxclk_inv);
+	if (rc != 0) {
+		dev_err(&pdev->dev, "SATA%d PHY initialize failed %d\n",
+			hpriv->cid, rc);
+		rc = -ENODEV;
+		goto error;
+	}
+
+	/* Remove IP RAM out of shutdown */
+	xgene_ahci_init_memram(hpriv);
+
+	if (hpriv->use_gen_avg) {
+		xgene_ahci_serdes_gen_avg_val(hpriv, 1);
+		xgene_ahci_serdes_gen_avg_val(hpriv, 0);
+	} else {
+		xgene_ahci_serdes_force_lat_summer_cal(hpriv, 0);
+		xgene_ahci_serdes_force_lat_summer_cal(hpriv, 1);
+	}
+	if (xgene_ahci_is_A1()) {
+		xgene_ahci_serdes_reset_rxa_rxd(hpriv, 0);
+		xgene_ahci_serdes_reset_rxa_rxd(hpriv, 1);
+	}
+	for (i = 0; i < MAX_AHCI_CHN_PERCTR; i++)
+		xgene_ahci_set_phy_cfg(hpriv, i);
+
+	/* Now enable top level interrupt. Otherwise, port interrupt will
+	   not work. */
+	/* AXI disable Mask */
+	xgene_ahci_out32_flush(hpriv->mmio_base + HOST_IRQ_STAT, 0xffffffff);
+	xgene_ahci_out32(hpriv->csr_base + INTSTATUSMASK_ADDR, 0);
+	xgene_ahci_in32(hpriv->csr_base + INTSTATUSMASK_ADDR, &val);
+	dev_dbg(&pdev->dev,
+		"SATA%d top level interrupt mask 0x%X value 0x%08X\n",
+		hpriv->cid, INTSTATUSMASK_ADDR, val);
+	xgene_ahci_out32_flush(hpriv->csr_base + ERRINTSTATUSMASK_ADDR, 0x0);
+	xgene_ahci_out32_flush(hpriv->csr_base + SATA_SHIM_OFFSET +
+			INT_SLV_TMOMASK_ADDR, 0x0);
+	/* Enable AXI Interrupt */
+	xgene_ahci_out32(hpriv->csr_base + SLVRDERRATTRIBUTES_ADDR, 0xffffffff);
+	xgene_ahci_out32(hpriv->csr_base + SLVWRERRATTRIBUTES_ADDR, 0xffffffff);
+	xgene_ahci_out32(hpriv->csr_base + MSTRDERRATTRIBUTES_ADDR, 0xffffffff);
+	xgene_ahci_out32(hpriv->csr_base + MSTWRERRATTRIBUTES_ADDR, 0xffffffff);
+
+	/* Enable coherency unless explicit disabled */
+	if (hpriv->coherent) {
+		xgene_ahci_in32(hpriv->csr_base + BUSCTLREG_ADDR, &val);
+		val = MSTAWAUX_COHERENT_BYPASS_SET(val, 0);
+		val = MSTARAUX_COHERENT_BYPASS_SET(val, 0);
+		xgene_ahci_out32(hpriv->csr_base + BUSCTLREG_ADDR, val);
+
+		xgene_ahci_in32(hpriv->csr_base + IOFMSTRWAUX_ADDR, &val);
+		val |= (1 << 3);	/* Enable read coherency */
+		val |= (1 << 9);	/* Enable write coherency */
+		xgene_ahci_out32_flush(hpriv->csr_base + IOFMSTRWAUX_ADDR, val);
+		xgene_ahci_in32(hpriv->csr_base + IOFMSTRWAUX_ADDR, &val);
+		dev_dbg(&pdev->dev,
+			"SATA%d coherency 0x%X value 0x%08X\n",
+			hpriv->cid, IOFMSTRWAUX_ADDR, val);
+	}
+	/* Setup AHCI host priv structure */
+	ahci_save_initial_config(&pdev->dev, &hpriv->hpriv, 0, 0);
+
+	/* prepare host */
+	if (hpriv->hpriv.cap & HOST_CAP_NCQ)
+		pi.flags |= ATA_FLAG_NCQ;
+	if (hpriv->hpriv.cap & HOST_CAP_PMP) {
+		pi.flags |= ATA_FLAG_PMP;
+		if (hpriv->hpriv.cap & HOST_CAP_FBS)
+			hpriv->hpriv.flags |= AHCI_HFLAG_YES_FBS;
+	}
+	ahci_set_em_messages(&hpriv->hpriv, &pi);
+
+	/* CAP.NP sometimes indicate the index of the last enabled
+	 * port, at other times, that of the last possible port, so
+	 * determining the maximum port number requires looking at
+	 * both CAP.NP and port_map.
+	 */
+	n_ports = max(ahci_nr_ports(hpriv->hpriv.cap),
+			fls(hpriv->hpriv.port_map));
+
+	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
+	if (!host) {
+		dev_err(&pdev->dev, "can not allocate host pinfo\n");
+		rc = -ENOMEM;
+		goto error;
+	}
+
+	host->private_data = hpriv;
+
+	if (!(hpriv->hpriv.cap & HOST_CAP_SSS) || ahci_ignore_sss)
+		host->flags |= ATA_HOST_PARALLEL_SCAN;
+	else
+		dev_warn(&pdev->dev,
+			"ahci: SSS flag set, parallel bus scan disabled\n");
+
+	if (pi.flags & ATA_FLAG_EM)
+		ahci_reset_em(host);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		ata_port_desc(ap, "mmio 0x%llX", hpriv->mmio_phys);
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
+	ahci_print_info(host, "XGene-AHCI\n");
+
+	if (xgene_ahci_is_A1()) {
+		xgene_ahci_sht.can_queue = 1;
+		dev_warn(&pdev->dev, "SATA%d limited to 1 NCQ\n", hpriv->cid);
+	}
+
+	/* Setup DMA mask */
+	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
+	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(64);
+
+	rc = ata_host_activate(host, hpriv->irq, xgene_ahci_interrupt,
+				IRQF_SHARED, &xgene_ahci_sht);
+	if (rc)
+		goto error;
+
+	dev_dbg(&pdev->dev, "SATA%d PHY initialized\n", hpriv->cid);
+	return 0;
+
+error:
+	devm_kfree(&pdev->dev, hpriv);
+	return rc;
+}
+
+static int xgene_ahci_remove(struct platform_device *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct xgene_ahci_context *hpriv = host->private_data;
+
+	dev_dbg(&pdev->dev, "SATA%d remove\n", hpriv->cid);
+	devm_kfree(&pdev->dev, hpriv);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int xgene_ahci_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct xgene_ahci_context *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio_base;
+	u32 ctl;
+	int rc;
+
+	dev_dbg(&pdev->dev, "SATA%d suspend\n", hpriv->cid);
+
+	/*
+	 * AHCI spec rev1.1 section 8.3.3:
+	 * Software must disable interrupts prior to requesting a
+	 * transition of the HBA to D3 state.
+	 */
+	ctl = readl(mmio + HOST_CTL);
+	ctl &= ~HOST_IRQ_EN;
+	writel(ctl, mmio + HOST_CTL);
+	readl(mmio + HOST_CTL); /* flush */
+
+	rc = ata_host_suspend(host, state);
+	if (rc)
+		return rc;
+
+	if (!IS_ERR(hpriv->hpriv.clk))
+		clk_disable_unprepare(hpriv->hpriv.clk);
+	return 0;
+}
+
+static int xgene_ahci_resume(struct platform_device *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct xgene_ahci_context *hpriv = host->private_data;
+	int rc;
+
+	dev_dbg(&pdev->dev, "SATA%d resume\n", hpriv->cid);
+
+	if (!IS_ERR(hpriv->hpriv.clk)) {
+		rc = clk_prepare_enable(hpriv->hpriv.clk);
+		if (rc) {
+			dev_err(&pdev->dev, "clock prepare enable failed\n");
+			return rc;
+		}
+	}
+
+	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
+		rc = ahci_reset_controller(host);
+		if (rc)
+			goto disable_unprepare_clk;
+
+		ahci_init_controller(host);
+	}
+
+	ata_host_resume(host);
+	return 0;
+
+disable_unprepare_clk:
+	if (!IS_ERR(hpriv->hpriv.clk))
+		clk_disable_unprepare(hpriv->hpriv.clk);
+
+	return rc;
+}
+#endif
+
+static const struct acpi_device_id xgene_ahci_acpi_match[] = {
+	{ "APMC0D00", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(acpi, xgene_ahci_acpi_match);
+
+static const struct of_device_id xgene_ahci_of_match[] = {
+	{ .compatible = "apm,xgene-ahci", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, xgene_ahci_of_match);
+
+static struct platform_driver xgene_ahci_driver = {
+	.driver = {
+		.name = "xgene-ahci",
+		.owner = THIS_MODULE,
+		.of_match_table = xgene_ahci_of_match,
+		.acpi_match_table = ACPI_PTR(xgene_ahci_acpi_match),
+	},
+	.probe = xgene_ahci_probe,
+	.remove = xgene_ahci_remove,
+#ifdef CONFIG_PM
+	.suspend	= xgene_ahci_suspend,
+	.resume		= xgene_ahci_resume,
+#endif
+};
+module_platform_driver(xgene_ahci_driver);
+
+MODULE_DESCRIPTION("APM X-Gene AHCI SATA driver");
+MODULE_AUTHOR("Loc Ho <lho@apm.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.3");
diff --git a/drivers/ata/sata_xgene.h b/drivers/ata/sata_xgene.h
new file mode 100644
index 0000000..138152e
--- /dev/null
+++ b/drivers/ata/sata_xgene.h
@@ -0,0 +1,112 @@
+/*
+ * AppliedMicro X-Gene SATA PHY driver
+ *
+ * Copyright (c) 2013, Applied Micro Circuits Corporation
+ * Author: Loc Ho <lho@apm.com>
+ *         Tuan Phan <tphan@apm.com>
+ *         Suman Tripathi <stripathi@apm.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __SATA_XGENE_H__
+#define __SATA_XGENE_H__
+
+#include "ahci.h"	/* for ahci_host_priv */
+
+/* Default tuning parameters */
+#define XGENE_SERDES_VAL_NOT_SET	~0x0
+#define CTLE_EQ				0x9
+#define PQ_REG				0x8
+#define CTLE_EQ_A2			0x2
+#define PQ_REG_A2			0xa
+#define SPD_SEL				0x5
+
+/*
+ * Configure Reference clock (clock type):
+ *  External differential 0
+ *  Internal differential 1
+ *  Internal single ended 2
+ */
+#define SATA_CLK_EXT_DIFF		0
+#define SATA_CLK_INT_DIFF		1
+#define SATA_CLK_INT_SING		2
+
+#define SPD_SEL_GEN2			0x3
+#define SPD_SEL_GEN1			0x1
+
+struct xgene_ahci_context {
+	struct ahci_host_priv  hpriv;
+	struct device *dev;
+	u8 cid;			/* Controller ID */
+	int irq;		/* IRQ */
+	void *csr_base;		/* CSR base address of IP - serdes */
+	void *mmio_base;	/* AHCI I/O base address */
+	void *pcie_base;	/* Shared Serdes CSR in PCIe 4/5 domain */
+	void *ahbc_io_base;	/* Used for IOB flushing */
+	u64 csr_phys;		/* Physical address of CSR base address */
+	u64 mmio_phys;		/* Physical address of MMIO base address */
+
+	/* Override Serdes parameters */
+	u32 ctrl_eq_A1; /* Serdes Reg 1 RX/TX ctrl_eq value for A1 */
+	u32 ctrl_eq;	/* Serdes Reg 1 RX/TX ctrl_eq value */
+	u32 pq_A1;	/* Serdes Reg 125 pq value for A1 */
+	u32 pq;		/* Serdes Reg 125 pq value */
+	u32 pq_sign;	/* Serdes Reg 125 pq sign */
+	u32 loopback_buf_en_A1; /* Serdes Reg 4 Tx loopback buf enable for A1 */
+	u32 loopback_buf_en;	/* Serdes Reg 4 Tx loopback buf enable */
+	u32 loopback_ena_ctle_A1; /* Serdes Reg 7 loopback enable ctrl for A1 */
+	u32 loopback_ena_ctle;	/* Serdes Reg 7 loopback enable ctrl */
+	u32 spd_sel_cdr_A1;	/* Serdes Reg 61 spd sel cdr value for A1*/
+	u32 spd_sel_cdr;	/* Serdes Reg 61 spd sel cdr value */
+	u32 use_gen_avg;	/* Use generate average value */
+
+	u32 coherent;		/* Coherent IO */
+};
+
+void xgene_ahci_in32(void *addr, u32 *val);
+void xgene_ahci_out32(void *addr, u32 val);
+void xgene_ahci_out32_flush(void *addr, u32 val);
+void xgene_ahci_delayus(unsigned long us);
+void xgene_ahci_delayms(unsigned long ms);
+int xgene_ahci_is_A1(void);
+
+int xgene_ahci_serdes_init(struct xgene_ahci_context *ctx,
+	int gen_sel, int clk_type, int rxwclk_inv);
+void xgene_ahci_serdes_gen_avg_val(struct xgene_ahci_context *ctx, int channel);
+void xgene_ahci_serdes_force_lat_summer_cal(struct xgene_ahci_context *ctx,
+	int channel);
+void xgene_ahci_serdes_reset_rxa_rxd(struct xgene_ahci_context *ctx,
+	int channel);
+void xgene_ahci_serdes_force_gen(struct xgene_ahci_context *ctx, int channel,
+	int gen);
+void xgene_ahci_serdes_set_pq(struct xgene_ahci_context *ctx, int channel,
+	int data);
+int xgene_ahci_port_start(struct ata_port *ap);
+int xgene_ahci_port_resume(struct ata_port *ap);
+#if defined(CONFIG_ARCH_MSLIM)
+void xgene_ahci_fill_cmd_slot(struct ahci_port_priv *pp,
+	unsigned int tag, u32 opts);
+u64 xgene_ahci_to_axi(dma_addr_t addr);
+void xgene_ahci_dflush(void *addr, int size);
+int xgene_ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
+	struct ata_taskfile *tf, int is_cmd, u16 flags,
+	unsigned long timeout_msec);
+#else
+#define xgene_ahci_fill_cmd_slot	ahci_fill_cmd_slot
+#define xgene_ahci_exec_polled_cmd	ahci_exec_polled_cmd
+#define xgene_ahci_to_axi(x)		(x)
+#define xgene_ahci_dflush(x, ...)
+#endif
+
+#endif /* __SATA_XGENE_H__ */
-- 
1.5.5
