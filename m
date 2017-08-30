From: "Byungchul Park" <byungchul.park@lge.com>
Subject: RE: possible circular locking dependency detected [was: linux-next: Tree for Aug 22]
Date: Wed, 30 Aug 2017 17:53:23 +0900
Message-ID: <004501d3216d$703bde80$50b39b80$@lge.com>
References: <20170822183816.7925e0f8@canb.auug.org.au> <20170822104708.GA491@jagdpanzerIV.localdomain> <1503438234.2508.27.camel@wdc.com> <20170823000304.GK20323@X58A-UD3R> <20170830052037.GA432@jagdpanzerIV.localdomain> <20170830054334.GF3240@X58A-UD3R> <20170830061511.GA330@jagdpanzerIV.localdomain> <20170830084207.GL32112@worktop.programming.kicks-ass.net> <20170830084746.GC660@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20170830084746.GC660@worktop.programming.kicks-ass.net>
Content-Language: ko
Sender: linux-next-owner@vger.kernel.org
To: 'Peter Zijlstra' <peterz@infradead.org>, 'Sergey Senozhatsky' <sergey.senozhatsky.work@gmail.com>
Cc: 'Bart Van Assche' <Bart.VanAssche@wdc.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, martin.petersen@oracle.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, sfr@canb.auug.org.au, linux-next@vger.kernel.org, kernel-team@lge.com
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Wednesday, August 30, 2017 5:48 PM
> To: Sergey Senozhatsky
> Cc: Byungchul Park; Bart Van Assche; linux-kernel@vger.kernel.org; linux-
> block@vger.kernel.org; martin.petersen@oracle.com; axboe@kernel.dk; linux-
> scsi@vger.kernel.org; sfr@canb.auug.org.au; linux-next@vger.kernel.org;
> kernel-team@lge.com
> Subject: Re: possible circular locking dependency detected [was: linux-
> next: Tree for Aug 22]
> 
> On Wed, Aug 30, 2017 at 10:42:07AM +0200, Peter Zijlstra wrote:
> >
> > So the overhead looks to be spread out over all sorts, which makes it
> > harder to find and fix.
> >
> > stack unwinding is done lots and is fairly expensive, I've not yet
> > checked if crossrelease does too much of that.
> 
> Aah, we do an unconditional stack unwind for every __lock_acquire() now.
> It keeps a trace in the xhlocks[].

Yeah.. I also think this is most significant..

> 
> Does the below cure most of that overhead?
> 
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index 44c8d0d17170..7b872036b72e 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -4872,7 +4872,7 @@ static void add_xhlock(struct held_lock *hlock)
>  	xhlock->trace.max_entries = MAX_XHLOCK_TRACE_ENTRIES;
>  	xhlock->trace.entries = xhlock->trace_entries;
>  	xhlock->trace.skip = 3;
> -	save_stack_trace(&xhlock->trace);
> +	/* save_stack_trace(&xhlock->trace); */
>  }
> 
>  static inline int same_context_xhlock(struct hist_lock *xhlock)
