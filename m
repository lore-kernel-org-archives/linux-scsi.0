From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFT][PATCH] aic79xx: remove busyq
Date: Sun, 29 May 2005 13:21:30 +0400
Message-ID: <200505291321.31090.adobriyan@gmail.com>
References: <20050529074620.GA26151@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.202]:1889 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261197AbVE2JQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 May 2005 05:16:58 -0400
Received: by wproxy.gmail.com with SMTP id 68so1290110wri
        for <linux-scsi@vger.kernel.org>; Sun, 29 May 2005 02:16:57 -0700 (PDT)
In-Reply-To: <20050529074620.GA26151@havoc.gtf.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sunday 29 May 2005 11:46, Jeff Garzik wrote:
> This changes the aic79xx driver to use the standard Linux SCSI queueing
> code, rather than its own.  After applying this patch, NO behavior
> changes should be seen.
> 
> The patch is against 2.6.12-rc5, but probably applies OK to recent 2.6.x
> kernels.

s/PF_FREEZE/PF_NOFREEZE/ to apply to recent ones.

> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c

> @@ -2478,18 +2045,10 @@ ahd_linux_dv_thread(void *data)
>  	 * Complete thread creation.
>  	 */
>  	lock_kernel();
> -#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,60)
> -	/*
> -	 * Don't care about any signals.
> -	 */
> -	siginitsetinv(&current->blocked, 0);
>  
> -	daemonize();
> -	sprintf(current->comm, "ahd_dv_%d", ahd->unit);
> -#else
>  	daemonize("ahd_dv_%d", ahd->unit);
>  	current->flags |= PF_FREEZE;
> -#endif
> +
>  	unlock_kernel();
>  
>  	while (1) {
