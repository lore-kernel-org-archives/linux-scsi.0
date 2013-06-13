From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [__blk_mq_run_hw_queue] BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000008
Date: Thu, 13 Jun 2013 09:47:44 +0800
Message-ID: <20130613014742.GA8079@localhost>
References: <20130613013032.GA7558@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130613013032.GA7558@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 13, 2013 at 09:30:32AM +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit a256ba092ec57213f96059d41ac5473ff92f5e7c
> Author: Nicholas Bellinger <nab@linux-iscsi.org>
> Date:   Sat May 18 02:40:43 2013 -0700
> 
>     scsi: Split scsi_dispatch_cmd into __scsi_dispatch_cmd setup
>     
>     Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> 
> [   29.326637]  vda: unknown partition table
> [   29.386474] ------------[ cut here ]------------
> [   29.388453] WARNING: at /c/kernel-tests/src/stable/fs/sysfs/dir.c:530 sysfs_add_one+0x96/0xaa()
> [   29.391061] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:05.0/virtio1/block/vda/mq/0/cpu0'
> [   29.403737] Modules linked in:
> [   29.406289] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc4-13319-g10adcdf #541
> [   29.407936] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [   29.410433]  ffffffff81d9d860 ffff88001df65958 ffffffff81994579 ffff88001df65998
> [   29.416742]  ffffffff81068740 ffff88001bf6f000 ffff88001df659a8 ffff88001bf6f000
> [   29.418708]  ffff88001b8fee60 00000000ffffffef ffff88001df65a48 ffff88001df659f8
> [   29.431422] Call Trace:
> [   29.433133]  [<ffffffff81994579>] dump_stack+0x19/0x1b
> [   29.434352]  [<ffffffff81068740>] warn_slowpath_common+0x67/0x80
> [   29.435606]  [<ffffffff810687fc>] warn_slowpath_fmt+0x46/0x48
> [   29.437753]  [<ffffffff811c0130>] sysfs_add_one+0x96/0xaa
> [   29.439068]  [<ffffffff811c02b5>] create_dir+0x70/0xb2
> [   29.451011]  [<ffffffff811c05b6>] sysfs_create_dir+0x9d/0xbb
> [   29.453076]  [<ffffffff81461f19>] kobject_add_internal+0x11e/0x222
> [   29.454405]  [<ffffffff81462220>] kobject_add+0x8b/0xa4
> [   29.455543]  [<ffffffff8144b70d>] ? blk_mq_register_disk+0x72/0x18d
> [   29.457534]  [<ffffffff8144b7bc>] blk_mq_register_disk+0x121/0x18d
> [   29.458956]  [<ffffffff81444464>] blk_register_queue+0xb1/0x121
> [   29.470939]  [<ffffffff8144d0b1>] ? disk_part_iter_next+0x27/0x126
> [   29.473011]  [<ffffffff8144df8f>] add_disk+0x33b/0x45b
> [   29.474129]  [<ffffffff815518fc>] virtblk_probe+0x4d6/0x5da
> [   29.475266]  [<ffffffff8153e7e5>] ? driver_probe_device+0x2f7/0x2f7
> [   29.477436]  [<ffffffff814e915b>] virtio_dev_probe+0xba/0xf9
> [   29.478740]  [<ffffffff8153e60a>] driver_probe_device+0x11c/0x2f7
> [   29.490567]  [<ffffffff8153e848>] __driver_attach+0x63/0x86
> [   29.491880]  [<ffffffff8153c868>] bus_for_each_dev+0x5f/0x91
> [   29.493903]  [<ffffffff8153df8d>] driver_attach+0x1e/0x20
> [   29.495102]  [<ffffffff8153dbbe>] bus_add_driver+0x11d/0x241
> [   29.497041]  [<ffffffff8153ee52>] driver_register+0x96/0x11c
> [   29.498262]  [<ffffffff82358d87>] ? loop_init+0x147/0x147
> [   29.499433]  [<ffffffff814e9303>] register_virtio_driver+0x2b/0x30
> [   29.511350]  [<ffffffff82358ddb>] init+0x54/0x8b
> [   29.513134]  [<ffffffff8100028d>] do_one_initcall+0xa0/0x137
> [   29.514312]  [<ffffffff82314e1a>] kernel_init_freeable+0x13c/0x1cb
> [   29.515532]  [<ffffffff823146ee>] ? do_early_param+0x8d/0x8d
> [   29.517357]  [<ffffffff8197dee9>] ? rest_init+0xdd/0xdd
> [   29.518558]  [<ffffffff8197def7>] kernel_init+0xe/0xdb
> [   29.527871]  [<ffffffff819a641c>] ret_from_fork+0x7c/0xb0
> [   29.529838]  [<ffffffff8197dee9>] ? rest_init+0xdd/0xdd
> [   29.531584] ---[ end trace dfaab53c7b1f7bcc ]---

Note that its parent commit 5754ab54c1b28888e9700550585c5729fccbd15f
(which is not necessarily the first bad commit) has another BUG.
Attached are 3 dmesg files which show the same stack trace.

[  147.913606] brd: module loaded
[  149.169462] loop: module loaded
[  149.297799] blk-mq: CPU -> queue map
[  149.298999]   CPU 0 -> Queue 0
[  149.624693] INFO: trying to register non-static key.
[  149.624988] the code is fine but needs lockdep annotation.
[  149.624988] turning off the locking correctness validator.
[  149.624988] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00011-g5754ab5 #131
[  149.624988] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  149.624988]  ffff88001ed18000 ffff88001ed134c8 ffffffff8190e5c9 ffff88001ed13538
[  149.624988]  ffffffff810854bc 0000000000000000 0000000000000000 0000000000000000
[  149.624988]  ffffffff81086394 ffff88001ed13518 0000000200000000 ffff88001f1d44c0
[  149.624988] Call Trace:
[  149.624988]  [<ffffffff8190e5c9>] dump_stack+0x19/0x1b
[  149.624988]  [<ffffffff810854bc>] __lock_acquire+0x842/0x951
[  149.624988]  [<ffffffff81086394>] ? trace_hardirqs_on_caller+0x14e/0x1aa
[  149.624988]  [<ffffffff81085b25>] lock_acquire+0xdb/0x127
[  149.624988]  [<ffffffff813f2042>] ? __blk_mq_run_hw_queue+0x8d/0x385
[  149.624988]  [<ffffffff810816b8>] ? lock_release_holdtime.part.6+0xa1/0xa6
[  149.624988]  [<ffffffff8191854d>] _raw_spin_lock+0x45/0x78
[  149.624988]  [<ffffffff813f2042>] ? __blk_mq_run_hw_queue+0x8d/0x385
[  149.624988]  [<ffffffff81918eef>] ? _raw_spin_unlock+0x29/0x3d
[  149.624988]  [<ffffffff813f2042>] __blk_mq_run_hw_queue+0x8d/0x385
[  149.624988]  [<ffffffff813f2ae7>] ? blk_mq_make_request+0x389/0x458
[  149.624988]  [<ffffffff813f2745>] blk_mq_run_hw_queue+0x1e/0x37
[  149.624988]  [<ffffffff813f2b02>] blk_mq_make_request+0x3a4/0x458
[  149.624988]  [<ffffffff813e96ae>] generic_make_request+0x9f/0xe0
[  149.624988]  [<ffffffff813e97e4>] submit_bio+0xf5/0x113
[  149.624988]  [<ffffffff811409b2>] _submit_bh+0x1b0/0x1d1
[  149.624988]  [<ffffffff811409e3>] submit_bh+0x10/0x12
[  149.624988]  [<ffffffff811434ba>] block_read_full_page+0x255/0x271
[  149.624988]  [<ffffffff811461b9>] ? I_BDEV+0xd/0xd
[  149.624988]  [<ffffffff810d7e7b>] ? add_to_page_cache_locked+0xb5/0x13e
[  149.624988]  [<ffffffff81146745>] ? blkdev_write_begin+0x25/0x25
[  149.624988]  [<ffffffff8114675d>] blkdev_readpage+0x18/0x1a
[  149.624988]  [<ffffffff810d7fd2>] do_read_cache_page+0x90/0x15d
[  149.624988]  [<ffffffff813fb33d>] ? efi_partition+0xce/0x53d
[  149.624988]  [<ffffffff810d80e3>] read_cache_page_async+0x1c/0x1e
[  149.624988]  [<ffffffff810d80f3>] read_cache_page+0xe/0x18
[  149.624988]  [<ffffffff813f8210>] read_dev_sector+0x30/0x8a
[  149.624988]  [<ffffffff813fadd4>] read_lba+0x9e/0x106
[  149.624988]  [<ffffffff813fb35e>] efi_partition+0xef/0x53d
[  149.624988]  [<ffffffff8140bdbc>] ? snprintf+0x34/0x36
[  149.624988]  [<ffffffff813f923f>] check_partition+0x114/0x1c1
[  149.624988]  [<ffffffff813f8e7f>] rescan_partitions+0xa6/0x2a7
[  149.624988]  [<ffffffff81918eef>] ? _raw_spin_unlock+0x29/0x3d
[  149.624988]  [<ffffffff811475c1>] __blkdev_get+0x17d/0x3b9
[  149.624988]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  149.624988]  [<ffffffff8114798c>] blkdev_get+0x18f/0x30a
[  149.624988]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  149.624988]  [<ffffffff8114663d>] ? bdget+0x121/0x131
[  149.624988]  [<ffffffff814e3f8e>] ? put_device+0x17/0x19
[  149.624988]  [<ffffffff813f6b28>] add_disk+0x2de/0x452
[  149.624988]  [<ffffffff81496b0e>] ? vp_get+0x4b/0x5f
[  149.624988]  [<ffffffff814f89ea>] virtblk_probe+0x4d5/0x5d9
[  149.624988]  [<ffffffff814e7cfb>] ? driver_probe_device+0x1bd/0x1bd
[  149.624988]  [<ffffffff81494dff>] virtio_dev_probe+0xba/0xf9
[  149.624988]  [<ffffffff814e7bdd>] driver_probe_device+0x9f/0x1bd
[  149.624988]  [<ffffffff814e7d5d>] __driver_attach+0x62/0x85
[  149.624988]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  149.624988]  [<ffffffff814e6198>] bus_for_each_dev+0x5c/0x8e
[  149.624988]  [<ffffffff814e774b>] driver_attach+0x1e/0x20
[  149.624988]  [<ffffffff814e7316>] bus_add_driver+0xf0/0x214
[  149.624988]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  149.624988]  [<ffffffff814e831c>] driver_register+0x93/0x119
[  149.624988]  [<ffffffff820d022c>] ? loop_init+0x147/0x147
[  149.624988]  [<ffffffff81494fa7>] register_virtio_driver+0x2b/0x30
[  149.624988]  [<ffffffff820d0280>] init+0x54/0x8b
[  149.624988]  [<ffffffff8100026d>] do_one_initcall+0x80/0x117
[  149.624988]  [<ffffffff8208fdbb>] kernel_init_freeable+0x13c/0x1cb
[  149.624988]  [<ffffffff8208f6bb>] ? do_early_param+0x8d/0x8d
[  149.624988]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  149.624988]  [<ffffffff818f7362>] kernel_init+0xe/0xd1
[  149.624988]  [<ffffffff819203dc>] ret_from_fork+0x7c/0xb0
[  149.624988]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  149.757670] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[  149.760321] IP: [<ffffffff813f2057>] __blk_mq_run_hw_queue+0xa2/0x385
[  149.760687] PGD 0 
[  149.760687] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[  149.760687] Modules linked in:
[  149.760687] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00011-g5754ab5 #131
[  149.760687] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  149.760687] task: ffff88001ed18000 ti: ffff88001ed12000 task.ti: ffff88001ed12000
[  149.760687] RIP: 0010:[<ffffffff813f2057>]  [<ffffffff813f2057>] __blk_mq_run_hw_queue+0xa2/0x385
[  149.760687] RSP: 0018:ffff88001ed135f8  EFLAGS: 00000217
[  149.760687] RAX: ffff88001f3db148 RBX: ffff88001f3db100 RCX: 0000000081030100
[  149.760687] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88001a6db200
[  149.760687] RBP: ffff88001ed13678 R08: 0000000000000002 R09: 0000000000000000
[  149.760687] R10: 0000000000000000 R11: ffff88001ec18000 R12: 0000000000000001
[  149.760687] R13: ffff88001ed13638 R14: ffff88001a63ca90 R15: ffff88001a63ca90
[  149.760687] FS:  0000000000000000(0000) GS:ffff88001f000000(0000) knlGS:0000000000000000
[  149.760687] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  149.760687] CR2: 0000000000000008 CR3: 0000000001dbf000 CR4: 00000000000006f0
[  149.760687] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  149.760687] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  149.760687] Stack:
[  149.760687]  ffff88001ed18000 ffff88001ed18758 ffff88001ed13628 ffff88001a622928
[  149.760687]  ffff88001ed18000 ffffffff813f2ae7 ffff88001ed13668 0000000000000246
[  149.760687]  ffff88001a6db200 ffff88001a6db200 ffff88001a622928 ffff88001a6db200
[  149.760687] Call Trace:
[  149.760687]  [<ffffffff813f2ae7>] ? blk_mq_make_request+0x389/0x458
[  149.760687]  [<ffffffff813f2745>] blk_mq_run_hw_queue+0x1e/0x37
[  149.760687]  [<ffffffff813f2b02>] blk_mq_make_request+0x3a4/0x458
[  149.760687]  [<ffffffff813e96ae>] generic_make_request+0x9f/0xe0
[  149.760687]  [<ffffffff813e97e4>] submit_bio+0xf5/0x113
[  149.760687]  [<ffffffff811409b2>] _submit_bh+0x1b0/0x1d1
[  149.760687]  [<ffffffff811409e3>] submit_bh+0x10/0x12
[  149.760687]  [<ffffffff811434ba>] block_read_full_page+0x255/0x271
[  149.760687]  [<ffffffff811461b9>] ? I_BDEV+0xd/0xd
[  149.760687]  [<ffffffff810d7e7b>] ? add_to_page_cache_locked+0xb5/0x13e
[  149.760687]  [<ffffffff81146745>] ? blkdev_write_begin+0x25/0x25
[  149.760687]  [<ffffffff8114675d>] blkdev_readpage+0x18/0x1a
[  149.760687]  [<ffffffff810d7fd2>] do_read_cache_page+0x90/0x15d
[  149.760687]  [<ffffffff813fb33d>] ? efi_partition+0xce/0x53d
[  149.760687]  [<ffffffff810d80e3>] read_cache_page_async+0x1c/0x1e
[  149.760687]  [<ffffffff810d80f3>] read_cache_page+0xe/0x18
[  149.760687]  [<ffffffff813f8210>] read_dev_sector+0x30/0x8a
[  149.760687]  [<ffffffff813fadd4>] read_lba+0x9e/0x106
[  149.760687]  [<ffffffff813fb35e>] efi_partition+0xef/0x53d
[  149.760687]  [<ffffffff8140bdbc>] ? snprintf+0x34/0x36
[  149.760687]  [<ffffffff813f923f>] check_partition+0x114/0x1c1
[  149.760687]  [<ffffffff813f8e7f>] rescan_partitions+0xa6/0x2a7
[  149.760687]  [<ffffffff81918eef>] ? _raw_spin_unlock+0x29/0x3d
[  149.760687]  [<ffffffff811475c1>] __blkdev_get+0x17d/0x3b9
[  149.760687]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  149.760687]  [<ffffffff8114798c>] blkdev_get+0x18f/0x30a
[  149.760687]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  149.760687]  [<ffffffff8114663d>] ? bdget+0x121/0x131
[  149.760687]  [<ffffffff814e3f8e>] ? put_device+0x17/0x19
[  149.760687]  [<ffffffff813f6b28>] add_disk+0x2de/0x452
[  149.760687]  [<ffffffff81496b0e>] ? vp_get+0x4b/0x5f
[  149.760687]  [<ffffffff814f89ea>] virtblk_probe+0x4d5/0x5d9
[  149.760687]  [<ffffffff814e7cfb>] ? driver_probe_device+0x1bd/0x1bd
[  149.760687]  [<ffffffff81494dff>] virtio_dev_probe+0xba/0xf9
[  149.760687]  [<ffffffff814e7bdd>] driver_probe_device+0x9f/0x1bd
[  149.760687]  [<ffffffff814e7d5d>] __driver_attach+0x62/0x85
[  149.760687]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  149.760687]  [<ffffffff814e6198>] bus_for_each_dev+0x5c/0x8e
[  149.760687]  [<ffffffff814e774b>] driver_attach+0x1e/0x20
[  149.760687]  [<ffffffff814e7316>] bus_add_driver+0xf0/0x214
[  149.760687]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  149.760687]  [<ffffffff814e831c>] driver_register+0x93/0x119
[  149.760687]  [<ffffffff820d022c>] ? loop_init+0x147/0x147
[  149.760687]  [<ffffffff81494fa7>] register_virtio_driver+0x2b/0x30
[  149.760687]  [<ffffffff820d0280>] init+0x54/0x8b
[  149.760687]  [<ffffffff8100026d>] do_one_initcall+0x80/0x117
[  149.760687]  [<ffffffff8208fdbb>] kernel_init_freeable+0x13c/0x1cb
[  149.760687]  [<ffffffff8208f6bb>] ? do_early_param+0x8d/0x8d
[  149.760687]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  149.760687]  [<ffffffff818f7362>] kernel_init+0xe/0xd1
[  149.760687]  [<ffffffff819203dc>] ret_from_fork+0x7c/0xb0
[  149.760687]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  149.760687] Code: 8b 1c d0 44 3b a3 84 00 00 00 74 02 0f 0b 48 89 df e8 c6 64 52 00 48 8b 53 48 48 8d 43 48 48 39 c2 74 1e 48 8b 73 50 48 8b 7d c8 <48> 89 7a 08 48 89 17 4c 89 2e 48 89 75 c8 48 89 43 48 48 89 43 
[  149.760687] RIP  [<ffffffff813f2057>] __blk_mq_run_hw_queue+0xa2/0x385
[  149.760687]  RSP <ffff88001ed135f8>
[  149.760687] CR2: 0000000000000008
[  149.926999] ---[ end trace f8fe103d2042a563 ]---
[  149.929737] note: swapper/0[1] exited with preempt_count 1
[  149.931874] swapper/0 (1) used greatest stack depth: 3008 bytes left
[  149.935558] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[  149.935558] 
[  149.938531] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 190

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-25454-20130613012427-3.10.0-rc3-00011-g5754ab5-131"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc3-00011-g5754ab5 (kbuild@inn) (gcc version 4.7.1 (Debian 4.7.1-6) ) #131 SMP Tue May 28 23:20:42 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=/kernel-tests/run-queue/kvm/x86_64-lkp/linux-devel:devel-hourly-2013060809:5754ab54c1b28888e9700550585c5729fccbd15f:bisect-linux/.vmlinuz-5754ab54c1b28888e9700550585c5729fccbd15f-20130613005850-206-ant branch=linux-devel/devel-hourly-2013060809 noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-lkp/5754ab54c1b28888e9700550585c5729fccbd15f/vmlinuz-3.10.0-rc3-00011-g5754ab5
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000001fffe000-0x000000001fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1fffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02c9d000, 0x02c9dfff] PGTABLE
[    0.000000] BRK [0x02c9e000, 0x02c9efff] PGTABLE
[    0.000000] BRK [0x02c9f000, 0x02c9ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1fc00000-0x1fdfffff]
[    0.000000]  [mem 0x1fc00000-0x1fdfffff] page 4k
[    0.000000] BRK [0x02ca0000, 0x02ca0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1c000000-0x1fbfffff]
[    0.000000]  [mem 0x1c000000-0x1fbfffff] page 4k
[    0.000000] BRK [0x02ca1000, 0x02ca1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1bffffff]
[    0.000000]  [mem 0x00100000-0x1bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x1fe00000-0x1fffdfff]
[    0.000000]  [mem 0x1fe00000-0x1fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127256(97%)
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 00040
[    0.000000] ACPI: SSDT 000000001ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000001ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001e400000-ffff88001ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffdfff]
[    0.000000] On node 0 totalpages: 130960
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 126974 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1         
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 28, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 0000000000094000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x20000000-0xfffbffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88001f000000 s1918912 r8192 d22592 u2097152
[    0.000000] pcpu-alloc: s1918912 r8192 d22592 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128891
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=/kernel-tests/run-queue/kvm/x86_64-lkp/linux-devel:devel-hourly-2013060809:5754ab54c1b28888e9700550585c5729fccbd15f:bisect-linux/.vmlinuz-5754ab54c1b28888e9700550585c5729fccbd15f-20130613005850-206-ant branch=linux-devel/devel-hourly-2013060809 noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-lkp/5754ab54c1b28888e9700550585c5729fccbd15f/vmlinuz-3.10.0-rc3-00011-g5754ab5
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 472376k/524280k available (9361k kernel code, 440k absent, 51464k reserved, 5711k data, 3088k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3191.802 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.052000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6383.60 BogoMIPS (lpj=12767208)
[    0.060651] pid_max: default: 32768 minimum: 301
[    0.118732] Mount-cache hash table entries: 256
[    0.329060] mce: CPU supports 10 MCE banks
[    0.334711] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.334711] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.334711] tlb_flushall_shift: -1
[    0.342472] debug: unmapping init [mem 0xffffffff821be000-0xffffffff821c6fff]
[    0.353384] ACPI: Core revision 20130328
[    2.822471] ACPI: All ACPI Tables successfully acquired
[    2.824954] ACPI: setting ELCR to 0200 (from 0c00)
[    2.831278] ftrace: allocating 36158 entries in 142 pages
[    3.266454] smpboot: SMP disabled
[    3.273683] Performance Events: 
[    3.274950] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    3.276293] no hardware sampling interrupt available.
[    3.277910] Broken PMU hardware detected, using software events only.
[    3.280406] Failed to access perfctr msr (MSR c0010004 is 0)
[    3.421525] Brought up 1 CPUs
[    3.423151] ----------------
[    3.424318] | NMI testsuite:
[    3.425163] --------------------
[    3.426132]   remote IPI:  ok  |
[    3.428676]    local IPI:  ok  |
[    5.481454] --------------------
[    5.482434] Good, all   2 testcases passed! |
[    5.484360] ---------------------------------
[    5.485787] smpboot: Total of 1 processors activated (6383.60 BogoMIPS)
[    5.501364] CPU0 attaching NULL sched-domain.
[    5.629949] devtmpfs: initialized
[    5.926075] khelper (13) used greatest stack depth: 5424 bytes left
[    6.544449] xor: measuring software checksum speed
[    6.592595]    prefetch64-sse:   201.000 MB/sec
[    6.632393]    generic_sse:   194.000 MB/sec
[    6.633815] xor: using function: prefetch64-sse (201.000 MB/sec)
[    6.638368] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    6.702043] NET: Registered protocol family 16
[    6.997664] ACPI: bus type PCI registered
[    6.999146] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    7.063025] kworker/u2:0 (25) used greatest stack depth: 5040 bytes left
[    7.086190] PCI: Using configuration type 1 for base access
[   17.293585] bio: create slab <bio-0> at 0
[   17.421035] raid6: sse2x1      72 MB/s
[   17.488964] raid6: sse2x2      77 MB/s
[   17.556433] raid6: sse2x4      55 MB/s
[   17.557729] raid6: using algorithm sse2x2 (77 MB/s)
[   17.559263] raid6: using intx1 recovery algorithm
[   17.595205] ACPI: Added _OSI(Module Device)
[   17.596977] ACPI: Added _OSI(Processor Device)
[   17.600520] ACPI: Added _OSI(3.0 _SCP Extensions)
[   17.602210] ACPI: Added _OSI(Processor Aggregator Device)
[   17.877481] ACPI: EC: Look up EC in DSDT
[   21.718366] ACPI: Interpreter enabled
[   21.722296] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
[   21.726228] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[   21.739100] ACPI: (supports S0 S3 S4 S5)
[   21.740372] ACPI: Using PIC for interrupt routing
[   21.773537] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[   31.346796] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   31.376530] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[   31.378410] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[   31.380404] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[   31.382233] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[   31.385725] PCI: root bus 00: using default resources
[   31.390520] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[   31.592532] acpiphp: Slot [3] registered
[   31.670053] acpiphp: Slot [4] registered
[   31.741867] acpiphp: Slot [5] registered
[   31.816326] acpiphp: Slot [6] registered
[   31.879480] acpiphp: Slot [7] registered
[   31.938409] acpiphp: Slot [8] registered
[   32.000479] acpiphp: Slot [9] registered
[   32.076323] acpiphp: Slot [10] registered
[   32.132352] acpiphp: Slot [11] registered
[   32.198487] acpiphp: Slot [12] registered
[   32.260340] acpiphp: Slot [13] registered
[   32.309571] acpiphp: Slot [14] registered
[   32.363436] acpiphp: Slot [15] registered
[   32.440289] acpiphp: Slot [16] registered
[   32.492811] acpiphp: Slot [17] registered
[   32.553885] acpiphp: Slot [18] registered
[   32.600800] acpiphp: Slot [19] registered
[   32.645755] acpiphp: Slot [20] registered
[   32.690466] acpiphp: Slot [21] registered
[   32.741825] acpiphp: Slot [22] registered
[   32.794008] acpiphp: Slot [23] registered
[   32.837248] acpiphp: Slot [24] registered
[   32.884710] acpiphp: Slot [25] registered
[   32.929657] acpiphp: Slot [26] registered
[   32.971503] acpiphp: Slot [27] registered
[   33.021648] acpiphp: Slot [28] registered
[   33.063158] acpiphp: Slot [29] registered
[   33.114075] acpiphp: Slot [30] registered
[   33.155433] acpiphp: Slot [31] registered
[   33.164763] PCI host bridge to bus 0000:00
[   33.168397] pci_bus 0000:00: root bus resource [bus 00-ff]
[   33.170143] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[   33.172302] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[   33.177136] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   33.382001] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   33.435131] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   33.447017] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[   33.637224] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   33.644872] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[   33.646744] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[   33.703134] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   33.708375] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[   33.713462] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[   33.729689] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[   33.784441] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[   33.789645] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[   33.793579] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[   33.810108] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[   33.884462] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[   33.889563] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[   33.893623] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[   33.909551] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[   33.986536] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   33.992376] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[   33.996324] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[   34.089453] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   34.093607] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[   34.098636] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[   34.198677] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   34.204346] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[   34.208347] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[   34.309973] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   34.314893] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[   34.318592] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[   34.429373] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   34.433576] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[   34.438533] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[   34.560455] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[   34.565665] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[   34.569592] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[   34.682811] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[   34.686103] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[   34.798082] pci_bus 0000:00: on NUMA node 0
[   34.801083] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[   34.802908] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[   35.258557] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[   35.370914] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[   35.497491] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[   35.632775] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[   35.740514] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[   35.916000] ACPI: Enabled 16 GPEs in block 00 to 0F
[   35.921403] acpi root: \_SB_.PCI0 notify handler is installed
[   35.934179] Found 1 acpi root devices
[   36.858543] ACPI: No dock devices found.
[   36.974017] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[   36.977005] vgaarb: loaded
[   36.980442] vgaarb: bridge control possible 0000:00:02.0
[   37.149339] SCSI subsystem initialized
[   37.152486] ACPI: bus type ATA registered
[   37.221216] libata version 3.00 loaded.
[   37.310657] ACPI: bus type USB registered
[   37.359117] usbcore: registered new interface driver usbfs
[   37.388466] usbcore: registered new interface driver hub
[   37.420331] usbcore: registered new device driver usb
[   37.534019] pps_core: LinuxPPS API ver. 1 registered
[   37.535368] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   37.555064] PTP clock support registered
[   37.702106] EDAC MC: Ver: 3.0.0
[   37.811309] PCI: Using ACPI for IRQ routing
[   37.812758] PCI: pci_cache_line_size set to 64 bytes
[   37.820490] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[   37.823225] e820: reserve RAM buffer [mem 0x1fffe000-0x1fffffff]
[   38.039273] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[   38.041440] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   38.044858] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[   38.087144] Switching to clocksource hpet
[   52.458230] pnp: PnP ACPI init
[   52.491531] ACPI: bus type PNP registered
[   52.623081] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   52.787601] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   52.961755] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   53.071395] pnp 00:03: [dma 2]
[   53.151220] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   53.385062] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   53.627604] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   54.185821] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   54.622639] pnp: PnP ACPI: found 7 devices
[   54.623976] ACPI: bus type PNP unregistered
[   59.267828] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[   59.281410] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[   59.322376] NET: Registered protocol family 2
[   59.537811] TCP established hash table entries: 4096 (order: 4, 65536 bytes)
[   59.547319] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[   59.609297] TCP: Hash tables configured (established 4096 bind 4096)
[   59.627998] TCP: reno registered
[   59.631198] UDP hash table entries: 256 (order: 3, 49152 bytes)
[   59.647198] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[   59.756299] NET: Registered protocol family 1
[   59.906735] RPC: Registered named UNIX socket transport module.
[   59.909547] RPC: Registered udp transport module.
[   59.910939] RPC: Registered tcp transport module.
[   59.921428] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   59.923519] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   59.926691] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   59.939826] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   59.943285] pci 0000:00:02.0: Boot video device
[   59.947302] PCI: CLS 0 bytes, default 64
[   98.653768] DMA-API: preallocated 65536 debug entries
[   98.655260] DMA-API: debugging enabled by kernel config
[  101.153996] Initializing RT-Tester: OK
[  104.214968] Kprobe smoke test started
[  108.787973] Kprobe smoke test passed successfully
[  109.193283] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[  117.966428] VFS: Disk quotas dquot_6.5.2
[  118.195900] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[  121.843470] NFS: Registering the id_resolver key type
[  121.859214] Key type id_resolver registered
[  121.861547] Key type id_legacy registered
[  121.865765] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  122.509991] ROMFS MTD (C) 2007 Red Hat, Inc.
[  122.597179] fuse init (API version 7.22)
[  122.799941] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
[  124.547629] bio: create slab <bio-1> at 1
[  125.387990] Btrfs loaded
[  125.403082] msgmni has been set to 922
[  126.133801] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[  126.138261] io scheduler noop registered
[  126.139708] io scheduler deadline registered
[  126.333685] io scheduler cfq registered (default)
[  126.457283] list_sort_test: start testing list_sort()
[  127.594223] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[  127.794206] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[  128.411284] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[  128.422135] ACPI: Power Button [PWRF]
[  129.099323] ACPI: NR_CPUS/possible_cpus limit of 2 reached.  Processor 2/0x1 ignored.
[  129.102595] Unable to map lapic to logical cpu number
[  135.015506] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[  135.027108] PCI: setting IRQ 11 as level-triggered
[  135.037969] virtio-pci 0000:00:03.0: setting latency timer to 64
[  136.728013] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[  136.730737] PCI: setting IRQ 10 as level-triggered
[  136.743859] virtio-pci 0000:00:05.0: setting latency timer to 64
[  138.245456] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[  138.249523] virtio-pci 0000:00:06.0: setting latency timer to 64
[  139.594947] virtio-pci 0000:00:07.0: setting latency timer to 64
[  141.323945] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[  141.335685] virtio-pci 0000:00:08.0: setting latency timer to 64
[  142.699926] virtio-pci 0000:00:09.0: setting latency timer to 64
[  143.685997] virtio-pci 0000:00:0a.0: setting latency timer to 64
[  143.829540] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[  143.891762] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  144.766753] Non-volatile memory driver v1.3
[  144.811172] Linux agpgart interface v0.103
[  145.273317] [drm] Initialized drm 1.1.0 20060810
[  147.913606] brd: module loaded
[  149.169462] loop: module loaded
[  149.297799] blk-mq: CPU -> queue map
[  149.298999]   CPU 0 -> Queue 0
[  149.624693] INFO: trying to register non-static key.
[  149.624988] the code is fine but needs lockdep annotation.
[  149.624988] turning off the locking correctness validator.
[  149.624988] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00011-g5754ab5 #131
[  149.624988] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  149.624988]  ffff88001ed18000 ffff88001ed134c8 ffffffff8190e5c9 ffff88001ed13538
[  149.624988]  ffffffff810854bc 0000000000000000 0000000000000000 0000000000000000
[  149.624988]  ffffffff81086394 ffff88001ed13518 0000000200000000 ffff88001f1d44c0
[  149.624988] Call Trace:
[  149.624988]  [<ffffffff8190e5c9>] dump_stack+0x19/0x1b
[  149.624988]  [<ffffffff810854bc>] __lock_acquire+0x842/0x951
[  149.624988]  [<ffffffff81086394>] ? trace_hardirqs_on_caller+0x14e/0x1aa
[  149.624988]  [<ffffffff81085b25>] lock_acquire+0xdb/0x127
[  149.624988]  [<ffffffff813f2042>] ? __blk_mq_run_hw_queue+0x8d/0x385
[  149.624988]  [<ffffffff810816b8>] ? lock_release_holdtime.part.6+0xa1/0xa6
[  149.624988]  [<ffffffff8191854d>] _raw_spin_lock+0x45/0x78
[  149.624988]  [<ffffffff813f2042>] ? __blk_mq_run_hw_queue+0x8d/0x385
[  149.624988]  [<ffffffff81918eef>] ? _raw_spin_unlock+0x29/0x3d
[  149.624988]  [<ffffffff813f2042>] __blk_mq_run_hw_queue+0x8d/0x385
[  149.624988]  [<ffffffff813f2ae7>] ? blk_mq_make_request+0x389/0x458
[  149.624988]  [<ffffffff813f2745>] blk_mq_run_hw_queue+0x1e/0x37
[  149.624988]  [<ffffffff813f2b02>] blk_mq_make_request+0x3a4/0x458
[  149.624988]  [<ffffffff813e96ae>] generic_make_request+0x9f/0xe0
[  149.624988]  [<ffffffff813e97e4>] submit_bio+0xf5/0x113
[  149.624988]  [<ffffffff811409b2>] _submit_bh+0x1b0/0x1d1
[  149.624988]  [<ffffffff811409e3>] submit_bh+0x10/0x12
[  149.624988]  [<ffffffff811434ba>] block_read_full_page+0x255/0x271
[  149.624988]  [<ffffffff811461b9>] ? I_BDEV+0xd/0xd
[  149.624988]  [<ffffffff810d7e7b>] ? add_to_page_cache_locked+0xb5/0x13e
[  149.624988]  [<ffffffff81146745>] ? blkdev_write_begin+0x25/0x25
[  149.624988]  [<ffffffff8114675d>] blkdev_readpage+0x18/0x1a
[  149.624988]  [<ffffffff810d7fd2>] do_read_cache_page+0x90/0x15d
[  149.624988]  [<ffffffff813fb33d>] ? efi_partition+0xce/0x53d
[  149.624988]  [<ffffffff810d80e3>] read_cache_page_async+0x1c/0x1e
[  149.624988]  [<ffffffff810d80f3>] read_cache_page+0xe/0x18
[  149.624988]  [<ffffffff813f8210>] read_dev_sector+0x30/0x8a
[  149.624988]  [<ffffffff813fadd4>] read_lba+0x9e/0x106
[  149.624988]  [<ffffffff813fb35e>] efi_partition+0xef/0x53d
[  149.624988]  [<ffffffff8140bdbc>] ? snprintf+0x34/0x36
[  149.624988]  [<ffffffff813f923f>] check_partition+0x114/0x1c1
[  149.624988]  [<ffffffff813f8e7f>] rescan_partitions+0xa6/0x2a7
[  149.624988]  [<ffffffff81918eef>] ? _raw_spin_unlock+0x29/0x3d
[  149.624988]  [<ffffffff811475c1>] __blkdev_get+0x17d/0x3b9
[  149.624988]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  149.624988]  [<ffffffff8114798c>] blkdev_get+0x18f/0x30a
[  149.624988]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  149.624988]  [<ffffffff8114663d>] ? bdget+0x121/0x131
[  149.624988]  [<ffffffff814e3f8e>] ? put_device+0x17/0x19
[  149.624988]  [<ffffffff813f6b28>] add_disk+0x2de/0x452
[  149.624988]  [<ffffffff81496b0e>] ? vp_get+0x4b/0x5f
[  149.624988]  [<ffffffff814f89ea>] virtblk_probe+0x4d5/0x5d9
[  149.624988]  [<ffffffff814e7cfb>] ? driver_probe_device+0x1bd/0x1bd
[  149.624988]  [<ffffffff81494dff>] virtio_dev_probe+0xba/0xf9
[  149.624988]  [<ffffffff814e7bdd>] driver_probe_device+0x9f/0x1bd
[  149.624988]  [<ffffffff814e7d5d>] __driver_attach+0x62/0x85
[  149.624988]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  149.624988]  [<ffffffff814e6198>] bus_for_each_dev+0x5c/0x8e
[  149.624988]  [<ffffffff814e774b>] driver_attach+0x1e/0x20
[  149.624988]  [<ffffffff814e7316>] bus_add_driver+0xf0/0x214
[  149.624988]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  149.624988]  [<ffffffff814e831c>] driver_register+0x93/0x119
[  149.624988]  [<ffffffff820d022c>] ? loop_init+0x147/0x147
[  149.624988]  [<ffffffff81494fa7>] register_virtio_driver+0x2b/0x30
[  149.624988]  [<ffffffff820d0280>] init+0x54/0x8b
[  149.624988]  [<ffffffff8100026d>] do_one_initcall+0x80/0x117
[  149.624988]  [<ffffffff8208fdbb>] kernel_init_freeable+0x13c/0x1cb
[  149.624988]  [<ffffffff8208f6bb>] ? do_early_param+0x8d/0x8d
[  149.624988]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  149.624988]  [<ffffffff818f7362>] kernel_init+0xe/0xd1
[  149.624988]  [<ffffffff819203dc>] ret_from_fork+0x7c/0xb0
[  149.624988]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  149.757670] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[  149.760321] IP: [<ffffffff813f2057>] __blk_mq_run_hw_queue+0xa2/0x385
[  149.760687] PGD 0 
[  149.760687] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[  149.760687] Modules linked in:
[  149.760687] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00011-g5754ab5 #131
[  149.760687] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  149.760687] task: ffff88001ed18000 ti: ffff88001ed12000 task.ti: ffff88001ed12000
[  149.760687] RIP: 0010:[<ffffffff813f2057>]  [<ffffffff813f2057>] __blk_mq_run_hw_queue+0xa2/0x385
[  149.760687] RSP: 0018:ffff88001ed135f8  EFLAGS: 00000217
[  149.760687] RAX: ffff88001f3db148 RBX: ffff88001f3db100 RCX: 0000000081030100
[  149.760687] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88001a6db200
[  149.760687] RBP: ffff88001ed13678 R08: 0000000000000002 R09: 0000000000000000
[  149.760687] R10: 0000000000000000 R11: ffff88001ec18000 R12: 0000000000000001
[  149.760687] R13: ffff88001ed13638 R14: ffff88001a63ca90 R15: ffff88001a63ca90
[  149.760687] FS:  0000000000000000(0000) GS:ffff88001f000000(0000) knlGS:0000000000000000
[  149.760687] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  149.760687] CR2: 0000000000000008 CR3: 0000000001dbf000 CR4: 00000000000006f0
[  149.760687] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  149.760687] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  149.760687] Stack:
[  149.760687]  ffff88001ed18000 ffff88001ed18758 ffff88001ed13628 ffff88001a622928
[  149.760687]  ffff88001ed18000 ffffffff813f2ae7 ffff88001ed13668 0000000000000246
[  149.760687]  ffff88001a6db200 ffff88001a6db200 ffff88001a622928 ffff88001a6db200
[  149.760687] Call Trace:
[  149.760687]  [<ffffffff813f2ae7>] ? blk_mq_make_request+0x389/0x458
[  149.760687]  [<ffffffff813f2745>] blk_mq_run_hw_queue+0x1e/0x37
[  149.760687]  [<ffffffff813f2b02>] blk_mq_make_request+0x3a4/0x458
[  149.760687]  [<ffffffff813e96ae>] generic_make_request+0x9f/0xe0
[  149.760687]  [<ffffffff813e97e4>] submit_bio+0xf5/0x113
[  149.760687]  [<ffffffff811409b2>] _submit_bh+0x1b0/0x1d1
[  149.760687]  [<ffffffff811409e3>] submit_bh+0x10/0x12
[  149.760687]  [<ffffffff811434ba>] block_read_full_page+0x255/0x271
[  149.760687]  [<ffffffff811461b9>] ? I_BDEV+0xd/0xd
[  149.760687]  [<ffffffff810d7e7b>] ? add_to_page_cache_locked+0xb5/0x13e
[  149.760687]  [<ffffffff81146745>] ? blkdev_write_begin+0x25/0x25
[  149.760687]  [<ffffffff8114675d>] blkdev_readpage+0x18/0x1a
[  149.760687]  [<ffffffff810d7fd2>] do_read_cache_page+0x90/0x15d
[  149.760687]  [<ffffffff813fb33d>] ? efi_partition+0xce/0x53d
[  149.760687]  [<ffffffff810d80e3>] read_cache_page_async+0x1c/0x1e
[  149.760687]  [<ffffffff810d80f3>] read_cache_page+0xe/0x18
[  149.760687]  [<ffffffff813f8210>] read_dev_sector+0x30/0x8a
[  149.760687]  [<ffffffff813fadd4>] read_lba+0x9e/0x106
[  149.760687]  [<ffffffff813fb35e>] efi_partition+0xef/0x53d
[  149.760687]  [<ffffffff8140bdbc>] ? snprintf+0x34/0x36
[  149.760687]  [<ffffffff813f923f>] check_partition+0x114/0x1c1
[  149.760687]  [<ffffffff813f8e7f>] rescan_partitions+0xa6/0x2a7
[  149.760687]  [<ffffffff81918eef>] ? _raw_spin_unlock+0x29/0x3d
[  149.760687]  [<ffffffff811475c1>] __blkdev_get+0x17d/0x3b9
[  149.760687]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  149.760687]  [<ffffffff8114798c>] blkdev_get+0x18f/0x30a
[  149.760687]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  149.760687]  [<ffffffff8114663d>] ? bdget+0x121/0x131
[  149.760687]  [<ffffffff814e3f8e>] ? put_device+0x17/0x19
[  149.760687]  [<ffffffff813f6b28>] add_disk+0x2de/0x452
[  149.760687]  [<ffffffff81496b0e>] ? vp_get+0x4b/0x5f
[  149.760687]  [<ffffffff814f89ea>] virtblk_probe+0x4d5/0x5d9
[  149.760687]  [<ffffffff814e7cfb>] ? driver_probe_device+0x1bd/0x1bd
[  149.760687]  [<ffffffff81494dff>] virtio_dev_probe+0xba/0xf9
[  149.760687]  [<ffffffff814e7bdd>] driver_probe_device+0x9f/0x1bd
[  149.760687]  [<ffffffff814e7d5d>] __driver_attach+0x62/0x85
[  149.760687]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  149.760687]  [<ffffffff814e6198>] bus_for_each_dev+0x5c/0x8e
[  149.760687]  [<ffffffff814e774b>] driver_attach+0x1e/0x20
[  149.760687]  [<ffffffff814e7316>] bus_add_driver+0xf0/0x214
[  149.760687]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  149.760687]  [<ffffffff814e831c>] driver_register+0x93/0x119
[  149.760687]  [<ffffffff820d022c>] ? loop_init+0x147/0x147
[  149.760687]  [<ffffffff81494fa7>] register_virtio_driver+0x2b/0x30
[  149.760687]  [<ffffffff820d0280>] init+0x54/0x8b
[  149.760687]  [<ffffffff8100026d>] do_one_initcall+0x80/0x117
[  149.760687]  [<ffffffff8208fdbb>] kernel_init_freeable+0x13c/0x1cb
[  149.760687]  [<ffffffff8208f6bb>] ? do_early_param+0x8d/0x8d
[  149.760687]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  149.760687]  [<ffffffff818f7362>] kernel_init+0xe/0xd1
[  149.760687]  [<ffffffff819203dc>] ret_from_fork+0x7c/0xb0
[  149.760687]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  149.760687] Code: 8b 1c d0 44 3b a3 84 00 00 00 74 02 0f 0b 48 89 df e8 c6 64 52 00 48 8b 53 48 48 8d 43 48 48 39 c2 74 1e 48 8b 73 50 48 8b 7d c8 <48> 89 7a 08 48 89 17 4c 89 2e 48 89 75 c8 48 89 43 48 48 89 43 
[  149.760687] RIP  [<ffffffff813f2057>] __blk_mq_run_hw_queue+0xa2/0x385
[  149.760687]  RSP <ffff88001ed135f8>
[  149.760687] CR2: 0000000000000008
[  149.926999] ---[ end trace f8fe103d2042a563 ]---
[  149.929737] note: swapper/0[1] exited with preempt_count 1
[  149.931874] swapper/0 (1) used greatest stack depth: 3008 bytes left
[  149.935558] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[  149.935558] 
[  149.938531] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 190

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-25454-20130613013001-3.10.0-rc3-00011-g5754ab5-131"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc3-00011-g5754ab5 (kbuild@inn) (gcc version 4.7.1 (Debian 4.7.1-6) ) #131 SMP Tue May 28 23:20:42 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=/kernel-tests/run-queue/kvm/x86_64-lkp/linux-devel:devel-hourly-2013060809:5754ab54c1b28888e9700550585c5729fccbd15f:bisect-linux/.vmlinuz-5754ab54c1b28888e9700550585c5729fccbd15f-20130613005850-90-ant branch=linux-devel/devel-hourly-2013060809 noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-lkp/5754ab54c1b28888e9700550585c5729fccbd15f/vmlinuz-3.10.0-rc3-00011-g5754ab5
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000001fffe000-0x000000001fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1fffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02c9d000, 0x02c9dfff] PGTABLE
[    0.000000] BRK [0x02c9e000, 0x02c9efff] PGTABLE
[    0.000000] BRK [0x02c9f000, 0x02c9ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1fc00000-0x1fdfffff]
[    0.000000]  [mem 0x1fc00000-0x1fdfffff] page 4k
[    0.000000] BRK [0x02ca0000, 0x02ca0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1c000000-0x1fbfffff]
[    0.000000]  [mem 0x1c000000-0x1fbfffff] page 4k
[    0.000000] BRK [0x02ca1000, 0x02ca1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1bffffff]
[    0.000000]  [mem 0x00100000-0x1bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x1fe00000-0x1fffdfff]
[    0.000000]  [mem 0x1fe00000-0x1fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127260(97%)
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 00040
[    0.000000] ACPI: SSDT 000000001ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000001ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001e400000-ffff88001ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffdfff]
[    0.000000] On node 0 totalpages: 130960
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 126974 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1         
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 28, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 0000000000094000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x20000000-0xfffbffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88001f000000 s1918912 r8192 d22592 u2097152
[    0.000000] pcpu-alloc: s1918912 r8192 d22592 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128891
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=/kernel-tests/run-queue/kvm/x86_64-lkp/linux-devel:devel-hourly-2013060809:5754ab54c1b28888e9700550585c5729fccbd15f:bisect-linux/.vmlinuz-5754ab54c1b28888e9700550585c5729fccbd15f-20130613005850-90-ant branch=linux-devel/devel-hourly-2013060809 noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-lkp/5754ab54c1b28888e9700550585c5729fccbd15f/vmlinuz-3.10.0-rc3-00011-g5754ab5
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 472376k/524280k available (9361k kernel code, 440k absent, 51464k reserved, 5711k data, 3088k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3191.895 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.044000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6383.79 BogoMIPS (lpj=12767580)
[    0.048632] pid_max: default: 32768 minimum: 301
[    0.086549] Mount-cache hash table entries: 256
[    0.279107] mce: CPU supports 10 MCE banks
[    0.284812] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.284812] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.284812] tlb_flushall_shift: -1
[    0.291004] debug: unmapping init [mem 0xffffffff821be000-0xffffffff821c6fff]
[    0.301598] ACPI: Core revision 20130328
[    2.662939] ACPI: All ACPI Tables successfully acquired
[    2.665840] ACPI: setting ELCR to 0200 (from 0c00)
[    2.672362] ftrace: allocating 36158 entries in 142 pages
[    3.122178] smpboot: SMP disabled
[    3.131315] Performance Events: 
[    3.132652] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    3.134149] no hardware sampling interrupt available.
[    3.136794] Broken PMU hardware detected, using software events only.
[    3.138219] Failed to access perfctr msr (MSR c0010004 is 0)
[    3.269931] Brought up 1 CPUs
[    3.271390] ----------------
[    3.272266] | NMI testsuite:
[    3.273099] --------------------
[    3.273988]   remote IPI:  ok  |
[    3.276625]    local IPI:  ok  |
[    5.334529] --------------------
[    5.335340] Good, all   2 testcases passed! |
[    5.336298] ---------------------------------
[    5.337586] smpboot: Total of 1 processors activated (6383.79 BogoMIPS)
[    5.350842] CPU0 attaching NULL sched-domain.
[    5.455209] devtmpfs: initialized
[    5.727576] khelper (13) used greatest stack depth: 5424 bytes left
[    6.316318] xor: measuring software checksum speed
[    6.360479]    prefetch64-sse:   189.000 MB/sec
[    6.401278]    generic_sse:   195.000 MB/sec
[    6.402655] xor: using function: generic_sse (195.000 MB/sec)
[    6.406430] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    6.466830] NET: Registered protocol family 16
[    6.774646] ACPI: bus type PCI registered
[    6.776490] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    6.834816] kworker/u2:0 (25) used greatest stack depth: 5040 bytes left
[    6.857968] PCI: Using configuration type 1 for base access
[   17.322589] bio: create slab <bio-0> at 0
[   17.488644] raid6: sse2x1      41 MB/s
[   17.556949] raid6: sse2x2      55 MB/s
[   17.624772] raid6: sse2x4      51 MB/s
[   17.626114] raid6: using algorithm sse2x2 (55 MB/s)
[   17.628792] raid6: using intx1 recovery algorithm
[   17.680974] ACPI: Added _OSI(Module Device)
[   17.684646] ACPI: Added _OSI(Processor Device)
[   17.686446] ACPI: Added _OSI(3.0 _SCP Extensions)
[   17.688848] ACPI: Added _OSI(Processor Aggregator Device)
[   17.997805] ACPI: EC: Look up EC in DSDT
[   22.576415] ACPI: Interpreter enabled
[   22.580571] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
[   22.585815] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[   22.603194] ACPI: (supports S0 S3 S4 S5)
[   22.604739] ACPI: Using PIC for interrupt routing
[   22.645970] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[   33.925636] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   33.951803] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[   33.952540] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[   33.956525] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[   33.960602] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[   33.966057] PCI: root bus 00: using default resources
[   33.970917] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[   34.182280] acpiphp: Slot [3] registered
[   34.241593] acpiphp: Slot [4] registered
[   34.297713] acpiphp: Slot [5] registered
[   34.366861] acpiphp: Slot [6] registered
[   34.440818] acpiphp: Slot [7] registered
[   34.494759] acpiphp: Slot [8] registered
[   34.570906] acpiphp: Slot [9] registered
[   34.629160] acpiphp: Slot [10] registered
[   34.690429] acpiphp: Slot [11] registered
[   34.773331] acpiphp: Slot [12] registered
[   34.839239] acpiphp: Slot [13] registered
[   34.902220] acpiphp: Slot [14] registered
[   34.959149] acpiphp: Slot [15] registered
[   35.019258] acpiphp: Slot [16] registered
[   35.074565] acpiphp: Slot [17] registered
[   35.135305] acpiphp: Slot [18] registered
[   35.193249] acpiphp: Slot [19] registered
[   35.250888] acpiphp: Slot [20] registered
[   35.320512] acpiphp: Slot [21] registered
[   35.406481] acpiphp: Slot [22] registered
[   35.459850] acpiphp: Slot [23] registered
[   35.514992] acpiphp: Slot [24] registered
[   35.573519] acpiphp: Slot [25] registered
[   35.634708] acpiphp: Slot [26] registered
[   35.712645] acpiphp: Slot [27] registered
[   35.793387] acpiphp: Slot [28] registered
[   35.889836] acpiphp: Slot [29] registered
[   35.958389] acpiphp: Slot [30] registered
[   36.037747] acpiphp: Slot [31] registered
[   36.042199] PCI host bridge to bus 0000:00
[   36.048922] pci_bus 0000:00: root bus resource [bus 00-ff]
[   36.056471] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[   36.060378] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[   36.066197] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   36.378728] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   36.469366] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   36.493806] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[   36.756619] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   36.766353] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[   36.768773] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[   36.841303] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   36.846103] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[   36.854019] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[   36.872593] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[   36.935045] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[   36.941616] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[   36.945758] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[   36.964429] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[   37.077124] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[   37.085747] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[   37.093719] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[   37.121871] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[   37.234698] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   37.244533] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[   37.252546] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[   37.389995] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   37.398043] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[   37.404472] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[   37.594083] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   37.601777] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[   37.609839] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[   37.821154] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   37.832416] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[   37.837873] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[   38.080362] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   38.089714] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[   38.097723] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[   38.365134] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[   38.376409] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[   38.381781] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[   38.617953] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[   38.625352] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[   38.821840] pci_bus 0000:00: on NUMA node 0
[   38.824988] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[   38.828647] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[   39.437763] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[   39.593138] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[   39.769812] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[   40.001785] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[   40.241521] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[   40.600000] ACPI: Enabled 16 GPEs in block 00 to 0F
[   40.604399] acpi root: \_SB_.PCI0 notify handler is installed
[   40.632518] Found 1 acpi root devices
[   42.166183] ACPI: No dock devices found.
[   42.346338] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[   42.349229] vgaarb: loaded
[   42.350212] vgaarb: bridge control possible 0000:00:02.0
[   42.578453] SCSI subsystem initialized
[   42.581169] ACPI: bus type ATA registered
[   42.688979] libata version 3.00 loaded.
[   42.856978] ACPI: bus type USB registered
[   42.941515] usbcore: registered new interface driver usbfs
[   42.993260] usbcore: registered new interface driver hub
[   43.033304] usbcore: registered new device driver usb
[   43.166424] pps_core: LinuxPPS API ver. 1 registered
[   43.168474] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   43.201753] PTP clock support registered
[   43.308506] EDAC MC: Ver: 3.0.0
[   43.426483] PCI: Using ACPI for IRQ routing
[   43.429550] PCI: pci_cache_line_size set to 64 bytes
[   43.438390] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[   43.444570] e820: reserve RAM buffer [mem 0x1fffe000-0x1fffffff]
[   43.697742] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[   43.701298] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   43.704413] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[   43.738066] Switching to clocksource hpet
[   43.754627] CE: hpet increased min_delta_ns to 5000 nsec
[   43.754627] CE: hpet increased min_delta_ns to 7500 nsec
[   64.448311] pnp: PnP ACPI init
[   64.459650] ACPI: bus type PNP registered
[   64.533273] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   64.666340] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   64.810493] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   64.855991] pnp 00:03: [dma 2]
[   64.897905] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   65.089883] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   65.201569] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   65.635652] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   66.006448] pnp: PnP ACPI: found 7 devices
[   66.007981] ACPI: bus type PNP unregistered
[   70.477985] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[   70.485974] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[   70.542013] NET: Registered protocol family 2
[   70.735677] TCP established hash table entries: 4096 (order: 4, 65536 bytes)
[   70.746357] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[   70.771808] TCP: Hash tables configured (established 4096 bind 4096)
[   70.782249] TCP: reno registered
[   70.785784] UDP hash table entries: 256 (order: 3, 49152 bytes)
[   70.791316] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[   70.915944] NET: Registered protocol family 1
[   71.009300] RPC: Registered named UNIX socket transport module.
[   71.011095] RPC: Registered udp transport module.
[   71.013167] RPC: Registered tcp transport module.
[   71.014411] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   71.017260] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   71.019171] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   71.022566] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   71.025710] pci 0000:00:02.0: Boot video device
[   71.029729] PCI: CLS 0 bytes, default 64
[  111.838820] DMA-API: preallocated 65536 debug entries
[  111.841167] DMA-API: debugging enabled by kernel config
[  112.435348] Initializing RT-Tester: OK
[  114.703015] Kprobe smoke test started
[  118.407170] Kprobe smoke test passed successfully
[  118.619919] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[  126.114531] VFS: Disk quotas dquot_6.5.2
[  126.210409] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[  129.418454] NFS: Registering the id_resolver key type
[  129.443553] Key type id_resolver registered
[  129.450391] Key type id_legacy registered
[  129.458733] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  130.519605] ROMFS MTD (C) 2007 Red Hat, Inc.
[  130.683958] fuse init (API version 7.22)
[  131.031139] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
[  133.456464] bio: create slab <bio-1> at 1
[  134.266222] Btrfs loaded
[  134.275399] msgmni has been set to 922
[  134.891878] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[  134.906657] io scheduler noop registered
[  134.909112] io scheduler deadline registered
[  135.079447] io scheduler cfq registered (default)
[  135.187775] list_sort_test: start testing list_sort()
[  136.139331] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[  136.227188] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[  136.566708] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[  136.577883] ACPI: Power Button [PWRF]
[  137.879748] ACPI: NR_CPUS/possible_cpus limit of 2 reached.  Processor 2/0x1 ignored.
[  137.887562] Unable to map lapic to logical cpu number
[  145.919999] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[  145.923155] PCI: setting IRQ 11 as level-triggered
[  145.929476] virtio-pci 0000:00:03.0: setting latency timer to 64
[  147.187214] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[  147.189881] PCI: setting IRQ 10 as level-triggered
[  147.193468] virtio-pci 0000:00:05.0: setting latency timer to 64
[  148.607876] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[  148.626243] virtio-pci 0000:00:06.0: setting latency timer to 64
[  149.918949] virtio-pci 0000:00:07.0: setting latency timer to 64
[  151.590358] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[  151.599029] virtio-pci 0000:00:08.0: setting latency timer to 64
[  152.890726] virtio-pci 0000:00:09.0: setting latency timer to 64
[  154.171200] virtio-pci 0000:00:0a.0: setting latency timer to 64
[  154.451000] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[  154.570221] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  156.203619] Non-volatile memory driver v1.3
[  156.312070] Linux agpgart interface v0.103
[  156.758884] [drm] Initialized drm 1.1.0 20060810
[  160.360070] brd: module loaded
[  162.226251] loop: module loaded
[  162.378138] blk-mq: CPU -> queue map
[  162.379465]   CPU 0 -> Queue 0
[  162.806569] INFO: trying to register non-static key.
[  162.808341] the code is fine but needs lockdep annotation.
[  162.808597] turning off the locking correctness validator.
[  162.808597] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00011-g5754ab5 #131
[  162.808597] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  162.808597]  ffff88001ed18000 ffff88001ed134c8 ffffffff8190e5c9 ffff88001ed13538
[  162.808597]  ffffffff810854bc ffff88001cc6ca90 ffff88001f1db148 0000000000000000
[  162.808597]  ffffffff81086394 ffff88001ed13518 0000000200000000 ffff88001f1d44c0
[  162.808597] Call Trace:
[  162.808597]  [<ffffffff8190e5c9>] dump_stack+0x19/0x1b
[  162.808597]  [<ffffffff810854bc>] __lock_acquire+0x842/0x951
[  162.808597]  [<ffffffff81086394>] ? trace_hardirqs_on_caller+0x14e/0x1aa
[  162.808597]  [<ffffffff81085b25>] lock_acquire+0xdb/0x127
[  162.808597]  [<ffffffff813f2042>] ? __blk_mq_run_hw_queue+0x8d/0x385
[  162.808597]  [<ffffffff810816b8>] ? lock_release_holdtime.part.6+0xa1/0xa6
[  162.808597]  [<ffffffff8191854d>] _raw_spin_lock+0x45/0x78
[  162.808597]  [<ffffffff813f2042>] ? __blk_mq_run_hw_queue+0x8d/0x385
[  162.808597]  [<ffffffff81918eef>] ? _raw_spin_unlock+0x29/0x3d
[  162.808597]  [<ffffffff813f2042>] __blk_mq_run_hw_queue+0x8d/0x385
[  162.808597]  [<ffffffff813f2ae7>] ? blk_mq_make_request+0x389/0x458
[  162.808597]  [<ffffffff813f2745>] blk_mq_run_hw_queue+0x1e/0x37
[  162.808597]  [<ffffffff813f2b02>] blk_mq_make_request+0x3a4/0x458
[  162.808597]  [<ffffffff813e96ae>] generic_make_request+0x9f/0xe0
[  162.808597]  [<ffffffff813e97e4>] submit_bio+0xf5/0x113
[  162.808597]  [<ffffffff811409b2>] _submit_bh+0x1b0/0x1d1
[  162.808597]  [<ffffffff811409e3>] submit_bh+0x10/0x12
[  162.808597]  [<ffffffff811434ba>] block_read_full_page+0x255/0x271
[  162.808597]  [<ffffffff811461b9>] ? I_BDEV+0xd/0xd
[  162.808597]  [<ffffffff810d7e7b>] ? add_to_page_cache_locked+0xb5/0x13e
[  162.808597]  [<ffffffff81146745>] ? blkdev_write_begin+0x25/0x25
[  162.808597]  [<ffffffff8114675d>] blkdev_readpage+0x18/0x1a
[  162.808597]  [<ffffffff810d7fd2>] do_read_cache_page+0x90/0x15d
[  162.808597]  [<ffffffff813fb33d>] ? efi_partition+0xce/0x53d
[  162.808597]  [<ffffffff810d80e3>] read_cache_page_async+0x1c/0x1e
[  162.808597]  [<ffffffff810d80f3>] read_cache_page+0xe/0x18
[  162.808597]  [<ffffffff813f8210>] read_dev_sector+0x30/0x8a
[  162.808597]  [<ffffffff813fadd4>] read_lba+0x9e/0x106
[  162.808597]  [<ffffffff813fb35e>] efi_partition+0xef/0x53d
[  162.808597]  [<ffffffff8140bdbc>] ? snprintf+0x34/0x36
[  162.808597]  [<ffffffff813f923f>] check_partition+0x114/0x1c1
[  162.808597]  [<ffffffff813f8e7f>] rescan_partitions+0xa6/0x2a7
[  162.808597]  [<ffffffff81918eef>] ? _raw_spin_unlock+0x29/0x3d
[  162.808597]  [<ffffffff811475c1>] __blkdev_get+0x17d/0x3b9
[  162.808597]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  162.808597]  [<ffffffff8114798c>] blkdev_get+0x18f/0x30a
[  162.808597]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  162.808597]  [<ffffffff8114663d>] ? bdget+0x121/0x131
[  162.808597]  [<ffffffff814e3f8e>] ? put_device+0x17/0x19
[  162.808597]  [<ffffffff813f6b28>] add_disk+0x2de/0x452
[  162.808597]  [<ffffffff81146cb0>] ? revalidate_disk+0x72/0x7e
[  162.808597]  [<ffffffff81496b0e>] ? vp_get+0x4b/0x5f
[  162.808597]  [<ffffffff814f89ea>] virtblk_probe+0x4d5/0x5d9
[  162.808597]  [<ffffffff814e7cfb>] ? driver_probe_device+0x1bd/0x1bd
[  162.808597]  [<ffffffff81494dff>] virtio_dev_probe+0xba/0xf9
[  162.808597]  [<ffffffff814e7bdd>] driver_probe_device+0x9f/0x1bd
[  162.808597]  [<ffffffff814e7d5d>] __driver_attach+0x62/0x85
[  162.808597]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  162.808597]  [<ffffffff814e6198>] bus_for_each_dev+0x5c/0x8e
[  162.808597]  [<ffffffff814e774b>] driver_attach+0x1e/0x20
[  162.808597]  [<ffffffff814e7316>] bus_add_driver+0xf0/0x214
[  162.808597]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  162.808597]  [<ffffffff814e831c>] driver_register+0x93/0x119
[  162.808597]  [<ffffffff820d022c>] ? loop_init+0x147/0x147
[  162.808597]  [<ffffffff81494fa7>] register_virtio_driver+0x2b/0x30
[  162.808597]  [<ffffffff820d0280>] init+0x54/0x8b
[  162.808597]  [<ffffffff8100026d>] do_one_initcall+0x80/0x117
[  162.808597]  [<ffffffff8208fdbb>] kernel_init_freeable+0x13c/0x1cb
[  162.808597]  [<ffffffff8208f6bb>] ? do_early_param+0x8d/0x8d
[  162.808597]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  162.808597]  [<ffffffff818f7362>] kernel_init+0xe/0xd1
[  162.808597]  [<ffffffff819203dc>] ret_from_fork+0x7c/0xb0
[  162.808597]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  163.063323] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[  163.065338] IP: [<ffffffff813f2057>] __blk_mq_run_hw_queue+0xa2/0x385
[  163.065338] PGD 0 
[  163.065338] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[  163.065338] Modules linked in:
[  163.065338] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00011-g5754ab5 #131
[  163.065338] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  163.065338] task: ffff88001ed18000 ti: ffff88001ed12000 task.ti: ffff88001ed12000
[  163.065338] RIP: 0010:[<ffffffff813f2057>]  [<ffffffff813f2057>] __blk_mq_run_hw_queue+0xa2/0x385
[  163.065338] RSP: 0018:ffff88001ed135f8  EFLAGS: 00000217
[  163.065338] RAX: ffff88001f3db148 RBX: ffff88001f3db100 RCX: 0000000081030100
[  163.065338] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88001a3bb200
[  163.065338] RBP: ffff88001ed13678 R08: 0000000000000002 R09: 0000000000000000
[  163.065338] R10: 0000000000000000 R11: ffff88001ec18000 R12: 0000000000000001
[  163.065338] R13: ffff88001ed13638 R14: ffff88001cc6ca90 R15: ffff88001cc6ca90
[  163.065338] FS:  0000000000000000(0000) GS:ffff88001f000000(0000) knlGS:0000000000000000
[  163.065338] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  163.065338] CR2: 0000000000000008 CR3: 0000000001dbf000 CR4: 00000000000006f0
[  163.065338] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  163.065338] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  163.065338] Stack:
[  163.065338]  ffff88001ed18000 ffff88001ed18758 ffff88001ed13628 ffff88001a34a928
[  163.065338]  ffff88001ed18000 ffffffff813f2ae7 ffff88001ed13668 0000000000000246
[  163.065338]  ffff88001a3bb200 ffff88001a3bb200 ffff88001a34a928 ffff88001a3bb200
[  163.065338] Call Trace:
[  163.065338]  [<ffffffff813f2ae7>] ? blk_mq_make_request+0x389/0x458
[  163.065338]  [<ffffffff813f2745>] blk_mq_run_hw_queue+0x1e/0x37
[  163.065338]  [<ffffffff813f2b02>] blk_mq_make_request+0x3a4/0x458
[  163.065338]  [<ffffffff813e96ae>] generic_make_request+0x9f/0xe0
[  163.065338]  [<ffffffff813e97e4>] submit_bio+0xf5/0x113
[  163.065338]  [<ffffffff811409b2>] _submit_bh+0x1b0/0x1d1
[  163.065338]  [<ffffffff811409e3>] submit_bh+0x10/0x12
[  163.065338]  [<ffffffff811434ba>] block_read_full_page+0x255/0x271
[  163.065338]  [<ffffffff811461b9>] ? I_BDEV+0xd/0xd
[  163.065338]  [<ffffffff810d7e7b>] ? add_to_page_cache_locked+0xb5/0x13e
[  163.065338]  [<ffffffff81146745>] ? blkdev_write_begin+0x25/0x25
[  163.065338]  [<ffffffff8114675d>] blkdev_readpage+0x18/0x1a
[  163.065338]  [<ffffffff810d7fd2>] do_read_cache_page+0x90/0x15d
[  163.065338]  [<ffffffff813fb33d>] ? efi_partition+0xce/0x53d
[  163.065338]  [<ffffffff810d80e3>] read_cache_page_async+0x1c/0x1e
[  163.065338]  [<ffffffff810d80f3>] read_cache_page+0xe/0x18
[  163.065338]  [<ffffffff813f8210>] read_dev_sector+0x30/0x8a
[  163.065338]  [<ffffffff813fadd4>] read_lba+0x9e/0x106
[  163.065338]  [<ffffffff813fb35e>] efi_partition+0xef/0x53d
[  163.065338]  [<ffffffff8140bdbc>] ? snprintf+0x34/0x36
[  163.065338]  [<ffffffff813f923f>] check_partition+0x114/0x1c1
[  163.065338]  [<ffffffff813f8e7f>] rescan_partitions+0xa6/0x2a7
[  163.065338]  [<ffffffff81918eef>] ? _raw_spin_unlock+0x29/0x3d
[  163.065338]  [<ffffffff811475c1>] __blkdev_get+0x17d/0x3b9
[  163.065338]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  163.065338]  [<ffffffff8114798c>] blkdev_get+0x18f/0x30a
[  163.065338]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  163.065338]  [<ffffffff8114663d>] ? bdget+0x121/0x131
[  163.065338]  [<ffffffff814e3f8e>] ? put_device+0x17/0x19
[  163.065338]  [<ffffffff813f6b28>] add_disk+0x2de/0x452
[  163.065338]  [<ffffffff81146cb0>] ? revalidate_disk+0x72/0x7e
[  163.065338]  [<ffffffff81496b0e>] ? vp_get+0x4b/0x5f
[  163.065338]  [<ffffffff814f89ea>] virtblk_probe+0x4d5/0x5d9
[  163.065338]  [<ffffffff814e7cfb>] ? driver_probe_device+0x1bd/0x1bd
[  163.065338]  [<ffffffff81494dff>] virtio_dev_probe+0xba/0xf9
[  163.065338]  [<ffffffff814e7bdd>] driver_probe_device+0x9f/0x1bd
[  163.065338]  [<ffffffff814e7d5d>] __driver_attach+0x62/0x85
[  163.065338]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  163.065338]  [<ffffffff814e6198>] bus_for_each_dev+0x5c/0x8e
[  163.065338]  [<ffffffff814e774b>] driver_attach+0x1e/0x20
[  163.065338]  [<ffffffff814e7316>] bus_add_driver+0xf0/0x214
[  163.065338]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  163.065338]  [<ffffffff814e831c>] driver_register+0x93/0x119
[  163.065338]  [<ffffffff820d022c>] ? loop_init+0x147/0x147
[  163.065338]  [<ffffffff81494fa7>] register_virtio_driver+0x2b/0x30
[  163.065338]  [<ffffffff820d0280>] init+0x54/0x8b
[  163.065338]  [<ffffffff8100026d>] do_one_initcall+0x80/0x117
[  163.065338]  [<ffffffff8208fdbb>] kernel_init_freeable+0x13c/0x1cb
[  163.065338]  [<ffffffff8208f6bb>] ? do_early_param+0x8d/0x8d
[  163.065338]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  163.065338]  [<ffffffff818f7362>] kernel_init+0xe/0xd1
[  163.065338]  [<ffffffff819203dc>] ret_from_fork+0x7c/0xb0
[  163.065338]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  163.065338] Code: 8b 1c d0 44 3b a3 84 00 00 00 74 02 0f 0b 48 89 df e8 c6 64 52 00 48 8b 53 48 48 8d 43 48 48 39 c2 74 1e 48 8b 73 50 48 8b 7d c8 <48> 89 7a 08 48 89 17 4c 89 2e 48 89 75 c8 48 89 43 48 48 89 43 
[  163.065338] RIP  [<ffffffff813f2057>] __blk_mq_run_hw_queue+0xa2/0x385
[  163.065338]  RSP <ffff88001ed135f8>
[  163.065338] CR2: 0000000000000008
[  163.381185] ---[ end trace 46258ce97cc0e540 ]---
[  163.382881] note: swapper/0[1] exited with preempt_count 1
[  163.397237] swapper/0 (1) used greatest stack depth: 3008 bytes left
[  163.399493] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[  163.399493] 
[  163.400892] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 200

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-25539-20130613013003-3.10.0-rc3-00011-g5754ab5-131"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc3-00011-g5754ab5 (kbuild@inn) (gcc version 4.7.1 (Debian 4.7.1-6) ) #131 SMP Tue May 28 23:20:42 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=/kernel-tests/run-queue/kvm/x86_64-lkp/linux-devel:devel-hourly-2013060809:5754ab54c1b28888e9700550585c5729fccbd15f:bisect-linux/.vmlinuz-5754ab54c1b28888e9700550585c5729fccbd15f-20130613005850-308-ant branch=linux-devel/devel-hourly-2013060809 noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-lkp/5754ab54c1b28888e9700550585c5729fccbd15f/vmlinuz-3.10.0-rc3-00011-g5754ab5
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000001fffe000-0x000000001fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1fffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02c9d000, 0x02c9dfff] PGTABLE
[    0.000000] BRK [0x02c9e000, 0x02c9efff] PGTABLE
[    0.000000] BRK [0x02c9f000, 0x02c9ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1fc00000-0x1fdfffff]
[    0.000000]  [mem 0x1fc00000-0x1fdfffff] page 4k
[    0.000000] BRK [0x02ca0000, 0x02ca0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1c000000-0x1fbfffff]
[    0.000000]  [mem 0x1c000000-0x1fbfffff] page 4k
[    0.000000] BRK [0x02ca1000, 0x02ca1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1bffffff]
[    0.000000]  [mem 0x00100000-0x1bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x1fe00000-0x1fffdfff]
[    0.000000]  [mem 0x1fe00000-0x1fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127256(97%)
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 00040
[    0.000000] ACPI: SSDT 000000001ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000001ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001e400000-ffff88001ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffdfff]
[    0.000000] On node 0 totalpages: 130960
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 126974 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1         
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 28, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 0000000000094000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x20000000-0xfffbffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88001f000000 s1918912 r8192 d22592 u2097152
[    0.000000] pcpu-alloc: s1918912 r8192 d22592 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128891
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=/kernel-tests/run-queue/kvm/x86_64-lkp/linux-devel:devel-hourly-2013060809:5754ab54c1b28888e9700550585c5729fccbd15f:bisect-linux/.vmlinuz-5754ab54c1b28888e9700550585c5729fccbd15f-20130613005850-308-ant branch=linux-devel/devel-hourly-2013060809 noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-lkp/5754ab54c1b28888e9700550585c5729fccbd15f/vmlinuz-3.10.0-rc3-00011-g5754ab5
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 472376k/524280k available (9361k kernel code, 440k absent, 51464k reserved, 5711k data, 3088k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3191.939 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.034550] Calibrating delay loop (skipped), value calculated using timer frequency.. 6383.87 BogoMIPS (lpj=12767756)
[    0.037903] pid_max: default: 32768 minimum: 301
[    0.063569] Mount-cache hash table entries: 256
[    0.194649] mce: CPU supports 10 MCE banks
[    0.198528] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.198528] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.198528] tlb_flushall_shift: -1
[    0.202422] debug: unmapping init [mem 0xffffffff821be000-0xffffffff821c6fff]
[    0.213630] ACPI: Core revision 20130328
[    2.136962] ACPI: All ACPI Tables successfully acquired
[    2.138878] ACPI: setting ELCR to 0200 (from 0c00)
[    2.144796] ftrace: allocating 36158 entries in 142 pages
[    2.581950] smpboot: SMP disabled
[    2.588450] Performance Events: 
[    2.589583] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    2.591442] no hardware sampling interrupt available.
[    2.592681] Broken PMU hardware detected, using software events only.
[    2.594123] Failed to access perfctr msr (MSR c0010004 is 0)
[    2.737308] Brought up 1 CPUs
[    2.738862] ----------------
[    2.740219] | NMI testsuite:
[    2.740974] --------------------
[    2.741754]   remote IPI:  ok  |
[    2.742999]    local IPI:  ok  |
[    4.714771] --------------------
[    4.716309] Good, all   2 testcases passed! |
[    4.717405] ---------------------------------
[    4.718711] smpboot: Total of 1 processors activated (6383.87 BogoMIPS)
[    4.733082] CPU0 attaching NULL sched-domain.
[    4.856609] devtmpfs: initialized
[    5.148452] khelper (13) used greatest stack depth: 5424 bytes left
[    5.864558] xor: measuring software checksum speed
[    5.908467]    prefetch64-sse:   193.000 MB/sec
[    5.948451]    generic_sse:   213.000 MB/sec
[    5.949760] xor: using function: generic_sse (213.000 MB/sec)
[    5.953954] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    6.022419] NET: Registered protocol family 16
[    6.165459] kworker/u2:1 (19) used greatest stack depth: 5040 bytes left
[    6.310699] ACPI: bus type PCI registered
[    6.312579] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    6.388654] PCI: Using configuration type 1 for base access
[   18.817836] bio: create slab <bio-0> at 0
[   19.024969] raid6: sse2x1      28 MB/s
[   19.100506] raid6: sse2x2      38 MB/s
[   19.180683] raid6: sse2x4      32 MB/s
[   19.181987] raid6: using algorithm sse2x2 (38 MB/s)
[   19.184713] raid6: using intx1 recovery algorithm
[   19.276818] ACPI: Added _OSI(Module Device)
[   19.278726] ACPI: Added _OSI(Processor Device)
[   19.284887] ACPI: Added _OSI(3.0 _SCP Extensions)
[   19.286758] ACPI: Added _OSI(Processor Aggregator Device)
[   19.791165] ACPI: EC: Look up EC in DSDT
[   27.216643] ACPI: Interpreter enabled
[   27.219503] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
[   27.232668] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[   27.256778] ACPI: (supports S0 S3 S4 S5)
[   27.258157] ACPI: Using PIC for interrupt routing
[   27.338395] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[   41.289298] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   41.310549] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[   41.312534] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[   41.316594] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[   41.318790] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[   41.324418] PCI: root bus 00: using default resources
[   41.328914] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[   41.531091] acpiphp: Slot [3] registered
[   41.590567] acpiphp: Slot [4] registered
[   41.665436] acpiphp: Slot [5] registered
[   41.738444] acpiphp: Slot [6] registered
[   41.813107] acpiphp: Slot [7] registered
[   41.876967] acpiphp: Slot [8] registered
[   41.942956] acpiphp: Slot [9] registered
[   42.002565] acpiphp: Slot [10] registered
[   42.062238] acpiphp: Slot [11] registered
[   42.125389] acpiphp: Slot [12] registered
[   42.184804] acpiphp: Slot [13] registered
[   42.249580] acpiphp: Slot [14] registered
[   42.310080] acpiphp: Slot [15] registered
[   42.370949] acpiphp: Slot [16] registered
[   42.428790] acpiphp: Slot [17] registered
[   42.487062] acpiphp: Slot [18] registered
[   42.556817] acpiphp: Slot [19] registered
[   42.626405] acpiphp: Slot [20] registered
[   42.697399] acpiphp: Slot [21] registered
[   42.814360] acpiphp: Slot [22] registered
[   42.917258] acpiphp: Slot [23] registered
[   43.006041] acpiphp: Slot [24] registered
[   43.065135] acpiphp: Slot [25] registered
[   43.126572] acpiphp: Slot [26] registered
[   43.205947] acpiphp: Slot [27] registered
[   43.268861] acpiphp: Slot [28] registered
[   43.338887] acpiphp: Slot [29] registered
[   43.405897] acpiphp: Slot [30] registered
[   43.510422] acpiphp: Slot [31] registered
[   43.518189] PCI host bridge to bus 0000:00
[   43.526102] pci_bus 0000:00: root bus resource [bus 00-ff]
[   43.533124] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[   43.535051] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[   43.545486] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   43.816927] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   43.908478] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   43.921888] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[   44.144688] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   44.153347] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[   44.155850] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[   44.244530] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   44.253859] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[   44.265877] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[   44.289930] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[   44.361612] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[   44.368438] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[   44.373456] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[   44.392444] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[   44.490173] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[   44.496547] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[   44.502194] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[   44.524537] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[   44.617255] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   44.623421] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[   44.629825] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[   44.753204] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   44.759124] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[   44.764460] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[   44.886834] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   44.893615] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[   44.898049] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[   45.033913] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   45.040459] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[   45.045758] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[   45.205329] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   45.211032] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[   45.216448] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[   45.347055] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[   45.353819] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[   45.360416] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[   45.532530] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[   45.537368] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[   45.690029] pci_bus 0000:00: on NUMA node 0
[   45.693890] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[   45.696507] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[   46.269549] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[   46.407168] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[   46.547171] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[   46.681226] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[   46.924556] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[   47.400000] ACPI: Enabled 16 GPEs in block 00 to 0F
[   47.410176] acpi root: \_SB_.PCI0 notify handler is installed
[   47.457028] Found 1 acpi root devices
[   49.830662] ACPI: No dock devices found.
[   50.042327] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[   50.045186] vgaarb: loaded
[   50.046125] vgaarb: bridge control possible 0000:00:02.0
[   50.376899] SCSI subsystem initialized
[   50.378802] ACPI: bus type ATA registered
[   50.521262] libata version 3.00 loaded.
[   50.693800] ACPI: bus type USB registered
[   50.799375] usbcore: registered new interface driver usbfs
[   50.856972] usbcore: registered new interface driver hub
[   50.912000] usbcore: registered new device driver usb
[   51.099346] pps_core: LinuxPPS API ver. 1 registered
[   51.100538] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   51.146716] PTP clock support registered
[   51.297707] EDAC MC: Ver: 3.0.0
[   51.461773] PCI: Using ACPI for IRQ routing
[   51.463504] PCI: pci_cache_line_size set to 64 bytes
[   51.473935] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[   51.485697] e820: reserve RAM buffer [mem 0x1fffe000-0x1fffffff]
[   52.176535] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[   52.181522] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   52.192481] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[   52.283049] Switching to clocksource hpet
[   52.300973] CE: hpet increased min_delta_ns to 5000 nsec
[   52.300973] CE: hpet increased min_delta_ns to 7500 nsec
[   72.785858] pnp: PnP ACPI init
[   72.810810] ACPI: bus type PNP registered
[   72.956965] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   73.161754] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   73.331206] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   73.423783] pnp 00:03: [dma 2]
[   73.511490] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   73.787503] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   73.945267] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   74.199797] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   74.439406] pnp: PnP ACPI: found 7 devices
[   74.443483] ACPI: bus type PNP unregistered
[   79.859729] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[   79.862572] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[   79.883416] NET: Registered protocol family 2
[   79.990974] TCP established hash table entries: 4096 (order: 4, 65536 bytes)
[   80.011560] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[   80.049327] TCP: Hash tables configured (established 4096 bind 4096)
[   80.057691] TCP: reno registered
[   80.059829] UDP hash table entries: 256 (order: 3, 49152 bytes)
[   80.066234] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[   80.115727] NET: Registered protocol family 1
[   80.239211] RPC: Registered named UNIX socket transport module.
[   80.249776] RPC: Registered udp transport module.
[   80.251035] RPC: Registered tcp transport module.
[   80.256970] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   80.258968] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   80.265601] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   80.272929] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   80.275315] pci 0000:00:02.0: Boot video device
[   80.283104] PCI: CLS 0 bytes, default 64
[  112.615791] DMA-API: preallocated 65536 debug entries
[  112.618408] DMA-API: debugging enabled by kernel config
[  113.367507] Initializing RT-Tester: OK
[  115.922869] Kprobe smoke test started
[  119.110378] Kprobe smoke test passed successfully
[  119.441713] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[  127.674003] VFS: Disk quotas dquot_6.5.2
[  127.782775] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[  130.962822] NFS: Registering the id_resolver key type
[  130.986876] Key type id_resolver registered
[  130.993270] Key type id_legacy registered
[  131.004756] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  132.131169] ROMFS MTD (C) 2007 Red Hat, Inc.
[  132.319069] fuse init (API version 7.22)
[  132.701762] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
[  135.264233] bio: create slab <bio-1> at 1
[  136.129607] Btrfs loaded
[  136.138002] msgmni has been set to 922
[  136.846623] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[  136.854347] io scheduler noop registered
[  136.855703] io scheduler deadline registered
[  137.065656] io scheduler cfq registered (default)
[  137.150251] list_sort_test: start testing list_sort()
[  138.263658] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[  138.450944] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[  139.175833] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[  139.191677] ACPI: Power Button [PWRF]
[  140.259885] ACPI: NR_CPUS/possible_cpus limit of 2 reached.  Processor 2/0x1 ignored.
[  140.263914] Unable to map lapic to logical cpu number
[  146.337063] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[  146.339209] PCI: setting IRQ 11 as level-triggered
[  146.357305] virtio-pci 0000:00:03.0: setting latency timer to 64
[  148.062996] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[  148.069344] PCI: setting IRQ 10 as level-triggered
[  148.081075] virtio-pci 0000:00:05.0: setting latency timer to 64
[  149.622237] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[  149.634036] virtio-pci 0000:00:06.0: setting latency timer to 64
[  150.955831] virtio-pci 0000:00:07.0: setting latency timer to 64
[  152.665466] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[  152.671453] virtio-pci 0000:00:08.0: setting latency timer to 64
[  153.963914] virtio-pci 0000:00:09.0: setting latency timer to 64
[  155.225600] virtio-pci 0000:00:0a.0: setting latency timer to 64
[  155.514610] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[  155.630735] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  157.054675] Non-volatile memory driver v1.3
[  157.147449] Linux agpgart interface v0.103
[  157.609965] [drm] Initialized drm 1.1.0 20060810
[  161.317038] brd: module loaded
[  163.415842] loop: module loaded
[  163.573320] blk-mq: CPU -> queue map
[  163.574577]   CPU 0 -> Queue 0
[  164.019198] INFO: trying to register non-static key.
[  164.020343] the code is fine but needs lockdep annotation.
[  164.020343] turning off the locking correctness validator.
[  164.020343] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00011-g5754ab5 #131
[  164.020343] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  164.020343]  ffff88001ed18000 ffff88001ed134c8 ffffffff8190e5c9 ffff88001ed13538
[  164.020343]  ffffffff810854bc ffffffff00000000 000000078100cfe1 0000000000000000
[  164.020343]  ffff88001ed18000 ffff88001ed13518 0000000200000000 ffff88001f1d44c0
[  164.020343] Call Trace:
[  164.020343]  [<ffffffff8190e5c9>] dump_stack+0x19/0x1b
[  164.020343]  [<ffffffff810854bc>] __lock_acquire+0x842/0x951
[  164.020343]  [<ffffffff81085b25>] lock_acquire+0xdb/0x127
[  164.020343]  [<ffffffff813f2042>] ? __blk_mq_run_hw_queue+0x8d/0x385
[  164.020343]  [<ffffffff810816b8>] ? lock_release_holdtime.part.6+0xa1/0xa6
[  164.020343]  [<ffffffff8191854d>] _raw_spin_lock+0x45/0x78
[  164.020343]  [<ffffffff813f2042>] ? __blk_mq_run_hw_queue+0x8d/0x385
[  164.020343]  [<ffffffff81918eef>] ? _raw_spin_unlock+0x29/0x3d
[  164.020343]  [<ffffffff813f2042>] __blk_mq_run_hw_queue+0x8d/0x385
[  164.020343]  [<ffffffff813f2ae7>] ? blk_mq_make_request+0x389/0x458
[  164.020343]  [<ffffffff813f2745>] blk_mq_run_hw_queue+0x1e/0x37
[  164.020343]  [<ffffffff813f2b02>] blk_mq_make_request+0x3a4/0x458
[  164.020343]  [<ffffffff813e96ae>] generic_make_request+0x9f/0xe0
[  164.020343]  [<ffffffff813e97e4>] submit_bio+0xf5/0x113
[  164.020343]  [<ffffffff811409b2>] _submit_bh+0x1b0/0x1d1
[  164.020343]  [<ffffffff811409e3>] submit_bh+0x10/0x12
[  164.020343]  [<ffffffff811434ba>] block_read_full_page+0x255/0x271
[  164.020343]  [<ffffffff811461b9>] ? I_BDEV+0xd/0xd
[  164.020343]  [<ffffffff810d7e7b>] ? add_to_page_cache_locked+0xb5/0x13e
[  164.020343]  [<ffffffff81146745>] ? blkdev_write_begin+0x25/0x25
[  164.020343]  [<ffffffff8114675d>] blkdev_readpage+0x18/0x1a
[  164.020343]  [<ffffffff810d7fd2>] do_read_cache_page+0x90/0x15d
[  164.020343]  [<ffffffff813fb33d>] ? efi_partition+0xce/0x53d
[  164.020343]  [<ffffffff810d80e3>] read_cache_page_async+0x1c/0x1e
[  164.020343]  [<ffffffff810d80f3>] read_cache_page+0xe/0x18
[  164.020343]  [<ffffffff813f8210>] read_dev_sector+0x30/0x8a
[  164.020343]  [<ffffffff813fadd4>] read_lba+0x9e/0x106
[  164.020343]  [<ffffffff813fb35e>] efi_partition+0xef/0x53d
[  164.020343]  [<ffffffff8140bdbc>] ? snprintf+0x34/0x36
[  164.020343]  [<ffffffff813f923f>] check_partition+0x114/0x1c1
[  164.020343]  [<ffffffff813f8e7f>] rescan_partitions+0xa6/0x2a7
[  164.020343]  [<ffffffff81918eef>] ? _raw_spin_unlock+0x29/0x3d
[  164.020343]  [<ffffffff811475c1>] __blkdev_get+0x17d/0x3b9
[  164.020343]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  164.020343]  [<ffffffff8114798c>] blkdev_get+0x18f/0x30a
[  164.020343]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  164.020343]  [<ffffffff8114663d>] ? bdget+0x121/0x131
[  164.020343]  [<ffffffff814e3f8e>] ? put_device+0x17/0x19
[  164.020343]  [<ffffffff813f6b28>] add_disk+0x2de/0x452
[  164.020343]  [<ffffffff81146cb0>] ? revalidate_disk+0x72/0x7e
[  164.020343]  [<ffffffff81496b0e>] ? vp_get+0x4b/0x5f
[  164.020343]  [<ffffffff814f89ea>] virtblk_probe+0x4d5/0x5d9
[  164.020343]  [<ffffffff814e7cfb>] ? driver_probe_device+0x1bd/0x1bd
[  164.020343]  [<ffffffff81494dff>] virtio_dev_probe+0xba/0xf9
[  164.020343]  [<ffffffff814e7bdd>] driver_probe_device+0x9f/0x1bd
[  164.020343]  [<ffffffff814e7d5d>] __driver_attach+0x62/0x85
[  164.020343]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  164.020343]  [<ffffffff814e6198>] bus_for_each_dev+0x5c/0x8e
[  164.020343]  [<ffffffff814e774b>] driver_attach+0x1e/0x20
[  164.020343]  [<ffffffff814e7316>] bus_add_driver+0xf0/0x214
[  164.020343]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  164.020343]  [<ffffffff814e831c>] driver_register+0x93/0x119
[  164.020343]  [<ffffffff820d022c>] ? loop_init+0x147/0x147
[  164.020343]  [<ffffffff81494fa7>] register_virtio_driver+0x2b/0x30
[  164.020343]  [<ffffffff820d0280>] init+0x54/0x8b
[  164.020343]  [<ffffffff8100026d>] do_one_initcall+0x80/0x117
[  164.020343]  [<ffffffff8208fdbb>] kernel_init_freeable+0x13c/0x1cb
[  164.020343]  [<ffffffff8208f6bb>] ? do_early_param+0x8d/0x8d
[  164.020343]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  164.020343]  [<ffffffff818f7362>] kernel_init+0xe/0xd1
[  164.020343]  [<ffffffff819203dc>] ret_from_fork+0x7c/0xb0
[  164.020343]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  164.275020] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[  164.277326] IP: [<ffffffff813f2057>] __blk_mq_run_hw_queue+0xa2/0x385
[  164.277326] PGD 0 
[  164.277326] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[  164.277326] Modules linked in:
[  164.277326] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00011-g5754ab5 #131
[  164.277326] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  164.277326] task: ffff88001ed18000 ti: ffff88001ed12000 task.ti: ffff88001ed12000
[  164.277326] RIP: 0010:[<ffffffff813f2057>]  [<ffffffff813f2057>] __blk_mq_run_hw_queue+0xa2/0x385
[  164.277326] RSP: 0018:ffff88001ed135f8  EFLAGS: 00000217
[  164.277326] RAX: ffff88001f3db148 RBX: ffff88001f3db100 RCX: 0000000081030100
[  164.277326] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88001a6cb200
[  164.277326] RBP: ffff88001ed13678 R08: 0000000000000002 R09: 0000000000000000
[  164.277326] R10: 0000000000000000 R11: ffff88001ec18000 R12: 0000000000000001
[  164.277326] R13: ffff88001ed13638 R14: ffff88001a634a90 R15: ffff88001a634a90
[  164.277326] FS:  0000000000000000(0000) GS:ffff88001f000000(0000) knlGS:0000000000000000
[  164.277326] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  164.277326] CR2: 0000000000000008 CR3: 0000000001dbf000 CR4: 00000000000006f0
[  164.277326] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  164.277326] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  164.277326] Stack:
[  164.277326]  ffff88001ed18000 ffff88001ed18758 ffff88001ed13628 ffff88001a61a928
[  164.277326]  ffff88001ed18000 ffffffff813f2ae7 ffff88001ed13668 0000000000000246
[  164.277326]  ffff88001a6cb200 ffff88001a6cb200 ffff88001a61a928 ffff88001a6cb200
[  164.277326] Call Trace:
[  164.277326]  [<ffffffff813f2ae7>] ? blk_mq_make_request+0x389/0x458
[  164.277326]  [<ffffffff813f2745>] blk_mq_run_hw_queue+0x1e/0x37
[  164.277326]  [<ffffffff813f2b02>] blk_mq_make_request+0x3a4/0x458
[  164.277326]  [<ffffffff813e96ae>] generic_make_request+0x9f/0xe0
[  164.277326]  [<ffffffff813e97e4>] submit_bio+0xf5/0x113
[  164.277326]  [<ffffffff811409b2>] _submit_bh+0x1b0/0x1d1
[  164.277326]  [<ffffffff811409e3>] submit_bh+0x10/0x12
[  164.277326]  [<ffffffff811434ba>] block_read_full_page+0x255/0x271
[  164.277326]  [<ffffffff811461b9>] ? I_BDEV+0xd/0xd
[  164.277326]  [<ffffffff810d7e7b>] ? add_to_page_cache_locked+0xb5/0x13e
[  164.277326]  [<ffffffff81146745>] ? blkdev_write_begin+0x25/0x25
[  164.277326]  [<ffffffff8114675d>] blkdev_readpage+0x18/0x1a
[  164.277326]  [<ffffffff810d7fd2>] do_read_cache_page+0x90/0x15d
[  164.277326]  [<ffffffff813fb33d>] ? efi_partition+0xce/0x53d
[  164.277326]  [<ffffffff810d80e3>] read_cache_page_async+0x1c/0x1e
[  164.277326]  [<ffffffff810d80f3>] read_cache_page+0xe/0x18
[  164.277326]  [<ffffffff813f8210>] read_dev_sector+0x30/0x8a
[  164.277326]  [<ffffffff813fadd4>] read_lba+0x9e/0x106
[  164.277326]  [<ffffffff813fb35e>] efi_partition+0xef/0x53d
[  164.277326]  [<ffffffff8140bdbc>] ? snprintf+0x34/0x36
[  164.277326]  [<ffffffff813f923f>] check_partition+0x114/0x1c1
[  164.277326]  [<ffffffff813f8e7f>] rescan_partitions+0xa6/0x2a7
[  164.277326]  [<ffffffff81918eef>] ? _raw_spin_unlock+0x29/0x3d
[  164.277326]  [<ffffffff811475c1>] __blkdev_get+0x17d/0x3b9
[  164.277326]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  164.277326]  [<ffffffff8114798c>] blkdev_get+0x18f/0x30a
[  164.277326]  [<ffffffff8112de6c>] ? unlock_new_inode+0x61/0x66
[  164.277326]  [<ffffffff8114663d>] ? bdget+0x121/0x131
[  164.277326]  [<ffffffff814e3f8e>] ? put_device+0x17/0x19
[  164.277326]  [<ffffffff813f6b28>] add_disk+0x2de/0x452
[  164.277326]  [<ffffffff81146cb0>] ? revalidate_disk+0x72/0x7e
[  164.277326]  [<ffffffff81496b0e>] ? vp_get+0x4b/0x5f
[  164.277326]  [<ffffffff814f89ea>] virtblk_probe+0x4d5/0x5d9
[  164.277326]  [<ffffffff814e7cfb>] ? driver_probe_device+0x1bd/0x1bd
[  164.277326]  [<ffffffff81494dff>] virtio_dev_probe+0xba/0xf9
[  164.277326]  [<ffffffff814e7bdd>] driver_probe_device+0x9f/0x1bd
[  164.277326]  [<ffffffff814e7d5d>] __driver_attach+0x62/0x85
[  164.277326]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  164.277326]  [<ffffffff814e6198>] bus_for_each_dev+0x5c/0x8e
[  164.277326]  [<ffffffff814e774b>] driver_attach+0x1e/0x20
[  164.277326]  [<ffffffff814e7316>] bus_add_driver+0xf0/0x214
[  164.277326]  [<ffffffff810645dd>] ? local_clock+0xf/0x3c
[  164.277326]  [<ffffffff814e831c>] driver_register+0x93/0x119
[  164.277326]  [<ffffffff820d022c>] ? loop_init+0x147/0x147
[  164.277326]  [<ffffffff81494fa7>] register_virtio_driver+0x2b/0x30
[  164.277326]  [<ffffffff820d0280>] init+0x54/0x8b
[  164.277326]  [<ffffffff8100026d>] do_one_initcall+0x80/0x117
[  164.277326]  [<ffffffff8208fdbb>] kernel_init_freeable+0x13c/0x1cb
[  164.277326]  [<ffffffff8208f6bb>] ? do_early_param+0x8d/0x8d
[  164.277326]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  164.277326]  [<ffffffff818f7362>] kernel_init+0xe/0xd1
[  164.277326]  [<ffffffff819203dc>] ret_from_fork+0x7c/0xb0
[  164.277326]  [<ffffffff818f7354>] ? rest_init+0xd8/0xd8
[  164.277326] Code: 8b 1c d0 44 3b a3 84 00 00 00 74 02 0f 0b 48 89 df e8 c6 64 52 00 48 8b 53 48 48 8d 43 48 48 39 c2 74 1e 48 8b 73 50 48 8b 7d c8 <48> 89 7a 08 48 89 17 4c 89 2e 48 89 75 c8 48 89 43 48 48 89 43 
[  164.277326] RIP  [<ffffffff813f2057>] __blk_mq_run_hw_queue+0xa2/0x385
[  164.277326]  RSP <ffff88001ed135f8>
[  164.277326] CR2: 0000000000000008
[  164.616857] ---[ end trace ee47ba33ab65034d ]---
[  164.618642] note: swapper/0[1] exited with preempt_count 1
[  164.625357] swapper/0 (1) used greatest stack depth: 3008 bytes left
[  164.627559] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[  164.627559] 
[  164.628290] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 200

--h31gzZEtNLTqOjlF--
