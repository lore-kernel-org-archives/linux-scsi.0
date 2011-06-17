From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: 2.6.39, GPF at _raw_spin_lock_irqsave/scsi_dh_detach
Date: Fri, 17 Jun 2011 10:33:19 +0200
Message-ID: <20110617103319.54d07fdd@pluto.restena.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Neil Brown <neilb@suse.de>
List-Id: linux-scsi@vger.kernel.org

On a HP Proliant DL360 G5 server I've got the following general protection
after the SAN it is connected to via QLA card hung hard.

Seems like there is a race/bug in the code handling multipath failover.

Server is running OpenSuSE 11.1 i586 userspace with
multipath-tools-0.4.8-26.10.1 and device-mapper-1.02.27-7.1

I won't be able to try reproducing (production server, SAN state you
don't want to ever see in production...) but can provide kernel config
and look for more information as needed.


[    0.000000] Linux version 2.6.39-x86_64 (kbuild@build) (gcc version 4.4.5 (Gentoo Hardened 4.4.5 p1.2, pie-0.4.5) ) #2 SMP Tue May 31 10:41:15 CEST 2011
...
[    3.858335] QLogic Fibre Channel HBA Driver: 8.03.07.00
[    3.865490] qla2xxx 0000:13:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.872625] qla2xxx 0000:13:00.0: Found an ISP2432, irq 17, iobase 0xffffc90000052000
[    3.880086] qla2xxx 0000:13:00.0: irq 68 for MSI/MSI-X
[    3.880178] qla2xxx 0000:13:00.0: Configuring PCI space...
[    3.887302] qla2xxx 0000:13:00.0: setting latency timer to 64
[    3.919587] qla2xxx 0000:13:00.0: Configure NVRAM parameters...
[    3.955579] qla2xxx 0000:13:00.0: Verifying loaded RISC code...
[    4.095334] qla2xxx 0000:13:00.0: FW: Loading via request-firmware...
[    4.510043] qla2xxx 0000:13:00.0: Allocated (64 KB) for EFT...
[    4.517581] qla2xxx 0000:13:00.0: Allocated (1285 KB) for firmware dump...
[    4.540197] scsi0 : qla2xxx
[    4.548034] qla2xxx 0000:13:00.0: 
[    4.548036]  QLogic Fibre Channel HBA Driver: 8.03.07.00
[    4.548037]   QLogic QLE2460 - PCI-Express Single Channel 4Gb Fibre Channel HBA
[    4.548038]   ISP2432: PCIe (2.5GT/s x4) @ 0000:13:00.0 hdma+, host#=0, fw=4.00.16 (2)
[    4.931715] qla2xxx 0000:13:00.0: LOOP UP detected (4 Gbps).
...
[1402053.890195] end_request: recoverable transport error, dev sdb, sector 150911320
[1402053.890212] sd 0:0:1:0: [sdb] Unhandled error code
[1402053.890214] sd 0:0:1:0: [sdb]  Result: hostbyte=0x0f driverbyte=0x00
[1402053.890218] sd 0:0:1:0: [sdb] Unhandled error code
[1402053.890222] sd 0:0:1:0: [sdb]  Result: hostbyte=0x0f driverbyte=0x00
[1402053.890227] sd 0:0:1:0: [sdb] CDB: cdb[0]=0x28: 28 00 15 38 77 b8 00 00 08 00
[1402053.890243] end_request: recoverable transport error, dev sdb, sector 356022200
[1402053.890251] sd 0:0:1:0: [sdb] CDB: cdb[0]=0x28: 28 00 0d 67 59 00 00 00
[1402053.890258] sd 0:0:1:0: [sdb] Unhandled error code
[1402053.890262] sd 0:0:1:0: [sdb]  Result: hostbyte=0x0f driverbyte=0x00
[1402053.890267] sd 0:0:1:0: [sdb] CDB: cdb[0]=0x28: 28 00 11 b9 c4 d0 00 00 08 00
[1402053.890282] end_request: recoverable transport error, dev sdb, sector 297387216
[1402053.890286]  28 00
[1402053.890289] end_request: recoverable transport error, dev sdb, sector 224876800
[1402053.890297] sd 0:0:1:0: [sdb] Unhandled error code
[1402053.890299] sd 0:0:1:0: [sdb]  Result: hostbyte=0x0f driverbyte=0x00
[1402053.890303] sd 0:0:1:0: [sdb] CDB: cdb[0]=0x2a: 2a 08 02 80 8b 51 00 00 37 00
[1402053.890311] end_request: recoverable transport error, dev sdb, sector 41978705
[1402053.890315] sd 0:0:1:0: [sdb] Unhandled error code
[1402053.890318] sd 0:0:1:0: [sdb]  Result: hostbyte=0x0f driverbyte=0x00
[1402053.890324] sd 0:0:1:0: [sdb] CDB: cdb[0]=0x28: 28 00 00 10 b0 38 00 00 08 00
[1402053.890339] end_request: recoverable transport error, dev sdb, sector 1093688
[1402053.890363] device-mapper: multipath: Failing path 8:16.
[1402053.895232] general protection fault: 0000 [#1] SMP
[1402053.895252] last sysfs file: /sys/kernel/uevent_seqnum
[1402053.895257] CPU 0
[1402053.895259] Modules linked in: squashfs loop dm_round_robin scsi_dh_rdac dm_multipath scsi_dh sg sr_mod cdrom ata_piix ahci libahci ipmi_si ipmi_msghandler
[1402053.895285] device-mapper: multipath: Failing path 8:16.
[1402053.895290]  bnx2 qla2xxx hpwdt libata
[1402053.895297]
[1402053.895302] Pid: 3163, comm: multipathd Not tainted 2.6.39-x86_64 #2 HP ProLiant DL360 G5
[1402053.895310] RIP: 0010:[<ffffffff814a03bc>]  [<ffffffff814a03bc>] _raw_spin_lock_irqsave+0xc/0x20
[1402053.895323] RSP: 0018:ffff8801a9bb3d18  EFLAGS: 00010086
[1402053.895329] RAX: 0000000000000286 RBX: ffff8801aa471510 RCX: 0000000000000000
[1402053.895335] RDX: 0000000000000100 RSI: ffffffffa00f0185 RDI: 6b6b6b6b6b6b6b6b
[1402053.895341] RBP: ffff8801a9bb3d18 R08: dead000000200200 R09: dead000000100100
[1402053.895346] R10: 0000000000000049 R11: 0000000000000028 R12: ffff8801aef69650
[1402053.895352] R13: ffff8801aa4d0bd0 R14: ffff8801aef69650 R15: ffffc9000003d040
[1402053.895358] FS:  0000000000000000(0000) GS:ffff8801afc00000(0063) knlGS:00000000f649db90
[1402053.895365] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[1402053.895370] CR2: 000000000a65e000 CR3: 00000001a9836000 CR4: 00000000000006f0
[1402053.895376] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1402053.895382] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1402053.895389] Process multipathd (pid: 3163, threadinfo ffff8801a9bb2000, task ffff8801aef549f0)
[1402053.895395] Stack:
[1402053.895398]  ffff8801a9bb3d48 ffffffffa002a52a ffff8801aa471510 ffff8801aef69650
[1402053.895407]  ffff8801aef69650 ffff8801aef69650 ffff8801a9bb3d98 ffffffffa0036b02
[1402053.895414]  ffff8801aef69618 ffff8801aaf9e5b0 0000000000000000 ffff8801ade05528
[1402053.895422] Call Trace:
[1402053.895432]  [<ffffffffa002a52a>] scsi_dh_detach+0x2a/0xb0 [scsi_dh]
[1402053.895441]  [<ffffffffa0036b02>] free_priority_group+0xb2/0xf0 [dm_multipath]
[1402053.895448]  [<ffffffffa0036ba3>] free_multipath+0x63/0xb0 [dm_multipath]
[1402053.895455]  [<ffffffffa0036c0d>] multipath_dtr+0x1d/0x30 [dm_multipath]
[1402053.895464]  [<ffffffff813a6ec1>] dm_table_destroy+0x81/0x110
[1402053.895471]  [<ffffffff813a9da8>] dev_suspend+0x178/0x230
[1402053.895478]  [<ffffffff813aabb4>] ctl_ioctl+0x1a4/0x250
[1402053.895484]  [<ffffffff813a9c30>] ? dev_wait+0xb0/0xb0
[1402053.895491]  [<ffffffff813aac8d>] dm_compat_ctl_ioctl+0xd/0x20
[1402053.895498]  [<ffffffff8110b2ae>] compat_sys_ioctl+0x9e/0x440
[1402053.895507]  [<ffffffff810ae4b1>] ? do_munmap+0x311/0x3b0
[1402053.895515]  [<ffffffff814a1d65>] sysenter_dispatch+0x7/0x2b
[1402053.895520] Code: b8 00 01 00 00 48 89 e5 f0 66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c9 c3 66 0f 1f 44 00 00 55 48 89 e5 9c 58 fa ba 00 01 00 00 <f0> 66 0f c1 17 38 f2 74 06 f3 90 8a
17 eb f6 c9 c3 0f 1f 00 55
[1402053.895562] RIP  [<ffffffff814a03bc>] _raw_spin_lock_irqsave+0xc/0x20
[1402053.895570]  RSP <ffff8801a9bb3d18>
[1402053.900002] ---[ end trace 85146cff0658761b ]---
