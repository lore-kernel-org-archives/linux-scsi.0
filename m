From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 8366] aic79xx and aic7xxx driver issues
Date: Thu, 26 Jul 2007 17:44:24 -0400
Message-ID: <1185486264.3501.99.camel@localhost.localdomain>
References: <20070725010525.614621080E4@picon.linux-foundation.org>
	 <1185329683.3488.46.camel@localhost.localdomain>
	 <1185461780.14419.17.camel@fea.ornl.gov>
	 <1185462341.3501.62.camel@localhost.localdomain>
	 <1185480022.14419.58.camel@fea.ornl.gov>
	 <1185482804.3501.87.camel@localhost.localdomain>
	 <1185484390.3501.93.camel@localhost.localdomain>
	 <1185484597.14419.65.camel@fea.ornl.gov>
	 <1185485358.3501.94.camel@localhost.localdomain>
	 <1185485848.14419.71.camel@fea.ornl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-OZ0fcWQVu0I2ngKNzWlj"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58099 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757885AbXGZVo0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 17:44:26 -0400
In-Reply-To: <1185485848.14419.71.camel@fea.ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: freelsjd@ornl.gov
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>


--=-OZ0fcWQVu0I2ngKNzWlj
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-07-26 at 17:37 -0400, Freels, James D. wrote:
> Here is what I get when I apply the patch against the vanilla 2.6.22.1
> source:

The reject files all have spaces instead of tabs, so it looks like your
mailer did some nefarious translation.

Try the attachment ... that usually defeats mailer text translations.

the md5sum just for integrity's sake is 9ba6ace80c06d34b5391407ea68c381a

I tested it against 2.6.22.1 and it applies (but with some offsets):

jejb@hobholes> quilt push
Applying patch tmp.diff
patching file drivers/scsi/aic7xxx/aic79xx_osm.c
Hunk #1 succeeded at 2309 (offset 25 lines).
Hunk #2 succeeded at 2393 (offset 25 lines).
Hunk #3 succeeded at 2475 (offset 25 lines).
Hunk #4 succeeded at 2515 (offset 25 lines).
Hunk #5 succeeded at 2551 (offset 25 lines).
Hunk #6 succeeded at 2595 (offset 25 lines).
Hunk #7 succeeded at 2631 (offset 25 lines).
Hunk #8 succeeded at 2675 (offset 25 lines).
patching file drivers/scsi/aic7xxx/aic7xxx_osm.c
Hunk #1 succeeded at 2356 (offset 39 lines).
Hunk #2 succeeded at 2425 (offset 39 lines).

James


--=-OZ0fcWQVu0I2ngKNzWlj
Content-Description: 
Content-Disposition: inline; filename=tmp.diff
Content-Type: text/x-patch; charset=utf-8
Content-Transfer-Encoding: 7bit

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

--=-OZ0fcWQVu0I2ngKNzWlj--

