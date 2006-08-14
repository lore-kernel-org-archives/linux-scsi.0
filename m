From: Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC] Sanitize INQUIRY vendor, product and revision strings
Date: Mon, 14 Aug 2006 12:34:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0608141221520.7399-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:22801 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751568AbWHNQe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Aug 2006 12:34:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Klaus Muth <muth@hagos.de>

Does anyone object to the patch below?  It would help at least one person; 
I'm concerned that it might cause trouble somewhere else.

The idea is to replace all non-graphic characters in the INQUIRY ASCII 
strings with ' '.  According to the SCSI spec these fields shouldn't 
contain any non-graphic characters to begin with, but some non-compliant 
devices have NUL characters and possibly others.

Alan Stern


Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -148,27 +148,19 @@ static void scsi_unlock_floptical(struct
 static void print_inquiry(unsigned char *inq_result)
 {
 	int i;
+	int n = inq_result[4] + 5;
 
 	printk(KERN_NOTICE "  Vendor: ");
 	for (i = 8; i < 16; i++)
-		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
-			printk("%c", inq_result[i]);
-		else
-			printk(" ");
+		printk("%c", (i < n ? inq_result[i] : ' '));
 
 	printk("  Model: ");
 	for (i = 16; i < 32; i++)
-		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
-			printk("%c", inq_result[i]);
-		else
-			printk(" ");
+		printk("%c", (i < n ? inq_result[i] : ' '));
 
 	printk("  Rev: ");
 	for (i = 32; i < 36; i++)
-		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
-			printk("%c", inq_result[i]);
-		else
-			printk(" ");
+		printk("%c", (i < n ? inq_result[i] : ' '));
 
 	printk("\n");
 
@@ -463,13 +455,14 @@ void scsi_target_reap(struct scsi_target
  *     INQUIRY data is in @inq_result; the scsi_level and INQUIRY length
  *     are copied to the scsi_device any flags value is stored in *@bflags.
  **/
-static int scsi_probe_lun(struct scsi_device *sdev, char *inq_result,
+static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			  int result_len, int *bflags)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count, result;
+	int i;
 	struct scsi_sense_hdr sshdr;
 
 	*bflags = 0;
@@ -526,6 +519,12 @@ static int scsi_probe_lun(struct scsi_de
 		if (response_len > 255)
 			response_len = first_inquiry_len;	/* sanity */
 
+		/* Sanitize the Vendor, Product, and Revision fields. */
+		for (i = 8; i < 36; ++i) {
+			if (inq_result[i] < 0x20 || inq_result[i] > 0x7e)
+				inq_result[i] = ' ';
+		}
+
 		/*
 		 * Get any flags for this device.
 		 *
@@ -628,7 +627,8 @@ static int scsi_probe_lun(struct scsi_de
  *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a scsi_device
  *     SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
  **/
-static int scsi_add_lun(struct scsi_device *sdev, char *inq_result, int *bflags)
+static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
+		int *bflags)
 {
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,

