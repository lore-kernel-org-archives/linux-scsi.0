From: Jeremy Higdon <jeremy@sgi.com>
Subject: [PATCH] drivers/scsi/scsi_devinfo.c
Date: Thu, 17 Jun 2004 23:14:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040618061451.GA13139@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:50513 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S264218AbUFRGOv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 02:14:51 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx3.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id i5I6TcTt029218
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2004 23:29:38 -0700
Received: from classic.engr.sgi.com (classic.engr.sgi.com [163.154.5.111])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id i5I6EoCd17554679
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2004 23:14:50 -0700 (PDT)
Received: from classic.engr.sgi.com (localhost [127.0.0.1])
	by classic.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id i5I6Ep7M013237
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2004 23:14:52 -0700 (PDT)
Received: (from jeremy@localhost)
	by classic.engr.sgi.com (SGI-8.12.5/8.12.5/Submit) id i5I6EpXK013236
	for linux-scsi@vger.kernel.org; Thu, 17 Jun 2004 23:14:51 -0700 (PDT)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The BLIST_REPORTLUN2 blacklist item has exactly the behavior that
the MYLEX DACARMRB (and SGI TP9100, which is really a 2Gb upgrade
to the DACARMRB) need.

These devices use a PQ of 1 instead of 3 for unconfigured luns,
which means that every RAID has 32 luns, many or most of which
are just phantoms.

However, it does support Report Luns, and it returns the correct
data.

jeremy

===== drivers/scsi/scsi_devinfo.c 1.14 vs edited =====
--- 1.14/drivers/scsi/scsi_devinfo.c	Sat May 29 10:09:05 2004
+++ edited/drivers/scsi/scsi_devinfo.c	Thu Jun 17 22:22:09 2004
@@ -160,7 +160,7 @@
 	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
 	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
 	{"MICROP", "4110", NULL, BLIST_NOTQ},
-	{"MYLEX", "DACARMRB", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"MYLEX", "DACARMRB", "*", BLIST_REPORTLUN2},
 	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
 	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NAKAMICH", "MJ-5.16S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
@@ -173,7 +173,7 @@
 	{"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN},
 	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
-	{"SGI", "TP9100", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
 	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN},
 	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
 	{"SONY", "TSL", NULL, BLIST_FORCELUN},		/* DDS3 & DDS4 autoloaders */
