From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Subject: kernel 5.0 blk_clear_pm_only triggers a warning during resume
Date: Tue, 12 Mar 2019 05:35:43 +0000
Message-ID: <20190312132826.12c5f166@xhacker.debian>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <988FA2967C0A644AACF3FE99D84C8CAF@namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

kernel version: 5.0

I got below warning during resume:

[  673.658888] sd 0:0:0:0: [sda] Starting disk
[  673.658899] WARNING: CPU: 3 PID: 1039 at blk_clear_pm_only+0x2a/0x30
[  673.658902] CPU: 3 PID: 1039 Comm: kworker/u8:49 Not tainted 5.0.0+ #1
[  673.658902] sd 2:0:0:0: [sdb] Starting disk
[  673.658903] Hardware name: LENOVO 4180F42/4180F42, BIOS 83ET75WW (1.45 )=
 05/10/2013
[  673.658906] Workqueue: events_unbound async_run_entry_fn
[  673.658909] RIP: 0010:blk_clear_pm_only+0x2a/0x30
[  673.658911] Code: b8 ff ff ff ff f0 0f c1 87 80 00 00 00 83 e8 01 78 18 =
74 01 c3 48 81 c7 58 05 00 00 31 c9 31 d2 be 03 00 00 00 e9 36 97 e2 ff <0f=
> 0b c3 0f 1f 00 48 81 c7 90 00 00 00 e9 04 01 3a 00 0f 1f 40 00
[  673.658911] RSP: 0000:ffff8881115a7e48 EFLAGS: 00010297
[  673.658913] RAX: 00000000ffffffff RBX: ffff888118d42800 RCX: ffff8881194=
c9a00
[  673.658914] RDX: ffff888118ab1a00 RSI: 0000000000000000 RDI: ffff888117e=
70000
[  673.658915] RBP: ffff888118d42f90 R08: 0000000000000004 R09: 00000000000=
1f900
[  673.658915] R10: 0000000045698a8e R11: 0000000000000010 R12: ffff8881194=
21000
[  673.658916] R13: 0000000000000000 R14: ffff88800030ea80 R15: 0ffff888119=
42100
[  673.658918] FS:  0000000000000000(0000) GS:ffff88811a180000(0000) knlGS:=
0000000000000000
[  673.658918] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  673.658919] CR2: 0000000000000000 CR3: 000000000200c001 CR4: 00000000000=
606e0
[  673.658920] Call Trace:
[  673.658924]  ? scsi_device_resume+0x28/0x50
[  673.658926]  ? scsi_dev_type_resume+0x2b/0x80
[  673.658927]  ? async_run_entry_fn+0x2c/0xd0
[  673.658930]  ? process_one_work+0x1f0/0x3f0
[  673.658932]  ? worker_thread+0x28/0x3c0
[  673.658933]  ? process_one_work+0x3f0/0x3f0
[  673.658935]  ? kthread+0x10c/0x130
[  673.658936]  ? __kthread_create_on_node+0x150/0x150
[  673.658938]  ? ret_from_fork+0x1f/0x30
[  673.658940] ---[ end trace ce18772de33e283e ]---


I notice that commit 388b4e6a00bb3 ("scsi: core: Avoid that system resume
triggers a kernel warning") tried to fix the warning in the same code path
perhaps, it isn't enough.

Thanks
