Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37ACBC56201
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 17:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E993E20B1F
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 17:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730848AbgKYRoR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 12:44:17 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45829 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730347AbgKYRoR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2020 12:44:17 -0500
Received: by mail-oi1-f193.google.com with SMTP id l206so3674802oif.12;
        Wed, 25 Nov 2020 09:44:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w3w5EShVpbS4zVPbdplKntiscAtOq+MnXntYOSkY/FM=;
        b=bQMb+SHomxrBAao1GvXPXSHUSGN3Svxu8Kwl4DL06+kKeGQXhzS5imdD5GePCyoOjc
         qbAvMcFoiM34LTrSgM5id9/m5cfRa6rPhHV6ri2qeRbCOuTACrD7+LoUvHH7UzCtQLeP
         NPuMDzzO+QHPRMInXQOCmUNtcO4dAUAHf7MKeJEY59oW92yxym7l8OSNkivqULvwfzK2
         FRy25fZGM3ObeLq3aMSWIxU/D+Dc2qOVIoY+qFmiN7ON2vA+ONVPNLLJrl9/6vQq7bNJ
         vPe6yMwbZUHKlErYqIysYPlHi56iTOxMeecr/GNsY1OdDUBGWKzDvKPjYwiKEDYhOoY1
         aiXw==
X-Gm-Message-State: AOAM5309Wkh198FWfUUt+SCKuCxXILWtwtjfbAcALc0szZzgxSie+syj
        bTJxWUCHjJCJAQR2kq5Zje/m9oOyHpqmKBpwgAY=
X-Google-Smtp-Source: ABdhPJxOygE74UQ+G1lD6bnR7mhcc8RtuvmAKFBdoetnUfm4z+PEuURaMkHekPtcNkyKYToO9U8wBMvSrH8YCqo/nkQ=
X-Received: by 2002:aca:f15:: with SMTP id 21mr3064705oip.71.1606326246822;
 Wed, 25 Nov 2020 09:44:06 -0800 (PST)
MIME-Version: 1.0
References: <1606324841-217570-1-git-send-email-john.garry@huawei.com> <1606324841-217570-3-git-send-email-john.garry@huawei.com>
In-Reply-To: <1606324841-217570-3-git-send-email-john.garry@huawei.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 25 Nov 2020 18:43:55 +0100
Message-ID: <CAJZ5v0j=H4NVdvdrC6nCd36zEA2n1xpiRSgKN-OV6+GLasA+Jw@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] ACPI: Make acpi_dev_irqresource_disabled() public
To:     John Garry <john.garry@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 25, 2020 at 6:25 PM John Garry <john.garry@huawei.com> wrote:
>
> To allow the platform device to "put" an irq, make the function to reset
> an ACPI companion device irq resource public.
>
> Signed-off-by: John Garry <john.garry@huawei.com>

I'd rather move it to kernel/resource.c as it is not ACPI-specific and
its only connection to ACPI is that it is used in the ACPI resources
management code.

> ---
>  drivers/acpi/resource.c | 2 +-
>  include/linux/acpi.h    | 5 +++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index ad04824ca3ba..0999a98cab3c 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -380,7 +380,7 @@ unsigned int acpi_dev_get_irq_type(int triggering, int polarity)
>  }
>  EXPORT_SYMBOL_GPL(acpi_dev_get_irq_type);
>
> -static void acpi_dev_irqresource_disabled(struct resource *res, u32 gsi)
> +void acpi_dev_irqresource_disabled(struct resource *res, u32 gsi)
>  {
>         res->start = gsi;
>         res->end = gsi;
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 39263c6b52e1..d5101e36a645 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -467,6 +467,7 @@ bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
>                                          struct resource_win *win);
>  unsigned long acpi_dev_irq_flags(u8 triggering, u8 polarity, u8 shareable);
>  unsigned int acpi_dev_get_irq_type(int triggering, int polarity);
> +void acpi_dev_irqresource_disabled(struct resource *res, u32 gsi);
>  bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
>                                  struct resource *res);
>
> @@ -939,6 +940,10 @@ static inline struct acpi_device *acpi_resource_consumer(struct resource *res)
>         return NULL;
>  }
>
> +static inline void acpi_dev_irqresource_disabled(struct resource *res, u32 gsi)
> +{
> +}
> +
>  #endif /* !CONFIG_ACPI */
>
>  #ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
> --
> 2.26.2
>
