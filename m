From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] Add 192 byte MODE SENSE flag
Date: Sat, 13 Mar 2004 17:50:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040313175044.B3101@beaverton.ibm.com>
References: <20040313174651.A3054@beaverton.ibm.com> <20040313174906.A3101@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:46769 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263249AbUCNBvB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Mar 2004 20:51:01 -0500
Content-Disposition: inline
In-Reply-To: <20040313174906.A3101@beaverton.ibm.com>; from patmans@us.ibm.com on Sat, Mar 13, 2004 at 05:49:06PM -0800
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu, mdharm-usb@one-eyed-alien.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

Add a BLIST_MS_192_BYTES_FOR_3F flag. If it is set, sends a 192 byte MODE
SENSE in sd.c.

diff -uprN -X /home/patman/dontdiff add_sdev_bflags-2.6/drivers/scsi/scsi_scan.c 192_byte_ms-2.6/drivers/scsi/scsi_scan.c
--- add_sdev_bflags-2.6/drivers/scsi/scsi_scan.c	Fri Mar 12 16:07:10 2004
+++ 192_byte_ms-2.6/drivers/scsi/scsi_scan.c	Fri Mar 12 16:17:55 2004
@@ -643,6 +643,9 @@ static int scsi_add_lun(struct scsi_devi
 	if (*bflags & BLIST_USE_10_BYTE_MS)
 		sdev->use_10_for_ms = 1;
 
+	if (*bflags & BLIST_MS_192_BYTES_FOR_3F)
+		sdev->use_192_bytes_for_3f = 1;
+
 	if(sdev->host->hostt->slave_configure)
 		sdev->host->hostt->slave_configure(sdev);
 
diff -uprN -X /home/patman/dontdiff add_sdev_bflags-2.6/drivers/scsi/sd.c 192_byte_ms-2.6/drivers/scsi/sd.c
--- add_sdev_bflags-2.6/drivers/scsi/sd.c	Fri Mar 12 16:07:10 2004
+++ 192_byte_ms-2.6/drivers/scsi/sd.c	Fri Mar 12 16:17:55 2004
@@ -1122,26 +1122,32 @@ sd_read_write_protect_flag(struct scsi_d
 		return;
 	}
 
-	/*
-	 * First attempt: ask for all pages (0x3F), but only 4 bytes.
-	 * We have to start carefully: some devices hang if we ask
-	 * for more than is available.
-	 */
-	res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, &data);
+	if (sdkp->device->use_192_bytes_for_3f) {
+		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 192, &data);
+	} else {
+		/*
+		 * First attempt: ask for all pages (0x3F), but only 4 bytes.
+		 * We have to start carefully: some devices hang if we ask
+		 * for more than is available.
+		 */
+		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, &data);
 
-	/*
-	 * Second attempt: ask for page 0
-	 * When only page 0 is implemented, a request for page 3F may return
-	 * Sense Key 5: Illegal Request, Sense Code 24: Invalid field in CDB.
-	 */
-	if (!scsi_status_is_good(res))
-		res = sd_do_mode_sense(SRpnt, 0, 0, buffer, 4, &data);
+		/*
+		 * Second attempt: ask for page 0 When only page 0 is
+		 * implemented, a request for page 3F may return Sense Key
+		 * 5: Illegal Request, Sense Code 24: Invalid field in
+		 * CDB.
+		 */
+		if (!scsi_status_is_good(res))
+			res = sd_do_mode_sense(SRpnt, 0, 0, buffer, 4, &data);
 
-	/*
-	 * Third attempt: ask 255 bytes, as we did earlier.
-	 */
-	if (!scsi_status_is_good(res))
-		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255, &data);
+		/*
+		 * Third attempt: ask 255 bytes, as we did earlier.
+		 */
+		if (!scsi_status_is_good(res))
+			res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255,
+					       &data);
+	}
 
 	if (!scsi_status_is_good(res)) {
 		printk(KERN_WARNING
diff -uprN -X /home/patman/dontdiff add_sdev_bflags-2.6/include/scsi/scsi_device.h 192_byte_ms-2.6/include/scsi/scsi_device.h
--- add_sdev_bflags-2.6/include/scsi/scsi_device.h	Fri Mar 12 16:16:47 2004
+++ 192_byte_ms-2.6/include/scsi/scsi_device.h	Fri Mar 12 16:17:55 2004
@@ -97,6 +97,7 @@ struct scsi_device {
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
+	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
 
diff -uprN -X /home/patman/dontdiff add_sdev_bflags-2.6/include/scsi/scsi_devinfo.h 192_byte_ms-2.6/include/scsi/scsi_devinfo.h
--- add_sdev_bflags-2.6/include/scsi/scsi_devinfo.h	Thu Mar 11 11:23:27 2004
+++ 192_byte_ms-2.6/include/scsi/scsi_devinfo.h	Fri Mar 12 16:17:55 2004
@@ -19,4 +19,5 @@
 #define BLIST_MS_SKIP_PAGE_08	0x2000	/* do not send ms page 0x08 */
 #define BLIST_MS_SKIP_PAGE_3F	0x4000	/* do not send ms page 0x3f */
 #define BLIST_USE_10_BYTE_MS	0x8000	/* use 10 byte ms before 6 byte ms */
+#define BLIST_MS_192_BYTES_FOR_3F	0x10000	/*  192 byte ms page 0x3f request */
 #endif
