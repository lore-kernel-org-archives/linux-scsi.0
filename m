From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill unused scsi_device fields
Date: Fri, 6 Jun 2003 10:04:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606080426.GF18838@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:17361 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264650AbTFFHu4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 03:50:56 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Thu Jun  5 12:06:03 2003
+++ b/drivers/scsi/scsi.h	Thu Jun  5 12:06:03 2003
@@ -355,14 +355,12 @@
 	char * model;		/* ... after scan; point to static string */
 	char * rev;		/* ... "nullnullnullnull" before scan */
 	unsigned char current_tag;	/* current tag */
-//	unsigned char sync_min_period;	/* Not less than this period */
-//	unsigned char sync_max_offset;	/* Not greater than this offset */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
 	unsigned online:1;
+
 	unsigned writeable:1;
 	unsigned removable:1;
-	unsigned random:1;
 	unsigned changed:1;	/* Data invalid due to media change */
 	unsigned busy:1;	/* Used to prevent races */
 	unsigned lockable:1;	/* Able to prevent media removal */
@@ -388,9 +386,6 @@
 				     * because we did a bus reset. */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
-	unsigned remap:1;	/* support remapping  */
-//	unsigned sync:1;	/* Sync transfer state, managed by host */
-//	unsigned wide:1;	/* WIDE transfer state, managed by host */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Thu Jun  5 12:06:03 2003
+++ b/drivers/scsi/scsi_lib.c	Thu Jun  5 12:06:03 2003
@@ -730,17 +730,6 @@
 	 * can choose a block to remap, etc.
 	 */
 	if (driver_byte(result) != 0) {
-		if (suggestion(result) == SUGGEST_REMAP) {
-#ifdef REMAP
-			/*
-			 * Not yet implemented.  A read will fail after being remapped,
-			 * a write will call the strategy routine again.
-			 */
-			if (cmd->device->remap) {
-				result = 0;
-			}
-#endif
-		}
 		if ((cmd->sense_buffer[0] & 0x7f) == 0x70) {
 			/*
 			 * If the device is in the process of becoming ready,
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Thu Jun  5 12:06:03 2003
+++ b/drivers/scsi/scsi_scan.c	Thu Jun  5 12:06:03 2003
@@ -541,8 +541,6 @@
 		printk(KERN_INFO "scsi: unknown device type %d\n", sdev->type);
 	}
 
-	sdev->random = (sdev->type == TYPE_TAPE) ? 0 : 1;
-
 	scsi_set_name(sdev, inq_result);
 
 	print_inquiry(inq_result);
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Thu Jun  5 12:06:03 2003
+++ b/drivers/scsi/sd.c	Thu Jun  5 12:06:03 2003
@@ -1271,8 +1271,6 @@
 		
 	SRpnt->sr_device->use_10_for_rw = 1;
 	SRpnt->sr_device->use_10_for_ms = 0;
-	SRpnt->sr_device->remap = 1;
-
  leave:
 	scsi_release_request(SRpnt);
 
diff -Nru a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Thu Jun  5 12:06:03 2003
+++ b/drivers/scsi/sr.c	Thu Jun  5 12:06:03 2003
@@ -526,7 +526,6 @@
 	sdev->sector_size = 2048;	/* A guess, just in case */
 	sdev->use_10_for_rw = 1;
 	sdev->use_10_for_ms = 0;
-	sdev->remap = 1;
 
 	/* FIXME: need to handle a get_capabilities failure properly ?? */
 	get_capabilities(cd);
