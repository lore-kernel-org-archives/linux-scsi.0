From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 4/5] aacraid: sa race condition fix
Date: Wed, 10 May 2006 09:13:11 -0700
Message-ID: <1147277591.29108.36.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:25732 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965006AbWEJQNO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 12:13:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received From Mark Salyzyn

A race condition existed that could result in a lost completion of a
command to the ppc based cards.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---
Applies to the scsi-misc-2.6 tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/sa.c	2006-05-09 14:48:58.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/sa.c	2006-05-09 14:49:54.000000000 -0700
@@ -66,11 +66,11 @@
 			sa_writew(dev, DoorbellClrReg_p, PrintfReady); /* clear PrintfReady */
 			sa_writew(dev, DoorbellReg_s, PrintfDone);
 		} else if (intstat & DOORBELL_1) {	// dev -> Host Normal Command Ready
-			aac_command_normal(&dev->queues->queue[HostNormCmdQueue]);
 			sa_writew(dev, DoorbellClrReg_p, DOORBELL_1);
+			aac_command_normal(&dev->queues->queue[HostNormCmdQueue]);
 		} else if (intstat & DOORBELL_2) {	// dev -> Host Normal Response Ready
-			aac_response_normal(&dev->queues->queue[HostNormRespQueue]);
 			sa_writew(dev, DoorbellClrReg_p, DOORBELL_2);
+			aac_response_normal(&dev->queues->queue[HostNormRespQueue]);
 		} else if (intstat & DOORBELL_3) {	// dev -> Host Normal Command Not Full
 			sa_writew(dev, DoorbellClrReg_p, DOORBELL_3);
 		} else if (intstat & DOORBELL_4) {	// dev -> Host Normal Response Not Full

-- 
Mark Haverkamp <markh@osdl.org>

