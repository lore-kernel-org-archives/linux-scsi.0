From: Shyam Kaushik <shyam@zadarastorage.com>
Subject: [Linux Megaraid SAS driver] bug report - megasas_aen_polling results
 in crash
Date: Mon, 30 Sep 2013 14:02:38 +0530
Message-ID: <3154115701819a18cac1bda05a6377b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:46834 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3I3Icl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2013 04:32:41 -0400
Received: by mail-ob0-f169.google.com with SMTP id wp4so4804162obc.14
        for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2013 01:32:41 -0700 (PDT)
References: 137472f34dfc10a004480f0e41039a7a@mail.gmail.com
In-Reply-To: 137472f34dfc10a004480f0e41039a7a@mail.gmail.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi Folks,

We are using Ubuntu linux kernel 3.2.0-29-generic & upon creating a
MegaRAID VD, we constantly run into the following OOPs

<1>[5277177.633716] BUG: unable to handle kernel NULL pointer dereferen=
ce
at=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (null)
<1>[5277177.665305] IP: [<ffffffff8141fcc2>] scsi_device_put+0x22/0x60
<4>[5277177.696626] PGD 3a7a2a067 PUD 3dba5d067 PMD 0
<0>[5277177.729987] Oops: 0000 [#1] SMP
<4>[5277177.760142] CPU 1
<4>[5277177.760192]
<4>[5277177.760195] Pid: 25707, comm: kworker/1:2 Tainted: G=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 O
3.2.0-29-generic #46-Ubuntu Dell Inc. PowerEdge R510/0DPRKF
<4>[5277177.760200] RIP: 0010:[<ffffffff8141fcc2>]=A0 [<ffffffff8141fcc=
2>]
scsi_device_put+0x22/0x60
<4>[5277177.760205] RSP: 0018:ffff8805461dbd90=A0 EFLAGS: 00010286
<4>[5277177.760207] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
00000001820000fc
<4>[5277177.760210] RDX: 00000001820000fd RSI: ffffea00072c2b00 RDI:
ffff8802596cd000
<4>[5277177.760212] RBP: ffff8805461dbda0 R08: 0000000000000001 R09:
0000000000000000
<4>[5277177.760215] R10: 0000000000000020 R11: dead000000100100 R12:
ffff8802596cd000
<4>[5277177.760219] R13: ffff8806193a1000 R14: 0000000000000002 R15:
0000000000000002
<4>[5277177.760222] FS:=A0 0000000000000000(0000) GS:ffff880323c00000(0=
000)
knlGS:0000000000000000
<4>[5277177.760225] CS:=A0 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
<4>[5277177.760227] CR2: 0000000000000000 CR3: 00000005b26c4000 CR4:
00000000000026e0
<4>[5277177.760230] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
<4>[5277177.760232] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
<4>[5277177.760235] Process kworker/1:2 (pid: 25707, threadinfo
ffff8805461da000, task ffff880291f9ae00)
<0>[5277177.760237] Stack:
<4>[5277177.760238]=A0 0000000000000000 ffff8806193a1690 ffff8805461dbe=
00
ffffffffa003e610
<4>[5277177.760245]=A0 ffff8805461dbde0 ffff8802596cd000 ffff8805744d70=
00
0000000000000000
<4>[5277177.760249]=A0 ffff880610b3f000 ffff8805744d7000 ffff8806176592=
80
ffff880323c17300
<0>[5277177.760254] Call Trace:
<4>[5277177.760264]=A0 [<ffffffffa003e610>] megasas_aen_polling+0x1d0/0=
x520
[megaraid_sas]
<4>[5277177.760272]=A0 [<ffffffffa003e440>] ?
megasas_get_ld_list+0x380/0x380 [megaraid_sas]
<4>[5277177.760279]=A0 [<ffffffff810849ea>] process_one_work+0x11a/0x48=
0
<4>[5277177.760284]=A0 [<ffffffff81085794>] worker_thread+0x164/0x370
<4>[5277177.760288]=A0 [<ffffffff81085630>] ?
manage_workers.isra.29+0x130/0x130
<4>[5277177.760293]=A0 [<ffffffff81089fbc>] kthread+0x8c/0xa0
<4>[5277177.760299]=A0 [<ffffffff81664034>] kernel_thread_helper+0x4/0x=
10
<4>[5277177.760303]=A0 [<ffffffff81089f30>] ? flush_kthread_worker+0xa0=
/0xa0
<4>[5277177.760306]=A0 [<ffffffff81664030>] ? gs_change+0x13/0x13
<0>[5277177.760308] Code: 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 =
ec
10 48 89 5d f0 4c 89 65 f8 66 66 66 66 90 48 8b 07 49 89 fc 48 8b 80 b8=
 00
00 00 <48> 8b 18 48 85 db 74 0c 48 89 df e8 2e 42 c8 ff 85 c0 75 1a 49
<1>[5277177.760332] RIP=A0 [<ffffffff8141fcc2>] scsi_device_put+0x22/0x=
60
<4>[5277177.760337]=A0 RSP <ffff8805461dbd90>
<0>[5277177.760338] CR2: 0000000000000000

I realize that this issue was already reported at
http://permalink.gmane.org/gmane.linux.raid/43146

I checked the latest kernel & don=92t see any fixtures in this area. Ca=
n you
pls advise on how to fix this issue?

Thanks.

PS: I am not subscribed to linux-scsi mailing list. So, please CC me in
the reply. Any help appreciated. Thanks.
--Shyam
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
