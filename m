From: Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH v3 2/2] scsi: ufs: Add UFS platform driver for Cadence UFS
Date: Wed, 29 Aug 2018 15:57:22 +0530
Message-ID: <0b273e2e-6d60-ac10-a1d5-78ea2346c1d9@ti.com>
References: <66C16650-56D0-46A3-8050-A5540E48C702@global.cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <66C16650-56D0-46A3-8050-A5540E48C702@global.cadence.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Janek Kotas <jank@cadence.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thursday 09 August 2018 06:55 PM, Janek Kotas wrote:
> This patch adds a device tree platform driver for
> Cadence UFS Host Controller.
> It can be enabled with SCSI_UFS_CDNS_PLATFORM Kconfig option.
> 
> Signed-off-by: Jan Kotas <jank@cadence.com>

[...]

> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
> new file mode 100644
> index 00000000..5d9e4875
> --- /dev/null
> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
> @@ -0,0 +1,147 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Platform UFS Host driver for Cadence controller
> + *
> + * Copyright (C) 2018 Cadence Design Systems, Inc.
> + *
> + * Authors:
> + *	Jan Kotas <jank@cadence.com>
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/time.h>
> +
> +#include "ufshcd-pltfrm.h"
> +
> +#define CDNS_UFS_REG_HCLKDIV 0xFC
> +
> +/**
> + * Sets HCLKDIV register value based on the core_clk
> + * @hba: host controller instance
> + *
> + * Return zero for success and non-zero for failure
> + */
> +static int cdns_ufs_set_hclkdiv(struct ufs_hba *hba)
> +{
> +	struct ufs_clk_info *clki;
> +	struct list_head *head = &hba->clk_list_head;
> +	unsigned long core_clk_rate = 0;
> +	u32 core_clk_div = 0;
> +
> +	if (list_empty(head))
> +		return 0;
> +
> +	list_for_each_entry(clki, head, list) {
> +		if (IS_ERR_OR_NULL(clki->clk))
> +			continue;
> +		if (!strcmp(clki->name, "core_clk"))
> +			core_clk_rate = clk_get_rate(clki->clk);
> +	}
> +
> +	if (!core_clk_rate) {
> +		dev_err(hba->dev, "%s: unable to find core_clk rate\n",
> +			__func__);
> +		return -EINVAL;
> +	}
> +
> +	core_clk_div = core_clk_rate / USEC_PER_SEC;
> +
> +	ufshcd_writel(hba, core_clk_div, CDNS_UFS_REG_HCLKDIV);
> +	/* Make sure the register was updated */
> +	mb();

Why is it critical to ensure write completed here?

> +
> +	return 0;
> +}
> +

> +/**
> + * cdns_ufs_pltfrm_remove - set driver_data of the device to NULL

This appear to do more than setting driver_data to NULL.

> + * @pdev: pointer to platform device handle
> + *
> + * Always returns 0
> + */
> +static int cdns_ufs_pltfrm_remove(struct platform_device *pdev)
> +{
> +	struct ufs_hba *hba =  platform_get_drvdata(pdev);
> +
> +	pm_runtime_get_sync(&(pdev)->dev);

This looks suspect. Why do you need this get_sync() on remove() and
where is the corresponding put_sync()?

> +	ufshcd_remove(hba);
> +	return 0;
> +}

Thanks,
Sekhar
