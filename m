Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A772BC43457
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 14:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 751182080A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 14:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389664AbgJLOvU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:51:20 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:42468 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389440AbgJLOvU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 10:51:20 -0400
Received: by mail-il1-f197.google.com with SMTP id f12so2430369ilq.9
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 07:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MG7LCgZV9JOV33VFA5S3dcXj+/fRsnhH4tx6womiSsI=;
        b=IQynlc5d0VukOZA2dX5csG8ionkXFz9KcG20zc/FQ6167rK/WUmG3hN0Pds0DgcsPH
         pyejjMh7Onu02STfw4frFkQTwK/TG8DRfp2l401N6Jss/zKDY14Uvap2Al8WMECA75+c
         xdmzpxav4nnsLqOUzU7wosWUy1IjyrnoL3X2CP0Qum1kycb1zACbZN7qvaTap+2Tx/c+
         70JLi0UTGVc+usk/GqPuHKIlGRfgjp98o/mcGSy4NZqSTQhTdoW6hKX/TZDZoXYcn+81
         +yyM3SjuTGIFg2HG3lfNqTLwfAEAKdG82BDRrvMFqOORD+vkk0aWPxCT3hVuX7rxM9W+
         31/A==
X-Gm-Message-State: AOAM5336Qjj0JLnDyL2IgRKTpZJHmcVMPXt/dVMLh9pKP+zhQ1DTWxlI
        CcHcdCDeh6wseQiU/lRfXkVC2hcpfTkDF28aYrWolkDleyft
X-Google-Smtp-Source: ABdhPJzjAr9+E4+dMkFlppgsJObffFCcsvpXcuPwLE5FQ2n1f7kFyepuI9mhKD5fSKBDsbF53JcWneaj1Csps57LxMCBRldUW55X
MIME-Version: 1.0
X-Received: by 2002:a92:a112:: with SMTP id v18mr19573477ili.290.1602514277849;
 Mon, 12 Oct 2020 07:51:17 -0700 (PDT)
Date:   Mon, 12 Oct 2020 07:51:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000047627e05b17a6ec9@google.com>
Subject: general protection fault in scsi_queue_rq
From:   syzbot <syzbot+0796b72dc61f223d8cc5@syzkaller.appspotmail.com>
To:     hare@suse.de, hch@lst.de, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e4fb79c7 Add linux-next specific files for 20201008
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=125c9a9f900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=568d41fe4341ed0f
dashboard link: https://syzkaller.appspot.com/bug?extid=0796b72dc61f223d8cc5
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12582fe7900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124ac7d0500000

The issue was bisected to:

commit 2ceda20f0a99a74a82b78870f3b3e5fa93087a7f
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Oct 5 08:41:23 2020 +0000

    scsi: core: Move command size detection out of the fast path

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=135ea777900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10dea777900000
console output: https://syzkaller.appspot.com/x/log.txt?x=175ea777900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0796b72dc61f223d8cc5@syzkaller.appspotmail.com
Fixes: 2ceda20f0a99 ("scsi: core: Move command size detection out of the fast path")

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 6889 Comm: syz-executor086 Not tainted 5.9.0-rc8-next-20201008-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:scsi_command_size include/scsi/scsi_common.h:24 [inline]
RIP: 0010:scsi_setup_scsi_cmnd drivers/scsi/scsi_lib.c:1186 [inline]
RIP: 0010:scsi_prepare_cmd drivers/scsi/scsi_lib.c:1565 [inline]
RIP: 0010:scsi_queue_rq+0x2155/0x3020 drivers/scsi/scsi_lib.c:1654
Code: 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 98 0c 00 00 48 8b 83 58 02 00 00 48 ba 00 00 00 00 00 fc ff df 48 89 c1 48 c1 e9 03 <0f> b6 14 11 48 89 c1 83 e1 07 38 ca 7f 08 84 d2 0f 85 53 0c 00 00
RSP: 0018:ffffc90005627580 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88801b6bd400 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: ffffffff84aaad82 RDI: 0000000000000003
RBP: ffff888019670000 R08: 0000000000000001 R09: ffff88801b6bd7c0
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88801b6bd658 R14: ffff8881341bc000 R15: 0000000000000000
FS:  00007f1d217b3700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005617bf6e4410 CR3: 000000001f08b000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 blk_mq_dispatch_rq_list+0x3a1/0x1eb0 block/blk-mq.c:1388
 __blk_mq_sched_dispatch_requests+0x263/0x490 block/blk-mq-sched.c:308
 blk_mq_sched_dispatch_requests+0xfb/0x180 block/blk-mq-sched.c:341
 __blk_mq_run_hw_queue+0x13a/0x2d0 block/blk-mq.c:1532
 __blk_mq_delay_run_hw_queue+0x522/0x5f0 block/blk-mq.c:1609
 blk_mq_run_hw_queue+0x16c/0x2f0 block/blk-mq.c:1662
 blk_mq_sched_insert_request+0x4d7/0x5e0 block/blk-mq-sched.c:473
 blk_execute_rq+0xd4/0x1b0 block/blk-exec.c:86
 sg_io+0x609/0xf50 block/scsi_ioctl.c:360
 scsi_cmd_ioctl+0x5ce/0x660 block/scsi_ioctl.c:808
 scsi_cmd_blk_ioctl block/scsi_ioctl.c:866 [inline]
 scsi_cmd_blk_ioctl+0xe1/0x130 block/scsi_ioctl.c:857
 sd_ioctl_common+0x17e/0x280 drivers/scsi/sd.c:1575
 sd_ioctl+0x26/0xf0 drivers/scsi/sd.c:1765
 __blkdev_driver_ioctl block/ioctl.c:228 [inline]
 blkdev_ioctl+0x2a7/0x7f0 block/ioctl.c:623
 block_ioctl+0xf9/0x140 fs/block_dev.c:1869
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446059
Code: e8 fc b8 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 0b 12 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1d217b2d98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000006ddc48 RCX: 0000000000446059
RDX: 00000000200046c0 RSI: 0000000000002285 RDI: 0000000000000004
RBP: 00000000006ddc40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006ddc4c
R13: 0000000020000000 R14: 00000000004ae698 R15: 0000000000000003
Modules linked in:
---[ end trace 2bb961546eae45fe ]---
RIP: 0010:scsi_command_size include/scsi/scsi_common.h:24 [inline]
RIP: 0010:scsi_setup_scsi_cmnd drivers/scsi/scsi_lib.c:1186 [inline]
RIP: 0010:scsi_prepare_cmd drivers/scsi/scsi_lib.c:1565 [inline]
RIP: 0010:scsi_queue_rq+0x2155/0x3020 drivers/scsi/scsi_lib.c:1654
Code: 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 98 0c 00 00 48 8b 83 58 02 00 00 48 ba 00 00 00 00 00 fc ff df 48 89 c1 48 c1 e9 03 <0f> b6 14 11 48 89 c1 83 e1 07 38 ca 7f 08 84 d2 0f 85 53 0c 00 00
RSP: 0018:ffffc90005627580 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88801b6bd400 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: ffffffff84aaad82 RDI: 0000000000000003
RBP: ffff888019670000 R08: 0000000000000001 R09: ffff88801b6bd7c0
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88801b6bd658 R14: ffff8881341bc000 R15: 0000000000000000
FS:  00007f1d217b3700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005617bf6e4410 CR3: 000000001f08b000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
