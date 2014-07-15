From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] SCSI: Add a blacklist flag which enables VPD page inquiries
Date: Tue, 15 Jul 2014 12:49:17 -0400
Message-ID: <yq18unuwos2.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33698 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaGOQtZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jul 2014 12:49:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: KY Srinivasan <kys@microsoft.com>

    
Despite supporting modern SCSI features some storage devices continue to
claim conformance to an older version of the SPC spec. This is done for
compatibility with legacy operating systems.

Linux by default will not attempt to read VPD pages on devices that
claim SPC-2 or older. Introduce a blacklist flag that can be used to
trigger VPD page inquiries on devices that are known to support them.

Reported-by: KY Srinivasan <kys@microsoft.com>
Tested-by: KY Srinivasan <kys@microsoft.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
CC: <stable@vger.kernel.org>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4a6e4ba5a400..a5b1a224628a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -949,7 +949,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
 
-	if (*bflags & BLIST_SKIP_VPD_PAGES)
+	if (*bflags & BLIST_TRY_VPD_PAGES)
+		sdev->try_vpd_pages = 1;
+	else if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
 
 	transport_configure_device(&sdev->sdev_gendev);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 87566b51fcf7..31d32b9077ca 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2701,6 +2701,11 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 
 static int sd_try_extended_inquiry(struct scsi_device *sdp)
 {
+	/* Attempt VPD inquiry if the device blacklist explicitly calls
+	 * for it.
+	 */
+	if (sdp->try_vpd_pages)
+		return 1;
 	/*
 	 * Although VPD inquiries can go to SCSI-2 type devices,
 	 * some USB ones crash on receiving them, and the pages
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9aa38f7b303b..f579408620f0 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -155,6 +155,7 @@ struct scsi_device {
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned skip_vpd_pages:1;	/* do not read VPD pages */
+	unsigned try_vpd_pages:1;	/* attempt to read VPD pages */
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 8670c04e199e..1fdd6fc5492b 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -34,4 +34,5 @@
 #define BLIST_SKIP_VPD_PAGES	0x4000000 /* Ignore SBC-3 VPD pages */
 #define BLIST_SCSI3LUN		0x8000000 /* Scan more than 256 LUNs
 					     for sequential scan */
+#define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #endif
