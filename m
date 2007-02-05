From: Mark Haverkamp <markh@linux-foundation.org>
Subject: [PATCH] scsi spi transport: SCSI domain validation after reset
Date: Mon, 05 Feb 2007 12:49:00 -0800
Message-ID: <1170708540.2573.10.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32781 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933366AbXBEUtG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Feb 2007 15:49:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

James,

Some months ago, I had problems with a mis-behaving disk that failed
domain validation on a fusion card resulting in an infinite loop of
domain validation.  At the time Eric proposed a patch to the mptspi
driver to reload devices with parameters previously negotiated when a
reset occurred.  You indicated that a more generic solution should be
done.

This patch updates spi_dv_device_internal() to check if domain
validation has already been performed on a device and just sets it
previously negotiated parameters.  This solved the "infinite domain
validation" loop for me when a reset is performed as a result of command
timeout with the mis-behaving device.

Signed-off-by Mark Haverkamp <markh@linux-foundation.org>

---

Applies to scsi-misc-2.6

---

Index: scsi-misc-2.6/drivers/scsi/scsi_transport_spi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_transport_spi.c
+++ scsi-misc-2.6/drivers/scsi/scsi_transport_spi.c
@@ -363,6 +363,7 @@ static int child_iter(struct device *dev
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 
+	spi_initial_dv(sdev->sdev_target) = 0;
 	spi_dv_device(sdev);
 	return 1;
 }
@@ -787,6 +788,29 @@ spi_dv_device_internal(struct scsi_devic
 	struct scsi_target *starget = sdev->sdev_target;
 	struct Scsi_Host *shost = sdev->host;
 	int len = sdev->inquiry_len;
+
+	/*
+	 * If dv has been done already on this target, just set its
+         * previously determined parameters.
+         */
+	if (spi_initial_dv(starget)) {
+		DV_SET(dt, spi_dt(starget));
+		DV_SET(iu, spi_iu(starget));
+		DV_SET(width, spi_width(starget));
+		DV_SET(offset, spi_offset(starget));
+		DV_SET(period, spi_period(starget));
+		DV_SET(qas, spi_qas(starget));
+		DV_SET(rd_strm, spi_rd_strm(starget));
+		DV_SET(wr_flow, spi_wr_flow(starget));
+		DV_SET(rti, spi_rti(starget));
+		DV_SET(pcomp_en, spi_pcomp_en(starget));
+		if (spi_dv_device_compare_inquiry(sdev, buffer,
+		    buffer, DV_LOOPS) == SPI_COMPARE_SUCCESS)
+			return;
+		starget_printk(KERN_ERR, starget,
+				"Domain Validation Inquiry Failed\n");
+	}
+
 	/* first set us up for narrow async */
 	DV_SET(offset, 0);
 	DV_SET(width, 0);
@@ -917,8 +941,10 @@ spi_dv_device(struct scsi_device *sdev)
 	if (unlikely(scsi_device_get(sdev)))
 		return;
 
-	if (unlikely(spi_dv_in_progress(starget)))
+	if (unlikely(spi_dv_in_progress(starget))) {
+		scsi_device_put(sdev);
 		return;
+	}
 	spi_dv_in_progress(starget) = 1;
 
 	buffer = kzalloc(len, GFP_KERNEL);

-- 
Mark Haverkamp <markh@linux-foundation.org>

