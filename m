From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] scsi/NCR5380: dprintk macro
Date: Thu, 29 May 2014 00:43:43 +1000 (EST)
Message-ID: <alpine.LNX.2.00.1405290020570.3539@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:51715 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbaE1OpE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 10:45:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org


This is the delta between the two submissions:
[PATCH 00/12] scsi/NCR5380: fix debugging macros and #include structure
and
[PATCH v2 00/12] scsi/NCR5380: fix debugging macros and #include structure

The macro definition changes were discussed on the mailing list during 
review. The idea is to get the compiler to check the parameters of 
disabled printk() calls so that the debugging code doesn't rot again.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

I know the whitespace is wrong throughout these drivers but when I put 
this patch series together it seemed best to defer the whitespace cleanup. 
(I still intend to do that cleanup.)

diff -ru v1/drivers/scsi/NCR5380.h v2/drivers/scsi/NCR5380.h
--- v1/drivers/scsi/NCR5380.h	2014-05-29 00:07:28.525627086 +1000
+++ v2/drivers/scsi/NCR5380.h	2014-05-29 00:06:41.335557873 +1000
@@ -295,9 +295,10 @@
 #define NDEBUG (0)
 #endif
 
+#define dprintk(flg, fmt, ...) \
+	do { if ((NDEBUG) & (flg)) pr_debug(fmt, ## __VA_ARGS__); } while (0)
+
 #if NDEBUG
-#define dprintk(flg, fmt, args...) \
-	do { if ((NDEBUG) & (flg)) pr_debug(fmt, ## args); } while (0)
 #define NCR5380_dprint(flg, arg) \
 	do { if ((NDEBUG) & (flg)) NCR5380_print(arg); } while (0)
 #define NCR5380_dprint_phase(flg, arg) \
@@ -305,7 +306,6 @@
 static void NCR5380_print_phase(struct Scsi_Host *instance);
 static void NCR5380_print(struct Scsi_Host *instance);
 #else
-#define dprintk(flg, fmt, args...)     do {} while (0)
 #define NCR5380_dprint(flg, arg)       do {} while (0)
 #define NCR5380_dprint_phase(flg, arg) do {} while (0)
 #endif
diff -ru v1/drivers/scsi/sun3_NCR5380.c v2/drivers/scsi/sun3_NCR5380.c
--- v1/drivers/scsi/sun3_NCR5380.c	2014-05-29 00:07:28.525627086 +1000
+++ v2/drivers/scsi/sun3_NCR5380.c	2014-05-29 00:06:41.355557902 +1000
@@ -1006,12 +1006,8 @@
 	    for (tmp = (struct scsi_cmnd *) hostdata->issue_queue,
 		 prev = NULL; tmp; prev = tmp, tmp = NEXT(tmp) ) {
 
-#if (NDEBUG & NDEBUG_LISTS)
 		if (prev != tmp)
-		    printk("MAIN tmp=%p   target=%d   busy=%d lun=%d\n",
-			   tmp, tmp->target, hostdata->busy[tmp->target],
-			   tmp->lun);
-#endif
+			dprintk(NDEBUG_LISTS, "MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun);
 		/*  When we find one, remove it from the issue queue. */
 		/* ++guenther: possible race with Falcon locking */
 		if (
