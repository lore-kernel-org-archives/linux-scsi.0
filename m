From: Michael Reed <mdr@sgi.com>
Subject: system hang / oops with 2.6.18-rc2-scsi-rc-fixes and fibre channel
 targets
Date: Thu, 27 Jul 2006 17:39:47 -0500
Message-ID: <44C940B3.6020403@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:2261 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751068AbWG0Wjv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jul 2006 18:39:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <James.Smart@Emulex.Com>

I can reproduce a variety of hangs / oopses using fibre channel storage.
I create an md on two fibre channel disks connected to a fabric.  (Haven't
tried loop.)  This sequence of events reliably induces failures like the
ones below.

	-if one doesn't exist, create an md stripe (simple) on two fc disks

		duck /root# cat /proc/mdstat
		Personalities : [linear] [raid0] [raid1] [multipath]
		md0 : active raid0 sdi[0] sdf[1]
		      71687168 blocks 64k chunks


	portdisable	the targets' switch port
	-wait for the transport dev_loss timer to fire
	portenable	the targets' switch port
	mdadm --stop /dev/md0
	portdisable	the targets' switch port
	-wait again
	portenable	the targets' switch port

I'll grant that I'm exploiting a known problem with md and target removal,
but I think it's fair to point these issues out.  Relevant threads below.

http://marc.theaimsgroup.com/?l=linux-scsi&m=114987740529740&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=115015423722568&w=2



Using fusion fibre channel
==========================
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sde: 71687372 512-byte hdwr sectors (36704 MB)
sde: Write Protect is off
sde: Mode Sense: ab 00 10 08
SCSI device sde: drive cache: write back w/ FUA
SCSI device sde: 71687372 512-byte hdwr sectors (36704 MB)
sde: Write Protect is off
sde: Mode Sense: ab 00 10 08
SCSI device sde: drive cache: write back w/ FUA
 sde: sde1 sde9 sde11
sd 3:0:8:0: Attached scsi disk sde
sd 3:0:8:0: Attached scsi generic sg12 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdf: 71687372 512-byte hdwr sectors (36704 MB)
sdf: Write Protect is off
sdf: Mode Sense: ab 00 10 08
SCSI device sdf: drive cache: write back w/ FUA
SCSI device sdf: 71687372 512-byte hdwr sectors (36704 MB)
sdf: Write Protect is off
sdf: Mode Sense: ab 00 10 08
SCSI device sdf: drive cache: write back w/ FUA
 sdf:<3>BUG: soft lockup detected on CPU#0!

Call Trace:
 [<a000000100012880>] show_stack+0x40/0xa0
                                sp=e000003013b6fa60 bsp=e000003013b694e8
 [<a000000100012910>] dump_stack+0x30/0x60
                                sp=e000003013b6fc30 bsp=e000003013b694d0
 [<a0000001000f4d30>] softlockup_tick+0x1f0/0x220
                                sp=e000003013b6fc30 bsp=e000003013b69490
 [<a0000001000bb410>] run_local_timers+0x30/0x60
                                sp=e000003013b6fc30 bsp=e000003013b69478
 [<a0000001000bb4c0>] update_process_times+0x80/0x100
                                sp=e000003013b6fc30 bsp=e000003013b69448
 [<a000000100034650>] timer_interrupt+0x110/0x2e0
                                sp=e000003013b6fc30 bsp=e000003013b69408
 [<a0000001000f53a0>] handle_IRQ_event+0xa0/0x140
                                sp=e000003013b6fc30 bsp=e000003013b693c0
 [<a0000001000f5570>] __do_IRQ+0x130/0x3e0
                                sp=e000003013b6fc30 bsp=e000003013b69378
 [<a0000001000102b0>] ia64_handle_irq+0xb0/0x160
                                sp=e000003013b6fc30 bsp=e000003013b69348
 [<a00000010000bb20>] ia64_leave_kernel+0x0/0x290
                                sp=e000003013b6fc30 bsp=e000003013b69348
 [<a000000100051f10>] smp_call_function+0x290/0x340
                                sp=e000003013b6fe00 bsp=e000003013b692e8
 [<a0000001000aeca0>] on_each_cpu+0x60/0x140
                                sp=e000003013b6fe20 bsp=e000003013b692b0
 [<a00000010015ebe0>] invalidate_bdev+0x40/0x80
                                sp=e000003013b6fe20 bsp=e000003013b69290
 [<a00000010016c310>] kill_bdev+0x30/0x80
                                sp=e000003013b6fe20 bsp=e000003013b69270
 [<a00000010016d280>] __blkdev_put+0xa0/0x420
                                sp=e000003013b6fe20 bsp=e000003013b69228
 [<a00000010016d690>] blkdev_put+0x30/0x60
                                sp=e000003013b6fe30 bsp=e000003013b69208
 [<a00000010016f220>] blkdev_close+0x60/0x80
                                sp=e000003013b6fe30 bsp=e000003013b691d0
 [<a00000010015ad80>] __fput+0x1a0/0x400
                                sp=e000003013b6fe30 bsp=e000003013b69190
 [<a00000010015b020>] fput+0x40/0x60
                                sp=e000003013b6fe30 bsp=e000003013b69170
 [<a0000001001547f0>] filp_close+0x110/0x140
                                sp=e000003013b6fe30 bsp=e000003013b69140
 [<a000000100154960>] sys_close+0x140/0x1a0
                                sp=e000003013b6fe30 bsp=e000003013b690c8
 [<a00000010000b980>] ia64_ret_from_syscall+0x0/0x20
                                sp=e000003013b6fe30 bsp=e000003013b690c8
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000003013b70000 bsp=e000003013b690c8






Using Emulex LightPulse Fibre Channel SCSI driver 8.1.7
=======================================================





Unable to handle kernel NULL pointer dereference (address 0000000000000260)
scsi_wq_2[1955]: Oops 8813272891392 [1]
Modules linked in: ipv6 nfsd exportfs nfs lockd sunrpc mptfc mptscsih mptbase lpfc sg

Pid: 1955, CPU 1, comm:            scsi_wq_2
psr : 0000101008026018 ifs : 8000000000000003 ip  : [<a00000010056ff70>]    Not tainted
ip is at scsi_is_fc_rport+0x10/0x40
unat: 0000000000000000 pfs : 000000000000040b rsc : 0000000000000003
rnat: 000000003b9aca00 bsps: 000000000001003e pr  : 0000000000006581
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a000000203ddeee0 b6  : a000000203ddeea0 b7  : a0000001004d7f20
f6  : 000000000000000000000 f7  : 1003e20c49ba5e353f7cf
f8  : 1003e00000000000004e2 f9  : 1003e000000000fa00000
f10 : 1003e000000003b9aca00 f11 : 1003e431bde82d7b634db
r1  : a000000100d4c690 r2  : a000000100b5b430 r3  : e0000034f52c7350
r8  : 0000000000000000 r9  : a000000100576ea0 r10 : e00000b07bbeb570
r11 : 0000284100000000 r12 : e00000b07881fc50 r13 : e00000b078818000
r14 : e0000034f7018000 r15 : e00000b078b98390 r16 : e0000034f709c150
r17 : 0000080000000000 r18 : a000000203dfbcd0 r19 : a000000100e95698
r20 : a000000100e95698 r21 : a000000203dfbc68 r22 : e0000034f70180b8
r23 : e0000034f7018000 r24 : 0004380100000000 r25 : 0000380100000000
r26 : 0004000000000000 r27 : a000000203ddeea0 r28 : 000000000000000a
r29 : e0000034f52c70d0 r30 : 0000204100000000 r31 : 0000000000000000

Call Trace:
 [<a000000100012880>] show_stack+0x40/0xa0
                                sp=e00000b07881f800 bsp=e00000b078819438
kernel BUG at mm/slab.c:3047!
scsi_wq_2[1955]: bugcheck! 0 [2]
Modules linked in: ipv6 nfsd exportfs nfs lockd sunrpc mptfc mptscsih mptbase lpfc sg

Pid: 1955, CPU 1, comm:            scsi_wq_2
psr : 0000101008022018 ifs : 800000000000048c ip  : [<a00000010014c2e0>]    Not tainted
ip is at __cache_alloc_node+0x140/0x2e0
unat: 0000000000000000 pfs : 000000000000048c rsc : 0000000000000003
rnat: 9999999996900000 bsps: 000000000000fffd pr  : 00000000000065a5
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a00000010014c2e0 b6  : e0000030025cbb10 b7  : a0000001004d7f20
f6  : 000000000000000000000 f7  : 1003e20c49ba5e353f7cf
f8  : 1003e00000000000000c8 f9  : 10006c7fffffffd73ea5c
f10 : 0fffd9999999996900000 f11 : 1003e0000000000000000
r1  : a000000100d4c690 r2  : e00000b078819060 r3  : 0000000000000005
r8  : 0000000000000021 r9  : 0000000000004000 r10 : a000000100b64ce8
r11 : a000000100b64cf8 r12 : e00000b07881f080 r13 : e00000b078818000
r14 : 0000000000000000 r15 : e00000b078819070 r16 : e00000b078819088
r17 : 0000000000004000 r18 : e00000b07881ef31 r19 : a000000100b63ec8
r20 : 0000000000000000 r21 : 0000000000004000 r22 : a000000100b64d00
r23 : a000000100b64ce0 r24 : a000000100a90f00 r25 : a000000100b63dc8
r26 : e00000b078819070 r27 : e00000b078819060 r28 : e00000b078819088
r29 : 0000000000000004 r30 : 0000000000000005 r31 : 000000000000030e
BUG: soft lockup detected on CPU#2!
BUG: warning at lib/kref.c:32/kref_get()




-------------- and this one -----------------





duck /root# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [multipath]
md0 : active raid0 sdi[0] sdf[1]
      71687168 blocks 64k chunks

unused devices: <none>
duck /root# lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1d:e9:fa NPort x131bd1 Data: x8 x7 x0
lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1e:1a:41 NPort x131bd3 Data: x8 x7 x0
lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1d:d8:6c NPort x131bce Data: x8 x7 x0
lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1d:d8:51 NPort x131bd2 Data: x8 x7 x0
lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1d:e9:80 NPort x131bd4 Data: x8 x7 x0
lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1e:3a:db NPort x131bd6 Data: x8 x7 x0
lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1e:3a:2d NPort x131bd5 Data: x8 x7 x0
lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1e:3a:fb NPort x131bd9 Data: x8 x7 x0
 rport-2:0-6: blocked FC remote port time out: removing target and saving binding
 rport-2:0-7: blocked FC remote port time out: removing target and saving binding
 rport-2:0-8: blocked FC remote port time out: removing target and saving binding
 rport-2:0-9: blocked FC remote port time out: removing target and saving binding
 rport-2:0-10: blocked FC remote port time out: removing target and saving binding
 rport-2:0-15: blocked FC remote port time out: removing target and saving binding
 rport-2:0-16: blocked FC remote port time out: removing target and saving binding
 rport-2:0-17: blocked FC remote port time out: removing target and saving binding
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sde: 71687372 512-byte hdwr sectors (36704 MB)
sde: Write Protect is off
sde: Mode Sense: ab 00 10 08
SCSI device sde: drive cache: write back w/ FUA
SCSI device sde: 71687372 512-byte hdwr sectors (36704 MB)
sde: Write Protect is off
sde: Mode Sense: ab 00 10 08
SCSI device sde: drive cache: write back w/ FUA
 sde: sde1 sde9 sde11
sd 2:0:6:0: Attached scsi disk sde
sd 2:0:6:0: Attached scsi generic sg8 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdg: 71687372 512-byte hdwr sectors (36704 MB)
sdg: Write Protect is off
sdg: Mode Sense: ab 00 10 08
SCSI device sdg: drive cache: write back w/ FUA
SCSI device sdg: 71687372 512-byte hdwr sectors (36704 MB)
sdg: Write Protect is off
sdg: Mode Sense: ab 00 10 08
SCSI device sdg: drive cache: write back w/ FUA
 sdg: sdg1 sdg9 sdg11
sd 2:0:4:0: Attached scsi disk sdg
sd 2:0:4:0: Attached scsi generic sg9 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdh: 71687372 512-byte hdwr sectors (36704 MB)
sdh: Write Protect is off
sdh: Mode Sense: ab 00 10 08
SCSI device sdh: drive cache: write back w/ FUA
SCSI device sdh: 71687372 512-byte hdwr sectors (36704 MB)
sdh: Write Protect is off
sdh: Mode Sense: ab 00 10 08
SCSI device sdh: drive cache: write back w/ FUA
 sdh: sdh1 sdh9 sdh11
sd 2:0:7:0: Attached scsi disk sdh
sd 2:0:7:0: Attached scsi generic sg10 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdj: 71687372 512-byte hdwr sectors (36704 MB)
sdj: Write Protect is off
sdj: Mode Sense: ab 00 10 08
SCSI device sdj: drive cache: write back w/ FUA
SCSI device sdj: 71687372 512-byte hdwr sectors (36704 MB)
sdj: Write Protect is off
sdj: Mode Sense: ab 00 10 08
SCSI device sdj: drive cache: write back w/ FUA
 sdj: unknown partition table
sd 2:0:5:0: Attached scsi disk sdj
sd 2:0:5:0: Attached scsi generic sg11 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
kobject_add failed for 2:0:5:0 with -EEXIST, don't try to register things with the same name in the same directory.

Call Trace:
 [<a000000100012880>] show_stack+0x40/0xa0
                                sp=e0000030148a7a80 bsp=e0000030148a13c8
 [<a000000100012910>] dump_stack+0x30/0x60
                                sp=e0000030148a7c50 bsp=e0000030148a13b0
 [<a0000001004080e0>] kobject_add+0x3a0/0x420
                                sp=e0000030148a7c50 bsp=e0000030148a1370
 [<a0000001004e5330>] device_add+0xf0/0x620
                                sp=e0000030148a7c50 bsp=e0000030148a1328
 [<a000000100566ea0>] scsi_sysfs_add_sdev+0x60/0x520
                                sp=e0000030148a7c50 bsp=e0000030148a12e0
 [<a0000001005629d0>] scsi_probe_and_add_lun+0x11b0/0x1460
                                sp=e0000030148a7c50 bsp=e0000030148a1278
 [<a000000100564100>] __scsi_scan_target+0x780/0xb60
                                sp=e0000030148a7c70 bsp=e0000030148a1220
 [<a000000100564a90>] scsi_scan_target+0xd0/0x100
                                sp=e0000030148a7cd0 bsp=e0000030148a11c8
 [<a000000100571b80>] fc_scsi_scan_rport+0xe0/0x160
                                sp=e0000030148a7cd0 bsp=e0000030148a11a0
 [<a0000001000ca460>] run_workqueue+0x1c0/0x280
                                sp=e0000030148a7cd0 bsp=e0000030148a1160
 [<a0000001000cba50>] worker_thread+0x1d0/0x260
                                sp=e0000030148a7cd0 bsp=e0000030148a1130
 [<a0000001000d3660>] kthread+0x220/0x2a0
                                sp=e0000030148a7d50 bsp=e0000030148a10e8
 [<a000000100010e30>] kernel_thread_helper+0xd0/0x100
                                sp=e0000030148a7e30 bsp=e0000030148a10c0
 [<a000000100009140>] start_kernel_thread+0x20/0x40
                                sp=e0000030148a7e30 bsp=e0000030148a10c0
error 1
scsi 2:0:5:0: Unexpected response from lun 0 while scanning, scan aborted
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdk: 71687372 512-byte hdwr sectors (36704 MB)
sdk: Write Protect is off
sdk: Mode Sense: ab 00 10 08
SCSI device sdk: drive cache: write back w/ FUA
SCSI device sdk: 71687372 512-byte hdwr sectors (36704 MB)
sdk: Write Protect is off
sdk: Mode Sense: ab 00 10 08
SCSI device sdk: drive cache: write back w/ FUA
 sdk: unknown partition table
sd 2:0:8:0: Attached scsi disk sdk
sd 2:0:8:0: Attached scsi generic sg12 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
kobject_add failed for 2:0:8:0 with -EEXIST, don't try to register things with the same name in the same directory.

Call Trace:
 [<a000000100012880>] show_stack+0x40/0xa0
                                sp=e0000030148a7a80 bsp=e0000030148a13c8
 [<a000000100012910>] dump_stack+0x30/0x60
                                sp=e0000030148a7c50 bsp=e0000030148a13b0
 [<a0000001004080e0>] kobject_add+0x3a0/0x420
                                sp=e0000030148a7c50 bsp=e0000030148a1370
 [<a0000001004e5330>] device_add+0xf0/0x620
                                sp=e0000030148a7c50 bsp=e0000030148a1328
 [<a000000100566ea0>] scsi_sysfs_add_sdev+0x60/0x520
                                sp=e0000030148a7c50 bsp=e0000030148a12e0
 [<a0000001005629d0>] scsi_probe_and_add_lun+0x11b0/0x1460
                                sp=e0000030148a7c50 bsp=e0000030148a1278
 [<a000000100564100>] __scsi_scan_target+0x780/0xb60
                                sp=e0000030148a7c70 bsp=e0000030148a1220
 [<a000000100564a90>] scsi_scan_target+0xd0/0x100
                                sp=e0000030148a7cd0 bsp=e0000030148a11c8
 [<a000000100571b80>] fc_scsi_scan_rport+0xe0/0x160
                                sp=e0000030148a7cd0 bsp=e0000030148a11a0
 [<a0000001000ca460>] run_workqueue+0x1c0/0x280
                                sp=e0000030148a7cd0 bsp=e0000030148a1160
 [<a0000001000cba50>] worker_thread+0x1d0/0x260
                                sp=e0000030148a7cd0 bsp=e0000030148a1130
 [<a0000001000d3660>] kthread+0x220/0x2a0
                                sp=e0000030148a7d50 bsp=e0000030148a10e8
 [<a000000100010e30>] kernel_thread_helper+0xd0/0x100
                                sp=e0000030148a7e30 bsp=e0000030148a10c0
 [<a000000100009140>] start_kernel_thread+0x20/0x40
                                sp=e0000030148a7e30 bsp=e0000030148a10c0
error 1
scsi 2:0:8:0: Unexpected response from lun 0 while scanning, scan aborted
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdl: 71687372 512-byte hdwr sectors (36704 MB)
sdl: Write Protect is off
sdl: Mode Sense: ab 00 10 08
SCSI device sdl: drive cache: write back w/ FUA
SCSI device sdl: 71687372 512-byte hdwr sectors (36704 MB)
sdl: Write Protect is off
sdl: Mode Sense: ab 00 10 08
SCSI device sdl: drive cache: write back w/ FUA
 sdl: sdl1 sdl9 sdl11
sd 2:0:14:0: Attached scsi disk sdl
sd 2:0:14:0: Attached scsi generic sg17 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdm: 71687372 512-byte hdwr sectors (36704 MB)
sdm: Write Protect is off
sdm: Mode Sense: ab 00 10 08
SCSI device sdm: drive cache: write back w/ FUA
SCSI device sdm: 71687372 512-byte hdwr sectors (36704 MB)
sdm: Write Protect is off
sdm: Mode Sense: ab 00 10 08
SCSI device sdm: drive cache: write back w/ FUA
 sdm: sdm1 sdm9 sdm11
sd 2:0:13:0: Attached scsi disk sdm
sd 2:0:13:0: Attached scsi generic sg18 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdn: 71687372 512-byte hdwr sectors (36704 MB)
sdn: Write Protect is off
sdn: Mode Sense: ab 00 10 08
SCSI device sdn: drive cache: write back w/ FUA
SCSI device sdn: 71687372 512-byte hdwr sectors (36704 MB)
sdn: Write Protect is off
sdn: Mode Sense: ab 00 10 08
SCSI device sdn: drive cache: write back w/ FUA
 sdn: sdn1 sdn9 sdn11
sd 2:0:15:0: Attached scsi disk sdn
sd 2:0:15:0: Attached scsi generic sg19 type 0

duck /root# sync
duck /root# sync
duck /root# !md
mdadm --stop /dev/md0
md: md0 stopped.
md: unbind<sdi>
md: export_rdev(sdi)
md: unbind<sdf>
md: export_rdev(sdf)
duck /root# lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1d:d8:6c NPort x131bce Data: x8 x7 x0
lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1d:e9:fa NPort x131bd1 Data: x8 x7 x0
lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1d:d8:51 NPort x131bd2 Data: x8 x7 x0
lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1e:1a:41 NPort x131bd3 Data: x8 x7 x0
lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1d:e9:80 NPort x131bd4 Data: x8 x7 x0
lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1e:3a:2d NPort x131bd5 Data: x8 x7 x0
lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1e:3a:db NPort x131bd6 Data: x8 x7 x0
lpfc 0001:00:02.0: 0:0203 Nodev timeout on WWPN 22:0:0:11:c6:1e:3a:fb NPort x131bd9 Data: x8 x7 x0

duck /root#  rport-2:0-8: blocked FC remote port time out: removing target and saving binding
 rport-2:0-6: blocked FC remote port time out: removing target and saving binding
 rport-2:0-9: blocked FC remote port time out: removing target and saving binding
 rport-2:0-7: blocked FC remote port time out: removing target and saving binding
 rport-2:0-10: blocked FC remote port time out: removing target and saving binding
 rport-2:0-16: blocked FC remote port time out: removing target and saving binding
 rport-2:0-15: blocked FC remote port time out: removing target and saving binding
 rport-2:0-17: blocked FC remote port time out: removing target and saving binding
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sde: 71687372 512-byte hdwr sectors (36704 MB)
sde: Write Protect is off
sde: Mode Sense: ab 00 10 08
SCSI device sde: drive cache: write back w/ FUA
SCSI device sde: 71687372 512-byte hdwr sectors (36704 MB)
sde: Write Protect is off
sde: Mode Sense: ab 00 10 08
SCSI device sde: drive cache: write back w/ FUA
 sde: sde1 sde9 sde11
sd 2:0:6:0: Attached scsi disk sde
sd 2:0:6:0: Attached scsi generic sg8 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdf: 71687372 512-byte hdwr sectors (36704 MB)
sdf: Write Protect is off
sdf: Mode Sense: ab 00 10 08
SCSI device sdf: drive cache: write back w/ FUA
SCSI device sdf: 71687372 512-byte hdwr sectors (36704 MB)
sdf: Write Protect is off
sdf: Mode Sense: ab 00 10 08
SCSI device sdf: drive cache: write back w/ FUA
 sdf: sdf1 sdf9 sdf11
sd 2:0:4:0: Attached scsi disk sdf
sd 2:0:4:0: Attached scsi generic sg9 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdg: 71687372 512-byte hdwr sectors (36704 MB)
sdg: Write Protect is off
sdg: Mode Sense: ab 00 10 08
SCSI device sdg: drive cache: write back w/ FUA
SCSI device sdg: 71687372 512-byte hdwr sectors (36704 MB)
sdg: Write Protect is off
sdg: Mode Sense: ab 00 10 08
SCSI device sdg: drive cache: write back w/ FUA
 sdg: sdg1 sdg9 sdg11
BUG: soft lockup detected on CPU#1!

Call Trace:
 [<a000000100012880>] show_stack+0x40/0xa0
                                sp=e0000030148a7850 bsp=e0000030148a1800
 [<a000000100012910>] dump_stack+0x30/0x60
                                sp=e0000030148a7a20 bsp=e0000030148a17e0
 [<a0000001000f4c90>] softlockup_tick+0x1f0/0x220
                                sp=e0000030148a7a20 bsp=e0000030148a17a0
 [<a0000001000bb350>] run_local_timers+0x30/0x60
                                sp=e0000030148a7a20 bsp=e0000030148a1788
 [<a0000001000bb400>] update_process_times+0x80/0x100
                                sp=e0000030148a7a20 bsp=e0000030148a1758
 [<a0000001000345d0>] timer_interrupt+0x110/0x2e0
                                sp=e0000030148a7a20 bsp=e0000030148a1718
 [<a0000001000f5300>] handle_IRQ_event+0xa0/0x140
                                sp=e0000030148a7a20 bsp=e0000030148a16d8
 [<a0000001000f54d0>] __do_IRQ+0x130/0x3e0
                                sp=e0000030148a7a20 bsp=e0000030148a1690
 [<a0000001000102b0>] ia64_handle_irq+0xb0/0x160
                                sp=e0000030148a7a20 bsp=e0000030148a1660
 [<a00000010000bb20>] ia64_leave_kernel+0x0/0x290
                                sp=e0000030148a7a20 bsp=e0000030148a1660
 [<a000000100051e90>] smp_call_function+0x290/0x340
                                sp=e0000030148a7bf0 bsp=e0000030148a1600
 [<a0000001000aeae0>] on_each_cpu+0x60/0x140
                                sp=e0000030148a7c10 bsp=e0000030148a15c0
 [<a00000010015eea0>] invalidate_bdev+0x40/0x80
                                sp=e0000030148a7c10 bsp=e0000030148a15a0
 [<a00000010016c5b0>] kill_bdev+0x30/0x80
                                sp=e0000030148a7c10 bsp=e0000030148a1580
 [<a00000010016d520>] __blkdev_put+0xa0/0x420
                                sp=e0000030148a7c10 bsp=e0000030148a1538
 [<a00000010016d930>] blkdev_put+0x30/0x60
                                sp=e0000030148a7c20 bsp=e0000030148a1518
 [<a0000001001f1d70>] register_disk+0x2b0/0x3a0
                                sp=e0000030148a7c20 bsp=e0000030148a14e0
 [<a0000001003df8c0>] add_disk+0xa0/0xe0
                                sp=e0000030148a7c20 bsp=e0000030148a14c0
 [<a0000001005a98d0>] sd_probe+0x6f0/0x7a0
                                sp=e0000030148a7c20 bsp=e0000030148a1468
 [<a0000001004e9640>] driver_probe_device+0x100/0x1e0
                                sp=e0000030148a7c30 bsp=e0000030148a1430
 [<a0000001004e9750>] __device_attach+0x30/0x60
                                sp=e0000030148a7c30 bsp=e0000030148a1408
 [<a0000001004e8640>] bus_for_each_drv+0x80/0x120
                                sp=e0000030148a7c30 bsp=e0000030148a13c8
 [<a0000001004e9820>] device_attach+0xa0/0x100
                                sp=e0000030148a7c50 bsp=e0000030148a1398
 [<a0000001004e7f50>] bus_attach_device+0x30/0x60
                                sp=e0000030148a7c50 bsp=e0000030148a1370
 [<a0000001004e5630>] device_add+0x3f0/0x620
                                sp=e0000030148a7c50 bsp=e0000030148a1328
 [<a000000100566ea0>] scsi_sysfs_add_sdev+0x60/0x520
                                sp=e0000030148a7c50 bsp=e0000030148a12e0
 [<a0000001005629d0>] scsi_probe_and_add_lun+0x11b0/0x1460
                                sp=e0000030148a7c50 bsp=e0000030148a1278
 [<a000000100563af0>] __scsi_scan_target+0x170/0xb60
                                sp=e0000030148a7c70 bsp=e0000030148a1220
 [<a000000100564a90>] scsi_scan_target+0xd0/0x100
                                sp=e0000030148a7cd0 bsp=e0000030148a11c8
 [<a000000100571b80>] fc_scsi_scan_rport+0xe0/0x160
                                sp=e0000030148a7cd0 bsp=e0000030148a11a0
 [<a0000001000ca460>] run_workqueue+0x1c0/0x280
                                sp=e0000030148a7cd0 bsp=e0000030148a1160
 [<a0000001000cba50>] worker_thread+0x1d0/0x260
                                sp=e0000030148a7cd0 bsp=e0000030148a1130
 [<a0000001000d3660>] kthread+0x220/0x2a0
                                sp=e0000030148a7d50 bsp=e0000030148a10e8
 [<a000000100010e30>] kernel_thread_helper+0xd0/0x100
                                sp=e0000030148a7e30 bsp=e0000030148a10c0
 [<a000000100009140>] start_kernel_thread+0x20/0x40
                                sp=e0000030148a7e30 bsp=e0000030148a10c0

Entering kdb (current=0xe00000300f4e8000, pid 5342) on processor 0 due to Keyboard Entry
[0]kdb> ps
84 sleeping system daemon (state M) processes suppressed
Task Addr               Pid   Parent [*] cpu State Thread             Command
0xe00000300f4e8000     5342        1  1    0   R  0xe00000300f4e8330 *nscd
0xe0000030148a0000     1946       19  1    1   R  0xe0000030148a0330  scsi_wq_2
0xe000003011bd8000     6403     2368  0    2   R  0xe000003011bd8330  udevd
0xe000003010bb8000     6398     6395  1    3   R  0xe000003010bb8330  vol_id

[0]kdb> btp 6398
Stack traceback for pid 6398
0xe000003010bb8000     6398     6395  1    3   R  0xe000003010bb8330  vol_id
0xa0000001006fe2f0 lock_kernel+0x1b0
        args (0x100000000, 0xa00000010016d4d0, 0x48b, 0x20000000002b4030)
0xa00000010016d4d0 __blkdev_put+0x50
        args (0xe00000b079b5fc00, 0x0, 0x40d, 0xe00000b078f23b00, 0xe00000b079b5fcd0)
0xa00000010016d930 blkdev_put+0x30
        args (0xe00000b079b5fc00, 0xa00000010016f4c0, 0x307, 0xb0)
0xa00000010016f4c0 blkdev_close+0x60
        args (0xe0000034f5b2c498, 0xe00000b0788bd580, 0xe00000b079b5fc00, 0xa00000010015b040, 0x40d)
0xa00000010015b040 __fput+0x1a0
        args (0xe00000b0788bd580, 0x10, 0xe0000034f5b2c498, 0xe000003015cdcb98, 0xe00000b07bad1b80)
0xa00000010015b2e0 fput+0x40
        args (0xe00000b0788bd580, 0xa000000100154ab0, 0x308, 0x308)
0xa000000100154ab0 filp_close+0x110
        args (0xe00000b0788bd580, 0xe0000034f725f400, 0x0, 0xa000000100154c20, 0x791)
0xa000000100154c20 sys_close+0x140
        args (0x3, 0x600000000000da58, 0x6000000000010010, 0x6000000000021a10, 0x4000000000002f10)
0xa00000010000b980 ia64_ret_from_syscall
        args (0x3, 0x600000000000da58, 0x6000000000010010, 0x6000000000021a10, 0x4000000000002f10)
0xa000000000010620 __kernel_syscall_via_break
        args (0x3, 0x600000000000da58, 0x6000000000010010, 0x6000000000021a10, 0x4000000000002f10)

