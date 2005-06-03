From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix aic7xxx coupled parameter problem
Date: Fri, 03 Jun 2005 09:49:01 -0500
Message-ID: <1117810141.5030.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:15023 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261302AbVFCOtD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jun 2005 10:49:03 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j53En2A31098
	for <linux-scsi@vger.kernel.org>; Fri, 3 Jun 2005 10:49:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

For setting coupled parameters, we need to be comparing against the goal
settings, not the current ones.

James

--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -2552,9 +2552,9 @@ static void ahc_linux_set_period(struct 
 				      starget->channel + 'A',
 				      shost->this_id, starget->id, &tstate);
 	struct ahc_devinfo devinfo;
-	unsigned int ppr_options = tinfo->curr.ppr_options;
+	unsigned int ppr_options = tinfo->goal.ppr_options;
 	unsigned long flags;
-	unsigned long offset = tinfo->curr.offset;
+	unsigned long offset = tinfo->goal.offset;
 	struct ahc_syncrate *syncrate;
 
 	if (offset == 0)
@@ -2600,8 +2600,8 @@ static void ahc_linux_set_offset(struct 
 			    starget->channel + 'A', ROLE_INITIATOR);
 	if (offset != 0) {
 		syncrate = ahc_find_syncrate(ahc, &period, &ppr_options, AHC_SYNCRATE_DT);
-		period = tinfo->curr.period;
-		ppr_options = tinfo->curr.ppr_options;
+		period = tinfo->goal.period;
+		ppr_options = tinfo->goal.ppr_options;
 	}
 	ahc_lock(ahc, &flags);
 	ahc_set_syncrate(ahc, &devinfo, syncrate, period, offset,
@@ -2619,9 +2619,9 @@ static void ahc_linux_set_dt(struct scsi
 				      starget->channel + 'A',
 				      shost->this_id, starget->id, &tstate);
 	struct ahc_devinfo devinfo;
-	unsigned int ppr_options = tinfo->curr.ppr_options
+	unsigned int ppr_options = tinfo->goal.ppr_options
 		& ~MSG_EXT_PPR_DT_REQ;
-	unsigned int period = tinfo->curr.period;
+	unsigned int period = tinfo->goal.period;
 	unsigned long flags;
 	struct ahc_syncrate *syncrate;
 
@@ -2635,7 +2635,7 @@ static void ahc_linux_set_dt(struct scsi
 			    starget->channel + 'A', ROLE_INITIATOR);
 	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options,AHC_SYNCRATE_DT);
 	ahc_lock(ahc, &flags);
-	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->curr.offset,
+	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->goal.offset,
 			 ppr_options, AHC_TRANS_GOAL, FALSE);
 	ahc_unlock(ahc, &flags);
 }
@@ -2650,9 +2650,9 @@ static void ahc_linux_set_qas(struct scs
 				      starget->channel + 'A',
 				      shost->this_id, starget->id, &tstate);
 	struct ahc_devinfo devinfo;
-	unsigned int ppr_options = tinfo->curr.ppr_options
+	unsigned int ppr_options = tinfo->goal.ppr_options
 		& ~MSG_EXT_PPR_QAS_REQ;
-	unsigned int period = tinfo->curr.period;
+	unsigned int period = tinfo->goal.period;
 	unsigned long flags;
 	struct ahc_syncrate *syncrate;
 
@@ -2663,7 +2663,7 @@ static void ahc_linux_set_qas(struct scs
 			    starget->channel + 'A', ROLE_INITIATOR);
 	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options, AHC_SYNCRATE_DT);
 	ahc_lock(ahc, &flags);
-	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->curr.offset,
+	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->goal.offset,
 			 ppr_options, AHC_TRANS_GOAL, FALSE);
 	ahc_unlock(ahc, &flags);
 }
@@ -2678,9 +2678,9 @@ static void ahc_linux_set_iu(struct scsi
 				      starget->channel + 'A',
 				      shost->this_id, starget->id, &tstate);
 	struct ahc_devinfo devinfo;
-	unsigned int ppr_options = tinfo->curr.ppr_options
+	unsigned int ppr_options = tinfo->goal.ppr_options
 		& ~MSG_EXT_PPR_IU_REQ;
-	unsigned int period = tinfo->curr.period;
+	unsigned int period = tinfo->goal.period;
 	unsigned long flags;
 	struct ahc_syncrate *syncrate;
 
@@ -2691,7 +2691,7 @@ static void ahc_linux_set_iu(struct scsi
 			    starget->channel + 'A', ROLE_INITIATOR);
 	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options, AHC_SYNCRATE_DT);
 	ahc_lock(ahc, &flags);
-	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->curr.offset,
+	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->goal.offset,
 			 ppr_options, AHC_TRANS_GOAL, FALSE);
 	ahc_unlock(ahc, &flags);
 }


