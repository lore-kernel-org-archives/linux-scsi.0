From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 06/12] mptfusion: Setting period,offset and width for SPI driver
Date: Thu, 18 Mar 2010 19:21:34 +0530
Message-ID: <20100318135122.GG22510@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:35966 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879Ab0CROWn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 10:22:43 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Set factor, offset and width while target negotiation.

Added config timeout 60 seconds. It was missing for only
mptspi_read_spi_device_pg0

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 763d080..6db9932 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -209,6 +209,10 @@ mptspi_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *target,
 	target->maxOffset = offset;
 	target->maxWidth = width;
 
+	spi_min_period(scsi_target(sdev)) = factor;
+	spi_max_offset(scsi_target(sdev)) = offset;
+	spi_max_width(scsi_target(sdev)) = width;
+
 	target->tflags |= MPT_TARGET_FLAGS_VALID_NEGO;
 
 	/* Disable unused features.
@@ -557,6 +561,7 @@ static int mptspi_read_spi_device_pg0(struct scsi_target *starget,
 	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 	cfg.dir = 0;
 	cfg.pageAddr = starget->id;
+	cfg.timeout = 60;
 
 	if (mpt_config(ioc, &cfg)) {
 		starget_printk(KERN_ERR, starget, MYIOC_s_FMT "mpt_config failed\n", ioc->name);
