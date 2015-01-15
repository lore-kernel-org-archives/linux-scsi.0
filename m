From: Alan Stern <stern@rowland.harvard.edu>
Subject: sysfs methods can race with ->remove
Date: Thu, 15 Jan 2015 13:22:03 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1501151255060.1064-100000@iolanthe.rowland.org>
References: <20150115160612.GA31446@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59356 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752198AbbAOSWF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2015 13:22:05 -0500
In-Reply-To: <20150115160612.GA31446@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kernel development list <linux-kernel@vger.kernel.org>

Tejun:

The context is that we have been talking about
drivers/scsi/scsi_scan.c:scsi_rescan_device(), which is called by the
store_rescan_field() sysfs method in scsi_sysfs.c.  The problem is
this: What happens in scsi_rescan_device if the device is unbound from
its driver before the module_put call?  The dev->driver->owner
calculation would dereference a NULL pointer.

On Thu, 15 Jan 2015, Christoph Hellwig wrote:

> On Wed, Jan 14, 2015 at 10:07:00AM -0500, Alan Stern wrote:
> > and the kernfs core insures that the underlying device won't be 
> > deallocated while a sysfs method runs.
> 
> It has a reference to keep it from beeing freed, but so far I can't find
> anything that prevents ->remove from beeing called while we are in or
> just before a method call.

There are two types of methods to think about: Those registered by the 
subsystem and those registered by the driver.

If a method is registered by the driver, then the driver will
unregister it when the ->remove routine runs.  I don't know for
certain, but I would expect that the sysfs/kernfs core will make sure
that any existing method calls complete before unregister returns.  
This would prevent races.

If a method is registered by the subsystem, and if the method runs 
entirely within the subsystem's code, then ->remove doesn't matter.  
The driver could be unbound while the method is running and it would be 
okay.

The only time we have a problem is when the method is registered by the 
subsystem and the method calls into the driver.  (Note that this is 
exactly what happens with scsi_rescan_device.)

> > > But this seems like a more generic problem, and at least a quick glance at
> > > the pci_driver methods seems like others don't have a good
> > > synchroniation of ->remove against random driver methods.
> > 
> > Can you give one or two examples?
> 
> I look at the sriov_configure PCI method, or the various sub-methods
> under pci_driver.err_handler.

The sriov_numvfs_store method does have the same problem, and so does 
the reset_store method (by way of pci_reset_function -> 
pci_dev_save_and_disable -> pci_reset_notify).

Tejun, is my analysis correct?  How should we fix these races?

Alan Stern

