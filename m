From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as333) BLIST flag for non-lockable devices
Date: Fri, 25 Jun 2004 12:14:28 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406251209580.1147-100000@ida.rowland.org>
References: <20040623191400.GC1387@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:16132 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S266786AbUFYQO2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2004 12:14:28 -0400
In-Reply-To: <20040623191400.GC1387@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wheeler <matt@yurisko.net>
Cc: Mike Anderson <andmike@us.ibm.com>, Javier Marcet <lists@marcet.info>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 23 Jun 2004, Mike Anderson wrote:

> Since SCSI already has the device list it would seem like we would
> possibly add a new flag like was done for mode sense. As this is not a
> transport issue I would assume we would not want to add flags in
> usb/storage, but handle it in the mid-layer as a SCSI protocol
> non-compliance.

Here is a patch that implements this suggestion.  It's rather similar to 
the one that Javier Marcet wrote back in January, in

http://marc.theaimsgroup.com/?l=linux-usb-users&m=107345268526718&w=2

Matthew, does this patch work for your digital camera?

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

===== include/scsi/scsi_devinfo.h 1.5 vs edited =====
--- 1.5/include/scsi/scsi_devinfo.h	Sun May 30 04:51:19 2004
+++ edited/include/scsi/scsi_devinfo.h	Fri Jun 25 11:53:20 2004
@@ -24,4 +24,5 @@
 #define BLIST_REPORTLUN2	0x20000	/* try REPORT_LUNS even for SCSI-2 devs
  					   (if HBA supports more than 8 LUNs) */
 #define BLIST_NOREPORTLUN	0x40000	/* don't try REPORT_LUNS scan (SCSI-3 devs) */
+#define BLIST_NOT_LOCKABLE	0x80000	/* don't use PREVENT-ALLOW commands */
 #endif
===== drivers/scsi/scsi_devinfo.c 1.9 vs edited =====
--- 1.9/drivers/scsi/scsi_devinfo.c	Sat Jun 19 07:49:23 2004
+++ edited/drivers/scsi/scsi_devinfo.c	Fri Jun 25 12:07:06 2004
@@ -158,8 +158,11 @@
 	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
 	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
 	{"INSITE", "I325VM", NULL, BLIST_KEY},
+	{"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
 	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
 	{"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"MATSHITA", "DMC-LC5", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
+	{"MATSHITA", "DMC-LC40", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
 	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
 	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
 	{"MICROP", "4110", NULL, BLIST_NOTQ},
===== drivers/scsi/scsi_scan.c 1.61 vs edited =====
--- 1.61/drivers/scsi/scsi_scan.c	Mon Jun 21 12:58:41 2004
+++ edited/drivers/scsi/scsi_scan.c	Fri Jun 25 11:56:28 2004
@@ -661,6 +661,9 @@
 	if (*bflags & BLIST_MS_192_BYTES_FOR_3F)
 		sdev->use_192_bytes_for_3f = 1;
 
+	if (*bflags & BLIST_NOT_LOCKABLE)
+		sdev->lockable = 0;
+
 	if(sdev->host->hostt->slave_configure)
 		sdev->host->hostt->slave_configure(sdev);
 

