From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v3] SG_SCSI_RESET ioctl: add no_escalate values
Date: Sat, 18 Oct 2014 22:11:21 +0200
Message-ID: <5442C969.4060504@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060601060607040208090109"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51576 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaJRULu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Oct 2014 16:11:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <elliott@hp.com>, Jeremy Linton <jlinton@tributary.com>

This is a multi-part message in MIME format.
--------------060601060607040208090109
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Further to a January 2013 thread titled: "[PATCH] SG_SCSI_RESET ioctl
should only perform requested operation" by Jeremy Linton a patch (v3)
is presented that expands the existing ioctl to include "no_escalate"
versions to the existing resets. This requires no changes to SCSI low
level drivers (LLDs); it adds several more finely tuned reset options
to the user space. For example:

   /* This call remains the same, with the same escalating semantics
    * if the device (LU) reset fail. That is: on failure to try a
    * target reset and if that fails, try a bus reset, and if that fails
    * try a host (i.e. LLD) reset. */
   val = SG_SCSI_RESET_DEVICE;
   res = ioctl(<sg_or_block_fd>, SG_SCSI_RESET, &val);

   /* What follows is a new option introduced by this patch series. Only
    * a device reset is attempted. If that fails then an appropriate
    * error code is provided. N.B. There is no reset escalation. */
   val = SG_SCSI_RESET_DEVICE | SG_SCSI_RESET_NO_ESCALATE;
   res = ioctl(<sg_or_block_fd>, SG_SCSI_RESET, &val);

This patches applies to lk 3.17.0 and Christoph's drivers-for-3.18
tree. The sg_reset utility has been extended to use this new option
since sg3_utils-1.36 package which was released on 20130531.

v3 of this patch changes adding, subtracting and arithmetic
comparisons to the corresponding bitwise logical operations.
For example 'SG_SCSI_RESET_DEVICE + SG_SCSI_RESET_NO_ESCALATE' has
been changed to 'SG_SCSI_RESET_DEVICE | SG_SCSI_RESET_NO_ESCALATE'.

ChangeLog:
   - modify SG_SCSI_RESET ioctl so the SG_SCSI_RESET_NO_ESCALATE
     value may be OR-ed to the existing values. If so the existing
     device->target->bus->host escalation does not occur. The
     SG_SCSI_RESET ioctl is modified in both the sg driver and
     scsi_ioctl.c (so block devices can use it).
   - modify scsi_reset_provider() in the scsi_error.c file in a
     similar way to support this additional functionality.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------060601060607040208090109
Content-Type: text/x-patch;
 name="scsi_reset_no_escal3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scsi_reset_no_escal3.patch"

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6b20ef3..1338479 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2362,8 +2362,18 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 			break;
 		/* FALLTHROUGH */
 	case SCSI_TRY_RESET_HOST:
+	case SCSI_TRY_RESET_HOST | SCSI_TRY_RESET_NO_ESCALATE:
 		rtn = scsi_try_host_reset(scmd);
 		break;
+	case SCSI_TRY_RESET_DEVICE | SCSI_TRY_RESET_NO_ESCALATE:
+		rtn = scsi_try_bus_device_reset(scmd);
+		break;
+	case SCSI_TRY_RESET_TARGET | SCSI_TRY_RESET_NO_ESCALATE:
+		rtn = scsi_try_target_reset(scmd);
+		break;
+	case SCSI_TRY_RESET_BUS | SCSI_TRY_RESET_NO_ESCALATE:
+		rtn = scsi_try_bus_reset(scmd);
+		break;
 	default:
 		rtn = FAILED;
 	}
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 1aaaf43..12fe676 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -285,13 +285,14 @@ EXPORT_SYMBOL(scsi_ioctl);
  * scsi_nonblockable_ioctl() - Handle SG_SCSI_RESET
  * @sdev: scsi device receiving ioctl
  * @cmd: Must be SC_SCSI_RESET
- * @arg: pointer to int containing SG_SCSI_RESET_{DEVICE,BUS,HOST}
+ * @arg: pointer to int containing SG_SCSI_RESET_{DEVICE,TARGET,BUS,HOST}
+ *       possibly OR-ed with SG_SCSI_RESET_NO_ESCALATE
  * @ndelay: file mode O_NDELAY flag
  */
 int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 			    void __user *arg, int ndelay)
 {
-	int val, result;
+	int val, val2, result;
 
 	/* The first set of iocts may be executed even if we're doing
 	 * error processing, as long as the device was opened
@@ -307,27 +308,32 @@ int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 		result = get_user(val, (int __user *)arg);
 		if (result)
 			return result;
+		if (val & SG_SCSI_RESET_NO_ESCALATE) {
+			val &= ~SG_SCSI_RESET_NO_ESCALATE;
+			val2 = SCSI_TRY_RESET_NO_ESCALATE;
+		} else
+			val2 = 0;
 		if (val == SG_SCSI_RESET_NOTHING)
 			return 0;
 		switch (val) {
 		case SG_SCSI_RESET_DEVICE:
-			val = SCSI_TRY_RESET_DEVICE;
+			val2 |= SCSI_TRY_RESET_DEVICE;
 			break;
 		case SG_SCSI_RESET_TARGET:
-			val = SCSI_TRY_RESET_TARGET;
+			val2 |= SCSI_TRY_RESET_TARGET;
 			break;
 		case SG_SCSI_RESET_BUS:
-			val = SCSI_TRY_RESET_BUS;
+			val2 |= SCSI_TRY_RESET_BUS;
 			break;
 		case SG_SCSI_RESET_HOST:
-			val = SCSI_TRY_RESET_HOST;
+			val2 |= SCSI_TRY_RESET_HOST;
 			break;
 		default:
 			return -EINVAL;
 		}
 		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 			return -EACCES;
-		return (scsi_reset_provider(sdev, val) ==
+		return (scsi_reset_provider(sdev, val2) ==
 			SUCCESS) ? 0 : -EIO;
 	}
 	return -ENODEV;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 01cf888..8345fab 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -847,7 +847,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
 	void __user *p = (void __user *)arg;
 	int __user *ip = p;
-	int result, val, read_only;
+	int result, val, val2, read_only;
 	Sg_device *sdp;
 	Sg_fd *sfp;
 	Sg_request *srp;
@@ -1082,27 +1082,32 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		result = get_user(val, ip);
 		if (result)
 			return result;
+		if (val & SG_SCSI_RESET_NO_ESCALATE) {
+			val &= ~SG_SCSI_RESET_NO_ESCALATE;
+			val2 = SCSI_TRY_RESET_NO_ESCALATE;
+		} else
+			val2 = 0;
 		if (SG_SCSI_RESET_NOTHING == val)
 			return 0;
 		switch (val) {
 		case SG_SCSI_RESET_DEVICE:
-			val = SCSI_TRY_RESET_DEVICE;
+			val2 |= SCSI_TRY_RESET_DEVICE;
 			break;
 		case SG_SCSI_RESET_TARGET:
-			val = SCSI_TRY_RESET_TARGET;
+			val2 |= SCSI_TRY_RESET_TARGET;
 			break;
 		case SG_SCSI_RESET_BUS:
-			val = SCSI_TRY_RESET_BUS;
+			val2 |= SCSI_TRY_RESET_BUS;
 			break;
 		case SG_SCSI_RESET_HOST:
-			val = SCSI_TRY_RESET_HOST;
+			val2 |= SCSI_TRY_RESET_HOST;
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
 		if (atomic_read(&sdp->detaching))
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 06a8790..49af14a 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -62,11 +62,16 @@ extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
 
 /*
  * Reset request from external source
+ * Note: if SCSI_TRY_RESET_DEVICE fails then it will escalate to
+ * SCSI_TRY_RESET_TARGET which if it fails will escalate to
+ * SCSI_TRY_RESET_BUS which if it fails will escalate to SCSI_TRY_RESET_HOST.
+ * To prevent escalation OR with SCSI_TRY_RESET_NO_ESCALATE.
  */
 #define SCSI_TRY_RESET_DEVICE	1
 #define SCSI_TRY_RESET_BUS	2
 #define SCSI_TRY_RESET_HOST	3
 #define SCSI_TRY_RESET_TARGET	4
+#define SCSI_TRY_RESET_NO_ESCALATE	0x100	/* OR-ed to prior defines */
 
 extern int scsi_reset_provider(struct scsi_device *, int);
 
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index 750e5db..3afec70 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -164,12 +164,15 @@ typedef struct sg_req_info { /* used by SG_GET_REQUEST_TABLE ioctl() */
 
 /* Returns -EBUSY if occupied. 3rd argument pointer to int (see next) */
 #define SG_SCSI_RESET 0x2284
-/* Associated values that can be given to SG_SCSI_RESET follow */
+/* Associated values that can be given to SG_SCSI_RESET follow.
+ * SG_SCSI_RESET_NO_ESCALATE may be OR-ed to the _DEVICE, _TARGET, _BUS
+ * or _HOST reset value so only that action is attempted. */
 #define		SG_SCSI_RESET_NOTHING	0
 #define		SG_SCSI_RESET_DEVICE	1
 #define		SG_SCSI_RESET_BUS	2
 #define		SG_SCSI_RESET_HOST	3
 #define		SG_SCSI_RESET_TARGET	4
+#define		SG_SCSI_RESET_NO_ESCALATE	0x100
 
 /* synchronous SCSI command ioctl, (only in version 3 interface) */
 #define SG_IO 0x2285   /* similar effect as write() followed by read() */

--------------060601060607040208090109--
