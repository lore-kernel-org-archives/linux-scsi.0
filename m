From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: Re: please fix FUSION (Was: [v3.13][v3.14][Regression] kthread:makekthread_create()killable)
Date: Wed, 19 Mar 2014 17:04:55 -0400
Message-ID: <532A0677.4080501@canonical.com>
References: <20140316162512.GA9467@redhat.com> <201403172138.GFB43278.OOOFFSQLVHJMtF@I-love.SAKURA.ne.jp> <20140317142246.GA27453@redhat.com> <201403182103.BJC78148.tFOFHQOJLOMVSF@I-love.SAKURA.ne.jp> <20140318171620.GA10636@redhat.com> <201403192049.BBI39025.OVFMOOJtFSHFQL@I-love.SAKURA.ne.jp> <5329C22A.5070206@canonical.com> <20140319175253.GB11923@redhat.com> <20140319182910.GA14511@redhat.com> <20140319194232.GA6207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47814 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbaCSVFM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2014 17:05:12 -0400
In-Reply-To: <20140319194232.GA6207@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, JBottomley@parallels.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com, linux-scsi@vger.kernel.org

On 03/19/2014 03:42 PM, Oleg Nesterov wrote:
> On 03/19, Oleg Nesterov wrote:
>> On 03/19, Oleg Nesterov wrote:
>>> But please do not forget that the kernel crashes. Whatever else we do, this
>>> should be fixed anyway. And this should be fixed in driver.
>> drivers/message/fusion/ is obviously buggy.
> Perhaps this is the only problem and Tetsuo is right, this driver
> really needs more than 30 secs to probe...
>
> But if you have a bit of free time, perhaps you can try the stupid
> debugging patch below ;) Not sure it will help, but who knows.
>
> Oleg.
>
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index 00d339c..5ecc27e 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -5400,12 +5400,16 @@ mptsas_init(void)
>  {
>  	int error;
>  
> +	printk(KERN_CRIT "mptsas_init start\n");
> +	current->flags |= 0x1;
>  	show_mptmod_ver(my_NAME, my_VERSION);
>  
>  	mptsas_transport_template =
>  	    sas_attach_transport(&mptsas_transport_functions);
> -	if (!mptsas_transport_template)
> -		return -ENODEV;
> +	if (!mptsas_transport_template) {
> +		error = -ENODEV;
> +		goto out;
> +	}
>  	mptsas_transport_template->eh_timed_out = mptsas_eh_timed_out;
>  
>  	mptsasDoneCtx = mpt_register(mptscsih_io_done, MPTSAS_DRIVER,
> @@ -5428,6 +5432,9 @@ mptsas_init(void)
>  	if (error)
>  		sas_release_transport(mptsas_transport_template);
>  
> +out:
> +	current->flags &= ~0x1;
> +	printk(KERN_CRIT "mptsas_init end\n");
>  	return error;
>  }
>  
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index b5ae3ee..78e643d 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -291,6 +291,13 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
>  	 * the OOM killer while kthreadd is trying to allocate memory for
>  	 * new kernel thread.
>  	 */
> +
> +	if (current->flags & 1) {
> +		pr_crit("mptsas no killable wait: %d %d\n",
> +			signal_pending(current), __fatal_signal_pending(current));
> +		goto wait;
> +	}
> +
>  	if (unlikely(wait_for_completion_killable(&done))) {
>  		/*
>  		 * If I was SIGKILLed before kthreadd (or new kernel thread)
> @@ -303,6 +310,7 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
>  		 * kthreadd (or new kernel thread) will call complete()
>  		 * shortly.
>  		 */
> +wait:
>  		wait_for_completion(&done);
>  	}
>  	task = create->result;
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b46131e..2b202bd 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2655,6 +2655,14 @@ static void __sched __schedule(void)
>  	unsigned long *switch_count;
>  	struct rq *rq;
>  	int cpu;
> +	bool trace;
> +
> +	trace = (current->flags & 1) && current->state && !(preempt_count() & PREEMPT_ACTIVE);
> +	if (trace) {
> +		pr_crit("mptsas sched: %lx %d %d\n", current->state,
> +			signal_pending(current), __fatal_signal_pending(current));
> +		show_stack(NULL, NULL);
> +	}
>  
>  need_resched:
>  	preempt_disable();
> @@ -2733,6 +2741,11 @@ need_resched:
>  	sched_preempt_enable_no_resched();
>  	if (need_resched())
>  		goto need_resched;
> +
> +	if (trace) {
> +		pr_crit("mptsas wake: %d %d\n",
> +			signal_pending(current), __fatal_signal_pending(current));
> +	}
>  }
>  
>  static inline void sched_submit_work(struct task_struct *tsk)
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 52f881d..d121944 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1152,6 +1152,11 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  {
>  	int from_ancestor_ns = 0;
>  
> +	if (t->flags & 1) {
> +		pr_crit("mptsas killed %d\n", sig);
> +		sched_show_task(t);
> +	}
> +
>  #ifdef CONFIG_PID_NS
>  	from_ancestor_ns = si_fromuser(info) &&
>  			   !task_pid_nr_ns(current, task_active_pid_ns(t));
>
Thanks for the patch, Oleg.  I built a test kernel and asked the bug
reporter to test it [0].

[0] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1276705/comments/56
