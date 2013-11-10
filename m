From: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2 3/5] ata: Add APM X-Gene SATA driver
Date: Sun, 10 Nov 2013 14:28:10 -0800
Message-ID: <CAOesGMjEpC9-i52zYb2LtmyfV7FZQQGeeo4Umg-LXOYytZ4E-A@mail.gmail.com>
References: <1383980431-6572-1-git-send-email-lho@apm.com>
	<1383980431-6572-2-git-send-email-lho@apm.com>
	<1383980431-6572-3-git-send-email-lho@apm.com>
	<1383980431-6572-4-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qe0-f52.google.com ([209.85.128.52]:57224 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3KJW2M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Nov 2013 17:28:12 -0500
Received: by mail-qe0-f52.google.com with SMTP id w7so3864553qeb.39
        for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2013 14:28:11 -0800 (PST)
In-Reply-To: <1383980431-6572-4-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

On Fri, Nov 8, 2013 at 11:00 PM, Loc Ho <lho@apm.com> wrote:
> ata: Add APM X-Gene SATA driver

This is not a proper patch description. Look at how others document
their patches (look at git logs for drivers/ata to start with).

> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index 4e73772..41b9da3 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -106,6 +106,13 @@ config AHCI_IMX
>
>           If unsure, say N.
>
> +config SATA_XGENE
> +       tristate "APM X-Gene 6.0Gbps SATA support"
> +       depends on SATA_AHCI_PLATFORM
> +       default y if ARM64
> +       help
> +         This option enables support for APM X-Gene SoC SATA controller.
> +
>  config SATA_FSL
>         tristate "Freescale 3.0Gbps SATA support"
>         depends on FSL_SOC
> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index 46518c6..022f9d1 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -11,6 +11,8 @@ obj-$(CONFIG_SATA_SIL24)      += sata_sil24.o
>  obj-$(CONFIG_SATA_DWC)         += sata_dwc_460ex.o
>  obj-$(CONFIG_SATA_HIGHBANK)    += sata_highbank.o libahci.o
>  obj-$(CONFIG_AHCI_IMX)         += ahci_imx.o
> +sata-xgene-objs := sata_xgene.o sata_xgene_serdes.o
> +obj-$(CONFIG_SATA_XGENE)       += sata-xgene.o

Why not just doing obj-$(CONFIG_SATA_XGENE)       += sata_xgene.o
sata_xgene_serdes.o
?


> diff --git a/drivers/ata/sata_xgene.c b/drivers/ata/sata_xgene.c
> new file mode 100644
> index 0000000..1f0f883
> --- /dev/null
> +++ b/drivers/ata/sata_xgene.c
> @@ -0,0 +1,1394 @@
> +/*
> + * AppliedMicro X-Gene SoC SATA Driver
> + *
> + * Copyright (c) 2013, Applied Micro Circuits Corporation
> + * Author: Loc Ho <lho@apm.com>
> + *         Tuan Phan <tphan@apm.com>
> + *         Suman Tripathi <stripathi@apm.com>
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 3 of the License, or
> + * (at your option) any later version.

v3-only driver? I don't think we can do that -- do v2-only or
v2-or-later, please.

> +void xgene_ahci_in32(void *addr, u32 *val)

If you shorten these accessor names the code will be more readable. It
gets pretty verbose now.

>

> +void xgene_ahci_delayus(unsigned long us)
> +{
> +       udelay(us);
> +}
> +
> +void xgene_ahci_delayms(unsigned long us)
> +{
> +       mdelay(us);
> +}

There is no need to roll your own wrapper on these.


> +static int xgene_ahci_hardreset(struct ata_link *link, unsigned int *class,
> +                               unsigned long deadline)
> +{
> +       const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
> +       struct ata_port *ap = link->ap;
> +       struct ahci_port_priv *pp = ap->private_data;
> +       u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
> +       struct ata_taskfile tf;
> +       bool online;
> +       int rc;
> +       struct ata_host *host = ap->host;
> +       struct xgene_ahci_context *ctx = host->private_data;
> +       int retry = 0;
> +       u32 sstatus;
> +       int channel;
> +       int link_retry = 0;
> +       void __iomem *port_mmio;
> +       int portcmd_saved;
> +       u32 portclb_saved;
> +       u32 portclbhi_saved;
> +       u32 portrxfis_saved;
> +       u32 portrxfishi_saved;
> +       u32 val;

This is an astonishing number of local variables for a local function
that isn't all that long. Usually it's an indication of needing to
refactor into more helpers.

> +
> +       channel = xgene_ahci_get_channel(host, ap);
> +       if (channel >= MAX_AHCI_CHN_PERCTR) {
> +               *class = ATA_DEV_NONE;
> +               return 0;
> +       }
> +       ata_link_dbg(link, "SATA%d.%d APM hardreset\n", ctx->cid, channel);
> +
> +       /* As hardreset reset these CSR, let save it to restore later */
> +       port_mmio = ahci_port_base(ap);
> +       portcmd_saved = readl(port_mmio + PORT_CMD);
> +       portclb_saved = readl(port_mmio + PORT_LST_ADDR);
> +       portclbhi_saved = readl(port_mmio + PORT_LST_ADDR_HI);
> +       portrxfis_saved = readl(port_mmio + PORT_FIS_ADDR);
> +       portrxfishi_saved = readl(port_mmio + PORT_FIS_ADDR_HI);
> +       ata_link_dbg(link, "SATA%d.%d PORT_CMD 0x%08X\n", ctx->cid, channel,
> +                    portcmd_saved);
> +
> +       ahci_stop_engine(ap);
> +
> +hardreset_retry:
> +       /* clear D2H reception area to properly wait for D2H FIS */
> +       ata_tf_init(link->device, &tf);
> +       tf.command = 0x80;
> +       ata_tf_to_fis(&tf, 0, 0, d2h_fis);
> +       if (!xgene_ahci_is_A1())
> +               xgene_ahci_serdes_set_pq(ctx, channel, 1);
> +       rc = sata_link_hardreset(link, timing, deadline, &online,
> +                                ahci_check_ready);
> +       if (!xgene_ahci_is_A1())
> +               xgene_ahci_serdes_set_pq(ctx, channel, 0);
> +       /* clear all errors */
> +       xgene_ahci_in32(port_mmio + PORT_SCR_ERR, &val);
> +       xgene_ahci_out32(port_mmio + PORT_SCR_ERR, val);
> +
> +       /* Check to ensure that the disk comes up in match speed */
> +       if (online) {
> +               sata_scr_read(link, SCR_STATUS, &sstatus);
> +               if (!retry) {
> +                       if (((sstatus >> 4) & 0xf) == 2) {
> +                               /* For Gen2 and first time, let's check again
> +                                * with Gen2 serdes to ensure actual Gen2 disk.
> +                                */
> +                               xgene_ahci_serdes_force_gen(ctx, channel,
> +                                                           SPD_SEL_GEN2);
> +                               xgene_ahci_phy_restart(link);
> +                               ++retry;
> +                               goto hardreset_retry;
> +                       } else if (((sstatus >> 4) & 0xf) == 1) {
> +                               /* For Gen1 and first time, let's check again
> +                                * with Gen1 serdes to ensure actual Gen1 disk.
> +                                */
> +                               xgene_ahci_serdes_force_gen(ctx, channel,
> +                                                           SPD_SEL_GEN1);
> +                               xgene_ahci_phy_restart(link);
> +                               ++retry;
> +                               goto hardreset_retry;
> +                       }
> +               }
> +       } else if (link_retry < 4) {
> +               link_retry++;
> +               goto hardreset_retry;
> +       }
> +       ata_link_dbg(link, "SATA%d.%d post-hardrest PORT_CMD 0x%08X\n",
> +                    ctx->cid, channel, readl(port_mmio + PORT_CMD));

Given the loop above, I wonder if the hardreset code should be moved
out. That'll move out a bunch of the variables as well.

> +static const char *xgene_ahci_chip_revision(void)
> +{
> +       static const char *revision = NULL;
> +
> +       if (!revision) {
> +               #define EFUSE0_SHADOW_VERSION_SHIFT     28
> +               #define EFUSE0_SHADOW_VERSION_MASK      0xF
> +               void *efuse;
> +               void *jtag;
> +               u32 efuse0;
> +               u32 jtagid;
> +
> +               /* Part registers are fixed in X-Gene. */
> +#if defined(CONFIG_ARCH_MSLIM)

I don't think this config exists in the kernel?

> +               /* MSLIM address map uses 0xC000.0000 */
> +               efuse = ioremap(0xC054A000ULL, 0x100);
> +#else
> +               /* Potenza address map uses 0x1000.0000 */
> +               efuse = ioremap(0x1054A000ULL, 0x100);

This is a magic address, and should probably come from somewhere else.

Is this a whole-chip chip id? if so, it doesn't belong in the SATA driver.

> +#endif
> +               jtag = ioremap(0x17000004ULL, 0x100);

Same here w.r.t. address.

> +               if (efuse == NULL || jtag == NULL) {
> +                       if (efuse)
> +                               iounmap(efuse);
> +                       if (jtag)
> +                               iounmap(jtag);
> +                       return revision = "A1";
> +               }
> +               efuse0 = (readl(efuse) >> EFUSE0_SHADOW_VERSION_SHIFT)
> +                               & EFUSE0_SHADOW_VERSION_MASK;
> +               iounmap(efuse);
> +               jtagid = readl(jtag);
> +               iounmap(jtag);
> +               switch (efuse0) {
> +               case 0x00:
> +                       if (jtagid & 0x10000000)
> +                               return revision = "A2";
> +                       else
> +                               return revision = "A1";
> +               case 0x01:      /* A2 */
> +                       return revision = "A2";
> +               case 0x02:      /* A3 */
> +                       return revision = "A3";
> +               case 0x03:      /* B0 */
> +                       return revision = "B0";
> +               default:        /* Unknown */
> +                       return revision = "Unknown";
> +               }
> +       }
> +       return revision;
> +}
> +
> +int xgene_ahci_is_A1(void)
> +{
> +       return strcmp(xgene_ahci_chip_revision(), "A1") == 0 ? 1 : 0;

Whoa. So you have a lookup that looks up an integere, converts it to a
string, returns that and then you compare the string? Bzzt.

Also, keep in mind if it makes sense to support the early chipset
versions in the upstream kernel. You still have downstream patches for
some of the really early silicon, and if you're like any other company
I've worked at, there will be very few of the early chips in use once
the newer versions come out and are available in volume. So unless you
have third party users with the early revs and they expect to run a
vanilla mainline kernel on it, I wouldn't bother upstreaming some of
the early workarounds for bugs.

> +/* Flush the IOB to ensure all SATA controller writes completed before
> +   servicing the completed command. */
> +static int xgene_ahci_iob_flush(struct xgene_ahci_context *ctx)
> +{
> +       if (ctx->ahbc_io_base == NULL) {
> +               void *ahbc_base;
> +               u32 val;
> +
> +               /* The AHBC address is fixed in X-Gene */
> +               ahbc_base = devm_ioremap(ctx->dev, 0x1F2A0000, 0x80000);

Even if fixed, having a defined constant makes sense here and below.



> +static int xgene_ahci_probe(struct platform_device *pdev)
> +{

This function is much much too long. Be see below.

> +       struct xgene_ahci_context *hpriv;
> +       struct ata_port_info pi = xgene_ahci_port_info[0];
> +       const struct ata_port_info *ppi[] = { &pi, NULL };
> +       struct ata_host *host;
> +       struct resource res;
> +       char res_name[30];
> +       int n_ports;
> +       int rc;
> +       int i;
> +       u32 val;
> +       u32 rxclk_inv;
> +       u32 gen_sel;
> +       u32 serdes_diff_clk;
> +
> +       /* When both ACPi and DTS are enabled, custom ACPI built-in ACPI
> +          table, and booting via DTS, we need to skip the probe of the
> +          built-in ACPI table probe. */
> +       if (!efi_enabled(EFI_BOOT) && pdev->dev.of_node == NULL)
> +               return -ENODEV;
> +
> +       /* Check if the entry is disabled for OF only */
> +       if (!efi_enabled(EFI_BOOT) &&
> +           !of_device_is_available(pdev->dev.of_node))
> +               return -ENODEV;
> +#if defined(CONFIG_ACPI)
> +       if (efi_enabled(EFI_BOOT)) {
> +               struct acpi_device *device;
> +
> +               if (acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &device))
> +                       return -ENODEV;
> +
> +               if (acpi_bus_get_status(device) || !device->status.present)
> +                       return -ENODEV;
> +       }
> +#endif
> +
> +       hpriv = devm_kzalloc(&pdev->dev, sizeof(*hpriv), GFP_KERNEL);
> +       if (!hpriv) {
> +               dev_err(&pdev->dev, "can't allocate host context\n");
> +               return -ENOMEM;
> +       }
> +       hpriv->dev = &pdev->dev;
> +
> +       rc = xgene_ahci_get_resource(pdev, 0, &res);
> +       if (rc != 0) {
> +               dev_err(&pdev->dev, "no AHCI resource address\n");
> +               goto error;
> +       }
> +       hpriv->mmio_phys = res.start;
> +       hpriv->mmio_base = devm_ioremap(&pdev->dev, res.start,
> +                                       resource_size(&res));
> +       if (!hpriv->mmio_base) {
> +               dev_err(&pdev->dev, "can't map MMIO resource\n");
> +               rc = -ENOMEM;
> +               goto error;
> +       }
> +       hpriv->hpriv.mmio = hpriv->mmio_base;
> +
> +       rc = xgene_ahci_get_resource(pdev, 1, &res);
> +       if (rc != 0) {
> +               dev_err(&pdev->dev, "no Serdes resource address\n");
> +               goto error;
> +       }
> +       hpriv->csr_phys = res.start;
> +       hpriv->csr_base = devm_ioremap(&pdev->dev, res.start,
> +                                      resource_size(&res));
> +       if (!hpriv->csr_base) {
> +               dev_err(&pdev->dev, "can't map Serdes CSR resource\n");
> +               rc = -ENOMEM;
> +               goto error;
> +       }
> +
> +       rc = xgene_ahci_get_str_param(pdev, "clock-names", "CLNM", res_name,
> +                                     sizeof(res_name));
> +       if (rc) {
> +               dev_err(&pdev->dev, "no clock name resource\n");
> +               goto error;
> +       }
> +       hpriv->hpriv.clk = clk_get(&pdev->dev, res_name);
> +       if (!IS_ERR(hpriv->hpriv.clk)) {
> +               rc = clk_prepare_enable(hpriv->hpriv.clk);
> +               if (rc) {
> +                       dev_err(&pdev->dev, "clock prepare enable failed\n");
> +                       goto error;
> +               }
> +       } else {
> +               dev_warn(&pdev->dev, "no clock\n");
> +       }
> +       if (strcmp(res_name, "eth01clk") == 0)
> +               hpriv->cid = 0;
> +       else if (strcmp(res_name, "eth23clk") == 0)
> +               hpriv->cid = 1;
> +       else
> +               hpriv->cid = 2;
> +
> +       if (hpriv->cid == 2) {
> +               rc = xgene_ahci_get_resource(pdev, 2, &res);
> +               if (rc != 0) {
> +                       dev_err(&pdev->dev, "no SATA/PCIE resource address\n");
> +                       goto error;
> +               }
> +               hpriv->pcie_base = devm_ioremap(&pdev->dev, res.start,
> +                                               resource_size(&res));
> +               if (!hpriv->pcie_base) {
> +                       dev_err(&pdev->dev, "can't map SATA/PCIe resource\n");
> +                       rc = -ENOMEM;
> +                       goto error;
> +               }
> +       }
> +
> +       /* Map in the IOB register */
> +       rc = xgene_ahci_iob_flush(hpriv);
> +       if (rc)
> +               goto error;
> +
> +       dev_dbg(&pdev->dev,
> +               "SATA%d PHY PAddr 0x%016LX VAddr 0x%p Mmio PAddr 0x%016LX VAddr 0x%p\n",
> +               hpriv->cid, hpriv->csr_phys, hpriv->csr_base, hpriv->mmio_phys,
> +               hpriv->mmio_base);
> +
> +       /* Custom Serdes override paraemter */

This doesn't quite make sense for me. In the case of ACPI firmware on
server, the firmware can setup SERDES on its own. And if you want to
provide new override values, you need to rebuild the firmware anyway,
so there's no way to supply the overrides separately. Thus it really
makes no sense to do these in the ACPI case.

For DT the case is slightly different since the DT is supplied
separate from the firmware image, so it's possible to ship newer
settings. Still, even there there's no reason to not have firmware do
the setup in most cases.

[...]

> diff --git a/drivers/ata/sata_xgene.h b/drivers/ata/sata_xgene.h
> new file mode 100644
> index 0000000..138152e
> --- /dev/null
> +++ b/drivers/ata/sata_xgene.h
> @@ -0,0 +1,112 @@
> +/*
> + * AppliedMicro X-Gene SATA PHY driver
> + *
> + * Copyright (c) 2013, Applied Micro Circuits Corporation
> + * Author: Loc Ho <lho@apm.com>
> + *         Tuan Phan <tphan@apm.com>
> + *         Suman Tripathi <stripathi@apm.com>
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 3 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __SATA_XGENE_H__
> +#define __SATA_XGENE_H__
> +
> +#include "ahci.h"      /* for ahci_host_priv */
> +
> +/* Default tuning parameters */
> +#define XGENE_SERDES_VAL_NOT_SET       ~0x0
> +#define CTLE_EQ                                0x9
> +#define PQ_REG                         0x8
> +#define CTLE_EQ_A2                     0x2
> +#define PQ_REG_A2                      0xa
> +#define SPD_SEL                                0x5
> +
> +/*
> + * Configure Reference clock (clock type):
> + *  External differential 0
> + *  Internal differential 1
> + *  Internal single ended 2
> + */
> +#define SATA_CLK_EXT_DIFF              0
> +#define SATA_CLK_INT_DIFF              1
> +#define SATA_CLK_INT_SING              2
> +
> +#define SPD_SEL_GEN2                   0x3
> +#define SPD_SEL_GEN1                   0x1
> +
> +struct xgene_ahci_context {
> +       struct ahci_host_priv  hpriv;
> +       struct device *dev;
> +       u8 cid;                 /* Controller ID */
> +       int irq;                /* IRQ */
> +       void *csr_base;         /* CSR base address of IP - serdes */
> +       void *mmio_base;        /* AHCI I/O base address */
> +       void *pcie_base;        /* Shared Serdes CSR in PCIe 4/5 domain */
> +       void *ahbc_io_base;     /* Used for IOB flushing */
> +       u64 csr_phys;           /* Physical address of CSR base address */
> +       u64 mmio_phys;          /* Physical address of MMIO base address */
> +
> +       /* Override Serdes parameters */
> +       u32 ctrl_eq_A1; /* Serdes Reg 1 RX/TX ctrl_eq value for A1 */
> +       u32 ctrl_eq;    /* Serdes Reg 1 RX/TX ctrl_eq value */
> +       u32 pq_A1;      /* Serdes Reg 125 pq value for A1 */
> +       u32 pq;         /* Serdes Reg 125 pq value */
> +       u32 pq_sign;    /* Serdes Reg 125 pq sign */
> +       u32 loopback_buf_en_A1; /* Serdes Reg 4 Tx loopback buf enable for A1 */
> +       u32 loopback_buf_en;    /* Serdes Reg 4 Tx loopback buf enable */
> +       u32 loopback_ena_ctle_A1; /* Serdes Reg 7 loopback enable ctrl for A1 */
> +       u32 loopback_ena_ctle;  /* Serdes Reg 7 loopback enable ctrl */
> +       u32 spd_sel_cdr_A1;     /* Serdes Reg 61 spd sel cdr value for A1*/
> +       u32 spd_sel_cdr;        /* Serdes Reg 61 spd sel cdr value */
> +       u32 use_gen_avg;        /* Use generate average value */
> +
> +       u32 coherent;           /* Coherent IO */
> +};
> +
> +void xgene_ahci_in32(void *addr, u32 *val);
> +void xgene_ahci_out32(void *addr, u32 val);
> +void xgene_ahci_out32_flush(void *addr, u32 val);
> +void xgene_ahci_delayus(unsigned long us);
> +void xgene_ahci_delayms(unsigned long ms);
> +int xgene_ahci_is_A1(void);
> +
> +int xgene_ahci_serdes_init(struct xgene_ahci_context *ctx,
> +       int gen_sel, int clk_type, int rxwclk_inv);
> +void xgene_ahci_serdes_gen_avg_val(struct xgene_ahci_context *ctx, int channel);
> +void xgene_ahci_serdes_force_lat_summer_cal(struct xgene_ahci_context *ctx,
> +       int channel);
> +void xgene_ahci_serdes_reset_rxa_rxd(struct xgene_ahci_context *ctx,
> +       int channel);
> +void xgene_ahci_serdes_force_gen(struct xgene_ahci_context *ctx, int channel,
> +       int gen);
> +void xgene_ahci_serdes_set_pq(struct xgene_ahci_context *ctx, int channel,
> +       int data);
> +int xgene_ahci_port_start(struct ata_port *ap);
> +int xgene_ahci_port_resume(struct ata_port *ap);
> +#if defined(CONFIG_ARCH_MSLIM)

Again, MSLIM doesn't make sense here.

> +void xgene_ahci_fill_cmd_slot(struct ahci_port_priv *pp,
> +       unsigned int tag, u32 opts);
> +u64 xgene_ahci_to_axi(dma_addr_t addr);
> +void xgene_ahci_dflush(void *addr, int size);
> +int xgene_ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
> +       struct ata_taskfile *tf, int is_cmd, u16 flags,
> +       unsigned long timeout_msec);
> +#else
> +#define xgene_ahci_fill_cmd_slot       ahci_fill_cmd_slot
> +#define xgene_ahci_exec_polled_cmd     ahci_exec_polled_cmd
> +#define xgene_ahci_to_axi(x)           (x)
> +#define xgene_ahci_dflush(x, ...)
> +#endif
> +
> +#endif /* __SATA_XGENE_H__ */


-Olof
