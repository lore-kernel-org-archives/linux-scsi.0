From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 30 Jan 2008 10:22:54 -0600
Message-ID: <1201710175.3292.16.camel@localhost.localdomain>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <e2e108260801300029r1a949353k73b30f1f28db0bc9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53455 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753206AbYA3QXE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2008 11:23:04 -0500
In-Reply-To: <e2e108260801300029r1a949353k73b30f1f28db0bc9@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 09:29 +0100, Bart Van Assche wrote:
> On Jan 29, 2008 9:42 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > > As an SCST user, I would like to see the SCST kernel code integrated
> > > in the mainstream kernel because of its excellent performance on an
> > > InfiniBand network. Since the SCST project comprises about 14 KLOC,
> > > reviewing the SCST code will take considerable time. Who will do this
> > > reviewing work ? And with regard to the comments made by the
> > > reviewers: Vladislav, do you have the time to carry out the
> > > modifications requested by the reviewers ? I expect a.o. that
> > > reviewers will ask to move SCST's configuration pseudofiles from
> > > procfs to sysfs.
> >
> > The two target architectures perform essentially identical functions, so
> > there's only really room for one in the kernel.  Right at the moment,
> > it's STGT.  Problems in STGT come from the user<->kernel boundary which
> > can be mitigated in a variety of ways.  The fact that the figures are
> > pretty much comparable on non IB networks shows this.
> 
> Are you saying that users who need an efficient iSCSI implementation
> should switch to OpenSolaris ?

I'd certainly say that's a totally unsupported conclusion.

>  The OpenSolaris COMSTAR project involves
> the migration of the existing OpenSolaris iSCSI target daemon from
> userspace to their kernel. The OpenSolaris developers are
> spending time on this because they expect a significant performance
> improvement.

Just because Solaris takes a particular design decision doesn't
automatically make it the right course of action.

Microsoft once pulled huge gobs of the C library and their windowing
system into the kernel in the name of efficiency.  It proved not only to
be less efficient, but also to degrade their security model. 

Deciding what lives in userspace and what should be in the kernel lies
at the very heart of architectural decisions.  However, the argument
that "it should be in the kernel because that would make it faster" is
pretty much a discredited one.  To prevail on that argument, you have to
demonstrate that there's no way to enable user space to do the same
thing at the same speed.  Further, it was the same argument used the
last time around when the STGT vs SCST investigation was done.  Your own
results on non-IB networks show that both architectures perform at the
same speed.  That tends to support the conclusion that there's something
specific about IB that needs to be tweaked or improved for STGT to get
it to perform correctly.

Furthermore, if you have already decided before testing that SCST is
right and that STGT is wrong based on the architectures, it isn't
exactly going to increase my confidence in your measurement methodology
claiming to show this, now is it?

> > I really need a whole lot more evidence than at worst a 20% performance
> > difference on IB to pull one implementation out and replace it with
> > another.  Particularly as there's no real evidence that STGT can't be
> > tweaked to recover the 20% even on IB.
> 
> My measurements on a 1 GB/s InfiniBand network have shown that the current
> SCST implementation is able to read data via direct I/O at a rate of 811 GB/s
> (via SRP) and that the current STGT implementation is able to transfer data at a
> rate of 589 MB/s (via iSER). That's a performance difference of 38%.
> 
> And even more important, the I/O latency of SCST is significantly
> lower than that
> of STGT. This is very important for database workloads -- the I/O pattern caused
> by database software is close to random I/O, and database software needs low
> latency I/O in order to run efficiently.
> 
> In the thread with the title "Performance of SCST versus STGT" on the
> SCST-devel /
> STGT-devel mailing lists not only the raw performance numbers were discussed but
> also which further performance improvements are possible. It became clear that
> the SCST performance can be improved further by implementing a well known
> optimization (zero-copy I/O). Fujita Tomonori explained in the same
> thread that it is
> possible to improve the performance of STGT further, but that this would require
> a lot of effort (implementing asynchronous I/O in the kernel and also
> implementing
> a new caching mechanism using pre-registered buffers).

These are both features being independently worked on, are they not?
Even if they weren't, the combination of the size of SCST in kernel plus
the problem of having to find a migration path for the current STGT
users still looks to me to involve the greater amount of work.

James


