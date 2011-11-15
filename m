From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 4/4] ata: add ata port runtime PM callbacks
Date: Tue, 15 Nov 2011 11:08:52 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1111151052160.2345-100000@iolanthe.rowland.org>
References: <20111115145425.GL30922@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111115145425.GL30922@google.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 15 Nov 2011, Tejun Heo wrote:

> On Tue, Nov 15, 2011 at 04:51:29PM +0800, Lin Ming wrote:
> > > This is not the right approach.  You should look instead at 
> > > scsi_dev_type_suspend() in scsi_pm.c.  If the device is already runtime 
> > > suspended then the routine should return immediately.
> > 
> > How about below?
> > 
> > diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> > index d329f8b..94b60bd 100644
> > --- a/drivers/scsi/scsi_pm.c
> > +++ b/drivers/scsi/scsi_pm.c
> > @@ -20,6 +20,9 @@ static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
> >  	struct device_driver *drv;
> >  	int err;
> >  
> > +	if (pm_runtime_suspended(dev))
> > +		return 0;
> > +
> 
> Something to be careful about is there are different types of suspend
> states (PMSG_*).  IIUC, runtime PM is using PMSG_SUSPEND.  Other
> states may or may not be compatible with PMSG_SUSPEND expectations, so
> you can skip suspend operation if the newly requested state is
> PMSG_SUSPEND but otherwise the controller needs to be woken up and
> told to comply to the new state.

That's right.  Surprisingly enough (and contrary to what I wrote
earlier), the sd_suspend() routine doesn't spin down a drive for
runtime suspend.  This probably should be considered a bug.

Anyway, it looks like the correct approach would be more like this:

 static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
 {
 	int err = 0;
 
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev)) {
 		pm_runtime_resume(dev);
 		err = scsi_dev_type_suspend(dev, msg);
+	}
 	return err;
 }

Alan Stern

