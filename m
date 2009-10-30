From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: unconditional discard calls in the swap code
Date: Fri, 30 Oct 2009 17:26:18 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0910301629030.4106@sister.anvils>
References: <20091030065102.GA2896@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:44570 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932571AbZJ3R0U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2009 13:26:20 -0400
In-Reply-To: <20091030065102.GA2896@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Matthew Wilcox <matthew@wil.cx>, linux-mm@kvack.org, linux-scsi@vger.kernel.org

Hi Christoph,

(I've added Ccs, hoping for more expertise than we have in linux-mm.)

On Fri, 30 Oct 2009, Christoph Hellwig wrote:
> 
> since 6a6ba83175c029c7820765bae44692266b29e67a the swap code
> unconditionally calls blkdev_issue_discard when swap clusters get freed.
> So far this was harmless because only the mtd driver has discard support
> wired up and it's pretty fast there (entirely done in-kernel).
> 
> We're now adding support for real UNMAP/TRIM support for SCSI arrays and
> SSDs, and so far all the real life ones we've dealt with have too many
> performance issues to just issue the discard requests on the fly.
> Because of that unconditionally enabling this code is a bad idea, it
> really needs an option to disable it or even better just leave it
> disabled by default for now with an option to enable it.

Thanks for the info.

Yes, in practice TRIM seems a huge disappointment: is there a device on
which it is really implemented, and not more trouble than it's worth?

I'd been waiting for OCZ to get a Vertex 1.4* firmware out of Beta
before looking at swap discard again; but even then, the Linux ATA
support is still up in the air, so far as I know.

You don't mention swap's discard of the whole partition (or all
extents of the swapfile) at swapon time: do you believe that usage
is okay to retain?  Is it likely on some devices to take so long,
that I ought to make it asynchronous?

Assuming that initial swap discard is good, I wonder whether just
to revert the discard of swap clusters for now: until such time as
we find devices (other than mtd) that can implement it efficiently.

If we do retain the discard of swap clusters, under something more
than an #if 0, any ideas for what I should make it conditional upon?

Something near /sys/block/sda/queue/rotational (nicely rw these days)
seems appropriate: any chance of a /sys/block/sda/queue/discard_is_useful?
I think I'd prefer that to a new option to swapon.

Or is there a sensible measurement I could make in swapfile.c: for
example, does discard of a range complete faster than write of the
same range?  (But my guess is that those devices we'd want to avoid
discard on, would give erratic answers to any such test; never mind
the noise of what other I/Os are concurrent to the same device.)

Something I should almost certainly revert: at one stage I made the
non-rotational case spread its swapping evenly over the partition,
in case the device's wear-levelling was inadequate (localized).

But now I think it's better to ignore that possibility, and anchor
swapping to the start of the partition just as in the rotational case:
in the rotational case it's done to minimize seeking, in the non-
rotational case it would be to minimize encroaching upon that
initially discarded total extent.

Hugh
