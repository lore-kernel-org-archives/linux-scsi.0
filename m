From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Fri, 2 Feb 2007 13:49:56 -0600
Message-ID: <20070202194956.GF16722@waste.org>
References: <200701301947.08478.liml@rtr.ca> <1170206199.10890.13.camel@mulgrave.il.steeleye.com> <45C2474E.9030306@rtr.ca> <1170366920.3388.62.camel@mulgrave.il.steeleye.com> <45C32C7F.9050706@emc.com> <20070202145003.525bd682@localhost.localdomain> <45C3617B.2020400@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1946039AbXBBUCt@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45C3617B.2020400@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Ric Wheeler <ric@emc.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 02, 2007 at 11:06:19AM -0500, Mark Lord wrote:
> Alan wrote:
> >
> >If this is the right strategy for disk recovery for a given type of
> >device then this ought to be an automatic strategy. Most end users will
> >not have the knowledge to frob about in sysfs, and if the bad sector hits
> >at the wrong moment a sensible automatic recovery strategy is going to do
> >the right thing faster than human intervention, which may be some hours
> >away.
> 
> I think something we seem to be discussing here are the opposite aims
> of enterprise RAID (traditional SCSI market) versus desktop filesystems
> (now the number one user of Linux SCSI, courtesy of libata).
> 
> With RAID, it's safe to suggest that a very fast, bounded exit from EH
> is almost always what the customer / end-user wants, because the higher
> level RAID management can then deal with the failed drive offline.
> 
> But for a desktop filesystem, failing out quickly and bulk-failing megabytes
> around a couple of bad sectors is not good -- no redundancy, and this will
> lead to unneeded data loss.
> 
> It's beginning to look like this needs to be run-time tuneable,
> per block minor device (per-partition), through sysfs at a minimum.
> The RAID tools could then automatically choose settings to bias more
> towards an "instant exit" when errors are found, whereas a non-RAID
> desktop could select a more reliable recovery strategy.
> 
> Right now, with Jame's patch (earlier in this thread), the whole scheme
> is heavily weighted towards the RAID "instant exit" strategy, which is
> making me quite nervous about the data on my laptop.

Also worth considering is that spending minutes trying to reread
damaged sectors is likely to accelerate your death spiral. More data
may be recoverable if you give up quickly in a first pass, then go
back and manually retry damaged bits with smaller I/Os.

Another approach is to have separate retries per hard sector and
hard errors per MB at the block device level. We don't want to have
the same number of retries for a 64KB block as a 1MB block and we
certainly don't want to do 2K retries in a row.

So for instance, I could have the first set to 1 and the second set to
16. For a 256KB read, this gets scaled down to 4, which means we'll
retry each sector once and fail the whole I/O when we hit the 5th
sector error.

More reasonable number might be 0 and 1, meaning "don't do OS level
retries on sectors and fail the whole I/O on the second sector error
(or immediately for smaller reads)".

It might also be informative to add a kernel message reporting if a retry
(in the non-transient cases) ever actually succeeds. 

-- 
Mathematics is the supreme nostalgia of our time.
