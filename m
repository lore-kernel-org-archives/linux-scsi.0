From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: [PATCH] 2.4.25-rc2 more devices to  scsi_scan.c's blacklist
Date: Thu, 12 Feb 2004 18:34:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <402BB921.2000808@wanadoo.es>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030209090105020102030705"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp13.eresmas.com ([62.81.235.113]:47329 "EHLO
	smtp13.eresmas.com") by vger.kernel.org with ESMTP id S266557AbUBLRfz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 12:35:55 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, marcelo.tosatti@cyclades.com

This is a multi-part message in MIME format.
--------------030209090105020102030705
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

hi,

I only have a doubt, this is a RHEL modification that
I don't know if it is ok:

-       {"DEC","HSG80","*", BLIST_FORCELUN | BLIST_NOSTARTONADD},
+       {"DEC","HSG80","*", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_NOSTARTONADD},

Most of them were gotten from a RHEL patch, so they should be right.

FYI, 2.6 needs a resync.

-thanks-

--------------030209090105020102030705
Content-Type: text/plain;
 name="scsi-blacklist.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-blacklist.diff"

--- linux/drivers/scsi/scsi_scan.c	2004-01-05 15:39:12.000000000 +0100
+++ n/drivers/scsi/scsi_scan.c	2004-02-12 18:14:34.000000000 +0100
@@ -83,6 +83,7 @@
 	{"NEC", "CD-ROM DRIVE:841", "1.0", BLIST_NOLUN},	/* Locks-up when LUN>0 polled. */
 	{"PHILIPS", "PCA80SC", "V4-2", BLIST_NOLUN},		/* Responds to all lun */
 	{"RODIME", "RO3000S", "2.33", BLIST_NOLUN},		/* Locks up if polled for lun != 0 */
+	{"SUN", "SENA", "*", BLIST_NOLUN},			/* responds to all luns */
 	{"SANYO", "CRD-250S", "1.20", BLIST_NOLUN},		/* causes failed REQUEST SENSE on lun 1
 								 * for aha152x controller, which causes
 								 * SCSI code to reset bus.*/
@@ -126,6 +127,7 @@
 	{"RELISYS", "VM3530+", "*", BLIST_NOLUN},		/* responds to all LUN */
 	{"ACROSS", "", "*", BLIST_NOLUN},			/* responds to all LUN */
 	{"MICROTEK", "ScanMaker II", "5.61", BLIST_NOLUN},	/* responds to all LUN */
+	{"NEC", "D3856", "0009", BLIST_NOLUN},
 
 /*
  * Other types of devices that have special flags.
@@ -148,7 +150,7 @@
 	{"EMULEX", "MD21/S2     ESDI", "*", BLIST_SINGLELUN},
 	{"CANON", "IPUBJD", "*", BLIST_SPARSELUN},
 	{"nCipher", "Fastness Crypto", "*", BLIST_FORCELUN},
-	{"DEC","HSG80","*", BLIST_FORCELUN | BLIST_NOSTARTONADD},
+	{"DEC","HSG80","*", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_NOSTARTONADD},
 	{"COMPAQ","LOGICAL VOLUME","*", BLIST_FORCELUN},
 	{"COMPAQ","CR3500","*", BLIST_FORCELUN},
 	{"NEC", "PD-1 ODX654P", "*", BLIST_FORCELUN | BLIST_SINGLELUN},
@@ -189,8 +191,10 @@
 	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "OPEN-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},  /* HITACHI XP Arrays */
-	{"WINSYS","FLASHDISK G6", "*", BLIST_SPARSELUN},
-	{"DotHill","SANnet RAID X300", "*", BLIST_SPARSELUN},	
+	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_SPARSELUN | BLIST_LARGELUN},  /* HITACHI 9960 */
+	{"WINSYS","FLASHDISK", "*", BLIST_SPARSELUN},
+	{"WINSYS","Flashdisk", "*", BLIST_SPARSELUN},
+	{"DotHill","SANnet", "*", BLIST_SPARSELUN},
 	{"SUN", "T300", "*", BLIST_SPARSELUN},
 	{"SUN", "T4", "*", BLIST_SPARSELUN},
 	{"SGI", "RAID3", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
@@ -206,6 +210,10 @@
 	{"SMSC", "USB 2 HS", "*", BLIST_SPARSELUN | BLIST_LARGELUN}, 
 	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"NEC", "iStorage", "*", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
+	{"SUN", "StorEdge", "*", BLIST_SPARSELUN},
+	{"IBM", "1742", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"CNSi", "JSS122", "*", BLIST_SPARSELUN},		// Chaparral SR0812 SR1422
+	{"CNSi", "JSS224", "*", BLIST_SPARSELUN},		// Chaparral FR1422
 
 	/*
 	 * Must be at end of list...

--------------030209090105020102030705--


