Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB59C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 06:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEF1761406
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 06:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhEOGvX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 May 2021 02:51:23 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:41655 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbhEOGvV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 May 2021 02:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621061409; x=1652597409;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=G115ED+d704BCp60dpowxTlv7ZZmS8X6WASF0DZ+X+w=;
  b=YsYVTfIcTtiOIpfbbntozd0jvs8taNkEF/08zNX9VAgUepg8o/7gS0nX
   1kk+vIS8WtdB728tkQcPkYChbmLUXGao695KkU07gt+1afjnHl1YgQ7L4
   3OFVRGX6EaSYAeOWeobEReNsQdPkKvQ6eFHk0ZLKT5j2k+D26xWZFaOdx
   Qqkm6N4wwsND/ytTwkM88TsOcjLvIJ3GWrOJppBy0i8fn1f0QCVb7Z69z
   fsdByBxFx5PMU6fY1iChbkGLukUH58Fw6kZJQ3hjPAzUqPIra50Y6Lu5Z
   YEZwr3kU8CjBmvc2TkVOiAnHO+22EcZwn2Y2qFLZi5MTmPxTYVi8XABXT
   Q==;
IronPort-SDR: j82kRRuHZocKQYiPZneYYGoOIPVoETukJbPWkOtHI+ywP2RDrEBfJZXs96Lr6RplGa3RZAdtvL
 x76siOOI0bAyx3Nv4ctPMHGQr5GmWJqylS1N6Q4Wbnj7vz8TkdOuuHiE1IzwvSAXWwQtlKk8lb
 CNV6+/+pvlOKE5PGuLDf3CJ39kpH0CfvGYHSwwMMZsnxK5PhSj9TnlRVDyQaVRHl9W/TcmwHZ5
 JlS9o0yJEqnxY2c0eQgeJ9a+NEzpW2Ey7T9qzwCCQS0s45kZn4lp0fjZNgepiVC+A5wEOrqpMC
 6Go=
X-IronPort-AV: E=Sophos;i="5.82,301,1613404800"; 
   d="scan'208";a="279484628"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2021 14:50:08 +0800
IronPort-SDR: XnEkvGVv4xIp5jPPI48vx8mo3ijo9UwOaUNq2cjXJAiIHTa2Acc4QSMd2hYcATcmzljybkSo6u
 PWpqK3Q7NpG+b/gMLTlEd0B/+yHNR9mS3m/dz8wCSnYdsN+KbKsundh9HgaOuBxhMv3hMFIOEk
 oplk4OB6qts6gbBWIT75Qz0pT1ODq6A7L2iDp3qokzZBLHc1u1gFbk6K8zywM7KYsZ2FrTbFzA
 nOr+6UbyuDF/hopYk+YW85OT8FIst6/VfeouZ35fOp8d4J3Nd61ezn83SRfFFjrVtpmKcFQL1I
 P5+cunt/mH4mxvJQLMx5RvlN
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 23:28:38 -0700
IronPort-SDR: yKprFtRKzOTKk5xIU9MBwSL51m3n5/vqAlZOeL9e67Y85hmhn03MMj4Q56NRwlMHxHOjtiHunw
 oLYAbG1tFmnEDfcwJU/DGYkl+D3p2uahjgdIStloEgYOmdrifw5Fb6stRR7FlBe+plrtbw389q
 VI94IfLyU/XZpiI0n3nJFbPq+G9/9DyS+8CZ89T/RhnTCwYd5klNMUQZ83PbLG9hBYKjqtkl0r
 ZcafSD9JmM8rbTTQ6RrDldYu52UmKAFX5vGlZCsSniW2t+swxHAlpA0DKb34zRHs3cva+28oJx
 7nk=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 May 2021 23:50:08 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Bodo Stroesser <bostroesser@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2] scsi: target: tcmu: Fix xarray RCU warning
Date:   Sat, 15 May 2021 15:50:06 +0900
Message-Id: <20210515065006.210238-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE = N *
PAGE_SIZE") introduced xas_next() calls to iterate xarray elements.
These calls triggered the WARNING "suspicious RCU usage" at tcmu device
set up [1]. In the call stack of xas_next(), xas_load() was called.
According to its comment, this function requires "the xa_lock or the RCU
lock".

To avoid the warning, guard xas_next() calls. For the small loop of
xas_next(), guard with the RCU lock. For the large loop of xas_next(),
guard with the xa_lock using xas_lock().

[1]

[ 1899.867091] =============================
[ 1899.871199] WARNING: suspicious RCU usage
[ 1899.875310] 5.13.0-rc1+ #41 Not tainted
[ 1899.879222] -----------------------------
[ 1899.883299] include/linux/xarray.h:1182 suspicious rcu_dereference_check() usage!
[ 1899.890940] other info that might help us debug this:
[ 1899.899082] rcu_scheduler_active = 2, debug_locks = 1
[ 1899.905719] 3 locks held by kworker/0:1/1368:
[ 1899.910161]  #0: ffffa1f8c8b98738 ((wq_completion)target_submission){+.+.}-{0:0}, at: process_one_work+0x1ee/0x580
[ 1899.920732]  #1: ffffbd7040cd7e78 ((work_completion)(&q->sq.work)){+.+.}-{0:0}, at: process_one_work+0x1ee/0x580
[ 1899.931146]  #2: ffffa1f8d1c99768 (&udev->cmdr_lock){+.+.}-{3:3}, at: tcmu_queue_cmd+0xea/0x160 [target_core_user]
[ 1899.941678] stack backtrace:
[ 1899.946093] CPU: 0 PID: 1368 Comm: kworker/0:1 Not tainted 5.13.0-rc1+ #41
[ 1899.953070] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 1302 03/15/2018
[ 1899.962459] Workqueue: target_submission target_queued_submit_work [target_core_mod]
[ 1899.970337] Call Trace:
[ 1899.972839]  dump_stack+0x6d/0x89
[ 1899.976222]  xas_descend+0x10e/0x120
[ 1899.979875]  xas_load+0x39/0x50
[ 1899.983077]  tcmu_get_empty_blocks+0x115/0x1c0 [target_core_user]
[ 1899.989318]  queue_cmd_ring+0x1da/0x630 [target_core_user]
[ 1899.994897]  ? rcu_read_lock_sched_held+0x3f/0x70
[ 1899.999695]  ? trace_kmalloc+0xa6/0xd0
[ 1900.003501]  ? __kmalloc+0x205/0x380
[ 1900.007167]  tcmu_queue_cmd+0x12f/0x160 [target_core_user]
[ 1900.012746]  __target_execute_cmd+0x23/0xa0 [target_core_mod]
[ 1900.018589]  transport_generic_new_cmd+0x1f3/0x370 [target_core_mod]
[ 1900.025046]  transport_handle_cdb_direct+0x34/0x50 [target_core_mod]
[ 1900.031517]  target_queued_submit_work+0x43/0xe0 [target_core_mod]
[ 1900.037837]  process_one_work+0x268/0x580
[ 1900.041952]  ? process_one_work+0x580/0x580
[ 1900.046195]  worker_thread+0x55/0x3b0
[ 1900.049921]  ? process_one_work+0x580/0x580
[ 1900.054192]  kthread+0x143/0x160
[ 1900.057499]  ? kthread_create_worker_on_cpu+0x40/0x40
[ 1900.062661]  ret_from_fork+0x1f/0x30

Fixes: f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE = N * PAGE_SIZE")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
Changes from v1:
* Used xas_(un)lock() instead of rcu_read_(un)lock() for the large loop

 drivers/target/target_core_user.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 198d25ae482a..834bd3910de8 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -516,8 +516,10 @@ static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
 	dpi = dbi * udev->data_pages_per_blk;
 	/* Count the number of already allocated pages */
 	xas_set(&xas, dpi);
+	rcu_read_lock();
 	for (cnt = 0; xas_next(&xas) && cnt < page_cnt;)
 		cnt++;
+	rcu_read_unlock();
 
 	for (i = cnt; i < page_cnt; i++) {
 		/* try to get new page from the mm */
@@ -727,6 +729,7 @@ static inline void tcmu_copy_data(struct tcmu_dev *udev,
 			page_cnt = udev->data_pages_per_blk;
 
 		xas_set(&xas, dbi * udev->data_pages_per_blk);
+		xas_lock(&xas);
 		for (page_inx = 0; page_inx < page_cnt && data_len; page_inx++) {
 			page = xas_next(&xas);
 
@@ -763,6 +766,7 @@ static inline void tcmu_copy_data(struct tcmu_dev *udev,
 			if (direction == TCMU_SG_TO_DATA_AREA)
 				flush_dcache_page(page);
 		}
+		xas_unlock(&xas);
 	}
 }
 
-- 
2.31.1

