From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 4/4] ata: add ata port runtime PM callbacks
Date: Tue, 15 Nov 2011 06:54:25 -0800
Message-ID: <20111115145425.GL30922@google.com>
References: <Pine.LNX.4.44L0.1111141028140.2035-100000@iolanthe.rowland.org>
 <1321347089.26084.2.camel@minggr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48900 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab1KOOyb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2011 09:54:31 -0500
Content-Disposition: inline
In-Reply-To: <1321347089.26084.2.camel@minggr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>

On Tue, Nov 15, 2011 at 04:51:29PM +0800, Lin Ming wrote:
> > This is not the right approach.  You should look instead at 
> > scsi_dev_type_suspend() in scsi_pm.c.  If the device is already runtime 
> > suspended then the routine should return immediately.
> 
> How about below?
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index d329f8b..94b60bd 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -20,6 +20,9 @@ static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
>  	struct device_driver *drv;
>  	int err;
>  
> +	if (pm_runtime_suspended(dev))
> +		return 0;
> +

Something to be careful about is there are different types of suspend
states (PMSG_*).  IIUC, runtime PM is using PMSG_SUSPEND.  Other
states may or may not be compatible with PMSG_SUSPEND expectations, so
you can skip suspend operation if the newly requested state is
PMSG_SUSPEND but otherwise the controller needs to be woken up and
told to comply to the new state.

Thanks.

-- 
tejun
