From: david@lang.hm
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Mon, 15 Oct 2007 21:10:10 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0710152105460.1538@asgard.lang.hm>
References: <200710112011.22000.rob@landley.net> <20071015014503.GF9715@thunk.org>
 <200710150304.00901.rob@landley.net> <200710152337.45252.nickpiggin@yahoo.com.au>
 <m1tzoriuhq.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:59562
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbXJPEGT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 00:06:19 -0400
In-Reply-To: <m1tzoriuhq.fsf@ebiederm.dsl.xmission.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Mon, 15 Oct 2007, Eric W. Biederman wrote:

> Nick Piggin <nickpiggin@yahoo.com.au> writes:
>
>> How much swap do you have configured? You really shouldn't configure
>> so much unless you do want the kernel to actually use it all, right?
>
> No.
>
> There are three basic swapping scenarios.
> - Pushing unused data out of ram
> - Swapping
> - Thrashing
>
> To effectively swap you need SWAP > RAM because after a little while of
> swapping all of your pages in RAM should be assigned a location in the
> page cache.

on some kernel versions you are correct about needing swap > ram, but on 
current versions you are not. the swap space gets allocated as needed, and 
re-used as needed (I don't know the mechanism of this, but I remember the 
last time this changed from vm=max(ram,swap) to vm=ram+swap)

> I have not heard of many people swapping and not thrashing lately.
> I think part of the problem is that we do random access to the swap
> partition which makes us seek limited.  And since the number of
> seeks per unit time has been increasing at a linear or slower rate
> that if we are doing random disk I/O then the amount we can use
> the disk for is very limited.   I wonder if we could figure out
> how to push and pull 1M or bigger chunks into and out of swap?

it has been noted by many people that linux is very slow to pull things 
back into ram from swap, significantly slower then simple seed limiting 
would seem to account for.

Davdi Lang
