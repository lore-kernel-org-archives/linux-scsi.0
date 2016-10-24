From: TomK <tk@mdevsys.com>
Subject: Re: Kernel 4.8.4: INFO: task kworker/u16:8:289 blocked for more than
 120 seconds.
Date: Mon, 24 Oct 2016 00:32:39 -0400
Message-ID: <64ef386e-8de2-0b1c-9322-f02530a3e783@mdevsys.com>
References: <0f72bb4a-3cdf-ffd0-db75-5c8b303b921c@mdevsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:56614 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757132AbcJXEcp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 00:32:45 -0400
Received: from [192.168.0.211] ([108.168.115.11]) by mrelay.perfora.net
 (mreueus003) with ESMTPSA (Nemesis) id 0M1Xxv-1cmm6k0eoD-00tRCq for
 <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2016 06:32:43 +0200
In-Reply-To: <0f72bb4a-3cdf-ffd0-db75-5c8b303b921c@mdevsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 10/23/2016 10:03 PM, TomK wrote:
> Hey,
>
> Has anyone seen this and could have a workaround?  Seems like it is more
> Kernel related with various apps not just target apparently not but
> wondering if there is an interim solution
> (https://access.redhat.com/solutions/408833)
>
> Getting this message after few minutes of usage from the QLA2xxx driver.
>  This is after some activity on an ESXi server (15 VM's) that I'm
> connecting to this HBA.  I've tried the following tuning parameters but
> there was no change in behaviour:
>
> vm.dirty_background_ratio = 5
> vm.dirty_ratio = 10
>
> Details:
>
>
> Oct 23 21:28:25 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
> Oct 23 21:28:29 mbpc-pc kernel: ABORT_TASK: Found referenced qla2xxx
> task_tag: 1128612
> Oct 23 21:28:42 mbpc-pc kernel: ABORT_TASK: Sending
> TMR_FUNCTION_COMPLETE for ref_tag: 1128612
> Oct 23 21:28:42 mbpc-pc kernel: ABORT_TASK: Found referenced qla2xxx
> task_tag: 1129116
> Jan  6 23:52:00 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon
> successfully started
> Oct 23 21:30:18 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
> Jan  6 23:54:01 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon
> successfully started
> Oct 23 21:32:16 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
> Oct 23 21:32:24 mbpc-pc kernel: INFO: task kworker/u16:8:289 blocked for
> more than 120 seconds.
> Oct 23 21:32:24 mbpc-pc kernel:      Not tainted 4.8.4 #2
> Oct 23 21:32:24 mbpc-pc kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 23 21:32:24 mbpc-pc kernel: kworker/u16:8   D ffff88011113ba18     0
>   289      2 0x00000000
> Oct 23 21:32:24 mbpc-pc kernel: Workqueue: tmr-fileio target_tmr_work
> [target_core_mod]
> Oct 23 21:32:24 mbpc-pc kernel: ffff88011113ba18 0000000000000400
> ffff880049e926c0 ffff88011113b998
> Oct 23 21:32:24 mbpc-pc kernel: ffff880111134600 ffffffff81f99ca0
> ffffffff81f998ef ffff880100000000
> Oct 23 21:32:24 mbpc-pc kernel: ffffffff812f27d9 0000000000000000
> ffffe8ffffc9a000 ffff880000000000
> Oct 23 21:32:24 mbpc-pc kernel: Call Trace:
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff812f27d9>] ? number+0x2e9/0x310
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162c040>] schedule+0x40/0xb0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81080169>] ?
> start_flush_work+0x49/0x180
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162e7ec>]
> schedule_timeout+0x9c/0xe0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810802ba>] ? flush_work+0x1a/0x40
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810bd15c>] ?
> console_unlock+0x35c/0x380
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162cfa0>]
> wait_for_completion+0xc0/0xf0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810923e0>] ?
> try_to_wake_up+0x260/0x260
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa08f6f84>]
> __transport_wait_for_tasks+0xb4/0x1b0 [target_core_mod]
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810bdd1f>] ?
> vprintk_default+0x1f/0x30
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8115cc5c>] ? printk+0x46/0x48
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa08f70c4>]
> transport_wait_for_tasks+0x44/0x60 [target_core_mod]
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa08f46e2>]
> core_tmr_abort_task+0xf2/0x160 [target_core_mod]
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa08f6aa4>]
> target_tmr_work+0x154/0x160 [target_core_mod]
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81080639>]
> process_one_work+0x189/0x4e0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8108150d>]
> worker_thread+0x16d/0x520
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810923f2>] ?
> default_wake_function+0x12/0x20
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810a6f06>] ?
> __wake_up_common+0x56/0x90
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810813a0>] ?
> maybe_create_worker+0x110/0x110
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810813a0>] ?
> maybe_create_worker+0x110/0x110
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8109130e>] ?
> schedule_tail+0x1e/0xc0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162f60f>]
> ret_from_fork+0x1f/0x40
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81085f20>] ?
> kthread_freezable_should_stop+0x70/0x70
> Oct 23 21:32:24 mbpc-pc kernel: INFO: task kworker/1:48:6089 blocked for
> more than 120 seconds.
> Oct 23 21:32:24 mbpc-pc kernel:      Not tainted 4.8.4 #2
> Oct 23 21:32:24 mbpc-pc kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 23 21:32:24 mbpc-pc kernel: kworker/1:48    D ffff88004017f968     0
>  6089      2 0x00000080
> Oct 23 21:32:24 mbpc-pc kernel: Workqueue: events qlt_free_session_done
> [qla2xxx]
> Oct 23 21:32:24 mbpc-pc kernel: ffff88004017f968 ffff88004017f8f8
> ffff88011a83a300 0000000000000004
> Oct 23 21:32:24 mbpc-pc kernel: ffff88004017a600 ffff88004017f938
> ffffffff810a0bb6 ffff880100000000
> Oct 23 21:32:24 mbpc-pc kernel: ffff880110fd0840 ffff880000000000
> ffffffff81090728 ffff880100000000
> Oct 23 21:32:24 mbpc-pc kernel: Call Trace:
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810a0bb6>] ?
> enqueue_task_fair+0x66/0x410
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81090728>] ?
> check_preempt_curr+0x78/0x90
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8109075d>] ?
> ttwu_do_wakeup+0x1d/0xf0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162c040>] schedule+0x40/0xb0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81090de0>] ?
> ttwu_queue+0x180/0x190
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162e7ec>]
> schedule_timeout+0x9c/0xe0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162cfa0>]
> wait_for_completion+0xc0/0xf0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810923e0>] ?
> try_to_wake_up+0x260/0x260
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa08f76ad>]
> target_wait_for_sess_cmds+0x4d/0x1b0 [target_core_mod]
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa00e7188>] ?
> qla2x00_post_work+0x58/0x70 [qla2xxx]
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa0286f69>]
> tcm_qla2xxx_free_session+0x49/0x90 [tcm_qla2xxx]
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffffa01447e9>]
> qlt_free_session_done+0xf9/0x3d0 [qla2xxx]
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff815092fc>] ?
> dbs_work_handler+0x5c/0x90
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8107f960>] ?
> pwq_dec_nr_in_flight+0x50/0xa0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81080639>]
> process_one_work+0x189/0x4e0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810d060c>] ?
> del_timer_sync+0x4c/0x60
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8108131e>] ?
> maybe_create_worker+0x8e/0x110
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8108150d>]
> worker_thread+0x16d/0x520
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810923f2>] ?
> default_wake_function+0x12/0x20
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810a6f06>] ?
> __wake_up_common+0x56/0x90
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810813a0>] ?
> maybe_create_worker+0x110/0x110
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff810813a0>] ?
> maybe_create_worker+0x110/0x110
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8109130e>] ?
> schedule_tail+0x1e/0xc0
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff8162f60f>]
> ret_from_fork+0x1f/0x40
> Oct 23 21:32:24 mbpc-pc kernel: [<ffffffff81085f20>] ?
> kthread_freezable_should_stop+0x70/0x70
> Jan  6 23:56:00 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon
> successfully started
> Oct 23 21:34:22 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
> Oct 23 21:34:22 mbpc-pc kernel: hpet1: lost 3 rtc interrupts
> Oct 23 21:34:27 mbpc-pc kernel: INFO: task kworker/u16:8:289 blocked for
> more than 120 seconds.
> Oct 23 21:34:27 mbpc-pc kernel:      Not tainted 4.8.4 #2
> Oct 23 21:34:27 mbpc-pc kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 23 21:34:27 mbpc-pc kernel: kworker/u16:8   D ffff88011113ba18     0
>   289      2 0x00000000
> Oct 23 21:34:27 mbpc-pc kernel: Workqueue: tmr-fileio target_tmr_work
> [target_core_mod]
> Oct 23 21:34:27 mbpc-pc kernel: ffff88011113ba18 0000000000000400
> ffff880049e926c0 ffff88011113b998
> Oct 23 21:34:27 mbpc-pc kernel: ffff880111134600 ffffffff81f99ca0
> ffffffff81f998ef ffff880100000000
> Oct 23 21:34:27 mbpc-pc kernel: ffffffff812f27d9 0000000000000000
> ffffe8ffffc9a000 ffff880000000000
> Oct 23 21:34:27 mbpc-pc kernel: Call Trace:
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff812f27d9>] ? number+0x2e9/0x310
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162c040>] schedule+0x40/0xb0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81080169>] ?
> start_flush_work+0x49/0x180
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162e7ec>]
> schedule_timeout+0x9c/0xe0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810802ba>] ? flush_work+0x1a/0x40
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810bd15c>] ?
> console_unlock+0x35c/0x380
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162cfa0>]
> wait_for_completion+0xc0/0xf0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810923e0>] ?
> try_to_wake_up+0x260/0x260
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa08f6f84>]
> __transport_wait_for_tasks+0xb4/0x1b0 [target_core_mod]
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810bdd1f>] ?
> vprintk_default+0x1f/0x30
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8115cc5c>] ? printk+0x46/0x48
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa08f70c4>]
> transport_wait_for_tasks+0x44/0x60 [target_core_mod]
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa08f46e2>]
> core_tmr_abort_task+0xf2/0x160 [target_core_mod]
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa08f6aa4>]
> target_tmr_work+0x154/0x160 [target_core_mod]
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81080639>]
> process_one_work+0x189/0x4e0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8108150d>]
> worker_thread+0x16d/0x520
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810923f2>] ?
> default_wake_function+0x12/0x20
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810a6f06>] ?
> __wake_up_common+0x56/0x90
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810813a0>] ?
> maybe_create_worker+0x110/0x110
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810813a0>] ?
> maybe_create_worker+0x110/0x110
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8109130e>] ?
> schedule_tail+0x1e/0xc0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162f60f>]
> ret_from_fork+0x1f/0x40
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81085f20>] ?
> kthread_freezable_should_stop+0x70/0x70
> Oct 23 21:34:27 mbpc-pc kernel: INFO: task kworker/1:48:6089 blocked for
> more than 120 seconds.
> Oct 23 21:34:27 mbpc-pc kernel:      Not tainted 4.8.4 #2
> Oct 23 21:34:27 mbpc-pc kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 23 21:34:27 mbpc-pc kernel: kworker/1:48    D ffff88004017f968     0
>  6089      2 0x00000080
> Oct 23 21:34:27 mbpc-pc kernel: Workqueue: events qlt_free_session_done
> [qla2xxx]
> Oct 23 21:34:27 mbpc-pc kernel: ffff88004017f968 ffff88004017f8f8
> ffff88011a83a300 0000000000000004
> Oct 23 21:34:27 mbpc-pc kernel: ffff88004017a600 ffff88004017f938
> ffffffff810a0bb6 ffff880100000000
> Oct 23 21:34:27 mbpc-pc kernel: ffff880110fd0840 ffff880000000000
> ffffffff81090728 ffff880100000000
> Oct 23 21:34:27 mbpc-pc kernel: Call Trace:
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810a0bb6>] ?
> enqueue_task_fair+0x66/0x410
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81090728>] ?
> check_preempt_curr+0x78/0x90
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8109075d>] ?
> ttwu_do_wakeup+0x1d/0xf0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162c040>] schedule+0x40/0xb0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81090de0>] ?
> ttwu_queue+0x180/0x190
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162e7ec>]
> schedule_timeout+0x9c/0xe0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162cfa0>]
> wait_for_completion+0xc0/0xf0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810923e0>] ?
> try_to_wake_up+0x260/0x260
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa08f76ad>]
> target_wait_for_sess_cmds+0x4d/0x1b0 [target_core_mod]
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa00e7188>] ?
> qla2x00_post_work+0x58/0x70 [qla2xxx]
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa0286f69>]
> tcm_qla2xxx_free_session+0x49/0x90 [tcm_qla2xxx]
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffffa01447e9>]
> qlt_free_session_done+0xf9/0x3d0 [qla2xxx]
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff815092fc>] ?
> dbs_work_handler+0x5c/0x90
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8107f960>] ?
> pwq_dec_nr_in_flight+0x50/0xa0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81080639>]
> process_one_work+0x189/0x4e0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810d060c>] ?
> del_timer_sync+0x4c/0x60
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8108131e>] ?
> maybe_create_worker+0x8e/0x110
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8108150d>]
> worker_thread+0x16d/0x520
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810923f2>] ?
> default_wake_function+0x12/0x20
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810a6f06>] ?
> __wake_up_common+0x56/0x90
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810813a0>] ?
> maybe_create_worker+0x110/0x110
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff810813a0>] ?
> maybe_create_worker+0x110/0x110
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8109130e>] ?
> schedule_tail+0x1e/0xc0
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff8162f60f>]
> ret_from_fork+0x1f/0x40
> Oct 23 21:34:27 mbpc-pc kernel: [<ffffffff81085f20>] ?
> kthread_freezable_should_stop+0x70/0x70
> Oct 23 21:36:04 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
> Oct 23 21:36:04 mbpc-pc kernel: hpet1: lost 3 rtc interrupts
> Jan  6 23:58:00 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon
> successfully started
> Oct 23 21:36:30 mbpc-pc kernel: INFO: task kworker/u16:8:289 blocked for
> more than 120 seconds.
> Oct 23 21:36:30 mbpc-pc kernel:      Not tainted 4.8.4 #2
> Oct 23 21:36:30 mbpc-pc kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 23 21:36:30 mbpc-pc kernel: kworker/u16:8   D ffff88011113ba18     0
>   289      2 0x00000000
> Oct 23 21:36:30 mbpc-pc kernel: Workqueue: tmr-fileio target_tmr_work
> [target_core_mod]
> Oct 23 21:36:30 mbpc-pc kernel: ffff88011113ba18 0000000000000400
> ffff880049e926c0 ffff88011113b998
> Oct 23 21:36:30 mbpc-pc kernel: ffff880111134600 ffffffff81f99ca0
> ffffffff81f998ef ffff880100000000
> Oct 23 21:36:30 mbpc-pc kernel: ffffffff812f27d9 0000000000000000
> ffffe8ffffc9a000 ffff880000000000
> Oct 23 21:36:30 mbpc-pc kernel: Call Trace:
> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff812f27d9>] ? number+0x2e9/0x310
> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff8162c040>] schedule+0x40/0xb0
> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff81080169>] ?
> start_flush_work+0x49/0x180
> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff8162e7ec>]
> schedule_timeout+0x9c/0xe0
> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff810802ba>] ? flush_work+0x1a/0x40
> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff810bd15c>] ?
> console_unlock+0x35c/0x380
> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff8162cfa0>]
> wait_for_completion+0xc0/0xf0
> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff810923e0>] ?
> try_to_wake_up+0x260/0x260
> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffffa08f6f84>]
> __transport_wait_for_tasks+0xb4/0x1b0 [target_core_mod]
> Oct 23 21:36:30 mbpc-pc kernel: [<ffffffff810bdd1f>] ?
> vprintk_default+0x1f/0x30
>
>


Including the full log:

http://microdevsys.com/linux-lio/messages-mailing-list

-- 
Cheers,
Tom K.
-------------------------------------------------------------------------------------

