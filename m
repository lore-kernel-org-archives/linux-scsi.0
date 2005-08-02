From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic7xxx: final fixes for DT handling
Date: Tue, 02 Aug 2005 09:32:17 -0500
Message-ID: <1122993137.5029.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:4778 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261558AbVHBOcU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2005 10:32:20 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j72EWJA10927
	for <linux-scsi@vger.kernel.org>; Tue, 2 Aug 2005 10:32:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The aic7xxx can support Data Group transfers at periods > 12.5, so
eliminate that restriction.  Additionally wide is a requirement for DT
so ensure wide is set if users request DT.

James

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -2429,16 +2432,16 @@ static void ahc_linux_set_dt(struct scsi
 	unsigned int ppr_options = tinfo->goal.ppr_options
 		& ~MSG_EXT_PPR_DT_REQ;
 	unsigned int period = tinfo->goal.period;
+	unsigned int width = tinfo->goal.width;
 	unsigned long flags;
 	struct ahc_syncrate *syncrate;
 
 	if (dt) {
-		period = 9;	/* 12.5ns is the only period valid for DT */
 		ppr_options |= MSG_EXT_PPR_DT_REQ;
-	} else if (period == 9) {
+		if (!width)
+			ahc_linux_set_width(starget, 1);
+	} else if (period == 9)
 		period = 10;	/* if resetting DT, period must be >= 25ns */
-		ppr_options &= ~MSG_EXT_PPR_DT_REQ;
-	}
 
 	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);


