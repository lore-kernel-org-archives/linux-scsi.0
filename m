From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 5/6] phy: mediatek: Add UFS M-PHY driver
Date: Wed, 27 Feb 2019 15:27:21 +0800
Message-ID: <1551252441.30977.26.camel@mtkswgap22>
References: <1551086655-5029-1-git-send-email-stanley.chu@mediatek.com>
 <1551086655-5029-7-git-send-email-stanley.chu@mediatek.com>
 <1551089232.2210.53.camel@mhfsdcap03>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1551089232.2210.53.camel@mhfsdcap03>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Chunfeng Yun <chunfeng.yun-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kishon-l0cyMroinI0@public.gmane.org, avri.altman-Sjgp3cTcYWE@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, vivek.gautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Chunfeng,

Thanks so much for comments!

phy-mtk-ufs will be simplified and all belows are also fixed in v3.

Thanks,
Stanley


On Mon, 2019-02-25 at 18:07 +0800, Chunfeng Yun wrote:
> Hi Stanley,
> 
> On Mon, 2019-02-25 at 17:24 +0800, stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org wrote:
> > From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> > 
> > Add UFS M-PHY driver on Mediatek chipsets.
> > 
> > Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/phy/mediatek/Kconfig            |  29 ++--
> >  drivers/phy/mediatek/Makefile           |   2 +
> >  drivers/phy/mediatek/phy-mtk-ufs-12nm.c | 151 +++++++++++++++++++
> >  drivers/phy/mediatek/phy-mtk-ufs-12nm.h |  52 +++++++
> >  drivers/phy/mediatek/phy-mtk-ufs.c      | 189 ++++++++++++++++++++++++
> >  drivers/phy/mediatek/phy-mtk-ufs.h      |  76 ++++++++++
> >  6 files changed, 489 insertions(+), 10 deletions(-)
> >  create mode 100644 drivers/phy/mediatek/phy-mtk-ufs-12nm.c
> >  create mode 100644 drivers/phy/mediatek/phy-mtk-ufs-12nm.h
> >  create mode 100644 drivers/phy/mediatek/phy-mtk-ufs.c
> >  create mode 100644 drivers/phy/mediatek/phy-mtk-ufs.h
> > 
> > diff --git a/drivers/phy/mediatek/Kconfig b/drivers/phy/mediatek/Kconfig
> > index 8857d00b3c65..38c41836ef46 100644
> > --- a/drivers/phy/mediatek/Kconfig
> > +++ b/drivers/phy/mediatek/Kconfig
> > @@ -2,22 +2,31 @@
> >  # Phy drivers for Mediatek devices
> >  #
> >  config PHY_MTK_TPHY
> > -    tristate "MediaTek T-PHY Driver"
> > -    depends on ARCH_MEDIATEK && OF
> > -    select GENERIC_PHY
> > -    help
> > -      Say 'Y' here to add support for MediaTek T-PHY driver,
> > -      it supports multiple usb2.0, usb3.0 ports, PCIe and
> > +	tristate "MediaTek T-PHY Driver"
> > +	depends on ARCH_MEDIATEK && OF
> > +	select GENERIC_PHY
> > +	help
> > +	  Say 'Y' here to add support for MediaTek T-PHY driver,
> > +	  it supports multiple usb2.0, usb3.0 ports, PCIe and
> Could you please revert these changes? no relations with the new driver
> 
> >  	  SATA, and meanwhile supports two version T-PHY which have
> >  	  different banks layout, the T-PHY with shared banks between
> >  	  multi-ports is first version, otherwise is second veriosn,
> >  	  so you can easily distinguish them by banks layout.
> >  
> >  config PHY_MTK_XSPHY
> > -    tristate "MediaTek XS-PHY Driver"
> > -    depends on ARCH_MEDIATEK && OF
> > -    select GENERIC_PHY
> > -    help
> > +	tristate "MediaTek XS-PHY Driver"
> > +	depends on ARCH_MEDIATEK && OF
> > +	select GENERIC_PHY
> > +	help
> Ditto
> >  	  Enable this to support the SuperSpeedPlus XS-PHY transceiver for
> >  	  USB3.1 GEN2 controllers on MediaTek chips. The driver supports
> >  	  multiple USB2.0, USB3.1 GEN2 ports.
> > +
> > +config PHY_MTK_UFS
> > +	tristate "Mediatek UFS M-PHY driver"
> > +	depends on ARCH_MEDIATEK && OF
> > +	select GENERIC_PHY
> > +	help
> > +	  Support for UFS M-PHY on MediaTek chipsets. Enable this to provide
> > +	  vendor-specific initialization, power on and off flow of specified
> > +	  M-PHYs.
> > diff --git a/drivers/phy/mediatek/Makefile b/drivers/phy/mediatek/Makefile
> > index ee49edc97ee9..e29b56b29d21 100644
> > --- a/drivers/phy/mediatek/Makefile
> > +++ b/drivers/phy/mediatek/Makefile
> > @@ -5,3 +5,5 @@
> >  
> >  obj-$(CONFIG_PHY_MTK_TPHY)		+= phy-mtk-tphy.o
> >  obj-$(CONFIG_PHY_MTK_XSPHY)		+= phy-mtk-xsphy.o
> > +obj-$(CONFIG_PHY_MTK_UFS)		+= phy-mtk-ufs.o
> > +obj-$(CONFIG_PHY_MTK_UFS) 		+= phy-mtk-ufs-12nm.o
> > diff --git a/drivers/phy/mediatek/phy-mtk-ufs-12nm.c b/drivers/phy/mediatek/phy-mtk-ufs-12nm.c
> > new file mode 100644
> > index 000000000000..7ddcaaceafbd
> > --- /dev/null
> > +++ b/drivers/phy/mediatek/phy-mtk-ufs-12nm.c
> > @@ -0,0 +1,151 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2019 MediaTek Inc.
> Add author, and the follow lines can be removed
> 
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > + * See http://www.gnu.org/licenses/gpl-2.0.html for more details.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/delay.h>
> > +#include <linux/io.h>
> > +#include <linux/module.h>
> > +#include <linux/phy/phy.h>
> > +#include <linux/platform_device.h>
> > +#include "phy-mtk-ufs.h"
> > +#include "phy-mtk-ufs-12nm.h"
> > +
> > +#define MPHY_NAME "ufs_phy_mtk_12nm"
> > +
> > +static void ufs_mtk_phy_12nm_power_on(struct ufs_mtk_phy *phy)
> > +{
> > +	/* release DA_MP_PLL_PWR_ON */
> > +	mphy_set_bit(phy, MP_GLB_DIG_8C, PLL_PWR_ON);
> > +	mphy_clr_bit(phy, MP_GLB_DIG_8C, FRC_FRC_PWR_ON);
> > +
> > +	/* release DA_MP_PLL_ISO_EN */
> > +	mphy_clr_bit(phy, MP_GLB_DIG_8C, PLL_ISO_EN);
> > +	mphy_clr_bit(phy, MP_GLB_DIG_8C, FRC_PLL_ISO_EN);
> > +
> > +	/* release DA_MP_CDR_PWR_ON */
> > +	mphy_set_bit(phy, MP_LN_RX_44, CDR_PWR_ON);
> > +	mphy_clr_bit(phy, MP_LN_RX_44, FRC_CDR_PWR_ON);
> > +
> > +	/* release DA_MP_CDR_ISO_EN */
> > +	mphy_clr_bit(phy, MP_LN_RX_44, CDR_ISO_EN);
> > +	mphy_clr_bit(phy, MP_LN_RX_44, FRC_CDR_ISO_EN);
> > +
> > +	/* release DA_MP_RX0_SQ_EN */
> > +	mphy_set_bit(phy, MP_LN_DIG_RX_AC, RX_SQ_EN);
> > +	mphy_clr_bit(phy, MP_LN_DIG_RX_AC, FRC_RX_SQ_EN);
> > +
> > +	/* delay 1us to wait DIFZ stable */
> > +	udelay(1);
> > +
> > +	/* release DIFZ */
> > +	mphy_clr_bit(phy, MP_LN_DIG_RX_9C, FSM_DIFZ_FRC);
> > +}
> > +
> > +static void ufs_mtk_phy_12nm_power_off(struct ufs_mtk_phy *phy)
> > +{
> > +	/* force DIFZ */
> > +	mphy_set_bit(phy, MP_LN_DIG_RX_9C, FSM_DIFZ_FRC);
> > +
> > +	/* force DA_MP_RX0_SQ_EN */
> > +	mphy_set_bit(phy, MP_LN_DIG_RX_AC, FRC_RX_SQ_EN);
> > +	mphy_clr_bit(phy, MP_LN_DIG_RX_AC, RX_SQ_EN);
> > +
> > +	/* force DA_MP_CDR_ISO_EN */
> > +	mphy_set_bit(phy, MP_LN_RX_44, FRC_CDR_ISO_EN);
> > +	mphy_set_bit(phy, MP_LN_RX_44, CDR_ISO_EN);
> > +
> > +	/* force DA_MP_CDR_PWR_ON */
> > +	mphy_set_bit(phy, MP_LN_RX_44, FRC_CDR_PWR_ON);
> > +	mphy_clr_bit(phy, MP_LN_RX_44, CDR_PWR_ON);
> > +
> > +	/* force DA_MP_PLL_ISO_EN */
> > +	mphy_set_bit(phy, MP_GLB_DIG_8C, FRC_PLL_ISO_EN);
> > +	mphy_set_bit(phy, MP_GLB_DIG_8C, PLL_ISO_EN);
> > +
> > +	/* force DA_MP_PLL_PWR_ON */
> > +	mphy_set_bit(phy, MP_GLB_DIG_8C, FRC_FRC_PWR_ON);
> > +	mphy_clr_bit(phy, MP_GLB_DIG_8C, PLL_PWR_ON);
> > +}
> > +
> > +static void ufs_mtk_phy_12nm_power_control(struct ufs_mtk_phy *phy, bool on)
> > +{
> > +	if (on)
> > +		ufs_mtk_phy_12nm_power_on(phy);
> > +	else
> > +		ufs_mtk_phy_12nm_power_off(phy);
> > +}
> > +
> > +static const struct phy_ops ufs_mtk_phy_12nm_phy_ops = {
> > +	.power_on       = ufs_mtk_phy_power_on,
> > +	.power_off      = ufs_mtk_phy_power_off,
> > +	.owner          = THIS_MODULE,
> > +};
> > +
> > +static struct ufs_mtk_phy_specific_ops phy_12nm_ops = {
> > +	.power_control  = ufs_mtk_phy_12nm_power_control,
> > +};
> > +
> > +static int ufs_mtk_phy_12nm_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct phy *generic_phy;
> > +	struct ufs_mtk_phy_12nm *phy;
> > +	int err = 0;
> > +
> > +	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
> > +	if (!phy) {
> > +		err = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	generic_phy = ufs_mtk_phy_generic_probe(pdev, &phy->common_cfg,
> > +						&ufs_mtk_phy_12nm_phy_ops,
> > +						&phy_12nm_ops);
> > +
> > +	if (!generic_phy) {
> > +		dev_info(dev, "%s: ufs_mtk_phy_generic_probe() failed\n",
> > +			 __func__);
> use dev_err()
> > +		err = -EIO;
> > +		goto out;
> > +	}
> > +
> > +	phy_set_drvdata(generic_phy, phy);
> > +
> > +	strlcpy(phy->common_cfg.name, MPHY_NAME,
> > +		sizeof(phy->common_cfg.name));
> > +
> > +	err = ufs_mtk_phy_init_clks(generic_phy, &phy->common_cfg);
> > +	if (err) {
> > +		dev_info(dev,
> > +			 "%s: ufs_mtk_phy_init_clks() failed %d\n",
> > +			 __func__, err);
> ditto
> > +	}
> > +out:
> > +	return err;
> > +}
> > +
> > +static const struct of_device_id ufs_mtk_phy_12nm_of_match[] = {
> > +	{.compatible = "mediatek,ufs-mphy-12nm"},
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, ufs_mtk_phy_12nm_of_match);
> > +
> > +static struct platform_driver ufs_mtk_phy_12nm_driver = {
> > +	.probe = ufs_mtk_phy_12nm_probe,
> > +	.driver = {
> > +		.of_match_table = ufs_mtk_phy_12nm_of_match,
> > +		.name = "ufs_mtk_phy_12nm",
> > +	},
> > +};
> > +module_platform_driver(ufs_mtk_phy_12nm_driver);
> > +
> > +MODULE_DESCRIPTION("Universal Flash Storage (UFS) Mediatek MPHY 12nm");
> > diff --git a/drivers/phy/mediatek/phy-mtk-ufs-12nm.h b/drivers/phy/mediatek/phy-mtk-ufs-12nm.h
> > new file mode 100644
> > index 000000000000..5ebcdbd8ec4d
> > --- /dev/null
> > +++ b/drivers/phy/mediatek/phy-mtk-ufs-12nm.h
> > @@ -0,0 +1,52 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) 2019 MediaTek Inc.
> add author, and the following lines can be removed when
> SPDX-License-Identifier is provided before
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > + * See http://www.gnu.org/licenses/gpl-2.0.html for more details.
> > + */
> > +
> > +#ifndef UFS_MTK_PHY_12NM_H_
> > +#define UFS_MTK_PHY_12NM_H_
> > +
> > +#include "phy-mtk-ufs.h"
> > +
> > +/*
> > + * MPHY register and offsets
> > + */
> > +#define MP_GLB_DIG_8C               0x008C
> > +#define FRC_PLL_ISO_EN              0x00000100
> > +#define PLL_ISO_EN                  0x00000200
> > +#define FRC_FRC_PWR_ON              0x00000400
> > +#define PLL_PWR_ON                  0x00000800
> Use BIT()
> > +
> > +#define MP_LN_DIG_RX_9C             0xA09C
> > +#define FSM_DIFZ_FRC                0x00040000
> ditto
> > +
> > +#define MP_LN_DIG_RX_AC             0xA0AC
> > +#define FRC_RX_SQ_EN                0x00000001
> > +#define RX_SQ_EN                    0x00000002
> ditto
> > +
> > +#define MP_LN_RX_44                 0xB044
> > +#define FRC_CDR_PWR_ON              0x00020000
> > +#define CDR_PWR_ON                  0x00040000
> > +#define FRC_CDR_ISO_EN              0x00080000
> > +#define CDR_ISO_EN                  0x00100000
> ditto
> > +
> > +/*
> > + * This structure represents the 12nm specific phy.
> > + * common_cfg MUST remain the first field in this structure
> > + * in case extra fields are added. This way, when calling
> > + * get_ufs_mtk_phy() of generic phy, we can extract the
> > + * common phy structure (struct ufs_mtk_phy) out of it
> > + * regardless of the relevant specific phy.
> > + */
> > +struct ufs_mtk_phy_12nm {
> > +	struct ufs_mtk_phy common_cfg;
> > +};
> > +
> > +#endif
> > diff --git a/drivers/phy/mediatek/phy-mtk-ufs.c b/drivers/phy/mediatek/phy-mtk-ufs.c
> > new file mode 100644
> > index 000000000000..68ed27eaf195
> > --- /dev/null
> > +++ b/drivers/phy/mediatek/phy-mtk-ufs.c
> > @@ -0,0 +1,189 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2019 MediaTek Inc.
> also here
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > + * See http://www.gnu.org/licenses/gpl-2.0.html for more details.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/io.h>
> > +#include <linux/module.h>
> > +#include <linux/phy/phy.h>
> > +#include <linux/platform_device.h>
> > +#include "phy-mtk-ufs.h"
> > +
> > +static int ufs_mtk_phy_base_init(struct platform_device *pdev,
> > +				 struct ufs_mtk_phy *phy);
> > +
> > +struct phy
> > +*ufs_mtk_phy_generic_probe(struct platform_device *pdev,
> > +			   struct ufs_mtk_phy *common_cfg,
> > +			   const struct phy_ops *ufs_mtk_phy_gen_ops,
> > +			   struct ufs_mtk_phy_specific_ops *phy_spec_ops)
> > +{
> > +	int err;
> > +	struct device *dev = &pdev->dev;
> > +	struct phy *generic_phy = NULL;
> > +	struct phy_provider *phy_provider;
> > +
> > +	err = ufs_mtk_phy_base_init(pdev, common_cfg);
> > +	if (err) {
> > +		dev_info(dev, "%s: phy base init failed %d\n", __func__, err);
> dev_err
> > +		goto out;
> > +	}
> > +
> > +	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
> > +	if (IS_ERR(phy_provider)) {
> > +		err = PTR_ERR(phy_provider);
> > +		dev_info(dev, "%s: failed to register phy %d\n", __func__, err);
> ditto
> > +		goto out;
> > +	}
> > +
> > +	generic_phy = devm_phy_create(dev, NULL, ufs_mtk_phy_gen_ops);
> > +	if (IS_ERR(generic_phy)) {
> > +		err =  PTR_ERR(generic_phy);
> > +		dev_info(dev, "%s: failed to create phy %d\n", __func__, err);
> ditto
> > +		generic_phy = NULL;
> > +		goto out;
> > +	}
> > +
> > +	common_cfg->phy_spec_ops = phy_spec_ops;
> > +	common_cfg->dev = dev;
> > +
> > +out:
> > +	return generic_phy;
> > +}
> > +EXPORT_SYMBOL_GPL(ufs_mtk_phy_generic_probe);
> > +
> > +/*
> > + * This assumes the embedded phy structure inside generic_phy is of type
> > + * struct ufs_mtk_phy. In order to function properly it's crucial
> > + * to keep the embedded struct "struct ufs_mtk_phy common_cfg"
> > + * as the first inside generic_phy.
> > + */
> > +struct ufs_mtk_phy *get_ufs_mtk_phy(struct phy *generic_phy)
> > +{
> > +	return (struct ufs_mtk_phy *)phy_get_drvdata(generic_phy);
> > +}
> > +EXPORT_SYMBOL_GPL(get_ufs_mtk_phy);
> > +
> > +static int ufs_mtk_phy_ctl_clk(struct ufs_mtk_phy *phy,
> > +			       struct clk *clk,
> > +			       bool on)
> > +{
> > +	int ret = 0;
> > +
> > +	if (on) {
> > +		ret = clk_prepare_enable(clk);
> > +		if (ret) {
> > +			dev_info(phy->dev,
> > +				 "%s: mp_clk enable failed %d\n",
> > +				 __func__, ret);
> ditto
> > +			goto out;
> > +		}
> > +	} else {
> > +		clk_disable_unprepare(clk);
> > +	}
> > +out:
> > +	return ret;
> > +}
> > +
> > +static int ufs_mtk_phy_ctl_clks(struct phy *generic_phy, bool on)
> > +{
> > +	struct ufs_mtk_phy *phy = get_ufs_mtk_phy(generic_phy);
> > +	int ret;
> > +
> > +	ret = ufs_mtk_phy_ctl_clk(phy, phy->unipro_clk, on);
> > +	if (ret)
> > +		goto out;
> > +
> > +	ret = ufs_mtk_phy_ctl_clk(phy, phy->mp_clk, on);
> > +out:
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(ufs_mtk_phy_ctl_clks);
> > +
> > +static int ufs_mtk_phy_base_init(struct platform_device *pdev,
> > +				 struct ufs_mtk_phy *phy)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct resource *res;
> > +	int err = 0;
> > +
> > +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ufs_mphy");
> > +	phy->mmio = devm_ioremap_resource(dev, res);
> > +	if (IS_ERR((void const *)phy->mmio)) {
> > +		err = PTR_ERR((void const *)phy->mmio);
> > +		phy->mmio = NULL;
> > +		dev_info(dev, "%s: ioremap for ufs_mphy resource failed %d\n",
> > +			 __func__, err);
> ditto
> > +		return err;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static
> > +int ufs_mtk_phy_clk_get(struct phy *phy,
> > +			const char *name, struct clk **clk_out)
> > +{
> > +	struct clk *clk;
> > +	int err = 0;
> > +	struct ufs_mtk_phy *ufs_mtk_phy = get_ufs_mtk_phy(phy);
> > +	struct device *dev = ufs_mtk_phy->dev;
> > +
> > +	clk = devm_clk_get(dev, name);
> > +	if (IS_ERR(clk)) {
> > +		err = PTR_ERR(clk);
> > +		dev_info(dev, "failed to get %s err %d", name, err);
> ditto
> > +	} else {
> > +		*clk_out = clk;
> > +	}
> > +
> > +	return err;
> > +}
> 
> > +
> > +int ufs_mtk_phy_init_clks(struct phy *generic_phy,
> > +			  struct ufs_mtk_phy *phy)
> > +{
> > +	int err;
> > +
> > +	err = ufs_mtk_phy_clk_get(generic_phy, "ufs0-unipro-clk",
> > +				  &phy->unipro_clk);
> > +	if (err)
> > +		goto out;
> > +
> > +	err = ufs_mtk_phy_clk_get(generic_phy, "ufs0-mp-clk",
> > +				  &phy->mp_clk);
> > +out:
> > +	return err;
> > +}
> > +EXPORT_SYMBOL_GPL(ufs_mtk_phy_init_clks);
> > +
> > +int ufs_mtk_phy_power_on(struct phy *generic_phy)
> > +{
> > +	struct ufs_mtk_phy *phy = get_ufs_mtk_phy(generic_phy);
> > +
> > +	ufs_mtk_phy_ctl_clks(generic_phy, true);
> > +	phy->phy_spec_ops->power_control(phy, true);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(ufs_mtk_phy_power_on);
> > +
> > +int ufs_mtk_phy_power_off(struct phy *generic_phy)
> > +{
> > +	struct ufs_mtk_phy *phy = get_ufs_mtk_phy(generic_phy);
> > +
> > +	phy->phy_spec_ops->power_control(phy, false);
> > +	ufs_mtk_phy_ctl_clks(generic_phy, false);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(ufs_mtk_phy_power_off);
> > +
> > diff --git a/drivers/phy/mediatek/phy-mtk-ufs.h b/drivers/phy/mediatek/phy-mtk-ufs.h
> > new file mode 100644
> > index 000000000000..7163aae2b56b
> > --- /dev/null
> > +++ b/drivers/phy/mediatek/phy-mtk-ufs.h
> > @@ -0,0 +1,76 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) 2019 MediaTek Inc.
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > + * See http://www.gnu.org/licenses/gpl-2.0.html for more details.
> > + */
> > +
> > +#ifndef UFS_MTK_PHY_H_
> > +#define UFS_MTK_PHY_H_
> > +
> > +#include <linux/clk.h>
> > +#include <linux/io.h>
> > +#include <linux/module.h>
> > +#include <linux/phy/phy.h>
> > +#include <linux/platform_device.h>
> > +
> > +#define UFS_MTK_PHY_NAME_LEN       30
> > +
> > +#define mphy_readl(phy, ofs) readl((phy)->mmio + (ofs))
> > +#define mphy_writel(phy, val, ofs) writel((val), (phy)->mmio + (ofs))
> > +
> > +#define mphy_set_bit(phy, reg, ofs) \
> > +do { \
> > +	u32 val; \
> > +	u32 _reg = (reg); \
> > +	struct ufs_mtk_phy *_phy = (phy); \
> > +	val = mphy_readl(_phy, _reg); \
> > +	val = val | (ofs); \
> > +	mphy_writel(_phy, val, _reg); \
> > +} while (0)
> > +
> define it as a inline function?
> > +#define mphy_clr_bit(phy, reg, ofs) \
> > +do { \
> > +	u32 val; \
> > +	u32 _reg = (reg); \
> > +	struct ufs_mtk_phy *_phy = (phy); \
> > +	val = mphy_readl(_phy, _reg); \
> > +	val = val & ~(ofs); \
> > +	mphy_writel(_phy, val, _reg); \
> > +} while (0)
> > +
> > +struct ufs_mtk_phy {
> > +	struct device *dev;
> > +	void __iomem *mmio;
> > +	struct clk *mp_clk;
> > +	struct clk *unipro_clk;
> > +	char name[UFS_MTK_PHY_NAME_LEN];
> > +	struct ufs_mtk_phy_specific_ops *phy_spec_ops;
> > +};
> > +
> > +/**
> > + * struct ufs_mtk_phy_specific_ops - set of pointers to functions which have a
> > + * specific implementation per phy. Each UFS phy, should implement
> > + * those functions according to its spec and requirements
> > + * @power_control: Control power on/off flow of phy.
> > + */
> > +struct ufs_mtk_phy_specific_ops {
> > +	void (*power_control)(struct ufs_mtk_phy *phy, bool on);
> > +};
> > +
> > +struct ufs_mtk_phy *get_ufs_mtk_phy(struct phy *generic_phy);
> > +int ufs_mtk_phy_power_on(struct phy *generic_phy);
> > +int ufs_mtk_phy_power_off(struct phy *generic_phy);
> > +int ufs_mtk_phy_init_clks(struct phy *generic_phy,
> > +			  struct ufs_mtk_phy *phy_common);
> > +struct phy
> > +*ufs_mtk_phy_generic_probe(struct platform_device *pdev,
> > +			   struct ufs_mtk_phy *common_cfg,
> > +			   const struct phy_ops *ufs_mtk_phy_gen_ops,
> > +			   struct ufs_mtk_phy_specific_ops *phy_spec_ops);
> > +#endif
> 
