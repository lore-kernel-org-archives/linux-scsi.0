From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic79xx: fix up transport settings
Date: Wed, 03 Aug 2005 13:25:10 -0500
Message-ID: <1123093511.5019.17.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:26041 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262386AbVHCSZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2005 14:25:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

There's a slight problem in the way you've done the transport
parameters; reading from the variables actually produces the current
settings, not the ones you just set (and there's usually a lag because
devices don't renegotiate until the next command goes over the bus).  If
you set the bit immediately, you get into the situation where the
transport parameters report something as being set even if the drive
cannot support it.

I patched the driver to do it this way and also corrected a panic in the
proc routines.

James

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1624,7 +1624,11 @@ ahd_send_async(struct ahd_softc *ahd, ch
 		target_ppr_options =
 			(spi_dt(starget) ? MSG_EXT_PPR_DT_REQ : 0)
 			+ (spi_qas(starget) ? MSG_EXT_PPR_QAS_REQ : 0)
-			+ (spi_iu(starget) ?  MSG_EXT_PPR_IU_REQ : 0);
+			+ (spi_iu(starget) ?  MSG_EXT_PPR_IU_REQ : 0)
+			+ (spi_rd_strm(starget) ? MSG_EXT_PPR_RD_STRM : 0)
+			+ (spi_pcomp_en(starget) ? MSG_EXT_PPR_PCOMP_EN : 0)
+			+ (spi_rti(starget) ? MSG_EXT_PPR_RTI : 0)
+			+ (spi_wr_flow(starget) ? MSG_EXT_PPR_WR_FLOW : 0);
 
 		if (tinfo->curr.period == spi_period(starget)
 		    && tinfo->curr.width == spi_width(starget)
@@ -1639,6 +1643,10 @@ ahd_send_async(struct ahd_softc *ahd, ch
 		spi_dt(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_DT_REQ ? 1 : 0;
 		spi_qas(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_QAS_REQ ? 1 : 0;
 		spi_iu(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ ? 1 : 0;
+		spi_rd_strm(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_RD_STRM ? 1 : 0;
+		spi_pcomp_en(starget) =  tinfo->curr.ppr_options & MSG_EXT_PPR_PCOMP_EN ? 1 : 0;
+		spi_rti(starget) =  tinfo->curr.ppr_options &  MSG_EXT_PPR_RTI ? 1 : 0;
+		spi_wr_flow(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_WR_FLOW ? 1 : 0;
 		spi_display_xfer_agreement(starget);
 		break;
 	}
@@ -2318,18 +2326,6 @@ done:
 
 static void ahd_linux_exit(void);
 
-static void ahd_linux_set_xferflags(struct scsi_target *starget, unsigned int ppr_options, unsigned int period)
-{
-	spi_qas(starget) = (ppr_options & MSG_EXT_PPR_QAS_REQ)? 1 : 0;
-	spi_dt(starget) = (ppr_options & MSG_EXT_PPR_DT_REQ)? 1 : 0;
-	spi_iu(starget) = (ppr_options & MSG_EXT_PPR_IU_REQ) ? 1 : 0;
-	spi_rd_strm(starget) = (ppr_options & MSG_EXT_PPR_RD_STRM) ? 1 : 0;
-	spi_wr_flow(starget) = (ppr_options & MSG_EXT_PPR_WR_FLOW) ? 1 : 0;
-	spi_pcomp_en(starget) = (ppr_options & MSG_EXT_PPR_PCOMP_EN) ? 1 : 0;
-	spi_rti(starget) = (ppr_options & MSG_EXT_PPR_RTI) ? 1 : 0;
-	spi_period(starget) = period;
-}
-
 static void ahd_linux_set_width(struct scsi_target *starget, int width)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -2388,8 +2384,6 @@ static void ahd_linux_set_period(struct 
 	ahd_find_syncrate(ahd, &period, &ppr_options,
 			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
 
-	ahd_linux_set_xferflags(starget, ppr_options, period);
-
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, offset,
 			 ppr_options, AHD_TRANS_GOAL, FALSE);
@@ -2424,7 +2418,6 @@ static void ahd_linux_set_offset(struct 
 		ahd_find_syncrate(ahd, &period, &ppr_options, 
 				  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
 	}
-	ahd_linux_set_xferflags(starget, ppr_options, period);
 
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, offset, ppr_options,
@@ -2467,8 +2460,6 @@ static void ahd_linux_set_dt(struct scsi
 	ahd_find_syncrate(ahd, &period, &ppr_options,
 			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
 
-	ahd_linux_set_xferflags(starget, ppr_options, period);
-
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
 			 ppr_options, AHD_TRANS_GOAL, FALSE);
@@ -2508,8 +2499,6 @@ static void ahd_linux_set_qas(struct scs
 	ahd_find_syncrate(ahd, &period, &ppr_options,
 			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
 
-	spi_qas(starget) = (ppr_options & MSG_EXT_PPR_QAS_REQ)? 1 : 0;
-
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
 			 ppr_options, AHD_TRANS_GOAL, FALSE);
@@ -2550,8 +2539,6 @@ static void ahd_linux_set_iu(struct scsi
 	ahd_find_syncrate(ahd, &period, &ppr_options,
 			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
 
-	ahd_linux_set_xferflags(starget, ppr_options, period);
-
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
 			 ppr_options, AHD_TRANS_GOAL, FALSE);
@@ -2588,8 +2575,6 @@ static void ahd_linux_set_rd_strm(struct
 	ahd_find_syncrate(ahd, &period, &ppr_options,
 			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
 
-	spi_rd_strm(starget) = (ppr_options & MSG_EXT_PPR_RD_STRM) ? 1 : 0;
-
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
 			 ppr_options, AHD_TRANS_GOAL, FALSE);
@@ -2626,8 +2611,6 @@ static void ahd_linux_set_wr_flow(struct
 	ahd_find_syncrate(ahd, &period, &ppr_options,
 			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
 
-	spi_wr_flow(starget) = (ppr_options & MSG_EXT_PPR_WR_FLOW) ? 1 : 0;
-
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
 			 ppr_options, AHD_TRANS_GOAL, FALSE);
@@ -2672,8 +2655,6 @@ static void ahd_linux_set_rti(struct scs
 	ahd_find_syncrate(ahd, &period, &ppr_options,
 			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
 
-	spi_rti(starget) = (ppr_options & MSG_EXT_PPR_RTI) ? 1 : 0;
-
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
 			 ppr_options, AHD_TRANS_GOAL, FALSE);
@@ -2710,8 +2691,6 @@ static void ahd_linux_set_pcomp_en(struc
 	ahd_find_syncrate(ahd, &period, &ppr_options,
 			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
 
-	spi_pcomp_en(starget) = (ppr_options & MSG_EXT_PPR_PCOMP_EN) ? 1 : 0;
-
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
 			 ppr_options, AHD_TRANS_GOAL, FALSE);
diff --git a/drivers/scsi/aic7xxx/aic79xx_proc.c b/drivers/scsi/aic7xxx/aic79xx_proc.c
--- a/drivers/scsi/aic7xxx/aic79xx_proc.c
+++ b/drivers/scsi/aic7xxx/aic79xx_proc.c
@@ -178,9 +178,9 @@ ahd_dump_target_state(struct ahd_softc *
 	copy_info(info, "\tUser: ");
 	ahd_format_transinfo(info, &tinfo->user);
 	starget = ahd->platform_data->starget[target_offset];
-	targ = scsi_transport_target_data(starget);
-	if (targ == NULL)
+	if (starget == NULL)
 		return;
+	targ = scsi_transport_target_data(starget);
 
 	copy_info(info, "\tGoal: ");
 	ahd_format_transinfo(info, &tinfo->goal);


