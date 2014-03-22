From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: please fix FUSION (Was:
	[v3.13][v3.14][Regression]kthread:makekthread_create()killable)
Date: Sat, 22 Mar 2014 20:25:11 +0100
Message-ID: <20140322192511.GA14811@redhat.com>
References: <20140319182910.GA14511@redhat.com> <20140319194232.GA6207@redhat.com> <532B1B67.5050104@canonical.com> <20140320192307.GA11883@redhat.com> <20140321183443.GA3891@redhat.com> <201403221525.FJC69759.MSLOtHOJOVFFQF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201403221525.FJC69759.MSLOtHOJOVFFQF@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: joseph.salisbury@canonical.com, JBottomley@parallels.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com, linux-scsi@vger.kernel.org, thenzl@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 03/22, Tetsuo Handa wrote:
>
> Oleg Nesterov wrote:
> > Tetsuo, what do you think?
>
> I don't like blocking SIGKILL while doing operations that depend on memory
> allocation by other processes. If the OOM killer is triggered and it chose
> the process blocking SIGKILL in mptsas_init() (I know it unlikely happens),
> it generates the OOM killer deadlock.

It seems that we do not understand each other.

I do not like this hack too. And it is even wrong, you can't really block
SIGKILL. And it is unnecessary in a sense that (I think) it is fine that
module_init() reacts to SIGKILL and aborts, just the fact it crashes the
kernel in the error paths is not fine.

The driver should be fixed anyway. As for timeout, either userspace/systemd
should be changed to not send SIGKILL after 30 secs, or (better) the driver
should be changed to not waste 30 secs.

The hack I sent can only serve as a short term solution, it should be
reverted once we have something better. And, otoh, this hack only affects
the problematic driver which should be fixed in any case.

Do you see my point? I can be wrong, but I think that you constantly
misunderstand the intent.

> My preference is to fix kthread_create() to handle SIGKILL gracefully.

And now I do not understand you too. I do not understand why should we
"fix" kthread_create().

> Many kernel operations (e.g. mutex_lock() wait_event() wait_for_completion())
> ignore SIGKILL and the current users depend on SIGKILL being ignored. Thus,
> commit 786235ee sounds like a kernel API breakage.

Personally I do not really think so, but OK. In this case lets revert
786235ee.

> Commit 786235ee "kthread: make kthread_create() killable" changed to
> leave kthread_create() as soon as receiving SIGKILL. But this change
> caused boot failures because systemd-udevd receives SIGKILL due to timeout
> while loading SCSI controller drivers using finit_module() [1].

And I still think that 786235ee simply uncovered the problems in this
driver. Perhaps we should change kthread_create() for some reason, but
(imho) not because we need to help the buggy code.

> Therefore, this patch changes kthread_create() from "wait forever in
> killable state" to "wait for 10 seconds in unkillable state, check for
> the OOM killer every second".

Personally I dislike this change. In fact I think it is ugly. But this
is only my opinion.

If you convince someone to take this patch I won't argue.


> This patch also changes the return value of timeout case from -ENOMEM
> to -EINTR because -ENOMEM could make sense for only TIF_MEMDIE case.
>
>   [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1276705
>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  kernel/kthread.c |   37 +++++++++++++++++++++----------------
>  1 files changed, 21 insertions(+), 16 deletions(-)
>
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index b5ae3ee..6a25a9f 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -269,6 +269,7 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
>  					   const char namefmt[],
>  					   ...)
>  {
> +	int i = 0;
>  	DECLARE_COMPLETION_ONSTACK(done);
>  	struct task_struct *task;
>  	struct kthread_create_info *create = kmalloc(sizeof(*create),
> @@ -287,24 +288,28 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
>
>  	wake_up_process(kthreadd_task);
>  	/*
> -	 * Wait for completion in killable state, for I might be chosen by
> -	 * the OOM killer while kthreadd is trying to allocate memory for
> -	 * new kernel thread.
> +	 * Wait for completion with 10 seconds timeout. Unless the kthreadd is
> +	 * blocked for direct memory reclaim path, the kthreadd will be able to
> +	 * complete the request within 10 seconds. Also, check every second if
> +	 * I was chosen by the OOM killer in order to avoid the OOM killer
> +	 * deadlock.
>  	 */
> -	if (unlikely(wait_for_completion_killable(&done))) {
> -		/*
> -		 * If I was SIGKILLed before kthreadd (or new kernel thread)
> -		 * calls complete(), leave the cleanup of this structure to
> -		 * that thread.
> -		 */
> -		if (xchg(&create->done, NULL))
> -			return ERR_PTR(-ENOMEM);
> -		/*
> -		 * kthreadd (or new kernel thread) will call complete()
> -		 * shortly.
> -		 */
> -		wait_for_completion(&done);
> +	do {
> +		if (likely(wait_for_completion_timeout(&done, HZ)))
> +			goto ready;
> +	} while (i++ < 10 && !test_thread_flag(TIF_MEMDIE));
> +	/*
> +	 * The kthreadd was unable to complete the request within 10 seconds
> +	 * (or I was chosen by the OOM killer). Thus, give up and leave the
> +	 * cleanup of this structure to the kthreadd (or new kernel thread).
> +	 */
> +	if (xchg(&create->done, NULL)) {
> +		WARN(1, "Gave up waiting for kthreadd.\n");
> +		return ERR_PTR(-EINTR);
>  	}
> +	/* kthreadd (or new kernel thread) will call complete() shortly. */
> +	wait_for_completion(&done);
> +ready:
>  	task = create->result;
>  	if (!IS_ERR(task)) {
>  		static const struct sched_param param = { .sched_priority = 0 };
> --
> 1.7.1
