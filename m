From: Doug Ledford <dledford@redhat.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 23 Jan 2003 16:34:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030123213423.GA26415@redhat.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232040.41862.oliver@neukum.name> <20030123202835.GA25838@redhat.com> <200301232159.28656.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200301232159.28656.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

On Thu, Jan 23, 2003 at 09:59:28PM +0100, Oliver Neukum wrote:
> Hi Doug
> 
> > Actually, I would have both complicated and simple transports call
> > scsi_set_device_offline() and for two reasons.  1) you have to provide
> > that function for simple drivers so duplicating other detection code in
> > the scsi completion handler is a waste.  2) pretty much all transports
> > will learn of the device being offline while they are in their interrupt
> > handler and should already be holding the lock for the device, which means
> 
> This is not the case for USB and IEEE1394. I am not sure about PCMCIA.
> We are in context of a kernel thread while we learn about device removal.

No.  You might be in a kernel thread context when you decode an interrupt 
down to determining that a device was removed, but somewhere along the 
line you took an interrupt that told you the device was removed (or else 
the command simply timed out and you are in the error handler for the 
command already).  Are you saying that the USB subsystem queues up those 
interrupt packets and decodes them later (which is fine, I just want to be 
clear on the point)?

> > that calling scsi_set_device_offline() won't race with scsi_request_fn()
> > which also needs the device lock (which in reality is the host lock).
> > Saving this race is convenient enough IMHO to warrant saying that's the
> > way things need to be.
> >
> > > > scsi_set_device_offline(dev) calls a high-level kernel function to
> > > > start higher level things (block queue cut off, etc) which *may* need
> > > > to be done.
> >
> > No, scsi_set_device_offline() schedules the error handler thread for that
> > host to be woken up.
> >
> > > How do you differentiate between real failure and device removal?
> >
> > We don't, and we shouldn't.  Device removal *is* a real failure.
> 
> Well shouldn't a device removal remove the device as a logical
> entity and a failure should not?

No.  That's what the user space hot plug manager is for.  If you want this 
type of behaviour, you take an interrupt to tell you that the device is 
gone, you mark it gone, the error handler cleans up any outstanding 
commands, then once the device no longer has any commands outstanding 
*then* the hot plug manager can successfully umount/unattach/whatever the 
device and then tell the kernel to actually remove it.  Putting this into 
the scsi stack when it's already in place elsewhere makes no sense to me.

> > If the LLDD is the type such that it knows the device is gone (aka, in my
> > driver if I get a selection timeout then I know something is fishy and can
> > proceed from there, iSCSI may not be so lucky), then it has one of two
> > choices.  1) it may flush any commands that it can out of the hardware and
> > return them immediately with the same error condition as the one that it
> > is already returning.  2) it can sit and wait for the commands to timeout
> > one by one if that's what it wants.  Since the device has already been
> > marked offline by scsi_set_device_offline() and the error handler thread
> > is already scheduled to run for the device, 2 is probably the easiest
> > thing for the driver to do.  The error handler will call the abort/reset
> 
> Again not for USB and IEEE1394. We'd have to wait for the error handler
> to finish. Doing it ourselves is easier.

OK, are you reading my comments or not?  I said "since the error handler 
thread is already scheduled to run for the device, 2 is probably easiest".  
In other words, you don't have to wait for anything, it's gonna happen 
post-haste.  So since you should already have proper error handling 
functions in place (You do have proper error handler functions in place, 
don't you?), duplicating that code here won't really buy you anything.

> > Once all the commands are gone and no more are arriving, then if, and only
> > if, someone actually removes the device from the scsi subsystem (maybe
> > hotplug manager or something) then you will get the typical
> > slave_destroy() call to tell you that it is safe to release all resources
> > related to this device.  Otherwise, the device will hang around as an
> > offline device until someone does echo "scsi-remove-single-device a b c d"
> 
> Eek. That part I must strongly object to. The device is physically gone.
> Ever bothering the LLDD with it is very inconvinient.

OK, let's look at this realistically.  I'm saying you get an interrupt 
telling you that the device is gone and you tell the scsi core the same 
thing.  Immediately after that the scsi core calls your error handler 
routines to clean up any pending commands on the device.  Once all those 
pending commands are cleaned up, the hot plug manager is free to remove 
the device from the system.  Once the hot plug manager calls for the free 
to happen, you get a slave_destroy() call and you free the instances.  
This all happens in a span of a few milliseconds most likely.  Is that 
really so inconvenient for you?

> > > /proc/scsi/scsi to remove it.
> >
> > Basically, as I see it, we need a new function scsi_set_device_offline()
> > that marks the device offline, we need an offline check in
> 
> These functions are needed for a whole bus as well. USB needs it.
> 
> > As far as plugging back in, the answer is simple.  Until the old instance
> > is dead *and removed* a new one can't be added at the same ID, aka you
> > simply ignore the hot plug until the hot remove has completed.
> 
> What do you mean? It is dead because it is removed. How can a device be
> anything than dead if it has been unplugged? Please elaborate.

I said "old instance", aka the internal data structs (struct scsi_device 
for that device).  A device can be dead but not removed from the scsi 
subsys if no one has cleaned up after the removal by unmounting any 
filesystems that were on it and removing the scsi device itself.  That 
would be the job of the hotplug manager.

> And who should ignore a hot addition, the LLDD or SCSI core.
> If the former, again I must object.

The scsi core doesn't allow two devices with the same complete ID set.  
You would either have to attach the device at a different ID (aka khubd 
could set the reattached device to a higher SCSI ID or something) or wait 
for the hot plug manager to complete the old instance of the device's 
removal before adding the device back in again.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
