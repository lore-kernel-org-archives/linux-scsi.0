Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6D7C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 05:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC9A206C0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 05:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgENFxM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 01:53:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:54036 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbgENFxM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 May 2020 01:53:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AE6C4AD72;
        Thu, 14 May 2020 05:53:13 +0000 (UTC)
Subject: Re: [RFC PATCH v2 5/7] ata_dev_printk: Use dev_printk
To:     Tony Asleson <tasleson@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20200513213621.470411-1-tasleson@redhat.com>
 <20200513213621.470411-6-tasleson@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <82257837-c5a8-6a38-ce13-0f1ce7e245ac@suse.de>
Date:   Thu, 14 May 2020 07:53:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200513213621.470411-6-tasleson@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/20 11:36 PM, Tony Asleson wrote:
> Utilize the dev_printk function which will add structured data
> to the log message.
> 
> Signed-off-by: Tony Asleson <tasleson@redhat.com>
> ---
>   drivers/ata/libata-core.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 42c8728f6117..16978d615a17 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -7301,6 +7301,7 @@ EXPORT_SYMBOL(ata_link_printk);
>   void ata_dev_printk(const struct ata_device *dev, const char *level,
>   		    const char *fmt, ...)
>   {
> +	const struct device *gendev;
>   	struct va_format vaf;
>   	va_list args;
>   
> @@ -7309,9 +7310,12 @@ void ata_dev_printk(const struct ata_device *dev, const char *level,
>   	vaf.fmt = fmt;
>   	vaf.va = &args;
>   
> -	printk("%sata%u.%02u: %pV",
> -	       level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
> -	       &vaf);
> +	gendev = (dev->sdev) ? &dev->sdev->sdev_gendev : &dev->tdev;
> +
> +	dev_printk(level, gendev, "ata%u.%02u: %pV",
> +			dev->link->ap->print_id,
> +			dev->link->pmp + dev->devno,
> +			&vaf);
>   
>   	va_end(args);
>   }
> 
That is wrong.
dev_printk() will already prefix the logging message with the device 
name, so we'll end up having the name printed twice.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
