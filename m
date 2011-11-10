From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: segfault the use xen and multipath devices
Date: Thu, 10 Nov 2011 13:52:23 +0400
Message-ID: <CACaajQtfbG=qs5c3RKQUUQ4d5UhQ=mB6o78rQw7hBMpQ0WD8tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63018 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933957Ab1KJJwl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2011 04:52:41 -0500
Received: by wyh15 with SMTP id 15so2485074wyh.19
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2011 01:52:39 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello. I'm use xen-2.6.32.46 from jeremy linux tree
(http://git.kernel.org/?p=linux/kernel/git/jeremy/xen.git)

dm3, dm-4, dm-5 multipath devices inside it devices connected via SRP.
after i manualy shutdown srp devices, SRP see that and try to
reconnect after unsuccesseful connect, says: scsi host4: ib_srp:
reconnect failed (-22), removing target port.

messages like "I/O error, dev dm-5, sector 0 says that multipath try
to write on shutdown device.
after that scsi says: scsi 4:0:0:0: Device offlined - not ready after
error recovery
and in dmesg i see segfault: BUG: unable to handle kernel NULL pointer
dereference at 0000000000000038

afte that scsi doing offline second target: scsi 5:0:0:1: Device
offlined - not ready after error recovery

after that i see: invalid opcode: 0000 [#2] SMP

Does this messages says, that in kernel scsi subsystem not works fine
or they says about xen related problems?

Thanks for all suggestions.

dmesg log:

[239828.774879] device-mapper: multipath: Failing path 8:160.
[239829.810871] device-mapper: multipath: Failing path 8:176.
[239831.189426] scsi host4: ib_srp: failed send status 12
[239831.189489] scsi host4: ib_srp: failed send status 5
[239831.189542] scsi host5: ib_srp: failed send status 12
[239831.189596] scsi host4: ib_srp: failed send status 5
[239831.189648] scsi host5: ib_srp: failed send status 5
[239831.189704] scsi host4: ib_srp: failed send status 5
[239831.189759] scsi host5: ib_srp: failed send status 5
[239832.485855] scsi host4: SRP abort called
[239832.485912] scsi host4: SRP abort called
[239832.485960] scsi host4: SRP abort called
[239832.486008] scsi host4: SRP abort called
[239832.486063] scsi host4: SRP reset_device called
[239832.486114] scsi host4: SRP reset_device called
[239832.486164] scsi host4: SRP reset_device called
[239832.486229] scsi host4: ib_srp: SRP reset_host called state 0 qp_err 1
[239832.846957] device-mapper: multipath: Failing path 8:96.
[239832.850767] device-mapper: multipath: Failing path 8:112.
[239832.853760] end_request: I/O error, dev dm-4, sector 0
[239832.853822] Buffer I/O error on device dm-4, logical block 0
[239832.853889] end_request: I/O error, dev dm-4, sector 4
[239832.853944] Buffer I/O error on device dm-4, logical block 1
[239832.854008] Buffer I/O error on device dm-4, logical block 2
[239832.854068] Buffer I/O error on device dm-4, logical block 3
[239832.854072] end_request: I/O error, dev dm-4, sector 0
[239832.854076] Buffer I/O error on device dm-4, logical block 0
[239832.854081] Buffer I/O error on device dm-4, logical block 1
[239832.854186] end_request: I/O error, dev dm-4, sector 3515228760
[239832.854190] Buffer I/O error on device dm-4, logical block 878807190
[239832.854243] end_request: I/O error, dev dm-4, sector 3515228760
[239832.854246] Buffer I/O error on device dm-4, logical block 878807190
[239832.854315] end_request: I/O error, dev dm-4, sector 0
[239832.854319] Buffer I/O error on device dm-4, logical block 0
[239832.854327] Buffer I/O error on device dm-4, logical block 1
[239832.854486] end_request: I/O error, dev dm-4, sector 0
[239832.854728] device-mapper: multipath: Failing path 8:128.
[239832.854852] end_request: I/O error, dev dm-4, sector 24
[239832.858110] end_request: I/O error, dev dm-5, sector 0
[239832.858176] end_request: I/O error, dev dm-5, sector 4
[239832.858305] end_request: I/O error, dev dm-5, sector 0
[239832.858466] end_request: I/O error, dev dm-5, sector 3515228760
[239832.858573] end_request: I/O error, dev dm-5, sector 3515228760
[239832.858711] end_request: I/O error, dev dm-5, sector 0
[239832.858886] end_request: I/O error, dev dm-5, sector 0
[239832.859003] end_request: I/O error, dev dm-5, sector 24
[239832.903778] end_request: I/O error, dev dm-4, sector 0
[239832.903909] end_request: I/O error, dev dm-4, sector 3515228760
[239832.904027] end_request: I/O error, dev dm-4, sector 0
[239832.904173] end_request: I/O error, dev dm-4, sector 0
[239832.904289] end_request: I/O error, dev dm-4, sector 24
[239832.907028] end_request: I/O error, dev dm-5, sector 0
[239832.907165] end_request: I/O error, dev dm-5, sector 3515228760
[239832.907284] end_request: I/O error, dev dm-5, sector 0
[239832.907418] end_request: I/O error, dev dm-5, sector 0
[239832.907535] end_request: I/O error, dev dm-5, sector 24
[239834.401687] scsi host5: SRP abort called
[239834.401745] scsi host5: SRP abort called
[239834.401793] scsi host5: SRP abort called
[239834.401847] scsi host5: SRP reset_device called
[239834.401897] scsi host5: SRP reset_device called
[239834.401948] scsi host5: SRP reset_device called
[239834.402000] scsi host5: ib_srp: SRP reset_host called state 0
qp_err 1
[239834.870961] device-mapper: multipath: Failing path 8:144.
[239852.489918] scsi host4: SRP abort called
[239852.489974] scsi host4: SRP reset_device called
[239852.490026] scsi host4: ib_srp: SRP reset_host called state 0
qp_err 1
[239854.405903] scsi host5: SRP abort called
[239854.405961] scsi host5: SRP reset_device called
[239854.406013] scsi host5: ib_srp: SRP reset_host called state 0
qp_err 1
[239861.499864] scsi host4: ib_srp: Got failed path rec status -22
[239861.499980] scsi host4: ib_srp: Path record query failed
[239861.500037] scsi host4: ib_srp: reconnect failed (-22), removing
target port.
[239861.501259] scsi host5: ib_srp: Got failed path rec status -22
[239861.501324] scsi host5: ib_srp: Path record query failed
[239861.501380] scsi host5: ib_srp: reconnect failed (-22), removing
target port.
[239862.494015] scsi 4:0:0:0: Device offlined - not ready after error recovery
[239862.494111] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000038
[239862.494267] IP: [<ffffffff811781d0>] elv_requeue_request+0x42/0x6d
[239862.494334] PGD 0
[239862.494380] Oops: 0000 [#1] SMP
[239862.494435] last sysfs file:
/sys/devices/pci0000:00/0000:00:07.0/0000:04:00.0/host5/target5:0:0/5:0:0:2/block/sdl/uevent
[239862.494535] CPU 7
[239862.494580] Modules linked in: dm_ioband raid1 dm_round_robin
sd_mod crc_t10dif nls_utf8 cifs bonding ip6table_filter ip6_tables
iptable_filter ip_tables ebtable_nat ebtables x_tables xen_evtchn
xenfs dm_multipath dm_mod scsi_dh ib_sdp ib_srp scsi_transport_srp
scsi_tgt ib_ipoib ib_umad rdma_ucm rdma_cm ib_cm iw_cm ib_addr ib_sa
ib_uverbs mlx4_ib ib_mad ib_core md_mod ata_generic evdev snd_pcm
ata_piix snd_timer snd tpm_tis soundcore libata tpm snd_page_alloc
tpm_bios scsi_mod pcspkr serio_raw button processor acpi_processor
squashfs loop aufs(C) ide_generic ide_core mlx4_en uhci_hcd ehci_hcd
usbcore nls_base mlx4_core igb dca thermal thermal_sys
[239862.495433] Pid: 3957, comm: scsi_eh_4 Tainted: G         C
2.6.32-5-xen-amd64 #1 ProLiant DL170h G6
[239862.495527] RIP: e030:[<ffffffff811781d0>]  [<ffffffff811781d0>]
elv_requeue_request+0x42/0x6d
[239862.495623] RSP: e02b:ffff88010726bd30  EFLAGS: 00010002
[239862.495677] RAX: 0000000000000000 RBX: ffff8800b3f818f0 RCX:
ffff8800b3f81a10
[239862.495763] RDX: ffff8800b3f81a10 RSI: ffff8800b3f818f0 RDI:
ffff880107232340
[239862.495888] RBP: ffff880107232340 R08: ffff880107232340 R09:
0000000000000000
[239862.495975] R10: 0000160000000000 R11: ffff88010726bea0 R12:
ffff880107232340
[239862.496062] R13: ffff8801049ae200 R14: ffff88010726c000 R15:
ffff88010723f828
[239862.496153] FS:  00007fb7c1e357a0(0000) GS:ffff880028122000(0000)
knlGS:0000000000000000
[239862.496243] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[239862.496297] CR2: 0000000000000038 CR3: 000000011395e000 CR4:
0000000000002660
[239862.496384] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[239862.496471] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[239862.496558] Process scsi_eh_4 (pid: 3957, threadinfo
ffff88010726a000, task ffff880107260700)
[239862.496648] Stack:
[239862.496689]  0000000000000200 0000000000000200 0000000000001057
ffffffffa010ecc0
[239862.496760] <0> 0000000007232340 0000000000000000 ffff8800b3f818f0
ffff8801049ae200
[239862.496867] <0> 0000000000000000 ffff8800b3f818f0 0000000000080000
ffffffffa010f0d1
[239862.497008] Call Trace:
[239862.497061]  [<ffffffffa010ecc0>] ? __scsi_queue_insert+0xbe/0xe4 [scsi_mod]
[239862.497126]  [<ffffffffa010f0d1>] ? scsi_io_completion+0x3eb/0x3fa
[scsi_mod]
[239862.497219]  [<ffffffffa010bbac>] ?
scsi_eh_flush_done_q+0xe3/0x104 [scsi_mod]
[239862.497311]  [<ffffffffa010cdbf>] ? scsi_error_handler+0x3cb/0x5b5
[scsi_mod]
[239862.497404]  [<ffffffffa010c9f4>] ? scsi_error_handler+0x0/0x5b5 [scsi_mod]
[239862.497466]  [<ffffffff81065c71>] ? kthread+0x79/0x81
[239862.497522]  [<ffffffff81012baa>] ? child_rip+0xa/0x20
[239862.497577]  [<ffffffff81011d61>] ? int_ret_from_sys_call+0x7/0x1b
[239862.497634]  [<ffffffff8101251d>] ? retint_restore_args+0x5/0x6
[239862.497692]  [<ffffffff8100ef4f>] ? xen_restore_fl_direct_end+0x0/0x1
[239862.497750]  [<ffffffff81012ba0>] ? child_rip+0x0/0x20
[239862.497802] Code: 01 74 04 a8 10 74 35 25 01 00 04 00 ff c8 0f 95
c0 83 e0 01 48 05 ec 00 00 00 ff 4c 85 04 f6 43 48 20 74 18 48 8b 45
18 48 8b 00 <48> 8b 40 38 48 85 c0 74 08 48 89 de 48 89 ef ff d0 81 63
48 ff
[239862.498351] RIP  [<ffffffff811781d0>] elv_requeue_request+0x42/0x6d
[239862.498412]  RSP <ffff88010726bd30>
[239862.498459] CR2: 0000000000000038
[239862.498880] ---[ end trace 80ef0ddbabc31003 ]---
[239864.410004] scsi 5:0:0:1: Device offlined - not ready after error recovery
[239864.410151] invalid opcode: 0000 [#2] SMP
[239864.418643] last sysfs file:
/sys/devices/pci0000:00/0000:00:07.0/0000:04:00.0/host5/target5:0:0/5:0:0:2/block/sdl/uevent
[239864.418798] CPU 8
[239864.418937] Modules linked in: dm_ioband raid1 dm_round_robin
sd_mod crc_t10dif nls_utf8 cifs bonding ip6table_filter ip6_tables
iptable_filter ip_tables ebtable_nat ebtables x_tables xen_evtchn
xenfs dm_multipath dm_mod scsi_dh ib_sdp ib_srp scsi_transport_srp
scsi_tgt ib_ipoib ib_umad rdma_ucm rdma_cm ib_cm iw_cm ib_addr ib_sa
ib_uverbs mlx4_ib ib_mad ib_core md_mod ata_generic evdev snd_pcm
ata_piix snd_timer snd tpm_tis soundcore libata tpm snd_page_alloc
tpm_bios scsi_mod pcspkr serio_raw button processor acpi_processor
squashfs loop aufs(C) ide_generic ide_core mlx4_en uhci_hcd ehci_hcd
usbcore nls_base mlx4_core igb dca thermal thermal_sys
[239864.423151] Pid: 3975, comm: scsi_eh_5 Tainted: G      D  C
2.6.32-5-xen-amd64 #1 ProLiant DL170h G6
[239864.423290] RIP: e030:[<ffffffff8147b5b5>]  [<ffffffff8147b5b5>]
0xffffffff8147b5b5
[239864.423481] RSP: e02b:ffff88010718fd28  EFLAGS: 00010086
[239864.423580] RAX: ffffffff8147b590 RBX: ffff8800b3f80a80 RCX:
ffff8800b3f847a0
[239864.423820] RDX: ffff8800b3f80ba0 RSI: ffff8800b3f80a80 RDI:
ffff880107234680
[239864.423955] RBP: ffff880107234680 R08: ffff880107234680 R09:
0000000000000000
[239864.424088] R10: 0000160000000000 R11: ffff88010718fea0 R12:
ffff880107234680
[239864.424220] R13: ffff8801049aef00 R14: ffff880107338000 R15:
ffff88010723d028
[239864.424357] FS:  00007fcd364b9700(0000) GS:ffff880028140000(0000)
knlGS:0000000000000000
[239864.424493] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[239864.424594] CR2: 00007fb7c2cf7e30 CR3: 00000000b60ef000 CR4:
0000000000002660
[239864.424727] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[239864.424860] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[239864.424994] Process scsi_eh_5 (pid: 3975, threadinfo
ffff88010718e000, task ffff880107260e00)
[239864.425131] Stack:
[239864.425218]  ffffffff811781e1 0000000000000200 0000000000000200
0000000000001057
[239864.425480] <0> ffffffffa010ecc0 0000000007234680 0000000000000000
ffff8800b3f80a80
[239864.425875] <0> ffff8801049aef00 0000000000000000 ffff8800b3f80a80
0000000000080000
[239864.426374] Call Trace:
[239864.426470]  [<ffffffff811781e1>] ? elv_requeue_request+0x53/0x6d
[239864.426581]  [<ffffffffa010ecc0>] ? __scsi_queue_insert+0xbe/0xe4 [scsi_mod]
[239864.426693]  [<ffffffffa010f0d1>] ? scsi_io_completion+0x3eb/0x3fa
[scsi_mod]
[239864.426832]  [<ffffffffa010bbac>] ?
scsi_eh_flush_done_q+0xe3/0x104 [scsi_mod]
[239864.426971]  [<ffffffffa010cdbf>] ? scsi_error_handler+0x3cb/0x5b5
[scsi_mod]
[239864.427110]  [<ffffffffa010c9f4>] ? scsi_error_handler+0x0/0x5b5 [scsi_mod]
[239864.427220]  [<ffffffff81065c71>] ? kthread+0x79/0x81
[239864.427322]  [<ffffffff81012baa>] ? child_rip+0xa/0x20
[239864.427422]  [<ffffffff81011d61>] ? int_ret_from_sys_call+0x7/0x1b
[239864.427526]  [<ffffffff8101251d>] ? retint_restore_args+0x5/0x6
[239864.427630]  [<ffffffff8100ef4f>] ? xen_restore_fl_direct_end+0x0/0x1
[239864.427735]  [<ffffffff81012ba0>] ? child_rip+0x0/0x20
[239864.427833] Code: 47 81 ff ff ff ff e9 77 17 81 ff ff ff ff b0 b5
47 81 ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 93
78 17 81 ff <ff> ff ff 23 78 17 81 ff ff ff ff 00 00 00 00 00 00 00 00
08 7d
[239864.431489] RIP  [<ffffffff8147b5b5>] 0xffffffff8147b5b5
[239864.431643]  RSP <ffff88010718fd28>
[239864.431738] ---[ end trace 80ef0ddbabc31004 ]---

-- 
Vasiliy Tolstov,
Clodo.ru
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
