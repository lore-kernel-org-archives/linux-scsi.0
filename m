From: Walter Haidinger <walter.haidinger@k9-shop.com>
Subject: 2.6.35.14 kernel panic during boot on CentOS 5.7
Date: Tue, 25 Oct 2011 17:32:20 +0200
Message-ID: <4EA6D684.90909@k9-shop.com>
References: <4EA53ECB.2030801@k9-shop.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EA53ECB.2030801@k9-shop.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi!

I've hit a reproducible kernel panic when booting CentOS 5.7
(x86_64, all updates) on a machine with vanilla 2.6.35.14
after upgrading from a dual-core Athlon X2 to a Phenom II
X6 1100T. The mainboard (Asus M3A-H/HDMI) was updated with
the latest BIOS available (2101).
Note: previous 2.6.35.13 works, also 2.6.35.14 with
Athlon X2 or similar machine (same OS/MB) with 2.6.35.14
and Phenom II X4 965. Only the six-core X6 panics 2.6.35.14.

The kernel panics every time when running /sbin/start_udev
from /etc/rc.d/rc.sysinit during a regular boot. I've been
able to "bypass" the panic with the "confirm" RHEL kernel
option sometimes, but not always. Odd, yes.
Booting into single user mode always works.

I'm pasting the kernel panic below, captured from a serial
console with the "debugmodprobe" RHEL kernel option added.

I'd be happy to provide any other information if required.

Walter

...
INIT: version 2.86 booting
                Welcome to  CentOS release 5.7 (Final)
                Press 'I' to enter interactive startup.
Setting clock  (utc): Fri Oct 21 12:02:08 CEST 2011 [  OK  ]
Starting udev: modprobe: FATAL: Module platform:pcspkr not found.
modprobe: FATAL: Module platform:vesafb not found.
modprobe: FATAL: Module pci:v00001022d00009606sv00001002sd00007910bc06sc04i00 not found.
[CUT: lots of failed module loads]
insmod /lib/modules/2.6.35.14-k9/kernel/drivers/usb/storage/usb-libusual.ko
insmod /lib/modules/2.6.35.14-k9/kernel/drivers/usb/serial/usb_wwan.ko
insmod /lib/modules/2.6.35.14-k9/kernel/drivers/usb/serial/option.ko
modprobe: FATAL: Module hid:b0003v0000051Dp00000002 not found.

[   49.284505] general protection fault: 0000 [#1]
[   49.287660] sd 8:0:0:0: [sdf] Assuming drive cache: write through
[   49.287663]  sdf:SMP
[   49.294480] last sysfs file: /sys/devices/pci0000:00/0000:00:12.2/usb1/1-4/dev
[   49.294480] CPU 2
[   49.294480] Modules linked in: option usb_wwan usb_storage usb_libusual usbserial usbhid hid asus_atk0110 sr_mod cdrom mousee
[   49.294480]
[   49.294480] Pid: 8, comm: ksoftirqd/2 Not tainted 2.6.35.14-k9 #6 M3A-H/HDMI/System Product Name
[   49.294480] RIP: 0010:[<ffffffff81154290>]  [<ffffffff81154290>] elv_queue_empty+0x20/0x30
[   49.294480] RSP: 0018:ffff880001883d58  EFLAGS: 00010086
[   49.294480] RAX: 0000000000000001 RBX: ffff88021e5c9190 RCX: ffff880001883dd8
[   49.294480] RDX: dead000000200200 RSI: 0000000000000246 RDI: ffff88021e5c9190
[   49.294480] RBP: ffff880001883d58 R08: 00000002f604e111 R09: 0000000000000000
[   49.294480] R10: ffff8800018d2368 R11: 0000000000000000 R12: 0000000000000286
[   49.294480] R13: ffff88021cab4000 R14: ffff88021cab4040 R15: ffff880001883dd8
[   49.294480] FS:  00007f6b3b4d8710(0000) GS:ffff880001880000(0000) knlGS:0000000000000000
[   49.294480] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   49.294480] CR2: 00007f6b3ac06ea0 CR3: 000000021e2a2000 CR4: 00000000000006e0
[   49.294480] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   49.294480] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   49.294480] Process ksoftirqd/2 (pid: 8, threadinfo ffff88021fc9c000, task ffff88021fc94350)
[   49.294480] Stack:
[   49.294480]  ffff880001883d78 ffffffff811564c2 ffff88021cab4040 ffff88021e5c9190
[   49.294480] <0> ffff880001883d98 ffffffff8115710b ffff88021cab7000 ffff88021e512320
[   49.294480] <0> ffff880001883e18 ffffffffa00ae7ae ffff880001883db8 ffffffff811feed2
[   49.294480] Call Trace:
[   49.294480]  <IRQ>
[   49.294480]  [<ffffffff811564c2>] __blk_run_queue+0x22/0x150
[   49.294480]  [<ffffffff8115710b>] blk_run_queue+0x2b/0x50
[   49.294480]  [<ffffffffa00ae7ae>] scsi_run_queue+0x13e/0x380 [scsi_mod]
[   49.294480]  [<ffffffff811feed2>] ? put_device+0x12/0x20
[   49.294480]  [<ffffffffa00af31d>] scsi_next_command+0x3d/0x60 [scsi_mod]
[   49.294480]  [<ffffffffa00b022e>] scsi_io_completion+0x33e/0x540 [scsi_mod]
[   49.294480]  [<ffffffffa00a867e>] scsi_finish_command+0xbe/0x130 [scsi_mod]
[   49.294480]  [<ffffffffa00b0575>] scsi_softirq_done+0x145/0x180 [scsi_mod]
[   49.294480]  [<ffffffff8115b38b>] blk_done_softirq+0x6b/0x80
[   49.294480]  [<ffffffff81003a0c>] ? call_softirq+0x1c/0x30
[   49.294480]  [<ffffffff81048492>] __do_softirq+0xb2/0x150
[   49.294480]  [<ffffffff81003a0c>] call_softirq+0x1c/0x30
[   49.294480]  <EOI>
[   49.294480]  [<ffffffff8100598a>] ? do_softirq+0x4a/0x80
[   49.294480]  [<ffffffff810482b0>] run_ksoftirqd+0x80/0x130
[   49.294480]  [<ffffffff81048230>] ? run_ksoftirqd+0x0/0x130
[   49.294480]  [<ffffffff8105922e>] kthread+0x8e/0xa0
[   49.294480]  [<ffffffff81003914>] kernel_thread_helper+0x4/0x10
[   49.294480]  [<ffffffff810591a0>] ? kthread+0x0/0xa0
[   49.294480]  [<ffffffff81003910>] ? kernel_thread_helper+0x0/0x10
[   49.294480] Code: 00 00 00 eb a3 66 0f 1f 44 00 00 31 c0 48 39 3f 55 48 8b 57 18 48 89 e5 75 13 48 8b 02 48 8b 50 48 b8 01 0
[   49.294480] RIP  [<ffffffff81154290>] elv_queue_empty+0x20/0x30
[   49.294480]  RSP <ffff880001883d58>
[   49.294480] ---[ end trace e244e0a0bab81f34 ]---
[   49.294480] Kernel panic - not syncing: Fatal exception in interrupt
[   49.294480] Pid: 8, comm: ksoftirqd/2 Tainted: G      D     2.6.35.14-k9 #6
[   49.294480] Call Trace:
[   49.294480]  <IRQ>  [<ffffffff810429f4>] panic+0xb4/0x140
[   49.294480]  [<ffffffff8105dc84>] ? up+0x34/0x50
[   49.294480]  [<ffffffff810443b0>] ? kmsg_dump+0x110/0x180
[   49.294480]  [<ffffffff81006dac>] oops_end+0xcc/0xe0
[   49.294480]  [<ffffffff81006eb6>] die+0x56/0x90
[   49.294480]  [<ffffffff81004a12>] do_general_protection+0x152/0x160
[   49.294480]  [<ffffffff812e2eaf>] general_protection+0x1f/0x30
[   49.294480]  [<ffffffff81154290>] ? elv_queue_empty+0x20/0x30
[   49.294480]  [<ffffffff81154292>] ? elv_queue_empty+0x22/0x30
[   49.294480]  [<ffffffff811564c2>] __blk_run_queue+0x22/0x150
[   49.294480]  [<ffffffff8115710b>] blk_run_queue+0x2b/0x50
[   49.294480]  [<ffffffffa00ae7ae>] scsi_run_queue+0x13e/0x380 [scsi_mod]
[   49.294480]  [<ffffffff811feed2>] ? put_device+0x12/0x20
[   49.294480]  [<ffffffffa00af31d>] scsi_next_command+0x3d/0x60 [scsi_mod]
[   49.294480]  [<ffffffffa00b022e>] scsi_io_completion+0x33e/0x540 [scsi_mod]
[   49.294480]  [<ffffffffa00a867e>] scsi_finish_command+0xbe/0x130 [scsi_mod]
[   49.294480]  [<ffffffffa00b0575>] scsi_softirq_done+0x145/0x180 [scsi_mod]
[   49.294480]  [<ffffffff8115b38b>] blk_done_softirq+0x6b/0x80
[   49.294480] Pid: 8, comm: ksoftirqd/2 Tainted: G      D     2.6.35.14-k9 #6
[   49.294480] Call Trace:
[   49.294480]  <IRQ>  [<ffffffff810429f4>] panic+0xb4/0x140
[   49.294480]  [<ffffffff8105dc84>] ? up+0x34/0x50
[   49.294480]  [<ffffffff810443b0>] ? kmsg_dump+0x110/0x180
[   49.294480]  [<ffffffff81006dac>] oops_end+0xcc/0xe0
[   49.294480]  [<ffffffff81006eb6>] die+0x56/0x90
[   49.294480]  [<ffffffff81004a12>] do_general_protection+0x152/0x160
[   49.294480]  [<ffffffff812e2eaf>] general_protection+0x1f/0x30
[   49.294480]  [<ffffffff81154290>] ? elv_queue_empty+0x20/0x30
[   49.294480]  [<ffffffff81154292>] ? elv_queue_empty+0x22/0x30
[   49.294480]  [<ffffffff811564c2>] __blk_run_queue+0x22/0x150
[   49.294480]  [<ffffffff8115710b>] blk_run_queue+0x2b/0x50
[   49.294480]  [<ffffffffa00ae7ae>] scsi_run_queue+0x13e/0x380 [scsi_mod]
[   49.294480]  [<ffffffff811feed2>] ? put_device+0x12/0x20
[   49.294480]  [<ffffffffa00af31d>] scsi_next_command+0x3d/0x60 [scsi_mod]
[   49.294480]  [<ffffffffa00b022e>] scsi_io_completion+0x33e/0x540 [scsi_mod]
[   49.294480]  [<ffffffffa00a867e>] scsi_finish_command+0xbe/0x130 [scsi_mod]
[   49.294480]  [<ffffffffa00b0575>] scsi_softirq_done+0x145/0x180 [scsi_mod]
[   49.294480]  [<ffffffff8115b38b>] blk_done_softirq+0x6b/0x80
[   49.294480]  [<ffffffff81003a0c>] ? call_softirq+0x1c/0x30
[   49.294480]  [<ffffffff81048492>] __do_softirq+0xb2/0x150
[   49.294480]  [<ffffffff81003a0c>] call_softirq+0x1c/0x30
[   49.294480]  <EOI>  [<ffffffff8100598a>] ? do_softirq+0x4a/0x80
[   49.294480]  [<ffffffff810482b0>] run_ksoftirqd+0x80/0x130
[   49.294480]  [<ffffffff81048230>] ? run_ksoftirqd+0x0/0x130
[   49.294480]  [<ffffffff8105922e>] kthread+0x8e/0xa0
[   49.294480]  [<ffffffff81003914>] kernel_thread_helper+0x4/0x10
[   49.294480]  [<ffffffff810591a0>] ? kthread+0x0/0xa0
[   49.294480]  [<ffffffff81003910>] ? kernel_thread_helper+0x0/0x10
[   49.294480] panic occurred, switching back to text console
