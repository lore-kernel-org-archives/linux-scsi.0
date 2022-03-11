Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC210C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Mar 2022 13:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347714AbiCKNXO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Mar 2022 08:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236044AbiCKNXN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2022 08:23:13 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABE81C2F7E;
        Fri, 11 Mar 2022 05:22:09 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V6uG0i8_1647004926;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V6uG0i8_1647004926)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 11 Mar 2022 21:22:06 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     bostroesser@gmail.com
Subject: [PATCH 1/2] scsi: target: tcmu: Fix possible page UAF
Date:   Fri, 11 Mar 2022 21:22:05 +0800
Message-Id: <20220311132206.24515-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

tcmu_try_get_data_page() looks up pages under cmdr_lock, but it don't
take refcount properly and just return page pointer.

When tcmu_try_get_data_page() returns, the returned page may have been
freed by tcmu_blocks_release(), need to get_page() under cmdr_lock to
avoid concurrent tcmu_blocks_release().

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 drivers/target/target_core_user.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7b2a89a67cdb..06a5c4086551 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1820,6 +1820,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
 	mutex_lock(&udev->cmdr_lock);
 	page = xa_load(&udev->data_pages, dpi);
 	if (likely(page)) {
+		get_page(page);
 		mutex_unlock(&udev->cmdr_lock);
 		return page;
 	}
@@ -1876,6 +1877,7 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 		/* For the vmalloc()ed cmd area pages */
 		addr = (void *)(unsigned long)info->mem[mi].addr + offset;
 		page = vmalloc_to_page(addr);
+		get_page(page);
 	} else {
 		uint32_t dpi;
 
@@ -1886,7 +1888,6 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 			return VM_FAULT_SIGBUS;
 	}
 
-	get_page(page);
 	vmf->page = page;
 	return 0;
 }
-- 
2.14.4.44.g2045bb6

