From: Chris Mason <chris.mason@oracle.com>
Subject: RE: Mainline kernel OLTP performance update
Date: Mon, 19 Jan 2009 13:55:05 -0500
Message-ID: <1232391305.6521.146.camel@think.oraclecorp.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>
	 <20090114163557.11e097f2.akpm@linux-foundation.org>
	 <20090115012147.GW29283@parisc-linux.org>
	 <20090114180431.f4a96543.akpm@linux-foundation.org>
	 <1231986439.21980.54.camel@localhost.localdomain>
	 <BC02C49EEB98354DBA7F5DD76F2A9E80031752B166@azsmsx501.amr.corp.intel.com>
	 <1232388291.6521.140.camel@think.oraclecorp.com>
	 <1232390259.25783.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet14.oracle.com ([148.87.113.126]:64357 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbZASS6A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2009 13:58:00 -0500
Received: from rgminet13.oracle.com (rcsinet13.oracle.com [148.87.113.125])
	by rgminet14.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n0JIwsMw022009
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2009 19:00:29 GMT
In-Reply-To: <1232390259.25783.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Rostedt <srostedt@redhat.com>
Cc: "Ma, Chinang" <chinang.ma@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "arjan@linux.intel.com" <arjan@linux.intel.com>, "Kleen, Andi" <andi.kleen@intel.com>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>, "Chilukuri, Harita" <harita.chilukuri@intel.com>, "Styner, Douglas W" <douglas.w.styner@intel.com>, "Wang, Peter Xihong" <peter.xihong.wang@intel.com>, "Nueckel, Hubert" <hubert.nueckel@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>

On Mon, 2009-01-19 at 13:37 -0500, Steven Rostedt wrote:
> (added Rusty)
> 
> On Mon, 2009-01-19 at 13:04 -0500, Chris Mason wrote:
> > 
> > I think the -rt version of check_preempt_equal_prio has gotten much more
> > expensive since 2.6.24.
> > 
> > I'm sure these changes were made for good reasons, and this workload may
> > not be a good reason to change it back.  But, what does the patch below
> > do to performance on 2.6.29-rcX?
> > 
> > -chris
> > 
> > diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> > index 954e1a8..bbe3492 100644
> > --- a/kernel/sched_rt.c
> > +++ b/kernel/sched_rt.c
> > @@ -842,6 +842,7 @@ static void check_preempt_curr_rt(struct rq *rq,
> > struct task_struct *p, int sync
> >  		resched_task(rq->curr);
> >  		return;
> >  	}
> > +	return;
> >  
> >  #ifdef CONFIG_SMP
> >  	/*
> 
> That should not cause much of a problem if the scheduling task is not
> pinned to an CPU. But!!!!!
> 
> A recent change makes it expensive:


> +       if (!alloc_cpumask_var(&mask, GFP_ATOMIC))
>                 return;

> check_preempt_equal_prio is in a scheduling hot path!!!!!
> 
> WTF are we allocating there for?

I wasn't actually looking at the cost of the checks, even though they do
look higher (if they are using CONFIG_CPUMASK_OFFSTACK anyway).

The 2.6.24 code would trigger a rescheduling interrupt only when the
prio of the inbound task was higher than the running task.

This workload has a large number of equal priority rt tasks that are not
bound to a single CPU, and so I think it should trigger more
preempts/reschedules with the today's check_preempt_equal_prio().

-chris


