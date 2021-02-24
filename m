Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6867AC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 18:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 207D964F0B
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 18:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234498AbhBXSzf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 13:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235617AbhBXSyr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 13:54:47 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF367C06174A;
        Wed, 24 Feb 2021 10:54:01 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id v22so3824158edx.13;
        Wed, 24 Feb 2021 10:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8PICk5tpw0y1zvTDynLhN5NoJV1yk+g6TjhaESxmI00=;
        b=L9frWbOKqfq0l+A5akS5xX0MZfe8OgxgeVrSpm0KzP0//kkvRPeXZUKoq8PyEKKeby
         S/Oe3+KmhquSJCvfAn7MnF4YxEhAm8/uTnegbCEeop83fkAooQQqXSPmrP0xpG76atJw
         EUOZERKo3fwpk+KMKoEAli+vyhFRz1A9ufhqcKv0k4iy8QZXZVHsdBqdx41LAgqiV5QO
         Du3+1g1TduewSPnwmDkP7mkewTzDVyQcIggDNBGahqEFRfZOLA8h/1KEHzwEODNoPbum
         MzdDfMdjHZ2MaH1GDwWiDekw71LOVlZm2Dp4jRVMFTvi7NMOXGMIpi/CGRGkxWByU8HK
         Bq5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8PICk5tpw0y1zvTDynLhN5NoJV1yk+g6TjhaESxmI00=;
        b=svjePY+QV3Zo3XcpJiOdu0pT8OQUVkZVemfGtS8n5L3hyk/yB8HvTv1MnEMXSfz1Wv
         lzs+GkuoO50jgusrgzBLnJD6sH75xPCQgKno9KT9jJgTac6zRr9xpjKxEuvQ/nIWtlOj
         FcZXQcFGMheQTvABgqdoFZCzKCrZjvWnL8PMW227B/dK7A6gnA5V1uf0VXaZjeTy0aA6
         sDA3DQKvEJRf52SUKfXtuZCs9IBPqwUObdyUxQtshVEBLmm2oPMpoQ0SnAGnxpLewNwN
         i7i/BoDMFY3xSh/GfHNsEt1A2UnQWXZkGKxvIOFkCzN5u/m8UlfhumStlQf94qMcbev6
         Oykg==
X-Gm-Message-State: AOAM530+p4LijnZSEps+/3UaEi4rELIbfWpyYPlKLYMuHVKHerSQ681K
        hVPWo0z1NRRPRfuJAX2MkLylr3fKNYE=
X-Google-Smtp-Source: ABdhPJxbqfIljt+3BfqyC+kglnnPKSicOOLyc8JociyNNkmjXLiDElcuxfTAnQi0V4b7RM1nU1ucpg==
X-Received: by 2002:a50:ee16:: with SMTP id g22mr36368209eds.235.1614192840803;
        Wed, 24 Feb 2021 10:54:00 -0800 (PST)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id cz28sm2111515edb.22.2021.02.24.10.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 10:54:00 -0800 (PST)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH 2/2] scsi: target: tcmu: Replace radix_tree with XArray
Date:   Wed, 24 Feb 2021 19:53:35 +0100
Message-Id: <20210224185335.13844-3-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210224185335.13844-1-bostroesser@gmail.com>
References: <20210224185335.13844-1-bostroesser@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An attempt from Matthew Wilcox to replace radix-tree usage by
XArray in tcmu more than 1 year ago unfortunately got lost.

I rebased that work on latest tcmu and tested it.

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 drivers/target/target_core_user.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 1fbfb307d5e5..067e00e37673 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -14,7 +14,6 @@
 #include <linux/vmalloc.h>
 #include <linux/uio_driver.h>
 #include <linux/xarray.h>
-#include <linux/radix-tree.h>
 #include <linux/stringify.h>
 #include <linux/bitops.h>
 #include <linux/highmem.h>
@@ -143,7 +142,7 @@ struct tcmu_dev {
 	uint32_t dbi_max;
 	uint32_t dbi_thresh;
 	unsigned long *data_bitmap;
-	struct radix_tree_root data_blocks;
+	struct xarray data_blocks;
 
 	struct xarray commands;
 
@@ -500,13 +499,13 @@ static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
 				       int prev_dbi, int *iov_cnt)
 {
 	struct page *page;
-	int ret, dbi;
+	int dbi;
 
 	dbi = find_first_zero_bit(udev->data_bitmap, udev->dbi_thresh);
 	if (dbi == udev->dbi_thresh)
 		return -1;
 
-	page = radix_tree_lookup(&udev->data_blocks, dbi);
+	page = xa_load(&udev->data_blocks, dbi);
 	if (!page) {
 		if (atomic_add_return(1, &global_db_count) >
 				      tcmu_global_max_blocks)
@@ -517,8 +516,7 @@ static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
 		if (!page)
 			goto err_alloc;
 
-		ret = radix_tree_insert(&udev->data_blocks, dbi, page);
-		if (ret)
+		if (xa_store(&udev->data_blocks, dbi, page, GFP_KERNEL))
 			goto err_insert;
 	}
 
@@ -557,7 +555,7 @@ static int tcmu_get_empty_blocks(struct tcmu_dev *udev,
 static inline struct page *
 tcmu_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
 {
-	return radix_tree_lookup(&udev->data_blocks, dbi);
+	return xa_load(&udev->data_blocks, dbi);
 }
 
 static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
@@ -1561,7 +1559,7 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	timer_setup(&udev->qfull_timer, tcmu_qfull_timedout, 0);
 	timer_setup(&udev->cmd_timer, tcmu_cmd_timedout, 0);
 
-	INIT_RADIX_TREE(&udev->data_blocks, GFP_KERNEL);
+	xa_init(&udev->data_blocks);
 
 	return &udev->se_dev;
 }
@@ -1585,19 +1583,19 @@ static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
 	return -EINVAL;
 }
 
-static void tcmu_blocks_release(struct radix_tree_root *blocks,
-				int start, int end)
+static void tcmu_blocks_release(struct xarray *blocks, unsigned long first,
+				unsigned long last)
 {
-	int i;
+	XA_STATE(xas, blocks, first);
 	struct page *page;
 
-	for (i = start; i < end; i++) {
-		page = radix_tree_delete(blocks, i);
-		if (page) {
-			__free_page(page);
-			atomic_dec(&global_db_count);
-		}
+	xas_lock(&xas);
+	xas_for_each(&xas, page, last) {
+		xas_store(&xas, NULL);
+		__free_page(page);
+		atomic_dec(&global_db_count);
 	}
+	xas_unlock(&xas);
 }
 
 static void tcmu_remove_all_queued_tmr(struct tcmu_dev *udev)
@@ -2923,7 +2921,7 @@ static void find_free_blocks(void)
 		unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
 
 		/* Release the block pages */
-		tcmu_blocks_release(&udev->data_blocks, start, end);
+		tcmu_blocks_release(&udev->data_blocks, start, end - 1);
 		mutex_unlock(&udev->cmdr_lock);
 
 		total_freed += end - start;
-- 
2.12.3

