From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] megaraid: Fix a sleep-in-atomic bug
Date: Wed, 31 May 2017 10:56:56 +0800
Message-ID: <1496199416-2556-1-git-send-email-baijiaju1990@163.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:43085 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751030AbdEaCzT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 May 2017 22:55:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>

The driver may sleep under a spin lock, and the function call path is:
mraid_mm_attach_buf (acquire the lock by spin_lock_irqsave)
  pci_pool_alloc(GFP_KERNEL) --> may sleep

To fix it, the "GFP_KERNEL" is replaced with "GFP_ATOMIC".

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/scsi/megaraid/megaraid_mm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 4cf9ed9..c43afb8 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -574,7 +574,7 @@
 
 	kioc->pool_index	= right_pool;
 	kioc->free_buf		= 1;
-	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_KERNEL,
+	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_ATOMIC,
 							&kioc->buf_paddr);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-- 
1.7.9.5
