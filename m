From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as284c) Add BLIST_INQUIRY_36 to all USB blacklist entries
Date: Thu, 26 Aug 2004 11:53:45 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0408261149150.1089-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:22532 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S269109AbUHZPxt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 11:53:49 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

I submitted this patch earlier but received no response.

This patch adds the BLIST_INQUIRY_36 flag to all the SCSI blacklist
entries for USB devices.  While it may not be strictly necessary for all
of them, it doesn't hurt: Since the usb-storage driver doesn't use any of
the INQUIRY data after the first 36 bytes, there's no reason to try
reading any more of it.  And some devices crash when we try to read more,
even though they advertise that more bytes are available.  The usb-storage
driver does try to set the flag automatically, but the blacklist entries
override that setting.

Please apply.

Alan Stern




Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

===== drivers/scsi/scsi_devinfo.c 1.11 vs edited =====
--- 1.11/drivers/scsi/scsi_devinfo.c	Thu Jul  1 07:54:11 2004
+++ edited/drivers/scsi/scsi_devinfo.c	Thu Aug 26 11:51:19 2004
@@ -115,13 +115,14 @@
 
 	/*
 	 * Other types of devices that have special flags.
+	 * Note that all USB devices should have the BLIST_INQUIRY_36 flag.
 	 */
 	{"ADAPTEC", "AACRAID", NULL, BLIST_FORCELUN},
 	{"ADAPTEC", "Adaptec 5400S", NULL, BLIST_FORCELUN},
 	{"AFT PRO", "-IX CF", "0.0>", BLIST_FORCELUN},
-	{"BELKIN", "USB 2 HS-CF", "1.95",  BLIST_FORCELUN},
+	{"BELKIN", "USB 2 HS-CF", "1.95",  BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"CANON", "IPUBJD", NULL, BLIST_SPARSELUN},
-	{"CBOX3", "USB Storage-SMC", "300A", BLIST_FORCELUN},
+	{"CBOX3", "USB Storage-SMC", "300A", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"CMD", "CRA-7280", NULL, BLIST_SPARSELUN},	/* CMD RAID Controller */
 	{"CNSI", "G7324", NULL, BLIST_SPARSELUN},	/* Chaparral G7324 RAID */
 	{"CNSi", "G8324", NULL, BLIST_SPARSELUN},	/* Chaparral G8324 RAID */
@@ -142,9 +143,9 @@
 	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
 	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN},
-	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN},
-	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN},
+	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIRY_36},
+	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQUIRY_36},
+	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"HITACHI", "DF400", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DF500", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
@@ -182,7 +183,7 @@
 	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
-	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN},
+	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN | BLIST_INQUIRY_36},
 	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
 	{"SONY", "TSL", NULL, BLIST_FORCELUN},		/* DDS3 & DDS4 autoloaders */
 	{"SUN", "T300", "*", BLIST_SPARSELUN},
@@ -190,7 +191,7 @@
 	{"TEXEL", "CD-ROM", "1.06", BLIST_BORKEN},
 	{"TOSHIBA", "CDROM", NULL, BLIST_ISROM},
 	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
-	{"USB2.0", "SMARTMEDIA/XD", NULL, BLIST_FORCELUN},
+	{"USB2.0", "SMARTMEDIA/XD", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"Zzyzx", "RocketStor 500S", NULL, BLIST_SPARSELUN},
 	{"Zzyzx", "RocketStor 2000", NULL, BLIST_SPARSELUN},

