From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
Subject: [PATCH] megaraid_mm: moved pci_pool_alloc() from critical section
 to outward
Date: Fri, 15 Aug 2008 15:51:08 +0900
Message-ID: <48A5275C.6050303@miraclelinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.miraclelinux.com ([219.118.163.66]:55441 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbYHOHBO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Aug 2008 03:01:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com
Cc: linux-scsi@vger.kernel.org

Hi
This patch moved call of pci_pool_alloc from critical section to outward.
It seems like that original code behavior schedule-in without unlock.

Note
This patch is not tested because I don't have this device.

Thanks.
Hirofumi Nakagawa

Signed-off-by: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
---
 drivers/scsi/megaraid/megaraid_mm.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index f680561..4d70906 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -499,6 +499,7 @@ mraid_mm_attach_buf(mraid_mmadp_t *adp, uioc_t *kioc, int xferlen)
 	int		right_pool = -1;
 	unsigned long	flags;
 	int		i;
+	void *t;

 	kioc->pool_index	= -1;
 	kioc->buf_vaddr		= NULL;
@@ -549,17 +550,19 @@ mraid_mm_attach_buf(mraid_mmadp_t *adp, uioc_t *kioc, int xferlen)
 	 * to allocate one new buffer. NOTE: This is a blocking call.
 	 */
 	pool = &adp->dma_pool_list[right_pool];
+	t = pci_pool_alloc(pool->handle, GFP_KERNEL,
+							&kioc->buf_paddr);
+
+	if (!t)
+		return -ENOMEM;

 	spin_lock_irqsave(&pool->lock, flags);

 	kioc->pool_index	= right_pool;
 	kioc->free_buf		= 1;
-	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_KERNEL,
-							&kioc->buf_paddr);
-	spin_unlock_irqrestore(&pool->lock, flags);
+	kioc->buf_vaddr 	= t;

-	if (!kioc->buf_vaddr)
-		return -ENOMEM;
+	spin_unlock_irqrestore(&pool->lock, flags);

 	return 0;
 }
-- 

