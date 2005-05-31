From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] update spi transport class so that u320 Domain Validation
	works
Date: Tue, 31 May 2005 18:35:39 -0500
Message-ID: <1117582540.8643.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:16769 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261198AbVEaXfo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2005 19:35:44 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j4VNZeA08486
	for <linux-scsi@vger.kernel.org>; Tue, 31 May 2005 19:35:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

There are several extra things that have to be considered when running
Domain Validation on a u320 target (notably how you fall back).

Hopefully this should help us when someone adds this transport class to
aic79xx.

I've tested this on the lsi1030, so I know it works correctly up to
u320.

James

--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -669,6 +669,7 @@ spi_dv_retrain(struct scsi_request *sreq
 {
 	struct spi_internal *i = to_spi_internal(sreq->sr_host->transportt);
 	struct scsi_device *sdev = sreq->sr_device;
+	struct scsi_target *starget = sdev->sdev_target;
 	int period = 0, prevperiod = 0; 
 	enum spi_compare_returns retval;
 
@@ -682,24 +683,40 @@ spi_dv_retrain(struct scsi_request *sreq
 			break;
 
 		/* OK, retrain, fallback */
+		if (i->f->get_iu)
+			i->f->get_iu(starget);
+		if (i->f->get_qas)
+			i->f->get_qas(starget);
 		if (i->f->get_period)
 			i->f->get_period(sdev->sdev_target);
-		newperiod = spi_period(sdev->sdev_target);
-		period = newperiod > period ? newperiod : period;
-		if (period < 0x0d)
-			period++;
-		else
-			period += period >> 1;
-
-		if (unlikely(period > 0xff || period == prevperiod)) {
-			/* Total failure; set to async and return */
-			SPI_PRINTK(sdev->sdev_target, KERN_ERR, "Domain Validation Failure, dropping back to Asynchronous\n");
-			DV_SET(offset, 0);
-			return SPI_COMPARE_FAILURE;
+
+		/* Here's the fallback sequence; first try turning off
+		 * IU, then QAS (if we can control them), then finally
+		 * fall down the periods */
+		if (i->f->set_iu && spi_iu(starget)) {
+			SPI_PRINTK(starget, KERN_ERR, "Domain Validation Disabing Information Units\n");
+			DV_SET(iu, 0);
+		} else if (i->f->set_qas && spi_qas(starget)) {
+			SPI_PRINTK(starget, KERN_ERR, "Domain Validation Disabing Quick Arbitration and Selection\n");
+			DV_SET(qas, 0);
+		} else {
+			newperiod = spi_period(starget);
+			period = newperiod > period ? newperiod : period;
+			if (period < 0x0d)
+				period++;
+			else
+				period += period >> 1;
+
+			if (unlikely(period > 0xff || period == prevperiod)) {
+				/* Total failure; set to async and return */
+				SPI_PRINTK(starget, KERN_ERR, "Domain Validation Failure, dropping back to Asynchronous\n");
+				DV_SET(offset, 0);
+				return SPI_COMPARE_FAILURE;
+			}
+			SPI_PRINTK(starget, KERN_ERR, "Domain Validation detected failure, dropping back\n");
+			DV_SET(period, period);
+			prevperiod = period;
 		}
-		SPI_PRINTK(sdev->sdev_target, KERN_ERR, "Domain Validation detected failure, dropping back\n");
-		DV_SET(period, period);
-		prevperiod = period;
 	}
 	return retval;
 }
@@ -768,23 +785,21 @@ spi_dv_device_internal(struct scsi_reque
 	
 	if (spi_dv_device_compare_inquiry(sreq, buffer, buffer, DV_LOOPS)
 	    != SPI_COMPARE_SUCCESS) {
-		SPI_PRINTK(sdev->sdev_target, KERN_ERR, "Domain Validation Initial Inquiry Failed\n");
+		SPI_PRINTK(starget, KERN_ERR, "Domain Validation Initial Inquiry Failed\n");
 		/* FIXME: should probably offline the device here? */
 		return;
 	}
 
 	/* test width */
 	if (i->f->set_width && spi_max_width(starget) && sdev->wdtr) {
-		i->f->set_width(sdev->sdev_target, 1);
-
-		printk("WIDTH IS %d\n", spi_max_width(starget));
+		i->f->set_width(starget, 1);
 
 		if (spi_dv_device_compare_inquiry(sreq, buffer,
 						   buffer + len,
 						   DV_LOOPS)
 		    != SPI_COMPARE_SUCCESS) {
-			SPI_PRINTK(sdev->sdev_target, KERN_ERR, "Wide Transfers Fail\n");
-			i->f->set_width(sdev->sdev_target, 0);
+			SPI_PRINTK(starget, KERN_ERR, "Wide Transfers Fail\n");
+			i->f->set_width(starget, 0);
 		}
 	}
 
@@ -792,7 +807,7 @@ spi_dv_device_internal(struct scsi_reque
 		return;
 
 	/* device can't handle synchronous */
-	if(!sdev->ppr && !sdev->sdtr)
+	if (!sdev->ppr && !sdev->sdtr)
 		return;
 
 	/* see if the device has an echo buffer.  If it does we can
@@ -807,16 +822,30 @@ spi_dv_device_internal(struct scsi_reque
 	/* now set up to the maximum */
 	DV_SET(offset, spi_max_offset(starget));
 	DV_SET(period, spi_min_period(starget));
+	/* try QAS requests; this should be harmless to set if the
+	 * target supports it */
+	DV_SET(qas, 1);
+	/* Also try IU transfers */
+	DV_SET(iu, 1);
+	if (spi_min_period(starget) < 9) {
+		/* This u320 (or u640). Ignore the coupled parameters
+		 * like DT and IU, but set the optional ones */
+		DV_SET(rd_strm, 1);
+		DV_SET(wr_flow, 1);
+		DV_SET(rti, 1);
+		if (spi_min_period(starget) == 8)
+			DV_SET(pcomp_en, 1);
+	}
 
 	if (len == 0) {
-		SPI_PRINTK(sdev->sdev_target, KERN_INFO, "Domain Validation skipping write tests\n");
+		SPI_PRINTK(starget, KERN_INFO, "Domain Validation skipping write tests\n");
 		spi_dv_retrain(sreq, buffer, buffer + len,
 			       spi_dv_device_compare_inquiry);
 		return;
 	}
 
 	if (len > SPI_MAX_ECHO_BUFFER_SIZE) {
-		SPI_PRINTK(sdev->sdev_target, KERN_WARNING, "Echo buffer size %d is too big, trimming to %d\n", len, SPI_MAX_ECHO_BUFFER_SIZE);
+		SPI_PRINTK(starget, KERN_WARNING, "Echo buffer size %d is too big, trimming to %d\n", len, SPI_MAX_ECHO_BUFFER_SIZE);
 		len = SPI_MAX_ECHO_BUFFER_SIZE;
 	}
 


