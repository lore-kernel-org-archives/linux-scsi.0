From: akpm@osdl.org
Subject: [patch 5/5] ips.c highmem fix
Date: Fri, 28 Oct 2005 15:07:52 -0700
Message-ID: <200510282207.j9SM7Y99022290@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:46518 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030268AbVJ1WHh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 18:07:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, jack_hammer@adaptec.com


From: Jack Hammer <jack_hammer@adaptec.com>

Make ips.c play properly with highmem pages.

Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/ips.c |   49 ++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 36 insertions(+), 13 deletions(-)

diff -puN drivers/scsi/ips.c~ipsc-highmem-fixes drivers/scsi/ips.c
--- 25/drivers/scsi/ips.c~ipsc-highmem-fixes	Fri Oct 28 15:06:43 2005
+++ 25-akpm/drivers/scsi/ips.c	Fri Oct 28 15:06:43 2005
@@ -219,15 +219,12 @@ module_param(ips, charp, 0);
 #if LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,0)
 #include <linux/blk.h>
 #include "sd.h"
-#define IPS_SG_ADDRESS(sg)       ((sg)->address)
 #define IPS_LOCK_SAVE(lock,flags) spin_lock_irqsave(&io_request_lock,flags)
 #define IPS_UNLOCK_RESTORE(lock,flags) spin_unlock_irqrestore(&io_request_lock,flags)
 #ifndef __devexit_p
 #define __devexit_p(x) x
 #endif
 #else
-#define IPS_SG_ADDRESS(sg)      (page_address((sg)->page) ? \
-                                   page_address((sg)->page)+(sg)->offset : NULL)
 #define IPS_LOCK_SAVE(lock,flags) do{spin_lock(lock);(void)flags;}while(0)
 #define IPS_UNLOCK_RESTORE(lock,flags) do{spin_unlock(lock);(void)flags;}while(0)
 #endif
@@ -1605,6 +1602,8 @@ ips_proc_info(struct Scsi_Host *host, ch
 static int
 ips_is_passthru(Scsi_Cmnd * SC)
 {
+	unsigned long flags;
+
 	METHOD_TRACE("ips_is_passthru", 1);
 
 	if (!SC)
@@ -1622,10 +1621,20 @@ ips_is_passthru(Scsi_Cmnd * SC)
 			return 1;
 		else if (SC->use_sg) {
 			struct scatterlist *sg = SC->request_buffer;
-			char *buffer = IPS_SG_ADDRESS(sg);
+			char  *buffer;
+
+			/* kmap_atomic() ensures addressability of the user buffer.*/
+			/* local_irq_save() protects the KM_IRQ0 address slot.     */
+			local_irq_save(flags);
+			buffer = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
 			if (buffer && buffer[0] == 'C' && buffer[1] == 'O' &&
-			    buffer[2] == 'P' && buffer[3] == 'P')
+			    buffer[2] == 'P' && buffer[3] == 'P') {
+				kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+				local_irq_restore(flags);
 				return 1;
+			}
+			kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+			local_irq_restore(flags);
 		}
 	}
 	return 0;
@@ -3656,14 +3665,21 @@ ips_scmd_buf_write(Scsi_Cmnd * scmd, voi
 		int i;
 		unsigned int min_cnt, xfer_cnt;
 		char *cdata = (char *) data;
+		unsigned char *buffer;
+		unsigned long flags;
 		struct scatterlist *sg = scmd->request_buffer;
 		for (i = 0, xfer_cnt = 0;
 		     (i < scmd->use_sg) && (xfer_cnt < count); i++) {
-			if (!IPS_SG_ADDRESS(&sg[i]))
-				return;
 			min_cnt = min(count - xfer_cnt, sg[i].length);
-			memcpy(IPS_SG_ADDRESS(&sg[i]), &cdata[xfer_cnt],
-			       min_cnt);
+
+			/* kmap_atomic() ensures addressability of the data buffer.*/
+			/* local_irq_save() protects the KM_IRQ0 address slot.     */
+			local_irq_save(flags);
+			buffer = kmap_atomic(sg[i].page, KM_IRQ0) + sg[i].offset;
+			memcpy(buffer, &cdata[xfer_cnt], min_cnt);
+			kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
+			local_irq_restore(flags);
+
 			xfer_cnt += min_cnt;
 		}
 
@@ -3688,14 +3704,21 @@ ips_scmd_buf_read(Scsi_Cmnd * scmd, void
 		int i;
 		unsigned int min_cnt, xfer_cnt;
 		char *cdata = (char *) data;
+		unsigned char *buffer;
+		unsigned long flags;
 		struct scatterlist *sg = scmd->request_buffer;
 		for (i = 0, xfer_cnt = 0;
 		     (i < scmd->use_sg) && (xfer_cnt < count); i++) {
-			if (!IPS_SG_ADDRESS(&sg[i]))
-				return;
 			min_cnt = min(count - xfer_cnt, sg[i].length);
-			memcpy(&cdata[xfer_cnt], IPS_SG_ADDRESS(&sg[i]),
-			       min_cnt);
+
+			/* kmap_atomic() ensures addressability of the data buffer.*/
+			/* local_irq_save() protects the KM_IRQ0 address slot.     */
+			local_irq_save(flags);
+			buffer = kmap_atomic(sg[i].page, KM_IRQ0) + sg[i].offset;
+			memcpy(&cdata[xfer_cnt], buffer, min_cnt);
+			kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
+			local_irq_restore(flags);
+
 			xfer_cnt += min_cnt;
 		}
 
_
