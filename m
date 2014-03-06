From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v13 2/3] PHY: add APM X-Gene SoC 15Gbps Multi-purpose
 PHY driver
Date: Thu, 6 Mar 2014 14:23:05 +0530
Message-ID: <53183771.9070501@ti.com>
References: <1394059399-30671-1-git-send-email-lho@apm.com> <1394059399-30671-2-git-send-email-lho@apm.com> <1394059399-30671-3-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1394059399-30671-3-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>, tj@kernel.org
Cc: olof@lixom.net, arnd@arndb.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Thursday 06 March 2014 04:13 AM, Loc Ho wrote:
> This patch adds support for the APM X-Gene SoC 15Gbps Multi-purpose PHY.
> This is the physical layer interface for the corresponding host
> controller. Currently, only external clock and Gen3 SATA mode
> are supported.
>
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>   drivers/phy/Kconfig     |    7 +
>   drivers/phy/Makefile    |    2 +
>   drivers/phy/phy-xgene.c | 1756 +++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 1765 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/phy/phy-xgene.c
>
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index afa2354..221a1b7 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -64,4 +64,11 @@ config BCM_KONA_USB2_PHY
>   	help
>   	  Enable this to support the Broadcom Kona USB 2.0 PHY.
>
> +config PHY_XGENE
> +	tristate "APM X-Gene 15Gbps PHY support"
> +	depends on HAS_IOMEM && OF && (ARM64 || COMPILE_TEST)
> +	select GENERIC_PHY
> +	help
> +	  This option enables support for APM X-Gene SoC multi-purpose PHY.
> +
>   endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index b57c253..dee70f4 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -9,3 +9,5 @@ obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>   obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
>   obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
>   obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
> +obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
> +
.
.
<snip>
.
.

> +	int i;
> +
> +	rc = xgene_phy_hw_initialize(ctx, CLK_EXT_DIFF, SSC_DISABLE);
> +	if (rc) {
> +		dev_err(ctx->dev, "PHY initialize failed %d\n", rc);
> +		return rc;
> +	}
> +
> +	/* Setup clock properly after PHY configuration */
> +	if (!IS_ERR(ctx->clk)) {
> +		/* HW requires an toggle of the clock */
> +		clk_prepare_enable(ctx->clk);
> +		clk_disable_unprepare(ctx->clk);
> +		clk_prepare_enable(ctx->clk);
> +	}
> +
> +	/* Compute average value */
> +	for (i = 0; i < MAX_LANE; i++)
> +		xgene_phy_gen_avg_val(ctx, i);
> +
> +	dev_dbg(ctx->dev, "PHY initialized\n");
> +	return 0;
> +}
> +
> +static const struct phy_ops xgene_phy_ops = {
> +	.init		= xgene_phy_hw_init,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static struct phy *xgene_phy_xlate(struct device *dev,
> +				   struct of_phandle_args *args)
> +{
> +	struct xgene_phy_ctx *ctx = dev_get_drvdata(dev);
> +
> +	if (args->args_count > 0) {
> +		if (args->args[0] >= MODE_MAX)
> +			return NULL;

Are you sure you want to return NULL instead of error? NULL is 
considered a valid value for optional PHYs.
> +		ctx->mode = args->args[0];
> +	}

I think it doesn't make sense to return the phy without the 'mode'. So 
we should report error here too.

> +	return ctx->phy;
> +}
> +
> +static void xgene_phy_get_param(struct platform_device *pdev,
> +				const char *name, u32 *buffer,
> +				int count, u32 *default_val,
> +				u32 conv_factor)
> +{
> +	int i;
> +
> +	if (!of_property_read_u32_array(pdev->dev.of_node, name, buffer,
> +					count)) {
> +		for (i = 0; i < count; i++)
> +			buffer[i] /= conv_factor;
> +		return;
> +	}
> +	/* Does not exist, load default */
> +	for (i = 0; i < count; i++)
> +		buffer[i] = default_val[i % 3];
> +}
> +
> +static int xgene_phy_probe(struct platform_device *pdev)
> +{
> +	struct phy_provider *phy_provider;
> +	struct xgene_phy_ctx *ctx;
> +	struct resource *res;
> +	int rc = 0;
> +	u32 default_spd[] = DEFAULT_SATA_SPD_SEL;
> +	u32 default_txboost_gain[] = DEFAULT_SATA_TXBOOST_GAIN;
> +	u32 default_txeye_direction[] = DEFAULT_SATA_TXEYEDIRECTION;
> +	u32 default_txeye_tuning[] = DEFAULT_SATA_TXEYETUNING;
> +	u32 default_txamp[] = DEFAULT_SATA_TXAMP;
> +	u32 default_txcn1[] = DEFAULT_SATA_TXCN1;
> +	u32 default_txcn2[] = DEFAULT_SATA_TXCN2;
> +	u32 default_txcp1[] = DEFAULT_SATA_TXCP1;
> +	int i;
> +
> +	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx) {
> +		dev_err(&pdev->dev, "can't allocate PHY context\n");
remove dev_err here.. kzalloc will do that for you..
> +		return -ENOMEM;
> +	}
> +	ctx->dev = &pdev->dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "no PHY resource address\n");

same here.. you don't have to even check for return value of res. 
ioremap_resource will take care of that.
> +		rc = -EINVAL;
> +		goto error;
> +	}
> +	ctx->sds_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (!ctx->sds_base) {
> +		dev_err(&pdev->dev, "can't map PHY resource\n");

same here..

Thanks
Kishon
