From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add SCSI reset ioctls to scsi_ioctl.c (and sd and sr)
Date: 18 Sep 2004 22:39:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095561548.2483.12.camel@mulgrave>
References: <1095526671.2483.5.camel@mulgrave>
	<Pine.LNX.4.58.0409182238070.2555@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:33982 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269692AbUISCjK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Sep 2004 22:39:10 -0400
In-Reply-To: <Pine.LNX.4.58.0409182238070.2555@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Sat, 2004-09-18 at 15:49, Kai Makisara wrote:
> Yes, please do that. I would like st to have the same generic capabilities 
> as the other high-level drivers as far as possible and I don't see any 
> problems in adding this feature. It is useful to have an easy way to reset 
> a tape drive. Some drives seem to be lock up easily when they see a bad tape.

OK, I added st.  The attached actually works (I even tested it) for sd.

James

===== drivers/scsi/scsi_ioctl.c 1.30 vs edited =====
--- 1.30/drivers/scsi/scsi_ioctl.c	2004-08-25 11:21:41 -05:00
+++ edited/drivers/scsi/scsi_ioctl.c	2004-09-18 21:31:05 -05:00
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
+++ edited/drivers/scsi/sd.c	2004-09-18 16:23:46 -05:00
@@ -574,8 +574,9 @@
 	 * may try and take the device offline, in which case all further
 	 * access to the device is prohibited.
 	 */
-	if (!scsi_block_when_processing_errors(sdp))
-		return -ENODEV;
+	error = scsi_nonblockable_ioctl(sdp, cmd, p, filp);
+	if (!scsi_block_when_processing_errors(sdp) || !error)
+		return error;
 
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
===== drivers/scsi/st.c 1.94 vs edited =====
--- 1.94/drivers/scsi/st.c	2004-09-14 14:30:18 -05:00
+++ edited/drivers/scsi/st.c	2004-09-18 16:29:29 -05:00
@@ -3128,10 +3128,10 @@
 	 * may try and take the device offline, in which case all further
 	 * access to the device is prohibited.
 	 */
-	if (!scsi_block_when_processing_errors(STp->device)) {
-		retval = (-ENXIO);
+	retval = scsi_nonblockable_ioctl(STp->device, cmd_in, p, file);
+	if (!scsi_block_when_processing_errors(STp->device) || !retval)
 		goto out;
-	}
+
 	cmd_type = _IOC_TYPE(cmd_in);
 	cmd_nr = _IOC_NR(cmd_in);
 
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

