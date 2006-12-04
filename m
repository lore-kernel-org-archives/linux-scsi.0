From: akpm@osdl.org
Subject: [patch 17/30] scsi: fix uaccess handling
Date: Mon, 04 Dec 2006 15:18:34 -0800
Message-ID: <200612042319.kB4NJh8v008777@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56883 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967770AbWLDXUO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 18:20:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, heiko.carstens@de.ibm.com

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/scsi_ioctl.c |   17 +++++++------
 drivers/scsi/sg.c         |   47 +++++++++++++++++++-----------------
 2 files changed, 35 insertions(+), 29 deletions(-)

diff -puN drivers/scsi/scsi_ioctl.c~scsi-fix-uaccess-handling drivers/scsi/scsi_ioctl.c
--- a/drivers/scsi/scsi_ioctl.c~scsi-fix-uaccess-handling
+++ a/drivers/scsi/scsi_ioctl.c
@@ -217,13 +217,16 @@ int scsi_ioctl(struct scsi_device *sdev,
 		if (!access_ok(VERIFY_WRITE, arg, sizeof(struct scsi_idlun)))
 			return -EFAULT;
 
-		__put_user((sdev->id & 0xff)
-			 + ((sdev->lun & 0xff) << 8)
-			 + ((sdev->channel & 0xff) << 16)
-			 + ((sdev->host->host_no & 0xff) << 24),
-			 &((struct scsi_idlun __user *)arg)->dev_id);
-		__put_user(sdev->host->unique_id,
-			 &((struct scsi_idlun __user *)arg)->host_unique_id);
+		if (__put_user((sdev->id & 0xff)
+			       + ((sdev->lun & 0xff) << 8)
+			       + ((sdev->channel & 0xff) << 16)
+			       + ((sdev->host->host_no & 0xff) << 24),
+			       &((struct scsi_idlun __user *)arg)->dev_id))
+			return -EFAULT;
+
+		if(__put_user(sdev->host->unique_id,
+			&((struct scsi_idlun __user *)arg)->host_unique_id))
+			return -EFAULT;
 		return 0;
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 		return put_user(sdev->host->host_no, (int __user *)arg);
diff -puN drivers/scsi/sg.c~scsi-fix-uaccess-handling drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~scsi-fix-uaccess-handling
+++ a/drivers/scsi/sg.c
@@ -556,7 +556,8 @@ sg_write(struct file *filp, const char _
 		return -EDOM;
 	}
 	buf += SZ_SG_HEADER;
-	__get_user(opcode, buf);
+	if (__get_user(opcode, buf))
+		return -EFAULT;
 	if (sfp->next_cmd_len > 0) {
 		if (sfp->next_cmd_len > MAX_COMMAND_SIZE) {
 			SCSI_LOG_TIMEOUT(1, printk("sg_write: command length too long\n"));
@@ -779,6 +780,7 @@ sg_ioctl(struct inode *inode, struct fil
 	Sg_fd *sfp;
 	Sg_request *srp;
 	unsigned long iflags;
+	sg_scsi_id_t __user *sg_idp;
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
@@ -860,26 +862,25 @@ sg_ioctl(struct inode *inode, struct fil
 	case SG_GET_SCSI_ID:
 		if (!access_ok(VERIFY_WRITE, p, sizeof (sg_scsi_id_t)))
 			return -EFAULT;
-		else {
-			sg_scsi_id_t __user *sg_idp = p;
+		sg_idp = p;
 
-			if (sdp->detached)
-				return -ENODEV;
-			__put_user((int) sdp->device->host->host_no,
-				   &sg_idp->host_no);
-			__put_user((int) sdp->device->channel,
-				   &sg_idp->channel);
-			__put_user((int) sdp->device->id, &sg_idp->scsi_id);
-			__put_user((int) sdp->device->lun, &sg_idp->lun);
-			__put_user((int) sdp->device->type, &sg_idp->scsi_type);
-			__put_user((short) sdp->device->host->cmd_per_lun,
-				   &sg_idp->h_cmd_per_lun);
-			__put_user((short) sdp->device->queue_depth,
-				   &sg_idp->d_queue_depth);
-			__put_user(0, &sg_idp->unused[0]);
-			__put_user(0, &sg_idp->unused[1]);
-			return 0;
-		}
+		if (sdp->detached)
+			return -ENODEV;
+		if (__put_user((int) sdp->device->host->host_no,
+			       &sg_idp->host_no) ||
+		    __put_user((int) sdp->device->channel,
+			       &sg_idp->channel) ||
+		    __put_user((int) sdp->device->id, &sg_idp->scsi_id) ||
+		    __put_user((int) sdp->device->lun, &sg_idp->lun) ||
+		    __put_user((int) sdp->device->type, &sg_idp->scsi_type) ||
+		    __put_user((short) sdp->device->host->cmd_per_lun,
+			       &sg_idp->h_cmd_per_lun) ||
+		    __put_user((short) sdp->device->queue_depth,
+			       &sg_idp->d_queue_depth) ||
+		    __put_user(0, &sg_idp->unused[0]) ||
+		    __put_user(0, &sg_idp->unused[1]))
+			return -EFAULT;
+		return 0;
 	case SG_SET_FORCE_PACK_ID:
 		result = get_user(val, ip);
 		if (result)
@@ -894,12 +895,14 @@ sg_ioctl(struct inode *inode, struct fil
 			if ((1 == srp->done) && (!srp->sg_io_owned)) {
 				read_unlock_irqrestore(&sfp->rq_list_lock,
 						       iflags);
-				__put_user(srp->header.pack_id, ip);
+				if (__put_user(srp->header.pack_id, ip))
+					return -EFAULT;
 				return 0;
 			}
 		}
 		read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-		__put_user(-1, ip);
+		if (__put_user(-1, ip))
+			return -EFAULT;
 		return 0;
 	case SG_GET_NUM_WAITING:
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
_
