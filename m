From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: Re: [PATCH] 2.4.25-rc2 more devices to  scsi_scan.c's blacklist
Date: Fri, 13 Feb 2004 00:15:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <402C0900.6080104@wanadoo.es>
References: <402BB921.2000808@wanadoo.es>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080306080801090106080005"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp14.eresmas.com ([62.81.235.114]:56728 "EHLO
	smtp14.eresmas.com") by vger.kernel.org with ESMTP id S266660AbUBLXPU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 18:15:20 -0500
Received: from [192.168.108.52] (helo=mx02.eresmas.com)
	by smtp14.eresmas.com with esmtp (Exim 4.10)
	id 1ArQ3C-0005RJ-00
	for linux-scsi@vger.kernel.org; Fri, 13 Feb 2004 00:15:18 +0100
Received: from [80.103.5.172] (helo=wanadoo.es)
	by mx02.eresmas.com with esmtp (Exim 4.30)
	id 1ArQ38-0001SB-9I
	for linux-scsi@vger.kernel.org; Fri, 13 Feb 2004 00:15:14 +0100
In-Reply-To: <402BB921.2000808@wanadoo.es>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080306080801090106080005
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

hi,

new and better patch with _additions_ from linux-kernel ml, SLES y RHEL.

There are some _modifications_ from SuSE, but they were not added.
Does anybody know what are right ? kernel.org vs. SuSE(and one of RH)

-       {"COMPAQ", "MSA1000", "*", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_NOSTARTONADD},
+       {"COMPAQ", "MSA1000", "*", BLIST_SPARSELUN | BLIST_LARGELUN},

-       {"COMPAQ", "HSV110", "*", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_NOSTARTONADD},
+       {"COMPAQ", "HSV110", "*", BLIST_SPARSELUN | BLIST_LARGELUN},

-       {"DEC", "HSG80","*", BLIST_FORCELUN | BLIST_NOSTARTONADD},
+       {"DEC", "HSG80","*", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_NOSTARTONADD}, -> RH
+       {"DEC", "HSG80","*", BLIST_FORCELUN | BLIST_LARGELUN}, -> SuSE

-       {"EMC", "SYMMETRIX", "*", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
+       {"EMC", "SYMMETRIX", "*", BLIST_SPARSELUN | BLIST_LARGELUN},

-       {"HP", "HSV100", "*", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_NOSTARTONADD},
+       {"HP", "HSV100", "*", BLIST_SPARSELUN | BLIST_LARGELUN},

-       {"HP", "NetRAID-4M", "*", BLIST_FORCELUN},
+       {"HP", "NetRAID-4M", "*", BLIST_FORCELUN | BLIST_LARGELUN},

-thanks-

--------------080306080801090106080005
Content-Type: text/plain;
 name="scsi-blacklist-v2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-blacklist-v2.diff"

--- linux/drivers/scsi/scsi_scan.c	2004-01-05 15:39:12.000000000 +0100
+++ n/drivers/scsi/scsi_scan.c	2004-02-12 23:56:32.000000000 +0100
@@ -112,10 +112,6 @@
 	{"HP", "C1750A", "3226", BLIST_NOLUN},			/* scanjet iic */
 	{"HP", "C1790A", "", BLIST_NOLUN},			/* scanjet iip */
 	{"HP", "C2500A", "", BLIST_NOLUN},			/* scanjet iicx */
-	{"HP", "A6188A", "*", BLIST_SPARSELUN | BLIST_LARGELUN},/* HP Va7100 Array */
-	{"HP", "A6189A", "*", BLIST_SPARSELUN | BLIST_LARGELUN},/* HP Va7400 Array */
-	{"HP", "A6189B", "*", BLIST_SPARSELUN | BLIST_LARGELUN},/* HP Va7110 Array */
-	{"HP", "A6218A", "*", BLIST_SPARSELUN | BLIST_LARGELUN},/* HP Va7410 Array */
 	{"YAMAHA", "CDR100", "1.00", BLIST_NOLUN},		/* Locks up if polled for lun != 0 */
 	{"YAMAHA", "CDR102", "1.00", BLIST_NOLUN},		/* Locks up if polled for lun != 0  
 								 * extra reset */
@@ -126,6 +122,9 @@
 	{"RELISYS", "VM3530+", "*", BLIST_NOLUN},		/* responds to all LUN */
 	{"ACROSS", "", "*", BLIST_NOLUN},			/* responds to all LUN */
 	{"MICROTEK", "ScanMaker II", "5.61", BLIST_NOLUN},	/* responds to all LUN */
+	{"IBM", "EXP300", "D014", BLIST_NOLUN},			/* locks up */
+	{"NEC", "D3856", "0009", BLIST_NOLUN},
+	{"SUN", "SENA", "*", BLIST_NOLUN},			/* responds to all LUN */
 
 /*
  * Other types of devices that have special flags.
@@ -164,7 +163,10 @@
 	{"DELL", "PSEUDO DEVICE .",   "*", BLIST_SPARSELUN | BLIST_LARGELUN}, // Dell PV 530F
 	{"DELL", "PV530F",    "*", BLIST_SPARSELUN | BLIST_LARGELUN}, // Dell PV 530F
 	{"EMC", "SYMMETRIX", "*", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
-	{"HP", "A6189A", "*", BLIST_SPARSELUN |  BLIST_LARGELUN}, // HP VA7400, by Alar Aun
+	{"HP", "A6188A", "*", BLIST_SPARSELUN | BLIST_LARGELUN},/* HP Va7100 Array */
+	{"HP", "A6189A", "*", BLIST_SPARSELUN | BLIST_LARGELUN},/* HP Va7400 Array */
+	{"HP", "A6189B", "*", BLIST_SPARSELUN | BLIST_LARGELUN},/* HP Va7110 Array */
+	{"HP", "A6218A", "*", BLIST_SPARSELUN | BLIST_LARGELUN},/* HP Va7410 Array */
 	{"HP", "OPEN-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},	/* HP XP Arrays */
 	{"CMD", "CRA-7280", "*", BLIST_SPARSELUN | BLIST_LARGELUN},   // CMD RAID Controller
 	{"CNSI", "G7324", "*", BLIST_SPARSELUN | BLIST_LARGELUN},     // Chaparral G7324 RAID
@@ -189,8 +191,8 @@
 	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "OPEN-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},  /* HITACHI XP Arrays */
-	{"WINSYS","FLASHDISK G6", "*", BLIST_SPARSELUN},
-	{"DotHill","SANnet RAID X300", "*", BLIST_SPARSELUN},	
+	{"WINSYS","FLASHDISK", "*", BLIST_SPARSELUN},
+	{"DotHill","SANnet", "*", BLIST_SPARSELUN},
 	{"SUN", "T300", "*", BLIST_SPARSELUN},
 	{"SUN", "T4", "*", BLIST_SPARSELUN},
 	{"SGI", "RAID3", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
@@ -206,6 +208,22 @@
 	{"SMSC", "USB 2 HS", "*", BLIST_SPARSELUN | BLIST_LARGELUN}, 
 	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"NEC", "iStorage", "*", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
+	{"ADIC", "Pathlight 5000", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"CNSi", "JSS122", "*", BLIST_SPARSELUN},		// Chaparral SR0812 SR1422
+	{"CNSi", "JSS224", "*", BLIST_SPARSELUN},		// Chaparral FR1422
+	{"COMPAQ","FCTC","*", BLIST_FORCELUN | BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"Crossrds", "4", "*", BLIST_SPARSELUN | BLIST_LARGELUN}, // 4150, 4250, 4450
+	{"DELL", "PV-136T-FC", "*", BLIST_FORCELUN},
+	{"EUROLOGC", "FC2502", "*", BLIST_LARGELUN | BLIST_SPARSELUN},
+	{"IBM", "1742", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"IBM", "2145", "*", BLIST_SPARSELUN},
+	{"IBM", "3542", "*", BLIST_FORCELUN},
+	{"IBM", "2105800", "*", BLIST_SPARSELUN},
+	{"IBM", "2105F20", "*", BLIST_SPARSELUN},
+	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_SPARSELUN | BLIST_LARGELUN},  /* HITACHI 9960 */
+	{"PATHLGHT", "SAN Router", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"SUN", "StorEdge", "*", BLIST_SPARSELUN},
+	{"WINSYS","Flashdisk", "*", BLIST_SPARSELUN},
 
 	/*
 	 * Must be at end of list...

--------------080306080801090106080005--

