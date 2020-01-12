Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D460C33CA9
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 23:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1C2C21744
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 23:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387474AbgALX6D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 18:58:03 -0500
Received: from smtp.infotech.no ([82.134.31.41]:51915 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbgALX6D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Jan 2020 18:58:03 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B016820429C;
        Mon, 13 Jan 2020 00:57:59 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rNj-bDhF7N83; Mon, 13 Jan 2020 00:57:56 +0100 (CET)
Received: from xtwo70.bingwo.ca (unknown [213.52.86.138])
        by smtp.infotech.no (Postfix) with ESMTPA id 75C55204248;
        Mon, 13 Jan 2020 00:57:56 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH v6 01/37] sg: move functions around
Date:   Mon, 13 Jan 2020 00:57:19 +0100
Message-Id: <20200112235755.14197-2-dgilbert@interlog.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200112235755.14197-1-dgilbert@interlog.com>
References: <20200112235755.14197-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
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

Helper functions are often placed above their caller to reduce
the number of forward function declarations needed.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 506 ++++++++++++++++++++++++----------------------
 1 file changed, 263 insertions(+), 243 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 160748ad9c0f..d954ff639c9e 100644
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
@@ -47,6 +48,7 @@ static int sg_version_num = 30536;	/* 2 digits for each component */
 #include <linux/ratelimit.h>
 #include <linux/uio.h>
 #include <linux/cred.h> /* for sg_check_file_access() */
+#include <linux/proc_fs.h>
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -57,12 +59,6 @@ static int sg_version_num = 30536;	/* 2 digits for each component */
 
 #include "scsi_logging.h"
 
-#ifdef CONFIG_SCSI_PROC_FS
-#include <linux/proc_fs.h>
-static char *sg_version_date = "20140603";
-
-static int sg_proc_init(void);
-#endif
 
 #define SG_ALLOW_DIO_DEF 0
 
@@ -173,11 +169,11 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 
 /* tasklet or soft irq callback */
 static void sg_rq_end_io(struct request *rq, blk_status_t status);
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
@@ -190,7 +186,6 @@ static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
 static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
 static Sg_fd *sg_add_sfp(Sg_device * sdp);
 static void sg_remove_sfp(struct kref *);
-static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
 static Sg_device *sg_get_dev(int dev);
@@ -232,16 +227,6 @@ static int sg_check_file_access(struct file *filp, const char *caller)
 	return 0;
 }
 
-static int sg_allow_access(struct file *filp, unsigned char *cmd)
-{
-	struct sg_fd *sfp = filp->private_data;
-
-	if (sfp->parentdp->device->type == TYPE_SCANNER)
-		return 0;
-
-	return blk_verify_command(cmd, filp->f_mode);
-}
-
 static int
 open_wait(Sg_device *sdp, int flags)
 {
@@ -405,204 +390,12 @@ sg_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static ssize_t
-sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
-{
-	Sg_device *sdp;
-	Sg_fd *sfp;
-	Sg_request *srp;
-	int req_pack_id = -1;
-	sg_io_hdr_t *hp;
-	struct sg_header *old_hdr = NULL;
-	int retval = 0;
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
-	if (sfp->force_packid && (count >= SZ_SG_HEADER)) {
-		old_hdr = memdup_user(buf, SZ_SG_HEADER);
-		if (IS_ERR(old_hdr))
-			return PTR_ERR(old_hdr);
-		if (old_hdr->reply_len < 0) {
-			if (count >= SZ_SG_IO_HDR) {
-				/*
-				 * This is stupid.
-				 *
-				 * We're copying the whole sg_io_hdr_t from user
-				 * space just to get the 'pack_id' field. But the
-				 * field is at different offsets for the compat
-				 * case, so we'll use "get_sg_io_hdr()" to copy
-				 * the whole thing and convert it.
-				 *
-				 * We could do something like just calculating the
-				 * offset based of 'in_compat_syscall()', but the
-				 * 'compat_sg_io_hdr' definition is in the wrong
-				 * place for that.
-				 */
-				sg_io_hdr_t *new_hdr;
-				new_hdr = kmalloc(SZ_SG_IO_HDR, GFP_KERNEL);
-				if (!new_hdr) {
-					retval = -ENOMEM;
-					goto free_old_hdr;
-				}
-				retval = get_sg_io_hdr(new_hdr, buf);
-				req_pack_id = new_hdr->pack_id;
-				kfree(new_hdr);
-				if (retval) {
-					retval = -EFAULT;
-					goto free_old_hdr;
-				}
-			}
-		} else
-			req_pack_id = old_hdr->pack_id;
-	}
-	srp = sg_get_rq_mark(sfp, req_pack_id);
-	if (!srp) {		/* now wait on packet to arrive */
-		if (atomic_read(&sdp->detaching)) {
-			retval = -ENODEV;
-			goto free_old_hdr;
-		}
-		if (filp->f_flags & O_NONBLOCK) {
-			retval = -EAGAIN;
-			goto free_old_hdr;
-		}
-		retval = wait_event_interruptible(sfp->read_wait,
-			(atomic_read(&sdp->detaching) ||
-			(srp = sg_get_rq_mark(sfp, req_pack_id))));
-		if (atomic_read(&sdp->detaching)) {
-			retval = -ENODEV;
-			goto free_old_hdr;
-		}
-		if (retval) {
-			/* -ERESTARTSYS as signal hit process */
-			goto free_old_hdr;
-		}
-	}
-	if (srp->header.interface_id != '\0') {
-		retval = sg_new_read(sfp, buf, count, srp);
-		goto free_old_hdr;
-	}
-
-	hp = &srp->header;
-	if (old_hdr == NULL) {
-		old_hdr = kmalloc(SZ_SG_HEADER, GFP_KERNEL);
-		if (! old_hdr) {
-			retval = -ENOMEM;
-			goto free_old_hdr;
-		}
-	}
-	memset(old_hdr, 0, SZ_SG_HEADER);
-	old_hdr->reply_len = (int) hp->timeout;
-	old_hdr->pack_len = old_hdr->reply_len; /* old, strange behaviour */
-	old_hdr->pack_id = hp->pack_id;
-	old_hdr->twelve_byte =
-	    ((srp->data.cmd_opcode >= 0xc0) && (12 == hp->cmd_len)) ? 1 : 0;
-	old_hdr->target_status = hp->masked_status;
-	old_hdr->host_status = hp->host_status;
-	old_hdr->driver_status = hp->driver_status;
-	if ((CHECK_CONDITION & hp->masked_status) ||
-	    (DRIVER_SENSE & hp->driver_status))
-		memcpy(old_hdr->sense_buffer, srp->sense_b,
-		       sizeof (old_hdr->sense_buffer));
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
-	if (count < SZ_SG_IO_HDR) {
-		err = -EINVAL;
-		goto err_out;
-	}
-	hp->sb_len_wr = 0;
-	if ((hp->mx_sb_len > 0) && hp->sbp) {
-		if ((CHECK_CONDITION & hp->masked_status) ||
-		    (DRIVER_SENSE & hp->driver_status)) {
-			int sb_len = SCSI_SENSE_BUFFERSIZE;
-			sb_len = (hp->mx_sb_len > sb_len) ? sb_len : hp->mx_sb_len;
-			len = 8 + (int) srp->sense_b[7];	/* Additional sense length field */
-			len = (len > sb_len) ? sb_len : len;
-			if (copy_to_user(hp->sbp, srp->sense_b, len)) {
-				err = -EFAULT;
-				goto err_out;
-			}
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
+/*
+ * write(2) related functions follow. They are shown before read(2) related
+ * functions. That is because SCSI commands/requests are first "written" to
+ * the SCSI device by using write(2), ioctl(SG_IOSUBMIT) or the first half
+ * of the synchronous ioctl(SG_IO) system call.
+ */
 static ssize_t
 sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 {
@@ -714,6 +507,16 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	return (k < 0) ? k : count;
 }
 
+static int sg_allow_access(struct file *filp, unsigned char *cmd)
+{
+	struct sg_fd *sfp = filp->private_data;
+
+	if (sfp->parentdp->device->type == TYPE_SCANNER)
+		return 0;
+
+	return blk_verify_command(cmd, filp->f_mode);
+}
+
 static ssize_t
 sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 		 size_t count, int blocking, int read_only, int sg_io_owned,
@@ -838,6 +641,74 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	return 0;
 }
 
+
+/*
+ * read(2) related functions follow. They are shown after write(2) related
+ * functions. Apart from read(2) itself, ioctl(SG_IORECEIVE) and the second
+ * half of the ioctl(SG_IO) share code with read(2).
+ */
+
+static Sg_request *
+sg_get_rq_mark(Sg_fd *sfp, int pack_id)
+{
+	Sg_request *resp;
+	unsigned long iflags;
+
+	write_lock_irqsave(&sfp->rq_list_lock, iflags);
+	list_for_each_entry(resp, &sfp->rq_list, entry) {
+		/* look for requests that are ready + not SG_IO owned */
+		if ((resp->done == 1) && (!resp->sg_io_owned) &&
+		    ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
+			resp->done = 2;	/* guard against other readers */
+			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+			return resp;
+		}
+	}
+	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	return NULL;
+}
+
+static ssize_t
+sg_new_read(Sg_fd *sfp, char __user *buf, size_t count, Sg_request *srp)
+{
+	sg_io_hdr_t *hp = &srp->header;
+	int err = 0, err2;
+	int len;
+
+	if (count < SZ_SG_IO_HDR) {
+		err = -EINVAL;
+		goto err_out;
+	}
+	hp->sb_len_wr = 0;
+	if ((hp->mx_sb_len > 0) && hp->sbp) {
+		if ((CHECK_CONDITION & hp->masked_status) ||
+		    (DRIVER_SENSE & hp->driver_status)) {
+			int sb_len = SCSI_SENSE_BUFFERSIZE;
+
+			sb_len = (hp->mx_sb_len > sb_len) ? sb_len :
+							    hp->mx_sb_len;
+			/* Additional sense length field */
+			len = 8 + (int) srp->sense_b[7];
+			len = (len > sb_len) ? sb_len : len;
+			if (copy_to_user(hp->sbp, srp->sense_b, len)) {
+				err = -EFAULT;
+				goto err_out;
+			}
+			hp->sb_len_wr = len;
+		}
+	}
+	if (hp->masked_status || hp->host_status || hp->driver_status)
+		hp->info |= SG_INFO_CHECK;
+	if (copy_to_user(buf, hp, SZ_SG_IO_HDR)) {
+		err = -EFAULT;
+		goto err_out;
+	}
+err_out:
+	err2 = sg_finish_rem_req(srp);
+	sg_remove_request(sfp, srp);
+	return err ? : err2 ? : count;
+}
+
 static int srp_done(Sg_fd *sfp, Sg_request *srp)
 {
 	unsigned long flags;
@@ -849,6 +720,168 @@ static int srp_done(Sg_fd *sfp, Sg_request *srp)
 	return ret;
 }
 
+static ssize_t
+sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
+{
+	Sg_device *sdp;
+	Sg_fd *sfp;
+	Sg_request *srp;
+	int req_pack_id = -1;
+	sg_io_hdr_t *hp;
+	struct sg_header *old_hdr = NULL;
+	int retval = 0;
+
+	/*
+	 * This could cause a response to be stranded. Close the associated
+	 * file descriptor to free up any resources being held.
+	 */
+	retval = sg_check_file_access(filp, __func__);
+	if (retval)
+		return retval;
+
+	sfp = filp->private_data;
+	sdp = sfp->parentdp;
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
+				      "%s: count=%d\n", __func__,
+				      (int) count));
+	if (!sdp)
+		return -ENXIO;
+
+	if (!access_ok(buf, count))
+		return -EFAULT;
+	if (sfp->force_packid && (count >= SZ_SG_HEADER)) {
+		old_hdr = kmalloc(SZ_SG_HEADER, GFP_KERNEL);
+		if (!old_hdr)
+			return -ENOMEM;
+		if (__copy_from_user(old_hdr, buf, SZ_SG_HEADER)) {
+			retval = -EFAULT;
+			goto free_old_hdr;
+		}
+		if (old_hdr->reply_len < 0) {
+			if (count >= SZ_SG_IO_HDR) {
+				sg_io_hdr_t *new_hdr;
+
+				new_hdr = kmalloc(SZ_SG_IO_HDR, GFP_KERNEL);
+				if (!new_hdr) {
+					retval = -ENOMEM;
+					goto free_old_hdr;
+				}
+				retval = __copy_from_user
+				    (new_hdr, buf, SZ_SG_IO_HDR);
+				req_pack_id = new_hdr->pack_id;
+				kfree(new_hdr);
+				if (retval) {
+					retval = -EFAULT;
+					goto free_old_hdr;
+				}
+			}
+		} else
+			req_pack_id = old_hdr->pack_id;
+	}
+	srp = sg_get_rq_mark(sfp, req_pack_id);
+	if (!srp) {		/* now wait on packet to arrive */
+		if (atomic_read(&sdp->detaching)) {
+			retval = -ENODEV;
+			goto free_old_hdr;
+		}
+		if (filp->f_flags & O_NONBLOCK) {
+			retval = -EAGAIN;
+			goto free_old_hdr;
+		}
+		retval = wait_event_interruptible(sfp->read_wait,
+			(atomic_read(&sdp->detaching) ||
+			(srp = sg_get_rq_mark(sfp, req_pack_id))));
+		if (atomic_read(&sdp->detaching)) {
+			retval = -ENODEV;
+			goto free_old_hdr;
+		}
+		if (retval) {
+			/* -ERESTARTSYS as signal hit process */
+			goto free_old_hdr;
+		}
+	}
+	if (srp->header.interface_id != '\0') {
+		retval = sg_new_read(sfp, buf, count, srp);
+		goto free_old_hdr;
+	}
+
+	hp = &srp->header;
+	if (old_hdr == NULL) {
+		old_hdr = kmalloc(SZ_SG_HEADER, GFP_KERNEL);
+		if (!old_hdr) {
+			retval = -ENOMEM;
+			goto free_old_hdr;
+		}
+	}
+	memset(old_hdr, 0, SZ_SG_HEADER);
+	old_hdr->reply_len = (int) hp->timeout;
+	old_hdr->pack_len = old_hdr->reply_len; /* old, strange behaviour */
+	old_hdr->pack_id = hp->pack_id;
+	old_hdr->twelve_byte =
+	    ((srp->data.cmd_opcode >= 0xc0) && (hp->cmd_len == 12)) ? 1 : 0;
+	old_hdr->target_status = hp->masked_status;
+	old_hdr->host_status = hp->host_status;
+	old_hdr->driver_status = hp->driver_status;
+	if ((hp->masked_status & CHECK_CONDITION) ||
+	    (hp->driver_status & DRIVER_SENSE))
+		memcpy(old_hdr->sense_buffer, srp->sense_b,
+		       sizeof(old_hdr->sense_buffer));
+	switch (hp->host_status) {
+	/*
+	 * This setup of 'result' is for backward compatibility and is best
+	 * ignored by the user who should use target, host + driver status
+	 */
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
+		if (__copy_to_user(buf, old_hdr, SZ_SG_HEADER)) {
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
@@ -1686,9 +1719,7 @@ init_sg(void)
 	sg_sysfs_valid = 1;
 	rc = scsi_register_interface(&sg_interface);
 	if (0 == rc) {
-#ifdef CONFIG_SCSI_PROC_FS
 		sg_proc_init();
-#endif				/* CONFIG_SCSI_PROC_FS */
 		return 0;
 	}
 	class_destroy(sg_sysfs_class);
@@ -1697,6 +1728,14 @@ init_sg(void)
 	return rc;
 }
 
+#ifndef CONFIG_SCSI_PROC_FS
+static int
+sg_proc_init(void)
+{
+	return 0;
+}
+#endif
+
 static void __exit
 exit_sg(void)
 {
@@ -2070,9 +2109,10 @@ sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
 			rem -= num;
 	}
 
-	if (k >= rsv_schp->k_use_sg)
+	if (k >= rsv_schp->k_use_sg) {
 		SCSI_LOG_TIMEOUT(1, sg_printk(KERN_INFO, sfp->parentdp,
 				 "sg_link_reserve: BAD size\n"));
+	}
 }
 
 static void
@@ -2093,26 +2133,6 @@ sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
 	sfp->res_in_use = 0;
 }
 
-static Sg_request *
-sg_get_rq_mark(Sg_fd * sfp, int pack_id)
-{
-	Sg_request *resp;
-	unsigned long iflags;
-
-	write_lock_irqsave(&sfp->rq_list_lock, iflags);
-	list_for_each_entry(resp, &sfp->rq_list, entry) {
-		/* look for requests that are ready + not SG_IO owned */
-		if ((1 == resp->done) && (!resp->sg_io_owned) &&
-		    ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
-			resp->done = 2;	/* guard against other readers */
-			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-			return resp;
-		}
-	}
-	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return NULL;
-}
-
 /* always adds to end of list */
 static Sg_request *
 sg_add_request(Sg_fd * sfp)
-- 
2.24.1

