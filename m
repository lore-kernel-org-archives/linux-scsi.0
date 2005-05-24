From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] allow the HBA to reserve target and device private areas
Date: Tue, 24 May 2005 16:57:31 -0500
Message-ID: <1116971851.5897.52.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:28636 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262204AbVEXV5c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 17:57:32 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j4OLvWA03805
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2005 17:57:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This patch basically allows any HBA attached to the SPI transport class
to declare an extra area which the mid-layer will allocate as part of
its device and target allocations.

James

--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -21,6 +21,7 @@
 #define SCSI_TRANSPORT_H
 
 #include <linux/transport_class.h>
+#include <scsi/scsi_host.h>
 
 struct scsi_transport_template {
 	/* the attribute containers */
@@ -32,8 +33,11 @@ struct scsi_transport_template {
 	 * space of this size will be left at the end of the
 	 * scsi_* structure */
 	int	device_size;
+	int	device_private_offset;
 	int	target_size;
+	int	target_private_offset;
 	int	host_size;
+	/* no private offset for the host; there's an alternative mechanism */
 
 	/*
 	 * True if the transport wants to use a host-based work-queue
@@ -45,4 +49,36 @@ struct scsi_transport_template {
 	dev_to_shost((tc)->dev)
 
 
+/* Private area maintenance. The driver requested allocations come
+ * directly after the transport class allocations (if any).  The idea
+ * is that you *must* call these only once.  The code assumes that the
+ * initial values are the ones the transport specific code requires */
+static inline void
+scsi_transport_reserve_target(struct scsi_transport_template * t, int space)
+{
+	t->target_private_offset = ALIGN(t->target_size, sizeof(void *));
+	t->target_size = t->target_private_offset + space;
+}
+static inline void
+scsi_transport_reserve_device(struct scsi_transport_template * t, int space)
+{
+	t->device_private_offset = ALIGN(t->device_size, sizeof(void *));
+	t->device_size = t->device_private_offset + space;
+}
+static inline void *
+scsi_transport_target_data(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	return (u8 *)starget->starget_data
+		+ shost->transportt->target_private_offset;
+
+}
+static inline void *
+scsi_transport_device_data(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	return (u8 *)sdev->sdev_data
+		+ shost->transportt->device_private_offset;
+}
+
 #endif /* SCSI_TRANSPORT_H */


