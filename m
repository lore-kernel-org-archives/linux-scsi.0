Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8BBCC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Mar 2022 13:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244520AbiCWNvS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Mar 2022 09:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244514AbiCWNvQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2022 09:51:16 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2C247396;
        Wed, 23 Mar 2022 06:49:46 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V80Aqnw_1648043383;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V80Aqnw_1648043383)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Mar 2022 21:49:43 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux-block@vger.kernel.org, bostroesser@gmail.com
Subject: [PATCH v2 3/3] scsi: target: tcmu: Use address_space->invalidate_lock
Date:   Wed, 23 Mar 2022 21:49:40 +0800
Message-Id: <20220323134940.31463-4-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20220323134940.31463-1-xiaoguang.wang@linux.alibaba.com>
References: <20220323134940.31463-1-xiaoguang.wang@linux.alibaba.com>
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
 drivers/target/target_core_user.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9196188504ec..81bfa553cc67 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1820,13 +1820,14 @@ static int tcmu_find_mem_index(struct vm_area_struct *vma)
 
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
 
@@ -1836,7 +1837,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
 	 */
 	pr_err("Invalid addr to data page mapping (dpi %u) on device %s\n",
 	       dpi, udev->name);
-	mutex_unlock(&udev->cmdr_lock);
+	filemap_invalidate_unlock_shared(mapping);
 
 	return NULL;
 }
@@ -3116,6 +3117,7 @@ static void find_free_blocks(void)
 	loff_t off;
 	u32 pages_freed, total_pages_freed = 0;
 	u32 start, end, block, total_blocks_freed = 0;
+	struct address_space *mapping;
 
 	if (atomic_read(&global_page_count) <= tcmu_global_max_pages)
 		return;
@@ -3139,6 +3141,8 @@ static void find_free_blocks(void)
 			continue;
 		}
 
+		mapping = udev->inode->i_mapping;
+		filemap_invalidate_lock(mapping);
 		end = udev->dbi_max + 1;
 		block = find_last_bit(udev->data_bitmap, end);
 		if (block == udev->dbi_max) {
@@ -3146,6 +3150,7 @@ static void find_free_blocks(void)
 			 * The last bit is dbi_max, so it is not possible
 			 * reclaim any blocks.
 			 */
+			filemap_invalidate_unlock(mapping);
 			mutex_unlock(&udev->cmdr_lock);
 			continue;
 		} else if (block == end) {
@@ -3159,10 +3164,11 @@ static void find_free_blocks(void)
 
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

