From: Chaitra Basappa <chaitra.basappa@broadcom.com>
Subject: smp-induced oops/NULL pointer dereference in mpt3sas, from kernel >= 4.11
Date: Thu, 17 Aug 2017 15:18:56 +0530
Message-ID: <155d5b2c7af4ae0cc6162baf6a52ef5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Hi All,
 In testing kernel 4.11.1 and 4.11.6 we've hit an oops/ blown pointer
issue in mpt3sas. It is easily reproducible on a system that contains
expanders/enclosure connected behind SAS3 HBA.
Soon after connecting expander / enclosure we observe below call trace.


Jul 12 15:28:27 localhost kernel: BUG: unable to handle kernel NULL
pointer dereference at 00000000000000dc
Jul 12 15:28:27 localhost kernel: IP: _transport_smp_handler+0x8bb/0x10c0
[mpt3sas]
Jul 12 15:28:27 localhost kernel: PGD 811abb067
Jul 12 15:28:27 localhost kernel: PUD 81c96a067
Jul 12 15:28:27 localhost kernel: PMD 0
Jul 12 15:28:27 localhost kernel:
Jul 12 15:28:27 localhost kernel: Oops: 0002 [#1] SMP
Jul 12 15:28:27 localhost kernel: mpt3sas_cm0: Discovery: (stop)
Jul 12 15:28:27 localhost kernel:
Jul 12 15:28:27 localhost kernel: mpt3sas_cm0: discovery event: (stop)
Jul 12 15:28:27 localhost kernel:
Jul 12 15:28:27 localhost kernel: Hardware name: Dell Inc. PowerEdge
T620/0658N7, BIOS 2.5.4 01/22/2016
Jul 12 15:28:27 localhost kernel: task: ffff88081c1b8100 task.stack:
ffffc90006168000
Jul 12 15:28:27 localhost kernel: RIP:
0010:_transport_smp_handler+0x8bb/0x10c0 [mpt3sas]
Jul 12 15:28:27 localhost kernel: RSP: 0018:ffffc9000616bb38 EFLAGS:
00010286
Jul 12 15:28:27 localhost kernel: RAX: 00000000000000dc RBX:
ffff88041c2ba7b0 RCX: 0000003c1a07ff00
Jul 12 15:28:27 localhost kernel: RDX: ffff88081a45c948 RSI:
dead000000000200 RDI: dead000000000100
Jul 12 15:28:27 localhost kernel: RBP: ffffc9000616bbf8 R08:
ffffc9000616bac0 R09: dead000000000200
Jul 12 15:28:27 localhost kernel: R10: 0000000000000000 R11:
0000000000000010 R12: 0000000000000105
Jul 12 15:28:27 localhost kernel: R13: ffff88041d631680 R14:
ffff88041a6c6c38 R15: 0000000000000001
Jul 12 15:28:27 localhost kernel: FS:  00007f1818ad1700(0000)
GS:ffff88042f800000(0000) knlGS:0000000000000000
Jul 12 15:28:27 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Jul 12 15:28:27 localhost kernel: CR2: 00000000000000dc CR3:
000000081dad1000 CR4: 00000000000406f0
Jul 12 15:28:27 localhost kernel: Call Trace:
Jul 12 15:28:27 localhost kernel: ? blk_rq_bio_prep+0x3c/0x80
Jul 12 15:28:27 localhost kernel: ? blk_start_request+0x38/0x60
Jul 12 15:28:27 localhost kernel: sas_smp_request+0x5f/0xa0
[scsi_transport_sas]
Jul 12 15:28:27 localhost kernel: sas_non_host_smp_request+0x4a/0x60
[scsi_transport_sas]
Jul 12 15:28:27 localhost kernel: __blk_run_queue+0x37/0x50
Jul 12 15:28:27 localhost kernel: blk_execute_rq_nowait+0xeb/0x140
Jul 12 15:28:27 localhost kernel: blk_execute_rq+0x48/0x90
Jul 12 15:28:27 localhost kernel: bsg_ioctl+0x18a/0x1e0
Jul 12 15:28:27 localhost kernel: vfs_ioctl+0x18/0x30
Jul 12 15:28:27 localhost kernel: do_vfs_ioctl+0x14b/0x3f0
Jul 12 15:28:27 localhost kernel: ? security_file_ioctl+0x45/0x60
Jul 12 15:28:27 localhost kernel: SyS_ioctl+0x92/0xa0
Jul 12 15:28:27 localhost kernel: do_syscall_64+0x6c/0x160
Jul 12 15:28:27 localhost kernel: entry_SYSCALL64_slow_path+0x25/0x25
Jul 12 15:28:27 localhost kernel: RIP: 0033:0x35a88e0a77
Jul 12 15:28:27 localhost kernel: RSP: 002b:00007ffded06f278 EFLAGS:
00000246 ORIG_RAX: 0000000000000010
Jul 12 15:28:27 localhost kernel: RAX: ffffffffffffffda RBX:
00007ffded06f370 RCX: 00000035a88e0a77
Jul 12 15:28:27 localhost kernel: RDX: 00007ffded06f280 RSI:
0000000000002285 RDI: 0000000000000003
Jul 12 15:28:27 localhost kernel: RBP: 0000000000000000 R08:
00000000000003ea R09: 0000000000008000
Jul 12 15:28:27 localhost kernel: R10: fffffffffffffff0 R11:
0000000000000246 R12: 0000000000000003
Jul 12 15:28:27 localhost kernel: R13: 0000000000000000 R14:
00007ffded06f3a0 R15: 0000000000000000
Jul 12 15:28:27 localhost kernel: Code: 84 3e 02 00 00 48 8b 5d a8 85 d2
4c 8b ab f8 02 00 00 0f 85 e3 05 00 00 48 8b 55 98 49 8b 4d 00 48 81 c2 48
01 00 00 48 8b 42 28 <48> 89 08 49 8b 4d 08 48 89 48 08 49 8b 4d 10 48 89
48 10 41 8b
Jul 12 15:28:27 localhost kernel: RIP: _transport_smp_handler+0x8bb/0x10c0
[mpt3sas] RSP: ffffc9000616bb38
Jul 12 15:28:27 localhost kernel: CR2: 00000000000000dc
Jul 12 15:28:27 localhost kernel: ---[ end trace d0a22e0e5a84886a ]---
Jul 12 15:28:28 localhost kernel: ses 4:0:0:0: Attached Enclosure device




We analyzed this issue and could figure out it is not because of driver,
its because the "sense" field of the 'struct scsi_request' is not being
populated properly from the upper layer.
And this "sense" member is being referenced in our driver code for kernel
versions >= 4.11 as shown below in the snippet:
Whereas as for < 4.11 kernel version this "sense" member was referenced
via 'struct request'


static int
_transport_smp_handler (.....) {
.....
.....
>>memcpy(scsi_req(req)->sense, mpi_reply, sizeof(*mpi_reply));
.....
.....
}

And hence the NULL pointer dereference call trace is seen for the above
chunk of mpt3sas. This needs to be addressed from upper layer, so please
help us in getting this resolved.

Thanks in advance for the support,

Regards,
 Chaitra
