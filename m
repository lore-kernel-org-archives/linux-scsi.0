From: Jack Hammer <jack_hammer@adaptec.com>
Subject: ips.c warnings
Date: Thu, 20 Oct 2005 12:59:54 -0400
Message-ID: <4357CD0A.10300@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:13740 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932451AbVJTRAB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 13:00:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akmpm@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, ipslinux@adaptec.com

This patch ( applied to 2.6.14-rc4-mm1 ) keeps all the ips code intact for both 2.4 and 2.6 kernels, and should eliminate the compiler warnings ( in 2.6 ) reported by Andrew.

I did not use kmap() because these routines can be called from the interrupt handler context and kmap() can sleep.


--- 2.6.14-rc4/drivers/scsi/ips.c	Thu Oct 20 11:26:50 2005
+++ devel/drivers/scsi/ips.c	Thu Oct 20 11:33:39 2005
@@ -220,13 +220,15 @@
 #include <linux/blk.h>
 #include "sd.h"
 #define IPS_SG_ADDRESS(sg)       ((sg)->address)
+#define IPS_CHECK_SG_ADDRESS(sg) ((sg)->address)
 #define IPS_LOCK_SAVE(lock,flags) spin_lock_irqsave(&io_request_lock,flags)
 #define IPS_UNLOCK_RESTORE(lock,flags) spin_unlock_irqrestore(&io_request_lock,flags)
 #ifndef __devexit_p
 #define __devexit_p(x) x
 #endif
 #else
-#define IPS_SG_ADDRESS(sg)      (page_address((sg)->page) ? \
+#define IPS_SG_ADDRESS(sg)       page_address((sg)->page)+(sg)->offset
+#define IPS_CHECK_SG_ADDRESS(sg) (page_address((sg)->page) ? \
                                    page_address((sg)->page)+(sg)->offset : NULL)
 #define IPS_LOCK_SAVE(lock,flags) do{spin_lock(lock);(void)flags;}while(0)
 #define IPS_UNLOCK_RESTORE(lock,flags) do{spin_unlock(lock);(void)flags;}while(0)
@@ -3659,7 +3661,7 @@
 		struct scatterlist *sg = scmd->request_buffer;
 		for (i = 0, xfer_cnt = 0;
 		     (i < scmd->use_sg) && (xfer_cnt < count); i++) {
-			if (!IPS_SG_ADDRESS(&sg[i]))
+			if (!IPS_CHECK_SG_ADDRESS(&sg[i]))
 				return;
 			min_cnt = min(count - xfer_cnt, sg[i].length);
 			memcpy(IPS_SG_ADDRESS(&sg[i]), &cdata[xfer_cnt],
@@ -3691,7 +3693,7 @@
 		struct scatterlist *sg = scmd->request_buffer;
 		for (i = 0, xfer_cnt = 0;
 		     (i < scmd->use_sg) && (xfer_cnt < count); i++) {
-			if (!IPS_SG_ADDRESS(&sg[i]))
+			if (!IPS_CHECK_SG_ADDRESS(&sg[i]))
 				return;
 			min_cnt = min(count - xfer_cnt, sg[i].length);
 			memcpy(&cdata[xfer_cnt], IPS_SG_ADDRESS(&sg[i]),
