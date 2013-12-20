From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] [SCSI] megaraid: use GFP_ATOMIC under spin lock
Date: Fri, 20 Dec 2013 11:08:03 +0800
Message-ID: <CAPgLHd82Wqz_sG9s5RPJ+ad+N73JA+_R+5kG-NQwaTYmzik2Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:38852 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3LTDIE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2013 22:08:04 -0500
Received: by mail-bk0-f43.google.com with SMTP id mz12so989410bkb.2
        for <linux-scsi@vger.kernel.org>; Thu, 19 Dec 2013 19:08:03 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com, JBottomley@parallels.com, simon.puels@gmail.com, jkosina@suse.cz
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

A spin lock is taken here so we should use GFP_ATOMIC.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/megaraid/megaraid_mm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index a706927..99fa5d3 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -570,7 +570,7 @@ mraid_mm_attach_buf(mraid_mmadp_t *adp, uioc_t *kioc, int xferlen)
 
 	kioc->pool_index	= right_pool;
 	kioc->free_buf		= 1;
-	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_KERNEL,
+	kioc->buf_vaddr		= pci_pool_alloc(pool->handle, GFP_ATOMIC,
 							&kioc->buf_paddr);
 	spin_unlock_irqrestore(&pool->lock, flags);
 

