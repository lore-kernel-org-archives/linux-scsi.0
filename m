From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Mon, 24 Sep 2012 23:40:18 +0200
Message-ID: <201209242340.18318.rjw@sisk.pl>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <201209241455.31754.rjw@sisk.pl> <20120924145235.GA3293@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120924145235.GA3293@mint-spring.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Monday, September 24, 2012, Aaron Lu wrote:
> On Mon, Sep 24, 2012 at 02:55:31PM +0200, Rafael J. Wysocki wrote:
> > On Monday, September 24, 2012, Aaron Lu wrote:
> > > On Fri, Sep 21, 2012 at 10:49:32PM +0200, Rafael J. Wysocki wrote:
> > > > On Friday, September 21, 2012, Aaron Lu wrote:
> > > > > On Thu, Sep 20, 2012 at 10:48:10PM +0200, Rafael J. Wysocki wrote:
> > > > > > On Wednesday, September 12, 2012, Aaron Lu wrote:

[...] 

> > > > > > >  	/* check whether GET_EVENT is reporting spurious MEDIA_CHANGE */
> > > > > > >  	if (!cd->tur_changed) {
> > > > > > > @@ -287,6 +294,12 @@ do_tur:
> > > > > > >  	cd->tur_changed = false;
> > > > > > >  	cd->get_event_changed = false;
> > > > > > >  
> > > > > > > +out:
> > > > > > > +	if (cd->media_present && !last_present)
> > > > > > > +		pm_runtime_put_noidle(&cd->device->sdev_gendev);
> > > > > > > +	else
> > > > > > > +		scsi_autopm_put_device(cd->device);
> > > > > > > +
> > > > > > 
> > > > > > This thing is asking for a comment.
> > > > > > 
> > > > > > It looks like you're kind of avoiding to call _idle() for the device, but why?
> > > > > > What might go wrong if pm_runtime_put() is used instead of the whole conditional,
> > > > > > among other things?
> > > > > 
> > > > > The above code means, if we found that a disc is just inserted(reflected
> > > > > by cd->media_present is true and last_present is false), we do not want
> > > > > to put the device into suspend state immediately until next poll. In the
> > > > > interval, some programs may decide to use this device by opening it.
> > > > > 
> > > > > Nothing will go wrong, but it can possibly avoid a runtime status change.
> > > > 
> > > > OK, so suppose the condition is true and we do the _noidle() put.  Who's
> > > > going to suspend the device in that case if no one actually uses the device?
> > > 
> > > Next time when the check_events poll runs, it will find that:
> > > 1 Either the disc is still there, then both last_present and
> > >   media_present would be true, we will do the put to idle it;
> > > 2 Or the disc is ejected, we will do the put to idle it.
> > 
> > In that case I would do:
> > 
> > pm_runtime_put_noidle(&cd->device->sdev_gendev);
> > if (cd->media_present && !last_present)
> >     pm_runtime_suspend(&cd->device->sdev_gendev);
> 
> This doesn't cover the !cd->media_present(media not present) case.
> If there is no media present, we will also need to idle it.

Oh, I got the condition backwards.  I meant:

pm_runtime_put_noidle(&cd->device->sdev_gendev);
if (!cd->media_present || last_present)
     pm_runtime_suspend(&cd->device->sdev_gendev);

which should be equivalent to your original code (if I'm not mistaken again).

> > And I'd add a comment about the next poll.
> > 
> > This appears somewhat racy, though, because in theory a media may be inserted
> > while we are removing power from the device.  Isn't that a problem?
> 
> Yes, this is a problem.
> To avoid this race, I think the following needs to be done:
> - For slot type ODD, make it such that user can't insert a disc;
> - For tray type ODD, make it such that when user presses the eject
>   button, the tray doesn't open.
> I'll see if this is possible, thanks for the remind.

OK

> > > The poll runs periodically, until the device is powered off(reflected by
> > > the powered_off flag), in which case, the poll will simply return
> > > 0 without touching this device.
> > 
> > Is it useful to poll the device after it has been suspended, but not powered
> > off?
> 
> Yes, it is necessary to poll the device when it has been suspended with
> power left. The reason is, we need to check if there is a media change
> event happened, and the way to check this is to issue a
> GET_EVENT_STATUS_NOTIFICATION comand.
> 
> Please note that when the drive is not powered off, it will not send us
> a notification when its eject button is pressed.

I'm not sure about that, actually.  If it doesn't notify us, that whole thing
is inherently racy pretty much beyond fixing, because it is always possible
that the user will press the eject button right after we've checked the
status last time and right before power removal.  We're going to lose that
event, so the user will have to push the button once again in that case.

> > > > > > >  	return events;
> > > > > > >  }
> > > > > > >  
> > > > > > > @@ -715,9 +728,14 @@ static int sr_probe(struct device *dev)
> > > > > > >  	dev_set_drvdata(dev, cd);
> > > > > > >  	disk->flags |= GENHD_FL_REMOVABLE;
> > > > > > >  	add_disk(disk);
> > > > > > > +	disk_events_set_poll_msecs(disk, 5000);
> > > > > > 
> > > > > > Why do you need this and why is the poll interval universally suitable?
> > > > > 
> > > > > For a system with udev, the block module parameter events_dfl_poll_msecs
> > > > > will be set to 2s. If disk's events_poll_msecs is not set, that will be
> > > > > used. So the disk will be polled every 2s, that means it will be runtime
> > > > > suspended/resumed every 2s if there is no user. I set it to 5s so that
> > > > > the device can stay in runtime suspended state longer.
> > > > > 
> > > > > And the sysfs interface is still there, if udev thinks a device needs
> > > > > special setting, it will do that and I'll not overwrite that setting.
> > > > 
> > > > I'm not quite convinced this is the right approach here.
> > > > 
> > > > So if you set it to 5 s this way, the user space will have no idea that
> > > > the polling happens less often than it thinks, or am I misunderstanding
> > > > what you said above?
> > > 
> > > That's correct.
> > > AFAIK, user space does not care how often the device is polled, it
> > > cares only one thing: when there is a media change event, please let me
> > > know(through uevent).
> > 
> > So that's why we do the polling, right?
> 
> Yes.

Well, that's difficult.

If the remote wakeup is signaled through a GPE, it should be possible to
enable it before we actually put the device into D3cold.  That may allow us
to eliminate the races.

Thanks,
Rafael
