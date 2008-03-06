From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [21/21] Convert DMA buffers in ch.c to allocate via the block layer
Date: Thu,  6 Mar 2008 21:51:43 +0100 (CET)
Message-ID: <20080306205143.771491B419C@basil.firstfloor.org>
References: <20080306951.147874949@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:12111 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762069AbYCFUvp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 15:51:45 -0500
In-Reply-To: <20080306951.147874949@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


Instead of specifying GFP_DMA always ask the block layer to get 
some dma'able memory

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/ch.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux/drivers/scsi/ch.c
===================================================================
--- linux.orig/drivers/scsi/ch.c
+++ linux/drivers/scsi/ch.c
@@ -231,7 +231,7 @@ ch_read_element_status(scsi_changer *ch,
 	u_char  *buffer;
 	int     result;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = blk_kmalloc(ch->device->request_queue, 512, GFP_KERNEL);
 	if(!buffer)
 		return -ENOMEM;
 
@@ -261,7 +261,7 @@ ch_read_element_status(scsi_changer *ch,
 		}
 		dprintk("READ ELEMENT STATUS for element 0x%x failed\n",elem);
 	}
-	kfree(buffer);
+	blk_kfree(buffer, 512);
 	return result;
 }
 
@@ -288,9 +288,10 @@ ch_readconfig(scsi_changer *ch)
 	int     result,id,lun,i;
 	u_int   elem;
 
-	buffer = kzalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = blk_kmalloc(ch->device->request_queue, 512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
+	memset(buffer, 0, 512);
 
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = MODE_SENSE;
@@ -401,7 +402,7 @@ ch_readconfig(scsi_changer *ch)
 		}
 	}
 	ch->voltags = 1;
-	kfree(buffer);
+	blk_kfree(buffer, 512);
 
 	return 0;
 }
@@ -733,7 +734,7 @@ static long ch_ioctl(struct file *file,
 			return -EINVAL;
 		elem = ch->firsts[cge.cge_type] + cge.cge_unit;
 
-		buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+		buffer = blk_kmalloc(ch->device->request_queue, 512, GFP_KERNEL);
 		if (!buffer)
 			return -ENOMEM;
 		mutex_lock(&ch->lock);
@@ -786,7 +787,7 @@ static long ch_ioctl(struct file *file,
 			vprintk("device has no volume tag support\n");
 			goto voltag_retry;
 		}
-		kfree(buffer);
+		blk_kfree(buffer, 512);
 		mutex_unlock(&ch->lock);
 
 		if (copy_to_user(argp, &cge, sizeof (cge)))
