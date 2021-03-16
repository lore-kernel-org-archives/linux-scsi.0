Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B837C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 01:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8F0A6500D
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 01:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbhCPB7U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 21:59:20 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:54469 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhCPB7P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 21:59:15 -0400
Received: by mail-il1-f197.google.com with SMTP id w8so25643406ilg.21
        for <linux-scsi@vger.kernel.org>; Mon, 15 Mar 2021 18:59:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=R6Uw28w5orVwVt3fDtgWk1USLUmusEnOKl/UcqFTeVQ=;
        b=YoKgptjoa/KB/mDx/7x7g+Py4foL8Q8vw3pKvPUNFxqcIhRNjOUyu0DOAa3CIbEq3M
         U0VGInl5/wJ8iXKBp0gNb6HNDIAdEiLPdBhimVoOektsKXuvkuXg3SzAbCIDtGaCe95D
         dhsxA9hYMzWMbLGzsSKlBi5oOLwfMoN7MB1ol61BIBRKapFEfvS+fsxmIsOgfPdLl5VJ
         uaX//5q2Et/J8lnrKycXaVl/gnJS8s1N/rHl1azV9Dzmdnqn/ag368viEP/exGspBPrD
         L78GdnoATwTcOeqZl3TUb+9CsjRppvwCz70D3yDH+yJgI/RRVIsk/JWzkWnhh46IWLYc
         II9A==
X-Gm-Message-State: AOAM533uzPGZdNB5S/t1LtZ6/uOvFOvs7vEiiWdKY/LlPzh4UJnFA5KF
        rR+Z2TZrnppsDCWWuwBTH6btv1oSaDuNNkjZ+TNU1qqYQ/ec
X-Google-Smtp-Source: ABdhPJyi6YR7kyFETILMo6mpRwzvqTgKyJP6DGWX0ecuVsKMz9nvTyjvzIXWdqPavkNbThRlZwiAeheGJxM8GSif93JWu1a5jimA
MIME-Version: 1.0
X-Received: by 2002:a02:9083:: with SMTP id x3mr11850000jaf.17.1615859955448;
 Mon, 15 Mar 2021 18:59:15 -0700 (PDT)
Date:   Mon, 15 Mar 2021 18:59:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a6bf1605bd9db661@google.com>
Subject: [syzbot] KASAN: invalid-free in sg_finish_scsi_blk_rq
From:   syzbot <syzbot+0a0e8ecea895d38332e6@syzkaller.appspotmail.com>
To:     dgilbert@interlog.com, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d98f554b Add linux-next specific files for 20210312
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1189318ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e362835d2e58cef6
dashboard link: https://syzkaller.appspot.com/bug?extid=0a0e8ecea895d38332e6

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0a0e8ecea895d38332e6@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: double-free or invalid-free in slab_free mm/slub.c:3161 [inline]
BUG: KASAN: double-free or invalid-free in kfree+0xe5/0x7f0 mm/slub.c:4215

CPU: 0 PID: 10481 Comm: syz-executor.5 Not tainted 5.12.0-rc2-next-20210312-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
 kasan_report_invalid_free+0x51/0x80 mm/kasan/report.c:357
 ____kasan_slab_free mm/kasan/common.c:340 [inline]
 __kasan_slab_free+0x118/0x130 mm/kasan/common.c:367
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1562 [inline]
 slab_free_freelist_hook+0x92/0x210 mm/slub.c:1600
 slab_free mm/slub.c:3161 [inline]
 kfree+0xe5/0x7f0 mm/slub.c:4215
 scsi_req_free_cmd include/scsi/scsi_request.h:28 [inline]
 sg_finish_scsi_blk_rq+0x690/0x810 drivers/scsi/sg.c:3224
 sg_common_write+0xa07/0xe70 drivers/scsi/sg.c:1132
 sg_v3_submit+0x3b1/0x530 drivers/scsi/sg.c:797
 sg_ctl_sg_io drivers/scsi/sg.c:1785 [inline]
 sg_ioctl_common+0x3c86/0x97f0 drivers/scsi/sg.c:2014
 sg_ioctl+0x7c/0x110 drivers/scsi/sg.c:2229
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465f69
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8413efa188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465f69
RDX: 0000000020001780 RSI: 0000000000002285 RDI: 0000000000000003
RBP: 00000000004bfa8f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffe20e16e2f R14: 00007f8413efa300 R15: 0000000000022000

Allocated by task 10481:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc mm/kasan/common.c:506 [inline]
 ____kasan_kmalloc mm/kasan/common.c:465 [inline]
 __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc include/linux/slab.h:686 [inline]
 sg_start_req+0x16f/0x24e0 drivers/scsi/sg.c:3044
 sg_common_write+0x5fd/0xe70 drivers/scsi/sg.c:1109
 sg_v3_submit+0x3b1/0x530 drivers/scsi/sg.c:797
 sg_ctl_sg_io drivers/scsi/sg.c:1785 [inline]
 sg_ioctl_common+0x3c86/0x97f0 drivers/scsi/sg.c:2014
 sg_ioctl+0x7c/0x110 drivers/scsi/sg.c:2229
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 10481:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xf5/0x130 mm/kasan/common.c:367
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1562 [inline]
 slab_free_freelist_hook+0x92/0x210 mm/slub.c:1600
 slab_free mm/slub.c:3161 [inline]
 kfree+0xe5/0x7f0 mm/slub.c:4215
 sg_start_req+0x1b33/0x24e0 drivers/scsi/sg.c:3106
 sg_common_write+0x5fd/0xe70 drivers/scsi/sg.c:1109
 sg_v3_submit+0x3b1/0x530 drivers/scsi/sg.c:797
 sg_ctl_sg_io drivers/scsi/sg.c:1785 [inline]
 sg_ioctl_common+0x3c86/0x97f0 drivers/scsi/sg.c:2014
 sg_ioctl+0x7c/0x110 drivers/scsi/sg.c:2229
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 kvfree_call_rcu+0x74/0x8c0 kernel/rcu/tree.c:3597
 drop_sysctl_table+0x3c0/0x4e0 fs/proc/proc_sysctl.c:1646
 unregister_sysctl_table fs/proc/proc_sysctl.c:1684 [inline]
 unregister_sysctl_table+0xc2/0x190 fs/proc/proc_sysctl.c:1659
 mpls_dev_sysctl_unregister net/mpls/af_mpls.c:1442 [inline]
 mpls_dev_notify+0x64d/0x8b0 net/mpls/af_mpls.c:1632
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2063
 call_netdevice_notifiers_extack net/core/dev.c:2075 [inline]
 call_netdevice_notifiers net/core/dev.c:2089 [inline]
 dev_change_name+0x447/0x690 net/core/dev.c:1346
 do_setlink+0x2c1f/0x3a70 net/core/rtnetlink.c:2688
 __rtnl_newlink+0xdc6/0x1710 net/core/rtnetlink.c:3376
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3491
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 __sys_sendto+0x21c/0x320 net/socket.c:1977
 __do_sys_sendto net/socket.c:1989 [inline]
 __se_sys_sendto net/socket.c:1985 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:1985
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88802ae5f400
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 0 bytes inside of
 256-byte region [ffff88802ae5f400, ffff88802ae5f500)
The buggy address belongs to the page:
page:ffffea0000ab9780 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2ae5e
head:ffffea0000ab9780 order:1 compound_mapcount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 0000000000000000 0000000600000001 ffff888010841b40
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88802ae5f300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88802ae5f380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88802ae5f400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88802ae5f480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802ae5f500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
