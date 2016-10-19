From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 178381] New: Suspend to RAM test failed while
 CONFIG_SCSI_MQ_DEFAULT is set
Date: Wed, 19 Oct 2016 12:33:58 +0000
Message-ID: <bug-178381-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943862AbcJSPBm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Oct 2016 11:01:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 0AAD720364
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2016 12:34:02 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id C63A820361
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2016 12:33:59 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=178381

            Bug ID: 178381
           Summary: Suspend to RAM test failed while
                    CONFIG_SCSI_MQ_DEFAULT is set
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.8.2
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: chintzung@gmail.com
        Regression: No

Hi, 

OS is Fedora 24 + Linux kernel 4.8.2 with SCSI_MQ is enabled.

I executed below commands to do suspend to RAM test (S3 mode).

$ echo platform > /sys/power/pm_test;echo mem > /sys/power/state

It can resume correctly while only one disk is installed.

However, it can't resume correctly while there are multiple disks.
the system is hanging up.  


I set hung_task_timeout_secs=120 to get the below message.
============================================================

[ 1280.985118] call 0000:00:01.1+ returned 0 after 5 usecs
[ 1479.326798] INFO: task kworker/u8:2:1772 blocked for more than 120 seconds.
[ 1479.333754] Tainted: G U 4.8.2 #1
[ 1479.338718] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1479.346533] kworker/u8:2 D ffff8802596f3bf8 0 1772 2 0x00000000
[ 1479.353622] Workqueue: events_unbound async_run_entry_fn
[ 1479.358951] ffff8802596f3bf8 00ff8802596f3bd8 ffff880250e71e00
ffff880263dd5a00
[ 1479.366428] ffff88026dd19500 ffff8802596f4000 7fffffffffffffff
ffff88025f5e2260
[ 1479.373908] ffff880250e71e00 ffff880260af0740 ffff8802596f3c10
ffffffff817f5cc5
[ 1479.381385] Call Trace:
[ 1479.383838] [<ffffffff817f5cc5>] schedule+0x35/0x80
[ 1479.388800] [<ffffffff817f91e4>] schedule_timeout+0x2c4/0x440
[ 1479.394627] [<ffffffff810d87dc>] ? __enqueue_entity+0x6c/0x70
[ 1479.400454] [<ffffffff810deb58>] ? enqueue_entity+0x2e8/0x8e0
[ 1479.406279] [<ffffffff817f70f1>] wait_for_completion+0xe1/0x120
[ 1479.412276] [<ffffffff810d1f00>] ? wake_up_q+0x80/0x80
[ 1479.417497] [<ffffffff8153b870>] ? dpm_wait+0x40/0x40
[ 1479.422629] [<ffffffff8153b862>] dpm_wait+0x32/0x40
[ 1479.427587] [<ffffffff8153b881>] dpm_wait_fn+0x11/0x20
[ 1479.432805] [<ffffffff815299f0>] device_for_each_child+0x50/0x90
[ 1479.438890] [<ffffffff8153c841>] __device_suspend+0x51/0x380
[ 1479.444642] [<ffffffff8153cb8f>] async_suspend+0x1f/0xa0
[ 1479.450035] [<ffffffff810c9a39>] async_run_entry_fn+0x39/0x140
[ 1479.455950] [<ffffffff810c1234>] process_one_work+0x184/0x430
[ 1479.461776] [<ffffffff810c152e>] worker_thread+0x4e/0x480
[ 1479.467255] [<ffffffff810c14e0>] ? process_one_work+0x430/0x430
[ 1479.473269] [<ffffffff810c7048>] kthread+0xd8/0xf0
[ 1479.478144] [<ffffffff817fa63f>] ret_from_fork+0x1f/0x40
[ 1479.483535] [<ffffffff810c6f70>] ? kthread_worker_fn+0x180/0x180
[ 1479.489621] INFO: task md0_resync:2133 blocked for more than 120 seconds.
[ 1479.496400] Tainted: G U 4.8.2 #1
[ 1479.501358] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1479.509173] md0_resync D ffff88025717bbc8 0 2133 2 0x00000000
[ 1479.516274] ffff88025717bbc8 00ff88025717bb78 ffff880263f69e00
ffff880263dd5a00
[ 1479.523766] 0000000058ec83c0 ffff88025717c000 ffff88025717bc48
ffff880258662088
[ 1479.531264] ffff880258662070 ffff880250a6f300 ffff88025717bbe0
ffffffff817f5cc5
[ 1479.538753] Call Trace:
[ 1479.541203] [<ffffffff817f5cc5>] schedule+0x35/0x80
[ 1479.546163] [<ffffffffa081910a>] raid1_sync_request+0x2da/0xba0 [raid1]
[ 1479.552865] [<ffffffff810ea410>] ? prepare_to_wait_event+0xf0/0xf0
[ 1479.559122] [<ffffffff8165618b>] md_do_sync+0x8bb/0xec0
[ 1479.564428] [<ffffffff810ea410>] ? prepare_to_wait_event+0xf0/0xf0
[ 1479.570688] [<ffffffff810d0fbe>] ? check_preempt_curr+0x7e/0x90
[ 1479.576686] [<ffffffff810b41f3>] ? kernel_sigaction+0x43/0xe0
[ 1479.582538] [<ffffffff81652ab9>] md_thread+0x139/0x150
[ 1479.587757] [<ffffffff81652980>] ? find_pers+0x70/0x70
[ 1479.592978] [<ffffffff810c7048>] kthread+0xd8/0xf0
[ 1479.597863] [<ffffffff817fa63f>] ret_from_fork+0x1f/0x40
[ 1479.603254] [<ffffffff810c6f70>] ? kthread_worker_fn+0x180/0x180
[ 1479.609350] INFO: task ext4lazyinit:2167 blocked for more than 120 seconds.
[ 1479.616297] Tainted: G U 4.8.2 #1
[ 1479.621256] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1479.629071] ext4lazyinit D ffff8802530e7be8 0 2167 2 0x00000000
[ 1479.636161] ffff8802530e7be8 00000000041a2d80 ffff880253cf0000
ffff880263dd5a00
[ 1479.643637] 0000000420000008 ffff8802530e8000 ffff88026dd99500
7fffffffffffffff
[ 1479.651114] ffff880253cf0000 0000000000001000 ffff8802530e7c00
ffffffff817f5cc5
[ 1479.658587] Call Trace:
[ 1479.661034] [<ffffffff817f5cc5>] schedule+0x35/0x80
[ 1479.665995] [<ffffffff817f91e4>] schedule_timeout+0x2c4/0x440
[ 1479.671818] [<ffffffff81653776>] ? md_make_request+0xf6/0x230
[ 1479.677645] [<ffffffff8111c741>] ? ktime_get+0x41/0xb0
[ 1479.682864] [<ffffffff817f54b4>] io_schedule_timeout+0xa4/0x110
[ 1479.688863] [<ffffffff817f6791>] wait_for_completion_io+0xe1/0x120
[ 1479.695122] [<ffffffff810d1f00>] ? wake_up_q+0x80/0x80
[ 1479.700340] [<ffffffff813ac165>] submit_bio_wait+0x65/0x90
[ 1479.705905] [<ffffffff813be862>] blkdev_issue_zeroout+0x172/0x1e0
[ 1479.712073] [<ffffffff812e3f9d>] ext4_init_inode_table+0x18d/0x390
[ 1479.718343] [<ffffffff81301aa6>] ext4_lazyinit_thread+0x136/0x330
[ 1479.724514] [<ffffffff81301970>] ? init_once+0x80/0x80
[ 1479.729732] [<ffffffff810c7048>] kthread+0xd8/0xf0
[ 1479.734607] [<ffffffff817fa63f>] ret_from_fork+0x1f/0x40
[ 1479.739999] [<ffffffff810c6f70>] ? kthread_worker_fn+0x180/0x180
[ 1479.746082] INFO: task test.sh:2189 blocked for more than 120 seconds.
[ 1479.752599] Tainted: G U 4.8.2 #1
[ 1479.757557] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1479.765388] test.sh D ffff88021086fc10 0 2189 1865 0x00000000
[ 1479.772474] ffff88021086fc10 00000000c74278a3 ffff8802597b1e00
ffff880263dd5a00
[ 1479.779955] ffffffff81e4c5a0 ffff880210870000 0000000000000000
ffffffff81e4c5a0
[ 1479.787434] ffffffff81ed8458 ffffffff81ed9510 ffff88021086fc28
ffffffff817f5cc5
[ 1479.794912] Call Trace:
[ 1479.797361] [<ffffffff817f5cc5>] schedule+0x35/0x80
[ 1479.802319] [<ffffffff810c9bb7>] async_synchronize_cookie_domain+0x77/0x150
[ 1479.809357] [<ffffffff810ea410>] ? prepare_to_wait_event+0xf0/0xf0
[ 1479.815611] [<ffffffff810c9cc7>] async_synchronize_full+0x17/0x20
[ 1479.821795] [<ffffffff8153e37b>] dpm_suspend+0x1fb/0x2d0
[ 1479.827186] [<ffffffff8153e890>] dpm_suspend_start+0x50/0x60
[ 1479.832924] [<ffffffff810f5823>] suspend_devices_and_enter+0xd3/0x6d0
[ 1479.839444] [<ffffffff810f6145>] pm_suspend+0x325/0x390
[ 1479.844768] [<ffffffff810f494e>] state_store+0x7e/0xe0
[ 1479.850002] [<ffffffff813e824f>] kobj_attr_store+0xf/0x20
[ 1479.855480] [<ffffffff812d7037>] sysfs_kf_write+0x37/0x40
[ 1479.860959] [<ffffffff812d657c>] kernfs_fop_write+0x11c/0x1b0
[ 1479.866795] [<ffffffff81251c17>] __vfs_write+0x37/0x160
[ 1479.872099] [<ffffffff8136e317>] ? selinux_file_permission+0xd7/0x110
[ 1479.878612] [<ffffffff81363fad>] ? security_file_permission+0x3d/0xc0
[ 1479.885127] [<ffffffff810f1a42>] ? percpu_down_read+0x12/0x50
[ 1479.890951] [<ffffffff81252555>] vfs_write+0xb5/0x1a0
[ 1479.896085] [<ffffffff812539a5>] SyS_write+0x55/0xc0
[ 1479.901131] [<ffffffff817fa432>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[ 1479.907578] INFO: task kworker/u8:3:2193 blocked for more than 120 seconds.
[ 1479.914527] Tainted: G U 4.8.2 #1
[ 1479.919482] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1479.927296] kworker/u8:3 D ffff88025332bbf8 0 2193 2 0x00000000
[ 1479.934379] Workqueue: events_unbound async_run_entry_fn
[ 1479.939728] ffff88025332bbf8 0000000000000000 ffff880263ef1e00
ffff880263dd3c00
[ 1479.947208] ffffffff81a13180 ffff88025332c000 7fffffffffffffff
ffff88025f5e7260
[ 1479.954708] ffff880263ef1e00 ffff880260af0980 ffff88025332bc10
ffffffff817f5cc5
[ 1479.962190] Call Trace:
[ 1479.964639] [<ffffffff817f5cc5>] schedule+0x35/0x80
[ 1479.969611] [<ffffffff817f91e4>] schedule_timeout+0x2c4/0x440
[ 1479.975436] [<ffffffff810d87dc>] ? __enqueue_entity+0x6c/0x70
[ 1479.981262] [<ffffffff810deb58>] ? enqueue_entity+0x2e8/0x8e0
[ 1479.987087] [<ffffffff810cfe76>] ? __sched_setscheduler+0x8b6/0xb20
[ 1479.993430] [<ffffffff817f70f1>] wait_for_completion+0xe1/0x120
[ 1479.999429] [<ffffffff810d1f00>] ? wake_up_q+0x80/0x80
[ 1480.004650] [<ffffffff8153b870>] ? dpm_wait+0x40/0x40
[ 1480.009782] [<ffffffff8153b862>] dpm_wait+0x32/0x40
[ 1480.014741] [<ffffffff8153b881>] dpm_wait_fn+0x11/0x20
[ 1480.019957] [<ffffffff815299f0>] device_for_each_child+0x50/0x90
[ 1480.026042] [<ffffffff8153c841>] __device_suspend+0x51/0x380
[ 1480.031782] [<ffffffff8153cb8f>] async_suspend+0x1f/0xa0
[ 1480.037173] [<ffffffff810c9a39>] async_run_entry_fn+0x39/0x140
[ 1480.043084] [<ffffffff810c1234>] process_one_work+0x184/0x430
[ 1480.048922] [<ffffffff810c152e>] worker_thread+0x4e/0x480
[ 1480.054405] [<ffffffff810c14e0>] ? process_one_work+0x430/0x430
[ 1480.060400] [<ffffffff810c7048>] kthread+0xd8/0xf0
[ 1480.065275] [<ffffffff817fa63f>] ret_from_fork+0x1f/0x40
[ 1480.070666] [<ffffffff810c6f70>] ? kthread_worker_fn+0x180/0x180
[ 1480.076748] INFO: task kworker/u8:14:2204 blocked for more than 120 seconds.
[ 1480.083798] Tainted: G U 4.8.2 #1
[ 1480.088754] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1480.096571] kworker/u8:14 D ffff880259763bf8 0 2204 2 0x00000000
[ 1480.103667] Workqueue: events_unbound async_run_entry_fn
[ 1480.108993] ffff880259763bf8 00ffffff810d7019 ffff88025ffc0000
ffff88025678da00
[ 1480.116476] ffff880259763c30 ffff880259764000 7fffffffffffffff
ffff880255c294f8
[ 1480.123956] ffff88025ffc0000 ffff8802589da620 ffff880259763c10
ffffffff817f5cc5
[ 1480.131452] Call Trace:
[ 1480.133907] [<ffffffff817f5cc5>] schedule+0x35/0x80
[ 1480.138866] [<ffffffff817f91e4>] schedule_timeout+0x2c4/0x440
[ 1480.144706] [<ffffffff810fe619>] ? console_trylock+0x19/0x60
[ 1480.150444] [<ffffffff810ffbb1>] ? vprintk_emit+0x2b1/0x500
[ 1480.156094] [<ffffffff817f70f1>] wait_for_completion+0xe1/0x120
[ 1480.162105] [<ffffffff810d1f00>] ? wake_up_q+0x80/0x80
[ 1480.167322] [<ffffffff8153b870>] ? dpm_wait+0x40/0x40
[ 1480.172455] [<ffffffff8153b862>] dpm_wait+0x32/0x40
[ 1480.177412] [<ffffffff8153b881>] dpm_wait_fn+0x11/0x20
[ 1480.182629] [<ffffffff815299f0>] device_for_each_child+0x50/0x90
[ 1480.188724] [<ffffffff8153c841>] __device_suspend+0x51/0x380
[ 1480.194460] [<ffffffff8153cb8f>] async_suspend+0x1f/0xa0
[ 1480.199852] [<ffffffff810c9a39>] async_run_entry_fn+0x39/0x140
[ 1480.205762] [<ffffffff810c1234>] process_one_work+0x184/0x430
[ 1480.211585] [<ffffffff810c152e>] worker_thread+0x4e/0x480
[ 1480.217063] [<ffffffff810c14e0>] ? process_one_work+0x430/0x430
[ 1480.223060] [<ffffffff810c7048>] kthread+0xd8/0xf0
[ 1480.227933] [<ffffffff817fa63f>] ret_from_fork+0x1f/0x40
[ 1480.233329] [<ffffffff810c6f70>] ? kthread_worker_fn+0x180/0x180
[ 1480.239414] INFO: task kworker/u8:15:2205 blocked for more than 120 seconds.
[ 1480.246449] Tainted: G U 4.8.2 #1
[ 1480.251407] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1480.259219] kworker/u8:15 D ffff880260bf3bf8 0 2205 2 0x00000000
[ 1480.266302] Workqueue: events_unbound async_run_entry_fn
[ 1480.271631] ffff880260bf3bf8 00ffffff810d7019 ffff88025ffc1e00
ffff88025470bc00
[ 1480.279110] ffff880260bf3c30 ffff880260bf4000 7fffffffffffffff
ffff880263f332d8
[ 1480.286593] ffff88025ffc1e00 ffff8802589da4a0 ffff880260bf3c10
ffffffff817f5cc5
[ 1480.294072] Call Trace:
[ 1480.296520] [<ffffffff817f5cc5>] schedule+0x35/0x80
[ 1480.301479] [<ffffffff817f91e4>] schedule_timeout+0x2c4/0x440
[ 1480.307306] [<ffffffff810fe619>] ? console_trylock+0x19/0x60
[ 1480.313042] [<ffffffff810ffbb1>] ? vprintk_emit+0x2b1/0x500
[ 1480.318691] [<ffffffff817f70f1>] wait_for_completion+0xe1/0x120
[ 1480.324687] [<ffffffff810d1f00>] ? wake_up_q+0x80/0x80
[ 1480.329904] [<ffffffff8153b870>] ? dpm_wait+0x40/0x40
[ 1480.335049] [<ffffffff8153b862>] dpm_wait+0x32/0x40
[ 1480.340008] [<ffffffff8153b881>] dpm_wait_fn+0x11/0x20
[ 1480.345230] [<ffffffff815299f0>] device_for_each_child+0x50/0x90
[ 1480.351313] [<ffffffff8153c841>] __device_suspend+0x51/0x380
[ 1480.357052] [<ffffffff8153cb8f>] async_suspend+0x1f/0xa0
[ 1480.362444] [<ffffffff810c9a39>] async_run_entry_fn+0x39/0x140
[ 1480.368371] [<ffffffff810c1234>] process_one_work+0x184/0x430
[ 1480.374199] [<ffffffff810c152e>] worker_thread+0x4e/0x480
[ 1480.379677] [<ffffffff810c14e0>] ? process_one_work+0x430/0x430
[ 1480.385673] [<ffffffff810c7048>] kthread+0xd8/0xf0
[ 1480.390545] [<ffffffff817fa63f>] ret_from_fork+0x1f/0x40
[ 1480.395937] [<ffffffff810c6f70>] ? kthread_worker_fn+0x180/0x180
[ 1480.402023] INFO: task kworker/u8:16:2206 blocked for more than 120 seconds.
[ 1480.409057] Tainted: G U 4.8.2 #1
[ 1480.414016] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1480.421830] kworker/u8:16 D ffff88021c917bf8 0 2206 2 0x00000000
[ 1480.428918] Workqueue: events_unbound async_run_entry_fn
[ 1480.434248] ffff88021c917bf8 00ffffff810d7019 ffff880262ec1e00
ffff88025678da00
[ 1480.441755] ffff88021c917c30 ffff88021c918000 7fffffffffffffff
ffff880263f32ad8
[ 1480.449230] ffff880262ec1e00 ffff8802589da440 ffff88021c917c10
ffffffff817f5cc5
[ 1480.456723] Call Trace:
[ 1480.459174] [<ffffffff817f5cc5>] schedule+0x35/0x80
[ 1480.464133] [<ffffffff817f91e4>] schedule_timeout+0x2c4/0x440
[ 1480.469958] [<ffffffff810d7019>] ? sched_clock_cpu+0x99/0xb0
[ 1480.475696] [<ffffffff810d0f92>] ? check_preempt_curr+0x52/0x90
[ 1480.481696] [<ffffffff810d0fe9>] ? ttwu_do_wakeup+0x19/0xe0
[ 1480.487345] [<ffffffff817f70f1>] wait_for_completion+0xe1/0x120
[ 1480.493343] [<ffffffff810d1f00>] ? wake_up_q+0x80/0x80
[ 1480.498561] [<ffffffff8153b870>] ? dpm_wait+0x40/0x40
[ 1480.503693] [<ffffffff8153b862>] dpm_wait+0x32/0x40
[ 1480.508652] [<ffffffff8153b881>] dpm_wait_fn+0x11/0x20
[ 1480.513869] [<ffffffff815299f0>] device_for_each_child+0x50/0x90
[ 1480.519953] [<ffffffff8153c841>] __device_suspend+0x51/0x380
[ 1480.525695] [<ffffffff8153cb8f>] async_suspend+0x1f/0xa0
[ 1480.531089] [<ffffffff810c9a39>] async_run_entry_fn+0x39/0x140
[ 1480.537002] [<ffffffff810c1234>] process_one_work+0x184/0x430
[ 1480.542824] [<ffffffff810c152e>] worker_thread+0x4e/0x480
[ 1480.548300] [<ffffffff810c14e0>] ? process_one_work+0x430/0x430
[ 1480.554308] [<ffffffff810c7048>] kthread+0xd8/0xf0
[ 1480.559192] [<ffffffff817fa63f>] ret_from_fork+0x1f/0x40
[ 1480.564583] [<ffffffff810c6f70>] ? kthread_worker_fn+0x180/0x180
[ 1480.570666] INFO: task kworker/u8:17:2207 blocked for more than 120 seconds.
[ 1480.577714] Tainted: G U 4.8.2 #1
[ 1480.582674] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1480.590489] kworker/u8:17 D ffff880253343bf8 0 2207 2 0x00000000
[ 1480.597574] Workqueue: events_unbound async_run_entry_fn
[ 1480.602903] ffff880253343bf8 0000000000000000 ffff88025fceda00
ffff8802597b1e00
[ 1480.610386] 0000000000019500 ffff880253344000 7fffffffffffffff
ffff880255c2a4f8
[ 1480.617867] ffff88025fceda00 ffff8802589da860 ffff880253343c10
ffffffff817f5cc5
[ 1480.625349] Call Trace:
[ 1480.627801] [<ffffffff817f5cc5>] schedule+0x35/0x80
[ 1480.632760] [<ffffffff817f91e4>] schedule_timeout+0x2c4/0x440
[ 1480.638585] [<ffffffff810dbe11>] ? check_preempt_wakeup+0x121/0x220
[ 1480.644929] [<ffffffff810d0fbe>] ? check_preempt_curr+0x7e/0x90
[ 1480.650925] [<ffffffff810d0fe9>] ? ttwu_do_wakeup+0x19/0xe0
[ 1480.656578] [<ffffffff817f70f1>] wait_for_completion+0xe1/0x120
[ 1480.662588] [<ffffffff810d1f00>] ? wake_up_q+0x80/0x80
[ 1480.667807] [<ffffffff8153b870>] ? dpm_wait+0x40/0x40
[ 1480.672938] [<ffffffff8153b862>] dpm_wait+0x32/0x40
[ 1480.677896] [<ffffffff8153b881>] dpm_wait_fn+0x11/0x20
[ 1480.683116] [<ffffffff815299f0>] device_for_each_child+0x50/0x90
[ 1480.689201] [<ffffffff8153c841>] __device_suspend+0x51/0x380
[ 1480.694938] [<ffffffff8153cb8f>] async_suspend+0x1f/0xa0
[ 1480.700332] [<ffffffff810c9a39>] async_run_entry_fn+0x39/0x140
[ 1480.706243] [<ffffffff810c1234>] process_one_work+0x184/0x430
[ 1480.712067] [<ffffffff810c152e>] worker_thread+0x4e/0x480
[ 1480.717556] [<ffffffff810c14e0>] ? process_one_work+0x430/0x430
[ 1480.723554] [<ffffffff810c7048>] kthread+0xd8/0xf0
[ 1480.728440] [<ffffffff817fa63f>] ret_from_fork+0x1f/0x40
[ 1480.733832] [<ffffffff810c6f70>] ? kthread_worker_fn+0x180/0x180
[ 1480.739930] INFO: task kworker/u8:25:2215 blocked for more than 120 seconds.
[ 1480.746968] Tainted: G U 4.8.2 #1
[ 1480.751923] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1480.759739] kworker/u8:25 D ffff88025336bbf8 0 2215 2 0x00000000
[ 1480.766827] Workqueue: events_unbound async_run_entry_fn
[ 1480.772154] ffff88025336bbf8 0000000000000104 ffff880258bc5a00
ffff880263dd5a00
[ 1480.779636] 000001298023182e ffff88025336c000 7fffffffffffffff
ffff880257aff458
[ 1480.787116] ffff880258bc5a00 ffff8802597a4740 ffff88025336bc10
ffffffff817f5cc5
[ 1480.794594] Call Trace:
[ 1480.797043] [<ffffffff817f5cc5>] schedule+0x35/0x80
[ 1480.802002] [<ffffffff817f91e4>] schedule_timeout+0x2c4/0x440
[ 1480.807840] [<ffffffff810d7019>] ? sched_clock_cpu+0x99/0xb0
[ 1480.813594] [<ffffffff810d0f92>] ? check_preempt_curr+0x52/0x90
[ 1480.819592] [<ffffffff810d0fe9>] ? ttwu_do_wakeup+0x19/0xe0
[ 1480.825242] [<ffffffff817f70f1>] wait_for_completion+0xe1/0x120
[ 1480.831239] [<ffffffff810d1f00>] ? wake_up_q+0x80/0x80
[ 1480.836457] [<ffffffff8153b870>] ? dpm_wait+0x40/0x40
[ 1480.841588] [<ffffffff8153b862>] dpm_wait+0x32/0x40
[ 1480.846560] [<ffffffff8153b881>] dpm_wait_fn+0x11/0x20
[ 1480.851779] [<ffffffff815299f0>] device_for_each_child+0x50/0x90
[ 1480.857861] [<ffffffff8153c841>] __device_suspend+0x51/0x380
[ 1480.863601] [<ffffffff8153cb8f>] async_suspend+0x1f/0xa0
[ 1480.868996] [<ffffffff810c9a39>] async_run_entry_fn+0x39/0x140
[ 1480.874924] [<ffffffff810c1234>] process_one_work+0x184/0x430
[ 1480.880746] [<ffffffff810c152e>] worker_thread+0x4e/0x480
[ 1480.886223] [<ffffffff810c14e0>] ? process_one_work+0x430/0x430
[ 1480.892221] [<ffffffff810c7048>] kthread+0xd8/0xf0
[ 1480.897093] [<ffffffff817fa63f>] ret_from_fork+0x1f/0x40
[ 1480.902486] [<ffffffff810c6f70>] ? kthread_worker_fn+0x180/0x180

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
