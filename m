From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Mon, 15 Oct 2007 21:55:13 -0600
Message-ID: <m1tzoriuhq.fsf@ebiederm.dsl.xmission.com>
References: <200710112011.22000.rob@landley.net>
	<20071015014503.GF9715@thunk.org> <200710150304.00901.rob@landley.net>
	<200710152337.45252.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48081 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464AbXJPD4C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 23:56:02 -0400
In-Reply-To: <200710152337.45252.nickpiggin@yahoo.com.au> (Nick Piggin's
	message of "Mon, 15 Oct 2007 23:37:44 +1000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Monday 15 October 2007 18:04, Rob Landley wrote:
>> On Sunday 14 October 2007 8:45:03 pm Theodore Tso wrote:
>
>> > > excuse for conflating different categories of devices in the first
>> > > place.
>> >
>> > See the thinkpad Ultrabay drive example above.
>>
>> Last week I drove my laptop so deep into swap (with a "make -j" on qemu)
>> that after half an hour trying to repaint my kmail window, it locked solid.
>> Again.  You'd think the oom killer would come to the rescue, but it didn't.
>> Maybe Ubuntu disabled it.  I have _2_gigs_ of ram in this sucker, on a
>> stock Ubuntu 7.04 install (with the "upgrade all" tab pressed a few times),
>> and yet I managed to make it swap itself to death one more time.
>>
>> Virtual memory isn't perfect.  I've _always_ been able to come up with
>> examples where it just doesn't work for me.  This doesn't mean VM
>> overcommit should be abolished, because it's useful more often than not.
>
> I hate to go completely offtopic here, but disks are so incredibly
> slow when compared to RAM that there is really nothing the kernel
> can do about this. Presumably the job will finish, given infinite
> time.
>
> How much swap do you have configured? You really shouldn't configure
> so much unless you do want the kernel to actually use it all, right?

No.

There are three basic swapping scenarios.
- Pushing unused data out of ram
- Swapping 
- Thrashing

To effectively swap you need SWAP > RAM because after a little while of
swapping all of your pages in RAM should be assigned a location in the
page cache.

I have not heard of many people swapping and not thrashing lately.
I think part of the problem is that we do random access to the swap
partition which makes us seek limited.  And since the number of
seeks per unit time has been increasing at a linear or slower rate
that if we are doing random disk I/O then the amount we can use
the disk for is very limited.   I wonder if we could figure out
how to push and pull 1M or bigger chunks into and out of swap?

I don't know if swap has actually worked since we vmscan stopped
going over the virtual addresses.

> Because if we're not really conservative about OOM killing, then the
> user who actually really did want to use all the swap they configured
> gets angry when we kill their jobs without using it all.

I totally agree. The fact that the OOM killer started is a sign that
the system was completely overwhelmed and nothing better could happen.

In this case my gut feel says limiting the total number of processes
would have been much more effective then anything at all to do with
swap. make -j reminds me of the classic fork bomb.

> Would an oom-kill-someone-now sysrq be of help, I wonder?

Well we have SAQ which should kill everything on your current VT
which should include X and all of it's children.

Eric
