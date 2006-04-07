From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] aic79xx: target hotplug fixes
Date: Fri, 07 Apr 2006 13:47:03 +0200
Message-ID: <44365137.90202@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050604010103010808010000"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:30366 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S964780AbWDGLrF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2006 07:47:05 -0400
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 928CE1E4F4
	for <linux-scsi@vger.kernel.org>; Fri,  7 Apr 2006 13:47:03 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050604010103010808010000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi all,

aic79xx has a _very_ peculiar handling for target hotplug. It detects
the target reset okay, but then decides to change the command on the fly
to TEST UNIT READY and tries to requeue the original command.
Nice idea, but if we can't send the TEST UNIT READY command we'll get
the sense code from that and not that one we'd have gotten from the
original command.
And of course the requeueing bit is stuffed, too, as the TUR command
will basically never requeued.
Especially harmful if the Midlayer does a rescanning, as the INQUIRY
command sent by the rescan should _never_ return a CHECK CONDITION
status as this is a violation of the SCSI spec.

This patch just strips out that peculiar handling and let the midlayer
deal with it. Works far better that way and again some code cleanup
achieved :-)

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------050604010103010808010000
Content-Type: text/plain;
 name="0001-aic79xx-target-hotplug-fixes.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-aic79xx-target-hotplug-fixes.txt"

Subject: [PATCH] aic79xx: target hotplug fixes

When a target is added aic79xx tries to be overly clever: it changes
the command on the fly to TEST UNIT READY and tries to requeue the
original command. Sadly this breaks SCSI compability and of course
the midlayer is getting a bit confused by it.

So we're just removing that bit of code and let the midlayer deal with
it. It's clever enough by now. And the driver code is getting simpler.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 drivers/scsi/aic7xxx/aic79xx.h      |    2 +
 drivers/scsi/aic7xxx/aic79xx_core.c |   52 ++++++-----------------------------
 2 files changed, 10 insertions(+), 44 deletions(-)

41b91d017439519c496ceb20ee877b8fedd2b61b
diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index 1d11f7e..1c85db6 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -589,7 +589,7 @@ typedef enum {
 	SCB_PACKETIZED		= 0x00800,
 	SCB_EXPECT_PPR_BUSFREE	= 0x01000,
 	SCB_PKT_SENSE		= 0x02000,
-	SCB_CMDPHASE_ABORT	= 0x04000,
+	SCB_EXTERNAL_RESET	= 0x04000,/* Device was reset externally */
 	SCB_ON_COL_LIST		= 0x08000,
 	SCB_SILENT		= 0x10000 /*
 					   * Be quiet about transmission type
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 326a622..9ab0209 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -1054,12 +1054,10 @@ ahd_handle_seqint(struct ahd_softc *ahd,
 			 * If a target takes us into the command phase
 			 * assume that it has been externally reset and
 			 * has thus lost our previous packetized negotiation
-			 * agreement.  Since we have not sent an identify
-			 * message and may not have fully qualified the
-			 * connection, we change our command to TUR, assert
-			 * ATN and ABORT the task when we go to message in
-			 * phase.  The OSM will see the REQUEUE_REQUEST
-			 * status and retry the command.
+			 * agreement.
+			 * Revert to async/narrow transfers until we
+			 * can renegotiate with the device and notify
+			 * the OSM about the reset.
 			 */
 			scbid = ahd_get_scbptr(ahd);
 			scb = ahd_lookup_scb(ahd, scbid);
@@ -1086,31 +1084,15 @@ ahd_handle_seqint(struct ahd_softc *ahd,
 			ahd_set_syncrate(ahd, &devinfo, /*period*/0,
 					 /*offset*/0, /*ppr_options*/0,
 					 AHD_TRANS_ACTIVE, /*paused*/TRUE);
-			ahd_outb(ahd, SCB_CDB_STORE, 0);
-			ahd_outb(ahd, SCB_CDB_STORE+1, 0);
-			ahd_outb(ahd, SCB_CDB_STORE+2, 0);
-			ahd_outb(ahd, SCB_CDB_STORE+3, 0);
-			ahd_outb(ahd, SCB_CDB_STORE+4, 0);
-			ahd_outb(ahd, SCB_CDB_STORE+5, 0);
-			ahd_outb(ahd, SCB_CDB_LEN, 6);
-			scb->hscb->control &= ~(TAG_ENB|SCB_TAG_TYPE);
-			scb->hscb->control |= MK_MESSAGE;
-			ahd_outb(ahd, SCB_CONTROL, scb->hscb->control);
-			ahd_outb(ahd, MSG_OUT, HOST_MSG);
-			ahd_outb(ahd, SAVED_SCSIID, scb->hscb->scsiid);
-			/*
-			 * The lun is 0, regardless of the SCB's lun
-			 * as we have not sent an identify message.
-			 */
-			ahd_outb(ahd, SAVED_LUN, 0);
-			ahd_outb(ahd, SEQ_FLAGS, 0);
-			ahd_assert_atn(ahd);
-			scb->flags &= ~SCB_PACKETIZED;
-			scb->flags |= SCB_ABORT|SCB_CMDPHASE_ABORT;
+			scb->flags |= SCB_EXTERNAL_RESET;
 			ahd_freeze_devq(ahd, scb);
 			ahd_set_transaction_status(scb, CAM_REQUEUE_REQ);
 			ahd_freeze_scb(scb);
 
+			/* Notify XPT */
+			ahd_send_async(ahd, devinfo.channel, devinfo.target,
+				       CAM_LUN_WILDCARD, AC_SENT_BDR, NULL);
+
 			/*
 			 * Allow the sequencer to continue with
 			 * non-pack processing.
@@ -2207,22 +2189,6 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 			if (sent_msg == MSG_ABORT_TAG)
 				tag = SCB_GET_TAG(scb);
 
-			if ((scb->flags & SCB_CMDPHASE_ABORT) != 0) {
-				/*
-				 * This abort is in response to an
-				 * unexpected switch to command phase
-				 * for a packetized connection.  Since
-				 * the identify message was never sent,
-				 * "saved lun" is 0.  We really want to
-				 * abort only the SCB that encountered
-				 * this error, which could have a different
-				 * lun.  The SCB will be retried so the OS
-				 * will see the UA after renegotiating to
-				 * packetized.
-				 */
-				tag = SCB_GET_TAG(scb);
-				saved_lun = scb->hscb->lun;
-			}
 			found = ahd_abort_scbs(ahd, target, 'A', saved_lun,
 					       tag, ROLE_INITIATOR,
 					       CAM_REQ_ABORTED);
-- 
1.1.3

--------------050604010103010808010000--
