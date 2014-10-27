From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] scsi: split scsi_nonblockable_ioctl
Date: Mon, 27 Oct 2014 18:59:02 +0100
Message-ID: <1414432746-12888-3-git-send-email-hch@lst.de>
References: <1414432746-12888-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48699 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaJ0QxF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2014 12:53:05 -0400
In-Reply-To: <1414432746-12888-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

The calling conventions for this function where bad as it could return
-ENODEV both for a device not currently online and a not recognized ioctl.

Add a new scsi_ioctl_block_when_processing_errors function that wraps
scsi_block_when_processing_errors with the a special case for the
SG_SCSI_RESET ioctl command, and handle the SG_SCSI_RESET case itself
in scsi_ioctl.  All callers of scsi_ioctl now must call the above helper
to check for the EH state, so that the ioctl handler itself doesn't
have to.

Reported-by: Robert Elliott <Elliott@hp.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ch.c         |  5 +++++
 drivers/scsi/osst.c       |  6 +++---
 drivers/scsi/scsi_ioctl.c | 47 +++++++++++++----------------------------------
 drivers/scsi/sd.c         |  6 +++---
 drivers/scsi/sg.c         | 33 +++++++++++++++------------------
 drivers/scsi/sr.c         | 15 +++++----------
 drivers/scsi/st.c         |  7 +++----
 include/scsi/scsi_ioctl.h |  4 ++--
 8 files changed, 49 insertions(+), 74 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index ef5ae0d..fcd9327 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -616,6 +616,11 @@ static long ch_ioctl(struct file *file,
 	int retval;
 	void __user *argp = (void __user *)arg;
 
+	retval = scsi_ioctl_block_when_processing_errors(ch->device, cmd,
+			file->f_flags & O_NDELAY);
+	if (retval)
+		return retval;
+
 	switch (cmd) {
 	case CHIOGPARAMS:
 	{
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index dff37a25..8c28b49 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -4967,10 +4967,10 @@ static long osst_ioctl(struct file * file,
 	 * may try and take the device offline, in which case all further
 	 * access to the device is prohibited.
 	 */
-	if( !scsi_block_when_processing_errors(STp->device) ) {
-		retval = (-ENXIO);
+	retval = scsi_ioctl_block_when_processing_errors(STp->device, cmd_in,
+			file->f_flags & O_NDELAY);
+	if (retval)
 		goto out;
-	}
 
 	cmd_type = _IOC_TYPE(cmd_in);
 	cmd_nr   = _IOC_NR(cmd_in);
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 6dc61b0..d0cb33d 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -200,19 +200,6 @@ int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	char scsi_cmd[MAX_COMMAND_SIZE];
 
-	/* No idea how this happens.... */
-	if (!sdev)
-		return -ENXIO;
-
-	/*
-	 * If we are in the middle of error recovery, don't let anyone
-	 * else try and use this device.  Also, if error recovery fails, it
-	 * may try and take the device offline, in which case all further
-	 * access to the device is prohibited.
-	 */
-	if (!scsi_block_when_processing_errors(sdev))
-		return -ENODEV;
-
 	/* Check for deprecated ioctls ... all the ioctls which don't
 	 * follow the new unique numbering scheme are deprecated */
 	switch (cmd) {
@@ -273,6 +260,8 @@ int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 				     START_STOP_TIMEOUT, NORMAL_RETRIES);
         case SCSI_IOCTL_GET_PCI:
                 return scsi_ioctl_get_pci(sdev, arg);
+	case SG_SCSI_RESET:
+		return scsi_ioctl_reset(sdev, arg);
 	default:
 		if (sdev->host->hostt->ioctl)
 			return sdev->host->hostt->ioctl(sdev, cmd, arg);
@@ -281,30 +270,20 @@ int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 }
 EXPORT_SYMBOL(scsi_ioctl);
 
-/**
- * scsi_nonblockable_ioctl() - Handle SG_SCSI_RESET
- * @sdev: scsi device receiving ioctl
- * @cmd: Must be SC_SCSI_RESET
- * @arg: pointer to int containing SG_SCSI_RESET_{DEVICE,TARGET,BUS,HOST}
- *       possibly OR-ed with SG_SCSI_RESET_NO_ESCALATE
- * @ndelay: file mode O_NDELAY flag
+/*
+ * We can process a reset even when a device isn't fully operable.
  */
-int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
-			    void __user *arg, int ndelay)
+int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev, int cmd,
+		bool ndelay)
 {
-	/* The first set of iocts may be executed even if we're doing
-	 * error processing, as long as the device was opened
-	 * non-blocking */
-	if (ndelay) {
+	if (cmd == SG_SCSI_RESET && ndelay) {
 		if (scsi_host_in_recovery(sdev->host))
 			return -ENODEV;
-	} else if (!scsi_block_when_processing_errors(sdev))
-		return -ENODEV;
-
-	switch (cmd) {
-	case SG_SCSI_RESET:
-		return scsi_ioctl_reset(sdev, arg);
+	} else {
+		if (!scsi_block_when_processing_errors(sdev))
+			return -ENODEV;
 	}
-	return -ENODEV;
+
+	return 0;
 }
-EXPORT_SYMBOL(scsi_nonblockable_ioctl);
+EXPORT_SYMBOL_GPL(scsi_ioctl_block_when_processing_errors);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cfba74c..070b4b7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1334,9 +1334,9 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 	 * may try and take the device offline, in which case all further
 	 * access to the device is prohibited.
 	 */
-	error = scsi_nonblockable_ioctl(sdp, cmd, p,
-					(mode & FMODE_NDELAY) != 0);
-	if (!scsi_block_when_processing_errors(sdp) || !error)
+	error = scsi_ioctl_block_when_processing_errors(sdp, cmd,
+			mode & FMODE_NDELAY);
+	if (error)
 		goto out;
 
 	/*
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index bf8b14b..2da32ac 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1071,16 +1071,6 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		return put_user(sdp->device->host->hostt->emulated, ip);
-	case SG_SCSI_RESET:
-		if (atomic_read(&sdp->detaching))
-			return -ENODEV;
-		if (filp->f_flags & O_NONBLOCK) {
-			if (scsi_host_in_recovery(sdp->device->host))
-				return -EBUSY;
-		} else if (!scsi_block_when_processing_errors(sdp->device))
-			return -EBUSY;
-
-		return scsi_ioctl_reset(sdp->device, ip);
 	case SCSI_IOCTL_SEND_COMMAND:
 		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
@@ -1100,13 +1090,6 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			return result;
 		sdp->sgdebug = (char) val;
 		return 0;
-	case SCSI_IOCTL_GET_IDLUN:
-	case SCSI_IOCTL_GET_BUS_NUMBER:
-	case SCSI_IOCTL_PROBE_HOST:
-	case SG_GET_TRANSFORM:
-		if (atomic_read(&sdp->detaching))
-			return -ENODEV;
-		return scsi_ioctl(sdp->device, cmd_in, p);
 	case BLKSECTGET:
 		return put_user(max_sectors_bytes(sdp->device->request_queue),
 				ip);
@@ -1122,11 +1105,25 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		return blk_trace_startstop(sdp->device->request_queue, 0);
 	case BLKTRACETEARDOWN:
 		return blk_trace_remove(sdp->device->request_queue);
+	case SCSI_IOCTL_GET_IDLUN:
+	case SCSI_IOCTL_GET_BUS_NUMBER:
+	case SCSI_IOCTL_PROBE_HOST:
+	case SG_GET_TRANSFORM:
+	case SG_SCSI_RESET:
+		if (atomic_read(&sdp->detaching))
+			return -ENODEV;
+		break;
 	default:
 		if (read_only)
 			return -EPERM;	/* don't know so take safe approach */
-		return scsi_ioctl(sdp->device, cmd_in, p);
+		break;
 	}
+
+	result = scsi_ioctl_block_when_processing_errors(sdp->device,
+			cmd_in, filp->f_flags & O_NDELAY);
+	if (result)
+		return result;
+	return scsi_ioctl(sdp->device, cmd_in, p);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 2de44cc..1d9eabf 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -549,6 +549,11 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 
 	mutex_lock(&sr_mutex);
 
+	ret = scsi_ioctl_block_when_processing_errors(sdev, cmd,
+			mode & FMODE_NDELAY);
+	if (ret)
+		goto out;
+
 	/*
 	 * Send SCSI addressing ioctls directly to mid level, send other
 	 * ioctls to cdrom/block level.
@@ -564,16 +569,6 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	if (ret != -ENOSYS)
 		goto out;
 
-	/*
-	 * ENODEV means that we didn't recognise the ioctl, or that we
-	 * cannot execute it in the current device state.  In either
-	 * case fall through to scsi_ioctl, which will return ENDOEV again
-	 * if it doesn't recognise the ioctl
-	 */
-	ret = scsi_nonblockable_ioctl(sdev, cmd, argp,
-					(mode & FMODE_NDELAY) != 0);
-	if (ret != -ENODEV)
-		goto out;
 	ret = scsi_ioctl(sdev, cmd, argp);
 
 out:
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 8d5f8b4..7270e3f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3375,11 +3375,10 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	 * may try and take the device offline, in which case all further
 	 * access to the device is prohibited.
 	 */
-	retval = scsi_nonblockable_ioctl(STp->device, cmd_in, p,
-					file->f_flags & O_NDELAY);
-	if (!scsi_block_when_processing_errors(STp->device) || retval != -ENODEV)
+	retval = scsi_ioctl_block_when_processing_errors(STp->device, cmd_in,
+			file->f_flags & O_NDELAY);
+	if (retval)
 		goto out;
-	retval = 0;
 
 	cmd_type = _IOC_TYPE(cmd_in);
 	cmd_nr = _IOC_NR(cmd_in);
diff --git a/include/scsi/scsi_ioctl.h b/include/scsi/scsi_ioctl.h
index b900684..8d19d1d 100644
--- a/include/scsi/scsi_ioctl.h
+++ b/include/scsi/scsi_ioctl.h
@@ -40,9 +40,9 @@ typedef struct scsi_fctargaddress {
 	unsigned char host_wwn[8]; // include NULL term.
 } Scsi_FCTargAddress;
 
+int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev,
+		int cmd, bool ndelay);
 extern int scsi_ioctl(struct scsi_device *, int, void __user *);
-extern int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
-				   void __user *arg, int ndelay);
 
 #endif /* __KERNEL__ */
 #endif /* _SCSI_IOCTL_H */
-- 
1.9.1

