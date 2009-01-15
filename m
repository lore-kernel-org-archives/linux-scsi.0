From: Steven Rostedt <srostedt@redhat.com>
Subject: Re: Mainline kernel OLTP performance update
Date: Thu, 15 Jan 2009 13:14:47 -0500
Message-ID: <1232043287.21980.65.camel@localhost.localdomain>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>
	 <20090114163557.11e097f2.akpm@linux-foundation.org>
	 <20090115012147.GW29283@parisc-linux.org>
	 <20090114180431.f4a96543.akpm@linux-foundation.org>
	 <1232028766.5966.10.camel@localhost.localdomain>
	 <20090115094442.b6394544.akpm@linux-foundation.org>
	 <20090115180052.GG29283@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39569 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbZAOSPY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2009 13:15:24 -0500
In-Reply-To: <20090115180052.GG29283@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, Gregory Haskins <ghaskins@novell.com>


On Thu, 2009-01-15 at 11:00 -0700, Matthew Wilcox wrote:
> On Thu, Jan 15, 2009 at 09:44:42AM -0800, Andrew Morton wrote:
> > > Me too.  Anecdotally, I haven't noticed this in my lab machines, but
> > > what I have noticed is on someone else's laptop (a hyperthreaded atom)
> > > that I was trying to demo powertop on was that IPI reschedule interrupts
> > > seem to be out of control ... they were ticking over at a really high
> > > rate and preventing the CPU from spending much time in the low C and P
> > > states.  To me this implicates some scheduler problem since that's the
> > > primary producer of IPI reschedules ... I think it wouldn't be a
> > > significant extrapolation to predict that the scheduler might be the
> > > cause of the above problem as well.
> > > 
> > 
> > Good point.
> > 
> > The context switch rate actually went down a bit.
> > 
> > I wonder if the Intel test people have records of /proc/interrupts for
> > the various kernel versions.
> 
> I think Chinang does, but he's out of office today.  He did say in an
> earlier reply:
> 
> > I took a quick look at the interrupts figure between 2.6.24 and 2.6.27.
> > i/o interuputs is slightly down in 2.6.27 (due to reduce throughput).
> > But both NMI and reschedule interrupt increased.  Reschedule interrupts
> > is 2x of 2.6.24.
> 
> So if the reschedule interrupt is happening twice as often, and the
> context switch rate is basically unchanged, I guess that means the
> scheduler is doing a lot more work to get approximately the same
> results.  And that seems like a bad thing.
> 
> Again, it's worth bearing in mind that these are all RT tasks, so the
> underlying problem may be very different from the one that both James and
> I have observed with an Atom laptop running predominantly non-RT tasks.
> 

The RT scheduler is a bit more aggressive than it use to be. It use to
just migrate RT tasks when the migration thread woke up, and did that in
"bulk".  Now, when an individual RT task wakes up and it can not run on
the current CPU but can on another CPU, it is scheduled immediately, and
an IPI is sent out.

As for context switching, it would be the same amount as before, but the
difference is that the RT task will try to wake up as soon as possible.
This also causes RT tasks to bounce around CPUs more often.

If there are many threads, they should not be RT, unless there is some
design behind it.

Forgive me if you already did this and said so, but what is the result
of just making the writer an RT task and keeping all the readers as
SCHED_OTHER?

-- Steve


