From: "Luming Yu" <luming.yu@gmail.com>
Subject: Re: [PATCH] ATA convert GSI to irq on ia64
Date: Thu, 8 Feb 2007 17:15:32 +0800
Message-ID: <3877989d0702080115o15feb447h73e3fa310bc09fb4@mail.gmail.com>
References: <1170920422.15989.354.camel@ymzhang>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:22587 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423133AbXBHJPd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2007 04:15:33 -0500
Received: by an-out-0708.google.com with SMTP id b33so425386ana
        for <linux-scsi@vger.kernel.org>; Thu, 08 Feb 2007 01:15:32 -0800 (PST)
In-Reply-To: <1170920422.15989.354.camel@ymzhang>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>

if use ide_default_irq , then I guess the #if defined can be removed.
#define ATA_PRIMARY_IRQ(dev)   isa_irq_to_vector(0x1F0)


On 2/8/07, Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> If an ATA drive uses legacy mode, ata driver will choose 14 and 15 as the
> fixed irq number. On ia64 platform, such numbers are GSI and should be converted
> to irq vector.
>
> Below patch against kernel 2.6.20 fixes it.
>
> Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
>
> ---
>
> diff -Nraup linux-2.6.20/include/asm-generic/libata-portmap.h linux-2.6.20_fix/include/asm-generic/libata-portmap.h
> --- linux-2.6.20/include/asm-generic/libata-portmap.h   2007-02-08 15:13:44.000000000 +0800
> +++ linux-2.6.20_fix/include/asm-generic/libata-portmap.h       2007-02-08 15:20:13.000000000 +0800
> @@ -3,10 +3,20 @@
>
>  #define ATA_PRIMARY_CMD                0x1F0
>  #define ATA_PRIMARY_CTL                0x3F6
> +#if defined(__ia64__)
> +#define ATA_PRIMARY_IRQ(dev)   isa_irq_to_vector(14)
> +#else
>  #define ATA_PRIMARY_IRQ(dev)   14
> +#endif
> +
>
>  #define ATA_SECONDARY_CMD      0x170
>  #define ATA_SECONDARY_CTL      0x376
> +#if defined(__ia64__)
> +#define ATA_SECONDARY_IRQ(dev) isa_irq_to_vector(15)
> +#else
>  #define ATA_SECONDARY_IRQ(dev) 15
> +#endif
> +
>
>  #endif
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
