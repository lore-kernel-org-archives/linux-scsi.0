From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 8 Aug 2005 18:36:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0508081818131.4470-100000@iolanthe.rowland.org>
References: <20050808213601.GC22773@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:21169 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932306AbVHHWgV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 18:36:21 -0400
In-Reply-To: <20050808213601.GC22773@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Luben Tuikov <luben_tuikov@adaptec.com>

On Mon, 8 Aug 2005, Stefan Richter wrote:

> > Here you are wrong.  In fact the core makes no such guarantees.  It _will_
> > try to enter the host (for things like telling disk drives to flush
> > their caches) for as long as it retains a reference to the host structure.
> 
> Sure. But after all high-level drivers were detached (and that should
> have happend right before scsi_remove_host returns) I don't see why  
> the host's ref count might not be down to zero.

There might still be outstanding references: processes holding files open, 
that sort of thing.  It happens all the time in refcounting systems.


On Mon, 8 Aug 2005, Mike Anderson wrote:

> Well post scsi_remove_host returning no commands can be sent through the
> LLDD's queuecommand. There is still the issue you previously mentioned
> about a possible race of the scsi error handler and a call to
> scsi_remove_host.

Yes, and there's other pathway too: the procfs interface.


> In USB is a driver controlling more than one host instance. As I believe
> the suggestion that James indicated as a possible addition would be at per
> host instance granularity and your solution below looks like a
> notification once all instances controlled by a driver are gone.

That's right.  They are not the same thing.

> > --- usb-2.6.orig/drivers/scsi/hosts.c
> > +++ usb-2.6/drivers/scsi/hosts.c
> > @@ -205,6 +205,9 @@ int scsi_add_host(struct Scsi_Host *shos
> >  		goto out_destroy_host;
> >  
> >  	scsi_proc_host_add(shost);
> > +	shost->parent_driver = dev->driver;
> > +	if (shost->parent_driver)
> > +		get_driver(shost->parent_driver);
> 
> Just a nit, for a general case solution dev can be null for drivers who live on a
> bus that is not converted to the driver model and may not have a parent.

Okay, so the patch needs to test for (dev != NULL) before making the 
assignment.  The idea is still sound.


> > So here's how things end up.
> > 
> > 	The scanning thread owns shost->scan_mutex and is waiting
> > 	for the error handler to finish.
> > 
> > 	The EH thread is executing usb-storage's bus_reset routine
> > 	and is waiting to acquire the device semaphore.
> > 
> > 	USB's khubd thread owns the device semaphore and has invoked
> > 	the usb-storage disconnect routine.  Among other things, this
> > 	routine calls scsi_remove_host, which tries to acquire the
> > 	scan_mutex.
> > 
> > How should this deadlock be resolved?  The current code has an extremely 
> > inelegant solution, and I would like to find a better one.  Any ideas?
> > 
> > Alan Stern
> > 
> 
> I do not mean to push everything down into the LLDD, but in this case it
> is unclear what type of protection the scsi mid layer could add to protect
> against unknown future events while scanning. Is the current inelegant
> solution in the usb storage driver using some form of state model. It
> would appear that if it is not that a state model that uses a spin lock or
> something other than device semaphore to determine a disconnect was
> happening during a reset or vis-versa would be a good idea.

On Mon, 8 Aug 2005, Stefan Richter wrote:

> Can't the eh_*_reset_handler use down_*_trylock? If the semaphore was
> already down, there should be a means for the reset handler to figure
> out the reason so that it can back out in an appropriate way. I hope 
> there is a limited set of reasons...

To answer both of you at once...  The current code does use
down_*_trylock, and it does check the device state for
disconnect-in-progress.  If things don't work out, it sleeps for a short
while and then tries again.  Like I said, it's inelegant.

The underlying problem is that as things stand, the natural order of
locking is device semaphore first, scan_mutex second -- that's what
happens during a disconnect.  (It's also what would happen during a probe,
if we performed device scanning from the probe routine.)  But when the
error handler tries to do a bus reset during scanning, the locking order
is reversed.  It's a hard problem.  The only reason I've kept the current
code is because USB port resets occur very infrequently.

Alan Stern

