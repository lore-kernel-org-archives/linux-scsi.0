From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add SCSI reset ioctls to scsi_ioctl.c (and sd and sr)
Date: 18 Sep 2004 12:57:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095526671.2483.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:27872 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269581AbUIRQ5v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Sep 2004 12:57:51 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <axboe@suse.de>, Kai Makisara <Kai.Makisara@kolumbus.fi>

The purpose of this patch is to allow a SCSI reset to be issued directly
to the devices without having to go via sg.  Because the reset may be
issued even while the device is in recovery, this had to be done via a
new api (sd won't invoke scsi_ioctl() while the device is in recovery).

Kai, do you want me to plum this into st as well?

James

===== drivers/scsi/scsi_ioctl.c 1.30 vs edited =====
--- 1.30/drivers/scsi/scsi_ioctl.c	2004-08-25 11:21:41 -05:00
+++ edited/drivers/scsi/scsi_ioctl.c	2004-09-18 11:35:17 -05:00
@@ -20,6 +20,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_request.h>
+#include <scsi/sg.h>
 
 #include "scsi_logging.h"
 
@@ -456,3 +457,51 @@
 	}
 	return -EINVAL;
 }
+
+/*
+ * the scsi_nonblock_ioctl() function is designed for ioctls which may
+ * be executed even if the device is in recovery.
+ */
+int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
+			    void __user *arg, struct file *filp)
+{
+	int val, result;
+
+	/* The first set of iocts may be executed even if we're doing
+	 * error processing, as long as the device was opened
+	 * non-blocking */
+	if (filp && filp->f_flags & O_NONBLOCK) {
+		if (test_bit(SHOST_RECOVERY,
+			     &sdev->host->shost_state))
+			return -ENODEV;
+	} else if (!scsi_block_when_processing_errors(sdev))
+		return -ENODEV;
+
+	switch (cmd) {
+	case SG_SCSI_RESET:
+		result = get_user(val, (int __user *)arg);
+		if (result)
+			return result;
+		if (val == SG_SCSI_RESET_NOTHING)
+			return 0;
+		switch (val) {
+		case SG_SCSI_RESET_DEVICE:
+			val = SCSI_TRY_RESET_DEVICE;
+			break;
+		case SG_SCSI_RESET_BUS:
+			val = SCSI_TRY_RESET_BUS;
+			break;
+		case SG_SCSI_RESET_HOST:
+			val = SCSI_TRY_RESET_HOST;
+			break;
+		default:
+			return -EINVAL;
+		}
+		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+			return -EACCES;
+		return (scsi_reset_provider(sdev, val) ==
+			SUCCESS) ? 0 : -EIO;
+	}
+	return -ENODEV;
+}
+EXPORT_SYMBOL(scsi_nonblockable_ioctl);
===== drivers/scsi/sd.c 1.159 vs edited =====
--- 1.159/drivers/scsi/sd.c	2004-09-01 12:35:48 -05:00
+++ edited/drivers/scsi/sd.c	2004-09-18 11:37:41 -05:00
@@ -575,7 +575,7 @@
 	 * access to the device is prohibited.
 	 */
 	if (!scsi_block_when_processing_errors(sdp))
-		return -ENODEV;
+		return scsi_nonblockable_ioctl(sdp, cmd, p, filp);
 
 	if (cmd == HDIO_GETGEO) {
 		if (!arg)
===== drivers/scsi/sr_ioctl.c 1.36 vs edited =====
--- 1.36/drivers/scsi/sr_ioctl.c	2004-08-18 21:45:43 -05:00
+++ edited/drivers/scsi/sr_ioctl.c	2004-09-18 11:34:40 -05:00
@@ -549,5 +549,17 @@
 		 unsigned int cmd, unsigned long arg)
 {
 	Scsi_CD *cd = cdi->handle;
+	int ret;
+	
+	ret = scsi_nonblockable_ioctl(cd->device, cmd,
+				      (void __user *)arg, NULL);
+	/*
+	 * ENODEV means that we didn't recognise the ioctl, or that we
+	 * cannot execute it in the current device state.  In either
+	 * case fall through to scsi_ioctl, which will return ENDOEV again
+	 * if it doesn't recognise the ioctl
+	 */
+	if (ret != -ENODEV)
+		return ret;
 	return scsi_ioctl(cd->device, cmd, (void __user *)arg);
 }
===== include/scsi/scsi_ioctl.h 1.4 vs edited =====
--- 1.4/include/scsi/scsi_ioctl.h	2004-06-18 09:38:19 -05:00
+++ edited/include/scsi/scsi_ioctl.h	2004-09-18 11:31:04 -05:00
@@ -43,6 +43,8 @@
 extern int scsi_ioctl(struct scsi_device *, int, void __user *);
 extern int scsi_ioctl_send_command(struct scsi_device *,
 				   struct scsi_ioctl_command __user *);
+extern int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
+				   void __user *arg, struct file *filp);
 
 #endif /* __KERNEL__ */
 #endif /* _SCSI_IOCTL_H */

