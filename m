From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch VER6
Date: Fri, 31 Mar 2006 20:07:45 -0600
Message-ID: <1143857265.3381.3.camel@mulgrave.il.steeleye.com>
References: <1143656547.3248.36.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603292025500.4009@filebunker.xip.at>
	 <1143657838.3248.39.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603292052430.4009@filebunker.xip.at>
	 <1143659029.3248.42.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603292125370.4009@filebunker.xip.at>
	 <1143666681.3248.48.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603301252100.595@filebunker.xip.at>
	 <20060330125816.GG13590@parisc-linux.org>
	 <Pine.GSO.4.64.0603301523130.6412@filebunker.xip.at>
	 <20060330162429.GI13590@parisc-linux.org>
	 <Pine.GSO.4.64.0603301825560.14161@filebunker.xip.at>
	 <1143834313.3342.54.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603312311590.25350@filebunker.xip.at>
	 <1143840100.3342.57.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603312323350.25350@filebunker.xip.at>
	 <Pine.GSO.4.64.0604010312590.4531@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:39147 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751475AbWDACHv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Mar 2006 21:07:51 -0500
In-Reply-To: <Pine.GSO.4.64.0604010312590.4531@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2006-04-01 at 03:16 +0200, Ingo Flaschberger wrote:
> I have looked around in the kernel but I get no idea how to inform the 
> block layer about the limit.
> Please advise.

OK, try this out.  It places the sector limit in the block queue.  I
also removed all the superfluous condition braces and tried to change
the comments to match what you're doing (the block size is actually in
multiples of 512 bytes, so the limit you impose is actually 512 *blocks*
or 256kB).

James

Index: BUILD-2.6/drivers/scsi/scsi.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi.c	2006-03-30 23:19:20.000000000 -0600
+++ BUILD-2.6/drivers/scsi/scsi.c	2006-03-31 19:48:54.000000000 -0600
@@ -565,7 +565,8 @@
 	/* 
 	 * If SCSI-2 or lower, store the LUN value in cmnd.
 	 */
-	if (cmd->device->scsi_level <= SCSI_2) {
+	if (cmd->device->scsi_level <= SCSI_2 &&
+	    cmd->device->scsi_level != SCSI_UNKNOWN) {
 		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
 			       (cmd->device->lun << 5 & 0xe0);
 	}
Index: BUILD-2.6/drivers/scsi/scsi_devinfo.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_devinfo.c	2006-03-30 17:31:53.000000000 -0600
+++ BUILD-2.6/drivers/scsi/scsi_devinfo.c	2006-03-31 19:47:06.000000000 -0600
@@ -132,7 +132,9 @@
 	{"CMD", "CRA-7280", NULL, BLIST_SPARSELUN},	/* CMD RAID Controller */
 	{"CNSI", "G7324", NULL, BLIST_SPARSELUN},	/* Chaparral G7324 RAID */
 	{"CNSi", "G8324", NULL, BLIST_SPARSELUN},	/* Chaparral G8324 RAID */
-	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN},
+	{"COMPAQ", "ARRAY CONTROLLER", NULL, BLIST_SPARSELUN | BLIST_LARGELUN |
+		BLIST_MAX_512 | BLIST_REPORTLUN2},	/* Compaq RA4x00 */
+	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN | BLIST_MAX_512K}, /* Compaq RA4x00 */
 	{"COMPAQ", "CR3500", NULL, BLIST_FORCELUN},
 	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
Index: BUILD-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_scan.c	2006-03-30 17:31:53.000000000 -0600
+++ BUILD-2.6/drivers/scsi/scsi_scan.c	2006-03-31 19:50:29.000000000 -0600
@@ -673,6 +673,7 @@
 	case TYPE_MEDIUM_CHANGER:
 	case TYPE_ENCLOSURE:
 	case TYPE_COMM:
+	case TYPE_RAID:
 	case TYPE_RBC:
 		sdev->writeable = 1;
 		break;
@@ -738,6 +739,13 @@
 		sdev->select_no_atn = 1;
 
 	/*
+	 * Maximum 512 sector transfer length
+	 * broken RA4x00 Compaq Disk Array
+	 */
+	if (*bflags & BLIST_MAX_512)
+		blk_queue_max_sectors(sdev->request_queue, 512);
+
+	/*
 	 * Some devices may not want to have a start command automatically
 	 * issued when a device is added.
 	 */
@@ -1123,10 +1131,13 @@
 	 * Also allow SCSI-2 if BLIST_REPORTLUN2 is set and host adapter does
 	 * support more than 8 LUNs.
 	 */
-	if ((bflags & BLIST_NOREPORTLUN) || 
-	     starget->scsi_level < SCSI_2 ||
-	    (starget->scsi_level < SCSI_3 && 
-	     (!(bflags & BLIST_REPORTLUN2) || shost->max_lun <= 8)) )
+	if (bflags & BLIST_NOREPORTLUN)
+		return 1;
+	if (starget->scsi_level < SCSI_2 &&
+	    starget->scsi_level != SCSI_UNKNOWN)
+		return 1;
+	if (starget->scsi_level < SCSI_3 &&
+	    (!(bflags & BLIST_REPORTLUN2) || shost->max_lun <= 8))
 		return 1;
 	if (bflags & BLIST_NOLUN)
 		return 0;
Index: BUILD-2.6/include/scsi/scsi_devinfo.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi_devinfo.h	2006-03-30 17:32:02.000000000 -0600
+++ BUILD-2.6/include/scsi/scsi_devinfo.h	2006-03-31 19:46:46.000000000 -0600
@@ -28,4 +28,5 @@
 #define BLIST_NO_ULD_ATTACH	0x100000 /* device is actually for RAID config */
 #define BLIST_SELECT_NO_ATN	0x200000 /* select without ATN */
 #define BLIST_RETRY_HWERROR	0x400000 /* retry HARDWARE_ERROR */
+#define BLIST_MAX_512		0x800000 /* maximum 512 sector cdb length */
 #endif


