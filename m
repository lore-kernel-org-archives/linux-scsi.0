From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove dead struct scsi_device members
Date: Sun, 27 Apr 2003 14:04:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427140441.A27904@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:54795 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263944AbTD0Lw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 07:52:29 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

->scpnt_wait is initialized and cpqfc calls wake_up on it but no one
ever waits for it, ->allow_revalidate is completly unused.


--- 1.35/drivers/scsi/cpqfcTSinit.c	Sat Apr 26 10:28:19 2003
+++ edited/drivers/scsi/cpqfcTSinit.c	Sun Apr 27 09:12:47 2003
@@ -677,11 +677,6 @@
         scsi_release_request(ScsiPassThruReq); // "de-allocate"
         ScsiPassThruReq = NULL;
 
-        // if (!SDpnt->was_reset && SDpnt->scsi_request_fn)
-        //  (*SDpnt->scsi_request_fn)();
-
-        wake_up(&SDpnt->scpnt_wait);
-
 	// need to pass data back to user (space)?
 	if( (vendor_cmd->rw_flag == VENDOR_READ_OPCODE) &&
 	     vendor_cmd->len )
@@ -1656,10 +1651,6 @@
   scsi_put_command(SCpnt);
   SCpnt = NULL;
 
-  // if (!SDpnt->was_reset && SDpnt->scsi_request_fn)
-  // 	(*SDpnt->scsi_request_fn)();
-
-  wake_up(&SDpnt->scpnt_wait);
   // printk("   LEAVING cpqfcTS_TargetDeviceReset() - return SUCCESS \n");
   return SUCCESS;
 }
--- 1.75/drivers/scsi/scsi.h	Wed Apr 23 04:06:29 2003
+++ edited/drivers/scsi/scsi.h	Sun Apr 27 10:45:24 2003
@@ -540,8 +321,6 @@
 	 */
 	struct list_head    siblings;   /* list of all devices on this host */
 	struct list_head    same_target_siblings; /* just the devices sharing same target id */
-	wait_queue_head_t   scpnt_wait;	/* Used to wait if
-					   device is busy */
 	struct Scsi_Host *host;
 	request_queue_t *request_queue;
 	volatile unsigned short device_busy;	/* commands actually active on low-level */
@@ -619,9 +396,6 @@
   	/* default value if the device doesn't override */
 	#define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
-
-	// Flag to allow revalidate to succeed in sd_open
-	int allow_revalidate;
 	struct device sdev_driverfs_dev;
 };
 #define	to_scsi_device(d)	\
--- 1.80/drivers/scsi/scsi_scan.c	Thu Apr 24 12:55:44 2003
+++ edited/drivers/scsi/scsi_scan.c	Sun Apr 27 09:12:47 2003
@@ -429,7 +429,6 @@
 
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
-	init_waitqueue_head(&sdev->scpnt_wait);
 
 	if (shost->hostt->slave_alloc) {
 		if (shost->hostt->slave_alloc(sdev))
