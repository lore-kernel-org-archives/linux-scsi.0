From: "Jason J. Herne" <hernejj@gmail.com>
Subject: [PATCH] USB enclosures seem to require read(16) with >2TB drives
Date: Fri,  9 Nov 2012 11:08:09 -0500
Message-ID: <1352477289-8133-1-git-send-email-hernejj@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53623 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2KIQIO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Nov 2012 11:08:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-usb@vger.kernel.org, stern@rowland.harvard.edu, "Jason J. Herne" <hernejj@gmail.com>

From: "Jason J. Herne" <hernejj@gmail.com>

Force large capacity (> 2TB) drives in USB enclosures to use READ(16) instead
of READ(10).  Some(most/all?) enclosures do not like READ(10) commands when a
large capacity drive is installed.

Signed-off-by: Jason J. Herne <hernejj@gmail.com>
---
 drivers/scsi/sd.c              |    7 +++++--
 drivers/usb/storage/scsiglue.c |    5 +++++
 include/scsi/scsi_device.h     |    1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4b63c73..9b65ddf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -649,7 +649,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	sector_t block = blk_rq_pos(rq);
 	sector_t threshold;
 	unsigned int this_count = blk_rq_sectors(rq);
-	int ret, host_dif;
+	int ret, host_dif, force_read16;
 	unsigned char protect;
 
 	/*
@@ -797,6 +797,9 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	else
 		protect = 0;
 
+	/* Many large capacity USB drives/controllers require the use of read(16). */
+	force_read16 = (sdkp->capacity > 0xffffffffULL && sdp->force_read_16);
+
 	if (host_dif == SD_DIF_TYPE2_PROTECTION) {
 		SCpnt->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);
 
@@ -833,7 +836,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		SCpnt->cmnd[29] = (unsigned char) (this_count >> 16) & 0xff;
 		SCpnt->cmnd[30] = (unsigned char) (this_count >> 8) & 0xff;
 		SCpnt->cmnd[31] = (unsigned char) this_count & 0xff;
-	} else if (block > 0xffffffff) {
+	} else if (block > 0xffffffff || force_read16) {
 		SCpnt->cmnd[0] += READ_16 - READ_6;
 		SCpnt->cmnd[1] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
 		SCpnt->cmnd[2] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 13b8bcd..6ff785e 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -251,6 +251,11 @@ static int slave_configure(struct scsi_device *sdev)
 					US_FL_SCM_MULT_TARG)) &&
 				us->protocol == USB_PR_BULK)
 			us->use_last_sector_hacks = 1;
+
+		/* Force read-16 for large capacity drives. */
+		sdev->force_read_16 = 1;
+
+
 	} else {
 
 		/* Non-disk-type devices don't need to blacklist any pages
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5591ed5..e92b846 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -134,6 +134,7 @@ struct scsi_device {
 				     * because we did a bus reset. */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
+	unsigned force_read_16:1; /* Use read(16) over read(10) */
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
-- 
1.7.9.5

