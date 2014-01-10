From: David Milburn <dmilburn@redhat.com>
Subject: Re: [PATCH v8 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Fri, 10 Jan 2014 14:07:21 -0600
Message-ID: <52D052F9.8050703@redhat.com>
References: <1389031922-4309-1-git-send-email-lho@apm.com> <1389031922-4309-2-git-send-email-lho@apm.com> <1389031922-4309-3-git-send-email-lho@apm.com> <1389031922-4309-4-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1389031922-4309-4-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org
Cc: Loc Ho <lho@apm.com>, olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Loc Ho wrote:
> This patch adds support for the APM X-Gene SoC SATA host controller driver.
> It requires the corresponding APM X-Gene SoC PHY driver.
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>  drivers/ata/Kconfig      |    8 +
>  drivers/ata/Makefile     |    1 +
>  drivers/ata/sata_xgene.c | 1047 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1056 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/ata/sata_xgene.c
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index 4e73772..cd1bc3c 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -106,6 +106,14 @@ config AHCI_IMX
>  
>  	  If unsure, say N.
>  
> +config SATA_XGENE
> +	tristate "APM X-Gene 6.0Gbps SATA host controller support"
> +	depends on ARM64 || COMPILE_TEST
> +	select SATA_AHCI_PLATFORM
> +	select PHY_XGENE
> +	help
> +	  This option enables support for APM X-Gene SoC SATA host controller.
> +
>  config SATA_FSL
>  	tristate "Freescale 3.0Gbps SATA support"
>  	depends on FSL_SOC
> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index 46518c6..1c0fabe 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
>  obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
>  obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
>  obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o
> +obj-$(CONFIG_SATA_XGENE)	+= sata_xgene.o
>  
>  # SFF w/ custom DMA
>  obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
> diff --git a/drivers/ata/sata_xgene.c b/drivers/ata/sata_xgene.c
> new file mode 100644
> index 0000000..d69943e
> --- /dev/null
> +++ b/drivers/ata/sata_xgene.c
> @@ -0,0 +1,1047 @@
> +/*
> + * AppliedMicro X-Gene SoC SATA Host Controller Driver
> + *
> + * Copyright (c) 2013, Applied Micro Circuits Corporation
> + * Author: Loc Ho <lho@apm.com>
> + *         Tuan Phan <tphan@apm.com>
> + *         Suman Tripathi <stripathi@apm.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + *
> + */
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/acpi.h>
> +#include <linux/efi.h>
> +#include <linux/phy/phy.h>
> +#include "ahci.h"
> +
> +/* Controller who PHY shared with SGMII Ethernet PHY */
> +#define XGENE_AHCI_SGMII_DTS		"apm,xgene-ahci-sgmii"
> +
> +/* Controller who PHY (internal reference clock macro) shared with PCIe */
> +#define XGENE_AHCI_PCIE_DTS		"apm,xgene-ahci-pcie"
> +
> +/* Max # of disk per a controller */
> +#define MAX_AHCI_CHN_PERCTR		2
> +
> +#define SATA_ENET_MUX_OFFSET		0x00007000
> +#define SATA_DIAG_OFFSET		0x0000D000
> +#define SATA_GLB_OFFSET			0x0000D850
> +#define SATA_SHIM_OFFSET		0x0000E000
> +#define SATA_MASTER_OFFSET		0x0000F000
> +#define SATA_PORT0_OFFSET		0x00000100
> +#define SATA_PORT1_OFFSET		0x00000180
> +
> +/* MUX CSR */
> +#define SATA_ENET_CONFIG_REG	0x00000000
> +#define  CFG_SATA_ENET_SELECT_MASK	0x00000001
> +
> +/* SATA host controller CSR */
> +#define SLVRDERRATTRIBUTES		0x00000000
> +#define SLVWRERRATTRIBUTES		0x00000004
> +#define MSTRDERRATTRIBUTES		0x00000008
> +#define MSTWRERRATTRIBUTES		0x0000000c
> +#define BUSCTLREG			0x00000014
> +#define IOFMSTRWAUX		0x00000018
> +#define INTSTATUSMASK		0x0000002c
> +#define ERRINTSTATUS		0x00000030
> +#define ERRINTSTATUSMASK		0x00000034
> +
> +/* SATA host AHCI CSR */
> +#define PORTCFG			0x000000a4
> +#define  PORTADDR_SET(dst, src) \
> +		(((dst) & ~0x0000003f) | (((u32)(src)) & 0x0000003f))
> +#define PORTPHY1CFG		0x000000a8
> +#define PORTPHY1CFG_FRCPHYRDY_SET(dst, src) \
> +		(((dst) & ~0x00100000) | (((u32)(src) << 0x14) & 0x00100000))
> +#define PORTPHY2CFG		0x000000ac
> +#define PORTPHY3CFG		0x000000b0
> +#define PORTPHY4CFG		0x000000b4
> +#define PORTPHY5CFG		0x000000b8
> +#define SCTL0			0x0000012C
> +#define PORTPHY5CFG_RTCHG_SET(dst, src) \
> +		(((dst) & ~0xfff00000) | (((u32)(src) << 0x14) & 0xfff00000))
> +#define PORTAXICFG_EN_CONTEXT_SET(dst, src) \
> +		(((dst) & ~0x01000000) | (((u32)(src) << 0x18) & 0x01000000))
> +#define PORTAXICFG			0x000000bc
> +#define PORTAXICFG_OUTTRANS_SET(dst, src) \
> +		(((dst) & ~0x00f00000) | (((u32)(src) << 0x14) & 0x00f00000))
> +
> +/* SATA host controller slave CSR */
> +#define INT_SLV_TMOMASK		0x00000010
> +
> +/* SATA global diagnostic CSR */
> +#define REGSPEC_CFG_MEM_RAM_SHUTDOWN	0x00000070
> +#define REGSPEC_BLOCK_MEM_RDY		0x00000074
> +
> +/* AHBC IOB flush CSR */
> +#define CFG_AMA_MODE		0x0000e014
> +#define  CFG_RD2WR_EN			0x00000002
> +
> +struct xgene_ahci_context {
> +	struct ahci_host_priv  hpriv;
> +	struct device *dev;
> +	int irq;
> +	void __iomem *csr_base;		/* CSR base address of IP */
> +	void __iomem *mmio_base;	/* AHCI I/O base address */
> +	void __iomem *ahbc_csr_base;	/* Used for IOB flushing if non-zero */
> +	void __iomem *ahbc_io_base;	/* Used for IOB flushing if non-zero */
> +
> +	struct phy *phy;
> +};
> +
> +static void xgene_rd(void *addr, u32 *val)
> +{
> +	*val = readl(addr);
> +	pr_debug("X-Gene SATA CSR RD: 0x%p value: 0x%08x\n", addr, *val);
> +}
> +
> +static void xgene_wr(void *addr, u32 val)
> +{
> +	writel(val, addr);
> +	pr_debug("X-Gene SATA CSR WR: 0x%p value: 0x%08x\n", addr, val);
> +}
> +
> +static void xgene_wr_flush(void *addr, u32 val)
> +{
> +	writel(val, addr);
> +	pr_debug("X-Gene SATA CSR WR: 0x%p value: 0x%08x\n", addr, val);
> +	val = readl(addr);	/* Force a barrier */
> +}
> +
> +static int xgene_ahci_get_channel(struct ata_host *host, struct ata_port *port)
> +{
> +	int i;
> +	for (i = 0; i < host->n_ports; i++)
> +		if (host->ports[i] == port)
> +			return i;
> +	return -1;
> +}
> +
> +static int xgene_ahci_init_memram(struct xgene_ahci_context *ctx)
> +{
> +	void *diagcsr = ctx->csr_base + SATA_DIAG_OFFSET;
> +	int try;
> +	u32 val;
> +
> +	xgene_rd(diagcsr + REGSPEC_CFG_MEM_RAM_SHUTDOWN, &val);
> +	if (val == 0) {
> +		dev_dbg(ctx->dev, "memory already released from shutdown\n");
> +		return 0;
> +	}
> +	dev_dbg(ctx->dev, "Release memory from shutdown\n");
> +	/* SATA controller memory in shutdown. Remove from shutdown. */
> +	xgene_wr_flush(diagcsr + REGSPEC_CFG_MEM_RAM_SHUTDOWN, 0x00);
> +
> +	/* Check for at least ~1ms */
> +	try = 1000;
> +	do {
> +		xgene_rd(diagcsr + REGSPEC_BLOCK_MEM_RDY, &val);
> +		if (val != 0xFFFFFFFF)
> +			usleep_range(1, 100);
> +	} while (val != 0xFFFFFFFF && try-- > 0);
> +	if (try <= 0) {
> +		dev_err(ctx->dev, "failed to release memory from shutdown\n");
> +		return -ENODEV;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Custom Query ID command
> + *
> + * Due to HW errata, we must stop and re-start the port state machine after
> + * read ID command.
> + */
> +static unsigned int xgene_ahci_read_id(struct ata_device *dev,
> +				       struct ata_taskfile *tf, u16 *id)
> +{
> +	u32 err_mask;
> +	struct ata_port *ap = dev->link->ap;
> +	void *port_mmio = ahci_port_base(ap);
> +	u32 data32;
> +
> +	err_mask = ata_do_dev_read_id(dev, tf, id);
> +	if (err_mask)
> +		return err_mask;
> +
> +	/* Mask reserved area. Bit78 spec of Link Power Management
> +	 * bit15-8: reserved
> +	 * bit7: NCQ autosence
> +	 * bit6: Software settings preservation supported
> +	 * bit5: reserved
> +	 * bit4: In-order sata delivery supported
> +	 * bit3: DIPM requests supported
> +	 * bit2: DMA Setup FIS Auto-Activate optimization supported
> +	 * bit1: DMA Setup FIX non-Zero buffer offsets supported
> +	 * bit0: Reserved
> +	 *
> +	 * Clear reserved bit (DEVSLP bit) as we don't support DEVSLP
> +	 */
> +	id[78] &= 0x00FF;
> +
> +	/* Restart the port if requred due to HW errata */
> +	data32 = readl(port_mmio + PORT_CMD_ISSUE);
> +	if (data32 == 0x00000000) {
> +		writel(PORT_CMD_FIS_RX, port_mmio + PORT_CMD);
> +		readl(port_mmio + PORT_CMD);	/* flush */
> +		writel(PORT_CMD_FIS_RX | PORT_CMD_START, port_mmio + PORT_CMD);
> +		readl(port_mmio + PORT_CMD);	/* flush */
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Custom QC issue
> + *
> + * Due to HW errata, we must stop and re-start the port state machine after
> + * read ID command.
> + */
> +static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
> +{
> +	struct ata_port *ap = qc->ap;
> +	void __iomem *port_mmio = ahci_port_base(ap);
> +	struct ahci_port_priv *pp = ap->private_data;
> +
> +	/* Keep track of the currently active link.  It will be used
> +	 * in completion path to determine whether NCQ phase is in
> +	 * progress.
> +	 */
> +	pp->active_link = qc->dev->link;
> +
> +	if (qc->tf.protocol == ATA_PROT_NCQ)
> +		writel(1 << qc->tag, port_mmio + PORT_SCR_ACT);
> +
> +	if (pp->fbs_enabled && pp->fbs_last_dev != qc->dev->link->pmp) {
> +		u32 fbs = readl(port_mmio + PORT_FBS);
> +		fbs &= ~(PORT_FBS_DEV_MASK | PORT_FBS_DEC);
> +		fbs |= qc->dev->link->pmp << PORT_FBS_DEV_OFFSET;
> +		writel(fbs, port_mmio + PORT_FBS);
> +		pp->fbs_last_dev = qc->dev->link->pmp;
> +	}
> +
> +	writel(1 << qc->tag, port_mmio + PORT_CMD_ISSUE);
> +
> +	ahci_sw_activity(qc->dev->link);
> +
> +	/* For query ID command, restart the port if requred due to HW errata.
> +	   This is needed when PMP is attached. */
> +	if (qc->dev->link->pmp && qc->tf.command == ATA_CMD_ID_ATA &&
> +	    readl(port_mmio + PORT_CMD_ISSUE) == 0x0) {
> +		writel(PORT_CMD_FIS_RX, port_mmio + PORT_CMD);
> +		readl(port_mmio + PORT_CMD);	/* flush */
> +		writel(PORT_CMD_FIS_RX | PORT_CMD_START, port_mmio + PORT_CMD);
> +		readl(port_mmio + PORT_CMD);	/* flush */
> +	}
> +
> +	return 0;
> +}
> +
> +static void xgene_ahci_enable_phy(struct xgene_ahci_context *ctx,
> +				  int channel, int enable)
> +{
> +	void *mmio = ctx->mmio_base;
> +	u32 val;
> +
> +	xgene_rd(mmio + PORTCFG, &val);
> +	val = PORTADDR_SET(val, channel == 0 ? 2 : 3);
> +	xgene_wr_flush(mmio + PORTCFG, val);
> +	xgene_rd(mmio + PORTPHY1CFG, &val);
> +	val = PORTPHY1CFG_FRCPHYRDY_SET(val, enable);
> +	xgene_wr(mmio + PORTPHY1CFG, val);
> +}
> +
> +static void xgene_ahci_set_phy_cfg(struct xgene_ahci_context *ctx, int channel)
> +{
> +	void *mmio = ctx->mmio_base;
> +	u32 val;
> +
> +	dev_dbg(ctx->dev, "port configure mmio 0x%p channel %d\n",
> +		mmio, channel);
> +	xgene_rd(mmio + PORTCFG, &val);
> +	val = PORTADDR_SET(val, channel == 0 ? 2 : 3);
> +	xgene_wr_flush(mmio + PORTCFG, val);
> +	/* Disable fix rate */
> +	xgene_wr_flush(mmio + PORTPHY1CFG, 0x0001fffe);
> +	xgene_wr_flush(mmio + PORTPHY2CFG, 0x5018461c);
> +	xgene_wr_flush(mmio + PORTPHY3CFG, 0x1c081907);
> +	xgene_wr_flush(mmio + PORTPHY4CFG, 0x1c080815);
> +	xgene_rd(mmio + PORTPHY5CFG, &val);
> +	/* Window negotiation 0x800 to 0x400 */
> +	val = PORTPHY5CFG_RTCHG_SET(val, 0x300);
> +	xgene_wr_flush(mmio + PORTPHY5CFG, val);
> +	xgene_rd(mmio + PORTAXICFG, &val);
> +	val = PORTAXICFG_EN_CONTEXT_SET(val, 0x1); /* enable context mgmt */
> +	val = PORTAXICFG_OUTTRANS_SET(val, 0xe); /* Outstanding */
> +	xgene_wr_flush(mmio + PORTAXICFG, val);
> +}
> +
> +/* Restart the PHY  */
> +static int xgene_ahci_phy_restart(struct ata_link *link)
> +{
> +	struct ata_port *port = link->ap;
> +	struct ata_host *host = port->host;
> +	struct xgene_ahci_context *ctx = host->private_data;
> +	int channel;
> +
> +	channel = xgene_ahci_get_channel(host, port);
> +	if (channel < 0 || channel >= MAX_AHCI_CHN_PERCTR)
> +		return -EINVAL;
> +	xgene_ahci_enable_phy(ctx, channel, 1);
> +	xgene_ahci_enable_phy(ctx, channel, 0);
> +	return 0;
> +}
> +
> +static int xgene_ahci_do_hardreset(struct ata_link *link, int chan,
> +				   unsigned long deadline, bool *online)
> +{
> +	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
> +	struct ata_port *ap = link->ap;
> +	struct xgene_ahci_context *ctx = ap->host->private_data;
> +	struct ahci_port_priv *pp = ap->private_data;
> +	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
> +	void __iomem *port_mmio = ahci_port_base(ap);
> +	struct ata_taskfile tf;
> +	int link_retry = 0;
> +	int retry = 0;
> +	int rc;
> +	u32 val;
> +
> +hardreset_retry:
> +	/* clear D2H reception area to properly wait for D2H FIS */
> +	ata_tf_init(link->device, &tf);
> +	tf.command = 0x80;
> +	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
> +	rc = sata_link_hardreset(link, timing, deadline, online,
> +				 ahci_check_ready);
> +	/* clear all errors */
> +	xgene_rd(port_mmio + PORT_SCR_ERR, &val);
> +	xgene_wr(port_mmio + PORT_SCR_ERR, val);
> +
> +	/* Check to ensure that the disk comes up in match speed */
> +	if (*online) {
> +		u32 sstatus;
> +		sata_scr_read(link, SCR_STATUS, &sstatus);
> +		if (!retry) {
> +			if (((sstatus >> 4) & 0xf) == 2) {
> +				/* For Gen2 and first time, let's check again
> +				 * with Gen2 serdes to ensure actual Gen2 disk.
> +				 */
> +				phy_set_speed(ctx->phy, chan, 3000000000ULL);
> +				xgene_ahci_phy_restart(link);
> +				++retry;
> +				goto hardreset_retry;
> +			} else if (((sstatus >> 4) & 0xf) == 1) {
> +				/* For Gen1 and first time, let's check again
> +				 * with Gen1 serdes to ensure actual Gen1 disk.
> +				 */
> +				phy_set_speed(ctx->phy, chan, 1500000000ULL);
> +				xgene_ahci_phy_restart(link);
> +				++retry;
> +				goto hardreset_retry;
> +			}
> +		}
> +	} else if (link_retry < 4) {
> +		link_retry++;
> +		goto hardreset_retry;
> +	}
> +	ata_link_dbg(link, "channel %d post-hardrest PORT_CMD 0x%08X\n",
> +		     chan, readl(port_mmio + PORT_CMD));
> +
> +	return rc;
> +}
> +
> +static int xgene_ahci_hardreset(struct ata_link *link, unsigned int *class,
> +				unsigned long deadline)
> +{
> +	struct ata_port *ap = link->ap;
> +	void __iomem *port_mmio = ahci_port_base(ap);
> +	bool online;
> +	int chan;
> +	int rc;
> +	int portcmd_saved;
> +	u32 portclb_saved;
> +	u32 portclbhi_saved;
> +	u32 portrxfis_saved;
> +	u32 portrxfishi_saved;
> +
> +	chan = xgene_ahci_get_channel(ap->host, ap);
> +	if (chan >= MAX_AHCI_CHN_PERCTR) {
> +		*class = ATA_DEV_NONE;
> +		return 0;
> +	}
> +	ata_link_dbg(link, "channel %d APM hardreset\n", chan);
> +
> +	/* As hardreset reset these CSR, let save it to restore later */
> +	portcmd_saved = readl(port_mmio + PORT_CMD);
> +	portclb_saved = readl(port_mmio + PORT_LST_ADDR);
> +	portclbhi_saved = readl(port_mmio + PORT_LST_ADDR_HI);
> +	portrxfis_saved = readl(port_mmio + PORT_FIS_ADDR);
> +	portrxfishi_saved = readl(port_mmio + PORT_FIS_ADDR_HI);
> +
> +	ahci_stop_engine(ap);
> +
> +	rc = xgene_ahci_do_hardreset(link, chan, deadline, &online);
> +
> +	/* As controller hardreset clear them, let restore them */
> +	writel(portcmd_saved, port_mmio + PORT_CMD);
> +	writel(portclb_saved, port_mmio + PORT_LST_ADDR);
> +	writel(portclbhi_saved, port_mmio + PORT_LST_ADDR_HI);
> +	writel(portrxfis_saved, port_mmio + PORT_FIS_ADDR);
> +	writel(portrxfishi_saved, port_mmio + PORT_FIS_ADDR_HI);
> +
> +	ahci_start_engine(ap);
> +
> +	if (online)
> +		*class = ahci_dev_classify(ap);
> +
> +	ata_link_dbg(link, "channel %d APM hardreset EXIT class %u\n",
> +		     chan, *class);
> +	return rc;
> +}
> +
> +/* Flush the IOB to ensure all SATA controller writes completed before
> +   servicing the completed command. This is needed due to the possibility
> +   that interrupt serviced before the data actually written to the cache/DDR.
> +   Writes from the IP to the CPU domain is not synchronized with the IRQ
> +   line or the IP core toggled the CI bits before the data write completed. */
> +static int xgene_ahci_iob_flush(struct xgene_ahci_context *ctx)
> +{
> +	if (ctx->ahbc_io_base)
> +		readl(ctx->ahbc_io_base);
> +	return 0;
> +}
> +
> +static void xgene_ahci_qc_prep(struct ata_queued_cmd *qc)
> +{
> +	struct ata_port *ap = qc->ap;
> +	struct ahci_port_priv *pp = ap->private_data;
> +	int is_atapi = ata_is_atapi(qc->tf.protocol);
> +	void *cmd_tbl;
> +	u32 opts;
> +	const u32 cmd_fis_len = 5;	/* five dwords */
> +	unsigned int n_elem;
> +	void *port_mmio = ahci_port_base(ap);
> +	u32 fbs;
> +
> +	/*
> +	 * Fill in command table information.  First, the header,
> +	 * a SATA Register - Host to Device command FIS.
> +	 */
> +	cmd_tbl = pp->cmd_tbl + qc->tag * AHCI_CMD_TBL_SZ;
> +
> +	/* Due to hardware errata for port multipier CBS mode, enable DEV
> +	   field of PxFBS in order to clear the PxCI */
> +	fbs = readl(port_mmio + 0x40);
> +	if (qc->dev->link->pmp || ((fbs >> 8) & 0x0000000f)) {
> +		fbs &= 0xfffff0ff;
> +		fbs |= qc->dev->link->pmp << 8;
> +		writel(fbs, port_mmio + 0x40);
> +	}
> +
> +	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, cmd_tbl);
> +	if (is_atapi) {
> +		memset(cmd_tbl + AHCI_CMD_TBL_CDB, 0, 32);
> +		memcpy(cmd_tbl + AHCI_CMD_TBL_CDB, qc->cdb, qc->dev->cdb_len);
> +	}
> +	n_elem = 0;
> +	if (qc->flags & ATA_QCFLAG_DMAMAP)
> +		n_elem = ahci_fill_sg(qc, cmd_tbl);
> +
> +	/*
> +	 * Fill in command slot information.
> +	 */
> +	opts = cmd_fis_len | n_elem << 16 | (qc->dev->link->pmp << 12);
> +	if (qc->tf.flags & ATA_TFLAG_WRITE)
> +		opts |= AHCI_CMD_WRITE;
> +	if (is_atapi)
> +		opts |= AHCI_CMD_ATAPI | AHCI_CMD_PREFETCH;
> +
> +	ahci_fill_cmd_slot(pp, qc->tag, opts);
> +}
> +
> +/* Due to HW BUG we are limited to single FIS receive area for FBS so
> + * limiting the FBS FIS area from 16 to 0.
> + */
> +static bool xgene_ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
> +{
> +	struct ahci_port_priv *pp = qc->ap->private_data;
> +	u8 *rx_fis = pp->rx_fis;
> +
> +	/*
> +	 * After a successful execution of an ATA PIO data-in command,
> +	 * the device doesn't send D2H Reg FIS to update the TF and
> +	 * the host should take TF and E_Status from the preceding PIO
> +	 * Setup FIS.
> +	 */
> +	if (qc->tf.protocol == ATA_PROT_PIO && qc->dma_dir == DMA_FROM_DEVICE &&
> +	    !(qc->flags & ATA_QCFLAG_FAILED)) {
> +		ata_tf_from_fis(rx_fis + RX_FIS_PIO_SETUP, &qc->result_tf);
> +		qc->result_tf.command = (rx_fis + RX_FIS_PIO_SETUP)[15];
> +	} else {
> +		ata_tf_from_fis(rx_fis + RX_FIS_D2H_REG, &qc->result_tf);
> +	}
> +
> +	return true;
> +}
> +
> +static int xgene_ahci_do_softreset(struct ata_link *link,
> +				   unsigned int *class, int pmp,
> +				   unsigned long deadline,
> +				   int (*check_ready) (struct ata_link *link))
> +{
> +	struct ata_port *ap = link->ap;
> +	struct ahci_host_priv *hpriv = ap->host->private_data;
> +	const char *reason = NULL;
> +	unsigned long now, msecs;
> +	struct ata_taskfile tf;
> +	int rc;
> +
> +	ata_link_dbg(link, "ENTER\n");
> +
> +	/* prepare for SRST (AHCI-1.1 10.4.1) */
> +	rc = ahci_kick_engine(ap);
> +	if (rc && rc != -EOPNOTSUPP)
> +		ata_link_warn(link, "failed to reset engine (errno=%d)\n", rc);
> +
> +	ata_tf_init(link->device, &tf);
> +	/* issue the first D2H Register FIS */
> +	msecs = 0;
> +	now = jiffies;
> +	if (time_after(deadline, now))
> +		msecs = jiffies_to_msecs(deadline - now);
> +
> +	tf.ctl |= ATA_SRST;
> +	if (ahci_exec_polled_cmd(ap, pmp, &tf, 0,
> +				 AHCI_CMD_RESET | AHCI_CMD_CLR_BUSY, msecs)) {
> +		rc = -EIO;
> +		reason = "1st FIS failed";
> +		goto fail;
> +	}
> +
> +	/* spec says at least 5us, but be generous and sleep for 1ms */
> +	ata_msleep(ap, 1);
> +
> +	/* issue the second D2H Register FIS */
> +	tf.ctl &= ~ATA_SRST;
> +	/* HW need AHCI_CMD_RESET and AHCI_CMD_CLR_BUSY */
> +	ahci_exec_polled_cmd(ap, pmp, &tf, 0,
> +			     AHCI_CMD_RESET | AHCI_CMD_CLR_BUSY, msecs);
> +	/* wait for link to become ready */
> +	rc = ata_wait_after_reset(link, deadline, check_ready);
> +	if (rc == -EBUSY && hpriv->flags & AHCI_HFLAG_SRST_TOUT_IS_OFFLINE) {
> +		/*
> +		 * Workaround for cases where link online status can't
> +		 * be trusted.  Treat device readiness timeout as link
> +		 * offline.
> +		 */
> +		ata_link_info(link, "device not ready, treating as offline\n");
> +		*class = ATA_DEV_NONE;
> +	} else if (rc) {
> +		/* link occupied, -ENODEV too is an error */
> +		reason = "device not ready";
> +		goto fail;
> +	} else {
> +		*class = ahci_dev_classify(ap);
> +	}
> +
> +	ata_link_dbg(link, "EXIT, class=%u\n", *class);
> +	return 0;
> +
> +fail:
> +	ata_link_err(link, "softreset failed (%s)\n", reason);
> +	return rc;
> +}
> +
> +static int xgene_ahci_softreset(struct ata_link *link, unsigned int *class,
> +				unsigned long deadline)
> +{
> +	int pmp = sata_srst_pmp(link);
> +	return xgene_ahci_do_softreset(link, class, pmp, deadline,
> +				       ahci_check_ready);
> +}
> +
> +static struct ata_port_operations xgene_ahci_ops = {
> +	.inherits = &ahci_ops,
> +	.hardreset = xgene_ahci_hardreset,
> +	.read_id = xgene_ahci_read_id,
> +	.qc_issue = xgene_ahci_qc_issue,
> +	.qc_fill_rtf = xgene_ahci_qc_fill_rtf,
> +	.qc_prep = xgene_ahci_qc_prep,
> +	.softreset = xgene_ahci_softreset,
> +	.pmp_softreset = xgene_ahci_softreset,
> +};
> +
> +static const struct ata_port_info xgene_ahci_port_info[] = {
> +	{
> +	 .flags = AHCI_FLAG_COMMON,
> +	 .pio_mask = ATA_PIO4,
> +	 .udma_mask = ATA_UDMA6,
> +	 .port_ops = &xgene_ahci_ops,
> +	 },
> +};
> +
> +static struct scsi_host_template xgene_ahci_sht = {
> +	AHCI_SHT("XGene-ahci"),
> +};
> +
> +static void xgene_ahci_port_intr(struct ata_port *ap)
> +{
> +	void __iomem *port_mmio = ahci_port_base(ap);
> +	struct ata_eh_info *ehi = &ap->link.eh_info;
> +	struct ahci_port_priv *pp = ap->private_data;
> +	struct ahci_host_priv *hpriv = ap->host->private_data;
> +	int resetting = !!(ap->pflags & ATA_PFLAG_RESETTING);
> +	u32 status, qc_active = 0;
> +	int rc;
> +
> +	status = readl(port_mmio + PORT_IRQ_STAT);
> +	writel(status, port_mmio + PORT_IRQ_STAT);
> +
> +	/* ignore BAD_PMP while resetting */
> +	if (unlikely(resetting))
> +		status &= ~PORT_IRQ_BAD_PMP;
> +
> +	/* if LPM is enabled, PHYRDY doesn't mean anything */
> +	if (ap->link.lpm_policy > ATA_LPM_MAX_POWER) {
> +		status &= ~PORT_IRQ_PHYRDY;
> +		ahci_scr_write(&ap->link, SCR_ERROR, SERR_PHYRDY_CHG);
> +	}
> +
> +	if (unlikely(status & PORT_IRQ_ERROR)) {
> +		ahci_error_intr(ap, status);
> +		return;
> +	}
> +
> +	if (status & PORT_IRQ_SDB_FIS) {
> +		/* If SNotification is available, leave notification
> +		 * handling to sata_async_notification().  If not,
> +		 * emulate it by snooping SDB FIS RX area.
> +		 *
> +		 * Snooping FIS RX area is probably cheaper than
> +		 * poking SNotification but some constrollers which
> +		 * implement SNotification, ICH9 for example, don't
> +		 * store AN SDB FIS into receive area.
> +		 */
> +		if (hpriv->cap & HOST_CAP_SNTF)
> +			sata_async_notification(ap);
> +		else {
> +			/* If the 'N' bit in word 0 of the FIS is set,
> +			 * we just received asynchronous notification.
> +			 * Tell libata about it.
> +			 *
> +			 * Lack of SNotification should not appear in
> +			 * ahci 1.2, so the workaround is unnecessary
> +			 * when FBS is enabled.
> +			 */
> +			if (pp->fbs_enabled)
> +				WARN_ON_ONCE(1);
> +			else {
> +				const __le32 *f = pp->rx_fis + RX_FIS_SDB;
> +				u32 f0 = le32_to_cpu(f[0]);
> +				if (f0 & (1 << 15))
> +					sata_async_notification(ap);
> +			}
> +		}
> +	}
> +
> +	/* pp->active_link is not reliable once FBS is enabled, both
> +	 * PORT_SCR_ACT and PORT_CMD_ISSUE should be checked because
> +	 * NCQ and non-NCQ commands may be in flight at the same time.
> +	 */
> +	if (pp->fbs_enabled) {
> +		if (ap->qc_active) {
> +			qc_active = readl(port_mmio + PORT_SCR_ACT);
> +			qc_active |= readl(port_mmio + PORT_CMD_ISSUE);
> +		}
> +	} else {
> +		/* pp->active_link is valid iff any command is in flight */
> +		if (ap->qc_active && pp->active_link->sactive)
> +			qc_active = readl(port_mmio + PORT_SCR_ACT);
> +		else
> +			qc_active = readl(port_mmio + PORT_CMD_ISSUE);
> +	}
> +
> +	/* Flush the IOB before servicing interrupt to ensure all data
> +	   written by the controller appears in DDR */
> +	xgene_ahci_iob_flush((struct xgene_ahci_context *) hpriv);

Tejun, to avoid some of the interrupt handling code duplication, would
it better to have a AHCI_HFLAG_FLUSH and then change

this driver to set flush

hpriv->hpriv.flush = (void *) xgene_ahci_iob_flush;

and then standard code flush when necessary

ahci_handle_port_interrupt

        /* board-specific flush before servicing completed cmds */
        if (hpriv-> flags & AHCI_HFLAG_FLUSH)
                hpriv->flush(hpriv);

Thanks,
David


> +
> +	rc = ata_qc_complete_multiple(ap, qc_active);
> +
> +	/* while resetting, invalid completions are expected */
> +	if (unlikely(rc < 0 && !resetting)) {
> +		ehi->err_mask |= AC_ERR_HSM;
> +		ehi->action |= ATA_EH_RESET;
> +		ata_port_freeze(ap);
> +	}
> +}
> +
> +static irqreturn_t xgene_ahci_interrupt(int irq, void *dev_instance)
> +{
> +	struct ata_host *host = dev_instance;
> +	struct ahci_host_priv *hpriv;
> +	unsigned int i, handled = 0;
> +	void __iomem *mmio;
> +	u32 irq_stat, irq_masked;
> +
> +	VPRINTK("ENTER\n");
> +
> +	hpriv = host->private_data;
> +	mmio = hpriv->mmio;
> +
> +	/* sigh.  0xffffffff is a valid return from h/w */
> +	irq_stat = readl(mmio + HOST_IRQ_STAT);
> +	if (!irq_stat)
> +		return IRQ_NONE;
> +
> +	irq_masked = irq_stat & hpriv->port_map;
> +
> +	spin_lock(&host->lock);
> +
> +	for (i = 0; i < host->n_ports; i++) {
> +		struct ata_port *ap;
> +
> +		if (!(irq_masked & (1 << i)))
> +			continue;
> +
> +		ap = host->ports[i];
> +		if (ap) {
> +			xgene_ahci_port_intr(ap);
> +			VPRINTK("port %u\n", i);
> +		} else {
> +			VPRINTK("port %u (no irq)\n", i);
> +			if (ata_ratelimit())
> +				dev_warn(host->dev,
> +					 "interrupt on disabled port %u\n", i);
> +		}
> +
> +		handled = 1;
> +	}
> +
> +	/* HOST_IRQ_STAT behaves as level triggered latch meaning that
> +	 * it should be cleared after all the port events are cleared;
> +	 * otherwise, it will raise a spurious interrupt after each
> +	 * valid one.  Please read section 10.6.2 of ahci 1.1 for more
> +	 * information.
> +	 *
> +	 * Also, use the unmasked value to clear interrupt as spurious
> +	 * pending event on a dummy port might cause screaming IRQ.
> +	 */
> +	writel(irq_stat, mmio + HOST_IRQ_STAT);
> +
> +	spin_unlock(&host->lock);
> +
> +	VPRINTK("EXIT\n");
> +
> +	return IRQ_RETVAL(handled);
> +}
> +
