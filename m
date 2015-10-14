From: Alim Akhtar <alim.akhtar@gmail.com>
Subject: Re: [PATCH v4 02/11] phy: exynos-ufs: add UFS PHY driver for EXYNOS SoC
Date: Wed, 14 Oct 2015 21:43:04 +0530
Message-ID: <CAGOxZ53TNC40mANw8GAQFJcLGSAH6xh4BP5kfuTtyump0saTJg@mail.gmail.com>
References: <1444827351-24128-1-git-send-email-alim.akhtar@samsung.com>
 <1444827351-24128-3-git-send-email-alim.akhtar@samsung.com> <561E7C3C.4070509@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35807 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbbJNQNo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Oct 2015 12:13:44 -0400
In-Reply-To: <561E7C3C.4070509@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@odin.com>, vinayak holikatti <vinholikatti@gmail.com>, "amit.daniel@samsung.com" <amit.daniel@samsung.com>, Seungwon Jeon <essuuj@gmail.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>

Hi,

On Wed, Oct 14, 2015 at 9:31 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
> On Wednesday 14 October 2015 06:25 PM, Alim Akhtar wrote:
>> From: Seungwon Jeon <essuuj@gmail.com>
>>
>> This patch introduces Exynos UFS PHY driver. This driver
>> supports to deal with phy calibration and power control
>> according to UFS host driver's behavior.
>>
>> Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  drivers/phy/Kconfig                |    7 +
>>  drivers/phy/Makefile               |    1 +
>>  drivers/phy/phy-exynos-ufs.c       |  257 ++++++++++++++++++++++++++++++++++++
>>  drivers/phy/phy-exynos-ufs.h       |   88 ++++++++++++
>>  drivers/phy/phy-exynos7-ufs.h      |   89 +++++++++++++
>>  include/linux/phy/phy-exynos-ufs.h |  101 ++++++++++++++
>>  6 files changed, 543 insertions(+)
>>  create mode 100644 drivers/phy/phy-exynos-ufs.c
>>  create mode 100644 drivers/phy/phy-exynos-ufs.h
>>  create mode 100644 drivers/phy/phy-exynos7-ufs.h
>>  create mode 100644 include/linux/phy/phy-exynos-ufs.h
>>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 47da573d0bab..499eec4a967c 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -371,4 +371,11 @@ config PHY_BRCMSTB_SATA
>>         Enable this to support the SATA3 PHY on 28nm Broadcom STB SoCs.
>>         Likely useful only with CONFIG_SATA_BRCMSTB enabled.
>>
>> +config PHY_EXYNOS_UFS
>> +     tristate "EXYNOS SoC series UFS PHY driver"
>> +     depends on OF && ARCH_EXYNOS || COMPILE_TEST
>> +     select GENERIC_PHY
>> +     help
>> +       Support for UFS PHY on Samsung EXYNOS chipsets.
>> +
>>  endmenu
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index a5b18c18fc12..2a312ca20795 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -46,3 +46,4 @@ obj-$(CONFIG_PHY_QCOM_UFS)  += phy-qcom-ufs-qmp-14nm.o
>>  obj-$(CONFIG_PHY_TUSB1210)           += phy-tusb1210.o
>>  obj-$(CONFIG_PHY_BRCMSTB_SATA)               += phy-brcmstb-sata.o
>>  obj-$(CONFIG_PHY_PISTACHIO_USB)              += phy-pistachio-usb.o
>> +obj-$(CONFIG_PHY_EXYNOS_UFS) += phy-exynos-ufs.o
>> diff --git a/drivers/phy/phy-exynos-ufs.c b/drivers/phy/phy-exynos-ufs.c
>> new file mode 100644
>> index 000000000000..77330b85e3f8
>> --- /dev/null
>> +++ b/drivers/phy/phy-exynos-ufs.c
>> @@ -0,0 +1,257 @@
>> +/*
>> + * UFS PHY driver for Samsung EXYNOS SoC
>> + *
>> + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
>> + * Author: Seungwon Jeon <essuuj@gmail.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/iopoll.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/phy/phy.h>
>> +#include <linux/phy/phy-exynos-ufs.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/regmap.h>
>> +
>> +#include "phy-exynos-ufs.h"
>> +
>> +#define for_each_phy_lane(phy, i) \
>> +     for (i = 0; i < (phy)->lane_cnt; i++)
>> +#define for_each_phy_cfg(cfg) \
>> +     for (; (cfg)->id; (cfg)++)
>> +
>> +#define PHY_DEF_LANE_CNT     1
>> +
>> +static void exynos_ufs_phy_config(struct exynos_ufs_phy *phy,
>> +                     const struct exynos_ufs_phy_cfg *cfg, u8 lane)
>> +{
>> +     enum {LANE_0, LANE_1}; /* lane index */
>> +
>> +     switch (lane) {
>> +     case LANE_0:
>> +             writel(cfg->val, (phy)->reg_pma + cfg->off_0);
>> +             break;
>> +     case LANE_1:
>> +             if (cfg->id == PHY_TRSV_BLK)
>> +                     writel(cfg->val, (phy)->reg_pma + cfg->off_1);
>> +             break;
>> +     }
>> +}
>> +
>> +static bool match_cfg_to_pwr_mode(u8 desc, u8 required_pwr)
>> +{
>> +     if (IS_PWR_MODE_ANY(desc))
>> +             return true;
>> +
>> +     if (IS_PWR_MODE_HS(required_pwr) && IS_PWR_MODE_HS_ANY(desc))
>> +             return true;
>> +
>> +     if (COMP_PWR_MODE(required_pwr, desc))
>> +             return true;
>> +
>> +     if (COMP_PWR_MODE_MD(required_pwr, desc) &&
>> +         COMP_PWR_MODE_GEAR(required_pwr, desc) &&
>> +         COMP_PWR_MODE_SER(required_pwr, desc))
>> +             return true;
>> +
>> +     return false;
>> +}
>> +
>> +static int exynos_ufs_phy_calibrate(struct phy *phy,
>> +                                 enum phy_cfg_tag tag, u8 pwr)
>> +{
>> +     struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
>> +     struct exynos_ufs_phy_cfg **cfgs = ufs_phy->cfg;
>> +     const struct exynos_ufs_phy_cfg *cfg;
>> +     int i;
>> +
>> +     if (unlikely(tag < CFG_PRE_INIT || tag >= CFG_TAG_MAX)) {
>> +             dev_err(ufs_phy->dev, "invalid phy config index %d\n", tag);
>> +             return -EINVAL;
>> +     }
>> +
>> +     cfg = cfgs[tag];
>> +     if (!cfg)
>> +             goto out;
>> +
>> +     for_each_phy_cfg(cfg) {
>> +             for_each_phy_lane(ufs_phy, i) {
>> +                     if (match_cfg_to_pwr_mode(cfg->desc, pwr))
>> +                             exynos_ufs_phy_config(ufs_phy, cfg, i);
>> +             }
>> +     }
>> +
>> +out:
>> +     return 0;
>> +}
>> +
>> +static void exynos_ufs_phy_set_lane_cnt(struct phy *phy, u8 lane_cnt)
>> +{
>> +     struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
>> +
>> +     ufs_phy->lane_cnt = lane_cnt;
>> +}
>> +
>> +static int exynos_ufs_phy_wait_for_lock_acq(struct phy *phy)
>> +{
>> +     struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
>> +     const unsigned int timeout_us = 100000;
>> +     const unsigned int sleep_us = 10;
>> +     u32 val;
>> +     int err;
>> +
>> +     err = readl_poll_timeout(
>> +                     ufs_phy->reg_pma + PHY_APB_ADDR(PHY_PLL_LOCK_STATUS),
>> +                     val, (val & PHY_PLL_LOCK_BIT), sleep_us, timeout_us);
>> +     if (err) {
>> +             dev_err(ufs_phy->dev,
>> +                     "failed to get phy pll lock acquisition %d\n", err);
>> +             goto out;
>> +     }
>> +
>> +     err = readl_poll_timeout(
>> +                     ufs_phy->reg_pma + PHY_APB_ADDR(PHY_CDR_LOCK_STATUS),
>> +                     val, (val & PHY_CDR_LOCK_BIT), sleep_us, timeout_us);
>> +     if (err) {
>> +             dev_err(ufs_phy->dev,
>> +                     "failed to get phy cdr lock acquisition %d\n", err);
>> +             goto out;
>> +     }
>> +
>> +out:
>> +     return err;
>> +}
>> +
>> +static int exynos_ufs_phy_power_on(struct phy *phy)
>> +{
>> +     struct exynos_ufs_phy *_phy = get_exynos_ufs_phy(phy);
>> +
>> +     exynos_ufs_phy_ctrl_isol(_phy, false);
>> +     return 0;
>> +}
>> +
>> +static int exynos_ufs_phy_power_off(struct phy *phy)
>> +{
>> +     struct exynos_ufs_phy *_phy = get_exynos_ufs_phy(phy);
>> +
>> +     exynos_ufs_phy_ctrl_isol(_phy, true);
>> +     return 0;
>> +}
>> +
>> +static struct phy_ops exynos_ufs_phy_ops = {
>> +     .power_on       = exynos_ufs_phy_power_on,
>> +     .power_off      = exynos_ufs_phy_power_off,
>> +};
>> +
>> +static struct exynos_ufs_phy_specific_ops phy_specific_ops = {
>> +     .calibrate_phy = exynos_ufs_phy_calibrate,
>> +     .set_lane_cnt = exynos_ufs_phy_set_lane_cnt,
>> +     .wait_for_lock_acq = exynos_ufs_phy_wait_for_lock_acq,
>> +};
>
> I'd like avoiding custom phy ops. Can you forward me the entire series
> so that it helps me in reviewing the use of these ops?
>
This is how it has been used in other phy drivers.

PTAL  https://lkml.org/lkml/2015/10/14/412

Let me know in case you want me to CC you on whole series.
Thanks,

> Thanks
> Kishon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,
Alim
