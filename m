From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 23 Jan 2003 21:59:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301232159.28656.oliver@neukum.name>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232040.41862.oliver@neukum.name> <20030123202835.GA25838@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030123202835.GA25838@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Hi Doug

> Actually, I would have both complicated and simple transports call
> scsi_set_device_offline() and for two reasons.  1) you have to provide
> that function for simple drivers so duplicating other detection code in
> the scsi completion handler is a waste.  2) pretty much all transports
> will learn of the device being offline while they are in their interrupt
> handler and should already be holding the lock for the device, which means

This is not the case for USB and IEEE1394. I am not sure about PCMCIA.
We are in context of a kernel thread while we learn about device removal.

> that calling scsi_set_device_offline() won't race with scsi_request_fn()
> which also needs the device lock (which in reality is the host lock).
> Saving this race is convenient enough IMHO to warrant saying that's the
> way things need to be.
>
> > > scsi_set_device_offline(dev) calls a high-level kernel function to
> > > start higher level things (block queue cut off, etc) which *may* need
> > > to be done.
>
> No, scsi_set_device_offline() schedules the error handler thread for that
> host to be woken up.
>
> > How do you differentiate between real failure and device removal?
>
> We don't, and we shouldn't.  Device removal *is* a real failure.

Well shouldn't a device removal remove the device as a logical
entity and a failure should not?

> If the LLDD is the type such that it knows the device is gone (aka, in my
> driver if I get a selection timeout then I know something is fishy and can
> proceed from there, iSCSI may not be so lucky), then it has one of two
> choices.  1) it may flush any commands that it can out of the hardware and
> return them immediately with the same error condition as the one that it
> is already returning.  2) it can sit and wait for the commands to timeout
> one by one if that's what it wants.  Since the device has already been
> marked offline by scsi_set_device_offline() and the error handler thread
> is already scheduled to run for the device, 2 is probably the easiest
> thing for the driver to do.  The error handler will call the abort/reset

Again not for USB and IEEE1394. We'd have to wait for the error handler
to finish. Doing it ourselves is easier.

> Once all the commands are gone and no more are arriving, then if, and only
> if, someone actually removes the device from the scsi subsystem (maybe
> hotplug manager or something) then you will get the typical
> slave_destroy() call to tell you that it is safe to release all resources
> related to this device.  Otherwise, the device will hang around as an
> offline device until someone does echo "scsi-remove-single-device a b c d"

Eek. That part I must strongly object to. The device is physically gone.
Ever bothering the LLDD with it is very inconvinient.

> > /proc/scsi/scsi to remove it.
>
> Basically, as I see it, we need a new function scsi_set_device_offline()
> that marks the device offline, we need an offline check in

These functions are needed for a whole bus as well. USB needs it.

> As far as plugging back in, the answer is simple.  Until the old instance
> is dead *and removed* a new one can't be added at the same ID, aka you
> simply ignore the hot plug until the hot remove has completed.

What do you mean? It is dead because it is removed. How can a device be
anything than dead if it has been unplugged? Please elaborate.

And who should ignore a hot addition, the LLDD or SCSI core.
If the former, again I must object.

	Regards
		Oliver

