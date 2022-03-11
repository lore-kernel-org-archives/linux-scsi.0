Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A246C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Mar 2022 13:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347909AbiCKNXP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Mar 2022 08:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242718AbiCKNXN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2022 08:23:13 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AE21C3D08;
        Fri, 11 Mar 2022 05:22:10 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V6uG0iM_1647004927;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V6uG0iM_1647004927)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 11 Mar 2022 21:22:07 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     bostroesser@gmail.com
Subject: [PATCH 2/2] scsi: target: tcmu: Use address_space->invalidate_lock
Date:   Fri, 11 Mar 2022 21:22:06 +0800
Message-Id: <20220311132206.24515-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20220311132206.24515-1-xiaoguang.wang@linux.alibaba.com>
References: <20220311132206.24515-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently tcmu_vma_fault() uses udev->cmdr_lock to avoid concurrent
find_free_blocks(), which unmaps idle pages and truncates them. This
work is really like many filesystem's truncate operations, but they
use address_space->invalidate_lock to protect race.

This patch replaces cmdr_lock with address_space->invalidate_lock in
tcmu fault procedure, which will also make page-fault have concurrency.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 drivers/target/target_core_user.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 06a5c4086551..e0a62623ccd7 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1815,13 +1815,14 @@ static int tcmu_find_mem_index(struct vm_area_struct *vma)
 
 static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
 {
+	struct address_space *mapping = udev->inode->i_mapping;
 	struct page *page;
 
-	mutex_lock(&udev->cmdr_lock);
+	filemap_invalidate_lock_shared(mapping);
 	page = xa_load(&udev->data_pages, dpi);
 	if (likely(page)) {
 		get_page(page);
-		mutex_unlock(&udev->cmdr_lock);
+		filemap_invalidate_unlock_shared(mapping);
 		return page;
 	}
 
@@ -1831,7 +1832,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
 	 */
 	pr_err("Invalid addr to data page mapping (dpi %u) on device %s\n",
 	       dpi, udev->name);
-	mutex_unlock(&udev->cmdr_lock);
+	filemap_invalidate_unlock_shared(mapping);
 
 	return NULL;
 }
@@ -3111,6 +3112,7 @@ static void find_free_blocks(void)
 	loff_t off;
 	u32 pages_freed, total_pages_freed = 0;
 	u32 start, end, block, total_blocks_freed = 0;
+	struct address_space *mapping;
 
 	if (atomic_read(&global_page_count) <= tcmu_global_max_pages)
 		return;
@@ -3134,6 +3136,7 @@ static void find_free_blocks(void)
 			continue;
 		}
 
+		mapping = udev->inode->i_mapping;
 		end = udev->dbi_max + 1;
 		block = find_last_bit(udev->data_bitmap, end);
 		if (block == udev->dbi_max) {
@@ -3152,12 +3155,14 @@ static void find_free_blocks(void)
 			udev->dbi_max = block;
 		}
 
+		filemap_invalidate_lock(mapping);
 		/* Here will truncate the data area from off */
 		off = udev->data_off + (loff_t)start * udev->data_blk_size;
-		unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
+		unmap_mapping_range(mapping, off, 0, 1);
 
 		/* Release the block pages */
 		pages_freed = tcmu_blocks_release(udev, start, end - 1);
+		filemap_invalidate_unlock(mapping);
 		mutex_unlock(&udev->cmdr_lock);
 
 		total_pages_freed += pages_freed;
-- 
2.14.4.44.g2045bb6

