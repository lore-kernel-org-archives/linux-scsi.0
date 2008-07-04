From: akpm@linux-foundation.org
Subject: [patch 10/16] scsi: aic79xx_core fix shadowed variables, add statics
Date: Thu, 03 Jul 2008 23:47:30 -0700
Message-ID: <200807040647.m646lUwV017496@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754342AbYGDGsG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2008 02:48:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, harvey.harrison@gmail.com

From: Harvey Harrison <harvey.harrison@gmail.com>

Redeclared within different if/else blocks, safe to reuse the
original from beginning of function.
drivers/scsi/aic7xxx/aic79xx_core.c:2475:10: warning: symbol 'scbid' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_core.c:2399:10: originally declared here
drivers/scsi/aic7xxx/aic79xx_core.c:2586:10: warning: symbol 'scbid' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_core.c:2399:10: originally declared here
drivers/scsi/aic7xxx/aic79xx_core.c:2587:15: warning: symbol 'scb' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_core.c:2393:13: originally declared here

Use caminfo for the outer declaration, the redeclared version is
iterating over all initiator/target pairs (devices) which.
drivers/scsi/aic7xxx/aic79xx_core.c:8857:23: warning: symbol 'devinfo' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_core.c:8711:21: originally declared here

Forward declaration was already marked static, make the definition match.
drivers/scsi/aic7xxx/aic79xx_core.c:3693:1: warning: symbol 'ahd_devlimited_syncrate' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_core.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~scsi-aic79xx_core-fix-shadowed-variables-add-statics drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~scsi-aic79xx_core-fix-shadowed-variables-add-statics
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -2472,8 +2472,6 @@ ahd_handle_scsiint(struct ahd_softc *ahd
 		if ((ahd->bugs & AHD_CLRLQO_AUTOCLR_BUG) != 0)
 			ahd_outb(ahd, CLRLQOINT1, 0);
 	} else if ((status & SELTO) != 0) {
-		u_int  scbid;
-
 		/* Stop the selection */
 		ahd_outb(ahd, SCSISEQ0, 0);
 
@@ -2583,9 +2581,6 @@ ahd_handle_scsiint(struct ahd_softc *ahd
 		case BUSFREE_DFF0:
 		case BUSFREE_DFF1:
 		{
-			u_int	scbid;
-			struct	scb *scb;
-
 			mode = busfreetime == BUSFREE_DFF0
 			     ? AHD_MODE_DFF0 : AHD_MODE_DFF1;
 			ahd_set_modes(ahd, mode, mode);
@@ -3689,7 +3684,7 @@ ahd_free_tstate(struct ahd_softc *ahd, u
  * by the capabilities of the bus connectivity of and sync settings for
  * the target.
  */
-void
+static void
 ahd_devlimited_syncrate(struct ahd_softc *ahd,
 			struct ahd_initiator_tinfo *tinfo,
 			u_int *period, u_int *ppr_options, role_t role)
@@ -8708,7 +8703,7 @@ ahd_reset_current_bus(struct ahd_softc *
 int
 ahd_reset_channel(struct ahd_softc *ahd, char channel, int initiate_reset)
 {
-	struct	ahd_devinfo devinfo;
+	struct	ahd_devinfo caminfo;
 	u_int	initiator;
 	u_int	target;
 	u_int	max_scsiid;
@@ -8729,7 +8724,7 @@ ahd_reset_channel(struct ahd_softc *ahd,
 
 	ahd->pending_device = NULL;
 
-	ahd_compile_devinfo(&devinfo,
+	ahd_compile_devinfo(&caminfo,
 			    CAM_TARGET_WILDCARD,
 			    CAM_TARGET_WILDCARD,
 			    CAM_LUN_WILDCARD,
@@ -8868,7 +8863,7 @@ ahd_reset_channel(struct ahd_softc *ahd,
 	}
 
 	/* Notify the XPT that a bus reset occurred */
-	ahd_send_async(ahd, devinfo.channel, CAM_TARGET_WILDCARD,
+	ahd_send_async(ahd, caminfo.channel, CAM_TARGET_WILDCARD,
 		       CAM_LUN_WILDCARD, AC_BUS_RESET);
 
 	ahd_restart(ahd);
_
