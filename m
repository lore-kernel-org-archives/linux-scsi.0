From: Mark Salter <msalter@redhat.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Wed, 18 Nov 2015 09:03:19 -0500
Message-ID: <1447855399.3974.24.camel@redhat.com>
References: <1447838334.1564.2.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447838334.1564.2.camel@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-11-18 at 20:18 +1100, Michael Ellerman wrote:
> Hi folks,
>=20
> I'm intermittently seeing the following oops on at least one powerpc =
box.
>=20
> The BUG_ON() is from:
>=20
> static int scsi_init_sgtable(struct request *req, struct scsi_data_bu=
ffer *sdb)
> {
> 	...
> 	count =3D blk_rq_map_sg(req->q, req, sdb->table.sgl);
> 	BUG_ON(count > sdb->table.nents);
>=20
> Looking at the dump it looks like count was 2, I can't work out what =
nents was.
>=20
> The machine's just a fairly boring bare metal setup, with a single IP=
R adapter:
>=20
> 0001:08:00.0 RAID bus controller: IBM PCI-E IPR SAS Adapter (ASIC) (r=
ev 02)
> 	Subsystem: IBM PCIe3 x8 SAS RAID Internal Adapter 6Gb (57D7)
> 	Flags: bus master, fast devsel, latency 0
> 	Kernel driver in use: ipr
>=20
>=20
> Anyone seen it before or have any ideas?

I'm also seeing it on arm64 in 4.4-rc1

[=C2=A0=C2=A0=C2=A0=C2=A06.859003] Call trace:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.861439] [<fffffe000074345c>] scsi_init_sgtab=
le+0x84/0x88=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.867072] [<fffffe00007434ac>] scsi_init_io+0x=
4c/0x1ac=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.872358] [<fffffe000075004c>] sd_setup_read_w=
rite_cmnd+0x44/0x844=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.878682] [<fffffe0000750884>] sd_init_command=
+0x38/0xb0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.884141] [<fffffe00007436e4>] scsi_setup_cmnd=
+0xd8/0x13c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.889686] [<fffffe000074397c>] scsi_prep_fn+0x=
c0/0x140=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.894973] [<fffffe00003bd0cc>] blk_peek_reques=
t+0x148/0x24c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.900692] [<fffffe0000744754>] scsi_request_fn=
+0x58/0x648=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.906237] [<fffffe00003b8e80>] __blk_run_queue=
+0x40/0x58=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.911696] [<fffffe00003b91a4>] blk_run_queue+0=
x30/0x48=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.916983] [<fffffe00007422e4>] scsi_run_queue+=
0x204/0x294=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.922528] [<fffffe000074321c>] scsi_end_reques=
t+0x13c/0x1a0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.928247] [<fffffe0000744ef4>] scsi_io_complet=
ion+0xf0/0x564=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.934052] [<fffffe000073beb0>] scsi_finish_com=
mand+0xe4/0x144=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.939943] [<fffffe00007446cc>] scsi_softirq_do=
ne+0x148/0x178=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.945748] [<fffffe00003c39a4>] blk_done_softir=
q+0x7c/0x94=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.951295] [<fffffe00000c8f44>] __do_softirq+0x=
114/0x2a0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.956667] [<fffffe00000c9340>] irq_exit+0x8c/0=
xe4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.961522] [<fffffe000009cf00>] handle_IPI+0x17=
0/0x228=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.966721] [<fffffe00000904e0>] gic_handle_irq+=
0xa0/0xb8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0
[=C2=A0=C2=A0=C2=A0=C2=A06.972093] Exception stack(0xfffffe03dc143de0 t=
o 0xfffffe03dc143f00)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0

>=20
> cheers
>=20
>=20
> systemd[1]: Starting Uncomplicated firewall...
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Starting Uncomp=
licated firewall...
> ------------[ cut here ]------------
> kernel BUG at drivers/scsi/scsi_lib.c:1096!
> Oops: Exception in kernel mode, sig: 5 [#1]
> SMP NR_CPUS=3D2048 NUMA PowerNV
> Modules linked in:
> CPU: 132 PID: 2699 Comm: kworker/132:1H Not tainted 4.4.0-rc1-54939-g=
e22a248-dirty #77
> Workqueue: kblockd cfq_kick_queue
> task: c000000fef147400 ti: c000000feb384000 task.ti: c000000feb384000
> NIP: c0000000005ab4a8 LR: c0000000005ab490 CTR: 0000000000000000
> REGS: c000000feb387620 TRAP: 0700=C2=A0=C2=A0=C2=A0Not tainted=C2=A0=C2=
=A0(4.4.0-rc1-54939-ge22a248-dirty)
> MSR: 9000000100029033 <SF,HV,EE,ME,IR,DR,RI,LE>=C2=A0=C2=A0CR: 240022=
28=C2=A0=C2=A0XER: 00000000
> CFAR: c000000000464950 SOFTE: 0=20
> GPR00: c0000000005ab490 c000000feb3878a0 c000000000d77d00 00000000000=
00002=20
> GPR04: c000000ff2030158 c000000ff47a0c00 0000000000000000 00000000000=
01000=20
> GPR08: 0000000000000000 0000000000000001 0000000000000000 fffffffffff=
ffff7=20
> GPR12: 0000000000002200 c00000000fde5200 c0000000000c8098 c000000000b=
39858=20
> GPR16: c000000000ae12c8 c000000000b39948 0000000000000000 00000000000=
00000=20
> GPR20: c0000000005ab9c0 c0000017f5800144 0000000000000000 c000001e551=
a6850=20
> GPR24: c0000017f5800140 c0000007efb9c800 0000000000000000 c000001e551=
a6800=20
> GPR28: 0000000000000000 0000000000000000 c000000ff2030158 c000000feb4=
20240=20
> NIP [c0000000005ab4a8] scsi_init_sgtable+0xa8/0x180
> LR [c0000000005ab490] scsi_init_sgtable+0x90/0x180
> Call Trace:
> [c000000feb3878a0] [c0000000005ab490] scsi_init_sgtable+0x90/0x180 (u=
nreliable)
> [c000000feb3878e0] [c0000000005ab5d4] scsi_init_io+0x54/0x160
> [c000000feb387930] [c0000000005fb43c] sd_init_command+0x6c/0xb00
> [c000000feb3879f0] [c0000000005ac2f8] scsi_setup_cmnd+0x108/0x1a0
> [c000000feb387a30] [c0000000005ac594] scsi_prep_fn+0x104/0x1c0
> [c000000feb387a70] [c00000000045d85c] blk_peek_request+0x20c/0x390
> [c000000feb387af0] [c0000000005ad6a8] scsi_request_fn+0xb8/0x7f0
> [c000000feb387bf0] [c0000000004583b4] __blk_run_queue+0x54/0x80
> [c000000feb387c20] [c00000000047e178] cfq_kick_queue+0x38/0xc0
> [c000000feb387c50] [c0000000000c00cc] process_one_work+0x2ac/0x560
> [c000000feb387ce0] [c0000000000c0510] worker_thread+0x190/0x660
> [c000000feb387d80] [c0000000000c8198] kthread+0x108/0x130
> [c000000feb387e30] [c0000000000095b0] ret_from_kernel_thread+0x5c/0xa=
c
> Instruction dump:
> 2fa30000 409e00e4 e8bf0000 e87e0030 7fc4f378 4beb91ed 60000000 813f00=
08=20
> 78630020 7f891840 7d301026 5529effe <0b090000> 907f0008 38600000 813e=
005c=20
> ---[ end trace 3ea632a512ff48d5 ]---
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-in=
fo.html
> Please read the FAQ at=C2=A0=C2=A0http://www.tux.org/lkml/
