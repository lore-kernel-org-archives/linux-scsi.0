From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [21/21] SCSI-ISA-DMA: Convert DMA buffers in ch.c to allocate via the block layer
Date: Thu,  2 Oct 2008 09:58:59 +0200 (CEST)
Message-ID: <20081002075859.83EFE3E6A09@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57129 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbYJBH7A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:59:00 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


Instead of specifying GFP_DMA always ask the block layer to get 
some dma'able memory

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/ch.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

Index: linux/drivers/scsi/ch.c
===================================================================
--- linux.orig/drivers/scsi/ch.c
+++ linux/drivers/scsi/ch.c
@@ -232,7 +232,8 @@ ch_read_element_status(scsi_changer *ch,
 	u_char  *buffer;
 	int     result;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = get_pages_mask(GFP_KERNEL, 512,
+				blk_q_mask(ch->device->request_queue));
 	if(!buffer)
 		return -ENOMEM;
 
@@ -262,7 +263,7 @@ ch_read_element_status(scsi_changer *ch,
 		}
 		dprintk("READ ELEMENT STATUS for element 0x%x failed\n",elem);
 	}
-	kfree(buffer);
+	free_pages_mask(buffer, 512);
 	return result;
 }
 
@@ -289,9 +290,11 @@ ch_readconfig(scsi_changer *ch)
 	int     result,id,lun,i;
 	u_int   elem;
 
-	buffer = kzalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = get_pages_mask(GFP_KERNEL, 512,
+				blk_q_mask(ch->device->request_queue));
 	if (!buffer)
 		return -ENOMEM;
+	memset(buffer, 0, 512);
 
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = MODE_SENSE;
@@ -402,7 +405,7 @@ ch_readconfig(scsi_changer *ch)
 		}
 	}
 	ch->voltags = 1;
-	kfree(buffer);
+	free_pages_mask(buffer, 512);
 
 	return 0;
 }
@@ -737,7 +740,8 @@ static long ch_ioctl(struct file *file,
 			return -EINVAL;
 		elem = ch->firsts[cge.cge_type] + cge.cge_unit;
 
-		buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+		buffer = get_pages_mask(GFP_KERNEL, 512,
+					blk_q_mask(ch->device->request_queue));
 		if (!buffer)
 			return -ENOMEM;
 		mutex_lock(&ch->lock);
@@ -791,7 +795,7 @@ static long ch_ioctl(struct file *file,
 			vprintk("device has no volume tag support\n");
 			goto voltag_retry;
 		}
-		kfree(buffer);
+		free_pages_mask(buffer, 512);
 		mutex_unlock(&ch->lock);
 
 		if (copy_to_user(argp, &cge, sizeof (cge)))
