Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9084C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 09:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD0BF611AD
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 09:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235442AbhIKJCi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Sep 2021 05:02:38 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9031 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbhIKJCh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Sep 2021 05:02:37 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H66CH3Bt2zVq0B;
        Sat, 11 Sep 2021 17:00:27 +0800 (CST)
Received: from dggpemm500004.china.huawei.com (7.185.36.219) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 11 Sep 2021 17:01:22 +0800
Received: from huawei.com (10.174.28.241) by dggpemm500004.china.huawei.com
 (7.185.36.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sat, 11 Sep
 2021 17:01:22 +0800
From:   Bixuan Cui <cuibixuan@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
CC:     <fujita.tomonori@lab.ntt.co.jp>, <axboe@kernel.dk>
Subject: [PATCH -next] scsi: bsg: Fix memory leak in bsg_register_queue()
Date:   Sat, 11 Sep 2021 16:57:26 +0800
Message-ID: <20210911085726.34778-1-cuibixuan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.28.241]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500004.china.huawei.com (7.185.36.219)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kmemleak tool detected a memory leak.

BUG: memory leak
unreferenced object 0xffff8881170da100 (size 32):
  comm "kworker/u4:4", pid 2996, jiffies 4294948956 (age 24.640s)
  hex dump (first 32 bytes):
    38 3a 30 3a 30 3a 31 00 00 00 00 00 00 00 00 00  8:0:0:1.........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8147fc76>] kstrdup+0x36/0x70 mm/util.c:60
    [<ffffffff8147fd03>] kstrdup_const+0x53/0x80 mm/util.c:83
    [<ffffffff82293362>] kvasprintf_const+0xc2/0x110 lib/kasprintf.c:48
    [<ffffffff8235545b>] kobject_set_name_vargs+0x3b/0xe0 lib/kobject.c:289
    [<ffffffff82652573>] dev_set_name+0x63/0x90 drivers/base/core.c:3147
    [<ffffffff822547d1>] bsg_register_queue+0xe1/0x1d0 block/bsg.c:201
    [<ffffffff82730abf>] scsi_sysfs_add_sdev+0x13f/0x380 drivers/scsi/scsi_sysfs.c:1376
    [<ffffffff8272e309>] scsi_sysfs_add_devices drivers/scsi/scsi_scan.c:1727 [inline]
    [<ffffffff8272e309>] scsi_finish_async_scan drivers/scsi/scsi_scan.c:1812 [inline]
    [<ffffffff8272e309>] do_scan_async+0x109/0x200 drivers/scsi/scsi_scan.c:1855
    [<ffffffff812752a4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff81263d1f>] process_one_work+0x2cf/0x620 kernel/workqueue.c:2297
    [<ffffffff81264629>] worker_thread+0x59/0x5d0 kernel/workqueue.c:2444
    [<ffffffff8126db28>] kthread+0x188/0x1d0 kernel/kthread.c:319
    [<ffffffff8100234f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The bsg_register_queue() use device_initialize() and dev_set_name() to
registe device. That way if it fails, call put_device() to clean up
correctly.

Reported-by: syzbot+cfe9b7cf55bb54ed4e57@syzkaller.appspotmail.com
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
---
 block/bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bsg.c b/block/bsg.c
index 351095193788..4d6803dad0b3 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -219,6 +219,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
 	cdev_device_del(&bd->cdev, &bd->device);
 out_ida_remove:
 	ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
+	put_device(&bd->device);
 out_kfree:
 	kfree(bd);
 	return ERR_PTR(ret);
-- 
2.17.1

