From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v16 3/4] ata: Add APM X-Gene SoC AHCI SATA host controller
 driver
Date: Wed, 12 Mar 2014 19:10:50 +0100
Message-ID: <2172234.huOH9CEWA3@amdc1032>
References: <1394575895-7039-1-git-send-email-lho@apm.com>
 <1394575895-7039-3-git-send-email-lho@apm.com>
 <1394575895-7039-4-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7Bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <1394575895-7039-4-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: olof@lixom.net, tj@kernel.org, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org


Hi,

Thanks for updating this patch, there are still some issue left though
(please see below).

On Tuesday, March 11, 2014 04:11:34 PM Loc Ho wrote:
> This patch adds support for the APM X-Gene SoC AHCI SATA host controller
> driver. It requires the corresponding APM X-Gene SoC PHY driver. This
> initial version only supports Gen3 speed.
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>  drivers/ata/Kconfig      |    7 +
>  drivers/ata/Makefile     |    1 +
>  drivers/ata/ahci_xgene.c |  490 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 498 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/ata/ahci_xgene.c
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index 93fc2f0..9de4ca5 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -115,6 +115,13 @@ config AHCI_SUNXI
>  
>  	  If unsure, say N.
>  
> +config AHCI_XGENE
> +	tristate "APM X-Gene 6.0Gbps AHCI SATA host controller support"
> +	depends on SATA_AHCI_PLATFORM && (ARM64 || COMPILE_TEST)
> +	select PHY_XGENE
> +	help
> +	 This option enables support for APM X-Gene SoC SATA host controller.
> +
>  config SATA_FSL
>  	tristate "Freescale 3.0Gbps SATA support"
>  	depends on FSL_SOC
> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index 246050b..72b423b 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -12,6 +12,7 @@ obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
>  obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
>  obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o
>  obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o
> +obj-$(CONFIG_AHCI_XGENE)	+= ahci_xgene.o
>  
>  # SFF w/ custom DMA
>  obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
> diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
> new file mode 100644
> index 0000000..df37c78
> --- /dev/null
> +++ b/drivers/ata/ahci_xgene.c

[...]

> +static struct ata_port_operations xgene_ahci_ops = {
> +	.inherits = &ahci_ops,
> +	.hardreset = xgene_ahci_hardreset,
> +	.read_id = xgene_ahci_read_id,
> +};

[...]

> +static int xgene_ahci_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct ahci_host_priv *hpriv;
> +	struct xgene_ahci_context *ctx;
> +	struct resource *res;
> +	int rc;
> +
> +	hpriv = ahci_platform_get_resources(pdev);
> +	if (IS_ERR(hpriv))
> +		return PTR_ERR(hpriv);
> +
> +	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx) {
> +		dev_err(dev, "can't allocate host context\n");
> +		return -ENOMEM;
> +	}
> +	hpriv->plat_data = ctx;
> +	ctx->hpriv = hpriv;
> +	ctx->dev = dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!res) {
> +		dev_err(dev, "no csr space\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Can't use devm_ioremap_resource due to overlapping region.
> +	 * 0xYYYY.0000 - host core
> +	 * 0xYYYY.7000 - Mux (if applicable)
> +	 * 0xYYYY.A000 - PHY indirect access
> +	 * 0xYYYY.C000 - Clock
> +	 * 0xYYYY.D000 - RAM shutdown removal
> +	 * As we map the entire region as one, it overlaps with the PHY driver.
> +	 */
> +	ctx->csr_base = devm_ioremap(dev, res->start, resource_size(res));
> +	if (!ctx->csr_base) {
> +		dev_err(dev, "can't map %pR\n", res);
> +		return -ENOMEM;
> +	}
> +
> +	dev_dbg(dev, "VAddr 0x%p Mmio VAddr 0x%p\n", ctx->csr_base,
> +		hpriv->mmio);
> +
> +	/* Select ATA */
> +	if (of_device_is_compatible(pdev->dev.of_node,
> +		XGENE_AHCI_SGMII_DTS)) {
> +		if (xgene_ahci_mux_select(ctx)) {
> +			dev_err(dev, "SATA mux selection failed\n");
> +			return -ENODEV;
> +		}
> +	}
> +
> +	/* Due to errata, HW requires full toggle transition */
> +	rc = ahci_platform_enable_clks(hpriv);
> +	if (rc)
> +		goto disable_resources;
> +	ahci_platform_disable_clks(hpriv);
> +
> +	rc = ahci_platform_enable_resources(hpriv);
> +	if (rc)
> +		goto disable_resources;
> +
> +	/* Configure the host controller */
> +	xgene_ahci_hw_init(hpriv);
> +
> +	/* Setup DMA mask - 32 for 32-bit system and 64 for 64-bit system */
> +	rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(8*sizeof(void *)));
> +	if (rc) {
> +		dev_err(dev, "Unable to set dma mask\n");
> +		phy_exit(hpriv->phy);
> +		goto disable_resources;

Since the code has been switched to use generic ahci_platform ->phy
support phy_exit() is now handled by ahci_platform_disable_resources()
and the direct call should be removed.

> +	}
> +
> +	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info, 0, 0);
> +	if (rc) {
> +		phy_exit(hpriv->phy);

ditto

> +		goto disable_resources;
> +	}
> +
> +	dev_dbg(dev, "X-Gene SATA host controller initialized\n");
> +	return 0;
> +
> +disable_resources:
> +	ahci_platform_disable_resources(hpriv);
> +	return rc;
> +}
> +
> +static const struct of_device_id xgene_ahci_of_match[] = {
> +	{.compatible = XGENE_AHCI_SGMII_DTS,},
> +	{.compatible = XGENE_AHCI_PCIE_DTS,},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, xgene_ahci_of_match);
> +
> +static struct platform_driver xgene_ahci_driver = {
> +	.probe = xgene_ahci_probe,
> +	.remove = ata_platform_remove_one,

It is good to use ata_platform_remove_one() here but some code still needs
to callback ahci_platform_disable_resources() before the driver is removed
completely.  The way other drivers do it is to define custom ->host_stop
method and add it to port ops (xgene_ahci_ops in this case).  For X-Gene
AHCI driver ->host_stop function can be quite simple and look like this:

static void xgene_ahci_host_stop(struct ata_host *host)
{
	struct ahci_host_priv *hpriv = host->private_data;

	ahci_platform_disable_resources(hpriv);
}

> +	.driver = {
> +		.name = "xgene-ahci",
> +		.owner = THIS_MODULE,
> +		.of_match_table = xgene_ahci_of_match,
> +	},

Power Management support is missing for this driver.  If your platform
doesn't support Suspend to RAM yet it would be good to add a comment
about this explaining the lack of PM.  Otherwise it should be fixed (you
can take a look at ahci_imx.c and ahci_sunxi.c for examples).

Otherwise the driver looks good to me and (FWIW) you can add:

	Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Once the aforementioned issues are fixed.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

