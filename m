From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic79xx problems
Date: Fri, 21 Sep 2007 18:01:40 -0500
Message-ID: <1190415701.3333.59.camel@localhost.localdomain>
References: <20070920130440.GE1606@loop.mdy.univie.ac.at>
	 <1190297751.3360.15.camel@localhost.localdomain>
	 <20070920143448.GF1606@loop.mdy.univie.ac.at>
	 <1190299275.3360.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35640 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765691AbXIUXBq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Sep 2007 19:01:46 -0400
In-Reply-To: <1190299275.3360.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Boresch <stefan@mdy.univie.ac.at>
Cc: linux-scsi@vger.kernel.org

On Thu, 2007-09-20 at 09:41 -0500, James Bottomley wrote:
> On Thu, 2007-09-20 at 16:34 +0200, Stefan Boresch wrote:
> > So, since I seem to have a slightly broken machine at hand, let me
> > know whether I can try/test anything to fix the issues the newer
> > kernels might have.
> 
> It will take me a while to set up the configuration, so the dmesg from
> the failing 2.6.2x might be helpful, just in case it's an obvious
> problem that doesn't need debugging (small chance, but still possible).

OK, did the cut cable test (finally).  It turns out that our DV
interaction with aic79xx isn't very smart.  After assessing that wide
isn't allowed and turning it off, it then merrily begins DV at the
lowest possible period it can think of, which turns wide back on again,
sigh.

Try this patch, it fixes the problem for me.

James

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 6f56f87..fccc62d 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -787,6 +787,7 @@ spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
 	struct scsi_target *starget = sdev->sdev_target;
 	struct Scsi_Host *shost = sdev->host;
 	int len = sdev->inquiry_len;
+	int min_period = spi_min_period(starget);
 	/* first set us up for narrow async */
 	DV_SET(offset, 0);
 	DV_SET(width, 0);
@@ -809,6 +810,11 @@ spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
 		    != SPI_COMPARE_SUCCESS) {
 			starget_printk(KERN_ERR, starget, "Wide Transfers Fail\n");
 			i->f->set_width(starget, 0);
+			/* Make sure we don't force wide back on by asking
+			 * for a transfer period that requires it */
+			spi_max_width(starget) = 0;
+			if (min_period < 10)
+				min_period = 10;
 		}
 	}
 
@@ -828,7 +834,8 @@ spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
 
 	/* now set up to the maximum */
 	DV_SET(offset, spi_max_offset(starget));
-	DV_SET(period, spi_min_period(starget));
+	DV_SET(period, min_period);
+
 	/* try QAS requests; this should be harmless to set if the
 	 * target supports it */
 	if (scsi_device_qas(sdev)) {
@@ -837,14 +844,14 @@ spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
 		DV_SET(qas, 0);
 	}
 
-	if (scsi_device_ius(sdev) && spi_min_period(starget) < 9) {
+	if (scsi_device_ius(sdev) && min_period < 9) {
 		/* This u320 (or u640). Set IU transfers */
 		DV_SET(iu, 1);
 		/* Then set the optional parameters */
 		DV_SET(rd_strm, 1);
 		DV_SET(wr_flow, 1);
 		DV_SET(rti, 1);
-		if (spi_min_period(starget) == 8)
+		if (min_period == 8)
 			DV_SET(pcomp_en, 1);
 	} else {
 		DV_SET(iu, 0);


