From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Tue, 16 Oct 2007 17:34:15 +1000
Message-ID: <200710161734.15880.nickpiggin@yahoo.com.au>
References: <200710112011.22000.rob@landley.net> <200710161659.28826.nickpiggin@yahoo.com.au> <m1lka3ishi.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:41430 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751359AbXJPEwh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Oct 2007 00:52:37 -0400
In-Reply-To: <m1lka3ishi.fsf@ebiederm.dsl.xmission.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Tuesday 16 October 2007 14:38, Eric W. Biederman wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> > On Tuesday 16 October 2007 13:55, Eric W. Biederman wrote:

> > I don't follow your logic. We don't need SWAP > RAM in order to swap
> > effectively, IMO.
>
> The steady state of a system that is heavily and usably swapping but
> not thrashing is that all of the pages in RAM are in the swap cache,
> at least that used to be the case.

Yeah, it works better in 2.6 (and, IIRC later 2.4 kernels).


> > I don't know if there is a causal relationship there. I mean, I
> > think it's been a long time since thrashing was ever a viable mode
> > of operation, right?
>
> Right.  But swapping heavily has been a viable mode of operation
> and that the vast gap in disk random IO performance seems to have
> hurt significantly.

Or, just not improved as fast as everything else is improving.
There isn't too much the kernel can do about that. It just
relatively changes the point at which you'd consider "swapping
heavily", right?


> It be very clear is used to able to run a problem at little below
> full speed with the disk pegged with swap traffic, and I did this
> regularly when I started out with linux.

I can do this now. In make -jhuge tests for example, you can get
a 4GB, 4 core machine to max out a disk with swapping and still
have 0 idle time. Of course you can also go past that point and
your idle time comes up. That's not new though.


> > Maybe desktops just have less need for swapping now, so nobody sees
> > it much until something goes _really_ bad. When I'm using my 256MB
> > machine, unused stuff goes to swap.
>
> There is a bit of truth in the fact that there is less need for
> swapping now.  At the same time however swapping simply does not
> work well right now, and I'm not at all certain why.
>
> >> the disk for is very limited.   I wonder if we could figure out
> >> how to push and pull 1M or bigger chunks into and out of swap?
> >
> > Pulling in 1MB pages can really easily end up compounding the
> > thrashing problem unless you're very sure a significant amount
> > of it will be used.
>
> It's a hard call.  The I/O time for 1MB of contiguous disk data
> is about the I/O time of 512 bytes of contiguous disk data.

And if you're thrashing, then by definition you need to throw
out 1MB of your working set in order to read it in.


> >> I don't know if swap has actually worked since we vmscan stopped
> >> going over the virtual addresses.
> >
> > I do, and it does ;)
>
> Really?  Not just the pushing of unused stuff into swap.

We had several bugs and things that caused swapping performance
regressions vs 2.4 in earlyish 2.6. After those were fixed, we're
pretty competitive with 2.4 in some basic tests I was using. I
haven't run them for a fair while, so something might have broken
since then, I don't know.
