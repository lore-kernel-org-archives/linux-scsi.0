From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/3] scsi_transport_spi: use spi target settings instead of
 inquiry data for DV
Date: Wed, 17 Jun 2009 15:03:41 -0400
Message-ID: <1245265421.8585.97.camel@mulgrave.site>
References: <1245265244.8585.94.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38379 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757467AbZFQTDm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jun 2009 15:03:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 092638EE10E
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 12:03:45 -0700 (PDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
	by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WA2hntNCD2GN for <linux-scsi@vger.kernel.org>;
	Wed, 17 Jun 2009 12:03:44 -0700 (PDT)
Received: from [192.168.10.224] (newmulgrave.ext.hansenpartnership.com [192.168.10.224])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id A79B28EE0F1
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 12:03:44 -0700 (PDT)
In-Reply-To: <1245265244.8585.94.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Right at the moment, we carefully set up the spi_support_xx in the
device configuration routines, but then we never actually use the
results: we rely on the inquiry strings.  If we're going to allow
overrides to the inquiry data, we have to rely on our own internal
settings.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_transport_spi.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 654a34f..00cfb40 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -833,7 +833,7 @@ spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
 		return;
 	}
 
-	if (!scsi_device_wide(sdev)) {
+	if (!spi_support_wide(starget)) {
 		spi_max_width(starget) = 0;
 		max_width = 0;
 	}
@@ -860,7 +860,7 @@ spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
 		return;
 
 	/* device can't handle synchronous */
-	if (!scsi_device_sync(sdev) && !scsi_device_dt(sdev))
+	if (!spi_support_sync(starget) && !spi_support_dt(starget))
 		return;
 
 	/* len == -1 is the signal that we need to ascertain the
@@ -876,13 +876,14 @@ spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
 
 	/* try QAS requests; this should be harmless to set if the
 	 * target supports it */
-	if (scsi_device_qas(sdev) && spi_max_qas(starget)) {
+	if (spi_support_qas(starget) && spi_max_qas(starget)) {
 		DV_SET(qas, 1);
 	} else {
 		DV_SET(qas, 0);
 	}
 
-	if (scsi_device_ius(sdev) && spi_max_iu(starget) && min_period < 9) {
+	if (spi_support_ius(starget) && spi_max_iu(starget) &&
+	    min_period < 9) {
 		/* This u320 (or u640). Set IU transfers */
 		DV_SET(iu, 1);
 		/* Then set the optional parameters */
@@ -902,7 +903,7 @@ spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
 		i->f->get_signalling(shost);
 	if (spi_signalling(shost) == SPI_SIGNAL_SE ||
 	    spi_signalling(shost) == SPI_SIGNAL_HVD ||
-	    !scsi_device_dt(sdev)) {
+	    !spi_support_dt(starget)) {
 		DV_SET(dt, 0);
 	} else {
 		DV_SET(dt, 1);
-- 
1.6.2.4



