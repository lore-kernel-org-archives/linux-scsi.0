From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: (as283) Use 192-byte ms flag for page 08
Date: Tue, 18 May 2004 17:09:09 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0405181707320.933-100000@ida.rowland.org>
References: <20040518123306.A12344@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:28164 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263591AbUERVJK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 May 2004 17:09:10 -0400
In-Reply-To: <20040518123306.A12344@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

I'm reposting a couple of patches because they might not have gotten 
through the mailing list...


On Tue, 18 May 2004, Patrick Mansfield wrote:

> On Tue, May 18, 2004 at 11:30:44AM -0400, Alan Stern wrote:
> > Patrick:
> > 
> > Is there any objection to applying the patch below?  It changes the name 
> > of the BLIST_MS_192_BYTES_FOR_3F and use_192_bytes_for_3f flags, and uses 
> > them to select the transfer length for MODE SENSE queries of page 0x08 in 
> > sd.c as well as page 0x3f.
> > 
> > If you do accept the patch let me know, because a corresponding name 
> > change will be needed in the usb-storage driver at the same time.
> 
> Looks good to me, but James has to accept it.
> 
> PS: linux-scsi is apparently not sending anything out today.
> 
> -- Patrick Mansfield



===== include/scsi/scsi_device.h 1.11 vs edited =====
--- 1.11/include/scsi/scsi_device.h	Tue Mar 16 12:00:50 2004
+++ edited/include/scsi/scsi_device.h	Tue May 18 11:14:28 2004
@@ -102,7 +102,7 @@
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
-	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
+	unsigned use_192_bytes_for_ms:1; /* ask for 192 byte in MODE SENSE */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
 
===== include/scsi/scsi_devinfo.h 1.4 vs edited =====
--- 1.4/include/scsi/scsi_devinfo.h	Fri Mar 12 03:17:55 2004
+++ edited/include/scsi/scsi_devinfo.h	Tue May 18 11:18:50 2004
@@ -19,5 +19,5 @@
 #define BLIST_MS_SKIP_PAGE_08	0x2000	/* do not send ms page 0x08 */
 #define BLIST_MS_SKIP_PAGE_3F	0x4000	/* do not send ms page 0x3f */
 #define BLIST_USE_10_BYTE_MS	0x8000	/* use 10 byte ms before 6 byte ms */
-#define BLIST_MS_192_BYTES_FOR_3F	0x10000	/*  192 byte ms page 0x3f request */
+#define BLIST_MS_XFER_192_BYTES	0x10000	/* use 192 byte ms transfers */
 #endif
===== drivers/scsi/sd.c 1.63 vs edited =====
--- 1.63/drivers/scsi/sd.c	Wed Apr 14 13:12:45 2004
+++ edited/drivers/scsi/sd.c	Tue May 18 11:14:28 2004
@@ -1126,7 +1126,7 @@
 		return;
 	}
 
-	if (sdkp->device->use_192_bytes_for_3f) {
+	if (sdkp->device->use_192_bytes_for_ms) {
 		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 192, &data);
 	} else {
 		/*
@@ -1182,29 +1182,35 @@
 	if (sdkp->device->skip_ms_page_8)
 		goto defaults;
 
-	/* cautiously ask */
-	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);
-
-	if (!scsi_status_is_good(res))
-		goto bad_sense;
-
-	/* that went OK, now ask for the proper length */
-	len = data.length;
+	if (sdkp->device->use_192_bytes_for_ms) {
+		res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 192,
+					&data);
+	} else {
+		/* cautiously ask */
+		res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);
 
-	/*
-	 * We're only interested in the first three bytes, actually.
-	 * But the data cache page is defined for the first 20.
-	 */
-	if (len < 3)
-		goto bad_sense;
-	if (len > 20)
-		len = 20;
+		if (!scsi_status_is_good(res))
+			goto bad_sense;
 
-	/* Take headers and block descriptors into account */
-	len += data.header_length + data.block_descriptor_length;
+		/* that went OK, now ask for the proper length */
+		len = data.length;
 
-	/* Get the data */
-	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, len, &data);
+		/*
+		 * We're only interested in the first three bytes, actually.
+		 * But the data cache page is defined for the first 20.
+		 */
+		if (len < 3)
+			goto bad_sense;
+		if (len > 20)
+			len = 20;
+
+		/* Take headers and block descriptors into account */
+		len += data.header_length + data.block_descriptor_length;
+
+		/* Get the data */
+		res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, len,
+					&data);
+	}
 
 	if (scsi_status_is_good(res)) {
 		const char *types[] = {
===== drivers/scsi/scsi_scan.c 1.58 vs edited =====
--- 1.58/drivers/scsi/scsi_scan.c	Wed Apr 14 13:12:45 2004
+++ edited/drivers/scsi/scsi_scan.c	Tue May 18 11:20:04 2004
@@ -646,8 +646,8 @@
 	 * may do I/O */
 	scsi_device_set_state(sdev, SDEV_RUNNING);
 
-	if (*bflags & BLIST_MS_192_BYTES_FOR_3F)
-		sdev->use_192_bytes_for_3f = 1;
+	if (*bflags & BLIST_MS_XFER_192_BYTES)
+		sdev->use_192_bytes_for_ms = 1;
 
 	if(sdev->host->hostt->slave_configure)
 		sdev->host->hostt->slave_configure(sdev);

