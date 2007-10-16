From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Mon, 15 Oct 2007 22:45:01 -0600
Message-ID: <m1ejfvis6q.fsf@ebiederm.dsl.xmission.com>
References: <200710112011.22000.rob@landley.net>
	<20071015014503.GF9715@thunk.org> <200710150304.00901.rob@landley.net>
	<200710152337.45252.nickpiggin@yahoo.com.au>
	<m1tzoriuhq.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0710152105460.1538@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41422 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbXJPEqY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 00:46:24 -0400
In-Reply-To: <Pine.LNX.4.64.0710152105460.1538@asgard.lang.hm>
	(david@lang.hm's message of "Mon, 15 Oct 2007 21:10:10 -0700 (PDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@lang.hm
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

david@lang.hm writes:

>
> on some kernel versions you are correct about needing swap > ram, but on current
> versions you are not. the swap space gets allocated as needed, and re-used as
> needed (I don't know the mechanism of this, but I remember the last time this
> changed from vm=max(ram,swap) to vm=ram+swap)

I don't think I can recall a linux kernel that required swap > ram.
However for serious swapping under linux having swap > ram was very
useful and pretty much a requirement for a workload that involved
swapping heavily (not thrashing).

>> I have not heard of many people swapping and not thrashing lately.
>> I think part of the problem is that we do random access to the swap
>> partition which makes us seek limited.  And since the number of
>> seeks per unit time has been increasing at a linear or slower rate
>> that if we are doing random disk I/O then the amount we can use
>> the disk for is very limited.   I wonder if we could figure out
>> how to push and pull 1M or bigger chunks into and out of swap?
>
> it has been noted by many people that linux is very slow to pull things back
> into ram from swap, significantly slower then simple seed limiting would seem to
> account for.

Yes.  It may be the large amount of random access (my current guess)
or it may be something else.

I'm wonder if I should build an application with a configurable
data set and working set that can be used for swap testing.  I don't
think it would be very hard and it might help sort through some of
the swap performance problems.

Eric



