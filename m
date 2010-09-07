From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v3] scsi_debug: Convert to use root_device_register() and
 root_device_unregister()
Date: Mon, 6 Sep 2010 17:32:52 -0700
Message-ID: <20100907003251.GA21430@core.coreip.homeip.net>
References: <1283819068-24587-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:53042 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab0IGAc5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 20:32:57 -0400
Content-Disposition: inline
In-Reply-To: <1283819068-24587-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Greg KH <greg@kroah.com>

On Mon, Sep 06, 2010 at 05:24:28PM -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi Doug and Co,
> 
> This patch updates the scsi_debug virtual LLD to use root_device_register()
> and root_device_unregister() from include/linux/device.h instead of device_register()
> and device_unregister() respectively within scsi_debug_init() and scsi_debug_exit()
> This simply involved converting the static struct device pseudo_primary into a
> pointer that is setup by the call to root_device_register().
> 
> This patch also contains the correct IS_ERR() conditional check of
> root_device_register() from within scsi_debug_init().
> 
> Thanks to Richard Sharpe and Dmitry Torokhov for their help with this item.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Thanks for making the changes.

Acked-by: Dmitry Torokhov <dtor@mail.ru>

> ---
>  drivers/scsi/scsi_debug.c |   25 ++++++++-----------------
>  1 files changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index b02bdc6..6047c10 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3207,16 +3207,7 @@ static void do_remove_driverfs_files(void)
>  	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_add_host);
>  }
>  
> -static void pseudo_0_release(struct device *dev)
> -{
> -	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
> -		printk(KERN_INFO "scsi_debug: pseudo_0_release() called\n");
> -}
> -
> -static struct device pseudo_primary = {
> -	.init_name	= "pseudo_0",
> -	.release	= pseudo_0_release,
> -};
> +struct device *pseudo_primary;
>  
>  static int __init scsi_debug_init(void)
>  {
> @@ -3352,10 +3343,10 @@ static int __init scsi_debug_init(void)
>  			map_region(0, 2);
>  	}
>  
> -	ret = device_register(&pseudo_primary);
> -	if (ret < 0) {
> -		printk(KERN_WARNING "scsi_debug: device_register error: %d\n",
> -			ret);
> +	pseudo_primary = root_device_register("pseudo_0");
> +	if (IS_ERR(pseudo_primary)) {
> +		printk(KERN_WARNING "scsi_debug: root_device_register() error\n");
> +		ret = PTR_ERR(pseudo_primary);
>  		goto free_vm;
>  	}
>  	ret = bus_register(&pseudo_lld_bus);
> @@ -3402,7 +3393,7 @@ del_files:
>  bus_unreg:
>  	bus_unregister(&pseudo_lld_bus);
>  dev_unreg:
> -	device_unregister(&pseudo_primary);
> +	root_device_unregister(pseudo_primary);
>  free_vm:
>  	if (map_storep)
>  		vfree(map_storep);
> @@ -3423,7 +3414,7 @@ static void __exit scsi_debug_exit(void)
>  	do_remove_driverfs_files();
>  	driver_unregister(&sdebug_driverfs_driver);
>  	bus_unregister(&pseudo_lld_bus);
> -	device_unregister(&pseudo_primary);
> +	root_device_unregister(pseudo_primary);
>  
>  	if (dif_storep)
>  		vfree(dif_storep);
> @@ -3474,7 +3465,7 @@ static int sdebug_add_adapter(void)
>          spin_unlock(&sdebug_host_list_lock);
>  
>          sdbg_host->dev.bus = &pseudo_lld_bus;
> -        sdbg_host->dev.parent = &pseudo_primary;
> +        sdbg_host->dev.parent = pseudo_primary;
>          sdbg_host->dev.release = &sdebug_release_adapter;
>          dev_set_name(&sdbg_host->dev, "adapter%d", scsi_debug_add_host);
>  
> -- 
> 1.5.6.5
> 

-- 
Dmitry
