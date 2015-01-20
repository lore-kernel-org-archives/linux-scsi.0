From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH for v3.19, v2] Avoid that sd_shutdown() triggers a kernel
 warning
Date: Tue, 20 Jan 2015 10:11:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1501200954330.1150-100000@iolanthe.rowland.org>
References: <20150114093302.GA17532@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150114093302.GA17532@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 14 Jan 2015, Christoph Hellwig wrote:

> On Mon, Jan 12, 2015 at 11:29:15AM -0500, Alan Stern wrote:
> > This seems like a good idea and the obvious (once it has been pointed 
> > out!) approach.
> > 
> > Perhaps not directly related to the issue at hand is this question: In
> > scsi_rescan_device() we will now have:
> > 
> > 	mutex_lock(&shost->scan_mutex);
> > 	if (dev->driver && try_module_get(dev->driver->owner)) {
> > 		struct scsi_driver *drv = to_scsi_driver(dev->driver);
> > 
> > 		if (drv->rescan)
> > 			drv->rescan(dev);
> > 		module_put(dev->driver->owner);
> > 	}
> > 	mutex_unlock(&shost->scan_mutex);
> > 
> > What prevents the device from being unbound from its driver while the
> > rescan runs?  Evaluating the argument to the module_put() would then
> > dereference a NULL pointer.
> > 
> > Unbind events that happen through the normal scsi_remove_host() 
> > mechanism are fine, because scsi_remove_host() locks the scan_mutex.  
> > But what about writes to the driver's sysfs "unbind" attribute?
> 
> Looks like we should still get an unconditional reference to
> the device using get_device in scsi_rescan_device at least.
> 
> But this seems like a more generic problem, and at least a quick glance at
> the pci_driver methods seems like others don't have a good
> synchroniation of ->remove against random driver methods.

This particular problem comes down to the fact that 
scsi_rescan_device() accesses dev->driver without appropriate mutual 
exclusion.  SCSI's scan_mutex won't help because it doesn't protect 
dev->driver.  Rather, dev->driver is protected by dev->mutex, and so 
scsi_rescan_device() needs to use device_lock/unlock.

This suggests that the scan_mutex may not be necessary at all.
Historically, it seems to be quite old, predating the device model.  
Now that we have the device model, maybe scan_mutex simply isn't 
needed.

Scanning for channels or targets beneath a host should be protected by
shost->gendev.mutex.  Scanning for logical units beneath a target
should be protected by starget->dev.mutex.  Scanning for partitions 
beneath a SCSI drive should be protected by sdev->sdev_gendev.mutex.

James, here's a related question.  Suppose userspace writes to the 
rescan attribute file for a disk drive for sd_probe_async() has 
started.  What will happen?  What _ought_ to happen?  Do we need to 
call

	async_synchronize_full_domain(&scsi_sd_probe_domain);

somewhere in this pathway, or will it be okay?

Alan Stern
