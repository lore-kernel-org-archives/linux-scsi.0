From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 2/3] scsi: add hooks for host runtime power management
Date: Thu, 03 Nov 2011 21:08:20 +0800
Message-ID: <1320325700.2813.61.camel@hp6530s>
References: <Pine.LNX.4.44L0.1111021044580.2217-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1111021044580.2217-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@Parallels.com>, Tejun Heo <tj@kernel.org>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-11-02 at 22:53 +0800, Alan Stern wrote:
> On Wed, 2 Nov 2011, Lin Ming wrote:
> 
> > Adds ->suspend and ->resume callbacks in struct scsi_host_template
> > to do host runtime power management.
> > 
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  drivers/scsi/scsi_pm.c   |   34 +++++++++++++++++++++++++++++++---
> >  include/scsi/scsi_host.h |    8 ++++++++
> >  2 files changed, 39 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> > index 1be6c5a..5742bed2 100644
> > --- a/drivers/scsi/scsi_pm.c
> > +++ b/drivers/scsi/scsi_pm.c
> > @@ -42,6 +42,28 @@ static int scsi_dev_type_resume(struct device *dev)
> >  	return err;
> >  }
> >  
> > +static int scsi_host_suspend(struct device *dev)
> > +{
> > +	struct Scsi_Host *shost = dev_to_shost(dev);
> > +	int err = 0;
> > +
> > +	if (shost->hostt->suspend)
> > +		err = shost->hostt->suspend(shost);
> > +
> > +	return err;
> > +}
> > +
> > +static int scsi_host_resume(struct device *dev)
> > +{
> > +	struct Scsi_Host *shost = dev_to_shost(dev);
> > +	int err = 0;
> > +
> > +	if (shost->hostt->resume)
> > +		err = shost->hostt->resume(shost);
> > +
> > +	return err;
> > +}
> 
> These don't need to be independent routines.  You can put them inline 
> in scsi_runtime_suspend() and scsi_runtime_resume() below; that's how 
> the device code is written.

OK.

> 
> > @@ -132,7 +160,7 @@ static int scsi_runtime_idle(struct device *dev)
> >  
> >  	/* Insert hooks here for targets, hosts, and transport classes */
> >  
> > -	if (scsi_is_sdev_device(dev))
> > +	if (scsi_is_sdev_device(dev) || scsi_is_host_device(dev))
> >  		err = pm_schedule_suspend(dev, 100);
> 
> This is wrong.  The 100-ms delay is meant for devices only.  There's 
> no reason to delay suspending a host once everything beneath it is 
> suspended.  Just leave the code the way it is now.

OK.

> 
> >  	else
> >  		err = pm_runtime_suspend(dev);
> > diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> > index f1f2644..512e2a0 100644
> > --- a/include/scsi/scsi_host.h
> > +++ b/include/scsi/scsi_host.h
> > @@ -356,6 +356,14 @@ struct scsi_host_template {
> >  	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
> >  
> >  	/*
> > +	 * Optional routine for scsi host runtime pm.
> > +	 *
> > +	 * Status: OPTIONAL
> > +	 */
> > +	int (*suspend)(struct Scsi_Host *);
> > +	int (*resume)(struct Scsi_Host *);
> 
> The comment should explain what drivers are supposed to do when these 
> hooks are called.  In particular, the suspend callback should _not_ 
> power-down the entire host adapter; it should power-down only the 
> circuitry that controls the interface to the SCSI bus.  The upstream 
> interface to the CPU should remain at full power.
> 
> If there's no way to power-down just that part of the host adapter then 
> there's no need to have these callbacks at all.  The low-level driver 
> can simply use the runtime PM API on its own struct device.

Good point.

I realize that this is not the natural way to do ata port runtime pm.
Hooking it to scsi host runtime pm is not good. It does not deal with
the races with system suspend/resume of host controller.

How about making ata port as the parent device of scsi host?
Then, for example, the runtime suspend happens as below,

disk suspend --> scsi target suspend --> scsi host suspend --> ata port
suspend.

Current device tree is:
/sys/devices/pci0000:00/0000:00:1f.2/
|-- ata1
|-- host0

After the change, the tree will become as:
/sys/devices/pci0000:00/0000:00:1f.2/ata1/
|-- host0

The tricky part is ata port(parent device) suspend need to schedule scsi
EH which will resume scsi host(child device). Then the child device
resume will in turn make parent device resume first. This is kind of
recursive.

We can fix this by adding a flag somewhere to tell scsi EH don't resume
the host in ata port pm request handling case.

What do you think?

Thanks,
Lin Ming

