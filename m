From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] mptfusion: use strlcpy() instead of strncpy()
Date: Fri, 12 Jan 2018 15:45:56 +0200
Message-ID: <CAHp75VctB9uRwvEQH=GW65gfOOn4-P7UKNa2OxM0pO7qQjOZrw@mail.gmail.com>
References: <1515757619-29651-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:38414 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933478AbeALNp6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jan 2018 08:45:58 -0500
Received: by mail-qt0-f170.google.com with SMTP id d4so6048656qtj.5
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2018 05:45:57 -0800 (PST)
In-Reply-To: <1515757619-29651-1-git-send-email-wangxiongfeng2@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: suganath-prabu.subramani@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi <linux-scsi@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>

On Fri, Jan 12, 2018 at 1:46 PM, Xiongfeng Wang
<wangxiongfeng2@huawei.com> wrote:
> From: Xiongfeng Wang <xiongfeng.wang@linaro.org>
>
> drivers/message/fusion/mptctl.c: In function '__mptctl_ioctl.isra.3':
> ./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
> bound 12 equals destination size [-Wstringop-truncation]
>
> The compiler requires that the destination size should be greater than
> the length we copy to make sure the dest string is nul-terminated. We
> can just use strlcpy() to avoid this warning.

Are you sure it's a best approach in this case?

> -       strncpy (karg->driverVersion, MPT_LINUX_PACKAGE_NAME, MPT_IOCTL_VERSION_LENGTH);
> -       karg->driverVersion[MPT_IOCTL_VERSION_LENGTH-1]='\0';
> +       strlcpy (karg->driverVersion, MPT_LINUX_PACKAGE_NAME, MPT_IOCTL_VERSION_LENGTH);

This one is false positive.

> -       strncpy (karg.name, ioc->name, MPT_MAX_NAME);
> -       karg.name[MPT_MAX_NAME-1]='\0';
> -       strncpy (karg.product, ioc->prod_name, MPT_PRODUCT_LENGTH);
> -       karg.product[MPT_PRODUCT_LENGTH-1]='\0';
> +       strlcpy (karg.name, ioc->name, MPT_MAX_NAME);
> +       strlcpy (karg.product, ioc->prod_name, MPT_PRODUCT_LENGTH);

These two as well.

> -       strncpy(karg.serial_number, " ", 24);
> +       strlcpy(karg.serial_number, " ", 24);

This one is interesting indeed.
Though the fix would be rather something like

memset(&karg.serial_number, " ", 24); // leave 24 for best performance of memset
karg.serial_number[24-1] = '\0';

>                                 if (mpt_config(ioc, &cfg) == 0) {
>                                         ManufacturingPage0_t *pdata = (ManufacturingPage0_t *) pbuf;

>                                         if (strlen(pdata->BoardTracerNumber) > 1) {
> -                                               strncpy(karg.serial_number,                                                                         pdata->BoardTracerNumber, 24);
> -                                               karg.serial_number[24-1]='\0';
> +                                               strlcpy(karg.serial_number,
> +                                                       pdata->BoardTracerNumber, 24);
>                                         }

...and here you don't need to touch anything.

-- 
With Best Regards,
Andy Shevchenko
