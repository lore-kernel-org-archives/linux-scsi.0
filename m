From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: max_hw_segments vs. max_phys_segments and scsi_alloc_queue()
Date: 26 Feb 2004 09:02:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077807779.1756.9.camel@mulgrave>
References: <20040226071558.GA559837@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:49899 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261854AbUBZPDU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2004 10:03:20 -0500
In-Reply-To: <20040226071558.GA559837@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, jbarnes@cthulhu.engr.sgi.com

On Thu, 2004-02-26 at 01:15, Jeremy Higdon wrote:
> That is, max_hw_segments is the number of discrete segments that
> a PCI device would see, while max_phys_segments would be the
> max s/g list size that a PCI device could handle.

No, max_hw_segments is the maximum size of the PCI device's sg table. 
max_hw_segments is the size of the internal sg list before dma_map_sg()
gets its paws on it.  The only parameter the drivers care about is
max_hw_segments.  It's the mid-layer that cares about the
max_phys_segments because the mid-layer provides the memory for the sg
list that comes out of blk_rq_map_sg()

> It further seems as though when there is no IOMMU that the number
> of hw_segments will equal the number of phys_segments, at least if I
> understand the code in blk_recount_segments() and the comments
> around the definition of BIO_VMERGE_BOUNDARY in
> include/asm-ia64/io.h.

That's correct.  No virtual merging => max_phys_segments ==
max_hw_segments.

> In particular, on ia64 machines, where BIO_VMERGE_BOUNDARY is
> currently 0, and thus, the number of hw_segments equals the number
> of phys_segments, we should be using the host's sg_tablesize to
> set the max number of phys segments (as well as the max number
> of hw segments).  I see no reason why this wouldn't carry forward
> to the other architectures, though there may be limits to the
> total amount of data that could be mapped.  This would have to
> be fed to the block layer from the arch layer, though, I think.
> 
> Does this make sense, or have I completely missed something?

No, you can't do this (or at least, not simply like your patch).

Like I said, the mid-layer has to allocate the sg table coming out of
blk_rq_map_sg().  It does this in scsi_alloc_sgtable() using mempools,
and the maximum sg table size it's expecting is MAX_PHYS_SEGMENTS.  If
you increase max_phys_segments beyond what the mid-layer can cope with,
you'll end up with a request we can never map.

We'd have to rejig the entire mempool setup to increase this (even
though it looks like it's nicely coded to be variable for
MAX_PHYS_SEGMENTS, in fact, the mempools are coded assuming that the
value is 128).

James


