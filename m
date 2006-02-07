From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] aic79xx: convert qfrozen to atomic_t
Date: Tue, 7 Feb 2006 18:57:32 +0000
Message-ID: <20060207185732.GA23340@infradead.org>
References: <43E851D2.1060306@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:31902 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964903AbWBGS5d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 13:57:33 -0500
Content-Disposition: inline
In-Reply-To: <43E851D2.1060306@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "emmanuel.fuste" <emmanuel.fuste@laposte.net>

On Tue, Feb 07, 2006 at 08:52:50AM +0100, Hannes Reinecke wrote:
> This patch converts platform_data->qfrozen to atomic_t.
> This way we can get rid of ahd_lock / ahd_unlock for the
> accessor functions; it also fixes some deadlocks in the
> recovery code (again).

While we're at it there's also a qfrozen variable in the ahd_linux_device
structure.  Since the driver lost it's internal queueing it and the
surrounding core are totally unused.


Index: linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm.c	2006-01-31 12:23:38.000000000 +0100
+++ linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm.c	2006-02-07 19:52:47.000000000 +0100
@@ -1290,12 +1290,6 @@
 		now_queuing = AHD_DEV_Q_TAGGED;
 		break;
 	}
-	if ((dev->flags & AHD_DEV_FREEZE_TIL_EMPTY) == 0
-	 && (was_queuing != now_queuing)
-	 && (dev->active != 0)) {
-		dev->flags |= AHD_DEV_FREEZE_TIL_EMPTY;
-		dev->qfrozen++;
-	}
 
 	dev->flags &= ~(AHD_DEV_Q_BASIC|AHD_DEV_Q_TAGGED|AHD_DEV_PERIODIC_OTAG);
 	if (now_queuing) {
@@ -1705,10 +1699,7 @@
 	dev = scb->platform_data->dev;
 	dev->active--;
 	dev->openings++;
-	if ((cmd->result & (CAM_DEV_QFRZN << 16)) != 0) {
-		cmd->result &= ~(CAM_DEV_QFRZN << 16);
-		dev->qfrozen--;
-	}
+
 	ahd_linux_unmap_scb(ahd, scb);
 
 	/*
Index: linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm.h
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm.h	2006-01-31 12:23:38.000000000 +0100
+++ linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm.h	2006-02-07 19:52:57.000000000 +0100
@@ -264,7 +264,6 @@
  */
 
 typedef enum {
-	AHD_DEV_FREEZE_TIL_EMPTY = 0x02, /* Freeze queue until active == 0 */
 	AHD_DEV_Q_BASIC		 = 0x10, /* Allow basic device queuing */
 	AHD_DEV_Q_TAGGED	 = 0x20, /* Allow full SCSI2 command queueing */
 	AHD_DEV_PERIODIC_OTAG	 = 0x40, /* Send OTAG to prevent starvation */
@@ -291,12 +290,6 @@
 	int			openings;
 
 	/*
-	 * A positive count indicates that this
-	 * device's queue is halted.
-	 */
-	u_int			qfrozen;
-	
-	/*
 	 * Cumulative command counter.
 	 */
 	u_long			commands_issued;
@@ -870,10 +863,6 @@
 static __inline void
 ahd_freeze_scb(struct scb *scb)
 {
-	if ((scb->io_ctx->result & (CAM_DEV_QFRZN << 16)) == 0) {
-                scb->io_ctx->result |= CAM_DEV_QFRZN << 16;
-                scb->platform_data->dev->qfrozen++;
-        }
 }
 
 void	ahd_platform_set_tags(struct ahd_softc *ahd,
Index: linux-2.6/drivers/scsi/aic7xxx/aic79xx_proc.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic79xx_proc.c	2005-10-31 12:23:45.000000000 +0100
+++ linux-2.6/drivers/scsi/aic7xxx/aic79xx_proc.c	2006-02-07 18:12:11.000000000 +0100
@@ -255,7 +255,6 @@
 	copy_info(info, "\t\tCommands Active %d\n", dev->active);
 	copy_info(info, "\t\tCommand Openings %d\n", dev->openings);
 	copy_info(info, "\t\tMax Tagged Openings %d\n", dev->maxtags);
-	copy_info(info, "\t\tDevice Queue Frozen Count %d\n", dev->qfrozen);
 }
 
 static int
