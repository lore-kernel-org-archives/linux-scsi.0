From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] scsi: remove various unused blist flags
Date: Mon, 19 Jun 2017 14:27:23 +0200
Message-ID: <20170619122724.32720-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35572 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753942AbdFSM11 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jun 2017 08:27:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_scan.c    | 25 ++-----------------------
 include/scsi/scsi_devinfo.h |  9 ---------
 2 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e6de4eee97a3..3c4403210a1a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -656,8 +656,6 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		if (pass == 1) {
 			if (BLIST_INQUIRY_36 & *bflags)
 				next_inquiry_len = 36;
-			else if (BLIST_INQUIRY_58 & *bflags)
-				next_inquiry_len = 58;
 			else if (sdev->inquiry_len)
 				next_inquiry_len = sdev->inquiry_len;
 			else
@@ -927,15 +925,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	sdev->use_10_for_rw = 1;
 
-	if (*bflags & BLIST_MS_SKIP_PAGE_08)
-		sdev->skip_ms_page_8 = 1;
-
-	if (*bflags & BLIST_MS_SKIP_PAGE_3F)
-		sdev->skip_ms_page_3f = 1;
-
-	if (*bflags & BLIST_USE_10_BYTE_MS)
-		sdev->use_10_for_ms = 1;
-
 	/* some devices don't like REPORT SUPPORTED OPERATION CODES
 	 * and will simply timeout causing sd_mod init to take a very
 	 * very long time */
@@ -957,9 +946,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		return SCSI_SCAN_NO_RESPONSE;
 	}
 
-	if (*bflags & BLIST_MS_192_BYTES_FOR_3F)
-		sdev->use_192_bytes_for_3f = 1;
-
 	if (*bflags & BLIST_NOT_LOCKABLE)
 		sdev->lockable = 0;
 
@@ -969,9 +955,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_NO_DIF)
 		sdev->no_dif = 1;
 
-	if (*bflags & BLIST_SYNC_ALUA)
-		sdev->synchronous_alua = 1;
-
 	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
 
 	if (*bflags & BLIST_TRY_VPD_PAGES)
@@ -1109,7 +1092,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	/*
 	 * result contains valid SCSI INQUIRY data.
 	 */
-	if (((result[0] >> 5) == 3) && !(bflags & BLIST_ATTACH_PQ3)) {
+	if ((result[0] >> 5) == 3) {
 		/*
 		 * For a Peripheral qualifier 3 (011b), the SCSI
 		 * spec says: The device server is not capable of
@@ -1267,11 +1250,7 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 	 */
 	if (scsi_level < SCSI_3 && !(bflags & BLIST_LARGELUN))
 		max_dev_lun = min(8U, max_dev_lun);
-
-	/*
-	 * Stop scanning at 255 unless BLIST_SCSI3LUN
-	 */
-	if (!(bflags & BLIST_SCSI3LUN))
+	else
 		max_dev_lun = min(256U, max_dev_lun);
 
 	/*
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 9f750cb63b03..9592570e092a 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -15,12 +15,7 @@
 #define BLIST_ISROM     	0x100	/* Treat as (removable) CD-ROM */
 #define BLIST_LARGELUN		0x200	/* LUNs past 7 on a SCSI-2 device */
 #define BLIST_INQUIRY_36	0x400	/* override additional length field */
-#define BLIST_INQUIRY_58	0x800	/* ... for broken inquiry responses */
 #define BLIST_NOSTARTONADD	0x1000	/* do not do automatic start on add */
-#define BLIST_MS_SKIP_PAGE_08	0x2000	/* do not send ms page 0x08 */
-#define BLIST_MS_SKIP_PAGE_3F	0x4000	/* do not send ms page 0x3f */
-#define BLIST_USE_10_BYTE_MS	0x8000	/* use 10 byte ms before 6 byte ms */
-#define BLIST_MS_192_BYTES_FOR_3F	0x10000	/*  192 byte ms page 0x3f request */
 #define BLIST_REPORTLUN2	0x20000	/* try REPORT_LUNS even for SCSI-2 devs
  					   (if HBA supports more than 8 LUNs) */
 #define BLIST_NOREPORTLUN	0x40000	/* don't try REPORT_LUNS scan (SCSI-3 devs) */
@@ -29,14 +24,10 @@
 #define BLIST_SELECT_NO_ATN	0x200000 /* select without ATN */
 #define BLIST_RETRY_HWERROR	0x400000 /* retry HARDWARE_ERROR */
 #define BLIST_MAX_512		0x800000 /* maximum 512 sector cdb length */
-#define BLIST_ATTACH_PQ3	0x1000000 /* Scan: Attach to PQ3 devices */
 #define BLIST_NO_DIF		0x2000000 /* Disable T10 PI (DIF) */
 #define BLIST_SKIP_VPD_PAGES	0x4000000 /* Ignore SBC-3 VPD pages */
-#define BLIST_SCSI3LUN		0x8000000 /* Scan more than 256 LUNs
-					     for sequential scan */
 #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
 #define BLIST_MAX_1024		0x40000000 /* maximum 1024 sector cdb length */
-#define BLIST_SYNC_ALUA		0x80000000 /* Synchronous ALUA commands */
 
 #endif
-- 
2.11.0
