From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 03/25] scsi: hisi_sas: add initial bare driver
Date: Thu, 15 Oct 2015 10:23:08 +0100
Message-ID: <561F707C.1070305@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
 <1444663237-238302-4-git-send-email-john.garry@huawei.com>
 <561F68A9.6090706@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:4186 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbJOJXj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 05:23:39 -0400
In-Reply-To: <561F68A9.6090706@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xinwei Kong <kong.kongxinwei@hisilicon.com>, James.Bottomley@HansenPartnership.com
Cc: devicetree@vger.kernel.org, arnd@arndb.de, linux-scsi@vger.kernel.org, john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-kernel@vger.kernel.com, hare@suse.de, zhangfei.gao@linaro.org

On 15/10/2015 09:49, Xinwei Kong wrote:
>
>
> On 2015/10/12 23:20, John Garry wrote:
>> This patch adds the initial bare driver for the HiSilicon
>> SAS HBA. The driver includes no HW interaction, but only
>> the changes to build and load the driver module.
>>
>> The HBA is a platform device.
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> ---
>>   drivers/scsi/Kconfig                  |  1 +
>>   drivers/scsi/Makefile                 |  1 +
>>   drivers/scsi/hisi_sas/Kconfig         |  5 +++
>>   drivers/scsi/hisi_sas/Makefile        |  2 ++
>>   drivers/scsi/hisi_sas/hisi_sas.h      | 24 +++++++++++++++
>>   drivers/scsi/hisi_sas/hisi_sas_init.c | 58 +++++++++++++++++++++++++++++++++++
>>   6 files changed, 91 insertions(+)
>>   create mode 100644 drivers/scsi/hisi_sas/Kconfig
>>   create mode 100644 drivers/scsi/hisi_sas/Makefile
>>   create mode 100644 drivers/scsi/hisi_sas/hisi_sas.h
>>   create mode 100644 drivers/scsi/hisi_sas/hisi_sas_init.c
>>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 95f7a76..5c345f9 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -1774,5 +1774,6 @@ source "drivers/scsi/pcmcia/Kconfig"
>>   source "drivers/scsi/device_handler/Kconfig"
>>
>>   source "drivers/scsi/osd/Kconfig"
>> +source "drivers/scsi/hisi_sas/Kconfig"
>>
>>   endmenu
>> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
>> index 1a8c9b5..03c30de 100644
>> --- a/drivers/scsi/Makefile
>> +++ b/drivers/scsi/Makefile
>> @@ -158,6 +158,7 @@ obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
>>   obj-$(CONFIG_SCSI_ENCLOSURE)	+= ses.o
>>
>>   obj-$(CONFIG_SCSI_OSD_INITIATOR) += osd/
>> +obj-$(CONFIG_SCSI_HISI_SAS) += hisi_sas/
>>
>>   # This goes last, so that "real" scsi devices probe earlier
>>   obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
>> diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
>> new file mode 100644
>> index 0000000..a7f47a2
>> --- /dev/null
>> +++ b/drivers/scsi/hisi_sas/Kconfig
>> @@ -0,0 +1,5 @@
>> +config SCSI_HISI_SAS
>> +	tristate "HiSilicon SAS"
>> +	select SCSI_SAS_LIBSAS
>> +	help
>> +		This driver supports HiSilicon's SAS HBA
>> diff --git a/drivers/scsi/hisi_sas/Makefile b/drivers/scsi/hisi_sas/Makefile
>> new file mode 100644
>> index 0000000..63c3c4d
>> --- /dev/null
>> +++ b/drivers/scsi/hisi_sas/Makefile
>> @@ -0,0 +1,2 @@
>> +obj-$(CONFIG_SCSI_HISI_SAS) += hisi_sas.o
>> +hisi_sas-y+= hisi_sas_init.o
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
>> new file mode 100644
>> index 0000000..50204a2
>> --- /dev/null
>> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
>> @@ -0,0 +1,24 @@
>> +/*
>> + * Copyright (c) 2015 Linaro Ltd.
>> + * Copyright (c) 2015 Hisilicon Limited.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + */
>> +
>> +#ifndef _HISI_SAS_H_
>> +#define _HISI_SAS_H_
>> +
>> +#include <linux/module.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/platform_device.h>
>> +#include <scsi/libsas.h>
>> +
> why place some "include" head in .h file rather than .c file?
This is private header within the module, which:
- makes the code more concise
- relocate functions within c files is cleaner
- easier to change the kernel APIs we use in the module

>> +#define DRV_NAME "hisi_sas"
>> +#define DRV_VERSION "v1.0"
>> +
>> +#endif
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
>> new file mode 100644
>> index 0000000..dd83430
>> --- /dev/null
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
>> @@ -0,0 +1,58 @@
>> +/*
>> + * Copyright (c) 2015 Linaro Ltd.
>> + * Copyright (c) 2015 Hisilicon Limited.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + */
>> +
>> +#include "hisi_sas.h"
>> +
>> +static const struct of_device_id sas_of_match[] = {
>> +	{ .compatible = "hisilicon,sas-controller-v1",},
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, sas_of_match);
>> +static int hisi_sas_probe(struct platform_device *pdev)
>> +{
>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_sas_remove(struct platform_device *pdev)
>> +{
>> +	return 0;
>> +}
>> +
>> +static struct platform_driver hisi_sas_driver = {
>> +	.probe = hisi_sas_probe,
>> +	.remove = hisi_sas_remove,
>> +	.driver = {
>> +		.name = DRV_NAME,
>> +		.of_match_table = sas_of_match,
>> +	},
>> +};
>> +
>> +static __init int hisi_sas_init(void)
>> +{
>> +	pr_info("hisi_sas: driver version %s\n", DRV_VERSION);
>> +
>> +	return platform_driver_register(&hisi_sas_driver);
>> +}
>> +
>> +static __exit void hisi_sas_exit(void)
>> +{
>> +	platform_driver_unregister(&hisi_sas_driver);
>> +}
>> +
>> +module_init(hisi_sas_init);
>> +module_exit(hisi_sas_exit);
>> +
>> +MODULE_VERSION(DRV_VERSION);
>> +MODULE_LICENSE("GPL");
> V2
Can add. We do say in the header that it is v2.

>> +MODULE_AUTHOR("John Garry <john.garry@huawei.com>");
>> +MODULE_DESCRIPTION("HISILICON SAS controller driver");
>> +MODULE_ALIAS("platform:" DRV_NAME);
>>
>
>
> .
>

thanks,
John


