From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] if PQ == 1 don't clear online or allow upper level probes
Date: Fri, 6 Jun 2003 10:00:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606100003.A31327@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:5569 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262028AbTFFQub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 12:50:31 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Similiar to a patch Mike A sent out a long time ago:

http://marc.theaimsgroup.com/?l=linux-scsi&m=99837483305810&w=2

And AFAIR similiar to what redhat does based on Doug L's patch:

http://marc.theaimsgroup.com/?l=linux-scsi&m=98462326621762&w=2

Don't clear online based on the peripheral qualifier value.

Don't allow upper drivers (except for the sg class) to probe/attach to a
scsi_device that has a PQ of 1. sg can still be flooded with devices with
PQ of 1, but not sd.

===== drivers/scsi/scsi_scan.c 1.86 vs edited =====
--- 1.86/drivers/scsi/scsi_scan.c	Sat Jun  7 09:02:08 2003
+++ edited/drivers/scsi/scsi_scan.c	Sat Jun  7 11:07:11 2003
@@ -545,28 +545,6 @@
 
 	print_inquiry(inq_result);
 
-	/*
-	 * For a peripheral qualifier (PQ) value of 1 (001b), the SCSI
-	 * spec says: The device server is capable of supporting the
-	 * specified peripheral device type on this logical unit. However,
-	 * the physical device is not currently connected to this logical
-	 * unit.
-	 *
-	 * The above is vague, as it implies that we could treat 001 and
-	 * 011 the same. Stay compatible with previous code, and create a
-	 * Scsi_Device for a PQ of 1
-	 *
-	 * XXX Save the PQ field let the upper layers figure out if they
-	 * want to attach or not to this device, do not set online FALSE;
-	 * otherwise, offline devices still get an sd allocated, and they
-	 * use up an sd slot.
-	 */
-	if (((inq_result[0] >> 5) & 7) == 1) {
-		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: peripheral"
-				" qualifier of 1, device offlined\n"));
-		sdev->online = FALSE;
-	}
-
 	sdev->removable = (0x80 & inq_result[1]) >> 7;
 	sdev->lockable = sdev->removable;
 	sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
===== drivers/scsi/scsi_sysfs.c 1.22 vs edited =====
--- 1.22/drivers/scsi/scsi_sysfs.c	Thu Jun  5 11:52:51 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Sat Jun  7 11:15:06 2003
@@ -15,6 +15,7 @@
 #include "hosts.h"
 
 #include "scsi_priv.h"
+#include "scsi_logging.h"
 
 /*
  * shost_show_function: macro to create an attr function that can be used to
@@ -65,7 +66,28 @@
 /* all probing is done in the individual ->probe routines */
 static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
 {
-	return 1;
+	struct scsi_device *sdev;
+
+	sdev = to_scsi_device(dev);
+	/*
+	 * For a peripheral qualifier (PQ) value of 1 (001b), the SCSI
+	 * spec says: The device server is capable of supporting the
+	 * specified peripheral device type on this logical unit. However,
+	 * the physical device is not currently connected to this logical
+	 * unit.
+	 *
+	 * The above is vague, as it implies that we could treat 001 and
+	 * 011 the same. Stay compatible with previous code, and create a
+	 * scsi_device for a PQ of 1, but do not allow any upper level
+	 * drivers to attach (this excludes the sg class interface).
+	 */
+	if (((sdev->inquiry[0] >> 5) & 7) == 1) {
+		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "%s: peripheral"
+				" qualifier of 1, no upper drivers probed\n",
+				__FUNCTION__));
+		return 0;
+	} else
+		return 1;
 }
 
 struct bus_type scsi_bus_type = {
