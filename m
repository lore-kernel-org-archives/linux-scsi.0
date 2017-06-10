From: Guodong Xu <guodong.xu@linaro.org>
Subject: Re: [PATCH 3/3] scsi:ufs:add hi3660 ufs driver code
Date: Sat, 10 Jun 2017 13:49:54 +0800
Message-ID: <CAFGCpxyL4HtHX+CCkLP3Owh6EDvCK9z0x0pZ2osOg7LAT7-ELA@mail.gmail.com>
References: <20170610012114.33533-1-butao@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170610012114.33533-1-butao@hisilicon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: butao <butao@hisilicon.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Gengjianfeng <gengjianfeng@hisilicon.com>, Kongfei <kongfei@hisilicon.com>, Suzhuangluan <suzhuangluan@hisilicon.com>, steven.yujianfeng@hisilicon.com, zangleigang@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

On Sat, Jun 10, 2017 at 9:21 AM, butao <butao@hisilicon.com> wrote:
> add hi3660 ufs driver code
>
> Signed-off-by: Geng Jianfeng <gengjianfeng@hisilicon.com>
> Signed-off-by: Bu Tao <butao@hisilicon.com>
> Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
> Signed-off-by: Yu Jianfeng <steven.yujianfeng@hisilicon.com>
> ---
>  drivers/scsi/ufs/Kconfig      |   8 +
>  drivers/scsi/ufs/Makefile     |   1 +
>  drivers/scsi/ufs/ufs-hi3660.c | 715 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-hi3660.h | 170 ++++++++++
>  4 files changed, 894 insertions(+)
>  mode change 100644 => 100755 drivers/scsi/ufs/Kconfig
>  mode change 100644 => 100755 drivers/scsi/ufs/Makefile
>  create mode 100755 drivers/scsi/ufs/ufs-hi3660.c
>  create mode 100755 drivers/scsi/ufs/ufs-hi3660.h

mode 755? Err.

>
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> old mode 100644
> new mode 100755
> index e27b4d4e6ae2..119604ea0aae
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -80,6 +80,14 @@ config SCSI_UFSHCD_PLATFORM
>
>           If unsure, say N.
>
> +config SCSI_UFS_HI3660
> +       tristate "Hisilicon Hi3660 UFS controller platform driver"
> +       depends on (ARCH_HISI || COMPILE_TEST) && SCSI_UFSHCD_PLATFORM
> +       help
> +         This selects the Hisilicon HI3660 additions to UFSHCD platform driver.
> +
> +         If unsure, say N.
> +

Please also add "SCSI_UFS_HI3660=y" into arch/arm64/configs/defconfig,
and submit as a separate patch.

-Guodong


>  config SCSI_UFS_DWC_TC_PLATFORM
>         tristate "DesignWare platform support using a G210 Test Chip"
>         depends on SCSI_UFSHCD_PLATFORM
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> old mode 100644
> new mode 100755
> index 6e77cb0bfee9..ae880189f018
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -2,6 +2,7 @@
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
>  obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
> +obj-$(CONFIG_SCSI_UFS_HI3660) += ufs-hi3660.o
>  obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
>  obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
>  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
> diff --git a/drivers/scsi/ufs/ufs-hi3660.c b/drivers/scsi/ufs/ufs-hi3660.c
> new file mode 100755
> index 000000000000..ccbcb01f6863
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-hi3660.c
> @@ -0,0 +1,715 @@
> +/*
> + * Copyright (c) 2016-2017 Linaro Ltd.
> + * Copyright (c) 2016-2017 HiSilicon Technologies Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/gpio.h>
> +#include <linux/time.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_gpio.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/platform_device.h>
> +#include <linux/reset.h>
> +
> +#include "ufshcd.h"
> +#include "ufshcd-pltfrm.h"
> +#include "unipro.h"
> +#include "ufs-hi3660.h"
> +#include "ufshci.h"
> +
> +static int ufs_hi3660_check_hibern8(struct ufs_hba *hba)
> +{
> +       int err;
> +       u32 tx_fsm_val_0;
> +       u32 tx_fsm_val_1;
> +       unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
> +
> +       do {
> +               err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
> +                                     &tx_fsm_val_0);
> +               err |= ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1),
> +                                     &tx_fsm_val_1);
> +               if (err || (tx_fsm_val_0 == TX_FSM_HIBERN8 && tx_fsm_val_1 == TX_FSM_HIBERN8))
> +                       break;
> +
> +               /* sleep for max. 200us */
> +               usleep_range(100, 200);
> +       } while (time_before(jiffies, timeout));
> +
> +       /*
> +        * we might have scheduled out for long during polling so
> +        * check the state again.
> +        */
> +       if (time_after(jiffies, timeout)) {
> +               err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
> +                                    &tx_fsm_val_0);
> +               err |= ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1),
> +                                    &tx_fsm_val_1);
> +       }
> +
> +       if (err) {
> +               dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
> +                       __func__, err);
> +       } else if (tx_fsm_val_0 != TX_FSM_HIBERN8 || tx_fsm_val_1 != TX_FSM_HIBERN8) {
> +               err = -1;
> +               dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
> +                       __func__, tx_fsm_val_0, tx_fsm_val_1);
> +       }
> +
> +       return err;
> +}
> +
> +static void ufs_hi3660_clk_init(struct ufs_hba *hba)
> +{
> +       struct ufs_hi3660_host *host = ufshcd_get_variant(hba);
> +
> +       ufs_sys_ctrl_clr_bits(host, BIT_SYSCTRL_REF_CLOCK_EN, PHY_CLK_CTRL);
> +       if (ufs_sys_ctrl_readl(host, PHY_CLK_CTRL) & BIT_SYSCTRL_REF_CLOCK_EN)
> +               mdelay(1);
> +       /* use abb clk */
> +       ufs_sys_ctrl_clr_bits(host, BIT_UFS_REFCLK_SRC_SEl, UFS_SYSCTRL);
> +       ufs_sys_ctrl_clr_bits(host, BIT_UFS_REFCLK_ISO_EN, PHY_ISO_EN);
> +       /* open mphy ref clk */
> +       ufs_sys_ctrl_set_bits(host, BIT_SYSCTRL_REF_CLOCK_EN, PHY_CLK_CTRL);
> +}
> +
> +static void ufs_hi3660_soc_init(struct ufs_hba *hba)
> +{
> +       struct ufs_hi3660_host *host = ufshcd_get_variant(hba);
> +       u32 reg;
> +
> +       if (!IS_ERR(host->rst))
> +               reset_control_assert(host->rst);
> +
> +       /* HC_PSW powerup */
> +       ufs_sys_ctrl_set_bits(host, BIT_UFS_PSW_MTCMOS_EN, PSW_POWER_CTRL);
> +       udelay(10);
> +       /* notify PWR ready */
> +       ufs_sys_ctrl_set_bits(host, BIT_SYSCTRL_PWR_READY, HC_LP_CTRL);
> +       ufs_sys_ctrl_writel(host, MASK_UFS_DEVICE_RESET | 0,
> +               UFS_DEVICE_RESET_CTRL);
> +
> +       if (gpio_is_valid(host->reset_gpio))
> +               gpio_direction_output(host->reset_gpio, 0);
> +
> +       reg = ufs_sys_ctrl_readl(host, PHY_CLK_CTRL);
> +       reg = (reg & ~MASK_SYSCTRL_CFG_CLOCK_FREQ) | UFS_FREQ_CFG_CLK;
> +       /* set cfg clk freq */
> +       ufs_sys_ctrl_writel(host, reg, PHY_CLK_CTRL);
> +       /* set ref clk freq */
> +       ufs_sys_ctrl_clr_bits(host, MASK_SYSCTRL_REF_CLOCK_SEL, PHY_CLK_CTRL);
> +       /* bypass ufs clk gate */
> +       ufs_sys_ctrl_set_bits(host, MASK_UFS_CLK_GATE_BYPASS, CLOCK_GATE_BYPASS);
> +       ufs_sys_ctrl_set_bits(host, MASK_UFS_SYSCRTL_BYPASS, UFS_SYSCTRL);
> +
> +       /* open psw clk */
> +       ufs_sys_ctrl_set_bits(host, BIT_SYSCTRL_PSW_CLK_EN, PSW_CLK_CTRL);
> +       /* disable ufshc iso */
> +       ufs_sys_ctrl_clr_bits(host, BIT_UFS_PSW_ISO_CTRL, PSW_POWER_CTRL);
> +       /* disable phy iso */
> +       ufs_sys_ctrl_clr_bits(host, BIT_UFS_PHY_ISO_CTRL, PHY_ISO_EN);
> +       /* notice iso disable */
> +       ufs_sys_ctrl_clr_bits(host, BIT_SYSCTRL_LP_ISOL_EN, HC_LP_CTRL);
> +       if (!IS_ERR(host->assert))
> +               reset_control_deassert(host->assert);
> +       /* disable lp_reset_n */
> +       ufs_sys_ctrl_set_bits(host, BIT_SYSCTRL_LP_RESET_N, RESET_CTRL_EN);
> +       mdelay(1);
> +
> +       if (gpio_is_valid(host->reset_gpio))
> +               gpio_direction_output(host->reset_gpio, 1);
> +
> +       ufs_sys_ctrl_writel(host, MASK_UFS_DEVICE_RESET | BIT_UFS_DEVICE_RESET,
> +               UFS_DEVICE_RESET_CTRL);
> +
> +       mdelay(20);
> +
> +       /*
> +        * enable the fix of linereset recovery,
> +        * and enable rx_reset/tx_rest beat
> +        * enable ref_clk_en override(bit5) &
> +        * override value = 1(bit4), with mask
> +        */
> +       ufs_sys_ctrl_writel(host, 0x03300330, UFS_DEVICE_RESET_CTRL);
> +
> +       if (!IS_ERR(host->rst))
> +               reset_control_deassert(host->rst);
> +}
> +
> +static int ufs_hi3660_link_startup_pre_change(struct ufs_hba *hba)
> +{
> +       int err;
> +       uint32_t value;
> +       uint32_t reg;
> +       struct ufs_hi3660_host *host = ufshcd_get_variant(hba);
> +
> +       /* Unipro VS_mphy_disable */
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x1);
> +       if (host->caps & USE_RATE_B) {
> +               /* PA_HSSeries */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x156A, 0x0), 0x2);
> +               /* MPHY CBRATESEL */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x8114, 0x0), 0x1);
> +               /* MPHY CBOVRCTRL2 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x8121, 0x0), 0x2D);
> +               /* MPHY CBOVRCTRL3 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x8122, 0x0), 0x1);
> +               /* Unipro VS_MphyCfgUpdt */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD085, 0x0), 0x1);
> +               /* MPHY RXOVRCTRL4 rx0 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x800D, 0x4), 0x58);
> +               /* MPHY RXOVRCTRL4 rx1 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x800D, 0x5), 0x58);
> +               /* MPHY RXOVRCTRL5 rx0 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x800E, 0x4), 0xB);
> +               /* MPHY RXOVRCTRL5 rx1 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x800E, 0x5), 0xB);
> +               /* MPHY RXSQCONTROL rx0 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x8009, 0x4), 0x1);
> +               /* MPHY RXSQCONTROL rx1 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x8009, 0x5), 0x1);
> +               /* Unipro VS_MphyCfgUpdt */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD085, 0x0), 0x1);
> +       } else {
> +               /* PA_HSSeries */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x156A, 0x0), 0x1);
> +               /* MPHY CBRATESEL */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x8114, 0x0), 0x0);
> +               /* MPHY CBOVRCTRL2 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x8121, 0x0), 0x4C);
> +               /* MPHY CBOVRCTRL3 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x8122, 0x0), 0x1);
> +               /* Unipro VS_MphyCfgUpdt */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD085, 0x0), 0x1);
> +               /* MPHY RXOVRCTRL4 rx0 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x800D, 0x4), 0x18);
> +               /* MPHY RXOVRCTRL4 rx1 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x800D, 0x5), 0x18);
> +               /* MPHY RXOVRCTRL5 rx0 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x800E, 0x4), 0xD);
> +               /* MPHY RXOVRCTRL5 rx1 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x800E, 0x5), 0xD);
> +               /* MPHY RXSQCONTROL rx0 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x8009, 0x4), 0x1);
> +               /* MPHY RXSQCONTROL rx1 */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x8009, 0x5), 0x1);
> +               /* Unipro VS_MphyCfgUpdt */
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD085, 0x0), 0x1);
> +       }
> +
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x8113, 0x0), 0x1);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD085, 0x0), 0x1);
> +       /* Gear3 Synclength */
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x0095, 0x4), 0x4A);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x0095, 0x5), 0x4A);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x0094, 0x4), 0x4A);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x0094, 0x5), 0x4A);
> +       /* Tactive RX */
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x008F, 0x4), 0x7);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x008F, 0x5), 0x7);
> +       /* Thibernate Tx */
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x000F, 0x0), 0x5);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x000F, 0x1), 0x5);
> +
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD085, 0x0), 0x1);
> +       /* Unipro VS_mphy_disable */
> +       ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), &value);
> +       if (value != 0x1)
> +               dev_info(hba->dev,
> +                           "Warring!!! Unipro VS_mphy_disable is 0x%x\n", value);
> +
> +       /* Unipro VS_mphy_disable */
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
> +       err = ufs_hi3660_check_hibern8(hba);
> +       if (err)
> +               dev_err(hba->dev, "ufs_hi3660_check_hibern8 error\n");
> +
> +       ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
> +
> +       /* disable auto H8 */
> +       reg = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +       reg = reg & (~UFS_AHIT_AH8ITV_MASK);
> +       ufshcd_writel(hba, reg, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +
> +       /* Unipro PA_Local_TX_LCC_Enable */
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x155E, 0x0), 0x0);
> +       /* close Unipro VS_Mk2ExtnSupport */
> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0AB, 0x0), 0x0);
> +       ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(0xD0AB, 0x0), &value);
> +       if (0 != value) {
> +               /* Ensure close success */
> +               dev_info(hba->dev, "WARN: close VS_Mk2ExtnSupport failed\n");
> +       }
> +
> +       return err;
> +}
> +
> +static int ufs_hi3660_link_startup_post_change(struct ufs_hba *hba)
> +{
> +       struct ufs_hi3660_host *host = ufshcd_get_variant(hba);
> +
> +       /* Unipro DL_AFC0CreditThreshold */
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x2044), 0x0);
> +       /* Unipro DL_TC0OutAckThreshold */
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x2045), 0x0);
> +       /* Unipro DL_TC0TXFCThreshold */
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x2040), 0x9);
> +
> +       if (host->caps & BROKEN_CLK_GATE_BYPASS) {
> +               /* not bypass ufs clk gate */
> +               ufs_sys_ctrl_clr_bits(host, MASK_UFS_CLK_GATE_BYPASS, CLOCK_GATE_BYPASS);
> +               ufs_sys_ctrl_clr_bits(host, MASK_UFS_SYSCRTL_BYPASS, UFS_SYSCTRL);
> +       }
> +
> +       if (host->caps & USE_AUTO_H8) {
> +               /* disable power-gating in auto hibernate 8 */
> +               ufshcd_rmwl(hba, LP_AH8_PGE, 0, UFS_REG_OCPTHRTL);
> +
> +               /* enable auto H8 */
> +               ufshcd_writel(hba, UFS_AHIT_AUTOH8_TIMER, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +       }
> +
> +       return 0;
> +}
> +
> +static int ufs_hi3660_link_startup_notify(struct ufs_hba *hba,
> +                                         enum ufs_notify_change_status status)
> +{
> +       int err = 0;
> +
> +       switch (status) {
> +       case PRE_CHANGE:
> +               err = ufs_hi3660_link_startup_pre_change(hba);
> +               break;
> +       case POST_CHANGE:
> +               err = ufs_hi3660_link_startup_post_change(hba);
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       return err;
> +}
> +
> +struct ufs_hi3660_dev_params {
> +       u32 pwm_rx_gear; /* pwm rx gear to work in */
> +       u32 pwm_tx_gear; /* pwm tx gear to work in */
> +       u32 hs_rx_gear;  /* hs rx gear to work in */
> +       u32 hs_tx_gear;  /* hs tx gear to work in */
> +       u32 rx_lanes;    /* number of rx lanes */
> +       u32 tx_lanes;    /* number of tx lanes */
> +       u32 rx_pwr_pwm;  /* rx pwm working pwr */
> +       u32 tx_pwr_pwm;  /* tx pwm working pwr */
> +       u32 rx_pwr_hs;   /* rx hs working pwr */
> +       u32 tx_pwr_hs;   /* tx hs working pwr */
> +       u32 hs_rate;     /* rate A/B to work in HS */
> +       u32 desired_working_mode;
> +};
> +
> +static int ufs_hi3660_get_pwr_dev_param(struct ufs_hi3660_dev_params *hi3660_param,
> +                                      struct ufs_pa_layer_attr *dev_max,
> +                                      struct ufs_pa_layer_attr *agreed_pwr)
> +{
> +       int min_hi3660_gear;
> +       int min_dev_gear;
> +       bool is_dev_sup_hs = false;
> +       bool is_hi3660_max_hs = false;
> +
> +       if (dev_max->pwr_rx == FASTAUTO_MODE || dev_max->pwr_rx == FAST_MODE)
> +               is_dev_sup_hs = true;
> +
> +       if (hi3660_param->desired_working_mode == FAST) {
> +               is_hi3660_max_hs = true;
> +               min_hi3660_gear = min_t(u32, hi3660_param->hs_rx_gear,
> +                                      hi3660_param->hs_tx_gear);
> +       } else {
> +               min_hi3660_gear = min_t(u32, hi3660_param->pwm_rx_gear,
> +                                      hi3660_param->pwm_tx_gear);
> +       }
> +
> +       /*
> +        * device doesn't support HS but
> +        * hi3660_param->desired_working_mode is HS,
> +        * thus device and hi3660_param don't agree
> +        */
> +       if (!is_dev_sup_hs && is_hi3660_max_hs) {
> +               pr_err("%s: device not support HS\n", __func__);
> +               return -ENOTSUPP;
> +       } else if (is_dev_sup_hs && is_hi3660_max_hs) {
> +               /*
> +                * since device supports HS, it supports FAST_MODE.
> +                * since hi3660_param->desired_working_mode is also HS
> +                * then final decision (FAST/FASTAUTO) is done according
> +                * to hi3660_params as it is the restricting factor
> +                */
> +               agreed_pwr->pwr_rx = agreed_pwr->pwr_tx =
> +                       hi3660_param->rx_pwr_hs;
> +       } else {
> +               /*
> +                * here hi3660_param->desired_working_mode is PWM.
> +                * it doesn't matter whether device supports HS or PWM,
> +                * in both cases hi3660_param->desired_working_mode will
> +                * determine the mode
> +                */
> +               agreed_pwr->pwr_rx = agreed_pwr->pwr_tx =
> +                       hi3660_param->rx_pwr_pwm;
> +       }
> +
> +       /*
> +        * we would like tx to work in the minimum number of lanes
> +        * between device capability and vendor preferences.
> +        * the same decision will be made for rx
> +        */
> +       agreed_pwr->lane_tx =
> +               min_t(u32, dev_max->lane_tx, hi3660_param->tx_lanes);
> +       agreed_pwr->lane_rx =
> +               min_t(u32, dev_max->lane_rx, hi3660_param->rx_lanes);
> +
> +       /* device maximum gear is the minimum between device rx and tx gears */
> +       min_dev_gear = min_t(u32, dev_max->gear_rx, dev_max->gear_tx);
> +
> +       /*
> +        * if both device capabilities and vendor pre-defined preferences are
> +        * both HS or both PWM then set the minimum gear to be the chosen
> +        * working gear.
> +        * if one is PWM and one is HS then the one that is PWM get to decide
> +        * what is the gear, as it is the one that also decided previously what
> +        * pwr the device will be configured to.
> +        */
> +       if ((is_dev_sup_hs && is_hi3660_max_hs) ||
> +           (!is_dev_sup_hs && !is_hi3660_max_hs))
> +               agreed_pwr->gear_rx = agreed_pwr->gear_tx =
> +                       min_t(u32, min_dev_gear, min_hi3660_gear);
> +       else
> +               agreed_pwr->gear_rx = agreed_pwr->gear_tx = min_hi3660_gear;
> +
> +       agreed_pwr->hs_rate = hi3660_param->hs_rate;
> +
> +       pr_info("ufs final power mode: gear = %d, lane = %d, pwr = %d, "
> +               "rate = %d\n",
> +               agreed_pwr->gear_rx, agreed_pwr->lane_rx, agreed_pwr->pwr_rx,
> +               agreed_pwr->hs_rate);
> +       return 0;
> +}
> +
> +static void ufs_hi3660_pwr_change_pre_change(struct ufs_hba *hba)
> +{
> +       /* update */
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x15A8), 0x1);
> +       /* PA_TxSkip */
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x155c), 0x0);
> +       /*PA_PWRModeUserData0 = 8191, default is 0*/
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x15b0), 8191);
> +       /*PA_PWRModeUserData1 = 65535, default is 0*/
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x15b1), 65535);
> +       /*PA_PWRModeUserData2 = 32767, default is 0*/
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x15b2), 32767);
> +       /*DME_FC0ProtectionTimeOutVal = 8191, default is 0*/
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0xd041), 8191);
> +       /*DME_TC0ReplayTimeOutVal = 65535, default is 0*/
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0xd042), 65535);
> +       /*DME_AFC0ReqTimeOutVal = 32767, default is 0*/
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0xd043), 32767);
> +       /*PA_PWRModeUserData3 = 8191, default is 0*/
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x15b3), 8191);
> +       /*PA_PWRModeUserData4 = 65535, default is 0*/
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x15b4), 65535);
> +       /*PA_PWRModeUserData5 = 32767, default is 0*/
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x15b5), 32767);
> +       /*DME_FC1ProtectionTimeOutVal = 8191, default is 0*/
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0xd044), 8191);
> +       /*DME_TC1ReplayTimeOutVal = 65535, default is 0*/
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0xd045), 65535);
> +       /*DME_AFC1ReqTimeOutVal = 32767, default is 0*/
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0xd046), 32767);
> +}
> +
> +static int ufs_hi3660_pwr_change_notify(struct ufs_hba *hba,
> +                                      enum ufs_notify_change_status status,
> +                                      struct ufs_pa_layer_attr *dev_max_params,
> +                                      struct ufs_pa_layer_attr *dev_req_params)
> +{
> +       struct ufs_hi3660_dev_params ufs_hi3660_cap;
> +       struct ufs_hi3660_host *host = ufshcd_get_variant(hba);
> +       int ret = 0;
> +       uint32_t value;
> +
> +       if (!dev_req_params) {
> +               dev_err(hba->dev,
> +                           "%s: incoming dev_req_params is NULL\n", __func__);
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +
> +       switch (status) {
> +       case PRE_CHANGE:
> +               if (host->caps & USE_ONE_LANE) {
> +                       ufs_hi3660_cap.tx_lanes = 1;
> +                       ufs_hi3660_cap.rx_lanes = 1;
> +               } else {
> +                       ufs_hi3660_cap.tx_lanes = 2;
> +                       ufs_hi3660_cap.rx_lanes = 2;
> +               }
> +
> +               if (host->caps & USE_HS_GEAR3) {
> +                       ufs_hi3660_cap.hs_rx_gear = UFS_HS_G3;
> +                       ufs_hi3660_cap.hs_tx_gear = UFS_HS_G3;
> +                       ufs_hi3660_cap.desired_working_mode = FAST;
> +               } else if (host->caps & USE_HS_GEAR2) {
> +                       ufs_hi3660_cap.hs_rx_gear = UFS_HS_G2;
> +                       ufs_hi3660_cap.hs_tx_gear = UFS_HS_G2;
> +                       ufs_hi3660_cap.desired_working_mode = FAST;
> +               } else if (host->caps & USE_HS_GEAR1) {
> +                       ufs_hi3660_cap.hs_rx_gear = UFS_HS_G1;
> +                       ufs_hi3660_cap.hs_tx_gear = UFS_HS_G1;
> +                       ufs_hi3660_cap.desired_working_mode = FAST;
> +               } else {
> +                       ufs_hi3660_cap.desired_working_mode = SLOW;
> +               }
> +
> +               ufs_hi3660_cap.pwm_rx_gear = UFS_HI3660_LIMIT_PWMGEAR_RX;
> +               ufs_hi3660_cap.pwm_tx_gear = UFS_HI3660_LIMIT_PWMGEAR_TX;
> +               ufs_hi3660_cap.rx_pwr_pwm = UFS_HI3660_LIMIT_RX_PWR_PWM;
> +               ufs_hi3660_cap.tx_pwr_pwm = UFS_HI3660_LIMIT_TX_PWR_PWM;
> +               /*hynix not support fastauto now*/
> +               if (host->caps & BROKEN_FASTAUTO) {
> +                       ufs_hi3660_cap.rx_pwr_hs = FAST_MODE;
> +                       ufs_hi3660_cap.tx_pwr_hs = FAST_MODE;
> +               } else {
> +                       ufs_hi3660_cap.rx_pwr_hs = FASTAUTO_MODE;
> +                       ufs_hi3660_cap.tx_pwr_hs = FASTAUTO_MODE;
> +               }
> +
> +               if (host->caps & USE_RATE_B)
> +                       ufs_hi3660_cap.hs_rate = PA_HS_MODE_B;
> +               else
> +                       ufs_hi3660_cap.hs_rate = PA_HS_MODE_A;
> +
> +               ret = ufs_hi3660_get_pwr_dev_param(
> +                       &ufs_hi3660_cap, dev_max_params, dev_req_params);
> +               if (ret) {
> +                       dev_err(hba->dev,
> +                           "%s: failed to determine capabilities\n", __func__);
> +                       goto out;
> +               }
> +
> +               dev_info(hba->dev, "set TX_EQUALIZER 3.5db\n");
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x0037, 0x0), 0x1);
> +               if ((dev_req_params->lane_tx > 1) && (dev_req_params->lane_rx > 1))
> +                       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x0037, 0x1), 0x1);
> +
> +               ufs_hi3660_pwr_change_pre_change(hba);
> +               break;
> +       case POST_CHANGE:
> +               ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(0x0037, 0x0), &value);
> +               dev_info(hba->dev, "check TX_EQUALIZER DB value lane0 = 0x%x\n", value);
> +               if ((dev_req_params->lane_tx > 1) && (dev_req_params->lane_rx > 1)) {
> +                       ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(0x0037, 0x1), &value);
> +                       dev_info(hba->dev, "check TX_EQUALIZER DB value lane1 = 0x%x\n", value);
> +               }
> +               break;
> +       default:
> +               ret = -EINVAL;
> +               break;
> +       }
> +out:
> +       return ret;
> +}
> +
> +static int ufs_hi3660_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
> +{
> +       struct ufs_hi3660_host *host = ufshcd_get_variant(hba);
> +
> +       if (ufshcd_is_runtime_pm(pm_op))
> +               return 0;
> +
> +       if (host->in_suspend) {
> +               WARN_ON(1);
> +               return 0;
> +       }
> +
> +       ufs_sys_ctrl_clr_bits(host, BIT_SYSCTRL_REF_CLOCK_EN, PHY_CLK_CTRL);
> +       udelay(10);
> +       /* set ref_dig_clk override of PHY PCS to 0 */
> +       ufs_sys_ctrl_writel(host, 0x00100000, UFS_DEVICE_RESET_CTRL);
> +
> +       host->in_suspend = true;
> +
> +       return 0;
> +}
> +
> +static int ufs_hi3660_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
> +{
> +       struct ufs_hi3660_host *host = ufshcd_get_variant(hba);
> +
> +       if (!host->in_suspend)
> +               return 0;
> +
> +       /* set ref_dig_clk override of PHY PCS to 1 */
> +       ufs_sys_ctrl_writel(host, 0x00100010, UFS_DEVICE_RESET_CTRL);
> +       udelay(10);
> +       ufs_sys_ctrl_set_bits(host, BIT_SYSCTRL_REF_CLOCK_EN, PHY_CLK_CTRL);
> +
> +       host->in_suspend = false;
> +       return 0;
> +}
> +
> +static int ufs_hi3660_get_resource(struct ufs_hi3660_host *host)
> +{
> +       struct resource *mem_res;
> +       struct device *dev = host->hba->dev;
> +       struct platform_device *pdev = to_platform_device(dev);
> +
> +       /* get resource of ufs sys ctrl */
> +       mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +       host->ufs_sys_ctrl = devm_ioremap_resource(dev, mem_res);
> +       if (!host->ufs_sys_ctrl) {
> +               dev_err(dev, "cannot ioremap for ufs sys ctrl register\n");
> +               return -ENOMEM;
> +       }
> +
> +       return 0;
> +}
> +
> +static void ufs_hi3660_set_pm_lvl(struct ufs_hba *hba)
> +{
> +       hba->rpm_lvl = UFS_PM_LVL_1;
> +       hba->spm_lvl = UFS_PM_LVL_3;
> +}
> +
> +static void ufs_hi3660_populate_dt(struct device *dev,
> +                                  struct ufs_hi3660_host *host)
> +{
> +       struct device_node *np = dev->of_node;
> +       int ret;
> +
> +       if (!np) {
> +               dev_err(dev, "can not find device node\n");
> +               return;
> +       }
> +
> +       if (of_find_property(np, "ufs-hi3660-use-rate-B", NULL))
> +               host->caps |= USE_RATE_B;
> +
> +       if (of_find_property(np, "ufs-hi3660-broken-fastauto", NULL))
> +               host->caps |= BROKEN_FASTAUTO;
> +
> +       if (of_find_property(np, "ufs-hi3660-use-one-line", NULL))
> +               host->caps |= USE_ONE_LANE;
> +
> +       if (of_find_property(np, "ufs-hi3660-use-HS-GEAR3", NULL))
> +               host->caps |= USE_HS_GEAR3;
> +
> +       if (of_find_property(np, "ufs-hi3660-use-HS-GEAR2", NULL))
> +               host->caps |= USE_HS_GEAR2;
> +
> +       if (of_find_property(np, "ufs-hi3660-use-HS-GEAR1", NULL))
> +               host->caps |= USE_HS_GEAR1;
> +
> +       if (of_find_property(np, "ufs-hi3660-broken-clk-gate-bypass", NULL))
> +               host->caps |= BROKEN_CLK_GATE_BYPASS;
> +
> +       host->reset_gpio = of_get_named_gpio(np, "reset-gpio", 0);
> +       if (gpio_is_valid(host->reset_gpio)) {
> +               ret = devm_gpio_request_one(dev, host->reset_gpio,
> +                                           GPIOF_DIR_OUT, "hi3660_ufs_reset");
> +               if (ret < 0)
> +                       dev_err(dev, "could not acquire gpio (err=%d)\n", ret);
> +       }
> +}
> +
> +/**
> + * ufs_hi3660_init
> + * @hba: host controller instance
> + */
> +static int ufs_hi3660_init(struct ufs_hba *hba)
> +{
> +       int err;
> +       struct device *dev = hba->dev;
> +       struct ufs_hi3660_host *host;
> +
> +       host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> +       if (!host) {
> +               dev_err(dev, "%s: no memory for hi3660 ufs host\n", __func__);
> +               return -ENOMEM;
> +       }
> +
> +       host->hba = hba;
> +       ufshcd_set_variant(hba, host);
> +
> +       host->rst = devm_reset_control_get(dev, "rst");
> +       host->assert = devm_reset_control_get(dev, "assert");
> +
> +       ufs_hi3660_set_pm_lvl(hba);
> +
> +       ufs_hi3660_populate_dt(dev, host);
> +
> +       err = ufs_hi3660_get_resource(host);
> +       if (err) {
> +               ufshcd_set_variant(hba, NULL);
> +               return err;
> +       }
> +
> +       ufs_hi3660_clk_init(hba);
> +
> +       ufs_hi3660_soc_init(hba);
> +
> +       return 0;
> +}
> +
> +static struct ufs_hba_variant_ops ufs_hba_hi3660_vops = {
> +       .name = "hi3660",
> +       .init = ufs_hi3660_init,
> +       .link_startup_notify = ufs_hi3660_link_startup_notify,
> +       .pwr_change_notify = ufs_hi3660_pwr_change_notify,
> +       .suspend = ufs_hi3660_suspend,
> +       .resume = ufs_hi3660_resume,
> +};
> +
> +static int ufs_hi3660_probe(struct platform_device *pdev)
> +{
> +       return ufshcd_pltfrm_init(pdev, &ufs_hba_hi3660_vops);
> +}
> +
> +static int ufs_hi3660_remove(struct platform_device *pdev)
> +{
> +       struct ufs_hba *hba =  platform_get_drvdata(pdev);
> +
> +       ufshcd_remove(hba);
> +       return 0;
> +}
> +
> +static const struct of_device_id ufs_hi3660_of_match[] = {
> +       { .compatible = "hisilicon,hi3660-ufs" },
> +       {},
> +};
> +
> +static const struct dev_pm_ops ufs_hi3660_pm_ops = {
> +       .suspend        = ufshcd_pltfrm_suspend,
> +       .resume         = ufshcd_pltfrm_resume,
> +       .runtime_suspend = ufshcd_pltfrm_runtime_suspend,
> +       .runtime_resume  = ufshcd_pltfrm_runtime_resume,
> +       .runtime_idle    = ufshcd_pltfrm_runtime_idle,
> +};
> +
> +static struct platform_driver ufs_hi3660_pltform = {
> +       .probe  = ufs_hi3660_probe,
> +       .remove = ufs_hi3660_remove,
> +       .shutdown = ufshcd_pltfrm_shutdown,
> +       .driver = {
> +               .name   = "ufshcd-hi3660",
> +               .pm     = &ufs_hi3660_pm_ops,
> +               .of_match_table = of_match_ptr(ufs_hi3660_of_match),
> +       },
> +};
> +module_platform_driver(ufs_hi3660_pltform);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:ufshcd-hi3660");
> +MODULE_DESCRIPTION("HiSilicon Hi3660 UFS Driver");
> diff --git a/drivers/scsi/ufs/ufs-hi3660.h b/drivers/scsi/ufs/ufs-hi3660.h
> new file mode 100755
> index 000000000000..04775cd2dddf
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-hi3660.h
> @@ -0,0 +1,170 @@
> +/* Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef UFS_HI3660_H_
> +#define UFS_HI3660_H_
> +
> +#define HBRN8_POLL_TOUT_MS      1000
> +
> +/*
> + * pericrg specific define
> + */
> +#define PEREN5_OFFSET          (0x050)
> +#define PERRSTEN3_OFFSET       (0x084)
> +#define PERRSTDIS3_OFFSET      (0x088)
> +#define PERRSTSTAT3_OFFSET     (0x08C)
> +#define CLKDIV16_OFFSET                (0x0E8)
> +#define CLKDIV17_OFFSET                (0x0EC)
> +#define CLKDIV21_OFFSET                (0x0FC)
> +#define UFS_ARESET             UFS_BIT(7)
> +#define RST_UFS                        UFS_BIT(12)
> +
> +/*
> + * ufs sysctrl specific define
> + */
> +#define PSW_POWER_CTRL                 (0x04)
> +#define PHY_ISO_EN                     (0x08)
> +#define HC_LP_CTRL                     (0x0C)
> +#define PHY_CLK_CTRL                   (0x10)
> +#define PSW_CLK_CTRL                   (0x14)
> +#define CLOCK_GATE_BYPASS              (0x18)
> +#define RESET_CTRL_EN                  (0x1C)
> +#define PHY_RESET_STATUS               (0x28)
> +#define UFS_SYSCTRL                    (0x5C)
> +#define UFS_DEVICE_RESET_CTRL           (0x60)
> +#define UFS_APB_ADDR_MASK              (0x64)
> +
> +#define BIT_UFS_PSW_ISO_CTRL           (1 << 16)
> +#define BIT_UFS_PSW_MTCMOS_EN          (1 << 0)
> +#define BIT_UFS_REFCLK_ISO_EN          (1 << 16)
> +#define BIT_UFS_PHY_ISO_CTRL           (1 << 0)
> +#define BIT_SYSCTRL_LP_ISOL_EN         (1 << 16)
> +#define BIT_SYSCTRL_LP_PWR_GATE                (1 << 0)
> +#define BIT_SYSCTRL_PWR_READY          (1 << 8)
> +#define BIT_SYSCTRL_REF_CLOCK_EN       (1 << 24)
> +#define MASK_SYSCTRL_REF_CLOCK_SEL     (0x3 << 8)
> +#define MASK_SYSCTRL_CFG_CLOCK_FREQ    (0xFF)
> +#define UFS_FREQ_CFG_CLK                (0x39)
> +#define BIT_SYSCTRL_PSW_CLK_EN         (1 << 4)
> +#define MASK_UFS_CLK_GATE_BYPASS       (0x3F)
> +#define BIT_STATUS_LP_RESETCOMPLETE    (1 << 0)
> +#define BIT_SYSCTRL_LP_RESET_N         (1 << 0)
> +#define BIT_UFS_REFCLK_SRC_SEl         (1 << 0)
> +#define MASK_UFS_SYSCRTL_BYPASS                (0x3F << 16)
> +#define MASK_UFS_DEVICE_RESET          (0x1 << 16)
> +#define BIT_UFS_DEVICE_RESET           (0x1)
> +
> +/*
> + * M-TX Configuration Attributes for hi3660
> + */
> +#define MPHY_TX_FSM_STATE                      0x41
> +#define TX_FSM_DISABLED                                0x0
> +#define TX_FSM_HIBERN8                         0x1
> +#define TX_FSM_SLEEP                           0x2
> +#define TX_FSM_STALL                           0x3
> +#define TX_FSM_LS_BURST                                0x4
> +#define TX_FSM_HS_BURST                                0x5
> +#define TX_FSM_LINE_CFG                                0x6
> +#define TX_FSM_LINE_RESET                      0x7
> +
> +/*
> + * hi3660 UFS HC specific Registers
> + */
> +enum {
> +       UFS_REG_OCPTHRTL = 0xc0,
> +       UFS_REG_OOCPR    = 0xc4,
> +
> +       UFS_REG_CDACFG   = 0xd0,
> +       UFS_REG_CDATX1   = 0xd4,
> +       UFS_REG_CDATX2   = 0xd8,
> +       UFS_REG_CDARX1   = 0xdc,
> +       UFS_REG_CDARX2   = 0xe0,
> +       UFS_REG_CDASTA   = 0xe4,
> +
> +       UFS_REG_LBMCFG   = 0xf0,
> +       UFS_REG_LBMSTA   = 0xf4,
> +       UFS_REG_UFSMODE  = 0xf8,
> +
> +       UFS_REG_HCLKDIV  = 0xfc,
> +};
> +
> +#define UFS_AHIT_AUTOH8_TIMER           (0x1001)
> +
> +/* REG UFS_REG_OCPTHRTL definition */
> +#define LP_PGE UFS_BIT(16)
> +#define LP_AH8_PGE UFS_BIT(17)
> +
> +#define UFS_HCLKDIV_NORMAL_VALUE       0xE4
> +#define UFS_HCLKDIV_FPGA_VALUE         0x28
> +
> +/* hi3660 UFS Unipro specific Registers */
> +#define VS_ULPH8_Cntrl 0xd0af
> +#define Ulp_Ulp_CtrlMode UFS_BIT(3)
> +
> +/* vendor specific pre-defined parameters */
> +#define SLOW 1
> +#define FAST 2
> +
> +#define UFS_HI3660_LIMIT_NUM_LANES_RX  2
> +#define UFS_HI3660_LIMIT_NUM_LANES_TX  2
> +#define UFS_HI3660_LIMIT_HSGEAR_RX     UFS_HS_G1
> +#define UFS_HI3660_LIMIT_HSGEAR_TX     UFS_HS_G1
> +#define UFS_HI3660_LIMIT_PWMGEAR_RX    UFS_PWM_G1
> +#define UFS_HI3660_LIMIT_PWMGEAR_TX    UFS_PWM_G1
> +#define UFS_HI3660_LIMIT_RX_PWR_PWM    SLOWAUTO_MODE
> +#define UFS_HI3660_LIMIT_TX_PWR_PWM    SLOWAUTO_MODE
> +#define UFS_HI3660_LIMIT_RX_PWR_HS     FASTAUTO_MODE
> +#define UFS_HI3660_LIMIT_TX_PWR_HS     FASTAUTO_MODE
> +#define UFS_HI3660_LIMIT_HS_RATE       PA_HS_MODE_A
> +#define UFS_HI3660_LIMIT_DESIRED_MODE  FAST
> +
> +struct ufs_hi3660_host {
> +       struct ufs_hba *hba;
> +       void __iomem *ufs_sys_ctrl;
> +       struct reset_control    *rst;
> +       struct reset_control    *assert;
> +       uint64_t caps;
> +#define hi3660_CAP_RESERVED    UFS_BIT(0)
> +#define USE_SNPS_MPHY_TC       UFS_BIT(1)
> +#define USE_FPGA_BOARD_CLK     UFS_BIT(2)
> +#define USE_RATE_B             UFS_BIT(3)
> +#define BROKEN_FASTAUTO                UFS_BIT(4)
> +#define USE_ONE_LANE           UFS_BIT(5)
> +#define USE_HS_GEAR3           UFS_BIT(6)
> +#define USE_HS_GEAR2           UFS_BIT(7)
> +#define USE_HS_GEAR1           UFS_BIT(8)
> +#define USE_AUTO_H8            UFS_BIT(9)
> +#define BROKEN_CLK_GATE_BYPASS UFS_BIT(10)
> +
> +       int avail_ln_rx;
> +       int avail_ln_tx;
> +
> +       u32 busthrtl_backup;
> +       u32 reset_gpio;
> +
> +       bool in_suspend;
> +
> +       struct ufs_pa_layer_attr dev_req_params;
> +};
> +
> +#define ufs_sys_ctrl_writel(host, val, reg)                                    \
> +       writel((val), (host)->ufs_sys_ctrl + (reg))
> +#define ufs_sys_ctrl_readl(host, reg) readl((host)->ufs_sys_ctrl + (reg))
> +#define ufs_sys_ctrl_set_bits(host, mask, reg)                                 \
> +       ufs_sys_ctrl_writel(                                                   \
> +               (host), ((mask) | (ufs_sys_ctrl_readl((host), (reg)))), (reg))
> +#define ufs_sys_ctrl_clr_bits(host, mask, reg)                                 \
> +       ufs_sys_ctrl_writel((host),                                            \
> +                           ((~(mask)) & (ufs_sys_ctrl_readl((host), (reg)))), \
> +                           (reg))
> +#endif /* UFS_HI3660_H_ */
> --
> 2.11.GIT
>
