From: Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Kernel v4.3 - RCU hang, USB + SCSI implicated
Date: Mon, 14 Dec 2015 12:42:50 -0500
Message-ID: <CAKb7Uvhn=XdD23xQn5qDiqP6L8WLDSCDegFbwdtQk=jEYD9XJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-usb@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Oliver Neukum <oneukum@suse.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

This is a follow-up to an earlier report where I was directed by
Oliver Neukum to repost to linux-scsi. I got lazy and forgot, but the
same issue happened a second time.

Original posting at: https://lkml.org/lkml/2015/11/16/569

This is an Intel Haswell system, DELL U2415 monitor (which has a USB
hub, with a mouse connected) connected over USB which in turn suspends
after a while (and disconnects from the bus). There's also a flash
reader thing in the computer case, which is also (internally)
connected over USB, but I don't think that powers down. However
they're on the same bus according to lsusb.

It seems that this time my SATA driver also got taken down this time
and so the log messages are a bit odd... they have ATA EH recovery
messages interspersed in them (but the logs made it to disk, so it
worked). Pardon the gmail-induced wrapping :(

Please let me know if there's any additional info I might provide to
help track this down.

Thanks,

  -ilia


Log:

INFO: rcu_sched detected stalls on CPUs/tasks:
\x090: (1 GPs behind) idle=e1d/140000000000001/0
softirq=78957631/78957633 fqs=6975
\x09(detected by 2, t=21002 jiffies, g=109144013, c=109144012, q=26882)
Task dump for CPU 0:
cc1plus         R  running task    14472 15396  15395 0x00000008
 0000000000000000 00007fb90b706004 ffff880049264280 0000000000000007
 ffff88000b587f58 ffff88003ebd3e80 ffff88000b587f38 ffffffff8108d834
 ffff88003ebd3e80 0000000000000002 ffff8800492642e8 0000000800000000
Call Trace:
 [<ffffffff8108d834>] ? __do_page_fault+0x1b4/0x400
 [<ffffffff818be91b>] ? retint_user+0x8/0xd
xhci_hcd 0000:00:14.0: xHCI host not responding to stop endpoint command.
xhci_hcd 0000:00:14.0: Assuming host is dying, halting host.
xhci_hcd 0000:00:14.0: HC died; cleaning up
usb 1-7: USB disconnect, device number 2
usb 2-4: USB disconnect, device number 2
usb 2-4.4: USB disconnect, device number 3
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 10 pio 16392
in\x0a         Get event status notification 4a 01 00 00 10 00 00 00
08 00res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2.00: status: { DRDY }
ata2: hard resetting link
ata1.00: exception Emask 0x0 SAct 0x7fff0000 SErr 0x0 action 0x6 frozen
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/08:80:28:be:e0/00:00:5d:00:00/40 tag 16 ncq 4096
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/e0:88:78:31:e1/00:00:5d:00:00/40 tag 17 ncq 114688
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/28:90:e8:d6:cd/00:00:25:00:00/40 tag 18 ncq 20480
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/60:98:10:d7:cd/01:00:25:00:00/40 tag 19 ncq 180224
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/18:a0:70:d8:cd/00:00:25:00:00/40 tag 20 ncq 12288
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/08:a8:38:b5:cd/00:00:25:00:00/40 tag 21 ncq 4096
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/10:b0:90:d6:cd/00:00:25:00:00/40 tag 22 ncq 8192
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/08:b8:e8:3a:04/00:00:21:00:00/40 tag 23 ncq 4096
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/08:c0:f0:3a:04/00:00:21:00:00/40 tag 24 ncq 4096
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/08:c8:08:3b:04/00:00:21:00:00/40 tag 25 ncq 4096
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/08:d0:10:3b:04/00:00:21:00:00/40 tag 26 ncq 4096
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/08:d8:20:3b:04/00:00:21:00:00/40 tag 27 ncq 4096
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/08:e0:38:3b:04/00:00:21:00:00/40 tag 28 ncq 4096
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/08:e8:30:3b:04/00:00:21:00:00/40 tag 29 ncq 4096
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/08:f0:40:3b:04/00:00:21:00:00/40 tag 30 ncq 4096
out\x0a         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
ata1.00: status: { DRDY }
ata1: hard resetting link
ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/133
ata1.00: device reported invalid CHS sector 0
ata1.00: device reported invalid CHS sector 0
ata1.00: device reported invalid CHS sector 0
ata1: EH complete
ata2.00: configured for UDMA/100
ata2: EH complete
INFO: rcu_sched detected expedited stalls on CPUs: { 0 1 2 3 4 5 6 7 }
21000 jiffies s: 35513
Task dump for CPU 0:
cc1plus         R  running task    14472 15396  15395 0x00000008
 0000000000000000 00007fb90b706004 ffff880049264280 0000000000000007
 ffff88000b587f58 ffff88003ebd3e80 ffff88000b587f38 ffffffff8108d834
 ffff88003ebd3e80 0000000000000002 ffff8800492642e8 0000000800000000
Call Trace:
 [<ffffffff8108d834>] ? __do_page_fault+0x1b4/0x400
 [<ffffffff818be91b>] ? retint_user+0x8/0xd
Task dump for CPU 1:
cc1plus         R  running task    14448 15555  15554 0x00000000
 0000000000000000 00007f19b456c000 ffff880214fa4d00 0000000000000006
 ffff8800c1dc3f58 ffff8800bfad8c80 ffff8800c1dc3f38 ffffffff8108d834
 ffff880214fa4d68 0000000000000002 ffff880214fa4d68 0000000000000000
Call Trace:
 [<ffffffff8108d834>] ? __do_page_fault+0x1b4/0x400
 [<ffffffff818be91b>] ? retint_user+0x8/0xd
Task dump for CPU 2:
kworker/2:3     R  running task    13152 15411      2 0x00000000
Workqueue: usb_hub_wq hub_event
 ffff8801ac3efa08 ffff8801ac3ef9c8 ffffffff8111dfc8 0000000000000002
 ffff8801ac3efa08 ffff8801ac3ef9e0 ffffffff8111fd39 0000000000000002
 ffff8801ac3efa30 ffffffff81146727 ffff880100000000 ffff8800068bd780
Call Trace:
 [<ffffffff8111dfc8>] sched_show_task+0xc8/0x130
 [<ffffffff8111fd39>] dump_cpu_task+0x39/0x40
 [<ffffffff81146727>] synchronize_sched_expedited_wait.constprop.64+0x1f7/0x220
 [<ffffffff8112d420>] ? wait_woken+0x80/0x80
 [<ffffffff81146945>] synchronize_sched_expedited+0x1f5/0x2e0
 [<ffffffff81146a3e>] synchronize_rcu_expedited+0xe/0x10
 [<ffffffff811c8eaf>] bdi_unregister+0x4f/0x100
 [<ffffffff813a6fff>] blk_cleanup_queue+0xef/0x120
 [<ffffffff815c79b4>] __scsi_remove_device+0x54/0xd0
 [<ffffffff815c6060>] scsi_forget_host+0x60/0x70
 [<ffffffff815bb947>] scsi_remove_host+0x77/0x110
 [<ffffffff81661629>] usb_stor_disconnect+0x59/0xc0
 [<ffffffff8162c723>] usb_unbind_interface+0x83/0x270
 [<ffffffff8159a8e6>] __device_release_driver+0x96/0x130
 [<ffffffff8159a9a3>] device_release_driver+0x23/0x30
 [<ffffffff81599a88>] bus_remove_device+0xf8/0x140
 [<ffffffff81596499>] device_del+0x139/0x270
 [<ffffffff81630c1f>] ? usb_remove_ep_devs+0x1f/0x30
 [<ffffffff8162a270>] usb_disable_device+0xa0/0x1f0
 [<ffffffff81621767>] usb_disconnect+0x87/0x230
 [<ffffffff8162196a>] hub_quiesce+0x5a/0xb0
 [<ffffffff8162310f>] hub_event+0x33f/0x1180
 [<ffffffff81127832>] ? pick_next_task_fair+0x1a2/0x970
 [<ffffffff8110dd2c>] process_one_work+0x14c/0x3d0
 [<ffffffff8110e2cb>] worker_thread+0x4b/0x440
 [<ffffffff818b9f15>] ? __schedule+0x335/0x8e0
 [<ffffffff8110e280>] ? rescuer_thread+0x2d0/0x2d0
 [<ffffffff8110e280>] ? rescuer_thread+0x2d0/0x2d0
 [<ffffffff81112e39>] kthread+0xc9/0xe0
 [<ffffffff81112d70>] ? kthread_park+0x60/0x60
 [<ffffffff818be1af>] ret_from_fork+0x3f/0x70
 [<ffffffff81112d70>] ? kthread_park+0x60/0x60
Task dump for CPU 3:
cc1plus         R  running task    14264 15558  15557 0x00000000
 0000000181f1a900 ffff88022fad8d00 ffff880185ebfce8 ffff88022fad8d20
 ffff88022fad8d30 0000010000000000 ffffffff81f1b518 000000000000001f
 ffff880100000141 ffffffff811d6400 0000000000000040 ffffffff000280da
Call Trace:
 [<ffffffff811d6400>] ? handle_mm_fault+0xe10/0xf00
 [<ffffffff811b5921>] ? __alloc_pages_nodemask+0x101/0x7f0
 [<ffffffff811b54ff>] ? get_page_from_freelist+0x41f/0x660
 [<ffffffff813dd635>] ? find_next_bit+0x15/0x20
 [<ffffffff81093ead>] ? flush_tlb_page+0x3d/0x80
 [<ffffffff811b5921>] ? __alloc_pages_nodemask+0x101/0x7f0
 [<ffffffff811d4496>] ? do_wp_page+0x86/0x5a0
 [<ffffffff811b9fd0>] ? lru_deactivate_file_fn+0x170/0x170
 [<ffffffff811baf27>] ? lru_cache_add_active_or_unevictable+0x27/0x70
 [<ffffffff811d6400>] ? handle_mm_fault+0xe10/0xf00
 [<ffffffff811c689d>] ? vm_mmap_pgoff+0x9d/0xc0
 [<ffffffff8108d834>] ? __do_page_fault+0x1b4/0x400
 [<ffffffff818be91b>] ? retint_user+0x8/0xd
Task dump for CPU 4:
swapper/4       R  running task    15136     0      1 0x00200000
 ffffffff816cbf54 0007c787c2484d5c 0000033826a5fec8 ffffffff81ebcab8
 ffffffff81f39d18 ffff880226a60000 ffff88022fb1d618 ffffffff81ebc8c0
 ffff880226a5c000 ffff880226a5fec0 ffffffff816cc0e7 ffff880226a5fed8
Call Trace:
 [<ffffffff816cbf54>] ? cpuidle_enter_state+0xb4/0x210
 [<ffffffff816cc0e7>] ? cpuidle_enter+0x17/0x20
 [<ffffffff8112d842>] ? call_cpuidle+0x32/0x60
 [<ffffffff816cc0c3>] ? cpuidle_select+0x13/0x20
 [<ffffffff8112dab3>] ? cpu_startup_entry+0x243/0x2f0
 [<ffffffff8107e92c>] ? start_secondary+0x12c/0x140
Task dump for CPU 5:
swapper/5       R  running task    15136     0      1 0x00200000
 ffffffff816cbf54 0007c787c2484d1e 0000002d26a63ec8 ffffffff81ebc9f8
 ffffffff81f39d18 ffff880226a64000 ffff88022fb5d618 ffffffff81ebc8c0
 ffff880226a60000 ffff880226a63ec0 ffffffff816cc0e7 ffff880226a63ed8
Call Trace:
 [<ffffffff816cbf54>] ? cpuidle_enter_state+0xb4/0x210
 [<ffffffff816cc0e7>] ? cpuidle_enter+0x17/0x20
 [<ffffffff8112d842>] ? call_cpuidle+0x32/0x60
 [<ffffffff816cc0c3>] ? cpuidle_select+0x13/0x20
 [<ffffffff8112dab3>] ? cpu_startup_entry+0x243/0x2f0
 [<ffffffff8107e92c>] ? start_secondary+0x12c/0x140
Task dump for CPU 6:
swapper/6       R  running task    15136     0      1 0x00200000
 ffffffff816cbf54 0007c787c24849a2 0000001f26a67ec8 ffffffff81ebc998
 ffffffff81f39d18 ffff880226a68000 ffff88022fb9d618 ffffffff81ebc8c0
 ffff880226a64000 ffff880226a67ec0 ffffffff816cc0e7 ffff880226a67ed8
Call Trace:
 [<ffffffff816cbf54>] ? cpuidle_enter_state+0xb4/0x210
 [<ffffffff816cc0e7>] ? cpuidle_enter+0x17/0x20
 [<ffffffff8112d842>] ? call_cpuidle+0x32/0x60
 [<ffffffff816cc0c3>] ? cpuidle_select+0x13/0x20
 [<ffffffff8112dab3>] ? cpu_startup_entry+0x243/0x2f0
 [<ffffffff8107e92c>] ? start_secondary+0x12c/0x140
Task dump for CPU 7:
swapper/7       R  running task    15136     0      1 0x00200000
 ffffffff816cbf54 0007c787c24845f3 0000033d26a6bec8 ffffffff81ebcab8
 ffffffff81f39d18 ffff880226a6c000 ffff88022fbdd618 ffffffff81ebc8c0
 ffff880226a68000 ffff880226a6bec0 ffffffff816cc0e7 ffff880226a6bed8
Call Trace:
 [<ffffffff816cbf54>] ? cpuidle_enter_state+0xb4/0x210
 [<ffffffff816cc0e7>] ? cpuidle_enter+0x17/0x20
 [<ffffffff8112d842>] ? call_cpuidle+0x32/0x60
 [<ffffffff816cc0c3>] ? cpuidle_select+0x13/0x20
 [<ffffffff8112dab3>] ? cpu_startup_entry+0x243/0x2f0
 [<ffffffff8107e92c>] ? start_secondary+0x12c/0x140
