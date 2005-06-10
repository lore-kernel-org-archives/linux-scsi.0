From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic7xxx: remove some dead wood
Date: Sat, 11 Jun 2005 00:13:30 +0200
Message-ID: <20050610221330.GA8706@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:56755 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261267AbVFJWNf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 18:13:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

especially the now dead scsi_cmnd overlay


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx.h	2005-06-10 23:53:30.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx.h	2005-06-10 23:56:05.000000000 +0200
@@ -346,7 +346,6 @@
 					  * controller.
 					  */
 	AHC_NEWEEPROM_FMT     = 0x4000,
-	AHC_RESOURCE_SHORTAGE = 0x8000,
 	AHC_TQINFIFO_BLOCKED  = 0x10000,  /* Blocked waiting for ATIOs */
 	AHC_INT50_SPEEDFLEX   = 0x20000,  /*
 					   * Internal 50pin connector
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-06-10 23:53:59.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-06-10 23:57:17.000000000 +0200
@@ -501,17 +501,6 @@
 	int     found = 0;
 
 	/*
-	 * Sanity checking of Linux SCSI data structures so
-	 * that some of our hacks^H^H^H^H^Hassumptions aren't
-	 * violated.
-	 */
-	if (offsetof(struct ahc_cmd_internal, end)
-	  > offsetof(struct scsi_cmnd, host_scribble)) {
-		printf("ahc_linux_detect: SCSI data structures changed.\n");
-		printf("ahc_linux_detect: Unable to attach\n");
-		return (0);
-	}
-	/*
 	 * If we've been passed any parameters, process them now.
 	 */
 	if (aic7xxx)
@@ -1587,10 +1576,9 @@
 	/*
 	 * Get an scb to use.
 	 */
-	if ((scb = ahc_get_scb(ahc)) == NULL) {
-			ahc->flags |= AHC_RESOURCE_SHORTAGE;
-			return SCSI_MLQUEUE_HOST_BUSY;
-	}
+	scb = ahc_get_scb(ahc);
+	if (!scb)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
 	scb->io_ctx = cmd;
 	scb->platform_data->dev = dev;
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-06-10 23:53:30.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-06-10 23:56:06.000000000 +0200
@@ -285,35 +285,6 @@
 
 #define AIC7XXX_DRIVER_VERSION "6.2.36"
 
-/**************************** Front End Queues ********************************/
-/*
- * Data structure used to cast the Linux struct scsi_cmnd to something
- * that allows us to use the queue macros.  The linux structure has
- * plenty of space to hold the links fields as required by the queue
- * macros, but the queue macors require them to have the correct type.
- */
-struct ahc_cmd_internal {
-	/* Area owned by the Linux scsi layer. */
-	uint8_t	private[offsetof(struct scsi_cmnd, SCp.Status)];
-	union {
-		STAILQ_ENTRY(ahc_cmd)	ste;
-		LIST_ENTRY(ahc_cmd)	le;
-		TAILQ_ENTRY(ahc_cmd)	tqe;
-	} links;
-	uint32_t			end;
-};
-
-struct ahc_cmd {
-	union {
-		struct ahc_cmd_internal	icmd;
-		struct scsi_cmnd	scsi_cmd;
-	} un;
-};
-
-#define acmd_icmd(cmd) ((cmd)->un.icmd)
-#define acmd_scsi_cmd(cmd) ((cmd)->un.scsi_cmd)
-#define acmd_links un.icmd.links
-
 /*************************** Device Data Structures ***************************/
 /*
  * A per probed device structure used to deal with some error recovery
@@ -322,7 +293,6 @@
  * after a successfully completed inquiry command to the target when
  * that inquiry data indicates a lun is present.
  */
-TAILQ_HEAD(ahc_busyq, ahc_cmd);
 typedef enum {
 	AHC_DEV_FREEZE_TIL_EMPTY = 0x02, /* Freeze queue until active == 0 */
 	AHC_DEV_Q_BASIC		 = 0x10, /* Allow basic device queuing */
@@ -917,7 +887,6 @@
 static __inline void
 ahc_platform_scb_free(struct ahc_softc *ahc, struct scb *scb)
 {
-	ahc->flags &= ~AHC_RESOURCE_SHORTAGE;
 }
 
 int	ahc_platform_alloc(struct ahc_softc *ahc, void *platform_arg);
