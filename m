From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fw: 2.6.6-rc3 ia64 smp_call_function() called with interrupts disabled
Date: Tue, 4 May 2004 10:41:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040504104143.A21207@infradead.org>
References: <20040502214525.5ad05bed.akpm@osdl.org> <20040503122948.GI2281@parcelfarce.linux.theplanet.co.uk> <20040503203512.GP2281@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:39693 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264278AbUEDJlq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2004 05:41:46 -0400
Content-Disposition: inline
In-Reply-To: <20040503203512.GP2281@parcelfarce.linux.theplanet.co.uk>; from willy@debian.org on Mon, May 03, 2004 at 09:35:13PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, kaos@sgi.com, linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org

On Mon, May 03, 2004 at 09:35:13PM +0100, Matthew Wilcox wrote:
> That patch is crap -- it only frees the memory on the error path, not
> the normal exit.  Since I got confused by this function, it struck me
> as not unreasonable that somebody else might also get confused by it
> and split it into two parts.
> 
> I simplified some of the code.  The old code took the lock, scanned
> through looking for a free slot, dropped the lock, allocated an sdp,
> grabbed the lock and checked the slot was still free, branching back
> if it had raced.  This rewrite assumes that we will find a slot and
> allocates an sdp in advance.
> 
> Does anybody like this patch?  It survived booting on my test box which
> only has one scsi device.  More testing welcomed.

Better than what was there, but I still don't like it.  A global array
of devices is just utter crap.  Every entry point from scsi already has
struct scsi_device from which we can derive the sg-specific portion easily,
and for anything else (from a quick look that seems to be only procfs
stuff which should fade out anyway) a linear search on a linked list
is okay.

btw, why are we vmalloc()ing Sg_device?
