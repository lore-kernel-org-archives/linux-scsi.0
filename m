From: vinayak holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH V5 3/4] [SCSI] ufs: Add Platform glue driver for ufshcd
Date: Fri, 4 Jan 2013 13:07:26 +0530
Message-ID: <CAKVbJB-rT3qE41AO_vbG-YyKv+F9_FxO6njsVfe+bJkBpw0FoQ@mail.gmail.com>
References: <50db5b12.644e420a.0ead.ffffbbac@mx.google.com>
	<50DC6224.7050109@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:53162 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab3ADHh1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jan 2013 02:37:27 -0500
Received: by mail-ob0-f172.google.com with SMTP id za17so14640704obc.3
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jan 2013 23:37:26 -0800 (PST)
In-Reply-To: <50DC6224.7050109@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, santoshsy@gmail.com

On Thu, Dec 27, 2012 at 8:28 PM, Subhash Jadavani
<subhashj@codeaurora.org> wrote:
> On 12/27/2012 1:45 AM, vinholikatti@gmail.com wrote:
>>
>> From: Vinayak Holikatti <vinholikatti@gmail.com>
>>
>> This patch adds Platform glue driver for ufshcd.
>>
>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>> Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
>> Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
>> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
>> ---
>>   drivers/scsi/ufs/Kconfig         |   11 ++
>>   drivers/scsi/ufs/Makefile        |    1 +
>>   drivers/scsi/ufs/ufshcd-pltfrm.c |  205
>> ++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 217 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.c
>>
>> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
>> index d77ae97..96e1721 100644
>> --- a/drivers/scsi/ufs/Kconfig
>> +++ b/drivers/scsi/ufs/Kconfig
>> @@ -57,3 +57,14 @@ config SCSI_UFSHCD_PCI
>>           If you have a controller with this interface, say Y or M here.
>>           If unsure, say N.
>> +
>> +config SCSI_UFSHCD_PLATFORM
>> +       tristate "Platform based UFS Controller support"
>
> This may sound more explicit: s/"Platform based"/"Platform bus based"
>>
>> +       depends on SCSI_UFSHCD
>> +       ---help---
>> +       This selects the UFS host controller support. If you have a
>> +          platform with UFS controller, say Y or M here.
>
> s/"If you have a platform with UFS controller,"/"If you have UFS controller
> on platform bus,"
>>
>> +
>> +          If you have a controller with this interface, say Y or M here.
>
> Why do we need this line? we already one comment above.
>>
>> +
>> +         If unsure, say N.
>> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
>> index 9eda0df..1e5bd48 100644
>> --- a/drivers/scsi/ufs/Makefile
>> +++ b/drivers/scsi/ufs/Makefile
>> @@ -1,3 +1,4 @@
>>   # UFSHCD makefile
>>   obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
>>   obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
>> +obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
>> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c
>> b/drivers/scsi/ufs/ufshcd-pltfrm.c
>> new file mode 100644
>> index 0000000..94acfdc
>> --- /dev/null
>> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
>> @@ -0,0 +1,205 @@
>> +/*
>> + * Universal Flash Storage Host controller driver
>
> Please add some comment to indicate that this is platform bus UFS host
> controller driver.
The File name itself would identify the nature of driver. can add for more info.
>>
>> + *
>> + * This code is based on drivers/scsi/ufs/ufshcd-pltfrm.c
>> + * Copyright (C) 2011-2012 Samsung India Software Operations
>> + *
>> + * Authors:
>> + *     Santosh Yaraganavi <santosh.sy@samsung.com>
>> + *     Vinayak Holikatti <h.vinayak@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version 2
>> + * of the License, or (at your option) any later version.
>> + * See the COPYING file in the top-level directory or visit
>> + * <http://www.gnu.org/licenses/gpl-2.0.html>
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * This program is provided "AS IS" and "WITH ALL FAULTS" and
>> + * without warranty of any kind. You are solely responsible for
>> + * determining the appropriateness of using and distributing
>> + * the program and assume all risks associated with your exercise
>> + * of rights with respect to the program, including but not limited
>> + * to infringement of third party rights, the risks and costs of
>> + * program errors, damage to or loss of data, programs or equipment,
>> + * and unavailability or interruption of operations. Under no
>> + * circumstances will the contributor of this Program be liable for
>> + * any damages of any kind arising from your use or distribution of
>> + * this program.
>> + */
>> +
>> +#include "ufshcd.h"
>> +#include <linux/platform_device.h>
>> +
>> +#ifdef CONFIG_PM
>> +/**
>> + * ufshcd_pltfrm_suspend - suspend power management function
>> + * @pdev: pointer to Platform device handle
>> + * @mesg: power state
>> + *
>> + * Returns -ENOSYS
>> + */
>> +static int ufshcd_pltfrm_suspend(struct platform_device *pdev,
>> +                                pm_message_t mesg)
>> +{
>> +       /*
>> +        * TODO:
>> +        * 1. Call ufshcd_suspend
>> +        * 2. Do bus specific power management
>> +        */
>> +
>> +       return -ENOSYS;
>> +}
>> +
>> +/**
>> + * ufshcd_pltfrm_resume - resume power management function
>> + * @pdev: pointer to Platform device handle
>> + *
>> + * Returns -ENOSYS
>> + */
>> +static int ufshcd_pltfrm_resume(struct platform_device *pdev)
>> +{
>> +       /*
>> +        * TODO:
>> +        * 1. Call ufshcd_resume.
>> +        * 2. Do bus specific wake up
>> +        */
>> +
>> +       return -ENOSYS;
>> +}
>> +#endif
>> +
>> +/**
>> + * ufshcd_pltfrm_probe - probe routine of the driver
>> + * @pdev: pointer to Platform device handle
>> + *
>> + * Returns 0 on success, non-zero value on failure
>> + */
>> +static int __devinit
>> +ufshcd_pltfrm_probe(struct platform_device *pdev)
>> +{
>> +       struct ufs_hba *hba;
>> +       void __iomem *mmio_base;
>> +       struct resource *mem_res;
>> +       struct resource *irq_res;
>> +       resource_size_t mem_size;
>> +       int err;
>> +       struct device *dev = &pdev->dev;
>> +
>> +       mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       if (!mem_res) {
>> +               dev_err(&pdev->dev,
>> +                       "%s: Memory resource not available\n", __FILE__);
>
> Why would we print the file name? Won't the device name prefix enough in
> debug message?
File name would be necessary for faster debugging
>>
>> +               err = -ENODEV;
>> +               goto out_error;
>> +       }
>> +
>> +       mem_size = resource_size(mem_res);
>> +       if (!request_mem_region(mem_res->start, mem_size, "ufshcd")) {
>
> you may want to use the UFSHCD macro:   s/"ufshcd"/UFSHCD
>
>> +               dev_err(&pdev->dev,
>> +                       "ufshcd: Cannot reserve the memory resource\n");
>
>
> "ufshcd:" prefix may not be required here as the device name prefix should
> be enough to know the context of the error.
"ufshcd:" Can be removed.
>>
>> +               err = -EBUSY;
>> +               goto out_error;
>> +       }
>> +
>> +       mmio_base = ioremap_nocache(mem_res->start, mem_size);
>> +       if (!mmio_base) {
>> +               dev_err(&pdev->dev, "memory map failed\n");
>> +               err = -ENOMEM;
>> +               goto out_release_regions;
>> +       }
>> +
>> +       irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>> +       if (!irq_res) {
>> +               dev_err(&pdev->dev, "ufshcd: IRQ resource not
>> available\n");
>
>
> Same as above. "ufshcd:" prefix may not be required here as the device name
> prefix should be enough to know the context of the error.
can be removed.
>
>> +               err = -ENODEV;
>> +               goto out_iounmap;
>> +       }
>> +
>> +       err = dma_set_coherent_mask(dev, dev->coherent_dma_mask);
>> +       if (err) {
>> +               dev_err(&pdev->dev, "set dma mask failed\n");
>> +               goto out_iounmap;
>> +       }
>> +
>> +       err = ufshcd_init(&pdev->dev, &hba, mmio_base, irq_res->start);
>> +       if (err) {
>> +               dev_err(&pdev->dev, "%s: Intialization failed\n",
>> +                       __FILE__);
>
>
> Again, not sure why we would need to prefix the file name here.
__FILE__ is necessary for faster debugging
>
>> +               goto out_iounmap;
>> +       }
>> +
>> +       platform_set_drvdata(pdev, hba);
>> +
>> +       return 0;
>> +
>> +out_iounmap:
>> +       iounmap(mmio_base);
>> +out_release_regions:
>> +       release_mem_region(mem_res->start, mem_size);
>> +out_error:
>> +       return err;
>> +}
>> +
>> +/**
>> + * ufshcd_pltfrm_remove - remove platform driver routine
>> + * @pdev: pointer to platform device handle
>> + *
>> + * Returns 0 on success, non-zero value on failure
>> + */
>> +static int __devexit ufshcd_pltfrm_remove(struct platform_device *pdev)
>> +{
>> +       struct resource *mem_res;
>> +       struct resource *irq_res;
>> +       resource_size_t mem_size;
>> +       struct ufs_hba *hba =  platform_get_drvdata(pdev);
>> +
>> +       irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>
> It would be better to save the irq number under "struct ufs_hba" during
> probe. So here during remove you just need simply need to call the
> "free_irq(irq_res->start, hba)"
Will modify the code accordingly in the next patchset.
>>
>> +
>> +       if (!irq_res)
>> +               dev_err(&pdev->dev, "ufshcd: IRQ resource not
>> available\n");
>> +       else
>> +               free_irq(irq_res->start, hba);
>> +
>> +       ufshcd_remove(hba);
>
> Remove should be exactly opposite of probe(). So shouldn't you call the
> ufshcd_remove() first and then free_irq() after that.
Some bugging controllers might raise the interrupt after resources are removed.
this sequence will prevent it.
>>
>> +       mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>
> You might want to save the pointer to mem_res in "struct ufs_hba" during
> probe and may use the same here.
>>
>> +       if (!mem_res)
>> +               dev_err(&pdev->dev, "ufshcd: Memory resource not
>> available\n");
>> +       else {
>> +               mem_size = resource_size(mem_res);
>> +               release_mem_region(mem_res->start, mem_size);
>> +       }
>> +       platform_set_drvdata(pdev, NULL);
>> +       return 0;
>> +}
>> +
>> +static const struct of_device_id ufs_of_match[] = {
>> +       { .compatible = "jedec,ufs-1.1"},
>> +};
>> +
>> +static struct platform_driver ufshcd_pltfrm_driver = {
>> +       .probe  = ufshcd_pltfrm_probe,
>> +       .remove = __devexit_p(ufshcd_pltfrm_remove),
>> +#ifdef CONFIG_PM
>> +       .suspend = ufshcd_pltfrm_suspend,
>> +       .resume = ufshcd_pltfrm_resume,
>> +#endif
>> +       .driver = {
>> +               .name   = "ufshcd",
>> +               .owner  = THIS_MODULE,
>> +               .of_match_table = ufs_of_match,
>> +       },
>> +};
>> +
>> +module_platform_driver(ufshcd_pltfrm_driver);
>> +
>> +MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
>> +MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
>> +MODULE_DESCRIPTION("Platform based UFS host controller driver");
>
>
> s/"Platform based"/"Platform Bus based"
>
>> +MODULE_LICENSE("GPL");
>> +MODULE_VERSION(UFSHCD_DRIVER_VERSION);
>
> You want to keep the same driver version as the UFS core driver?
>

-- 
Regards,
Vinayak Holikatti
