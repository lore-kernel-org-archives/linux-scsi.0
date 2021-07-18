Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A54BC636CA
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Jul 2021 13:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E459960FF3
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Jul 2021 13:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhGRNI1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Jul 2021 09:08:27 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:54916 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbhGRNI0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jul 2021 09:08:26 -0400
Received: by mail-io1-f69.google.com with SMTP id m14-20020a5d898e0000b02904f7957d92b5so10134900iol.21
        for <linux-scsi@vger.kernel.org>; Sun, 18 Jul 2021 06:05:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gtL4p5cHU8XeH+65TJNNSFyAP4IndYy+groV9Bwj3zk=;
        b=QIIAuf6bZK4uqDetVUcnmGDpvnzfAry6FRH5x5iC03FDsLqaco8m1BQQEgpgU/b80I
         CYvP4wHQZCbAaQLUpMfOYXRj+hNy6Vs6WH+31WkaexqE0VOouGRuLVxN6Wu3GuZ5ZZMu
         AfXGn/4lT8ripH43IGuV9wGKVdtnJUBjwfCIu+C+2g6xm6eyjuYPZwRBnsSVV1rTv/xG
         V6e599aIF/ku/NLUq1PcT9jvZ40eSZUgd8zg3ar131M1YVfOi0S7r/lGMw6zHt2hz7ZE
         0GQiH1Wck+fpgfCVXfRUicCdJUyIEfDK2gTAPthW3o5N3pKSQpYKILpVNU59RNt3VeWW
         tXiw==
X-Gm-Message-State: AOAM530WfJJWekVf6k8Ous8lKDBSSqmtrIV5Cv17HXxqwFe3KXSQUaWk
        q+tfVPqP/ZmeSrHMWaRGrQZumYjL7XiYHF5MGzS2akQjnt/8
X-Google-Smtp-Source: ABdhPJxH3oVRzl3kzeuUz+vS7PkDKpf8IVWEFbNHgEczQ32pXO/FE2SLZhC5/vGaaNmb+ylQxgbJyCXx3eSNow3Ha+jPs/4JIJ5t
MIME-Version: 1.0
X-Received: by 2002:a92:d141:: with SMTP id t1mr13090632ilg.171.1626613528546;
 Sun, 18 Jul 2021 06:05:28 -0700 (PDT)
Date:   Sun, 18 Jul 2021 06:05:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008e52e005c765798b@google.com>
Subject: [syzbot] WARNING in scsi_alloc_sgtables
From:   syzbot <syzbot+d44b35ecfb807e5af0b5@syzkaller.appspotmail.com>
To:     jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    dd9c7df94c1b Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13dffb78300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4743a765b066cc1c
dashboard link: https://syzkaller.appspot.com/bug?extid=d44b35ecfb807e5af0b5

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d44b35ecfb807e5af0b5@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 15940 at drivers/scsi/scsi_lib.c:988 scsi_alloc_sgtables+0xc92/0xf80 drivers/scsi/scsi_lib.c:988
Modules linked in:
CPU: 1 PID: 15940 Comm: syz-executor.0 Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:scsi_alloc_sgtables+0xc92/0xf80 drivers/scsi/scsi_lib.c:988
Code: 31 ff 44 89 f6 e8 1e e5 f3 fc 45 85 f6 0f 84 28 f5 ff ff e8 60 dc f3 fc 41 83 c4 01 45 0f b7 e4 e9 1b f5 ff ff e8 4e dc f3 fc <0f> 0b 41 be 0a 00 00 00 e9 25 fb ff ff 41 be 09 00 00 00 e9 1a fb
RSP: 0018:ffffc90003c87468 EFLAGS: 00010202
RAX: 00000000000086f0 RBX: ffff88801d2c0128 RCX: ffffc90001929000
RDX: 0000000000040000 RSI: ffffffff8480e152 RDI: 0000000000000003
RBP: ffff88801d2c0000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff8480d659 R11: 0000000000000000 R12: 0000000000000000
R13: ffff888014892000 R14: 0000000000000000 R15: ffff888014448000
FS:  00007f47d4121700(0000) GS:ffff88802cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000515cb0 CR3: 000000004d420000 CR4: 0000000000150ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 scsi_setup_scsi_cmnd drivers/scsi/scsi_lib.c:1160 [inline]
 scsi_prepare_cmd drivers/scsi/scsi_lib.c:1559 [inline]
 scsi_queue_rq+0x26b2/0x35b0 drivers/scsi/scsi_lib.c:1665
 blk_mq_dispatch_rq_list+0x422/0x1f00 block/blk-mq.c:1380
 __blk_mq_sched_dispatch_requests+0x20b/0x410 block/blk-mq-sched.c:327
 blk_mq_sched_dispatch_requests+0xfb/0x180 block/blk-mq-sched.c:360
 __blk_mq_run_hw_queue+0xd8/0x150 block/blk-mq.c:1500
 __blk_mq_delay_run_hw_queue+0x547/0x640 block/blk-mq.c:1577
 blk_mq_run_hw_queue+0x16c/0x2f0 block/blk-mq.c:1630
 blk_mq_sched_insert_request+0x368/0x450 block/blk-mq-sched.c:479
 blk_execute_rq+0xdc/0x410 block/blk-exec.c:96
 sg_io+0x602/0xfe0 block/scsi_ioctl.c:358
 scsi_cmd_ioctl+0x519/0x580 block/scsi_ioctl.c:808
 scsi_cmd_blk_ioctl block/scsi_ioctl.c:866 [inline]
 scsi_cmd_blk_ioctl+0xe1/0x130 block/scsi_ioctl.c:857
 sd_ioctl_common+0x17e/0x280 drivers/scsi/sd.c:1585
 sd_ioctl+0x26/0xf0 drivers/scsi/sd.c:1778
 blkdev_ioctl+0x2a1/0x6d0 block/ioctl.c:585
 block_ioctl+0xf9/0x140 fs/block_dev.c:1602
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f47d4121188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 00000000200065c0 RSI: 0000000000002285 RDI: 0000000000000004
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffc92ec284f R14: 00007f47d4121300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
