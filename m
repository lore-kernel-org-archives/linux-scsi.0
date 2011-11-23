From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 3/6] [SCSI] runtime resume device before system suspend
Date: Wed, 23 Nov 2011 12:02:39 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1111231149300.2111-100000@iolanthe.rowland.org>
References: <1322031686-28233-4-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1322031686-28233-4-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 23 Nov 2011, Lin Ming wrote:

> From: Alan Stern <stern@rowland.harvard.edu>
> 
> scsi device runtime PM is using PMSG_SUSPEND. System PM may use other state
> that may not be compatiable with PMSG_SUSPEND.

Actually SCSI runtime PM uses PMSG_AUTO_AUTOSUSPEND, which is the same
as PMSG_SUSPEND except that the PM_EVENT_AUTO bit is also set in the
pm_message.event field.  Currently they _are_ compatible.

> So we need to runtime resume the device before system suspend.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
> 
> Alan,
> 
> Could you add your Signed-off-by?
> Free free to change the commit logs.

I don't know; this is a little questionable.

The point of this patch is to handle drivers that do different things
for runtime suspend and system sleep.  The only SCSI driver that
currently supports runtime suspend is sd, and it treats runtime suspend
the same as system sleep.  (Earlier I said it doesn't spin down disks
for runtime suspend -- that was wrong, it does.  It skips the spin-down
step only for PM_EVENT_FREEZE, which is part of the hibernation
procedure.)

Until other SCSI drivers support runtime suspend, this patch shouldn't 
be needed.  And spinning up runtime-suspended disks could add a lengthy 
delay to the system sleep transition, so it's better not to do this if 
at all possible.

Alan Stern

>  drivers/scsi/scsi_pm.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index d329f8b..549ea72 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -49,8 +49,10 @@ static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
>  {
>  	int err = 0;
>  
> -	if (scsi_is_sdev_device(dev))
> +	if (scsi_is_sdev_device(dev)) {
> +		pm_runtime_resume(dev);
>  		err = scsi_dev_type_suspend(dev, msg);
> +	}
>  	return err;
>  }

