From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix scsi_debug compile warning
Date: Sun, 27 Apr 2003 13:35:07 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427133507.A27453@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:35083 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263924AbTD0LXR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 07:23:17 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

spin_lock_irqsave takes an unsigned long.


--- 1.31/drivers/scsi/scsi_debug.c	Mon Mar 31 15:52:02 2003
+++ edited/drivers/scsi/scsi_debug.c	Sun Apr 27 09:22:25 2003
@@ -866,7 +871,7 @@
 static void timer_intr_handler(unsigned long indx)
 {
 	struct sdebug_queued_cmd * sqcp;
-	unsigned int iflags;
+	unsigned long iflags;
 
 	if (indx >= SCSI_DEBUG_CANQUEUE) {
 		printk(KERN_ERR "scsi_debug:timer_intr_handler: indx too "
