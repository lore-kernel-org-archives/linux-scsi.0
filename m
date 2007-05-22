From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] scsi_error: send the sense buffer down without copying
Date: Tue, 22 May 2007 14:43:14 -0500
Message-ID: <1179862994.3738.51.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60013 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759822AbXEVTnR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 15:43:17 -0400
Received: from [172.17.6.40] (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (Postfix) with ESMTP id 948AEAAA8235
	for <linux-scsi@vger.kernel.org>; Tue, 22 May 2007 15:43:15 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Now that the block submission path correctly bounces, we can simply
use the command sense_buffer to send to retrieve sense information and
junk the unnecessary page allocation.

James

Index: scsi-misc-2.6/drivers/scsi/scsi_error.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_error.c	2007-05-15 11:08:31.000000000 -0500
+++ scsi-misc-2.6/drivers/scsi/scsi_error.c	2007-05-22 14:38:49.000000000 -0500
@@ -18,12 +18,12 @@
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
-#include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/scatterlist.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -640,16 +640,8 @@ static int scsi_send_eh_cmnd(struct scsi
 	memcpy(scmd->cmnd, cmnd, cmnd_size);
 
 	if (copy_sense) {
-		gfp_t gfp_mask = GFP_ATOMIC;
-
-		if (shost->hostt->unchecked_isa_dma)
-			gfp_mask |= __GFP_DMA;
-
-		sgl.page = alloc_page(gfp_mask);
-		if (!sgl.page)
-			return FAILED;
-		sgl.offset = 0;
-		sgl.length = 252;
+		sg_init_one(&sgl, scmd->sense_buffer,
+			    sizeof(scmd->sense_buffer));
 
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
 		scmd->request_bufflen = sgl.length;
@@ -720,18 +712,6 @@ static int scsi_send_eh_cmnd(struct scsi
 
 
 	/*
-	 * Last chance to have valid sense data.
-	 */
-	if (copy_sense) {
-		if (!SCSI_SENSE_VALID(scmd)) {
-			memcpy(scmd->sense_buffer, page_address(sgl.page),
-			       sizeof(scmd->sense_buffer));
-		}
-		__free_page(sgl.page);
-	}
-
-
-	/*
 	 * Restore original data
 	 */
 	scmd->request_buffer = old_buffer;


