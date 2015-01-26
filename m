From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sysfs methods can race with ->remove
Date: Mon, 26 Jan 2015 13:38:23 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1501261335000.1257-100000@iolanthe.rowland.org>
References: <20150126171950.GA9015@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47844 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753313AbbAZSiY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2015 13:38:24 -0500
In-Reply-To: <20150126171950.GA9015@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kernel development list <linux-kernel@vger.kernel.org>

On Mon, 26 Jan 2015, Christoph Hellwig wrote:

> On Thu, Jan 15, 2015 at 02:40:31PM -0500, Tejun Heo wrote:
> > > If a method is registered by the driver, then the driver will
> > > unregister it when the ->remove routine runs.  I don't know for
> > > certain, but I would expect that the sysfs/kernfs core will make sure
> > > that any existing method calls complete before unregister returns.  
> > > This would prevent races.
> > 
> > Yes, attribute deletions are blocked till the on-going sysfs
> > read/write operations are finished and further rw accesses are failed.
> 
> Btw, where do we do that?  I did a walk through the code starting
> from device_del, but must have missed the obvious.

It happens in fs/kernfs/dir.c:kernfs_drain().  That routine is called 
when a sysfs file is removed, and it waits until all ongoing read/write 
operations are finished.

> > > The sriov_numvfs_store method does have the same problem, and so does 
> > > the reset_store method (by way of pci_reset_function -> 
> > > pci_dev_save_and_disable -> pci_reset_notify).
> > > 
> > > Tejun, is my analysis correct?  How should we fix these races?
> > 
> > I'm not really following what the actual problem case is, so SCSI
> > subsystem store methods are derefing dev->driver without synchronizing
> > against detach events?  If that's the case, the solution would be
> > synchronizing against attach/detach events?  Sorry if I'm being
> > totally idiotic.  I'm having a bit of hard time jumping right in.  :)
> 
> No problem.  That's the basic situation we are talking about.  I have
> a serie fixing some long standing issues in the device model integration
> in SCSI, and pointed out a possible issue in that area.
> 
> So what is the proper lock to take to prevent ->remove from beeing
> called while in such a method?  A mentioned about I tried to peel
> through all the layers of the onion^H^H^H^H^Hdriver core, but so far
> couldn't find anything obvious.

The proper lock is dev->mutex, as I mentioned in an earlier email 
(http://marc.info/?l=linux-scsi&m=142176669519982&w=2).  That lock is 
held whenever a ->remove method is called.

Alan Stern

