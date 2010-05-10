From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: libata, hddtemp + s2ram is racy
Date: Mon, 10 May 2010 20:08:15 +0200
Message-ID: <20100510200815.1b92eb0c@neptune.home>
References: <20100507230732.5dd15e93@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100507230732.5dd15e93@neptune.home>
Sender: linux-ide-owner@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[cc linux-scsi]

> Hi,
> 
> On a SMP system I've hit a race condition between suspend and hddtemp
> checking disk's temperature.
> 
> System details:
> - Dual-core AMD Turion CPU
> - 00:12.0 SATA controller [0106]: ATI Technologies Inc SB600 Non-Raid-5 SATA [1002:4380]
> - hddtemp-0.3_beta15 (Gentoo package app-admin/hddtemp-0.3_beta15-r3)
> - Linus' tree shortly after v2.6.34-rc6, at commit
>   be1066bbcd443a65df312fdecea7e4959adedb45 with some drm updates on
>   top of it.
> 
> 
> It looked like hddtemp had sent the SMART request to disk right before
> suspend and during suspend process ata2 did complain without aborting
> suspend (see below).
> After resume access to that disk was dead-locked (any further
> attempt to suspend timed-out freezing hddtemp and any access attempt
> towards that disk did put userspace tasks in uninterruptible state and
> caused soft-raid to mark the disk failed).
> 
> Is suspend not waiting on SG_IO ioctls to complete (at ata host level)?
> 
> To get best luck in reproducing it something like the following is probably
> needed:
>                    sync
>   ioctl(SG_IO)      //      echo mem > /sys/power/state
> 
> Thanks,
> Bruno
> 
> 
> 
> 
> Kernel log extract relating to this issue:
> ... boot, zero or more s2ram, start suspend
> [  142.241048] ahci 0000:00:12.0: suspend
> [  142.660041] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  147.660046] ata2.00: qc timeout (cmd 0xec)
> [  147.664449] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  147.670978] ata2.00: revalidation failed (errno=-5)
> [  148.022541] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  158.022520] ata2.00: qc timeout (cmd 0xec)
> [  158.026923] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  158.033467] ata2.00: revalidation failed (errno=-5)
> [  158.038695] ata2: limiting SATA link speed to 1.5 Gbps
> [  158.390042] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [  188.390023] ata2.00: qc timeout (cmd 0xec)
> [  188.394426] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  188.400953] ata2.00: revalidation failed (errno=-5)
> [  188.406170] ata2.00: disabled
> [  188.420366] ahci 0000:00:12.0: PCI INT A disabled
> ... resuming
> [  200.672629] sd 1:0:0:0: [sdb] Unhandled error code
> [  200.672632] sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
> [  200.672635] sd 1:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 00 81 8f c1 00 00 08 00
> [  200.672641] end_request: I/O error, dev sdb, sector 8490945
> [  200.672646] end_request: I/O error, dev sdb, sector 8490945
> [  200.672649] md: super_written gets error=-5, uptodate=0
> [  200.672653] raid1: Disk failure on sdb3, disabling device.
> [  200.672654] raid1: Operation continuing on 1 devices.
> ... finish resuming, start next suspend
> [  249.291920] sd 2:0:0:0: legacy suspend
> [  249.291924] sd 2:0:0:0: [sdc] Synchronizing SCSI cache
> [  249.292076] sd 2:0:0:0: [sdc] Stopping disk
> [  250.316996] scsi target2:0:0: legacy suspend
> [  250.324040] sd 1:0:0:0: legacy suspend
> [  250.330415] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
> [  250.338435] sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
> [  250.347830] legacy_suspend(): scsi_bus_suspend+0x0/0x70 returns -5
> [  250.357082] PM: Device 1:0:0:0 failed to suspend: error -5
> [  250.365534] PM: Some devices failed to suspend
> [  250.372901] scsi target2:0:0: legacy resume
> [  250.379835] sd 2:0:0:0: legacy resume
> [  250.386081] sd 2:0:0:0: [sdc] Starting disk
> ... resume from aborted suspend
> ... for each subsequent suspend attempt:
> [  333.626278] Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze):
> [  333.637718] hddtemp       D 0000000000000000     0  1889      1 0x00800004
> [  333.648048]  ffff88007abe3908 0000000000000082 ffff88007abe3fd8 ffff88007cec4820
> [  333.658986]  ffff88007abe3fd8 ffff88007abe3fd8 00000000000129c0 00000000000129c0
> [  333.669921]  ffff88007cec4820 ffff88007cda2820 00000000ffffeda8 0000000000000002
> [  333.680901] Call Trace:
> [  333.685892]  [<ffffffff8146c65d>] schedule_timeout+0x19d/0x230
> [  333.694938]  [<ffffffff8146bc31>] wait_for_common+0xe1/0x170
> [  333.703779]  [<ffffffff81037820>] ? default_wake_function+0x0/0x10
> [  333.713234]  [<ffffffff811add9d>] ? __generic_unplug_device+0x2d/0x40
> [  333.723069]  [<ffffffff8146bd58>] wait_for_completion+0x18/0x20
> [  333.732255]  [<ffffffff811b3597>] blk_execute_rq+0x67/0xb0
> [  333.740800]  [<ffffffff811aecd0>] ? freed_request+0x30/0x60
> [  333.749487]  [<ffffffff810485ed>] ? capable+0x2d/0x60
> [  333.757471]  [<ffffffff811b6f85>] sg_io+0x1c5/0x3e0
> [  333.764566]  [<ffffffff810c6340>] ? pollwake+0x0/0x60
> [  333.771808]  [<ffffffff811b77cf>] scsi_cmd_ioctl+0x27f/0x450
> [  333.779715]  [<ffffffff813e0080>] ? ip_output+0xa0/0xb0
> [  333.787134]  [<ffffffff813dee30>] ? ip_local_out+0x20/0x30
> [  333.794936]  [<ffffffff81322d0a>] sd_ioctl+0x8a/0xd0
> [  333.802134]  [<ffffffff811b4ac2>] __blkdev_driver_ioctl+0xa2/0xc0
> [  333.810568]  [<ffffffff811b4cf2>] blkdev_ioctl+0x202/0xa00
> [  333.818296]  [<ffffffff8146e040>] ? _raw_spin_unlock_bh+0x10/0x20
> [  333.826714]  [<ffffffff81398a48>] ? release_sock+0xb8/0xd0
> [  333.834461]  [<ffffffff8146e0c1>] ? _raw_spin_lock_bh+0x11/0x40
> [  333.842807]  [<ffffffff81398b15>] ? lock_sock_nested+0xb5/0xd0
> [  333.851003]  [<ffffffff8146e040>] ? _raw_spin_unlock_bh+0x10/0x20
> [  333.859534]  [<ffffffff81398a48>] ? release_sock+0xb8/0xd0
> [  333.867379]  [<ffffffff810e0b45>] block_ioctl+0x35/0x40
> [  333.874943]  [<ffffffff810c4605>] vfs_ioctl+0x35/0xd0
> [  333.882238]  [<ffffffff810c4b03>] do_vfs_ioctl+0x3d3/0x560
> [  333.889997]  [<ffffffff810c4cda>] sys_ioctl+0x4a/0x80
> [  333.897321]  [<ffffffff81002d6b>] system_call_fastpath+0x16/0x1b
> 
> 
> 
> Strace of hddtemp querying a disk:
> ...
> open("/dev/sda", O_RDONLY|O_NONBLOCK)   = 3
> ioctl(3, SCSI_IOCTL_GET_BUS_NUMBER, 0x7fff11f034fc) = 0
> ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[6]=[12, 00, 00, 00, 24, 00], mx_sb_len=0, iovec_count=0, dxfer_len=36, timeout=3000, flags=0, data[36]=["\0\0\5\2[\0\0\0ATA     FUJITSU MHW2160B"...], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=0, info=0}) = 0
> ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[16]=[85, 08, 2e, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, ec, 00], mx_sb_len=32, iovec_count=0, dxfer_len=512, timeout=3000, flags=0, data[512]=["Z\4\377?7\310\20\0\0\0\0\0?\0\0\0\0\0\0\0        1K20"...], status=02, masked_status=01, sb[22]=[72, 00, 00, 00, 00, 00, 00, 0e, 09, 0c, 00, 00, 00, 00, 00, 09, 00, 27, 00, 64, 40, 40], host_status=0, driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
> ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[16]=[85, 08, 2e, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, ec, 00], mx_sb_len=32, iovec_count=0, dxfer_len=512, timeout=3000, flags=0, data[512]=["Z\4\377?7\310\20\0\0\0\0\0?\0\0\0\0\0\0\0        1K20"...], status=02, masked_status=01, sb[22]=[72, 00, 00, 00, 00, 00, 00, 0e, 09, 0c, 00, 00, 00, 00, 00, 09, 00, 27, 00, 64, 40, 40], host_status=0, driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
> ... (checking its disk DB)
> ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[16]=[85, 06, 20, 00, d8, 00, 00, 00, 00, 00, 4f, 00, c2, 00, b0, 00], mx_sb_len=32, iovec_count=0, dxfer_len=0, timeout=3000, flags=0, status=02, masked_status=01, sb[22]=[72, 00, 00, 00, 00, 00, 00, 0e, 09, 0c, 00, 00, 00, 00, 00, 00, 00, 4f, 00, c2, 00, 50], host_status=0, driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
> ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[16]=[85, 08, 2e, 00, d0, 00, 01, 00, 00, 00, 4f, 00, c2, 00, b0, 00], mx_sb_len=32, iovec_count=0, dxfer_len=512, timeout=3000, flags=0, data[512]=["\20\0\1\17\0dd>\3\1\0\0\0\0\2\5\0dd\0\0P\2\0\0\0\3\3\0dd\1"...], status=02, masked_status=01, sb[22]=[72, 00, 00, 00, 00, 00, 00, 0e, 09, 0c, 00, 00, 00, 00, 00, 00, 00, 4f, 00, c2, 00, 50], host_status=0, driver_status=0x8, resid=0, duration=120, info=0x1}) = 0
> ... (printing result)
