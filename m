From: Andrew Morton <akpm@digeo.com>
Subject: Re: Making sym-2 do 160 MB/sec
Date: Wed, 19 Feb 2003 15:22:26 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030219152226.07d381d6.akpm@digeo.com>
References: <20030219120639.3df58497.akpm@digeo.com>
	<20030219231204.GA3705@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id PAA03494
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2003 15:24:41 -0800 (PST)
In-Reply-To: <20030219231204.GA3705@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike Anderson <andmike@us.ibm.com> wrote:
>
> >  	 * Btw, 'period' is in tenths of nanoseconds.
> >  	 */
> >  	period = (4 * div_10M[0] + np->clock_khz - 1) / np->clock_khz;
> > -	if	(period <= 250)		np->minsync = 10;
> > +	if	(period == 250)		np->minsync = 9;
> > +	else if	(period <= 250)		np->minsync = 10;
> >  	else if	(period <= 303)		np->minsync = 11;
> >  	else if	(period <= 500)		np->minsync = 12;
> >  	else				np->minsync = (period + 40 - 1) / 40;
> > 

On reflection, the above code is fairly weird.  But it works..

> I do not have one of these cards (and my docs are for older 53C chips)
> so I may be mis-reading something, but if the values are to match the
> spec I would have thought 9 would be for Fast-80.
> 
> The SPI spec I have indicates that the transfer period factors should
> be:
> 	FAST-160	Period: 6.25 ns	Value: 8
> 	FAST-80		Period: 12.5 ns	Value: 9
> 	FAST-40		Period: 25 ns	Value: 10
> 	FAST-40		Period: 30.3 ns	Value: 11
> 	FAST-20		Period: 50 ns	Value: 12

Yes, certainly the `9' is the magic which yields FAST-80.

But the thing is, at that point in the driver, `period' is 250.  I wonder
where that algorithm to go from `period' to `np->minsync' came from.

Judging by the comment "Btw, 'period' is in tenths of nanoseconds.", I need
to go further into the driver and work out why it has decided that the period
is 25 nSec.

But note that the current code is:

	if	(period <= 250)		np->minsync = 10;
	else if	(period <= 303)		np->minsync = 11;
	else if	(period <= 500)		np->minsync = 12;
	else				np->minsync = (period + 40 - 1) / 40;

So even if `period' was one nanosecond, we'll still be stuck at FAST-40.

So perhaps something has gone wrong here:

	if	(np->features & (FE_ULTRA3 | FE_ULTRA2))
		np->clock_khz = 160000;
	else if	(np->features & FE_ULTRA)
		np->clock_khz = 80000;
	else
		np->clock_khz = 40000;

and we need to add a "if (period <= 125)" clause there.

I'll poke at it some more, thanks.
