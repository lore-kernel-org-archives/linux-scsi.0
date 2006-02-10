From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: SCSI BLIST_*, sdev_bflags, and scsi_device flags
Date: Fri, 10 Feb 2006 10:58:29 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602101050140.5227-100000@iolanthe.rowland.org>
References: <20060210153046.GC12822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:23425 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932153AbWBJP6a
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 10:58:30 -0500
In-Reply-To: <20060210153046.GC12822@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 10 Feb 2006, Matthew Wilcox wrote:

> On Fri, Feb 10, 2006 at 10:27:21AM -0500, Alan Stern wrote:
> > On Fri, 10 Feb 2006, Christoph Hellwig wrote:
> > > Do we need per-device blist flags at all?  I suspect just having them in
> > > the target should be enough.
> > 
> > Some of the blist flags clearly are per-device: BLIST_KEY, BLIST_ISROM,
> > BLIST_NOSTARTONADD, BLIST_MS_SKIP_PAGE_08, BLIST_MS_SKIP_PAGE_3F,
> > BLIST_USE_10_BYTE_MS, BLIST_MS_192_BYTES_FOR_3F, BLIST_NOT_LOCKABLE,
> > BLIST_NO_ULD_ATTACH, BLIST_RETRY_HWERROR.  There are a few others I'm not
> > certain about.
> 
> Why are these clearly per LUN?  I agree some of them are debatable,
> but most of them indicate a general lack-of-scsi-spec compliance on the
> part of the manufacturer and hence apply to the piece of hardware (==
> scsi target) rather than just one of the LUNs in it.

Isn't is possible for a target to contain LUNs made by different 
manufacturers, each with its own kind of lack-of-compliance?

Or to put it another way...  Somewhere the SCSI commands have to be 
decoded and carried out.  With some devices that may be done at the target 
level, and with others it may be done at the LUN level.  So any BLIST flag 
that affects which commands get used should be per-LUN, for greatest 
generality.

For that matter, consider BLIST_ISROM (which means that the device is a 
cdrom).  Obviously that applies to a LUN and not to a target; there's no 
requirement that all the logical units in a target be the same kind of 
device.

Alan Stern

