From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Clean up scsi_add_lun a bit
Date: Wed, 11 Jul 2007 12:54:55 -0600
Message-ID: <20070711185455.GU9704@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46018 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145AbXGKSy5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2007 14:54:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch tidies up scsi_add_lun a bit.  I rewrote the kerneldoc to match
the actual parameters, moved the check for RBC and MMC REPORT_LUN devices
away from the switch(), changed the setup of sdev->type to account for
BLIST_ISROM, moved the check for BLIST_NO_ULD_ATTACH further down in
the function, removed a bogus comment and fixed some whitespace issues.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 662577f..fe7e90b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -703,16 +703,14 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 /**
  * scsi_add_lun - allocate and fully initialze a scsi_device
- * @sdevscan:	holds information to be stored in the new scsi_device
- * @sdevnew:	store the address of the newly allocated scsi_device
+ * @sdev:	holds information to be stored in the new scsi_device
  * @inq_result:	holds the result of a previous INQUIRY to the LUN
  * @bflags:	black/white list flag
+ * @async:	1 if this device is being scanned asynchronously
  *
  * Description:
- *     Allocate and initialize a scsi_device matching sdevscan. Optionally
- *     set fields based on values in *@bflags. If @sdevnew is not
- *     NULL, store the address of the new scsi_device in *@sdevnew (needed
- *     when scanning a particular LUN).
+ *     Initialize the scsi_device @sdev.  Optionally set fields based
+ *     on values in *@bflags.
  *
  * Return:
  *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a scsi_device
@@ -752,25 +750,15 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->rev = (char *) (sdev->inquiry + 32);
 
 	if (*bflags & BLIST_ISROM) {
-		/*
-		 * It would be better to modify sdev->type, and set
-		 * sdev->removable; this can now be done since
-		 * print_inquiry has gone away.
-		 */
-		inq_result[0] = TYPE_ROM;
-		inq_result[1] |= 0x80;	/* removable */
-	} else if (*bflags & BLIST_NO_ULD_ATTACH)
-		sdev->no_uld_attach = 1;
+		sdev->type = TYPE_ROM;
+		sdev->removable = 1;
+	} else {
+		sdev->type = (inq_result[0] & 0x1f);
+		sdev->removable = (inq_result[1] & 0x80) >> 7;
+	}
 
-	switch (sdev->type = (inq_result[0] & 0x1f)) {
+	switch (sdev->type) {
 	case TYPE_RBC:
-		/* RBC devices can return SCSI-3 compliance and yet
-		 * still not support REPORT LUNS, so make them act as
-		 * BLIST_NOREPORTLUN unless BLIST_REPORTLUN2 is
-		 * specifically set */
-		if ((*bflags & BLIST_REPORTLUN2) == 0)
-			*bflags |= BLIST_NOREPORTLUN;
-		/* fall through */
 	case TYPE_TAPE:
 	case TYPE_DISK:
 	case TYPE_PRINTER:
@@ -784,13 +772,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		sdev->writeable = 1;
 		break;
 	case TYPE_ROM:
-		/* MMC devices can return SCSI-3 compliance and yet
-		 * still not support REPORT LUNS, so make them act as
-		 * BLIST_NOREPORTLUN unless BLIST_REPORTLUN2 is
-		 * specifically set */
-		if ((*bflags & BLIST_REPORTLUN2) == 0)
-			*bflags |= BLIST_NOREPORTLUN;
-		/* fall through */
 	case TYPE_WORM:
 		sdev->writeable = 0;
 		break;
@@ -798,6 +779,15 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		printk(KERN_INFO "scsi: unknown device type %d\n", sdev->type);
 	}
 
+	if (sdev->type == TYPE_RBC || sdev->type == TYPE_ROM) {
+		/* RBC and MMC devices can return SCSI-3 compliance and yet
+		 * still not support REPORT LUNS, so make them act as
+		 * BLIST_NOREPORTLUN unless BLIST_REPORTLUN2 is
+		 * specifically set */
+		if ((*bflags & BLIST_REPORTLUN2) == 0)
+			*bflags |= BLIST_NOREPORTLUN;
+	}
+
 	/*
 	 * For a peripheral qualifier (PQ) value of 1 (001b), the SCSI
 	 * spec says: The device server is capable of supporting the
@@ -815,12 +805,11 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 */ 
 
 	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
-	sdev->removable = (0x80 & inq_result[1]) >> 7;
 	sdev->lockable = sdev->removable;
 	sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
 
-	if (sdev->scsi_level >= SCSI_3 || (sdev->inquiry_len > 56 &&
-		inq_result[56] & 0x04))
+	if (sdev->scsi_level >= SCSI_3 ||
+			(sdev->inquiry_len > 56 && inq_result[56] & 0x04))
 		sdev->ppr = 1;
 	if (inq_result[7] & 0x60)
 		sdev->wdtr = 1;
@@ -833,13 +822,10 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			sdev->inq_periph_qual, inq_result[2] & 0x07,
 			(inq_result[3] & 0x0f) == 1 ? " CCS" : "");
 
-	/*
-	 * End sysfs code.
-	 */
-
 	if ((sdev->scsi_level >= SCSI_2) && (inq_result[7] & 2) &&
 	    !(*bflags & BLIST_NOTQ))
 		sdev->tagged_supported = 1;
+
 	/*
 	 * Some devices (Texel CD ROM drives) have handshaking problems
 	 * when used with the Seagate controllers. borken is initialized
@@ -848,6 +834,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if ((*bflags & BLIST_BORKEN) == 0)
 		sdev->borken = 0;
 
+	if (*bflags & BLIST_NO_ULD_ATTACH)
+		sdev->no_uld_attach = 1;
+
 	/*
 	 * Apparently some really broken devices (contrary to the SCSI
 	 * standards) need to be selected without asserting ATN
@@ -872,7 +861,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_SINGLELUN)
 		sdev->single_lun = 1;
 
-
 	sdev->use_10_for_rw = 1;
 
 	if (*bflags & BLIST_MS_SKIP_PAGE_08)

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
