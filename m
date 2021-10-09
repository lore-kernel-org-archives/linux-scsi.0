Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F133CC433FE
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 07:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D474260F94
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 07:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbhJIHlt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Oct 2021 03:41:49 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24181 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbhJIHls (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2021 03:41:48 -0400
Received: from dggeme754-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HRH3Z5XLvz1DHKF;
        Sat,  9 Oct 2021 15:38:18 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggeme754-chm.china.huawei.com
 (10.3.19.100) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Sat, 9 Oct
 2021 15:39:50 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH v2 1/2]  scsi:scsi_debug: Fix out-of-bound read in resp_readcap16
Date:   Sat, 9 Oct 2021 15:52:30 +0800
Message-ID: <20211009075231.2489878-2-yebin10@huawei.com>
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

We got following warning when runing syzkaller:
[ 3813.830724] sg_write: data in/out 65466/242 bytes for SCSI command 0x9e-- guessing data in;
[ 3813.830724]    program syz-executor not setting count and/or reply_len properly
[ 3813.836956] ==================================================================
[ 3813.839465] BUG: KASAN: stack-out-of-bounds in sg_copy_buffer+0x157/0x1e0
[ 3813.841773] Read of size 4096 at addr ffff8883cf80f540 by task syz-executor/1549
[ 3813.846612] Call Trace:
[ 3813.846995]  dump_stack+0x108/0x15f
[ 3813.847524]  print_address_description+0xa5/0x372
[ 3813.848243]  kasan_report.cold+0x236/0x2a8
[ 3813.849439]  check_memory_region+0x240/0x270
[ 3813.850094]  memcpy+0x30/0x80
[ 3813.850553]  sg_copy_buffer+0x157/0x1e0
[ 3813.853032]  sg_copy_from_buffer+0x13/0x20
[ 3813.853660]  fill_from_dev_buffer+0x135/0x370
[ 3813.854329]  resp_readcap16+0x1ac/0x280
[ 3813.856917]  schedule_resp+0x41f/0x1630
[ 3813.858203]  scsi_debug_queuecommand+0xb32/0x17e0
[ 3813.862699]  scsi_dispatch_cmd+0x330/0x950
[ 3813.863329]  scsi_request_fn+0xd8e/0x1710
[ 3813.863946]  __blk_run_queue+0x10b/0x230
[ 3813.864544]  blk_execute_rq_nowait+0x1d8/0x400
[ 3813.865220]  sg_common_write.isra.0+0xe61/0x2420
[ 3813.871637]  sg_write+0x6c8/0xef0
[ 3813.878853]  __vfs_write+0xe4/0x800
[ 3813.883487]  vfs_write+0x17b/0x530
[ 3813.884008]  ksys_write+0x103/0x270
[ 3813.886268]  __x64_sys_write+0x77/0xc0
[ 3813.886841]  do_syscall_64+0x106/0x360
[ 3813.887415]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

We can reproduce this issue with following syzkaller log:
r0 = openat(0xffffffffffffff9c, &(0x7f0000000040)='./file0\x00', 0x26e1, 0x0)
r1 = syz_open_procfs(0xffffffffffffffff, &(0x7f0000000000)='fd/3\x00')
open_by_handle_at(r1, &(0x7f00000003c0)=ANY=[@ANYRESHEX], 0x602000)
r2 = syz_open_dev$sg(&(0x7f0000000000), 0x0, 0x40782)
write$binfmt_aout(r2, &(0x7f0000000340)=ANY=[@ANYBLOB="00000000deff000000000000000000000000000000000000000000000000000047f007af9e107a41ec395f1bded7be24277a1501ff6196a83366f4e6362bc0ff2b247f68a972989b094b2da4fb3607fcf611a22dd04310d28c75039d"], 0x126)

As in resp_readcap16 we get "int alloc_len" value -1104926854, and then pass
huge arr_len to fill_from_dev_buffer, but arr is only has 32 bytes space. So
lead to OOB in sg_copy_buffer.
To solve this issue just define alloc_len with U32 type.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/scsi_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 66f507469a31..be0440545744 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1856,7 +1856,7 @@ static int resp_readcap16(struct scsi_cmnd *scp,
 {
 	unsigned char *cmd = scp->cmnd;
 	unsigned char arr[SDEBUG_READCAP16_ARR_SZ];
-	int alloc_len;
+	u32 alloc_len;
 
 	alloc_len = get_unaligned_be32(cmd + 10);
 	/* following just in case virtual_gb changed */
@@ -1885,7 +1885,7 @@ static int resp_readcap16(struct scsi_cmnd *scp,
 	}
 
 	return fill_from_dev_buffer(scp, arr,
-			    min_t(int, alloc_len, SDEBUG_READCAP16_ARR_SZ));
+			    min_t(u32, alloc_len, SDEBUG_READCAP16_ARR_SZ));
 }
 
 #define SDEBUG_MAX_TGTPGS_ARR_SZ 1412
-- 
2.31.1

