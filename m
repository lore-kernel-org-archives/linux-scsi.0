Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B9CAC3F2D7
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 03:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5921122B48
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 03:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgCBDdO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Mar 2020 22:33:14 -0500
Received: from smtp.infotech.no ([82.134.31.41]:60552 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbgCBDdN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 1 Mar 2020 22:33:13 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2964C204269;
        Mon,  2 Mar 2020 04:33:10 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ae4IZG16igcr; Mon,  2 Mar 2020 04:33:08 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 7F8CF204255;
        Mon,  2 Mar 2020 04:33:03 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v8 09/38] sg: sg_allow_if_err_recovery and renames
Date:   Sun,  1 Mar 2020 22:32:20 -0500
Message-Id: <20200302033249.4515-10-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200302033249.4515-1-dgilbert@interlog.com>
References: <20200302033249.4515-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add sg_allow_if_err_recover() to do checks common to several entry
points. Replace retval with either res or ret. Rename
sg_finish_rem_req() to sg_finish_scsi_blk_rq(). Rename
sg_new_write() to sg_submit(). Other cleanups triggered by
checkpatch.pl .

*** Reviewed-by: Hannes Reinecke <hare@suse.com>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 240 +++++++++++++++++++++++++---------------------
 1 file changed, 130 insertions(+), 110 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2cc20f77c303..246c630d3523 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -68,7 +68,7 @@ static char *sg_version_date = "20190606";
 
 /* SG_MAX_CDB_SIZE should be 260 (spc4r37 section 3.1.30) however the type
  * of sg_io_hdr::cmd_len can only represent 255. All SCSI commands greater
- * than 16 bytes are "variable length" whose length is a multiple of 4
+ * than 16 bytes are "variable length" whose length is a multiple of 4, so:
  */
 #define SG_MAX_CDB_SIZE 252
 
@@ -178,16 +178,16 @@ static void sg_rq_end_io(struct request *rq, blk_status_t status);
 /* Declarations of other static functions used before they are defined */
 static int sg_proc_init(void);
 static int sg_start_req(struct sg_request *srp, u8 *cmd);
-static int sg_finish_rem_req(struct sg_request *srp);
+static int sg_finish_scsi_blk_rq(struct sg_request *srp);
 static int sg_build_indirect(struct sg_scatter_hold *schp, struct sg_fd *sfp,
 			     int buff_size);
-static ssize_t sg_new_write(struct sg_fd *sfp, struct file *file,
-			    const char __user *buf, size_t count, int blocking,
-			    int read_only, int sg_io_owned,
-			    struct sg_request **o_srp);
+static ssize_t sg_submit(struct sg_fd *sfp, struct file *filp,
+			 const char __user *buf, size_t count, bool blocking,
+			 bool read_only, bool sg_io_owned,
+			 struct sg_request **o_srp);
 static int sg_common_write(struct sg_fd *sfp, struct sg_request *srp,
 			   u8 *cmnd, int timeout, int blocking);
-static int sg_rd_append(struct sg_request *srp, char __user *outp,
+static int sg_rd_append(struct sg_request *srp, void __user *outp,
 			int num_xfer);
 static void sg_remove_scat(struct sg_fd *sfp, struct sg_scatter_hold *schp);
 static void sg_build_reserve(struct sg_fd *sfp, int req_size);
@@ -275,37 +275,60 @@ sg_check_file_access(struct file *filp, const char *caller)
 static int
 sg_wait_open_event(struct sg_device *sdp, bool o_excl)
 {
-	int retval = 0;
+	int res = 0;
 
 	if (o_excl) {
 		while (atomic_read(&sdp->open_cnt) > 0) {
 			mutex_unlock(&sdp->open_rel_lock);
-			retval = wait_event_interruptible(sdp->open_wait,
-					(SG_IS_DETACHING(sdp) ||
-					 atomic_read(&sdp->open_cnt) == 0));
+			res = wait_event_interruptible
+					(sdp->open_wait,
+					 (SG_IS_DETACHING(sdp) ||
+					  atomic_read(&sdp->open_cnt) == 0));
 			mutex_lock(&sdp->open_rel_lock);
 
-			if (retval) /* -ERESTARTSYS */
-				return retval;
+			if (res) /* -ERESTARTSYS */
+				return res;
 			if (SG_IS_DETACHING(sdp))
 				return -ENODEV;
 		}
 	} else {
 		while (SG_HAVE_EXCLUDE(sdp)) {
 			mutex_unlock(&sdp->open_rel_lock);
-			retval = wait_event_interruptible(sdp->open_wait,
-					(SG_IS_DETACHING(sdp) ||
-					 !SG_HAVE_EXCLUDE(sdp)));
+			res = wait_event_interruptible
+					(sdp->open_wait,
+					 (SG_IS_DETACHING(sdp) ||
+					  !SG_HAVE_EXCLUDE(sdp)));
 			mutex_lock(&sdp->open_rel_lock);
 
-			if (retval) /* -ERESTARTSYS */
-				return retval;
+			if (res) /* -ERESTARTSYS */
+				return res;
 			if (SG_IS_DETACHING(sdp))
 				return -ENODEV;
 		}
 	}
 
-	return retval;
+	return res;
+}
+
+/*
+ * scsi_block_when_processing_errors() returns 0 when dev was taken offline by
+ * error recovery, 1 otherwise (i.e. okay). Even if in error recovery, let
+ * user continue if O_NONBLOCK set. Permits SCSI commands to be issued during
+ * error recovery. Tread carefully.
+ * Returns 0 for ok (i.e. allow), -EPROTO if sdp is NULL, otherwise -ENXIO .
+ */
+static inline int
+sg_allow_if_err_recovery(struct sg_device *sdp, bool non_block)
+{
+	if (!sdp)
+		return -EPROTO;
+	if (SG_IS_DETACHING(sdp))
+		return -ENODEV;
+	if (non_block)
+		return 0;
+	if (likely(scsi_block_when_processing_errors(sdp->device)))
+		return 0;
+	return -ENXIO;
 }
 
 /*
@@ -318,16 +341,17 @@ sg_wait_open_event(struct sg_device *sdp, bool o_excl)
 static int
 sg_open(struct inode *inode, struct file *filp)
 {
-	bool o_excl;
+	bool o_excl, non_block;
 	int min_dev = iminor(inode);
 	int op_flags = filp->f_flags;
+	int res;
 	struct request_queue *q;
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
-	int retval;
 
 	nonseekable_open(inode, filp);
 	o_excl = !!(op_flags & O_EXCL);
+	non_block = !!(op_flags & O_NONBLOCK);
 	if (o_excl && ((op_flags & O_ACCMODE) == O_RDONLY))
 		return -EPERM; /* Can't lock it with read only access */
 	sdp = sg_get_dev(min_dev);	/* increments sdp->d_ref */
@@ -336,20 +360,23 @@ sg_open(struct inode *inode, struct file *filp)
 
 	/* This driver's module count bumped by fops_get in <linux/fs.h> */
 	/* Prevent the device driver from vanishing while we sleep */
-	retval = scsi_device_get(sdp->device);
-	if (retval)
+	res = scsi_device_get(sdp->device);
+	if (res)
 		goto sg_put;
 
-	retval = scsi_autopm_get_device(sdp->device);
-	if (retval)
+	res = scsi_autopm_get_device(sdp->device);
+	if (res)
 		goto sdp_put;
 
+	res = sg_allow_if_err_recovery(sdp, non_block);
+	if (res)
+		goto error_out;
 	/* scsi_block_when_processing_errors() may block so bypass
 	 * check if O_NONBLOCK. Permits SCSI commands to be issued
 	 * during error recovery. Tread carefully. */
 	if (!((op_flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
-		retval = -ENXIO;
+		res = -ENXIO;
 		/* we are in error recovery for this device */
 		goto error_out;
 	}
@@ -358,18 +385,18 @@ sg_open(struct inode *inode, struct file *filp)
 	if (op_flags & O_NONBLOCK) {
 		if (o_excl) {
 			if (atomic_read(&sdp->open_cnt) > 0) {
-				retval = -EBUSY;
+				res = -EBUSY;
 				goto error_mutex_locked;
 			}
 		} else {
 			if (SG_HAVE_EXCLUDE(sdp)) {
-				retval = -EBUSY;
+				res = -EBUSY;
 				goto error_mutex_locked;
 			}
 		}
 	} else {
-		retval = sg_wait_open_event(sdp, o_excl);
-		if (retval) /* -ERESTARTSYS or -ENODEV */
+		res = sg_wait_open_event(sdp, o_excl);
+		if (res) /* -ERESTARTSYS or -ENODEV */
 			goto error_mutex_locked;
 	}
 
@@ -384,7 +411,7 @@ sg_open(struct inode *inode, struct file *filp)
 	}
 	sfp = sg_add_sfp(sdp);		/* increments sdp->d_ref */
 	if (IS_ERR(sfp)) {
-		retval = PTR_ERR(sfp);
+		res = PTR_ERR(sfp);
 		goto out_undo;
 	}
 
@@ -396,11 +423,11 @@ sg_open(struct inode *inode, struct file *filp)
 	       atomic_read(&sdp->open_cnt),
 	       ((op_flags & O_NONBLOCK) ? " O_NONBLOCK" : ""));
 
-	retval = 0;
+	res = 0;
 sg_put:
 	kref_put(&sdp->d_ref, sg_device_destroy);
 	/* if success, sdp->d_ref is incremented twice, decremented once */
-	return retval;
+	return res;
 
 out_undo:
 	if (o_excl) {		/* undo if error */
@@ -449,40 +476,34 @@ sg_release(struct inode *inode, struct file *filp)
 static ssize_t
 sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 {
-	int mxsize, cmd_size, k;
-	int input_size, blocking;
+	bool blocking = !(filp->f_flags & O_NONBLOCK);
 	u8 opcode;
+	int mxsize, cmd_size, input_size, res;
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
 	struct sg_request *srp;
 	struct sg_header old_hdr;
 	sg_io_hdr_t *hp;
 	u8 cmnd[SG_MAX_CDB_SIZE];
-	int retval;
 
-	retval = sg_check_file_access(filp, __func__);
-	if (retval)
-		return retval;
+	res = sg_check_file_access(filp, __func__);
+	if (res)
+		return res;
 
 	sfp = filp->private_data;
 	sdp = sfp->parentdp;
 	SG_LOG(3, sfp, "%s: write(3rd arg) count=%d\n", __func__, (int)count);
-	if (!sdp)
-		return -ENXIO;
-	if (SG_IS_DETACHING(sdp))
-		return -ENODEV;
-	if (!((filp->f_flags & O_NONBLOCK) ||
-	      scsi_block_when_processing_errors(sdp->device)))
-		return -ENXIO;
+	res = sg_allow_if_err_recovery(sdp, !blocking);
+	if (res)
+		return res;
 
 	if (count < SZ_SG_HEADER)
 		return -EIO;
 	if (copy_from_user(&old_hdr, buf, SZ_SG_HEADER))
 		return -EFAULT;
-	blocking = !(filp->f_flags & O_NONBLOCK);
 	if (old_hdr.reply_len < 0)
-		return sg_new_write(sfp, filp, buf, count,
-				    blocking, 0, 0, NULL);
+		return sg_submit(sfp, filp, buf, count, blocking, false, false,
+				 NULL);
 	if (count < (SZ_SG_HEADER + 6))
 		return -EIO;	/* The minimum scsi command length is 6 bytes. */
 
@@ -552,8 +573,8 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 				   input_size, (unsigned int) cmnd[0],
 				   current->comm);
 	}
-	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
-	return (k < 0) ? k : count;
+	res = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
+	return (res < 0) ? res : count;
 }
 
 static int
@@ -568,9 +589,9 @@ sg_allow_access(struct file *filp, u8 *cmd)
 }
 
 static ssize_t
-sg_new_write(struct sg_fd *sfp, struct file *file, const char __user *buf,
-	     size_t count, int blocking, int read_only, int sg_io_owned,
-	     struct sg_request **o_srp)
+sg_submit(struct sg_fd *sfp, struct file *filp, const char __user *buf,
+	  size_t count, bool blocking, bool read_only, bool sg_io_owned,
+	  struct sg_request **o_srp)
 {
 	int k;
 	struct sg_request *srp;
@@ -621,7 +642,7 @@ sg_new_write(struct sg_fd *sfp, struct file *file, const char __user *buf,
 		sg_remove_request(sfp, srp);
 		return -EFAULT;
 	}
-	if (read_only && sg_allow_access(file, cmnd)) {
+	if (read_only && sg_allow_access(filp, cmnd)) {
 		sg_remove_request(sfp, srp);
 		return -EPERM;
 	}
@@ -658,7 +679,7 @@ sg_common_write(struct sg_fd *sfp, struct sg_request *srp,
 	k = sg_start_req(srp, cmnd);
 	if (k) {
 		SG_LOG(1, sfp, "%s: start_req err=%d\n", __func__, k);
-		sg_finish_rem_req(srp);
+		sg_finish_scsi_blk_rq(srp);
 		sg_remove_request(sfp, srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
@@ -669,7 +690,7 @@ sg_common_write(struct sg_fd *sfp, struct sg_request *srp,
 			srp->rq = NULL;
 		}
 
-		sg_finish_rem_req(srp);
+		sg_finish_scsi_blk_rq(srp);
 		sg_remove_request(sfp, srp);
 		return -ENODEV;
 	}
@@ -755,7 +776,7 @@ sg_new_read(struct sg_fd *sfp, char __user *buf, size_t count,
 		hp->info |= SG_INFO_CHECK;
 	err = put_sg_io_hdr(hp, buf);
 err_out:
-	err2 = sg_finish_rem_req(srp);
+	err2 = sg_finish_scsi_blk_rq(srp);
 	sg_remove_request(sfp, srp);
 	return err ? : err2 ? : count;
 }
@@ -779,23 +800,24 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 	struct sg_fd *sfp;
 	struct sg_request *srp;
 	int req_pack_id = -1;
+	int ret = 0;
 	sg_io_hdr_t *hp;
 	struct sg_header *old_hdr = NULL;
-	int retval = 0;
 
 	/*
 	 * This could cause a response to be stranded. Close the associated
 	 * file descriptor to free up any resources being held.
 	 */
-	retval = sg_check_file_access(filp, __func__);
-	if (retval)
-		return retval;
+	ret = sg_check_file_access(filp, __func__);
+	if (ret)
+		return ret;
 
 	sfp = filp->private_data;
 	sdp = sfp->parentdp;
 	SG_LOG(3, sfp, "%s: read() count=%d\n", __func__, (int)count);
-	if (!sdp)
-		return -ENXIO;
+	ret = sg_allow_if_err_recovery(sdp, false);
+	if (ret)
+		return ret;
 
 	if (!access_ok(buf, count))
 		return -EFAULT;
@@ -804,7 +826,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 		if (!old_hdr)
 			return -ENOMEM;
 		if (copy_from_user(old_hdr, buf, SZ_SG_HEADER)) {
-			retval = -EFAULT;
+			ret = -EFAULT;
 			goto free_old_hdr;
 		}
 		if (old_hdr->reply_len < 0) {
@@ -813,15 +835,15 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 
 				new_hdr = kmalloc(SZ_SG_IO_HDR, GFP_KERNEL);
 				if (!new_hdr) {
-					retval = -ENOMEM;
+					ret = -ENOMEM;
 					goto free_old_hdr;
 				}
-				retval = copy_from_user
+				ret = copy_from_user
 				    (new_hdr, buf, SZ_SG_IO_HDR);
 				req_pack_id = new_hdr->pack_id;
 				kfree(new_hdr);
-				if (retval) {
-					retval = -EFAULT;
+				if (ret) {
+					ret = -EFAULT;
 					goto free_old_hdr;
 				}
 			}
@@ -832,28 +854,28 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 	srp = sg_get_rq_mark(sfp, req_pack_id);
 	if (!srp) {		/* now wait on packet to arrive */
 		if (SG_IS_DETACHING(sdp)) {
-			retval = -ENODEV;
+			ret = -ENODEV;
 			goto free_old_hdr;
 		}
 		if (filp->f_flags & O_NONBLOCK) {
-			retval = -EAGAIN;
+			ret = -EAGAIN;
 			goto free_old_hdr;
 		}
-		retval = wait_event_interruptible
+		ret = wait_event_interruptible
 				(sfp->read_wait,
 				 (SG_IS_DETACHING(sdp) ||
 				  (srp = sg_get_rq_mark(sfp, req_pack_id))));
 		if (SG_IS_DETACHING(sdp)) {
-			retval = -ENODEV;
+			ret = -ENODEV;
 			goto free_old_hdr;
 		}
-		if (retval) {
+		if (ret) {
 			/* -ERESTARTSYS as signal hit process */
 			goto free_old_hdr;
 		}
 	}
 	if (srp->header.interface_id != '\0') {
-		retval = sg_new_read(sfp, buf, count, srp);
+		ret = sg_new_read(sfp, buf, count, srp);
 		goto free_old_hdr;
 	}
 
@@ -861,7 +883,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 	if (!old_hdr) {
 		old_hdr = kmalloc(SZ_SG_HEADER, GFP_KERNEL);
 		if (!old_hdr) {
-			retval = -ENOMEM;
+			ret = -ENOMEM;
 			goto free_old_hdr;
 		}
 	}
@@ -912,7 +934,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 	/* Now copy the result back to the user buffer.  */
 	if (count >= SZ_SG_HEADER) {
 		if (copy_to_user(buf, old_hdr, SZ_SG_HEADER)) {
-			retval = -EFAULT;
+			ret = -EFAULT;
 			goto free_old_hdr;
 		}
 		buf += SZ_SG_HEADER;
@@ -920,19 +942,19 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 			count = old_hdr->reply_len;
 		if (count > SZ_SG_HEADER) {
 			if (sg_rd_append(srp, buf, count - SZ_SG_HEADER)) {
-				retval = -EFAULT;
+				ret = -EFAULT;
 				goto free_old_hdr;
 			}
 		}
 	} else {
 		count = (old_hdr->result == 0) ? 0 : -EIO;
 	}
-	sg_finish_rem_req(srp);
+	sg_finish_scsi_blk_rq(srp);
 	sg_remove_request(sfp, srp);
-	retval = count;
+	ret = count;
 free_old_hdr:
 	kfree(old_hdr);
-	return retval;
+	return ret;
 }
 
 static int
@@ -1020,12 +1042,11 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 
 	switch (cmd_in) {
 	case SG_IO:
-		if (SG_IS_DETACHING(sdp))
-			return -ENODEV;
-		if (!scsi_block_when_processing_errors(sdp->device))
-			return -ENXIO;
-		result = sg_new_write(sfp, filp, p, SZ_SG_IO_HDR,
-				 1, read_only, 1, &srp);
+		result = sg_allow_if_err_recovery(sdp, false);
+		if (result)
+			return result;
+		result = sg_submit(sfp, filp, p, SZ_SG_IO_HDR, true, read_only,
+				   true, &srp);
 		if (result < 0)
 			return result;
 		result = wait_event_interruptible(sfp->read_wait,
@@ -1225,8 +1246,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		break;
 	}
 
-	result = scsi_ioctl_block_when_processing_errors(sdp->device,
-			cmd_in, filp->f_flags & O_NDELAY);
+	result = sg_allow_if_err_recovery(sdp, filp->f_flags & O_NDELAY);
 	if (result)
 		return result;
 
@@ -1406,7 +1426,7 @@ sg_rq_end_io_usercontext(struct work_struct *work)
 	struct sg_request *srp = container_of(work, struct sg_request, ew.work);
 	struct sg_fd *sfp = srp->parentfp;
 
-	sg_finish_rem_req(srp);
+	sg_finish_scsi_blk_rq(srp);
 	sg_remove_request(sfp, srp);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 }
@@ -1935,7 +1955,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd)
 }
 
 static int
-sg_finish_rem_req(struct sg_request *srp)
+sg_finish_scsi_blk_rq(struct sg_request *srp)
 {
 	int ret = 0;
 
@@ -2080,7 +2100,7 @@ sg_remove_scat(struct sg_fd *sfp, struct sg_scatter_hold *schp)
  * appended to given struct sg_header object.
  */
 static int
-sg_rd_append(struct sg_request *srp, char __user *outp, int num_xfer)
+sg_rd_append(struct sg_request *srp, void __user *outp, int num_xfer)
 {
 	struct sg_scatter_hold *schp = &srp->data;
 	int k, num;
@@ -2283,7 +2303,7 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	while (!list_empty(&sfp->rq_list)) {
 		srp = list_first_entry(&sfp->rq_list, struct sg_request, entry);
-		sg_finish_rem_req(srp);
+		sg_finish_scsi_blk_rq(srp);
 		list_del(&srp->entry);
 		srp->parentfp = NULL;
 	}
@@ -2361,7 +2381,7 @@ sg_get_dev(int dev)
 #if IS_ENABLED(CONFIG_SCSI_PROC_FS)     /* long, almost to end of file */
 static int sg_proc_seq_show_int(struct seq_file *s, void *v);
 
-static int sg_proc_single_open_adio(struct inode *inode, struct file *file);
+static int sg_proc_single_open_adio(struct inode *inode, struct file *filp);
 static ssize_t sg_proc_write_adio(struct file *filp, const char __user *buffer,
 			          size_t count, loff_t *off);
 static const struct proc_ops adio_proc_ops = {
@@ -2372,7 +2392,7 @@ static const struct proc_ops adio_proc_ops = {
 	.proc_release	= single_release,
 };
 
-static int sg_proc_single_open_dressz(struct inode *inode, struct file *file);
+static int sg_proc_single_open_dressz(struct inode *inode, struct file *filp);
 static ssize_t sg_proc_write_dressz(struct file *filp, 
 		const char __user *buffer, size_t count, loff_t *off);
 static const struct proc_ops dressz_proc_ops = {
@@ -2421,13 +2441,13 @@ sg_proc_init(void)
 	if (!p)
 		return 1;
 
-	proc_create("allow_dio", S_IRUGO | S_IWUSR, p, &adio_proc_ops);
-	proc_create_seq("debug", S_IRUGO, p, &debug_seq_ops);
-	proc_create("def_reserved_size", S_IRUGO | S_IWUSR, p, &dressz_proc_ops);
-	proc_create_single("device_hdr", S_IRUGO, p, sg_proc_seq_show_devhdr);
-	proc_create_seq("devices", S_IRUGO, p, &dev_seq_ops);
-	proc_create_seq("device_strs", S_IRUGO, p, &devstrs_seq_ops);
-	proc_create_single("version", S_IRUGO, p, sg_proc_seq_show_version);
+	proc_create("allow_dio", 0644, p, &adio_proc_ops);
+	proc_create_seq("debug", 0444, p, &debug_seq_ops);
+	proc_create("def_reserved_size", 0644, p, &dressz_proc_ops);
+	proc_create_single("device_hdr", 0444, p, sg_proc_seq_show_devhdr);
+	proc_create_seq("devices", 0444, p, &dev_seq_ops);
+	proc_create_seq("device_strs", 0444, p, &devstrs_seq_ops);
+	proc_create_single("version", 0444, p, sg_proc_seq_show_version);
 	return 0;
 }
 
@@ -2451,9 +2471,9 @@ sg_proc_seq_show_int(struct seq_file *s, void *v)
 }
 
 static int
-sg_proc_single_open_adio(struct inode *inode, struct file *file)
+sg_proc_single_open_adio(struct inode *inode, struct file *filp)
 {
-	return single_open(file, sg_proc_seq_show_int, &sg_allow_dio);
+	return single_open(filp, sg_proc_seq_show_int, &sg_allow_dio);
 }
 
 static ssize_t 
@@ -2473,9 +2493,9 @@ sg_proc_write_adio(struct file *filp, const char __user *buffer,
 }
 
 static int
-sg_proc_single_open_dressz(struct inode *inode, struct file *file)
+sg_proc_single_open_dressz(struct inode *inode, struct file *filp)
 {
-	return single_open(file, sg_proc_seq_show_int, &sg_big_buff);
+	return single_open(filp, sg_proc_seq_show_int, &sg_big_buff);
 }
 
 static ssize_t 
@@ -2537,7 +2557,7 @@ dev_seq_start(struct seq_file *s, loff_t *pos)
 static void *
 dev_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct sg_proc_deviter * it = s->private;
+	struct sg_proc_deviter *it = s->private;
 
 	*pos = ++it->index;
 	return (it->index < it->max) ? it : NULL;
@@ -2552,7 +2572,7 @@ dev_seq_stop(struct seq_file *s, void *v)
 static int
 sg_proc_seq_show_dev(struct seq_file *s, void *v)
 {
-	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
+	struct sg_proc_deviter *it = (struct sg_proc_deviter *)v;
 	struct sg_device *sdp;
 	struct scsi_device *scsidp;
 	unsigned long iflags;
@@ -2578,7 +2598,7 @@ sg_proc_seq_show_dev(struct seq_file *s, void *v)
 static int
 sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 {
-	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
+	struct sg_proc_deviter *it = (struct sg_proc_deviter *)v;
 	struct sg_device *sdp;
 	struct scsi_device *scsidp;
 	unsigned long iflags;
@@ -2666,7 +2686,7 @@ sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 static int
 sg_proc_seq_show_debug(struct seq_file *s, void *v)
 {
-	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
+	struct sg_proc_deviter *it = (struct sg_proc_deviter *)v;
 	struct sg_device *sdp;
 	unsigned long iflags;
 
-- 
2.25.1

