From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Mon, 28 Nov 2005 15:41:58 -0600
Message-ID: <1133214118.3325.59.camel@mulgrave>
References: <20051121022158.82709.qmail@web88012.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:2517 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751311AbVK1Vmy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 16:42:54 -0500
In-Reply-To: <20051121022158.82709.qmail@web88012.mail.re2.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Graham Knap <graham.knap@rogers.com>
Cc: Horms <horms@debian.org>, Doug Ledford <dledford@redhat.com>, 338089@bugs.debian.org, linux-scsi@vger.kernel.org

On Sun, 2005-11-20 at 21:21 -0500, Graham Knap wrote:
> Sure enough, the kernel now boots. I'll attach the "dmesg" output here.
> 
> Do you guys have a "final" patch in mind?
> 
> Let me know if there are other tests you'd like me to run. Now that I
> know how to do this, I should be able to turn around test results
> fairly quickly.

OK, try the attached.  If it works out, I'll soak it in -mm for a while
and then try to put it in as a bug fix for 2.6.15.

James

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -812,12 +812,10 @@ spi_dv_device_internal(struct scsi_devic
 	if (!scsi_device_sync(sdev) && !scsi_device_dt(sdev))
 		return;
 
-	/* see if the device has an echo buffer.  If it does we can
-	 * do the SPI pattern write tests */
-
-	len = 0;
-	if (scsi_device_dt(sdev))
-		len = spi_dv_device_get_echo_buffer(sdev, buffer);
+	/* len == -1 is the signal that we need to ascertain the
+	 * presence of an echo buffer before trying to use it.  len ==
+	 * 0 means we don't have an echo buffer */
+	len = -1;
 
  retry:
 
@@ -840,11 +838,23 @@ spi_dv_device_internal(struct scsi_devic
 		if (spi_min_period(starget) == 8)
 			DV_SET(pcomp_en, 1);
 	}
+	/* Do the read only INQUIRY tests */
+	spi_dv_retrain(sdev, buffer, buffer + sdev->inquiry_len,
+		       spi_dv_device_compare_inquiry);
+	/* See if we actually managed to negotiate and sustain DT */
+	if (i->f->get_dt)
+		i->f->get_dt(starget);
+
+	/* see if the device has an echo buffer.  If it does we can do
+	 * the SPI pattern write tests.  Because of some broken
+	 * devices, we *only* try this on a device that has actually
+	 * negotiated DT */
+
+	if (len == -1 && spi_dt(starget))
+		len = spi_dv_device_get_echo_buffer(sdev, buffer);
 
-	if (len == 0) {
+	if (len <= 0) {
 		starget_printk(KERN_INFO, starget, "Domain Validation skipping write tests\n");
-		spi_dv_retrain(sdev, buffer, buffer + len,
-			       spi_dv_device_compare_inquiry);
 		return;
 	}
 


