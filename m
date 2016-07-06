From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] qla2xxx: Fix NULL pointer deref in QLA interrupt
Date: Wed, 6 Jul 2016 09:28:39 +0200
Message-ID: <20160706072839.xeoobuabvqdb2uor@c203.arch.suse.de>
References: <20160630170032.6dbaf496@pluto.restena.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbcGFH2p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jul 2016 03:28:45 -0400
Content-Disposition: inline
In-Reply-To: <20160630170032.6dbaf496@pluto.restena.lu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jun 30, 2016 at 05:00:32PM +0200, Bruno Pr=E9mont wrote:
> In qla24xx_process_response_queue() rsp->msix->cpuid may trigger NULL
> pointer dereference when rsp->msix is NULL:
>=20
> [    5.622457] NULL pointer dereference at 0000000000000050
> [    5.622457] IP: [<ffffffff8155e614>] qla24xx_process_response_queu=
e+0x44/0x4b0
> [    5.622457] PGD 0
> [    5.622457] Oops: 0000 [#1] SMP
> [    5.622457] Modules linked in:
> [    5.622457] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 4.6.3-x86_64=
 #1
> [    5.622457] Hardware name: HP ProLiant DL360 G5, BIOS P58 05/02/20=
11
> [    5.622457] task: ffff8801a88f3740 ti: ffff8801a8954000 task.ti: f=
fff8801a8954000
> [    5.622457] RIP: 0010:[<ffffffff8155e614>]  [<ffffffff8155e614>] q=
la24xx_process_response_queue+0x44/0x4b0
> [    5.622457] RSP: 0000:ffff8801afb03de8  EFLAGS: 00010002
> [    5.622457] RAX: 0000000000000000 RBX: 0000000000000032 RCX: 00000=
000ffffffff
> [    5.622457] RDX: 0000000000000002 RSI: ffff8801a79bf8c8 RDI: ffff8=
800c8f7e7c0
> [    5.622457] RBP: ffff8801afb03e68 R08: 0000000000000000 R09: 00000=
00000000000
> [    5.622457] R10: 00000000ffff8c47 R11: 0000000000000002 R12: ffff8=
801a79bf8c8
> [    5.622457] R13: ffff8800c8f7e7c0 R14: ffff8800c8f60000 R15: 00000=
00000018013
> [    5.622457] FS:  0000000000000000(0000) GS:ffff8801afb00000(0000) =
knlGS:0000000000000000
> [    5.622457] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    5.622457] CR2: 0000000000000050 CR3: 0000000001e07000 CR4: 00000=
000000006e0
> [    5.622457] Stack:
> [    5.622457]  ffff8801afb03e30 ffffffff810c0f2d 0000000000000086 00=
00000000000002
> [    5.622457]  ffff8801afb03e28 ffffffff816570e1 ffff8800c8994628 00=
00000000000002
> [    5.622457]  ffff8801afb03e60 ffffffff816772d4 b47c472ad6955e68 00=
00000000000032
> [    5.622457] Call Trace:
> [    5.622457]  <IRQ>
> [    5.622457]  [<ffffffff810c0f2d>] ? __wake_up_common+0x4d/0x80
> [    5.622457]  [<ffffffff816570e1>] ? usb_hcd_resume_root_hub+0x51/0=
x60
> [    5.622457]  [<ffffffff816772d4>] ? uhci_hub_status_data+0x64/0x24=
0
> [    5.622457]  [<ffffffff81560d00>] qla24xx_intr_handler+0xf0/0x2e0
> [    5.622457]  [<ffffffff810d569e>] ? get_next_timer_interrupt+0xce/=
0x200
> [    5.622457]  [<ffffffff810c89b4>] handle_irq_event_percpu+0x64/0x1=
00
> [    5.622457]  [<ffffffff810c8a77>] handle_irq_event+0x27/0x50
> [    5.622457]  [<ffffffff810cb965>] handle_edge_irq+0x65/0x140
> [    5.622457]  [<ffffffff8101a498>] handle_irq+0x18/0x30
> [    5.622457]  [<ffffffff8101a276>] do_IRQ+0x46/0xd0
> [    5.622457]  [<ffffffff817f8fff>] common_interrupt+0x7f/0x7f
> [    5.622457]  <EOI>
> [    5.622457]  [<ffffffff81020d38>] ? mwait_idle+0x68/0x80
> [    5.622457]  [<ffffffff8102114a>] arch_cpu_idle+0xa/0x10
> [    5.622457]  [<ffffffff810c1b97>] default_idle_call+0x27/0x30
> [    5.622457]  [<ffffffff810c1d3b>] cpu_startup_entry+0x19b/0x230
> [    5.622457]  [<ffffffff810324c6>] start_secondary+0x136/0x140
> [    5.622457] Code: 00 00 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 =
c0 48 8b 47 58 a8 02 0f 84 c5 00 00 00 48 8b 46 50 49 89 f4 65 8b 15 34=
 bb aa 7e <39> 50 50 74 11 89 50 50 48 8b 46 50 8b 40 50 41 89 86 60 8b=
 00
> [    5.622457] RIP  [<ffffffff8155e614>] qla24xx_process_response_que=
ue+0x44/0x4b0
> [    5.622457]  RSP <ffff8801afb03de8>
> [    5.622457] CR2: 0000000000000050
> [    5.622457] ---[ end trace fa2b19c25106d42b ]---
> [    5.622457] Kernel panic - not syncing: Fatal exception in interru=
pt
>=20
>=20
> The affected code was introduced by commit cdb898c52d1dfad4b4800b83a5=
8b3fe5d352edde
> (qla2xxx: Add irq affinity notification).
>=20
> Only dereference rsp->msix when it has been set so the machine can bo=
ot
> fine. Possibly rsp->msix is unset because:
> [    3.479679] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HB=
A Driver: 8.07.00.33-k.
> [    3.481839] qla2xxx [0000:13:00.0]-001d: : Found an ISP2432 irq 17=
 iobase 0xffffc90000038000.
> [    3.484081] qla2xxx [0000:13:00.0]-0035:0: MSI-X; Unsupported ISP2=
432 (0x2, 0x3).
> [    3.485804] qla2xxx [0000:13:00.0]-0037:0: Falling back-to MSI mod=
e -258.
> [    3.890145] scsi host0: qla2xxx
> [    3.891956] qla2xxx [0000:13:00.0]-00fb:0: QLogic QLE2460 - PCI-Ex=
press Single Channel 4Gb Fibre Channel HBA.
> [    3.894207] qla2xxx [0000:13:00.0]-00fc:0: ISP2432: PCIe (2.5GT/s =
x4) @ 0000:13:00.0 hdma+ host#=3D0 fw=3D7.03.00 (9496).
> [    5.714774] qla2xxx [0000:13:00.0]-500a:0: LOOP UP detected (4 Gbp=
s).
>=20
>=20
> CC: <stable@vger.kernel.org>
> Signed-off-by: Bruno Pr=E9mont <bonbons@linux-vserver.org>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
