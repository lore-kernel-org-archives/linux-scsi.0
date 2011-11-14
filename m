From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 4/4] ata: add ata port runtime PM callbacks
Date: Mon, 14 Nov 2011 10:31:45 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1111141028140.2035-100000@iolanthe.rowland.org>
References: <1321247661.6599.110.camel@minggr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1321247661.6599.110.camel@minggr>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 14 Nov 2011, Lin Ming wrote:

> Current patches has a bug that system suspend fails if ata port was
> runtime suspended.
> 
> disk suspend issues sync cache and stop device commands that obviously
> need ata port to be active. So we need to runtime resume ata port first.

This is wrong.  If the port is already suspended then so are all the 
drives below the port.  Hence there is no need to sync the cache or 
stop the device.

> Alan, Tejun
> 
> How about below fix?
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index fa3a591..ebb87fbf 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -50,6 +50,7 @@
>  #include <linux/string_helpers.h>
>  #include <linux/async.h>
>  #include <linux/slab.h>
> +#include <linux/pm_runtime.h>
>  #include <asm/uaccess.h>
>  #include <asm/unaligned.h>
>  
> @@ -2762,6 +2763,14 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
>  	if (!sdkp)
>  		return 0;	/* this can happen */
>  
> +	/*
> +	 * Resume parent device to handle sync cache and
> +	 * stop device commands
> +	 */
> +	ret = pm_runtime_get_sync(dev->parent);
> +	if (ret)
> +		goto exit;
> +
>  	if (sdkp->WCE) {
>  		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
>  		ret = sd_sync_cache(sdkp);

This is not the right approach.  You should look instead at 
scsi_dev_type_suspend() in scsi_pm.c.  If the device is already runtime 
suspended then the routine should return immediately.

Alan Stern

