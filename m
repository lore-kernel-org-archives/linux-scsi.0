Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F336C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 07:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1385F60F8F
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 07:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhJIHlu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Oct 2021 03:41:50 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:28902 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhJIHlt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2021 03:41:49 -0400
Received: from dggeme754-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HRH0G1SvKzbmkP;
        Sat,  9 Oct 2021 15:35:26 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggeme754-chm.china.huawei.com
 (10.3.19.100) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Sat, 9 Oct
 2021 15:39:50 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH v2 2/2] scsi:scsi_debug:Fix out-of-bound read in resp_report_tgtpgs
Date:   Sat, 9 Oct 2021 15:52:31 +0800
Message-ID: <20211009075231.2489878-3-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211009075231.2489878-1-yebin10@huawei.com>
References: <20211009075231.2489878-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme754-chm.china.huawei.com (10.3.19.100)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We got follow issue when run syzkaller:
BUG: KASAN: slab-out-of-bounds in memcpy include/linux/string.h:377 [inline]
BUG: KASAN: slab-out-of-bounds in sg_copy_buffer+0x150/0x1c0 lib/scatterlist.c:831
Read of size 2132 at addr ffff8880aea95dc8 by task syz-executor.0/9815

CPU: 0 PID: 9815 Comm: syz-executor.0 Not tainted 4.19.202-00874-gfc0fe04215a9 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xe4/0x14a lib/dump_stack.c:118
 print_address_description+0x73/0x280 mm/kasan/report.c:253
 kasan_report_error mm/kasan/report.c:352 [inline]
 kasan_report+0x272/0x370 mm/kasan/report.c:410
 memcpy+0x1f/0x50 mm/kasan/kasan.c:302
 memcpy include/linux/string.h:377 [inline]
 sg_copy_buffer+0x150/0x1c0 lib/scatterlist.c:831
 fill_from_dev_buffer+0x14f/0x340 drivers/scsi/scsi_debug.c:1021
 resp_report_tgtpgs+0x5aa/0x770 drivers/scsi/scsi_debug.c:1772
 schedule_resp+0x464/0x12f0 drivers/scsi/scsi_debug.c:4429
 scsi_debug_queuecommand+0x467/0x1390 drivers/scsi/scsi_debug.c:5835
 scsi_dispatch_cmd+0x3fc/0x9b0 drivers/scsi/scsi_lib.c:1896
 scsi_request_fn+0x1042/0x1810 drivers/scsi/scsi_lib.c:2034
 __blk_run_queue_uncond block/blk-core.c:464 [inline]
 __blk_run_queue+0x1a4/0x380 block/blk-core.c:484
 blk_execute_rq_nowait+0x1c2/0x2d0 block/blk-exec.c:78
 sg_common_write.isra.19+0xd74/0x1dc0 drivers/scsi/sg.c:847
 sg_write.part.23+0x6e0/0xd00 drivers/scsi/sg.c:716
 sg_write+0x64/0xa0 drivers/scsi/sg.c:622
 __vfs_write+0xed/0x690 fs/read_write.c:485
kill_bdev:block_device:00000000e138492c
 vfs_write+0x184/0x4c0 fs/read_write.c:549
 ksys_write+0x107/0x240 fs/read_write.c:599
 do_syscall_64+0xc2/0x560 arch/x86/entry/common.c:293
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

 As with previous patch, we get 'alen' from command, and 'alen''s type is
 int, If userspace pass large length we will get negative 'alen'.
 So just set 'n'/'alen'/'rlen' with u32 type.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/scsi_debug.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index be0440545744..ead65cdfb522 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1896,8 +1896,9 @@ static int resp_report_tgtpgs(struct scsi_cmnd *scp,
 	unsigned char *cmd = scp->cmnd;
 	unsigned char *arr;
 	int host_no = devip->sdbg_host->shost->host_no;
-	int n, ret, alen, rlen;
 	int port_group_a, port_group_b, port_a, port_b;
+	u32 alen, n, rlen;
+	int ret;
 
 	alen = get_unaligned_be32(cmd + 6);
 	arr = kzalloc(SDEBUG_MAX_TGTPGS_ARR_SZ, GFP_ATOMIC);
@@ -1959,9 +1960,9 @@ static int resp_report_tgtpgs(struct scsi_cmnd *scp,
 	 * - The constructed command length
 	 * - The maximum array size
 	 */
-	rlen = min_t(int, alen, n);
+	rlen = min(alen, n);
 	ret = fill_from_dev_buffer(scp, arr,
-			   min_t(int, rlen, SDEBUG_MAX_TGTPGS_ARR_SZ));
+			   min_t(u32, rlen, SDEBUG_MAX_TGTPGS_ARR_SZ));
 	kfree(arr);
 	return ret;
 }
-- 
2.31.1

