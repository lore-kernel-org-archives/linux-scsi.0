From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for v3.19, v2] Avoid that sd_shutdown() triggers a kernel
 warning
Date: Wed, 14 Jan 2015 01:33:02 -0800
Message-ID: <20150114093302.GA17532@infradead.org>
References: <20150108131508.GA31022@infradead.org>
 <Pine.LNX.4.44L0.1501121116220.1707-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1501121116220.1707-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 12, 2015 at 11:29:15AM -0500, Alan Stern wrote:
> This seems like a good idea and the obvious (once it has been pointed 
> out!) approach.
> 
> Perhaps not directly related to the issue at hand is this question: In
> scsi_rescan_device() we will now have:
> 
> 	mutex_lock(&shost->scan_mutex);
> 	if (dev->driver && try_module_get(dev->driver->owner)) {
> 		struct scsi_driver *drv = to_scsi_driver(dev->driver);
> 
> 		if (drv->rescan)
> 			drv->rescan(dev);
> 		module_put(dev->driver->owner);
> 	}
> 	mutex_unlock(&shost->scan_mutex);
> 
> What prevents the device from being unbound from its driver while the
> rescan runs?  Evaluating the argument to the module_put() would then
> dereference a NULL pointer.
> 
> Unbind events that happen through the normal scsi_remove_host() 
> mechanism are fine, because scsi_remove_host() locks the scan_mutex.  
> But what about writes to the driver's sysfs "unbind" attribute?

Looks like we should still get an unconditional reference to
the device using get_device in scsi_rescan_device at least.

But this seems like a more generic problem, and at least a quick glance at
the pci_driver methods seems like others don't have a good
synchroniation of ->remove against random driver methods.
