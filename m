From: Jiri Slaby <jirislaby@gmail.com>
Subject: BUG at drivers/scsi/scsi_lib.c:1113
Date: Thu, 22 Jul 2010 09:04:27 +0200
Message-ID: <4C47ED7B.1050709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48841 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab0GVHEf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2010 03:04:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org

Hello,

I'm seeing this BUG while booting:

EXT3-fs (md1): using internal journal
------------[ cut here ]------------
kernel BUG at /home/l/latest/xxx/drivers/scsi/scsi_lib.c:1113!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/block/dm-1/dm/suspended
CPU 0
Modules linked in: ath5k dvb_usb_af9015 dvb_usb

Pid: 879, comm: md3_raid1 Tainted: G        W   2.6.35-rc5-mm1_64+ #1265
To be filled by O.E.M./To Be Filled By O.E.M.
RIP: 0010:[<ffffffff813312d6>]  [<ffffffff813312d6>]
scsi_setup_fs_cmnd+0x96/0xd0
RSP: 0018:ffff8801c4717c30  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8801c429c7b0 RCX: ffff8801c54ba400
RDX: 0000000000000001 RSI: ffff8801c429c7b0 RDI: ffff8801c4feb000
RBP: ffff8801c4717c40 R08: 0000000000000000 R09: 000000000203c40f
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8801c4feb000
R13: ffff8801c4feb000 R14: 0000000000000000 R15: ffff8801c4feb048
FS:  0000000000000000(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007eff59831230 CR3: 00000001c28e2000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process md3_raid1 (pid: 879, threadinfo ffff8801c4716000, task
ffff8801cbd5a6a0)
Stack:
 ffff8801c429c7b0 ffff8801c4fd9170 ffff8801c4717cb0 ffffffff81339a78
<0> ffff8801c4717c80 ffffffff812252e9 0000000000000000 ffff8801c54ba400
<0> 0000000000000000 ffff8801c2a80bc8 ffff8801c4717cb0 ffff8801c429c7b0
Call Trace:
 [<ffffffff81339a78>] sd_prep_fn+0xa8/0x800
 [<ffffffff812252e9>] ? cfq_dispatch_request+0x49/0xb0
 [<ffffffff8121a24a>] blk_peek_request+0xca/0x1a0
 [<ffffffff81330a56>] scsi_request_fn+0x56/0x400
 [<ffffffff81219dad>] __generic_unplug_device+0x2d/0x40
 [<ffffffff8121a059>] generic_unplug_device+0x29/0x40
 [<ffffffff81217682>] blk_unplug+0x12/0x20
 [<ffffffff813f14c8>] unplug_slaves+0x78/0xc0
 [<ffffffff813f3ecb>] raid1d+0x37b/0x420
 [<ffffffff813fb6e3>] md_thread+0x53/0x120
 [<ffffffff8107c9f0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff813fb690>] ? md_thread+0x0/0x120
 [<ffffffff8107c54e>] kthread+0x8e/0xa0
 [<ffffffff8102bb14>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107c4c0>] ? kthread+0x0/0xa0
 [<ffffffff8102bb10>] ? kernel_thread_helper+0x0/0x10
Code: e8 d0 fe ff ff 5b 41 5c c9 c3 0f 1f 00 4c 89 e7 be 20 00 00 00 e8
db 9f ff ff 48 89 c7 48 85 c0 74 35 48 89 83 c8 00 00 00 eb a3 <0f> 0b
48 8b 00 48 85 c0 74 83 48 8b 40 48 48 85 c0 0f 84 76 ff
RIP  [<ffffffff813312d6>] scsi_setup_fs_cmnd+0x96/0xd0
 RSP <ffff8801c4717c30>
---[ end trace 70a1134e7c27f7b3 ]---


I bisected it down to:
commit 74450be123b6f3cb480c358a056be398cce6aa6e
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Jun 18 11:53:43 2010 +0200

    block: unify flags for struct bio and struct request

    Remove the current bio flags and reuse the request flags for the
bio, too.
    This allows to more easily trace the type of I/O from the filesystem
    down to the block driver.  There were two flags in the bio that were
    missing in the requests:  BIO_RW_UNPLUG and BIO_RW_AHEAD.  Also I've
    renamed two request flags that had a superflous RW in them.

    Note that the flags are in bio.h despite having the REQ_ name - as
    blkdev.h includes bio.h that is the only way to go for now.

    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>



# bad: [d8d58e7fbcb3152e4e04931b80c8bae4b4a36c9f] Add linux-next
specific files for 20100720
# good: [d0c6f6258478e1dba532bf7c28e2cd6e1047d3a4] Merge branch
'x86-fixes-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect start 'next/master' 'd0c6f6258478e1dba532bf7c28e2cd6e1047d3a4'
# good: [3953691c38e4612bfbf4fe595656e658addf9e29] Merge remote branch
'async_tx/next'
git bisect good 3953691c38e4612bfbf4fe595656e658addf9e29
# good: [185f234d7291ffe44a9ccc94903eafdb6c84ab60] Merge remote branch
'sound/for-next'
git bisect good 185f234d7291ffe44a9ccc94903eafdb6c84ab60
# bad: [ea464c012ffc63a5d902c4609c8119925e621812] Merge remote branch
'omap_dss2/for-next'
git bisect bad ea464c012ffc63a5d902c4609c8119925e621812
# bad: [74e29f4e42cc638bf52c05b1e50cd40c8d4b03d6] Merge remote branch
'security-testing/next'
git bisect bad 74e29f4e42cc638bf52c05b1e50cd40c8d4b03d6
# bad: [fd0f6364d604311693e5de90a0ed624378f167ea] Merge branch
'quilt/device-mapper'
git bisect bad fd0f6364d604311693e5de90a0ed624378f167ea
# good: [b63983efdc35a4cfdc77075ca32432cd29507d90] Merge remote branch
'input/next'
git bisect good b63983efdc35a4cfdc77075ca32432cd29507d90
# bad: [5107cb04989311a4f4c0b49bb26b179d6ad724a3] Merge branch
'for-2.6.36' into for-next
git bisect bad 5107cb04989311a4f4c0b49bb26b179d6ad724a3
# good: [fc734ac98dbce1e3d3e1e1359524c279a336ac49] block: remove
wrappers for request type/flags
git bisect good fc734ac98dbce1e3d3e1e1359524c279a336ac49
# good: [ea99235763799b2577b6838664867cb8a7985019] Merge branch
'for-linus' into for-next
git bisect good ea99235763799b2577b6838664867cb8a7985019
# bad: [087971e4d08cda751813065fd3479505d85d4773] Merge branch
'writeback-2.6.36' into for-2.6.36
git bisect bad 087971e4d08cda751813065fd3479505d85d4773
# bad: [f1b6857c5f527de464ad0c433bbbb84d62d60564] virtio_blk: remove
overzealous warning
git bisect bad f1b6857c5f527de464ad0c433bbbb84d62d60564
# bad: [baec0ad935fb538ebe54c8afa7eceea765fce004] virtio_blk: add
default case to cmd type switch
git bisect bad baec0ad935fb538ebe54c8afa7eceea765fce004
# bad: [74450be123b6f3cb480c358a056be398cce6aa6e] block: unify flags for
struct bio and struct request
git bisect bad 74450be123b6f3cb480c358a056be398cce6aa6e

regards,
-- 
js
