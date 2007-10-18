From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Thu, 18 Oct 2007 15:00:49 +0200
Message-ID: <20071018130048.GA25084@bitwizard.nl>
References: <200710112011.22000.rob@landley.net> <200710161659.28826.nickpiggin@yahoo.com.au> <m1lka3ishi.fsf@ebiederm.dsl.xmission.com> <200710161734.15880.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.126.206.180]:40520 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756685AbXJRNHe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Oct 2007 09:07:34 -0400
Content-Disposition: inline
In-Reply-To: <200710161734.15880.nickpiggin@yahoo.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Tue, Oct 16, 2007 at 05:34:15PM +1000, Nick Piggin wrote:
> > It's a hard call.  The I/O time for 1MB of contiguous disk data
> > is about the I/O time of 512 bytes of contiguous disk data.
> 
> And if you're thrashing, then by definition you need to throw
> out 1MB of your working set in order to read it in.

Right. But you need a differential hit rate of only a few percent on
that 1020 extra kb of data you swapped in versus the 1Mb of data you
swapped out for this to be advantageous.

With "differential hit rate" I mean the chances of getting a hit on
the 1Mb of data just paged in, minus the chances of getting a hit on
the 1Mb of data just paged out. 

With a little luck that 1Mb that is paged out didn't get used for
quite a while, while there is a hint that the 1Mb you're paging in
is active, as one of its sub-pages just got a hit.

So... IMHO, it would be useful to implement something that pages out
chunks of memory larger than a single hardware page. This would reduce
the size of the memory management tables (*), as well as improve disk
throughput if things DO come to paging....

This should of course be configurable. Some workloads are better off
with a virtual page size of 8k, some with 128k. some with 1M.

As far as I can see, the "page-cluster" parameter defines how many
pages at a time are selected for page-out at a time. This increases
the page-out efficiency. Improving the page-in efficiency is also
useful: It is the other half of hte equation.

	Roger. 


(*) If the kernel starts working with a 1Mb virtual page size, you
need a 256 times smaller mapping table between processes and memory or
swap. Of course, the hardware doesn't support this (actually, it does
for 1Mb virtual pages), so you'll have to create 256 page table
entries for the hardware instead of just one.



-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
