Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2607EC433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Apr 2022 13:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355105AbiDCNkW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 09:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243404AbiDCNkU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 09:40:20 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC48B127
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 06:38:22 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id y4-20020a6bd804000000b0064c68fa4f70so4763276iob.2
        for <linux-scsi@vger.kernel.org>; Sun, 03 Apr 2022 06:38:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=jRiN7vFWUg7EVsgEtKjNWgX5el9xUaFmICxGrQuUQ7o=;
        b=Fw2GoEVm2rQ4V14OI08qd320dC3bPX0tlQ4mA+T/NCSOGcU0P7B+9JHA1mpuKxxdj3
         mk2Jx0KiOwj1zLFepM80UrnsL/njimFecQ9tpO/ndkXMiTbf3xH6P+ZEIbiJEYCn3mIc
         4CvOwj7pHB9cRd/JbRFcLRLyuAulYNEaQ3yeLiNKnbWwaGmWXFxOp7Npcq8g0af/lxoo
         pfqwt87ycPqi4jX2dPBqfpKKXNVXEdcrhHnj5JQpC+N7mV+DkqGGPeBpfmGvBBXXVxoQ
         Svv9ZHkDLixkx7Wgn1Z12PpXBUDGrmB9CU3pOvZTHrTCB1XOUGWdKMip2fCF84ViUNMb
         3hjQ==
X-Gm-Message-State: AOAM530Z4W6lueL+hDBmGknLVGd6dOTSqKw6qtZeqZI2/+Mn/PTR2RVF
        dyKOS9AaNo4vaa22RVAApR8EZfpFhrD89Vv3woqAkx+oBH7E
X-Google-Smtp-Source: ABdhPJwgecakUOLPyO/0zjZDahmyr2pj4SH1iIdZaG7UUZhi+5HDGMeRoqqCxJ4L0khIqKSnOn/DMiy4UGoN8qekscRX9SjfxB49
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2512:b0:323:e54d:711 with SMTP id
 v18-20020a056638251200b00323e54d0711mr877337jat.132.1648993102235; Sun, 03
 Apr 2022 06:38:22 -0700 (PDT)
Date:   Sun, 03 Apr 2022 06:38:22 -0700
In-Reply-To: <000000000000c341cc05db38c1b0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000188c9705dbc020de@google.com>
Subject: Re: [syzbot] memory leak in blk_mq_init_tags
From:   syzbot <syzbot+f08c77040fa163a75a46@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, dan.carpenter@oracle.com, fmdefrancesco@gmail.com,
        haowenchao@huawei.com, hch@infradead.org, jejb@linux.ibm.com,
        linfeilong@huawei.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, syzkaller-bugs@googlegroups.com,
        wubo40@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    be2d3ecedd99 Merge tag 'perf-tools-for-v5.18-2022-04-02' o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17c30c5f700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=58ae7615fea18863
dashboard link: https://syzkaller.appspot.com/bug?extid=f08c77040fa163a75a46
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11aff7e7700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1195476b700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f08c77040fa163a75a46@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88810dbc1240 (size 192):
  comm "kworker/u4:2", pid 53, jiffies 4294997418 (age 17.570s)
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    02 00 00 00 06 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff822c3f2b>] kmalloc_node include/linux/slab.h:599 [inline]
    [<ffffffff822c3f2b>] kzalloc_node include/linux/slab.h:725 [inline]
    [<ffffffff822c3f2b>] blk_mq_init_tags+0x4b/0xc0 block/blk-mq-tag.c:578
    [<ffffffff822ba7ba>] blk_mq_alloc_rq_map+0xea/0x1a0 block/blk-mq.c:3168
    [<ffffffff822bf686>] blk_mq_alloc_map_and_rqs+0x26/0xb0 block/blk-mq.c:3619
    [<ffffffff822c6f37>] blk_mq_sched_alloc_map_and_rqs block/blk-mq-sched.c:507 [inline]
    [<ffffffff822c6f37>] blk_mq_init_sched+0x127/0x2e0 block/blk-mq-sched.c:587
    [<ffffffff822a2f69>] elevator_init_mq+0x1f9/0x240 block/elevator.c:709
    [<ffffffff822cabad>] device_add_disk+0x4d/0x520 block/genhd.c:425
    [<ffffffff82833357>] sd_probe+0x457/0x670 drivers/scsi/sd.c:3475
    [<ffffffff826fce97>] call_driver_probe drivers/base/dd.c:541 [inline]
    [<ffffffff826fce97>] really_probe.part.0+0xe7/0x310 drivers/base/dd.c:620
    [<ffffffff826fd1cc>] really_probe drivers/base/dd.c:582 [inline]
    [<ffffffff826fd1cc>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:751
    [<ffffffff826fd2ca>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:781
    [<ffffffff826fdb36>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:898
    [<ffffffff826fa037>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427
    [<ffffffff826fc6bf>] __device_attach_async_helper+0xcf/0x110 drivers/base/dd.c:927
    [<ffffffff8127ce74>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b28f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2289
    [<ffffffff8126bbb9>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2436

BUG: memory leak
unreferenced object 0xffff888109d6da00 (size 128):
  comm "kworker/u4:2", pid 53, jiffies 4294997418 (age 17.570s)
  hex dump (first 32 bytes):
    03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814a70de>] kmalloc_node include/linux/slab.h:604 [inline]
    [<ffffffff814a70de>] kvmalloc_node+0x3e/0x130 mm/util.c:580
    [<ffffffff8240fbee>] kvzalloc_node include/linux/slab.h:735 [inline]
    [<ffffffff8240fbee>] sbitmap_init_node+0xde/0x2d0 lib/sbitmap.c:113
    [<ffffffff8241045c>] sbitmap_queue_init_node+0x3c/0x1f0 lib/sbitmap.c:428
    [<ffffffff822c3e47>] bt_alloc block/blk-mq-tag.c:543 [inline]
    [<ffffffff822c3e47>] blk_mq_init_bitmaps+0x57/0xf0 block/blk-mq-tag.c:555
    [<ffffffff822c3f68>] blk_mq_init_tags+0x88/0xc0 block/blk-mq-tag.c:586
    [<ffffffff822ba7ba>] blk_mq_alloc_rq_map+0xea/0x1a0 block/blk-mq.c:3168
    [<ffffffff822bf686>] blk_mq_alloc_map_and_rqs+0x26/0xb0 block/blk-mq.c:3619
    [<ffffffff822c6f37>] blk_mq_sched_alloc_map_and_rqs block/blk-mq-sched.c:507 [inline]
    [<ffffffff822c6f37>] blk_mq_init_sched+0x127/0x2e0 block/blk-mq-sched.c:587
    [<ffffffff822a2f69>] elevator_init_mq+0x1f9/0x240 block/elevator.c:709
    [<ffffffff822cabad>] device_add_disk+0x4d/0x520 block/genhd.c:425
    [<ffffffff82833357>] sd_probe+0x457/0x670 drivers/scsi/sd.c:3475
    [<ffffffff826fce97>] call_driver_probe drivers/base/dd.c:541 [inline]
    [<ffffffff826fce97>] really_probe.part.0+0xe7/0x310 drivers/base/dd.c:620
    [<ffffffff826fd1cc>] really_probe drivers/base/dd.c:582 [inline]
    [<ffffffff826fd1cc>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:751
    [<ffffffff826fd2ca>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:781
    [<ffffffff826fdb36>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:898
    [<ffffffff826fa037>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427

BUG: memory leak
unreferenced object 0xffff88810c0e1600 (size 512):
  comm "kworker/u4:2", pid 53, jiffies 4294997418 (age 17.570s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    10 16 0e 0c 81 88 ff ff 10 16 0e 0c 81 88 ff ff  ................
  backtrace:
    [<ffffffff82410528>] kmalloc_node include/linux/slab.h:599 [inline]
    [<ffffffff82410528>] kzalloc_node include/linux/slab.h:725 [inline]
    [<ffffffff82410528>] sbitmap_queue_init_node+0x108/0x1f0 lib/sbitmap.c:438
    [<ffffffff822c3e47>] bt_alloc block/blk-mq-tag.c:543 [inline]
    [<ffffffff822c3e47>] blk_mq_init_bitmaps+0x57/0xf0 block/blk-mq-tag.c:555
    [<ffffffff822c3f68>] blk_mq_init_tags+0x88/0xc0 block/blk-mq-tag.c:586
    [<ffffffff822ba7ba>] blk_mq_alloc_rq_map+0xea/0x1a0 block/blk-mq.c:3168
    [<ffffffff822bf686>] blk_mq_alloc_map_and_rqs+0x26/0xb0 block/blk-mq.c:3619
    [<ffffffff822c6f37>] blk_mq_sched_alloc_map_and_rqs block/blk-mq-sched.c:507 [inline]
    [<ffffffff822c6f37>] blk_mq_init_sched+0x127/0x2e0 block/blk-mq-sched.c:587
    [<ffffffff822a2f69>] elevator_init_mq+0x1f9/0x240 block/elevator.c:709
    [<ffffffff822cabad>] device_add_disk+0x4d/0x520 block/genhd.c:425
    [<ffffffff82833357>] sd_probe+0x457/0x670 drivers/scsi/sd.c:3475
    [<ffffffff826fce97>] call_driver_probe drivers/base/dd.c:541 [inline]
    [<ffffffff826fce97>] really_probe.part.0+0xe7/0x310 drivers/base/dd.c:620
    [<ffffffff826fd1cc>] really_probe drivers/base/dd.c:582 [inline]
    [<ffffffff826fd1cc>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:751
    [<ffffffff826fd2ca>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:781
    [<ffffffff826fdb36>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:898
    [<ffffffff826fa037>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427
    [<ffffffff826fc6bf>] __device_attach_async_helper+0xcf/0x110 drivers/base/dd.c:927
    [<ffffffff8127ce74>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127

BUG: memory leak
unreferenced object 0xffff88810dbc1240 (size 192):
  comm "kworker/u4:2", pid 53, jiffies 4294997418 (age 20.380s)
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    02 00 00 00 06 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff822c3f2b>] kmalloc_node include/linux/slab.h:599 [inline]
    [<ffffffff822c3f2b>] kzalloc_node include/linux/slab.h:725 [inline]
    [<ffffffff822c3f2b>] blk_mq_init_tags+0x4b/0xc0 block/blk-mq-tag.c:578
    [<ffffffff822ba7ba>] blk_mq_alloc_rq_map+0xea/0x1a0 block/blk-mq.c:3168
    [<ffffffff822bf686>] blk_mq_alloc_map_and_rqs+0x26/0xb0 block/blk-mq.c:3619
    [<ffffffff822c6f37>] blk_mq_sched_alloc_map_and_rqs block/blk-mq-sched.c:507 [inline]
    [<ffffffff822c6f37>] blk_mq_init_sched+0x127/0x2e0 block/blk-mq-sched.c:587
    [<ffffffff822a2f69>] elevator_init_mq+0x1f9/0x240 block/elevator.c:709
    [<ffffffff822cabad>] device_add_disk+0x4d/0x520 block/genhd.c:425
    [<ffffffff82833357>] sd_probe+0x457/0x670 drivers/scsi/sd.c:3475
    [<ffffffff826fce97>] call_driver_probe drivers/base/dd.c:541 [inline]
    [<ffffffff826fce97>] really_probe.part.0+0xe7/0x310 drivers/base/dd.c:620
    [<ffffffff826fd1cc>] really_probe drivers/base/dd.c:582 [inline]
    [<ffffffff826fd1cc>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:751
    [<ffffffff826fd2ca>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:781
    [<ffffffff826fdb36>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:898
    [<ffffffff826fa037>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427
    [<ffffffff826fc6bf>] __device_attach_async_helper+0xcf/0x110 drivers/base/dd.c:927
    [<ffffffff8127ce74>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b28f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2289
    [<ffffffff8126bbb9>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2436

BUG: memory leak
unreferenced object 0xffff888109d6da00 (size 128):
  comm "kworker/u4:2", pid 53, jiffies 4294997418 (age 20.380s)
  hex dump (first 32 bytes):
    03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814a70de>] kmalloc_node include/linux/slab.h:604 [inline]
    [<ffffffff814a70de>] kvmalloc_node+0x3e/0x130 mm/util.c:580
    [<ffffffff8240fbee>] kvzalloc_node include/linux/slab.h:735 [inline]
    [<ffffffff8240fbee>] sbitmap_init_node+0xde/0x2d0 lib/sbitmap.c:113
    [<ffffffff8241045c>] sbitmap_queue_init_node+0x3c/0x1f0 lib/sbitmap.c:428
    [<ffffffff822c3e47>] bt_alloc block/blk-mq-tag.c:543 [inline]
    [<ffffffff822c3e47>] blk_mq_init_bitmaps+0x57/0xf0 block/blk-mq-tag.c:555
    [<ffffffff822c3f68>] blk_mq_init_tags+0x88/0xc0 block/blk-mq-tag.c:586
    [<ffffffff822ba7ba>] blk_mq_alloc_rq_map+0xea/0x1a0 block/blk-mq.c:3168
    [<ffffffff822bf686>] blk_mq_alloc_map_and_rqs+0x26/0xb0 block/blk-mq.c:3619
    [<ffffffff822c6f37>] blk_mq_sched_alloc_map_and_rqs block/blk-mq-sched.c:507 [inline]
    [<ffffffff822c6f37>] blk_mq_init_sched+0x127/0x2e0 block/blk-mq-sched.c:587
    [<ffffffff822a2f69>] elevator_init_mq+0x1f9/0x240 block/elevator.c:709
    [<ffffffff822cabad>] device_add_disk+0x4d/0x520 block/genhd.c:425
    [<ffffffff82833357>] sd_probe+0x457/0x670 drivers/scsi/sd.c:3475
    [<ffffffff826fce97>] call_driver_probe drivers/base/dd.c:541 [inline]
    [<ffffffff826fce97>] really_probe.part.0+0xe7/0x310 drivers/base/dd.c:620
    [<ffffffff826fd1cc>] really_probe drivers/base/dd.c:582 [inline]
    [<ffffffff826fd1cc>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:751
    [<ffffffff826fd2ca>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:781
    [<ffffffff826fdb36>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:898
    [<ffffffff826fa037>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427

BUG: memory leak
unreferenced object 0xffff88810c0e1600 (size 512):
  comm "kworker/u4:2", pid 53, jiffies 4294997418 (age 20.380s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    10 16 0e 0c 81 88 ff ff 10 16 0e 0c 81 88 ff ff  ................
  backtrace:
    [<ffffffff82410528>] kmalloc_node include/linux/slab.h:599 [inline]
    [<ffffffff82410528>] kzalloc_node include/linux/slab.h:725 [inline]
    [<ffffffff82410528>] sbitmap_queue_init_node+0x108/0x1f0 lib/sbitmap.c:438
    [<ffffffff822c3e47>] bt_alloc block/blk-mq-tag.c:543 [inline]
    [<ffffffff822c3e47>] blk_mq_init_bitmaps+0x57/0xf0 block/blk-mq-tag.c:555
    [<ffffffff822c3f68>] blk_mq_init_tags+0x88/0xc0 block/blk-mq-tag.c:586
    [<ffffffff822ba7ba>] blk_mq_alloc_rq_map+0xea/0x1a0 block/blk-mq.c:3168
    [<ffffffff822bf686>] blk_mq_alloc_map_and_rqs+0x26/0xb0 block/blk-mq.c:3619
    [<ffffffff822c6f37>] blk_mq_sched_alloc_map_and_rqs block/blk-mq-sched.c:507 [inline]
    [<ffffffff822c6f37>] blk_mq_init_sched+0x127/0x2e0 block/blk-mq-sched.c:587
    [<ffffffff822a2f69>] elevator_init_mq+0x1f9/0x240 block/elevator.c:709
    [<ffffffff822cabad>] device_add_disk+0x4d/0x520 block/genhd.c:425
    [<ffffffff82833357>] sd_probe+0x457/0x670 drivers/scsi/sd.c:3475
    [<ffffffff826fce97>] call_driver_probe drivers/base/dd.c:541 [inline]
    [<ffffffff826fce97>] really_probe.part.0+0xe7/0x310 drivers/base/dd.c:620
    [<ffffffff826fd1cc>] really_probe drivers/base/dd.c:582 [inline]
    [<ffffffff826fd1cc>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:751
    [<ffffffff826fd2ca>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:781
    [<ffffffff826fdb36>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:898
    [<ffffffff826fa037>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427
    [<ffffffff826fc6bf>] __device_attach_async_helper+0xcf/0x110 drivers/base/dd.c:927
    [<ffffffff8127ce74>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127

BUG: memory leak
unreferenced object 0xffff88810dbc1240 (size 192):
  comm "kworker/u4:2", pid 53, jiffies 4294997418 (age 21.330s)
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    02 00 00 00 06 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff822c3f2b>] kmalloc_node include/linux/slab.h:599 [inline]
    [<ffffffff822c3f2b>] kzalloc_node include/linux/slab.h:725 [inline]
    [<ffffffff822c3f2b>] blk_mq_init_tags+0x4b/0xc0 block/blk-mq-tag.c:578
    [<ffffffff822ba7ba>] blk_mq_alloc_rq_map+0xea/0x1a0 block/blk-mq.c:3168
    [<ffffffff822bf686>] blk_mq_alloc_map_and_rqs+0x26/0xb0 block/blk-mq.c:3619
    [<ffffffff822c6f37>] blk_mq_sched_alloc_map_and_rqs block/blk-mq-sched.c:507 [inline]
    [<ffffffff822c6f37>] blk_mq_init_sched+0x127/0x2e0 block/blk-mq-sched.c:587
    [<ffffffff822a2f69>] elevator_init_mq+0x1f9/0x240 block/elevator.c:709
    [<ffffffff822cabad>] device_add_disk+0x4d/0x520 block/genhd.c:425
    [<ffffffff82833357>] sd_probe+0x457/0x670 drivers/scsi/sd.c:3475
    [<ffffffff826fce97>] call_driver_probe drivers/base/dd.c:541 [inline]
    [<ffffffff826fce97>] really_probe.part.0+0xe7/0x310 drivers/base/dd.c:620
    [<ffffffff826fd1cc>] really_probe drivers/base/dd.c:582 [inline]
    [<ffffffff826fd1cc>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:751
    [<ffffffff826fd2ca>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:781
    [<ffffffff826fdb36>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:898
    [<ffffffff826fa037>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427
    [<ffffffff826fc6bf>] __device_attach_async_helper+0xcf/0x110 drivers/base/dd.c:927
    [<ffffffff8127ce74>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b28f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2289
    [<ffffffff8126bbb9>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2436

BUG: memory leak
unreferenced object 0xffff888109d6da00 (size 128):
  comm "kworker/u4:2", pid 53, jiffies 4294997418 (age 21.330s)
  hex dump (first 32 bytes):
    03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814a70de>] kmalloc_node include/linux/slab.h:604 [inline]
    [<ffffffff814a70de>] kvmalloc_node+0x3e/0x130 mm/util.c:580
    [<ffffffff8240fbee>] kvzalloc_node include/linux/slab.h:735 [inline]
    [<ffffffff8240fbee>] sbitmap_init_node+0xde/0x2d0 lib/sbitmap.c:113
    [<ffffffff8241045c>] sbitmap_queue_init_node+0x3c/0x1f0 lib/sbitmap.c:428
    [<ffffffff822c3e47>] bt_alloc block/blk-mq-tag.c:543 [inline]
    [<ffffffff822c3e47>] blk_mq_init_bitmaps+0x57/0xf0 block/blk-mq-tag.c:555
    [<ffffffff822c3f68>] blk_mq_init_tags+0x88/0xc0 block/blk-mq-tag.c:586
    [<ffffffff822ba7ba>] blk_mq_alloc_rq_map+0xea/0x1a0 block/blk-mq.c:3168
    [<ffffffff822bf686>] blk_mq_alloc_map_and_rqs+0x26/0xb0 block/blk-mq.c:3619
    [<ffffffff822c6f37>] blk_mq_sched_alloc_map_and_rqs block/blk-mq-sched.c:507 [inline]
    [<ffffffff822c6f37>] blk_mq_init_sched+0x127/0x2e0 block/blk-mq-sched.c:587
    [<ffffffff822a2f69>] elevator_init_mq+0x1f9/0x240 block/elevator.c:709
    [<ffffffff822cabad>] device_add_disk+0x4d/0x520 block/genhd.c:425
    [<ffffffff82833357>] sd_probe+0x457/0x670 drivers/scsi/sd.c:3475
    [<ffffffff826fce97>] call_driver_probe drivers/base/dd.c:541 [inline]
    [<ffffffff826fce97>] really_probe.part.0+0xe7/0x310 drivers/base/dd.c:620
    [<ffffffff826fd1cc>] really_probe drivers/base/dd.c:582 [inline]
    [<ffffffff826fd1cc>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:751
    [<ffffffff826fd2ca>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:781
    [<ffffffff826fdb36>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:898
    [<ffffffff826fa037>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427

BUG: memory leak
unreferenced object 0xffff88810c0e1600 (size 512):
  comm "kworker/u4:2", pid 53, jiffies 4294997418 (age 21.330s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    10 16 0e 0c 81 88 ff ff 10 16 0e 0c 81 88 ff ff  ................
  backtrace:
    [<ffffffff82410528>] kmalloc_node include/linux/slab.h:599 [inline]
    [<ffffffff82410528>] kzalloc_node include/linux/slab.h:725 [inline]
    [<ffffffff82410528>] sbitmap_queue_init_node+0x108/0x1f0 lib/sbitmap.c:438
    [<ffffffff822c3e47>] bt_alloc block/blk-mq-tag.c:543 [inline]
    [<ffffffff822c3e47>] blk_mq_init_bitmaps+0x57/0xf0 block/blk-mq-tag.c:555
    [<ffffffff822c3f68>] blk_mq_init_tags+0x88/0xc0 block/blk-mq-tag.c:586
    [<ffffffff822ba7ba>] blk_mq_alloc_rq_map+0xea/0x1a0 block/blk-mq.c:3168
    [<ffffffff822bf686>] blk_mq_alloc_map_and_rqs+0x26/0xb0 block/blk-mq.c:3619
    [<ffffffff822c6f37>] blk_mq_sched_alloc_map_and_rqs block/blk-mq-sched.c:507 [inline]
    [<ffffffff822c6f37>] blk_mq_init_sched+0x127/0x2e0 block/blk-mq-sched.c:587
    [<ffffffff822a2f69>] elevator_init_mq+0x1f9/0x240 block/elevator.c:709
    [<ffffffff822cabad>] device_add_disk+0x4d/0x520 block/genhd.c:425
    [<ffffffff82833357>] sd_probe+0x457/0x670 drivers/scsi/sd.c:3475
    [<ffffffff826fce97>] call_driver_probe drivers/base/dd.c:541 [inline]
    [<ffffffff826fce97>] really_probe.part.0+0xe7/0x310 drivers/base/dd.c:620
    [<ffffffff826fd1cc>] really_probe drivers/base/dd.c:582 [inline]
    [<ffffffff826fd1cc>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:751
    [<ffffffff826fd2ca>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:781
    [<ffffffff826fdb36>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:898
    [<ffffffff826fa037>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427
    [<ffffffff826fc6bf>] __device_attach_async_helper+0xcf/0x110 drivers/base/dd.c:927
    [<ffffffff8127ce74>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127

write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
executing program
executing program
executing program
executing program
executing program
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory

