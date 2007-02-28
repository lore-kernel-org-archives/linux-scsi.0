From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/4] SCSI: Convert sd logging to new printk helpers
Date: Tue, 27 Feb 2007 22:41:19 -0500
Message-ID: <yq11wkb6ja8.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:43584 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbXB1Dm7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Feb 2007 22:42:59 -0500
Received: from rgmgw3.us.oracle.com (rgmgw3.us.oracle.com [138.1.186.112])
	by rgminet01.oracle.com (Switch-3.2.4/Switch-3.1.6) with ESMTP id l1S3gv1H032699
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2007 20:42:57 -0700
Received: from rcsmt250.oracle.com (rcsmt250.oracle.com [148.87.90.195])
	by rgmgw3.us.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l1S3AVvX031248
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2007 20:42:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Convert the sd.c SCSI logging calls to scmd_printk()/sd_printk()
instead of plain printk().

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

--- 

 sd.c |   50 +++++++++++++++++++++++++++++---------------------
 1 files changed, 29 insertions(+), 21 deletions(-)


Index: scsi-misc-2.6/drivers/scsi/sd.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sd.c
+++ scsi-misc-2.6/drivers/scsi/sd.c
@@ -312,15 +312,19 @@ static int sd_init_command(struct scsi_c
 	unsigned int this_count = SCpnt->request_bufflen >> 9;
 	unsigned int timeout = sdp->timeout;
 
-	SCSI_LOG_HLQUEUE(1, printk("sd_init_command: disk=%s, block=%llu, "
-			    "count=%d\n", disk->disk_name,
-			 (unsigned long long)block, this_count));
+	SCSI_LOG_HLQUEUE(1, scmd_printk(KERN_INFO, SCpnt,
+					"sd_init_command: block=%llu, "
+					"count=%d\n",
+					(unsigned long long)block,
+					this_count));
 
 	if (!sdp || !scsi_device_online(sdp) ||
  	    block + rq->nr_sectors > get_capacity(disk)) {
-		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n", 
-				 rq->nr_sectors));
-		SCSI_LOG_HLQUEUE(2, printk("Retry with 0x%p\n", SCpnt));
+		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
+						"Finishing %ld sectors\n",
+						rq->nr_sectors));
+		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
+						"Retry with 0x%p\n", SCpnt));
 		return 0;
 	}
 
@@ -332,8 +336,8 @@ static int sd_init_command(struct scsi_c
 		/* printk("SCSI disk has been changed. Prohibiting further I/O.\n"); */
 		return 0;
 	}
-	SCSI_LOG_HLQUEUE(2, printk("%s : block=%llu\n",
-				   disk->disk_name, (unsigned long long)block));
+	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=%llu\n",
+					(unsigned long long)block));
 
 	/*
 	 * If we have a 1K hardware sectorsize, prevent access to single
@@ -390,9 +394,11 @@ static int sd_init_command(struct scsi_c
 		return 0;
 	}
 
-	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n", 
-		disk->disk_name, (rq_data_dir(rq) == WRITE) ? 
-		"writing" : "reading", this_count, rq->nr_sectors));
+	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
+					"%s %d/%ld 512 byte blocks.\n",
+					(rq_data_dir(rq) == WRITE) ?
+					"writing" : "reading", this_count,
+					rq->nr_sectors));
 
 	SCpnt->cmnd[1] = 0;
 	
@@ -494,7 +500,7 @@ static int sd_open(struct inode *inode, 
 		return -ENXIO;
 
 
-	SCSI_LOG_HLQUEUE(3, printk("sd_open: disk=%s\n", disk->disk_name));
+	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_open\n"));
 
 	sdev = sdkp->device;
 
@@ -564,7 +570,7 @@ static int sd_release(struct inode *inod
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdev = sdkp->device;
 
-	SCSI_LOG_HLQUEUE(3, printk("sd_release: disk=%s\n", disk->disk_name));
+	SCSI_LOG_HLQUEUE(3, sdkp_printk(KERN_INFO, sdkp, "sd_release\n"));
 
 	if (!--sdkp->openers && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
@@ -677,8 +683,7 @@ static int sd_media_changed(struct gendi
 	struct scsi_device *sdp = sdkp->device;
 	int retval;
 
-	SCSI_LOG_HLQUEUE(3, printk("sd_media_changed: disk=%s\n",
-						disk->disk_name));
+	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_media_changed\n"));
 
 	if (!sdp->removable)
 		return 0;
@@ -871,12 +876,14 @@ static void sd_rw_intr(struct scsi_cmnd 
 			sense_deferred = scsi_sense_is_deferred(&sshdr);
 	}
 #ifdef CONFIG_SCSI_LOGGING
-	SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: %s: res=0x%x\n", 
-				SCpnt->request->rq_disk->disk_name, result));
+	SCSI_LOG_HLCOMPLETE(1, scsi_print_result(SCpnt));
 	if (sense_valid) {
-		SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: sb[respc,sk,asc,"
-				"ascq]=%x,%x,%x,%x\n", sshdr.response_code,
-				sshdr.sense_key, sshdr.asc, sshdr.ascq));
+		SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
+						   "sd_rw_intr: sb[respc,sk,asc,"
+						   "ascq]=%x,%x,%x,%x\n",
+						   sshdr.response_code,
+						   sshdr.sense_key, sshdr.asc,
+						   sshdr.ascq));
 	}
 #endif
 	if (driver_byte(result) != DRIVER_SENSE &&
@@ -1458,7 +1465,8 @@ static int sd_revalidate_disk(struct gen
 	unsigned char *buffer;
 	unsigned ordered;
 
-	SCSI_LOG_HLQUEUE(3, printk("sd_revalidate_disk: disk=%s\n", disk->disk_name));
+	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
+				      "sd_revalidate_disk\n"));
 
 	/*
 	 * If the device is offline, don't try and read capacity or any
