From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v3 12/13] scsi: ufs-exynos: add UFS host support for Exynos SoCs
Date: Thu, 01 Oct 2015 14:12:09 +0200
Message-ID: <2228323.jdbqnSKW75@wuerfel>
References: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com> <1443686970-28104-13-git-send-email-alim.akhtar@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443686970-28104-13-git-send-email-alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, JBottomley-wo1vFcy6AUs@public.gmane.org, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, amit.daniel-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thursday 01 October 2015 13:39:29 Alim Akhtar wrote:

> +static int exynos7_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
> +{
> +	int ret;
> +	const char *const clks[] = {
> +		"mout_sclk_combo_phy_embedded",
> +		"top_sclk_phy_fsys1_26m",
> +	};
> +

These clocks are neither in the binding nor in the example.

> +struct exynos_ufs_drv_data exynos_ufs_drvs[] = {
> +{
> +	.compatible		= "samsung,exynos7-ufs",
> +	.uic_attr		= &exynos7_uic_attr,
> +	.quirks			= UFSHCI_QUIRK_BYTE_ALIGN_UTRD |
> +				  UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR |
> +				  UFSHCI_QUIRK_BROKEN_HCE |
> +				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR,
> +	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
> +				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
> +				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
> +	.drv_init		= exynos7_ufs_drv_init,
> +	.pre_link		= exynos7_ufs_pre_link,
> +	.post_link		= exynos7_ufs_post_link,
> +	.pre_pwr_change		= exynos7_ufs_pre_pwr_change,
> +	.post_pwr_change	= exynos7_ufs_post_pwr_change,
> +}, {
> +}, };

The indentation is a bit unusual  here.

> diff --git a/drivers/scsi/ufs/ufs-exynos-hw.h b/drivers/scsi/ufs/ufs-exynos-hw.h
> new file mode 100644
> index 0000000..8464ec8
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-exynos-hw.h
> @@ -0,0 +1,43 @@
> +/*
> + * UFS Host Controller driver for Exynos specific extensions
> + *
> + * Copyright (C) 2014-2015 Samsung Electronics Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef _UFS_EXYNOS_HW_H_
> +#define _UFS_EXYNOS_HW_H_
> +
> +#include "ufs-exynos.h"
> +#include "unipro.h"
> +
> +static struct exynos_ufs_uic_attr exynos7_uic_attr = {

You cannot put 'static' variables into a header file.

> +
> +/**
> + * exynos_ufs_auto_ctrl_hcc - HCI core clock control by h/w
> + * Control should be disabled in the below cases
> + * - Before host controller S/W reset
> + * - Access to UFS protector's register
> + */
> +static void exynos_ufs_auto_ctrl_hcc(struct exynos_ufs *ufs, bool en)
> +{
> +	u32 misc = hci_readl(ufs, HCI_MISC);
> +
> +	if (en)
> +		hci_writel(ufs, misc | HCI_CORECLK_CTRL_EN, HCI_MISC);
> +	else
> +		hci_writel(ufs, misc & ~HCI_CORECLK_CTRL_EN, HCI_MISC);

Does this need a spinlock to ensure the change is done atomically?

> +}
> +
> +static void exynos_ufs_ctrl_clkstop(struct exynos_ufs *ufs, bool en)
> +{
> +	u32 ctrl = hci_readl(ufs, HCI_CLKSTOP_CTRL);
> +	u32 misc = hci_readl(ufs, HCI_MISC);
> +
> +	if (en) {
> +		hci_writel(ufs, misc | CLK_CTRL_EN_MASK, HCI_MISC);
> +		hci_writel(ufs, ctrl | CLK_STOP_MASK, HCI_CLKSTOP_CTRL);
> +	} else {
> +		hci_writel(ufs, ctrl & ~CLK_STOP_MASK, HCI_CLKSTOP_CTRL);
> +		hci_writel(ufs, misc & ~CLK_CTRL_EN_MASK, HCI_MISC);
> +	}

same here.

> +
> +static int exynos_ufs_get_clk_info(struct exynos_ufs *ufs)
> +{
> +	struct ufs_hba *hba = ufs->hba;
> +	struct list_head *head = &hba->clk_list_head;
> +	struct ufs_clk_info *clki;
> +	u32 pclk_rate;
> +	u32 f_min, f_max;
> +	u8 div = 0;
> +	int ret = 0;
> +
> +	if (!head || list_empty(head))
> +		goto out;
> +
> +	list_for_each_entry(clki, head, list) {
> +		if (!IS_ERR_OR_NULL(clki->clk)) {
> +			if (!strcmp(clki->name, "aclk_ufs"))
> +				ufs->clk_hci_core = clki->clk;
> +			else if (!strcmp(clki->name, "sclk_unipro_apb"))
> +				ufs->clk_apb = clki->clk;
> +			else if (!strcmp(clki->name, "sclk_unipro_main"))
> +				ufs->clk_unipro_main = clki->clk;
> +		}
> +	}

Using IS_ERR_OR_NULL is normally a bug. Also the list/loop can likely be
replaced with another way to express this.

> +			do {
> +				delta = h8_time - ktime_us_delta(ktime_get(),
> +							ufs->entry_hibern8_t);
> +				if (delta <= 0)
> +					break;
> +
> +				us = min_t(s64, delta, USEC_PER_MSEC);
> +				if (us >= 10)
> +					usleep_range(us, us + 10);
> +				else
> +					udelay(us);
> +			} while (1);

us is at least 1000 (USEC_PER_MSEC), so the else clause is never needed.

> +
> +const struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
> +	.name				= "exynos_ufs",
> +	.init				= exynos_ufs_init,
> +	.hce_enable_notify		= exynos_ufs_hce_enable_notify,
> +	.link_startup_notify		= exynos_ufs_link_startup_notify,
> +	.pwr_change_notify		= exynos_ufs_pwr_change_notify,
> +	.specify_nexus_t_xfer_req	= exynos_ufs_specify_nexus_t_xfer_req,
> +	.specify_nexus_t_tm_req		= exynos_ufs_specify_nexus_t_tm_req,
> +	.hibern8_notify			= exynos_ufs_hibern8_notify,
> +	.suspend			= exynos_ufs_suspend,
> +	.resume				= exynos_ufs_resume,
> +};
> +EXPORT_SYMBOL(ufs_hba_exynos_ops);

As mentioned in my reply to the build bug report, please restructure the
driver so this is not a global exported function but gets passed by the
probe function of the exynos driver into an exported function of the
common driver.

> diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
> new file mode 100644
> index 0000000..58aa714
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-exynos.h
> @@ -0,0 +1,463 @@
> +/*
> + * UFS Host Controller driver for Exynos specific extensions
> + *
> + * Copyright (C) 2014-2015 Samsung Electronics Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef _UFS_EXYNOS_H_
> +#define _UFS_EXYNOS_H_

You have a lot of things in this header that are only used in one of the
.c files, so just move them there and make the header as small as possible.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
