From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic79xx: add hold_mcs
Date: Wed, 03 Aug 2005 15:59:04 -0500
Message-ID: <1123102744.5019.30.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:54714 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262444AbVHCU7G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2005 16:59:06 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j73Kx5A04334
	for <linux-scsi@vger.kernel.org>; Wed, 3 Aug 2005 16:59:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

since this card can support the setting, add it to the parameter list.

James

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1628,7 +1628,8 @@ ahd_send_async(struct ahd_softc *ahd, ch
 			+ (spi_rd_strm(starget) ? MSG_EXT_PPR_RD_STRM : 0)
 			+ (spi_pcomp_en(starget) ? MSG_EXT_PPR_PCOMP_EN : 0)
 			+ (spi_rti(starget) ? MSG_EXT_PPR_RTI : 0)
-			+ (spi_wr_flow(starget) ? MSG_EXT_PPR_WR_FLOW : 0);
+			+ (spi_wr_flow(starget) ? MSG_EXT_PPR_WR_FLOW : 0)
+			+ (spi_hold_mcs(starget) ? MSG_EXT_PPR_HOLD_MCS : 0);
 
 		if (tinfo->curr.period == spi_period(starget)
 		    && tinfo->curr.width == spi_width(starget)
@@ -1647,6 +1648,7 @@ ahd_send_async(struct ahd_softc *ahd, ch
 		spi_pcomp_en(starget) =  tinfo->curr.ppr_options & MSG_EXT_PPR_PCOMP_EN ? 1 : 0;
 		spi_rti(starget) =  tinfo->curr.ppr_options &  MSG_EXT_PPR_RTI ? 1 : 0;
 		spi_wr_flow(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_WR_FLOW ? 1 : 0;
+		spi_hold_mcs(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_HOLD_MCS ? 1 : 0;
 		spi_display_xfer_agreement(starget);
 		break;
 	}
@@ -2697,6 +2699,38 @@ static void ahd_linux_set_pcomp_en(struc
 	ahd_unlock(ahd, &flags);
 }
 
+static void ahd_linux_set_hold_mcs(struct scsi_target *starget, int hold)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahd_softc *ahd = *((struct ahd_softc **)shost->hostdata);
+	struct ahd_tmode_tstate *tstate;
+	struct ahd_initiator_tinfo *tinfo 
+		= ahd_fetch_transinfo(ahd,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	struct ahd_devinfo devinfo;
+	unsigned int ppr_options = tinfo->goal.ppr_options
+		& ~MSG_EXT_PPR_HOLD_MCS;
+	unsigned int period = tinfo->goal.period;
+	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
+	unsigned long flags;
+
+	if (hold)
+		ppr_options |= MSG_EXT_PPR_HOLD_MCS;
+
+	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	ahd_find_syncrate(ahd, &period, &ppr_options,
+			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
+
+	ahd_lock(ahd, &flags);
+	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
+			 ppr_options, AHD_TRANS_GOAL, FALSE);
+	ahd_unlock(ahd, &flags);
+}
+
+
+
 static struct spi_function_template ahd_linux_transport_functions = {
 	.set_offset	= ahd_linux_set_offset,
 	.show_offset	= 1,
@@ -2718,6 +2752,8 @@ static struct spi_function_template ahd_
 	.show_rti	= 1,
 	.set_pcomp_en	= ahd_linux_set_pcomp_en,
 	.show_pcomp_en	= 1,
+	.set_hold_mcs	= ahd_linux_set_hold_mcs,
+	.show_hold_mcs	= 1,
 };
 
 


