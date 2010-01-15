From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] aic79xx: check for non-NULL scb in
 ahd_handle_nonpkt_busfree
Date: Fri, 15 Jan 2010 13:07:34 +0100
Message-ID: <20100115120734.CCC193A4EC@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48677 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882Ab0AOMHg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2010 07:07:36 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 026B090975
	for <linux-scsi@vger.kernel.org>; Fri, 15 Jan 2010 13:07:35 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

aic79xx: check for non-NULL scb in ahd_handle_nonpkt_busfree

When removing several devices aic79xx will occasionally Oops
in ahd_handle_nonpkt_busfree during rescan. Looking at the
code I found that we're indeed not checking if the scb in
question is NULL. So check for it before accessing it.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 4d419c1..92cc866 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -3171,13 +3171,16 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 				tinfo->curr.transport_version = 2;
 				tinfo->goal.transport_version = 2;
 				tinfo->goal.ppr_options = 0;
-				/*
-				 * Remove any SCBs in the waiting for selection
-				 * queue that may also be for this target so
-				 * that command ordering is preserved.
-				 */
-				ahd_freeze_devq(ahd, scb);
-				ahd_qinfifo_requeue_tail(ahd, scb);
+				if (scb != NULL) {
+					/*
+					 * Remove any SCBs in the waiting
+					 * for selection queue that may
+					 * also be for this target so that
+					 * command ordering is preserved.
+					 */
+					ahd_freeze_devq(ahd, scb);
+					ahd_qinfifo_requeue_tail(ahd, scb);
+				}
 				printerror = 0;
 			}
 		} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_WDTR, FALSE)
@@ -3194,13 +3197,16 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 				      MSG_EXT_WDTR_BUS_8_BIT,
 				      AHD_TRANS_CUR|AHD_TRANS_GOAL,
 				      /*paused*/TRUE);
-			/*
-			 * Remove any SCBs in the waiting for selection
-			 * queue that may also be for this target so that
-			 * command ordering is preserved.
-			 */
-			ahd_freeze_devq(ahd, scb);
-			ahd_qinfifo_requeue_tail(ahd, scb);
+			if (scb != NULL) {
+				/*
+				 * Remove any SCBs in the waiting for
+				 * selection queue that may also be for
+				 * this target so that command ordering
+				 * is preserved.
+				 */
+				ahd_freeze_devq(ahd, scb);
+				ahd_qinfifo_requeue_tail(ahd, scb);
+			}
 			printerror = 0;
 		} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_SDTR, FALSE)
 			&& ppr_busfree == 0) {
@@ -3217,13 +3223,16 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 					/*ppr_options*/0,
 					AHD_TRANS_CUR|AHD_TRANS_GOAL,
 					/*paused*/TRUE);
-			/*
-			 * Remove any SCBs in the waiting for selection
-			 * queue that may also be for this target so that
-			 * command ordering is preserved.
-			 */
-			ahd_freeze_devq(ahd, scb);
-			ahd_qinfifo_requeue_tail(ahd, scb);
+			if (scb != NULL) {
+				/*
+				 * Remove any SCBs in the waiting for
+				 * selection queue that may also be for
+				 * this target so that command ordering
+				 * is preserved.
+				 */
+				ahd_freeze_devq(ahd, scb);
+				ahd_qinfifo_requeue_tail(ahd, scb);
+			}
 			printerror = 0;
 		} else if ((ahd->msg_flags & MSG_FLAG_EXPECT_IDE_BUSFREE) != 0
 			&& ahd_sent_msg(ahd, AHDMSG_1B,
@@ -3251,7 +3260,7 @@ ahd_handle_nonpkt_busfree(struct ahd_softc *ahd)
 	 * the message phases.  We check it last in case we
 	 * had to send some other message that caused a busfree.
 	 */
-	if (printerror != 0
+	if (scb != NULL && printerror != 0
 	 && (lastphase == P_MESGIN || lastphase == P_MESGOUT)
 	 && ((ahd->msg_flags & MSG_FLAG_EXPECT_PPR_BUSFREE) != 0)) {
 
