From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] esp_scsi.c: fix compilation
Date: Sat, 28 Apr 2007 02:09:01 +0400
Message-ID: <20070427220901.GC5986@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:1901 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455AbXD0WI2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Apr 2007 18:08:28 -0400
Received: by ug-out-1314.google.com with SMTP id 44so902252uga
        for <linux-scsi@vger.kernel.org>; Fri, 27 Apr 2007 15:08:27 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osd.org, akpm@osdl.org
Cc: davem@davemloft.net, linux-scsi@vger.kernel.org

irqreturn.h for irqreturn_t and dma_addr_t being u128 warnings ;-)

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/esp_scsi.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
+#include <linux/irqreturn.h>
 
 #include <asm/irq.h>
 #include <asm/io.h>
@@ -1706,17 +1707,17 @@ again:
 		if (!dma_len) {
 			printk(KERN_ERR PFX "esp%d: DMA length is zero!\n",
 			       esp->host->unique_id);
-			printk(KERN_ERR PFX "esp%d: cur adr[%08x] len[%08x]\n",
+			printk(KERN_ERR PFX "esp%d: cur adr[%08llx] len[%08x]\n",
 			       esp->host->unique_id,
-			       esp_cur_dma_addr(ent, cmd),
+			       (unsigned long long)esp_cur_dma_addr(ent, cmd),
 			       esp_cur_dma_len(ent, cmd));
 			esp_schedule_reset(esp);
 			return 0;
 		}
 
-		esp_log_datastart("ESP: start data addr[%08x] len[%u] "
+		esp_log_datastart("ESP: start data addr[%08llx] len[%u] "
 				  "write(%d)\n",
-				  dma_addr, dma_len, write);
+				  (unsigned long long)dma_addr, dma_len, write);
 
 		esp->ops->send_dma_cmd(esp, dma_addr, dma_len, dma_len,
 				       write, ESP_CMD_DMA | ESP_CMD_TI);

