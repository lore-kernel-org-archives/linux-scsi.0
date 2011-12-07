From: Tom Gundersen <teg@jklm.no>
Subject: [PATCH] scsi: mark some messages as INFO/WARNING/ERROR
Date: Wed,  7 Dec 2011 17:52:34 +0100
Message-ID: <1323276754-1744-1-git-send-email-teg@jklm.no>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61544 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab1LGQwo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2011 11:52:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tom Gundersen <teg@jklm.no>

This reduces the noice in

$ dmesg --kernel --level=err,warn

Signed-off-by: Tom Gundersen <teg@jklm.no>
---
 drivers/scsi/sr.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..762039a 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -306,7 +306,7 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
 
 #ifdef DEBUG
-	printk("sr.c done: %x\n", result);
+	printk(KERN_DEBUG "sr.c done: %x\n", result);
 #endif
 
 	/*
@@ -416,7 +416,7 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 		if (!in_interrupt())
 			sr_set_blocklength(cd, 2048);
 		else
-			printk("sr: can't switch blocksize: in interrupt\n");
+			printk(KERN_WARNING "sr: can't switch blocksize: in interrupt\n");
 	}
 
 	if (s_size != 512 && s_size != 1024 && s_size != 2048) {
@@ -790,7 +790,7 @@ static void get_sectorsize(struct scsi_cd *cd)
 		case 512:
 			break;
 		default:
-			printk("%s: unsupported sector size %d.\n",
+			printk(KERN_ERR "%s: unsupported sector size %d.\n",
 			       cd->cdi.name, sector_size);
 			cd->capacity = 0;
 		}
@@ -852,7 +852,7 @@ static void get_capabilities(struct scsi_cd *cd)
 				 CDC_SELECT_DISC | CDC_SELECT_SPEED |
 				 CDC_MRW | CDC_MRW_W | CDC_RAM);
 		kfree(buffer);
-		printk("%s: scsi-1 drive\n", cd->cdi.name);
+		printk(KERN_INFO "%s: scsi-1 drive\n", cd->cdi.name);
 		return;
 	}
 
@@ -861,7 +861,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	cd->readcd_known = 1;
 	cd->readcd_cdda = buffer[n + 5] & 0x01;
 	/* print some capability bits */
-	printk("%s: scsi3-mmc drive: %dx/%dx %s%s%s%s%s%s\n", cd->cdi.name,
+	printk(KERN_INFO "%s: scsi3-mmc drive: %dx/%dx %s%s%s%s%s%s\n", cd->cdi.name,
 	       ((buffer[n + 14] << 8) + buffer[n + 15]) / 176,
 	       cd->cdi.speed,
 	       buffer[n + 3] & 0x01 ? "writer " : "", /* CD Writer */
-- 
1.7.8

