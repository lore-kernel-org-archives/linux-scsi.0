From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/10] sr: Use dev_printk()
Date: Fri, 12 Oct 2012 10:33:42 +0200
Message-ID: <1350030830-25614-3-git-send-email-hare@suse.de>
References: <1350030830-25614-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933574Ab2JLId4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 04:33:56 -0400
In-Reply-To: <1350030830-25614-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Kay Sievers <kay@vrfy.org>, Jens Axboe <axboe@kernel.dk>

Convert sr to use dev_printk() to avoid linebreaks in kernel
messages.

Cc: Kay Sievers <kay@vrfy.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sr.c |   47 ++++++++++++++++++++++++++---------------------
 drivers/scsi/sr.h |    4 ++++
 2 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..26404ca 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -276,8 +276,8 @@ do_tur:
 	if (!cd->tur_changed) {
 		if (cd->get_event_changed) {
 			if (cd->tur_mismatch++ > 8) {
-				sdev_printk(KERN_WARNING, cd->device,
-					    "GET_EVENT and TUR disagree continuously, suppress GET_EVENT events\n");
+				sr_printk(KERN_WARNING, cd,
+					  "GET_EVENT and TUR disagree continuously, suppress GET_EVENT events\n");
 				cd->ignore_get_event = true;
 			}
 		} else {
@@ -306,7 +306,7 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
 
 #ifdef DEBUG
-	printk("sr.c done: %x\n", result);
+	sr_printk(KERN_INFO, cd, "sr.c done: %x\n", result);
 #endif
 
 	/*
@@ -389,13 +389,16 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 	 * is used for a killable error condition */
 	ret = BLKPREP_KILL;
 
-	SCSI_LOG_HLQUEUE(1, printk("Doing sr request, dev = %s, block = %d\n",
-				cd->disk->disk_name, block));
+	SCSI_LOG_HLQUEUE(1,
+		scmd_printk(KERN_INFO, SCpnt,
+			    "Doing sr request, block = %d\n", block));
 
 	if (!cd->device || !scsi_device_online(cd->device)) {
-		SCSI_LOG_HLQUEUE(2, printk("Finishing %u sectors\n",
-					   blk_rq_sectors(rq)));
-		SCSI_LOG_HLQUEUE(2, printk("Retry with 0x%p\n", SCpnt));
+		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
+						"Finishing %u sectors\n",
+					      blk_rq_sectors(rq)));
+		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
+						"Retry with 0x%p\n", SCpnt));
 		goto out;
 	}
 
@@ -416,7 +419,8 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 		if (!in_interrupt())
 			sr_set_blocklength(cd, 2048);
 		else
-			printk("sr: can't switch blocksize: in interrupt\n");
+			scmd_printk(KERN_INFO, SCpnt,
+				  "sr: can't switch blocksize: in interrupt\n");
 	}
 
 	if (s_size != 512 && s_size != 1024 && s_size != 2048) {
@@ -429,7 +433,7 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 			goto out;
 		SCpnt->cmnd[0] = WRITE_10;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
- 	 	cd->cdi.media_written = 1;
+		cd->cdi.media_written = 1;
 	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_10;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
@@ -447,8 +451,8 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 
 		if (size != scsi_bufflen(SCpnt)) {
 			scmd_printk(KERN_ERR, SCpnt,
-				"mismatch count %d, bytes %d\n",
-				size, scsi_bufflen(SCpnt));
+				    "mismatch count %d, bytes %d\n",
+				    size, scsi_bufflen(SCpnt));
 			if (scsi_bufflen(SCpnt) > size)
 				SCpnt->sdb.length = size;
 		}
@@ -466,11 +470,11 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 	this_count = (scsi_bufflen(SCpnt) >> 9) / (s_size >> 9);
 
 
-	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%u 512 byte blocks.\n",
-				cd->cdi.name,
-				(rq_data_dir(rq) == WRITE) ?
-					"writing" : "reading",
-				this_count, blk_rq_sectors(rq)));
+	SCSI_LOG_HLQUEUE(2, sr_printk(KERN_INFO, cd,
+				      "%s %d/%u 512 byte blocks.\n",
+				      (rq_data_dir(rq) == WRITE) ?
+				      "writing" : "reading",
+				      this_count, blk_rq_sectors(rq)));
 
 	SCpnt->cmnd[1] = 0;
 	block = (unsigned int)blk_rq_pos(rq) / (s_size >> 9);
@@ -790,8 +794,9 @@ static void get_sectorsize(struct scsi_cd *cd)
 		case 512:
 			break;
 		default:
-			printk("%s: unsupported sector size %d.\n",
-			       cd->cdi.name, sector_size);
+			sr_printk(KERN_INFO, cd,
+				  "unsupported sector size %d.\n",
+				  sector_size);
 			cd->capacity = 0;
 		}
 
@@ -852,7 +857,7 @@ static void get_capabilities(struct scsi_cd *cd)
 				 CDC_SELECT_DISC | CDC_SELECT_SPEED |
 				 CDC_MRW | CDC_MRW_W | CDC_RAM);
 		kfree(buffer);
-		printk("%s: scsi-1 drive\n", cd->cdi.name);
+		sr_printk(KERN_INFO, cd, "scsi-1 drive");
 		return;
 	}
 
@@ -861,7 +866,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	cd->readcd_known = 1;
 	cd->readcd_cdda = buffer[n + 5] & 0x01;
 	/* print some capability bits */
-	printk("%s: scsi3-mmc drive: %dx/%dx %s%s%s%s%s%s\n", cd->cdi.name,
+	sr_printk(KERN_INFO, cd, "scsi3-mmc drive: %dx/%dx %s%s%s%s%s%s",
 	       ((buffer[n + 14] << 8) + buffer[n + 15]) / 176,
 	       cd->cdi.speed,
 	       buffer[n + 3] & 0x01 ? "writer " : "", /* CD Writer */
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 37c8f6b..1610cac 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -55,6 +55,10 @@ typedef struct scsi_cd {
 	struct gendisk *disk;
 } Scsi_CD;
 
+#define sr_printk(prefix, scd, fmt, a...)				\
+	sdev_printk(prefix, (scd)->device, "[%s] " fmt,		\
+		    (scd)->cdi.name, ##a)
+
 int sr_do_ioctl(Scsi_CD *, struct packet_command *);
 
 int sr_lock_door(struct cdrom_device_info *, int);
-- 
1.7.4.2

