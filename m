From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: lower block queue alignment requirement
Date: Sun, 14 Jan 2007 19:45:30 +0100 (CET)
Message-ID: <tkrat.37326df2d568d12d@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:44551 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbXANSqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jan 2007 13:46:05 -0500
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org

The old setting seems to be copy & paste from usb-storage.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

I wonder, do we need this call to blk_queue_dma_alignment() at all?
Does the block layer perhaps provide sufficient alignment guarantees?


Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c	2007-01-14 18:40:08.000000000 +0100
+++ linux/drivers/ieee1394/sbp2.c	2007-01-14 19:30:42.000000000 +0100
@@ -2012,7 +2012,10 @@ static int sbp2scsi_slave_configure(stru
 {
 	struct sbp2_lu *lu = (struct sbp2_lu *)sdev->host->hostdata[0];
 
-	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
+	/* Page table elements shall be octlet-aligned.
+	 * Everything else can be quadlet-aligned. */
+	blk_queue_dma_alignment(sdev->request_queue, 7);
+
 	sdev->use_10_for_rw = 1;
 
 	if (sdev->type == TYPE_ROM)

-- 
Stefan Richter
-=====-=-=== ---= -===-
http://arcgraph.de/sr/

