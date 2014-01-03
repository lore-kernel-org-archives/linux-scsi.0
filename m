From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v7 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Fri, 3 Jan 2014 11:59:12 -0800
Message-ID: <CAPw-ZT=0FR8fC+-WUxS4ehh1KC6vyJZLUj+VWKeDOra4hm9oQQ@mail.gmail.com>
References: <1388708539-333-1-git-send-email-lho@apm.com>
	<1388708539-333-3-git-send-email-lho@apm.com>
	<1388708539-333-4-git-send-email-lho@apm.com>
	<201401031652.33212.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:35847 "HELO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753199AbaACT7N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2014 14:59:13 -0500
Received: by mail-qa0-f51.google.com with SMTP id o15so847944qap.10
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jan 2014 11:59:12 -0800 (PST)
In-Reply-To: <201401031652.33212.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hi,

>> +/* Controller who PHY shared with SGMII Ethernet PHY */
>> +#define XGENE_AHCI_SGMII_DTS         "apm,xgene-ahci-sgmii"
>> +
>> +/* Controller who PHY (internal reference clock macro) shared with PCIe */
>> +#define XGENE_AHCI_PCIE_DTS          "apm,xgene-ahci-pcie"
>
> Kill these macros. I've commented on this in the past.
>
> Also, there really shouldn't be any difference to the SATA driver
> based on what PHY is used, so the strings shouldn't be different
> either.

The only need for this is the MUX when the PHY is shared between SGMII
and SATA. If we get rip of the MUX code, we can drop this. MUX
discussion is below.

>
>> +/* SATA host controller CSR */
>> +#define SLVRDERRATTRIBUTES_ADDR              0x00000000
>> +#define SLVWRERRATTRIBUTES_ADDR              0x00000004
>> +#define MSTRDERRATTRIBUTES_ADDR              0x00000008
>> +#define MSTWRERRATTRIBUTES_ADDR              0x0000000c
>> +#define BUSCTLREG_ADDR                       0x00000014
>
> Are these strings taken literally from the data sheet? You can probably
> drop the _ADDR part.

These names are directly from the programming reference manual. I will
get rip of the _ADDR for both drivers - host and PHY.

>
>> +#define  MSTAWAUX_COHERENT_BYPASS_SET(dst, src) \
>> +             (((dst) & ~0x00000002) | (((u32)(src)<<1) & 0x00000002))
>> +#define  MSTARAUX_COHERENT_BYPASS_SET(dst, src) \
>> +             (((dst) & ~0x00000001) | (((u32)(src)) & 0x00000001))
>
> The macros are only used once and don't really help readability.
> Just open-code them. If you have complex macros like these
> and use them multiple times, it may be better to use an inline
> function.

For these particular one, I will get rip of them.

>
>> +static void xgene_ahci_enable_phy(struct xgene_ahci_context *ctx,
>> +                               int channel, int enable)
>> +{
>> +     void *mmio = ctx->mmio_base;
>> +     u32 val;
>> +
>> +     xgene_rd(mmio + PORTCFG_ADDR, &val);
>> +     val = PORTADDR_SET(val, channel == 0 ? 2 : 3);
>> +     xgene_wr_flush(mmio + PORTCFG_ADDR, val);
>> +     xgene_rd(mmio + PORTPHY1CFG_ADDR, &val);
>> +     val = PORTPHY1CFG_FRCPHYRDY_SET(val, enable);
>> +     xgene_wr(mmio + PORTPHY1CFG_ADDR, val);
>> +}
>> +
>> +static void xgene_ahci_set_phy_cfg(struct xgene_ahci_context *ctx, int channel)
>> +{
>> +     void *mmio = ctx->mmio_base;
>> +     u32 val;
>> +
>> +     dev_dbg(ctx->dev, "port configure mmio 0x%p channel %d\n",
>> +             mmio, channel);
>> +     xgene_rd(mmio + PORTCFG_ADDR, &val);
>> +     val = PORTADDR_SET(val, channel == 0 ? 2 : 3);
>> +     xgene_wr_flush(mmio + PORTCFG_ADDR, val);
>> +     /* Disable fix rate */
>> +     xgene_wr_flush(mmio + PORTPHY1CFG_ADDR, 0x0001fffe);
>> +     xgene_wr_flush(mmio + PORTPHY2CFG_ADDR, 0x5018461c);
>> +     xgene_wr_flush(mmio + PORTPHY3CFG_ADDR, 0x1c081907);
>> +     xgene_wr_flush(mmio + PORTPHY4CFG_ADDR, 0x1c080815);
>> +     xgene_rd(mmio + PORTPHY5CFG_ADDR, &val);
>> +     /* Window negotiation 0x800 to 0x400 */
>> +     val = PORTPHY5CFG_RTCHG_SET(val, 0x300);
>> +     xgene_wr_flush(mmio + PORTPHY5CFG_ADDR, val);
>> +     xgene_rd(mmio + PORTAXICFG_ADDR, &val);
>> +     val = PORTAXICFG_EN_CONTEXT_SET(val, 0x1); /* enable context mgmt */
>> +     val = PORTAXICFG_OUTTRANS_SET(val, 0xe); /* Outstanding */
>> +     xgene_wr_flush(mmio + PORTAXICFG_ADDR, val);
>> +}
>
> This looks like it should be part of the PHY driver?

There are the corresponding configure on the host controller side. It
is not part of the PHY. Each host such as SATA, SGMII, or PCIe has its
own version of these registers. It can be completely different between
SATA and PCIe for example.

>
>> +     /*
>> +      * When both ACPI and DTS are enabled, custom ACPI built-in ACPI
>> +      * table, and booting via DTS, we need to skip the probe of the
>> +      * built-in ACPI table probe.
>> +      */
>> +     if (!efi_enabled(EFI_BOOT) && dev->of_node == NULL)
>> +             return -ENODEV;
>
> I think I've commented on this one before too. The comment talks
> about ACPI, but the code is about EFI, which is completely unrelated.
> Neither the code nor the comment seems to make sense here and
> you wouldn't be in this function in the first place if the device
> is not defined in ACPI or in DT.

Let remove them for the time being. Unless one has an custom ACPI
table built in the kernel, it isn't a problem.

>
>> +     /* Can't use devm_ioremap_resource due to overlapping region */
>> +     hpriv->csr_base = devm_ioremap(dev, res->start, resource_size(res));
>> +     if (!hpriv->csr_base) {
>> +             dev_err(dev, "can't map %pR\n", res);
>> +             return -ENOMEM;
>> +     }
>
> Why are the regions overlapping? That should not happen!

Each host controller/PHY includes the following resource:

0xXXXX.0000 for the host core register
0xXXXX.7000 for the mux select if shared with SGMII
0xXXXX.A000 for the PHY indirect access
0xXXXX.C000 for the host/PHY clocks
0xXXXX.D000 for the RAM shutdown removal

As I only used one resource register of size 64K, it overlapped with
the 0xXXXX.A000 mapped by the PHY already. If you believe it is better
that I have two resources to map the host core/mux and the RAM
shutdown removal resources, then ok. let me know.

>
>> +     /* Select ATA */
>> +     if (of_device_is_compatible(pdev->dev.of_node,
>> +             XGENE_AHCI_SGMII_DTS)) {
>> +             if (xgene_ahci_mux_select(hpriv)) {
>> +                     dev_err(dev, "SATA mux selection failed\n");
>> +                     return -ENODEV;
>> +             }
>> +     }
>
> What kind of mux is this? Why does the SATA driver need to care about
> it? It sounds like this should be part of the pinctrl driver.

This is an internal mux that select either the SGMII or SATA. The
default value is to select SGMII. Therefore, to enable SATA, it musts
be cleared to 0. Are you suggesting that I write another driver to
clear this register? It is an simple register writes - far too simple
to worth an driver itself as it only applies to SATA.

>
>> +     /* Setup DMA mask */
>> +     rc = dma_set_mask(dev, DMA_BIT_MASK(64));
>> +     if (rc) {
>> +             dev_err(dev, "Unable to set dma mask\n");
>> +             goto error;
>> +     }
>> +     rc = dma_set_coherent_mask(dev, DMA_BIT_MASK(64));
>> +     if (rc) {
>> +             dev_err(dev, "Unable to set dma coherent mask\n");
>> +             goto error;
>> +     }
>
> dma_set_mask_and_coherent?

okay.

>
>> +
>> +static const struct acpi_device_id xgene_ahci_acpi_match[] = {
>> +     {"APMC0D00", 0},
>> +     {},
>> +};
>> +MODULE_DEVICE_TABLE(acpi, xgene_ahci_acpi_match);
>
> Just drop the ACPI part for now. It's clear that the driver won't
> work with ACPI in this state, since it would need to handle the
> PHY and clock management completely differently. It's better to
> add the code once it has a chance to actually work.
>

Okay... I will remove all ACPI stuff for now.

-Loc
