Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C13CC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 13:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47C026108D
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 13:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241528AbhESN4U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 09:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241071AbhESN4T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 09:56:19 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A6CC06175F;
        Wed, 19 May 2021 06:54:59 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id s22so19886460ejv.12;
        Wed, 19 May 2021 06:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ca29eW0paaI5oHeLYHIRQELkdNdJWMdtnbA9Gd8Xw00=;
        b=XQ5520VfYPS4uhfAsKV4HmyAQSQ2tCZn/sk6OYgHqfM4Nlhqhl1FZ6CJqAPU4kaWV/
         xDI3pyXdpSn+S+4ORx6MC+O0ahuQmTMbjs9QteQI8kd3bzcP2s9PfPPKYU8q3sK+Rk/J
         7Lyra6HMchKMZwGh472YMsOP1fvhKRsgPXXDZGt0lQxjKQPPxg3oaneO/DIsjYbmT752
         hwga9bO5A8iAPhKslG5GKNARqPKBL8VD2NihcSl/Dw30ynH62/bCIVbGmvtG5lfy5dNH
         VouOr9/6sG2Gp2JbZopLHC9Y+YEWFWGMAYe5f3DYu9agudiHC7jIsCPXCqKgbVRyi5aP
         5Okg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ca29eW0paaI5oHeLYHIRQELkdNdJWMdtnbA9Gd8Xw00=;
        b=sg39cgJnWfEDCJvks9Gnl/c6a3Oyk1+XmZ/b7aczxRw3fSB9l2U9NmSvo7Ic64mjSt
         wfV/W0SHnS0RCmFMuMyWJKwlEUZxUZrIywumdDinZNJ+p/n5ORLUUl1P8zau94VfGnG4
         oeYvbX81q4fLKDSGyay+fbbSbEvxuFkPnXjfk79O3IFJcAQy3VcGCn5Y5D17Z86owISg
         bE50nSdU5i0DiCiheenOXP+BjMfFQZMdpyXUiElspVV5mv2k/KBfMx775xlJJbiVc2rj
         x5BAhNIegMus8w8wKsnjqBKCFM6qk6nDgDQTjgXQZ4ud1klQWrqQmbRgN0PgZ24dut1M
         15Fg==
X-Gm-Message-State: AOAM53302xeec3A3rfwa1H/tEHxeXABns04ATKwLGItCpu79/gqOL0Sn
        PtRztF5Qix3oy4S0y8FCU/+G5pGiutg=
X-Google-Smtp-Source: ABdhPJw90icdxURIyfOXsBdOpCjY8EyoMrPjfecTcJy9RD9i2aWK7vHAvw2zezBBpWpHNDW0AnwNdg==
X-Received: by 2002:a17:906:5495:: with SMTP id r21mr13066604ejo.471.1621432498567;
        Wed, 19 May 2021 06:54:58 -0700 (PDT)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id g21sm3081341edb.92.2021.05.19.06.54.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 06:54:57 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: [PATCH v3] scsi: target: tcmu: Fix xarray RCU warning
Date:   Wed, 19 May 2021 15:54:40 +0200
Message-Id: <20210519135440.26773-1-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE = N *
PAGE_SIZE") introduced xas_next() calls to iterate xarray elements.
These calls triggered the WARNING "suspicious RCU usage" at tcmu device
set up [1]. In the call stack of xas_next(), xas_load() was called.
According to its comment, this function requires "the xa_lock or the RCU
lock".

To avoid the warning
 - guard the small loop calling xas_next() in tcmu_get_empty_block with
   RCU lock
 - In the large loop in tcmu_copy_data using RCU lock would possibly
   disable preemtion for a long time (copy multi MBs). Therefore replace
   XA_STATE, xas_set and xas_next with a single xa_load.

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
Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
Changes from v2:
* In the large loop of tcmu_copy_data use xa_load instead of xas_*.

Changes from v1:
* Used xas_(un)lock() instead of rcu_read_(un)lock() for the large loop
---
 drivers/target/target_core_user.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9866d7b49ab8..806f64a6a779 100644
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
@@ -699,11 +701,10 @@ static inline void tcmu_copy_data(struct tcmu_dev *udev,
 				  struct scatterlist *sg, unsigned int sg_nents,
 				  struct iovec **iov, size_t data_len)
 {
-	XA_STATE(xas, &udev->data_pages, 0);
 	/* start value of dbi + 1 must not be a valid dbi */
 	int dbi = -2;
 	size_t page_remaining, cp_len;
-	int page_cnt, page_inx;
+	int page_cnt, page_inx, dpi;
 	struct sg_mapping_iter sg_iter;
 	unsigned int sg_flags;
 	struct page *page;
@@ -726,9 +727,10 @@ static inline void tcmu_copy_data(struct tcmu_dev *udev,
 		if (page_cnt > udev->data_pages_per_blk)
 			page_cnt = udev->data_pages_per_blk;
 
-		xas_set(&xas, dbi * udev->data_pages_per_blk);
-		for (page_inx = 0; page_inx < page_cnt && data_len; page_inx++) {
-			page = xas_next(&xas);
+		dpi = dbi * udev->data_pages_per_blk;
+		for (page_inx = 0; page_inx < page_cnt && data_len;
+		     page_inx++, dpi++) {
+			page = xa_load(&udev->data_pages, dpi);
 
 			if (direction == TCMU_DATA_AREA_TO_SG)
 				flush_dcache_page(page);
-- 
2.12.3

