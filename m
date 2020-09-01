Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBA2C433E7
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 17:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4E65207D3
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 17:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729870AbgIARSe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 13:18:34 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:35449 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732649AbgIARSS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2020 13:18:18 -0400
Received: by mail-il1-f197.google.com with SMTP id p16so1448750ilp.2
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2020 10:18:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=FxTGVKFsQfLx849aB24wjiFOLnvV6WwA9z4aBDTxdrI=;
        b=knI16jcZWOVg8rkcCRoirvcjZI2g7McdR1g0qDIL5/NuKlPE/MochSL3epoolU5NSX
         OpNofeE/a3XSLnuAoD6qozv3oz/pFJlAQCIEwKUHVRz1FHXG90w0WCgYSqXZ1kM7JdO4
         lLc6SuBCIyQNnTyp2P3L4+GJpnixUku8e+pBUrhIs6bXRxdRlUElo4ORNnqmN7zBzh0I
         sEgZSzSpHOzkRy07aYYlf8IMjLcGj/uJyH+VRBkju78/l7P5Wzk7emeiPo/9frPgyf1/
         JqFfeKIAuYc2iTJQ9uT2LBDovFSp0pQBqcErKpppktNARtuxzNbY1aroy/ekYFtG5/MR
         Byrw==
X-Gm-Message-State: AOAM530almbiLrBUXTvPk897xf1yacNmpE4ZsqGaB0sWR9wvSzT1Kk6C
        7hmBD8FS5PzJqzpN3Cuj5zVypzvJHlTkWj3iKPHVYg+QSmML
X-Google-Smtp-Source: ABdhPJw9VF/mVvBTssdBX69XEB+x1xz5RJkUszVPbdDc9W0S7CQC8XNgSsw6QPfcU16yAr6tg5S5XGafeu62S8pegCVAiRLEC61M
MIME-Version: 1.0
X-Received: by 2002:a02:838e:: with SMTP id z14mr2403961jag.84.1598980696981;
 Tue, 01 Sep 2020 10:18:16 -0700 (PDT)
Date:   Tue, 01 Sep 2020 10:18:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007244da05ae43b492@google.com>
Subject: KMSAN: uninit-value in scsi_mode_sense
From:   syzbot <syzbot+6b02c1da3865f750164a@syzkaller.appspotmail.com>
To:     glider@google.com, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ce8056d1 wip: changed copy_from_user where instrumented
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=10278e91900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=6b02c1da3865f750164a
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177d957a900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14528186900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6b02c1da3865f750164a@syzkaller.appspotmail.com

sd 1:0:0:0: [sdb] 0 512-byte logical blocks: (0 B/0 B)
sd 1:0:0:0: [sdb] 0-byte physical blocks
=====================================================
BUG: KMSAN: uninit-value in scsi_mode_sense+0x10f0/0x17b0 drivers/scsi/scsi_lib.c:2138
CPU: 1 PID: 624 Comm: kworker/u4:6 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound async_run_entry_fn
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 scsi_mode_sense+0x10f0/0x17b0 drivers/scsi/scsi_lib.c:2138
 sd_read_write_protect_flag drivers/scsi/sd.c:2636 [inline]
 sd_revalidate_disk+0x4ffa/0xdae0 drivers/scsi/sd.c:3175
 sd_probe+0x10d1/0x18c0 drivers/scsi/sd.c:3405
 really_probe+0xf20/0x20b0 drivers/base/dd.c:529
 driver_probe_device+0x293/0x390 drivers/base/dd.c:701
 __device_attach_driver+0x63f/0x830 drivers/base/dd.c:807
 bus_for_each_drv+0x2ca/0x3f0 drivers/base/bus.c:431
 __device_attach_async_helper+0x31a/0x3f0 drivers/base/dd.c:833
 async_run_entry_fn+0x1a2/0x7d0 kernel/async.c:123
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 bio_copy_kern_endio_read+0x494/0x5f0 block/blk-map.c:448
 bio_endio+0xce1/0xde0 block/bio.c:1447
 req_bio_endio block/blk-core.c:261 [inline]
 blk_update_request+0x1178/0x2710 block/blk-core.c:1569
 scsi_end_request+0x102/0xc00 drivers/scsi/scsi_lib.c:558
 scsi_io_completion+0x34f/0x2f20 drivers/scsi/scsi_lib.c:934
 scsi_finish_command+0x85b/0x880 drivers/scsi/scsi.c:214
 scsi_softirq_done+0x683/0xa80 drivers/scsi/scsi_lib.c:1460
 blk_done_softirq+0x2fe/0x4e0 block/blk-softirq.c:37
 __do_softirq+0x2ea/0x7f5 kernel/softirq.c:293

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
 kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:269 [inline]
 kmsan_alloc_page+0xc5/0x1a0 mm/kmsan/kmsan_shadow.c:293
 __alloc_pages_nodemask+0xdf0/0x1030 mm/page_alloc.c:4889
 alloc_pages_current+0x685/0xb50 mm/mempolicy.c:2292
 alloc_pages include/linux/gfp.h:545 [inline]
 bio_copy_kern block/blk-map.c:494 [inline]
 blk_rq_map_kern+0xdda/0x1570 block/blk-map.c:743
 __scsi_execute+0x318/0xc80 drivers/scsi/scsi_lib.c:258
 scsi_execute_req include/scsi/scsi_device.h:460 [inline]
 scsi_mode_sense+0x600/0x17b0 drivers/scsi/scsi_lib.c:2115
 sd_read_write_protect_flag drivers/scsi/sd.c:2636 [inline]
 sd_revalidate_disk+0x4ffa/0xdae0 drivers/scsi/sd.c:3175
 sd_probe+0x10d1/0x18c0 drivers/scsi/sd.c:3405
 really_probe+0xf20/0x20b0 drivers/base/dd.c:529
 driver_probe_device+0x293/0x390 drivers/base/dd.c:701
 __device_attach_driver+0x63f/0x830 drivers/base/dd.c:807
 bus_for_each_drv+0x2ca/0x3f0 drivers/base/bus.c:431
 __device_attach_async_helper+0x31a/0x3f0 drivers/base/dd.c:833
 async_run_entry_fn+0x1a2/0x7d0 kernel/async.c:123
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
