From: Takashi TAKATORI <MXE02152@nifty.com>
Subject: kernel oops on the kernel with 'fix race conditions in SCSI/Block leading to oops' patch.
Date: Thu, 16 Jun 2011 21:07:31 +0900
Message-ID: <201106161207.p5GC7cX8003727@msag502.nifty.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sv1.nifty.com ([220.209.183.60]:48379 "EHLO
	defg302.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab1FPMTM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2011 08:19:12 -0400
Received: from msag502.nifty.com (msag502p.nifty.com [172.22.128.253])by defg302.nifty.com with ESMTP id p5GC8RUZ021954
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2011 21:08:27 +0900
Received: from nifty.com (p8058-ipbfp03kobeminato.hyogo.ocn.ne.jp [125.200.195.58]) (authenticated)
	by msag502.nifty.com with ESMTP id p5GC7cX8003727
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2011 21:07:38 +0900
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm using kernel-2.6.33.7 and rt-patch(patch-2.6.33.7.2-rt30).
My first problem is a very rare occurrence, the kernel stops during boot sequence.(the log at the bottom of this mail)

I found a similar issue.

https://bugzilla.kernel.org/show_bug.cgi?id=33802

So I patched followings for work around boot time hung-up.

https://patchwork.kernel.org/patch/705411/
https://patchwork.kernel.org/patch/750832/

After that, oops occurred insted of hung-up.

---
[<c042d64a>] ? kmsg_dump+0xe2/0xec
[<c08ae43c>] oops_end+0x7a/0x81
[<c04188ca>] no_context+0x113/0x11d
[<c04189c8>] __bad_area_nosemaphore+0xef/0xf7
[<c04189dd>] bad_area_nosemaphore+0x12/0x15
[<c08af92a>] do_page_fault+0x1e7/0x359
[<c08af743>] ? do_page_fault+0x0/0x359
[<c08adb8f>] error_code+0x73/0x78
[<c041edaa>] ? task_rq_lock+0x31/0x72
[<c04269b2>] try_to_wake_up+0x29/0x334
[<c0426d35>] ? wake_up_process+0x3/0x18
[<c0430928>] ? wakeup_softirq+0x2d/0x2f
[<c0465108>] ? ftrace_list_func+0x18/0x28
[<c0426d48>] wake_up_process+0x16/0x18
[<c0430928>] wakeup_softirqd+0x2d/0x2f
[<c043094b>] trigger_softirqs+0x21/0x2c
[<c04318f7>] __do_softirq+0x1b8/0x1c0
[<c0431903>] ? do_softirq+0x4/0x30
[<c04319b5>] ? irq_exit+0x31/0x6e
[<c0465108>] ? ftrace_list_func+0x18/0x28
[<c043192a>] do_softirq+0x2b/0x30
[<c04319b5>] irq_exit+0x31/0x6e
[<c0413089>] smp_apic_timer_interrupt+0x74/0x82
[<c08ad925>] apic_timer_interrupt+0x31/0x38
[<c04076c6>] ? mwait_idle+0x9a/0xa0
[<c0401518>] cpu_idle+0x6f/0x9e
[<c0880a59>] rest_init+0x85/0x87
[<c0b2f735>] start_kernel+0x314/0x319
[<c0b2f092>] i386_start_kernel+0x92/0x99
---
(Sorry, I didn't log serial console. So I typed messages on the screen.)

I'm afraid I need any other patch(es). (and your helps)

Would you please give me some advice?

ttaka

---

The log of boot time hung-up is here.

=============================================
[ INFO: possible recursive locking detected ]
2.6.33.7.2-rt30 #56
---------------------------------------------
kblockd/0/39 is trying to acquire lock:
 ((&q->unplug_work)){+.+...}, at: [<c0441916>] __cancel_work_timer+0x81/0x12f

but task is already holding lock:
 ((&q->unplug_work)){+.+...}, at: [<c044172d>] worker_thread+0x1e9/0x318

other info that might help us debug this:
2 locks held by kblockd/0/39:
 #0:  (kblockd){+.+...}, at: [<c044172d>] worker_thread+0x1e9/0x318
 #1:  ((&q->unplug_work)){+.+...}, at: [<c044172d>] worker_thread+0x1e9/0x318

stack backtrace:
Pid: 39, comm: kblockd/0 Not tainted 2.6.33.7.2-rt30 #56
 sda:Call Trace:
 [<c08c20da>] ? printk+0x14/0x16
 [<c045452a>] __lock_acquire+0xc4e/0x1381
 [<c045564d>] ? mark_held_locks+0x41/0x5d
 [<c046e633>] ? function_profile_call+0xe8/0xf2
 [<c0441916>] ? __cancel_work_timer+0x81/0x12f
 [<c04550d1>] lock_acquire+0xac/0xc5
 [<c0441916>] ? __cancel_work_timer+0x81/0x12f
 [<c044192d>] __cancel_work_timer+0x98/0x12f
 [<c0441916>] ? __cancel_work_timer+0x81/0x12f
 [<c04419e5>] cancel_work_sync+0xf/0x11
 [<c05bf9ca>] blk_sync_queue+0x2c/0x2f
 [<c05bf9de>] blk_cleanup_queue+0x11/0x48
 [<c066d7fb>] scsi_free_queue+0xd/0xf
 [<c066ff21>] scsi_device_dev_release_usercontext+0x10b/0x144
 [<c066fe16>] ? scsi_device_dev_release_usercontext+0x0/0x144
 [<c0441506>] execute_in_process_context+0x22/0x60
 [<c066fe14>] scsi_device_dev_release+0x18/0x1a
 [<c064a123>] device_release+0x3a/0x62
 [<c05d076d>] kobject_release+0x40/0x50
 [<c05d072d>] ? kobject_release+0x0/0x50
 [<c05d1400>] kref_put+0x39/0x42
 [<c05d06b9>] kobject_put+0x37/0x3c
 [<c0649cde>] put_device+0x14/0x16
 [<c066d099>] scsi_request_fn+0x322/0x3e3
 [<c05c2523>] __generic_unplug_device+0x2e/0x31
 [<c05c2748>] generic_unplug_device+0x26/0x34
 [<c05bd5b4>] blk_unplug_work+0x56/0x5a
 [<c0441772>] worker_thread+0x22e/0x318
 [<c044172d>] ? worker_thread+0x1e9/0x318
 [<c05bd55e>] ? blk_unplug_work+0x0/0x5a
 [<c0444d51>] ? autoremove_wake_function+0x0/0x34
 [<c0441544>] ? worker_thread+0x0/0x318
 [<c04449b9>] kthread+0x64/0x69
 [<c0444955>] ? kthread+0x0/0x69
 [<c0444955>] ? kthread+0x0/0x69
 [<c0402d82>] kernel_thread_helper+0x6/0x10

