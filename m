From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi_transport_spi: fix oops in revalidate
Date: Tue, 29 Jul 2008 12:52:20 -0500
Message-ID: <1217353940.6103.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34334 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754410AbYG2Rws (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2008 13:52:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Hannes Reinecke <hare@suse.de>

The class_device->device conversion is causing an oops in revalidate
because it's assuming that the device_for_each_child iterator will only
return struct scsi_device children.  The conversion made all former
class_devices children of the device as well, so this assumption is
broken.  Fix it.

James

---

I've audited the rest of SCSI, this is the only unchecked iterator function

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 75a64a6..b29360e 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -366,12 +366,14 @@ spi_transport_rd_attr(rti, "%d\n");
 spi_transport_rd_attr(pcomp_en, "%d\n");
 spi_transport_rd_attr(hold_mcs, "%d\n");
 
-/* we only care about the first child device so we return 1 */
+/* we only care about the first child device that's a real SCSI device
+ * so we return 1 to terminate the iteration when we find it */
 static int child_iter(struct device *dev, void *data)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
+	if (!scsi_is_sdev_device(dev))
+		return 0;
 
-	spi_dv_device(sdev);
+	spi_dv_device(to_scsi_device(dev));
 	return 1;
 }
 


