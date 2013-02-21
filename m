From: Denis Efremov <yefremov.denis@gmail.com>
Subject: [PATCH] [SCSI]: megaraid: avoid sleeping on spinlock
Date: Thu, 21 Feb 2013 15:57:21 +0400
Message-ID: <1361447841-873-1-git-send-email-yefremov.denis@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:62791 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3BUL7D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Feb 2013 06:59:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org

GFP_KERNEL may cause pci_pool_alloc() sleep,
so we need use GFP_ATOMIC instead of GFP_KERNEL.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 drivers/scsi/megaraid/megaraid_mm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 25506c7..4b2f336 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -568,7 +568,7 @@ mraid_mm_attach_buf(mraid_mmadp_t *adp, uioc_t *kioc, int xferlen)
 
 	kioc->pool_index	= right_pool;
 	kioc->free_buf		= 1;
-	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_KERNEL,
+	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_ATOMIC,
 							&kioc->buf_paddr);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-- 
1.8.1.2

