From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Kernel 4.8.4: INFO: task kworker/u16:8:289 blocked for more
 than 120 seconds.
Date: Sun, 23 Oct 2016 23:36:57 -0700
Message-ID: <1477291017.19735.26.camel@haakon3.risingtidesystems.com>
References: <0f72bb4a-3cdf-ffd0-db75-5c8b303b921c@mdevsys.com>
         <64ef386e-8de2-0b1c-9322-f02530a3e783@mdevsys.com>
         <0851dba9-ad6c-c419-dc92-93c5d7d2f54a@mdevsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35371 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757085AbcJXGhJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2016 02:37:09 -0400
In-Reply-To: <0851dba9-ad6c-c419-dc92-93c5d7d2f54a@mdevsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: TomK <tk@mdevsys.com>
Cc: linux-scsi@vger.kernel.org, Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>

Hi TomK,

Thanks for reporting this bug.  Comments inline below.

On Mon, 2016-10-24 at 00:45 -0400, TomK wrote:
> On 10/24/2016 12:32 AM, TomK wrote:
> > On 10/23/2016 10:03 PM, TomK wrote:
> >> Hey,
> >>
> >> Has anyone seen this and could have a workaround?  Seems like it is more
> >> Kernel related with various apps not just target apparently not but
> >> wondering if there is an interim solution
> >> (https://access.redhat.com/solutions/408833)
> >>
> >> Getting this message after few minutes of usage from the QLA2xxx driver.
> >>  This is after some activity on an ESXi server (15 VM's) that I'm
> >> connecting to this HBA.  I've tried the following tuning parameters but
> >> there was no change in behaviour:
> >>
> >> vm.dirty_background_ratio = 5
> >> vm.dirty_ratio = 10
> >>
> >> Details:
> >>
> >>
> >> Oct 23 21:28:25 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
> >> Oct 23 21:28:29 mbpc-pc kernel: ABORT_TASK: Found referenced qla2xxx
> >> task_tag: 1128612
> >> Oct 23 21:28:42 mbpc-pc kernel: ABORT_TASK: Sending
> >> TMR_FUNCTION_COMPLETE for ref_tag: 1128612
> >> Oct 23 21:28:42 mbpc-pc kernel: ABORT_TASK: Found referenced qla2xxx
> >> task_tag: 1129116

You are likely hitting a known v4.1+ regression, not yet merged up to
v4.8.y code:

https://github.com/torvalds/linux/commit/527268df31e57cf2b6d417198717c6d6afdb1e3e

> >> Jan  6 23:52:00 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon
> >> successfully started
> >> Oct 23 21:30:18 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
> >> Jan  6 23:54:01 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon
> >> successfully started
> >> Oct 23 21:32:16 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
> >> Oct 23 21:32:24 mbpc-pc kernel: INFO: task kworker/u16:8:289 blocked for
> >> more than 120 seconds.
> >> Oct 23 21:32:24 mbpc-pc kernel:      Not tainted 4.8.4 #2
> >> Oct 23 21:32:24 mbpc-pc kernel: "echo 0 >
> >> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> Oct 23 21:32:24 mbpc-pc kernel: kworker/u16:8   D ffff88011113ba18     0
> >>   289      2 0x00000000
> >> Oct 23 21:32:24 mbpc-pc kernel: Workqueue: tmr-fileio target_tmr_work
> >> [target_core_mod]
> >> Oct 23 21:32:24 mbpc-pc kernel: ffff88011113ba18 0000000000000400
> >> ffff880049e926c0 ffff88011113b998
> >> Oct 23 21:32:24 mbpc-pc kernel: ffff880111134600 ffffffff81f99ca0
> >> ffffffff81f998ef ffff880100000000
> >> Oct 23 21:32:24 mbpc-pc kernel: ffffffff812f27d9 0000000000000000
> >> ffffe8ffffc9a000 ffff880000000000
> >> Oct 23 21:32:24 mbpc-pc kernel: Call Trace:
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff812f27d9>] ? number+0x2e9/0x310
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162c040>] schedule+0x40/0xb0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81080169>] ?
> >> start_flush_work+0x49/0x180
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162e7ec>]
> >> schedule_timeout+0x9c/0xe0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810802ba>] ?
> >> flush_work+0x1a/0x40
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810bd15c>] ?
> >> console_unlock+0x35c/0x380
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162cfa0>]
> >> wait_for_completion+0xc0/0xf0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810923e0>] ?
> >> try_to_wake_up+0x260/0x260
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa08f6f84>]
> >> __transport_wait_for_tasks+0xb4/0x1b0 [target_core_mod]
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810bdd1f>] ?
> >> vprintk_default+0x1f/0x30
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8115cc5c>] ? printk+0x46/0x48
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa08f70c4>]
> >> transport_wait_for_tasks+0x44/0x60 [target_core_mod]
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa08f46e2>]
> >> core_tmr_abort_task+0xf2/0x160 [target_core_mod]
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa08f6aa4>]
> >> target_tmr_work+0x154/0x160 [target_core_mod]
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81080639>]
> >> process_one_work+0x189/0x4e0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8108150d>]
> >> worker_thread+0x16d/0x520
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810923f2>] ?
> >> default_wake_function+0x12/0x20
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810a6f06>] ?
> >> __wake_up_common+0x56/0x90
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810813a0>] ?
> >> maybe_create_worker+0x110/0x110
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810813a0>] ?
> >> maybe_create_worker+0x110/0x110
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8109130e>] ?
> >> schedule_tail+0x1e/0xc0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162f60f>]
> >> ret_from_fork+0x1f/0x40
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81085f20>] ?
> >> kthread_freezable_should_stop+0x70/0x70
> >> Oct 23 21:32:24 mbpc-pc kernel: INFO: task kworker/1:48:6089 blocked for
> >> more than 120 seconds.
> >> Oct 23 21:32:24 mbpc-pc kernel:      Not tainted 4.8.4 #2
> >> Oct 23 21:32:24 mbpc-pc kernel: "echo 0 >
> >> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> Oct 23 21:32:24 mbpc-pc kernel: kworker/1:48    D ffff88004017f968     0
> >>  6089      2 0x00000080
> >> Oct 23 21:32:24 mbpc-pc kernel: Workqueue: events qlt_free_session_done
> >> [qla2xxx]
> >> Oct 23 21:32:24 mbpc-pc kernel: ffff88004017f968 ffff88004017f8f8
> >> ffff88011a83a300 0000000000000004
> >> Oct 23 21:32:24 mbpc-pc kernel: ffff88004017a600 ffff88004017f938
> >> ffffffff810a0bb6 ffff880100000000
> >> Oct 23 21:32:24 mbpc-pc kernel: ffff880110fd0840 ffff880000000000
> >> ffffffff81090728 ffff880100000000
> >> Oct 23 21:32:24 mbpc-pc kernel: Call Trace:
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810a0bb6>] ?
> >> enqueue_task_fair+0x66/0x410
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81090728>] ?
> >> check_preempt_curr+0x78/0x90
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8109075d>] ?
> >> ttwu_do_wakeup+0x1d/0xf0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162c040>] schedule+0x40/0xb0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81090de0>] ?
> >> ttwu_queue+0x180/0x190
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162e7ec>]
> >> schedule_timeout+0x9c/0xe0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162cfa0>]
> >> wait_for_completion+0xc0/0xf0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810923e0>] ?
> >> try_to_wake_up+0x260/0x260
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa08f76ad>]
> >> target_wait_for_sess_cmds+0x4d/0x1b0 [target_core_mod]
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa00e7188>] ?
> >> qla2x00_post_work+0x58/0x70 [qla2xxx]
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa0286f69>]
> >> tcm_qla2xxx_free_session+0x49/0x90 [tcm_qla2xxx]
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa01447e9>]
> >> qlt_free_session_done+0xf9/0x3d0 [qla2xxx]
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff815092fc>] ?
> >> dbs_work_handler+0x5c/0x90
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8107f960>] ?
> >> pwq_dec_nr_in_flight+0x50/0xa0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81080639>]
> >> process_one_work+0x189/0x4e0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810d060c>] ?
> >> del_timer_sync+0x4c/0x60
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8108131e>] ?
> >> maybe_create_worker+0x8e/0x110
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8108150d>]
> >> worker_thread+0x16d/0x520
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810923f2>] ?
> >> default_wake_function+0x12/0x20
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810a6f06>] ?
> >> __wake_up_common+0x56/0x90
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810813a0>] ?
> >> maybe_create_worker+0x110/0x110
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810813a0>] ?
> >> maybe_create_worker+0x110/0x110
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8109130e>] ?
> >> schedule_tail+0x1e/0xc0
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162f60f>]
> >> ret_from_fork+0x1f/0x40
> >> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81085f20>] ?
> >> kthread_freezable_should_stop+0x70/0x70
> >> Jan  6 23:56:00 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon
> >> successfully started
> >> Oct 23 21:34:22 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
> >> Oct 23 21:34:22 mbpc-pc kernel: hpet1: lost 3 rtc interrupts
> >> Oct 23 21:34:27 mbpc-pc kernel: INFO: task kworker/u16:8:289 blocked for
> >> more than 120 seconds.
> >> Oct 23 21:34:27 mbpc-pc kernel:      Not tainted 4.8.4 #2
> >> Oct 23 21:34:27 mbpc-pc kernel: "echo 0 >
> >> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> Oct 23 21:34:27 mbpc-pc kernel: kworker/u16:8   D ffff88011113ba18     0
> >>   289      2 0x00000000
> >> Oct 23 21:34:27 mbpc-pc kernel: Workqueue: tmr-fileio target_tmr_work
> >> [target_core_mod]
> >> Oct 23 21:34:27 mbpc-pc kernel: ffff88011113ba18 0000000000000400
> >> ffff880049e926c0 ffff88011113b998
> >> Oct 23 21:34:27 mbpc-pc kernel: ffff880111134600 ffffffff81f99ca0
> >> ffffffff81f998ef ffff880100000000
> >> Oct 23 21:34:27 mbpc-pc kernel: ffffffff812f27d9 0000000000000000
> >> ffffe8ffffc9a000 ffff880000000000
> >> Oct 23 21:34:27 mbpc-pc kernel: Call Trace:
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff812f27d9>] ? number+0x2e9/0x310
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162c040>] schedule+0x40/0xb0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81080169>] ?
> >> start_flush_work+0x49/0x180
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162e7ec>]
> >> schedule_timeout+0x9c/0xe0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810802ba>] ?
> >> flush_work+0x1a/0x40
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810bd15c>] ?
> >> console_unlock+0x35c/0x380
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162cfa0>]
> >> wait_for_completion+0xc0/0xf0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810923e0>] ?
> >> try_to_wake_up+0x260/0x260
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa08f6f84>]
> >> __transport_wait_for_tasks+0xb4/0x1b0 [target_core_mod]
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810bdd1f>] ?
> >> vprintk_default+0x1f/0x30
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8115cc5c>] ? printk+0x46/0x48
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa08f70c4>]
> >> transport_wait_for_tasks+0x44/0x60 [target_core_mod]
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa08f46e2>]
> >> core_tmr_abort_task+0xf2/0x160 [target_core_mod]
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa08f6aa4>]
> >> target_tmr_work+0x154/0x160 [target_core_mod]
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81080639>]
> >> process_one_work+0x189/0x4e0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8108150d>]
> >> worker_thread+0x16d/0x520
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810923f2>] ?
> >> default_wake_function+0x12/0x20
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810a6f06>] ?
> >> __wake_up_common+0x56/0x90
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810813a0>] ?
> >> maybe_create_worker+0x110/0x110
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810813a0>] ?
> >> maybe_create_worker+0x110/0x110
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8109130e>] ?
> >> schedule_tail+0x1e/0xc0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162f60f>]
> >> ret_from_fork+0x1f/0x40
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81085f20>] ?
> >> kthread_freezable_should_stop+0x70/0x70
> >> Oct 23 21:34:27 mbpc-pc kernel: INFO: task kworker/1:48:6089 blocked for
> >> more than 120 seconds.
> >> Oct 23 21:34:27 mbpc-pc kernel:      Not tainted 4.8.4 #2
> >> Oct 23 21:34:27 mbpc-pc kernel: "echo 0 >
> >> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> Oct 23 21:34:27 mbpc-pc kernel: kworker/1:48    D ffff88004017f968     0
> >>  6089      2 0x00000080
> >> Oct 23 21:34:27 mbpc-pc kernel: Workqueue: events qlt_free_session_done
> >> [qla2xxx]
> >> Oct 23 21:34:27 mbpc-pc kernel: ffff88004017f968 ffff88004017f8f8
> >> ffff88011a83a300 0000000000000004
> >> Oct 23 21:34:27 mbpc-pc kernel: ffff88004017a600 ffff88004017f938
> >> ffffffff810a0bb6 ffff880100000000
> >> Oct 23 21:34:27 mbpc-pc kernel: ffff880110fd0840 ffff880000000000
> >> ffffffff81090728 ffff880100000000
> >> Oct 23 21:34:27 mbpc-pc kernel: Call Trace:
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810a0bb6>] ?
> >> enqueue_task_fair+0x66/0x410
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81090728>] ?
> >> check_preempt_curr+0x78/0x90
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8109075d>] ?
> >> ttwu_do_wakeup+0x1d/0xf0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162c040>] schedule+0x40/0xb0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81090de0>] ?
> >> ttwu_queue+0x180/0x190
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162e7ec>]
> >> schedule_timeout+0x9c/0xe0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162cfa0>]
> >> wait_for_completion+0xc0/0xf0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810923e0>] ?
> >> try_to_wake_up+0x260/0x260
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa08f76ad>]
> >> target_wait_for_sess_cmds+0x4d/0x1b0 [target_core_mod]
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa00e7188>] ?
> >> qla2x00_post_work+0x58/0x70 [qla2xxx]
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa0286f69>]
> >> tcm_qla2xxx_free_session+0x49/0x90 [tcm_qla2xxx]
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa01447e9>]
> >> qlt_free_session_done+0xf9/0x3d0 [qla2xxx]
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff815092fc>] ?
> >> dbs_work_handler+0x5c/0x90
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8107f960>] ?
> >> pwq_dec_nr_in_flight+0x50/0xa0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81080639>]
> >> process_one_work+0x189/0x4e0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810d060c>] ?
> >> del_timer_sync+0x4c/0x60
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8108131e>] ?
> >> maybe_create_worker+0x8e/0x110
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8108150d>]
> >> worker_thread+0x16d/0x520
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810923f2>] ?
> >> default_wake_function+0x12/0x20
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810a6f06>] ?
> >> __wake_up_common+0x56/0x90
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810813a0>] ?
> >> maybe_create_worker+0x110/0x110
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810813a0>] ?
> >> maybe_create_worker+0x110/0x110
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8109130e>] ?
> >> schedule_tail+0x1e/0xc0
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162f60f>]
> >> ret_from_fork+0x1f/0x40
> >> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81085f20>] ?
> >> kthread_freezable_should_stop+0x70/0x70
> >> Oct 23 21:36:04 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
> >> Oct 23 21:36:04 mbpc-pc kernel: hpet1: lost 3 rtc interrupts
> >> Jan  6 23:58:00 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon
> >> successfully started
> >> Oct 23 21:36:30 mbpc-pc kernel: INFO: task kworker/u16:8:289 blocked for
> >> more than 120 seconds.
> >> Oct 23 21:36:30 mbpc-pc kernel:      Not tainted 4.8.4 #2
> >> Oct 23 21:36:30 mbpc-pc kernel: "echo 0 >
> >> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> Oct 23 21:36:30 mbpc-pc kernel: kworker/u16:8   D ffff88011113ba18     0
> >>   289      2 0x00000000
> >> Oct 23 21:36:30 mbpc-pc kernel: Workqueue: tmr-fileio target_tmr_work
> >> [target_core_mod]
> >> Oct 23 21:36:30 mbpc-pc kernel: ffff88011113ba18 0000000000000400
> >> ffff880049e926c0 ffff88011113b998
> >> Oct 23 21:36:30 mbpc-pc kernel: ffff880111134600 ffffffff81f99ca0
> >> ffffffff81f998ef ffff880100000000
> >> Oct 23 21:36:30 mbpc-pc kernel: ffffffff812f27d9 0000000000000000
> >> ffffe8ffffc9a000 ffff880000000000
> >> Oct 23 21:36:30 mbpc-pc kernel: Call Trace:
> >> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff812f27d9>] ? number+0x2e9/0x310
> >> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff8162c040>] schedule+0x40/0xb0
> >> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff81080169>] ?
> >> start_flush_work+0x49/0x180
> >> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff8162e7ec>]
> >> schedule_timeout+0x9c/0xe0
> >> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff810802ba>] ?
> >> flush_work+0x1a/0x40
> >> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff810bd15c>] ?
> >> console_unlock+0x35c/0x380
> >> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff8162cfa0>]
> >> wait_for_completion+0xc0/0xf0
> >> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff810923e0>] ?
> >> try_to_wake_up+0x260/0x260
> >> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffffa08f6f84>]
> >> __transport_wait_for_tasks+0xb4/0x1b0 [target_core_mod]
> >> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff810bdd1f>] ?
> >> vprintk_default+0x1f/0x30
> >>
> >>
> >
> >
> > Including the full log:
> >
> > http://microdevsys.com/linux-lio/messages-mailing-list
> >
> 

Thanks for posting with qla2xxx verbose debug enabled on your setup.

> 
> When tryint to shut down target using /etc/init.d/target stop, the 
> following is printed repeatedly:
> 
> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e837:20: 
> ABTS_RECV_24XX: instance 0
> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f811:20: 
> qla_target(0): task abort (s_id=1:5:0, tag=1177068, param=0)
> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f812:20: 
> qla_target(0): task abort for non-existant session
> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f80e:20: 
> Scheduling work (type 1, prm ffff880093365680) to find session for param 
> ffff88010f8c7680 (size 64, tgt ffff880111f06600)
> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f800:20: Sess 
> work (tgt ffff880111f06600)
> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e806:20: Sending 
> task mgmt ABTS response (ha=ffff88010fae0000, atio=ffff880093365694, 
> status=4
> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e838:20: 
> ABTS_RESP_24XX: compl_status 31
> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e807:20: Sending 
> retry TERM EXCH CTIO7 (ha=ffff88010fae0000)
> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e806:20: Sending 
> task mgmt ABTS response (ha=ffff88010fae0000, atio=ffff88010f8c76c0, 
> status=0
> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e838:20: 
> ABTS_RESP_24XX: compl_status 0
> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:20: 
> qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 029c
> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-3861:20: New 
> command while device ffff880111f06600 is shutting down
> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e859:20: 
> qla_target: Unable to send command to target for req, ignoring.
> 
> 

At your earliest convenience, please verify the patch using v4.8.y with
the above ABORT_TASK + shutdown scenario.

Also, it would be helpful to understand why this ESX FC host is
generating ABORT_TASKs.

Eg: Is ABORT_TASK generated due to FC target response packet loss..?
Or due to target backend I/O latency, that ultimately triggers FC host
side timeouts...?

> 
> + when I disable the ports on the brocade switch that we're using then 
> try to stop target, the following is printed:
> 
> 
> 
> Oct 24 00:41:31 mbpc-pc kernel: qla2xxx [0000:04:00.1]-680a:21: Loop 
> down - seconds remaining 231.
> Oct 24 00:41:32 mbpc-pc kernel: qla2xxx [0000:04:00.0]-680a:20: Loop 
> down - seconds remaining 153.
> Oct 24 00:41:32 mbpc-pc kernel: ------------[ cut here ]------------
> Oct 24 00:41:32 mbpc-pc kernel: WARNING: CPU: 2 PID: 8615 at 
> lib/list_debug.c:33 __list_add+0xbe/0xd0
> Oct 24 00:41:32 mbpc-pc kernel: list_add corruption. prev->next should 
> be next (ffff88009e83b330), but was ffff88011fc972a0. 
> (prev=ffff880118ada4c0).
> Oct 24 00:41:32 mbpc-pc kernel: Modules linked in: tcm_qla2xxx tcm_fc 
> tcm_loop target_core_file target_core_iblock target_core_pscsi 
> target_core_mod configfs ip6table_filter ip6_tables ebtable_nat ebtables 
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_CHECKSUM 
> iptable_mangle bridge nfsd lockd grace nfs_acl auth_rpcgss autofs4 it87 
> hwmon_vid bnx2fc cnic uio fcoe libfcoe libfc 8021q garp stp llc ppdev 
> parport_pc parport sunrpc cpufreq_ondemand bonding ipv6 crc_ccitt 
> ipt_REJECT nf_reject_ipv4 xt_multiport iptable_filter ip_tables fuse 
> vfat fat xfs vhost_net macvtap macvlan vhost tun uinput raid456 
> async_raid6_recov async_pq async_xor xor async_memcpy async_tx raid6_pq 
> libcrc32c joydev sg serio_raw e1000 kvm_amd kvm irqbypass r8169 mii 
> pcspkr k10temp snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel 
> snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm 
> snd_timer snd soundcore i2c_piix4 i2c_core wmi acpi_cpufreq shpchp ext4 
> mbcache jbd2 qla2xxx scsi_transport_fc floppy firewire_ohci f
> Oct 24 00:41:32 mbpc-pc kernel: irewire_core crc_itu_t sd_mod pata_acpi 
> ata_generic pata_jmicron ahci libahci usb_storage dm_mirror 
> dm_region_hash dm_log dm_mod
> Oct 24 00:41:32 mbpc-pc kernel: CPU: 2 PID: 8615 Comm: kworker/2:3 Not 
> tainted 4.8.4 #2
> Oct 24 00:41:32 mbpc-pc kernel: Hardware name: Gigabyte Technology Co., 
> Ltd. GA-890XA-UD3/GA-890XA-UD3, BIOS FC 08/02/2010
> Oct 24 00:41:32 mbpc-pc kernel: 0000000000000000 ffff880092b83b48 
> ffffffff812e88e9 ffffffff8130753e
> Oct 24 00:41:32 mbpc-pc kernel: ffff880092b83ba8 ffff880092b83ba8 
> 0000000000000000 ffff880092b83b98
> Oct 24 00:41:32 mbpc-pc kernel: ffffffff81066a7d ffff88000058f952 
> 0000002100000046 ffffffff8101eae8
> Oct 24 00:41:32 mbpc-pc kernel: Call Trace:
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff812e88e9>] dump_stack+0x51/0x78
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8130753e>] ? __list_add+0xbe/0xd0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81066a7d>] __warn+0xfd/0x120
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8101eae8>] ? 
> __switch_to+0x398/0x7e0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81066b59>] 
> warn_slowpath_fmt+0x49/0x50
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8130753e>] __list_add+0xbe/0xd0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8107d0b2>] 
> move_linked_works+0x62/0x90
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8108070c>] 
> process_one_work+0x25c/0x4e0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8108150d>] 
> worker_thread+0x16d/0x520
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162bb3d>] ? 
> __schedule+0x2fd/0x6a0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810923f2>] ? 
> default_wake_function+0x12/0x20
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810a6f06>] ? 
> __wake_up_common+0x56/0x90
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810813a0>] ? 
> maybe_create_worker+0x110/0x110
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810813a0>] ? 
> maybe_create_worker+0x110/0x110
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8109130e>] ? 
> schedule_tail+0x1e/0xc0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162f60f>] ret_from_fork+0x1f/0x40
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81085f20>] ? 
> kthread_freezable_should_stop+0x70/0x70
> Oct 24 00:41:32 mbpc-pc kernel: ---[ end trace 713a9071c9f5f464 ]---
> Oct 24 00:41:32 mbpc-pc kernel: ------------[ cut here ]------------
> Oct 24 00:41:32 mbpc-pc kernel: WARNING: CPU: 2 PID: 8615 at 
> lib/list_debug.c:36 __list_add+0x9c/0xd0
> Oct 24 00:41:32 mbpc-pc kernel: list_add double add: 
> new=ffff880118ada4c0, prev=ffff880118ada4c0, next=ffff88009e83b330.
> Oct 24 00:41:32 mbpc-pc kernel: Modules linked in: tcm_qla2xxx tcm_fc 
> tcm_loop target_core_file target_core_iblock target_core_pscsi 
> target_core_mod configfs ip6table_filter ip6_tables ebtable_nat ebtables 
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_CHECKSUM 
> iptable_mangle bridge nfsd lockd grace nfs_acl auth_rpcgss autofs4 it87 
> hwmon_vid bnx2fc cnic uio fcoe libfcoe libfc 8021q garp stp llc ppdev 
> parport_pc parport sunrpc cpufreq_ondemand bonding ipv6 crc_ccitt 
> ipt_REJECT nf_reject_ipv4 xt_multiport iptable_filter ip_tables fuse 
> vfat fat xfs vhost_net macvtap macvlan vhost tun uinput raid456 
> async_raid6_recov async_pq async_xor xor async_memcpy async_tx raid6_pq 
> libcrc32c joydev sg serio_raw e1000 kvm_amd kvm irqbypass r8169 mii 
> pcspkr k10temp snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel 
> snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm 
> snd_timer snd soundcore i2c_piix4 i2c_core wmi acpi_cpufreq shpchp ext4 
> mbcache jbd2 qla2xxx scsi_transport_fc floppy firewire_ohci f
> Oct 24 00:41:32 mbpc-pc kernel: irewire_core crc_itu_t sd_mod pata_acpi 
> ata_generic pata_jmicron ahci libahci usb_storage dm_mirror 
> dm_region_hash dm_log dm_mod
> Oct 24 00:41:32 mbpc-pc kernel: CPU: 2 PID: 8615 Comm: kworker/2:3 
> Tainted: G        W       4.8.4 #2
> Oct 24 00:41:32 mbpc-pc kernel: Hardware name: Gigabyte Technology Co., 
> Ltd. GA-890XA-UD3/GA-890XA-UD3, BIOS FC 08/02/2010
> Oct 24 00:41:32 mbpc-pc kernel: 0000000000000000 ffff880092b83b48 
> ffffffff812e88e9 ffffffff8130751c
> Oct 24 00:41:32 mbpc-pc kernel: ffff880092b83ba8 ffff880092b83ba8 
> 0000000000000000 ffff880092b83b98
> Oct 24 00:41:32 mbpc-pc kernel: ffffffff81066a7d ffff88000058f952 
> 0000002400000046 ffffffff8101eae8
> Oct 24 00:41:32 mbpc-pc kernel: Call Trace:
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff812e88e9>] dump_stack+0x51/0x78
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8130751c>] ? __list_add+0x9c/0xd0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81066a7d>] __warn+0xfd/0x120
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8101eae8>] ? 
> __switch_to+0x398/0x7e0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81066b59>] 
> warn_slowpath_fmt+0x49/0x50
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8130751c>] __list_add+0x9c/0xd0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8107d0b2>] 
> move_linked_works+0x62/0x90
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8108070c>] 
> process_one_work+0x25c/0x4e0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8108150d>] 
> worker_thread+0x16d/0x520
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162bb3d>] ? 
> __schedule+0x2fd/0x6a0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810923f2>] ? 
> default_wake_function+0x12/0x20
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810a6f06>] ? 
> __wake_up_common+0x56/0x90
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810813a0>] ? 
> maybe_create_worker+0x110/0x110
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810813a0>] ? 
> maybe_create_worker+0x110/0x110
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8109130e>] ? 
> schedule_tail+0x1e/0xc0
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162f60f>] ret_from_fork+0x1f/0x40
> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81085f20>] ? 
> kthread_freezable_should_stop+0x70/0x70
> Oct 24 00:41:32 mbpc-pc kernel: ---[ end trace 713a9071c9f5f465 ]---
> Oct 24 00:41:32 mbpc-pc kernel: qla2xxx [0000:04:00.1]-680a:21: Loop 
> down - seconds remaining 230.
> Oct 24 00:41:33 mbpc-pc kernel: qla2xxx [0000:04:00.0]-680a:20: Loop 
> down - seconds remaining 152.
> 
> 

Mmmm.  Could be a side effect of the target-core regression, but not
completely sure..

Adding QLOGIC folks CC'.

