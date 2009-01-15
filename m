From: "Ma, Chinang" <chinang.ma@intel.com>
Subject: RE: Mainline kernel OLTP performance update
Date: Thu, 15 Jan 2009 00:11:51 -0700
Message-ID: <BC02C49EEB98354DBA7F5DD76F2A9E80031752B166@azsmsx501.amr.corp.intel.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>
	 <20090114163557.11e097f2.akpm@linux-foundation.org>
	 <20090115012147.GW29283@parisc-linux.org>
	 <20090114180431.f4a96543.akpm@linux-foundation.org>
 <1231986439.21980.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:21985 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbZAOHL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 02:11:59 -0500
In-Reply-To: <1231986439.21980.54.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Rostedt <srostedt@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "arjan@linux.intel.com" <arjan@linux.intel.com>, "Kleen, Andi" <andi.kleen@intel.com>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>, "Chilukuri, Harita" <harita.chilukuri@intel.com>, "Styner, Douglas W" <douglas.w.styner@intel.com>, "Wang, Peter Xihong" <peter.xihong.wang@intel.com>, "Nueckel, Hubert" <hubert.nueckel@intel.com>, "chris.mason@oracle.com" <chris.mason@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Gregory Haskins <ghaskins@nove>

Trying to answer to some of the question below:

-Chinang

>-----Original Message-----
>From: Steven Rostedt [mailto:srostedt@redhat.com]
>Sent: Wednesday, January 14, 2009 6:27 PM
>To: Andrew Morton
>Cc: Matthew Wilcox; Wilcox, Matthew R; Ma, Chinang; linux-
>kernel@vger.kernel.org; Tripathi, Sharad C; arjan@linux.intel.com; Kleen,
>Andi; Siddha, Suresh B; Chilukuri, Harita; Styner, Douglas W; Wang, Peter
>Xihong; Nueckel, Hubert; chris.mason@oracle.com; linux-scsi@vger.kernel.org;
>Andrew Vasquez; Anirban Chakraborty; Ingo Molnar; Thomas Gleixner; Peter
>Zijlstra; Gregory Haskins
>Subject: Re: Mainline kernel OLTP performance update
>
>(added Ingo, Thomas, Peter and Gregory)
>
>On Wed, 2009-01-14 at 18:04 -0800, Andrew Morton wrote:
>> On Wed, 14 Jan 2009 18:21:47 -0700 Matthew Wilcox <matthew@wil.cx> wrote:
>>
>> > On Wed, Jan 14, 2009 at 04:35:57PM -0800, Andrew Morton wrote:
>> > > On Tue, 13 Jan 2009 15:44:17 -0700
>> > > "Wilcox, Matthew R" <matthew.r.wilcox@intel.com> wrote:
>> > > >
>> > >
>> > > (top-posting repaired.  That @intel.com address is a bad influence ;))
>> >
>> > Alas, that email address goes to an Outlook client.  Not much to be
>done
>> > about that.
>>
>> aspirin?
>>
>> > > (cc linux-scsi)
>> > >
>> > > > > This is latest 2.6.29-rc1 kernel OLTP performance result. Compare
>to
>> > > > > 2.6.24.2 the regression is around 3.5%.
>> > > > >
>> > > > > Linux OLTP Performance summary
>> > > > > Kernel#            Speedup(x)   Intr/s  CtxSw/s us%  sys%   idle%
>iowait%
>> > > > > 2.6.24.2                1.000   21969   43425   76   24     0
>0
>> > > > > 2.6.27.2                0.973   30402   43523   74   25     0
>1
>> > > > > 2.6.29-rc1              0.965   30331   41970   74   26     0
>0
>> >
>> > > But the interrupt rate went through the roof.
>> >
>> > Yes.  I forget why that was; I'll have to dig through my archives for
>> > that.
>>
>> Oh.  I'd have thought that this alone could account for 3.5%.
>>
>> > > A 3.5% slowdown in this workload is considered pretty serious, isn't
>it?
>> >
>> > Yes.  Anything above 0.3% is statistically significant.  1% is a big
>> > deal.  The fact that we've lost 3.5% in the last year doesn't make
>> > people happy.  There's a few things we've identified that have a big
>> > effect:
>> >
>> >  - Per-partition statistics.  Putting in a sysctl to stop doing them
>gets
>> >    some of that back, but not as much as taking them out (even when
>> >    the sysctl'd variable is in a __read_mostly section).  We tried a
>> >    patch from Jens to speed up the search for a new partition, but it
>> >    had no effect.
>>
>> I find this surprising.
>>
>> >  - The RT scheduler changes.  They're better for some RT tasks, but not
>> >    the database benchmark workload.  Chinang has posted about
>> >    this before, but the thread didn't really go anywhere.
>> >    http://marc.info/?t=122903815000001&r=1&w=2
>
>I read the whole thread before I found what you were talking about here:
>
>http://marc.info/?l=linux-kernel&m=122937424114658&w=2
>
>With this comment:
>
>"When setting foreground and log writer to rt-prio, the log latency reduced
>to 4.8ms. \
>Performance is about 1.5% higher than the CFS result.
>On a side note, we had been using rt-prio on all DBMS processes and log
>writer ( in \
>higher priority) for the best OLTP performance. That has worked pretty well
>until \
>2.6.25 when the new rt scheduler introduced the pull/push task for lower
>scheduling \
>latency for rt-task. That has negative impact on this workload, probably
>due to the \
>more elaborated load calculation/balancing for hundred of foreground rt-
>prio \
>processes. Also, there is that question of no production environment would
>run DBMS \
>with rt-prio. That is why I am going back to explore CFS and see whether I
>can drop \
>rt-prio for good."
>

>A couple of questions:
>
>1) how does the latest rt scheduler compare?  There has been a lot of
>improvements.

It is difficult for me to isolate the recent rt scheduler improvement as so many other changes were introduced to the kernel at the same time. A more accurate comparison should just revert the rt-scheduler back to the previous version and test the delta. I am not sure how to get that done. 

>2) how many rt tasks?   
	Around 250 rt tasks.

>3) what were the prios, producer compared to consumers, not actual numbers
	I suppose the single log writer is the main producer (rt-prio 49, higheset rt-prio in this workload) which wake up all foreground process when the log write is done. The 240 foreground processes are the consumer (rt-prio 48). At any given time some number of the 240 foreground was waiting for log writer to finish flushing out the log data.

>4) have you tried pinning tasks?
>
We did try pin foreground rt-process to cpu. That recovered about 1% performance but introduce idle time in some cpu. Without load balancing, my solution is to pin more processes to the idle cpu. I don't think this is a practical solution for the idle time problem as the process distribution need to be adjusted again when upgrade to a different server. 

>RT is more about determinism than performance. The old scheduler
>migrated rt tasks the same as other tasks. This helps with performance
>because it will keep several rt tasks on the same CPU and cache hot even
>when a rt task can migrate. This helps performance, but kills
>determinism (I was seeing 10 ms wake up times from the next-highest-prio
>task on a cpu, even when another CPU was available).
>
>If you pin a task to a cpu, then it skips over the push and pull logic
>and will help with performance too.
>
>-- Steve
>
>
>
>>
>> Well.  It's more a case that it wasn't taken anywhere.  I appear to
>> have recently been informed that there have never been any
>> CPU-scheduler-caused regressions.  Please persist!
>>
>> > SLUB would have had a huge negative effect if we were using it -- on
>the
>> > order of 7% iirc.  SLQB is at least performance-neutral with SLAB.
>>
>> We really need to unblock that problem somehow.  I assume that
>> enterprise distros are shipping slab?
>>

