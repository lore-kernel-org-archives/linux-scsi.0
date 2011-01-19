From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH] [SCSI] megaraid_sas: Sanity check user supplied length before passing it to dma_alloc_coherent()
Date: Wed, 19 Jan 2011 07:33:56 +0100
Message-ID: <87tyh52yi3.fsf@nemi.mork.no>
References: <1289498526-22589-1-git-send-email-bjorn@mork.no>
	<1291387026-23262-1-git-send-email-bjorn@mork.no>
	<8739op51hr.fsf@nemi.mork.no>
	<4B6A08C587958942AA3002690DD4F8C30106FA7846@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:60847 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1ASGwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2011 01:52:20 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106FA7846@cosmail02.lsi.com>
	(Bo Yang's message of "Tue, 18 Jan 2011 19:07:59 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>

"Yang, Bo" <Bo.Yang@lsi.com> writes:

> If you are using megasas ioctl routine to develop your owner
> application, the best way you may need to contact with LSI for the
> tech support.

???

Thanks for answering, but I'm afraid I don't understand.  You don't fix
bugs in the driver because you don't support the application used to
trigger it?

The application in question is smartctl which is part of
http://smartmontools.sourceforge.net and AFAIK included with most (all?=
)
Linux distributions.  The action required to trigger the driver bug is
attempting to initiate a SMART device self test.


Quoting from the Debian bug report http://bugs.debian.org/604627 :

 calling 'smartctl -d megaraid,0 /dev/sda -t short' gives:

 smartctl 5.40 2010-07-12 r3124 [x86_64-unknown-linux-gnu] (local build=
)
 Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge=
=2Enet
 Short offline self test failed [Cannot allocate memory]
 megasas: Failed to alloc kernel SGL buffer for IOCTL


Another user reported the same issue on the linux-ide list:
http://marc.info/?l=3Dlinux-ide&m=3D128941801715301
with the following backtrace:

[   69.162393] ------------[ cut here ]------------
[   69.162404] WARNING: at /build/buildd/linux-2.6.32/mm/page_alloc.c:1=
806 \
__alloc_pages_slowpath+0x43b/0x580() [   69.162407] Hardware name: X8DT=
N
[   69.162409] Modules linked in: fbcon tileblit font bitblit softcurso=
r vga16fb \
vgastate ioatdma radeon ttm drm_kms_helper shpchp drm i2c_algo_bit lp p=
arport floppy \
pata_jmicron megaraid_sas igb dca [   69.162429] Pid: 1206, comm: smart=
ctl Not \
tainted 2.6.32-25-server #45-Ubuntu [   69.162432] Call Trace:
[   69.162439]  [<ffffffff81065f3b>] warn_slowpath_common+0x7b/0xc0
[   69.162443]  [<ffffffff81065f94>] warn_slowpath_null+0x14/0x20
[   69.162447]  [<ffffffff810f98fb>] __alloc_pages_slowpath+0x43b/0x580
[   69.162454]  [<ffffffff8101078c>] ? __switch_to+0x1ac/0x320
[   69.162459]  [<ffffffff81057850>] ? finish_task_switch+0x50/0xe0
[   69.162463]  [<ffffffff810f9bb1>] __alloc_pages_nodemask+0x171/0x180
[   69.162468]  [<ffffffff81017536>] dma_generic_alloc_coherent+0xa6/0x=
160
[   69.162475]  [<ffffffff81038b01>] x86_swiotlb_alloc_coherent+0x31/0x=
70
[   69.162482]  [<ffffffffa002d0ce>] megasas_mgmt_fw_ioctl+0x1ae/0x690 =
[megaraid_sas]
[   69.162488]  [<ffffffffa002d748>] megasas_mgmt_ioctl_fw+0x198/0x240 =
[megaraid_sas]
[   69.162494]  [<ffffffffa002f695>] megasas_mgmt_ioctl+0x35/0x50 [mega=
raid_sas]
[   69.162500]  [<ffffffff81153b12>] vfs_ioctl+0x22/0xa0
[   69.162505]  [<ffffffff8115da2a>] ? alloc_fd+0x10a/0x150
[   69.162509]  [<ffffffff81153cb1>] do_vfs_ioctl+0x81/0x410
[   69.162515]  [<ffffffff8155cc13>] ? do_page_fault+0x153/0x3b0
[   69.162518]  [<ffffffff811540c1>] sys_ioctl+0x81/0xa0
[   69.162523]  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b
[   69.162526] ---[ end trace 6a2181b634e2abc6 ]---
[   69.162538] ------------[ cut here ]------------
[   69.162806] kernel BUG at /build/buildd/linux-2.6.32/lib/swiotlb.c:3=
68!
[   69.163134] invalid opcode: 0000 [#1] SMP
[   69.163570] last sysfs file: \
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map [   69.163975]=
 CPU 0
[   69.164227] Modules linked in: fbcon tileblit font bitblit softcurso=
r vga16fb \
vgastate ioatdma radeon ttm drm_kms_helper shpchp drm i2c_algo_bit lp p=
arport floppy \
pata_jmicron megaraid_sas igb dca [   69.167419] Pid: 1206, comm: smart=
ctl Tainted: G \
W  2.6.32-25-server #45-Ubuntu X8DTN [   69.167843] RIP: 0010:[<fffffff=
f812c4dc5>]  \
[<ffffffff812c4dc5>] map_single+0x255/0x260 [   69.168370] RSP: 0018:ff=
ff88081c0ebc58 \
EFLAGS: 00010246 [   69.168655] RAX: 000000000003bffc RBX: 00000000ffff=
ffff RCX: \
0000000000000002 [   69.169000] RDX: 0000000000000000 RSI: 000000000000=
0000 RDI: \
ffff88001dffe000 [   69.169346] RBP: ffff88081c0ebcb8 R08: 000000000000=
0000 R09: \
ffff880000030840 [   69.169691] R10: 0000000000100000 R11: 000000000000=
0000 R12: \
0000000000000000 [   69.170036] R13: 00000000ffffffff R14: 000000000000=
0001 R15: \
0000000000200000 [   69.170382] FS:  00007fb8de189720(0000) GS:ffff8800=
1de00000(0000) \
knlGS:0000000000000000 [   69.170794] CS:  0010 DS: 0000 ES: 0000 CR0: =
\
0000000080050033 [   69.171094] CR2: 00007fb8dd59237c CR3: 000000081a79=
0000 CR4: \
00000000000006f0 [   69.171439] DR0: 0000000000000000 DR1: 000000000000=
0000 DR2: \
0000000000000000 [   69.171784] DR3: 0000000000000000 DR6: 00000000ffff=
0ff0 DR7: \
0000000000000400 [   69.172130] Process smartctl (pid: 1206, threadinfo=
 \
ffff88081c0ea000, task ffff88081a760000) [   69.194513] Stack:
[   69.205788]  0000000000000034 00000002817e3390 0000000000000000 ffff=
88081c0ebe00
[   69.217739] <0> 0000000000000000 000000000003bffc 0000000000000000 \
0000000000000000 [   69.241250] <0> 0000000000000000 00000000ffffffff \
ffff88081c5b4080 ffff88081c0ebe00 [   69.277310] Call Trace:
[   69.289278]  [<ffffffff812c52ac>] swiotlb_alloc_coherent+0xec/0x130
[   69.301118]  [<ffffffff81038b31>] x86_swiotlb_alloc_coherent+0x61/0x=
70
[   69.313045]  [<ffffffffa002d0ce>] megasas_mgmt_fw_ioctl+0x1ae/0x690 =
[megaraid_sas]
[   69.336399]  [<ffffffffa002d748>] megasas_mgmt_ioctl_fw+0x198/0x240 =
[megaraid_sas]
[   69.359346]  [<ffffffffa002f695>] megasas_mgmt_ioctl+0x35/0x50 [mega=
raid_sas]
[   69.370902]  [<ffffffff81153b12>] vfs_ioctl+0x22/0xa0
[   69.382322]  [<ffffffff8115da2a>] ? alloc_fd+0x10a/0x150
[   69.393622]  [<ffffffff81153cb1>] do_vfs_ioctl+0x81/0x410
[   69.404696]  [<ffffffff8155cc13>] ? do_page_fault+0x153/0x3b0
[   69.415761]  [<ffffffff811540c1>] sys_ioctl+0x81/0xa0
[   69.426640]  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b
[   69.437491] Code: fe ff ff 48 8b 3d 74 38 76 00 41 bf 00 00 20 00 e8=
 51 f5 d7 ff \
83 e0 ff 48 05 ff 07 00 00 48 c1 e8 0b 48 89 45 c8 e9 13 fe ff ff <0f> =
0b eb fe 0f 1f \
80 00 00 00 00 55 48 89 e5 48 83 ec 20 4c 89 [   69.478216] RIP  [<ffff=
ffff812c4dc5>] \
map_single+0x255/0x260 [   69.489668]  RSP <ffff88081c0ebc58>
[   69.500975] ---[ end trace 6a2181b634e2abc7 ]---


Both users have confirmed that the patch fixes their problem. One could
of course imagine a workaround in the smartctl application so that it
never sent requests with a zero iov_len, but I still believe that
actually fixing the driver to handle such requests is better.

No?




Bj=C3=B8rn
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
