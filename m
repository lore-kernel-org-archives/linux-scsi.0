From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 8 Aug 2005 14:36:01 -0700
Message-ID: <20050808213601.GC22773@us.ibm.com>
References: <42F687EA.2020601@s5r6.in-berlin.de> <Pine.LNX.4.44L0.0508081517000.4454-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37554 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932219AbVHHVgu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2005 17:36:50 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j78Lan6f018938
	for <linux-scsi@vger.kernel.org>; Mon, 8 Aug 2005 17:36:49 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j78LaYWw225468
	for <linux-scsi@vger.kernel.org>; Mon, 8 Aug 2005 17:36:49 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j78LaXAg002054
	for <linux-scsi@vger.kernel.org>; Mon, 8 Aug 2005 17:36:33 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0508081517000.4454-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Luben Tuikov <luben_tuikov@adaptec.com>

Alan Stern <stern@rowland.harvard.edu> wrote:
> Here you are wrong.  In fact the core makes no such guarantees.  It _will_
> try to enter the host (for things like telling disk drives to flush
> their caches) for as long as it retains a reference to the host structure.

Well post scsi_remove_host returning no commands can be sent through the
LLDD's queuecommand. There is still the issue you previously mentioned
about a possible race of the scsi error handler and a call to
scsi_remove_host.


> I tried to provoke such a case, but failed.  Evidently I've been barking
> up the wrong tree.  Normally the SCSI core doesn't call the LLD unless
> some process has opened a device file for something on that host.  This
> will automatically do try_module_get on the LLD, making it impossible for
> the LLD to be removed from memory.
> 
> I'm not certain this reasoning is 100% reliable, though -- does it cover
> _every_ case where the core calls the LLD?  Maybe something like this 
> little patch would be a good idea:

In USB is a driver controlling more than one host instance. As I believe
the suggestion that James indicated as a possible addition would be at per
host instance granularity and your solution below looks like a
notification once all instances controlled by a driver are gone.

> --- usb-2.6.orig/drivers/scsi/hosts.c
> +++ usb-2.6/drivers/scsi/hosts.c
> @@ -205,6 +205,9 @@ int scsi_add_host(struct Scsi_Host *shos
>  		goto out_destroy_host;
>  
>  	scsi_proc_host_add(shost);
> +	shost->parent_driver = dev->driver;
> +	if (shost->parent_driver)
> +		get_driver(shost->parent_driver);

Just a nit, for a general case solution dev can be null for drivers who live on a
bus that is not converted to the driver model and may not have a parent.

> But if you think this isn't needed, then okay.
> 
> There is an exceptional case: device scanning.  During scanning, there is
> nothing to directly prevent the LLD from being unloaded.  There is an
> indirect protection, however, because the scanning thread will own
> shost->scan_mutex, and scsi_remove_host acquires the mutex before
> returning.

I think in the past someone has indicated that we really should be getting
refs during scanning to hold things in place. I guess as you note above
and below scan_mutex is holding things in place.


> memory.  In fact, I've been using the template as kind of a surrogate,
> standing for all of the LLD's module -- so long as one is present, so is
> the other.
> 
> 
> I still have one related question.  This is a little bit off to one 
> side, but maybe you folks can suggest possible solutions.  The question 
> concerns a deadlock I _was_ able to generate earlier today with a patched
> usb-storage.
> 
> My USB mass-storage test device doesn't respond to TEST UNIT READY, so it
> causes a timeout and kicks the error handler into action.  This happens 
> during device scanning, just prior to reading the partition table.  The 
> error handler goes through various stages of processing, leading up to a 
> bus reset.  I disconnected the USB device just before the bus reset 
> routine was called.
> 
> Now, usb-storage implements a "SCSI bus reset" by actually performing a
> USB port reset.  The USB subsystem requires the caller to acquire a
> device-specific semaphore before doing a port reset, and the subsystem
> itself acquires this same semaphore when notifying drivers about a
> disconnection.  (The idea is that we don't want drivers trying to handle
> a disconnect and a reset on the same device at the same time.)
> 
> So here's how things end up.
> 
> 	The scanning thread owns shost->scan_mutex and is waiting
> 	for the error handler to finish.
> 
> 	The EH thread is executing usb-storage's bus_reset routine
> 	and is waiting to acquire the device semaphore.
> 
> 	USB's khubd thread owns the device semaphore and has invoked
> 	the usb-storage disconnect routine.  Among other things, this
> 	routine calls scsi_remove_host, which tries to acquire the
> 	scan_mutex.
> 
> How should this deadlock be resolved?  The current code has an extremely 
> inelegant solution, and I would like to find a better one.  Any ideas?
> 
> Alan Stern
> 

I do not mean to push everything down into the LLDD, but in this case it
is unclear what type of protection the scsi mid layer could add to protect
against unknown future events while scanning. Is the current inelegant
solution in the usb storage driver using some form of state model. It
would appear that if it is not that a state model that uses a spin lock or
something other than device semaphore to determine a disconnect was
happening during a reset or vis-versa would be a good idea.

-andmike
--
Michael Anderson
andmike@us.ibm.com
