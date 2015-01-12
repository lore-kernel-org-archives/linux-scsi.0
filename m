From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH for v3.19, v2] Avoid that sd_shutdown() triggers a kernel
 warning
Date: Mon, 12 Jan 2015 11:29:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1501121116220.1707-100000@iolanthe.rowland.org>
References: <20150108131508.GA31022@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41568 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751999AbbALQ3Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2015 11:29:16 -0500
In-Reply-To: <20150108131508.GA31022@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 8 Jan 2015, Christoph Hellwig wrote:

> On Wed, Jan 07, 2015 at 02:03:22PM +0100, Bart Van Assche wrote:
> > Since kernel v3.19-rc1 module_refcount() returns 1 instead of 0
> > when called from inside module_exit(). This breaks the
> > module_refcount() test in scsi_device_put() and hence causes the
> > following kernel warning to be reported when unloading the ib_srp
> > kernel module:
> 
> This is getting better, but I still think we need to sort out the root
> cause.
> 
> The problemt started with commit 39b7f1e25 ("[SCSI] sd: Fix refcounting"),
> which added the calls to scsi_device_get in various struct
> device_driver/scsi_driver methods.  From the BZ it seems like the
> rationale was to protect against races between ->rescan and ->remove,
> but instead of doing that using refcounting we better ensure that
> in the SCSI midlayer by taking scan_mutex around calls to ->rescan.
> The first attached patch does that, which allows us to functionally
> revert 39b7f1e25, which then also allows to revert 85b6c720
> ("[SCSI] sd: fix cache flushing on module removal (and individual
> device removal)").
> 
> See the attached series to do that.  Warnings: so far it only got
> minimal testing.

This seems like a good idea and the obvious (once it has been pointed 
out!) approach.

Perhaps not directly related to the issue at hand is this question: In
scsi_rescan_device() we will now have:

	mutex_lock(&shost->scan_mutex);
	if (dev->driver && try_module_get(dev->driver->owner)) {
		struct scsi_driver *drv = to_scsi_driver(dev->driver);

		if (drv->rescan)
			drv->rescan(dev);
		module_put(dev->driver->owner);
	}
	mutex_unlock(&shost->scan_mutex);

What prevents the device from being unbound from its driver while the
rescan runs?  Evaluating the argument to the module_put() would then
dereference a NULL pointer.

Unbind events that happen through the normal scsi_remove_host() 
mechanism are fine, because scsi_remove_host() locks the scan_mutex.  
But what about writes to the driver's sysfs "unbind" attribute?

Alan Stern

