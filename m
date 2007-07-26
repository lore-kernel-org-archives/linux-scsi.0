From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 8366] aic79xx and aic7xxx driver issues
Date: Thu, 26 Jul 2007 17:13:10 -0400
Message-ID: <1185484390.3501.93.camel@localhost.localdomain>
References: <20070725010525.614621080E4@picon.linux-foundation.org>
	 <1185329683.3488.46.camel@localhost.localdomain>
	 <1185461780.14419.17.camel@fea.ornl.gov>
	 <1185462341.3501.62.camel@localhost.localdomain>
	 <1185480022.14419.58.camel@fea.ornl.gov>
	 <1185482804.3501.87.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39589 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756385AbXGZVNM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 17:13:12 -0400
In-Reply-To: <1185482804.3501.87.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: freelsjd@ornl.gov
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2007-07-26 at 16:46 -0400, James Bottomley wrote:
> On Thu, 2007-07-26 at 16:00 -0400, Freels, James D. wrote:
> > 9) the output from the commands you asked for are shown below for the
> > 2.6.22.1 kernel.  They indicate parity errors on the changer at scsi
> > id=3.  Also, when booting up under 2.6.18.8, the linux media changer
> > scsi device works and initializes; when booting up under 2.6.22.1, it
> > does not; probably because of the same parity errors ?
> > 
> >  target0:0:3: Beginning Domain Validation
> >  target0:0:3: asynchronous
> >  target0:0:3: FAST-20 WIDE SCSI 40.0
>                         ^^^^
> This is the problem.
> 
> Something in the transport class is causing WIDE to be set regardless of
> the max_width setting ... this looks to be a bug in the aic7xxx
> transport class implementation
> 
> >  MB/s ST (50 ns, offset 32)
> > (scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a6)
> > SCSIRATE(0x95)
> 
> Once it goes wide on a narrow device, you get immediate parity errors
> half the time, because you're missing the upper 8 bits for the parity
> calculation.
> 
> I'll see if I can trace this inside the driver ... naturally, I have no
> aic7xxx setup where I only have a narrow device.

OK, could you try the attached as the fix ... I've verified a similar
problem on the aic79xx which this fixes ... I just don't have access to
an aic7xxx currently to try it out with, but I think it should work.

James

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 286ab83..641dc4e 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -2284,9 +2284,12 @@ static void ahd_linux_set_period(struct scsi_target *starget, int period)
 	if (period < 8)
 		period = 8;
 	if (period < 10) {
-		ppr_options |= MSG_EXT_PPR_DT_REQ;
-		if (period == 8)
-			ppr_options |= MSG_EXT_PPR_IU_REQ;
+		if (spi_max_width(starget)) {
+			ppr_options |= MSG_EXT_PPR_DT_REQ;
+			if (period == 8)
+				ppr_options |= MSG_EXT_PPR_IU_REQ;
+		} else 
+			period = 10;
 	}
 
 	dt = ppr_options & MSG_EXT_PPR_DT_REQ;
@@ -2365,7 +2368,7 @@ static void ahd_linux_set_dt(struct scsi_target *starget, int dt)
 		printf("%s: %s DT\n", ahd_name(ahd), 
 		       dt ? "enabling" : "disabling");
 #endif
-	if (dt) {
+	if (dt && spi_max_width(starget)) {
 		ppr_options |= MSG_EXT_PPR_DT_REQ;
 		if (!width)
 			ahd_linux_set_width(starget, 1);
@@ -2447,7 +2450,7 @@ static void ahd_linux_set_iu(struct scsi_target *starget, int iu)
 		       iu ? "enabling" : "disabling");
 #endif
 
-	if (iu) {
+	if (iu && spi_max_width(starget)) {
 		ppr_options |= MSG_EXT_PPR_IU_REQ;
 		ppr_options |= MSG_EXT_PPR_DT_REQ; /* IU requires DT */
 	}
@@ -2487,7 +2490,7 @@ static void ahd_linux_set_rd_strm(struct scsi_target *starget, int rdstrm)
 		       rdstrm  ? "enabling" : "disabling");
 #endif
 
-	if (rdstrm)
+	if (rdstrm && spi_max_width(starget))
 		ppr_options |= MSG_EXT_PPR_RD_STRM;
 
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
@@ -2523,7 +2526,7 @@ static void ahd_linux_set_wr_flow(struct scsi_target *starget, int wrflow)
 		       wrflow ? "enabling" : "disabling");
 #endif
 
-	if (wrflow)
+	if (wrflow && spi_max_width(starget))
 		ppr_options |= MSG_EXT_PPR_WR_FLOW;
 
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
@@ -2567,7 +2570,7 @@ static void ahd_linux_set_rti(struct scsi_target *starget, int rti)
 		       rti ? "enabling" : "disabling");
 #endif
 
-	if (rti)
+	if (rti && spi_max_width(starget))
 		ppr_options |= MSG_EXT_PPR_RTI;
 
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
@@ -2603,7 +2606,7 @@ static void ahd_linux_set_pcomp_en(struct scsi_target *starget, int pcomp)
 		       pcomp ? "Enable" : "Disable");
 #endif
 
-	if (pcomp) {
+	if (pcomp && spi_max_width(starget)) {
 		uint8_t precomp;
 
 		if (ahd->unit < ARRAY_SIZE(aic79xx_iocell_info)) {
@@ -2647,7 +2650,7 @@ static void ahd_linux_set_hold_mcs(struct scsi_target *starget, int hold)
 	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
 	unsigned long flags;
 
-	if (hold)
+	if (hold && spi_max_width(starget))
 		ppr_options |= MSG_EXT_PPR_HOLD_MCS;
 
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 1803ab6..2e9c38f 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -2317,8 +2317,13 @@ static void ahc_linux_set_period(struct scsi_target *starget, int period)
 
 	if (period < 9)
 		period = 9;	/* 12.5ns is our minimum */
-	if (period == 9)
-		ppr_options |= MSG_EXT_PPR_DT_REQ;
+	if (period == 9) {
+		if (spi_max_width(starget))
+			ppr_options |= MSG_EXT_PPR_DT_REQ;
+		else
+			/* need wide for DT and need DT for 12.5 ns */
+			period = 10;
+	}
 
 	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
@@ -2381,7 +2386,7 @@ static void ahc_linux_set_dt(struct scsi_target *starget, int dt)
 	unsigned long flags;
 	struct ahc_syncrate *syncrate;
 
-	if (dt) {
+	if (dt && spi_max_width(starget)) {
 		ppr_options |= MSG_EXT_PPR_DT_REQ;
 		if (!width)
 			ahc_linux_set_width(starget, 1);


