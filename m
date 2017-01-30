From: Dmitry Vyukov <dvyukov@google.com>
Subject: scsi: use-after-free in sg_start_req
Date: Mon, 30 Jan 2017 08:25:59 +0100
Message-ID: <CACT4Y+bwWs4cndXQfCXyaM8Z-YOvxvj0+8rW4GhzfwESDAtGaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:35211 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752492AbdA3H0U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2017 02:26:20 -0500
Received: by mail-ua0-f176.google.com with SMTP id y9so245626175uae.2
        for <linux-scsi@vger.kernel.org>; Sun, 29 Jan 2017 23:26:20 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: syzkaller <syzkaller@googlegroups.com>

Hello,

The following program triggers use-after-free in sg_start_req:
https://gist.githubusercontent.com/dvyukov/be6561d2819fe30a78711234e53866b8/raw/1d75d4508f7a8ebb0b1ec0d18c0054fbffbc0708/gistfile1.txt

BUG: KASAN: use-after-free in bio_copy_user_iov+0xee1/0xf00
block/bio.c:1248 at addr ffff8801c8c3ed00
Read of size 8 by task /9023
CPU: 0 PID: 9023 Comm:  Not tainted 4.9.0 #5
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011
 ffff8801d451f420 ffffffff82346bdf ffffffff00000000 1ffff1003a8a3e17
 ffffed003a8a3e0f 0000000041b58ab3 ffffffff84b37e38 ffffffff823468f1
 ffffffff813183a6 ffff8801d451f0e0 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff82346bdf>] __dump_stack lib/dump_stack.c:15 [inline]
 [<ffffffff82346bdf>] dump_stack+0x2ee/0x3ef lib/dump_stack.c:51
 [<ffffffff819de90c>] kasan_object_err+0x1c/0x70 mm/kasan/report.c:161
 [<ffffffff819deb91>] print_address_description mm/kasan/report.c:199 [inline]
 [<ffffffff819deb91>] kasan_report_error+0x1d1/0x4d0 mm/kasan/report.c:288
 [<ffffffff819def8e>] kasan_report mm/kasan/report.c:308 [inline]
 [<ffffffff819def8e>] __asan_report_load8_noabort+0x3e/0x40
mm/kasan/report.c:329
 [<ffffffff822820c1>] bio_copy_user_iov+0xee1/0xf00 block/bio.c:1248
 [<ffffffff822c0d35>] __blk_rq_map_user_iov block/blk-map.c:56 [inline]
 [<ffffffff822c0d35>] blk_rq_map_user_iov+0x2c5/0x970 block/blk-map.c:133
 [<ffffffff822c1514>] blk_rq_map_user+0x134/0x1d0 block/blk-map.c:163
 [<ffffffff82d2abb1>] sg_start_req drivers/scsi/sg.c:1758 [inline]
 [<ffffffff82d2abb1>] sg_common_write.isra.20+0x12b1/0x1b00
drivers/scsi/sg.c:772
 [<ffffffff82d2fc45>] sg_write+0x785/0xda0 drivers/scsi/sg.c:675
 [<ffffffff81a27771>] __vfs_write+0x5b1/0x740 fs/read_write.c:510
 [<ffffffff81a29060>] vfs_write+0x170/0x4e0 fs/read_write.c:560
 [<ffffffff81a2d42b>] SYSC_write fs/read_write.c:607 [inline]
 [<ffffffff81a2d42b>] SyS_write+0xfb/0x230 fs/read_write.c:599
 [<ffffffff84371941>] entry_SYSCALL_64_fastpath+0x1f/0xc2
Object at ffff8801c8c3ed00, in cache kmalloc-256 size: 256
Allocated:
PID = 9032
 [   52.586815] [<ffffffff8129c696>] save_stack_trace+0x16/0x20
arch/x86/kernel/stacktrace.c:57
 [   52.594037] [<ffffffff819ddba3>] save_stack+0x43/0xd0 mm/kasan/kasan.c:495
 [   52.600735] [<ffffffff819dde2a>] set_track mm/kasan/kasan.c:507 [inline]
 [   52.600735] [<ffffffff819dde2a>] kasan_kmalloc+0xaa/0xd0
mm/kasan/kasan.c:598
 [   52.607700] [<ffffffff819d940c>] __do_kmalloc mm/slab.c:3729 [inline]
 [   52.607700] [<ffffffff819d940c>] __kmalloc+0x12c/0x690 mm/slab.c:3738
 [   52.614520] [<ffffffff82d27deb>] kmalloc include/linux/slab.h:495 [inline]
 [   52.614520] [<ffffffff82d27deb>] kzalloc include/linux/slab.h:636 [inline]
 [   52.614520] [<ffffffff82d27deb>] sg_build_sgat
drivers/scsi/sg.c:1808 [inline]
 [   52.614520] [<ffffffff82d27deb>]
sg_build_indirect.isra.19+0x8b/0x540 drivers/scsi/sg.c:1834
 [   52.622591] [<ffffffff82d2832d>] sg_build_reserve+0x8d/0xb0
drivers/scsi/sg.c:1965
 [   52.629815] [<ffffffff82d29001>] sg_add_sfp drivers/scsi/sg.c:2152 [inline]
 [   52.629815] [<ffffffff82d29001>] sg_open+0xcb1/0x15b0 drivers/scsi/sg.c:329
 [   52.636503] [<ffffffff81a36b23>] chrdev_open+0x253/0x6b0 fs/char_dev.c:392
 [   52.643451] [<ffffffff81a1eeca>] do_dentry_open+0x6ca/0xc50 fs/open.c:753
 [   52.650660] [<ffffffff81a22ea5>] vfs_open+0x105/0x220 fs/open.c:866
 [   52.657351] [<ffffffff81a62c4f>] do_last fs/namei.c:3374 [inline]
 [   52.657351] [<ffffffff81a62c4f>] path_openat+0x100f/0x3830 fs/namei.c:3497
 [   52.664488] [<ffffffff81a69bf8>] do_filp_open+0x288/0x3f0 fs/namei.c:3532
 [   52.671538] [<ffffffff81a23dc5>] do_sys_open+0x535/0x710 fs/open.c:1053
 [   52.678484] [<ffffffff81a23fcd>] SYSC_open fs/open.c:1071 [inline]
 [   52.678484] [<ffffffff81a23fcd>] SyS_open+0x2d/0x40 fs/open.c:1066
 [   52.685000] [<ffffffff84371941>] entry_SYSCALL_64_fastpath+0x1f/0xc2
Freed:
PID = 9032
 [   52.697636] [<ffffffff8129c696>] save_stack_trace+0x16/0x20
arch/x86/kernel/stacktrace.c:57
 [   52.704842] [<ffffffff819ddba3>] save_stack+0x43/0xd0 mm/kasan/kasan.c:495
 [   52.711522] [<ffffffff819de49f>] set_track mm/kasan/kasan.c:507 [inline]
 [   52.711522] [<ffffffff819de49f>] kasan_slab_free+0x6f/0xb0
mm/kasan/kasan.c:571
 [   52.718640] [<ffffffff819dc393>] __cache_free mm/slab.c:3507 [inline]
 [   52.718640] [<ffffffff819dc393>] kfree+0xd3/0x250 mm/slab.c:3824
 [   52.724979] [<ffffffff82d23bd2>]
sg_remove_scat.isra.16+0x212/0x2d0 drivers/scsi/sg.c:1916
 [   52.732879] [<ffffffff82d2d583>] sg_ioctl+0x1903/0x3840
drivers/scsi/sg.c:970
 [   52.739745] [<ffffffff81a749bf>] vfs_ioctl fs/ioctl.c:43 [inline]
 [   52.739745] [<ffffffff81a749bf>] do_vfs_ioctl+0x1bf/0x1630 fs/ioctl.c:679
 [   52.746866] [<ffffffff81a75ebf>] SYSC_ioctl fs/ioctl.c:694 [inline]
 [   52.746866] [<ffffffff81a75ebf>] SyS_ioctl+0x8f/0xc0 fs/ioctl.c:685
 [   52.753478] [<ffffffff84371941>] entry_SYSCALL_64_fastpath+0x1f/0xc2

On commit ca63ff9b11f958efafd8c8fa60fda14baec6149c
