From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [21/22] Remove GFP_DMA in ch.c
Date: Mon, 25 Feb 2008 00:35:34 +0100 (CET)
Message-ID: <20080224233534.5BE801B4183@basil.firstfloor.org>
References: <200802251235.889863872@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:55517 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbYBXXvh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 18:51:37 -0500
In-Reply-To: <200802251235.889863872@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com


All buffers are bounced by the block layer

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/drivers/scsi/ch.c
===================================================================
--- linux.orig/drivers/scsi/ch.c
+++ linux/drivers/scsi/ch.c
@@ -231,7 +231,7 @@ ch_read_element_status(scsi_changer *ch,
 	u_char  *buffer;
 	int     result;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if(!buffer)
 		return -ENOMEM;
 
@@ -288,7 +288,7 @@ ch_readconfig(scsi_changer *ch)
 	int     result,id,lun,i;
 	u_int   elem;
 
-	buffer = kzalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kzalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -733,7 +733,7 @@ static long ch_ioctl(struct file *file,
 			return -EINVAL;
 		elem = ch->firsts[cge.cge_type] + cge.cge_unit;
 
-		buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+		buffer = kmalloc(512, GFP_KERNEL);
 		if (!buffer)
 			return -ENOMEM;
 		mutex_lock(&ch->lock);
