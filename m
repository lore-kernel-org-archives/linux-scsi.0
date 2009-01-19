From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Mainline kernel OLTP performance update
Date: Mon, 19 Jan 2009 19:33:27 +1100
Message-ID: <200901191933.29322.nickpiggin@yahoo.com.au>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <200901191813.07960.nickpiggin@yahoo.com.au> <1232352303.30141.25.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:47507 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751116AbZASIdv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2009 03:33:51 -0500
In-Reply-To: <1232352303.30141.25.camel@penberg-laptop>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, Christoph Lameter <cl@linux-foundation.org>

On Monday 19 January 2009 19:05:03 Pekka Enberg wrote:
> Hi Nick,
>
> On Mon, 2009-01-19 at 18:13 +1100, Nick Piggin wrote:
> > SLUB was distinctly slower on the tbench, netperf, and hackbench
> > tests that I ran. These were faster with SLUB on your machine?
>
> I was trying to bisect a somewhat recent SLAB vs. SLUB regression in
> tbench that seems to be triggered by CONFIG_SLUB as suggested by Evgeniy
> Polyakov performance tests. Unfortunately I bisected it down to a bogus
> commit so while I saw SLUB beating SLAB, I also saw the reverse in
> nearby commits which didn't touch anything interesting. So for tbench,
> SLUB _used to_ dominate SLAB on my machine but the current situation is
> not as clear with all the tbench regressions in other subsystems.

OK.


> SLUB has been a consistent winner for hackbench after Christoph fixed
> the regression reported by Ingo Molnar two years (?) ago. I don't think
> I've ran netperf, but for the fio test you mentioned, SLUB is beating
> SLAB here.

Hmm, netperf, hackbench, and fio are all faster with SLAB than SLUB.


> On Mon, 2009-01-19 at 18:13 +1100, Nick Piggin wrote:
> > What kind of system is it?
>
> 2-way Core2. I posted my /proc/cpuinfo in this thread if you're
> interested.

Thanks. I guess one of three obvious differences, mine is a K10, is
NUMA, and has significantly more cores. I can try setting it to
interleave cachelines over nodes or use fewer cores to see if the
picture changes...


> On Mon, 2009-01-19 at 18:13 +1100, Nick Piggin wrote:
> > > So I have very mixed feelings about SLQB. It's very
> > > nice that it works for OLTP but we still don't have much insight (i.e.
> > > numbers) on why it's better.
>
> On Mon, 2009-01-19 at 18:13 +1100, Nick Piggin wrote:
> > According to estimates in this thread, I think Matthew said SLUB would
> > be around 6% slower? SLQB is within measurement error of SLAB.
>
> Yeah but I say that we don't know _why_ it's better. There's the
> kmalloc()/kfree() CPU ping-pong hypothesis but it could also be due to
> page allocator interaction or just a plain bug in SLUB. And lets not
> forget bad interaction with some random subsystem (SCSI, for example).
>
> On Mon, 2009-01-19 at 18:13 +1100, Nick Piggin wrote:
> > Fair point about personally reproducing the OLTP problem yourself. But
> > the fact is that we will get problem reports that cannot be reproduced.
> > That does not make them less relevant. I can't reproduce the OLTP
> > benchmark myself. And I'm fully expecting to get problem reports for
> > SLQB against insanely sized SGI systems, which I will take very seriously
> > and try to fix them.
>
> Again, it's not that I don't take the OLTP regression seriously (I do)
> but as a "part-time maintainer" I simply don't have the time and
> resources to attempt to fix it without either (a) being able to
> reproduce the problem or (b) have someone who can reproduce it who is
> willing to do oprofile and so on.
>
> So as much as I would have preferred that you had at least attempted to
> fix SLUB, I'm more than happy that we have a very active developer
> working on the problem now. I mean, I don't really care which allocator
> we decide to go forward with, if all the relevant regressions are dealt
> with.

OK, good to know.


> All I am saying is that I don't like how we're fixing a performance bug
> with a shiny new allocator without a credible explanation why the
> current approach is not fixable.

To be honest, my biggest concern with SLUB is the higher order pages
thing. But Christoph always poo poos me when I raise that concern, and
it's hard to get concrete numbers showing real fragmentation problems
when it can take days or months to start biting.

It really stems from queueing versus not queueing I guess. And I think
SLUB is flawed due to its avoidance of queueing.


> On Mon, 2009-01-19 at 18:13 +1100, Nick Piggin wrote:
> > > The good news is that SLQB can replace SLAB so either way, we're not
> > > going to end up with four allocators. Whether it can replace SLUB
> > > remains to be seen.
> >
> > Well I think being able to simply replace SLAB is not ideal. The plan
> > I'm hoping is to have four allocators for a few releases, and then
> > go back to having two. That is going to mean some groups might not
> > have their ideal allocator merged... but I think it is crazy to settle
> > with more than one main compile-time allocator for the long term.
>
> So now the HPC folk will be screwed over by the OLTP folk?

No. I'm imagining there will be a discussion of the 3, and at some
point an executive decision will be made if an agreement can't be
reached. At this point, I think that is a better and fairer option
than just asserting one allocator is better than another and making
it the default.

And... we have no indication that SLQB will be worse for HPC than
SLUB ;)


> I guess
> that's okay as the latter have been treated rather badly for the past
> two years.... ;-)

I don't know if that is meant to be sarcastic, but the OLTP performance
numbers almost never get better from one kernel to the next. Actually
the trend is downward. Mainly due to bloat or new features being added.

I think that at some level, controlled addition of features that may
add some cycles to these paths is not a bad idea (what good is Moore's
Law if we can't have shiny new features? :) But on the other hand, this
OLTP test is incredibly valuable to monitor the general performance-
health of this area of the kernel.

