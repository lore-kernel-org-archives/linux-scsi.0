From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH as494] Add a scsi_device flag for RETRY_HWERROR
Date: Thu, 24 Mar 2005 11:45:50 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0503241134300.1345-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from ida.rowland.org ([192.131.102.52]:6404 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262638AbVCXQp6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Mar 2005 11:45:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

It turns out that a bunch of USB-IDE converters make the mistake of
returning SK = 04 (Hardware Error) whenever the IDE device signals any
sort of error, without bothering to distinguish recoverable from
non-recoverable errors.  The best way to handle this is for usb-storage to
set a per-device flag indicating that these errors should always be
retried.  The current scheme (blacklist flag but no per-device flag) isn't
well suited for this situation.

This patch adds the per-device flag and sets it initially based on the
blacklist setting.  Once this has been merged, a separate patch will be
submitted to Matt Dharm adding the corresponding support to usb-storage.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

===== include/scsi/scsi_device.h 1.18 vs edited =====
--- 1.18/include/scsi/scsi_device.h	2005-03-22 01:44:56 -05:00
+++ edited/include/scsi/scsi_device.h	2005-03-23 16:58:05 -05:00
@@ -112,6 +112,7 @@
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
 	unsigned select_no_atn:1;
 	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
+	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 
===== drivers/scsi/scsi_error.c 1.48 vs edited =====
--- 1.48/drivers/scsi/scsi_error.c	2005-03-22 01:44:55 -05:00
+++ edited/drivers/scsi/scsi_error.c	2005-03-24 11:41:29 -05:00
@@ -31,7 +31,6 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_request.h>
-#include <scsi/scsi_devinfo.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -352,10 +351,7 @@
 		return NEEDS_RETRY;
 
 	case HARDWARE_ERROR:
-		if (scsi_get_device_flags(scmd->device,
-					scmd->device->vendor,
-					scmd->device->model)
-				& BLIST_RETRY_HWERROR)
+		if (scmd->device->retry_hwerror)
 			return NEEDS_RETRY;
 		else
 			return SUCCESS;
===== drivers/scsi/scsi_scan.c 1.68 vs edited =====
--- 1.68/drivers/scsi/scsi_scan.c	2005-03-22 01:48:14 -05:00
+++ edited/drivers/scsi/scsi_scan.c	2005-03-23 16:58:13 -05:00
@@ -725,6 +725,9 @@
 	if (*bflags & BLIST_NOT_LOCKABLE)
 		sdev->lockable = 0;
 
+	if (*bflags & BLIST_RETRY_HWERROR)
+		sdev->retry_hwerror = 1;
+
 	transport_configure_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->slave_configure)

