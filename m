From: mclark@metaparadigm.com
Subject: [2.6.9 PATCH] blacklist device don't use SYNCHRONIZE_CACHE
Date: Fri, 29 Oct 2004 18:22:15 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1CNTtf-0007Nq-00@localhost>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gort.metaparadigm.com ([203.117.131.12]:41886 "EHLO
	gort.metaparadigm.com") by vger.kernel.org with ESMTP
	id S263217AbUJ2KVV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 06:21:21 -0400
Received: from localhost (unknown [127.0.0.1])
	by gort.metaparadigm.com (Postfix) with ESMTP id B1D7C1ACFD
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2004 18:21:19 +0800 (SGT)
Received: from gort.metaparadigm.com ([127.0.0.1])
 by localhost (gort [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 09159-02 for <linux-scsi@vger.kernel.org>;
 Fri, 29 Oct 2004 18:21:19 +0800 (SGT)
Received: from localhost (monty-ath0.metaparadigm.com [10.1.0.59])
	by gort.metaparadigm.com (Postfix) with ESMTP id 6AF821ACCD
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2004 18:21:19 +0800 (SGT)
Received: from mclark by localhost with local (Exim 3.36 #1 (Debian))
	id 1CNTtf-0007Nq-00
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2004 18:22:15 +0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Adds a flag to the SCSI blacklist infrastructure to allow marking
devices we shouldn't send a SYNCRONIZE_CACHE command to.
Adds the Chaparral JFS224 to the blacklist with this flag.

Signed-off-by: Michael Clark <michael@metaparadigm.com>

diff -ur linux-2.6.9.orig/drivers/scsi/scsi_devinfo.c linux-2.6.9.edited/drivers/scsi/scsi_devinfo.c
--- linux-2.6.9.orig/drivers/scsi/scsi_devinfo.c	2004-10-29 15:33:38.000000000 +0800
+++ linux-2.6.9.edited/drivers/scsi/scsi_devinfo.c	2004-10-29 16:35:53.000000000 +0800
@@ -125,6 +125,7 @@
 	{"CMD", "CRA-7280", NULL, BLIST_SPARSELUN},	/* CMD RAID Controller */
 	{"CNSI", "G7324", NULL, BLIST_SPARSELUN},	/* Chaparral G7324 RAID */
 	{"CNSi", "G8324", NULL, BLIST_SPARSELUN},	/* Chaparral G8324 RAID */
+	{"CNSi", "JFS224", NULL, BLIST_SPARSELUN | BLIST_NO_SYNC_CACHE},
 	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN},
 	{"COMPAQ", "CR3500", NULL, BLIST_FORCELUN},
 	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
diff -ur linux-2.6.9.orig/drivers/scsi/scsi_scan.c linux-2.6.9.edited/drivers/scsi/scsi_scan.c
--- linux-2.6.9.orig/drivers/scsi/scsi_scan.c	2004-10-29 16:00:22.000000000 +0800
+++ linux-2.6.9.edited/drivers/scsi/scsi_scan.c	2004-10-29 16:02:51.000000000 +0800
@@ -668,6 +668,9 @@
 	if (*bflags & BLIST_NOT_LOCKABLE)
 		sdev->lockable = 0;
 
+	if (*bflags & BLIST_NO_SYNC_CACHE)
+		sdev->no_sync_cache = 1;
+
 	if(sdev->host->hostt->slave_configure)
 		sdev->host->hostt->slave_configure(sdev);
 
diff -ur linux-2.6.9.orig/drivers/scsi/sd.c linux-2.6.9.edited/drivers/scsi/sd.c
--- linux-2.6.9.orig/drivers/scsi/sd.c	2004-10-29 08:38:09.000000000 +0800
+++ linux-2.6.9.edited/drivers/scsi/sd.c	2004-10-29 15:59:50.000000000 +0800
@@ -1560,6 +1560,9 @@
 	if (!sdkp->WCE)
 		return;
 
+	if(sdp->no_sync_cache)
+		return;
+
 	printk(KERN_NOTICE "Synchronizing SCSI cache for disk %s: \n",
 			sdkp->disk->disk_name);
 	sd_sync_cache(sdp);
diff -ur linux-2.6.9.orig/include/scsi/scsi_device.h linux-2.6.9.edited/include/scsi/scsi_device.h
--- linux-2.6.9.orig/include/scsi/scsi_device.h	2004-10-29 15:52:57.000000000 +0800
+++ linux-2.6.9.edited/include/scsi/scsi_device.h	2004-10-29 16:32:58.000000000 +0800
@@ -106,6 +106,7 @@
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
+	unsigned no_sync_cache:1;	/* do not issue SYNCRONIZE_CACHE */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 
diff -ur linux-2.6.9.orig/include/scsi/scsi_devinfo.h linux-2.6.9.edited/include/scsi/scsi_devinfo.h
--- linux-2.6.9.orig/include/scsi/scsi_devinfo.h	2004-10-29 15:34:52.000000000 +0800
+++ linux-2.6.9.edited/include/scsi/scsi_devinfo.h	2004-10-29 15:47:43.000000000 +0800
@@ -25,4 +25,5 @@
  					   (if HBA supports more than 8 LUNs) */
 #define BLIST_NOREPORTLUN	0x40000	/* don't try REPORT_LUNS scan (SCSI-3 devs) */
 #define BLIST_NOT_LOCKABLE	0x80000	/* don't use PREVENT-ALLOW commands */
+#define BLIST_NO_SYNC_CACHE	0x100000 /* don't use SYNCHRONIZE_CACHE commands */
 #endif
