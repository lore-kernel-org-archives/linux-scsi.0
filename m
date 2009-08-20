From: Chris Webb <chris@arachsys.com>
Subject: oops during scsi scanning disk setup
Date: Thu, 20 Aug 2009 19:05:49 +0100
Message-ID: <20090820180549.GD7542@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:50469 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbZHTS1Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 14:27:24 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi. I originally sent this report to the open-iscsi list, but Mike Christie
recommended I repost it here as he doesn't think iscsi is the problem.

Originally, I saw an oops very similar to this one following an iscsi login
in Linux 2.6.30.4 x86-64 with async scsi bus scanning turned on. I've now
seen it again a couple of times with CONFIG_SCSI_SCAN_ASYNC turned off. The
machine locks up hard shortly after the oops.

There's a copy of the kernel .config at

  http://cdw.me.uk/tmp/linux-2.6.30.4-config.text

and boot dmesg at

  http://cdw.me.uk/tmp/linux-2.6.30.4-dmesg.text

if these are useful.

Mike Christie <michaelc@cs.wisc.edu> writes:

> I was thinking you might be hitting a problem in the async code the 
> scsi_scan.c/sd.c code use like here:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;f=kernel/async.c;h=27235f5de198997180d4a293adc932d48c6101c7;hb=HEAD

Sorry to follow up again, but I've now seen the same oops with async scsi
scan turned off at compile time in the kernel:

  p0# uname -a
  Linux f7ea8425-d45b-490f-a738-d181d0df6963.host.elastichosts.com 2.6.30.4-elastic-lon-p #2 SMP PREEMPT Thu Aug 20 14:30:50 BST 2009 x86_64 Intel(R) Xeon(R) CPU E5420 @ 2.50GHz GenuineIntel GNU/Linux
  p0# zgrep SCAN_ASYNC /proc/config.gz
  # CONFIG_SCSI_SCAN_ASYNC is not set

  p0# cat /var/log/kern/2009-08-20
  [...]
  15:27:10.485 kernel: scsi9 : iSCSI Initiator over TCP/IP
  15:27:11.493 kernel: scsi 9:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
  15:27:11.493 kernel: scsi 9:0:0:0: Attached scsi generic sg6 type 12
  15:27:11.495 kernel: scsi 9:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
  15:27:11.495 kernel: sd 9:0:0:1: Attached scsi generic sg7 type 0
  15:27:11.495 kernel: sd 9:0:0:1: [sdg] 4194304 512-byte hardware sectors: (2.14 GB/2.00 GiB)
  15:27:11.495 kernel: sd 9:0:0:1: [sdg] Write Protect is off
  15:27:11.495 kernel: sd 9:0:0:1: [sdg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
  15:27:13.012 kernel: sdg:<6>scsi 9:0:0:1: [sdg] Unhandled error code
  15:27:13.012 kernel: scsi 9:0:0:1: [sdg] Result: hostbyte=0x07 driverbyte=0x00
  15:27:13.012 kernel: end_request: I/O error, dev sdg, sector 0
  15:27:13.012 kernel: Buffer I/O error on device sdg, logical block 0
  15:27:13.012 kernel: ldm_validate_partition_table(): Disk read failed.
  15:27:13.012 kernel: unable to read partition table
  15:27:13.014 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
  15:27:13.014 kernel: IP: [<ffffffff803f0d77>] disk_part_iter_next+0x74/0xfd
  15:27:13.014 kernel: PGD 82ad0b067 PUD 82cd7e067 PMD 0 
  15:27:13.014 kernel: Oops: 0000 [#1] PREEMPT SMP 
  15:27:13.014 kernel: last sysfs file: /sys/devices/platform/host9/session4/iscsi_session/session4/ifacename
  15:27:13.014 kernel: CPU 5 
  15:27:13.014 kernel: Modules linked in:
  15:27:13.014 kernel: Pid: 13999, comm: async/0 Not tainted 2.6.30.4-elastic-lon-p #2 X7DBN
  15:27:13.014 kernel: RIP: 0010:[<ffffffff803f0d77>]  [<ffffffff803f0d77>] disk_part_iter_next+0x74/0xfd
  15:27:13.014 kernel: RSP: 0018:ffff88066afa3dd0  EFLAGS: 00010246
  15:27:13.014 kernel: RAX: ffff88082b58a000 RBX: ffff88066afa3e00 RCX: 0000000000000000
  15:27:13.014 kernel: RDX: 0000000000000000 RSI: ffff88082b58a000 RDI: 0000000000000000
  15:27:13.014 kernel: RBP: ffff88066afa3df0 R08: ffff88066afa2000 R09: ffff8806a204f000
  15:27:13.014 kernel: R10: 000000fb12c7d274 R11: ffff8806c2bf0628 R12: ffff88066afa3e00
  15:27:13.014 kernel: R13: ffff88082c829a00 R14: 0000000000000000 R15: ffff8806bc50c920
  15:27:13.014 kernel: FS:  0000000000000000(0000) GS:ffff88002818a000(0000) knlGS:0000000000000000
  15:27:13.014 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
  15:27:13.014 kernel: CR2: 0000000000000010 CR3: 000000082ade3000 CR4: 00000000000426e0
  15:27:13.014 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  15:27:13.014 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  15:27:13.014 kernel: Process async/0 (pid: 13999, threadinfo ffff88066afa2000, task ffff8806c2bf05e0)
  15:27:13.014 kernel: Stack:
  15:27:13.014 kernel: 0000000000000000 ffff88066afa3e00 ffff88066afa3e00 ffff88082c829a00
  15:27:13.014 kernel: ffff88066afa3e40 ffffffff80306feb ffff88082b58a000 0000000000000000
  15:27:13.014 kernel: 0000000000000001 ffff8806bc50c920 ffff88066afa3e40 ffff88082b58a000
  15:27:13.014 kernel: Call Trace:
  15:27:13.014 kernel: [<ffffffff80306feb>] register_disk+0x122/0x13a
  15:27:13.014 kernel: [<ffffffff803f0b0f>] add_disk+0xaa/0x106
  15:27:13.014 kernel: [<ffffffff80493609>] sd_probe_async+0x198/0x25b
  15:27:13.014 kernel: [<ffffffff80270482>] async_thread+0x10c/0x20d
  15:27:13.014 kernel: [<ffffffff802545ff>] ? default_wake_function+0x0/0xf
  15:27:13.014 kernel: [<ffffffff80270376>] ? async_thread+0x0/0x20d
  15:27:13.014 kernel: [<ffffffff8026ad89>] kthread+0x55/0x80
  15:27:13.014 kernel: [<ffffffff8022be6a>] child_rip+0xa/0x20
  15:27:13.014 kernel: [<ffffffff8026ad34>] ? kthread+0x0/0x80
  15:27:13.014 kernel: [<ffffffff8022be60>] ? child_rip+0x0/0x20
  15:27:13.014 kernel: Code: c8 ff 80 e1 0c b9 00 00 00 00 0f 44 c1 41 83 cd ff 48 8d 7a 20 48 be ff ff ff ff 08 00 00 00 48 b9 00 00 00 00 08 00 00 00 eb 50 <8b> 42 10 41 bd 01 00 00 00 eb db 4c 63 c2 4e 8d 04 c7 4d 8b 20 
  15:27:13.015 kernel: RIP  [<ffffffff803f0d77>] disk_part_iter_next+0x74/0xfd
  15:27:13.015 kernel: RSP <ffff88066afa3dd0>
  15:27:13.015 kernel: CR2: 0000000000000010
  15:27:13.015 kernel: ---[ end trace 6104b56ef5590e25 ]---
  15:27:13.015 kernel: note: async/0[13999] exited with preempt_count 1
  15:27:13.064 kernel: device-mapper: ioctl: device doesn't appear to be in the dev hash table.
  15:27:13.115 kernel: device-mapper: ioctl: device doesn't appear to be in the dev hash table.
  15:34:52.618 kernel: device tap1 entered promiscuous mode
  15:34:52.621 kernel: br0: port 8(tap1) entering forwarding state
  15:39:12.560 kernel: scsi10 : iSCSI Initiator over TCP/IP
  15:39:13.568 kernel: scsi 10:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
  15:39:13.568 kernel: scsi 10:0:0:0: Attached scsi generic sg6 type 12
  15:39:13.569 kernel: scsi 10:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
  15:39:13.572 kernel: general protection fault: 0000 [#2] PREEMPT SMP 
  15:39:13.572 kernel: last sysfs file: /sys/devices/platform/host10/scsi_host/host10/scan
  15:39:13.572 kernel: CPU 5 
  15:39:13.572 kernel: Modules linked in:
  15:39:13.572 kernel: Pid: 16876, comm: iscsid Tainted: G      D    2.6.30.4-elastic-lon-p #2 X7DBN
  15:39:13.572 kernel: RIP: 0010:[<ffffffff8024b6ce>]  [<ffffffff8024b6ce>] __wake_up_common+0x46/0x7f
  15:39:13.572 kernel: RSP: 0018:ffff8802580bd848  EFLAGS: 00010006
  15:39:13.572 kernel: RAX: ffff88066afa3ed0 RBX: 0000000000000001 RCX: 0000000000000000
  15:39:13.572 kernel: RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff88066afa3ed0
  15:39:13.572 kernel: RBP: ffff8802580bd888 R08: 0000000000000000 R09: ffff88082b9c4d88
  15:39:13.572 kernel: R10: 0000000000000abc R11: 00000000000002af R12: 0000000000000003
  15:39:13.572 kernel: R13: ea164bc9f170a707 R14: 000000003f771c34 R15: 0000000000000000
  15:39:13.572 kernel: FS:  00007f99209626f0(0000) GS:ffff88002818a000(0000) knlGS:0000000000000000
  15:39:13.572 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  15:39:13.572 kernel: CR2: 0000000002aced78 CR3: 00000005c6a7d000 CR4: 00000000000426e0
  15:39:13.572 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  15:39:13.572 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  15:39:13.572 kernel: Process iscsid (pid: 16876, threadinfo ffff8802580bc000, task ffff8806c2bf1780)
  15:39:13.572 kernel: Stack:
  15:39:13.572 kernel: 0000000000000000 ffffffff80835c38 ffff8802580bd888 ffffffff80835c30
  15:39:13.572 kernel: 0000000000000282 ffff88082b5d7000 0000000000000011 ffffffff80835c80
  15:39:13.572 kernel: ffff8802580bd8c8 ffffffff8024c06c 00000000000080d0 0000000000000000
  15:39:13.572 kernel: Call Trace:
  15:39:13.572 kernel: [<ffffffff8024c06c>] __wake_up+0x34/0x48
  15:39:13.572 kernel: [<ffffffff80493471>] ? sd_probe_async+0x0/0x25b
  15:39:13.572 kernel: [<ffffffff802708cb>] __async_schedule+0x17e/0x190
  15:39:13.572 kernel: [<ffffffff802708f8>] async_schedule+0x10/0x14
  15:39:13.572 kernel: [<ffffffff80493d4a>] sd_probe+0x1bd/0x213
  15:39:13.572 kernel: [<ffffffff80473a1e>] driver_probe_device+0x9a/0x11f
  15:39:13.572 kernel: [<ffffffff80473b54>] __device_attach+0x35/0x3a
  15:39:13.572 kernel: [<ffffffff80473b1f>] ? __device_attach+0x0/0x3a
  15:39:13.572 kernel: [<ffffffff80472fd4>] bus_for_each_drv+0x51/0x88
  15:39:13.572 kernel: [<ffffffff80473be1>] device_attach+0x5e/0x75
  15:39:13.572 kernel: [<ffffffff80472e3c>] bus_attach_device+0x26/0x58
  15:39:13.572 kernel: [<ffffffff80471a5d>] device_add+0x3ff/0x562
  15:39:13.572 kernel: [<ffffffff80485104>] scsi_sysfs_add_sdev+0xb5/0x252
  15:39:13.572 kernel: [<ffffffff80482f72>] scsi_probe_and_add_lun+0x910/0xa32
  15:39:13.572 kernel: [<ffffffff8048363c>] __scsi_scan_target+0x3a5/0x542
  15:39:13.572 kernel: [<ffffffff8029e08d>] ? zone_statistics+0x60/0x65
  15:39:13.572 kernel: [<ffffffff80293369>] ? get_page_from_freelist+0x4ad/0x67a
  15:39:13.572 kernel: [<ffffffff80483dce>] scsi_scan_target+0x97/0xae
  15:39:13.572 kernel: [<ffffffff80487c3b>] iscsi_user_scan_session+0xcd/0xe4
  15:39:13.572 kernel: [<ffffffff80487b6e>] ? iscsi_user_scan_session+0x0/0xe4
  15:39:13.572 kernel: [<ffffffff80470f95>] device_for_each_child+0x35/0x6c
  15:39:13.572 kernel: [<ffffffff80487b53>] iscsi_user_scan+0x28/0x2a
  15:39:13.572 kernel: [<ffffffff8048471c>] store_scan+0x9b/0xc6
  15:39:13.573 kernel: [<ffffffff80470765>] dev_attr_store+0x1b/0x1d
  15:39:13.573 kernel: [<ffffffff8030b61d>] sysfs_write_file+0xf2/0x12e
  15:39:13.573 kernel: [<ffffffff802c1711>] vfs_write+0xad/0x129
  15:39:13.573 kernel: [<ffffffff802c1846>] sys_write+0x45/0x6c
  15:39:13.573 kernel: [<ffffffff8022aeeb>] system_call_fastpath+0x16/0x1b
  15:39:13.573 kernel: Code: 47 08 48 83 c7 08 48 83 e8 18 4c 8b 68 18 48 89 7d c8 49 83 ed 18 eb 33 44 8b 30 4c 89 c1 4c 89 45 c0 44 89 fa 44 89 e6 48 89 c7 <ff> 50 10 4c 8b 45 c0 85 c0 74 0a 41 80 e6 01 74 04 ff cb 74 15 
  15:39:13.573 kernel: RIP  [<ffffffff8024b6ce>] __wake_up_common+0x46/0x7f
  15:39:13.573 kernel: RSP <ffff8802580bd848>
  15:39:13.573 kernel: ---[ end trace 6104b56ef5590e26 ]---
  15:39:13.573 kernel: note: iscsid[16876] exited with preempt_count 1
  15:39:13.573 kernel: BUG: scheduling while atomic: iscsid/16876/0x10000002
  15:39:13.573 kernel: Modules linked in:
  15:39:13.573 kernel: Pid: 16876, comm: iscsid Tainted: G      D    2.6.30.4-elastic-lon-p #2
  15:39:13.573 kernel: Call Trace:
  15:39:13.573 kernel: [<ffffffff80250e32>] __schedule_bug+0x57/0x5c
  15:39:13.573 kernel: [<ffffffff806645b9>] __schedule+0xc1/0x814
  15:39:13.573 kernel: [<ffffffff803ff025>] ? number+0x12f/0x225
  15:39:13.573 kernel: [<ffffffff8026ef79>] ? __atomic_notifier_call_chain+0x20/0x4e
  15:39:13.573 kernel: [<ffffffff80664dec>] schedule+0x18/0x3b
  15:39:13.573 kernel: [<ffffffff80250f33>] __cond_resched+0x1c/0x45
  15:39:13.573 kernel: [<ffffffff80664ec2>] _cond_resched+0x30/0x3b
  15:39:13.573 kernel: [<ffffffff802a17b2>] unmap_vmas+0x6cd/0x886
  15:39:13.573 kernel: [<ffffffff802a5db3>] exit_mmap+0xd4/0x184
  15:39:13.573 kernel: [<ffffffff80255c6b>] mmput+0x2b/0xb4
  15:39:13.573 kernel: [<ffffffff80259524>] exit_mm+0xff/0x10a
  15:39:13.574 kernel: [<ffffffff8025ae2c>] do_exit+0x17a/0x695
  15:39:13.574 kernel: [<ffffffff8022ea59>] oops_end+0x89/0x8e
  15:39:13.574 kernel: [<ffffffff8022ec1c>] die+0x55/0x5e
  15:39:13.574 kernel: [<ffffffff8022ccaa>] do_general_protection+0x123/0x12b
  15:39:13.574 kernel: [<ffffffff806670cf>] general_protection+0x1f/0x30
  15:39:13.574 kernel: [<ffffffff8024b6ce>] ? __wake_up_common+0x46/0x7f
  15:39:13.574 kernel: [<ffffffff8024c06c>] __wake_up+0x34/0x48
  15:39:13.574 kernel: [<ffffffff80493471>] ? sd_probe_async+0x0/0x25b
  15:39:13.574 kernel: [<ffffffff802708cb>] __async_schedule+0x17e/0x190
  15:39:13.574 kernel: [<ffffffff802708f8>] async_schedule+0x10/0x14
  15:39:13.574 kernel: [<ffffffff80493d4a>] sd_probe+0x1bd/0x213
  15:39:13.574 kernel: [<ffffffff80473a1e>] driver_probe_device+0x9a/0x11f
  15:39:13.575 kernel: [<ffffffff80473b54>] __device_attach+0x35/0x3a
  15:39:13.575 kernel: [<ffffffff80473b1f>] ? __device_attach+0x0/0x3a
  15:39:13.575 kernel: [<ffffffff80472fd4>] bus_for_each_drv+0x51/0x88
  15:39:13.575 kernel: [<ffffffff80473be1>] device_attach+0x5e/0x75
  15:39:13.575 kernel: [<ffffffff80472e3c>] bus_attach_device+0x26/0x58
  15:39:13.575 kernel: [<ffffffff80471a5d>] device_add+0x3ff/0x562
  15:39:13.575 kernel: [<ffffffff80485104>] scsi_sysfs_add_sdev+0xb5/0x252
  15:39:13.575 kernel: [<ffffffff80482f72>] scsi_probe_and_add_lun+0x910/0xa32
  15:39:13.575 kernel: [<ffffffff8048363c>] __scsi_scan_target+0x3a5/0x542
  15:39:13.575 kernel: [<ffffffff8029e08d>] ? zone_statistics+0x60/0x65
  15:39:13.575 kernel: [<ffffffff80293369>] ? get_page_from_freelist+0x4ad/0x67a
  15:39:13.575 kernel: [<ffffffff80483dce>] scsi_scan_target+0x97/0xae
  15:39:13.575 kernel: [<ffffffff80487c3b>] iscsi_user_scan_session+0xcd/0xe4
  15:39:13.575 kernel: [<ffffffff80487b6e>] ? iscsi_user_scan_session+0x0/0xe4
  15:39:13.575 kernel: [<ffffffff80470f95>] device_for_each_child+0x35/0x6c
  15:39:13.575 kernel: [<ffffffff80487b53>] iscsi_user_scan+0x28/0x2a
  15:39:13.575 kernel: [<ffffffff8048471c>] store_scan+0x9b/0xc6
  15:39:13.575 kernel: [<ffffffff80470765>] dev_attr_store+0x1b/0x1d
  15:39:13.575 kernel: [<ffffffff8030b61d>] sysfs_write_file+0xf2/0x12e
  15:39:13.575 kernel: [<ffffffff802c1711>] vfs_write+0xad/0x129
  15:39:13.575 kernel: [<ffffffff802c1846>] sys_write+0x45/0x6c
  15:39:13.575 kernel: [<ffffffff8022aeeb>] system_call_fastpath+0x16/0x1b
  15:39:13.643 kernel: device-mapper: ioctl: device doesn't appear to be in the dev hash table.
  [...]

iscsid crashed following this, and the machine locked up hard (no longer
even responding to ping) shortly afterwards.

I'm not quite clear how I can be in sd_probe_async when asynchronous bus
scanning is compiled out completely, but perhaps I'm misunderstanding how
this function is used.

The common factor between this incident and the last couple of crashes we've
seen is that the iSCSI target was under a bit of load in each case (RAID
resyncing here) and logins were therefore a bit slower than they'd normally
be. This might be evidence for some sort of race?

Best wishes,

Chris.
