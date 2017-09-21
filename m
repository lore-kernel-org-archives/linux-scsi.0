From: Andrey Konovalov <andreyknvl@google.com>
Subject: usb/storage/uas: slab-out-of-bounds in uas_probe
Date: Thu, 21 Sep 2017 17:39:05 +0200
Message-ID: <CAAeHK+xiFr1RW+HkoFhnypcgsnp6DgwzwVZ1pzQdzHeYZU+N5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>, syzkaller <syzkaller@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

Hi!

I've got the following report while fuzzing the kernel with syzkaller.

On commit ebb2c2437d8008d46796902ff390653822af6cc4 (Sep 18).

The issue occurs when we iterate over interface altsettings, but I
don't see the driver doing anything wrong. I might be missing
something, or this might be an issue in USB core altsettings parsing.

==================================================================
BUG: KASAN: slab-out-of-bounds in uas_probe+0x15de/0x1680
Read of size 1 at addr ffff880063ba9ad4 by task kworker/1:2/1845

CPU: 1 PID: 1845 Comm: kworker/1:2 Not tainted
4.14.0-rc1-42251-gebb2c2437d80 #215
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:16
 dump_stack+0x292/0x395 lib/dump_stack.c:52
 print_address_description+0x78/0x280 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x22f/0x340 mm/kasan/report.c:409
 __asan_report_load1_noabort+0x19/0x20 mm/kasan/report.c:427
 uas_is_interface drivers/usb/storage/uas-detect.h:9
 uas_find_uas_alt_setting drivers/usb/storage/uas-detect.h:19
 uas_use_uas_driver drivers/usb/storage/uas-detect.h:64
 uas_probe+0x15de/0x1680 drivers/usb/storage/uas.c:938
 usb_probe_interface+0x35d/0x8e0 drivers/usb/core/driver.c:361
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_set_configuration+0x104e/0x1870 drivers/usb/core/message.c:1932
 generic_probe+0x73/0xe0 drivers/usb/core/generic.c:174
 usb_probe_device+0xaf/0xe0 drivers/usb/core/driver.c:266
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_new_device+0x7b8/0x1020 drivers/usb/core/hub.c:2457
 hub_port_connect drivers/usb/core/hub.c:4903
 hub_port_connect_change drivers/usb/core/hub.c:5009
 port_event drivers/usb/core/hub.c:5115
 hub_event+0x194d/0x3740 drivers/usb/core/hub.c:5195
 process_one_work+0xc7f/0x1db0 kernel/workqueue.c:2119
 worker_thread+0x221/0x1850 kernel/workqueue.c:2253
 kthread+0x3a1/0x470 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431

Allocated by task 2641:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
 kmem_cache_alloc_node_trace+0x15e/0x2d0 mm/slub.c:2800
 kmalloc_node ./include/linux/slab.h:531
 kzalloc_node ./include/linux/slab.h:677
 __get_vm_area_node+0x141/0x570 mm/vmalloc.c:1402
 __vmalloc_node_range+0xa8/0x730 mm/vmalloc.c:1760
 __vmalloc_node mm/vmalloc.c:1810
 __vmalloc_node_flags mm/vmalloc.c:1824
 vmalloc+0x4a/0x50 mm/vmalloc.c:1846
 n_tty_open+0x20/0x470 drivers/tty/n_tty.c:1883
 tty_ldisc_open.isra.1+0x78/0xc0 drivers/tty/tty_ldisc.c:466
 tty_ldisc_setup+0x8f/0x100 drivers/tty/tty_ldisc.c:780
 tty_init_dev+0x1a2/0x4a0 drivers/tty/tty_io.c:1332
 ptmx_open+0xfe/0x320 drivers/tty/pty.c:831
 chrdev_open+0x25c/0x710 fs/char_dev.c:416
 do_dentry_open+0x74e/0xd60 fs/open.c:752
 vfs_open+0x10c/0x230 fs/open.c:866
 do_last fs/namei.c:3387
 path_openat+0xf22/0x34d0 fs/namei.c:3527
 do_filp_open+0x2a1/0x460 fs/namei.c:3562
 do_sys_open+0x543/0x720 fs/open.c:1059
 SYSC_open fs/open.c:1077
 SyS_open+0x32/0x40 fs/open.c:1072
 entry_SYSCALL_64_fastpath+0x23/0xc2 arch/x86/entry/entry_64.S:202

Freed by task 2641:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:524
 slab_free_hook mm/slub.c:1390
 slab_free_freelist_hook mm/slub.c:1412
 slab_free mm/slub.c:2988
 kfree+0xf6/0x2f0 mm/slub.c:3919
 __vunmap+0x24c/0x2f0 mm/vmalloc.c:1545
 vfree+0x55/0xe0 mm/vmalloc.c:1606
 n_tty_close+0xb7/0x120 drivers/tty/n_tty.c:1864
 tty_ldisc_close.isra.0+0x9e/0xd0 drivers/tty/tty_ldisc.c:490
 tty_ldisc_kill+0x50/0xc0 drivers/tty/tty_ldisc.c:639
 tty_ldisc_hangup+0x2a6/0x5c0 drivers/tty/tty_ldisc.c:758
 __tty_hangup.part.22+0x2e6/0x690 drivers/tty/tty_io.c:612
 __tty_hangup drivers/tty/tty_io.c:570
 tty_vhangup+0x26/0x30 drivers/tty/tty_io.c:684
 pty_close+0x36a/0x4b0 drivers/tty/pty.c:77
 tty_release+0x44b/0x1520 drivers/tty/tty_io.c:1638
 __fput+0x33e/0x800 fs/file_table.c:210
 ____fput+0x1a/0x20 fs/file_table.c:244
 task_work_run+0x1af/0x280 kernel/task_work.c:112
 tracehook_notify_resume ./include/linux/tracehook.h:191
 exit_to_usermode_loop+0x1e1/0x220 arch/x86/entry/common.c:162
 prepare_exit_to_usermode arch/x86/entry/common.c:197
 syscall_return_slowpath+0x414/0x480 arch/x86/entry/common.c:266
 entry_SYSCALL_64_fastpath+0xc0/0xc2 arch/x86/entry/entry_64.S:238

The buggy address belongs to the object at ffff880063ba9a80
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 20 bytes to the right of
 64-byte region [ffff880063ba9a80, ffff880063ba9ac0)
The buggy address belongs to the page:
page:ffffea00018eea40 count:1 mapcount:0 mapping:          (null) index:0x0
flags: 0x100000000000100(slab)
raw: 0100000000000100 0000000000000000 0000000000000000 00000001802a002a
raw: ffffea0001a42280 0000000a0000000a ffff88006c403800 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff880063ba9980: 00 00 fc fc fc fc fc fc fb fb fb fb fb fb fb fb
 ffff880063ba9a00: fc fc fc fc fb fb fb fb fb fb fb fb fc fc fc fc
>ffff880063ba9a80: fb fb fb fb fb fb fb fb fc fc fc fc fb fb fb fb
                                                 ^
 ffff880063ba9b00: fb fb fb fb fc fc fc fc 00 00 00 00 00 fc fc fc
 ffff880063ba9b80: fc fc fc fc fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================
