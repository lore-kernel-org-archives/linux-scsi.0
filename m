From: Chunfeng Yun <chunfeng.yun-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 6/7] phy: mediatek: Add UFS M-PHY driver
Date: Fri, 1 Mar 2019 15:13:23 +0800
Message-ID: <1551424403.2210.56.camel@mhfsdcap03>
References: <1551252192-535-1-git-send-email-stanley.chu@mediatek.com>
 <1551252192-535-8-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1551252192-535-8-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kishon-l0cyMroinI0@public.gmane.org, avri.altman-Sjgp3cTcYWE@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, vivek.gautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi, Stanley

On Wed, 2019-02-27 at 15:23 +0800, Stanley Chu wrote:
> Add UFS M-PHY driver on MediaTek chipsets.
> 
> Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/phy/mediatek/Kconfig       |   9 ++
>  drivers/phy/mediatek/Makefile      |   1 +
>  drivers/phy/mediatek/phy-mtk-ufs.c | 239 +++++++++++++++++++++++++++++
>  3 files changed, 249 insertions(+)
>  create mode 100644 drivers/phy/mediatek/phy-mtk-ufs.c
> 
> diff --git a/drivers/phy/mediatek/Kconfig b/drivers/phy/mediatek/Kconfig
> index 8857d00b3c65..4a20110a511d 100644
> --- a/drivers/phy/mediatek/Kconfig
> +++ b/drivers/phy/mediatek/Kconfig
> @@ -21,3 +21,12 @@ config PHY_MTK_XSPHY
>  	  Enable this to support the SuperSpeedPlus XS-PHY transceiver for
>  	  USB3.1 GEN2 controllers on MediaTek chips. The driver supports
>  	  multiple USB2.0, USB3.1 GEN2 ports.
> +
> +config PHY_MTK_UFS
> +	tristate "MediaTek UFS M-PHY driver"
> +	depends on ARCH_MEDIATEK && OF
> +	select GENERIC_PHY
> +	help
> +	  Support for UFS M-PHY on MediaTek chipsets. Enable this to provide
> +	  vendor-specific initialization, power on and off flow of specified
> +	  M-PHYs.
> diff --git a/drivers/phy/mediatek/Makefile b/drivers/phy/mediatek/Makefile
> index ee49edc97ee9..14e9aa0b8aa4 100644
> --- a/drivers/phy/mediatek/Makefile
> +++ b/drivers/phy/mediatek/Makefile
> @@ -5,3 +5,4 @@
>  
>  obj-$(CONFIG_PHY_MTK_TPHY)		+= phy-mtk-tphy.o
>  obj-$(CONFIG_PHY_MTK_XSPHY)		+= phy-mtk-xsphy.o
> +obj-$(CONFIG_PHY_MTK_UFS)		+= phy-mtk-ufs.o
> diff --git a/drivers/phy/mediatek/phy-mtk-ufs.c b/drivers/phy/mediatek/phy-mtk-ufs.c
> new file mode 100644
> index 000000000000..7375ad83af05
> --- /dev/null
> +++ b/drivers/phy/mediatek/phy-mtk-ufs.c
> @@ -0,0 +1,239 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 MediaTek Inc.
> + * Author: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +
> +/* mphy register and offsets */
> +#define MP_GLB_DIG_8C               0x008C
> +#define FRC_PLL_ISO_EN              BIT(8)
> +#define PLL_ISO_EN                  BIT(9)
> +#define FRC_FRC_PWR_ON              BIT(10)
> +#define PLL_PWR_ON                  BIT(11)
> +
> +#define MP_LN_DIG_RX_9C             0xA09C
> +#define FSM_DIFZ_FRC                BIT(18)
> +
> +#define MP_LN_DIG_RX_AC             0xA0AC
> +#define FRC_RX_SQ_EN                BIT(0)
> +#define RX_SQ_EN                    BIT(1)
> +
> +#define MP_LN_RX_44                 0xB044
> +#define FRC_CDR_PWR_ON              BIT(17)
> +#define CDR_PWR_ON                  BIT(18)
> +#define FRC_CDR_ISO_EN              BIT(19)
> +#define CDR_ISO_EN                  BIT(20)
> +
> +#define mphy_readl(phy, ofs) readl((phy)->mmio + (ofs))
> +#define mphy_writel(phy, val, ofs) writel((val), (phy)->mmio + (ofs))
> +
> +struct ufs_mtk_phy {
> +	struct device *dev;
> +	void __iomem *mmio;
> +	struct clk *mp_clk;
> +	struct clk *unipro_clk;
> +};
> +
> +static inline void mphy_set_bit(struct ufs_mtk_phy *phy, u32 reg, u32 ofs)
> +{
> +	u32 val;
> +
> +	val = mphy_readl(phy, reg);
> +	val |= ofs;
> +	mphy_writel(phy, val, reg);
> +}
> +
> +static inline void mphy_clr_bit(struct ufs_mtk_phy *phy, u32 reg, u32 ofs)
> +{
> +	u32 val;
> +
> +	val = mphy_readl(phy, reg);
> +	val &= ~ofs;
> +	mphy_writel(phy, val, reg);
> +}
> +
> +static struct ufs_mtk_phy *get_ufs_mtk_phy(struct phy *generic_phy)
> +{
> +	return (struct ufs_mtk_phy *)phy_get_drvdata(generic_phy);
> +}
> +
> +static int ufs_mtk_phy_clk_init(struct ufs_mtk_phy *phy)
> +{
> +	struct device *dev = phy->dev;
> +
> +	phy->unipro_clk = devm_clk_get(dev, "unipro-clk");
> +	if (IS_ERR(phy->unipro_clk)) {
> +		dev_err(dev, "failed to get unipro-clk");
> +		return PTR_ERR(phy->unipro_clk);
> +	}
> +
> +	phy->mp_clk = devm_clk_get(dev, "mp-clk");
> +	if (IS_ERR(phy->mp_clk)) {
> +		dev_err(dev, "failed to get mp-clk");
> +		return PTR_ERR(phy->mp_clk);
> +	}
> +
> +	return 0;
> +}
> +
> +static void ufs_mtk_phy_set_active(struct ufs_mtk_phy *phy)
> +{
> +	/* release DA_MP_PLL_PWR_ON */
> +	mphy_set_bit(phy, MP_GLB_DIG_8C, PLL_PWR_ON);
> +	mphy_clr_bit(phy, MP_GLB_DIG_8C, FRC_FRC_PWR_ON);
> +
> +	/* release DA_MP_PLL_ISO_EN */
> +	mphy_clr_bit(phy, MP_GLB_DIG_8C, PLL_ISO_EN);
> +	mphy_clr_bit(phy, MP_GLB_DIG_8C, FRC_PLL_ISO_EN);
> +
> +	/* release DA_MP_CDR_PWR_ON */
> +	mphy_set_bit(phy, MP_LN_RX_44, CDR_PWR_ON);
> +	mphy_clr_bit(phy, MP_LN_RX_44, FRC_CDR_PWR_ON);
> +
> +	/* release DA_MP_CDR_ISO_EN */
> +	mphy_clr_bit(phy, MP_LN_RX_44, CDR_ISO_EN);
> +	mphy_clr_bit(phy, MP_LN_RX_44, FRC_CDR_ISO_EN);
> +
> +	/* release DA_MP_RX0_SQ_EN */
> +	mphy_set_bit(phy, MP_LN_DIG_RX_AC, RX_SQ_EN);
> +	mphy_clr_bit(phy, MP_LN_DIG_RX_AC, FRC_RX_SQ_EN);
> +
> +	/* delay 1us to wait DIFZ stable */
> +	udelay(1);
> +
> +	/* release DIFZ */
> +	mphy_clr_bit(phy, MP_LN_DIG_RX_9C, FSM_DIFZ_FRC);
> +}
> +
> +static void ufs_mtk_phy_set_deep_hibern(struct ufs_mtk_phy *phy)
> +{
> +	/* force DIFZ */
> +	mphy_set_bit(phy, MP_LN_DIG_RX_9C, FSM_DIFZ_FRC);
> +
> +	/* force DA_MP_RX0_SQ_EN */
> +	mphy_set_bit(phy, MP_LN_DIG_RX_AC, FRC_RX_SQ_EN);
> +	mphy_clr_bit(phy, MP_LN_DIG_RX_AC, RX_SQ_EN);
> +
> +	/* force DA_MP_CDR_ISO_EN */
> +	mphy_set_bit(phy, MP_LN_RX_44, FRC_CDR_ISO_EN);
> +	mphy_set_bit(phy, MP_LN_RX_44, CDR_ISO_EN);
> +
> +	/* force DA_MP_CDR_PWR_ON */
> +	mphy_set_bit(phy, MP_LN_RX_44, FRC_CDR_PWR_ON);
> +	mphy_clr_bit(phy, MP_LN_RX_44, CDR_PWR_ON);
> +
> +	/* force DA_MP_PLL_ISO_EN */
> +	mphy_set_bit(phy, MP_GLB_DIG_8C, FRC_PLL_ISO_EN);
> +	mphy_set_bit(phy, MP_GLB_DIG_8C, PLL_ISO_EN);
> +
> +	/* force DA_MP_PLL_PWR_ON */
> +	mphy_set_bit(phy, MP_GLB_DIG_8C, FRC_FRC_PWR_ON);
> +	mphy_clr_bit(phy, MP_GLB_DIG_8C, PLL_PWR_ON);
> +}
> +
> +static int ufs_mtk_phy_power_on(struct phy *generic_phy)
> +{
> +	struct ufs_mtk_phy *phy = get_ufs_mtk_phy(generic_phy);
> +	int ret;
> +
> +	ret = clk_prepare_enable(phy->unipro_clk);
> +	if (ret) {
> +		dev_err(phy->dev, "unipro_clk enable failed %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = clk_prepare_enable(phy->mp_clk);
> +	if (ret) {
> +		dev_err(phy->dev, "mp_clk enable failed %d\n", ret);
> +		goto out_unprepare_unipro_clk;
> +	}
> +
> +	ufs_mtk_phy_set_active(phy);
> +
> +	return 0;
> +
> +out_unprepare_unipro_clk:
> +	clk_disable_unprepare(phy->unipro_clk);
> +out:
> +	return ret;
> +}
> +
> +static int ufs_mtk_phy_power_off(struct phy *generic_phy)
> +{
> +	struct ufs_mtk_phy *phy = get_ufs_mtk_phy(generic_phy);
> +
> +	ufs_mtk_phy_set_deep_hibern(phy);
> +
> +	clk_disable_unprepare(phy->unipro_clk);
> +	clk_disable_unprepare(phy->mp_clk);
> +
> +	return 0;
> +}
> +
> +static const struct phy_ops ufs_mtk_phy_ops = {
> +	.power_on       = ufs_mtk_phy_power_on,
> +	.power_off      = ufs_mtk_phy_power_off,
> +	.owner          = THIS_MODULE,
> +};
> +
> +static int ufs_mtk_phy_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct phy *generic_phy;
> +	struct phy_provider *phy_provider;
> +	struct resource *res;
> +	struct ufs_mtk_phy *phy;
> +	int ret;
> +
> +	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
> +	if (!phy)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	phy->mmio = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(phy->mmio))
> +		return PTR_ERR(phy->mmio);
> +
> +	phy->dev = dev;
> +
> +	ret = ufs_mtk_phy_clk_init(phy);
> +	if (ret)
> +		return ret;
> +
> +	generic_phy = devm_phy_create(dev, NULL, &ufs_mtk_phy_ops);
> +	if (IS_ERR(generic_phy))
> +		return PTR_ERR(generic_phy);
> +
> +	phy_set_drvdata(generic_phy, phy);
> +
> +	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
> +
> +	return PTR_ERR_OR_ZERO(phy_provider);
> +}
> +
> +static const struct of_device_id ufs_mtk_phy_of_match[] = {
> +	{.compatible = "mediatek,ufs-mphy"},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, ufs_mtk_phy_of_match);
> +
> +static struct platform_driver ufs_mtk_phy_driver = {
> +	.probe = ufs_mtk_phy_probe,
> +	.driver = {
> +		.of_match_table = ufs_mtk_phy_of_match,
> +		.name = "ufs_mtk_phy",
> +	},
> +};
> +module_platform_driver(ufs_mtk_phy_driver);
> +
> +MODULE_DESCRIPTION("Universal Flash Storage (UFS) MediaTek MPHY");
> +MODULE_AUTHOR("Stanley Chu <stanley.chu-c+3QU6Y0cdFWk0Htik3J/w@public.gmane.org>");
> +MODULE_LICENSE("GPL v2");
> +

Reviewed-by: Chunfeng Yun <chunfeng.yun-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
