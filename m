From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Tue, 16 Oct 2007 03:31:28 -0600
Message-ID: <m1tzorh0cv.fsf@ebiederm.dsl.xmission.com>
References: <200710112011.22000.rob@landley.net>
	<200710161659.28826.nickpiggin@yahoo.com.au>
	<m1lka3ishi.fsf@ebiederm.dsl.xmission.com>
	<200710160138.57893.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48002 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbXJPJc6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 05:32:58 -0400
In-Reply-To: <200710160138.57893.rob@landley.net> (Rob Landley's message of
	"Tue, 16 Oct 2007 01:38:57 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

Rob Landley <rob@landley.net> writes:

> On Monday 15 October 2007 11:38:33 pm Eric W. Biederman wrote:
>> > I don't follow your logic. We don't need SWAP > RAM in order to swap
>> > effectively, IMO.
>>
>> The steady state of a system that is heavily and usably swapping but
>> not thrashing is that all of the pages in RAM are in the swap cache,
>> at least that used to be the case.
>
> Mind if I throw in some vague and questionable numbers? :)
>
> I vaguely recall that my old 486 laptop with 16 megabyes of ram (circa 1998) 
> used to be able to do 3 point something megabytes per second to/from disk, 
> according to hdparm -t.  (That was with DMA enabled.)
>
> This means that my old laptop, using sequential writes and not being bogged 
> down by excessive seeking, could write its entire memory contents to disk and 
> read it back in again in about 10 seconds total (5 write, 5 read).
>
> My current laptop has 2 gigabytes of ram, and hdparm -t /dev/sda says:
>   /dev/sda:
>    Timing buffered disk reads:  116 MB in  3.01 seconds =  38.54 MB/sec
>
> So that's a little over a factor of 10 speed improvement.  (Although I note 
> that I got 30 megabytes/second off of an ATA/100 adapter in 2002, so it's 
> barely any faster than it was 5 years ago.)
>
> This means I can expect my current laptop to write out its memory in 50 
> seconds (2000/40), and another 50 seconds to read it back in.
>
> So 10 seconds to cycle through memory 10 years ago, vs a little under 2 
> minutes today, on systems at roughly the same price point.  And that's 
> limited by what the hardware is doing, assuming a _perfect_ linear read/write 
> pattern with no seeks.
>
> Oh, and my old 486 had its RAM maxed out.  This one can hold twice as much.  
> And heavy seeking sucks more than it used to relative to sequential reads by 
> something like a proportional amount (hence the rise of I/O elevators as a 
> mitigation strategy), although I haven't got numbers for that handy.
>
>> > I don't know if there is a causal relationship there. I mean, I
>> > think it's been a long time since thrashing was ever a viable mode
>> > of operation, right?
>>
>> Right.  But swapping heavily has been a viable mode of operation
>> and that the vast gap in disk random IO performance seems to have
>> hurt significantly.
>>
>> It be very clear is used to able to run a problem at little below
>> full speed with the disk pegged with swap traffic, and I did this
>> regularly when I started out with linux.
>
> The problem is the gap is getting bigger.  The 486-75 laptop mentioned above 
> had a 25 mhz 32 bit front side bus.  A quick google suggests my core 2 duo 
> has a 667 mhz FSB and I'm guessing a 128 bit data path (two 64-bit channels).

I'm pretty certain Intels' arechitecture is only has a 64bit front side bus.
Of course I'm used to seeing it clocked a bit higher.

> I could boot up memtest86 and get actual benchmarks, but total handwaving for 
> a moment, 25*32=800 and 667*128=85376, and the second divided by the first is 
> over 100 times as big.  That concurs with the 16mhz->1733 mhz processor speed 
> increase.
>
> Factor of 10 disk speed increase, factor of 100 memory speed increase.  Disks 
> speeds aren't keeping up with processor and memory increases.  Disk _sizes_ 
> are, but speeds aren't.

Exactly.

>> > Maybe desktops just have less need for swapping now, so nobody sees
>> > it much until something goes _really_ bad. When I'm using my 256MB
>> > machine, unused stuff goes to swap.
>>
>> There is a bit of truth in the fact that there is less need for
>> swapping now.  At the same time however swapping simply does not
>> work well right now, and I'm not at all certain why.
>
> Do the numbers above help?  It'll only get worse, unless some random new 
> technology (maybe http://en.wikipedia.org/wiki/MRAM or something) swoops in 
> to change everything, again.

Well it will be interesting to see what happens with NAND flash.  So far
it is pricey but you can easily make it faster then todays hard drives.
Capacity is still coming.

>> >> the disk for is very limited.   I wonder if we could figure out
>> >> how to push and pull 1M or bigger chunks into and out of swap?
>> >
>> > Pulling in 1MB pages can really easily end up compounding the
>> > thrashing problem unless you're very sure a significant amount
>> > of it will be used.
>>
>> It's a hard call.  The I/O time for 1MB of contiguous disk data
>> is about the I/O time of 512 bytes of contiguous disk data.
>
> Hence "the seek sucking even more now" part. :(

> I'm sure somebody will eventually write an OLS paper or something on the 
> advisability of making swapping decisions with 4k granularity when disks 
> really want bigger I/O transactions.  Maybe they already have, somewhere 
> between:
> http://kernel.org/doc/ols/2007/ols2007v1-pages-53-64.pdf
> and
> http://kernel.org/doc/ols/2007/ols2007v1-pages-277-284.pdf

An interesting point.  What would really impress me is actually finding
a current work load that can productively swap after everything kernel
side is fixed up and optimized.   So far it seems like real swapping is so
painful that everyone is simply avoiding it.

Eric
