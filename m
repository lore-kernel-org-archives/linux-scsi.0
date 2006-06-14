From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] Build mptspi.c on architectures where CONFIG_PM is unset
Date: Wed, 14 Jun 2006 17:16:27 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70199769@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:16365 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965025AbWFNXQl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jun 2006 19:16:41 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom 'spot' Callaway <tcallawa@redhat.com>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: davem@davemloft.net

On Saturday, June 03, 2006 8:37 AM,  Tom Callaway wrote:

> When trying to build mpt* for sparc64 (my T2000 needs mptsas and
> friends), I noticed that mptspi.o was not building:
> 
>   CC [M]  drivers/message/fusion/mptspi.o
> drivers/message/fusion/mptspi.c: In function `mptspi_resume':
> drivers/message/fusion/mptspi.c:844: error: implicit declaration of
> function `mptscsih_resume'
> drivers/message/fusion/mptspi.c: At top level:
> drivers/message/fusion/mptspi.c:839: warning: 'mptspi_resume' defined
> but not used
> make[3]: *** [drivers/message/fusion/mptspi.o] Error 1
> make[2]: *** [drivers/message/fusion] Error 2
> make[1]: *** [drivers/message] Error 2
> 
> sparc64 does not have CONFIG_PM defined, and mptscsih_resume 
> is wrapped
> in an #ifdef CONFIG_PM in mptscsih.h. mptscsih_resume is only used in
> the mptspi_resume function in mptspi.c, and its only call is in the
> pci_driver struct (and that call is also #ifdef CONFIG_PM). 
> In order to
> get the code to compile, I just needed to wrap the actual function in
> #ifdef CONFIG_PM, which is what this patch does. I can confirm that it
> gets the module building again without errors.
> 
> Signed-off-by: Tom "spot" Callaway <tcallawa@redhat.com>
> 
> --- linux-2.6.16-sparc64/drivers/message/fusion/mptspi.c.BAD
> +++ linux-2.6.16-sparc64/drivers/message/fusion/mptspi.c
> @@ -831,6 +831,7 @@
>  	return rc;
>  }
>  
> +#ifdef CONFIG_PM
>  /*
>   * spi module resume handler
>   */
> @@ -846,6 +847,7 @@
>  
>  	return rc;
>  }
> +#endif
>  

ACK, James pls apply to your scsi-misc tree.   


Eric Moore
LSI Logic
