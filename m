From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13133] New: ODEBUG: object is on stack, but not annotated
Date: Sat, 18 Apr 2009 00:30:19 GMT
Message-ID: <bug-13133-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47440 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbZDRAaV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 20:30:21 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3I0UJUD008689
	for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2009 00:30:19 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13133

           Summary: ODEBUG: object is on stack, but not annotated
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.29-0.258.2.3.rc8.git2.fc11.x86_64
          Platform: All
        OS/Version: Linux
              Tree: Fedora
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: dsbailey@pacbell.net
        Regression: No


Apr 17 16:14:13 euclid kernel: WARNING: at lib/debugobjects.c:253
__debug_object_init+0x2a0/0x33d() (Not tainted)
Apr 17 16:14:13 euclid kernel: Hardware name: Precision WorkStation T7400  
Apr 17 16:14:13 euclid kernel: Modules linked in: mptsas(+) mptscsih mptbase
scsi_transport_sas ext4 jbd2 crc16 nouveau drm i2c_core
Apr 17 16:14:13 euclid kernel: Pid: 20, comm: work_on_cpu/0 Not tainted
2.6.29-0.258.2.3.rc8.git2.fc11.x86_64 #1
Apr 17 16:14:13 euclid kernel: Call Trace:
Apr 17 16:14:13 euclid kernel: [<ffffffff8104bae3>] warn_slowpath+0xbc/0xf0
Apr 17 16:14:13 euclid kernel: [<ffffffff8104c0ba>] ?
release_console_sem+0x1c3/0x1f4
Apr 17 16:14:13 euclid kernel: [<ffffffff8101781b>] ?
native_sched_clock+0x2d/0x5a
Apr 17 16:14:13 euclid kernel: [<ffffffff81393b9b>] ? printk+0x41/0x46
Apr 17 16:14:13 euclid kernel: [<ffffffff811a2a44>]
__debug_object_init+0x2a0/0x33d
Apr 17 16:14:13 euclid kernel: [<ffffffff811a2b0e>] debug_object_init+0x14/0x16
Apr 17 16:14:13 euclid kernel: [<ffffffff81055ea2>] init_timer+0x1d/0x60
Apr 17 16:14:13 euclid kernel: [<ffffffffa010823c>] mpt_config+0x1d2/0x2e6
[mptbase]
Apr 17 16:14:13 euclid kernel: [<ffffffff8106f9d6>] ? mark_held_locks+0x68/0x86
Apr 17 16:14:13 euclid kernel: [<ffffffffa0108729>]
mpt_findImVolumes+0xa1/0x484 [mptbase]
Apr 17 16:14:13 euclid kernel: [<ffffffff8106fbf9>] ? trace_hardirqs_on+0xd/0xf
Apr 17 16:14:13 euclid kernel: [<ffffffff811a223a>] ? free_object+0x84/0xba
Apr 17 16:14:13 euclid kernel: [<ffffffff811a24eb>] ?
debug_object_free+0xd0/0xe9
Apr 17 16:14:13 euclid kernel: [<ffffffff81055a55>] ?
destroy_timer_on_stack+0x15/0x17
Apr 17 16:14:13 euclid kernel: [<ffffffff81394975>] ?
schedule_timeout+0xa4/0xc0
Apr 17 16:14:13 euclid kernel: [<ffffffff810560d0>] ? process_timeout+0x0/0x10
Apr 17 16:14:13 euclid kernel: [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
Apr 17 16:14:13 euclid kernel: [<ffffffff8105679b>] ? __mod_timer+0x21/0xd2
Apr 17 16:14:13 euclid kernel: [<ffffffff81056867>] ? msleep+0x1b/0x22
Apr 17 16:14:13 euclid kernel: [<ffffffffa0106626>] ?
WaitForDoorbellInt+0x56/0xd0 [mptbase]
Apr 17 16:14:13 euclid kernel: [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
Apr 17 16:14:13 euclid kernel: [<ffffffff8106fd2c>] ?
debug_check_no_locks_freed+0x131/0x149
Apr 17 16:14:13 euclid kernel: [<ffffffff8106fbc8>] ?
trace_hardirqs_on_caller+0x12f/0x153
Apr 17 16:14:13 euclid kernel: [<ffffffff8106e298>] ? static_obj+0x74/0x80
Apr 17 16:14:13 euclid kernel: [<ffffffff8106e975>] ?
lockdep_init_map+0x93/0x102
Apr 17 16:14:13 euclid kernel: [<ffffffff8106d581>] ?
debug_mutex_init+0x31/0x44
Apr 17 16:14:13 euclid kernel: [<ffffffffa010ba74>]
mpt_do_ioc_recovery+0x824/0x1560 [mptbase]
Apr 17 16:14:13 euclid kernel: [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
Apr 17 16:14:13 euclid kernel: [<ffffffff8105eb80>] ?
__kernel_text_address+0x42/0x4d
Apr 17 16:14:13 euclid kernel: [<ffffffff81014d35>] ?
print_context_stack+0xae/0xcd
Apr 17 16:14:13 euclid kernel: [<ffffffff81014252>] ? dump_trace+0x256/0x268
Apr 17 16:14:13 euclid kernel: [<ffffffff8106deaf>] ?
find_usage_backwards+0x3b/0x103
Apr 17 16:14:13 euclid kernel: [<ffffffff8101c37f>] ?
save_stack_trace+0x2f/0x4c
Apr 17 16:14:13 euclid kernel: [<ffffffff8106ea23>] ? save_trace+0x3f/0x95
Apr 17 16:14:13 euclid kernel: [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
Apr 17 16:14:13 euclid kernel: [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
Apr 17 16:14:13 euclid kernel: [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
Apr 17 16:14:13 euclid kernel: [<ffffffff8106f9d6>] ? mark_held_locks+0x68/0x86
Apr 17 16:14:13 euclid kernel: [<ffffffff813967de>] ?
_spin_unlock_irqrestore+0x48/0x58
Apr 17 16:14:13 euclid kernel: [<ffffffff8106fbc8>] ?
trace_hardirqs_on_caller+0x12f/0x153
Apr 17 16:14:13 euclid kernel: [<ffffffff8106fbf9>] ? trace_hardirqs_on+0xd/0xf
Apr 17 16:14:13 euclid kernel: [<ffffffff8119bc2d>] ? __up_read+0x76/0x7f
Apr 17 16:14:13 euclid kernel: [<ffffffff810645dc>] ? up_read+0x2b/0x2f
Apr 17 16:14:13 euclid kernel: [<ffffffffa010d51d>] mpt_attach+0x8b2/0xa11
[mptbase]
Apr 17 16:14:13 euclid kernel: [<ffffffff8105cac4>] ? do_work_for_cpu+0x0/0x20
Apr 17 16:14:13 euclid kernel: [<ffffffffa012a5a7>] mptsas_probe+0x1e/0x46e
[mptsas]
Apr 17 16:14:13 euclid kernel: [<ffffffff8105cac4>] ? do_work_for_cpu+0x0/0x20
Apr 17 16:14:13 euclid kernel: [<ffffffff811ad085>] local_pci_probe+0x17/0x1b
Apr 17 16:14:13 euclid kernel: [<ffffffff8105cadc>] do_work_for_cpu+0x18/0x20
Apr 17 16:14:13 euclid kernel: [<ffffffff8105ccb0>] run_workqueue+0xfd/0x1fd
Apr 17 16:14:13 euclid kernel: [<ffffffff8105cc5f>] ? run_workqueue+0xac/0x1fd
Apr 17 16:14:13 euclid kernel: [<ffffffff8106fbc8>] ?
trace_hardirqs_on_caller+0x12f/0x153
Apr 17 16:14:13 euclid kernel: [<ffffffff8105ce9f>] worker_thread+0xef/0x100
Apr 17 16:14:13 euclid kernel: [<ffffffff81060d46>] ?
autoremove_wake_function+0x0/0x39
Apr 17 16:14:13 euclid kernel: [<ffffffff8105cdb0>] ? worker_thread+0x0/0x100
Apr 17 16:14:13 euclid kernel: [<ffffffff8105cdb0>] ? worker_thread+0x0/0x100
Apr 17 16:14:13 euclid kernel: [<ffffffff810609ad>] kthread+0x4d/0x78
Apr 17 16:14:13 euclid kernel: [<ffffffff810126aa>] child_rip+0xa/0x20
Apr 17 16:14:13 euclid kernel: [<ffffffff8100f88b>] ? __switch_to+0x190/0x398
Apr 17 16:14:13 euclid kernel: [<ffffffff81011fbe>] ? restore_args+0x0/0x30
Apr 17 16:14:13 euclid kernel: [<ffffffff81060960>] ? kthread+0x0/0x78
Apr 17 16:14:13 euclid kernel: [<ffffffff810126a0>] ? child_rip+0x0/0x20
Apr 17 16:14:13 euclid kernel: ---[ end trace 03486043348b658d ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
