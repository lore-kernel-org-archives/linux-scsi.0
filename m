From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [v3.13][v3.14][Regression] kthread:makekthread_create()killable
Date: Wed, 19 Mar 2014 20:49:25 +0900
Message-ID: <201403192049.BBI39025.OVFMOOJtFSHFQL@I-love.SAKURA.ne.jp>
References: <20140316162512.GA9467@redhat.com>
	<201403172138.GFB43278.OOOFFSQLVHJMtF@I-love.SAKURA.ne.jp>
	<20140317142246.GA27453@redhat.com>
	<201403182103.BJC78148.tFOFHQOJLOMVSF@I-love.SAKURA.ne.jp>
	<20140318171620.GA10636@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:62330 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602AbaCSLtb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2014 07:49:31 -0400
In-Reply-To: <20140318171620.GA10636@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: oleg@redhat.com, joseph.salisbury@canonical.com
Cc: JBottomley@parallels.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com, linux-scsi@vger.kernel.org

Oleg Nesterov wrote:
> > > If we need the urgent hack to fix the regression, then I suggest to change
> > > scsi_host_alloc() temporary until mptsas (or whatever) is fixed.
> >
> > Device initialization taking longer than 30 seconds is possible and is not a
> > hang up. It is systemd which needs to be fixed.
> 
> Perhaps systemd needs the fix too, I do not know. But this is irrelevant,
> I think. Or at least this should be discussed separately.

I confirmed that this problem goes away if systemd-udevd supports longer
timeout.

> 
> kthread_run() can fail anyway, mptsas_probe() should not crash the kernel.

Right. But mptsas_probe() triggering an OOPS is irrelevant to kthread_run()
( comment #27 ).

> 
> And btw, it is not clear to me if in this case device initialization really
> needs more than 30 seconds... My understanding is probably wrong, so please
> correct me. But it seems that before your "make kthread_create() killable"
> 
> 	- probe hangs
> 
> 	- SIGKILL wakes it up
> 
> 	- so I assume that the probe was interrupted and didn't finish
> 	  correctly ???
> 
> 	- initialization continues, does scsi_host_alloc(), etc, and
> 	  everything works fine even if probe was interrupted?
> 

I confirmed that device initialization really took more than 30 seconds
( comments #51 and #52 ).

> So perhaps that probe should not hang and this should be fixed too ?
> Do you know where exactly it hangs? And where it is woken up by SIGKILL ?
> Or I totally misunderstood ?

The probe did not hang. SIGKILL affected only wait_for_completion_killable()
in kthread_create_on_node() called by mptsas_probe() via scsi_host_alloc().
Thus, the probe was interrupted because kthread_run() returned an error.

> > I think we need a bit different version, in order to take TIF_MEMDIE flag into
> > account at the caller of kthread_create(), for the purpose of commit 786235ee
> > is "try to die as soon as possible if chosen by the OOM killer".
> >
> > 	for (;;) {
> > 		shost->ehandler = kthread_run(scsi_error_handler, shost,
> > 					      "scsi_eh_%d", shost->host_no);
> > 		if (PTR_ERR(shost->ehandler) != -EINTR ||
> > 		    test_thread_flag(TIF_MEMDIE))
> 
> Well, personally I do not care about TIF_MEMDIE/oom at all. We need the
> temporary hack (unless we have the "right" fix right now) which should be
> reverted later.

I do seriously care about TIF_MEMDIE/oom. Last week I respond to a trouble
which hit "kernel: request_module() OOM local DoS" (RHBZ #853474) without
any malice.

> Not sure I understand... Yes, wait_for_completion_killable() can return
> immediately if TIF_SIGPENDING will be set again for any reason. Say, another
> signal. But the next iteration will clear TIF_SIGPENDING ?
> 
> >      As I think it is difficult to prove that kmalloc(GFP_KERNEL) never sets
> >      TIF_SIGPENDING flag
> 
> Ah, I see, you mean that kmalloc() can do this every time. No, this should
> not happen or we have another problem.

Then, what happens if somebody does

  while (1)
      kill(pid, SIGKILL);

where pid is the process calling kthread_run() from the "for (;;)" loop in
scsi_host_alloc()? Theoretically, it will form an infinite retry loop.
Clearing TIF_SIGPENDING does not guarantee that next
wait_for_completion_killable() does not return immediately.
Doing retry decision at scsi_host_alloc() will make things worse than
doing it at kthread_create_on_node().

> Anyway. I agree with any hack in scsi_host_alloc/etc, this is up to
> maintainers. I still think that your change uncovered the problems in
> drivers/message/fusion/, these problems should be fixed somehow.
> 
> Dear maintainers, we need your help.
> 

Right. We found that we can fix this problem by updating systemd-udevd to
support longer timeout ( comment #53 ). Joseph, would you consult systemd
maintainers?
