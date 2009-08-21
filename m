From: Chris Webb <chris@arachsys.com>
Subject: Re: oops during scsi scanning disk setup
Date: Fri, 21 Aug 2009 15:51:41 +0100
Message-ID: <20090821145141.GR32115@arachsys.com>
References: <20090820180549.GD7542@arachsys.com> <1250807161.4302.167.camel@mulgrave.site> <20090821081621.GB32115@arachsys.com> <20090821083356.GC32115@arachsys.com> <20090821092326.GF32115@arachsys.com> <1250863216.3844.1.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:35999 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbZHUOzy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2009 10:55:54 -0400
Content-Disposition: inline
In-Reply-To: <1250863216.3844.1.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@suse.de> writes:

> On Fri, 2009-08-21 at 10:23 +0100, Chris Webb wrote:
>
> > Sorry to follow up a third time, but I can now confirm this. I slipped -g into
> > CFLAGS in the kernel Makefile and rebuilt genhd.o and then the entire vmlinux.
> 
> I suppose it makes sense:  That was the only dereference at offset 16 I
> could find in the code.  The thing which doesn't quite make sense is
> that disk_part_iter_init() also dereferences the same pointer
> successfully ... I suppose this could be a race with another thread to
> null out the gendisk part_tbl ... I'll have to think about it some more.

Thanks! If it helps, I've only ever seen it following an iscsi login to a
target machine which is heavy loaded (e.g. RAID resync in this case),
presumably meaning that everything (including disk reads) happens a bit
slowly. Perhaps this increases the window for a race in some way?

I've spent some time over the past week trying to reproduce it in a VM with
magic sysrq enabled so I could find out a bit more, but it subbornly refuses
to happen except on machines in a busy production cluster.

Here are some more crashes we've seen which look extremely similar, but don't
all directly involve disk_part_iter_next:

  20:15:29.272 kernel: scsi2 : iSCSI Initiator over TCP/IP
  20:15:30.278 kernel: scsi 2:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
  20:15:30.279 kernel: scsi 2:0:0:0: Attached scsi generic sg4 type 12
  20:15:30.280 kernel: scsi 2:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
  20:15:30.281 kernel: sd 2:0:0:1: Attached scsi generic sg5 type 0
  20:15:30.281 kernel: sd 2:0:0:1: [sde] 1957888 512-byte hardware sectors: (1.00 GB/956 MiB)
  20:15:30.281 kernel: sd 2:0:0:1: [sde] Write Protect is off
  20:15:30.281 kernel: sd 2:0:0:1: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
  20:15:30.334 kernel: sde:<4>device-mapper: ioctl: device doesn't appear to be in the dev hash table.
  20:15:30.842 kernel: scsi 2:0:0:1: [sde] Unhandled error code
  20:15:30.842 kernel: scsi 2:0:0:1: [sde] Result: hostbyte=0x07 driverbyte=0x00
  20:15:30.842 kernel: end_request: I/O error, dev sde, sector 0
  20:15:30.842 kernel: Buffer I/O error on device sde, logical block 0
  20:15:30.842 kernel: ldm_validate_partition_table(): Disk read failed.
  20:15:30.842 kernel: unable to read partition table
  20:15:30.844 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
  20:15:30.844 kernel: IP: [<ffffffff803f0cf7>] disk_part_iter_next+0x74/0xfd
  20:15:30.844 kernel: PGD 82cdff067 PUD 82cd52067 PMD 0 
  20:15:30.844 kernel: Oops: 0000 [#1] PREEMPT SMP 
  20:15:30.844 kernel: last sysfs file: /sys/devices/platform/host2/session1/iscsi_session/session1/ifacename
  20:15:30.844 kernel: CPU 2 
  20:15:30.844 kernel: Modules linked in:
  20:15:30.844 kernel: Pid: 1546, comm: async/0 Not tainted 2.6.30.3-elastic-lon-p #2 X7DBN
  20:15:30.844 kernel: RIP: 0010:[<ffffffff803f0cf7>]  [<ffffffff803f0cf7>] disk_part_iter_next+0x74/0xfd
  20:15:30.844 kernel: RSP: 0018:ffff8808285e1dd0  EFLAGS: 00010246
  20:15:30.844 kernel: RAX: ffff88082b664800 RBX: ffff8808285e1e00 RCX: 0000000000000000
  20:15:30.844 kernel: RDX: 0000000000000000 RSI: ffff88082b664800 RDI: 0000000000000000
  20:15:30.844 kernel: RBP: ffff8808285e1df0 R08: ffff8808285e0000 R09: ffff8808285c3000
  20:15:30.844 kernel: R10: 0000000021cd6417 R11: ffff88082cd2bd80 R12: ffff8808285e1e00
  20:15:30.844 kernel: R13: ffff88082c970340 R14: 0000000000000000 R15: ffff88082ae10120
  20:15:30.844 kernel: FS:  0000000000000000(0000) GS:ffff88002813c000(0000) knlGS:0000000000000000
  20:15:30.844 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
  20:15:30.844 kernel: CR2: 0000000000000010 CR3: 000000082cd77000 CR4: 00000000000426e0
  20:15:30.844 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  20:15:30.844 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  20:15:30.844 kernel: Process async/0 (pid: 1546, threadinfo ffff8808285e0000, task ffff88082af58bc0)
  20:15:30.844 kernel: Stack:
  20:15:30.844 kernel: 0000000000000000 ffff8808285e1e00 ffff8808285e1e00 ffff88082c970340
  20:15:30.844 kernel: ffff8808285e1e40 ffffffff80306f5f ffff88082b664800 0000000000000000
  20:15:30.844 kernel: 0000000000000001 ffff88082ae10120 ffff8808285e1e40 ffff88082b664800
  20:15:30.844 kernel: Call Trace:
  20:15:30.844 kernel: [<ffffffff80306f5f>] register_disk+0x122/0x13a
  20:15:30.844 kernel: [<ffffffff803f0a8f>] add_disk+0xaa/0x106
  20:15:30.844 kernel: [<ffffffff80493581>] sd_probe_async+0x198/0x25b
  20:15:30.844 kernel: [<ffffffff8027046e>] async_thread+0x10c/0x20d
  20:15:30.844 kernel: [<ffffffff802545ec>] ? default_wake_function+0x0/0xf
  20:15:30.844 kernel: [<ffffffff80270362>] ? async_thread+0x0/0x20d
  20:15:30.844 kernel: [<ffffffff8026ad75>] kthread+0x55/0x80
  20:15:30.844 kernel: [<ffffffff8022be6a>] child_rip+0xa/0x20
  20:15:30.844 kernel: [<ffffffff8026ad20>] ? kthread+0x0/0x80
  20:15:30.844 kernel: [<ffffffff8022be60>] ? child_rip+0x0/0x20
  20:15:30.844 kernel: Code: c8 ff 80 e1 0c b9 00 00 00 00 0f 44 c1 41 83 cd ff 48 8d 7a 20 48 be ff ff ff ff 08 00 00 00 48 b9 00 00 00 00 08 00 00 00 eb 50 <8b> 42 10 41 bd 01 00 00 00 eb db 4c 63 c2 4e 8d 04 c7 4d 8b 20 
  20:15:30.844 kernel: RIP  [<ffffffff803f0cf7>] disk_part_iter_next+0x74/0xfd
  20:15:30.844 kernel: RSP <ffff8808285e1dd0>
  20:15:30.844 kernel: CR2: 0000000000000010
  20:15:30.844 kernel: ---[ end trace 0c87b5734489633f ]---
  20:15:30.844 kernel: note: async/0[1546] exited with preempt_count 1
  [...]
  20:16:32.450 kernel: scsi3 : iSCSI Initiator over TCP/IP
  20:16:33.456 kernel: scsi 3:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
  20:16:33.456 kernel: scsi 3:0:0:0: Attached scsi generic sg4 type 12
  20:16:33.457 kernel: scsi 3:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
  20:16:33.465 kernel: ------------[ cut here ]------------
  20:16:33.465 kernel: kernel BUG at kernel/exit.c:1014!
  20:16:33.465 kernel: invalid opcode: 0000 [#2] PREEMPT SMP 
  20:16:33.465 kernel: last sysfs file: /sys/devices/platform/host3/scsi_host/host3/scan
  20:16:33.465 kernel: CPU 0 
  20:16:33.465 kernel: Modules linked in:
  20:16:33.465 kernel: Pid: 1733, comm: iscsid Tainted: G      D    2.6.30.3-elastic-lon-p #2 X7DBN
  20:16:33.465 kernel: RIP: 0010:[<ffffffff8025b324>]  [<ffffffff8025b324>] do_exit+0x686/0x695
  20:16:33.465 kernel: RSP: 0018:ffff88082cd79840  EFLAGS: 00010006
  20:16:33.465 kernel: RAX: ffff8808285e1ed0 RBX: 0000000000000001 RCX: 0000000000000000
  20:16:33.465 kernel: RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff8808285e1ed0
  20:16:33.465 kernel: RBP: ffff88082cd79888 R08: 0000000000000000 R09: ffff88082b9ab208
  20:16:33.465 kernel: R10: 00000000000002bc R11: 00000000000000af R12: 0000000000000003
  20:16:33.465 kernel: R13: ffff88082ae71340 R14: 0000000080664c7c R15: 0000000000000000
  20:16:33.465 kernel: FS:  00007fe7c45ff6f0(0000) GS:ffff880028108000(0000) knlGS:0000000000000000
  20:16:33.465 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  20:16:33.465 kernel: CR2: 0000000000f893c8 CR3: 0000000828441000 CR4: 00000000000426e0
  20:16:33.465 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  20:16:33.465 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  20:16:33.465 kernel: Process iscsid (pid: 1733, threadinfo ffff88082cd78000, task ffff88082b551d60)
  20:16:33.465 kernel: Stack:
  20:16:33.465 kernel: ffffffff8024b6f1 0000000000000000 ffffffff80835c38 ffff88082cd79888
  20:16:33.465 kernel: ffffffff80835c30 0000000000000282 ffff88082b66f600 0000000000000008
  20:16:33.465 kernel: ffffffff80835c80 ffff88082cd798c8 ffffffff8024c08c 00000000000080d0
  20:16:33.465 kernel: Call Trace:
  20:16:33.465 kernel: [<ffffffff8024b6f1>] ? __wake_up_common+0x49/0x7f
  20:16:33.465 kernel: [<ffffffff8024c08c>] __wake_up+0x34/0x48
  20:16:33.465 kernel: [<ffffffff804933e9>] ? sd_probe_async+0x0/0x25b
  20:16:33.465 kernel: [<ffffffff802708b7>] __async_schedule+0x17e/0x190
  20:16:33.465 kernel: [<ffffffff802708e4>] async_schedule+0x10/0x14
  20:16:33.465 kernel: [<ffffffff80493cc2>] sd_probe+0x1bd/0x213
  20:16:33.465 kernel: [<ffffffff8047399e>] driver_probe_device+0x9a/0x11f
  20:16:33.465 kernel: [<ffffffff80473ad4>] __device_attach+0x35/0x3a
  20:16:33.465 kernel: [<ffffffff80473a9f>] ? __device_attach+0x0/0x3a
  20:16:33.465 kernel: [<ffffffff80472f54>] bus_for_each_drv+0x51/0x88
  20:16:33.465 kernel: [<ffffffff80473b61>] device_attach+0x5e/0x75
  20:16:33.465 kernel: [<ffffffff80472dbc>] bus_attach_device+0x26/0x58
  20:16:33.465 kernel: [<ffffffff804719dd>] device_add+0x3ff/0x562
  20:16:33.465 kernel: [<ffffffff8048507c>] scsi_sysfs_add_sdev+0xb5/0x252
  20:16:33.465 kernel: [<ffffffff80482eea>] scsi_probe_and_add_lun+0x910/0xa32
  20:16:33.465 kernel: [<ffffffff804835b4>] __scsi_scan_target+0x3a5/0x542
  20:16:33.465 kernel: [<ffffffff8029e029>] ? zone_statistics+0x60/0x65
  20:16:33.465 kernel: [<ffffffff80483d46>] scsi_scan_target+0x97/0xae
  20:16:33.465 kernel: [<ffffffff80487bb3>] iscsi_user_scan_session+0xcd/0xe4
  20:16:33.465 kernel: [<ffffffff80487ae6>] ? iscsi_user_scan_session+0x0/0xe4
  20:16:33.465 kernel: [<ffffffff80470f15>] device_for_each_child+0x35/0x6c
  20:16:33.465 kernel: [<ffffffff80487acb>] iscsi_user_scan+0x28/0x2a
  20:16:33.465 kernel: [<ffffffff80484694>] store_scan+0x9b/0xc6
  20:16:33.465 kernel: [<ffffffff804706e5>] dev_attr_store+0x1b/0x1d
  20:16:33.465 kernel: [<ffffffff8030b585>] sysfs_write_file+0xf2/0x12e
  20:16:33.465 kernel: [<ffffffff802c169d>] vfs_write+0xad/0x129
  20:16:33.465 kernel: [<ffffffff802c17d2>] sys_write+0x45/0x6c
  20:16:33.465 kernel: [<ffffffff8022aeeb>] system_call_fastpath+0x16/0x1b
  20:16:33.465 kernel: Code: 8b bb 98 05 00 00 48 85 ff 74 05 e8 04 c4 06 00 65 48 8b 04 25 e8 b4 00 00 ff 80 44 e0 ff ff 48 c7 03 40 00 00 00 e8 40 99 40 00 <0f> 0b eb fe 41 bc fe ff ff ff e9 17 ff ff ff 55 48 89 e5 41 55 
  20:16:33.465 kernel: RIP  [<ffffffff8025b324>] do_exit+0x686/0x695
  20:16:33.465 kernel: RSP <ffff88082cd79840>
  20:16:33.465 kernel: ---[ end trace 0c87b57344896340 ]---
  20:16:33.465 kernel: note: iscsid[1733] exited with preempt_count 1

  [following a hard lockup and reboot from previous crash] 
  20:21:03.288 kernel: scsi2 : iSCSI Initiator over TCP/IP
  20:21:04.295 kernel: scsi 2:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
  20:21:04.295 kernel: scsi 2:0:0:0: Attached scsi generic sg4 type 12
  20:21:04.296 kernel: scsi 2:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
  20:21:04.296 kernel: sd 2:0:0:1: Attached scsi generic sg5 type 0
  20:21:04.297 kernel: sd 2:0:0:1: [sde] 1957888 512-byte hardware sectors: (1.00 GB/956 MiB)
  20:21:04.297 kernel: sd 2:0:0:1: [sde] Write Protect is off
  20:21:04.298 kernel: sd 2:0:0:1: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
  20:21:04.359 kernel: sde:<4>device-mapper: ioctl: device doesn't appear to be in the dev hash table.
  20:21:04.868 kernel: scsi 2:0:0:1: [sde] Unhandled error code
  20:21:04.868 kernel: scsi 2:0:0:1: [sde] Result: hostbyte=0x07 driverbyte=0x00
  20:21:04.868 kernel: end_request: I/O error, dev sde, sector 0
  20:21:04.868 kernel: Buffer I/O error on device sde, logical block 0
  20:21:04.868 kernel: ldm_validate_partition_table(): Disk read failed.
  20:21:04.868 kernel: unable to read partition table
  20:21:04.875 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
  20:21:04.875 kernel: IP: [<ffffffff803f0cf7>] disk_part_iter_next+0x74/0xfd
  20:21:04.875 kernel: PGD 82a4c6067 PUD 82a4c2067 PMD 0 
  20:21:04.875 kernel: Oops: 0000 [#1] PREEMPT SMP 
  20:21:04.875 kernel: last sysfs file: /sys/devices/platform/host2/session1/iscsi_session/session1/ifacename
  20:21:04.875 kernel: CPU 1 
  20:21:04.875 kernel: Modules linked in:
  20:21:04.875 kernel: Pid: 1388, comm: async/0 Not tainted 2.6.30.3-elastic-lon-p #2 X7DBN
  20:21:04.875 kernel: RIP: 0010:[<ffffffff803f0cf7>]  [<ffffffff803f0cf7>] disk_part_iter_next+0x74/0xfd
  20:21:04.875 kernel: RSP: 0018:ffff880827951dd0  EFLAGS: 00010246
  20:21:04.875 kernel: RAX: ffff88082b495400 RBX: ffff880827951e00 RCX: 0000000000000000
  20:21:04.875 kernel: RDX: 0000000000000000 RSI: ffff88082b495400 RDI: 0000000000000000
  20:21:04.875 kernel: RBP: ffff880827951df0 R08: ffff880827950000 R09: ffff88082b9aa000
  20:21:04.875 kernel: R10: ffff88082ccbd018 R11: 0000000000000000 R12: ffff880827951e00
  20:21:04.875 kernel: R13: ffff88082c971380 R14: 0000000000000000 R15: ffff88082add6520
  20:21:04.875 kernel: FS:  0000000000000000(0000) GS:ffff880028122000(0000) knlGS:0000000000000000
  20:21:04.875 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
  20:21:04.875 kernel: CR2: 0000000000000010 CR3: 000000082a48c000 CR4: 00000000000426e0
  20:21:04.875 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  20:21:04.875 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  20:21:04.875 kernel: Process async/0 (pid: 1388, threadinfo ffff880827950000, task ffff88082aed2f00)
  20:21:04.875 kernel: Stack:
  20:21:04.875 kernel: 0000000000000000 ffff880827951e00 ffff880827951e00 ffff88082c971380
  20:21:04.875 kernel: ffff880827951e40 ffffffff80306f5f ffff88082b495400 0000000000000000
  20:21:04.875 kernel: 0000000000000001 ffff88082add6520 ffff880827951e40 ffff88082b495400
  20:21:04.875 kernel: Call Trace:
  20:21:04.875 kernel: [<ffffffff80306f5f>] register_disk+0x122/0x13a
  20:21:04.875 kernel: [<ffffffff803f0a8f>] add_disk+0xaa/0x106
  20:21:04.875 kernel: [<ffffffff80493581>] sd_probe_async+0x198/0x25b
  20:21:04.875 kernel: [<ffffffff8027046e>] async_thread+0x10c/0x20d
  20:21:04.875 kernel: [<ffffffff802545ec>] ? default_wake_function+0x0/0xf
  20:21:04.875 kernel: [<ffffffff80270362>] ? async_thread+0x0/0x20d
  20:21:04.875 kernel: [<ffffffff8026ad75>] kthread+0x55/0x80
  20:21:04.875 kernel: [<ffffffff8022be6a>] child_rip+0xa/0x20
  20:21:04.875 kernel: [<ffffffff8026ad20>] ? kthread+0x0/0x80
  20:21:04.875 kernel: [<ffffffff8022be60>] ? child_rip+0x0/0x20
  20:21:04.875 kernel: Code: c8 ff 80 e1 0c b9 00 00 00 00 0f 44 c1 41 83 cd ff 48 8d 7a 20 48 be ff ff ff ff 08 00 00 00 48 b9 00 00 00 00 08 00 00 00 eb 50 <8b> 42 10 41 bd 01 00 00 00 eb db 4c 63 c2 4e 8d 04 c7 4d 8b 20 
  20:21:04.875 kernel: RIP  [<ffffffff803f0cf7>] disk_part_iter_next+0x74/0xfd
  20:21:04.875 kernel: RSP <ffff880827951dd0>
  20:21:04.875 kernel: CR2: 0000000000000010
  20:21:04.875 kernel: ---[ end trace d0aff0b325825503 ]---
  20:21:04.875 kernel: note: async/0[1388] exited with preempt_count 1
 
  [a few days later] 
  10:05:03.019 kernel: scsi23 : iSCSI Initiator over TCP/IP
  10:05:04.015 kernel: scsi 23:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
  10:05:04.015 kernel: scsi 23:0:0:0: Attached scsi generic sg14 type 12
  10:05:04.017 kernel: scsi 23:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
  10:05:04.017 kernel: sd 23:0:0:1: Attached scsi generic sg15 type 0
  10:05:04.018 kernel: sd 23:0:0:1: [sdk] 27262976 512-byte hardware sectors: (13.9 GB/13.0 GiB)
  10:05:04.018 kernel: sd 23:0:0:1: [sdk] Write Protect is off
  10:05:04.019 kernel: sd 23:0:0:1: [sdk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
  10:05:04.248 kernel: sdk: unknown partition table
  10:05:04.248 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
  10:05:04.248 kernel: IP: [<ffffffff803f0d77>] disk_part_iter_next+0x74/0xfd
  10:05:04.248 kernel: PGD 82ad47067 PUD 82b591067 PMD 0 
  10:05:04.248 kernel: Oops: 0000 [#1] PREEMPT SMP 
  10:05:04.248 kernel: last sysfs file: /sys/devices/platform/host14/session9/iscsi_session/session9/ifacename
  10:05:04.248 kernel: CPU 6 
  10:05:04.248 kernel: Modules linked in:
  10:05:04.248 kernel: Pid: 29251, comm: async/0 Not tainted 2.6.30.4-elastic-lon-p #1 X7DBN
  10:05:04.248 kernel: RIP: 0010:[<ffffffff803f0d77>]  [<ffffffff803f0d77>] disk_part_iter_next+0x74/0xfd
  10:05:04.248 kernel: RSP: 0018:ffff8802645b9dd0  EFLAGS: 00010246
  10:05:04.248 kernel: RAX: ffff880548d43c00 RBX: ffff8802645b9e00 RCX: 0000000000000000
  10:05:04.248 kernel: RDX: 0000000000000000 RSI: ffff880548d43c00 RDI: 0000000000000000
  10:05:04.248 kernel: RBP: ffff8802645b9df0 R08: 0000000000000000 R09: ffff88082cdaf000
  10:05:04.248 kernel: R10: ffff8802645b9ce0 R11: ffff880825d06fe8 R12: ffff8802645b9e00
  10:05:04.248 kernel: R13: ffff88082c91f1c0 R14: 0000000000000000 R15: ffff880548d45920
  10:05:04.248 kernel: FS:  0000000000000000(0000) GS:ffff8800281a4000(0000) knlGS:0000000000000000
  10:05:04.248 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
  10:05:04.248 kernel: CR2: 0000000000000010 CR3: 000000082ad48000 CR4: 00000000000426e0
  10:05:04.248 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  10:05:04.248 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  10:05:04.248 kernel: Process async/0 (pid: 29251, threadinfo ffff8802645b8000, task ffff88082af363e0)
  10:05:04.248 kernel: Stack:
  10:05:04.248 kernel: 0000000000000000 ffff8802645b9e00 ffff8802645b9e00 ffff88082c91f1c0
  10:05:04.248 kernel: ffff8802645b9e40 ffffffff80306feb ffff880548d43c00 0000000000000000
  10:05:04.248 kernel: 0000000000000001 ffff880548d45920 ffff8802645b9e40 ffff880548d43c00
  10:05:04.248 kernel: Call Trace:
  10:05:04.248 kernel: [<ffffffff80306feb>] register_disk+0x122/0x13a
  10:05:04.248 kernel: [<ffffffff803f0b0f>] add_disk+0xaa/0x106
  10:05:04.248 kernel: [<ffffffff80493609>] sd_probe_async+0x198/0x25b
  10:05:04.248 kernel: [<ffffffff802de5a3>] ? free_fs_struct+0x2d/0x31
  10:05:04.248 kernel: [<ffffffff80270482>] async_thread+0x10c/0x20d
  10:05:04.249 kernel: [<ffffffff802545ff>] ? default_wake_function+0x0/0xf
  10:05:04.249 kernel: [<ffffffff80270376>] ? async_thread+0x0/0x20d
  10:05:04.249 kernel: [<ffffffff8026ad89>] kthread+0x55/0x80
  10:05:04.249 kernel: [<ffffffff8022be6a>] child_rip+0xa/0x20
  10:05:04.249 kernel: [<ffffffff8026ad34>] ? kthread+0x0/0x80
  10:05:04.249 kernel: [<ffffffff8022be60>] ? child_rip+0x0/0x20
  10:05:04.249 kernel: Code: c8 ff 80 e1 0c b9 00 00 00 00 0f 44 c1 41 83 cd ff 48 8d 7a 20 48 be ff ff ff ff 08 00 00 00 48 b9 00 00 00 00 08 00 00 00 eb 50 <8b> 42 10 41 bd 01 00 00 00 eb db 4c 63 c2 4e 8d 04 c7 4d 8b 20 
  10:05:04.249 kernel: RIP  [<ffffffff803f0d77>] disk_part_iter_next+0x74/0xfd
  10:05:04.249 kernel: RSP <ffff8802645b9dd0>
  10:05:04.249 kernel: CR2: 0000000000000010
  10:05:04.249 kernel: ---[ end trace c2e45cd8c17e96d1 ]---
  10:05:04.249 kernel: note: async/0[29251] exited with preempt_count 1
  [...] 
  10:05:42.880 kernel: scsi24 : iSCSI Initiator over TCP/IP
  10:05:43.888 kernel: scsi 24:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
  10:05:43.888 kernel: scsi 24:0:0:0: Attached scsi generic sg14 type 12
  10:05:43.888 kernel: scsi 24:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
  10:05:43.897 kernel: ------------[ cut here ]------------
  10:05:43.899 kernel: kernel BUG at kernel/exit.c:1014!
  10:05:43.899 kernel: invalid opcode: 0000 [#2] PREEMPT SMP 
  10:05:43.899 kernel: last sysfs file: /sys/devices/platform/host24/scsi_host/host24/scan
  10:05:43.899 kernel: CPU 7 
  10:05:43.899 kernel: Modules linked in:
  10:05:43.899 kernel: Pid: 29567, comm: iscsid Tainted: G      D    2.6.30.4-elastic-lon-p #1 X7DBN
  10:05:43.899 kernel: RIP: 0010:[<ffffffff8025b338>]  [<ffffffff8025b338>] do_exit+0x686/0x695
  10:05:43.899 kernel: RSP: 0018:ffff8801da10f840  EFLAGS: 00010006
  10:05:43.899 kernel: RAX: ffff8802645b9ed0 RBX: 0000000000000001 RCX: 0000000000000000
  10:05:43.899 kernel: RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff8802645b9ed0
  10:05:43.899 kernel: RBP: ffff8801da10f888 R08: 0000000000000000 R09: ffff88082cd3f108
  10:05:43.899 kernel: R10: 000000000000046c R11: 000000000000011b R12: 0000000000000003
  10:05:43.899 kernel: R13: ffff8806d24a9920 R14: 0000000080664dec R15: 0000000000000000
  10:05:43.899 kernel: FS:  00007f3b0eefa6f0(0000) GS:ffff8800281be000(0000) knlGS:0000000000000000
  10:05:43.899 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  10:05:43.899 kernel: CR2: fffff88004d30000 CR3: 0000000275c0e000 CR4: 00000000000426e0
  10:05:43.899 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  10:05:43.899 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  10:05:43.899 kernel: Process iscsid (pid: 29567, threadinfo ffff8801da10e000, task ffff8802811fd820)
  10:05:43.899 kernel: Stack:
  10:05:43.899 kernel: ffffffff8024b6d1 0000000000000000 ffffffff80835c38 ffff8801da10f888
  10:05:43.899 kernel: ffffffff80835c30 0000000000000282 ffff88020696c200 000000000000001f
  10:05:43.899 kernel: ffffffff80835c80 ffff8801da10f8c8 ffffffff8024c06c 00000000000080d0
  10:05:43.899 kernel: Call Trace:
  10:05:43.899 kernel: [<ffffffff8024b6d1>] ? __wake_up_common+0x49/0x7f
  10:05:43.899 kernel: [<ffffffff8024c06c>] __wake_up+0x34/0x48
  10:05:43.899 kernel: [<ffffffff80493471>] ? sd_probe_async+0x0/0x25b
  10:05:43.899 kernel: [<ffffffff802708cb>] __async_schedule+0x17e/0x190
  10:05:43.899 kernel: [<ffffffff802708f8>] async_schedule+0x10/0x14
  10:05:43.899 kernel: [<ffffffff80493d4a>] sd_probe+0x1bd/0x213
  10:05:43.899 kernel: [<ffffffff80473a1e>] driver_probe_device+0x9a/0x11f
  10:05:43.899 kernel: [<ffffffff80473b54>] __device_attach+0x35/0x3a
  10:05:43.899 kernel: [<ffffffff80473b1f>] ? __device_attach+0x0/0x3a
  10:05:43.899 kernel: [<ffffffff80472fd4>] bus_for_each_drv+0x51/0x88
  10:05:43.899 kernel: [<ffffffff80473be1>] device_attach+0x5e/0x75
  10:05:43.899 kernel: [<ffffffff80472e3c>] bus_attach_device+0x26/0x58
  10:05:43.899 kernel: [<ffffffff80471a5d>] device_add+0x3ff/0x562
  10:05:43.899 kernel: [<ffffffff80485104>] scsi_sysfs_add_sdev+0xb5/0x252
  10:05:43.899 kernel: [<ffffffff80482f72>] scsi_probe_and_add_lun+0x910/0xa32
  10:05:43.899 kernel: [<ffffffff8048363c>] __scsi_scan_target+0x3a5/0x542
  10:05:43.899 kernel: [<ffffffff8029e08d>] ? zone_statistics+0x60/0x65
  10:05:43.899 kernel: [<ffffffff80293369>] ? get_page_from_freelist+0x4ad/0x67a
  10:05:43.899 kernel: [<ffffffff80483dce>] scsi_scan_target+0x97/0xae
  10:05:43.899 kernel: [<ffffffff80487c3b>] iscsi_user_scan_session+0xcd/0xe4
  10:05:43.899 kernel: [<ffffffff80487b6e>] ? iscsi_user_scan_session+0x0/0xe4
  10:05:43.899 kernel: [<ffffffff80470f95>] device_for_each_child+0x35/0x6c
  10:05:43.899 kernel: [<ffffffff80487b53>] iscsi_user_scan+0x28/0x2a
  10:05:43.899 kernel: [<ffffffff8048471c>] store_scan+0x9b/0xc6
  10:05:43.899 kernel: [<ffffffff80470765>] dev_attr_store+0x1b/0x1d
  10:05:43.899 kernel: [<ffffffff8030b61d>] sysfs_write_file+0xf2/0x12e
  10:05:43.899 kernel: [<ffffffff802c1711>] vfs_write+0xad/0x129
  10:05:43.899 kernel: [<ffffffff802c1846>] sys_write+0x45/0x6c
  10:05:43.899 kernel: [<ffffffff8022aeeb>] system_call_fastpath+0x16/0x1b
  10:05:43.899 kernel: Code: 8b bb 98 05 00 00 48 85 ff 74 05 e8 64 c4 06 00 65 48 8b 04 25 e8 b4 00 00 ff 80 44 e0 ff ff 48 c7 03 40 00 00 00 e8 9c 9a 40 00 <0f> 0b eb fe 41 bc fe ff ff ff e9 17 ff ff ff 55 48 89 e5 41 55 
  10:05:43.899 kernel: RIP  [<ffffffff8025b338>] do_exit+0x686/0x695
  10:05:43.899 kernel: RSP <ffff8801da10f840>
  10:05:43.899 kernel: ---[ end trace c2e45cd8c17e96d2 ]---
  10:05:43.899 kernel: note: iscsid[29567] exited with preempt_count 1
  10:05:43.899 kernel: BUG: scheduling while atomic: iscsid/29567/0x10000002
  10:05:43.899 kernel: Modules linked in:
  10:05:43.899 kernel: Pid: 29567, comm: iscsid Tainted: G      D    2.6.30.4-elastic-lon-p #1
  10:05:43.899 kernel: Call Trace:
  10:05:43.899 kernel: [<ffffffff80250e32>] __schedule_bug+0x57/0x5c
  10:05:43.899 kernel: [<ffffffff806645b9>] __schedule+0xc1/0x814
  10:05:43.899 kernel: [<ffffffff803ff025>] ? number+0x12f/0x225
  10:05:43.899 kernel: [<ffffffff80292cb0>] ? __pagevec_free+0x29/0x3c
  10:05:43.899 kernel: [<ffffffff80664dec>] schedule+0x18/0x3b
  10:05:43.899 kernel: [<ffffffff80250f33>] __cond_resched+0x1c/0x45
  10:05:43.899 kernel: [<ffffffff80664ec2>] _cond_resched+0x30/0x3b
  10:05:43.899 kernel: [<ffffffff802a17b2>] unmap_vmas+0x6cd/0x886
  10:05:43.899 kernel: [<ffffffff802a5db3>] exit_mmap+0xd4/0x184
  10:05:43.899 kernel: [<ffffffff80255c6b>] mmput+0x2b/0xb4
  10:05:43.899 kernel: [<ffffffff80259524>] exit_mm+0xff/0x10a
  10:05:43.899 kernel: [<ffffffff8025ae2c>] do_exit+0x17a/0x695
  10:05:43.899 kernel: [<ffffffff80419d84>] ? vgacon_set_cursor_size+0xfd/0x109
  10:05:43.899 kernel: [<ffffffff8022ea59>] oops_end+0x89/0x8e
  10:05:43.899 kernel: [<ffffffff8022ec1c>] die+0x55/0x5e
  10:05:43.899 kernel: [<ffffffff8022c6a0>] do_trap+0x115/0x124
  10:05:43.899 kernel: [<ffffffff8022ca20>] do_invalid_op+0x91/0x9a
  10:05:43.899 kernel: [<ffffffff8025b338>] ? do_exit+0x686/0x695
  10:05:43.899 kernel: [<ffffffff8024ecfd>] ? dequeue_task_fair+0x68/0x71
  10:05:43.899 kernel: [<ffffffff80250e89>] ? finish_task_switch+0x52/0xe0
  10:05:43.899 kernel: [<ffffffff8022bc05>] invalid_op+0x15/0x20
  10:05:43.899 kernel: [<ffffffff8025b338>] ? do_exit+0x686/0x695
  10:05:43.899 kernel: [<ffffffff8024b6d1>] ? __wake_up_common+0x49/0x7f
  10:05:43.899 kernel: [<ffffffff8024c06c>] __wake_up+0x34/0x48
  10:05:43.899 kernel: [<ffffffff80493471>] ? sd_probe_async+0x0/0x25b
  10:05:43.899 kernel: [<ffffffff802708cb>] __async_schedule+0x17e/0x190
  10:05:43.899 kernel: [<ffffffff802708f8>] async_schedule+0x10/0x14
  10:05:43.899 kernel: [<ffffffff80493d4a>] sd_probe+0x1bd/0x213
  10:05:43.899 kernel: [<ffffffff80473a1e>] driver_probe_device+0x9a/0x11f
  10:05:43.899 kernel: [<ffffffff80473b54>] __device_attach+0x35/0x3a
  10:05:43.899 kernel: [<ffffffff80473b1f>] ? __device_attach+0x0/0x3a
  10:05:43.899 kernel: [<ffffffff80472fd4>] bus_for_each_drv+0x51/0x88
  10:05:43.899 kernel: [<ffffffff80473be1>] device_attach+0x5e/0x75
  10:05:43.899 kernel: [<ffffffff80472e3c>] bus_attach_device+0x26/0x58
  10:05:43.899 kernel: [<ffffffff80471a5d>] device_add+0x3ff/0x562
  10:05:43.899 kernel: [<ffffffff80485104>] scsi_sysfs_add_sdev+0xb5/0x252
  10:05:43.900 kernel: [<ffffffff80482f72>] scsi_probe_and_add_lun+0x910/0xa32
  10:05:43.900 kernel: [<ffffffff8048363c>] __scsi_scan_target+0x3a5/0x542
  10:05:43.900 kernel: [<ffffffff8029e08d>] ? zone_statistics+0x60/0x65
  10:05:43.900 kernel: [<ffffffff80293369>] ? get_page_from_freelist+0x4ad/0x67a
  10:05:43.900 kernel: [<ffffffff80483dce>] scsi_scan_target+0x97/0xae
  10:05:43.900 kernel: [<ffffffff80487c3b>] iscsi_user_scan_session+0xcd/0xe4
  10:05:43.900 kernel: [<ffffffff80487b6e>] ? iscsi_user_scan_session+0x0/0xe4
  10:05:43.900 kernel: [<ffffffff80470f95>] device_for_each_child+0x35/0x6c
  10:05:43.900 kernel: [<ffffffff80487b53>] iscsi_user_scan+0x28/0x2a
  10:05:43.900 kernel: [<ffffffff8048471c>] store_scan+0x9b/0xc6
  10:05:43.900 kernel: [<ffffffff80470765>] dev_attr_store+0x1b/0x1d
  10:05:43.901 kernel: [<ffffffff8030b61d>] sysfs_write_file+0xf2/0x12e
  10:05:43.901 kernel: [<ffffffff802c1711>] vfs_write+0xad/0x129
  10:05:43.901 kernel: [<ffffffff802c1846>] sys_write+0x45/0x6c
  10:05:43.901 kernel: [<ffffffff8022aeeb>] system_call_fastpath+0x16/0x1b
  10:05:43.950 kernel: device-mapper: ioctl: device doesn't appear to be in the dev hash table.
  [another hard lockup after a short time]

register_disk+0x122 is line 183 of include/linux/genhd.h.

Ironically, although these disks contain partitions, we're only using the
whole device to export to kvm virtual machines, so it'd be sufficient to fix
our problem if we were able to turn off partition detection altogether on
them. Is that possible for just iSCSI disks without turning off partitioning
on all disks? (Normal partitioned SATA drives are also in use on these
boxes, so I can't just compile out all the partition support from the
kernel.)

Cheers,

Chris.
