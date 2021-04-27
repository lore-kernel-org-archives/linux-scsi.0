Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780D6C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B13D613F1
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239394AbhD0WAo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:44 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39159 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239512AbhD0WA0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 407BE2042A2;
        Tue, 27 Apr 2021 23:59:40 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cmqabYYFLwaH; Tue, 27 Apr 2021 23:59:32 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id DCA4820429C;
        Tue, 27 Apr 2021 23:59:30 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 75/83] sg: expand source line length to 100 characters
Date:   Tue, 27 Apr 2021 17:57:25 -0400
Message-Id: <20210427215733.417746-77-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are many examples of function invocation, debug strings and
function header comments that are split due to the previous limit
of 80 characters per source line in most cases. Over 350 lines are
saved by squeezing more onto each line.

Inline the simple sg_find_srp_idx() function as it is only called
twice.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 1395 ++++++++++++++++++---------------------------
 1 file changed, 563 insertions(+), 832 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index d6e18cb4df11..a159af1e3ee6 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -33,7 +33,7 @@ static char *sg_version_date = "20210421";
 #include <linux/moduleparam.h>
 #include <linux/cdev.h>
 #include <linux/idr.h>
-#include <linux/file.h>		/* for fget() and fput() */
+#include <linux/file.h>			/* for fget() and fput() */
 #include <linux/seq_file.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
@@ -78,9 +78,9 @@ static char *sg_version_date = "20210421";
 #endif
 
 /*
- * SG_MAX_CDB_SIZE should be 260 (spc4r37 section 3.1.30) however the type
- * of sg_io_hdr::cmd_len can only represent 255. All SCSI commands greater
- * than 16 bytes are "variable length" whose length is a multiple of 4, so:
+ * SG_MAX_CDB_SIZE should be 260 (spc4r37 section 3.1.30) however the type of sg_io_hdr::cmd_len
+ * can only represent 255. All SCSI commands greater than 16 bytes are "variable length" whose
+ * length is a multiple of 4, so:
  */
 #define SG_MAX_CDB_SIZE 252
 
@@ -176,9 +176,9 @@ enum sg_shr_var {
 
 int sg_big_buff = SG_DEF_RESERVED_SIZE;
 /*
- * This variable is accessible via /proc/scsi/sg/def_reserved_size . Each
- * time sg_open() is called a sg_request of this size (or less if there is
- * not enough memory) will be reserved for use by this file descriptor.
+ * This variable is accessible via /proc/scsi/sg/def_reserved_size . Each time sg_open() is called
+ * a sg_request of this size (or less if there is not enough memory) will be reserved for use by
+ * this file descriptor.
  */
 static int def_reserved_size = -1;	/* picks up init parameter */
 static int sg_allow_dio = SG_ALLOW_DIO_DEF;	/* ignored by code */
@@ -367,32 +367,26 @@ static void sg_rq_end_io(struct request *rqq, blk_status_t status);
 static int sg_proc_init(void);
 static void sg_dfs_init(void);
 static void sg_dfs_exit(void);
-static int sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp,
-			int dxfer_dir);
+static int sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir);
 static void sg_finish_scsi_blk_rq(struct sg_request *srp);
 static int sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen);
-static int sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp,
-			 void __user *p);
+static int sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, void __user *p);
 static int sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 			struct sg_request **o_srp);
 static struct sg_request *sg_common_write(struct sg_comm_wr_t *cwrp);
-static int sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp,
-			 void __user *p, struct sg_io_v4 *h4p);
-static int sg_read_append(struct sg_request *srp, void __user *outp,
-			  int num_xfer);
+static int sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
+			 struct sg_io_v4 *h4p);
+static int sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer);
 static void sg_remove_srp(struct sg_request *srp);
 static struct sg_fd *sg_add_sfp(struct sg_device *sdp, struct file *filp);
 static void sg_remove_sfp(struct kref *);
 static void sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side);
-static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int id,
-					    bool is_tag);
-static struct sg_request *sg_setup_req(struct sg_comm_wr_t *cwrp,
-				       enum sg_shr_var sh_var);
+static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag);
+static struct sg_request *sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var);
 static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int min_dev);
 static void sg_device_destroy(struct kref *kref);
-static struct sg_request *sg_mk_srp_sgat(struct sg_fd *sfp, bool first,
-					 int db_len);
+static struct sg_request *sg_mk_srp_sgat(struct sg_fd *sfp, bool first, int db_len);
 static int sg_abort_req(struct sg_fd *sfp, struct sg_request *srp);
 static int sg_rq_chg_state(struct sg_request *srp, enum sg_rq_state old_st,
 			   enum sg_rq_state new_st);
@@ -408,8 +402,8 @@ static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
 static const char *sg_shr_str(enum sg_shr_var sh_var, bool long_str);
 #endif
 #if IS_ENABLED(SG_PROC_OR_DEBUG_FS)
-static int sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len,
-			      int *fd_counterp, bool reduced);
+static int sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len, int *fd_counterp,
+			      bool reduced);
 static void sg_take_snap(struct sg_fd *sfp, bool clear_first);
 #endif
 
@@ -430,11 +424,10 @@ static void sg_take_snap(struct sg_fd *sfp, bool clear_first);
 #define SG_IS_V4I(srp) test_bit(SG_FRQ_IS_V4I, (srp)->frq_bm)
 
 /*
- * Kernel needs to be built with CONFIG_SCSI_LOGGING to see log messages.
- * 'depth' is a number between 1 (most severe) and 7 (most noisy, most
- * information). All messages are logged as informational (KERN_INFO). In
- * the unexpected situation where sfp or sdp is NULL the macro reverts to
- * a pr_info and ignores SCSI_LOG_TIMEOUT and always prints to the log.
+ * Kernel needs to be built with CONFIG_SCSI_LOGGING to see log messages. 'depth' is a number
+ * between 1 (most severe) and 7 (most noisy, most information). All messages are logged as
+ * informational (KERN_INFO). In the unexpected situation where sfp or sdp is NULL the macro
+ * reverts to a pr_info and ignores SCSI_LOG_TIMEOUT and always prints to the log.
  * Example: this invocation: 'scsi_logging_level -s -T 3' will print
  * depth (aka level) 1 and 2 SG_LOG() messages.
  */
@@ -446,21 +439,19 @@ static void sg_take_snap(struct sg_fd *sfp, bool clear_first);
 #define SG_LOG_BUFF_SZ 48
 #define SG_LOG_ACTIVE 1
 
-#define SG_LOG(depth, sfp, fmt, a...)					\
-	do {								\
-		char _b[SG_LOG_BUFF_SZ];				\
-		int _tid = (current ? current->pid : -1);		\
-		struct sg_fd *_fp = sfp;				\
-		struct sg_device *_sdp = _fp ? _fp->parentdp : NULL;	\
-									\
-		if (likely(_sdp && _sdp->disk)) {			\
-			snprintf(_b, sizeof(_b), "sg%u: tid=%d",	\
-				 _sdp->index, _tid);			\
-			SCSI_LOG_TIMEOUT(depth,				\
-					 sdev_prefix_printk(KERN_INFO,	\
-					 _sdp->device, _b, fmt, ##a));	\
-		} else							\
-			pr_info("sg: sdp or sfp NULL, " fmt, ##a);	\
+#define SG_LOG(depth, sfp, fmt, a...)							\
+	do {										\
+		char _b[SG_LOG_BUFF_SZ];						\
+		int _tid = (current ? current->pid : -1);				\
+		struct sg_fd *_fp = sfp;						\
+		struct sg_device *_sdp = _fp ? _fp->parentdp : NULL;			\
+											\
+		if (likely(_sdp && _sdp->disk)) {					\
+			snprintf(_b, sizeof(_b), "sg%u: tid=%d", _sdp->index, _tid);	\
+			SCSI_LOG_TIMEOUT(depth,	sdev_prefix_printk(KERN_INFO,		\
+					 _sdp->device, _b, fmt, ##a));			\
+		} else									\
+			pr_info("sg: sdp or sfp NULL, " fmt, ##a);			\
 	} while (0)
 #else
 #define SG_LOG(depth, sfp, fmt, a...) do { } while (0)
@@ -503,7 +494,7 @@ static void sg_take_snap(struct sg_fd *sfp, bool clear_first);
  *		violation, opened read-only but SCSI command not listed read-only
  * EPROTO	logic error (in driver); like "shouldn't get here"
  * EPROTOTYPE	atomic state change failed unexpectedly
- * ERANGE	multiple requests: usually bad flag values
+ * ERANGE	multiple requests: usually a bad flag or combination of flag values
  * ERESTARTSYS	should not be seen in user space, associated with an
  *		interruptible wait; will restart system call or give EINTR
  * EWOULDBLOCK	[aka EAGAIN]; additionally if the 'more async' flag is set
@@ -512,15 +503,13 @@ static void sg_take_snap(struct sg_fd *sfp, bool clear_first);
 
 /*
  * The SCSI interfaces that use read() and write() as an asynchronous variant of
- * ioctl(..., SG_IO, ...) are fundamentally unsafe, since there are lots of ways
- * to trigger read() and write() calls from various contexts with elevated
- * privileges. This can lead to kernel memory corruption (e.g. if these
- * interfaces are called through splice()) and privilege escalation inside
- * userspace (e.g. if a process with access to such a device passes a file
+ * ioctl(..., SG_IO, ...) are fundamentally unsafe, since there are lots of ways to trigger read()
+ * and write() calls from various contexts with elevated privileges. This can lead to kernel
+ * memory corruption (e.g. if these interfaces are called through splice()) and privilege
+ * escalation inside userspace (e.g. if a process with access to such a device passes a file
  * descriptor to a SUID binary as stdin/stdout/stderr).
  *
- * This function provides protection for the legacy API by restricting the
- * calling context.
+ * This function provides protection for the legacy API by restricting the calling context.
  */
 static int
 sg_check_file_access(struct file *filp, const char *caller)
@@ -579,11 +568,9 @@ sg_wait_open_event(struct sg_device *sdp, bool o_excl)
 }
 
 /*
- * scsi_block_when_processing_errors() returns 0 when dev was taken offline by
- * error recovery, 1 otherwise (i.e. okay). Even if in error recovery, let
- * user continue if O_NONBLOCK set. Permits SCSI commands to be issued during
- * error recovery. Tread carefully.
- * Returns 0 for ok (i.e. allow), -EPROTO if sdp is NULL, otherwise -ENXIO .
+ * scsi_block_when_processing_errors() returns 0 when dev was taken offline by error recovery, 1
+ * otherwise (i.e. okay). Even if in error recovery, let user continue if O_NONBLOCK set. Permits
+ * SCSI commands to be issued during error recovery. Tread carefully.
  */
 static inline int
 sg_allow_if_err_recovery(struct sg_device *sdp, bool non_block)
@@ -600,11 +587,10 @@ sg_allow_if_err_recovery(struct sg_device *sdp, bool non_block)
 }
 
 /*
- * Corresponds to the open() system call on sg devices. Implements O_EXCL on
- * a per device basis using 'open_cnt'. If O_EXCL and O_NONBLOCK and there is
- * already a sg handle open on this device then it fails with an errno of
- * EBUSY. Without the O_NONBLOCK flag then this thread enters an interruptible
- * wait until the other handle(s) are closed.
+ * Corresponds to the open() system call on sg devices. Implements O_EXCL on a per device basis
+ * using 'open_cnt'. If O_EXCL and O_NONBLOCK and there is already a sg handle open on this device
+ * then it fails with an errno of EBUSY. Without the O_NONBLOCK flag then this thread enters an
+ * interruptible wait until the other handle(s) are closed.
  */
 static int
 sg_open(struct inode *inode, struct file *filp)
@@ -671,9 +657,8 @@ sg_open(struct inode *inode, struct file *filp)
 	filp->private_data = sfp;
 	sfp->tid = (current ? current->pid : -1);
 	mutex_unlock(&sdp->open_rel_lock);
-	SG_LOG(3, sfp, "%s: o_count after=%d on minor=%d, op_flags=0x%x%s\n",
-	       __func__, o_count, min_dev, op_flags,
-	       (non_block ? " O_NONBLOCK" : ""));
+	SG_LOG(3, sfp, "%s: o_count after=%d on minor=%d, op_flags=0x%x%s\n", __func__, o_count,
+	       min_dev, op_flags, (non_block ? " O_NONBLOCK" : ""));
 
 	res = 0;
 sg_put:
@@ -697,8 +682,7 @@ sg_open(struct inode *inode, struct file *filp)
 static inline bool
 sg_fd_is_shared(struct sg_fd *sfp)
 {
-	return !xa_get_mark(&sfp->parentdp->sfp_arr, sfp->idx,
-			    SG_XA_FD_UNSHARED);
+	return !xa_get_mark(&sfp->parentdp->sfp_arr, sfp->idx, SG_XA_FD_UNSHARED);
 }
 
 static inline struct sg_fd *
@@ -718,7 +702,7 @@ sg_fd_share_ptr(struct sg_fd *sfp)
 
 /*
  * Picks up driver or host (transport) errors and actual SCSI status problems.
- * Specifically SAM_STAT_CONDITION_MET is _not_ an error.
+ * Specifically SCSI status: SAM_STAT_CONDITION_MET is _not_ an error.
  */
 static inline bool
 sg_result_is_good(int rq_result)
@@ -730,11 +714,10 @@ sg_result_is_good(int rq_result)
 }
 
 /*
- * Release resources associated with a prior, successful sg_open(). It can be
- * seen as the (final) close() call on a sg device file descriptor in the user
- * space. The real work releasing all resources associated with this file
- * descriptor is done by sg_uc_remove_sfp() which is scheduled by
- * sg_remove_sfp().
+ * Release resources associated with a prior, successful sg_open(). It can be seen as the (final)
+ * close() call on a sg device file descriptor in the user space. The real work releasing all
+ * resources associated with this file descriptor is done by sg_uc_remove_sfp() which is
+ * scheduled by sg_remove_sfp().
  */
 static int
 sg_release(struct inode *inode, struct file *filp)
@@ -757,17 +740,14 @@ sg_release(struct inode *inode, struct file *filp)
 	o_count = atomic_read(&sdp->open_cnt);
 	SG_LOG(3, sfp, "%s: open count before=%d\n", __func__, o_count);
 	if (unlikely(test_and_set_bit(SG_FFD_RELEASE, sfp->ffd_bm)))
-		SG_LOG(1, sfp, "%s: second release on this fd ? ?\n",
-		       __func__);
+		SG_LOG(1, sfp, "%s: second release on this fd ? ?\n", __func__);
 	scsi_autopm_put_device(sdp->device);
-	if (likely(!xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_FREE)) &&
-	    sg_fd_is_shared(sfp))
-		sg_remove_sfp_share(sfp, xa_get_mark(&sdp->sfp_arr, sfp->idx,
-						     SG_XA_FD_RS_SHARE));
+	if (likely(!xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_FREE)) && sg_fd_is_shared(sfp))
+		sg_remove_sfp_share(sfp, xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_RS_SHARE));
 	kref_put(&sfp->f_ref, sg_remove_sfp);	/* init=1: sg_add_sfp() */
 	/*
-	 * Possibly many open()s waiting on exclude clearing, start many;
-	 * only open(O_EXCL)'s wait when open_cnt<2 and only start one.
+	 * Possibly many open()s waiting on exclude clearing, start many; only open(O_EXCL)'s wait
+	 * when open_cnt<2 and only start one.
 	 */
 	if (test_and_clear_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm))
 		wake_up_interruptible_all(&sdp->open_wait);
@@ -786,12 +766,11 @@ sg_comm_wr_init(struct sg_comm_wr_t *cwrp)
 }
 
 /*
- * ***********************************************************************
- * write(2) related functions follow. They are shown before read(2) related
- * functions. That is because SCSI commands/requests are first "written" to
- * the SCSI device by using write(2), ioctl(SG_IOSUBMIT) or the first half
- * of the synchronous ioctl(SG_IO) system call.
- * ***********************************************************************
+ * **********************************************************************************************
+ * write(2) related functions follow. They are shown before read(2) related functions. That is
+ * because SCSI commands/requests are first "written" to the SCSI device by using write(2),
+ * ioctl(SG_IOSUBMIT) or the first half of the synchronous ioctl(SG_IO) system call.
+ * **********************************************************************************************
  */
 
 /* This is the write(2) system call entry point. v4 interface disallowed. */
@@ -799,7 +778,7 @@ static ssize_t
 sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 {
 	bool get_v3_hdr;
-	int mxsize, cmd_size, input_size, res;
+	int mxsize, cmd_size, input_size, res, ddir;
 	u8 opcode;
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
@@ -861,12 +840,10 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 			goto to_v2;
 		}
 		if (h3p->interface_id != 'S') {
-			pr_info_once("sg: %s: v3 interface only here\n",
-				     __func__);
+			pr_info_once("sg: %s: v3 interface only here\n", __func__);
 			return -EPERM;
 		}
-		pr_warn_once("Please use %s instead of write(),\n%s\n",
-			     "ioctl(SG_SUBMIT_V3)",
+		pr_warn_once("Please use ioctl(SG_SUBMIT_V3) instead of write(),\n%s\n",
 			     "  See: https://sg.danny.cz/sg/sg_v40.html");
 		res = sg_submit_v3(sfp, h3p, false, NULL);
 		return res < 0 ? res : (int)count;
@@ -902,14 +879,12 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	h3p->iovec_count = 0;
 	h3p->mx_sb_len = 0;
 	if (input_size > 0)
-		h3p->dxfer_direction = (ohp->reply_len > SZ_SG_HEADER) ?
-		    SG_DXFER_TO_FROM_DEV : SG_DXFER_TO_DEV;
+		ddir = (ohp->reply_len > SZ_SG_HEADER) ? SG_DXFER_TO_FROM_DEV : SG_DXFER_TO_DEV;
 	else
-		h3p->dxfer_direction = (mxsize > 0) ? SG_DXFER_FROM_DEV :
-						      SG_DXFER_NONE;
+		ddir = (mxsize > 0) ? SG_DXFER_FROM_DEV : SG_DXFER_NONE;
+	h3p->dxfer_direction = ddir;
 	h3p->dxfer_len = mxsize;
-	if (h3p->dxfer_direction == SG_DXFER_TO_DEV ||
-	    h3p->dxfer_direction == SG_DXFER_TO_FROM_DEV)
+	if (ddir == SG_DXFER_TO_DEV || ddir == SG_DXFER_TO_FROM_DEV)
 		h3p->dxferp = (u8 __user *)p + cmd_size;
 	else
 		h3p->dxferp = NULL;
@@ -919,17 +894,17 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	h3p->pack_id = ohp->pack_id;
 	h3p->usr_ptr = NULL;
 	/*
-	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
-	 * but it is possible that the app intended SG_DXFER_TO_DEV, because
-	 * there is a non-zero input_size, so emit a warning.
+	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV, but it is possible
+	 * that the app intended SG_DXFER_TO_DEV, because there is a non-zero input_size, so emit
+	 * a warning.
 	 */
 	if (unlikely(h3p->dxfer_direction == SG_DXFER_TO_FROM_DEV)) {
+		/* Linux kernel has questionable multiline string literal conventions */
 		printk_ratelimited
-			(KERN_WARNING
-			 "%s: data in/out %d/%d bytes for SCSI command 0x%x-- guessing data in;\n"
-			 "   program %s not setting count and/or reply_len properly\n",
-			 __func__, ohp->reply_len - (int)SZ_SG_HEADER,
-			 input_size, (unsigned int)opcode, current->comm);
+			(KERN_WARNING "%s: data in/out %d/%d %s 0x%x-- %s;\n   program %s %s\n",
+			 __func__, ohp->reply_len - (int)SZ_SG_HEADER, input_size,
+			 "bytes for SCSI command", (unsigned int)opcode, "guessing data in",
+			 current->comm, "not setting count and/or reply_len properly");
 	}
 	sg_comm_wr_init(&cwr);
 	cwr.h3p = h3p;
@@ -983,8 +958,7 @@ sg_fetch_cmnd(struct sg_fd *sfp, const u8 __user *u_cdbp, int len, u8 *cdbp)
 }
 
 static int
-sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
-	     struct sg_request **o_srp)
+sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync, struct sg_request **o_srp)
 {
 	unsigned long ul_timeout;
 	struct sg_request *srp;
@@ -1076,13 +1050,11 @@ sg_sgat_zero(struct sg_scatter_hold *sgatp, int off, int nbytes)
 }
 
 /*
- * Copies nbytes from the start of 'fromp' into sgatp (this driver's scatter
- * gather list representation) starting at byte offset 'off'. If nbytes is
- * too long then it is trimmed.
+ * Copies nbytes from the start of 'fromp' into sgatp (this driver's scatter gather list
+ * representation) starting at byte offset 'off'. If nbytes is too long then it is trimmed.
  */
 static void
-sg_sgat_cp_into(struct sg_scatter_hold *sgatp, int off, const u8 *fromp,
-		int nbytes)
+sg_sgat_cp_into(struct sg_scatter_hold *sgatp, int off, const u8 *fromp, int nbytes)
 {
 	int k, rem, off_pl_nbyt;
 	int ind = 0;
@@ -1116,8 +1088,7 @@ sg_sgat_cp_into(struct sg_scatter_hold *sgatp, int off, const u8 *fromp,
 	for ( ; k < off_pl_nbyt; k += rem) {
 		rem = off_pl_nbyt - k;
 		if (rem >= elem_sz) {
-			memcpy((u8 *)pg_ep + ind, fromp + from_off,
-			       elem_sz - ind);
+			memcpy((u8 *)pg_ep + ind, fromp + from_off, elem_sz - ind);
 			if (++pg_ind >= num_sgat)
 				return;
 			pg_ep = sgatp->pages[pg_ind];
@@ -1132,10 +1103,9 @@ sg_sgat_cp_into(struct sg_scatter_hold *sgatp, int off, const u8 *fromp,
 }
 
 /*
- * Takes a pointer (cop) to the multiple request (mrq) control object and
- * a pointer to the command array. The command array (with tot_reqs elements)
- * is written out (flushed) to user space pointer cop->din_xferp. The
- * secondary error value (s_res) is placed in the cop->spare_out field.
+ * Takes a pointer (cop) to the multiple request (mrq) control object and a pointer to the command
+ * array. The command array (with tot_reqs elements) is written out (flushed) to user space
+ * pointer cop->din_xferp. The secondary error value (s_res) is placed in the cop->spare_out field.
  */
 static int
 sg_mrq_arr_flush(struct sg_mrq_hold *mhp)
@@ -1143,15 +1113,12 @@ sg_mrq_arr_flush(struct sg_mrq_hold *mhp)
 	int s_res = mhp->s_res;
 	struct sg_io_v4 *cop = mhp->cwrp->h4p;
 	void __user *p = uptr64(cop->din_xferp);
-	struct sg_io_v4 *a_hds = mhp->a_hds;
 	u32 sz = min(mhp->tot_reqs * SZ_SG_IO_V4, cop->din_xfer_len);
 
 	if (unlikely(s_res))
 		cop->spare_out = -s_res;
-	if (unlikely(!p))
-		return 0;
-	if (sz > 0) {
-		if (copy_to_user(p, a_hds, sz))
+	if (likely(sz > 0 && p)) {
+		if (copy_to_user(p, mhp->a_hds, sz))
 			return -EFAULT;
 	}
 	return 0;
@@ -1223,8 +1190,7 @@ sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
 
 /* N.B. After this function is completed what srp points to should be considered invalid. */
 static int
-sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_fd *sfp,
-		struct sg_request *srp)
+sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_request *srp)
 {
 	int s_res, indx;
 	int tot_reqs = mhp->tot_reqs;
@@ -1236,12 +1202,11 @@ sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_fd *sfp,
 		return -EPROTO;
 	indx = srp->s_hdr4.mrq_ind;
 	if (unlikely(srp->parentfp != sfp)) {
-		SG_LOG(1, sfp, "%s: mrq_ind=%d, sfp out-of-sync\n",
-		       __func__, indx);
+		SG_LOG(1, sfp, "%s: mrq_ind=%d, sfp out-of-sync\n", __func__, indx);
 		return -EPROTO;
 	}
-	SG_LOG(3, sfp, "%s: %s, mrq_ind=%d, pack_id=%d\n", __func__,
-	       sg_side_str(srp), indx, srp->pack_id);
+	SG_LOG(3, sfp, "%s: %s, mrq_ind=%d, pack_id=%d\n", __func__, sg_side_str(srp), indx,
+	       srp->pack_id);
 	if (unlikely(indx < 0 || indx >= tot_reqs))
 		return -EPROTO;
 	hp = a_hds + indx;
@@ -1257,14 +1222,12 @@ sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_fd *sfp,
 	if (cop->din_xfer_len > 0)
 		--cop->din_resid;
 	if (mhp->co_mmap) {
-		sg_sgat_cp_into(mhp->co_mmap_sgatp, indx * SZ_SG_IO_V4,
-				(const u8 *)hp, SZ_SG_IO_V4);
+		sg_sgat_cp_into(mhp->co_mmap_sgatp, indx * SZ_SG_IO_V4, (const u8 *)hp,
+				SZ_SG_IO_V4);
 		if (sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL))
 			kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
 		if (sfp->efd_ctxp && (hp->flags & SGV4_FLAG_EVENTFD)) {
-			u64 n = eventfd_signal(sfp->efd_ctxp, 1);
-
-			if (n != 1)
+			if (eventfd_signal(sfp->efd_ctxp, 1) != 1)
 				pr_info("%s: eventfd_signal problem\n", __func__);
 		}
 	} else if (sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL)) {
@@ -1280,11 +1243,9 @@ static int
 sg_wait_any_mrq(struct sg_fd *sfp, struct sg_request **srpp)
 {
 	if (test_bit(SG_FFD_EXCL_WAITQ, sfp->ffd_bm))
-		return __wait_event_interruptible_exclusive
-					(sfp->cmpl_wait,
-					 sg_mrq_get_ready_srp(sfp, srpp));
-	return __wait_event_interruptible(sfp->cmpl_wait,
-					  sg_mrq_get_ready_srp(sfp, srpp));
+		return __wait_event_interruptible_exclusive(sfp->cmpl_wait,
+							    sg_mrq_get_ready_srp(sfp, srpp));
+	return __wait_event_interruptible(sfp->cmpl_wait, sg_mrq_get_ready_srp(sfp, srpp));
 }
 
 static bool
@@ -1339,15 +1300,13 @@ sg_wait_poll_for_given_srp(struct sg_fd *sfp, struct sg_request *srp, bool do_po
 	if (atomic_read(&srp->rq_st) != SG_RQ_INFLIGHT)
 		goto skip_wait;		/* and skip _acquire() */
 	/* N.B. The SG_FFD_EXCL_WAITQ flag is ignored here. */
-	res = __wait_event_interruptible(sfp->cmpl_wait,
-					 sg_rq_landed(sdp, srp));
+	res = __wait_event_interruptible(sfp->cmpl_wait, sg_rq_landed(sdp, srp));
 	if (unlikely(res)) { /* -ERESTARTSYS because signal hit thread */
 		set_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
 		/* orphans harvested when sfp->keep_orphan is false */
 		sg_rq_chg_state_force(srp, SG_RQ_INFLIGHT);
-		SG_LOG(1, sfp, "%s:  wait_event_interruptible(): %s[%d]\n",
-		       __func__, (res == -ERESTARTSYS ? "ERESTARTSYS" : ""),
-		       res);
+		SG_LOG(1, sfp, "%s:  wait_event_interruptible(): %s[%d]\n", __func__,
+		       (res == -ERESTARTSYS ? "ERESTARTSYS" : ""), res);
 		return res;
 	}
 skip_wait:
@@ -1441,20 +1400,18 @@ sg_mrq_poll_either(struct sg_fd *sfp, struct sg_fd *sec_sfp, bool *on_sfp)
 }
 
 /*
- * This is a fair-ish algorithm for an interruptible wait on two file
- * descriptors. It favours the main fd over the secondary fd (sec_sfp).
- * Increments cop->info for each successful completion.
+ * This is a fair-ish algorithm for an interruptible wait on two file descriptors. It favours the
+ * main fd over the secondary fd (sec_sfp). Increments cop->info for each successful completion.
  */
 static int
-sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp,
-		struct sg_fd *sec_sfp, int mreqs, int sec_reqs)
+sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_fd *sec_sfp, int mreqs,
+		int sec_reqs)
 {
 	bool on_sfp;
 	int res;
 	struct sg_request *srp;
 
-	SG_LOG(3, sfp, "%s: mreqs=%d, sec_reqs=%d\n", __func__, mreqs,
-	       sec_reqs);
+	SG_LOG(3, sfp, "%s: mreqs=%d, sec_reqs=%d\n", __func__, mreqs, sec_reqs);
 	while (mreqs + sec_reqs > 0) {
 		while (mreqs > 0 && sg_mrq_get_ready_srp(sfp, &srp)) {
 			--mreqs;
@@ -1637,6 +1594,8 @@ sg_mrq_sanity(struct sg_mrq_hold *mhp, bool is_svb)
 	       rip, k);
 	return false;
 }
+
+/* rsv_idx>=0 only when this request is the write-side of a request share */
 static struct sg_request *
 sg_mrq_submit(struct sg_fd *rq_sfp, struct sg_mrq_hold *mhp, int pos_in_rq_arr, int rsv_idx,
 	      struct sg_request *possible_srp)
@@ -1667,12 +1626,11 @@ sg_mrq_submit(struct sg_fd *rq_sfp, struct sg_mrq_hold *mhp, int pos_in_rq_arr,
 }
 
 /*
- * Processes most mrq requests apart from those from "shared variable
- * blocking" (svb) method which is processed in sg_process_svb_mrq().
+ * Processes most mrq requests apart from those from "shared variable blocking" (svb) method which
+ * is processed in sg_process_svb_mrq().
  */
 static int
-sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
-		    struct sg_mrq_hold *mhp)
+sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mhp)
 {
 	int flags, j;
 	int num_subm = 0;
@@ -1686,14 +1644,13 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 	struct sg_io_v4 *hp;		/* ptr to request object in a_hds */
 	struct sg_request *srp;
 
-	SG_LOG(3, fp, "%s: id_of_mrq=%d, tot_reqs=%d, enter\n", __func__,
-	       mhp->id_of_mrq, mhp->tot_reqs);
+	SG_LOG(3, fp, "%s: id_of_mrq=%d, tot_reqs=%d, enter\n", __func__, mhp->id_of_mrq,
+	       mhp->tot_reqs);
 	/* Dispatch (submit) requests and optionally wait for response */
 	for (hp = mhp->a_hds, j = 0; num_subm < mhp->tot_reqs; ++hp, ++j) {
-		if (mhp->chk_abort && test_and_clear_bit(SG_FFD_MRQ_ABORT,
-							 fp->ffd_bm)) {
-			SG_LOG(1, fp, "%s: id_of_mrq=%d aborting at ind=%d\n",
-			       __func__, mhp->id_of_mrq, num_subm);
+		if (mhp->chk_abort && test_and_clear_bit(SG_FFD_MRQ_ABORT, fp->ffd_bm)) {
+			SG_LOG(1, fp, "%s: id_of_mrq=%d aborting at ind=%d\n", __func__,
+			       mhp->id_of_mrq, num_subm);
 			break;	/* N.B. rest not submitted */
 		}
 		flags = hp->flags;
@@ -1705,8 +1662,7 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 		}
 		srp->s_hdr4.mrq_ind = num_subm++;
 		if (mhp->chk_abort)
-			atomic_set(&srp->s_hdr4.pack_id_of_mrq,
-				   mhp->id_of_mrq);
+			atomic_set(&srp->s_hdr4.pack_id_of_mrq, mhp->id_of_mrq);
 		if (mhp->immed || (!(mhp->from_sg_io || (flags & shr_complet_b4)))) {
 			if (fp == rq_sfp)
 				++this_fp_sent;
@@ -1724,7 +1680,6 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 		if (unlikely(res))
 			break;
 		++num_cmpl;
-
 	}	/* end of dispatch request and optionally wait response loop */
 	cop->dout_resid = mhp->tot_reqs - num_subm;
 	cop->info = mhp->immed ? num_subm : num_cmpl;
@@ -1736,10 +1691,8 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 	if (mhp->immed)
 		return res;
 	if (likely(res == 0 && (this_fp_sent + other_fp_sent) > 0)) {
-		mhp->s_res = sg_mrq_complets(mhp, fp, o_sfp, this_fp_sent,
-					     other_fp_sent);
-		if (unlikely(mhp->s_res == -EFAULT ||
-			     mhp->s_res == -ERESTARTSYS))
+		mhp->s_res = sg_mrq_complets(mhp, fp, o_sfp, this_fp_sent, other_fp_sent);
+		if (unlikely(mhp->s_res == -EFAULT || mhp->s_res == -ERESTARTSYS))
 			res = mhp->s_res;	/* this may leave orphans */
 	}
 	if (mhp->id_of_mrq)	/* can no longer do a mrq abort */
@@ -1869,7 +1822,8 @@ sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold
 				if (first_err == 0)
 					first_err = mhp->s_res;
 				svb_arr[m].prev_ws_srp = NULL;
-				SG_LOG(1, o_sfp, "%s: mrq_submit(oth)->%d\n", __func__, mhp->s_res);
+				SG_LOG(1, o_sfp, "%s: sg_mrq_submit(oth)->%d\n", __func__,
+				       mhp->s_res);
 				continue;
 			}
 			svb_arr[m].prev_ws_srp = srp;
@@ -1902,7 +1856,7 @@ sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold
 		}
 		if (chk_oth_first)
 			goto this_second;
-	}	/* end of loop for deferred ws submits and all responses */
+	}	/* end of loop for deferred ws submits and rs+ws responses */
 
 	if (res == 0 && first_err)
 		res = first_err;
@@ -1998,9 +1952,7 @@ sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 		if (IS_ERR(srp)) {
 			mhp->s_res = PTR_ERR(srp);
 			res = mhp->s_res;
-			SG_LOG(1, o_sfp,
-			       "%s: mrq_submit(oth)->%d\n",
-				__func__, res);
+			SG_LOG(1, o_sfp, "%s: mrq_submit(oth)->%d\n", __func__, res);
 			return res;
 		}
 		svb_arr[m].prev_ws_srp = srp;
@@ -2008,8 +1960,7 @@ sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 		++other_fp_sent;
 		srp->s_hdr4.mrq_ind = ws_pos;
 		if (mhp->chk_abort)
-			atomic_set(&srp->s_hdr4.pack_id_of_mrq,
-				   mhp->id_of_mrq);
+			atomic_set(&srp->s_hdr4.pack_id_of_mrq, mhp->id_of_mrq);
 	}
 	while (this_fp_sent > 0) {	/* non-data requests */
 		res = sg_wait_any_mrq(fp, &srp);
@@ -2043,8 +1994,7 @@ sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
  * per fd" rule is enforced by the SG_FFD_SVB_ACTIVE file descriptor flag.
  */
 static int
-sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
-		   struct sg_mrq_hold *mhp)
+sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mhp)
 {
 	bool aborted = false;
 	int j, delta_subm, subm_before, cmpl_before;
@@ -2053,13 +2003,12 @@ sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 	int res = 0;
 	struct sg_io_v4 *cop = mhp->cwrp->h4p;
 
-	SG_LOG(3, fp, "%s: id_of_mrq=%d, tot_reqs=%d, enter\n", __func__,
-	       mhp->id_of_mrq, mhp->tot_reqs);
+	SG_LOG(3, fp, "%s: id_of_mrq=%d, tot_reqs=%d, enter\n", __func__, mhp->id_of_mrq,
+	       mhp->tot_reqs);
 
 	/* outer loop: SG_MAX_RSV_REQS read-side requests (chunks) at a time */
 	for (j = 0; j < mhp->tot_reqs; j += delta_subm) {
-		if (mhp->chk_abort &&
-		    test_and_clear_bit(SG_FFD_MRQ_ABORT, fp->ffd_bm)) {
+		if (mhp->chk_abort && test_and_clear_bit(SG_FFD_MRQ_ABORT, fp->ffd_bm)) {
 			SG_LOG(1, fp, "%s: id_of_mrq=%d aborting at pos=%d\n", __func__,
 			       mhp->id_of_mrq, num_subm);
 			aborted = true;
@@ -2077,8 +2026,7 @@ sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 		num_cmpl += (cop->info - cmpl_before);
 		if (res || delta_subm == 0)	/* error or didn't make progress */
 			break;
-		if (unlikely(mhp->s_res == -EFAULT ||
-			     mhp->s_res == -ERESTARTSYS))
+		if (unlikely(mhp->s_res == -EFAULT || mhp->s_res == -ERESTARTSYS))
 			res = mhp->s_res;	/* this may leave orphans */
 		if (res)
 			break;
@@ -2110,11 +2058,10 @@ sg_mrq_name(bool from_sg_io, u32 flags)
 #endif
 
 /*
- * Implements the multiple request functionality. When 'from_sg_io' is true
- * invocation was via ioctl(SG_IO), otherwise it was via ioctl(SG_IOSUBMIT).
- * Submit non-blocking if IMMED flag given or when ioctl(SG_IOSUBMIT)
- * is used with O_NONBLOCK set on its file descriptor. Hipri non-blocking
- * is when the HIPRI flag is given.
+ * Implements the multiple request functionality. When from_sg_io is true invocation was via
+ * ioctl(SG_IO), otherwise it was via ioctl(SG_IOSUBMIT). Submit non-blocking if IMMED flag given
+ * or when ioctl(SG_IOSUBMIT) is used with O_NONBLOCK set on its file descriptor. Hipri
+ * non-blocking is when the HIPRI flag is given.
  */
 static int
 sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
@@ -2129,7 +2076,7 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 	u32 cdb_alen = cop->request_len;
 	u32 tot_reqs = dout_len / SZ_SG_IO_V4;
 	u8 *cdb_ap = NULL;
-	struct sg_io_v4 *a_hds;		/* array of request objects */
+	struct sg_io_v4 *a_hds;			/* array of request objects */
 	struct sg_fd *fp = cwrp->sfp;
 	struct sg_fd *o_sfp = sg_fd_share_ptr(fp);
 	struct sg_device *sdp = fp->parentdp;
@@ -2157,11 +2104,10 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 	mhp->tot_reqs = tot_reqs;
 	mhp->s_res = 0;
 	if (mhp->id_of_mrq) {
-		existing_id = atomic_cmpxchg(&fp->mrq_id_abort, 0,
-					     mhp->id_of_mrq);
+		existing_id = atomic_cmpxchg(&fp->mrq_id_abort, 0, mhp->id_of_mrq);
 		if (existing_id && existing_id != mhp->id_of_mrq) {
-			SG_LOG(1, fp, "%s: existing id=%d id_of_mrq=%d\n",
-			       __func__, existing_id, mhp->id_of_mrq);
+			SG_LOG(1, fp, "%s: existing id=%d id_of_mrq=%d\n", __func__, existing_id,
+			       mhp->id_of_mrq);
 			return -EDOM;
 		}
 		clear_bit(SG_FFD_MRQ_ABORT, fp->ffd_bm);
@@ -2169,27 +2115,26 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 	} else {
 		mhp->chk_abort = false;
 	}
-	if (from_sg_io) {
+	if (from_sg_io) {	/* only ordered blocking uses ioctl(SG_IO) */
 		if (unlikely(mhp->immed)) {
-			SG_LOG(1, fp, "%s: ioctl(SG_IO) %s contradicts\n",
-			       __func__, "with SGV4_FLAG_IMMED");
+			SG_LOG(1, fp, "%s: ioctl(SG_IO) with SGV4_FLAG_IMMED contradicts\n",
+			       __func__);
 			return -ERANGE;
 		}
 		if (unlikely(is_svb)) {
-			SG_LOG(1, fp, "%s: ioctl(SG_IO) %s contradicts\n",
-			       __func__, "with SGV4_FLAG_SHARE");
+			SG_LOG(1, fp, "%s: ioctl(SG_IO) with SGV4_FLAG_SHARE contradicts\n",
+			       __func__);
 			return -ERANGE;
 		}
 		if (unlikely(f_non_block)) {
-			SG_LOG(6, fp, "%s: ioctl(SG_IO) %s O_NONBLOCK\n",
-			       __func__, "ignoring");
+			SG_LOG(6, fp, "%s: ioctl(SG_IO) ignoring O_NONBLOCK\n", __func__);
 			f_non_block = false;
 		}
 	}
 	if (!mhp->immed && f_non_block)
 		mhp->immed = true;	/* hmm, think about this */
-	SG_LOG(3, fp, "%s: %s, tot_reqs=%u, id_of_mrq=%d\n", __func__,
-	       mrq_name, tot_reqs, mhp->id_of_mrq);
+	SG_LOG(3, fp, "%s: %s, tot_reqs=%u, id_of_mrq=%d\n", __func__, mrq_name, tot_reqs,
+	       mhp->id_of_mrq);
 	sg_v4h_partial_zero(cop);
 
 	if (mhp->co_mmap) {
@@ -2209,8 +2154,7 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 	}
 	if (unlikely(tot_reqs > U16_MAX)) {
 		return -ERANGE;
-	} else if (unlikely(dout_len > SG_MAX_MULTI_REQ_SZ ||
-			    din_len > SG_MAX_MULTI_REQ_SZ ||
+	} else if (unlikely(dout_len > SG_MAX_MULTI_REQ_SZ || din_len > SG_MAX_MULTI_REQ_SZ ||
 			    cdb_alen > SG_MAX_MULTI_REQ_SZ)) {
 		return  -E2BIG;
 	} else if (unlikely(mhp->immed && mhp->stop_if)) {
@@ -2241,8 +2185,7 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 			clear_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm);
 		return -ENOMEM;
 	}
-	if (copy_from_user(a_hds, cuptr64(cop->dout_xferp),
-			   tot_reqs * SZ_SG_IO_V4)) {
+	if (copy_from_user(a_hds, cuptr64(cop->dout_xferp), tot_reqs * SZ_SG_IO_V4)) {
 		res = -EFAULT;
 		goto fini;
 	}
@@ -2290,8 +2233,8 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 }
 
 static int
-sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
-	     bool from_sg_io, struct sg_request **o_srp)
+sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p, bool from_sg_io,
+	     struct sg_request **o_srp)
 {
 	int res = 0;
 	int dlen;
@@ -2304,8 +2247,7 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 	cwr.dlen = dlen;
 	if (h4p->flags & SGV4_FLAG_MULTIPLE_REQS) {
 		/* want v4 async or sync with guard, din and dout and flags */
-		if (!h4p->dout_xferp || h4p->din_iovec_count ||
-		    h4p->dout_iovec_count ||
+		if (!h4p->dout_xferp || h4p->din_iovec_count || h4p->dout_iovec_count ||
 		    (h4p->dout_xfer_len % SZ_SG_IO_V4))
 			return -ERANGE;
 		if (o_srp)
@@ -2349,8 +2291,7 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 		u64 gen_tag = srp->tag;
 		struct sg_io_v4 __user *h4_up = (struct sg_io_v4 __user *)p;
 
-		if (copy_to_user(&h4_up->generated_tag, &gen_tag,
-				 sizeof(gen_tag)))
+		if (copy_to_user(&h4_up->generated_tag, &gen_tag, sizeof(gen_tag)))
 			return -EFAULT;
 	}
 	return res;
@@ -2393,18 +2334,16 @@ sg_ctl_iosubmit_v3(struct sg_fd *sfp, void __user *p)
 }
 
 /*
- * Assumes sharing has been established at the file descriptor level and now we
- * check the rq_flags of a new request/command. SGV4_FLAG_NO_DXFER may or may
- * not be used on the read-side, it must be used on the write-side. Also
- * returns (via *sh_varp) the proposed sg_request::sh_var of the new request
- * yet to be built/re-used.
+ * Assumes sharing has been established at the file descriptor level and now we check the rq_flags
+ * of a new request/command. SGV4_FLAG_NO_DXFER may or may not be used on the read-side, it must
+ * be used on the write-side. Also returns (via *sh_varp) the proposed sg_request::sh_var of the
+ * new request yet to be built/re-used.
  */
 static int
 sg_share_chk_flags(struct sg_fd *sfp, u32 rq_flags, int dxfer_len, int dir,
 		   enum sg_shr_var *sh_varp)
 {
-	bool is_read_side = xa_get_mark(&sfp->parentdp->sfp_arr, sfp->idx,
-					SG_XA_FD_RS_SHARE);
+	bool is_read_side = xa_get_mark(&sfp->parentdp->sfp_arr, sfp->idx, SG_XA_FD_RS_SHARE);
 	int result = 0;
 	enum sg_shr_var sh_var = SG_SHR_NONE;
 
@@ -2412,14 +2351,12 @@ sg_share_chk_flags(struct sg_fd *sfp, u32 rq_flags, int dxfer_len, int dir,
 		if (unlikely(rq_flags & SG_FLAG_DIRECT_IO)) {
 			result = -EINVAL; /* since no control of data buffer */
 		} else if (unlikely(dxfer_len < 1)) {
-			sh_var = is_read_side ? SG_SHR_RS_NOT_SRQ :
-						SG_SHR_WS_NOT_SRQ;
+			sh_var = is_read_side ? SG_SHR_RS_NOT_SRQ : SG_SHR_WS_NOT_SRQ;
 		} else if (is_read_side) {
 			sh_var = SG_SHR_RS_RQ;
 			if (unlikely(dir != SG_DXFER_FROM_DEV))
 				result = -ENOMSG;
-			if (rq_flags & SGV4_FLAG_NO_DXFER) {
-				/* rule out some contradictions */
+			if (rq_flags & SGV4_FLAG_NO_DXFER) {	/* rule out some contradictions */
 				if (unlikely(rq_flags & SG_FL_MMAP_DIRECT))
 					result = -ENODATA;
 			}
@@ -2443,19 +2380,17 @@ sg_share_chk_flags(struct sg_fd *sfp, u32 rq_flags, int dxfer_len, int dir,
 
 #if IS_ENABLED(SG_LOG_ACTIVE)
 static void
-sg_rq_state_fail_msg(struct sg_fd *sfp, enum sg_rq_state exp_old_st,
-		     enum sg_rq_state want_st, const char *fromp)
+sg_rq_state_fail_msg(struct sg_fd *sfp, enum sg_rq_state exp_old_st, enum sg_rq_state want_st,
+		     const char *fromp)
 {
 	const char *eaw_rs = "expected_old,wanted rq_st";
 
 	if (IS_ENABLED(CONFIG_SCSI_PROC_FS))
-		SG_LOG(1, sfp, "%s: %s: %s,%s,%s\n",
-		       __func__, fromp, eaw_rs,
-		       sg_rq_st_str(exp_old_st, false),
-		       sg_rq_st_str(want_st, false));
+		SG_LOG(1, sfp, "%s: %s: %s,%s,%s\n", __func__, fromp, eaw_rs,
+		       sg_rq_st_str(exp_old_st, false), sg_rq_st_str(want_st, false));
 	else
-		pr_info("sg: %s: %s: %s: %d,%d\n", __func__, fromp, eaw_rs,
-			(int)exp_old_st, (int)want_st);
+		pr_info("sg: %s: %s: %s: %d,%d\n", __func__, fromp, eaw_rs, (int)exp_old_st,
+			(int)want_st);
 }
 #endif
 
@@ -2529,8 +2464,7 @@ static const int sg_rq_state_mul2arr[] = {2, 0, 8, 0, 0, 0};
  * function (and others ending in '_ulck') assumes srp_arr xarray spinlock is already held.
  */
 static int
-sg_rq_chg_state_ulck(struct sg_request *srp, enum sg_rq_state old_st,
-		     enum sg_rq_state new_st)
+sg_rq_chg_state_ulck(struct sg_request *srp, enum sg_rq_state old_st, enum sg_rq_state new_st)
 {
 	enum sg_rq_state act_old_st =
 			(enum sg_rq_state)atomic_cmpxchg_relaxed(&srp->rq_st, old_st, new_st);
@@ -2538,8 +2472,8 @@ sg_rq_chg_state_ulck(struct sg_request *srp, enum sg_rq_state old_st,
 
 	if (unlikely(act_old_st != old_st)) {
 #if IS_ENABLED(SG_LOG_ACTIVE)
-		SG_LOG(1, srp->parentfp, "%s: unexpected old state: %s\n",
-		       __func__, sg_rq_st_str(act_old_st, false));
+		SG_LOG(1, srp->parentfp, "%s: unexpected old state: %s\n", __func__,
+		       sg_rq_st_str(act_old_st, false));
 #endif
 		return -EPROTOTYPE;	/* only used for this error type */
 	}
@@ -2561,8 +2495,7 @@ sg_rq_chg_state_ulck(struct sg_request *srp, enum sg_rq_state old_st,
 
 /* Similar to sg_rq_chg_state_ulck() but uses the xarray spinlock */
 static int
-sg_rq_chg_state(struct sg_request *srp, enum sg_rq_state old_st,
-		enum sg_rq_state new_st)
+sg_rq_chg_state(struct sg_request *srp, enum sg_rq_state old_st, enum sg_rq_state new_st)
 {
 	enum sg_rq_state act_old_st;
 	int indic = sg_rq_state_arr[(int)old_st] + sg_rq_state_mul2arr[(int)new_st];
@@ -2601,8 +2534,8 @@ sg_rq_chg_state(struct sg_request *srp, enum sg_rq_state old_st,
 }
 
 /*
- * Returns index of an unused element in sfp's rsv_arr, or -1 if it is full.
- * Marks that element's rsv_srp with ERR_PTR(-EBUSY) to reserve that index.
+ * Returns index of an unused element in sfp's rsv_arr, or -1 if it is full. Marks that element's
+ * rsv_srp with ERR_PTR(-EBUSY) to reserve that index.
  */
 static int
 sg_get_idx_new(struct sg_fd *sfp)
@@ -2632,9 +2565,8 @@ sg_get_idx_new_lck(struct sg_fd *sfp)
 }
 
 /*
- * Looks for an available element index in sfp's rsv_arr. That element's
- * sh_srp must be NULL and will be set to ERR_PTR(-EBUSY). If no element
- * is available then returns -1.
+ * Looks for an available element index in sfp's rsv_arr. That element's sh_srp must be NULL and
+ * will be set to ERR_PTR(-EBUSY). If no element is available then returns -1.
  */
 static int
 sg_get_idx_available(struct sg_fd *sfp)
@@ -2684,13 +2616,11 @@ sg_get_probable_read_side(struct sg_fd *sfp)
 }
 
 /*
- * Returns string of the form: <leadin>rsv<num><leadout> if srp is one of
- * the reserve requests. Otherwise a blank string of length <leadin> plus
- * length of <leadout> is returned.
+ * Returns string of the form: <leadin>rsv<num><leadout> if srp is one of the reserve requests.
+ * Otherwise a blank string of length <leadin> plus length of <leadout> is returned.
  */
 static const char *
-sg_get_rsv_str(struct sg_request *srp, const char *leadin,
-	       const char *leadout, int b_len, char *b)
+sg_get_rsv_str(struct sg_request *srp, const char *leadin, const char *leadout, int b_len, char *b)
 {
 	int k, i_len, o_len, len;
 	struct sg_fd *sfp;
@@ -2727,8 +2657,8 @@ sg_get_rsv_str(struct sg_request *srp, const char *leadin,
 }
 
 static inline const char *
-sg_get_rsv_str_lck(struct sg_request *srp, const char *leadin,
-		   const char *leadout, int b_len, char *b)
+sg_get_rsv_str_lck(struct sg_request *srp, const char *leadin, const char *leadout, int b_len,
+		   char *b)
 {
 	unsigned long iflags;
 	const char *cp;
@@ -2777,11 +2707,10 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 }
 
 /*
- * All writes and submits converge on this function to launch the SCSI
- * command/request (via blk_execute_rq_nowait). Returns a pointer to a
- * sg_request object holding the request just issued or a negated errno
- * value twisted by ERR_PTR.
- * N.B. pack_id placed in sg_io_v4::request_extra field.
+ * All writes and submits converge on this function to launch the SCSI command/request (via
+ * blk_execute_rq_nowait). Returns a pointer to a sg_request object holding the request just issued
+ * or a negated errno value twisted by ERR_PTR. N.B. pack_id placed in sg_io_v4::request_extra
+ * field.
  */
 static struct sg_request *
 sg_common_write(struct sg_comm_wr_t *cwrp)
@@ -2856,8 +2785,8 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 	res = sg_start_req(srp, cwrp, dir);
 	if (unlikely(res < 0))	/* probably out of space --> -ENOMEM */
 		goto err_out;
-	SG_LOG(4, fp, "%s: opcode=0x%02x, cdb_sz=%d, pack_id=%d\n", __func__,
-	       srp->cmd_opcode, cwrp->cmd_len, pack_id);
+	SG_LOG(4, fp, "%s: opcode=0x%02x, cdb_sz=%d, pack_id=%d\n", __func__, srp->cmd_opcode,
+	       cwrp->cmd_len, pack_id);
 	if (SG_IS_DETACHING(sdp)) {
 		res = -ENODEV;
 		goto err_out;
@@ -2871,21 +2800,20 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 }
 
 /*
- * ***********************************************************************
- * read(2) related functions follow. They are shown after write(2) related
- * functions. Apart from read(2) itself, ioctl(SG_IORECEIVE) and the second
- * half of the ioctl(SG_IO) share code with read(2).
- * ***********************************************************************
+ * *********************************************************************************************
+ * read(2) related functions follow. They are shown after write(2) related functions. Apart from
+ * read(2) itself, ioctl(SG_IORECEIVE) and the second half of the ioctl(SG_IO) share code with
+ * read(2).
+ * *********************************************************************************************
  */
 
 /*
- * This function is called by wait_event_interruptible in sg_read() and
- * sg_ctl_ioreceive(). wait_event_interruptible will return if this one
- * returns true (or an event like a signal (e.g. control-C) occurs).
+ * This function is called by wait_event_interruptible in sg_read() and sg_ctl_ioreceive().
+ * wait_event_interruptible will return if this one returns true (or an event like a signal (e.g.
+ * control-C) occurs).
  */
 static inline bool
-sg_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp, int id,
-		 bool is_tag)
+sg_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp, int id, bool is_tag)
 {
 	struct sg_request *srp;
 
@@ -2898,10 +2826,7 @@ sg_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp, int id,
 	return !!srp;
 }
 
-/*
- * Returns number of bytes copied to user space provided sense buffer or
- * negated errno value.
- */
+/* Returns number of bytes copied to user space provided sense buffer or negated errno value. */
 static int
 sg_copy_sense(struct sg_request *srp, bool v4_active)
 {
@@ -2971,17 +2896,15 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 		case SG_RQ_SHR_SWAP:
 			if (!(srp->rq_flags & SGV4_FLAG_KEEP_SHARE))
 				goto set_inactive;
-			SG_LOG(6, sfp, "%s: hold onto %s share\n",
-			       __func__, sg_get_rsv_str(rs_srp, "", "",
-							sizeof(b), b));
+			SG_LOG(6, sfp, "%s: hold onto %s share\n", __func__,
+			       sg_get_rsv_str(rs_srp, "", "", sizeof(b), b));
 			break;
 		case SG_RQ_SHR_IN_WS:
 			if (!(srp->rq_flags & SGV4_FLAG_KEEP_SHARE))
 				goto set_inactive;
 			err = sg_rq_chg_state(rs_srp, rs_st, SG_RQ_SHR_SWAP);
-			SG_LOG(6, sfp, "%s: hold onto %s share\n",
-			       __func__, sg_get_rsv_str(rs_srp, "", "",
-							sizeof(b), b));
+			SG_LOG(6, sfp, "%s: hold onto %s share\n", __func__,
+			       sg_get_rsv_str(rs_srp, "", "", sizeof(b), b));
 			break;
 		case SG_RQ_AWAIT_RCV:
 			break;
@@ -2991,9 +2914,8 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 			break;
 		default:
 			err = -EPROTO;	/* Logic error */
-			SG_LOG(1, sfp,
-			       "%s: SHR_WS_RQ, bad read-side state: %s\n",
-			       __func__, sg_rq_st_str(rs_st, true));
+			SG_LOG(1, sfp, "%s: SHR_WS_RQ, bad read-side state: %s\n", __func__,
+			       sg_rq_st_str(rs_st, true));
 			break;	/* nothing to do */
 		}
 	}
@@ -3029,15 +2951,13 @@ sg_complete_shr_rs(struct sg_fd *sfp, struct sg_request *srp, bool other_err,
 		sg_rq_chg_state_force(srp, SG_RQ_SHR_SWAP);
 	}
 	if (ws_sfp && !srp->sh_srp) {
-		if (ws_sfp->async_qp &&
-		    (!SG_IS_V4I(srp) || (srp->rq_flags & SGV4_FLAG_SIGNAL)))
+		if (ws_sfp->async_qp && (!SG_IS_V4I(srp) || (srp->rq_flags & SGV4_FLAG_SIGNAL)))
 			kill_fasync(&ws_sfp->async_qp, SIGPOLL, poll_type);
 		if (ws_sfp->efd_ctxp && (srp->rq_flags & SGV4_FLAG_EVENTFD)) {
 			u64 n = eventfd_signal(ws_sfp->efd_ctxp, 1);
 
 			if (n != 1)
-				pr_info("%s: srp=%pK eventfd prob\n",
-					__func__, srp);
+				pr_info("%s: srp=%pK eventfd problem\n", __func__, srp);
 		}
 	}
 }
@@ -3048,8 +2968,7 @@ sg_complete_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool other_err)
 	enum sg_rq_state sr_st = atomic_read(&srp->rq_st);
 
 	/* advance state machine, send signal to write-side if appropriate */
-	SG_LOG(4, sfp, "%s: %pK: sh_var=%s\n", __func__, srp,
-	       sg_shr_str(srp->sh_var, true));
+	SG_LOG(4, sfp, "%s: %pK: sh_var=%s\n", __func__, srp, sg_shr_str(srp->sh_var, true));
 	switch (srp->sh_var) {
 	case SG_SHR_RS_RQ:
 		sg_complete_shr_rs(sfp, srp, other_err, sr_st);
@@ -3062,8 +2981,7 @@ sg_complete_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool other_err)
 				rs_srp->sh_srp = NULL;
 				rs_srp->sh_var = SG_SHR_RS_NOT_SRQ;
 			} else {
-				SG_LOG(2, sfp, "%s: write-side's paired read is missing\n",
-				       __func__);
+				SG_LOG(2, sfp, "%s: paired read is missing\n", __func__);
 			}
 		}
 		srp->sh_var = SG_SHR_WS_NOT_SRQ;
@@ -3081,14 +2999,13 @@ sg_complete_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool other_err)
 }
 
 static int
-sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
-	      struct sg_io_v4 *h4p)
+sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p, struct sg_io_v4 *h4p)
 {
 	int err;
 	u32 rq_result = srp->rq_result;
 
-	SG_LOG(3, sfp, "%s: p=%s, h4p=%s\n", __func__,
-	       (p ? "given" : "NULL"), (h4p ? "given" : "NULL"));
+	SG_LOG(3, sfp, "%s: p=%s, h4p=%s\n", __func__, (p ? "given" : "NULL"),
+	       (h4p ? "given" : "NULL"));
 	err = sg_rec_state_v3v4(sfp, srp, true);
 	h4p->guard = 'Q';
 	h4p->protocol = 0;
@@ -3128,14 +3045,12 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
 }
 
 /*
- * Invoked when user calls ioctl(SG_IORECEIVE, SGV4_FLAG_MULTIPLE_REQS).
- * Returns negative on error including -ENODATA if there are no mrqs submitted
- * nor waiting. Otherwise it returns the number of elements written to
- * rsp_arr, which may be 0 if mrqs submitted but none waiting
+ * Invoked when user calls ioctl(SG_IORECEIVE, SGV4_FLAG_MULTIPLE_REQS). Returns negative on error
+ * including -ENODATA if there are no mrqs submitted nor waiting. Otherwise it returns the number
+ * of elements written to rsp_arr, which may be 0 if mrqs submitted but none waiting
  */
 static int
-sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_mrqs,
-		      struct sg_io_v4 *rsp_arr)
+sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_mrqs, struct sg_io_v4 *rsp_arr)
 {
 	int k;
 	int res = 0;
@@ -3170,14 +3085,12 @@ sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_mrqs,
 }
 
 /*
- * Invoked when user calls ioctl(SG_IORECEIVE, SGV4_FLAG_MULTIPLE_REQS).
- * Expected race as many concurrent calls with the same pack_id/tag can
- * occur. Only one should succeed per request (more may succeed but will get
- * different requests).
+ * Invoked when user calls ioctl(SG_IORECEIVE, SGV4_FLAG_MULTIPLE_REQS). Expected race as many
+ * concurrent calls with the same pack_id/tag can occur. Only one should succeed per request (more
+ * may succeed but will get different requests).
  */
 static int
-sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p,
-		 bool non_block)
+sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p, bool non_block)
 {
 	int res = 0;
 	u32 len, n;
@@ -3192,8 +3105,7 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p,
 		return -ERANGE;
 	n /= SZ_SG_IO_V4;
 	len = n * SZ_SG_IO_V4;
-	SG_LOG(3, sfp, "%s: %s, num_reqs=%u\n", __func__,
-	       (non_block ? "IMMED" : "blocking"), n);
+	SG_LOG(3, sfp, "%s: %s, num_reqs=%u\n", __func__, (non_block ? "IMMED" : "blocking"), n);
 	rsp_v4_arr = kcalloc(n, SZ_SG_IO_V4, GFP_KERNEL);
 	if (unlikely(!rsp_v4_arr))
 		return -ENOMEM;
@@ -3230,11 +3142,8 @@ sg_wait_poll_by_id(struct sg_fd *sfp, struct sg_request **srpp, int id,
 
 	if (test_bit(SG_FFD_EXCL_WAITQ, sfp->ffd_bm))
 		return __wait_event_interruptible_exclusive
-				(sfp->cmpl_wait,
-				 sg_get_ready_srp(sfp, srpp, id, is_tag));
-	return __wait_event_interruptible
-			(sfp->cmpl_wait,
-			 sg_get_ready_srp(sfp, srpp, id, is_tag));
+					(sfp->cmpl_wait, sg_get_ready_srp(sfp, srpp, id, is_tag));
+	return __wait_event_interruptible(sfp->cmpl_wait, sg_get_ready_srp(sfp, srpp, id, is_tag));
 poll_loop:
 	{
 		bool sig_pending = false;
@@ -3260,10 +3169,9 @@ sg_wait_poll_by_id(struct sg_fd *sfp, struct sg_request **srpp, int id,
 }
 
 /*
- * Called when ioctl(SG_IORECEIVE) received. Expects a v4 interface object.
- * Checks if O_NONBLOCK file flag given, if not checks given 'flags' field
- * to see if SGV4_FLAG_IMMED is set. Either of these implies non blocking.
- * When non-blocking and there is no request waiting, yields EAGAIN;
+ * Called when ioctl(SG_IORECEIVE) received. Expects a v4 interface object. Checks if O_NONBLOCK
+ * file flag given, if not checks given 'flags' field to see if SGV4_FLAG_IMMED is set. Either of
+ * these implies non blocking. When non-blocking and there is no request waiting, yields EAGAIN;
  * otherwise it waits (i.e. it "blocks").
  */
 static int
@@ -3286,8 +3194,7 @@ sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 	if (copy_from_user(h4p, p, SZ_SG_IO_V4))
 		return -EFAULT;
 	/* for v4: protocol=0 --> SCSI;  subprotocol=0 --> SPC++ */
-	if (unlikely(h4p->guard != 'Q' || h4p->protocol != 0 ||
-		     h4p->subprotocol != 0))
+	if (unlikely(h4p->guard != 'Q' || h4p->protocol != 0 || h4p->subprotocol != 0))
 		return -EPERM;
 	SG_LOG(3, sfp, "%s: non_block=%d, immed=%d, hipri=%d\n", __func__, non_block,
 	       !!(h4p->flags & SGV4_FLAG_IMMED), !!(h4p->flags & SGV4_FLAG_HIPRI));
@@ -3325,10 +3232,9 @@ sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 }
 
 /*
- * Called when ioctl(SG_IORECEIVE_V3) received. Expects a v3 interface.
- * Checks if O_NONBLOCK file flag given, if not checks given flags field
- * to see if SGV4_FLAG_IMMED is set. Either of these implies non blocking.
- * When non-blocking and there is no request waiting, yields EAGAIN;
+ * Called when ioctl(SG_IORECEIVE_V3) received. Expects a v3 interface. Checks if O_NONBLOCK file
+ * flag given, if not checks given flags field to see if SGV4_FLAG_IMMED is set. Either of these
+ * implies non blocking. When non-blocking and there is no request waiting, yields EAGAIN;
  * otherwise it waits.
  */
 static int
@@ -3380,8 +3286,7 @@ sg_ctl_ioreceive_v3(struct sg_fd *sfp, void __user *p)
 }
 
 static int
-sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
-	     struct sg_request *srp)
+sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp, struct sg_request *srp)
 {
 	int res = 0;
 	u32 rq_res = srp->rq_result;
@@ -3399,22 +3304,19 @@ sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 	h2p->target_status = status_byte(rq_res);
 	h2p->host_status = host_byte(rq_res);
 	h2p->driver_status = driver_byte(rq_res);
-	if (unlikely(!scsi_status_is_good(rq_res) ||
-		     (driver_byte(rq_res) & DRIVER_SENSE))) {
+	if (unlikely(!scsi_status_is_good(rq_res) || (driver_byte(rq_res) & DRIVER_SENSE))) {
 		if (likely(srp->sense_bp)) {
 			u8 *sbp = srp->sense_bp;
 
 			srp->sense_bp = NULL;
-			memcpy(h2p->sense_buffer, sbp,
-			       sizeof(h2p->sense_buffer));
+			memcpy(h2p->sense_buffer, sbp, sizeof(h2p->sense_buffer));
 			mempool_free(sbp, sg_sense_pool);
 		}
 	}
 	switch (unlikely(host_byte(rq_res))) {
 	/*
-	 * This following setting of 'result' is for backward compatibility
-	 * and is best ignored by the user who should use target, host and
-	 * driver status.
+	 * This following setting of 'result' is for backward compatibility and is best ignored by
+	 * the user who should use target, host and driver status.
 	 */
 	case DID_OK:
 	case DID_PASSTHROUGH:
@@ -3465,10 +3367,9 @@ sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 }
 
 /*
- * This is the read(2) system call entry point (see sg_fops) for this driver.
- * Accepts v1, v2 or v3 type headers (not v4). Returns count or negated
- * errno; if count is 0 then v3: returns -EINVAL; v1+v2: 0 when no other
- * error detected or -EIO.
+ * This is the read(2) system call entry point (see sg_fops) for this driver. Accepts v1, v2 or
+ * v3 type headers (not v4). Returns count or negated errno; if count is 0 then v3: returns
+ * -EINVAL; v1+v2: 0 when no other error detected or -EIO.
  */
 static ssize_t
 sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
@@ -3484,8 +3385,8 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 	struct sg_io_hdr a_sg_io_hdr;
 
 	/*
-	 * This could cause a response to be stranded. Close the associated
-	 * file descriptor to free up any resources being held.
+	 * This could cause a response to be stranded. Close the associated file descriptor to
+	 * free up any resources being held.
 	 */
 	ret = sg_check_file_access(filp, __func__);
 	if (unlikely(ret))
@@ -3504,9 +3405,8 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 
 	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm) && (int)count >= hlen) {
 		/*
-		 * Even though this is a user space read() system call, this
-		 * code is cheating to fetch the pack_id.
-		 * Only need first three 32 bit ints to determine interface.
+		 * Even though this is a user space read() system call, this code is cheating to
+		 * fetch the pack_id. Only need first three 32 bit ints to determine interface.
 		 */
 		if (copy_from_user(h2p, p, 3 * sizeof(int)))
 			return -EFAULT;
@@ -3530,8 +3430,7 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 						non_block = true;
 				}
 			} else if (v3_hdr->interface_id == 'Q') {
-				pr_info_once("sg: %s: v4 interface%s here\n",
-					     __func__, " disallowed");
+				pr_info_once("sg: %s: v4 interface disallowed here\n", __func__);
 				return -EPERM;
 			} else {
 				return -EPERM;
@@ -3575,9 +3474,8 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 }
 
 /*
- * Completes a v3 request/command. Called from sg_read {v2 or v3},
- * ioctl(SG_IO) {for v3}, or from ioctl(SG_IORECEIVE) when its
- * completing a v3 request/command.
+ * Completes a v3 request/command. Called from sg_read {v2 or v3}, ioctl(SG_IO) {for v3}, or from
+ * ioctl(SG_IORECEIVE) when its completing a v3 request/command.
  */
 static int
 sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, void __user *p)
@@ -3587,8 +3485,8 @@ sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, void __user *p)
 	struct sg_io_hdr hdr3;
 	struct sg_io_hdr *hp = &hdr3;
 
-	SG_LOG(3, sfp, "%s: sh_var: %s srp=0x%pK\n", __func__,
-	       sg_shr_str(srp->sh_var, false), srp);
+	SG_LOG(3, sfp, "%s: sh_var: %s srp=0x%pK\n", __func__, sg_shr_str(srp->sh_var, false),
+	       srp);
 	err = sg_rec_state_v3v4(sfp, srp, false);
 	memset(hp, 0, sizeof(*hp));
 	memcpy(hp, &srp->s_hdr3, sizeof(srp->s_hdr3));
@@ -3620,11 +3518,10 @@ max_sectors_bytes(struct request_queue *q)
 }
 
 /*
- * Calculates sg_device::max_sgat_elems and sg_device::max_sgat_sz. It uses
- * the device's request queue. If q not available sets max_sgat_elems to 1
- * and max_sgat_sz to PAGE_SIZE. If potential max_sgat_sz is greater than
- * 2^30 scales down the implied max_segment_size so the product of the
- * max_segment_size and max_sgat_elems is less than or equal to 2^30 .
+ * Calculates sg_device::max_sgat_elems and sg_device::max_sgat_sz. It uses the device's request
+ * queue. If q not available sets max_sgat_elems to 1 and max_sgat_sz to PAGE_SIZE. If potential
+ * max_sgat_sz is greater than 2^30 scales down the implied max_segment_size so the product of
+ * the max_segment_size and max_sgat_elems is less than or equal to 2^30 .
  */
 static void
 sg_calc_sgat_param(struct sg_device *sdp)
@@ -3759,7 +3656,7 @@ sg_unshare_rs_fd(struct sg_fd *rs_sfp, bool lck)
 	if (lck)
 		xa_unlock_irqrestore(xadp, iflags);
 	rcu_assign_pointer(rs_sfp->share_sfp, NULL);
-	kref_put(&rs_sfp->f_ref, sg_remove_sfp);/* get: sg_find_sfp_by_fd() */
+	kref_put(&rs_sfp->f_ref, sg_remove_sfp);	/* get: sg_find_sfp_by_fd() */
 }
 
 static void
@@ -3780,11 +3677,10 @@ sg_unshare_ws_fd(struct sg_fd *ws_sfp, bool lck)
 }
 
 /*
- * Clean up loose ends that occur when closing a file descriptor which is
- * part of a file share. There may be request shares in various states using
- * this file share so care is needed. Potential race when both sides of fd
- * share have their fd_s closed (i.e. sg_release()) at around the same time
- * is the reason for rechecking the FD_RS_SHARE or FD_UNSHARED marks.
+ * Clean up loose ends that occur when closing a file descriptor which is part of a file share.
+ * There may be request shares in various states using this file share so care is needed. Potential
+ * race when both sides of fd share have their fd_s closed (i.e. sg_release()) at around the same
+ * time is the reason for rechecking the FD_RS_SHARE or FD_UNSHARED marks.
  */
 static void
 sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
@@ -3803,8 +3699,7 @@ sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
 	struct xarray *xadp = &sdp->sfp_arr;
 	struct xarray *xafp = &sfp->srp_arr;
 
-	SG_LOG(3, sfp, "%s: sfp=%pK %s\n", __func__, sfp,
-	       (is_rd_side ? "read-side" : "write-side"));
+	SG_LOG(3, sfp, "%s: sfp=%pK %s-side\n", __func__, sfp, (is_rd_side ? "read" : "write"));
 	xa_lock_irqsave(xadp, iflags);
 	retry_count = 0;
 try_again:
@@ -3816,8 +3711,8 @@ sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
 	sh_sdp = sh_sfp->parentdp;
 	if (!xa_trylock(xafp)) {
 		/*
-		 * The other side of the share might be closing as well, avoid
-		 * deadlock. Should clear relatively quickly.
+		 * The other side of the share might be closing as well, avoid deadlock. Should
+		 * clear relatively quickly.
 		 */
 		xa_unlock_irqrestore(xadp, iflags);
 		if (++retry_count > SG_ADD_RQ_MAX_RETRIES) {
@@ -3837,8 +3732,7 @@ sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
 			bool set_inactive = false;
 
 			rsv_srp = *rapp;
-			if (IS_ERR_OR_NULL(rsv_srp) ||
-			    rsv_srp->sh_var != SG_SHR_RS_RQ)
+			if (IS_ERR_OR_NULL(rsv_srp) || rsv_srp->sh_var != SG_SHR_RS_RQ)
 				continue;
 			sr_st = atomic_read_acquire(&rsv_srp->rq_st);
 			switch (sr_st) {
@@ -3847,11 +3741,9 @@ sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
 				break;
 			case SG_RQ_SHR_IN_WS:
 				ws_srp = rsv_srp->sh_srp;
-				if (!IS_ERR_OR_NULL(ws_srp) &&
-				    !test_bit(SG_FFD_RELEASE,
-					      sh_sfp->ffd_bm)) {
+				if (!IS_ERR_OR_NULL(ws_srp) && !test_bit(SG_FFD_RELEASE,
+									 sh_sfp->ffd_bm))
 					ws_srp->sh_var = SG_SHR_WS_NOT_SRQ;
-				}
 				rsv_srp->sh_srp = NULL;
 				set_inactive = true;
 				break;
@@ -3865,13 +3757,13 @@ sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
 					atomic_inc(&sfp->inactives);
 			}
 		}
-		if (!xa_get_mark(&sh_sdp->sfp_arr, sh_sfp->idx,
-				 SG_XA_FD_FREE) && sg_fd_is_shared(sh_sfp))
+		if (!xa_get_mark(&sh_sdp->sfp_arr, sh_sfp->idx, SG_XA_FD_FREE) &&
+		    sg_fd_is_shared(sh_sfp))
 			sg_unshare_ws_fd(sh_sfp, sdp != sh_sdp);
 		sg_unshare_rs_fd(sfp, false);
 	} else {			/* is write-side of share */
-		if (!xa_get_mark(&sh_sdp->sfp_arr, sh_sfp->idx,
-				 SG_XA_FD_FREE) && sg_fd_is_shared(sh_sfp))
+		if (!xa_get_mark(&sh_sdp->sfp_arr, sh_sfp->idx, SG_XA_FD_FREE) &&
+		    sg_fd_is_shared(sh_sfp))
 			sg_unshare_rs_fd(sh_sfp, sdp != sh_sdp);
 		sg_unshare_ws_fd(sfp, false);
 	}
@@ -3881,9 +3773,8 @@ sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
 }
 
 /*
- * Active when writing 1 to ioctl(SG_SET_GET_EXTENDED(CTL_FLAGS(UNSHARE))),
- * writing 0 has no effect. Undoes the configuration that has done by
- * ioctl(SG_SET_GET_EXTENDED(SHARE_FD)).
+ * Active when writing 1 to ioctl(SG_SET_GET_EXTENDED(CTL_FLAGS(UNSHARE))), writing 0 has no
+ * effect. Undoes the configuration that has done by ioctl(SG_SET_GET_EXTENDED(SHARE_FD)).
  */
 static void
 sg_do_unshare(struct sg_fd *sfp, bool unshare_val)
@@ -3912,13 +3803,10 @@ sg_do_unshare(struct sg_fd *sfp, bool unshare_val)
 		rs_sfp = sfp;
 		ws_sfp = o_sfp;
 		rs_rsv_srp = rs_sfp->rsv_arr[0];
-		if (!IS_ERR_OR_NULL(rs_rsv_srp) &&
-		    rs_rsv_srp->sh_var != SG_SHR_RS_RQ) {
+		if (!IS_ERR_OR_NULL(rs_rsv_srp) && rs_rsv_srp->sh_var != SG_SHR_RS_RQ) {
 			if (unlikely(!mutex_trylock(&ws_sfp->f_mutex))) {
 				if (++retry_count > SG_ADD_RQ_MAX_RETRIES)
-					SG_LOG(1, sfp,
-					       "%s: cannot get write-side lock\n",
-					       __func__);
+					SG_LOG(1, sfp, "%s: cannot get ws lock\n", __func__);
 				else
 					retry = true;
 				goto fini;
@@ -3940,15 +3828,13 @@ sg_do_unshare(struct sg_fd *sfp, bool unshare_val)
 		ws_sfp = sfp;
 		if (unlikely(!mutex_trylock(&rs_sfp->f_mutex))) {
 			if (++retry_count > SG_ADD_RQ_MAX_RETRIES)
-				SG_LOG(1, sfp, "%s: cannot get read side lock\n",
-				       __func__);
+				SG_LOG(1, sfp, "%s: cannot get read side lock\n", __func__);
 			else
 				retry = true;
 			goto fini;
 		}
 		rs_rsv_srp = rs_sfp->rsv_arr[0];
-		if (!IS_ERR_OR_NULL(rs_rsv_srp) &&
-		    rs_rsv_srp->sh_var != SG_SHR_RS_RQ) {
+		if (!IS_ERR_OR_NULL(rs_rsv_srp) && rs_rsv_srp->sh_var != SG_SHR_RS_RQ) {
 			if (same_sdp_s) {
 				xa_lock_irqsave(xadp, iflags);
 				/* read-side is 'other' so do first */
@@ -3970,15 +3856,13 @@ sg_do_unshare(struct sg_fd *sfp, bool unshare_val)
 }
 
 /*
- * Returns duration since srp->start_ns (using boot time as an epoch). Unit
- * is nanoseconds when time_in_ns==true; else it is in milliseconds.
- * For backward compatibility the duration is placed in a 32 bit unsigned
- * integer. This limits the maximum nanosecond duration that can be
- * represented (without wrapping) to about 4.3 seconds. If that is exceeded
- * return equivalent of 3.999.. secs as it is more eye catching than the real
- * number. Negative durations should not be possible but if they occur set
- * duration to an unlikely 2 nanosec. Stalls in a request setup will have
- * ts0==S64_MAX and will return 1 for an unlikely 1 nanosecond duration.
+ * Returns duration since srp->start_ns (using boot time as an epoch). Unit is nanoseconds when
+ * time_in_ns==true; else it is in milliseconds. For backward compatibility the duration is placed
+ * in a 32 bit unsigned integer. This limits the maximum nanosecond duration that can be
+ * represented (without wrapping) to about 4.3 seconds. If that is exceeded return equivalent of
+ * 3.999.. secs as it is more eye catching than the real number. Negative durations should not be
+ * possible but if they occur set duration to an unlikely 2 nanosec. Stalls in a request setup
+ * will have ts0==S64_MAX and will return 1 for an unlikely 1 nanosecond duration.
  */
 static u32
 sg_calc_rq_dur(const struct sg_request *srp, bool time_in_ns)
@@ -4001,9 +3885,13 @@ sg_calc_rq_dur(const struct sg_request *srp, bool time_in_ns)
 	return (diff > (s64)U32_MAX) ? 3999999999U : (u32)diff;
 }
 
+/*
+ * Return of U32_MAX means srp is inactive. *is_durp is unused as an input but if is_dur is
+ * non-NULL, it is set on output when duration calculation has completed, clear (or false) if
+ * it is on-going.
+ */
 static u32
-sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,
-	   bool time_in_ns, bool *is_durp)
+sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp, bool time_in_ns, bool *is_durp)
 {
 	bool is_dur = false;
 	u32 res = U32_MAX;
@@ -4029,30 +3917,23 @@ sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,
 }
 
 static void
-sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp,
-			struct sg_req_info *rip)
+sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp, struct sg_req_info *rip)
 {
 	unsigned long iflags;
 
 	xa_lock_irqsave(&sfp->srp_arr, iflags);
-	rip->duration = sg_get_dur(srp, NULL, test_bit(SG_FFD_TIME_IN_NS,
-						       sfp->ffd_bm), NULL);
+	rip->duration = sg_get_dur(srp, NULL, test_bit(SG_FFD_TIME_IN_NS, sfp->ffd_bm), NULL);
 	if (rip->duration == U32_MAX)
 		rip->duration = 0;
 	rip->orphan = test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
 	rip->sg_io_owned = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
 	rip->problem = !sg_result_is_good(srp->rq_result);
-	rip->pack_id = test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm) ?
-				srp->tag : srp->pack_id;
-	rip->usr_ptr = SG_IS_V4I(srp) ? uptr64(srp->s_hdr4.usr_ptr)
-				      : srp->s_hdr3.usr_ptr;
+	rip->pack_id = test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm) ? srp->tag : srp->pack_id;
+	rip->usr_ptr = SG_IS_V4I(srp) ? uptr64(srp->s_hdr4.usr_ptr) : srp->s_hdr3.usr_ptr;
 	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 }
 
-/*
- * Handles ioctl(SG_IO) for blocking (sync) usage of v3 or v4 interface.
- * Returns 0 on success else a negated errno.
- */
+/* Handles ioctl(SG_IO) for blocking (sync) usage of v3 or v4 interface. */
 static int
 sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 {
@@ -4070,8 +3951,7 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		return res;
 	if (unlikely(get_sg_io_hdr(h3p, p)))
 		return -EFAULT;
-	if (h3p->interface_id == 'Q') {
-		/* copy in rest of sg_io_v4 object */
+	if (h3p->interface_id == 'Q') {	/* copy in rest of sg_io_v4 object */
 		int v3_len;
 
 #ifdef CONFIG_COMPAT
@@ -4082,8 +3962,7 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 #else
 		v3_len = SZ_SG_IO_HDR;
 #endif
-		if (copy_from_user(hu8arr + v3_len,
-				   ((u8 __user *)p) + v3_len,
+		if (copy_from_user(hu8arr + v3_len, ((u8 __user *)p) + v3_len,
 				   SZ_SG_IO_V4 - v3_len))
 			return -EFAULT;
 		is_v4 = true;
@@ -4094,8 +3973,7 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		hipri = !!(h3p->flags & SGV4_FLAG_HIPRI);
 		res = sg_submit_v3(sfp, h3p, true, &srp);
 	} else {
-		pr_info_once("sg: %s: v3 or v4 interface only here\n",
-			     __func__);
+		pr_info_once("sg: %s: v3 or v4 interface only here\n", __func__);
 		return -EPERM;
 	}
 	if (unlikely(res < 0))
@@ -4105,9 +3983,8 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 	res = sg_wait_poll_for_given_srp(sfp, srp, hipri);
 #if IS_ENABLED(SG_LOG_ACTIVE)
 	if (unlikely(res))
-		SG_LOG(1, sfp, "%s: %s=0x%pK  state: %s, share: %s\n",
-		       __func__, "unexpected srp", srp,
-		       sg_rq_st_str(atomic_read(&srp->rq_st), false),
+		SG_LOG(1, sfp, "%s: unexpected srp=0x%pK  state: %s, share: %s\n", __func__,
+		       srp, sg_rq_st_str(atomic_read(&srp->rq_st), false),
 		       sg_shr_str(srp->sh_var, false));
 #endif
 	if (likely(res == 0)) {
@@ -4120,8 +3997,8 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 }
 
 /*
- * When use_tag is true then id is a tag, else it is a pack_id. Returns
- * valid srp if match, else returns NULL.
+ * When use_tag is true then id is a tag, else it is a pack_id. Returns valid srp if match, else
+ * returns NULL.
  */
 static struct sg_request *
 sg_match_request(struct sg_fd *sfp, bool use_tag, int id)
@@ -4149,14 +4026,12 @@ sg_match_request(struct sg_fd *sfp, bool use_tag, int id)
 }
 
 /*
- * Looks for first request following 'after_rp' (or the start if after_rp is
- * NULL) whose pack_id_of_mrq matches the given pack_id. If after_rp is
- * non-NULL and it is not found, then the search restarts from the beginning
- * of the list. If no match is found then NULL is returned.
+ * Looks for first request following 'after_rp' (or the start if after_rp is NULL) whose
+ * pack_id_of_mrq matches the given pack_id. If after_rp is non-NULL and it is not found, then the
+ * search restarts from the beginning of the list. If no match is found then NULL is returned.
  */
 static struct sg_request *
-sg_match_first_mrq_after(struct sg_fd *sfp, int pack_id,
-			 struct sg_request *after_rp)
+sg_match_first_mrq_after(struct sg_fd *sfp, int pack_id, struct sg_request *after_rp)
 {
 	bool found = false;
 	bool look_for_after = after_rp ? true : false;
@@ -4197,13 +4072,13 @@ sg_abort_req(struct sg_fd *sfp, struct sg_request *srp)
 	struct request *rqq;
 
 	if (test_and_set_bit(SG_FRQ_ABORTING, srp->frq_bm)) {
-		SG_LOG(1, sfp, "%s: already aborting req pack_id/tag=%d/%d\n",
-		       __func__, srp->pack_id, srp->tag);
+		SG_LOG(1, sfp, "%s: already aborting req pack_id/tag=%d/%d\n", __func__,
+		       srp->pack_id, srp->tag);
 		goto fini;	/* skip quietly if already aborted */
 	}
 	rq_st = atomic_read_acquire(&srp->rq_st);
-	SG_LOG(3, sfp, "%s: req pack_id/tag=%d/%d, status=%s\n", __func__,
-	       srp->pack_id, srp->tag, sg_rq_st_str(rq_st, false));
+	SG_LOG(3, sfp, "%s: req pack_id/tag=%d/%d, status=%s\n", __func__, srp->pack_id, srp->tag,
+	       sg_rq_st_str(rq_st, false));
 	switch (rq_st) {
 	case SG_RQ_BUSY:
 		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
@@ -4221,8 +4096,7 @@ sg_abort_req(struct sg_fd *sfp, struct sg_request *srp)
 		srp->rq_result |= (DRIVER_SOFT << 24);
 		rqq = READ_ONCE(srp->rqq);
 		if (likely(rqq)) {
-			SG_LOG(5, sfp, "%s: -->blk_abort_request srp=0x%pK\n",
-			       __func__, srp);
+			SG_LOG(5, sfp, "%s: -->blk_abort_request srp=0x%pK\n", __func__, srp);
 			blk_abort_request(rqq);
 		}
 		break;
@@ -4259,12 +4133,11 @@ sg_mrq_abort_inflight(struct sg_fd *sfp, int pack_id)
 }
 
 /*
- * Implements ioctl(SG_IOABORT) when SGV4_FLAG_MULTIPLE_REQS set. pack_id is
- * non-zero and is from the request_extra field. dev_scope is set when
- * SGV4_FLAG_DEV_SCOPE is given; in that case there is one level of recursion
- * if there is no match or clash with given sfp. Will abort the first
- * mrq that matches then exit. Can only do mrq abort if the mrq submission
- * used a non-zero ctl_obj.request_extra (pack_id).
+ * Implements ioctl(SG_IOABORT) when SGV4_FLAG_MULTIPLE_REQS set. pack_id is non-zero and is from
+ * the request_extra field. dev_scope is set when SGV4_FLAG_DEV_SCOPE is given; in that case there
+ * is one level of recursion if there is no match or clash with given sfp. Will abort the first
+ * mrq that matches then exit. Can only do mrq abort if the mrq submission used a non-zero
+ * ctl_obj.request_extra (pack_id).
  */
 static int
 sg_mrq_abort(struct sg_fd *sfp, int pack_id, bool dev_scope)
@@ -4278,30 +4151,27 @@ sg_mrq_abort(struct sg_fd *sfp, int pack_id, bool dev_scope)
 	struct sg_fd *s_sfp;
 
 	if (pack_id != SG_PACK_ID_WILDCARD)
-		SG_LOG(3, sfp, "%s: pack_id=%d, dev_scope=%s\n", __func__,
-		       pack_id, (dev_scope ? "true" : "false"));
+		SG_LOG(3, sfp, "%s: pack_id=%d, dev_scope=%s\n", __func__, pack_id,
+		       (dev_scope ? "true" : "false"));
 	existing_id = atomic_read(&sfp->mrq_id_abort);
 	if (existing_id == 0) {
 		if (dev_scope)
 			goto check_whole_dev;
-		SG_LOG(1, sfp, "%s: sfp->mrq_id_abort is 0, nothing to do\n",
-		       __func__);
+		SG_LOG(1, sfp, "%s: sfp->mrq_id_abort is 0, nothing to do\n", __func__);
 		return -EADDRNOTAVAIL;
 	}
 	if (pack_id == SG_PACK_ID_WILDCARD) {
 		pack_id = existing_id;
-		SG_LOG(3, sfp, "%s: wildcard becomes pack_id=%d\n", __func__,
-		       pack_id);
+		SG_LOG(3, sfp, "%s: wildcard becomes pack_id=%d\n", __func__, pack_id);
 	} else if (pack_id != existing_id) {
 		if (dev_scope)
 			goto check_whole_dev;
-		SG_LOG(1, sfp, "%s: want id=%d, got sfp->mrq_id_abort=%d\n",
-		       __func__, pack_id, existing_id);
+		SG_LOG(1, sfp, "%s: want id=%d, got sfp->mrq_id_abort=%d\n", __func__, pack_id,
+		       existing_id);
 		return -EADDRINUSE;
 	}
 	if (test_and_set_bit(SG_FFD_MRQ_ABORT, sfp->ffd_bm))
-		SG_LOG(2, sfp, "%s: repeated SG_IOABORT on mrq_id=%d\n",
-		       __func__, pack_id);
+		SG_LOG(2, sfp, "%s: repeated SG_IOABORT on mrq_id=%d\n", __func__, pack_id);
 
 	/* now look for inflight requests matching that mrq pack_id */
 	xa_lock_irqsave(&sfp->srp_arr, iflags);
@@ -4344,11 +4214,10 @@ sg_mrq_abort(struct sg_fd *sfp, int pack_id, bool dev_scope)
 }
 
 /*
- * Tries to abort an inflight request/command. First it checks the current fd
- * for a match on pack_id or tag. If there is a match, aborts that match.
- * Otherwise, if SGV4_FLAG_DEV_SCOPE is set, the rest of the file descriptors
- * belonging to the current device are similarly checked. If there is no match
- * then -ENODATA is returned.
+ * Tries to abort an inflight request/command. First it checks the current fd for a match on
+ * pack_id or tag. If there is a match, aborts that match. Otherwise, if SGV4_FLAG_DEV_SCOPE is
+ * set, the rest of the file descriptors belonging to the current device are similarly checked.
+ * If there is no match then -ENODATA is returned.
  */
 static int
 sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
@@ -4403,15 +4272,13 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 }
 
 /*
- * Check if search_for is a "char" device fd whose MAJOR is this driver.
- * If so filp->private_data must be the sfp we are looking for. Do further
- * checks (e.g. not already in a file share). If all is well set up cross
- * references and adjust xarray marks. Returns a sfp or negative errno
- * twisted by ERR_PTR().
+ * Check if search_for is a "char" device fd whose MAJOR is this driver. If so filp->private_data
+ * must be the sfp we are looking for. Do further checks (e.g. not already in a file share). If all
+ * is well set up cross references and adjust xarray marks. Returns a sfp or negative errno twisted
+ * by ERR_PTR().
  */
 static struct sg_fd *
-sg_find_sfp_by_fd(const struct file *search_for, struct sg_fd *from_sfp,
-		  bool is_reshare)
+sg_find_sfp_by_fd(const struct file *search_for, struct sg_fd *from_sfp, bool is_reshare)
 		__must_hold(&from_sfp->f_mutex)
 {
 	int res = 0;
@@ -4420,8 +4287,8 @@ sg_find_sfp_by_fd(const struct file *search_for, struct sg_fd *from_sfp,
 	struct sg_device *from_sdp = from_sfp->parentdp;
 	struct sg_device *sdp;
 
-	SG_LOG(6, from_sfp, "%s: enter,  from_sfp=%pK search_for=%pK\n",
-	       __func__, from_sfp, search_for);
+	SG_LOG(6, from_sfp, "%s: enter,  from_sfp=%pK search_for=%pK\n", __func__, from_sfp,
+	       search_for);
 	if (!(S_ISCHR(search_for->f_inode->i_mode) &&
 	      MAJOR(search_for->f_inode->i_rdev) == SCSI_GENERIC_MAJOR))
 		return ERR_PTR(-EBADF);
@@ -4446,8 +4313,7 @@ sg_find_sfp_by_fd(const struct file *search_for, struct sg_fd *from_sfp,
 	rcu_assign_pointer(from_sfp->share_sfp, sfp);
 	__xa_clear_mark(&from_sdp->sfp_arr, from_sfp->idx, SG_XA_FD_UNSHARED);
 	if (is_reshare)	/* reshare case: no kref_get() on read-side */
-		__xa_set_mark(&from_sdp->sfp_arr, from_sfp->idx,
-			      SG_XA_FD_RS_SHARE);
+		__xa_set_mark(&from_sdp->sfp_arr, from_sfp->idx, SG_XA_FD_RS_SHARE);
 	else
 		kref_get(&from_sfp->f_ref);  /* undone: sg_unshare_*_fd() */
 	if (from_sdp != sdp) {
@@ -4466,9 +4332,9 @@ sg_find_sfp_by_fd(const struct file *search_for, struct sg_fd *from_sfp,
 }
 
 /*
- * After checking the proposed read-side/write-side relationship is unique and valid,
- * sets up pointers between read-side and write-side sg_fd objects. Returns 0 on
- * success or negated errno value. From ioctl(EXTENDED(SG_SEIM_SHARE_FD)).
+ * After checking the proposed read-side/write-side relationship is unique and valid, sets up
+ * pointers between read-side and write-side sg_fd objects. Returns 0 on success or negated errno
+ * value. From ioctl(EXTENDED(SG_SEIM_SHARE_FD)).
  */
 static int
 sg_fd_share(struct sg_fd *ws_sfp, int m_fd)
@@ -4495,8 +4361,7 @@ sg_fd_share(struct sg_fd *ws_sfp, int m_fd)
 		res = -ELOOP;
 		goto fini;
 	}
-	SG_LOG(6, ws_sfp, "%s: read-side fd okay, scan for filp=0x%pK\n",
-	       __func__, filp);
+	SG_LOG(6, ws_sfp, "%s: read-side fd okay, scan for filp=0x%pK\n", __func__, filp);
 	rs_sfp = sg_find_sfp_by_fd(filp, ws_sfp, false);
 	if (!IS_ERR(rs_sfp))
 		found = !!rs_sfp;
@@ -4509,10 +4374,9 @@ sg_fd_share(struct sg_fd *ws_sfp, int m_fd)
 }
 
 /*
- * After checking the proposed file share relationship is unique and
- * valid, sets up pointers between read-side and write-side sg_fd objects. Allows
- * previous write-side to be the same as the new write-side (fd). Return 0 on success
- * or negated errno value.
+ * After checking the proposed file share relationship is unique and valid, sets up pointers
+ * between read-side and write-side sg_fd objects. Allows previous write-side to be the same as
+ * the new write-side (fd). Return 0 on success or negated errno value.
  */
 static int
 sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
@@ -4528,8 +4392,7 @@ sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
 		return -EACCES;
 	if (unlikely(new_ws_fd < 0))
 		return -EBADF;
-	if (unlikely(!xa_get_mark(&rs_sfp->parentdp->sfp_arr, rs_sfp->idx,
-				  SG_XA_FD_RS_SHARE)))
+	if (unlikely(!xa_get_mark(&rs_sfp->parentdp->sfp_arr, rs_sfp->idx, SG_XA_FD_RS_SHARE)))
 		res = -EINVAL;	/* invalid unless prev_sl==new_sl */
 
 	/* Alternate approach: fcheck_files(current->files, m_fd) */
@@ -4547,8 +4410,7 @@ sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
 		}	/* else it is invalid and res is still -EINVAL */
 		goto fini;
 	}
-	SG_LOG(6, ws_sfp, "%s: write-side fd ok, scan for filp=0x%pK\n", __func__,
-	       filp);
+	SG_LOG(6, ws_sfp, "%s: write-side fd ok, scan for filp=0x%pK\n", __func__, filp);
 	sg_unshare_ws_fd(ws_sfp, true);
 	ws_sfp = sg_find_sfp_by_fd(filp, rs_sfp, true);
 	if (!IS_ERR(ws_sfp))
@@ -4586,12 +4448,11 @@ sg_eventfd_new(struct sg_fd *rs_sfp, int eventfd)
 }
 
 /*
- * First normalize want_rsv_sz to be >= sfp->sgat_elem_sz and
- * <= max_segment_size. Exit if that is the same as old size; otherwise
- * create a new candidate request of the new size. Then decide whether to
- * re-use an existing inactive request (least buflen >= required size) or
- * use the new candidate. If new one used, leave old one but it is no longer
- * the reserved request. Returns 0 on success, else a negated errno value.
+ * First normalize want_rsv_sz to be >= sfp->sgat_elem_sz and <= max_segment_size. Exit if that is
+ * the same as old size; otherwise create a new candidate request of the new size. Then decide
+ * whether to re-use an existing inactive request (least buflen >= required size) or use the new
+ * candidate. If new one used, leave old one but it is no longer the reserved request. Returns 0
+ * on success, else a negated errno value.
  */
 static int
 sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
@@ -4613,9 +4474,8 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 		return -EBUSY;	/* this fd can't be either side of share */
 	new_sz = min_t(int, want_rsv_sz, sdp->max_sgat_sz);
 	new_sz = max_t(int, new_sz, sfp->sgat_elem_sz);
-	SG_LOG(3, sfp, "%s: was=%d, ask=%d, new=%d (sgat_elem_sz=%d)\n",
-	       __func__, *rapp ? (*rapp)->sgatp->buflen : -1,
-	       want_rsv_sz, new_sz, sfp->sgat_elem_sz);
+	SG_LOG(3, sfp, "%s: was=%d, ask=%d, new=%d (sgat_elem_sz=%d)\n", __func__,
+	       *rapp ? (*rapp)->sgatp->buflen : -1, want_rsv_sz, new_sz, sfp->sgat_elem_sz);
 	if (unlikely(sfp->mmap_sz > 0))
 		return -EBUSY;	/* existing pages possibly pinned */
 
@@ -4657,26 +4517,22 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 			xa_lock_irqsave(xafp, iflags);
 			n_srp->rq_idx = o_srp->rq_idx;
 			idx = o_srp->rq_idx;
-			cxc_srp = __xa_cmpxchg(xafp, idx, o_srp, n_srp,
-					       GFP_ATOMIC);
+			cxc_srp = __xa_cmpxchg(xafp, idx, o_srp, n_srp, GFP_ATOMIC);
 			if (o_srp == cxc_srp) {
 				__assign_bit(SG_FRQ_RESERVED, n_srp->frq_bm,
-					     test_bit(SG_FRQ_RESERVED,
-						      o_srp->frq_bm));
+					     test_bit(SG_FRQ_RESERVED, o_srp->frq_bm));
 				*rapp = n_srp;
 				sg_rq_chg_state_force_ulck(n_srp, SG_RQ_INACTIVE);
 				/* no bump of sfp->inactives since replacement */
 				xa_unlock_irqrestore(xafp, iflags);
-				SG_LOG(6, sfp, "%s: new rsv srp=0x%pK ++\n",
-				       __func__, n_srp);
+				SG_LOG(6, sfp, "%s: new rsv srp=0x%pK ++\n", __func__, n_srp);
 				n_srp = NULL;
 				sg_remove_srp(o_srp);
 				kfree(o_srp);
 				o_srp = NULL;
 			} else {
 				xa_unlock_irqrestore(xafp, iflags);
-				SG_LOG(1, sfp, "%s: xa_cmpxchg()-->retry\n",
-				       __func__);
+				SG_LOG(1, sfp, "%s: xa_cmpxchg()-->retry\n", __func__);
 				goto try_again;
 			}
 		}
@@ -4702,8 +4558,7 @@ struct compat_sg_req_info { /* used by SG_GET_REQUEST_TABLE ioctl() */
 	int unused;
 };
 
-static int put_compat_request_table(struct compat_sg_req_info __user *o,
-				    struct sg_req_info *rinfo)
+static int put_compat_request_table(struct compat_sg_req_info __user *o, struct sg_req_info *rinfo)
 {
 	int i;
 
@@ -4738,11 +4593,9 @@ sg_any_persistent_orphans(struct sg_fd *sfp)
 
 /*
  * Will clear_first if size already over half of available buffer.
- *
- * N.B. This function is a useful debug aid to be called inline with its
- * output going to /sys/kernel/debug/scsi_generic/snapped for later
- * examination. Best to call it with no locks held and that implies that
- * the driver state may change while it is processing. Interpret the
+ * N.B. This function is a useful debug aid to be called inline with its output going to
+ * /sys/kernel/debug/scsi_generic/snapped for later examination. Best to call it with no locks
+ * held and that implies that the driver state may change while it is processing. Interpret the
  * result with this in mind.
  */
 static void
@@ -4762,13 +4615,11 @@ sg_take_snap(struct sg_fd *sfp, bool clear_first)
 	second = (u32)do_div(n, 60);
 	minute = (u32)do_div(n, 60);
 	hour = (u32)do_div(n, 24);	/* hour within a UTC day */
-	snprintf(b, sizeof(b), "UTC time: %.2u:%.2u:%.2u:%.6u [tid=%d]",
-		 hour, minute, second, (u32)ts64.tv_nsec / 1000,
-		 (current ? current->pid : -1));
+	snprintf(b, sizeof(b), "UTC time: %.2u:%.2u:%.2u:%.6u [tid=%d]", hour, minute, second,
+		 (u32)ts64.tv_nsec / 1000, (current ? current->pid : -1));
 	mutex_lock(&snapped_mutex);
 	if (!snapped_buf) {
-		snapped_buf = kzalloc(SG_SNAP_BUFF_SZ,
-				      GFP_KERNEL | __GFP_NOWARN);
+		snapped_buf = kzalloc(SG_SNAP_BUFF_SZ, GFP_KERNEL | __GFP_NOWARN);
 		if (!snapped_buf)
 			goto fini;
 	} else if (clear_first) {
@@ -4801,9 +4652,9 @@ sg_take_snap(struct sg_fd *sfp, bool clear_first)
 }
 
 /*
- * Processing of ioctl(SG_SET_GET_EXTENDED(SG_SEIM_CTL_FLAGS)) which is a set
- * of boolean flags. Access abbreviations: [rw], read-write; [ro], read-only;
- * [wo], write-only; [raw], read after write; [rbw], read before write.
+ * Processing of ioctl(SG_SET_GET_EXTENDED(SG_SEIM_CTL_FLAGS)) which is a set of boolean flags.
+ * Access abbreviations: [rw], read-write; [ro], read-only; [wo], write-only; [raw], read after
+ * write; [rbw], read before write.
  */
 static int
 sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
@@ -4852,8 +4703,7 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 	}
 	/* Q_TAIL boolean, [raw] 1: queue at tail; 0: head (def: depends) */
 	if (c_flgs_wm & SG_CTL_FLAGM_Q_TAIL)
-		assign_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm,
-			   !!(c_flgs_val_in & SG_CTL_FLAGM_Q_TAIL));
+		assign_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm, !!(c_flgs_val_in & SG_CTL_FLAGM_Q_TAIL));
 	if (c_flgs_rm & SG_CTL_FLAGM_Q_TAIL) {
 		if (test_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm))
 			c_flgs_val_out |= SG_CTL_FLAGM_Q_TAIL;
@@ -4861,10 +4711,9 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 			c_flgs_val_out &= ~SG_CTL_FLAGM_Q_TAIL;
 	}
 	/*
-	 * UNSHARE boolean: when reading yields zero. When writing true,
-	 * unshares this fd from a previously established fd share. If
-	 * a shared commands is inflight, waits a little while for it
-	 * to finish.
+	 * UNSHARE boolean: when reading yields zero. When writing true, unshares this fd from a
+	 * previously established fd share. If a shared commands is inflight, waits a little
+	 * while for it to finish.
 	 */
 	if (c_flgs_wm & SG_CTL_FLAGM_UNSHARE) {
 		mutex_lock(&sfp->f_mutex);
@@ -4888,9 +4737,9 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 			c_flgs_val_out &= ~SG_CTL_FLAGM_IS_READ_SIDE;
 	}
 	/*
-	 * READ_SIDE_FINI boolean, [rbw] should be called by write-side; when
-	 * reading: read-side is finished, awaiting action by write-side;
-	 * when written: 1 --> write-side doesn't want to continue
+	 * READ_SIDE_FINI boolean, [rbw] should be called by write-side; when reading: read-side
+	 * is finished, awaiting action by write-side; when written: 1 --> write-side doesn't
+	 * want to continue
 	 */
 	if ((c_flgs_rm & SG_CTL_FLAGM_READ_SIDE_FINI) && sg_fd_is_shared(sfp)) {
 		struct sg_fd *rs_sfp = sg_fd_share_ptr(sfp);
@@ -5010,16 +4859,14 @@ sg_extended_read_value(struct sg_fd *sfp, struct sg_extended_info *seip)
 		break;
 	case SG_SEIRV_INACT_RQS:
 		uv = 0;
-		xa_for_each_marked(&sfp->srp_arr, idx, srp,
-				   SG_XA_RQ_INACTIVE)
+		xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_INACTIVE)
 			++uv;
 		seip->read_value = uv;
 		break;
 	case SG_SEIRV_DEV_INACT_RQS:
 		uv = 0;
 		xa_for_each(&sdp->sfp_arr, idx2, a_sfp) {
-			xa_for_each_marked(&a_sfp->srp_arr, idx, srp,
-					   SG_XA_RQ_INACTIVE)
+			xa_for_each_marked(&a_sfp->srp_arr, idx, srp, SG_XA_RQ_INACTIVE)
 				++uv;
 		}
 		seip->read_value = uv;
@@ -5043,8 +4890,7 @@ sg_extended_read_value(struct sg_fd *sfp, struct sg_extended_info *seip)
 		seip->read_value = (sfp->parentdp->create_ns >> 32) & U32_MAX;
 		break;
 	default:
-		SG_LOG(6, sfp, "%s: can't decode %d --> read_value\n",
-		       __func__, seip->read_value);
+		SG_LOG(6, sfp, "%s: can't decode %d --> read_value\n", __func__, seip->read_value);
 		seip->read_value = 0;
 		break;
 	}
@@ -5072,8 +4918,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 		SG_LOG(2, sfp, "%s: both masks 0, do nothing\n", __func__);
 		return 0;
 	}
-	SG_LOG(3, sfp, "%s: wr_mask=0x%x rd_mask=0x%x\n", __func__, s_wr_mask,
-	       s_rd_mask);
+	SG_LOG(3, sfp, "%s: wr_mask=0x%x rd_mask=0x%x\n", __func__, s_wr_mask, s_rd_mask);
 	/* tot_fd_thresh (u32), [rbw] [limit for sum of active cmd dlen_s] */
 	if (or_masks & SG_SEIM_TOT_FD_THRESH) {
 		u32 hold = sfp->tot_fd_thresh;
@@ -5114,8 +4959,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 		if (s_rd_mask & SG_SEIM_SHARE_FD) {
 			struct sg_fd *sh_sfp = sg_fd_share_ptr(sfp);
 
-			seip->share_fd = sh_sfp ? sh_sfp->parentdp->index :
-						  U32_MAX;
+			seip->share_fd = sh_sfp ? sh_sfp->parentdp->index : U32_MAX;
 		}
 		mutex_unlock(&sfp->f_mutex);
 	}
@@ -5131,8 +4975,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 		if (s_rd_mask & SG_SEIM_CHG_SHARE_FD) {
 			struct sg_fd *sh_sfp = sg_fd_share_ptr(sfp);
 
-			seip->share_fd = sh_sfp ? sh_sfp->parentdp->index :
-						  U32_MAX;
+			seip->share_fd = sh_sfp ? sh_sfp->parentdp->index : U32_MAX;
 		}
 		mutex_unlock(&sfp->f_mutex);
 	}
@@ -5166,9 +5009,8 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 		if (s_wr_mask & SG_SEIM_SGAT_ELEM_SZ) {
 			j = (int)seip->sgat_elem_sz;
 			if (!is_power_of_2(j) || j < (int)PAGE_SIZE) {
-				SG_LOG(1, sfp, "%s: %s not power of 2, %s\n",
-				       __func__, "sgat element size",
-				       "or less than PAGE_SIZE");
+				SG_LOG(1, sfp, "%s: sgat element size not power of 2, %s\n",
+				       __func__, "or less than PAGE_SIZE");
 				ret = -EINVAL;
 			} else {
 				sfp->sgat_elem_sz = j;
@@ -5188,8 +5030,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 	if (s_rd_mask & SG_SEIM_RESERVED_SIZE) {
 		struct sg_request *r_srp = sfp->rsv_arr[0];
 
-		seip->reserved_sz = (u32)min_t(int, r_srp->sgatp->buflen,
-					       sdp->max_sgat_sz);
+		seip->reserved_sz = (u32)min_t(int, r_srp->sgatp->buflen, sdp->max_sgat_sz);
 	}
 	/* copy to user space if int or boolean read mask non-zero */
 	if (s_rd_mask || seip->ctl_flags_rd_mask) {
@@ -5200,10 +5041,9 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 }
 
 /*
- * For backward compatibility, output SG_MAX_QUEUE sg_req_info objects. First
- * fetch from the active list then, if there is still room, from the free
- * list. Some of the trailing elements may be empty which is indicated by all
- * fields being zero. Any requests beyond SG_MAX_QUEUE are ignored.
+ * For backward compatibility, output SG_MAX_QUEUE sg_req_info objects. First fetch from the active
+ * list then, if there is still room, from the free list. Some of the trailing elements may be
+ * empty which is indicated by all fields being zero. Any requests beyond SG_MAX_QUEUE are ignored.
  */
 static int
 sg_ctl_req_tbl(struct sg_fd *sfp, void __user *p)
@@ -5240,11 +5080,9 @@ sg_ctl_req_tbl(struct sg_fd *sfp, void __user *p)
 	if (in_compat_syscall())
 		result = put_compat_request_table(p, rinfop);
 	else
-		result = copy_to_user(p, rinfop,
-				      SZ_SG_REQ_INFO * SG_MAX_QUEUE);
+		result = copy_to_user(p, rinfop, SZ_SG_REQ_INFO * SG_MAX_QUEUE);
 #else
-	result = copy_to_user(p, rinfop,
-			      SZ_SG_REQ_INFO * SG_MAX_QUEUE);
+	result = copy_to_user(p, rinfop, SZ_SG_REQ_INFO * SG_MAX_QUEUE);
 #endif
 	kfree(rinfop);
 	return result > 0 ? -EFAULT : result;	/* treat short copy as error */
@@ -5273,8 +5111,8 @@ sg_ctl_scsi_id(struct scsi_device *sdev, struct sg_fd *sfp, void __user *p)
 }
 
 static long
-sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
-		unsigned int cmd_in, void __user *p)
+sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp, unsigned int cmd_in,
+		void __user *p)
 {
 	bool read_only = O_RDWR != (filp->f_flags & O_ACCMODE);
 	int val;
@@ -5352,16 +5190,14 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	case SG_GET_PACK_ID:    /* or tag of oldest "read"-able, -1 if none */
 		val = -1;
 		if (test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm)) {
-			xa_for_each_marked(&sfp->srp_arr, idx, srp,
-					   SG_XA_RQ_AWAIT) {
+			xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
 				if (!test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm)) {
 					val = srp->tag;
 					break;
 				}
 			}
 		} else {
-			xa_for_each_marked(&sfp->srp_arr, idx, srp,
-					   SG_XA_RQ_AWAIT) {
+			xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
 				if (!test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm)) {
 					val = srp->pack_id;
 					break;
@@ -5371,8 +5207,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		SG_LOG(3, sfp, "%s:    SG_GET_PACK_ID=%d\n", __func__, val);
 		return put_user(val, ip);
 	case SG_GET_SG_TABLESIZE:
-		SG_LOG(3, sfp, "%s:    SG_GET_SG_TABLESIZE=%d\n", __func__,
-		       sdp->max_sgat_elems);
+		SG_LOG(3, sfp, "%s:    SG_GET_SG_TABLESIZE=%d\n", __func__, sdp->max_sgat_elems);
 		return put_user(sdp->max_sgat_elems, ip);
 	case SG_SET_RESERVED_SIZE:
 		res = get_user(val, ip);
@@ -5389,16 +5224,12 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		return res;
 	case SG_GET_RESERVED_SIZE:
 		{
-			struct sg_request *r_srp = sfp->rsv_arr[0];
-
 			mutex_lock(&sfp->f_mutex);
-			val = min_t(int, r_srp->sgatp->buflen,
-				    sdp->max_sgat_sz);
+			val = min_t(int, sfp->rsv_arr[0]->sgatp->buflen, sdp->max_sgat_sz);
 			mutex_unlock(&sfp->f_mutex);
 			res = put_user(val, ip);
 		}
-		SG_LOG(3, sfp, "%s:    SG_GET_RESERVED_SIZE=%d\n", __func__,
-		       val);
+		SG_LOG(3, sfp, "%s:    SG_GET_RESERVED_SIZE=%d\n", __func__, val);
 		return res;
 	case SG_SET_COMMAND_Q:	/* set by driver whenever v3 or v4 req seen */
 		SG_LOG(3, sfp, "%s:    SG_SET_COMMAND_Q\n", __func__);
@@ -5419,8 +5250,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		return 0;
 	case SG_GET_KEEP_ORPHAN:
 		SG_LOG(3, sfp, "%s:    SG_GET_KEEP_ORPHAN\n", __func__);
-		return put_user(test_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm),
-				ip);
+		return put_user(test_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm), ip);
 	case SG_GET_VERSION_NUM:
 		SG_LOG(3, sfp, "%s:    SG_GET_VERSION_NUM\n", __func__);
 		return put_user(sg_version_num, ip);
@@ -5437,20 +5267,18 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		if (unlikely(val < 0))
 			return -EIO;
 		if (val >= mult_frac((s64)INT_MAX, USER_HZ, HZ))
-			val = min_t(s64, mult_frac((s64)INT_MAX, USER_HZ, HZ),
-				    INT_MAX);
+			val = min_t(s64, mult_frac((s64)INT_MAX, USER_HZ, HZ), INT_MAX);
 		sfp->timeout_user = val;
 		sfp->timeout = mult_frac(val, HZ, USER_HZ);
 		return 0;
-	case SG_GET_TIMEOUT:    /* N.B. User receives timeout as return value */
-				/* strange ..., for backward compatibility */
+	case SG_GET_TIMEOUT:
+		/* N.B. User receives timeout as return value, keep for backward compatibility */
 		SG_LOG(3, sfp, "%s:    SG_GET_TIMEOUT\n", __func__);
 		return sfp->timeout_user;
 	case SG_SET_FORCE_LOW_DMA:
 		/*
-		 * N.B. This ioctl never worked properly, but failed to
-		 * return an error value. So returning '0' to keep
-		 * compatibility with legacy applications.
+		 * N.B. This ioctl never worked properly, but failed to return an error value. So
+		 * returning '0' to keep compatibility with legacy applications.
 		 */
 		SG_LOG(3, sfp, "%s:    SG_SET_FORCE_LOW_DMA\n", __func__);
 		return 0;
@@ -5480,8 +5308,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		return put_user(sdev->host->hostt->emulated, ip);
 	case SCSI_IOCTL_SEND_COMMAND:
 		SG_LOG(3, sfp, "%s:    SCSI_IOCTL_SEND_COMMAND\n", __func__);
-		return sg_scsi_ioctl(sdev->request_queue, NULL, filp->f_mode,
-				     p);
+		return sg_scsi_ioctl(sdev->request_queue, NULL, filp->f_mode, p);
 	case SG_SET_DEBUG:
 		SG_LOG(3, sfp, "%s:    SG_SET_DEBUG\n", __func__);
 		res = get_user(val, ip);
@@ -5496,10 +5323,8 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		return put_user(max_sectors_bytes(sdev->request_queue), ip);
 	case BLKTRACESETUP:
 		SG_LOG(3, sfp, "%s:    BLKTRACESETUP\n", __func__);
-		return blk_trace_setup(sdev->request_queue,
-				       sdp->disk->disk_name,
-				       MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
-				       NULL, p);
+		return blk_trace_setup(sdev->request_queue, sdp->disk->disk_name,
+				       MKDEV(SCSI_GENERIC_MAJOR, sdp->index), NULL, p);
 	case BLKTRACESTART:
 		SG_LOG(3, sfp, "%s:    BLKTRACESTART\n", __func__);
 		return blk_trace_startstop(sdev->request_queue, 1);
@@ -5510,23 +5335,19 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		SG_LOG(3, sfp, "%s:    BLKTRACETEARDOWN\n", __func__);
 		return blk_trace_remove(sdev->request_queue);
 	case SCSI_IOCTL_GET_IDLUN:
-		SG_LOG(3, sfp, "%s:    SCSI_IOCTL_GET_IDLUN %s\n", __func__,
-		       pmlp);
+		SG_LOG(3, sfp, "%s:    SCSI_IOCTL_GET_IDLUN %s\n", __func__, pmlp);
 		break;
 	case SCSI_IOCTL_GET_BUS_NUMBER:
-		SG_LOG(3, sfp, "%s:    SCSI_IOCTL_GET_BUS_NUMBER%s\n",
-		       __func__, pmlp);
+		SG_LOG(3, sfp, "%s:    SCSI_IOCTL_GET_BUS_NUMBER%s\n", __func__, pmlp);
 		break;
 	case SCSI_IOCTL_PROBE_HOST:
-		SG_LOG(3, sfp, "%s:    SCSI_IOCTL_PROBE_HOST%s",
-		       __func__, pmlp);
+		SG_LOG(3, sfp, "%s:    SCSI_IOCTL_PROBE_HOST%s", __func__, pmlp);
 		break;
 	case SG_GET_TRANSFORM:
 		SG_LOG(3, sfp, "%s:    SG_GET_TRANSFORM%s\n", __func__, pmlp);
 		break;
 	default:
-		SG_LOG(3, sfp, "%s:    unrecognized ioctl [0x%x]%s\n",
-		       __func__, cmd_in, pmlp);
+		SG_LOG(3, sfp, "%s:    unrecognized ioctl [0x%x]%s\n", __func__, cmd_in, pmlp);
 		if (read_only)
 			return -EPERM;	/* don't know, so take safer approach */
 		break;
@@ -5643,10 +5464,7 @@ sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count)
 	return res;
 }
 
-/*
- * Implements the poll(2) system call for this driver. Returns various EPOLL*
- * flags OR-ed together.
- */
+/* Implements the poll(2) system call. Returns various EPOLL* flags OR-ed together. */
 static __poll_t
 sg_poll(struct file *filp, poll_table *wait)
 {
@@ -5746,12 +5564,10 @@ sg_vma_fault(struct vm_fault *vmf)
 	rsv_schp = srp->sgatp;
 	offset = vmf->pgoff << PAGE_SHIFT;
 	if (unlikely(offset >= (unsigned int)rsv_schp->buflen)) {
-		SG_LOG(1, sfp, "%s: offset[%lu] >= rsv.buflen\n", __func__,
-		       offset);
+		SG_LOG(1, sfp, "%s: offset[%lu] >= rsv.buflen\n", __func__, offset);
 		goto out_err_unlock;
 	}
-	SG_LOG(5, sfp, "%s: vm_start=0x%lx, off=%lu\n", __func__,
-	       vma->vm_start, offset);
+	SG_LOG(5, sfp, "%s: vm_start=0x%lx, off=%lu\n", __func__, vma->vm_start, offset);
 	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
 	k = (int)offset / length;
 	n = ((int)offset % length) >> PAGE_SHIFT;
@@ -5772,9 +5588,8 @@ static const struct vm_operations_struct sg_mmap_vm_ops = {
 };
 
 /*
- * Entry point for mmap(2) system call. For mmap(2) to work, request's
- * scatter gather list needs to be order 0 which it is unlikely to be
- * by default. mmap(2) cannot be called more than once per fd.
+ * Entry point for mmap(2) system call. For mmap(2) to work, request's scatter gather list needs
+ * to be order 0 which it is unlikely to be by default. mmap(2) calls cannot overlap on this fd.
  */
 static int
 sg_mmap(struct file *filp, struct vm_area_struct *vma)
@@ -5794,8 +5609,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	if (unlikely(!mutex_trylock(&sfp->f_mutex)))
 		return -EBUSY;
 	req_sz = vma->vm_end - vma->vm_start;
-	SG_LOG(3, sfp, "%s: vm_start=%pK, len=%d\n", __func__,
-	       (void *)vma->vm_start, (int)req_sz);
+	SG_LOG(3, sfp, "%s: vm_start=%pK, len=%d\n", __func__, (void *)vma->vm_start, (int)req_sz);
 	if (unlikely(vma->vm_pgoff || req_sz < SG_DEF_SECTOR_SZ)) {
 		res = -EINVAL; /* only an offset of 0 accepted */
 		goto fini;
@@ -5811,19 +5625,16 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 		goto fini;
 	}
 	if (sfp->mmap_sz > 0) {
-		SG_LOG(1, sfp, "%s: multiple invocations on this fd\n",
-		       __func__);
+		SG_LOG(1, sfp, "%s: multiple invocations on this fd\n", __func__);
 		res = -EADDRINUSE;
 		goto fini;
 	}
-	if (srp->sgat_h.page_order > 0 ||
-	    req_sz > (unsigned long)srp->sgat_h.buflen) {
+	if (srp->sgat_h.page_order > 0 || req_sz > (unsigned long)srp->sgat_h.buflen) {
 		sg_remove_srp(srp);
 		set_bit(SG_FRQ_FOR_MMAP, srp->frq_bm);
 		res = sg_mk_sgat(srp, sfp, req_sz);
 		if (res) {
-			SG_LOG(1, sfp, "%s: sg_mk_sgat failed, wanted=%lu\n",
-			       __func__, req_sz);
+			SG_LOG(1, sfp, "%s: sg_mk_sgat failed, wanted=%lu\n", __func__, req_sz);
 			goto fini;
 		}
 	}
@@ -5838,15 +5649,13 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 }
 
 /*
- * This user context function is called from sg_rq_end_io() when an orphaned
- * request needs to be cleaned up (e.g. when control C is typed while an
- * ioctl(SG_IO) is active).
+ * This user context function is called from sg_rq_end_io() when an orphaned request needs to be
+ * cleaned up (e.g. when control C is typed while an ioctl(SG_IO) is active).
  */
 static void
 sg_uc_rq_end_io_orphaned(struct work_struct *work)
 {
-	struct sg_request *srp = container_of(work, struct sg_request,
-					      ew_orph.work);
+	struct sg_request *srp = container_of(work, struct sg_request, ew_orph.work);
 	struct sg_fd *sfp;
 
 	sfp = srp->parentfp;
@@ -5863,10 +5672,9 @@ sg_uc_rq_end_io_orphaned(struct work_struct *work)
 }
 
 /*
- * This "bottom half" (soft interrupt) handler is called by the mid-level
- * when a request has completed or failed. This callback is registered in a
- * blk_execute_rq_nowait() call in the sg_common_write(). For ioctl(SG_IO)
- * (sync) usage, sg_ctl_sg_io() waits to be woken up by this callback.
+ * This "bottom half" (soft interrupt) handler is called by the mid-level when a request has
+ * completed or failed. This callback is registered in a blk_execute_rq_nowait() call in the
+ * sg_common_write(). For ioctl(SG_IO) (sync) usage, sg_ctl_sg_io() awaits this callback.
  */
 static void
 sg_rq_end_io(struct request *rqq, blk_status_t status)
@@ -5901,11 +5709,10 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	if (unlikely(test_bit(SG_FRQ_ABORTING, srp->frq_bm)) && sg_result_is_good(rq_result))
 		srp->rq_result |= (DRIVER_HARD << 24);
 
-	SG_LOG(6, sfp, "%s: pack/tag_id=%d/%d, cmd=0x%x, res=0x%x\n", __func__,
-	       srp->pack_id, srp->tag, srp->cmd_opcode, srp->rq_result);
+	SG_LOG(6, sfp, "%s: pack/tag_id=%d/%d, cmd=0x%x, res=0x%x\n", __func__, srp->pack_id,
+	       srp->tag, srp->cmd_opcode, srp->rq_result);
 	if (srp->start_ns > 0)	/* zero only when SG_FFD_NO_DURATION is set */
-		srp->duration = sg_calc_rq_dur(srp, test_bit(SG_FFD_TIME_IN_NS,
-							     sfp->ffd_bm));
+		srp->duration = sg_calc_rq_dur(srp, test_bit(SG_FFD_TIME_IN_NS, sfp->ffd_bm));
 	if (unlikely(!sg_result_is_good(rq_result) && slen > 0 &&
 		     test_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm))) {
 		if ((rq_result & 0xfe) == SAM_STAT_CHECK_CONDITION ||
@@ -5914,9 +5721,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	}
 	if (unlikely(slen > 0)) {
 		if (likely(scsi_rp->sense && !srp->sense_bp)) {
-			srp->sense_bp =
-				mempool_alloc(sg_sense_pool,
-					      GFP_ATOMIC   /* <-- leave */);
+			srp->sense_bp = mempool_alloc(sg_sense_pool, GFP_ATOMIC /* <-- leave */);
 			if (likely(srp->sense_bp)) {
 				memcpy(srp->sense_bp, scsi_rp->sense, slen);
 				if (slen < SCSI_SENSE_BUFFERSIZE)
@@ -5924,8 +5729,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 					       SCSI_SENSE_BUFFERSIZE - slen);
 			} else {
 				slen = 0;
-				pr_warn("%s: sense but can't alloc buffer\n",
-					__func__);
+				pr_warn("%s: sense but can't alloc buffer\n", __func__);
 			}
 		} else if (unlikely(srp->sense_bp)) {
 			slen = 0;
@@ -5963,8 +5767,8 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	}
 	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 	/*
-	 * Free the mid-level resources apart from the bio (if any). The bio's
-	 * blk_rq_unmap_user() can be called later from user context.
+	 * Free the mid-level resources apart from the bio (if any). The bio's blk_rq_unmap_user()
+	 * can be called later from user context.
 	 */
 	scsi_req_free_cmd(scsi_rp);
 	blk_put_request(rqq);
@@ -5978,15 +5782,13 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	}
 	if (!(srp->rq_flags & SGV4_FLAG_HIPRI))
 		wake_up_interruptible(&sfp->cmpl_wait);
-	if (sfp->async_qp && (!SG_IS_V4I(srp) ||
-			      (srp->rq_flags & SGV4_FLAG_SIGNAL)))
+	if (sfp->async_qp && (!SG_IS_V4I(srp) || (srp->rq_flags & SGV4_FLAG_SIGNAL)))
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
 	if (sfp->efd_ctxp && (srp->rq_flags & SGV4_FLAG_EVENTFD)) {
 		u64 n = eventfd_signal(sfp->efd_ctxp, 1);
 
 		if (n != 1)
-			pr_info("%s: srp=%pK eventfd_signal problem\n",
-				__func__, srp);
+			pr_info("%s: srp=%pK eventfd_signal problem\n", __func__, srp);
 	}
 	kref_put(&sfp->f_ref, sg_remove_sfp);	/* get in: sg_execute_cmd() */
 }
@@ -6030,21 +5832,19 @@ sg_add_device_helper(struct gendisk *disk, struct scsi_device *scsidp)
 	error = idr_alloc(&sg_index_idr, sdp, 0, SG_MAX_DEVS, GFP_NOWAIT);
 	if (unlikely(error < 0)) {
 		if (error == -ENOSPC) {
-			sdev_printk(KERN_WARNING, scsidp,
-				    "Unable to attach sg device type=%d, minor number exceeds %d\n",
-				    scsidp->type, SG_MAX_DEVS - 1);
+			sdev_printk(KERN_WARNING, scsidp, "Can't attach sg device type=%d%s%d\n",
+				    scsidp->type, ", minor number exceeds ", SG_MAX_DEVS - 1);
 			error = -ENODEV;
 		} else {
-			sdev_printk(KERN_WARNING, scsidp,
-				"%s: idr allocation sg_device failure: %d\n",
+			sdev_printk(KERN_WARNING, scsidp, "%s: idr_alloc sg_device failure: %d\n",
 				    __func__, error);
 		}
 		goto out_unlock;
 	}
 	k = error;
 
-	SCSI_LOG_TIMEOUT(3, sdev_printk(KERN_INFO, scsidp,
-			 "%s: dev=%d, sdp=0x%pK ++\n", __func__, k, sdp));
+	SCSI_LOG_TIMEOUT(3, sdev_printk(KERN_INFO, scsidp, "%s: dev=%d, sdp=0x%pK ++\n", __func__,
+					k, sdp));
 	sprintf(disk->disk_name, "sg%d", k);
 	disk->first_minor = k;
 	sdp->disk = disk;
@@ -6111,27 +5911,26 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 		struct device *sg_class_member;
 
 		sg_class_member = device_create(sg_sysfs_class, cl_dev->parent,
-						MKDEV(SCSI_GENERIC_MAJOR,
-						      sdp->index),
+						MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
 						sdp, "%s", disk->disk_name);
 		if (IS_ERR(sg_class_member)) {
 			pr_err("%s: device_create failed\n", __func__);
 			error = PTR_ERR(sg_class_member);
 			goto cdev_add_err;
 		}
-		error = sysfs_create_link(&scsidp->sdev_gendev.kobj,
-					  &sg_class_member->kobj, "generic");
+		error = sysfs_create_link(&scsidp->sdev_gendev.kobj, &sg_class_member->kobj,
+					  "generic");
 		if (unlikely(error))
-			pr_err("%s: unable to make symlink 'generic' back "
-			       "to sg%d\n", __func__, sdp->index);
+			pr_err("%s: unable to make symlink 'generic' back to sg%d\n", __func__,
+			       sdp->index);
 	} else {
 		pr_warn("%s: sg_sys Invalid\n", __func__);
 	}
 
 	sdp->create_ns = ktime_get_boottime_ns();
 	sg_calc_sgat_param(sdp);
-	sdev_printk(KERN_NOTICE, scsidp, "Attached scsi generic sg%d "
-		    "type %d\n", sdp->index, scsidp->type);
+	sdev_printk(KERN_NOTICE, scsidp, "Attached scsi generic sg%d type %d\n", sdp->index,
+		    scsidp->type);
 
 	dev_set_drvdata(cl_dev, sdp);
 	return 0;
@@ -6156,12 +5955,10 @@ sg_device_destroy(struct kref *kref)
 	unsigned long iflags;
 
 	SCSI_LOG_TIMEOUT(1, pr_info("[tid=%d] %s: sdp idx=%d, sdp=0x%pK --\n",
-				    (current ? current->pid : -1), __func__,
-				    sdp->index, sdp));
+				    (current ? current->pid : -1), __func__, sdp->index, sdp));
 	/*
-	 * CAUTION!  Note that the device can still be found via idr_find()
-	 * even though the refcount is 0.  Therefore, do idr_remove() BEFORE
-	 * any other cleanup.
+	 * CAUTION!  Note that the device can still be found via idr_find() even though the
+	 * refcount is 0.  Therefore, do idr_remove() BEFORE any other cleanup.
 	 */
 
 	xa_destroy(&sdp->sfp_arr);
@@ -6188,8 +5985,7 @@ sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 		pr_warn("%s: multiple entries: sg%u\n", __func__, sdp->index);
 		return; /* only want to do following once per device */
 	}
-	SCSI_LOG_TIMEOUT(3, sdev_printk(KERN_INFO, sdp->device,
-					"%s: sg%u 0x%pK\n", __func__,
+	SCSI_LOG_TIMEOUT(3, sdev_printk(KERN_INFO, sdp->device, "%s: sg%u 0x%pK\n", __func__,
 					sdp->index, sdp));
 	xa_for_each(&sdp->sfp_arr, idx, sfp) {
 		wake_up_interruptible_all(&sfp->cmpl_wait);
@@ -6222,31 +6018,27 @@ init_sg(void)
 	else
 		def_reserved_size = sg_big_buff;
 
-	rc = register_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0),
-				    SG_MAX_DEVS, "sg");
+	rc = register_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), SG_MAX_DEVS, "sg");
 	if (unlikely(rc))
 		return rc;
 
-	sg_sense_cache = kmem_cache_create_usercopy
-				("sg_sense", SCSI_SENSE_BUFFERSIZE, 0,
-				 SLAB_HWCACHE_ALIGN, 0,
-				 SCSI_SENSE_BUFFERSIZE, NULL);
+	sg_sense_cache = kmem_cache_create_usercopy("sg_sense", SCSI_SENSE_BUFFERSIZE, 0,
+						    SLAB_HWCACHE_ALIGN, 0, SCSI_SENSE_BUFFERSIZE,
+						    NULL);
 	if (unlikely(!sg_sense_cache)) {
 		pr_err("sg: can't init sense cache\n");
 		rc = -ENOMEM;
 		goto err_out_unreg;
 	}
-	sg_sense_pool = mempool_create_slab_pool(SG_MEMPOOL_MIN_NR,
-						 sg_sense_cache);
+	sg_sense_pool = mempool_create_slab_pool(SG_MEMPOOL_MIN_NR, sg_sense_cache);
 	if (unlikely(!sg_sense_pool)) {
 		pr_err("sg: can't init sense pool\n");
 		rc = -ENOMEM;
 		goto err_out_cache;
 	}
 
-	pr_info("Registered %s[char major=0x%x], version: %s, date: %s\n",
-		"sg device ", SCSI_GENERIC_MAJOR, SG_VERSION_STR,
-		sg_version_date);
+	pr_info("Registered sg device [char major=0x%x], version: %s, date: %s\n",
+		SCSI_GENERIC_MAJOR, SG_VERSION_STR, sg_version_date);
 	sg_sysfs_class = class_create(THIS_MODULE, "scsi_generic");
 	if (IS_ERR(sg_sysfs_class)) {
 		rc = PTR_ERR(sg_sysfs_class);
@@ -6282,8 +6074,7 @@ exit_sg(void)
 	kmem_cache_destroy(sg_sense_cache);
 	class_destroy(sg_sysfs_class);
 	sg_sysfs_valid = false;
-	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0),
-				 SG_MAX_DEVS);
+	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), SG_MAX_DEVS);
 	idr_destroy(&sg_index_idr);
 }
 
@@ -6436,10 +6227,9 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	q = sdp->device->request_queue;
 
 	/*
-	 * For backward compatibility default to using blocking variant even
-	 * when in non-blocking (async) mode. If the SG_CTL_FLAGM_MORE_ASYNC
-	 * boolean set on this file descriptor, returns -EAGAIN if
-	 * blk_get_request(BLK_MQ_REQ_NOWAIT) yields EAGAIN (aka EWOULDBLOCK).
+	 * For backward compatibility default to using blocking variant even when in non-blocking
+	 * (async) mode. If the SG_CTL_FLAGM_MORE_ASYNC boolean set on this file descriptor,
+	 * returns -EAGAIN if blk_get_request(BLK_MQ_REQ_NOWAIT) yields EAGAIN (aka EWOULDBLOCK).
 	 */
 	rqq = blk_get_request(q, (r0w ? REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN),
 			      (test_bit(SG_FFD_MORE_ASYNC, sfp->ffd_bm) ?  BLK_MQ_REQ_NOWAIT : 0));
@@ -6460,8 +6250,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		long_cmdp = NULL;
 	}
 	if (cwrp->u_cmdp)
-		res = sg_fetch_cmnd(sfp, cwrp->u_cmdp, cwrp->cmd_len,
-				    scsi_rp->cmd);
+		res = sg_fetch_cmnd(sfp, cwrp->u_cmdp, cwrp->cmd_len, scsi_rp->cmd);
 	else if (likely(cwrp->cmdp))
 		memcpy(scsi_rp->cmd, cwrp->cmdp, cwrp->cmd_len);
 	else
@@ -6501,9 +6290,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 			if (unlikely(!reserve0 || dlen > req_schp->buflen))
 				res = reserve0 ? -ENOMEM : -EBUSY;
 		} else if (req_schp->buflen == 0) {
-			int up_sz = max_t(int, dlen, sfp->sgat_elem_sz);
-
-			res = sg_mk_sgat(srp, sfp, up_sz);
+			res = sg_mk_sgat(srp, sfp, max_t(int, dlen, sfp->sgat_elem_sz));
 		}
 		if (unlikely(res))
 			goto fini;
@@ -6539,8 +6326,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		res = blk_rq_map_user(q, rqq, md, up, dlen, GFP_ATOMIC);
 #if IS_ENABLED(SG_LOG_ACTIVE)
 		if (unlikely(res))
-			SG_LOG(1, sfp, "%s: blk_rq_map_user() res=%d\n",
-			       __func__, res);
+			SG_LOG(1, sfp, "%s: blk_rq_map_user() res=%d\n", __func__, res);
 #endif
 	} else {	/* transfer data to/from kernel buffers */
 		res = sg_rq_map_kern(srp, q, rqq, r0w);
@@ -6563,11 +6349,10 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 }
 
 /*
- * Clean up mid-level and block layer resources of finished request. Sometimes
- * blk_rq_unmap_user() returns -4 (-EINTR) and this is why: "If we're in a
- * workqueue, the request is orphaned, so don't copy into a random user
- * address space, just free and return -EINTR so user space doesn't expect
- * any data." [block/bio.c]
+ * Clean up mid-level and block layer resources of finished request. Sometimes blk_rq_unmap_user()
+ * returns -4 (-EINTR) and this is why: "If we're in a workqueue, the request is orphaned, so
+ * don't copy into a random user address space, just free and return -EINTR so user space doesn't
+ * expect any data." [block/bio.c]
  */
 static void
 sg_finish_scsi_blk_rq(struct sg_request *srp)
@@ -6577,8 +6362,8 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 	struct request *rqq = READ_ONCE(srp->rqq);
 	__maybe_unused char b[32];
 
-	SG_LOG(4, sfp, "%s: srp=0x%pK%s\n", __func__, srp,
-	       sg_get_rsv_str_lck(srp, " ", "", sizeof(b), b));
+	SG_LOG(4, sfp, "%s: srp=0x%pK%s\n", __func__, srp, sg_get_rsv_str_lck(srp, " ", "",
+									      sizeof(b), b));
 	if (test_and_clear_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
 		if (atomic_dec_and_test(&sfp->submitted))
 			clear_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
@@ -6599,11 +6384,8 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 		srp->bio = NULL;
 		if (us_xfer && bio) {
 			ret = blk_rq_unmap_user(bio);
-			if (unlikely(ret)) {	/* -EINTR (-4) can be ignored */
-				SG_LOG(6, sfp,
-				       "%s: blk_rq_unmap_user() --> %d\n",
-				       __func__, ret);
-			}
+			if (unlikely(ret))	/* -EINTR (-4) can be ignored */
+				SG_LOG(6, sfp, "%s: blk_rq_unmap_user() --> %d\n", __func__, ret);
 		}
 	}
 	/* In worst case, READ data returned to user space by this point */
@@ -6644,9 +6426,8 @@ sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen)
 	order = o_order;
 
 again:
-	if (elem_sz * mx_sgat_elems < align_sz) {	/* misfit ? */
-		SG_LOG(1, sfp, "%s: align_sz=%d too big\n", __func__,
-		       align_sz);
+	if (elem_sz * mx_sgat_elems < align_sz) {
+		SG_LOG(1, sfp, "%s: align_sz=%d too big\n", __func__, align_sz);
 		goto b4_alloc_pages;
 	}
 	rem_sz = align_sz;
@@ -6654,13 +6435,11 @@ sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen)
 		*pgp = alloc_pages(mask_ap, order);
 		if (unlikely(!*pgp))
 			goto err_out;
-		SG_LOG(6, sfp, "%s: elem_sz=%d [0x%pK ++]\n", __func__,
-		       elem_sz, *pgp);
+		SG_LOG(6, sfp, "%s: elem_sz=%d [0x%pK ++]\n", __func__, elem_sz, *pgp);
 	}
 	k = pgp - schp->pages;
 	SG_LOG(((order != o_order || rem_sz > 0) ? 2 : 5), sfp,
-	       "%s: num_sgat=%d, order=%d,%d  rem_sz=%d\n", __func__, k,
-	       o_order, order, rem_sz);
+	       "%s: num_sgat=%d, order=%d,%d  rem_sz=%d\n", __func__, k, o_order, order, rem_sz);
 	schp->page_order = order;
 	schp->num_sgat = k;
 	schp->buflen = align_sz;
@@ -6697,8 +6476,8 @@ sg_remove_sgat(struct sg_fd *sfp, struct sg_scatter_hold *schp)
 			continue;
 		__free_pages(p, schp->page_order);
 	}
-	SG_LOG(5, sfp, "%s: pg_order=%u, free pgs=0x%pK --\n", __func__,
-	       schp->page_order, schp->pages);
+	SG_LOG(5, sfp, "%s: pg_order=%u, free pgs=0x%pK --\n", __func__, schp->page_order,
+	       schp->pages);
 	kfree(schp->pages);
 }
 
@@ -6721,8 +6500,7 @@ sg_remove_srp(struct sg_request *srp)
 	if (sfp->tot_fd_thresh > 0) {
 		/* this is a subtraction, error if it goes negative */
 		if (atomic_add_negative(-schp->buflen, &sfp->sum_fd_dlens)) {
-			SG_LOG(2, sfp, "%s: logic error: this dlen > %s\n",
-			       __func__, "sum_fd_dlens");
+			SG_LOG(2, sfp, "%s: logic error: this dlen > sum_fd_dlens\n", __func__);
 			atomic_set(&sfp->sum_fd_dlens, 0);
 		}
 	}
@@ -6730,9 +6508,8 @@ sg_remove_srp(struct sg_request *srp)
 }
 
 /*
- * For sg v1 and v2 interface: with a command yielding a data-in buffer, after
- * it has arrived in kernel memory, this function copies it to the user space,
- * appended to given struct sg_header object.
+ * For sg v1 and v2 interface: with a command yielding a data-in buffer, after it has arrived in
+ * kernel memory, this function copies it to the user space, appended to given sg_header object.
  */
 static int
 sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
@@ -6770,12 +6547,11 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
 }
 
 /*
- * If there are many requests outstanding, the speed of this function is
- * important. 'id' is pack_id when is_tag=false, otherwise it is a tag. Both
- * SG_PACK_ID_WILDCARD and SG_TAG_WILDCARD are -1 and that case is typically
- * the fast path. This function is only used in the non-blocking cases.
- * Returns pointer to (first) matching sg_request or NULL. If found,
- * sg_request state is moved from SG_RQ_AWAIT_RCV to SG_RQ_BUSY.
+ * If there are many requests outstanding, the speed of this function is important. 'id' is pack_id
+ * when is_tag=false, otherwise it is a tag. Both SG_PACK_ID_WILDCARD and SG_TAG_WILDCARD are -1
+ * and that case is typically the fast path. This function is only used in the non-blocking cases.
+ * Returns pointer to (first) matching sg_request or NULL. If found, sg_request state is moved
+ * from SG_RQ_AWAIT_RCV to SG_RQ_BUSY.
  */
 static struct sg_request *
 sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
@@ -6859,16 +6635,15 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 	}
 	return NULL;
 good:
-	SG_LOG(5, sfp, "%s: %s%d found [srp=0x%pK]\n", __func__,
-	       (is_tag ? "tag=" : "pack_id="), id, srp);
+	SG_LOG(5, sfp, "%s: %s%d found [srp=0x%pK]\n", __func__, (is_tag ? "tag=" : "pack_id="),
+	       id, srp);
 	return srp;
 }
 
 /*
- * Makes a new sg_request object. If 'first' is set then use GFP_KERNEL which
- * may take time but has improved chance of success, otherwise use GFP_ATOMIC.
- * Note that basic initialization is done but srp is not added to either sfp
- * list. On error returns twisted negated errno value (not NULL).
+ * Makes a new sg_request object. If 'first' is set then use GFP_KERNEL which may take time but has
+ * improved chance of success, otherwise use GFP_ATOMIC. Note that basic initialization is done but
+ * srp is not added to either sfp list. On error returns twisted negated errno value (not NULL).
  * N.B. Initializes new srp state to SG_RQ_BUSY.
  */
 static struct sg_request *
@@ -6912,11 +6687,10 @@ sg_mk_srp_sgat(struct sg_fd *sfp, bool first, int db_len)
 }
 
 /*
- * Irrespective of the given reserve request size, the minimum size requested
- * will be PAGE_SIZE (often 4096 bytes). Returns a pointer to reserve object or
- * a negated errno value twisted by ERR_PTR() macro. The actual number of bytes
- * allocated (maybe less than buflen) is in srp->sgatp->buflen . Note that this
- * function is only called in contexts where locking is not required.
+ * Irrespective of the given reserve request size, the minimum size requested will be PAGE_SIZE
+ * (often 4096 bytes). Returns a pointer to reserve object or a negated errno value twisted by
+ * ERR_PTR() macro. The actual number of bytes allocated (maybe less than buflen) is in
+ * srp->sgatp->buflen . NB this function is only called in contexts where locking is not required.
  */
 static struct sg_request *
 sg_build_reserve(struct sg_fd *sfp, int buflen)
@@ -6946,9 +6720,8 @@ sg_build_reserve(struct sg_fd *sfp, int buflen)
 		res = sg_mk_sgat(srp, sfp, buflen);
 		if (likely(res == 0)) {
 			*rapp = srp;
-			SG_LOG(4, sfp,
-			       "%s: rsv%d: final buflen=%d, srp=0x%pK ++\n",
-			       __func__, idx, buflen, srp);
+			SG_LOG(4, sfp, "%s: rsv%d: final buflen=%d, srp=0x%pK ++\n", __func__,
+			       idx, buflen, srp);
 			return srp;
 		}
 		if (go_out) {
@@ -7070,12 +6843,11 @@ sg_setup_req_new_srp(struct sg_comm_wr_t *cwrp, bool new_rsv_srp, bool no_reqs,
 }
 
 /*
- * Setup an active request (soon to carry a SCSI command) to the current file
- * descriptor by creating a new one or re-using a request marked inactive.
- * If successful returns a valid pointer to a sg_request object which is in
- * the SG_RQ_BUSY state. On failure returns a negated errno value twisted by
- * ERR_PTR() macro. Note that once a file share is established, the read-side
- * side's reserve request can only be used in a request share.
+ * Setup an active request (soon to carry a SCSI command) to the current file descriptor by
+ * creating a new one or re-using a request marked inactive. If successful returns a valid pointer
+ * to a sg_request object which is in the SG_RQ_BUSY state. On failure returns a negated errno
+ * value twisted by ERR_PTR() macro. Note that once a file share is established, the read-side's
+ * reserve request can only be used in a request share.
  */
 static struct sg_request *
 sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
@@ -7126,6 +6898,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 			if (unlikely(res)) {
 				r_srp = NULL;
 			} else {
+				atomic_dec(&fp->inactives);
 				r_srp->sh_srp = NULL;
 				mk_new_srp = false;
 			}
@@ -7148,9 +6921,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 			r_srp = rs_rsv_srp;
 			goto err_out;
 		}
-		/* write-side dlen may be <= read-side's dlen */
-		if (unlikely(dlen + cwrp->wr_offset >
-			     rs_rsv_srp->sgatp->dlen)) {
+		if (unlikely(dlen + cwrp->wr_offset > rs_rsv_srp->sgatp->dlen)) {
 			SG_LOG(1, fp, "%s: bad, write-side dlen [%d] > read-side's\n",
 			       __func__, dlen);
 			r_srp = ERR_PTR(-E2BIG);
@@ -7332,19 +7103,17 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 			SG_LOG(1, fp, "%s: err=%d\n", __func__, err);
 	} else {
 		SG_LOG(4, fp, "%s: %s %sr_srp=0x%pK\n", __func__, cp,
-		       sg_get_rsv_str_lck(r_srp, "[", "] ", sizeof(b), b),
-		       r_srp);
+		       sg_get_rsv_str_lck(r_srp, "[", "] ", sizeof(b), b), r_srp);
 	}
 #endif
 	return r_srp;
 }
 
 /*
- * Sets srp to SG_RQ_INACTIVE unless it was in SG_RQ_SHR_SWAP state. Also
- * change the associated xarray entry flags to be consistent with
- * SG_RQ_INACTIVE. Since this function can be called from many contexts,
- * then assume no xa locks held.
- * The state machine should insure that two threads should never race here.
+ * Sets srp to SG_RQ_INACTIVE unless it was in SG_RQ_SHR_SWAP state. Also change the associated
+ * xarray entry flags to be consistent with SG_RQ_INACTIVE. Since this function can be called from
+ * many contexts, then assume no xa locks held.
+ * The state machine should ensure that two threads should never race here.
  */
 static void
 sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
@@ -7360,10 +7129,7 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 	srp->sense_bp = NULL;
 	sr_st = atomic_read_acquire(&srp->rq_st);
 	if (sr_st != SG_RQ_SHR_SWAP) {
-		/*
-		 * Can be called from many contexts and it is hard to know
-		 * whether xa locks held. So assume not.
-		 */
+		/* Called from many contexts, don't know whether xa locks held. So assume not. */
 		sg_rq_chg_state_force(srp, SG_RQ_INACTIVE);
 		atomic_inc(&sfp->inactives);
 		is_rsv = test_bit(SG_FRQ_RESERVED, srp->frq_bm);
@@ -7416,11 +7182,10 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 	atomic_set(&sfp->waiting, 0);
 	atomic_set(&sfp->inactives, 0);
 	/*
-	 * SG_SCATTER_SZ initializes scatter_elem_sz but different value may
-	 * be given as driver/module parameter (e.g. 'scatter_elem_sz=8192').
-	 * Any user provided number will be changed to be PAGE_SIZE as a
-	 * minimum, otherwise it will be rounded down (if required) to a
-	 * power of 2. So it will always be a power of 2.
+	 * SG_SCATTER_SZ initializes scatter_elem_sz but different value may be given as driver
+	 * or module parameter (e.g. 'scatter_elem_sz=8192'). Any user provided number will be
+	 * changed to be PAGE_SIZE as a minimum, otherwise it will be rounded down (if required)
+	 * to a power of 2. So it will always be a power of 2.
 	 */
 	sfp->sgat_elem_sz = scatter_elem_sz;
 	sfp->parentdp = sdp;
@@ -7439,22 +7204,19 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 		srp = sg_build_reserve(sfp, rbuf_len);
 		if (IS_ERR(srp)) {
 			err = PTR_ERR(srp);
-			SG_LOG(1, sfp, "%s: build reserve err=%ld\n", __func__,
-			       -err);
+			SG_LOG(1, sfp, "%s: build reserve err=%ld\n", __func__, -err);
 			kfree(sfp);
 			return ERR_PTR(err);
 		}
 		if (srp->sgatp->buflen < rbuf_len) {
 			reduced = true;
-			SG_LOG(2, sfp,
-			       "%s: reserve reduced from %d to buflen=%d\n",
-			       __func__, rbuf_len, srp->sgatp->buflen);
+			SG_LOG(2, sfp, "%s: reserve reduced from %d to buflen=%d\n", __func__,
+			       rbuf_len, srp->sgatp->buflen);
 		}
 		xa_lock_irqsave(xafp, iflags);
 		res = __xa_alloc(xafp, &idx, srp, xa_limit_32b, GFP_ATOMIC);
 		if (res < 0) {
-			SG_LOG(1, sfp, "%s: xa_alloc(srp) bad, errno=%d\n",
-			       __func__,  -res);
+			SG_LOG(1, sfp, "%s: xa_alloc(srp) bad, errno=%d\n", __func__,  -res);
 			xa_unlock_irqrestore(xafp, iflags);
 			sg_remove_srp(srp);
 			kfree(srp);
@@ -7468,17 +7230,15 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 		atomic_inc(&sfp->inactives);
 		xa_unlock_irqrestore(xafp, iflags);
 	}
-	if (!reduced) {
-		SG_LOG(4, sfp, "%s: built reserve buflen=%d\n", __func__,
-		       rbuf_len);
-	}
+	if (!reduced)
+		SG_LOG(4, sfp, "%s: built reserve buflen=%d\n", __func__, rbuf_len);
 	xadp = &sdp->sfp_arr;
 	xa_lock_irqsave(xadp, iflags);
 	res = __xa_alloc(xadp, &idx, sfp, xa_limit_32b, GFP_ATOMIC);
 	if (unlikely(res < 0)) {
 		xa_unlock_irqrestore(xadp, iflags);
-		pr_warn("%s: xa_alloc(sdp) bad, o_count=%d, errno=%d\n",
-			__func__, atomic_read(&sdp->open_cnt), -res);
+		pr_warn("%s: xa_alloc(sdp) bad, o_count=%d, errno=%d\n", __func__,
+			atomic_read(&sdp->open_cnt), -res);
 		if (srp) {
 			sg_remove_srp(srp);
 			kfree(srp);
@@ -7496,13 +7256,12 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 }
 
 /*
- * A successful call to sg_release() will result, at some later time, to this
- * "user context" function being invoked. All requests associated with this
- * file descriptor should be completed or cancelled when this function is
- * called (due to sfp->f_ref). Also the file descriptor itself has not been
- * accessible since it was list_del()-ed by the preceding sg_remove_sfp()
- * call. So no locking is required. sdp should never be NULL but to make
- * debugging more robust, this function will not blow up in that case.
+ * A successful call to sg_release() will result, at some later time, to this "user context"
+ * function being invoked. All requests associated with this file descriptor should be completed
+ * or cancelled when this function is called (due to sfp->f_ref). Also the file descriptor itself
+ * has not been accessible since it was list_del()-ed by the preceding sg_remove_sfp() call. So
+ * no locking is required. sdp should never be NULL but to make debugging more robust, this
+ * function will not blow up in that case.
  */
 static void
 sg_uc_remove_sfp(struct work_struct *work)
@@ -7538,15 +7297,13 @@ sg_uc_remove_sfp(struct work_struct *work)
 		e_srp = __xa_erase(xafp, srp->rq_idx);
 		xa_unlock_irqrestore(xafp, iflags);
 		if (unlikely(srp != e_srp))
-			SG_LOG(1, sfp, "%s: xa_erase() return unexpected\n",
-			       __func__);
+			SG_LOG(1, sfp, "%s: xa_erase() return unexpected\n", __func__);
 		SG_LOG(6, sfp, "%s: kfree: srp=%pK --\n", __func__, srp);
 		kfree(srp);
 	}
 	subm = atomic_read(&sfp->submitted);
 	if (subm != 0)
-		SG_LOG(1, sfp, "%s: expected submitted=0 got %d\n",
-		       __func__, subm);
+		SG_LOG(1, sfp, "%s: expected submitted=0 got %d\n", __func__, subm);
 	if (sfp->efd_ctxp)
 		eventfd_ctx_put(sfp->efd_ctxp);
 	xa_destroy(xafp);
@@ -7555,11 +7312,9 @@ sg_uc_remove_sfp(struct work_struct *work)
 	e_sfp = __xa_erase(xadp, sfp->idx);
 	xa_unlock_irqrestore(xadp, iflags);
 	if (unlikely(sfp != e_sfp))
-		SG_LOG(1, sfp, "%s: xa_erase() return unexpected\n",
-		       __func__);
+		SG_LOG(1, sfp, "%s: xa_erase() return unexpected\n", __func__);
 	o_count = atomic_dec_return(&sdp->open_cnt);
-	SG_LOG(3, sfp, "%s: dev o_count after=%d: sfp=0x%pK --\n", __func__,
-	       o_count, sfp);
+	SG_LOG(3, sfp, "%s: dev o_count after=%d: sfp=0x%pK --\n", __func__, o_count, sfp);
 	kfree(sfp);
 
 	scsi_device_put(sdp->device);
@@ -7598,8 +7353,9 @@ sg_get_dev(int min_dev)
 	if (unlikely(!sdp))
 		sdp = ERR_PTR(-ENXIO);
 	else if (SG_IS_DETACHING(sdp)) {
-		/* If detaching, then the refcount may already be 0, in
-		 * which case it would be a bug to do kref_get().
+		/*
+		 * If detaching, then the refcount may already be 0, in which case it would
+		 * be a bug to do kref_get().
 		 */
 		sdp = ERR_PTR(-ENODEV);
 	} else
@@ -7756,8 +7512,7 @@ sg_proc_single_open_adio(struct inode *inode, struct file *filp)
 
 /* Kept for backward compatibility. sg_allow_dio is now ignored. */
 static ssize_t
-sg_proc_write_adio(struct file *filp, const char __user *buffer,
-		   size_t count, loff_t *off)
+sg_proc_write_adio(struct file *filp, const char __user *buffer, size_t count, loff_t *off)
 {
 	int err;
 	unsigned long num;
@@ -7778,8 +7533,7 @@ sg_proc_single_open_dressz(struct inode *inode, struct file *filp)
 }
 
 static ssize_t
-sg_proc_write_dressz(struct file *filp, const char __user *buffer,
-		     size_t count, loff_t *off)
+sg_proc_write_dressz(struct file *filp, const char __user *buffer, size_t count, loff_t *off)
 {
 	int err;
 	unsigned long k = ULONG_MAX;
@@ -7849,8 +7603,8 @@ sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
 	scsidp = sdp ? sdp->device : NULL;
 	if (sdp && scsidp && !SG_IS_DETACHING(sdp))
-		seq_printf(s, "%8.8s\t%16.16s\t%4.4s\n",
-			   scsidp->vendor, scsidp->model, scsidp->rev);
+		seq_printf(s, "%8.8s\t%16.16s\t%4.4s\n", scsidp->vendor, scsidp->model,
+			   scsidp->rev);
 	else
 		seq_puts(s, "<no active device>\n");
 	read_unlock_irqrestore(&sg_index_lock, iflags);
@@ -7879,26 +7633,22 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, bool inactive,
 	is_v3v4 = v4 ? true : (srp->s_hdr3.interface_id != '\0');
 	sg_get_rsv_str(srp, "     ", "", sizeof(b), b);
 	if (strlen(b) > 5)
-		cp = (is_v3v4 && (srp->rq_flags & SG_FLAG_MMAP_IO)) ?
-					" mmap" : "";
+		cp = (is_v3v4 && (srp->rq_flags & SG_FLAG_MMAP_IO)) ?  " mmap" : "";
 	else
 		cp = (srp->rq_info & SG_INFO_DIRECT_IO_MASK) ? " dio" : "";
 	rq_st = atomic_read(&srp->rq_st);
 	dur = sg_get_dur(srp, &rq_st, t_in_ns, &is_dur);
-	n += scnprintf(obp + n, len - n, "%s%s>> %s:%d dlen=%d/%d id=%d", b,
-		       cp, sg_rq_st_str(rq_st, false), srp->rq_idx, srp->sgatp->dlen,
+	n += scnprintf(obp + n, len - n, "%s%s>> %s:%d dlen=%d/%d id=%d", b, cp,
+		       sg_rq_st_str(rq_st, false), srp->rq_idx, srp->sgatp->dlen,
 		       srp->sgatp->buflen, (int)srp->pack_id);
 	if (test_bit(SG_FFD_NO_DURATION, srp->parentfp->ffd_bm))
 		;
 	else if (is_dur)	/* cmd/req has completed, waiting for ... */
 		n += scnprintf(obp + n, len - n, " dur=%u%s", dur, tp);
 	else if (dur < U32_MAX) { /* in-flight or busy (so ongoing) */
-		if ((srp->rq_flags & SGV4_FLAG_YIELD_TAG) &&
-		    srp->tag != SG_TAG_WILDCARD)
-			n += scnprintf(obp + n, len - n, " tag=0x%x",
-				       srp->tag);
-		n += scnprintf(obp + n, len - n, " t_o/elap=%us/%u%s",
-			       to / 1000, dur, tp);
+		if ((srp->rq_flags & SGV4_FLAG_YIELD_TAG) && srp->tag != SG_TAG_WILDCARD)
+			n += scnprintf(obp + n, len - n, " tag=0x%x", srp->tag);
+		n += scnprintf(obp + n, len - n, " t_o/elap=%us/%u%s", to / 1000, dur, tp);
 	}
 	if (srp->sh_var != SG_SHR_NONE)
 		n += scnprintf(obp + n, len - n, " shr=%s",
@@ -7919,8 +7669,7 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, bool inactive,
 
 /* Writes debug info for one sg fd (including its sg requests) in obp buffer */
 static int
-sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
-		 bool reduced)
+sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx, bool reduced)
 {
 	bool set_debug;
 	bool t_in_ns = test_bit(SG_FFD_TIME_IN_NS, fp->ffd_bm);
@@ -7932,16 +7681,15 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 	struct sg_device *sdp = fp->parentdp;
 
 	if (sg_fd_is_shared(fp))
-		cp = xa_get_mark(&sdp->sfp_arr, fp->idx, SG_XA_FD_RS_SHARE) ?
-			" shr_rs" : " shr_rs";
+		cp = xa_get_mark(&sdp->sfp_arr, fp->idx, SG_XA_FD_RS_SHARE) ? " shr_rs" :
+									      " shr_ws";
 	else
 		cp = "";
 	set_debug = test_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm);
 	/* sgat=-1 means unavailable */
 	to = (fp->timeout >= 0) ? jiffies_to_msecs(fp->timeout) : -999;
 	if (to < 0)
-		n += scnprintf(obp + n, len - n, "BAD timeout=%d",
-			       fp->timeout);
+		n += scnprintf(obp + n, len - n, "BAD timeout=%d", fp->timeout);
 	else if (to % 1000)
 		n += scnprintf(obp + n, len - n, "timeout=%dms rs", to);
 	else
@@ -7965,8 +7713,8 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 		       atomic_read(&fp->sum_fd_dlens));
 	n += scnprintf(obp + n, len - n,
 		       "   submitted=%d waiting=%d inactives=%d   open thr_id=%d\n",
-		       atomic_read(&fp->submitted),
-		       atomic_read(&fp->waiting), atomic_read(&fp->inactives), fp->tid);
+		       atomic_read(&fp->submitted), atomic_read(&fp->waiting),
+		       atomic_read(&fp->inactives), fp->tid);
 	if (reduced)
 		return n;
 	k = 0;
@@ -7978,11 +7726,9 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 		if (xa_get_mark(&fp->srp_arr, idx, SG_XA_RQ_INACTIVE))
 			continue;
 		if (set_debug)
-			n += scnprintf(obp + n, len - n, "     rq_bm=0x%lx",
-				       srp->frq_bm[0]);
+			n += scnprintf(obp + n, len - n, "     rq_bm=0x%lx", srp->frq_bm[0]);
 		else if (test_bit(SG_FRQ_ABORTING, srp->frq_bm))
-			n += scnprintf(obp + n, len - n,
-				       "     abort>> ");
+			n += scnprintf(obp + n, len - n, "     abort>> ");
 		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns, false, obp + n, len - n);
 		++k;
 		if ((k % 8) == 0) {	/* don't hold up isr_s too long */
@@ -7998,8 +7744,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 		if (k == 0)
 			n += scnprintf(obp + n, len - n, "   Inactives:\n");
 		if (set_debug)
-			n += scnprintf(obp + n, len - n, "     rq_bm=0x%lx",
-				       srp->frq_bm[0]);
+			n += scnprintf(obp + n, len - n, "     rq_bm=0x%lx", srp->frq_bm[0]);
 		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns, true, obp + n, len - n);
 		++k;
 		if ((k % 8) == 0) {	/* don't hold up isr_s too long */
@@ -8014,8 +7759,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 
 /* Writes debug info for one sg device (including its sg fds) in obp buffer */
 static int
-sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len,
-		   int *fd_counterp, bool reduced)
+sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len, int *fd_counterp, bool reduced)
 {
 	int n = 0;
 	int my_count = 0;
@@ -8028,10 +7772,9 @@ sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len,
 	countp = fd_counterp ? fd_counterp : &my_count;
 	disk_name = (sdp->disk ? sdp->disk->disk_name : "?_?");
 	n += scnprintf(obp + n, len - n, " >>> device=%s ", disk_name);
-	n += scnprintf(obp + n, len - n, "%d:%d:%d:%llu ", ssdp->host->host_no,
-		       ssdp->channel, ssdp->id, ssdp->lun);
-	n += scnprintf(obp + n, len - n,
-		       "  max_sgat_sz,elems=2^%d,%d excl=%d open_cnt=%d\n",
+	n += scnprintf(obp + n, len - n, "%d:%d:%d:%llu ", ssdp->host->host_no, ssdp->channel,
+		       ssdp->id, ssdp->lun);
+	n += scnprintf(obp + n, len - n, "  max_sgat_sz,elems=2^%d,%d excl=%d open_cnt=%d\n",
 		       ilog2(sdp->max_sgat_sz), sdp->max_sgat_elems,
 		       SG_HAVE_EXCLUDE(sdp), atomic_read(&sdp->open_cnt));
 	xa_for_each(&sdp->sfp_arr, idx, fp) {
@@ -8062,13 +7805,12 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v, bool reduced)
 
 	b1[0] = '\0';
 	if (it && it->index == 0)
-		seq_printf(s, "max_active_device=%d  def_reserved_size=%d\n",
-			   (int)it->max, def_reserved_size);
+		seq_printf(s, "max_active_device=%d  def_reserved_size=%d\n", (int)it->max,
+			   def_reserved_size);
 	fdi_p = it ? &it->fd_index : &k;
 	bp = kzalloc(bp_len, __GFP_NOWARN | GFP_KERNEL);
 	if (unlikely(!bp)) {
-		seq_printf(s, "%s: Unable to allocate %d on heap, finish\n",
-			   __func__, bp_len);
+		seq_printf(s, "%s: Unable to allocate %d on heap, finish\n", __func__, bp_len);
 		return -ENOMEM;
 	}
 	read_lock_irqsave(&sg_index_lock, iflags);
@@ -8102,19 +7844,17 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v, bool reduced)
 		found = true;
 		disk_name = (sdp->disk ? sdp->disk->disk_name : "?_?");
 		if (SG_IS_DETACHING(sdp)) {
-			snprintf(b1, sizeof(b1), " >>> %s %s\n", disk_name,
-				 "detaching pending close\n");
+			snprintf(b1, sizeof(b1), " >>> detaching pending close %s\n", disk_name);
 		} else if (sdp->device) {
-			n = sg_proc_debug_sdev(sdp, bp, bp_len, fdi_p,
-					       reduced);
+			n = sg_proc_debug_sdev(sdp, bp, bp_len, fdi_p, reduced);
 			if (n >= bp_len - 1) {
 				trunc = true;
 				if (bp[bp_len - 2] != '\n')
 					bp[bp_len - 2] = '\n';
 			}
 		} else {
-			snprintf(b1, sizeof(b1), " >>> device=%s  %s\n",
-				 disk_name, "sdp->device==NULL, skip");
+			snprintf(b1, sizeof(b1), " >>> device=%s sdp->device==NULL, skip\n",
+				 disk_name);
 		}
 	}
 skip:
@@ -8125,8 +7865,7 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v, bool reduced)
 			if (seq_has_overflowed(s))
 				goto s_ovfl;
 			if (trunc)
-				seq_printf(s, "   >> Output truncated %s\n",
-					   "due to buffer size");
+				seq_puts(s, "   >> Output truncated due to buffer size\n");
 		} else if (b1[0]) {
 			seq_puts(s, b1);
 			if (unlikely(seq_has_overflowed(s)))
@@ -8252,8 +7991,7 @@ sg_dfs_snapped_show(void *data, struct seq_file *m)
 }
 
 static ssize_t
-sg_dfs_snapped_write(void *data, const char __user *buf, size_t count,
-		     loff_t *ppos)
+sg_dfs_snapped_write(void *data, const char __user *buf, size_t count, loff_t *ppos)
 {
 	/* Any write clears snapped buffer */
 	mutex_lock(&snapped_mutex);
@@ -8292,8 +8030,7 @@ sg_dfs_snapshot_devs_show(void *data, struct seq_file *m)
 }
 
 static ssize_t
-sg_dfs_snapshot_devs_write(void *data, const char __user *buf, size_t count,
-			   loff_t *ppos)
+sg_dfs_snapshot_devs_write(void *data, const char __user *buf, size_t count, loff_t *ppos)
 {
 	bool trailing_comma;
 	int k, n;
@@ -8322,8 +8059,7 @@ sg_dfs_snapshot_devs_write(void *data, const char __user *buf, size_t count,
 	if (n == 0) {
 		return -EINVAL;
 	} else if (k >= SG_SNAPSHOT_DEV_MAX && trailing_comma) {
-		pr_err("%s: only %d elements in snapshot array\n", __func__,
-		       SG_SNAPSHOT_DEV_MAX);
+		pr_err("%s: only %d elements in snapshot array\n", __func__, SG_SNAPSHOT_DEV_MAX);
 		return -EINVAL;
 	}
 	if (n < SG_SNAPSHOT_DEV_MAX)
@@ -8341,16 +8077,15 @@ sg_dfs_show(struct seq_file *m, void *v)
 }
 
 static ssize_t
-sg_dfs_write(struct file *file, const char __user *buf, size_t count,
-	     loff_t *ppos)
+sg_dfs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
 	struct seq_file *m = file->private_data;
 	const struct sg_dfs_attr *attr = m->private;
 	void *data = d_inode(file->f_path.dentry->d_parent)->i_private;
 
 	/*
-	 * Attributes that only implement .seq_ops are read-only and 'attr' is
-	 * the same with 'data' in this case.
+	 * Attributes that only implement .seq_ops are read-only and 'attr' is the same with
+	 * 'data' in this case.
 	 */
 	if (unlikely(attr == data || !attr->write))
 		return -EPERM;
@@ -8397,16 +8132,14 @@ static const struct file_operations sg_dfs_fops = {
 	.release	= sg_dfs_release,
 };
 
-static void sg_dfs_mk_files(struct dentry *parent, void *data,
-			    const struct sg_dfs_attr *attr)
+static void sg_dfs_mk_files(struct dentry *parent, void *data, const struct sg_dfs_attr *attr)
 {
 	if (IS_ERR_OR_NULL(parent))
 		return;
 
 	d_inode(parent)->i_private = data;
 	for (; attr->name; ++attr)
-		debugfs_create_file(attr->name, attr->mode, parent,
-				    (void *)attr, &sg_dfs_fops);
+		debugfs_create_file(attr->name, attr->mode, parent, (void *)attr, &sg_dfs_fops);
 }
 
 static const struct seq_operations sg_snapshot_seq_ops = {
@@ -8437,10 +8170,8 @@ sg_dfs_init(void)
 {
 	/* create and populate /sys/kernel/debug/scsi_generic directory */
 	if (!sg_dfs_cxt.dfs_rootdir) {
-		sg_dfs_cxt.dfs_rootdir = debugfs_create_dir("scsi_generic",
-							    NULL);
-		sg_dfs_mk_files(sg_dfs_cxt.dfs_rootdir, &sg_dfs_cxt,
-				sg_dfs_attrs);
+		sg_dfs_cxt.dfs_rootdir = debugfs_create_dir("scsi_generic", NULL);
+		sg_dfs_mk_files(sg_dfs_cxt.dfs_rootdir, &sg_dfs_cxt, sg_dfs_attrs);
 	}
 	sg_dfs_cxt.snapshot_devs[0] = -1;	/* show all sg devices */
 }
-- 
2.25.1

