From: Doug Ledford <dledford@redhat.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 23 Jan 2003 15:28:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030123202835.GA25838@redhat.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301231919.40422.oliver@neukum.name> <3E303D5E.5020000@splentec.com> <200301232040.41862.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200301232040.41862.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

On Thu, Jan 23, 2003 at 08:40:41PM +0100, Oliver Neukum wrote:
> Am Donnerstag, 23. Januar 2003 20:07 schrieb Luben Tuikov:
> 
> > return value for simpler and more complicated transports has to
> > be the same (i.e. ones which know about the device disconnect and
> > others which send out the CDB and which will return with error).
> 
> Why? It throws away information needlessly. If the LLDD knows
> that the reason is unplugging why not report it?

What does it matter?  If you know that the device was unplugged, are you 
going to then wait for it to be plugged back in and if it's plugged back 
in (and confirmed to be the same device via serial number or some such) 
pick back up where you left off like nothing happened?  That would be the 
only reason to care about whether it was unplugged or died.  And if you 
did that you would probably violate the rule of least suprise with people 
unplugging their hard disks in a fit when they realize they did rm -fr on 
the drive and then when they plug it back in to check out how much damage 
they did it picks back up where it left off!

> A LLDD that doesn't
> know about devices going away on the other hand can just report
> an error.

For SPI that would be DID_TIMEOUT, aka the device wasn't there.  For iSCSI 
it would be timeout as well.  Pretty much anything is simply going to be 
either timeout or if you know it's gone you could return some other error.

> Can the higher layers simply assume that the device was unplugged?
> IMHO they can't and should at least try to recover from the error.

Correct.  And this isn't a problem.

> > I forgot to mention this with my previous email: think of a LLDD
> > more as part of the transport than of SCSI Core.
> 
> Hard to do. The scsi mid layer does timing out and error handling.
> There's a relatively tight connection.
> 
> > > So the first thing a LLDD has to do after it has learned about a device
> > > being removed is to have the device block.
> >
> > ``block'' (verb) is such a strong word.
> 
> What do you prefer ? ;-) I'll certainly use another word if you like me to
> do so.
> 
> > * Simple transports: call scsi_set_device_offline(dev) or something like
> > this.
> >
> > * More complicated transports: SCSI Core sees Service Response of Service
> > Delivery Failure and it itself calls scsi_set_device_offline(dev).

Actually, I would have both complicated and simple transports call 
scsi_set_device_offline() and for two reasons.  1) you have to provide 
that function for simple drivers so duplicating other detection code in 
the scsi completion handler is a waste.  2) pretty much all transports 
will learn of the device being offline while they are in their interrupt 
handler and should already be holding the lock for the device, which means 
that calling scsi_set_device_offline() won't race with scsi_request_fn() 
which also needs the device lock (which in reality is the host lock).  
Saving this race is convenient enough IMHO to warrant saying that's the 
way things need to be.

> > scsi_set_device_offline(dev) calls a high-level kernel function to start
> > higher level things (block queue cut off, etc) which *may* need to be done.

No, scsi_set_device_offline() schedules the error handler thread for that 
host to be woken up.

> How do you differentiate between real failure and device removal?

We don't, and we shouldn't.  Device removal *is* a real failure.

> > > So it should be the LLDD's responsibility to finish the outstanding
> > > commands.
> >
> > LLDD cannot really ``finish'' outstanding commands, it's just a transport
> > portal.
> 
> Well, report back the results, if you prefer, thus returning ownership to
> higher layers.

If the LLDD is the type such that it knows the device is gone (aka, in my 
driver if I get a selection timeout then I know something is fishy and can 
proceed from there, iSCSI may not be so lucky), then it has one of two 
choices.  1) it may flush any commands that it can out of the hardware and 
return them immediately with the same error condition as the one that it 
is already returning.  2) it can sit and wait for the commands to timeout 
one by one if that's what it wants.  Since the device has already been 
marked offline by scsi_set_device_offline() and the error handler thread 
is already scheduled to run for the device, 2 is probably the easiest 
thing for the driver to do.  The error handler will call the abort/reset 
routine for each command still outstanding and the LLDD can just clean up 
one at a time and return them as it would under any other error condition.

> > > Furthermore, there's a window for commands already having passed the
> > > check for offline but not yet being noticed by the LLDD.

No, not if you handle things in the interrupt handler and if your 
interrupt handler holds the host lock like it's suppossed to.  If you want 
to go without using these locking methods in your lldd then you are free 
to do so, but that means *you* need to handle this situation in your 
driver, the mid layer shouldn't be trying to solve this problem for lldd 
that want to be lock free.

> > They will return with an appropriate error.
> 
> Not quite so simple. Some LLDDs need to know at some point that
> no more commands will arrive for sure and none are still in flight.

Follow the simple rule above and when you call scsi_set_device_offline() 
then you will *never* get called in your queuecommand() for that device 
again.  That is separate from all commands being cleaned up.  That will 
happen after the error handler thread has run and cleaned your driver out.  
Once all the commands are gone and no more are arriving, then if, and only 
if, someone actually removes the device from the scsi subsystem (maybe 
hotplug manager or something) then you will get the typical 
slave_destroy() call to tell you that it is safe to release all resources 
related to this device.  Otherwise, the device will hang around as an 
offline device until someone does echo "scsi-remove-single-device a b c d" 
> /proc/scsi/scsi to remove it.

Basically, as I see it, we need a new function scsi_set_device_offline()  
that marks the device offline, we need an offline check in
scsi_request_fn(), and we need scsi_set_device_offline() to schedule the
error handler thread for wakeup (and it should flag the device that needs
recovered so that the error handler thread knows what to do), then the
error handler thread routine needs modified to understand what to do with
a device that's been offlined with commands outstanding, and once all the
commands are returned it should signal the higher layer (block or
whatever) that the device is offlined.  Sounds like about an afternoons
worth of work to me and should solve the issues you are bringing up.

As far as plugging back in, the answer is simple.  Until the old instance 
is dead *and removed* a new one can't be added at the same ID, aka you 
simply ignore the hot plug until the hot remove has completed.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
