From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [20/22] Remove GFP_DMA in sr.c
Date: Mon, 25 Feb 2008 00:35:33 +0100 (CET)
Message-ID: <20080224233533.57FEC1B4183@basil.firstfloor.org>
References: <200802251235.889863872@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:19737 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229AbYBXXfj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 18:35:39 -0500
In-Reply-To: <200802251235.889863872@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com


All buffers are bounced by the block layer

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/drivers/scsi/sr.c
===================================================================
--- linux.orig/drivers/scsi/sr.c
+++ linux/drivers/scsi/sr.c
@@ -674,7 +674,7 @@ static void get_sectorsize(struct scsi_c
 	int sector_size;
 	struct request_queue *queue;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer)
 		goto Enomem;
 
@@ -772,7 +772,7 @@ static void get_capabilities(struct scsi
 
 
 	/* allocate transfer buffer */
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer) {
 		printk(KERN_ERR "sr: out of memory.\n");
 		return;
