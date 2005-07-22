From: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Subject: RE: ServeRAID V7.12
Date: Fri, 22 Jul 2005 12:13:59 -0400
Message-ID: <A121ABA5B472B74EB59076B8E3C8F019015341E1@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:43720 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262107AbVGVQPn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2005 12:15:43 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org

Arjan,

I'll resend this patch including **only** the version info updates.  
That's really the only important changes anyway ...

Thanks.

Jack 



-----Original Message-----
From: Arjan van de Ven [mailto:arjan@infradead.org] 
Sent: Friday, July 22, 2005 10:53 AM
To: Hammer, Jack
Cc: linux-scsi@vger.kernel.org
Subject: Re: ServeRAID V7.12


> 
> 
> --- a/drivers/scsi/ips.c	Tue Jul 19 13:15:24 2005
> +++ b/drivers/scsi/ips.c	Tue Jul 19 13:12:44 2005
> @@ -133,10 +133,12 @@
>  
>  #ifdef MODULE
>  static char *ips = NULL;
> -module_param(ips, charp, 0);
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,25) MODULE_PARM(ips, 
> +"s"); #else #include <linux/moduleparam.h> #define 
> +MAX_BOOT_OPTIONS_SIZE 256 static char 
> +boot_options[MAX_BOOT_OPTIONS_SIZE];
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





