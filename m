From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101891] mvsas prep failed, NULL pointer dereference in
 mvs_slot_task_free+0x5/0x1f0 [mvsas]
Date: Fri, 24 Jul 2015 11:48:42 +0000
Message-ID: <bug-101891-11613-LWQO9RWu4n@https.bugzilla.kernel.org/>
References: <bug-101891-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51578 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbbGXLsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2015 07:48:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3224B20651
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2015 11:48:44 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 045A22064D
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2015 11:48:43 +0000 (UTC)
In-Reply-To: <bug-101891-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D101891

--- Comment #2 from D=C4=81vis <davispuh@gmail.com> ---
(In reply to D=C4=81vis from comment #0)
> Got this call trace, it caused any attempts to access those disks han=
g
> (couldn't even kill those processes, eg. ls).
> Using HighPoint RocketRAID 2760A controller.
>=20
> kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
> kernel: sas: Enter sas_scsi_recover_host busy: 1 failed: 1
> kernel: sas: trying to find task 0xffff880213ac6a00
> kernel: sas: sas_scsi_find_task: aborting task 0xffff880213ac6a00
> kernel: BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000010
> kernel: IP: [<ffffffffa020dfa5>] mvs_slot_task_free+0x5/0x1f0 [mvsas]
> kernel: PGD 1ee973067 PUD 1ee974067 PMD 0
> kernel: Oops: 0000 [#1] PREEMPT SMP
> kernel: Modules linked in: fuse nf_conntrack_netbios_ns
> nf_conntrack_broadcast xt_tcpudp ip6t_rpfilter ip
> kernel:  aesni_intel rc_core snd_hda_codec_realtek aes_x86_64 lrw gf1=
28mul
> videobuf2_dma_sg glue_helper a
> kernel: CPU: 3 PID: 227 Comm: scsi_eh_7 Tainted: P           O  =20
> 4.1.2-2-ARCH #1
> kernel: Hardware name: Gigabyte Technology Co., Ltd.
> GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
> kernel: task: ffff88007f849e90 ti: ffff880223184000 task.ti: ffff8802=
23184000
> kernel: RIP: 0010:[<ffffffffa020dfa5>]  [<ffffffffa020dfa5>]
> mvs_slot_task_free+0x5/0x1f0 [mvsas]
> kernel: RSP: 0018:ffff880223187d00  EFLAGS: 00010a13
> kernel: RAX: 2e8ba2e8ba2e8ba3 RBX: ffff880213ac6a00 RCX: a2e8bb8b9cb3=
907b
> kernel: RDX: 0000000000000000 RSI: ffff880213ac6a00 RDI: ffff88022244=
0000
> kernel: RBP: ffff880223187d58 R08: 000000000000000a R09: 000000000000=
0607
> kernel: R10: 00000000000213fc R11: 0000000000000607 R12: 000000000000=
0005
> kernel: R13: ffff880222a59000 R14: ffff880222440000 R15: ffff880213ac=
6a08
> kernel: FS:  00007fdddc839880(0000) GS:ffff88022ecc0000(0000)
> knlGS:0000000000000000
> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> kernel: CR2: 0000000000000010 CR3: 00000001ee978000 CR4: 000000000004=
07e0
> kernel: Stack:
> kernel:  ffffffffa0210bde ffff880200000018 ffff880223187d68 ffff88022=
3187d28
> kernel:  00000000a5257e12 ffff88007f840208 0000000000000005 ffff88022=
3187db0
> kernel:  ffff880213ac6a08 ffff8802230ef000 ffff880213ac6a00 ffff88022=
3187e28
> kernel: Call Trace:
> kernel:  [<ffffffffa0210bde>] ? mvs_abort_task+0x1ce/0x230 [mvsas]
> kernel:  [<ffffffffa0119eab>] sas_scsi_recover_host+0x47b/0xc20 [libs=
as]
> kernel:  [<ffffffffa0083afc>] scsi_error_handler+0xfc/0x580 [scsi_mod=
]
> kernel:  [<ffffffff81587212>] ? __schedule+0x362/0xa30
> kernel:  [<ffffffffa0083a00>] ? scsi_eh_get_sense+0x190/0x190 [scsi_m=
od]
> kernel:  [<ffffffff810977f8>] kthread+0xd8/0xf0
> kernel:  [<ffffffff81097720>] ? kthread_worker_fn+0x170/0x170
> kernel:  [<ffffffff8158b962>] ret_from_fork+0x42/0x70
> kernel:  [<ffffffff81097720>] ? kthread_worker_fn+0x170/0x170
> kernel: Code: 84 00 00 00 00 00 66 66 66 66 90 55 48 8b 87 b0 00 00 0=
0 89 f6
> 48 89 e5 f0 48 0f b3 30 5d c
> kernel: RIP  [<ffffffffa020dfa5>] mvs_slot_task_free+0x5/0x1f0 [mvsas=
]
> kernel:  RSP <ffff880223187d00>
> kernel: CR2: 0000000000000010
> kernel: ---[ end trace 18b7a6f928680374 ]---

It didn't used to happen before, but now today got it again. Seems it's=
 quite
reproducible as my usage was pretty similar, basically heavy I/O, rsync=
 and
compiling. Also seems there's no way to get disks back but just reboot =
as
removing kernel modules fail (not even with force).

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
