From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [v3.13][v3.14][Regression] kthread:
	makekthread_create()killable
Date: Tue, 18 Mar 2014 18:16:20 +0100
Message-ID: <20140318171620.GA10636@redhat.com>
References: <201403150943.BIH30251.FOQLOOtFJHSMVF@I-love.SAKURA.ne.jp> <201403170013.GJF86930.FtVOOQOHLFFMSJ@I-love.SAKURA.ne.jp> <20140316162512.GA9467@redhat.com> <201403172138.GFB43278.OOOFFSQLVHJMtF@I-love.SAKURA.ne.jp> <20140317142246.GA27453@redhat.com> <201403182103.BJC78148.tFOFHQOJLOMVSF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201403182103.BJC78148.tFOFHQOJLOMVSF@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: JBottomley@parallels.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, rientjes@google.com, akpm@linux-foundation.org, joseph.salisbury@canonical.com, torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/18, Tetsuo Handa wrote:
>
> Oleg Nesterov wrote:
> > If we need the urgent hack to fix the regression, then I suggest to change
> > scsi_host_alloc() temporary until mptsas (or whatever) is fixed.
>
> Device initialization taking longer than 30 seconds is possible and is not a
> hang up. It is systemd which needs to be fixed.

Perhaps systemd needs the fix too, I do not know. But this is irrelevant,
I think. Or at least this should be discussed separately.

kthread_run() can fail anyway, mptsas_probe() should not crash the kernel.

And btw, it is not clear to me if in this case device initialization really
needs more than 30 seconds... My understanding is probably wrong, so please
correct me. But it seems that before your "make kthread_create() killable"

	- probe hangs

	- SIGKILL wakes it up

	- so I assume that the probe was interrupted and didn't finish
	  correctly ???

	- initialization continues, does scsi_host_alloc(), etc, and
	  everything works fine even if probe was interrupted?

So perhaps that probe should not hang and this should be fixed too ?
Do you know where exactly it hangs? And where it is woken up by SIGKILL ?
Or I totally misunderstood ?

> > --- x/drivers/scsi/hosts.c
> > +++ x/drivers/scsi/hosts.c
> > @@ -447,8 +447,18 @@ struct Scsi_Host *scsi_host_alloc(struct
> >  	dev_set_name(&shost->shost_dev, "host%d", shost->host_no);
> >  	shost->shost_dev.groups = scsi_sysfs_shost_attr_groups;
> >
> > -	shost->ehandler = kthread_run(scsi_error_handler, shost,
> > -			"scsi_eh_%d", shost->host_no);
> > +	/*
> > +	 * HUGE COMMENT. and kthread_create() needs s/ENOMEM/EINTR/.
> > +	 */
> > +	for (;;) {
> > +		shost->ehandler = kthread_run(scsi_error_handler, shost,
> > +						"scsi_eh_%d", shost->host_no);
> > +		if (!IS_ERR(shost->ehandler) || PTR_ERR(shost->ehandler) != -EINTR)
> > +			break;
> > +		clear_thread_flag(TIF_SIGPENDING);
> > +	}
> > +	recalc_sigpending();
> > +
> >  	if (IS_ERR(shost->ehandler)) {
> >  		printk(KERN_WARNING "scsi%d: error handler thread failed to spawn, error = %ld\n",
> >  			shost->host_no, PTR_ERR(shost->ehandler));
> >
> >
>
> I think we need a bit different version, in order to take TIF_MEMDIE flag into
> account at the caller of kthread_create(), for the purpose of commit 786235ee
> is "try to die as soon as possible if chosen by the OOM killer".
>
> 	for (;;) {
> 		shost->ehandler = kthread_run(scsi_error_handler, shost,
> 					      "scsi_eh_%d", shost->host_no);
> 		if (PTR_ERR(shost->ehandler) != -EINTR ||
> 		    test_thread_flag(TIF_MEMDIE))

Well, personally I do not care about TIF_MEMDIE/oom at all. We need the
temporary hack (unless we have the "right" fix right now) which should be
reverted later.

>   (1) Changing return code from -ENOMEM to -EINTR may not be sufficient.

You mean, in kthread_create() ? And, sufficient for what?

>       If kmalloc(GFP_KERNEL) in kthread_create_on_node() does something that
>       calls recalc_sigpending(),

firstly, it should not. And almost every caller of recalc_sigpending() outside
of core signal code is wrong.

> TIF_SIGPENDING will be set on the second call
>       to kthread_run(). This will make wait_for_completion_killable() return
>       -EINTR immediately because the second call to kthread_run() happens only
>       when current thread already received SIGKILL (by other than the OOM
>       killer). This may form an infinite busy loop.

Not sure I understand... Yes, wait_for_completion_killable() can return
immediately if TIF_SIGPENDING will be set again for any reason. Say, another
signal. But the next iteration will clear TIF_SIGPENDING ?

>      As I think it is difficult to prove that kmalloc(GFP_KERNEL) never sets
>      TIF_SIGPENDING flag

Ah, I see, you mean that kmalloc() can do this every time. No, this should
not happen or we have another problem.

In any case. My only point is that the regression should be fixed here, imho.
And just in case, let me repeat that the code above is the dirty temporary hack.
I won't insist on the ugly TIF_SIGPENDING games, say, we can use workqueue.

>   (2) I don't like scattering around test_thread_flag(TIF_MEMDIE),
>       might be other drivers who receive SIGKILL by systemd's 30 seconds
>       timeout.

Can't understand this part too... and it was you who suggested to check
TIF_MEMDIE.

Anyway. I agree with any hack in scsi_host_alloc/etc, this is up to
maintainers. I still think that your change uncovered the problems in
drivers/message/fusion/, these problems should be fixed somehow.

Dear maintainers, we need your help.

Oleg.
