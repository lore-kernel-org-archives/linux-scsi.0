From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic7xxx: cap maxsync according to correct card limits
Date: Mon, 30 Jul 2007 09:52:25 -0500
Message-ID: <1185807145.3463.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:53636 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752404AbXG3Ow1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 10:52:27 -0400
Received: from [172.17.6.40] (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (Postfix) with ESMTP id 25D419ED8004
	for <linux-scsi@vger.kernel.org>; Mon, 30 Jul 2007 10:52:26 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Not doing this can cause cards less than u160 capable to send out PPR
offers to devices they can't then deliver on ... causing some devices to
get a bit confused.  Fix by capping the start syncrate at the
appropriate level according to the card capabilities.

James

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 75733b0..f350b5e 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1701,7 +1701,16 @@ ahc_find_syncrate(struct ahc_softc *ahc, u_int *period,
 	if ((*ppr_options & MSG_EXT_PPR_DT_REQ) == 0
 	 && maxsync < AHC_SYNCRATE_ULTRA2)
 		maxsync = AHC_SYNCRATE_ULTRA2;
-	
+
+	/* Now set the maxsync based on the card capabilities
+	 * DT is already done above */
+	if ((ahc->features & (AHC_DT | AHC_ULTRA2)) == 0
+	    && maxsync < AHC_SYNCRATE_ULTRA)
+		maxsync = AHC_SYNCRATE_ULTRA;
+	if ((ahc->features & (AHC_DT | AHC_ULTRA2 | AHC_ULTRA)) == 0
+	    && maxsync < AHC_SYNCRATE_FAST)
+		maxsync = AHC_SYNCRATE_FAST;
+
 	for (syncrate = &ahc_syncrates[maxsync];
 	     syncrate->rate != NULL;
 	     syncrate++) {
@@ -1765,6 +1774,17 @@ ahc_find_period(struct ahc_softc *ahc, u_int scsirate, u_int maxsync)
 	else
 		scsirate &= SXFR;
 
+	/* now set maxsync based on card capabilities */
+	if ((ahc->features & AHC_DT) == 0 && maxsync < AHC_SYNCRATE_ULTRA2)
+		maxsync = AHC_SYNCRATE_ULTRA2;
+	if ((ahc->features & (AHC_DT | AHC_ULTRA2)) == 0
+	    && maxsync < AHC_SYNCRATE_ULTRA)
+		maxsync = AHC_SYNCRATE_ULTRA;
+	if ((ahc->features & (AHC_DT | AHC_ULTRA2 | AHC_ULTRA)) == 0
+	    && maxsync < AHC_SYNCRATE_FAST)
+		maxsync = AHC_SYNCRATE_FAST;
+
+
 	syncrate = &ahc_syncrates[maxsync];
 	while (syncrate->rate != NULL) {
 


