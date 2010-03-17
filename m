From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mpt: modify mptctl_exit() to call proper deregister
 functions
Date: Wed, 17 Mar 2010 20:42:05 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249020E1A8413@inbmail02.lsi.com>
References: <4B9DCA3B.4080107@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:51662 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab0CQPMU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 11:12:20 -0400
In-Reply-To: <4B9DCA3B.4080107@jp.fujitsu.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Kei,

I do agree, your patch looks fine to me. We can consider if for upstream acceptance.
Please consider this patch as an ACKed.

--Kashyap

> -----Original Message-----
> From: Kei Tokunaga [mailto:tokunaga.keiich@jp.fujitsu.com]
> Sent: Monday, March 15, 2010 11:19 AM
> To: Desai, Kashyap
> Cc: linux-scsi@vger.kernel.org; Kei Tokunaga
> Subject: [PATCH] mpt: modify mptctl_exit() to call proper deregister
> functions
> 
> Hi Desai,
> 
> This patch fixes some issues of mptctl_exit().
> 
>   1) It doesn't call mpt_deregister() for mptctl_taskmgmt_id
>      => Insmoding/rmmoding mptctl.ko repeadtedly (up to
>         MPT_MAX_PROTOCOL_DRIVERS-1 at most) can eat up all cb_idx,
>         and that would cause a lack of MptCallbacks[],
> MptDriverClass[],
>         and MptEvHandlers[].
> 
>   2) It doesn't call mpt_event_deregister() for mptctl_id
>      => Need to call it.
> 
>   3) It calls mpt_reset_deregister() for mptctl_taskmgmt_id
>      => This could accidentally deregister an innocent reset handler
>         that you don't want to.
> 
> This patch also adds a check for mptctl_taskmgmt_id.
> 
> This applies to 2.6.34-rc1.
> 
> Thanks,
> Kei
> 
> 
> Signed-off-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
> ---
> 
>  linux-2.6.34-rc1-kei/drivers/message/fusion/mptctl.c |   13
> ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff -puN drivers/message/fusion/mptctl.c~fix-mptctl_exit
> drivers/message/fusion/mptctl.c
> --- linux-2.6.34-rc1/drivers/message/fusion/mptctl.c~fix-mptctl_exit
> 	2010-03-15 09:40:43.000000000 +0900
> +++ linux-2.6.34-rc1-kei/drivers/message/fusion/mptctl.c	2010-03-15
> 09:40:43.000000000 +0900
> @@ -2991,6 +2991,14 @@ static int __init mptctl_init(void)
>  	}
> 
>  	mptctl_taskmgmt_id = mpt_register(mptctl_taskmgmt_reply,
> MPTCTL_DRIVER);
> +	if (!mptctl_taskmgmt_id || mptctl_taskmgmt_id >=
> MPT_MAX_PROTOCOL_DRIVERS) {
> +		printk(KERN_ERR MYNAM ": ERROR: Failed to register with
> Fusion MPT base driver\n");
> +		mpt_deregister(mptctl_id);
> +		misc_deregister(&mptctl_miscdev);
> +		err = -EBUSY;
> +		goto out_fail;
> +	}
> +
>  	mpt_reset_register(mptctl_id, mptctl_ioc_reset);
>  	mpt_event_register(mptctl_id, mptctl_event_process);
> 
> @@ -3010,12 +3018,15 @@ static void mptctl_exit(void)
>  	printk(KERN_INFO MYNAM ": Deregistered /dev/%s @
> (major,minor=%d,%d)\n",
>  			 mptctl_miscdev.name, MISC_MAJOR,
> mptctl_miscdev.minor);
> 
> +	/* De-register event handler from base module */
> +	mpt_event_deregister(mptctl_id);
> +
>  	/* De-register reset handler from base module */
>  	mpt_reset_deregister(mptctl_id);
> 
>  	/* De-register callback handler from base module */
> +	mpt_deregister(mptctl_taskmgmt_id);
>  	mpt_deregister(mptctl_id);
> -	mpt_reset_deregister(mptctl_taskmgmt_id);
> 
>          mpt_device_driver_deregister(MPTCTL_DRIVER);
> 
> 
> _
> 
> 

