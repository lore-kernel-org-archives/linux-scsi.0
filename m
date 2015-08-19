From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 6/8] scsi: ufs: make the UFS variant a platform device
Date: Wed, 19 Aug 2015 21:23:09 +0900
Message-ID: <CAC5umyj1MGfrpgenXk0NJ6pd=PZ2VLRpOvn6Yq93SKsfaEDcTQ@mail.gmail.com>
References: <1439720057-9186-1-git-send-email-ygardi@codeaurora.org>
	<1439720057-9186-7-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1439720057-9186-7-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-08-16 19:14 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> +/**
> + * ufs_qcom_remove - set driver_data of the device to NULL
> + * @pdev: pointer to platform device handle
> + *
> + * Always return 0
> + */
> +static int ufs_qcom_remove(struct platform_device *pdev)
> +{
> +       struct ufs_hba *hba =  platform_get_drvdata(pdev);
> +
> +       pm_runtime_get_sync(&(pdev)->dev);
> +       ufshcd_remove(hba);
> +       ufshcd_dealloc_host(hba);

scsi_host_put (== ufshcd_dealloc_host) is already called in ufshcd_remove().
So we shouldn't call it here again.

> +static struct platform_driver ufs_qcom_pltform = {
> +       .probe  = ufs_qcom_probe,
> +       .remove = ufs_qcom_remove,
> +       .shutdown = ufs_qcom_shutdown,
> +       .driver = {
> +               .name   = "ufshcd-qcom",
> +               .owner  = THIS_MODULE,

We don't need to set .owner.  Please see commit 37b6fea57b4
("scsi: ufs: drop owner assignment from platform_drivers").

> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index 7db9564..20009a9 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -38,20 +38,9 @@
>  #include <linux/of.h>
>
>  #include "ufshcd.h"
> +#include "ufshcd-pltfrm.h"
>
>  static const struct of_device_id ufs_of_match[];

We can remove this forward declaration as ufs_of_match is removed below.

> @@ -245,10 +234,11 @@ out:
>   * Returns 0 if successful
>   * Returns non-zero otherwise
>   */
> -static int ufshcd_pltfrm_suspend(struct device *dev)
> +int ufshcd_pltfrm_suspend(struct device *dev)
>  {
>         return ufshcd_system_suspend(dev_get_drvdata(dev));
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_pltfrm_suspend);
>
>  /**
>   * ufshcd_pltfrm_resume - resume power management function
> @@ -257,23 +247,30 @@ static int ufshcd_pltfrm_suspend(struct device *dev)
>   * Returns 0 if successful
>   * Returns non-zero otherwise
>   */
> -static int ufshcd_pltfrm_resume(struct device *dev)
> +int ufshcd_pltfrm_resume(struct device *dev)
>  {
>         return ufshcd_system_resume(dev_get_drvdata(dev));
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_pltfrm_resume);
>
> -static int ufshcd_pltfrm_runtime_suspend(struct device *dev)
> +int ufshcd_pltfrm_runtime_suspend(struct device *dev)
>  {
>         return ufshcd_runtime_suspend(dev_get_drvdata(dev));
>  }
> -static int ufshcd_pltfrm_runtime_resume(struct device *dev)
> +EXPORT_SYMBOL_GPL(ufshcd_pltfrm_runtime_suspend);
> +
> +int ufshcd_pltfrm_runtime_resume(struct device *dev)
>  {
>         return ufshcd_runtime_resume(dev_get_drvdata(dev));
>  }
> -static int ufshcd_pltfrm_runtime_idle(struct device *dev)
> +EXPORT_SYMBOL_GPL(ufshcd_pltfrm_runtime_resume);
> +
> +int ufshcd_pltfrm_runtime_idle(struct device *dev)
>  {
>         return ufshcd_runtime_idle(dev_get_drvdata(dev));
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_pltfrm_runtime_idle);
> +
>  #else /* !CONFIG_PM */
>  #define ufshcd_pltfrm_suspend  NULL
>  #define ufshcd_pltfrm_resume   NULL

Since ufshcd_pltfrm_suspend()/resume() and ufshcd_pltfrm_runtime_*()
are only defined when CONFIG_PM=y,  ufs-qcom.c can't be built when !CONFIG_PM.

These #ifdef should be moved to ufshcd-pltfrm.h, or we can export
ufshcd_dev_pm_ops instead of the pm functions.

> @@ -282,18 +279,15 @@ static int ufshcd_pltfrm_runtime_idle(struct device *dev)
>  #define ufshcd_pltfrm_runtime_idle     NULL
>  #endif /* CONFIG_PM */
>
> -static void ufshcd_pltfrm_shutdown(struct platform_device *pdev)
> -{
> -       ufshcd_shutdown((struct ufs_hba *)platform_get_drvdata(pdev));
> -}

How about exporting this function? ufs-qcom and other variant can use this.

> +#ifndef UFSHCD_PLTFRM_H_
> +#define UFSHCD_PLTFRM_H_
> +
> +#include "ufshcd.h"
> +
> +int ufshcd_pltfrm_init(struct platform_device *pdev,
> +                      struct ufs_hba_variant_ops *vops);

struct platform_device appears before including <linux/platform_device.h>.

> +/* variant specific ops structures */
> +#ifdef CONFIG_SCSI_UFS_QCOM
> +extern struct ufs_hba_variant_ops ufs_hba_qcom_variant;
> +#endif

What is ufs_hba_qcom_variant? I can't find in kernel source and
this patch series.
