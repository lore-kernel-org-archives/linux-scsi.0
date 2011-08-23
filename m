From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [kernel.org users] [KORG] Panics on master backend
Date: Tue, 23 Aug 2011 16:32:53 -0500
Message-ID: <1314135173.14326.42.camel@mulgrave>
References: <4E53ECEF.7040109@kernel.org>  <1314129133.8002.102.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50879 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840Ab1HWVdD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2011 17:33:03 -0400
In-Reply-To: <1314129133.8002.102.camel@twins>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "J.H." <warthog9@kernel.org>, users@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Frank Rowand <frank.rowand@am.sony.com>, "yong.zhang0" <yong.zhang0@gmail.com>, mingo@kernel.org, Jens Axboe <jaxboe@fusionio.com>, Thomas Gleixner <tglx@linutronix.de>, scameron@beardog.cce.hp.com, hch <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

Cc: linux-scsi added 

On Tue, 2011-08-23 at 21:52 +0200, Peter Zijlstra wrote:
> On Tue, 2011-08-23 at 11:09 -0700, J.H. wrote:
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.702389]  <<EOE>>  <IRQ>  [<ffffffff81049469>] try_to_wake_up+0x89/0x1ca
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.709536]  [<ffffffff810495d3>] ? wake_up_process+0x15/0x17
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.715422]  [<ffffffff810495bc>] default_wake_function+0x12/0x14
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.721659]  [<ffffffff8103d165>] __wake_up_common+0x4e/0x84
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.727489]  [<ffffffffa0177066>] ? _xfs_buf_ioend+0x2f/0x36 [xfs]
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.733852]  [<ffffffff810428b0>] complete+0x3f/0x52
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.738985]  [<ffffffffa0177017>] xfs_buf_ioend+0xc2/0xe2 [xfs]
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.745079]  [<ffffffffa0177066>] _xfs_buf_ioend+0x2f/0x36 [xfs]
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.751259]  [<ffffffffa017727a>] xfs_buf_bio_end_io+0x2a/0x37 [xfs]
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.757758]  [<ffffffff8114f684>] bio_endio+0x2d/0x2f
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.762945]  [<ffffffff81229cd1>] req_bio_endio.clone.31+0x9e/0xa7
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.772811]  [<ffffffff81229e6b>] blk_update_request+0x191/0x32e
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.782563]  [<ffffffff8122a029>] blk_update_bidi_request+0x21/0x6d
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.792529]  [<ffffffff8122a180>] blk_end_bidi_request+0x1f/0x5d
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.802230]  [<ffffffff8122a1f8>] blk_end_request+0x10/0x12
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.811446]  [<ffffffff81313300>] scsi_io_completion+0x1e2/0x4d8
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.821002]  [<ffffffff814d47e7>] ? _raw_spin_unlock_irqrestore+0x17/0x19
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.831405]  [<ffffffff8130bf80>] scsi_finish_command+0xe8/0xf1
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.840948]  [<ffffffff8131305f>] scsi_softirq_done+0x109/0x112
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.850485]  [<ffffffff8122e3c8>] blk_done_softirq+0x73/0x87
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.859729]  [<ffffffff8105757a>] __do_softirq+0xc9/0x1b6
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.868705]  [<ffffffff81014e01>] ? paravirt_read_tsc+0x9/0xd
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.878093]  [<ffffffff814dd2ac>] call_softirq+0x1c/0x30
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.887025]  [<ffffffff81010c5e>] do_softirq+0x46/0x84
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.895767]  [<ffffffff81057849>] irq_exit+0x52/0xaf
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.904246]  [<ffffffff814ddc21>] smp_apic_timer_interrupt+0x7c/0x8a
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.914171]  [<ffffffff814dbb1e>] apic_timer_interrupt+0x6e/0x80
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.923618]  <EOI>  [<ffffffff81080526>] ? arch_local_irq_restore+0x6/0xd
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.933756]  [<ffffffff814d47e7>] _raw_spin_unlock_irqrestore+0x17/0x19
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.943630]  [<ffffffffa00446c4>] hpsa_scsi_queue_command+0x2f9/0x319 [hpsa]
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.953851]  [<ffffffff8130c9bb>] scsi_dispatch_cmd+0x18c/0x251
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.962917]  [<ffffffff81312d70>] scsi_request_fn+0x3cd/0x3f9
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.971781]  [<ffffffff81225214>] __blk_run_queue+0x1b/0x1d
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.980439]  [<ffffffff8123b637>] cfq_insert_request+0x4cf/0x504
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.989469]  [<ffffffff812248d4>] __elv_add_request+0x19c/0x1e7
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.998481]  [<ffffffff8122a934>] blk_flush_plug_list+0x166/0x19b
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.007670]  [<ffffffff814d2ce4>] schedule+0x2a3/0x6dc
> > 20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.015903]  [<ffffffff814d35e1>] schedule_timeout+0x36/0xe3 
> 
> Whee, you must be real 'lucky' to hit this so reliable.
> 
> Both panics included the above bit, so what I think happens is that we
> release rq->lock while calling that blk_flush_plug muck, it however then
> goes and re-enabled interrupts *FAIL*
> 
> An interrupts happens and it (or in fact a pending softirq) then tries
> to wake the current task which is in the process of going to sleep.
> Since the task is still on the cpu we spin until its gone (assuming its
> a remote task since interrupts aren't supposed to happen here).
> 
> Now I can fudge around this, see below, but really the whole
> block/scsi/hpsa crap should *NOT* re-enable interrupts here.
> 
> It looks like the offender is:
> 
> scsi_request_fn(), which does:
> 
>                 /*
>                  * XXX(hch): This is rather suboptimal, scsi_dispatch_cmd will
>                  *              take the lock again.
>                  */
>                 spin_unlock_irq(shost->host_lock);

Um, that one looks like a mistake missed in cleanup (probably years
ago).   The other host_lock acquisitions aren't _irq, so this one
shouldn't be either.  I can patch it up (or you can).

James


> 
> 
> ---
>  kernel/sched.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ccacdbd..30d9788 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2630,7 +2630,6 @@ static void ttwu_queue_remote(struct task_struct *p, int cpu)
>  		smp_send_reschedule(cpu);
>  }
>  
> -#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
>  static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
>  {
>  	struct rq *rq;
> @@ -2647,7 +2646,6 @@ static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
>  	return ret;
>  
>  }
> -#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
>  #endif /* CONFIG_SMP */
>  
>  static void ttwu_queue(struct task_struct *p, int cpu)
> @@ -2705,7 +2703,6 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  	 * this task as prev, wait until its done referencing the task.
>  	 */
>  	while (p->on_cpu) {
> -#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
>  		/*
>  		 * In case the architecture enables interrupts in
>  		 * context_switch(), we cannot busy wait, since that
> @@ -2713,11 +2710,11 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  		 * tries to wake up @prev. So bail and do a complete
>  		 * remote wakeup.
>  		 */
> -		if (ttwu_activate_remote(p, wake_flags))
> +		if (cpu == smp_processor_id() && 
> +				ttwu_activate_remote(p, wake_flags))
>  			goto stat;
> -#else
> +
>  		cpu_relax();
> -#endif
>  	}
>  	/*
>  	 * Pairs with the smp_wmb() in finish_lock_switch().


