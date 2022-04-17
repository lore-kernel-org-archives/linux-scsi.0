Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F8DC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Apr 2022 05:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbiDQF2p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Apr 2022 01:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbiDQF2o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Apr 2022 01:28:44 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87F113E12;
        Sat, 16 Apr 2022 22:26:07 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VADb8oq_1650173164;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VADb8oq_1650173164)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 17 Apr 2022 13:26:05 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux-block@vger.kernel.org, bostroesser@gmail.com
Subject: [PATCH v4] scsi: target: tcmu: Fix possible data corruption
Date:   Sun, 17 Apr 2022 13:26:04 +0800
Message-Id: <20220417052604.120942-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.14.4.44.g2045bb6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When tcmu_vma_fault() gets one page successfully, before the current
context completes page fault procedure, find_free_blocks() may run in
and call unmap_mapping_range() to unmap this page. Assume when
find_free_blocks() completes its job firstly, previous page fault
procedure starts to run again and completes, then one truncated page has
beed mapped to use space, but note that tcmu_vma_fault() has gotten one
refcount for this page, so any other subsystem won't use this page,
unless later the use space addr is unmapped.

If another command runs in later and needs to extends dbi_thresh, it may
reuse the corresponding slot to previous page in data_bitmap, then though
we'll allocate new page for this slot in data_area, but no page fault will
happen again, because we have a valid map, real request's data will lose.

Filesystem implementations will also run into this issue, but they
usually lock page when vm_operations_struct->fault gets one page, and
unlock page after finish_fault() completes. In truncate sides, they
lock pages in truncate_inode_pages() to protect race with page fault.
We can also have similar codes like filesystem to fix this issue.

To fix this possible data corruption, we can apply similar method like
filesystem. For pages that are to be freed, tcmu_blocks_release() locks
and unlocks these pages, and make tcmu_vma_fault() also lock found page
under cmdr_lock. At the same time, since tcmu_vma_fault() gets one extra
page refcount, tcmu_blocks_release() won't free pages if pages are in
page fault procedure, which means it's safe to call tcmu_blocks_release()
before unmap_mapping_range().

With above action, for above race, tcmu_blocks_release()
will wait all page faults to be completed before calling
unmap_mapping_range(), and later if unmap_mapping_range() is called,
it will ensure stale mappings to be removed cleanly.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
V4:
 Add comments to explain why it's safe to call tcmu_blocks_release()
before unmap_mapping_range().

V3:
 Just lock/unlock_page in tcmu_blocks_release(), and call
tcmu_blocks_release() before unmap_mapping_range().

V2:
  Wait all possible inflight page faults to be completed in
find_free_blocks() to fix possible stale map.
---
 drivers/target/target_core_user.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index fd7267baa707..f286b5294862 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -20,6 +20,7 @@
 #include <linux/configfs.h>
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
+#include <linux/pagemap.h>
 #include <net/genetlink.h>
 #include <scsi/scsi_common.h>
 #include <scsi/scsi_proto.h>
@@ -1667,6 +1668,25 @@ static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
 	xas_lock(&xas);
 	xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
 		xas_store(&xas, NULL);
+		/*
+		 * While reaching here, there maybe page faults occurring on
+		 * these to be released pages, and there maybe one race that
+		 * unmap_mapping_range() is called before page fault on these
+		 * pages are finished, then valid but stale map is created.
+		 *
+		 * If another command runs in later and needs to extends
+		 * dbi_thresh, it may reuse the corresponding slot to previous
+		 * page in data_bitmap, then though we'll allocate new page for
+		 * this slot in data_area, but no page fault will happen again,
+		 * because we have a valid map, command's data will lose.
+		 *
+		 * So here we lock and unlock pages that are to be released to
+		 * ensure all page faults to be completed, then following
+		 * unmap_mapping_range() can ensure stale maps to be removed
+		 * cleanly.
+		 */
+		lock_page(page);
+		unlock_page(page);
 		__free_page(page);
 		pages_freed++;
 	}
@@ -1822,6 +1842,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
 	page = xa_load(&udev->data_pages, dpi);
 	if (likely(page)) {
 		get_page(page);
+		lock_page(page);
 		mutex_unlock(&udev->cmdr_lock);
 		return page;
 	}
@@ -1863,6 +1884,7 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 	struct page *page;
 	unsigned long offset;
 	void *addr;
+	vm_fault_t ret = 0;
 
 	int mi = tcmu_find_mem_index(vmf->vma);
 	if (mi < 0)
@@ -1887,10 +1909,11 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 		page = tcmu_try_get_data_page(udev, dpi);
 		if (!page)
 			return VM_FAULT_SIGBUS;
+		ret = VM_FAULT_LOCKED;
 	}
 
 	vmf->page = page;
-	return 0;
+	return ret;
 }
 
 static const struct vm_operations_struct tcmu_vm_ops = {
@@ -3205,12 +3228,19 @@ static void find_free_blocks(void)
 			udev->dbi_max = block;
 		}
 
+		/*
+		 * Release the block pages.
+		 * Also note that since tcmu_vma_fault() gets one extra page
+		 * refcount, tcmu_blocks_release() won't free pages if pages
+		 * are in page fault procedure, which means it's safe to
+		 * call tcmu_blocks_release() before unmap_mapping_range().
+		 */
+		pages_freed = tcmu_blocks_release(udev, start, end - 1);
+
 		/* Here will truncate the data area from off */
 		off = udev->data_off + (loff_t)start * udev->data_blk_size;
 		unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
 
-		/* Release the block pages */
-		pages_freed = tcmu_blocks_release(udev, start, end - 1);
 		mutex_unlock(&udev->cmdr_lock);
 
 		total_pages_freed += pages_freed;
-- 
2.14.4.44.g2045bb6

