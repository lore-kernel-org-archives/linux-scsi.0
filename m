Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 515D5C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiJXDXC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiJXDWe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:22:34 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA2FF1A22F
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:21:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 9B0FC2041BD;
        Mon, 24 Oct 2022 05:21:03 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LCMX7Te23Q-1; Mon, 24 Oct 2022 05:21:03 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id 2554C2041AF;
        Mon, 24 Oct 2022 05:21:02 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, Hannes Reinecke <hare@suse.com>
Subject: [PATCH v25 01/44] sg: move functions around
Date:   Sun, 23 Oct 2022 23:20:15 -0400
Message-Id: <20221024032058.14077-2-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024032058.14077-1-dgilbert@interlog.com>
References: <20221024032058.14077-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move main entry point functions around so submission code comes
before completion code. Prior to this, the driver used the
traditional open(), close(), read(), write(), ioctl() ordering
however in this case that places completion code (i.e.
sg_read()) before submission code (i.e. sg_write()). The main
driver entry points are considered to be those named in struct
file_operations sg_fops' definition.

Helper functions are placed above their caller to reduce the
number of forward function declarations needed.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 422 +++++++++++++++++++++++-----------------------
 1 file changed, 210 insertions(+), 212 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ce34a8ad53b4..fc125d0aff97 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -8,11 +8,12 @@
  * Original driver (sg.c):
  *        Copyright (C) 1992 Lawrence Foard
  * Version 2 and 3 extensions to driver:
- *        Copyright (C) 1998 - 2014 Douglas Gilbert
+ *        Copyright (C) 1998 - 2019 Douglas Gilbert
  */
 
-static int sg_version_num = 30536;	/* 2 digits for each component */
-#define SG_VERSION_STR "3.5.36"
+static int sg_version_num = 30901;  /* [x]xyyzz where [x] empty when x=0 */
+#define SG_VERSION_STR "3.9.01"		/* [x]x.[y]y.zz */
+static char *sg_version_date = "20190606";
 
 /*
  *  D. P. Gilbert (dgilbert@interlog.com), notes:
@@ -48,6 +49,7 @@ static int sg_version_num = 30536;	/* 2 digits for each component */
 #include <linux/ratelimit.h>
 #include <linux/uio.h>
 #include <linux/cred.h> /* for sg_check_file_access() */
+#include <linux/proc_fs.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -62,12 +64,6 @@ static int sg_version_num = 30536;	/* 2 digits for each component */
 
 #include "scsi_logging.h"
 
-#ifdef CONFIG_SCSI_PROC_FS
-#include <linux/proc_fs.h>
-static char *sg_version_date = "20140603";
-
-static int sg_proc_init(void);
-#endif
 
 #define SG_ALLOW_DIO_DEF 0
 
@@ -178,11 +174,11 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 
 /* tasklet or soft irq callback */
 static enum rq_end_io_ret sg_rq_end_io(struct request *rq, blk_status_t status);
+/* Declarations of other static functions used before they are defined */
+static int sg_proc_init(void);
 static int sg_start_req(Sg_request *srp, unsigned char *cmd);
 static int sg_finish_rem_req(Sg_request * srp);
 static int sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size);
-static ssize_t sg_new_read(Sg_fd * sfp, char __user *buf, size_t count,
-			   Sg_request * srp);
 static ssize_t sg_new_write(Sg_fd *sfp, struct file *file,
 			const char __user *buf, size_t count, int blocking,
 			int read_only, int sg_io_owned, Sg_request **o_srp);
@@ -231,17 +227,6 @@ static int sg_check_file_access(struct file *filp, const char *caller)
 	return 0;
 }
 
-static int sg_allow_access(struct file *filp, unsigned char *cmd)
-{
-	struct sg_fd *sfp = filp->private_data;
-
-	if (sfp->parentdp->device->type == TYPE_SCANNER)
-		return 0;
-	if (!scsi_cmd_allowed(cmd, filp->f_mode))
-		return -EPERM;
-	return 0;
-}
-
 static int
 open_wait(Sg_device *sdp, int flags)
 {
@@ -405,196 +390,6 @@ sg_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static int get_sg_io_pack_id(int *pack_id, void __user *buf, size_t count)
-{
-	struct sg_header __user *old_hdr = buf;
-	int reply_len;
-
-	if (count >= SZ_SG_HEADER) {
-		/* negative reply_len means v3 format, otherwise v1/v2 */
-		if (get_user(reply_len, &old_hdr->reply_len))
-			return -EFAULT;
-
-		if (reply_len >= 0)
-			return get_user(*pack_id, &old_hdr->pack_id);
-
-		if (in_compat_syscall() &&
-		    count >= sizeof(struct compat_sg_io_hdr)) {
-			struct compat_sg_io_hdr __user *hp = buf;
-
-			return get_user(*pack_id, &hp->pack_id);
-		}
-
-		if (count >= sizeof(struct sg_io_hdr)) {
-			struct sg_io_hdr __user *hp = buf;
-
-			return get_user(*pack_id, &hp->pack_id);
-		}
-	}
-
-	/* no valid header was passed, so ignore the pack_id */
-	*pack_id = -1;
-	return 0;
-}
-
-static ssize_t
-sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
-{
-	Sg_device *sdp;
-	Sg_fd *sfp;
-	Sg_request *srp;
-	int req_pack_id = -1;
-	bool busy;
-	sg_io_hdr_t *hp;
-	struct sg_header *old_hdr;
-	int retval;
-
-	/*
-	 * This could cause a response to be stranded. Close the associated
-	 * file descriptor to free up any resources being held.
-	 */
-	retval = sg_check_file_access(filp, __func__);
-	if (retval)
-		return retval;
-
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
-		return -ENXIO;
-	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
-				      "sg_read: count=%d\n", (int) count));
-
-	if (sfp->force_packid)
-		retval = get_sg_io_pack_id(&req_pack_id, buf, count);
-	if (retval)
-		return retval;
-
-	srp = sg_get_rq_mark(sfp, req_pack_id, &busy);
-	if (!srp) {		/* now wait on packet to arrive */
-		if (filp->f_flags & O_NONBLOCK)
-			return -EAGAIN;
-		retval = wait_event_interruptible(sfp->read_wait,
-			((srp = sg_get_rq_mark(sfp, req_pack_id, &busy)) ||
-			(!busy && atomic_read(&sdp->detaching))));
-		if (!srp)
-			/* signal or detaching */
-			return retval ? retval : -ENODEV;
-	}
-	if (srp->header.interface_id != '\0')
-		return sg_new_read(sfp, buf, count, srp);
-
-	hp = &srp->header;
-	old_hdr = kzalloc(SZ_SG_HEADER, GFP_KERNEL);
-	if (!old_hdr)
-		return -ENOMEM;
-
-	old_hdr->reply_len = (int) hp->timeout;
-	old_hdr->pack_len = old_hdr->reply_len; /* old, strange behaviour */
-	old_hdr->pack_id = hp->pack_id;
-	old_hdr->twelve_byte =
-	    ((srp->data.cmd_opcode >= 0xc0) && (12 == hp->cmd_len)) ? 1 : 0;
-	old_hdr->target_status = hp->masked_status;
-	old_hdr->host_status = hp->host_status;
-	old_hdr->driver_status = hp->driver_status;
-	if ((CHECK_CONDITION & hp->masked_status) ||
-	    (srp->sense_b[0] & 0x70) == 0x70) {
-		old_hdr->driver_status = DRIVER_SENSE;
-		memcpy(old_hdr->sense_buffer, srp->sense_b,
-		       sizeof (old_hdr->sense_buffer));
-	}
-	switch (hp->host_status) {
-	/* This setup of 'result' is for backward compatibility and is best
-	   ignored by the user who should use target, host + driver status */
-	case DID_OK:
-	case DID_PASSTHROUGH:
-	case DID_SOFT_ERROR:
-		old_hdr->result = 0;
-		break;
-	case DID_NO_CONNECT:
-	case DID_BUS_BUSY:
-	case DID_TIME_OUT:
-		old_hdr->result = EBUSY;
-		break;
-	case DID_BAD_TARGET:
-	case DID_ABORT:
-	case DID_PARITY:
-	case DID_RESET:
-	case DID_BAD_INTR:
-		old_hdr->result = EIO;
-		break;
-	case DID_ERROR:
-		old_hdr->result = (srp->sense_b[0] == 0 && 
-				  hp->masked_status == GOOD) ? 0 : EIO;
-		break;
-	default:
-		old_hdr->result = EIO;
-		break;
-	}
-
-	/* Now copy the result back to the user buffer.  */
-	if (count >= SZ_SG_HEADER) {
-		if (copy_to_user(buf, old_hdr, SZ_SG_HEADER)) {
-			retval = -EFAULT;
-			goto free_old_hdr;
-		}
-		buf += SZ_SG_HEADER;
-		if (count > old_hdr->reply_len)
-			count = old_hdr->reply_len;
-		if (count > SZ_SG_HEADER) {
-			if (sg_read_oxfer(srp, buf, count - SZ_SG_HEADER)) {
-				retval = -EFAULT;
-				goto free_old_hdr;
-			}
-		}
-	} else
-		count = (old_hdr->result == 0) ? 0 : -EIO;
-	sg_finish_rem_req(srp);
-	sg_remove_request(sfp, srp);
-	retval = count;
-free_old_hdr:
-	kfree(old_hdr);
-	return retval;
-}
-
-static ssize_t
-sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
-{
-	sg_io_hdr_t *hp = &srp->header;
-	int err = 0, err2;
-	int len;
-
-	if (in_compat_syscall()) {
-		if (count < sizeof(struct compat_sg_io_hdr)) {
-			err = -EINVAL;
-			goto err_out;
-		}
-	} else if (count < SZ_SG_IO_HDR) {
-		err = -EINVAL;
-		goto err_out;
-	}
-	hp->sb_len_wr = 0;
-	if ((hp->mx_sb_len > 0) && hp->sbp) {
-		if ((CHECK_CONDITION & hp->masked_status) ||
-		    (srp->sense_b[0] & 0x70) == 0x70) {
-			int sb_len = SCSI_SENSE_BUFFERSIZE;
-			sb_len = (hp->mx_sb_len > sb_len) ? sb_len : hp->mx_sb_len;
-			len = 8 + (int) srp->sense_b[7];	/* Additional sense length field */
-			len = (len > sb_len) ? sb_len : len;
-			if (copy_to_user(hp->sbp, srp->sense_b, len)) {
-				err = -EFAULT;
-				goto err_out;
-			}
-			hp->driver_status = DRIVER_SENSE;
-			hp->sb_len_wr = len;
-		}
-	}
-	if (hp->masked_status || hp->host_status || hp->driver_status)
-		hp->info |= SG_INFO_CHECK;
-	err = put_sg_io_hdr(hp, buf);
-err_out:
-	err2 = sg_finish_rem_req(srp);
-	sg_remove_request(sfp, srp);
-	return err ? : err2 ? : count;
-}
-
 static ssize_t
 sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 {
@@ -708,6 +503,18 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	return (k < 0) ? k : count;
 }
 
+static int
+sg_allow_access(struct file *filp, unsigned char *cmd)
+{
+	struct sg_fd *sfp = filp->private_data;
+
+	if (sfp->parentdp->device->type == TYPE_SCANNER)
+		return 0;
+	if (!scsi_cmd_allowed(cmd, filp->f_mode))
+		return -EPERM;
+	return 0;
+}
+
 static ssize_t
 sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 		 size_t count, int blocking, int read_only, int sg_io_owned,
@@ -833,6 +640,80 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	return 0;
 }
 
+static int
+get_sg_io_pack_id(int *pack_id, void __user *buf, size_t count)
+{
+	struct sg_header __user *old_hdr = buf;
+	int reply_len;
+
+	if (count >= SZ_SG_HEADER) {
+		/* negative reply_len means v3 format, otherwise v1/v2 */
+		if (get_user(reply_len, &old_hdr->reply_len))
+			return -EFAULT;
+
+		if (reply_len >= 0)
+			return get_user(*pack_id, &old_hdr->pack_id);
+
+		if (in_compat_syscall() &&
+		    count >= sizeof(struct compat_sg_io_hdr)) {
+			struct compat_sg_io_hdr __user *hp = buf;
+
+			return get_user(*pack_id, &hp->pack_id);
+		}
+
+		if (count >= sizeof(struct sg_io_hdr)) {
+			struct sg_io_hdr __user *hp = buf;
+
+			return get_user(*pack_id, &hp->pack_id);
+		}
+	}
+
+	/* no valid header was passed, so ignore the pack_id */
+	*pack_id = -1;
+	return 0;
+}
+
+static ssize_t
+sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
+{
+	sg_io_hdr_t *hp = &srp->header;
+	int err = 0, err2;
+	int len;
+
+	if (in_compat_syscall()) {
+		if (count < sizeof(struct compat_sg_io_hdr)) {
+			err = -EINVAL;
+			goto err_out;
+		}
+	} else if (count < SZ_SG_IO_HDR) {
+		err = -EINVAL;
+		goto err_out;
+	}
+	hp->sb_len_wr = 0;
+	if ((hp->mx_sb_len > 0) && hp->sbp) {
+		if ((CHECK_CONDITION & hp->masked_status) ||
+		    (srp->sense_b[0] & 0x70) == 0x70) {
+			int sb_len = SCSI_SENSE_BUFFERSIZE;
+			sb_len = (hp->mx_sb_len > sb_len) ? sb_len : hp->mx_sb_len;
+			len = 8 + (int) srp->sense_b[7];	/* Additional sense length field */
+			len = (len > sb_len) ? sb_len : len;
+			if (copy_to_user(hp->sbp, srp->sense_b, len)) {
+				err = -EFAULT;
+				goto err_out;
+			}
+			hp->driver_status = DRIVER_SENSE;
+			hp->sb_len_wr = len;
+		}
+	}
+	if (hp->masked_status || hp->host_status || hp->driver_status)
+		hp->info |= SG_INFO_CHECK;
+	err = put_sg_io_hdr(hp, buf);
+err_out:
+	err2 = sg_finish_rem_req(srp);
+	sg_remove_request(sfp, srp);
+	return err ? : err2 ? : count;
+}
+
 static int srp_done(Sg_fd *sfp, Sg_request *srp)
 {
 	unsigned long flags;
@@ -844,6 +725,123 @@ static int srp_done(Sg_fd *sfp, Sg_request *srp)
 	return ret;
 }
 
+static ssize_t
+sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
+{
+	Sg_device *sdp;
+	Sg_fd *sfp;
+	Sg_request *srp;
+	int req_pack_id = -1;
+	bool busy;
+	sg_io_hdr_t *hp;
+	struct sg_header *old_hdr;
+	int retval;
+
+	/*
+	 * This could cause a response to be stranded. Close the associated
+	 * file descriptor to free up any resources being held.
+	 */
+	retval = sg_check_file_access(filp, __func__);
+	if (retval)
+		return retval;
+
+	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+		return -ENXIO;
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
+				      "sg_read: count=%d\n", (int) count));
+
+	if (sfp->force_packid)
+		retval = get_sg_io_pack_id(&req_pack_id, buf, count);
+	if (retval)
+		return retval;
+
+	srp = sg_get_rq_mark(sfp, req_pack_id, &busy);
+	if (!srp) {		/* now wait on packet to arrive */
+		if (filp->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+		retval = wait_event_interruptible(sfp->read_wait,
+			((srp = sg_get_rq_mark(sfp, req_pack_id, &busy)) ||
+			(!busy && atomic_read(&sdp->detaching))));
+		if (!srp)
+			/* signal or detaching */
+			return retval ? retval : -ENODEV;
+	}
+	if (srp->header.interface_id != '\0')
+		return sg_new_read(sfp, buf, count, srp);
+
+	hp = &srp->header;
+	old_hdr = kzalloc(SZ_SG_HEADER, GFP_KERNEL);
+	if (!old_hdr)
+		return -ENOMEM;
+
+	old_hdr->reply_len = (int) hp->timeout;
+	old_hdr->pack_len = old_hdr->reply_len; /* old, strange behaviour */
+	old_hdr->pack_id = hp->pack_id;
+	old_hdr->twelve_byte =
+	    ((srp->data.cmd_opcode >= 0xc0) && (12 == hp->cmd_len)) ? 1 : 0;
+	old_hdr->target_status = hp->masked_status;
+	old_hdr->host_status = hp->host_status;
+	old_hdr->driver_status = hp->driver_status;
+	if ((CHECK_CONDITION & hp->masked_status) ||
+	    (srp->sense_b[0] & 0x70) == 0x70) {
+		old_hdr->driver_status = DRIVER_SENSE;
+		memcpy(old_hdr->sense_buffer, srp->sense_b,
+		       sizeof (old_hdr->sense_buffer));
+	}
+	switch (hp->host_status) {
+	/* This setup of 'result' is for backward compatibility and is best
+	   ignored by the user who should use target, host + driver status */
+	case DID_OK:
+	case DID_PASSTHROUGH:
+	case DID_SOFT_ERROR:
+		old_hdr->result = 0;
+		break;
+	case DID_NO_CONNECT:
+	case DID_BUS_BUSY:
+	case DID_TIME_OUT:
+		old_hdr->result = EBUSY;
+		break;
+	case DID_BAD_TARGET:
+	case DID_ABORT:
+	case DID_PARITY:
+	case DID_RESET:
+	case DID_BAD_INTR:
+		old_hdr->result = EIO;
+		break;
+	case DID_ERROR:
+		old_hdr->result = (srp->sense_b[0] == 0 &&
+				  hp->masked_status == GOOD) ? 0 : EIO;
+		break;
+	default:
+		old_hdr->result = EIO;
+		break;
+	}
+
+	/* Now copy the result back to the user buffer.  */
+	if (count >= SZ_SG_HEADER) {
+		if (copy_to_user(buf, old_hdr, SZ_SG_HEADER)) {
+			retval = -EFAULT;
+			goto free_old_hdr;
+		}
+		buf += SZ_SG_HEADER;
+		if (count > old_hdr->reply_len)
+			count = old_hdr->reply_len;
+		if (count > SZ_SG_HEADER) {
+			if (sg_read_oxfer(srp, buf, count - SZ_SG_HEADER)) {
+				retval = -EFAULT;
+				goto free_old_hdr;
+			}
+		}
+	} else
+		count = (old_hdr->result == 0) ? 0 : -EIO;
+	sg_finish_rem_req(srp);
+	sg_remove_request(sfp, srp);
+	retval = count;
+free_old_hdr:
+	kfree(old_hdr);
+	return retval;
+}
+
 static int max_sectors_bytes(struct request_queue *q)
 {
 	unsigned int max_sectors = queue_max_sectors(q);
-- 
2.37.3

