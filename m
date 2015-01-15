From: Tejun Heo <tj@kernel.org>
Subject: Re: sysfs methods can race with ->remove
Date: Thu, 15 Jan 2015 14:40:31 -0500
Message-ID: <20150115194031.GE28195@htj.dyndns.org>
References: <20150115160612.GA31446@infradead.org>
 <Pine.LNX.4.44L0.1501151255060.1064-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1501151255060.1064-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello, Alan.

On Thu, Jan 15, 2015 at 01:22:03PM -0500, Alan Stern wrote:
> > It has a reference to keep it from beeing freed, but so far I can't find
> > anything that prevents ->remove from beeing called while we are in or
> > just before a method call.
> 
> There are two types of methods to think about: Those registered by the 
> subsystem and those registered by the driver.
> 
> If a method is registered by the driver, then the driver will
> unregister it when the ->remove routine runs.  I don't know for
> certain, but I would expect that the sysfs/kernfs core will make sure
> that any existing method calls complete before unregister returns.  
> This would prevent races.

Yes, attribute deletions are blocked till the on-going sysfs
read/write operations are finished and further rw accesses are failed.

> If a method is registered by the subsystem, and if the method runs 
> entirely within the subsystem's code, then ->remove doesn't matter.  
> The driver could be unbound while the method is running and it would be 
> okay.
> 
> The only time we have a problem is when the method is registered by the 
> subsystem and the method calls into the driver.  (Note that this is 
> exactly what happens with scsi_rescan_device.)
> 
> > > > But this seems like a more generic problem, and at least a quick glance at
> > > > the pci_driver methods seems like others don't have a good
> > > > synchroniation of ->remove against random driver methods.
> > > 
> > > Can you give one or two examples?
> > 
> > I look at the sriov_configure PCI method, or the various sub-methods
> > under pci_driver.err_handler.
> 
> The sriov_numvfs_store method does have the same problem, and so does 
> the reset_store method (by way of pci_reset_function -> 
> pci_dev_save_and_disable -> pci_reset_notify).
> 
> Tejun, is my analysis correct?  How should we fix these races?

I'm not really following what the actual problem case is, so SCSI
subsystem store methods are derefing dev->driver without synchronizing
against detach events?  If that's the case, the solution would be
synchronizing against attach/detach events?  Sorry if I'm being
totally idiotic.  I'm having a bit of hard time jumping right in.  :)

Thanks.

-- 
tejun
