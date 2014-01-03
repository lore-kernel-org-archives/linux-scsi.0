From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v7 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Fri, 3 Jan 2014 16:52:32 +0100
Message-ID: <201401031652.33212.arnd@arndb.de>
References: <1388708539-333-1-git-send-email-lho@apm.com>
 <1388708539-333-3-git-send-email-lho@apm.com>
 <1388708539-333-4-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1388708539-333-4-git-send-email-lho@apm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Loc Ho <lho@apm.com>
Cc: devicetree@vger.kernel.org, Suman Tripathi <stripathi@apm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jcm@redhat.com, patches@apm.com, tj@kernel.org, olof@lixom.net, Tuan Phan <tphan@apm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Friday 03 January 2014, Loc Ho wrote:
> +
> +/* Controller who PHY shared with SGMII Ethernet PHY */
> +#define XGENE_AHCI_SGMII_DTS		"apm,xgene-ahci-sgmii"
> +
> +/* Controller who PHY (internal reference clock macro) shared with PCIe */
> +#define XGENE_AHCI_PCIE_DTS		"apm,xgene-ahci-pcie"

Kill these macros. I've commented on this in the past.

Also, there really shouldn't be any difference to the SATA driver
based on what PHY is used, so the strings shouldn't be different
either.

> +/* SATA host controller CSR */
> +#define SLVRDERRATTRIBUTES_ADDR		0x00000000
> +#define SLVWRERRATTRIBUTES_ADDR		0x00000004
> +#define MSTRDERRATTRIBUTES_ADDR		0x00000008
> +#define MSTWRERRATTRIBUTES_ADDR		0x0000000c
> +#define BUSCTLREG_ADDR			0x00000014

Are these strings taken literally from the data sheet? You can probably
drop the _ADDR part.

> +#define  MSTAWAUX_COHERENT_BYPASS_SET(dst, src) \
> +		(((dst) & ~0x00000002) | (((u32)(src)<<1) & 0x00000002))
> +#define  MSTARAUX_COHERENT_BYPASS_SET(dst, src) \
> +		(((dst) & ~0x00000001) | (((u32)(src)) & 0x00000001))

The macros are only used once and don't really help readability.
Just open-code them. If you have complex macros like these
and use them multiple times, it may be better to use an inline
function.

> +static void xgene_ahci_enable_phy(struct xgene_ahci_context *ctx,
> +				  int channel, int enable)
> +{
> +	void *mmio = ctx->mmio_base;
> +	u32 val;
> +
> +	xgene_rd(mmio + PORTCFG_ADDR, &val);
> +	val = PORTADDR_SET(val, channel == 0 ? 2 : 3);
> +	xgene_wr_flush(mmio + PORTCFG_ADDR, val);
> +	xgene_rd(mmio + PORTPHY1CFG_ADDR, &val);
> +	val = PORTPHY1CFG_FRCPHYRDY_SET(val, enable);
> +	xgene_wr(mmio + PORTPHY1CFG_ADDR, val);
> +}
> +
> +static void xgene_ahci_set_phy_cfg(struct xgene_ahci_context *ctx, int channel)
> +{
> +	void *mmio = ctx->mmio_base;
> +	u32 val;
> +
> +	dev_dbg(ctx->dev, "port configure mmio 0x%p channel %d\n",
> +		mmio, channel);
> +	xgene_rd(mmio + PORTCFG_ADDR, &val);
> +	val = PORTADDR_SET(val, channel == 0 ? 2 : 3);
> +	xgene_wr_flush(mmio + PORTCFG_ADDR, val);
> +	/* Disable fix rate */
> +	xgene_wr_flush(mmio + PORTPHY1CFG_ADDR, 0x0001fffe);
> +	xgene_wr_flush(mmio + PORTPHY2CFG_ADDR, 0x5018461c);
> +	xgene_wr_flush(mmio + PORTPHY3CFG_ADDR, 0x1c081907);
> +	xgene_wr_flush(mmio + PORTPHY4CFG_ADDR, 0x1c080815);
> +	xgene_rd(mmio + PORTPHY5CFG_ADDR, &val);
> +	/* Window negotiation 0x800 to 0x400 */
> +	val = PORTPHY5CFG_RTCHG_SET(val, 0x300);
> +	xgene_wr_flush(mmio + PORTPHY5CFG_ADDR, val);
> +	xgene_rd(mmio + PORTAXICFG_ADDR, &val);
> +	val = PORTAXICFG_EN_CONTEXT_SET(val, 0x1); /* enable context mgmt */
> +	val = PORTAXICFG_OUTTRANS_SET(val, 0xe); /* Outstanding */
> +	xgene_wr_flush(mmio + PORTAXICFG_ADDR, val);
> +}

This looks like it should be part of the PHY driver?

> +	/*
> +	 * When both ACPI and DTS are enabled, custom ACPI built-in ACPI
> +	 * table, and booting via DTS, we need to skip the probe of the
> +	 * built-in ACPI table probe.
> +	 */
> +	if (!efi_enabled(EFI_BOOT) && dev->of_node == NULL)
> +		return -ENODEV;

I think I've commented on this one before too. The comment talks
about ACPI, but the code is about EFI, which is completely unrelated.
Neither the code nor the comment seems to make sense here and
you wouldn't be in this function in the first place if the device
is not defined in ACPI or in DT.

> +	/* Can't use devm_ioremap_resource due to overlapping region */
> +	hpriv->csr_base = devm_ioremap(dev, res->start, resource_size(res));
> +	if (!hpriv->csr_base) {
> +		dev_err(dev, "can't map %pR\n", res);
> +		return -ENOMEM;
> +	}

Why are the regions overlapping? That should not happen!

> +	/* Select ATA */
> +	if (of_device_is_compatible(pdev->dev.of_node,
> +		XGENE_AHCI_SGMII_DTS)) {
> +		if (xgene_ahci_mux_select(hpriv)) {
> +			dev_err(dev, "SATA mux selection failed\n");
> +			return -ENODEV;
> +		}
> +	}

What kind of mux is this? Why does the SATA driver need to care about
it? It sounds like this should be part of the pinctrl driver.

> +	/* Setup DMA mask */
> +	rc = dma_set_mask(dev, DMA_BIT_MASK(64));
> +	if (rc) {
> +		dev_err(dev, "Unable to set dma mask\n");
> +		goto error;
> +	}
> +	rc = dma_set_coherent_mask(dev, DMA_BIT_MASK(64));
> +	if (rc) {
> +		dev_err(dev, "Unable to set dma coherent mask\n");
> +		goto error;
> +	}

dma_set_mask_and_coherent?

> +
> +static const struct acpi_device_id xgene_ahci_acpi_match[] = {
> +	{"APMC0D00", 0},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(acpi, xgene_ahci_acpi_match);

Just drop the ACPI part for now. It's clear that the driver won't
work with ACPI in this state, since it would need to handle the
PHY and clock management completely differently. It's better to
add the code once it has a chance to actually work.

	Arnd
