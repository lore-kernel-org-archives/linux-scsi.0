From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] kill FusionInitCalled
Date: Thu, 21 Oct 2004 10:21:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041021092133.GA2322@infradead.org>
References: <20041002081148.GA13609@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:58633 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268700AbUJUJVn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 05:21:43 -0400
Content-Disposition: inline
In-Reply-To: <20041002081148.GA13609@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Emoore@lsil.com, linux-scsi@vger.kernel.org

On Sat, Oct 02, 2004 at 10:11:48AM +0200, Christoph Hellwig wrote:
> the scsi early init problem is long gone, so no need to work around it
> anymore.

ping?

> 
> 
> 
> --- 1.33/drivers/message/fusion/mptbase.c	2004-09-29 04:47:31 +02:00
> +++ edited/drivers/message/fusion/mptbase.c	2004-10-01 12:02:37 +02:00
> @@ -155,7 +155,6 @@
>  static MPT_RESETHANDLER		 MptResetHandlers[MPT_MAX_PROTOCOL_DRIVERS];
>  static struct mpt_pci_driver 	*MptDeviceDriverHandlers[MPT_MAX_PROTOCOL_DRIVERS];
>  
> -static int	FusionInitCalled = 0;
>  static int	mpt_base_index = -1;
>  static int	last_drv_idx = -1;
>  
> @@ -603,22 +602,6 @@
>  
>  	last_drv_idx = -1;
>  
> -#ifndef MODULE
> -	/*
> -	 *  Handle possibility of the mptscsih_detect() routine getting
> -	 *  called *before* fusion_init!
> -	 */
> -	if (!FusionInitCalled) {
> -		dprintk((KERN_INFO MYNAM ": Hmmm, calling fusion_init from mpt_register!\n"));
> -		/*
> -		 *  NOTE! We'll get recursion here, as fusion_init()
> -		 *  calls mpt_register()!
> -		 */
> -		fusion_init();
> -		FusionInitCalled++;
> -	}
> -#endif
> -
>  	/*
>  	 *  Search for empty callback slot in this order: {N,...,7,6,5,...,1}
>  	 *  (slot/handle 0 is reserved!)
> @@ -5933,11 +5916,6 @@
>  {
>  	int i;
>  	int r;
> -
> -	if (FusionInitCalled++) {
> -		dprintk((KERN_INFO MYNAM ": INFO - Driver late-init entry point called\n"));
> -		return 0;
> -	}
>  
>  	show_mptmod_ver(my_NAME, my_VERSION);
>  	printk(KERN_INFO COPYRIGHT "\n");
> ===== drivers/message/fusion/mptscsih.c 1.50 vs edited =====
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
