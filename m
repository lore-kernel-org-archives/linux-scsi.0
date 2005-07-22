From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: ServeRAID V7.12
Date: Fri, 22 Jul 2005 10:53:07 -0400
Message-ID: <1122043987.3577.35.camel@localhost.localdomain>
References: <A121ABA5B472B74EB59076B8E3C8F0190153418E@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [216.208.38.107] ([216.208.38.107]:36483 "EHLO
	OTTLS.pngxnet.com") by vger.kernel.org with ESMTP id S262105AbVGVOxT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2005 10:53:19 -0400
In-Reply-To: <A121ABA5B472B74EB59076B8E3C8F0190153418E@rtpe2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: linux-scsi@vger.kernel.org


> 
> 
> --- a/drivers/scsi/ips.c	Tue Jul 19 13:15:24 2005
> +++ b/drivers/scsi/ips.c	Tue Jul 19 13:12:44 2005
> @@ -133,10 +133,12 @@
>  
>  #ifdef MODULE
>  static char *ips = NULL;
> -module_param(ips, charp, 0);
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,25)
> +MODULE_PARM(ips, "s");
> +#else
> +#include <linux/moduleparam.h>
> +#define MAX_BOOT_OPTIONS_SIZE 256
> +static char boot_options[MAX_BOOT_OPTIONS_SIZE];
> +module_param_string(ips, boot_options, MAX_BOOT_OPTIONS_SIZE, 0);
> +#endif
>  #endif

this looks like a major code quality regression!
In fact, the outer MODULE ifdef should also go away


>  #ifdef MODULE
> -	if (ips)
> -		ips_setup(ips);
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,25)
> +    ips = boot_options;
> +#endif
> +    if (ips)
> +        ips_setup(ips);

this looks like a code clutter for a 2.6 driver




