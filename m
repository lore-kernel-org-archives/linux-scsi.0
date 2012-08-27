From: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 00/20, v4] Make ib_srp better suited for H.A. purposes
Date: Mon, 27 Aug 2012 20:37:31 +0200
Message-ID: <20120827183731.GB6094@gmail.com>
References: <5023DA39.7020000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5023DA39.7020000-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Bart,

while testing ib_srp based on your srp-ha,
we sometimes hit kernel crashes with the call trace below.

How to reproduce:

0. Kernel 3.2.15 with SCST v4193 on the target,
   Kernel 3.2.8 with ib_srp-ha on the initiator.
1. Configure 500+ vdisks on target, and get initiator connected.
2. Exchange data intensively, which works well.
3. (On initiator) delete SRP remote port occasionally, e.g.
   # echo "1" > /sys/class/srp_remote_ports/port-6\:1/delete
   And configure again the SRP target.
4. (On target) disable Infiniband interface, and enable it again.
5. Repeat 3 and 4.

Then the initiator's kernel suddenly crashes. (but not always)

Do you have any idea why?

Thanks in advance,
Dongsu

---------------------------------------------------------------
BUG: unable to handle kernel paging request at 0000000000010001
IP: [<ffffffff8139ec55>] strnlen+0x5/0x40
PGD 212fea067 PUD 2162f8067 PMD 0
Oops: 0000 [#1] SMP
CPU 0
Modules linked in: ib_srp scsi_transport_srp scsi_tgt rdma_ucm rdma_cm
iw_cm ib_addr ib_ipoib ib_cm ib_sa ib_uverbs ib_umad loop psmouse
serio_raw evdev i2c_piix4 tpm_tis tpm tpm_bios ib_mthca sg ib_mad
processor amd64_edac_mod edac_core thermal_sys edac_mce_amd ib_core
button sd_mod crc_t10dif hid_cherry usb_storage ahci libahci libata
scsi_mod [last unloaded: scsi_wait_scan]

Pid: 2311, comm: kworker/0:2 Not tainted 3.2.8 #1 Supermicro
H8DGU/H8DGU
RIP: 0010:[<ffffffff8139ec55>]  [<ffffffff8139ec55>] strnlen+0x5/0x40
RSP: 0018:ffff880215fe3c28  EFLAGS: 00010086
RAX: ffffffff81915991 RBX: ffffffff81ba5497 RCX: ffffffffff0a0004
RDX: 0000000000010001 RSI: ffffffffffffffff RDI: 0000000000010001
RBP: ffffffff81ba5860 R08: 000000000000fffb R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000010001
R13: ffffffffffffffff R14: 00000000ffffffff R15: 0000000000000000
FS:  00007faafb63e700(0000) GS:ffff880217c00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000010001 CR3: 0000000212f87000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:2 (pid: 2311, threadinfo ffff880215fe2000, task
ffff88020f2ce540)
Stack:
 ffffffff813a023c 0000000000000000 ffffffff81ba5497 ffffffffa0131d82
 ffffffffa0131d80 ffff880215fe3da0 ffffffff81ba5860 ffff880215fe3c90
 ffffffff813a142d 0000000000000016 ffffffff81ba5460 0000000000000400
Call Trace:
 [<ffffffff813a023c>] ? string+0x4c/0xe0
 [<ffffffff813a142d>] ? vsnprintf+0x1ed/0x5b0
 [<ffffffffa0131900>] ? do_srp_rport_del+0x30/0x30 [scsi_transport_srp]
 [<ffffffff813a18a9>] ? vscnprintf+0x9/0x20
 [<ffffffff81049b7f>] ? vprintk+0xaf/0x440
 [<ffffffff810f3cc0>] ? next_online_pgdat+0x20/0x50
 [<ffffffff810f3d20>] ? next_zone+0x30/0x40
 [<ffffffff810f4c60>] ? refresh_cpu_vm_stats+0xf0/0x160
 [<ffffffffa0131900>] ? do_srp_rport_del+0x30/0x30 [scsi_transport_srp]
 [<ffffffff816533b6>] ? printk+0x40/0x4a
 [<ffffffffa013192d>] ? rport_dev_loss_timedout+0x2d/0xa0
[scsi_transport_srp]
 [<ffffffff81063383>] ? process_one_work+0x113/0x470
 [<ffffffff81065c73>] ? worker_thread+0x163/0x3e0
 [<ffffffff81065b10>] ? manage_workers+0x200/0x200
 [<ffffffff81065b10>] ? manage_workers+0x200/0x200
 [<ffffffff8106a126>] ? kthread+0x96/0xa0
 [<ffffffff8165f674>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8106a090>] ? kthread_worker_fn+0x180/0x180
 [<ffffffff8165f670>] ? gs_change+0x13/0x13
Code: 1f 80 00 00 00 00 31 c0 80 3f 00 48 89 fa 74 14 66 0f 1f 44 00 00
48 ff c2 80 3a 00 75 f8 48 89 d0 48 29 f8 f3 c3 48 85 f6 74 27 <80> 3f
00 74 22 48 ff ce 48 89 f8 eb 0e 66 0f 1f 44 00 00 48 ff
RIP  [<ffffffff8139ec55>] strnlen+0x5/0x40
RSP <ffff880215fe3c28>
CR2: 0000000000010001
---[ end trace d55b61cd78c54a0a ]---
BUG: unable to handle kernel paging request at fffffffffffffff8


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
