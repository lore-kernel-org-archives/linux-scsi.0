From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 3/6] [SCSI] runtime resume device before system suspend
Date: Fri, 25 Nov 2011 10:19:58 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1111251018560.1951-100000@iolanthe.rowland.org>
References: <1322229039.4246.8.camel@hp6530s>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1322229039.4246.8.camel@hp6530s>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Tejun Heo <tj@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 25 Nov 2011, Lin Ming wrote:

> Below is the updated patch with your suggested patch description and
> comments.
> 
> Looks OK?
> 
> Subject: [PATCH] [SCSI] check runtime PM status in system PM
> 
> The only high-level SCSI driver that currently implements runtime PM is
> sd, and sd treats runtime suspend exactly the same as the SUSPEND and
> HIBERNATE stages of system sleep, but not the same as the FREEZE stage.
> 
> Therefore, when entering the SUSPEND or HIBERNATE stages of system
> sleep, we can skip the callback to the driver if the device is already
> in runtime suspend.  When entering the FREEZE stage, however, we should
> first issue a runtime resume.  The overhead of doing this is
> negligible, because a suspended drive would be spun up during the THAW
> stage of hibernation anyway.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  drivers/scsi/scsi_pm.c |   16 +++++++++++++++-
>  1 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index d329f8b..a633076 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -49,8 +49,22 @@ static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
>  {
>  	int err = 0;
>  
> -	if (scsi_is_sdev_device(dev))
> +	if (scsi_is_sdev_device(dev)) {
> +		/*
> +		 * sd is the only high-level SCSI driver to implement runtime
> +		 * PM, and sd treats runtime suspend, system suspend, and
> +		 * system hibernate identically (but not system freeze).
> +		 */
> +		if (pm_runtime_suspended(dev)) {
> +			if (msg.event == PM_EVENT_SUSPEND ||
> +			    msg.event == PM_EVENT_HIBERNATE)
> +				return 0;	/* already suspended */
> +
> +			/* wake up device so that FREEZE will succeed */
> +			pm_runtime_resume(dev);
> +		}
>  		err = scsi_dev_type_suspend(dev, msg);
> +	}
>  	return err;
>  }

This looks good to me.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

