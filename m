From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] [SCSI] pm: use callbacks from dev_pm_ops for scsi
 devices
Date: Wed, 10 Oct 2012 14:32:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1210101414570.1170-100000@iolanthe.rowland.org>
References: <1349854086-2502-2-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59566 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752293Ab2JJScO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Oct 2012 14:32:14 -0400
In-Reply-To: <1349854086-2502-2-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Wed, 10 Oct 2012, Aaron Lu wrote:

> Use of pm_message_t is deprecated and device driver is not supposed
> to use that. This patch tries to migrate the SCSI bus level pm callbacks
> to call device's pm callbacks defined in its driver's dev_pm_ops.
> 
> NO logic changes in scsi_pm.c, a new function called run_dev_callback is
> added, which will choose the proper callback for the device based on the
> mesg param passed in and then call that chosen callback function with
> the help of pm generic function APIs. So run_dev_callback will be used
> to replace the previous drv->suspend/drv->resume call.
> 
> Since only sd has implemented drv->suspend/drv->resume, and I'll update
> sd driver to use the new callbacks in the following patch, there is no
> need to fallback to call drv->suspend/drv->resume if dev_pm_ops is NULL.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

I'm sorry, but this is a really ugly patch.

>  drivers/scsi/scsi_pm.c | 85 +++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 66 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index dc0ad85..aeb151e 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -16,32 +16,62 @@
>  
>  #include "scsi_priv.h"
>  
> +static int run_dev_callback(struct device *dev, pm_message_t mesg)
> +{
> +	int ret;
> +
> +	switch (mesg.event) {
> +		case PM_EVENT_SUSPEND:
> +			ret = pm_generic_suspend(dev);
> +			break;
> +		case PM_EVENT_RESUME:
> +			ret = pm_generic_resume(dev);
> +			break;
> +		case PM_EVENT_FREEZE:
> +			ret = pm_generic_freeze(dev);
> +			break;
> +		case PM_EVENT_THAW:
> +			ret = pm_generic_thaw(dev);
> +			break;
> +		case PM_EVENT_HIBERNATE:
> +			ret = pm_generic_poweroff(dev);
> +			break;
> +		case PM_EVENT_RESTORE:
> +			ret = pm_generic_restore(dev);
> +			break;
> +		case PM_EVENT_AUTO_SUSPEND:
> +			ret = pm_generic_runtime_suspend(dev);
> +			break;
> +		case PM_EVENT_AUTO_RESUME:
> +			ret = pm_generic_runtime_resume(dev);
> +			break;
> +		default:
> +			ret = -1;
> +			break;
> +	}
> +
> +	return ret;
> +}

> @@ -115,23 +145,40 @@ static int scsi_bus_suspend(struct device *dev)
>  	return scsi_bus_suspend_common(dev, PMSG_SUSPEND);
>  }
>  
> +static int scsi_bus_resume(struct device *dev)
> +{
> +	return scsi_bus_resume_common(dev, PMSG_RESUME);
> +}
> +
>  static int scsi_bus_freeze(struct device *dev)
>  {
>  	return scsi_bus_suspend_common(dev, PMSG_FREEZE);
>  }
>  
> +static int scsi_bus_thaw(struct device *dev)
> +{
> +	return scsi_bus_resume_common(dev, PMSG_THAW);
> +}
> +
>  static int scsi_bus_poweroff(struct device *dev)
>  {
>  	return scsi_bus_suspend_common(dev, PMSG_HIBERNATE);
>  }
>  
> +static int scsi_bus_restore(struct device *dev)
> +{
> +	return scsi_bus_resume_common(dev, PMSG_RESTORE);
> +}
> +

This is just dumb.  Do the parts that depend on the event type here, in 
these routines, instead of using a big "switch" statement somewhere 
else.  For example, have these routines figure out which callback 
routine or generic routine to use, and pass that pointer to 
scsi_bus_{suspend,resume}_common() instead of the PMSG_* argument.

One thing may help simplify the conversion (you can do this in a
separate patch).  Linus's current git tree contains a new commit
88d26136a256576e444db312179e17af6dd0ea87 (PM: Prevent runtime suspend
during system resume) which makes some of the code in scsi_pm.c
unnecessary.  The following two commits can now be reverted:

	33a2285d96b5e7b9500612ec623bf4313397bb53
	[SCSI] scsi_pm: set device runtime state before parent suspended

	28fd00d42cca178638f51c08efa986a777c24a4b
	[SCSI] runtime resume parent for child's system-resume

This will reduce the amount of code you need to worry about.

Alan Stern

