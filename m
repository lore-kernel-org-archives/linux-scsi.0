From: Kyungtae Kim <kt0755@gmail.com>
Subject: UBSAN: Undefined behaviour in drivers/scsi/sr_ioctl.c
Date: Thu, 24 Jan 2019 19:23:43 -0500
Message-ID: <CAEAjamuFYNYTn8eqNZg-VU9A2=hrHxarhoFz+JEMmx0yVm40LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Byoungyoung Lee <lifeasageek@gmail.com>, DaeRyong Jeong <threeearcat@gmail.com>, syzkaller <syzkaller@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I'm reporting a bug in linux-5.0-rc2: "UBSAN: Undefined behaviour in
drivers/scsi/sr_ioctl.c"

kernel config: https://kt0755.github.io/etc/config-5.0-rc2
repro: https://kt0755.github.io/etc/repro.01311.c (need to provide cdrom image)

Integer overflow arose in sr_select_speed() when "speed *= 177"
is larger than the size of the type "int".
A sanity check right before it would help.

=========================================
UBSAN: Undefined behaviour in drivers/scsi/sr_ioctl.c:424:9
signed integer overflow:
-2147483648 * 177 cannot be represented in type 'int'
CPU: 0 PID: 22452 Comm: syz-executor4 Not tainted 5.0.0-rc2 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xb1/0x118 lib/dump_stack.c:113
 ubsan_epilogue+0x12/0x94 lib/ubsan.c:159
 handle_overflow+0x1cf/0x21a lib/ubsan.c:190
 __ubsan_handle_mul_overflow+0x2a/0x35 lib/ubsan.c:214
 sr_select_speed+0x179/0x1a0 drivers/scsi/sr_ioctl.c:424
 cdrom_ioctl_select_speed drivers/cdrom/cdrom.c:2435 [inline]
 cdrom_ioctl+0x850/0x2ffa drivers/cdrom/cdrom.c:3347
 sr_block_ioctl+0x129/0x180 drivers/scsi/sr.c:587
 __blkdev_driver_ioctl block/ioctl.c:303 [inline]
 blkdev_ioctl+0x1378/0x1b50 block/ioctl.c:605
 block_ioctl+0x105/0x150 fs/block_dev.c:1906
 vfs_ioctl fs/ioctl.c:46 [inline]
 do_vfs_ioctl+0x1aa/0x1160 fs/ioctl.c:698
 ksys_ioctl+0x9e/0xb0 fs/ioctl.c:713
 __do_sys_ioctl fs/ioctl.c:720 [inline]
 __se_sys_ioctl fs/ioctl.c:718 [inline]
 __x64_sys_ioctl+0x7e/0xc0 fs/ioctl.c:718
 do_syscall_64+0xbe/0x4f0 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4497b9
Code: e8 8c 9f 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 0f 83 9b 6b fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f4a70139c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f4a7013a6cc RCX: 00000000004497b9
RDX: 0000000080000000 RSI: 0000000000005322 RDI: 0000000000000013
RBP: 000000000071bea0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000002dd8 R14: 00000000006ebe78 R15: 00007f4a7013a700
=========================================

Thanks,
Kyungtae Kim
