From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 3/6] [SCSI] runtime resume device before system suspend
Date: Thu, 24 Nov 2011 11:36:20 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1111241123030.21532-100000@netrider.rowland.org>
References: <1322137287.2597.10.camel@hp6530s>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1322137287.2597.10.camel@hp6530s>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 24 Nov 2011, Lin Ming wrote:

> > The point of this patch is to handle drivers that do different things
> > for runtime suspend and system sleep.  The only SCSI driver that
> > currently supports runtime suspend is sd, and it treats runtime suspend
> > the same as system sleep.  (Earlier I said it doesn't spin down disks
> > for runtime suspend -- that was wrong, it does.  It skips the spin-down
> > step only for PM_EVENT_FREEZE, which is part of the hibernation
> > procedure.)
> > 
> > Until other SCSI drivers support runtime suspend, this patch shouldn't 
> > be needed.  And spinning up runtime-suspended disks could add a lengthy 
> > delay to the system sleep transition, so it's better not to do this if 
> > at all possible.
> 
> For sd driver, PMSG_SUSPEND and PMSG_HIBERNATE are compatible with
> PMSG_AUTO_SUSPEND. PMSG_FREEZE is not compatible.

I'm not sure what you mean.  In the sd driver, PMSG_SUSPEND,
PMSG_HIBERNATE, and PMSG_AUTO_SUSPEND all do exactly the same thing.  
PMSG_FREEZE does a little less -- it doesn't spin down the drive.

> So we only need to runtime resume sd for PMSG_FREEZE case.

No, we don't.  PMSG_FREEZE does not care whether the drive is spinning
or not.  (That's why it skips the spin-down step.)  Therefore it's
silly to restart a stopped drive just in order to do a PMSG_FREEZE.

> How about below?
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index 549ea72..e2759d9 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -50,7 +50,13 @@ static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
>  	int err = 0;
>  
>  	if (scsi_is_sdev_device(dev)) {
> -		pm_runtime_resume(dev);
> +		if (pm_runtime_suspended(dev)) {
> +			if (msg.event == PM_EVENT_FREEZE)
> +				pm_runtime_resume(dev);
> +			else

The 3 lines above aren't needed.

> +				return 0;
> +		}
> +
>  		err = scsi_dev_type_suspend(dev, msg);
>  	}
>  	return err;

Of course, this leaves the patch in pretty much the same state as what 
Tejun objected to in

	http://marc.info/?l=linux-ide&m=132136894329965&w=2

I think this email discussion has answered his objection: The only SCSI
top-level driver implementing runtime suspend is sd, and sd treats
runtime suspend the same as system sleep.  It might be a good idea to
add a comment with this explanation along with the new code, however.

Alan Stern
