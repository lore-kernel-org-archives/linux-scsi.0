Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B4DC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 728B7613FC
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239368AbhD0WAI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:08 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38991 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239482AbhD0V7l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:41 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 01E6020426D;
        Tue, 27 Apr 2021 23:58:54 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eHxLimvf7JBO; Tue, 27 Apr 2021 23:58:51 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id CD5BF204190;
        Tue, 27 Apr 2021 23:58:49 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 50/83] sg: add fd sharing , change, unshare
Date:   Tue, 27 Apr 2021 17:57:00 -0400
Message-Id: <20210427215733.417746-52-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the ability establish a share between any two open file
descriptors in the sg driver. Neither file descriptor can
already be part of a share. This fd share is used for two
features added and described in later patches: request sharing
and the "do_on_other" flag used when multiple requests are
issued (with a single invocation from the user space). See the
webpage at:
https://sg.danny.cz/sg/sg_v40.html
in the section titled: "6 Sharing file descriptors".

Usually two file descriptors are enough. To support the ability
to READ once and then WRITE to two or more file descriptors
(hence potentially to write the same data to different disks)
the ability to drop the share partner file descriptor and
replace it with a new fd is also available.

Finally a share can explicitly be undone, or unshared, by either
side. In practice, close()-ing either side of a fd share has the
same effect (i.e. to unshare) so this route is the more common.

File shares maybe within a single-threaded process, between
threads in the same process, or even between processes (on the
same machine) by passing an open file descriptor via Unix
sockets to the other process.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 694 +++++++++++++++++++++++++++++++++++------
 include/uapi/scsi/sg.h |   3 +
 2 files changed, 593 insertions(+), 104 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c0a4fbcc4aa2..fb3782b1f9c7 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -33,6 +33,7 @@ static char *sg_version_date = "20210421";
 #include <linux/moduleparam.h>
 #include <linux/cdev.h>
 #include <linux/idr.h>
+#include <linux/file.h>		/* for fget() and fput() */
 #include <linux/seq_file.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
@@ -42,6 +43,7 @@ static char *sg_version_date = "20210421";
 #include <linux/ratelimit.h>
 #include <linux/uio.h>
 #include <linux/cred.h>			/* for sg_check_file_access() */
+#include <linux/timekeeping.h>
 #include <linux/proc_fs.h>		/* used if CONFIG_SCSI_PROC_FS */
 #include <linux/xarray.h>
 #include <linux/debugfs.h>
@@ -133,8 +135,9 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 #define SG_FFD_TIME_IN_NS	4	/* set: time in nanoseconds, else ms */
 #define SG_FFD_Q_AT_TAIL	5	/* set: queue reqs at tail of blk q */
 #define SG_FFD_PREFER_TAG	6	/* prefer tag over pack_id (def) */
-#define SG_FFD_NO_DURATION	7	/* don't do command duration calc */
-#define SG_FFD_MORE_ASYNC	8	/* yield EBUSY more often */
+#define SG_FFD_RELEASE		7	/* release (close) underway */
+#define SG_FFD_NO_DURATION	8	/* don't do command duration calc */
+#define SG_FFD_MORE_ASYNC	9	/* yield EBUSY more often */
 
 /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
 #define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
@@ -142,7 +145,11 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 #define SG_FDEV_LOG_SENSE	2	/* set by ioctl(SG_SET_DEBUG) */
 
 /* xarray 'mark's allow sub-lists within main array/list. */
-#define SG_XA_RQ_FREE XA_MARK_0	/* xarray sets+clears */
+#define SG_XA_FD_FREE XA_MARK_0		/* xarray sets+clears */
+#define SG_XA_FD_UNSHARED XA_MARK_1
+#define SG_XA_FD_RS_SHARE XA_MARK_2
+
+#define SG_XA_RQ_FREE XA_MARK_0		/* xarray sets+clears */
 #define SG_XA_RQ_INACTIVE XA_MARK_1
 #define SG_XA_RQ_AWAIT XA_MARK_2
 
@@ -250,10 +257,12 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	int tot_fd_thresh;	/* E2BIG if sum_of(dlen) > this, 0: ignore */
 	int sgat_elem_sz;	/* initialized to scatter_elem_sz */
 	int mmap_sz;		/* byte size of previous mmap() call */
-	unsigned long ffd_bm[1];	/* see SG_FFD_* defines above */
 	pid_t tid;		/* thread id when opened */
 	u8 next_cmd_len;	/* 0: automatic, >0: use on next write() */
+	unsigned long ffd_bm[1];	/* see SG_FFD_* defines above */
+	struct file *filp;	/* my identity when sharing */
 	struct sg_request *rsv_srp;/* one reserve request per fd */
+	struct sg_fd __rcu *share_sfp;/* fd share cross-references, else NULL */
 	struct fasync_struct *async_qp; /* used by asynchronous notification */
 	struct xarray srp_arr;	/* xarray of sg_request object pointers */
 	struct kref f_ref;
@@ -285,7 +294,6 @@ struct sg_comm_wr_t {  /* arguments to sg_common_write() */
 		struct sg_io_v4 *h4p;
 	};
 	struct sg_fd *sfp;
-	struct file *filp;
 	const u8 __user *u_cmdp;
 };
 
@@ -299,14 +307,15 @@ static int sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp,
 			int dxfer_dir);
 static void sg_finish_scsi_blk_rq(struct sg_request *srp);
 static int sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen);
-static int sg_v3_submit(struct file *filp, struct sg_fd *sfp,
-			struct sg_io_hdr *hp, bool sync,
+static int sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp,
+			 void __user *p);
+static int sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 			struct sg_request **o_srp);
 static struct sg_request *sg_common_write(struct sg_comm_wr_t *cwrp);
 static int sg_read_append(struct sg_request *srp, void __user *outp,
 			  int num_xfer);
 static void sg_remove_sgat(struct sg_request *srp);
-static struct sg_fd *sg_add_sfp(struct sg_device *sdp);
+static struct sg_fd *sg_add_sfp(struct sg_device *sdp, struct file *filp);
 static void sg_remove_sfp(struct kref *);
 static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int id,
 					    bool is_tag);
@@ -529,7 +538,7 @@ sg_open(struct inode *inode, struct file *filp)
 		set_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm);
 
 	o_count = atomic_inc_return(&sdp->open_cnt);
-	sfp = sg_add_sfp(sdp);		/* increments sdp->d_ref */
+	sfp = sg_add_sfp(sdp, filp);	/* increments sdp->d_ref */
 	if (IS_ERR(sfp)) {
 		atomic_dec(&sdp->open_cnt);
 		res = PTR_ERR(sfp);
@@ -563,6 +572,21 @@ sg_open(struct inode *inode, struct file *filp)
 	goto sg_put;
 }
 
+static inline struct sg_fd *
+sg_fd_shared_ptr(struct sg_fd *sfp)
+{
+	struct sg_fd *res_sfp;
+	struct sg_device *sdp = sfp->parentdp;
+
+	rcu_read_lock();
+	if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_UNSHARED))
+		res_sfp = NULL;
+	else
+		res_sfp = sfp->share_sfp;
+	rcu_read_unlock();
+	return res_sfp;
+}
+
 /*
  * Release resources associated with a prior, successful sg_open(). It can be
  * seen as the (final) close() call on a sg device file descriptor in the user
@@ -582,9 +606,17 @@ sg_release(struct inode *inode, struct file *filp)
 	if (unlikely(!sdp))
 		return -ENXIO;
 
+	if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_FREE)) {
+		SG_LOG(1, sfp, "%s: sfp erased!!!\n", __func__);
+		return 0;	/* get out but can't fail */
+	}
+
 	mutex_lock(&sdp->open_rel_lock);
 	o_count = atomic_read(&sdp->open_cnt);
 	SG_LOG(3, sfp, "%s: open count before=%d\n", __func__, o_count);
+	if (test_and_set_bit(SG_FFD_RELEASE, sfp->ffd_bm))
+		SG_LOG(1, sfp, "%s: second release on this fd ? ?\n",
+		       __func__);
 	scsi_autopm_put_device(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 
@@ -673,7 +705,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 		pr_warn_once("Please use %s instead of write(),\n%s\n",
 			     "ioctl(SG_SUBMIT_V3)",
 			     "  See: https://sg.danny.cz/sg/sg_v40.html");
-		res = sg_v3_submit(filp, sfp, h3p, false, NULL);
+		res = sg_submit_v3(sfp, h3p, false, NULL);
 		return res < 0 ? res : (int)count;
 	}
 to_v2:
@@ -740,7 +772,6 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	WRITE_ONCE(cwr.frq_bm[0], 0);
 	cwr.timeout = sfp->timeout;
 	cwr.cmd_len = cmd_size;
-	cwr.filp = filp;
 	cwr.sfp = sfp;
 	cwr.u_cmdp = p;
 	srp = sg_common_write(&cwr);
@@ -764,19 +795,18 @@ sg_chk_mmap(struct sg_fd *sfp, int rq_flags, int len)
 }
 
 static int
-sg_fetch_cmnd(struct file *filp, struct sg_fd *sfp, const u8 __user *u_cdbp,
-	      int len, u8 *cdbp)
+sg_fetch_cmnd(struct sg_fd *sfp, const u8 __user *u_cdbp, int len, u8 *cdbp)
 {
 	if (!u_cdbp || len < 6 || len > SG_MAX_CDB_SIZE)
 		return -EMSGSIZE;
 	if (copy_from_user(cdbp, u_cdbp, len))
 		return -EFAULT;
-	if (O_RDWR != (filp->f_flags & O_ACCMODE)) {	/* read-only */
+	if (O_RDWR != (sfp->filp->f_flags & O_ACCMODE)) { /* read-only */
 		switch (sfp->parentdp->device->type) {
 		case TYPE_DISK:
 		case TYPE_RBC:
 		case TYPE_ZBC:
-			return blk_verify_command(cdbp, filp->f_mode);
+			return blk_verify_command(cdbp, sfp->filp->f_mode);
 		default:	/* SSC, SES, etc cbd_s may differ from SBC */
 			break;
 		}
@@ -785,8 +815,8 @@ sg_fetch_cmnd(struct file *filp, struct sg_fd *sfp, const u8 __user *u_cdbp,
 }
 
 static int
-sg_v3_submit(struct file *filp, struct sg_fd *sfp, struct sg_io_hdr *hp,
-	     bool sync, struct sg_request **o_srp)
+sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
+	     struct sg_request **o_srp)
 {
 	unsigned long ul_timeout;
 	struct sg_request *srp;
@@ -807,7 +837,6 @@ sg_v3_submit(struct file *filp, struct sg_fd *sfp, struct sg_io_hdr *hp,
 	cwr.h3p = hp;
 	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
 	cwr.cmd_len = hp->cmd_len;
-	cwr.filp = filp;
 	cwr.sfp = sfp;
 	cwr.u_cmdp = hp->cmdp;
 	srp = sg_common_write(&cwr);
@@ -819,8 +848,8 @@ sg_v3_submit(struct file *filp, struct sg_fd *sfp, struct sg_io_hdr *hp,
 }
 
 static int
-sg_submit_v4(struct file *filp, struct sg_fd *sfp, void __user *p,
-	     struct sg_io_v4 *h4p, bool sync, struct sg_request **o_srp)
+sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
+	     bool sync, struct sg_request **o_srp)
 {
 	int res = 0;
 	unsigned long ul_timeout;
@@ -841,7 +870,6 @@ sg_submit_v4(struct file *filp, struct sg_fd *sfp, void __user *p,
 	/* once v4 (or v3) seen, allow cmd_q on this fd (def: no cmd_q) */
 	set_bit(SG_FFD_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(h4p->timeout);
-	cwr.filp = filp;
 	cwr.sfp = sfp;
 	WRITE_ONCE(cwr.frq_bm[0], 0);
 	__assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)sync);
@@ -867,38 +895,38 @@ sg_submit_v4(struct file *filp, struct sg_fd *sfp, void __user *p,
 }
 
 static int
-sg_ctl_iosubmit(struct file *filp, struct sg_fd *sfp, void __user *p)
+sg_ctl_iosubmit(struct sg_fd *sfp, void __user *p)
 {
 	int res;
 	u8 hdr_store[SZ_SG_IO_V4];
 	struct sg_io_v4 *h4p = (struct sg_io_v4 *)hdr_store;
 	struct sg_device *sdp = sfp->parentdp;
 
-	res = sg_allow_if_err_recovery(sdp, (filp->f_flags & O_NONBLOCK));
+	res = sg_allow_if_err_recovery(sdp, (sfp->filp->f_flags & O_NONBLOCK));
 	if (res)
 		return res;
 	if (copy_from_user(hdr_store, p, SZ_SG_IO_V4))
 		return -EFAULT;
 	if (h4p->guard == 'Q')
-		return sg_submit_v4(filp, sfp, p, h4p, false, NULL);
+		return sg_submit_v4(sfp, p, h4p, false, NULL);
 	return -EPERM;
 }
 
 static int
-sg_ctl_iosubmit_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
+sg_ctl_iosubmit_v3(struct sg_fd *sfp, void __user *p)
 {
 	int res;
 	u8 hdr_store[SZ_SG_IO_V4];	/* max(v3interface, v4interface) */
 	struct sg_io_hdr *h3p = (struct sg_io_hdr *)hdr_store;
 	struct sg_device *sdp = sfp->parentdp;
 
-	res = sg_allow_if_err_recovery(sdp, (filp->f_flags & O_NONBLOCK));
+	res = sg_allow_if_err_recovery(sdp, (sfp->filp->f_flags & O_NONBLOCK));
 	if (unlikely(res))
 		return res;
 	if (copy_from_user(h3p, p, SZ_SG_IO_HDR))
 		return -EFAULT;
 	if (h3p->interface_id == 'S')
-		return sg_v3_submit(filp, sfp, h3p, false, NULL);
+		return sg_submit_v3(sfp, h3p, false, NULL);
 	return -EPERM;
 }
 
@@ -1233,46 +1261,6 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 	return 0;
 }
 
-static ssize_t
-sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, size_t count,
-	      void __user *p)
-{
-	int err, err2;
-	int rq_result = srp->rq_result;
-	struct sg_io_hdr hdr3;
-	struct sg_io_hdr *hp = &hdr3;
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
-	SG_LOG(3, sfp, "%s: srp=0x%pK\n", __func__, srp);
-	err = sg_rec_state_v3v4(sfp, srp, false);
-	memset(hp, 0, sizeof(*hp));
-	memcpy(hp, &srp->s_hdr3, sizeof(srp->s_hdr3));
-	hp->sb_len_wr = srp->sense_len;
-	hp->info = srp->rq_info;
-	hp->resid = srp->in_resid;
-	hp->pack_id = srp->pack_id;
-	hp->duration = srp->duration;
-	hp->status = rq_result & 0xff;
-	hp->masked_status = status_byte(rq_result);
-	hp->msg_status = msg_byte(rq_result);
-	hp->host_status = host_byte(rq_result);
-	hp->driver_status = driver_byte(rq_result);
-	err2 = put_sg_io_hdr(hp, p);
-	err = err ? err : err2;
-err_out:
-	sg_finish_scsi_blk_rq(srp);
-	sg_deact_request(sfp, srp);
-	return err;
-}
-
 static int
 sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
 	      struct sg_io_v4 *h4p)
@@ -1327,9 +1315,9 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
  * otherwise it waits (i.e. it "blocks").
  */
 static int
-sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
+sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 {
-	bool non_block = !!(filp->f_flags & O_NONBLOCK);
+	bool non_block = !!(sfp->filp->f_flags & O_NONBLOCK);
 	bool use_tag = false;
 	int res, id;
 	int pack_id = SG_PACK_ID_WILDCARD;
@@ -1390,9 +1378,9 @@ sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
  * otherwise it waits.
  */
 static int
-sg_ctl_ioreceive_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
+sg_ctl_ioreceive_v3(struct sg_fd *sfp, void __user *p)
 {
-	bool non_block = !!(filp->f_flags & O_NONBLOCK);
+	bool non_block = !!(sfp->filp->f_flags & O_NONBLOCK);
 	int res;
 	int pack_id = SG_PACK_ID_WILDCARD;
 	u8 v3_holder[SZ_SG_IO_HDR];
@@ -1434,7 +1422,7 @@ sg_ctl_ioreceive_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
 		cpu_relax();
 		goto try_again;
 	}
-	return sg_receive_v3(sfp, srp, SZ_SG_IO_HDR, p);
+	return sg_receive_v3(sfp, srp, p);
 }
 
 static int
@@ -1605,15 +1593,56 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 		cpu_relax();
 		goto try_again;
 	}
-	if (srp->s_hdr3.interface_id == '\0')
+	if (srp->s_hdr3.interface_id == '\0') {
 		ret = sg_read_v1v2(p, (int)count, sfp, srp);
-	else
-		ret = sg_receive_v3(sfp, srp, count, p);
+	} else {
+		if (in_compat_syscall()) {
+			if (count < sizeof(struct compat_sg_io_hdr))
+				return -EINVAL;
+		} else if (count < SZ_SG_IO_HDR) {
+			return -EINVAL;
+		}
+		ret = sg_receive_v3(sfp, srp, p);
+	}
 	if (ret < 0)
 		SG_LOG(1, sfp, "%s: negated errno: %d\n", __func__, ret);
 	return ret < 0 ? ret : (int)count;
 }
 
+/*
+ * Completes a v3 request/command. Called from sg_read {v2 or v3},
+ * ioctl(SG_IO) {for v3}, or from ioctl(SG_IORECEIVE) when its
+ * completing a v3 request/command.
+ */
+static int
+sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, void __user *p)
+{
+	int err, err2;
+	int rq_result = srp->rq_result;
+	struct sg_io_hdr hdr3;
+	struct sg_io_hdr *hp = &hdr3;
+
+	SG_LOG(3, sfp, "%s: srp=0x%pK\n", __func__, srp);
+	err = sg_rec_state_v3v4(sfp, srp, false);
+	memset(hp, 0, sizeof(*hp));
+	memcpy(hp, &srp->s_hdr3, sizeof(srp->s_hdr3));
+	hp->sb_len_wr = srp->sense_len;
+	hp->info = srp->rq_info;
+	hp->resid = srp->in_resid;
+	hp->pack_id = srp->pack_id;
+	hp->duration = srp->duration;
+	hp->status = rq_result & 0xff;
+	hp->masked_status = status_byte(rq_result);
+	hp->msg_status = msg_byte(rq_result);
+	hp->host_status = host_byte(rq_result);
+	hp->driver_status = driver_byte(rq_result);
+	err2 = put_sg_io_hdr(hp, p);
+	err = err ? err : err2;
+	sg_finish_scsi_blk_rq(srp);
+	sg_deact_request(sfp, srp);
+	return err;
+}
+
 static int
 max_sectors_bytes(struct request_queue *q)
 {
@@ -1657,6 +1686,155 @@ sg_calc_sgat_param(struct sg_device *sdp)
 	sdp->max_sgat_sz = sz;
 }
 
+/*
+ * Depending on which side is calling for the unshare, it is best to unshare
+ * the other side first. For example: if the invocation is from the read-side
+ * fd then rd_first should be false so the write-side is unshared first.
+ */
+static void
+sg_unshare_fds(struct sg_fd *rs_sfp, bool rs_lck, struct sg_fd *ws_sfp,
+	       bool ws_lck, bool rs_first)
+{
+	bool diff_sdps = true;
+	unsigned long iflags = 0;
+	struct sg_device *sdp;
+	struct xarray *xap;
+
+	if (rs_lck && ws_lck &&  rs_sfp && ws_sfp &&
+	    rs_sfp->parentdp == ws_sfp->parentdp)
+		diff_sdps = false;
+	if (!rs_first && ws_sfp)
+		goto wr_first;
+rd_first:
+	if (rs_sfp) {
+		sdp = rs_sfp->parentdp;
+		xap = &sdp->sfp_arr;
+		rcu_assign_pointer(rs_sfp->share_sfp, NULL);
+		if (rs_lck && (rs_first || diff_sdps))
+			xa_lock_irqsave(xap, iflags);
+		__xa_set_mark(xap, rs_sfp->idx, SG_XA_FD_UNSHARED);
+		__xa_clear_mark(xap, rs_sfp->idx, SG_XA_FD_RS_SHARE);
+		if (rs_lck && (!rs_first || diff_sdps))
+			xa_unlock_irqrestore(xap, iflags);
+		kref_put(&sdp->d_ref, sg_device_destroy);
+	}
+	if (!rs_first || !ws_sfp)
+		return;
+wr_first:
+	if (ws_sfp) {
+		sdp = ws_sfp->parentdp;
+		xap = &sdp->sfp_arr;
+		rcu_assign_pointer(ws_sfp->share_sfp, NULL);
+		if (ws_lck && (!rs_first || diff_sdps))
+			xa_lock_irqsave(xap, iflags);
+		__xa_set_mark(xap, ws_sfp->idx, SG_XA_FD_UNSHARED);
+		/* SG_XA_FD_RS_SHARE mark should be already clear */
+		if (ws_lck && (rs_first || diff_sdps))
+			xa_unlock_irqrestore(xap, iflags);
+		kref_put(&sdp->d_ref, sg_device_destroy);
+	}
+	if (!rs_first && rs_sfp)
+		goto rd_first;
+}
+
+/*
+ * Clean up loose ends that occur when clsong a file descriptor which is
+ * part of a file share. There may be request shares in various states using
+ * this file share so care is needed.
+ */
+static void
+sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
+{
+	unsigned long iflags;
+	struct sg_fd *o_sfp = sg_fd_shared_ptr(sfp);
+	struct sg_device *sdp;
+	struct xarray *xap;
+
+	SG_LOG(3, sfp, "%s: sfp=0x%pK, o_sfp=0x%pK%s\n", __func__, sfp, o_sfp,
+	       (is_rd_side ? " read-side" : ""));
+	if (is_rd_side) {
+		sdp = sfp->parentdp;
+		xap = &sdp->sfp_arr;
+		xa_lock_irqsave(xap, iflags);
+		if (!xa_get_mark(xap, sfp->idx, SG_XA_FD_RS_SHARE)) {
+			xa_unlock_irqrestore(xap, iflags);
+			return;
+		}
+		sg_unshare_fds(sfp, false, NULL, false, true);
+		xa_unlock_irqrestore(&sdp->sfp_arr, iflags);
+	} else {
+		sdp = sfp->parentdp;
+		xap = &sdp->sfp_arr;
+		xa_lock_irqsave(xap, iflags);
+		if (xa_get_mark(xap, sfp->idx, SG_XA_FD_UNSHARED)) {
+			xa_unlock_irqrestore(xap, iflags);
+			return;
+		}
+		sg_unshare_fds(NULL, false, sfp, false, false);
+		xa_unlock_irqrestore(xap, iflags);
+	}
+}
+
+/*
+ * Active when writing 1 to ioctl(SG_SET_GET_EXTENDED(CTL_FLAGS(UNSHARE))),
+ * writing 0 has no effect. Undoes the configuration that has done by
+ * ioctl(SG_SET_GET_EXTENDED(SHARE_FD)).
+ */
+static void
+sg_do_unshare(struct sg_fd *sfp, bool unshare_val)
+{
+	bool retry;
+	int retry_count = 0;
+	unsigned long iflags;
+	struct sg_fd *rs_sfp;
+	struct sg_fd *ws_sfp;
+	struct sg_fd *o_sfp = sg_fd_shared_ptr(sfp);
+	struct sg_device *sdp = sfp->parentdp;
+
+	if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_UNSHARED)) {
+		SG_LOG(1, sfp, "%s: not shared ? ?\n", __func__);
+		return; /* no share to undo */
+	}
+	if (!unshare_val)
+		return;
+again:
+	retry = false;
+	xa_lock_irqsave(&sfp->srp_arr, iflags);
+	if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_RS_SHARE)) {
+		rs_sfp = sfp;
+		ws_sfp = o_sfp;
+		if (!xa_trylock(&ws_sfp->srp_arr)) {
+			if (++retry_count > SG_ADD_RQ_MAX_RETRIES)
+				SG_LOG(1, sfp, "%s: cannot get write-side lock\n",
+				       __func__);
+			else
+				retry = true;
+			goto fini;
+		}
+		sg_unshare_fds(rs_sfp, false, ws_sfp, false, false);
+		xa_unlock(&ws_sfp->srp_arr);
+	} else {			/* called on write-side fd */
+		rs_sfp = o_sfp;
+		ws_sfp = sfp;
+		if (!xa_trylock(&rs_sfp->srp_arr)) {
+			if (++retry_count > SG_ADD_RQ_MAX_RETRIES)
+				SG_LOG(1, sfp, "%s: cannot get read side lock\n",
+				       __func__);
+			else
+				retry = true;
+			goto fini;
+		}
+		sg_unshare_fds(rs_sfp, false, ws_sfp, false, true);
+		xa_unlock(&rs_sfp->srp_arr);
+	}
+fini:
+	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
+	if (retry) {
+		cpu_relax();
+		goto again;
+	}
+}
+
 /*
  * Returns duration since srp->start_ns (using boot time as an epoch). Unit
  * is nanoseconds when time_in_ns==true; else it is in milliseconds.
@@ -1748,8 +1926,8 @@ sg_rq_landed(struct sg_device *sdp, struct sg_request *srp)
  * the blocking multiple request case
  */
 static int
-sg_wait_event_srp(struct file *filp, struct sg_fd *sfp, void __user *p,
-		  struct sg_io_v4 *h4p, struct sg_request *srp)
+sg_wait_event_srp(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
+		  struct sg_request *srp)
 {
 	int res;
 	enum sg_rq_state sr_st;
@@ -1795,7 +1973,7 @@ sg_wait_event_srp(struct file *filp, struct sg_fd *sfp, void __user *p,
 	if (test_bit(SG_FRQ_IS_V4I, srp->frq_bm))
 		res = sg_receive_v4(sfp, srp, p, h4p);
 	else
-		res = sg_receive_v3(sfp, srp, SZ_SG_IO_HDR, p);
+		res = sg_receive_v3(sfp, srp, p);
 	return (res < 0) ? res : 0;
 }
 
@@ -1804,8 +1982,7 @@ sg_wait_event_srp(struct file *filp, struct sg_fd *sfp, void __user *p,
  * Returns 0 on success else a negated errno.
  */
 static int
-sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
-	     void __user *p)
+sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 {
 	int res;
 	struct sg_request *srp = NULL;
@@ -1814,7 +1991,8 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	struct sg_io_v4 *h4p = (struct sg_io_v4 *)hu8arr;
 
 	SG_LOG(3, sfp, "%s:  SG_IO%s\n", __func__,
-	       ((filp->f_flags & O_NONBLOCK) ? " O_NONBLOCK ignored" : ""));
+	       ((sfp->filp->f_flags & O_NONBLOCK) ? " O_NONBLOCK ignored" :
+						    ""));
 	res = sg_allow_if_err_recovery(sdp, false);
 	if (res)
 		return res;
@@ -1826,9 +2004,9 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 				   ((u8 __user *)p) + SZ_SG_IO_HDR,
 				   SZ_SG_IO_V4 - SZ_SG_IO_HDR))
 			return -EFAULT;
-		res = sg_submit_v4(filp, sfp, p, h4p, true, &srp);
+		res = sg_submit_v4(sfp, p, h4p, true, &srp);
 	} else if (h3p->interface_id == 'S') {
-		res = sg_v3_submit(filp, sfp, h3p, true, &srp);
+		res = sg_submit_v3(sfp, h3p, true, &srp);
 	} else {
 		pr_info_once("sg: %s: v3 or v4 interface only here\n",
 			     __func__);
@@ -1838,7 +2016,7 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		return res;
 	if (!srp)	/* mrq case: already processed all responses */
 		return res;
-	res = sg_wait_event_srp(filp, sfp, p, h4p, srp);
+	res = sg_wait_event_srp(sfp, p, h4p, srp);
 	if (res)
 		SG_LOG(1, sfp, "%s: %s=0x%pK  state: %s\n", __func__,
 		       "unexpected srp", srp,
@@ -1945,6 +2123,265 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 	return res;
 }
 
+static int
+sg_idr_max_id(int id, void *p, void *data)
+		__must_hold(&sg_index_lock)
+{
+	int *k = data;
+
+	if (*k < id)
+		*k = id;
+	return 0;
+}
+
+static int
+sg_find_sfp_helper(struct sg_fd *from_sfp, struct sg_fd *pair_sfp,
+		   bool from_rd_side, int search_fd)
+		__must_hold(&from_sfp->f_mutex)
+{
+	bool same_sdp;
+	int res = 0;
+	unsigned long iflags;
+	struct sg_device *from_sdp = from_sfp->parentdp;
+	struct sg_device *pair_sdp = pair_sfp->parentdp;
+
+	if (unlikely(!mutex_trylock(&pair_sfp->f_mutex)))
+		return -EPROBE_DEFER;	/* use to suggest re-invocation */
+	if (unlikely(!xa_get_mark(&pair_sdp->sfp_arr, pair_sfp->idx,
+				  SG_XA_FD_UNSHARED)))
+		res = -EADDRNOTAVAIL;
+	else if (unlikely(SG_HAVE_EXCLUDE(pair_sdp)))
+		res = -EPERM;
+	if (res) {
+		mutex_unlock(&pair_sfp->f_mutex);
+		return res;
+	}
+	same_sdp = (from_sdp == pair_sdp);
+	xa_lock_irqsave(&from_sdp->sfp_arr, iflags);
+	rcu_assign_pointer(from_sfp->share_sfp, pair_sfp);
+	__xa_clear_mark(&from_sdp->sfp_arr, from_sfp->idx, SG_XA_FD_UNSHARED);
+	kref_get(&from_sdp->d_ref);	/* treat share like pseudo open() */
+	if (from_rd_side)
+		__xa_set_mark(&from_sdp->sfp_arr, from_sfp->idx,
+			      SG_XA_FD_RS_SHARE);
+
+	if (!same_sdp) {
+		xa_unlock_irqrestore(&from_sdp->sfp_arr, iflags);
+		xa_lock_irqsave(&pair_sdp->sfp_arr, iflags);
+	}
+
+	mutex_unlock(&pair_sfp->f_mutex);
+	rcu_assign_pointer(pair_sfp->share_sfp, from_sfp);
+	__xa_clear_mark(&pair_sdp->sfp_arr, pair_sfp->idx, SG_XA_FD_UNSHARED);
+	if (!from_rd_side)
+		__xa_set_mark(&pair_sdp->sfp_arr, pair_sfp->idx,
+			      SG_XA_FD_RS_SHARE);
+	kref_get(&pair_sdp->d_ref);	/* keep symmetry */
+	xa_unlock_irqrestore(&pair_sdp->sfp_arr, iflags);
+	return 0;
+}
+
+/*
+ * Scans sg driver object tree looking for search_for. Returns valid pointer
+ * if found; returns negated errno twisted by ERR_PTR(); or return NULL if
+ * not found (and no error).
+ */
+static struct sg_fd *
+sg_find_sfp_by_fd(const struct file *search_for, int search_fd,
+		  struct sg_fd *from_sfp, bool from_is_rd_side)
+		__must_hold(&from_sfp->f_mutex)
+{
+	bool found = false;
+	int k, num_d;
+	int res = 0;
+	unsigned long iflags, idx;
+	struct sg_fd *sfp;
+	struct sg_device *sdp;
+
+	num_d = -1;
+	SG_LOG(6, from_sfp, "%s: enter,  from_sfp=%pK search_for=%pK\n",
+	       __func__, from_sfp, search_for);
+	read_lock_irqsave(&sg_index_lock, iflags);
+	idr_for_each(&sg_index_idr, sg_idr_max_id, &num_d);
+	++num_d;
+	for (k = 0; k < num_d; ++k) {
+		sdp = idr_find(&sg_index_idr, k);
+		if (unlikely(!sdp || SG_IS_DETACHING(sdp)))
+			continue;
+		xa_for_each_marked(&sdp->sfp_arr, idx, sfp,
+				   SG_XA_FD_UNSHARED) {
+			if (sfp == from_sfp)
+				continue;
+			if (test_bit(SG_FFD_RELEASE, sfp->ffd_bm))
+				continue;
+			if (search_for != sfp->filp)
+				continue;       /* not this one */
+			res = sg_find_sfp_helper(from_sfp, sfp,
+						 from_is_rd_side, search_fd);
+			if (res == 0) {
+				found = true;
+				break;
+			}
+		}       /* end of loop of all fd_s in current device */
+		if (res || found)
+			break;
+	}       /* end of loop of all sg devices */
+	read_unlock_irqrestore(&sg_index_lock, iflags);
+	if (found) {	/* mark both fds as part of share */
+		struct sg_device *from_sdp = from_sfp->parentdp;
+
+		xa_lock_irqsave(&sdp->sfp_arr, iflags);
+		__xa_clear_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_UNSHARED);
+		xa_unlock_irqrestore(&sdp->sfp_arr, iflags);
+		xa_lock_irqsave(&from_sdp->sfp_arr, iflags);
+		__xa_clear_mark(&from_sfp->parentdp->sfp_arr, from_sfp->idx,
+				SG_XA_FD_UNSHARED);
+		xa_unlock_irqrestore(&from_sdp->sfp_arr, iflags);
+	} else if (res == 0) {	/* fine tune error response */
+		num_d = -1;
+		read_lock_irqsave(&sg_index_lock, iflags);
+		idr_for_each(&sg_index_idr, sg_idr_max_id, &num_d);
+		++num_d;
+		for (k = 0; k < num_d; ++k) {
+			sdp = idr_find(&sg_index_idr, k);
+			if (unlikely(!sdp || SG_IS_DETACHING(sdp)))
+				continue;
+			xa_for_each(&sdp->sfp_arr, idx, sfp) {
+				if (xa_get_mark(&sdp->sfp_arr, idx,
+						SG_XA_FD_UNSHARED))
+					continue;
+				if (search_for == sfp->filp) {
+					res = -EADDRNOTAVAIL;  /* already */
+					break;
+				}
+			}
+			if (res)
+				break;
+		}
+		read_unlock_irqrestore(&sg_index_lock, iflags);
+	}
+	if (unlikely(res < 0))
+		return ERR_PTR(res);
+	return found ? sfp : NULL;
+}
+
+/*
+ * After checking the proposed read-side/write-side relationship is unique and valid,
+ * sets up pointers between read-side and write-side sg_fd objects. Returns 0 on
+ * success or negated errno value. From ioctl(EXTENDED(SG_SEIM_SHARE_FD)).
+ */
+static int
+sg_fd_share(struct sg_fd *ws_sfp, int m_fd)
+		__must_hold(&ws_sfp->f_mutex)
+{
+	bool found = false;
+	int res = 0;
+	int retry_count = 0;
+	struct file *filp;
+	struct sg_fd *rs_sfp;
+
+	SG_LOG(3, ws_sfp, "%s:  SHARE: read-side fd: %d\n", __func__, m_fd);
+	if (unlikely(!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO)))
+		return -EACCES;
+	if (unlikely(m_fd < 0))
+		return -EBADF;
+
+	if (unlikely(!xa_get_mark(&ws_sfp->parentdp->sfp_arr, ws_sfp->idx,
+				  SG_XA_FD_UNSHARED)))
+		return -EADDRINUSE;  /* don't allow chain of shares */
+	/* Alternate approach: fcheck_files(current->files, m_fd) */
+	filp = fget(m_fd);
+	if (unlikely(!filp))
+		return -ENOENT;
+	if (unlikely(ws_sfp->filp == filp)) {/* share with self is confusing */
+		res = -ELOOP;
+		goto fini;
+	}
+	SG_LOG(6, ws_sfp, "%s: read-side fd okay, scan for filp=0x%pK\n",
+	       __func__, filp);
+again:
+	rs_sfp = sg_find_sfp_by_fd(filp, m_fd, ws_sfp, false);
+	if (IS_ERR(rs_sfp)) {
+		res = PTR_ERR(rs_sfp);
+		if (res == -EPROBE_DEFER) {
+			if (unlikely(++retry_count > SG_ADD_RQ_MAX_RETRIES)) {
+				res = -EBUSY;
+			} else {
+				res = 0;
+				cpu_relax();
+				goto again;
+			}
+		}
+	} else {
+		found = !!rs_sfp;
+	}
+fini:
+	/* paired with filp=fget(m_fd) above */
+	fput(filp);
+	if (unlikely(res))
+		return res;
+	return found ? 0 : -ENOTSOCK; /* ENOTSOCK for fd exists but not sg */
+}
+
+/*
+ * After checking the proposed file share relationship is unique and
+ * valid, sets up pointers between read-side and write-side sg_fd objects.
+ * Return 0 on success or negated errno value.
+ */
+static int
+sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
+		__must_hold(&rs_sfp->f_mutex)
+{
+	bool found = false;
+	int res = 0;
+	int retry_count = 0;
+	struct file *filp;
+	struct sg_fd *ws_sfp = sg_fd_shared_ptr(rs_sfp);
+
+	SG_LOG(3, ws_sfp, "%s:  new_write_side_fd: %d\n", __func__, new_ws_fd);
+	if (unlikely(!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO)))
+		return -EACCES;
+	if (unlikely(new_ws_fd < 0))
+		return -EBADF;
+	if (unlikely(!xa_get_mark(&rs_sfp->parentdp->sfp_arr, rs_sfp->idx,
+				  SG_XA_FD_RS_SHARE)))
+		return -EINVAL;
+
+	/* Alternate approach: fcheck_files(current->files, m_fd) */
+	filp = fget(new_ws_fd);
+	if (unlikely(!filp))
+		return -ENOENT;
+	if (unlikely(rs_sfp->filp == filp)) {/* share with self is confusing */
+		res = -ELOOP;
+		goto fini;
+	}
+	SG_LOG(6, ws_sfp, "%s: write-side fd ok, scan for filp=0x%pK\n", __func__,
+	       filp);
+	sg_unshare_fds(NULL, false, ws_sfp, false, false);
+again:
+	ws_sfp = sg_find_sfp_by_fd(filp, new_ws_fd, rs_sfp, true);
+	if (IS_ERR(ws_sfp)) {
+		res = PTR_ERR(ws_sfp);
+		if (res == -EPROBE_DEFER) {
+			if (unlikely(++retry_count > SG_ADD_RQ_MAX_RETRIES)) {
+				res = -EBUSY;
+			} else {
+				res = 0;
+				cpu_relax();
+				goto again;
+			}
+		}
+	} else {
+		found = !!ws_sfp;
+	}
+fini:
+	/* paired with filp=fget(new_ws_fd) above */
+	fput(filp);
+	if (unlikely(res))
+		return res;
+	return found ? 0 : -ENOTSOCK; /* ENOTSOCK for fd exists but not sg */
+}
+
 /*
  * First normalize want_rsv_sz to be >= sfp->sgat_elem_sz and
  * <= max_segment_size. Exit if that is the same as old size; otherwise
@@ -2111,6 +2548,16 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 		else
 			c_flgs_val_out &= ~SG_CTL_FLAGM_Q_TAIL;
 	}
+	/*
+	 * UNSHARE boolean: when reading yields zero. When writing true,
+	 * unshares this fd from a previously established fd share. If
+	 * a shared commands is inflight, waits a little while for it
+	 * to finish.
+	 */
+	if (c_flgs_wm & SG_CTL_FLAGM_UNSHARE)
+		sg_do_unshare(sfp, !!(c_flgs_val_in & SG_CTL_FLAGM_UNSHARE));
+	if (c_flgs_rm & SG_CTL_FLAGM_UNSHARE)
+		c_flgs_val_out &= ~SG_CTL_FLAGM_UNSHARE;   /* clear bit */
 	/* NO_DURATION boolean, [rbw] */
 	if (c_flgs_rm & SG_CTL_FLAGM_NO_DURATION)
 		flg = test_bit(SG_FFD_NO_DURATION, sfp->ffd_bm);
@@ -2243,6 +2690,40 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 	}
 	if ((s_rd_mask & SG_SEIM_READ_VAL) && (s_wr_mask & SG_SEIM_READ_VAL))
 		sg_extended_read_value(sfp, seip);
+	/* create share: write-side gives fd of read-side to share with [raw] */
+	if (or_masks & SG_SEIM_SHARE_FD) {
+		mutex_lock(&sfp->f_mutex);
+		if (s_wr_mask & SG_SEIM_SHARE_FD) {
+			result = sg_fd_share(sfp, (int)seip->share_fd);
+			if (ret == 0 && result)
+				ret = result;
+		}
+		/* if share then yield device number of (other) read-side */
+		if (s_rd_mask & SG_SEIM_SHARE_FD) {
+			struct sg_fd *sh_sfp = sg_fd_shared_ptr(sfp);
+
+			seip->share_fd = sh_sfp ? sh_sfp->parentdp->index :
+						   U32_MAX;
+		}
+		mutex_unlock(&sfp->f_mutex);
+	}
+	/* change_share: read-side is given shr_fd of new write-side [raw] */
+	if (or_masks & SG_SEIM_CHG_SHARE_FD) {
+		mutex_lock(&sfp->f_mutex);
+		if (s_wr_mask & SG_SEIM_CHG_SHARE_FD) {
+			result = sg_fd_reshare(sfp, (int)seip->share_fd);
+			if (ret == 0 && result)
+				ret = result;
+		}
+		/* if share then yield device number of (other) write-side */
+		if (s_rd_mask & SG_SEIM_CHG_SHARE_FD) {
+			struct sg_fd *sh_sfp = sg_fd_shared_ptr(sfp);
+
+			seip->share_fd = sh_sfp ? sh_sfp->parentdp->index :
+						  U32_MAX;
+		}
+		mutex_unlock(&sfp->f_mutex);
+	}
 	/* call blk_poll() on this fd's HIPRI requests [raw] */
 	if (or_masks & SG_SEIM_BLK_POLL) {
 		n = 0;
@@ -2388,19 +2869,19 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 
 	switch (cmd_in) {
 	case SG_IO:
-		return sg_ctl_sg_io(filp, sdp, sfp, p);
+		return sg_ctl_sg_io(sdp, sfp, p);
 	case SG_IOSUBMIT:
 		SG_LOG(3, sfp, "%s:    SG_IOSUBMIT\n", __func__);
-		return sg_ctl_iosubmit(filp, sfp, p);
+		return sg_ctl_iosubmit(sfp, p);
 	case SG_IOSUBMIT_V3:
 		SG_LOG(3, sfp, "%s:    SG_IOSUBMIT_V3\n", __func__);
-		return sg_ctl_iosubmit_v3(filp, sfp, p);
+		return sg_ctl_iosubmit_v3(sfp, p);
 	case SG_IORECEIVE:
 		SG_LOG(3, sfp, "%s:    SG_IORECEIVE\n", __func__);
-		return sg_ctl_ioreceive(filp, sfp, p);
+		return sg_ctl_ioreceive(sfp, p);
 	case SG_IORECEIVE_V3:
 		SG_LOG(3, sfp, "%s:    SG_IORECEIVE_V3\n", __func__);
-		return sg_ctl_ioreceive_v3(filp, sfp, p);
+		return sg_ctl_ioreceive_v3(sfp, p);
 	case SG_IOABORT:
 		SG_LOG(3, sfp, "%s:    SG_IOABORT\n", __func__);
 		if (read_only)
@@ -3491,8 +3972,8 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	if (cwrp->cmd_len > BLK_MAX_CDB)
 		scsi_rp->cmd = long_cmdp;	/* transfer ownership */
 	if (cwrp->u_cmdp)
-		res = sg_fetch_cmnd(cwrp->filp, sfp, cwrp->u_cmdp,
-				    cwrp->cmd_len, scsi_rp->cmd);
+		res = sg_fetch_cmnd(sfp, cwrp->u_cmdp, cwrp->cmd_len,
+				    scsi_rp->cmd);
 	else
 		res = -EPROTO;
 	if (res)
@@ -4179,7 +4660,7 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 
 /* Returns pointer to sg_fd object or negated errno twisted by ERR_PTR */
 static struct sg_fd *
-sg_add_sfp(struct sg_device *sdp)
+sg_add_sfp(struct sg_device *sdp, struct file *filp)
 {
 	bool reduced = false;
 	int rbuf_len, res;
@@ -4201,6 +4682,7 @@ sg_add_sfp(struct sg_device *sdp)
 	mutex_init(&sfp->f_mutex);
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
 	sfp->timeout_user = SG_DEFAULT_TIMEOUT_USER;
+	sfp->filp = filp;
 	/* other bits in sfp->ffd_bm[1] cleared by kzalloc() above */
 	__assign_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm, SG_DEF_FORCE_PACK_ID);
 	__assign_bit(SG_FFD_CMD_Q, sfp->ffd_bm, SG_DEF_COMMAND_Q);
@@ -4360,7 +4842,22 @@ static void
 sg_remove_sfp(struct kref *kref)
 {
 	struct sg_fd *sfp = container_of(kref, struct sg_fd, f_ref);
-
+	struct sg_device *sdp = sfp->parentdp;
+	struct xarray *xap = &sdp->sfp_arr;
+
+	if (!xa_get_mark(xap, sfp->idx, SG_XA_FD_UNSHARED)) {
+		struct sg_fd *o_sfp;
+
+		o_sfp = sg_fd_shared_ptr(sfp);
+		if (o_sfp && !test_bit(SG_FFD_RELEASE, o_sfp->ffd_bm) &&
+		    !xa_get_mark(xap, sfp->idx, SG_XA_FD_UNSHARED)) {
+			mutex_lock(&o_sfp->f_mutex);
+			sg_remove_sfp_share
+				(sfp, xa_get_mark(xap, sfp->idx,
+						  SG_XA_FD_RS_SHARE));
+			mutex_unlock(&o_sfp->f_mutex);
+		}
+	}
 	INIT_WORK(&sfp->ew_fd.work, sg_remove_sfp_usercontext);
 	schedule_work(&sfp->ew_fd.work);
 }
@@ -4443,17 +4940,6 @@ struct sg_proc_deviter {
 	int fd_index;
 };
 
-static int
-sg_idr_max_id(int id, void *p, void *data)
-		__must_hold(sg_index_lock)
-{
-	int *k = data;
-
-	if (*k < id)
-		*k = id;
-	return 0;
-}
-
 static int
 sg_last_dev(void)
 {
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index 7d11905dd787..5c8a7c2c3191 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -172,6 +172,8 @@ typedef struct sg_req_info {	/* used by SG_GET_REQUEST_TABLE ioctl() */
 #define SG_SEIM_RESERVED_SIZE	0x4	/* reserved_sz of reserve request */
 #define SG_SEIM_TOT_FD_THRESH	0x8	/* tot_fd_thresh of data buffers */
 #define SG_SEIM_MINOR_INDEX	0x10	/* sg device minor index number */
+#define SG_SEIM_SHARE_FD	0x20	/* write-side gives fd of read-side */
+#define SG_SEIM_CHG_SHARE_FD	0x40	/* read-side given new write-side fd */
 #define SG_SEIM_SGAT_ELEM_SZ	0x80	/* sgat element size (>= PAGE_SIZE) */
 #define SG_SEIM_BLK_POLL	0x100	/* call blk_poll, uses 'num' field */
 #define SG_SEIM_ALL_BITS	0x1ff	/* should be OR of previous items */
@@ -182,6 +184,7 @@ typedef struct sg_req_info {	/* used by SG_GET_REQUEST_TABLE ioctl() */
 #define SG_CTL_FLAGM_OTHER_OPENS 0x4	/* rd: other sg fd_s on this dev */
 #define SG_CTL_FLAGM_ORPHANS	0x8	/* rd: orphaned requests on this fd */
 #define SG_CTL_FLAGM_Q_TAIL	0x10	/* used for future cmds on this fd */
+#define SG_CTL_FLAGM_UNSHARE	0x80	/* undo share after inflight cmd */
 #define SG_CTL_FLAGM_NO_DURATION 0x400	/* don't calc command duration */
 #define SG_CTL_FLAGM_MORE_ASYNC	0x800	/* yield EAGAIN in more cases */
 #define SG_CTL_FLAGM_ALL_BITS	0xfff	/* should be OR of previous items */
-- 
2.25.1

