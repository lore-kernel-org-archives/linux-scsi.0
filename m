From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v4 00/11] scsi: fix module reference mismatch for scsi
 host
Date: Tue, 20 Jan 2015 10:20:35 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1501201013440.1150-100000@iolanthe.rowland.org>
References: <CAC5umyh+x_B3GOc4q=Q+2NsAK8KmaHvpyW329iG-d1yAUwN02A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58211 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752905AbbATPUg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2015 10:20:36 -0500
In-Reply-To: <CAC5umyh+x_B3GOc4q=Q+2NsAK8KmaHvpyW329iG-d1yAUwN02A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, Hans de Goede <hdegoede@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Robert Love <robert.w.love@intel.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, open-iscsi@googlegroups.com, fcoe-devel@open-fcoe.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Tue, 20 Jan 2015, Akinobu Mita wrote:

> 2015-01-19 23:22 GMT+09:00 Tejun Heo <tj@kernel.org>:
> > On Mon, Jan 19, 2015 at 12:05:58AM +0900, Akinobu Mita wrote:
> >> While accessing a scsi_device, the use count of the underlying LLDD
> >> module is incremented.  The module reference is retrieved through
> >> .module field of struct scsi_host_template.
> >>
> >> This mapping between scsi_device and underlying LLDD module works well
> >> except some drivers which consist with the core driver and the actual
> >> LLDDs and scsi_host_template is defined in the core driver.  In these
> >> cases, the actual LLDDs can be unloaded even if the scsi_device is
> >> being accessed.
> >>
> >> This patch series fixes the module reference mismatch problem for
> >> ufs, usb-storage, esp_scsi, ahci_platform, and pata_platform drivers
> >> by moving owner module reference field from struct scsi_host_template
> >> to struct Scsi_Host and allowing the LLDDs to set their correct module
> >> reference.
> >
> > Hmmm, can't we just move sht definitions to actual LLDDs?  libata can
> > do that easily.  sht, as its name implies, is the template for
> > creating the scsi_hosts of a given type.  We're now just moving module
> > ownership from sht definition site to whatever callsite the actual
> > instance is being created which can also be wrapped in a separate
> > layer requiring explicit propagation.  Why not just propagate sht's
> > directly?  What's the difference?
> 
> The reason I didn't move sht from the core driver to the LLDDs for
> fixing ufs and ums-* in the first place is to avoid exporting many
> symbols for callbacks in sht.  But I realized that we can do it
> without that many exported symbols by creating a single function that
> returns a kmemdup()ed sht with a few change including ->module.
> 
> So there are three options we can take for fixing this problem.
> I would like to know the opinions which one should be taken.
> 
> (1) Add owner module field to Scsi_Host for allowing LLDDs to adjust
> it after scsi host allocation.  This approach is used by v1,2,3 of
> this patch series and the scsi midlayer change is minimum.
> 
> (2) Move owner module field from scsi_host_template to Scsi_Host.
> The owner module reference is retrieved from the callsite of
> scsi_host_alloc() by passing THIS_MODULE to the extra argument.
> The scsi midlayer change is small, but we need the same macro trick
> for each scsi_host_alloc() wrapper and these changes are relatively
> large (required by libata, libiscsi, libfc, cxgbi, 53c700, legacy).
> This approach is used by v4 of this patch series.
> 
> (3) Allocate scsi host template for each module.  No scsi midlayer
> change is required.  Instead of sharing a single scsi host template
> defined in the core, create a single function that returns a
> kmemdup()ed sht with a few change including ->module so that the sub
> modules can use it as their sht.

(3) means duplicating a reasonably large data structure in order to
alter just one field.  It also means changing all the subdrivers to
make them call the new function.

(1) is the simplest.  Since the use of subdrivers in general tends to 
be a special case (most SCSI drivers don't do it), I prefer to keep the 
code optimized for it.  In other words, I prefer option (1).  If people 
think (2) is better, it can always be layered on top of (1).

Alan Stern

