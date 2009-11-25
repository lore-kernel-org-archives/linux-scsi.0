From: Jiri Slaby <jirislaby@gmail.com>
Subject: BUG at scsi_lib.c:1108 [Was: mmotm 2009-11-24-16-47 uploaded]
Date: Wed, 25 Nov 2009 16:12:09 +0100
Message-ID: <4B0D4949.4090109@gmail.com>
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757624AbZKYPMK@vger.kernel.org>
In-Reply-To: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@suse.de
List-Id: linux-scsi@vger.kernel.org

On 11/25/2009 01:47 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-11-24-16-47 has been uploaded to

Hi, I'm hitting the BUG below in the past two -mmotm's
(2009-11-24-16-47, 2009-11-17-14-03):

kernel BUG at /home/l/latest/xxx/drivers/scsi/scsi_lib.c:1108!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/kernel/uevent_seqnum
CPU 1
Modules linked in: ath5k ath
Pid: 10, comm: events/1 Not tainted 2.6.32-rc8-mm1_64 #905 To Be Filled
By O.E.M.
RIP: 0010:[<ffffffff81291cda>]  [<ffffffff81291cda>]
scsi_setup_fs_cmnd+0x8a/0xa0
RSP: 0018:ffff8801cb88db20  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8801c472b800 RCX: ffff8801c403a000
RDX: 0000000001082421 RSI: ffff8801c3d01000 RDI: ffff8801c472b800
RBP: ffff8801cb88db30 R08: 0000000000000000 R09: 0000000000000000
R10: ffff8801c53e68a0 R11: 0000000000000000 R12: ffff8801c3d01000
R13: ffff8801c472b800 R14: 0000000000000000 R15: ffff8801c472b848
FS:  0000000000000000(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f401b0065c0 CR3: 00000001c3e03000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process events/1 (pid: 10, threadinfo ffff8801cb88c000, task
ffff8801cb864140)
Stack:
 ffff8801c3d01000 ffff8801c53e68a0 ffff8801cb88dba0 ffffffff81299550
<0> ffff8801cb88db90 ffffffff81193a2a ffff8801cb88dba0 ffff8801c403a000
<0> 0000000000000000 ffff8801c4038b60 ffff8801c3d01000 ffff8801c3d01000
Call Trace:
 [<ffffffff81299550>] sd_prep_fn+0x80/0x800
 [<ffffffff81193a2a>] ? cfq_remove_request+0x14a/0x1d0
 [<ffffffff81189b7a>] blk_peek_request+0xca/0x1a0
 [<ffffffff81291206>] scsi_request_fn+0x56/0x3e0
 [<ffffffff8118934b>] __blk_run_queue+0x6b/0x140
 [<ffffffff81186fb4>] elv_insert+0x144/0x1a0
 [<ffffffff81187072>] __elv_add_request+0x62/0xc0
 [<ffffffff8118a479>] __make_request+0x129/0x3f0
 [<ffffffff81188fcf>] generic_make_request+0x19f/0x360
 [<ffffffff81188fcf>] ? generic_make_request+0x19f/0x360
 [<ffffffff811891f8>] submit_bio+0x68/0xe0
 [<ffffffff81328fe4>] md_submit_barrier+0xe4/0x170
 [<ffffffff81328f00>] ? md_submit_barrier+0x0/0x170
 [<ffffffff8104c81c>] worker_thread+0x12c/0x200
 [<ffffffff81050f60>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8104c6f0>] ? worker_thread+0x0/0x200
 [<ffffffff81050c8e>] kthread+0x8e/0xa0
 [<ffffffff81003cfa>] child_rip+0xa/0x20
 [<ffffffff81050c00>] ? kthread+0x0/0xa0
 [<ffffffff81003cf0>] ? child_rip+0x0/0x20
Code: 41 5c c9 c3 48 8b 00 48 85 c0 74 b7 48 8b 40 48 48 85 c0 74 ae 4c
89 e6 48 89 df ff d0 85 c0 74 a2 eb dc b0 02 0f 1f 40 00 eb d4 <0f> 0b
0f 1f 40 00 eb fa 66 66 66 66 66 2e 0f 1f 84 00 00 00 00
RIP  [<ffffffff81291cda>] scsi_setup_fs_cmnd+0x8a/0xa0
 RSP <ffff8801cb88db20>
---[ end trace 64ebbf58ad5b90ce ]---





I have raids 0 and 1, ext3 on the former, LVM+ext3 on the latter. It is
100% reproducible, each time while booting. But even after some services
start (opensuse 11.2). Plain singlemode doesn't trigger it. I didn't
investigate that further though.

regards,
-- 
js
Faculty of Informatics, Masaryk University
Suse Labs, Novell
