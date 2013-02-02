From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
Date: Sat, 2 Feb 2013 10:09:59 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1302021003390.25931-100000@netrider.rowland.org>
References: <510CEE46.80308@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:49697 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757185Ab3BBPKA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Feb 2013 10:10:00 -0500
In-Reply-To: <510CEE46.80308@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Derek Basehore <dbasehore@chromium.org>, James Bottomley <JBottomley@Parallels.com>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>

On Sat, 2 Feb 2013, Aaron Lu wrote:

> >> An alternative way of possibly solving this problem from PM's point of
> >> view might be:
> >> 1 Set both ata port and scsi device's runtime status to RPM_SUSPENDED
> >>   in their system suspend callback;

By the way, what reason is there for doing this to the ATA port?  Does 
the port take a long time to resume, in the same way that a disk can 
take a few seconds to spin back up?

> >> 2 On resume, do nothing in their system resume callback;
> >> 3 With request based runtime PM introduced here:
> >>   http://thread.gmane.org/gmane.linux.power-management.general/30405
> >>   When a request comes for the HDD after system resume, both the ata
> >>   port and the scsi device will be runtime resumed, which involves
> >>   re-initialize the ata link(in ata port's runtime resume callback) and
> >>   spin up the HDD(in sd's runtime resume callback).
> >>
> >> To make HDD un-affetcted by runtime PM during normal use, a large enough
> >> autosuspend_delay can be set for it.
> >>
> >> Just my 2 cents, I've not verified or tried in any way yet :-)
> > 
> > It's a good idea.  The problem is that it won't work if CONFIG_PM_SLEEP
> > is enabled but CONFIG_PM_RUNTIME isn't.
> 
> Right, what a pity... thanks for the hint.
> 
> But the code is really simple if we ignore this problem(with some proper
> modifications to scsi bus PM callbacks, see the delayed_resume branch if
> you are interested), so I'm tempted to post it here :-)
> 
>  drivers/ata/libata-core.c | 22 +++++++++++-----------
>  drivers/scsi/scsi_pm.c    | 14 +++++++++++---
>  2 files changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 497adea..38000fc 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5355,10 +5355,19 @@ static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
>  
>  static int ata_port_suspend(struct device *dev)
>  {
> +	int ret;
> +
>  	if (pm_runtime_suspended(dev))
>  		return 0;
>  
> -	return ata_port_suspend_common(dev, PMSG_SUSPEND);
> +	ret = ata_port_suspend_common(dev, PMSG_SUSPEND);
> +	if (!ret) {
> +		__pm_runtime_disable(dev, false);

Don't you mean pm_runtime_disable(dev)?

> +		pm_runtime_set_suspended(dev);
> +		pm_runtime_enable(dev);
> +	}
> +
> +	return ret;
>  }
>  
>  static int ata_port_do_freeze(struct device *dev)
> @@ -5393,16 +5402,7 @@ static int ata_port_resume_common(struct device *dev, pm_message_t mesg)
>  
>  static int ata_port_resume(struct device *dev)
>  {
> -	int rc;
> -
> -	rc = ata_port_resume_common(dev, PMSG_RESUME);
> -	if (!rc) {
> -		pm_runtime_disable(dev);
> -		pm_runtime_set_active(dev);
> -		pm_runtime_enable(dev);
> -	}
> -
> -	return rc;
> +	return 0;
>  }
>  
>  /*
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index d9956b6..d0b6997 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -127,13 +127,21 @@ static int scsi_bus_prepare(struct device *dev)
>  static int scsi_bus_suspend(struct device *dev)
>  {
>  	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> -	return scsi_bus_suspend_common(dev, pm ? pm->suspend : NULL);
> +	int ret;
> +
> +	ret = scsi_bus_suspend_common(dev, pm ? pm->suspend : NULL);
> +	if (!ret) {
> +		__pm_runtime_disable(dev, false);
> +		pm_runtime_set_suspended(dev);
> +		pm_runtime_enable(dev);
> +	}
> +
> +	return ret;
>  }
>  
>  static int scsi_bus_resume(struct device *dev)
>  {
> -	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> -	return scsi_bus_resume_common(dev, pm ? pm->resume : NULL);
> +	return 0;
>  }

This doesn't look like it would work very well with something like a CD 
drive, which doesn't use block-layer runtime PM.  Is that what you 
meant when you talked about modifying the SCSI PM callbacks?

Alan Stern

