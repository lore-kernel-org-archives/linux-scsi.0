From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH 01/10] phy: exynos-ufs: add UFS PHY driver for EXYNOS SoC
Date: Fri, 28 Aug 2015 18:31:11 +0530
Message-ID: <55E05B97.5090705@samsung.com>
References: <1440149281-26336-1-git-send-email-alim.akhtar@samsung.com>
 <1440149281-26336-2-git-send-email-alim.akhtar@samsung.com>
 <CALW4P++V0ymA9OsDZnaiV+6FXHyt8+F96vPe0Jn5Yyv9anKfAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <CALW4P++V0ymA9OsDZnaiV+6FXHyt8+F96vPe0Jn5Yyv9anKfAQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, vinholikatti@gmail.com, JBottomley@odin.com, Seungwon Jeon <tgih.jun@samsung.com>, Kishon Vijay Abraham I <kishon@ti.com>
List-Id: linux-scsi@vger.kernel.org

HI Alexey,
Thanks for review.
I will address your comments in v2 of this patch.

On 08/24/2015 04:15 AM, Alexey Klimov wrote:
> Hi Alim,
>
> On Fri, Aug 21, 2015 at 12:27 PM, Alim Akhtar <alim.akhtar@samsung.com> wrote:
>> From: Seungwon Jeon <tgih.jun@samsung.com>
>>
>> This patch introduces Exynos UFS PHY driver. This driver
>> supports to deal with phy calibration and power control
>> according to UFS host driver's behavior.
>>
>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   .../devicetree/bindings/phy/samsung-phy.txt        |   22 ++
>>   drivers/phy/Kconfig                                |    7 +
>>   drivers/phy/Makefile                               |    1 +
>>   drivers/phy/phy-exynos-ufs.c                       |  277 ++++++++++++++++++++
>>   drivers/phy/phy-exynos-ufs.h                       |   73 ++++++
>>   drivers/phy/phy-exynos7-ufs.h                      |   89 +++++++
>>   include/linux/phy/phy-exynos-ufs.h                 |  107 ++++++++
>>   7 files changed, 576 insertions(+)
>>   create mode 100644 drivers/phy/phy-exynos-ufs.c
>>   create mode 100644 drivers/phy/phy-exynos-ufs.h
>>   create mode 100644 drivers/phy/phy-exynos7-ufs.h
>>   create mode 100644 include/linux/phy/phy-exynos-ufs.h
>>
>> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> index 60c6f2a..1abe2c4 100644
>> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> @@ -174,3 +174,25 @@ Example:
>>                  usbdrdphy0 = &usb3_phy0;
>>                  usbdrdphy1 = &usb3_phy1;
>>          };
>> +
>> +Samsung Exynos7 soc serise UFS PHY Controller
>> +---------------------------------------------
>> +
>> +UFS PHY nodes are defined to describe on-chip UFS Physical layer controllers.
>> +Each UFS PHY controller should have its own node.
>> +
>> +Required properties:
>> +- compatible        : compatible list, contains "samsung,exynos7-ufs-phy"
>> +- reg : offset and length of the UFS PHY register set;
>> +- reg-names : reg name(s) must be 'phy-pma';
>> +- #phy-cells : must be zero
>> +- samsung,syscon-phandle : a phandle to the PMU system controller, no arguments
>> +
>> +Example:
>> +       ufs_phy: ufs-phy@0x15571800 {
>> +               compatible = "samsung,exynos7-ufs-phy";
>> +               reg = <0x15571800 0x240>;
>> +               reg-names = "phy-pma";
>> +               samsung,syscon-phandle = <&pmu_system_controller>;
>> +               #phy-cells = <0>;
>> +       };
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 6b8dd16..7449376 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -358,4 +358,11 @@ config PHY_BRCMSTB_SATA
>>            Enable this to support the SATA3 PHY on 28nm Broadcom STB SoCs.
>>            Likely useful only with CONFIG_SATA_BRCMSTB enabled.
>>
>> +config PHY_EXYNOS_UFS
>> +       tristate "EXYNOS SoC series UFS PHY driver"
>> +       depends on OF && ARCH_EXYNOS
>> +       select GENERIC_PHY
>> +       help
>> +         Support for UFS PHY on Samsung EXYNOS chipsets.
>> +
>>   endmenu
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index f344e1b..7a36818 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -45,3 +45,4 @@ obj-$(CONFIG_PHY_QCOM_UFS)    += phy-qcom-ufs-qmp-14nm.o
>>   obj-$(CONFIG_PHY_TUSB1210)             += phy-tusb1210.o
>>   obj-$(CONFIG_PHY_BRCMSTB_SATA)         += phy-brcmstb-sata.o
>>   obj-$(CONFIG_PHY_PISTACHIO_USB)                += phy-pistachio-usb.o
>> +obj-$(CONFIG_PHY_EXYNOS_UFS)   += phy-exynos-ufs.o
>> diff --git a/drivers/phy/phy-exynos-ufs.c b/drivers/phy/phy-exynos-ufs.c
>> new file mode 100644
>> index 0000000..840375d
>> --- /dev/null
>> +++ b/drivers/phy/phy-exynos-ufs.c
>> @@ -0,0 +1,277 @@
>> +/*
>> + * UFS PHY driver for Samsung EXYNOS SoC
>> + *
>> + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
>> + * Author: Seungwon Jeon <tgih.jun@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/of.h>
>> +#include <linux/io.h>
>> +#include <linux/err.h>
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +#include <linux/phy/phy.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/regmap.h>
>> +#include <linux/iopoll.h>
>> +#include <linux/phy/phy-exynos-ufs.h>
>
> What do you think about sorting this?
>
>
>> +#include "phy-exynos-ufs.h"
>> +
>> +#define for_each_phy_lane(phy, i) \
>> +       for (i = 0; i < (phy)->lane_cnt; i++)
>> +#define for_each_phy_cfg(cfg) \
>> +       for (; (cfg)->id; (cfg)++)
>> +
>> +#define phy_pma_writel(phy, val, reg) \
>> +       writel((val), (phy)->reg_pma + (reg))
>> +#define phy_pma_readl(phy, reg) \
>> +       readl((phy)->reg_pma + (reg))
>> +
>> +#define PHY_DEF_LANE_CNT       1
>> +
>> +static inline struct exynos_ufs_phy *get_exynos_ufs_phy(struct phy *phy)
>> +{
>> +       return (struct exynos_ufs_phy *)phy_get_drvdata(phy);
>> +}
>
> Let compiler decide when to inline static function.
> Please don't make static inline functions in *.c files.
>
>
>
> Thanks.
>
