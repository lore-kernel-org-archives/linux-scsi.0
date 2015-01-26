From: Christoph Hellwig <hch@infradead.org>
Subject: Re: sysfs methods can race with ->remove
Date: Mon, 26 Jan 2015 09:19:50 -0800
Message-ID: <20150126171950.GA9015@infradead.org>
References: <20150115160612.GA31446@infradead.org>
 <Pine.LNX.4.44L0.1501151255060.1064-100000@iolanthe.rowland.org>
 <20150115194031.GE28195@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150115194031.GE28195@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 15, 2015 at 02:40:31PM -0500, Tejun Heo wrote:
> > If a method is registered by the driver, then the driver will
> > unregister it when the ->remove routine runs.  I don't know for
> > certain, but I would expect that the sysfs/kernfs core will make sure
> > that any existing method calls complete before unregister returns.  
> > This would prevent races.
> 
> Yes, attribute deletions are blocked till the on-going sysfs
> read/write operations are finished and further rw accesses are failed.

Btw, where do we do that?  I did a walk through the code starting
from device_del, but must have missed the obvious.

> > The sriov_numvfs_store method does have the same problem, and so does 
> > the reset_store method (by way of pci_reset_function -> 
> > pci_dev_save_and_disable -> pci_reset_notify).
> > 
> > Tejun, is my analysis correct?  How should we fix these races?
> 
> I'm not really following what the actual problem case is, so SCSI
> subsystem store methods are derefing dev->driver without synchronizing
> against detach events?  If that's the case, the solution would be
> synchronizing against attach/detach events?  Sorry if I'm being
> totally idiotic.  I'm having a bit of hard time jumping right in.  :)

No problem.  That's the basic situation we are talking about.  I have
a serie fixing some long standing issues in the device model integration
in SCSI, and pointed out a possible issue in that area.

So what is the proper lock to take to prevent ->remove from beeing
called while in such a method?  A mentioned about I tried to peel
through all the layers of the onion^H^H^H^H^Hdriver core, but so far
couldn't find anything obvious.
