From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 8/10] mpt2sas : release diagnotic buffers prior host reset
Date: Tue, 21 Apr 2009 15:42:13 -0600
Message-ID: <20090421214211.GI18563@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og59.obsmtp.com ([64.18.14.183]:35563 "EHLO
	chip3og59.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbZDUVka (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 17:40:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

Diagnostic buffer support is already there in the driver.  This support allows
applications to pull ring buffers from controller firmware for debugging
firmware related issues.

What this patch does is sends reqeust to firmware to release the buffers prior
to host reset.   This will allow what ever debug info is there prior to reset
to be dma'd to host memory. With out this fix, some of the debug data would
been lost.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uarpN a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c	2009-04-13 15:45:09.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c	2009-04-13 16:10:12.000000000 -0600
@@ -64,6 +64,9 @@
 static struct fasync_struct *async_queue;
 static DECLARE_WAIT_QUEUE_HEAD(ctl_poll_wait);
 
+static int _ctl_send_release(struct MPT2SAS_ADAPTER *ioc, u8 buffer_type,
+    u8 *issue_reset);
+
 /**
  * enum block_state - blocking state
  * @NON_BLOCKING: non blocking
@@ -378,10 +381,22 @@ _ctl_verify_adapter(int ioc_number, stru
 void
 mpt2sas_ctl_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 {
+	int i;
+	u8 issue_reset;
+
 	switch (reset_phase) {
 	case MPT2_IOC_PRE_RESET:
 		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
 		    "MPT2_IOC_PRE_RESET\n", ioc->name, __func__));
+		for (i = 0; i < MPI2_DIAG_BUF_TYPE_COUNT; i++) {
+			if (!(ioc->diag_buffer_status[i] &
+			    MPT2_DIAG_BUFFER_IS_REGISTERED))
+				continue;
+			if ((ioc->diag_buffer_status[i] &
+			    MPT2_DIAG_BUFFER_IS_RELEASED))
+				continue;
+			_ctl_send_release(ioc, i, &issue_reset);
+		}
 		break;
 	case MPT2_IOC_AFTER_RESET:
 		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
@@ -395,6 +410,17 @@ mpt2sas_ctl_reset_handler(struct MPT2SAS
 	case MPT2_IOC_DONE_RESET:
 		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
 		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
+
+		for (i = 0; i < MPI2_DIAG_BUF_TYPE_COUNT; i++) {
+			if (!(ioc->diag_buffer_status[i] &
+			    MPT2_DIAG_BUFFER_IS_REGISTERED))
+				continue;
+			if ((ioc->diag_buffer_status[i] &
+			    MPT2_DIAG_BUFFER_IS_RELEASED))
+				continue;
+			ioc->diag_buffer_status[i] |=
+			    MPT2_DIAG_BUFFER_IS_DIAG_RESET;
+		}
 		break;
 	}
 }
@@ -1553,81 +1579,38 @@ _ctl_diag_query(void __user *arg)
 }
 
 /**
- * _ctl_diag_release - request to send Diag Release Message to firmware
- * @arg - user space buffer containing ioctl content
- * @state - NON_BLOCKING or BLOCKING
+ * _ctl_send_release - Diag Release Message
+ * @ioc: per adapter object
+ * @buffer_type - specifies either TRACE or SNAPSHOT
+ * @issue_reset - specifies whether host reset is required.
  *
- * This allows ownership of the specified buffer to returned to the driver,
- * allowing an application to read the buffer without fear that firmware is
- * overwritting information in the buffer.
  */
-static long
-_ctl_diag_release(void __user *arg, enum block_state state)
+static int
+_ctl_send_release(struct MPT2SAS_ADAPTER *ioc, u8 buffer_type, u8 *issue_reset)
 {
-	struct mpt2_diag_release karg;
-	struct MPT2SAS_ADAPTER *ioc;
-	void *request_data;
-	int rc;
 	Mpi2DiagReleaseRequest_t *mpi_request;
 	Mpi2DiagReleaseReply_t *mpi_reply;
-	u8 buffer_type;
-	unsigned long timeleft;
 	u16 smid;
 	u16 ioc_status;
-	u8 issue_reset = 0;
-
-	if (copy_from_user(&karg, arg, sizeof(karg))) {
-		printk(KERN_ERR "failure at %s:%d/%s()!\n",
-		    __FILE__, __LINE__, __func__);
-		return -EFAULT;
-	}
-	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
-		return -ENODEV;
+	u32 ioc_state;
+	int rc;
+	unsigned long timeleft;
 
 	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
 	    __func__));
 
-	buffer_type = karg.unique_id & 0x000000ff;
-	if (!_ctl_diag_capability(ioc, buffer_type)) {
-		printk(MPT2SAS_ERR_FMT "%s: doesn't have capability for "
-		    "buffer_type(0x%02x)\n", ioc->name, __func__, buffer_type);
-		return -EPERM;
-	}
-
-	if ((ioc->diag_buffer_status[buffer_type] &
-	    MPT2_DIAG_BUFFER_IS_REGISTERED) == 0) {
-		printk(MPT2SAS_ERR_FMT "%s: buffer_type(0x%02x) is not "
-		    "registered\n", ioc->name, __func__, buffer_type);
-		return -EINVAL;
-	}
-
-	if (karg.unique_id != ioc->unique_id[buffer_type]) {
-		printk(MPT2SAS_ERR_FMT "%s: unique_id(0x%08x) is not "
-		    "registered\n", ioc->name, __func__, karg.unique_id);
-		return -EINVAL;
-	}
-
-	if (ioc->diag_buffer_status[buffer_type] &
-	    MPT2_DIAG_BUFFER_IS_RELEASED) {
-		printk(MPT2SAS_ERR_FMT "%s: buffer_type(0x%02x) "
-		    "is already released\n", ioc->name, __func__,
-		    buffer_type);
-		return 0;
-	}
-
-	request_data = ioc->diag_buffer[buffer_type];
+	rc = 0;
+	*issue_reset = 0;
 
-	if (!request_data) {
-		printk(MPT2SAS_ERR_FMT "%s: doesn't have memory allocated for "
-		    "buffer_type(0x%02x)\n", ioc->name, __func__, buffer_type);
-		return -ENOMEM;
+	ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
+	if (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
+		dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "skipping due to FAULT state\n", ioc->name,
+		    __func__));
+		rc = -EAGAIN;
+		goto out;
 	}
 
-	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
-		return -EAGAIN;
-	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
-		return -ERESTARTSYS;
-
 	if (ioc->ctl_cmds.status != MPT2_CMD_NOT_USED) {
 		printk(MPT2SAS_ERR_FMT "%s: ctl_cmd in use\n",
 		    ioc->name, __func__);
@@ -1643,7 +1626,6 @@ _ctl_diag_release(void __user *arg, enum
 		goto out;
 	}
 
-	rc = 0;
 	ioc->ctl_cmds.status = MPT2_CMD_PENDING;
 	memset(ioc->ctl_cmds.reply, 0, ioc->reply_sz);
 	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
@@ -1662,8 +1644,9 @@ _ctl_diag_release(void __user *arg, enum
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2DiagReleaseRequest_t)/4);
 		if (!(ioc->ctl_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
-		goto issue_host_reset;
+			*issue_reset = 1;
+		rc = -EFAULT;
+		goto out;
 	}
 
 	/* process the completed Reply Message Frame */
@@ -1689,14 +1672,101 @@ _ctl_diag_release(void __user *arg, enum
 		rc = -EFAULT;
 	}
 
- issue_host_reset:
+ out:
+	ioc->ctl_cmds.status = MPT2_CMD_NOT_USED;
+	return rc;
+}
+
+/**
+ * _ctl_diag_release - request to send Diag Release Message to firmware
+ * @arg - user space buffer containing ioctl content
+ * @state - NON_BLOCKING or BLOCKING
+ *
+ * This allows ownership of the specified buffer to returned to the driver,
+ * allowing an application to read the buffer without fear that firmware is
+ * overwritting information in the buffer.
+ */
+static long
+_ctl_diag_release(void __user *arg, enum block_state state)
+{
+	struct mpt2_diag_release karg;
+	struct MPT2SAS_ADAPTER *ioc;
+	void *request_data;
+	int rc;
+	u8 buffer_type;
+	u8 issue_reset = 0;
+
+	if (copy_from_user(&karg, arg, sizeof(karg))) {
+		printk(KERN_ERR "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return -EFAULT;
+	}
+	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
+		return -ENODEV;
+
+	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	    __func__));
+
+	buffer_type = karg.unique_id & 0x000000ff;
+	if (!_ctl_diag_capability(ioc, buffer_type)) {
+		printk(MPT2SAS_ERR_FMT "%s: doesn't have capability for "
+		    "buffer_type(0x%02x)\n", ioc->name, __func__, buffer_type);
+		return -EPERM;
+	}
+
+	if ((ioc->diag_buffer_status[buffer_type] &
+	    MPT2_DIAG_BUFFER_IS_REGISTERED) == 0) {
+		printk(MPT2SAS_ERR_FMT "%s: buffer_type(0x%02x) is not "
+		    "registered\n", ioc->name, __func__, buffer_type);
+		return -EINVAL;
+	}
+
+	if (karg.unique_id != ioc->unique_id[buffer_type]) {
+		printk(MPT2SAS_ERR_FMT "%s: unique_id(0x%08x) is not "
+		    "registered\n", ioc->name, __func__, karg.unique_id);
+		return -EINVAL;
+	}
+
+	if (ioc->diag_buffer_status[buffer_type] &
+	    MPT2_DIAG_BUFFER_IS_RELEASED) {
+		printk(MPT2SAS_ERR_FMT "%s: buffer_type(0x%02x) "
+		    "is already released\n", ioc->name, __func__,
+		    buffer_type);
+		return 0;
+	}
+
+	request_data = ioc->diag_buffer[buffer_type];
+
+	if (!request_data) {
+		printk(MPT2SAS_ERR_FMT "%s: doesn't have memory allocated for "
+		    "buffer_type(0x%02x)\n", ioc->name, __func__, buffer_type);
+		return -ENOMEM;
+	}
+
+	/* buffers were released by due to host reset */
+	if ((ioc->diag_buffer_status[buffer_type] &
+	    MPT2_DIAG_BUFFER_IS_DIAG_RESET)) {
+		ioc->diag_buffer_status[buffer_type] |=
+		    MPT2_DIAG_BUFFER_IS_RELEASED;
+		ioc->diag_buffer_status[buffer_type] &=
+		    ~MPT2_DIAG_BUFFER_IS_DIAG_RESET;
+		printk(MPT2SAS_ERR_FMT "%s: buffer_type(0x%02x) "
+		    "was released due to host reset\n", ioc->name, __func__,
+		    buffer_type);
+		return 0;
+	}
+
+	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
+		return -EAGAIN;
+	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
+		return -ERESTARTSYS;
+
+	rc = _ctl_send_release(ioc, buffer_type, &issue_reset);
+
 	if (issue_reset)
 		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 		    FORCE_BIG_HAMMER);
 
- out:
-
-	ioc->ctl_cmds.status = MPT2_CMD_NOT_USED;
 	mutex_unlock(&ioc->ctl_cmds.mutex);
 	return rc;
 }
diff -uarpN a/drivers/scsi/mpt2sas/mpt2sas_ctl.h b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.h	2009-04-13 15:45:09.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.h	2009-04-13 16:17:42.000000000 -0600
@@ -295,8 +295,9 @@ struct mpt2_ioctl_btdh_mapping {
 
 
 /* status bits for ioc->diag_buffer_status */
-#define MPT2_DIAG_BUFFER_IS_REGISTERED 	(0x01)
-#define MPT2_DIAG_BUFFER_IS_RELEASED 	(0x02)
+#define MPT2_DIAG_BUFFER_IS_REGISTERED	(0x01)
+#define MPT2_DIAG_BUFFER_IS_RELEASED	(0x02)
+#define MPT2_DIAG_BUFFER_IS_DIAG_RESET	(0x04)
 
 /* application flags for mpt2_diag_register, mpt2_diag_query */
 #define MPT2_APP_FLAGS_APP_OWNED	(0x0001)
