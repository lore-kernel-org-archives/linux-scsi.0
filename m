From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] scsi: refactor scsi_reset_provider handling
Date: Thu, 30 Oct 2014 10:27:04 +0100
Message-ID: <1414661229-15199-2-git-send-email-hch@lst.de>
References: <1414661229-15199-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50936 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976AbaJ3J0y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 05:26:54 -0400
In-Reply-To: <1414661229-15199-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

Pull the common code from the two callers into the function,
and renamed it to scsi_ioctl_reset.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_error.c | 76 ++++++++++++++++++++++-------------------------
 drivers/scsi/scsi_ioctl.c | 33 +-------------------
 drivers/scsi/sg.c         | 34 ++-------------------
 include/scsi/scsi_eh.h    | 15 +---------
 4 files changed, 41 insertions(+), 117 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index fa7b5ec..ba19687 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -36,6 +36,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/sg.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -2309,39 +2310,36 @@ scsi_reset_provider_done_command(struct scsi_cmnd *scmd)
 {
 }
 
-/*
- * Function:	scsi_reset_provider
- *
- * Purpose:	Send requested reset to a bus or device at any phase.
- *
- * Arguments:	device	- device to send reset to
- *		flag - reset type (see scsi.h)
- *
- * Returns:	SUCCESS/FAILURE.
- *
- * Notes:	This is used by the SCSI Generic driver to provide
- *		Bus/Device reset capability.
+/**
+ * scsi_ioctl_reset: explicitly reset a host/bus/target/device
+ * @dev:	scsi_device to operate on
+ * @val:	reset type (see sg.h)
  */
 int
-scsi_reset_provider(struct scsi_device *dev, int flag)
+scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 {
 	struct scsi_cmnd *scmd;
 	struct Scsi_Host *shost = dev->host;
 	struct request req;
 	unsigned long flags;
-	int rtn;
+	int error = 0, rtn, val;
+
+	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+		return -EACCES;
+
+	error = get_user(val, arg);
+	if (error)
+		return error;
 
 	if (scsi_autopm_get_host(shost) < 0)
-		return FAILED;
+		return -EIO;
 
-	if (!get_device(&dev->sdev_gendev)) {
-		rtn = FAILED;
+	error = -EIO;
+	if (!get_device(&dev->sdev_gendev))
 		goto out_put_autopm_host;
-	}
 
 	scmd = scsi_get_command(dev, GFP_KERNEL);
 	if (!scmd) {
-		rtn = FAILED;
 		put_device(&dev->sdev_gendev);
 		goto out_put_autopm_host;
 	}
@@ -2362,39 +2360,37 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	shost->tmf_in_progress = 1;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	switch (flag) {
-	case SCSI_TRY_RESET_DEVICE:
+	switch (val & ~SG_SCSI_RESET_NO_ESCALATE) {
+	case SG_SCSI_RESET_NOTHING:
+		rtn = SUCCESS;
+		break;
+	case SG_SCSI_RESET_DEVICE:
 		rtn = scsi_try_bus_device_reset(scmd);
-		if (rtn == SUCCESS)
+		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
 			break;
 		/* FALLTHROUGH */
-	case SCSI_TRY_RESET_TARGET:
+	case SG_SCSI_RESET_TARGET:
 		rtn = scsi_try_target_reset(scmd);
-		if (rtn == SUCCESS)
+		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
 			break;
 		/* FALLTHROUGH */
-	case SCSI_TRY_RESET_BUS:
+	case SG_SCSI_RESET_BUS:
 		rtn = scsi_try_bus_reset(scmd);
-		if (rtn == SUCCESS)
+		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
 			break;
 		/* FALLTHROUGH */
-	case SCSI_TRY_RESET_HOST:
-	case SCSI_TRY_RESET_HOST | SCSI_TRY_RESET_NO_ESCALATE:
+	case SG_SCSI_RESET_HOST:
 		rtn = scsi_try_host_reset(scmd);
-		break;
-	case SCSI_TRY_RESET_DEVICE | SCSI_TRY_RESET_NO_ESCALATE:
-		rtn = scsi_try_bus_device_reset(scmd);
-		break;
-	case SCSI_TRY_RESET_TARGET | SCSI_TRY_RESET_NO_ESCALATE:
-		rtn = scsi_try_target_reset(scmd);
-		break;
-	case SCSI_TRY_RESET_BUS | SCSI_TRY_RESET_NO_ESCALATE:
-		rtn = scsi_try_bus_reset(scmd);
-		break;
+		if (rtn == SUCCESS)
+			break;
 	default:
+		/* FALLTHROUGH */
 		rtn = FAILED;
+		break;
 	}
 
+	error = (rtn == SUCCESS) ? 0 : -EIO;
+
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->tmf_in_progress = 0;
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -2414,9 +2410,9 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	scsi_next_command(scmd);
 out_put_autopm_host:
 	scsi_autopm_put_host(shost);
-	return rtn;
+	return error;
 }
-EXPORT_SYMBOL(scsi_reset_provider);
+EXPORT_SYMBOL(scsi_ioctl_reset);
 
 /**
  * scsi_normalize_sense - normalize main elements from either fixed or
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 5207274..5ddc08f 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -292,8 +292,6 @@ EXPORT_SYMBOL(scsi_ioctl);
 int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 			    void __user *arg, int ndelay)
 {
-	int val, val2, result;
-
 	/* The first set of iocts may be executed even if we're doing
 	 * error processing, as long as the device was opened
 	 * non-blocking */
@@ -305,36 +303,7 @@ int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 
 	switch (cmd) {
 	case SG_SCSI_RESET:
-		result = get_user(val, (int __user *)arg);
-		if (result)
-			return result;
-		if (val & SG_SCSI_RESET_NO_ESCALATE) {
-			val &= ~SG_SCSI_RESET_NO_ESCALATE;
-			val2 = SCSI_TRY_RESET_NO_ESCALATE;
-		} else
-			val2 = 0;
-		if (val == SG_SCSI_RESET_NOTHING)
-			return 0;
-		switch (val) {
-		case SG_SCSI_RESET_DEVICE:
-			val2 |= SCSI_TRY_RESET_DEVICE;
-			break;
-		case SG_SCSI_RESET_TARGET:
-			val2 |= SCSI_TRY_RESET_TARGET;
-			break;
-		case SG_SCSI_RESET_BUS:
-			val2 |= SCSI_TRY_RESET_BUS;
-			break;
-		case SG_SCSI_RESET_HOST:
-			val2 |= SCSI_TRY_RESET_HOST;
-			break;
-		default:
-			return -EINVAL;
-		}
-		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-			return -EACCES;
-		return (scsi_reset_provider(sdev, val2) ==
-			SUCCESS) ? 0 : -EIO;
+		return scsi_ioctl_reset(sdev, arg);
 	}
 	return -ENODEV;
 }
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2fe2701..7c55cac 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -847,7 +847,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
 	void __user *p = (void __user *)arg;
 	int __user *ip = p;
-	int result, val, val2, read_only;
+	int result, val, read_only;
 	Sg_device *sdp;
 	Sg_fd *sfp;
 	Sg_request *srp;
@@ -1079,36 +1079,8 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 				return -EBUSY;
 		} else if (!scsi_block_when_processing_errors(sdp->device))
 			return -EBUSY;
-		result = get_user(val, ip);
-		if (result)
-			return result;
-		if (val & SG_SCSI_RESET_NO_ESCALATE) {
-			val &= ~SG_SCSI_RESET_NO_ESCALATE;
-			val2 = SCSI_TRY_RESET_NO_ESCALATE;
-		} else
-			val2 = 0;
-		if (SG_SCSI_RESET_NOTHING == val)
-			return 0;
-		switch (val) {
-		case SG_SCSI_RESET_DEVICE:
-			val2 |= SCSI_TRY_RESET_DEVICE;
-			break;
-		case SG_SCSI_RESET_TARGET:
-			val2 |= SCSI_TRY_RESET_TARGET;
-			break;
-		case SG_SCSI_RESET_BUS:
-			val2 |= SCSI_TRY_RESET_BUS;
-			break;
-		case SG_SCSI_RESET_HOST:
-			val2 |= SCSI_TRY_RESET_HOST;
-			break;
-		default:
-			return -EINVAL;
-		}
-		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-			return -EACCES;
-		return (scsi_reset_provider(sdp->device, val2) ==
-			SUCCESS) ? 0 : -EIO;
+
+		return scsi_ioctl_reset(sdp->device, ip);
 	case SCSI_IOCTL_SEND_COMMAND:
 		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 2562481..1e1421b 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -60,20 +60,7 @@ extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 
 extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
 
-/*
- * Reset request from external source
- * Note: if SCSI_TRY_RESET_DEVICE fails then it will escalate to
- * SCSI_TRY_RESET_TARGET which if it fails will escalate to
- * SCSI_TRY_RESET_BUS which if it fails will escalate to SCSI_TRY_RESET_HOST.
- * To prevent escalation OR with SCSI_TRY_RESET_NO_ESCALATE.
- */
-#define SCSI_TRY_RESET_DEVICE	1
-#define SCSI_TRY_RESET_BUS	2
-#define SCSI_TRY_RESET_HOST	3
-#define SCSI_TRY_RESET_TARGET	4
-#define SCSI_TRY_RESET_NO_ESCALATE	0x100	/* OR-ed to prior defines */
-
-extern int scsi_reset_provider(struct scsi_device *, int);
+extern int scsi_ioctl_reset(struct scsi_device *, int __user *);
 
 struct scsi_eh_save {
 	/* saved state */
-- 
1.9.1

