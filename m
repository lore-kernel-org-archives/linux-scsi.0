From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for v3.19, v2] Avoid that sd_shutdown() triggers a kernel
 warning
Date: Thu, 15 Jan 2015 08:06:12 -0800
Message-ID: <20150115160612.GA31446@infradead.org>
References: <20150114093302.GA17532@infradead.org>
 <Pine.LNX.4.44L0.1501141002500.1464-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1501141002500.1464-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 14, 2015 at 10:07:00AM -0500, Alan Stern wrote:
> and the kernfs core insures that the underlying device won't be 
> deallocated while a sysfs method runs.

It has a reference to keep it from beeing freed, but so far I can't find
anything that prevents ->remove from beeing called while we are in or
just before a method call.

> > But this seems like a more generic problem, and at least a quick glance at
> > the pci_driver methods seems like others don't have a good
> > synchroniation of ->remove against random driver methods.
> 
> Can you give one or two examples?

I look at the sriov_configure PCI method, or the various sub-methods
under pci_driver.err_handler.
