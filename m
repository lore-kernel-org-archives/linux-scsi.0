From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [v3.13][v3.14][Regression] kthread: make
	kthread_create()killable
Date: Mon, 17 Mar 2014 15:22:46 +0100
Message-ID: <20140317142246.GA27453@redhat.com>
References: <53236AA2.7030105@canonical.com> <201403150943.BIH30251.FOQLOOtFJHSMVF@I-love.SAKURA.ne.jp> <201403170013.GJF86930.FtVOOQOHLFFMSJ@I-love.SAKURA.ne.jp> <20140316162512.GA9467@redhat.com> <201403172138.GFB43278.OOOFFSQLVHJMtF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201403172138.GFB43278.OOOFFSQLVHJMtF@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, "James E.J. Bottomley" <JBottomley@parallels.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: rientjes@google.com, akpm@linux-foundation.org, joseph.salisbury@canonical.com, torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/17, Tetsuo Handa wrote:
>
> Oleg Nesterov wrote:
> >
> > Personally I really dislike this hack. And btw, why we return -ENOMEM if
> > SIGKILL'ed? Why not EINTR ?
>
> I chose -ENOMEM because -ENOMEM looked better for conveying that current thread
> was SIGKILLed by the OOM killer in order to solve no memory state. But I forgot
> that -ENOMEM will not convey the reason properly if current thread was
> SIGKILLed by other than the OOM killer. Maybe
>
>   return test_tsk_thread_flag(current, TIF_MEMDIE) ? -ENOMEM : -EINTR;
>
> rather than
>
>   return -ENOMEM;

Why complicate the things? Following this logic you can change you
can change almost every user of, say, fatal_signal_pending() to take
TIF_MEMDIE into account. For what? Just return -EINTR.

> > > Commit 786235ee "kthread: make kthread_create() killable" changed to
> > > leave kthread_create() as soon as receiving SIGKILL. But this change
> > > caused boot failures if systemd-udevd received SIGKILL (probably due
> > > to timeout) while loading SCSI controller drivers using
> > > finit_module() [1].
> >
> > Shouldn't we fix the caller instead? It should handle the error from
> > kthread_create() correctly.
> >
> > And could you tell who is the caller which doesn't do this? If it can't
> > be fixed, then, say, it can use workqueue to create a kernel thread.
> >
>
> There are many callers.

Who else? I mean, who else doesn't handle SIGKILL correctly ?

> One of them is scsi_host_alloc() which is called
> upon bootup in order to recognize SCSI storage devices.
>
> To my surprise, systemd-udevd process sends SIGKILL to worker systemd-udevd
> processes if they did not complete their jobs within 30 seconds. On some
> machines, it takes more than 30 seconds to recognize SCSI storage devices.
>
> On such machines, scsi_host_alloc() is called after the worker process
> received SIGKILL. Since commit 786235ee "kthread: make kthread_create()
> killable" broke all callers of kthread_create() who had been able to survive
> SIGKILL,

Well. I do not know if user-space should be blamed or not. But. The worker
process was killed, the kernel has all rights to check signal_pending() at
any moment and return to user-mode. Even if we change kthread_create() to
ignore SIGKILL it still can fail.

And probably there is a bug in the driver. IIUC, the probe hangs, the task
is killed after 30 seconds, I'd say it should not even call scsi_host_alloc()
in this case.


Lets look at https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1276705
I do not understand what happens and I know nothing about drivers, scsci,
but https://launchpadlibrarian.net/165067008/console.log shows

	[   36.539955] scsi4: error handler thread failed to spawn, error = -12

OK, scsi_host_alloc() fails. But it can fail due to another reason,

	[   36.552694] mptsas: ioc0: WARNING - Unable to register controller with SCSI subsystem

mptsas_probe() goes to out_mptsas_probe,

	[   36.569962] BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
	[   36.573954] IP: [<ffffffff8170fe52>] mutex_lock+0x12/0x2f
	[   36.573954] PGD 368dd067 PUD 368de067 PMD 0
	[   36.573954] Oops: 0002 [#1] SMP
	[   36.573954] Modules linked in: tg3 hid_generic ptp usbhid mptsas(+) mptscsih hid mptbase pps_core scsi_transport_sas
	[   36.573954] CPU: 1 PID: 130 Comm: systemd-udevd Not tainted 3.13.0-6-generic #23-Ubuntu
	[   36.573954] Hardware name: Dell Inc. PowerEdge R300/0TY179, BIOS 1.5.2 11/02/2010
	[   36.573954] task: ffff88003689b000 ti: ffff8800368e8000 task.ti: ffff8800368e8000
	[   36.573954] RIP: 0010:[<ffffffff8170fe52>]  [<ffffffff8170fe52>] mutex_lock+0x12/0x2f
	[   36.573954] RSP: 0018:ffff8800368e9b10  EFLAGS: 00010246
	[   36.573954] RAX: 0000000000000000 RBX: 0000000000000060 RCX: 0000000000000dac
	[   36.573954] RDX: 000000000000229c RSI: 00000000229e229c RDI: 0000000000000060
	[   36.573954] RBP: ffff8800368e9b18 R08: 0000000000000086 R09: 00000000000002ac
	[   36.573954] R10: ffffffff8185a460 R11: ffff8800368e98ae R12: 0000000000000060
	[   36.573954] R13: ffff880223c4b000 R14: ffff880223c4b098 R15: ffffffffa00953a0
	[   36.573954] FS:  00007f22a26a1880(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
	[   36.573954] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
	[   36.573954] CR2: 0000000000000060 CR3: 00000000368dc000 CR4: 00000000000407e0
	[   36.573954] Stack:
	[   36.573954]  0000000000000000 ffff8800368e9b40 ffffffff814c851d ffff880220153000
	[   36.573954]  0000000000000000 ffff880223c4b000 ffff8800368e9b70 ffffffffa007d2a1
	[   36.573954]  ffff880220153000 00000000ffffffff ffff880223c4b000 ffff880223c4b098
	[   36.573954] Call Trace:
	[   36.573954]  [<ffffffff814c851d>] scsi_remove_host+0x1d/0x120
	[   36.573954]  [<ffffffffa007d2a1>] mptscsih_remove+0x31/0xc0 [mptscsih]
	[   36.573954]  [<ffffffffa008f259>] mptsas_probe+0x419/0x5a0 [mptsas]

and why the error path should OOPS? I think this should be fixed?

> I think fixing this regression at kthread_create() is the appropriate
> response.

I still can't understand why do you think we should "fix" kthread_create().

> Given that said, which one do we prefer?
>
>   (a) Wait for completion forever after receiving SIGKILL, unless chosen
>       by the OOM killer.
>
>   (b) Wait for completion for only limited duration after receiving SIGKILL.

Personally I dislike both. It should either react to SIGKILL or not, in the
latter case it would be better to revert this patch, imho.

If we need the urgent hack to fix the regression, then I suggest to change
scsi_host_alloc() temporary until mptsas (or whatever) is fixed.

Oleg.

--- x/drivers/scsi/hosts.c
+++ x/drivers/scsi/hosts.c
@@ -447,8 +447,18 @@ struct Scsi_Host *scsi_host_alloc(struct
 	dev_set_name(&shost->shost_dev, "host%d", shost->host_no);
 	shost->shost_dev.groups = scsi_sysfs_shost_attr_groups;
 
-	shost->ehandler = kthread_run(scsi_error_handler, shost,
-			"scsi_eh_%d", shost->host_no);
+	/*
+	 * HUGE COMMENT. and kthread_create() needs s/ENOMEM/EINTR/.
+	 */
+	for (;;) {
+		shost->ehandler = kthread_run(scsi_error_handler, shost,
+						"scsi_eh_%d", shost->host_no);
+		if (!IS_ERR(shost->ehandler) || PTR_ERR(shost->ehandler) != -EINTR)
+			break;
+		clear_thread_flag(TIF_SIGPENDING);
+	}
+	recalc_sigpending();
+
 	if (IS_ERR(shost->ehandler)) {
 		printk(KERN_WARNING "scsi%d: error handler thread failed to spawn, error = %ld\n",
 			shost->host_no, PTR_ERR(shost->ehandler));
