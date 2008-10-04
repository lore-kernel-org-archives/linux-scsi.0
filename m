From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] scsi: sr.c use unaligned access helpers
Date: Fri, 03 Oct 2008 17:46:13 -0700
Message-ID: <1223081173.6778.4.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:44607 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbYJDAqP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2008 20:46:15 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1887882wfd.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Oct 2008 17:46:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

Preserve the cd->capacity indentation near the #if 0'd if() statement.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/sr.c |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 27f5bfd..f1b650e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -45,6 +45,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
@@ -280,10 +281,7 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 		case ILLEGAL_REQUEST:
 			if (!(SCpnt->sense_buffer[0] & 0x90))
 				break;
-			error_sector = (SCpnt->sense_buffer[3] << 24) |
-				(SCpnt->sense_buffer[4] << 16) |
-				(SCpnt->sense_buffer[5] << 8) |
-				SCpnt->sense_buffer[6];
+			error_sector = get_unaligned_be32(SCpnt->sense_buffer + 3);
 			if (SCpnt->request->bio != NULL)
 				block_sectors =
 					bio_sectors(SCpnt->request->bio);
@@ -445,13 +443,9 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 		SCpnt->sdb.length = this_count * s_size;
 	}
 
-	SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
-	SCpnt->cmnd[3] = (unsigned char) (block >> 16) & 0xff;
-	SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;
-	SCpnt->cmnd[5] = (unsigned char) block & 0xff;
+	put_unaligned_be32(block, SCpnt->cmnd + 2);
 	SCpnt->cmnd[6] = SCpnt->cmnd[9] = 0;
-	SCpnt->cmnd[7] = (unsigned char) (this_count >> 8) & 0xff;
-	SCpnt->cmnd[8] = (unsigned char) this_count & 0xff;
+	put_unaligned_be16(this_count, SCpnt->cmnd + 7);
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
@@ -701,12 +695,8 @@ static void get_sectorsize(struct scsi_cd *cd)
 		if (cdrom_get_last_written(&cd->cdi,
 					   &cd->capacity))
 #endif
-			cd->capacity = 1 + ((buffer[0] << 24) |
-						    (buffer[1] << 16) |
-						    (buffer[2] << 8) |
-						    buffer[3]);
-		sector_size = (buffer[4] << 24) |
-		    (buffer[5] << 16) | (buffer[6] << 8) | buffer[7];
+			cd->capacity = 1 + get_unaligned_be32(buffer);
+		sector_size = get_unaligned_be32(buffer + 4);
 		switch (sector_size) {
 			/*
 			 * HP 4020i CD-Recorder reports 2340 byte sectors
@@ -792,12 +782,12 @@ static void get_capabilities(struct scsi_cd *cd)
 	}
 
 	n = data.header_length + data.block_descriptor_length;
-	cd->cdi.speed = ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
+	cd->cdi.speed = get_unaligned_be16(buffer + n + 8) / 176;
 	cd->readcd_known = 1;
 	cd->readcd_cdda = buffer[n + 5] & 0x01;
 	/* print some capability bits */
 	printk("%s: scsi3-mmc drive: %dx/%dx %s%s%s%s%s%s\n", cd->cdi.name,
-	       ((buffer[n + 14] << 8) + buffer[n + 15]) / 176,
+	       get_unaligned_be16(buffer + n + 14) / 176,
 	       cd->cdi.speed,
 	       buffer[n + 3] & 0x01 ? "writer " : "", /* CD Writer */
 	       buffer[n + 3] & 0x20 ? "dvd-ram " : "",
-- 
1.6.0.2.471.g47a76



