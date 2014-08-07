From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] New: mvsas.ko v0.8.16 error messages and kernel crashes
 attaching 4 SATA drives to specific HP SAS expander ports
Date: Thu, 07 Aug 2014 17:33:26 +0000
Message-ID: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38742 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264AbaHGRde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Aug 2014 13:33:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 00006201C0
	for <linux-scsi@vger.kernel.org>; Thu,  7 Aug 2014 17:33:31 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C1A7A2018E
	for <linux-scsi@vger.kernel.org>; Thu,  7 Aug 2014 17:33:28 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D81861

            Bug ID: 81861
           Summary: mvsas.ko v0.8.16 error messages and kernel crashes
                    attaching 4 SATA drives to specific HP SAS expander
                    ports
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.16.0-031600rc6
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: linux-ide@crashplan.pro
        Regression: No

The issues are (1) error messages and (2) kernel crashes when attaching=
 4
drives (1 SFF SAS cable) to specific ports of a SAS expander.

The issue is only tested with HP SAS port expander (PMC Sierra PM8005 c=
hip)
running firmware 2.08. This expander has 36/4=3D9 SAS ports.
1 port of type SFF-8088, labelled 1C on the PCB.
8 port of type SFF-8087, labelled 2C till 9C on the PCB.
Port =E2=80=9C1C=E2=80=9D is connected to a Supermicro SAS2LP-MV8, Marv=
ell 88SE9485 based chip,
lspci output is inserted below.

The issue is not always identical. When attaching the 4 drives to diffe=
rent
port numbers on the port multiplier, this is what happens in this order=
:
2C, 3C, 4C =3D ok
5C         =3D error
6C, 7C, 8C =3D kernel crash
9C         =3D error

After that first run from port 2 till 9, the issue seems more random:
9C =3D kernel crash
4C =3D kernel crash
3C =3D error
9C =3D error
7C =3D kernel crash
3C =3D error
2C =3D ok
4C =3D kernel crash

The =E2=80=9Cerror message=E2=80=9D on ports 5C and 9C is:
scsi 5:0:4:0: Failed to get diagnostic page 0x8000002
scsi 5:0:4:0: Failed to bind enclosure -19

=3D=3D=3D=3D
Most testing is done with Ubuntu 14.04.1 running Ubuntu=E2=80=99s suppl=
ied mainline
kernel 3.16.0-rc6.=20
# modprobe -v mvsas
insmod
/lib/modules/3.16.0-031600rc6-generic/kernel/drivers/scsi/scsi_transpor=
t_sas.ko
insmod
/lib/modules/3.16.0-031600rc6-generic/kernel/drivers/scsi/libsas/libsas=
=2Eko
insmod /lib/modules/3.16.0-031600rc6-generic/kernel/drivers/scsi/mvsas/=
mvsas.ko
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Other tested kernels, with similar results
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kernel Mainline 3.16-20140724
kernel Ubuntu 3.13.11
kernel Ubuntu 3.13.0-24
kernel Ubuntu 3.12.25
kernel Ubuntu 2.6.32 =3D no SAS expander detected -> no further testing
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
No drives attached to expander
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
# lsscsi
[4:0:0:0]    disk    ATA      OCZ-VERTEX       1.3   /dev/sda
[5:0:0:0]    enclosu HP       HP SAS EXP Card  2.08  -
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
With 4 drives (brown#4) attached to expander port 2C
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
# lsscsi
[4:0:0:0]    disk    ATA      OCZ-VERTEX       1.3   /dev/sda
[6:0:0:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdb
[6:0:1:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdc
[6:0:2:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdd
[6:0:3:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sde
[6:0:4:0]    enclosu HP       HP SAS EXP Card  2.08  -
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
With 4 drives (brown#4) attached to expander port 3C
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
# lsscsi
[4:0:0:0]    disk    ATA      OCZ-VERTEX       1.3   /dev/sda
[6:0:4:0]    enclosu HP       HP SAS EXP Card  2.08  -
[6:0:5:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdb
[6:0:6:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdc
[6:0:7:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdd
[6:0:8:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sde
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
With 4 drives (brown#4) attached to expander port 4C
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
# lsscsi
[4:0:0:0]    disk    ATA      OCZ-VERTEX       1.3   /dev/sda
[6:0:4:0]    enclosu HP       HP SAS EXP Card  2.08  -
[6:0:9:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdb
[6:0:10:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdc
[6:0:11:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdd
[6:0:12:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sde
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
With 4 drives (brown#4) attached to expander port 5C
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
scsi 5:0:4:0: Failed to get diagnostic page 0x8000002
scsi 5:0:4:0: Failed to bind enclosure -19
# lsscsi
[4:0:0:0]    disk    ATA      OCZ-VERTEX       1.3   /dev/sda
[5:0:4:0]    enclosu HP       HP SAS EXP Card  2.08  -
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
With 4 drives (brown#4) attached to expander port 6C
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Kernel crash (data from OCR-ed screenshot):
[ 263.190030] R13 ffff88020e837808 R14: ffff88021b4a0080 R15: ffff88003=
6cll200
[ 269.130052] FS: 00007f9ef5abb740(0000) GS:ffff88021b200000(0000)
knlGS:0000000000000000   =20
[ 269.190074] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 269.190091] CR2 00007f9ef5ac2000 CR3: 000000020fbd8000 CR4: 000000000=
00407f0
[ 269.190111] Stack:       =20
[ 269.190118]  0000000000000000 0000000000000002 ffff88021f5f7f08
dead000000200200       =20
[ 269.190145]  ffff38020dl037b0 0000000000000046 ffff88020eb81e38
ffffffff811b06ae   =20
[ 269.190171]  ffff38020e837798 ffff88020d69bl40 ffff88020dl037b0
ffff88020dl00000   =20
[ 269.190197] Call Trace:
[ 269.190210] [<fffffff811b06ae>] ? dma_pool_alloc+0xce/0x100
[ 269.190229] [<fffffffc06e44ab>] mvs_task_prep+0x58b/0x620 [mvsas]
[ 269.190248] [<fffffffc06e45a8>] mvs_task_exec.isra.14+0x68/0xf0 [mvsa=
s]
[ 269.190269] [<fffffffc06e5149>] mvs_queue_command+0x39/0x40 [mvsas]
[ 269.190291] [<fffffffc06d48ab>] sas_ata_qc_issue+0x28b/0x2d0 [libsas]
[ 269.190312] [<fffffff8153102f>] ata_qc_issue+0xl8f/0x2d0
[ 269.190331] [<fffffff81537dc0>] ? ata_scsi_rw_xlat+0x230/0x230
[ 269.190349] [<fffffff81535fe4>] ata_scsi_translate+0xb4/0x1b0
[ 269.190369] [<fffffff81539aal>] ata_sas_queuecmd+0xl21/0x2b0
[ 269.190389] [<fffffffc06d387f>] sas_queuecommand+0x20f/0x280 [libsas]
[ 269.190409] [<fffffff8150d6ce>] scsi_dispatch_cmd+0xce/0x280
[ 269.190428] [<fffffff81515dd2>] scsi_request_fn+0x372/0x490
[ 269.190447] [<fffffff813541c7>] __blk_run_queue+0x37/0x50
[ 269.190465] [<fffffff8135305f>] __elv_add_request+0xef/0x310
[ 269.190483] [<fffffff8135el23>] blk_execute_rq_noujait+0xb3/0x190
[ 269.190504] [<fffffff811c2653>] ? kmem_cache_alloc_node+0xle3/0x200
[ 269.190523] [<fffffff8135e28d>] blk_execute_rq+0x8d/0x160
[ 269.190542] [<fffffff812f8bf8>] ? security_capable+0x18/0x20
[ 269.190561] [<fffffff81079el0>] ? ns_capable+0x30/0x60
[ 269.190578] [<fffffff81079ed7>] ? capable+0x17/0x20
[ 269.191191] [<fffffff81369b85>] ? blk_verify_command+0x25/0x70
[ 269.191806] [<fffffff8136ald8>] sg_io+0x168/0x2c0
[ 269.192422] [<fffffff8136a557>] scsi_cmd_ioct1+0x227/0x520
[ 269.193030] [<fffffff81198bfb>] ? __handle_mm_fault+0x1db/0x360
[ 269.193631] [<fffffff8136a89e>] scsi_cmd_blk_ioctl+0x4e/0x60
[ 269.194231] [<fffffff81520ab7>] sd_ioctl+0xd7/0xl60
[ 269.194810] [<fffffff81366b9e>] blkdev_ioctl+0xde/0x810
[ 269.195373] [<fffffff810a8ead>] ? vtime_account_user+0x5d/0x70
[ 269.195921] [<fffffff812152d0>] block_ioct1+0x40/0x50
[ 269.196449] [<fffffffSllf1805>] do_vfs_ioct1+0x75/0x2c0
[ 269.196966] [<fffffff810247b5>] ? syscall_trace_enter+0x165/0x280
[ 269.197475] [<fffffff81168835>] ? context_tracking_user_enter+0x25/0x=
30
[ 269.197972] [<fffffff811flael>] SyS_ioctl+0x91/0xb0
[ 269.198458] [<fffffff817913bf>] tracesys+0xe1/0xe6
[ 269.198930] Code: 00 00 48 8b 0c  c8 0f 84 a7 02 00 00 44 89 c0 41 b9=
 00 10
00 00 48 8d 34 80 48 3d 04 70 48 3d b4 c3 b3 55 02
00 8b 43 58 89 46 lc <8b> 89 54 02 00 00 44 89 C0 8b 7b 58 0d 00 00 00 =
70 4c 8b
53 48
[ 269.200019] RIP [<ffffffffc06e35a0>] mvs_task_prep_ata+0x80/0x3a0 [mv=
sas]   =20
[ 269.200534] RSP <ffff88020e837738>       =20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
With 4 drives (brown#4) attached to expander port 7C
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Kernel crash (from OCR-ed screenshot):
[ 38.934484] OS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 38.934501] CR2: 0000000000000254 CR3: 0000000001C12000 CR4: 000000000=
00407e0
[ 38.934522] Stack:
[ 38.934529]  ffff88021b214400 ffff880200000000 0000000000000282
0000000000000000
[ 38.934556]  ffff8300d4c03618 0000000000000046 ffff8300d5b01e38
ffffffff811b06ae
[ 38.934582]  ffff88021b214400 ffff88020d65el40 ffff8800d4c03618
ffff8800d4c00000
[ 38.934608] Call Trace:
[ 38.934619] [<ffffffff811b06ae>] ? dma_pool_alloc+0xce/0xl00
[ 38.934638] [<ffffffffc03c04ab>] mvs_task_prep+0x58b/0x620 [mvsas]
[ 38.934659] [<ffffffff810a29e6>] ? ttwu_do_activate.constprop.111+0x66=
/0x70
[ 38.934682] [<ffffffffc03c05a8>] mvs_task_exec.isra.14+0x68/0xf0 [mvsa=
s]
[ 38.934703] [<ffffffffc03cll49>] mvs_queue_command+0x39/0x40 [mvsas]
[ 38.934725] [<ffffffffc03a88ab>] sas_ata_qc_issue+0x28b/0x2d0 [libsas]
[ 38.934747] [<ffffffff8153102f>] ata_qc_issue+0xl8f/0x2d0
[ 38.934764] [<ffffffff81531468>] ata_exec_internal_sg+0x2f8/0x5d0
[ 38.934783] [<ffffffff315317b2>] ata_exec_internal+0x72/0xb0
[ 38.934802] [<ffffffff8153Ifaa>] ata_do_dev_read_id+0x2a/0x30
[ 38.934821] [<ffffffffc03a84b0>] ? sas_ata_internal_abort+0xl20/0xl20 =
[libsas]
[ 38.934843] [<ffffffff81532If5>] ata_dev_read_id+0x245/0x460
[ 38.934861] [<ffffffff3153e99c>] ? ata_eh_reset+0x24c/0xe20
[ 38.934878] [<ffffffff8153d8f8>] ata_eh_revalidate_and_attach+0xl98/0x=
3a0
[ 38.934899] [<ffffffff8153fd69>] ata_eh_recover+0x599/0x7e0
[ 38.934917] [<ffffffff81534200>] ? sata_print_link_status+0xc0/0xc0
[ 38.934937] [<ffffffffc03a84b0>] ? sas_ata_internal_abort+0xl20/0xl20 =
[libsas]
[ 38.934959] [<ffffffff81534750>] ? sata_std_hardreset+0x50/0x50
[ 38.934978] [<ffffffffc03a84b0>] ? sas_ata_internal_abort+0xl20/0xl20 =
[libsas]
[ 38.935618] [<ffffffff81534750>] ? sata_std_hardreset+0x50/0x50
[ 38.936257] [<ffffffffc03a84b0>] ? sas_ata_internal_abort+0xl20/0xl20 =
[libsas]
[ 38.936905] [<ffffffff31540742>] ata_do_eh+0x52/0xc0
[ 38.937538] [<ffffffff81534200>] ? sata_print_link_status+0xc0/0xc0
[ 38.938163] [<ffffffff815407f7>] ata_std_error_handler+0x47/0x80
[ 38.938783] [<ffffffff8153b8f8>] ? ata_eh_handle_port_resume+0x38/0xl6=
0
[ 38.939410] [<ffffffff8154041b>] ata_scsi_port_error_handler+0x39b/0x5=
a0
[ 38.940024] [<ffffffffc03a82c5>] async_sas_ata_eh+0x55/0x90 [libsas]
[ 38.940621] [<ffffffff8109a89b>] async_run_entry_fn+0x3b/0xl40
[ 38.941201] [<ffffffff8108c6ff>] process_one_work+0xl7f/0x4c0
[ 38.941767] [<ffffffff8108d46b>] worker_thread+0xllb/0x3f0
[ 38.942320] [<ffffffff8108d350>] ? create_and_start_worker+0x80/0x80
[ 38.942864] [<ffffffff81094479>] kthread+0xc9/0xe0
[ 38.943398] [<ffffffff810943b0>] ? flush_kthread_worker+0xb0/0xb0
[ 38.943927] [<ffffffff817910fc>] ret_from_fork+0x7c/0xb0
[ 38.944443] [<ffffffff810943b0>] ? flush_kthread_worker+0xb0/0xb0
[ 38.944956] Code: 00 00 48 8b 0c c8 0f 84 a7 02 00 00 44 89 c0 41 b9 0=
0 10 00
00 48 8d 34 80 48 8d 04 70 48 8d b4 c3 b8 55 02
00 8b 43 58 89 46 lc <8b> 89 54 02 00 00 44 89 c0 8b 7b 58 Od 00 00 00 =
70 4c 8b
53 48
[ 38.946132] RIP [<ffffffffc03bf5a0>] mvs_task_prep_ata+0x80/0x3a0 [mvs=
as]
38.9466881 RSP <ffff88020d7bb7c8>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
With 4 drives (brown#4) attached to expander port 8C
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Kernel crash (text from OCR-ed screenshot):
[ 335.117520] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 335.117537] CR2: 00007fff5S6452C0 CR3: 0000000001C12000 CR4: 00000000=
000407e0
[ 335.117557] Stack:
[ 335.117565] ffff88021b214400 ffff880200000000 0000000000000282
74737572745f7374
[ 335.117591] ffff8800d5b03618 0000000000000046 ffff88020f301e38
ffffffff311b06ae
[ 335.117617] ffff8802lb214400 ffff8800d4bda280 ffff8800d5b03618
ffff8800d5b00000
[ 335.117644] Call Trace:
[ 335.117656] [<ffffffff811b06ae>] ? dma_pool_alloc+0xce/0x100
[ 335.117676] [<ffffffffc03fb4ab>] mvs_task_prep+0x58b/0x620 [mvsas]
[ 335.117697] [<ffffffff310a29e6>] ? ttwu_do_activate.constprop.111+0x6=
6/0x70
[ 335.117720] [<ffffffffc03fb5a8>] mvs_task_exec.isra.14+0x68/0xf0 [mvs=
as]
[ 335.117741] [<ffffffffc03fcl49>] mvs_queue_command+0x39/0x40 [mvsas]
[ 335.117764] [<ffffffffc03e38ab>] sas_ata_qc_issue+0x28b/0x2d0 [libsas=
]
[ 335.117786] [<ffffffff8153102f>] ata_qc_issue+0xl8f/0x2d0
[ 335.117804] [<ffffffff81531468>] ata_exec_internal_sg+0x2f8/0x5d0
[ 335.117823] [<ffffffff815317b2>] ata_exec_internal+0x72/0xb0
[ 335.117842] [<ffffffff8153Ifaa>] ata_do_dev_read_id+0x2a/0x30
[ 335.117861] [<ffffffffc03e34b0>] ? sas_ata_internal_abort+0xl20/0xl20
[libsas]
[ 335.117883] [<ffffffff81532If5>] ata_dev_read_id+0x245/0x460
[ 335.117901] [<ffffffff8153e99c>] ? ata_eh_reset+0x24c/0xe20
[ 335.117919] [<ffffffff8153d8f8>] ata_eh_revalidate_and_attach+0xl98/0=
x3a0
[ 335.117940] [<ffffffff8153fd69>] ata_eh_recover+0x599/0x7e0
[ 335.117959] [<ffffffff31534200>] ? sata_print_link_status+0xc0/0xc0
[ 335.117979] [<ffffffffc03e34b0>] ? sas_ata_internal_abort+0xl20/0xl20
[libsas]
[ 335.118001] [<ffffffff81534750>] ? sata_std_hardreset+0x50/0x50
[ 335.118019] [<ffffffffc03e34b0>] ? sas_ata_internal_abort+0xl20/0xl20
[libsas]
[ 335.118041] [<ffffffff81534750>] ? sata_std_hardreset+0x50/0x50
[ 335.118061] [<ffffffffc03e34b0>] ? sas_ata_internal_abort+0xl20/0xl20
[libsas]
[ 335.118083] [<ffffffff81540742>] ata_do_eh+0x52/0xc0
[ 335.118709] [<ffffffff81534200>] ? sata_print_link_status+0xc0/0xc0
[ 335.119338] [<ffffffff815407f7>] ata_std_error_handler+0x47/0x80
[ 335.119970] [<ffffffff8153b8f8>] ? ata_eh_handle_port_resume+0x38/0xl=
60
[ 335.120600] [<ffffffff8154041b>] ata_scsi_port_error_handler+0x39b/0x=
5a0
[ 335.121215] [<ffffffffc03e32c5>] async_sas_ata_eh+0x55/0x90 [libsas]
[ 335.121812] [<ffffffff8109a89b>] async_run_entry_fn+0x3b/0xl40
[ 335.122394] [<ffffffff8108c6ff>] process_one_work+0xl7f/0x4c0
[ 335.122963] [<ffffffff81776ba3>] ? maybe_create_worker+0xbb/0xlc5
[ 335.123520] [<ffffffff8108d46b>] worker_thread+0xllb/0x3f0
[ 335.124064] [<ffffffff8108d350>] ? create_and_start_worker+0x80/0x80
[ 335.124605] [<ffffffff81094479>] kthread+0xc9/0xe0
[ 335.125133] [<ffffffff810943b0>] ? flush_kthread_worker+0xb0/0xb0
[ 335.125654] [<ffffffff8179l0fc>] ret_from_fork+0x7c/0xb0
[ 335.126169] [<ffffffff310943b0>] ? flush_kthread_worker+0xb0/0xb0
[ 335.126685] Code: 00 00 48 8b 0c C8 0f 84 a7 02 00 00 44 89 C0 41 b9 =
00 10 00
00 48 8d 34 80 48 8d 04 70 48 8d b4 c3 b8 55 02
00 8b 43 58 89 46 lc <8b> 89 54 02 00 00 44 89 C0 8b 7b 58 0d 00 00 00 =
70 4c 8b
53 48
[ 335.127858] RIP [<ffffffffc03fa5a0>] mvs_task_prep_ata+0x80/0x3a0 [mv=
sas]
[ 335.128415] RSP <ffff8800d60237c8>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
With 4 drives (brown#4) attached to expander port 9C
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
scsi 5:0:4:0: Failed to get diagnostic page 0x8000002
scsi 5:0:4:0: Failed to bind enclosure -19
# lsscsi
[4:0:0:0]    disk    ATA      OCZ-VERTEX       1.3   /dev/sda
[5:0:4:0]    enclosu HP       HP SAS EXP Card  2.08  -
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
With 4 drives (brown#4) attached to expander port 9C [a second time],
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Kernel crash (text from screen OCR):
[ 35.957789] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 35.957806] CR2: 00007f6c3faf8000 CR3: 0000000001c12000 CR4: 000000000=
00407f0
[ 35.957826] Stack:
[ 35.957833] ffff88021b314400 ffff880200000000 0000000000000282
eb3377d73948ca01
[ 35.957860] ffff88020ed037b0 0000000000000046 ffff88020ec01e38
ffffffff811b06ae
[ 35.957885] ffff88021b314400 ffff88020d66ddc0 ffff88020ed037b0
ffff88020ed00000
[ 35.957912] Call Trace:
[ 35.957924] [<ffffffff811b06ae>] ? dma_pool_alloc+0xce/0x100
[ 35.957944] [<ffffffffc05dl4ab>] mvs_task_prep+0x58b/0x620 [mvsas]
[ 35.957965] [<ffffffff810a29e6>] ? ttwu_do_activate.constprop.111+0x66=
/0x70
[ 35.957987] [<ffffffffc05dl5a8>] mvs_task_exec.isra.14+0x68/0xf0 [mvsa=
s]
[ 35.958008] [<ffffffffc05d2149>] mvs_queue_command+0x39/0x40 [mvsas]
[ 35.958030] [<ffffffffc05b98ab>] sas_ata_qc_issue+0x28b/0x2d0 [libsas]
[ 35.958052] [<ffffffff8153102f>] ata_qc_issue+0xl8f/0x2d0
[ 35.958069] [<ffffffff81531468>] ata_exec_internal_sg+0x2f8/0x5d0
[ 35.958089] [<ffffffff815317b2>] ata_exec_internal+0x72/0xb0
[ 35.958107] [<ffffffff81531faa>] ata_do_dev_read_id+0x2a/0x30
[ 35.958126] [<ffffffffc05b94b0>] ? sas_ata_internal_abort+0xl20/0xl20 =
[libsas]
[ 35.958148] [<ffffffff81532If5>] ata_dev_read_id+0x245/0x460
[ 35.958166] [<ffffffff8153e99c>] ? ata_eh_reset+0x24c/0xe20
[ 35.958185] [<ffffffff8153d8f8>] ata_eh_revalidate_and_attach+0xl98/0x=
3a0
[ 35.958205] [<ffffffff8153fd69>] ata_eh_recover+0x599/0x7e0
[ 35.958223] [<ffffffff81534200>] ? sata_print_link_status+0xc0/0xc0
[ 35.958243] [<ffffffffc05b94b0>] ? sas_ata_internal_abort+0xl20/0xl20 =
[libsas]
[ 35.958265] [<ffffffff81534750>] ? sata_std_hardreset+0x50/0x50
[ 35.958283] [<ffffffffc05b94b0>] ? sas_ata_internal_abort+0xl20/0xl20 =
[libsas]
[ 35.958305] [<ffffffff81534750>] ? sata_std_hardreset+0x50/0x50
[ 35.958324] [<ffffffffc05b94b0>] ? sas_ata_internal_abort+0xl20/0xl20 =
[libsas]
[ 35.958346] [<ffffffff81540742>] ata_do_eh+0x52/0xc0
[ 35.958971] [<ffffffff81534200>] ? sata_print_link_status+0xc0/0xc0
[ 35.959600] [<ffffffff815407f7>] ata_std_error_handler+0x47/0x80
[ 35.960231] [<ffffffff8153b8f8>] ? ata_eh_handle_port_resume+0x38/0xl6=
0
[ 35.960861] [<ffffffff8154041b>] ata_scsi_port_error_handler+0x39b/0x5=
a0
[ 35.961475] [<ffffffffc05b92c5>] async_sas_ata_eh+0x55/0x90 [libsas]
[ 35.962071] [<ffffffff8109a89b>] async_run_entry_fn+0x3b/0xl40
[ 35.962652] [<ffffffff8108c6ff>] process_one_work+0xl7f/0x4c0
[ 35.963218] [<ffffffff81776ba8>] ? maybe_create_worker+0xbb/0xlc5
[ 35.963775] [<ffffffff8108d46b>] worker_thread+0x11b/0x3f0
[ 35.964319] [<ffffffff8108d350>] ? create_and_start_worker+0x80/0x80
[ 35.964858] [<ffffffff81094479>] kthread+0xc9/0xe0
[ 35.965385] [<ffffffff810943b0>] ? flush_kthread_worker+0xb0/0xb0
[ 35.965904] [<ffffffff8179l0fc>] ret_from_fork+0x7c/0xb0
[ 35.966418] [<ffffffff810943b0>] ? fIush_kthread_worker+0xb0/0xb0
[ 35.966932] Code: 00 00 48 8b 0c c8 0f 84 a7 02 00 00 44 89 C0 41 b9 0=
0 10 00
00 48 8d 34 80 48 8d 04 70 48 8d b4 c3 b8 55 02
00 8b 43 58 89 46 lc <8b> 89 54 02 00 00 44 89 C0 8b 7b 58 0d 00 00 00 =
70 4c 8b
53 48
[ 35.968100] RIP [<ffffffffc05d05a0>] mvs_task_prep_ata+0x80/0x3a0 [mvs=
as]
[ 35.968656] RSP <ffff8800d4b077c8>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
# lspci -nn -s 01: -vv
01:00.0 RAID bus controller [0104]: Marvell Technology Group Ltd. 88SE9=
485
SAS/SATA 6Gb/s controller [1b4b:9485] (rev 03)
    Subsystem: Marvell Technology Group Ltd. Device [1b4b:9480]
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at f0540000 (64-bit, non-prefetchable) [size=3D128=
K]
    Region 2: Memory at f0500000 (64-bit, non-prefetchable) [size=3D256=
K]
    Expansion ROM at f0560000 [disabled] [size=3D64K]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2- AuxCurrent=3D375mA
PME(D0+,D1+,D2-,D3hot+,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
    Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [70] Express (v2) Endpoint, MSI 00
        DevCap:    MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <1us=
, L1
<8us
            ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupp=
orted-
            RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- Tra=
nsPend-
        LnkCap:    Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Exit La=
tency
L0s <512ns, L1 <64us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActi=
ve-
BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, =
OBFF Not
Supported
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, O=
BFF
Disabled
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range, EnterModifiedComp=
liance-
ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-=
,
EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualization=
Request-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- Rx=
OF-
MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- Rx=
OF-
MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- R=
xOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalEr=
r+
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalEr=
r+
        AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ Chk=
En-
    Capabilities: [140 v1] Virtual Channel
        Caps:    LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=3DFixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Dff
            Status:    NegoPending- InProgress-
    Kernel driver in use: mvsas
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

A Highpoint Rocket 2720SGL controller (also a Marvell 9485 based chip a=
s far as
I know) ran with identical SAS expander and disk drives and power suppl=
y
without errors/crashes using the Highpoint 4.0.0.1528N driver (mv94xx.k=
o) on
Debian 6.0.6/kernel 2.6.32-46.

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
