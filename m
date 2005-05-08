From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] correct aic7xxx period setting routines
Date: Sun, 08 May 2005 11:00:15 -0500
Message-ID: <1115568016.18977.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:59278 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262888AbVEHQAV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 May 2005 12:00:21 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j48G0IA10713
	for <linux-scsi@vger.kernel.org>; Sun, 8 May 2005 12:00:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is similar to the previous sym2 problem.  For Domain Validation to
work we can't allow any period setting to turn wide on if it was
previously off.

James

--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -3346,6 +3346,32 @@ ahc_platform_dump_card_state(struct ahc_
 
 static void ahc_linux_exit(void);
 
+static void ahc_linux_get_width(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
+	struct ahc_tmode_tstate *tstate;
+	struct ahc_initiator_tinfo *tinfo 
+		= ahc_fetch_transinfo(ahc,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	spi_width(starget) = tinfo->curr.width;
+}
+
+static void ahc_linux_set_width(struct scsi_target *starget, int width)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
+	struct ahc_devinfo devinfo;
+	unsigned long flags;
+
+	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	ahc_lock(ahc, &flags);
+	ahc_set_width(ahc, &devinfo, width, AHC_TRANS_GOAL, FALSE);
+	ahc_unlock(ahc, &flags);
+}
+
 static void ahc_linux_get_period(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -3378,6 +3404,14 @@ static void ahc_linux_set_period(struct 
 
 	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
+
+	/* all PPR requests apart from QAS require wide transfers */
+	if (ppr_options & ~MSG_EXT_PPR_QAS_REQ) {
+		ahc_linux_get_width(starget);
+		if (spi_width(starget) == 0)
+			ppr_options &= MSG_EXT_PPR_QAS_REQ;
+	}
+
 	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options, AHC_SYNCRATE_DT);
 	ahc_lock(ahc, &flags);
 	ahc_set_syncrate(ahc, &devinfo, syncrate, period, offset,
@@ -3425,32 +3459,6 @@ static void ahc_linux_set_offset(struct 
 	ahc_unlock(ahc, &flags);
 }
 
-static void ahc_linux_get_width(struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
-	struct ahc_tmode_tstate *tstate;
-	struct ahc_initiator_tinfo *tinfo 
-		= ahc_fetch_transinfo(ahc,
-				      starget->channel + 'A',
-				      shost->this_id, starget->id, &tstate);
-	spi_width(starget) = tinfo->curr.width;
-}
-
-static void ahc_linux_set_width(struct scsi_target *starget, int width)
-{
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
-	struct ahc_devinfo devinfo;
-	unsigned long flags;
-
-	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
-			    starget->channel + 'A', ROLE_INITIATOR);
-	ahc_lock(ahc, &flags);
-	ahc_set_width(ahc, &devinfo, width, AHC_TRANS_GOAL, FALSE);
-	ahc_unlock(ahc, &flags);
-}
-
 static void ahc_linux_get_dt(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -3481,8 +3489,7 @@ static void ahc_linux_set_dt(struct scsi
 
 	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
-	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options,
-				     dt ? AHC_SYNCRATE_DT : AHC_SYNCRATE_ULTRA2);
+	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options,AHC_SYNCRATE_DT);
 	ahc_lock(ahc, &flags);
 	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->curr.offset,
 			 ppr_options, AHC_TRANS_GOAL, FALSE);
@@ -3514,7 +3521,6 @@ static void ahc_linux_set_qas(struct scs
 	unsigned int ppr_options = tinfo->curr.ppr_options
 		& ~MSG_EXT_PPR_QAS_REQ;
 	unsigned int period = tinfo->curr.period;
-	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
 	unsigned long flags;
 	struct ahc_syncrate *syncrate;
 
@@ -3523,8 +3529,7 @@ static void ahc_linux_set_qas(struct scs
 
 	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
-	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options,
-				     dt ? AHC_SYNCRATE_DT : AHC_SYNCRATE_ULTRA2);
+	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options, AHC_SYNCRATE_DT);
 	ahc_lock(ahc, &flags);
 	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->curr.offset,
 			 ppr_options, AHC_TRANS_GOAL, FALSE);
@@ -3556,7 +3561,6 @@ static void ahc_linux_set_iu(struct scsi
 	unsigned int ppr_options = tinfo->curr.ppr_options
 		& ~MSG_EXT_PPR_IU_REQ;
 	unsigned int period = tinfo->curr.period;
-	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
 	unsigned long flags;
 	struct ahc_syncrate *syncrate;
 
@@ -3565,8 +3569,7 @@ static void ahc_linux_set_iu(struct scsi
 
 	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
-	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options,
-				     dt ? AHC_SYNCRATE_DT : AHC_SYNCRATE_ULTRA2);
+	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options, AHC_SYNCRATE_DT);
 	ahc_lock(ahc, &flags);
 	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->curr.offset,
 			 ppr_options, AHC_TRANS_GOAL, FALSE);


