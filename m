From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v17 3/4] ata: Add APM X-Gene SoC AHCI SATA host controller driver
Date: Fri, 14 Mar 2014 11:49:17 -0700
Message-ID: <CAPw-ZTnVE0B+hJKGX=EPP5mjoA7-diTvi9hxNhBuAFL2hANz+Q@mail.gmail.com>
References: <1394655573-32645-1-git-send-email-lho@apm.com>
	<1394655573-32645-3-git-send-email-lho@apm.com>
	<1394655573-32645-4-git-send-email-lho@apm.com>
	<201403141241.16599.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og119.obsmtp.com ([64.18.0.189]:56413 "HELO
	exprod5og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754948AbaCNStS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Mar 2014 14:49:18 -0400
Received: by mail-qc0-f177.google.com with SMTP id w7so3316519qcr.8
        for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2014 11:49:17 -0700 (PDT)
In-Reply-To: <201403141241.16599.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hi,

> On Wednesday 12 March 2014, Loc Ho wrote:
> > This patch adds support for the APM X-Gene SoC AHCI SATA host controller
> > driver. It requires the corresponding APM X-Gene SoC PHY driver. This
> > initial version only supports Gen3 speed.
> >
> > Signed-off-by: Loc Ho <lho@apm.com>
> > Signed-off-by: Tuan Phan <tphan@apm.com>
> > Signed-off-by: Suman Tripathi <stripathi@apm.com>
>
> Sorry I've skipped the last ten review rounds. I'm glad to see the
> code has improved so much in the meantime!
>
> I hope the points I'm making here were not already covered in the
> many previous review rounds.
>
> > +/* Controller who PHY shared with SGMII Ethernet PHY */
> > +#define XGENE_AHCI_SGMII_DTS         "apm,xgene-ahci-sgmii"
> > +
> > +/* Controller who PHY (internal reference clock macro) shared with PCIe */
> > +#define XGENE_AHCI_PCIE_DTS          "apm,xgene-ahci-pcie"
>
> Please remove these macros, they don't help anything at all
> but make it harder to follow what's going on.
>
> Regarding the actual strings, reflecting them now I think listing 'pcie'
> and 'sgmii' is not really helpful to the reader. The difference to
> the AHCI driver should not be which device it's sharing its PHY with,
> but rather how that looks from software side.
>
> The only difference in your current driver is whether this function
>
> +/* MUX CSR */
> +#define SATA_ENET_CONFIG_REG           0x00000000
> +#define  CFG_SATA_ENET_SELECT_MASK     0x00000001
> +static int xgene_ahci_mux_select(struct xgene_ahci_context *ctx)
> +{
> +       void *mux_csr = ctx->csr_base + SATA_ENET_MUX_OFFSET;
> +       u32 val;
> +
> +       val = readl(mux_csr + SATA_ENET_CONFIG_REG);
> +       val &= ~CFG_SATA_ENET_SELECT_MASK;
> +       writel(val, mux_csr + SATA_ENET_CONFIG_REG);
> +       val = readl(mux_csr + SATA_ENET_CONFIG_REG);
> +       return val & CFG_SATA_ENET_SELECT_MASK ? -1 : 0;
> +}
>
> gets called. Can you clarify what this register access does?
> If it's just setting a index into a mux output, would it make
> sense to have an optional DT property containing an integer with
> the mux setting you want to set? That way you wouldn't even
> have to have two compatible strings but just do
>
>         ret = of_property_read_u32(node, "apm,ahci-mux", &mux);
>         if (!ret)
>                 xgene_ahci_mux_select(ctx, mux);
>

Given that fact that I will break up the resource. Let's just use the
resource for the MUX to handle this. For the IP that doesn't existed,
I will just not list it.


> > +     /*
> > +      * Can't use devm_ioremap_resource due to overlapping region.
> > +      * 0xYYYY.0000 - host core
> > +      * 0xYYYY.7000 - Mux (if applicable)
> > +      * 0xYYYY.A000 - PHY indirect access
> > +      * 0xYYYY.C000 - Clock
> > +      * 0xYYYY.D000 - RAM shutdown removal
> > +      * As we map the entire region as one, it overlaps with the PHY driver.
> > +      */
> > +     ctx->csr_base = devm_ioremap(dev, res->start, resource_size(res));
> > +     if (!ctx->csr_base) {
> > +             dev_err(dev, "can't map %pR\n", res);
> > +             return -ENOMEM;
> > +     }
>
> I still think we should try not to have overlapping memory areas here.
> Could you split up the registers into another range in the reg property
> to leave the PHY registers out?

Let me do this:

1. One resource for the RAM shutdown
2. One resource for the host controller
3. One optional resource for the MUX if needed.

With #3, this also solved the MUX detection and avoid having another
node "apm,ahci-mux".

>
> > +     /* Setup DMA mask - 32 for 32-bit system and 64 for 64-bit system */
> > +     rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(8*sizeof(void *)));
> > +     if (rc) {
> > +             dev_err(dev, "Unable to set dma mask\n");
> > +             goto disable_resources;
> > +     }
>
> This is something we definitely have to fix properly. We are hitting
> the problem of dma masks for internal devices on arm32 now, and there
> is ongoing discussion about whether a device driver should touch these
> at all, or rather rely on the DT core to set up the masks in a generic
> way. This device is probably the first DMA master capable device we
> have on arm64, other than PCI devices, and we must be careful to get it
> right.
>
> In either way, the mask of the device must *not* depend on sizeof(void*):
> If the device is capable of doing 64-bit DMA, it should also be able
> to do that when running a 32-bit kernel.
>
> Please change this to DMA_BIT_MASK(64) for now, and add a comment
> explaining that it is preliminary.

okay.

>
> Also, please read the thread named "[PATCH 0/7] of: setup dma
> parameters using dma-ranges and dma-coherent" and comment there
> about what you think we should do here. I assume we will have to
> add "dma-ranges" properties in a number of places to get this
> all to work fine any 64-bit SoC. Do you know if you have any
> DMA master devices in x-gene that are not 64-bit capable?
>

I will read and follow later. We do have non-64-bit devices such as
SDIO and SPI. But these IP's have translation in the bus similar to
PCIe PIM.

-Loc
