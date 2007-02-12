From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] scsi spi transport: SCSI domain validation after reset
Date: Mon, 12 Feb 2007 15:45:25 -0600
Message-ID: <1171316725.3690.16.camel@mulgrave.il.steeleye.com>
References: <20070207235140.GA20920@lsil.com>
	 <1171296886.23143.6.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44142 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030190AbXBLVpl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2007 16:45:41 -0500
In-Reply-To: <1171296886.23143.6.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@linux-foundation.org>
Cc: Eric Moore <eric.moore@lsi.com>, linux-scsi@vger.kernel.org

On Mon, 2007-02-12 at 08:14 -0800, Mark Haverkamp wrote:
> This patch fixed my looping DV problem.

As far as I can tell, this is identical to Eric's patch, but is done
using the existing dv_in_progress flag ... can you test it out and see
if it actually works?

Thanks,

James
Index: linux-2.6/drivers/scsi/scsi_transport_spi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_transport_spi.c	2007-02-11 14:16:51.000000000 -0600
+++ linux-2.6/drivers/scsi/scsi_transport_spi.c	2007-02-12 15:20:59.000000000 -0600
@@ -787,6 +787,7 @@ spi_dv_device_internal(struct scsi_devic
 	struct scsi_target *starget = sdev->sdev_target;
 	struct Scsi_Host *shost = sdev->host;
 	int len = sdev->inquiry_len;
+
 	/* first set us up for narrow async */
 	DV_SET(offset, 0);
 	DV_SET(width, 0);
@@ -917,8 +918,25 @@ spi_dv_device(struct scsi_device *sdev)
 	if (unlikely(scsi_device_get(sdev)))
 		return;
 
-	if (unlikely(spi_dv_in_progress(starget)))
+	if (unlikely(spi_dv_in_progress(starget))) {
+		/*
+		 * If DV is already pending, just make sure the device
+		 * has all the parameters set (in case this is the
+		 * result of a reset during the in progress DV)
+		 */
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
+		scsi_device_put(sdev);
 		return;
+	}
 	spi_dv_in_progress(starget) = 1;
 
 	buffer = kzalloc(len, GFP_KERNEL);


