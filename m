From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Tue, 16 Oct 2007 16:59:28 +1000
Message-ID: <200710161659.28826.nickpiggin@yahoo.com.au>
References: <200710112011.22000.rob@landley.net> <200710152337.45252.nickpiggin@yahoo.com.au> <m1tzoriuhq.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:38466 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750907AbXJPER4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Oct 2007 00:17:56 -0400
In-Reply-To: <m1tzoriuhq.fsf@ebiederm.dsl.xmission.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Tuesday 16 October 2007 13:55, Eric W. Biederman wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:

> > How much swap do you have configured? You really shouldn't configure
> > so much unless you do want the kernel to actually use it all, right?
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

I don't follow your logic. We don't need SWAP > RAM in order to swap
effectively, IMO.


> I have not heard of many people swapping and not thrashing lately.
> I think part of the problem is that we do random access to the swap
> partition which makes us seek limited.  And since the number of
> seeks per unit time has been increasing at a linear or slower rate
> that if we are doing random disk I/O then the amount we can use

I don't know if there is a causal relationship there. I mean, I
think it's been a long time since thrashing was ever a viable mode
of operation, right?

Maybe desktops just have less need for swapping now, so nobody sees
it much until something goes _really_ bad. When I'm using my 256MB
machine, unused stuff goes to swap.


> the disk for is very limited.   I wonder if we could figure out
> how to push and pull 1M or bigger chunks into and out of swap?

Pulling in 1MB pages can really easily end up compounding the
thrashing problem unless you're very sure a significant amount
of it will be used.


> I don't know if swap has actually worked since we vmscan stopped
> going over the virtual addresses.

I do, and it does ;)


> > Because if we're not really conservative about OOM killing, then the
> > user who actually really did want to use all the swap they configured
> > gets angry when we kill their jobs without using it all.
>
> I totally agree. The fact that the OOM killer started is a sign that
> the system was completely overwhelmed and nothing better could happen.
>
> In this case my gut feel says limiting the total number of processes
> would have been much more effective then anything at all to do with
> swap. make -j reminds me of the classic fork bomb.

Yep.


> > Would an oom-kill-someone-now sysrq be of help, I wonder?
>
> Well we have SAQ which should kill everything on your current VT
> which should include X and all of it's children.

Which is exactly what you don't want to do if you've just forkbombed
yourself. I missed the fact that we now have a manual oom kill...
