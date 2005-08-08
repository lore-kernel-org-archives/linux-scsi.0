From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 8 Aug 2005 16:41:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0508081517000.4454-100000@iolanthe.rowland.org>
References: <42F687EA.2020601@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54744 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932164AbVHHUlD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 16:41:03 -0400
In-Reply-To: <42F687EA.2020601@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Luben Tuikov <luben_tuikov@adaptec.com>, Mike Anderson <andmike@us.ibm.com>

On Mon, 8 Aug 2005, Stefan Richter wrote:

> Alan Stern wrote:
> > Anyhow, I'm not so concerned about releasing resources associated with the
> > host.  The LLD can handle that easily enough by first flagging the HBA
> > as not accessible, then waiting for current I/O to terminate, then
> > calling scsi_remove_host.  The resources can be released any time after
> > the current I/O is finished; it doesn't matter whether the host is removed
> > before or after.
> 
> What do you mean by "flagging the HBA as not accessible"?

I mean: setting a flag in the LLD's private data structure so that the LLD 
will know to immediately fail all future calls to queuecommand, 
device_reset, bus_reset, etc.

> Why should the LLD care if the core might want to access it after the
> LLD made the prescribed API calls for host removal? It is the core's
> responsibility that it never enters the host again after these API
> calls were invoked.

Here you are wrong.  In fact the core makes no such guarantees.  It _will_
try to enter the host (for things like telling disk drives to flush
their caches) for as long as it retains a reference to the host structure.


On Sun, 7 Aug 2005, James Bottomley wrote:

> > The only resource that matters for this discussion is associated with the
> > LLD itself, not with any of its hosts: the host template.  Once the SCSI 
> > core has released all references to the template, it can't call the LLD  
> > any more.  The problem is that the LLD has no way to know when all the   
> > references have been dropped.  This suggests that the entire problem could
> > be solved by adding a kref to struct scsi_host_template.
> > 
> > Would you agree to a patch adding such a kref?
> 
> Well, not really.  The host template usually exists as a variable in the
> module, so its lifetime is tied to the lifetime of the module.  Adding a
> kref wouldn't help because it will still be freed when the module is
> removed.  If there's a case where the template is being freed
> prematurely because the module is being removed, then we have the module
> refcounting wrong somewhere.  Have you run across such a case?

I tried to provoke such a case, but failed.  Evidently I've been barking
up the wrong tree.  Normally the SCSI core doesn't call the LLD unless
some process has opened a device file for something on that host.  This
will automatically do try_module_get on the LLD, making it impossible for
the LLD to be removed from memory.

I'm not certain this reasoning is 100% reliable, though -- does it cover
_every_ case where the core calls the LLD?  Maybe something like this 
little patch would be a good idea:

Index: usb-2.6/include/scsi/scsi_host.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_host.h
+++ usb-2.6/include/scsi/scsi_host.h
@@ -461,6 +461,7 @@ struct Scsi_Host {
 	spinlock_t		default_lock;
 	spinlock_t		*host_lock;
 
+	struct device_driver	*parent_driver;
 	struct semaphore	scan_mutex;/* serialize scanning activity */
 
 	struct list_head	eh_cmd_q;
Index: usb-2.6/drivers/scsi/hosts.c
===================================================================
--- usb-2.6.orig/drivers/scsi/hosts.c
+++ usb-2.6/drivers/scsi/hosts.c
@@ -205,6 +205,9 @@ int scsi_add_host(struct Scsi_Host *shos
 		goto out_destroy_host;
 
 	scsi_proc_host_add(shost);
+	shost->parent_driver = dev->driver;
+	if (shost->parent_driver)
+		get_driver(shost->parent_driver);
 	return error;
 
  out_destroy_host:
@@ -244,6 +247,8 @@ static void scsi_host_dev_release(struct
 
 	if (parent)
 		put_device(parent);
+	if (shost->parent_driver)
+		put_driver(shost->parent_driver);
 	kfree(shost);
 }

But if you think this isn't needed, then okay.

There is an exceptional case: device scanning.  During scanning, there is
nothing to directly prevent the LLD from being unloaded.  There is an
indirect protection, however, because the scanning thread will own
shost->scan_mutex, and scsi_remove_host acquires the mutex before
returning.


On Mon, 8 Aug 2005, Luben Tuikov wrote:

> Hmm, I think Alan has a point.
> 
> From object point of view, who is the parent and who is the child
> when talking about LLDD/module and the host template?
> 
> The reason is that the host template could be simulated on behalf
> of the underlying transport (as is the case for USB).
> 
> So, it could be the case that the host template _should_ be
> removed but the entity which removed it should stay, and that
> entity wants to know when the host template is to be removed.

I don't think things are quite this bad.  Host templates are static data
(normally) and they remain available as long as the LLD is present in
memory.  In fact, I've been using the template as kind of a surrogate,
standing for all of the LLD's module -- so long as one is present, so is
the other.


I still have one related question.  This is a little bit off to one 
side, but maybe you folks can suggest possible solutions.  The question 
concerns a deadlock I _was_ able to generate earlier today with a patched
usb-storage.

My USB mass-storage test device doesn't respond to TEST UNIT READY, so it
causes a timeout and kicks the error handler into action.  This happens 
during device scanning, just prior to reading the partition table.  The 
error handler goes through various stages of processing, leading up to a 
bus reset.  I disconnected the USB device just before the bus reset 
routine was called.

Now, usb-storage implements a "SCSI bus reset" by actually performing a
USB port reset.  The USB subsystem requires the caller to acquire a
device-specific semaphore before doing a port reset, and the subsystem
itself acquires this same semaphore when notifying drivers about a
disconnection.  (The idea is that we don't want drivers trying to handle
a disconnect and a reset on the same device at the same time.)

So here's how things end up.

	The scanning thread owns shost->scan_mutex and is waiting
	for the error handler to finish.

	The EH thread is executing usb-storage's bus_reset routine
	and is waiting to acquire the device semaphore.

	USB's khubd thread owns the device semaphore and has invoked
	the usb-storage disconnect routine.  Among other things, this
	routine calls scsi_remove_host, which tries to acquire the
	scan_mutex.

How should this deadlock be resolved?  The current code has an extremely 
inelegant solution, and I would like to find a better one.  Any ideas?

Alan Stern

