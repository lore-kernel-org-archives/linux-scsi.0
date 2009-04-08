From: Alexander Beregalov <a.beregalov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: 2.6.30-rc1 cannot boot: scsi/async
Date: Wed, 8 Apr 2009 21:12:25 +0400
Message-ID: <a4423d670904081012j30ad104etefeee0c8c682aca9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Testers List <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi

It is 2*2 SMP system, x86_64.

INFO: task async/0:1073 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
async/0       D 0000000000000000  6312  1073      2
 ffff88007ed91cd0 0000000000000046 0000000000000006 0000000000000000
 ffff88007ed91c40 000000000000d988 00000000001d2040 0000000000000000
 ffff88007f5c1300 ffff88007f7d8000 ffff88007f5c1690 0000000000000000
Call Trace:
 [<ffffffff802832ed>] ? trace_hardirqs_on_caller+0x18d/0x1f0
 [<ffffffff80283370>] ? trace_hardirqs_on+0x20/0x40
 [<ffffffff806d53e6>] schedule+0x26/0x60
 [<ffffffff80275825>] async_synchronize_cookie_domain+0x85/0x160
 [<ffffffff8026cd70>] ? autoremove_wake_function+0x0/0x60
 [<ffffffff80275923>] async_synchronize_cookie+0x23/0x40
 [<ffffffff8027596c>] async_synchronize_full+0x2c/0x70
 [<ffffffff8058a0c8>] scsi_complete_async_scans+0x88/0x140
 [<ffffffff8058c985>] __scsi_add_device+0x105/0x140
 [<ffffffff805aefb2>] ata_scsi_scan_host+0xc2/0x1f0
 [<ffffffff805aafd6>] async_port_probe+0xc6/0x110
 [<ffffffff806d8fa5>] ? _spin_unlock_irqrestore+0x55/0xb0
 [<ffffffff8027563a>] async_thread+0x11a/0x280
 [<ffffffff802460a0>] ? default_wake_function+0x0/0x40
 [<ffffffff80275520>] ? async_thread+0x0/0x280
 [<ffffffff8026c8dc>] kthread+0x5c/0xb0
 [<ffffffff8020cafa>] child_rip+0xa/0x20
 [<ffffffff8020c4c0>] ? restore_args+0x0/0x30
 [<ffffffff8026c880>] ? kthread+0x0/0xb0
 [<ffffffff8020caf0>] ? child_rip+0x0/0x20
1 lock held by async/0/1073:
 #0:  (&shost->scan_mutex){+.+.+.}, at: [<ffffffff8058c94a>]
__scsi_add_device+0xca/0x140
INFO: task async/1:1076 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
async/1       D 0000000000000001  6552  1076      2
 ffff88007ed97dc0 0000000000000046 ffff88007ed97d00 ffffffff8027fb01
 00000000000001d2 000000000000d988 00000000001d2040 0000000000000002
 ffff88007ed98000 ffff88007f7db900 ffff88007ed98390 000000027ed97eb0
Call Trace:
 [<ffffffff8027fb01>] ? put_lock_stats+0x21/0x60
 [<ffffffff802832ed>] ? trace_hardirqs_on_caller+0x18d/0x1f0
 [<ffffffff80283370>] ? trace_hardirqs_on+0x20/0x40
 [<ffffffff806d53e6>] schedule+0x26/0x60
 [<ffffffff80275825>] async_synchronize_cookie_domain+0x85/0x160
 [<ffffffff8026cd70>] ? autoremove_wake_function+0x0/0x60
 [<ffffffff80275923>] async_synchronize_cookie+0x23/0x40
 [<ffffffff805ab000>] async_port_probe+0xf0/0x110
 [<ffffffff806d8fa5>] ? _spin_unlock_irqrestore+0x55/0xb0
 [<ffffffff8027563a>] async_thread+0x11a/0x280
 [<ffffffff802460a0>] ? default_wake_function+0x0/0x40
 [<ffffffff80275520>] ? async_thread+0x0/0x280
 [<ffffffff8026c8dc>] kthread+0x5c/0xb0
 [<ffffffff8020cafa>] child_rip+0xa/0x20
 [<ffffffff8020c4c0>] ? restore_args+0x0/0x30
 [<ffffffff8026c880>] ? kthread+0x0/0xb0
 [<ffffffff8020caf0>] ? child_rip+0x0/0x20
no locks held by async/1/1076.
INFO: task swapper:1 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
swapper       D 0000000000000000  3336     1      0
 ffff88007f427dd0 0000000000000046 ffff88007f427d10 ffffffff8027fb01
 0000000000000145 000000000000d988 00000000001d2040 0000000000000000
 ffff88007f448000 ffffffff808744a0 ffff88007f448390 00000000808c9fe0
Call Trace:
 [<ffffffff8027fb01>] ? put_lock_stats+0x21/0x60
 [<ffffffff802832ed>] ? trace_hardirqs_on_caller+0x18d/0x1f0
 [<ffffffff80283370>] ? trace_hardirqs_on+0x20/0x40
 [<ffffffff806d53e6>] schedule+0x26/0x60
 [<ffffffff80275825>] async_synchronize_cookie_domain+0x85/0x160
 [<ffffffff8026cd70>] ? autoremove_wake_function+0x0/0x60
 [<ffffffff80275923>] async_synchronize_cookie+0x23/0x40
 [<ffffffff8027596c>] async_synchronize_full+0x2c/0x70
 [<ffffffff805758bf>] wait_for_device_probe+0x8f/0xc0
 [<ffffffff8026cd70>] ? autoremove_wake_function+0x0/0x60
 [<ffffffff808d865f>] prepare_namespace+0x2a/0x179
 [<ffffffff808d78c6>] kernel_init+0x1e9/0x250
 [<ffffffff8020cafa>] child_rip+0xa/0x20
 [<ffffffff8020c4c0>] ? restore_args+0x0/0x30
 [<ffffffff808d76dd>] ? kernel_init+0x0/0x250
 [<ffffffff8020caf0>] ? child_rip+0x0/0x20
no locks held by swapper/1.
