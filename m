From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Patch 0/2] Update aic79xx
Date: Mon, 01 Aug 2005 09:52:56 +0200
Message-ID: <42EDD4D8.9010602@suse.de>
References: <42E10572.6030105@suse.de> <1122048829.5128.1.camel@mulgrave>	 <42E49DBD.2010708@suse.de> <1122737875.5055.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010509060708060706000107"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:29344 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S262334AbVHAHxC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2005 03:53:02 -0400
In-Reply-To: <1122737875.5055.8.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

This is a multi-part message in MIME format.
--------------010509060708060706000107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

James Bottomley wrote:
> On Mon, 2005-07-25 at 10:07 +0200, Hannes Reinecke wrote:
>>But this is not the root problem.
>>
>> target5:0:10: FAST-160 WIDE SCSI 320.0 MB/s ST IU (6.25 ns, offset 127=
)
>>scsi5: target 10 synchronous with period =3D 0x8, offset =3D
>>0x7f(RDSTRM|DT|IU|QAS)
>>
>>So, the ppr_options (which have generated the second line) are set ok,
>>but they somehow haven't been transferred into the scsi_transport attri=
bute.
>=20
> Fortunately, HP gave me a U160 AIC card at OLS, so I can now boot it up=

> and see that the aic7xxx driver has the same problem.  Attached is the
> fix (basically it was a single bit variable rounding error).
>=20
Yes, figured out that much. But there was also quite some bits and
pieces missing (RDSTRM settings eg.) so a new patch is in place.
To be applied after the other two.

 target11:0:8: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
scsi11: target 8 synchronous with period =3D 0xa, offset =3D 0xf

 target11:0:10: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS (6.25 ns, offset
127)
scsi11: target 10 synchronous with period =3D 0x8, offset =3D
0x7f(RDSTRM|DT|IU|QAS)

Seems to have it fixed, now.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------010509060708060706000107
Content-Type: text/x-patch;
 name="aic79xx-update-dv-parameter.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic79xx-update-dv-parameter.patch"

From: Hannes Reinecke <hare@suse.de>
Subject: Update DV parameter settings

This patch updates various scsi_transport_spi parameters with the actual
parameters used by the driver internally.
Domain Validation for all devices should now work properly.

--- linux-2.6.12/drivers/scsi/aic7xxx/aic79xx_osm.c.orig	2005-08-01 09:33:54.000000000 +0200
+++ linux-2.6.12/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-08-01 09:44:54.000000000 +0200
@@ -1636,9 +1636,9 @@ ahd_send_async(struct ahd_softc *ahd, ch
 		spi_period(starget) = tinfo->curr.period;
 		spi_width(starget) = tinfo->curr.width;
 		spi_offset(starget) = tinfo->curr.offset;
-		spi_dt(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_DT_REQ;
-		spi_qas(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_QAS_REQ;
-		spi_iu(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ;
+		spi_dt(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_DT_REQ ? 1 : 0;
+		spi_qas(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_QAS_REQ ? 1 : 0;
+		spi_iu(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ ? 1 : 0;
 		spi_display_xfer_agreement(starget);
 		break;
 	}
@@ -2318,6 +2318,18 @@ done:
 
 static void ahd_linux_exit(void);
 
+static void ahd_linux_set_xferflags(struct scsi_target *starget, unsigned int ppr_options, unsigned int period)
+{
+	spi_qas(starget) = (ppr_options & MSG_EXT_PPR_QAS_REQ)? 1 : 0;
+	spi_dt(starget) = (ppr_options & MSG_EXT_PPR_DT_REQ)? 1 : 0;
+	spi_iu(starget) = (ppr_options & MSG_EXT_PPR_IU_REQ) ? 1 : 0;
+	spi_rd_strm(starget) = (ppr_options & MSG_EXT_PPR_RD_STRM) ? 1 : 0;
+	spi_wr_flow(starget) = (ppr_options & MSG_EXT_PPR_WR_FLOW) ? 1 : 0;
+	spi_pcomp_en(starget) = (ppr_options & MSG_EXT_PPR_PCOMP_EN) ? 1 : 0;
+	spi_rti(starget) = (ppr_options & MSG_EXT_PPR_RTI) ? 1 : 0;
+	spi_period(starget) = period;
+}
+
 static void ahd_linux_set_width(struct scsi_target *starget, int width)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -2343,9 +2355,14 @@ static void ahd_linux_set_period(struct 
 				      shost->this_id, starget->id, &tstate);
 	struct ahd_devinfo devinfo;
 	unsigned int ppr_options = tinfo->goal.ppr_options;
+	unsigned int dt;
 	unsigned long flags;
 	unsigned long offset = tinfo->goal.offset;
 
+#ifdef AHD_DEBUG
+	if ((ahd_debug & AHD_SHOW_DV) != 0)
+		printf("%s: set period to %d\n", ahd_name(ahd), period);
+#endif
 	if (offset == 0)
 		offset = MAX_OFFSET;
 
@@ -2357,6 +2374,8 @@ static void ahd_linux_set_period(struct 
 			ppr_options |= MSG_EXT_PPR_IU_REQ;
 	}
 
+	dt = ppr_options & MSG_EXT_PPR_DT_REQ;
+
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
 
@@ -2366,7 +2385,11 @@ static void ahd_linux_set_period(struct 
 			ppr_options &= MSG_EXT_PPR_QAS_REQ;
 	}
 
-	ahd_find_syncrate(ahd, &period, &ppr_options, AHD_SYNCRATE_MAX);
+	ahd_find_syncrate(ahd, &period, &ppr_options,
+			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
+
+	ahd_linux_set_xferflags(starget, ppr_options, period);
+
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, offset,
 			 ppr_options, AHD_TRANS_GOAL, FALSE);
@@ -2385,15 +2408,24 @@ static void ahd_linux_set_offset(struct 
 	struct ahd_devinfo devinfo;
 	unsigned int ppr_options = 0;
 	unsigned int period = 0;
+	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
 	unsigned long flags;
 
+#ifdef AHD_DEBUG
+	if ((ahd_debug & AHD_SHOW_DV) != 0)
+		printf("%s: set offset to %d\n", ahd_name(ahd), offset);
+#endif
+
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
 	if (offset != 0) {
 		period = tinfo->goal.period;
 		ppr_options = tinfo->goal.ppr_options;
-		ahd_find_syncrate(ahd, &period, &ppr_options, AHD_SYNCRATE_MAX);
+		ahd_find_syncrate(ahd, &period, &ppr_options, 
+				  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
 	}
+	ahd_linux_set_xferflags(starget, ppr_options, period);
+
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, offset, ppr_options,
 			 AHD_TRANS_GOAL, FALSE);
@@ -2415,17 +2447,28 @@ static void ahd_linux_set_dt(struct scsi
 	unsigned int period = tinfo->goal.period;
 	unsigned long flags;
 
+#ifdef AHD_DEBUG
+	if ((ahd_debug & AHD_SHOW_DV) != 0)
+		printf("%s: %s DT\n", ahd_name(ahd), 
+		       dt ? "enabling" : "disabling");
+#endif
 	if (dt) {
 		ppr_options |= MSG_EXT_PPR_DT_REQ;
 		if (period > 9)
 			period = 9; /* at least 12.5ns for DT */
-	} else if (period <= 9)
-		period = 10; /* If resetting DT, period must be >= 25ns */
-
+	} else {
+		if (period <= 9)
+			period = 10; /* If resetting DT, period must be >= 25ns */
+		/* IU is invalid without DT set */
+		ppr_options &= ~MSG_EXT_PPR_IU_REQ;
+	}
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
 	ahd_find_syncrate(ahd, &period, &ppr_options,
 			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
+
+	ahd_linux_set_xferflags(starget, ppr_options, period);
+
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
 			 ppr_options, AHD_TRANS_GOAL, FALSE);
@@ -2445,16 +2488,28 @@ static void ahd_linux_set_qas(struct scs
 	unsigned int ppr_options = tinfo->goal.ppr_options
 		& ~MSG_EXT_PPR_QAS_REQ;
 	unsigned int period = tinfo->goal.period;
-	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
+	unsigned int dt;
 	unsigned long flags;
 
-	if (qas)
-		ppr_options |= MSG_EXT_PPR_QAS_REQ;
+#ifdef AHD_DEBUG
+	if ((ahd_debug & AHD_SHOW_DV) != 0)
+		printf("%s: %s QAS\n", ahd_name(ahd), 
+		       qas ? "enabling" : "disabling");
+#endif
+
+	if (qas) {
+		ppr_options |= MSG_EXT_PPR_QAS_REQ; 
+	}
+
+	dt = ppr_options & MSG_EXT_PPR_DT_REQ;
 
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
 	ahd_find_syncrate(ahd, &period, &ppr_options,
 			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
+
+	spi_qas(starget) = (ppr_options & MSG_EXT_PPR_QAS_REQ)? 1 : 0;
+
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
 			 ppr_options, AHD_TRANS_GOAL, FALSE);
@@ -2474,16 +2529,29 @@ static void ahd_linux_set_iu(struct scsi
 	unsigned int ppr_options = tinfo->goal.ppr_options
 		& ~MSG_EXT_PPR_IU_REQ;
 	unsigned int period = tinfo->goal.period;
-	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
+	unsigned int dt;
 	unsigned long flags;
 
-	if (iu)
+#ifdef AHD_DEBUG
+	if ((ahd_debug & AHD_SHOW_DV) != 0)
+		printf("%s: %s IU\n", ahd_name(ahd),
+		       iu ? "enabling" : "disabling");
+#endif
+
+	if (iu) {
 		ppr_options |= MSG_EXT_PPR_IU_REQ;
+		ppr_options |= MSG_EXT_PPR_DT_REQ; /* IU requires DT */
+	}
+
+	dt = ppr_options & MSG_EXT_PPR_DT_REQ;
 
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
 	ahd_find_syncrate(ahd, &period, &ppr_options,
 			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
+
+	ahd_linux_set_xferflags(starget, ppr_options, period);
+
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
 			 ppr_options, AHD_TRANS_GOAL, FALSE);
@@ -2506,6 +2574,12 @@ static void ahd_linux_set_rd_strm(struct
 	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
 	unsigned long flags;
 
+#ifdef AHD_DEBUG
+	if ((ahd_debug & AHD_SHOW_DV) != 0)
+		printf("%s: %s Read Streaming\n", ahd_name(ahd), 
+		       rdstrm  ? "enabling" : "disabling");
+#endif
+
 	if (rdstrm)
 		ppr_options |= MSG_EXT_PPR_RD_STRM;
 
@@ -2513,6 +2587,131 @@ static void ahd_linux_set_rd_strm(struct
 			    starget->channel + 'A', ROLE_INITIATOR);
 	ahd_find_syncrate(ahd, &period, &ppr_options,
 			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
+
+	spi_rd_strm(starget) = (ppr_options & MSG_EXT_PPR_RD_STRM) ? 1 : 0;
+
+	ahd_lock(ahd, &flags);
+	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
+			 ppr_options, AHD_TRANS_GOAL, FALSE);
+	ahd_unlock(ahd, &flags);
+}
+
+static void ahd_linux_set_wr_flow(struct scsi_target *starget, int wrflow)
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
+		& ~MSG_EXT_PPR_WR_FLOW;
+	unsigned int period = tinfo->goal.period;
+	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
+	unsigned long flags;
+
+#ifdef AHD_DEBUG
+	if ((ahd_debug & AHD_SHOW_DV) != 0)
+		printf("%s: %s Write Flow Control\n", ahd_name(ahd),
+		       wrflow ? "enabling" : "disabling");
+#endif
+
+	if (wrflow)
+		ppr_options |= MSG_EXT_PPR_WR_FLOW;
+
+	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	ahd_find_syncrate(ahd, &period, &ppr_options,
+			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
+
+	spi_wr_flow(starget) = (ppr_options & MSG_EXT_PPR_WR_FLOW) ? 1 : 0;
+
+	ahd_lock(ahd, &flags);
+	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
+			 ppr_options, AHD_TRANS_GOAL, FALSE);
+	ahd_unlock(ahd, &flags);
+}
+
+static void ahd_linux_set_rti(struct scsi_target *starget, int rti)
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
+		& ~MSG_EXT_PPR_RTI;
+	unsigned int period = tinfo->goal.period;
+	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
+	unsigned long flags;
+
+	if ((ahd->features & AHD_RTI) == 0) {
+#ifdef AHD_DEBUG
+		if ((ahd_debug & AHD_SHOW_DV) != 0)
+			printf("%s: RTI not available\n", ahd_name(ahd));
+#endif
+		return;
+	}
+
+#ifdef AHD_DEBUG
+	if ((ahd_debug & AHD_SHOW_DV) != 0)
+		printf("%s: %s RTI\n", ahd_name(ahd),
+		       rti ? "enabling" : "disabling");
+#endif
+
+	if (rti)
+		ppr_options |= MSG_EXT_PPR_RTI;
+
+	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	ahd_find_syncrate(ahd, &period, &ppr_options,
+			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
+
+	spi_rti(starget) = (ppr_options & MSG_EXT_PPR_RTI) ? 1 : 0;
+
+	ahd_lock(ahd, &flags);
+	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
+			 ppr_options, AHD_TRANS_GOAL, FALSE);
+	ahd_unlock(ahd, &flags);
+}
+
+static void ahd_linux_set_pcomp_en(struct scsi_target *starget, int pcomp)
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
+		& ~MSG_EXT_PPR_PCOMP_EN;
+	unsigned int period = tinfo->goal.period;
+	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
+	unsigned long flags;
+
+#ifdef AHD_DEBUG
+	if ((ahd_debug & AHD_SHOW_DV) != 0)
+		printf("%s: %s Precompensation\n", ahd_name(ahd), 
+		       pcomp ? "Enable" : "Disable");
+#endif
+
+	if (pcomp)
+		ppr_options |= MSG_EXT_PPR_PCOMP_EN;
+
+	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	ahd_find_syncrate(ahd, &period, &ppr_options,
+			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
+
+	spi_pcomp_en(starget) = (ppr_options & MSG_EXT_PPR_PCOMP_EN) ? 1 : 0;
+
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, tinfo->goal.offset,
 			 ppr_options, AHD_TRANS_GOAL, FALSE);
@@ -2534,6 +2733,12 @@ static struct spi_function_template ahd_
 	.show_qas	= 1,
 	.set_rd_strm	= ahd_linux_set_rd_strm,
 	.show_rd_strm	= 1,
+	.set_wr_flow	= ahd_linux_set_wr_flow,
+	.show_wr_flow	= 1,
+	.set_rti	= ahd_linux_set_rti,
+	.show_rti	= 1,
+	.set_pcomp_en	= ahd_linux_set_pcomp_en,
+	.show_pcomp_en	= 1,
 };
 
 

--------------010509060708060706000107--
