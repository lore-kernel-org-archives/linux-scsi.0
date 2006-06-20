From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Print SCSI Inquiry data more compactly
Date: Tue, 20 Jun 2006 16:27:56 -0600
Message-ID: <20060620222756.GO1630@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:23190 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1751313AbWFTW15 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 18:27:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


print_inquiry is rather verbose, both in implementation and in output.
This patch reduces the output from two lines to one and reduces the
implementation to a single printk.

Sample output:
  Vendor: HP 18.2G  Model: ATLAS10K3_18_SCA  Rev: HP05
  Type:   Direct-Access                      ANSI SCSI revision: 02

becomes:

scsi 2:0:1:0: Device: HP 18.2G ATLAS10K3_18_SCA HP05 ANSI ver: 02               

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: drivers/scsi/scsi_scan.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_scan.c,v
retrieving revision 1.41
diff -u -p -r1.41 scsi_scan.c
--- drivers/scsi/scsi_scan.c	29 May 2006 02:51:18 -0000	1.41
+++ drivers/scsi/scsi_scan.c	20 Jun 2006 22:12:44 -0000
@@ -186,59 +186,6 @@ static void scsi_unlock_floptical(struct
 }
 
 /**
- * print_inquiry - printk the inquiry information
- * @inq_result:	printk this SCSI INQUIRY
- *
- * Description:
- *     printk the vendor, model, and other information found in the
- *     INQUIRY data in @inq_result.
- *
- * Notes:
- *     Remove this, and replace with a hotplug event that logs any
- *     relevant information.
- **/
-static void print_inquiry(unsigned char *inq_result)
-{
-	int i;
-
-	printk(KERN_NOTICE "  Vendor: ");
-	for (i = 8; i < 16; i++)
-		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
-			printk("%c", inq_result[i]);
-		else
-			printk(" ");
-
-	printk("  Model: ");
-	for (i = 16; i < 32; i++)
-		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
-			printk("%c", inq_result[i]);
-		else
-			printk(" ");
-
-	printk("  Rev: ");
-	for (i = 32; i < 36; i++)
-		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
-			printk("%c", inq_result[i]);
-		else
-			printk(" ");
-
-	printk("\n");
-
-	i = inq_result[0] & 0x1f;
-
-	printk(KERN_NOTICE "  Type:   %s ",
-	       i <
-	       MAX_SCSI_DEVICE_CODE ? scsi_device_types[i] :
-	       "Unknown          ");
-	printk("                 ANSI SCSI revision: %02x",
-	       inq_result[2] & 0x07);
-	if ((inq_result[2] & 0x07) == 1 && (inq_result[3] & 0x0f) == 1)
-		printk(" CCS\n");
-	else
-		printk("\n");
-}
-
-/**
  * scsi_alloc_sdev - allocate and setup a scsi_Device
  *
  * Description:
@@ -706,9 +653,8 @@ static int scsi_add_lun(struct scsi_devi
 	if (*bflags & BLIST_ISROM) {
 		/*
 		 * It would be better to modify sdev->type, and set
-		 * sdev->removable, but then the print_inquiry() output
-		 * would not show TYPE_ROM; if print_inquiry() is removed
-		 * the issue goes away.
+		 * sdev->removable; this can now be done since
+		 * print_inquiry has gone away.
 		 */
 		inq_result[0] = TYPE_ROM;
 		inq_result[1] |= 0x80;	/* removable */
@@ -737,7 +683,10 @@ static int scsi_add_lun(struct scsi_devi
 		printk(KERN_INFO "scsi: unknown device type %d\n", sdev->type);
 	}
 
-	print_inquiry(inq_result);
+	sdev_printk(KERN_NOTICE "scsi", sdev, "Device: %.8s %.16s %.4s "
+			"ANSI ver: %02x%s\n", sdev->vendor, sdev->model,
+			sdev->rev, inq_result[2] & 0x07,
+			(inq_result[3] & 0x0f) == 1 ? " CCS" : "");
 
 	/*
 	 * For a peripheral qualifier (PQ) value of 1 (001b), the SCSI
