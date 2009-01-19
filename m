From: Ingo Molnar <mingo@elte.hu>
Subject: Re: Mainline kernel OLTP performance update
Date: Tue, 20 Jan 2009 00:40:59 +0100
Message-ID: <20090119234059.GA452@elte.hu>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com> <20090114163557.11e097f2.akpm@linux-foundation.org> <20090115012147.GW29283@parisc-linux.org> <20090114180431.f4a96543.akpm@linux-foundation.org> <1231986439.21980.54.camel@localhost.localdomain> <BC02C49EEB98354DBA7F5DD76F2A9E80031752B166@azsmsx501.amr.corp.intel.com> <1232388291.6521.140.camel@think.oraclecorp.com> <1232390259.25783.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:44115 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbZASXl6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2009 18:41:58 -0500
Content-Disposition: inline
In-Reply-To: <1232390259.25783.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Mason <chris.mason@oracle.com>, "Ma, Chinang" <chinang.ma@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "arjan@linux.intel.com" <arjan@linux.intel.com>, "Kleen, Andi" <andi.kleen@intel.com>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>, "Chilukuri, Harita" <harita.chilukuri@intel.com>, "Styner, Douglas W" <douglas.w.styner@intel.com>, "Wang, Peter Xihong" <peter.xihong.wang@intel.com>, "Nueckel, Hubert" <hubert.nueckel@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>


* Steven Rostedt <srostedt@redhat.com> wrote:

> (added Rusty)
> 
> On Mon, 2009-01-19 at 13:04 -0500, Chris Mason wrote:
> > On Thu, 2009-01-15 at 00:11 -0700, Ma, Chinang wrote:
> > > >> > > > >
> > > >> > > > > Linux OLTP Performance summary
> > > >> > > > > Kernel#            Speedup(x)   Intr/s  CtxSw/s us%  sys%   idle%
> > > >iowait%
> > > >> > > > > 2.6.24.2                1.000   21969   43425   76   24     0
> > > >0
> > > >> > > > > 2.6.27.2                0.973   30402   43523   74   25     0
> > > >1
> > > >> > > > > 2.6.29-rc1              0.965   30331   41970   74   26     0
> > > >0
> > > >> >
> > > >> > > But the interrupt rate went through the roof.
> > > >> >
> > > >> > Yes.  I forget why that was; I'll have to dig through my archives for
> > > >> > that.
> > > >>
> > > >> Oh.  I'd have thought that this alone could account for 3.5%.
> > 
> > A later email indicated the reschedule interrupt count doubled since
> > 2.6.24, and so I poked around a bit at the causes of resched_task.
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
> 
> commit 24600ce89a819a8f2fb4fd69fd777218a82ade20
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Tue Nov 25 02:35:13 2008 +1030
> 
>     sched: convert check_preempt_equal_prio to cpumask_var_t.
>     
>     Impact: stack reduction for large NR_CPUS
> 
> 
> 
> which has:
> 
>  static void check_preempt_equal_prio(struct rq *rq, struct task_struct
> *p)
>  {
> -       cpumask_t mask;
> +       cpumask_var_t mask;
>  
>         if (rq->curr->rt.nr_cpus_allowed == 1)
>                 return;
>  
> -       if (p->rt.nr_cpus_allowed != 1
> -           && cpupri_find(&rq->rd->cpupri, p, &mask))
> +       if (!alloc_cpumask_var(&mask, GFP_ATOMIC))
>                 return;
> 
> 
> 
> 
> check_preempt_equal_prio is in a scheduling hot path!!!!!
> 
> WTF are we allocating there for?

Agreed - this needs to be fixed. Since this runs under the runqueue lock 
we can have a temporary cpumask in the runqueue itself, not on the stack.

	Ingo
