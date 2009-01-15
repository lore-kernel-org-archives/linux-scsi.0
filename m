From: "Ma, Chinang" <chinang.ma@intel.com>
Subject: RE: Mainline kernel OLTP performance update
Date: Thu, 15 Jan 2009 12:28:18 -0700
Message-ID: <BC02C49EEB98354DBA7F5DD76F2A9E8003175EB3F5@azsmsx501.amr.corp.intel.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>
	 <20090114163557.11e097f2.akpm@linux-foundation.org>
	 <20090115012147.GW29283@parisc-linux.org>
	 <20090114180431.f4a96543.akpm@linux-foundation.org>
	 <1232028766.5966.10.camel@localhost.localdomain>
	 <20090115094442.b6394544.akpm@linux-foundation.org>
	 <20090115180052.GG29283@parisc-linux.org>
 <1232043287.21980.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58461 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299AbZAOT2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 14:28:52 -0500
In-Reply-To: <1232043287.21980.65.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Rostedt <srostedt@redhat.com>, Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "arjan@linux.intel.com" <arjan@linux.intel.com>, "Kleen, Andi" <andi.kleen@intel.com>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>, "Chilukuri, Harita" <harita.chilukuri@intel.com>, "Styner, Douglas W" <douglas.w.styner@intel.com>, "Wang, Peter Xihong" <peter.xihong.wang@intel.com>, "Nueckel, Hubert" <hubert.nueckel@intel.com>, "chris.mason@oracle.com" <chris.mason@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, Gregory Haskins <ghaskins@novell.com>



>-----Original Message-----
>From: Steven Rostedt [mailto:srostedt@redhat.com]
>Sent: Thursday, January 15, 2009 10:15 AM
>To: Matthew Wilcox
>Cc: Andrew Morton; James Bottomley; Wilcox, Matthew R; Ma, Chinang; linux-
>kernel@vger.kernel.org; Tripathi, Sharad C; arjan@linux.intel.com; Kleen,
>Andi; Siddha, Suresh B; Chilukuri, Harita; Styner, Douglas W; Wang, Peter
>Xihong; Nueckel, Hubert; chris.mason@oracle.com; linux-scsi@vger.kernel.org;
>Andrew Vasquez; Anirban Chakraborty; Gregory Haskins
>Subject: Re: Mainline kernel OLTP performance update
>
>
>On Thu, 2009-01-15 at 11:00 -0700, Matthew Wilcox wrote:
>> On Thu, Jan 15, 2009 at 09:44:42AM -0800, Andrew Morton wrote:
>> > > Me too.  Anecdotally, I haven't noticed this in my lab machines, but
>> > > what I have noticed is on someone else's laptop (a hyperthreaded atom)
>> > > that I was trying to demo powertop on was that IPI reschedule
>interrupts
>> > > seem to be out of control ... they were ticking over at a really high
>> > > rate and preventing the CPU from spending much time in the low C and
>P
>> > > states.  To me this implicates some scheduler problem since that's
>the
>> > > primary producer of IPI reschedules ... I think it wouldn't be a
>> > > significant extrapolation to predict that the scheduler might be the
>> > > cause of the above problem as well.
>> > >
>> >
>> > Good point.
>> >
>> > The context switch rate actually went down a bit.
>> >
>> > I wonder if the Intel test people have records of /proc/interrupts for
>> > the various kernel versions.
>>
>> I think Chinang does, but he's out of office today.  He did say in an
>> earlier reply:
>>
>> > I took a quick look at the interrupts figure between 2.6.24 and 2.6.27.
>> > i/o interuputs is slightly down in 2.6.27 (due to reduce throughput).
>> > But both NMI and reschedule interrupt increased.  Reschedule interrupts
>> > is 2x of 2.6.24.
>>
>> So if the reschedule interrupt is happening twice as often, and the
>> context switch rate is basically unchanged, I guess that means the
>> scheduler is doing a lot more work to get approximately the same
>> results.  And that seems like a bad thing.
>>
>> Again, it's worth bearing in mind that these are all RT tasks, so the
>> underlying problem may be very different from the one that both James and
>> I have observed with an Atom laptop running predominantly non-RT tasks.
>>
>
>The RT scheduler is a bit more aggressive than it use to be. It use to
>just migrate RT tasks when the migration thread woke up, and did that in
>"bulk".  Now, when an individual RT task wakes up and it can not run on
>the current CPU but can on another CPU, it is scheduled immediately, and
>an IPI is sent out.
>
>As for context switching, it would be the same amount as before, but the
>difference is that the RT task will try to wake up as soon as possible.
>This also causes RT tasks to bounce around CPUs more often.
>
>If there are many threads, they should not be RT, unless there is some
>design behind it.
>
>Forgive me if you already did this and said so, but what is the result
>of just making the writer an RT task and keeping all the readers as
>SCHED_OTHER?
>
>-- Steve
>

I think the high OLTP throughtput with rt-prio is due to the fixed time-slice. It is better to give DBMS process a bigger timeslice for getting a data buffer lock, process data, release the lock and switch out due to waiting on i/o instead of being force to switch out while still holding a data lock. 

I suppose SCHED_OTHER is the default policy for user processes. We tried setting only the log writer to RT and left all other DBMS orocess in default sched policy and the performance is ~1.5% lower than the all rt-prio process result.

