From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] SG_SCSI_RESET ioctl: add no_escalate values
Date: Fri, 15 Feb 2013 14:39:35 -0500
Message-ID: <511E8EF7.3010004@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050603030106020701030903"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59784 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab3BOTjp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2013 14:39:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Jeremy Linton <jlinton@tributary.com>

This is a multi-part message in MIME format.
--------------050603030106020701030903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Further to the thread titled: "[PATCH] SG_SCSI_RESET ioctl should
only perform requested operation" by Jeremy Linton a patch
is presented that adds "no_escalate" versions to the existing
ioctl. This should not break any existing code.

This patches applies to lk 3.7.7 and lk 3.8.0-rc7 . I will extend
sg_reset in the sg3_utils package to use it.

ChangeLog:
   - modify SG_SCSI_RESET ioctl so the SG_SCSI_RESET_NO_ESCALATE
     value may be added to the existing values. If so the existing
     device->target->bus->host escalation does not occur.
   - modify scsi_reset_provider() in the scsi_error.c file in a
     similar way to support this new functionality.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------050603030106020701030903
Content-Type: text/x-patch;
 name="scsi_reset_no_escal1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scsi_reset_no_escal1.patch"

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c1b05a8..4ba79c1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2013,8 +2013,18 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 			break;
 		/* FALLTHROUGH */
 	case SCSI_TRY_RESET_HOST:
+	case SCSI_TRY_RESET_HOST + SCSI_TRY_RESET_NO_ESCALATE:
 		rtn = scsi_try_host_reset(scmd);
 		break;
+	case SCSI_TRY_RESET_DEVICE + SCSI_TRY_RESET_NO_ESCALATE:
+		rtn = scsi_try_bus_device_reset(scmd);
+		break;
+	case SCSI_TRY_RESET_TARGET + SCSI_TRY_RESET_NO_ESCALATE:
+		rtn = scsi_try_target_reset(scmd);
+		break;
+	case SCSI_TRY_RESET_BUS + SCSI_TRY_RESET_NO_ESCALATE:
+		rtn = scsi_try_bus_reset(scmd);
+		break;
 	default:
 		rtn = FAILED;
 	}
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 06a8790..49d07e9 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -62,11 +62,16 @@ extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
 
 /*
  * Reset request from external source
+ * Note: if SCSI_TRY_RESET_DEVICE fails then it will escalate to
+ * SCSI_TRY_RESET_TARGET which if it fails will escalate to
+ * SCSI_TRY_RESET_BUS which if it fails will escalate to SCSI_TRY_RESET_HOST.
+ * To prevent escalation add SCSI_TRY_RESET_NO_ESCALATE.
  */
 #define SCSI_TRY_RESET_DEVICE	1
 #define SCSI_TRY_RESET_BUS	2
 #define SCSI_TRY_RESET_HOST	3
 #define SCSI_TRY_RESET_TARGET	4
+#define SCSI_TRY_RESET_NO_ESCALATE	0x100	/* may add to prior defines */
 
 extern int scsi_reset_provider(struct scsi_device *, int);
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index be2c9a6..d9226ec 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -810,7 +810,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
 	void __user *p = (void __user *)arg;
 	int __user *ip = p;
-	int result, val, read_only;
+	int result, val, val2, read_only;
 	Sg_device *sdp;
 	Sg_fd *sfp;
 	Sg_request *srp;
@@ -1045,27 +1045,32 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		result = get_user(val, ip);
 		if (result)
 			return result;
+		if (val >= SG_SCSI_RESET_NO_ESCALATE) {
+			val -= SG_SCSI_RESET_NO_ESCALATE;
+			val2 = SCSI_TRY_RESET_NO_ESCALATE;
+		} else
+			val2 = 0;
 		if (SG_SCSI_RESET_NOTHING == val)
 			return 0;
 		switch (val) {
 		case SG_SCSI_RESET_DEVICE:
-			val = SCSI_TRY_RESET_DEVICE;
+			val2 += SCSI_TRY_RESET_DEVICE;
 			break;
 		case SG_SCSI_RESET_TARGET:
-			val = SCSI_TRY_RESET_TARGET;
+			val2 += SCSI_TRY_RESET_TARGET;
 			break;
 		case SG_SCSI_RESET_BUS:
-			val = SCSI_TRY_RESET_BUS;
+			val2 += SCSI_TRY_RESET_BUS;
 			break;
 		case SG_SCSI_RESET_HOST:
-			val = SCSI_TRY_RESET_HOST;
+			val2 += SCSI_TRY_RESET_HOST;
 			break;
 		default:
 			return -EINVAL;
 		}
 		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 			return -EACCES;
-		return (scsi_reset_provider(sdp->device, val) ==
+		return (scsi_reset_provider(sdp->device, val2) ==
 			SUCCESS) ? 0 : -EIO;
 	case SCSI_IOCTL_SEND_COMMAND:
 		if (sdp->detached)
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index a9f3c6f..8207171 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -204,12 +204,15 @@ typedef struct sg_req_info { /* used by SG_GET_REQUEST_TABLE ioctl() */
 
 /* Returns -EBUSY if occupied. 3rd argument pointer to int (see next) */
 #define SG_SCSI_RESET 0x2284
-/* Associated values that can be given to SG_SCSI_RESET follow */
+/* Associated values that can be given to SG_SCSI_RESET follow.
+ * SG_SCSI_RESET_NO_ESCALATE may be added to the _DEVICE, _TARGET, _BUS
+ * or _HOST reset value so only that action is attempted. */
 #define		SG_SCSI_RESET_NOTHING	0
 #define		SG_SCSI_RESET_DEVICE	1
 #define		SG_SCSI_RESET_BUS	2
 #define		SG_SCSI_RESET_HOST	3
 #define		SG_SCSI_RESET_TARGET	4
+#define		SG_SCSI_RESET_NO_ESCALATE	0x100
 
 /* synchronous SCSI command ioctl, (only in version 3 interface) */
 #define SG_IO 0x2285   /* similar effect as write() followed by read() */

--------------050603030106020701030903--
