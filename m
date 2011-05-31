From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt
 coalescing to device 	attributes in sysfs
Date: Tue, 31 May 2011 15:41:16 +0800
Message-ID: <20110531074116.GB6099@kroah.com>
References: <20110526021809.GA22496@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD846E0@SC-VEXCH4.marvell.com>
 <20110526141430.GD4164@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD848FB@SC-VEXCH4.marvell.com>
 <20110527073302.GA16178@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD84C40@SC-VEXCH4.marvell.com>
 <20110530074508.GB7806@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD84CD9@SC-VEXCH4.marvell.com>
 <20110530144815.GB2689@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD84E1E@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41962 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754064Ab1EaHlF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2011 03:41:05 -0400
Content-Disposition: inline
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FAD84E1E@SC-VEXCH4.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "jslaby@suse.cz" <jslaby@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jacky Feng <jfeng@marvell.com>

On Tue, May 31, 2011 at 12:26:45AM -0700, Xiangliang Yu wrote:
> 
> >Then I would strongly recommend never exporting this value to allow it
> >to be changed at all then.  It doesn't sound worth it.
> OK, Thanks!
> I remove the sysfs file and the modified patch is:

Thanks for removing it, but you still left part of it in the patch, see
below.

> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index 9f1cccc..d977684 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -34,6 +34,8 @@ MODULE_PARM_DESC(collector, "\n"
>  	"\tThe mvsas SAS LLDD supports both modes.\n"
>  	"\tDefault: 1 (Direct Mode).\n");
>  
> +int interrupt_coalescing = 0x80;

This should be named something else, or made static, as you just made it
a global name, which is not good at all.

> @@ -48,6 +50,8 @@ static const struct mvs_chip_info mvs_chips[] = {
>  	[chip_1320] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
>  };
>  
> +struct device_attribute *mvst_host_attrs[] = { NULL };
> +
>  #define SOC_SAS_NUM 2
>  #define SG_MX 64
>  
> @@ -74,6 +78,7 @@ static struct scsi_host_template mvs_sht = {
>  	.slave_alloc		= mvs_slave_alloc,
>  	.target_destroy		= sas_target_destroy,
>  	.ioctl			= sas_ioctl,
> +	.shost_attrs		= mvst_host_attrs,

Here, you don't need these at all now, right?

thanks,

greg k-h
