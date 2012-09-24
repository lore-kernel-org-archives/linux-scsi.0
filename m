From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Mon, 24 Sep 2012 22:52:37 +0800
Message-ID: <20120924145235.GA3293@mint-spring.sh.intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
 <201209212249.33063.rjw@sisk.pl>
 <20120924012010.GA14797@mint-spring.sh.intel.com>
 <201209241455.31754.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201209241455.31754.rjw@sisk.pl>
Sender: linux-ide-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 24, 2012 at 02:55:31PM +0200, Rafael J. Wysocki wrote:
> On Monday, September 24, 2012, Aaron Lu wrote:
> > On Fri, Sep 21, 2012 at 10:49:32PM +0200, Rafael J. Wysocki wrote:
> > > On Friday, September 21, 2012, Aaron Lu wrote:
> > > > On Thu, Sep 20, 2012 at 10:48:10PM +0200, Rafael J. Wysocki wrote:
> > > > > On Wednesday, September 12, 2012, Aaron Lu wrote:
> > > > > > Place the ODD into runtime suspend state as soon as there is nobody
> > > > > > using it.
> > > > > 
> > > > > OK, so how is ODD related to the sr driver?
> > > > 
> > > > As Alan has explained, ODD(optical disk drive) is driven by scsi
> > > > sr driver.
> > > 
> > > OK, but what about writing "ODD (Optical Disk Drive)" in the changelog?
> > > 
> > > People reading git logs may not know all of the hardware acronyms and the
> > > "0" message doesn't go into the git log. :-)
> > > 
> > > > > > The only exception is, if we just find that a new medium is
> > > > > > inserted, we wait for the next events checking to idle it.
> > > > > 
> > > > > What exactly do you mean by "to idle it"?
> > > > 
> > > > I mean to put its usage count so that its idle callback will kick in.
> > > 
> > > So I'd just write that directly in the changelog.
> > > 
> > > > > Does this patch have any functional effect without the following patches?
> > > > 
> > > > Yes, this one alone takes care of ODD's runtime pm
> > > 
> > > I suppose you mean the runtime PM status and usage counter?  I.e. the "software
> > > state"?
> > 
> > Yes.
> > 
> > > 
> > > > while the following
> > > > patches take care of removing its power after it's runtime suspended.
> > > > But it doesn't have any real benefit without the following patches.
> > > 
> > > Please put that information into the changelog too.
> > 
> > As Alan explained, I think I would say:
> > Though currently it doesn't have any benefit, it allows its parent
> > devices enter runtime suspend state which may save some power.
> 
> Well, please say that in the changelog, then. :-)
> 
> > > > > > Based on ideas of Alan Stern and Oliver Neukum.
> > > > > > 
> > > > > > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> > > > > > ---
> > > > > >  drivers/scsi/sr.c | 29 +++++++++++++++++++++++++----
> > > > > >  1 file changed, 25 insertions(+), 4 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> > > > > > index 5fc97d2..7a8222f 100644
> > > > > > --- a/drivers/scsi/sr.c
> > > > > > +++ b/drivers/scsi/sr.c
> > > > > > @@ -45,6 +45,7 @@
> > > > > >  #include <linux/blkdev.h>
> > > > > >  #include <linux/mutex.h>
> > > > > >  #include <linux/slab.h>
> > > > > > +#include <linux/pm_runtime.h>
> > > > > >  #include <asm/uaccess.h>
> > > > > >  
> > > > > >  #include <scsi/scsi.h>
> > > > > > @@ -146,8 +147,12 @@ static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
> > > > > >  	kref_get(&cd->kref);
> > > > > >  	if (scsi_device_get(cd->device))
> > > > > >  		goto out_put;
> > > > > > +	if (scsi_autopm_get_device(cd->device))
> > > > > > +		goto out_pm;
> > > > > >  	goto out;
> > > > > 
> > > > > Why don't you do
> > > > > 
> > > > > > +	if (!scsi_autopm_get_device(cd->device))
> > > > > > +		goto out;
> > > > > 
> > > > > without the new label?
> > > > 
> > > > I was just stupidly following the pattern.
> > > > Thanks and I'll change this.
> > > > 
> > > > > 
> > > > > >  
> > > > > > + out_pm:
> > > > > > +	scsi_device_put(cd->device);
> > > > > >   out_put:
> > > > > >  	kref_put(&cd->kref, sr_kref_release);
> > > > > >  	cd = NULL;
> > > > > > @@ -163,6 +168,7 @@ static void scsi_cd_put(struct scsi_cd *cd)
> > > > > >  	mutex_lock(&sr_ref_mutex);
> > > > > >  	kref_put(&cd->kref, sr_kref_release);
> > > > > >  	scsi_device_put(sdev);
> > > > > > +	scsi_autopm_put_device(sdev);
> > > > > >  	mutex_unlock(&sr_ref_mutex);
> > > > > >  }
> > > > > >  
> > > > > > @@ -211,7 +217,7 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
> > > > > >  				    unsigned int clearing, int slot)
> > > > > >  {
> > > > > >  	struct scsi_cd *cd = cdi->handle;
> > > > > > -	bool last_present;
> > > > > > +	bool last_present = cd->media_present;
> > > > > >  	struct scsi_sense_hdr sshdr;
> > > > > >  	unsigned int events;
> > > > > >  	int ret;
> > > > > > @@ -220,6 +226,8 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
> > > > > >  	if (CDSL_CURRENT != slot)
> > > > > >  		return 0;
> > > > > >  
> > > > > > +	scsi_autopm_get_device(cd->device);
> > > > > > +
> > > > > >  	events = sr_get_events(cd->device);
> > > > > >  	cd->get_event_changed |= events & DISK_EVENT_MEDIA_CHANGE;
> > > > > >  
> > > > > > @@ -246,10 +254,9 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
> > > > > >  	}
> > > > > >  
> > > > > >  	if (!(clearing & DISK_EVENT_MEDIA_CHANGE))
> > > > > > -		return events;
> > > > > > +		goto out;
> > > > > >  do_tur:
> > > > > >  	/* let's see whether the media is there with TUR */
> > > > > > -	last_present = cd->media_present;
> > > > > >  	ret = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
> > > > > >  
> > > > > >  	/*
> > > > > > @@ -270,7 +277,7 @@ do_tur:
> > > > > >  	}
> > > > > >  
> > > > > >  	if (cd->ignore_get_event)
> > > > > > -		return events;
> > > > > > +		goto out;
> > > > > >  
> > > > > >  	/* check whether GET_EVENT is reporting spurious MEDIA_CHANGE */
> > > > > >  	if (!cd->tur_changed) {
> > > > > > @@ -287,6 +294,12 @@ do_tur:
> > > > > >  	cd->tur_changed = false;
> > > > > >  	cd->get_event_changed = false;
> > > > > >  
> > > > > > +out:
> > > > > > +	if (cd->media_present && !last_present)
> > > > > > +		pm_runtime_put_noidle(&cd->device->sdev_gendev);
> > > > > > +	else
> > > > > > +		scsi_autopm_put_device(cd->device);
> > > > > > +
> > > > > 
> > > > > This thing is asking for a comment.
> > > > > 
> > > > > It looks like you're kind of avoiding to call _idle() for the device, but why?
> > > > > What might go wrong if pm_runtime_put() is used instead of the whole conditional,
> > > > > among other things?
> > > > 
> > > > The above code means, if we found that a disc is just inserted(reflected
> > > > by cd->media_present is true and last_present is false), we do not want
> > > > to put the device into suspend state immediately until next poll. In the
> > > > interval, some programs may decide to use this device by opening it.
> > > > 
> > > > Nothing will go wrong, but it can possibly avoid a runtime status change.
> > > 
> > > OK, so suppose the condition is true and we do the _noidle() put.  Who's
> > > going to suspend the device in that case if no one actually uses the device?
> > 
> > Next time when the check_events poll runs, it will find that:
> > 1 Either the disc is still there, then both last_present and
> >   media_present would be true, we will do the put to idle it;
> > 2 Or the disc is ejected, we will do the put to idle it.
> 
> In that case I would do:
> 
> pm_runtime_put_noidle(&cd->device->sdev_gendev);
> if (cd->media_present && !last_present)
>     pm_runtime_suspend(&cd->device->sdev_gendev);

This doesn't cover the !cd->media_present(media not present) case.
If there is no media present, we will also need to idle it.

> 
> And I'd add a comment about the next poll.
> 
> This appears somewhat racy, though, because in theory a media may be inserted
> while we are removing power from the device.  Isn't that a problem?

Yes, this is a problem.
To avoid this race, I think the following needs to be done:
- For slot type ODD, make it such that user can't insert a disc;
- For tray type ODD, make it such that when user presses the eject
  button, the tray doesn't open.
I'll see if this is possible, thanks for the remind.

> 
> > The poll runs periodically, until the device is powered off(reflected by
> > the powered_off flag), in which case, the poll will simply return
> > 0 without touching this device.
> 
> Is it useful to poll the device after it has been suspended, but not powered
> off?

Yes, it is necessary to poll the device when it has been suspended with
power left. The reason is, we need to check if there is a media change
event happened, and the way to check this is to issue a
GET_EVENT_STATUS_NOTIFICATION comand.

Please note that when the drive is not powered off, it will not send us
a notification when its eject button is pressed.

> 
> > > > > >  	return events;
> > > > > >  }
> > > > > >  
> > > > > > @@ -715,9 +728,14 @@ static int sr_probe(struct device *dev)
> > > > > >  	dev_set_drvdata(dev, cd);
> > > > > >  	disk->flags |= GENHD_FL_REMOVABLE;
> > > > > >  	add_disk(disk);
> > > > > > +	disk_events_set_poll_msecs(disk, 5000);
> > > > > 
> > > > > Why do you need this and why is the poll interval universally suitable?
> > > > 
> > > > For a system with udev, the block module parameter events_dfl_poll_msecs
> > > > will be set to 2s. If disk's events_poll_msecs is not set, that will be
> > > > used. So the disk will be polled every 2s, that means it will be runtime
> > > > suspended/resumed every 2s if there is no user. I set it to 5s so that
> > > > the device can stay in runtime suspended state longer.
> > > > 
> > > > And the sysfs interface is still there, if udev thinks a device needs
> > > > special setting, it will do that and I'll not overwrite that setting.
> > > 
> > > I'm not quite convinced this is the right approach here.
> > > 
> > > So if you set it to 5 s this way, the user space will have no idea that
> > > the polling happens less often than it thinks, or am I misunderstanding
> > > what you said above?
> > 
> > That's correct.
> > AFAIK, user space does not care how often the device is polled, it
> > cares only one thing: when there is a media change event, please let me
> > know(through uevent).
> 
> So that's why we do the polling, right?

Yes.

> 
> > I agree that we can't make user wait for too long before seeing
> > something happen(auto play, etc.) after he inserted a disc, and 5
> > seconds doesn't seem too long to me.
> > 
> > > 
> > > Moreover, what about changing the code so that the polling doesn't
> > > actually resume the device?
> > 
> > Since the device is going to do IO(executing a scsi command), I think I
> > should resume the device.
> > 
> > But there is a case for ZPODD, when the ODD is powered off(reflected by
> > the powered_off flag), the events checking will simply return without
> > resuming the device.
> 
> Yes, I understand that.  My question is whether or not we still need to poll
> if the device hasn't been powered off, although it has been suspended.

Yes, it's necessary.

Thanks,
Aaron

> 
> > > > > >  
> > > > > >  	sdev_printk(KERN_DEBUG, sdev,
> > > > > >  		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
> > > > > > +
> > > > > > +	/* enable runtime pm */
> > > > > 
> > > > > Not really.  What it does is to enable the device to be suspended.
> > > > 
> > > > OK, will change this.
> > > > 
> > > > > 
> > > > > > +	scsi_autopm_put_device(cd->device);
> > > > > > +
> > > > > >  	return 0;
> > > > > >  
> > > > > >  fail_put:
> > > > > > @@ -965,6 +983,9 @@ static int sr_remove(struct device *dev)
> > > > > >  {
> > > > > >  	struct scsi_cd *cd = dev_get_drvdata(dev);
> > > > > >  
> > > > > > +	/* disable runtime pm */
> > > > > 
> > > > > And that prevents the device from being suspended (which means that it's
> > > > > going to be resumed at this point in case it was suspended before).
> > > > 
> > > > Yes, that's what I want.
> > > > We are removing its driver and I think we should undo what we have done
> > > > to it.
> > > 
> > > Yes, I agree.  Only the comment wording can better reflect what really
> > > happens here (runtime PM is not disabled, in particular).
> > 
> > OK, looks like you are saying by disable, disable_depth is the subject
> > while I'm playing with usage_count. I'll pay attention to these words,
> > thanks for the remind.
> 
> Please do.
> 
> Thanks,
> Rafael
