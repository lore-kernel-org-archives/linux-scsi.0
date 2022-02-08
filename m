Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D9EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 06:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347592AbiBHGhT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 01:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347556AbiBHGhQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 01:37:16 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D780C0401EF;
        Mon,  7 Feb 2022 22:37:13 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V3vFgFf_1644302228;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V3vFgFf_1644302228)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Feb 2022 14:37:09 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, bostroesser@gmail.com,
        kanie@linux.alibaba.com
Subject: [PATCH 2/2] scsi: target: tcm_loop: use scsi_done_direct()
Date:   Tue,  8 Feb 2022 14:37:07 +0800
Message-Id: <20220208063707.4781-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20220208063707.4781-1-xiaoguang.wang@linux.alibaba.com>
References: <20220208063707.4781-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tcm_loop uses workqueue to end requests, which is non-interrupt context,
then we can complete request directly instead deferring it to softirq.
The call graph likes below:
    blk_mq_complete_request_remote+1
    blk_mq_complete_request+14
    target_put_sess_cmd+294
    transport_generic_free_cmd+93
    target_complete_ok_work+251
    process_one_work+482
    worker_thread+80
    kthread+361
    ret_from_fork+31

Use tcm_loop and tcmu(backstore is file) to evaluate performance, fio
job:
  [global]
  filename=/dev/sdb
  direct=1
  runtime=30
  thread=1
  norandommap=1
  time_based
  numjobs=1
  rw=randread
  iodepth=32
  ioengine=libaio

Without this patch:
bs 4k
  READ: bw=319MiB/s (334MB/s), 319MiB/s-319MiB/s (334MB/s-334MB/s),
io=9563MiB (10.0GB), run=30001-30001msec

bs 8k:
   READ: bw=611MiB/s (641MB/s), 611MiB/s-611MiB/s (641MB/s-641MB/s),
io=17.9GiB (19.2GB), run=30001-30001msec

bs 16k:
   READ: bw=1109MiB/s (1163MB/s), 1109MiB/s-1109MiB/s (1163MB/s-1163MB/s),
io=32.5GiB (34.9GB), run=30001-30001msec

bs 32k:
   READ: bw=2200MiB/s (2306MB/s), 2200MiB/s-2200MiB/s (2306MB/s-2306MB/s),
io=64.4GiB (69.2GB), run=30001-30001msec

With this patch:
bs 4k:
   READ: bw=344MiB/s (361MB/s), 344MiB/s-344MiB/s (361MB/s-361MB/s),
io=10.1GiB (10.8GB), run=30001-30001msec

bs 8k:
   READ: bw=651MiB/s (682MB/s), 651MiB/s-651MiB/s (682MB/s-682MB/s),
io=19.1GiB (20.5GB), run=30001-30001msec

bs 16k:
   READ: bw=1248MiB/s (1308MB/s), 1248MiB/s-1248MiB/s (1308MB/s-1308MB/s),
io=36.6GiB (39.3GB), run=30001-30001msec

bs 32k:
   READ: bw=2456MiB/s (2576MB/s), 2456MiB/s-2456MiB/s (2576MB/s-2576MB/s),
io=71.0GiB (77.3GB), run=30001-30001msec

We can get throughput improvement.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 drivers/target/loopback/tcm_loop.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 4407b56aa6d1..ce414fbdbae6 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -70,8 +70,12 @@ static void tcm_loop_release_cmd(struct se_cmd *se_cmd)
 
 	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
 		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
-	else
-		scsi_done(sc);
+	else {
+		if (unlikely(in_interrupt()))
+			scsi_done(sc);
+		else
+			scsi_done_direct(sc);
+	}
 }
 
 static int tcm_loop_show_info(struct seq_file *m, struct Scsi_Host *host)
-- 
2.14.4.44.g2045bb6

