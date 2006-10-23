From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] aic79xx: Fixup external device reset
Date: Mon, 23 Oct 2006 15:22:37 +0200
Message-ID: <453CC21D.5030201@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020209000106070803090306"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:34507 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S964826AbWJWNWk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Oct 2006 09:22:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020209000106070803090306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi all,

Whenever we detect an external device reset we have to take care to not 
confuse the SCSI bus. We already handle ML retry, but we have to 
non-packetized command mode as well. And notify the SCSI engine about 
the command abort.
This code is actually from the original adaptec driver.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------020209000106070803090306
Content-Type: text/plain;
 name="0001-aic79xx-Fixup-external-device-reset.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-aic79xx-Fixup-external-device-reset.txt"

From: Hannes Reinecke <hare@suse.de>
Date: Mon Oct 23 09:46:17 2006 +0200
Subject: aic79xx: Fixup external device reset

Whenever an external device is resetted we really have to take
care to keep the channel in sync. Just notifying SCSI-ML and retry
is not enough as we have to make sure the SCSI bus is not getting
confused, either.
So whenever we detect an external reset we rewrite the command to
TUR, disable packetized command and notify the internal engine
that an abort has happened. This way we trigger a proper bus
reset sequence and all devices will be renegotiated properly.
Kudos to Justin Gibbs and Luben Tuikov for this idea.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 drivers/scsi/aic7xxx/aic79xx_core.c |   66 ++++++++++++++++++++++++++++++-----
 1 files changed, 56 insertions(+), 10 deletions(-)

f23c5c586615db1224e5cc7926b2731c3246011f
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 653818d..555920a 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -1053,10 +1053,12 @@ #endif
 			 * If a target takes us into the command phase
 			 * assume that it has been externally reset and
 			 * has thus lost our previous packetized negotiation
-			 * agreement.
-			 * Revert to async/narrow transfers until we
-			 * can renegotiate with the device and notify
-			 * the OSM about the reset.
+			 * agreement.  Since we have not sent an identify
+			 * message and may not have fully qualified the
+			 * connection, we change our command to TUR, assert
+			 * ATN and ABORT the task when we go to message in
+			 * phase.  The OSM will see the REQUEUE_REQUEST
+			 * status and retry the command.
 			 */
 			scbid = ahd_get_scbptr(ahd);
 			scb = ahd_lookup_scb(ahd, scbid);
@@ -1083,7 +1085,28 @@ #endif
 			ahd_set_syncrate(ahd, &devinfo, /*period*/0,
 					 /*offset*/0, /*ppr_options*/0,
 					 AHD_TRANS_ACTIVE, /*paused*/TRUE);
-			scb->flags |= SCB_EXTERNAL_RESET;
+			/* Hand-craft TUR command */
+			ahd_outb(ahd, SCB_CDB_STORE, 0);
+			ahd_outb(ahd, SCB_CDB_STORE+1, 0);
+			ahd_outb(ahd, SCB_CDB_STORE+2, 0);
+			ahd_outb(ahd, SCB_CDB_STORE+3, 0);
+			ahd_outb(ahd, SCB_CDB_STORE+4, 0);
+			ahd_outb(ahd, SCB_CDB_STORE+5, 0);
+			ahd_outb(ahd, SCB_CDB_LEN, 6);
+			scb->hscb->control &= ~(TAG_ENB|SCB_TAG_TYPE);
+			scb->hscb->control |= MK_MESSAGE;
+			ahd_outb(ahd, SCB_CONTROL, scb->hscb->control);
+			ahd_outb(ahd, MSG_OUT, HOST_MSG);
+			ahd_outb(ahd, SAVED_SCSIID, scb->hscb->scsiid);
+			/*
+			 * The lun is 0, regardless of the SCB's lun
+			 * as we have not sent an identify message.
+			 */
+			ahd_outb(ahd, SAVED_LUN, 0);
+			ahd_outb(ahd, SEQ_FLAGS, 0);
+			ahd_assert_atn(ahd);
+			scb->flags &= ~SCB_PACKETIZED;
+			scb->flags |= SCB_ABORT|SCB_EXTERNAL_RESET;
 			ahd_freeze_devq(ahd, scb);
 			ahd_set_transaction_status(scb, CAM_REQUEUE_REQ);
 			ahd_freeze_scb(scb);
@@ -1519,8 +1542,10 @@ ahd_handle_scsiint(struct ahd_softc *ahd
 	/*
 	 * Ignore external resets after a bus reset.
 	 */
-	if (((status & SCSIRSTI) != 0) && (ahd->flags & AHD_BUS_RESET_ACTIVE))
+	if (((status & SCSIRSTI) != 0) && (ahd->flags & AHD_BUS_RESET_ACTIVE)) {
+		ahd_outb(ahd, CLRSINT1, CLRSCSIRSTI);
 		return;
+	}
 
 	/*
 	 * Clear bus reset flag
@@ -2200,6 +2225,22 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 			if (sent_msg == MSG_ABORT_TAG)
 				tag = SCB_GET_TAG(scb);
 
+			if ((scb->flags & SCB_EXTERNAL_RESET) != 0) {
+				/*
+				 * This abort is in response to an
+				 * unexpected switch to command phase
+				 * for a packetized connection.  Since
+				 * the identify message was never sent,
+				 * "saved lun" is 0.  We really want to
+				 * abort only the SCB that encountered
+				 * this error, which could have a different
+				 * lun.  The SCB will be retried so the OS
+				 * will see the UA after renegotiating to
+				 * packetized.
+				 */
+				tag = SCB_GET_TAG(scb);
+				saved_lun = scb->hscb->lun;
+			}
 			found = ahd_abort_scbs(ahd, target, 'A', saved_lun,
 					       tag, ROLE_INITIATOR,
 					       CAM_REQ_ABORTED);
@@ -7920,6 +7961,11 @@ #endif
 	ahd_clear_fifo(ahd, 1);
 
 	/*
+	 * Clear SCSI interrupt status
+	 */
+	ahd_outb(ahd, CLRSINT1, CLRSCSIRSTI);
+
+	/*
 	 * Reenable selections
 	 */
 	ahd_outb(ahd, SIMODE1, ahd_inb(ahd, SIMODE1) | ENSCSIRST);
@@ -7952,10 +7998,6 @@ #ifdef AHD_TARGET_MODE
 		}
 	}
 #endif
-	/* Notify the XPT that a bus reset occurred */
-	ahd_send_async(ahd, devinfo.channel, CAM_TARGET_WILDCARD,
-		       CAM_LUN_WILDCARD, AC_BUS_RESET);
-
 	/*
 	 * Revert to async/narrow transfers until we renegotiate.
 	 */
@@ -7977,6 +8019,10 @@ #endif
 		}
 	}
 
+	/* Notify the XPT that a bus reset occurred */
+	ahd_send_async(ahd, devinfo.channel, CAM_TARGET_WILDCARD,
+		       CAM_LUN_WILDCARD, AC_BUS_RESET);
+
 	ahd_restart(ahd);
 
 	return (found);
-- 
1.3.1


--------------020209000106070803090306--
