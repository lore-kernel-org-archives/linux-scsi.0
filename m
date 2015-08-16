From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101891] mvsas prep failed, NULL pointer dereference in
 mvs_slot_task_free+0x5/0x1f0 [mvsas]
Date: Sun, 16 Aug 2015 22:14:00 +0000
Message-ID: <bug-101891-11613-meD8jUxaYT@https.bugzilla.kernel.org/>
References: <bug-101891-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48724 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbbHPWOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Aug 2015 18:14:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6513C20582
	for <linux-scsi@vger.kernel.org>; Sun, 16 Aug 2015 22:14:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8C12D204E0
	for <linux-scsi@vger.kernel.org>; Sun, 16 Aug 2015 22:14:00 +0000 (UTC)
In-Reply-To: <bug-101891-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D101891

--- Comment #3 from D=C4=81vis <davispuh@gmail.com> ---
I narrowed it down to this section of mvs_abort_task function
(drivers/scsi/mvsas/mv_sas.c)

    } else if (task->task_proto & SAS_PROTOCOL_SATA ||
        task->task_proto & SAS_PROTOCOL_STP) {
        if (SAS_SATA_DEV =3D=3D dev->dev_type) {
            struct mvs_slot_info *slot =3D task->lldd_task;
            u32 slot_idx =3D (u32)(slot - mvi->slot_info);
            mv_dprintk("mvs_abort_task() mvi=3D%p task=3D%p "
                   "slot=3D%p slot_idx=3Dx%x\n",
                   mvi, task, slot, slot_idx);
            task->task_state_flags |=3D SAS_TASK_STATE_ABORTED;
            mvs_slot_task_free(mvi, task, slot, slot_idx);
            rc =3D TMF_RESP_FUNC_COMPLETE;
            goto out;
        }

    }


Basically this line "u32 slot_idx =3D (u32)(slot - mvi->slot_info)".
I think (slot - mvi->slot_info) returns 0x10 and that's why
(there's no "mvs_abort_task()" in journal so it crashes before that.

kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: sas: Enter sas_scsi_recover_host busy: 1 failed: 1
kernel: sas: trying to find task 0xffff8801fff87500
kernel: sas: sas_scsi_find_task: aborting task 0xffff8801fff87500
kernel: BUG: unable to handle kernel NULL pointer dereference at
0000000000000010
kernel: IP: [<ffffffffa017afa5>] mvs_slot_task_free+0x5/0x1f0 [mvsas]
kernel: PGD 0=20
kernel: Oops: 0000 [#1] PREEMPT SMP=20
kernel: Modules linked in: nls_iso8859_4 nls_cp775 vfat fat fuse nvidia=
(PO)
xt_CHECKSUM ipt_MASQUERADE nf_nat_masq
kernel:  serio_raw pcspkr fam15h_power snd_hda_codec_realtek snd_hda_co=
dec_hdmi
snd_hda_codec_generic snd_hda_inte
kernel:=20
kernel: CPU: 3 PID: 222 Comm: scsi_eh_7 Tainted: P           O  =20
4.1.5-ARCH-dirty #2
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: task: ffff880222718000 ti: ffff88007fc9c000 task.ti: ffff88007f=
c9c000
kernel: RIP: 0010:[<ffffffffa017afa5>]  [<ffffffffa017afa5>]
mvs_slot_task_free+0x5/0x1f0 [mvsas]
kernel: RSP: 0018:ffff88007fc9fd00  EFLAGS: 00010a13
kernel: RAX: 2e8ba2e8ba2e8ba3 RBX: ffff8801fff87500 RCX: 45d175ba2d1810=
7b
kernel: RDX: 0000000000000000 RSI: ffff8801fff87500 RDI: ffff88007fb800=
00
kernel: RBP: ffff88007fc9fd58 R08: 000000000000000a R09: 00000000000006=
0d
kernel: R10: 0000000000020cd8 R11: 000000000000060d R12: ffff88007fb836=
a0
kernel: R13: ffff8800ce394e00 R14: ffff88007fb80000 R15: ffff8801fff875=
08
kernel: FS:  00007f0720ffe700(0000) GS:ffff88022ecc0000(0000)
knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
kernel: CR2: 0000000000000010 CR3: 0000000224182000 CR4: 00000000000406=
e0
kernel: Stack:
kernel:  ffffffffa017dce2 ffff880000000018 ffff88007fc9fd68 ffff88007fc=
9fd28
kernel:  0000000020e55177 ffff88022536f208 0000000000000005 ffff88007fc=
9fdb0
kernel:  ffff8801fff87508 ffff8800ce321000 ffff8801fff87500 ffff88007fc=
9fe28
kernel: Call Trace:
kernel:  [<ffffffffa017dce2>] ? mvs_abort_task+0x272/0x2b0 [mvsas]
kernel:  [<ffffffffa030aeab>] sas_scsi_recover_host+0x47b/0xc20 [libsas=
]
kernel:  [<ffffffffa00dfb0c>] scsi_error_handler+0xfc/0x580 [scsi_mod]
kernel:  [<ffffffff81588152>] ? __schedule+0x372/0xa30
kernel:  [<ffffffffa00dfa10>] ? scsi_eh_get_sense+0x190/0x190 [scsi_mod=
]
kernel:  [<ffffffff81097818>] kthread+0xd8/0xf0
kernel:  [<ffffffff81097740>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8158c8a2>] ret_from_fork+0x42/0x70
kernel:  [<ffffffff81097740>] ? kthread_worker_fn+0x170/0x170
Code: 84 00 00 00 00 00 66 66 66 66 90 55 48 8b 87 b0 00 00 00 89 f6 48=
 89 e5
f0 48 0f b3 30 5d c3 0f 1f
80 00 00 00 00 66 66 66 66 90 <48> 83 7a 10 00 0f 84 60 01 00 00 55 48
kernel: Code: 84 00 00 00 00 00 66 66 66 66 90 55 48 8b 87 b0 00 00 00 =
89 f6 48
89 e5 f0 48 0f b3 30 5d c3 0f 1f 8
kernel: RIP  [<ffffffffa017afa5>] mvs_slot_task_free+0x5/0x1f0 [mvsas]
kernel:  RSP <ffff88007fc9fd00>
kernel: CR2: 0000000000000010
kernel: ---[ end trace 93debf717bb54039 ]---

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
