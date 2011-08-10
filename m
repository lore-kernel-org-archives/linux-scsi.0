From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [BUG] Oops when SCSI device under multipath is removed
Date: Wed, 10 Aug 2011 13:29:53 +0900
Message-ID: <4E420941.3080601@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, jaxboe@fusionio.com
Cc: roland@purestorage.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

Hi James,

With the attached shell script, blk_insert_cloned_request will cause
oops with 3.1-rc1. (This is a regression introduced in 2.6.39)

The regression was introduced by 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b,
"[SCSI] put stricter guards on queue dead checks".
Part of the commit has moved scsi_free_queue(), which calls
blk_cleanup_queue(), to scsi_remove_device(), which is called while
the device is still open.
The oops occurs because blk_insert_cloned_request() is called
after blk_cleanup_queue() is called (which frees elevator
and turns on QUEUE_FLAG_DEAD).

2 patches have been proposed but neither of them included:
  1) Add QUEUE_FLAG_DEAD check in blk_insert_cloned_request()
     https://lkml.org/lkml/2011/7/8/457
  2) SCSI to call blk_cleanup_queue() from device's ->release() callback
     (before 2.6.39, it used to work like this)
     https://lkml.org/lkml/2011/7/2/106

Both work fine for this test case
but it seems it's not possible to make the patch 1) safe because
QUEUE_FLAG_DEAD check is racy. There is a window between the check
and the use of elevator.
So I think the patch 2) is better. Could you please consider to include it?

   BUG: unable to handle kernel NULL pointer dereference at           (null)
   IP: [<          (null)>]           (null)
   PGD 29c015067 PUD 29855a067 PMD 0 
   Oops: 0010 [#1] SMP 
   CPU 2 
   ..
   Pid: 6125, comm: dd Not tainted 3.1.0-rc1 #1
   RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
   RSP: 0018:ffff880288377990  EFLAGS: 00010092
   RAX: ffff88029c3e4e00 RBX: ffff88029a324cc8 RCX: 0000000000000240
   RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffff88029a324cc8
   RBP: ffff8802883779a8 R08: 0000000000000000 R09: 0000000000000000
   R10: 0000000000000002 R11: 0000000000000000 R12: ffff88029a324cc8
   R13: 0000000000000002 R14: 0000000000000002 R15: ffff88029a46c180
   FS:  00007fc4daf3d700(0000) GS:ffff8802afa00000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: 0000000000000000 CR3: 000000029abe4000 CR4: 00000000000006e0
   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
   Process dd (pid: 6125, threadinfo ffff880288376000, task ffff8802879ac260)
   Stack:
   ffffffff81223d8a ffff8802883779d8 ffff88029b5a6018 ffff8802883779d8
   ffffffff81224bdf ffff88029b5a6018 ffff88029a324cc8 0000000000000002
   ffff88029a46c000 ffff880288377a08 ffffffff8122974d ffff880288377a08
   Call Trace:
   [<ffffffff81223d8a>] ? elv_drain_elevator+0x2a/0x80
   [<ffffffff81224bdf>] __elv_add_request+0x9f/0x200
   [<ffffffff8122974d>] add_acct_request+0x3d/0x50
   [<ffffffff812297c5>] blk_insert_cloned_request+0x65/0x90
   [<ffffffffa01870ee>] dm_dispatch_request+0x3e/0x70 [dm_mod]
   [<ffffffffa0187e71>] dm_request_fn+0x191/0x290 [dm_mod]
   [<ffffffff8122571e>] __blk_run_queue+0x1e/0x20
   [<ffffffff81228a4e>] queue_unplugged+0x4e/0xc0
   [<ffffffff81228c76>] blk_flush_plug_list+0x1b6/0x210
   [<ffffffff814c62a5>] io_schedule+0x75/0xd0
   [<ffffffff811a03b4>] __blockdev_direct_IO+0x924/0xb20
   [<ffffffff8119dc77>] blkdev_direct_IO+0x57/0x60
   [<ffffffff8119cc60>] ? blkdev_get_block+0x70/0x70
   [<ffffffff8110ce35>] generic_file_aio_read+0x6f5/0x770
   [<ffffffff814c971b>] ? _raw_spin_unlock+0x2b/0x40
   [<ffffffff81131cda>] ? handle_pte_fault+0x40a/0x9c0
   [<ffffffff8101aa53>] ? native_sched_clock+0x13/0x60
   [<ffffffff81019e99>] ? sched_clock+0x9/0x10
   [<ffffffff8116746a>] do_sync_read+0xda/0x120
   [<ffffffff811f943e>] ? security_file_permission+0x8e/0x90
   [<ffffffff81167bed>] vfs_read+0xcd/0x190
   [<ffffffff81167db4>] sys_read+0x54/0xa0
   [<ffffffff814d1582>] system_call_fastpath+0x16/0x1b
   Code:  Bad RIP value.
   RIP  [<          (null)>]           (null)
   RSP <ffff880288377990>
   CR2: 0000000000000000
   ---[ end trace 4abd28efc271910a ]---

-- 
Jun'ichi Nomura, NEC Corporation



#!/bin/bash

dev=$1
if [ -z "$dev" ]; then
	echo "usage: $0 <sdX>    where <sdX> is unused SCSI device"
	exit 1
fi
if [ ! -e /dev/$dev -o ! -d /sys/block/$dev ] ; then
	echo "device $dev not found"
	exit 1
fi
if [ $dev = ${dev#sd} ]; then
	echo "device $dev is not SCSI device"
	exit 1
fi
echo "Use SCSI device $dev"

mapname=deadmp
maptab="0 $(blockdev --getsz /dev/$dev) multipath 0 0 1 1 round-robin 1 1 1 1 /dev/$dev 1"
modprobe dm-multipath
modprobe dm-round-robin
echo "Creating multipath device: $mapname"
echo $maptab | dmsetup create $mapname
if [ $? -ne 0 ]; then
	echo "failed to create mpath device"
	exit 1
fi

echo "Deleting $dev"
echo 1 > /sys/block/$dev/device/delete
sleep 1

echo "Try I/O on $dev"
dd if=/dev/mapper/${mapname} of=/dev/null bs=4k count=1 iflag=direct

sleep 10
dmsetup remove $mapname
