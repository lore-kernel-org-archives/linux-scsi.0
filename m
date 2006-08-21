From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: sanitize INQUIRY strings
Date: Mon, 21 Aug 2006 15:53:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0608211549160.5767-100000@iolanthe.rowland.org>
References: <20060821182745.GB24068@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:27147 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1750880AbWHUTx2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 15:53:28 -0400
In-Reply-To: <20060821182745.GB24068@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <matthew@wil.cx>
Cc: "Philip R. Auld" <pauld@egenera.com>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as766b) sanitizes the Vendor, Product, and Revision strings
contained in an INQUIRY result, by setting all non-graphic or non-ASCII
characters to ' '.  Since the standard disallows such characters, this
will affect only non-compliant devices.

To help maintain backward compatibility, NUL characters are treated
specially.  They are taken as string terminators; they and all the
following characters are set to ' '.  If some valid characters get
erased as a result... well, we weren't seeing them before so we haven't
lost anything.

The primary purpose of this change is to allow blacklist entries to
match devices with illegal Vendor or Product strings.

In addition, the patch updates a couple of function prototypes, giving
inq_result its correct type (unsigned char *).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -397,6 +397,32 @@ void scsi_target_reap(struct scsi_target
 }
 
 /**
+ * sanitize_inquiry_string - remove non-graphical chars from an INQUIRY result string
+ * @s: INQUIRY result string to sanitize
+ * @len: length of the string
+ *
+ * Description:
+ *	The SCSI spec says that INQUIRY vendor, product, and revision
+ *	strings must consist entirely of graphic ASCII characters,
+ *	padded on the right with spaces.  Since not all devices obey
+ *	this rule, we will replace non-graphic or non-ASCII characters
+ *	with spaces.  Exception: a NUL character is interpreted as a
+ *	string terminator, so all the following characters are set to
+ *	spaces.
+ **/
+static void sanitize_inquiry_string(unsigned char *s, int len)
+{
+	int terminated = 0;
+
+	for (; len > 0; (--len, ++s)) {
+		if (*s == 0)
+			terminated = 1;
+		if (terminated || *s < 0x20 || *s > 0x7e)
+			*s = ' ';
+	}
+}
+
+/**
  * scsi_probe_lun - probe a single LUN using a SCSI INQUIRY
  * @sdev:	scsi_device to probe
  * @inq_result:	area to store the INQUIRY result
@@ -410,7 +436,7 @@ void scsi_target_reap(struct scsi_target
  *     INQUIRY data is in @inq_result; the scsi_level and INQUIRY length
  *     are copied to the scsi_device any flags value is stored in *@bflags.
  **/
-static int scsi_probe_lun(struct scsi_device *sdev, char *inq_result,
+static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			  int result_len, int *bflags)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
@@ -469,7 +495,11 @@ static int scsi_probe_lun(struct scsi_de
 	}
 
 	if (result == 0) {
-		response_len = (unsigned char) inq_result[4] + 5;
+		sanitize_inquiry_string(&inq_result[8], 8);
+		sanitize_inquiry_string(&inq_result[16], 16);
+		sanitize_inquiry_string(&inq_result[32], 4);
+
+		response_len = inq_result[4] + 5;
 		if (response_len > 255)
 			response_len = first_inquiry_len;	/* sanity */
 
@@ -575,7 +605,8 @@ static int scsi_probe_lun(struct scsi_de
  *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a scsi_device
  *     SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
  **/
-static int scsi_add_lun(struct scsi_device *sdev, char *inq_result, int *bflags)
+static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
+		int *bflags)
 {
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,

