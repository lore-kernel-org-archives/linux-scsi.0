Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046EAC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C09D4613B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239505AbhD0WAR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:17 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39022 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239496AbhD0V7s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:48 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id F1E512041CF;
        Tue, 27 Apr 2021 23:59:02 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id V4YZ9G-QXGXu; Tue, 27 Apr 2021 23:58:58 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 791B5204197;
        Tue, 27 Apr 2021 23:58:56 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 54/83] sg: unlikely likely
Date:   Tue, 27 Apr 2021 17:57:04 -0400
Message-Id: <20210427215733.417746-56-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Apply 'unlikely' qualifier (or 'likely' qualifier) across
almost all functions in the driver where error path departs
from the fast path.

Other small changes:
  - move sg_rep_rq_state_fail() definition before use
  - remove some remnants of when SG_IOSUBMIT and SG_IORECEIVE
    accepted both v3 and v4 interfaces. Hence no need for
    array u8 to hold either interface, simply use correct
    interface type
  - refactor some abort request code

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 576 +++++++++++++++++++++++++---------------------
 1 file changed, 314 insertions(+), 262 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index d30c0034d767..27d9ac801f11 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -369,7 +369,7 @@ static const char *sg_shr_str(enum sg_shr_var sh_var, bool long_str);
 
 /* There is a assert that SZ_SG_IO_V4 >= SZ_SG_IO_HDR in first function */
 
-#define SG_IS_DETACHING(sdp) test_bit(SG_FDEV_DETACHING, (sdp)->fdev_bm)
+#define SG_IS_DETACHING(sdp) unlikely(test_bit(SG_FDEV_DETACHING, (sdp)->fdev_bm))
 #define SG_HAVE_EXCLUDE(sdp) test_bit(SG_FDEV_EXCLUDE, (sdp)->fdev_bm)
 #define SG_IS_O_NONBLOCK(sfp) (!!((sfp)->filp->f_flags & O_NONBLOCK))
 #define SG_RQ_ACTIVE(srp) (atomic_read(&(srp)->rq_st) != SG_RQ_INACTIVE)
@@ -430,12 +430,12 @@ sg_check_file_access(struct file *filp, const char *caller)
 	compiletime_assert(SZ_SG_IO_V4 >= SZ_SG_IO_HDR,
 			   "struct sg_io_v4 should be larger than sg_io_hdr");
 
-	if (filp->f_cred != current_real_cred()) {
+	if (unlikely(filp->f_cred != current_real_cred())) {
 		pr_err_once("%s: process %d (%s) changed security contexts after opening file descriptor, this is not allowed.\n",
 			caller, task_tgid_vnr(current), current->comm);
 		return -EPERM;
 	}
-	if (uaccess_kernel()) {
+	if (unlikely(uaccess_kernel())) {
 		pr_err_once("%s: process %d (%s) called from kernel context, this is not allowed.\n",
 			caller, task_tgid_vnr(current), current->comm);
 		return -EACCES;
@@ -454,7 +454,7 @@ sg_wait_open_event(struct sg_device *sdp, bool o_excl)
 			mutex_unlock(&sdp->open_rel_lock);
 			res = wait_event_interruptible
 					(sdp->open_wait,
-					 (unlikely(SG_IS_DETACHING(sdp)) ||
+					 (SG_IS_DETACHING(sdp) ||
 					  atomic_read(&sdp->open_cnt) == 0));
 			mutex_lock(&sdp->open_rel_lock);
 
@@ -468,7 +468,7 @@ sg_wait_open_event(struct sg_device *sdp, bool o_excl)
 			mutex_unlock(&sdp->open_rel_lock);
 			res = wait_event_interruptible
 					(sdp->open_wait,
-					 (unlikely(SG_IS_DETACHING(sdp)) ||
+					 (SG_IS_DETACHING(sdp) ||
 					  !SG_HAVE_EXCLUDE(sdp)));
 			mutex_lock(&sdp->open_rel_lock);
 
@@ -532,36 +532,36 @@ sg_open(struct inode *inode, struct file *filp)
 
 	/* Prevent the device driver from vanishing while we sleep */
 	res = scsi_device_get(sdp->device);
-	if (res)
+	if (unlikely(res))
 		goto sg_put;
 	res = scsi_autopm_get_device(sdp->device);
-	if (res)
+	if (unlikely(res))
 		goto sdp_put;
 	res = sg_allow_if_err_recovery(sdp, non_block);
-	if (res)
+	if (unlikely(res))
 		goto error_out;
 
 	mutex_lock(&sdp->open_rel_lock);
 	if (op_flags & O_NONBLOCK) {
-		if (o_excl) {
+		if (unlikely(o_excl)) {
 			if (atomic_read(&sdp->open_cnt) > 0) {
 				res = -EBUSY;
 				goto error_mutex_locked;
 			}
 		} else {
-			if (SG_HAVE_EXCLUDE(sdp)) {
+			if (unlikely(SG_HAVE_EXCLUDE(sdp))) {
 				res = -EBUSY;
 				goto error_mutex_locked;
 			}
 		}
 	} else {
 		res = sg_wait_open_event(sdp, o_excl);
-		if (res) /* -ERESTARTSYS or -ENODEV */
+		if (unlikely(res)) /* -ERESTARTSYS or -ENODEV */
 			goto error_mutex_locked;
 	}
 
 	/* N.B. at this point we are holding the open_rel_lock */
-	if (o_excl)
+	if (unlikely(o_excl))
 		set_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm);
 
 	o_count = atomic_inc_return(&sdp->open_cnt);
@@ -586,7 +586,7 @@ sg_open(struct inode *inode, struct file *filp)
 	return res;
 
 out_undo:
-	if (o_excl) {		/* undo if error */
+	if (unlikely(o_excl)) {		/* undo if error */
 		clear_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm);
 		wake_up_interruptible(&sdp->open_wait);
 	}
@@ -640,7 +640,7 @@ sg_release(struct inode *inode, struct file *filp)
 	if (unlikely(!sdp))
 		return -ENXIO;
 
-	if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_FREE)) {
+	if (unlikely(xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_FREE))) {
 		SG_LOG(1, sfp, "%s: sfp erased!!!\n", __func__);
 		return 0;	/* get out but can't fail */
 	}
@@ -648,11 +648,11 @@ sg_release(struct inode *inode, struct file *filp)
 	mutex_lock(&sdp->open_rel_lock);
 	o_count = atomic_read(&sdp->open_cnt);
 	SG_LOG(3, sfp, "%s: open count before=%d\n", __func__, o_count);
-	if (test_and_set_bit(SG_FFD_RELEASE, sfp->ffd_bm))
+	if (unlikely(test_and_set_bit(SG_FFD_RELEASE, sfp->ffd_bm)))
 		SG_LOG(1, sfp, "%s: second release on this fd ? ?\n",
 		       __func__);
 	scsi_autopm_put_device(sdp->device);
-	if (!xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_FREE) &&
+	if (likely(!xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_FREE)) &&
 	    sg_fd_is_shared(sfp))
 		sg_remove_sfp_share(sfp, xa_get_mark(&sdp->sfp_arr, sfp->idx,
 						     SG_XA_FD_RS_SHARE));
@@ -696,16 +696,16 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	struct sg_comm_wr_t cwr;
 
 	res = sg_check_file_access(filp, __func__);
-	if (res)
+	if (unlikely(res))
 		return res;
 
 	sfp = filp->private_data;
 	sdp = sfp->parentdp;
 	SG_LOG(3, sfp, "%s: write(3rd arg) count=%d\n", __func__, (int)count);
 	res = sg_allow_if_err_recovery(sdp, !!(filp->f_flags & O_NONBLOCK));
-	if (res)
+	if (unlikely(res))
 		return res;
-	if (count < SZ_SG_HEADER || count > SG_WRITE_COUNT_LIMIT)
+	if (unlikely(count < SZ_SG_HEADER || count > SG_WRITE_COUNT_LIMIT))
 		return -EIO;
 #ifdef CONFIG_COMPAT
 	if (in_compat_syscall())
@@ -732,10 +732,10 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 #else
 			lt = (count < sizeof(struct sg_io_hdr));
 #endif
-			if (lt)
+			if (unlikely(lt))
 				return -EIO;
 			get_v3_hdr = true;
-			if (get_sg_io_hdr(h3p, p))
+			if (unlikely(get_sg_io_hdr(h3p, p)))
 				return -EFAULT;
 		}
 	}
@@ -758,13 +758,13 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	}
 to_v2:
 	/* v1 and v2 interfaces processed below this point */
-	if (count < (SZ_SG_HEADER + 6))
+	if (unlikely(count < SZ_SG_HEADER + 6))
 		return -EIO;    /* minimum scsi command length is 6 bytes */
 	p += SZ_SG_HEADER;
-	if (get_user(opcode, p))
+	if (unlikely(get_user(opcode, p)))
 		return -EFAULT;
 	mutex_lock(&sfp->f_mutex);
-	if (sfp->next_cmd_len > 0) {
+	if (unlikely(sfp->next_cmd_len > 0)) {
 		cmd_size = sfp->next_cmd_len;
 		sfp->next_cmd_len = 0;	/* reset, only this write() effected */
 	} else {
@@ -779,7 +779,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	mxsize = max_t(int, input_size, ohp->reply_len);
 	mxsize -= SZ_SG_HEADER;
 	input_size -= SZ_SG_HEADER;
-	if (input_size < 0)
+	if (unlikely(input_size < 0))
 		return -EIO; /* Insufficient bytes passed for this command. */
 	memset(h3p, 0, sizeof(*h3p));
 	h3p->interface_id = '\0';/* indicate v1 or v2 interface (tunnelled) */
@@ -808,7 +808,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	 * but it is possible that the app intended SG_DXFER_TO_DEV, because
 	 * there is a non-zero input_size, so emit a warning.
 	 */
-	if (h3p->dxfer_direction == SG_DXFER_TO_FROM_DEV) {
+	if (unlikely(h3p->dxfer_direction == SG_DXFER_TO_FROM_DEV)) {
 		printk_ratelimited
 			(KERN_WARNING
 			 "%s: data in/out %d/%d bytes for SCSI command 0x%x-- guessing data in;\n"
@@ -832,13 +832,13 @@ sg_chk_mmap(struct sg_fd *sfp, int rq_flags, int len)
 {
 	if (unlikely(sfp->mmap_sz == 0))
 		return -EBADFD;
-	if (atomic_read(&sfp->submitted) > 0)
+	if (unlikely(atomic_read(&sfp->submitted) > 0))
 		return -EBUSY;  /* already active requests on fd */
-	if (len > sfp->rsv_srp->sgat_h.buflen)
+	if (unlikely(len > sfp->rsv_srp->sgat_h.buflen))
 		return -ENOMEM; /* MMAP_IO size must fit in reserve */
 	if (unlikely(len > sfp->mmap_sz))
 		return -ENOMEM; /* MMAP_IO size can't exceed mmap() size */
-	if (rq_flags & SG_FLAG_DIRECT_IO)
+	if (unlikely(rq_flags & SG_FLAG_DIRECT_IO))
 		return -EINVAL; /* not both MMAP_IO and DIRECT_IO */
 	return 0;
 }
@@ -846,7 +846,7 @@ sg_chk_mmap(struct sg_fd *sfp, int rq_flags, int len)
 static int
 sg_fetch_cmnd(struct sg_fd *sfp, const u8 __user *u_cdbp, int len, u8 *cdbp)
 {
-	if (!u_cdbp || len < 6 || len > SG_MAX_CDB_SIZE)
+	if (unlikely(!u_cdbp || len < 6 || len > SG_MAX_CDB_SIZE))
 		return -EMSGSIZE;
 	if (copy_from_user(cdbp, u_cdbp, len))
 		return -EFAULT;
@@ -872,9 +872,9 @@ sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 	struct sg_comm_wr_t cwr;
 
 	/* now doing v3 blocking (sync) or non-blocking submission */
-	if (hp->flags & SGV4_FLAG_MULTIPLE_REQS)
+	if (unlikely(hp->flags & SGV4_FLAG_MULTIPLE_REQS))
 		return -ERANGE;		/* need to use v4 interface */
-	if (hp->flags & SG_FLAG_MMAP_IO) {
+	if (unlikely(hp->flags & SG_FLAG_MMAP_IO)) {
 		int res = sg_chk_mmap(sfp, hp->flags, hp->dxfer_len);
 
 		if (unlikely(res))
@@ -928,9 +928,9 @@ sg_mrq_arr_flush(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds, u32 tot_reqs,
 	u32 sz = min(tot_reqs * SZ_SG_IO_V4, cop->din_xfer_len);
 	void __user *p = uptr64(cop->din_xferp);
 
-	if (s_res)
+	if (unlikely(s_res))
 		cop->spare_out = -s_res;
-	if (!p)
+	if (unlikely(!p))
 		return 0;
 	if (sz > 0) {
 		if (copy_to_user(p, a_hds, sz))
@@ -947,14 +947,14 @@ sg_mrq_1complet(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 	struct sg_io_v4 *siv4p;
 
 	SG_LOG(3, w_sfp, "%s: start, tot_reqs=%d\n", __func__, tot_reqs);
-	if (!srp)
+	if (unlikely(!srp))
 		return -EPROTO;
 	indx = srp->s_hdr4.mrq_ind;
-	if (indx < 0 || indx >= tot_reqs)
+	if (unlikely(indx < 0 || indx >= tot_reqs))
 		return -EPROTO;
 	siv4p = a_hds + indx;
 	s_res = sg_receive_v4(w_sfp, srp, NULL, siv4p);
-	if (s_res == -EFAULT)
+	if (unlikely(s_res == -EFAULT))
 		return s_res;
 	siv4p->info |= SG_INFO_MRQ_FINI;
 	if (w_sfp->async_qp && (siv4p->flags & SGV4_FLAG_SIGNAL)) {
@@ -1067,32 +1067,32 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 			       __func__, k, "bad guard");
 			return -ERANGE;
 		}
-		if (flags & SGV4_FLAG_MULTIPLE_REQS) {
+		if (unlikely(flags & SGV4_FLAG_MULTIPLE_REQS)) {
 			SG_LOG(1, sfp, "%s: %s %u: no nested multi-reqs\n",
 			       __func__, rip, k);
 			return -ERANGE;
 		}
 		if (immed) {	/* only accept async submits on current fd */
-			if (flags & SGV4_FLAG_DO_ON_OTHER) {
+			if (unlikely(flags & SGV4_FLAG_DO_ON_OTHER)) {
 				SG_LOG(1, sfp, "%s: %s %u, %s\n", __func__,
 				       rip, k, "no IMMED with ON_OTHER");
 				return -ERANGE;
-			} else if (flags & SGV4_FLAG_SHARE) {
+			} else if (unlikely(flags & SGV4_FLAG_SHARE)) {
 				SG_LOG(1, sfp, "%s: %s %u, %s\n", __func__,
 				       rip, k, "no IMMED with FLAG_SHARE");
 				return -ERANGE;
-			} else if (flags & SGV4_FLAG_COMPLETE_B4) {
+			} else if (unlikely(flags & SGV4_FLAG_COMPLETE_B4)) {
 				SG_LOG(1, sfp, "%s: %s %u, %s\n", __func__,
 				       rip, k, "no IMMED with COMPLETE_B4");
 				return -ERANGE;
 			}
 		}
 		if (!sg_fd_is_shared(sfp)) {
-			if (flags & SGV4_FLAG_SHARE) {
+			if (unlikely(flags & SGV4_FLAG_SHARE)) {
 				SG_LOG(1, sfp, "%s: %s %u, no share\n",
 				       __func__, rip, k);
 				return -ERANGE;
-			} else if (flags & SGV4_FLAG_DO_ON_OTHER) {
+			} else if (unlikely(flags & SGV4_FLAG_DO_ON_OTHER)) {
 				SG_LOG(1, sfp, "%s: %s %u, %s do on\n",
 				       __func__, rip, k, "no other fd to");
 				return -ERANGE;
@@ -1188,13 +1188,13 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 		cdb_mxlen = 0;
 	}
 
-	if (unlikely(SG_IS_DETACHING(sdp)))
+	if (SG_IS_DETACHING(sdp))
 		return -ENODEV;
 	else if (unlikely(o_sfp && SG_IS_DETACHING((o_sfp->parentdp))))
 		return -ENODEV;
 
 	a_hds = kcalloc(tot_reqs, SZ_SG_IO_V4, GFP_KERNEL | __GFP_NOWARN);
-	if (!a_hds)
+	if (unlikely(!a_hds))
 		return -ENOMEM;
 	n = tot_reqs * SZ_SG_IO_V4;
 	if (copy_from_user(a_hds, cuptr64(cop->dout_xferp), n)) {
@@ -1261,10 +1261,6 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 			}
 			break;
 		}
-		if (!srp) {
-			s_res = -EPROTO;
-			break;
-		}
 		++num_cmpl;
 		hp->info |= SG_INFO_MRQ_FINI;
 		if (stop_if && (hp->driver_status || hp->transport_status ||
@@ -1292,14 +1288,14 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 	if (immed)
 		goto fini;
 
-	if (res == 0 && (this_fp_sent + other_fp_sent) > 0) {
+	if (likely(res == 0 && (this_fp_sent + other_fp_sent) > 0)) {
 		s_res = sg_mrq_complets(cop, a_hds, fp, o_sfp, tot_reqs,
 					this_fp_sent, other_fp_sent);
-		if (s_res == -EFAULT || s_res == -ERESTARTSYS)
+		if (unlikely(s_res == -EFAULT || s_res == -ERESTARTSYS))
 			res = s_res;	/* this may leave orphans */
 	}
 fini:
-	if (res == 0 && !immed)
+	if (likely(res == 0) && !immed)
 		res = sg_mrq_arr_flush(cop, a_hds, tot_reqs, s_res);
 	kfree(cdb_ap);
 	kfree(a_hds);
@@ -1329,7 +1325,7 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 		res = sg_do_multi_req(&cwr, sync);
 		if (unlikely(res))
 			return res;
-		if (p) {
+		if (likely(p)) {
 			/* Write back sg_io_v4 object for error/warning info */
 			if (copy_to_user(p, h4p, SZ_SG_IO_V4))
 				return -EFAULT;
@@ -1368,8 +1364,8 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 		u64 gen_tag = srp->tag;
 		struct sg_io_v4 __user *h4_up = (struct sg_io_v4 __user *)p;
 
-		if (unlikely(copy_to_user(&h4_up->generated_tag, &gen_tag,
-					  sizeof(gen_tag))))
+		if (copy_to_user(&h4_up->generated_tag, &gen_tag,
+				 sizeof(gen_tag)))
 			return -EFAULT;
 	}
 	return res;
@@ -1384,11 +1380,11 @@ sg_ctl_iosubmit(struct sg_fd *sfp, void __user *p)
 	struct sg_device *sdp = sfp->parentdp;
 
 	res = sg_allow_if_err_recovery(sdp, SG_IS_O_NONBLOCK(sfp));
-	if (res)
+	if (unlikely(res))
 		return res;
 	if (copy_from_user(h4p, p, SZ_SG_IO_V4))
 		return -EFAULT;
-	if (h4p->guard == 'Q')
+	if (likely(h4p->guard == 'Q'))
 		return sg_submit_v4(sfp, p, h4p, false, NULL);
 	return -EPERM;
 }
@@ -1406,7 +1402,7 @@ sg_ctl_iosubmit_v3(struct sg_fd *sfp, void __user *p)
 		return res;
 	if (copy_from_user(h3p, p, SZ_SG_IO_HDR))
 		return -EFAULT;
-	if (h3p->interface_id == 'S')
+	if (likely(h3p->interface_id == 'S'))
 		return sg_submit_v3(sfp, h3p, false, NULL);
 	return -EPERM;
 }
@@ -1428,26 +1424,26 @@ sg_share_chk_flags(struct sg_fd *sfp, u32 rq_flags, int dxfer_len, int dir,
 	enum sg_shr_var sh_var = SG_SHR_NONE;
 
 	if (rq_flags & SGV4_FLAG_SHARE) {
-		if (rq_flags & SG_FLAG_DIRECT_IO)
+		if (unlikely(rq_flags & SG_FLAG_DIRECT_IO))
 			result = -EINVAL; /* since no control of data buffer */
-		else if (dxfer_len < 1)
+		else if (unlikely(dxfer_len < 1))
 			result = -ENODATA;
 		else if (is_read_side) {
 			sh_var = SG_SHR_RS_RQ;
-			if (dir != SG_DXFER_FROM_DEV)
+			if (unlikely(dir != SG_DXFER_FROM_DEV))
 				result = -ENOMSG;
 			if (rq_flags & SGV4_FLAG_NO_DXFER) {
 				/* rule out some contradictions */
-				if (rq_flags & SG_FL_MMAP_DIRECT)
+				if (unlikely(rq_flags & SG_FL_MMAP_DIRECT))
 					result = -ENODATA;
 			}
 		} else {			/* fd is write-side */
 			sh_var = SG_SHR_WS_RQ;
-			if (dir != SG_DXFER_TO_DEV)
+			if (unlikely(dir != SG_DXFER_TO_DEV))
 				result = -ENOMSG;
-			if (!(rq_flags & SGV4_FLAG_NO_DXFER))
+			if (unlikely(!(rq_flags & SGV4_FLAG_NO_DXFER)))
 				result = -ENOMSG;
-			if (rq_flags & SG_FL_MMAP_DIRECT)
+			if (unlikely(rq_flags & SG_FL_MMAP_DIRECT))
 				result = -ENODATA;
 		}
 	} else if (is_read_side) {
@@ -1515,7 +1511,7 @@ sg_rq_chg_state_ulck(struct sg_request *srp, enum sg_rq_state old_st,
 		sg_rq_state_mul2arr[(int)new_st];
 	act_old_st = (enum sg_rq_state)atomic_cmpxchg(&srp->rq_st, old_st,
 						      new_st);
-	if (act_old_st != old_st) {
+	if (unlikely(act_old_st != old_st)) {
 #if IS_ENABLED(SG_LOG_ACTIVE)
 		SG_LOG(1, srp->parentfp, "%s: unexpected old state: %s\n",
 		       __func__, sg_rq_st_str(act_old_st, false));
@@ -1671,14 +1667,14 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 	struct sg_io_hdr *hi_p;
 	struct sg_io_v4 *h4p;
 
-	if (test_bit(SG_FRQ_IS_V4I, cwrp->frq_bm)) {
+	if (likely(test_bit(SG_FRQ_IS_V4I, cwrp->frq_bm))) {
 		h4p = cwrp->h4p;
 		hi_p = NULL;
 		dxfr_len = 0;
 		dir = SG_DXFER_NONE;
 		rq_flags = h4p->flags;
 		pack_id = h4p->request_extra;
-		if (h4p->din_xfer_len && h4p->dout_xfer_len) {
+		if (unlikely(h4p->din_xfer_len && h4p->dout_xfer_len)) {
 			return ERR_PTR(-EOPNOTSUPP);
 		} else if (h4p->din_xfer_len) {
 			dxfr_len = h4p->din_xfer_len;
@@ -1695,7 +1691,7 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		rq_flags = hi_p->flags;
 		pack_id = hi_p->pack_id;
 	}
-	if (rq_flags & SGV4_FLAG_MULTIPLE_REQS)
+	if (unlikely(rq_flags & SGV4_FLAG_MULTIPLE_REQS))
 		return ERR_PTR(-ERANGE);
 	if (sg_fd_is_shared(fp)) {
 		res = sg_share_chk_flags(fp, rq_flags, dxfr_len, dir, &sh_var);
@@ -1706,7 +1702,7 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		if (rq_flags & SGV4_FLAG_SHARE)
 			return ERR_PTR(-ENOMSG);
 	}
-	if (dxfr_len >= SZ_256M)
+	if (unlikely(dxfr_len >= SZ_256M))
 		return ERR_PTR(-EINVAL);
 
 	srp = sg_setup_req(cwrp, sh_var, dxfr_len);
@@ -1715,7 +1711,7 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 	srp->rq_flags = rq_flags;
 	srp->pack_id = pack_id;
 
-	if (h4p) {
+	if (likely(h4p)) {
 		srp->s_hdr4.usr_ptr = h4p->usr_ptr;
 		srp->s_hdr4.sbp = uptr64(h4p->response);
 		srp->s_hdr4.max_sb_len = h4p->max_response_len;
@@ -1726,11 +1722,11 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		memcpy(&srp->s_hdr3, hi_p, sizeof(srp->s_hdr3));
 	}
 	res = sg_start_req(srp, cwrp, dir);
-	if (res < 0)		/* probably out of space --> -ENOMEM */
+	if (unlikely(res < 0))	/* probably out of space --> -ENOMEM */
 		goto err_out;
 	SG_LOG(4, fp, "%s: opcode=0x%02x, cdb_sz=%d, pack_id=%d\n", __func__,
 	       srp->cmd_opcode, cwrp->cmd_len, pack_id);
-	if (unlikely(SG_IS_DETACHING(sdp))) {
+	if (SG_IS_DETACHING(sdp)) {
 		res = -ENODEV;
 		goto err_out;
 	}
@@ -1761,7 +1757,7 @@ sg_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp, int id,
 {
 	struct sg_request *srp;
 
-	if (unlikely(SG_IS_DETACHING(sfp->parentdp))) {
+	if (SG_IS_DETACHING(sfp->parentdp)) {
 		*srpp = ERR_PTR(-ENODEV);
 		return true;
 	}
@@ -1782,8 +1778,8 @@ sg_copy_sense(struct sg_request *srp, bool v4_active)
 
 	/* If need be, copy the sense buffer to the user space */
 	scsi_stat = srp->rq_result & 0xff;
-	if ((scsi_stat & SAM_STAT_CHECK_CONDITION) ||
-	    (driver_byte(srp->rq_result) & DRIVER_SENSE)) {
+	if (unlikely((scsi_stat & SAM_STAT_CHECK_CONDITION) ||
+		     (driver_byte(srp->rq_result) & DRIVER_SENSE))) {
 		int sb_len = min_t(int, SCSI_SENSE_BUFFERSIZE, srp->sense_len);
 		int mx_sb_len;
 		u8 *sbp = srp->sense_bp;
@@ -1821,12 +1817,12 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 	if (unlikely(srp->rq_result & 0xff)) {
 		int sb_len_wr = sg_copy_sense(srp, v4_active);
 
-		if (sb_len_wr < 0)
+		if (unlikely(sb_len_wr < 0))
 			return sb_len_wr;
 	}
 	if (rq_res & SG_ML_RESULT_MSK)
 		srp->rq_info |= SG_INFO_CHECK;
-	if (test_bit(SG_FRQ_ABORTING, srp->frq_bm))
+	if (unlikely(test_bit(SG_FRQ_ABORTING, srp->frq_bm)))
 		srp->rq_info |= SG_INFO_ABORTED;
 
 	sh_sfp = sg_fd_share_ptr(sfp);
@@ -1856,7 +1852,7 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 			break;	/* nothing to do */
 		}
 	}
-	if (unlikely(SG_IS_DETACHING(sfp->parentdp)))
+	if (SG_IS_DETACHING(sfp->parentdp))
 		srp->rq_info |= SG_INFO_DEVICE_DETACHING;
 	return err;
 }
@@ -1873,7 +1869,8 @@ sg_complete_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool other_err)
 			int poll_type = POLL_OUT;
 			struct sg_fd *ws_sfp = sg_fd_share_ptr(sfp);
 
-			if ((srp->rq_result & SG_ML_RESULT_MSK) || other_err) {
+			if (unlikely((srp->rq_result & SG_ML_RESULT_MSK) ||
+				     other_err)) {
 				set_bit(SG_FFD_READ_SIDE_ERR, sfp->ffd_bm);
 				if (sr_st != SG_RQ_BUSY)
 					sg_rq_chg_state_force(srp, SG_RQ_BUSY);
@@ -1892,7 +1889,7 @@ sg_complete_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool other_err)
 		{
 			struct sg_fd *rs_sfp = sg_fd_share_ptr(sfp);
 
-			if (rs_sfp) {
+			if (likely(rs_sfp)) {
 				rs_sfp->ws_srp = NULL;
 				if (rs_sfp->rsv_srp)
 					rs_sfp->rsv_srp->sh_var =
@@ -1955,7 +1952,7 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
 	sg_complete_v3v4(sfp, srp, err < 0);
 	sg_finish_scsi_blk_rq(srp);
 	sg_deact_request(sfp, srp);
-	return err < 0 ? err : 0;
+	return unlikely(err < 0) ? err : 0;
 }
 
 /*
@@ -2017,16 +2014,16 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p,
 
 	SG_LOG(3, sfp, "%s: non_block=%d\n", __func__, !!non_block);
 	n = cop->din_xfer_len;
-	if (n > SG_MAX_MULTI_REQ_SZ)
+	if (unlikely(n > SG_MAX_MULTI_REQ_SZ))
 		return -E2BIG;
-	if (!cop->din_xferp || n < SZ_SG_IO_V4 || (n % SZ_SG_IO_V4))
+	if (unlikely(!cop->din_xferp || n < SZ_SG_IO_V4 || (n % SZ_SG_IO_V4)))
 		return -ERANGE;
 	n /= SZ_SG_IO_V4;
 	len = n * SZ_SG_IO_V4;
 	SG_LOG(3, sfp, "%s: %s, num_reqs=%u\n", __func__,
 	       (non_block ? "IMMED" : "blocking"), n);
 	rsp_v4_arr = kcalloc(n, SZ_SG_IO_V4, GFP_KERNEL);
-	if (!rsp_v4_arr)
+	if (unlikely(!rsp_v4_arr))
 		return -ENOMEM;
 
 	sg_sgv4_out_zero(cop);
@@ -2040,7 +2037,7 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p,
 		return -EFAULT;
 	res = 0;
 	pp = uptr64(cop->din_xferp);
-	if (pp) {
+	if (likely(pp)) {
 		if (copy_to_user(pp, rsp_v4_arr, len))
 			res = -EFAULT;
 	} else {
@@ -2066,19 +2063,20 @@ sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 	int res, id;
 	int pack_id = SG_PACK_ID_WILDCARD;
 	int tag = SG_TAG_WILDCARD;
-	u8 v4_holder[SZ_SG_IO_V4];
-	struct sg_io_v4 *h4p = (struct sg_io_v4 *)v4_holder;
+	struct sg_io_v4 h4;
+	struct sg_io_v4 *h4p = &h4;
 	struct sg_device *sdp = sfp->parentdp;
 	struct sg_request *srp;
 
 	res = sg_allow_if_err_recovery(sdp, non_block);
-	if (res)
+	if (unlikely(res))
 		return res;
 	/* Get first three 32 bit integers: guard, proto+subproto */
 	if (copy_from_user(h4p, p, SZ_SG_IO_V4))
 		return -EFAULT;
 	/* for v4: protocol=0 --> SCSI;  subprotocol=0 --> SPC++ */
-	if (h4p->guard != 'Q' || h4p->protocol != 0 || h4p->subprotocol != 0)
+	if (unlikely(h4p->guard != 'Q' || h4p->protocol != 0 ||
+		     h4p->subprotocol != 0))
 		return -EPERM;
 	if (h4p->flags & SGV4_FLAG_IMMED)
 		non_block = true;	/* set by either this or O_NONBLOCK */
@@ -2097,14 +2095,14 @@ sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 try_again:
 	srp = sg_find_srp_by_id(sfp, id, use_tag);
 	if (!srp) {     /* nothing available so wait on packet or */
-		if (unlikely(SG_IS_DETACHING(sdp)))
+		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
 		if (non_block)
 			return -EAGAIN;
 		res = wait_event_interruptible
 				(sfp->cmpl_wait,
 				 sg_get_ready_srp(sfp, &srp, id, use_tag));
-		if (res)
+		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
 		if (IS_ERR(srp))
 			return PTR_ERR(srp);
@@ -2129,8 +2127,8 @@ sg_ctl_ioreceive_v3(struct sg_fd *sfp, void __user *p)
 	bool non_block = SG_IS_O_NONBLOCK(sfp);
 	int res;
 	int pack_id = SG_PACK_ID_WILDCARD;
-	u8 v3_holder[SZ_SG_IO_HDR];
-	struct sg_io_hdr *h3p = (struct sg_io_hdr *)v3_holder;
+	struct sg_io_hdr h3;
+	struct sg_io_hdr *h3p = &h3;
 	struct sg_device *sdp = sfp->parentdp;
 	struct sg_request *srp;
 
@@ -2141,12 +2139,12 @@ sg_ctl_ioreceive_v3(struct sg_fd *sfp, void __user *p)
 	if (copy_from_user(h3p, p, SZ_SG_IO_HDR))
 		return -EFAULT;
 	/* for v3: interface_id=='S' (in a 32 bit int) */
-	if (h3p->interface_id != 'S')
+	if (unlikely(h3p->interface_id != 'S'))
 		return -EPERM;
 	if (h3p->flags & SGV4_FLAG_IMMED)
 		non_block = true;	/* set by either this or O_NONBLOCK */
 	SG_LOG(3, sfp, "%s: non_block(+IMMED)=%d\n", __func__, non_block);
-	if (h3p->flags & SGV4_FLAG_MULTIPLE_REQS)
+	if (unlikely(h3p->flags & SGV4_FLAG_MULTIPLE_REQS))
 		return -EINVAL;
 
 	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm))
@@ -2154,7 +2152,7 @@ sg_ctl_ioreceive_v3(struct sg_fd *sfp, void __user *p)
 try_again:
 	srp = sg_find_srp_by_id(sfp, pack_id, false);
 	if (!srp) {     /* nothing available so wait on packet or */
-		if (unlikely(SG_IS_DETACHING(sdp)))
+		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
 		if (non_block)
 			return -EAGAIN;
@@ -2193,9 +2191,9 @@ sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 	h2p->target_status = status_byte(rq_result);
 	h2p->host_status = host_byte(rq_result);
 	h2p->driver_status = driver_byte(rq_result);
-	if ((CHECK_CONDITION & status_byte(rq_result)) ||
-	    (DRIVER_SENSE & driver_byte(rq_result))) {
-		if (srp->sense_bp) {
+	if (unlikely((CHECK_CONDITION & status_byte(rq_result)) ||
+		     (DRIVER_SENSE & driver_byte(rq_result)))) {
+		if (likely(srp->sense_bp)) {
 			u8 *sbp = srp->sense_bp;
 
 			srp->sense_bp = NULL;
@@ -2204,7 +2202,7 @@ sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 			mempool_free(sbp, sg_sense_pool);
 		}
 	}
-	switch (host_byte(rq_result)) {
+	switch (unlikely(host_byte(rq_result))) {
 	/*
 	 * This following setting of 'result' is for backward compatibility
 	 * and is best ignored by the user who should use target, host and
@@ -2246,7 +2244,7 @@ sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 			count = h2p->reply_len;
 		if (count > SZ_SG_HEADER) {
 			res = sg_read_append(srp, buf, count - SZ_SG_HEADER);
-			if (res)
+			if (unlikely(res))
 				goto fini;
 		}
 	} else {
@@ -2282,14 +2280,14 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 	 * file descriptor to free up any resources being held.
 	 */
 	ret = sg_check_file_access(filp, __func__);
-	if (ret)
+	if (unlikely(ret))
 		return ret;
 
 	sfp = filp->private_data;
 	sdp = sfp->parentdp;
 	SG_LOG(3, sfp, "%s: read() count=%d\n", __func__, (int)count);
 	ret = sg_allow_if_err_recovery(sdp, non_block);
-	if (ret)
+	if (unlikely(ret))
 		return ret;
 
 	could_be_v3 = (count >= SZ_SG_IO_HDR);
@@ -2307,12 +2305,12 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 		if (h2p->reply_len < 0 && could_be_v3) {
 			struct sg_io_hdr *v3_hdr = (struct sg_io_hdr *)h2p;
 
-			if (v3_hdr->interface_id == 'S') {
+			if (likely(v3_hdr->interface_id == 'S')) {
 				struct sg_io_hdr __user *h3_up;
 
 				h3_up = (struct sg_io_hdr __user *)p;
 				ret = get_user(want_id, &h3_up->pack_id);
-				if (ret)
+				if (unlikely(ret))
 					return ret;
 				if (!non_block) {
 					int flgs;
@@ -2337,14 +2335,14 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 try_again:
 	srp = sg_find_srp_by_id(sfp, want_id, false);
 	if (!srp) {	/* nothing available so wait on packet to arrive or */
-		if (unlikely(SG_IS_DETACHING(sdp)))
+		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
 		if (non_block) /* O_NONBLOCK or v3::flags & SGV4_FLAG_IMMED */
 			return -EAGAIN;
 		ret = wait_event_interruptible
 				(sfp->cmpl_wait,
 				 sg_get_ready_srp(sfp, &srp, want_id, false));
-		if (ret)	/* -ERESTARTSYS as signal hit process */
+		if (unlikely(ret))  /* -ERESTARTSYS as signal hit process */
 			return ret;
 		if (IS_ERR(srp))
 			return PTR_ERR(srp);
@@ -2365,9 +2363,11 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 		}
 		ret = sg_receive_v3(sfp, srp, p);
 	}
-	if (ret < 0)
+#if IS_ENABLED(SG_LOG_ACTIVE)
+	if (unlikely(ret < 0))
 		SG_LOG(1, sfp, "%s: negated errno: %d\n", __func__, ret);
-	return ret < 0 ? ret : (int)count;
+#endif
+	return unlikely(ret < 0) ? ret : (int)count;
 }
 
 /*
@@ -2496,7 +2496,7 @@ sg_change_after_read_side_rq(struct sg_fd *sfp, bool fini1_again0)
 		case SG_RQ_BUSY:
 			res = -EAGAIN;
 			break;
-		default:	/* read-side in SG_RQ_SHR_SWAIT is bad */
+		default:
 			res = -EINVAL;
 			break;
 		}
@@ -2589,14 +2589,15 @@ sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
 	if (is_rd_side) {
 		bool set_inactive = false;
 
-		if (!xa_get_mark(xadp, sfp->idx, SG_XA_FD_RS_SHARE)) {
+		if (unlikely(!xa_get_mark(xadp, sfp->idx,
+					  SG_XA_FD_RS_SHARE))) {
 			xa_unlock_irqrestore(xadp, iflags);
 			return;
 		}
 		rsv_srp = sfp->rsv_srp;
-		if (!rsv_srp)
+		if (unlikely(!rsv_srp))
 			goto fini;
-		if (rsv_srp->sh_var != SG_SHR_RS_RQ)
+		if (unlikely(rsv_srp->sh_var != SG_SHR_RS_RQ))
 			goto fini;
 		sr_st = atomic_read(&rsv_srp->rq_st);
 		switch (sr_st) {
@@ -2626,7 +2627,7 @@ sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
 			sg_unshare_ws_fd(sh_sfp, sdp != sh_sdp);
 		sg_unshare_rs_fd(sfp, false);
 	} else {
-		if (!sg_fd_is_shared(sfp)) {
+		if (unlikely(!sg_fd_is_shared(sfp))) {
 			xa_unlock_irqrestore(xadp, iflags);
 			return;
 		} else if (!xa_get_mark(&sh_sdp->sfp_arr, sh_sfp->idx,
@@ -2788,8 +2789,7 @@ sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp,
 static inline bool
 sg_rq_landed(struct sg_device *sdp, struct sg_request *srp)
 {
-	return atomic_read_acquire(&srp->rq_st) != SG_RQ_INFLIGHT ||
-	       unlikely(SG_IS_DETACHING(sdp));
+	return atomic_read_acquire(&srp->rq_st) != SG_RQ_INFLIGHT || SG_IS_DETACHING(sdp);
 }
 
 /*
@@ -2827,7 +2827,7 @@ sg_wait_event_srp(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 		return res;
 	}
 skip_wait:
-	if (unlikely(SG_IS_DETACHING(sdp))) {
+	if (SG_IS_DETACHING(sdp)) {
 		sg_rq_chg_state_force(srp, SG_RQ_INACTIVE);
 		atomic_inc(&sfp->inactives);
 		return -ENODEV;
@@ -2865,15 +2865,25 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 	SG_LOG(3, sfp, "%s:  SG_IO%s\n", __func__,
 	       (SG_IS_O_NONBLOCK(sfp) ? " O_NONBLOCK ignored" : ""));
 	res = sg_allow_if_err_recovery(sdp, false);
-	if (res)
+	if (unlikely(res))
 		return res;
-	if (get_sg_io_hdr(h3p, p))
+	if (unlikely(get_sg_io_hdr(h3p, p)))
 		return -EFAULT;
 	if (h3p->interface_id == 'Q') {
 		/* copy in rest of sg_io_v4 object */
-		if (copy_from_user(hu8arr + SZ_SG_IO_HDR,
-				   ((u8 __user *)p) + SZ_SG_IO_HDR,
-				   SZ_SG_IO_V4 - SZ_SG_IO_HDR))
+		int v3_len;
+
+#ifdef CONFIG_COMPAT
+		if (in_compat_syscall())
+			v3_len = sizeof(struct compat_sg_io_hdr);
+		else
+			v3_len = SZ_SG_IO_HDR;
+#else
+		v3_len = SZ_SG_IO_HDR;
+#endif
+		if (copy_from_user(hu8arr + v3_len,
+				   ((u8 __user *)p) + v3_len,
+				   SZ_SG_IO_V4 - v3_len))
 			return -EFAULT;
 		res = sg_submit_v4(sfp, p, h4p, true, &srp);
 	} else if (h3p->interface_id == 'S') {
@@ -2932,6 +2942,61 @@ sg_match_request(struct sg_fd *sfp, bool use_tag, int id)
 	return NULL;
 }
 
+static int
+sg_abort_req(struct sg_fd *sfp, struct sg_request *srp)
+		__must_hold(&sfp->srp_arr->xa_lock)
+{
+	int res = 0;
+	enum sg_rq_state rq_st;
+
+	if (test_and_set_bit(SG_FRQ_ABORTING, srp->frq_bm)) {
+		SG_LOG(1, sfp, "%s: already aborting req pack_id/tag=%d/%d\n",
+		       __func__, srp->pack_id, srp->tag);
+		goto fini;	/* skip quietly if already aborted */
+	}
+	rq_st = atomic_read(&srp->rq_st);
+	SG_LOG(3, sfp, "%s: req pack_id/tag=%d/%d, status=%s\n", __func__,
+	       srp->pack_id, srp->tag, sg_rq_st_str(rq_st, false));
+	switch (rq_st) {
+	case SG_RQ_BUSY:
+		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
+		res = -EBUSY;	/* should not occur often */
+		break;
+	case SG_RQ_INACTIVE:	/* perhaps done already */
+		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
+		break;
+	case SG_RQ_AWAIT_RCV:	/* user should still do completion */
+	case SG_RQ_SHR_SWAP:
+	case SG_RQ_SHR_IN_WS:
+		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
+		break;		/* nothing to do here, return 0 */
+	case SG_RQ_INFLIGHT:	/* only attempt abort if inflight */
+		srp->rq_result |= (DRIVER_SOFT << 24);
+		{
+			struct request *rqq = READ_ONCE(srp->rqq);
+
+			if (likely(rqq)) {
+				SG_LOG(5, sfp, "%s: -->blk_abort_request srp=0x%pK\n",
+				       __func__, srp);
+				blk_abort_request(rqq);
+			}
+		}
+		break;
+	default:
+		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
+		break;
+	}
+fini:
+	return res;
+}
+
+/*
+ * Tries to abort an inflight request/command. First it checks the current fd
+ * for a match on pack_id or tag. If there is a match, aborts that match.
+ * Otherwise, if SGV4_FLAG_DEV_SCOPE is set, the rest of the file descriptors
+ * belonging to the current device are similarly checked. If there is no match
+ * then -ENODATA is returned.
+ */
 static int
 sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		__must_hold(sfp->f_mutex)
@@ -2973,37 +3038,7 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		if (!srp)
 			return -ENODATA;
 	}
-
-	if (test_and_set_bit(SG_FRQ_ABORTING, srp->frq_bm))
-		goto fini;
-
-	switch (atomic_read(&srp->rq_st)) {
-	case SG_RQ_BUSY:
-		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
-		res = -EBUSY;	/* should not occur often */
-		break;
-	case SG_RQ_INACTIVE:	/* perhaps done already */
-		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
-		break;
-	case SG_RQ_AWAIT_RCV:	/* user should still do completion */
-	case SG_RQ_SHR_SWAP:
-	case SG_RQ_SHR_IN_WS:
-		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
-		break;		/* nothing to do here, return 0 */
-	case SG_RQ_INFLIGHT:	/* only attempt abort if inflight */
-		srp->rq_result |= (DRIVER_SOFT << 24);
-		{
-			struct request *rqq = READ_ONCE(srp->rqq);
-
-			if (rqq)
-				blk_abort_request(rqq);
-		}
-		break;
-	default:
-		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
-		break;
-	}
-fini:
+	res = sg_abort_req(sfp, srp);
 	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 	return res;
 }
@@ -3102,7 +3137,7 @@ sg_find_sfp_by_fd(const struct file *search_for, int search_fd,
 				continue;       /* not this one */
 			res = sg_find_sfp_helper(from_sfp, sfp,
 						 from_is_rd_side, search_fd);
-			if (res == 0) {
+			if (likely(res == 0)) {
 				found = true;
 				break;
 			}
@@ -3217,6 +3252,7 @@ sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
 	bool found = false;
 	int res = 0;
 	int retry_count = 0;
+	enum sg_rq_state rq_st;
 	struct file *filp;
 	struct sg_fd *ws_sfp = sg_fd_share_ptr(rs_sfp);
 
@@ -3228,6 +3264,17 @@ sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
 	if (unlikely(!xa_get_mark(&rs_sfp->parentdp->sfp_arr, rs_sfp->idx,
 				  SG_XA_FD_RS_SHARE)))
 		return -EINVAL;
+	if (unlikely(!ws_sfp))
+		return -EINVAL;
+	if (unlikely(!rs_sfp->rsv_srp))
+		res = -EPROTO;	/* Internal error */
+	rq_st = atomic_read(&rs_sfp->rsv_srp->rq_st);
+	if (!(rq_st == SG_RQ_INACTIVE || rq_st == SG_RQ_SHR_SWAP))
+		res = -EBUSY;		/* read-side reserve buffer busy */
+	if (rs_sfp->ws_srp)
+		res = -EBUSY;	/* previous write-side request not finished */
+	if (unlikely(res))
+		return res;
 
 	/* Alternate approach: fcheck_files(current->files, m_fd) */
 	filp = fget(new_ws_fd);
@@ -3289,7 +3336,7 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 	if (unlikely(sg_fd_is_shared(sfp)))
 		return -EBUSY;	/* this fd can't be either side of share */
 	o_srp = sfp->rsv_srp;
-	if (!o_srp)
+	if (unlikely(!o_srp))
 		return -EPROTO;
 	new_sz = min_t(int, want_rsv_sz, sdp->max_sgat_sz);
 	new_sz = max_t(int, new_sz, sfp->sgat_elem_sz);
@@ -3304,11 +3351,11 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 	/* new sg_request object, sized correctly is now available */
 try_again:
 	o_srp = sfp->rsv_srp;
-	if (!o_srp) {
+	if (unlikely(!o_srp)) {
 		res = -EPROTO;
 		goto fini;
 	}
-	if (SG_RQ_ACTIVE(o_srp) || sfp->mmap_sz > 0) {
+	if (unlikely(SG_RQ_ACTIVE(o_srp) || sfp->mmap_sz > 0)) {
 		res = -EBUSY;
 		goto fini;
 	}
@@ -3615,7 +3662,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 	s_wr_mask = seip->sei_wr_mask;
 	s_rd_mask = seip->sei_rd_mask;
 	or_masks = s_wr_mask | s_rd_mask;
-	if (or_masks == 0) {
+	if (unlikely(or_masks == 0)) {
 		SG_LOG(2, sfp, "%s: both masks 0, do nothing\n", __func__);
 		return 0;
 	}
@@ -3653,7 +3700,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 		mutex_lock(&sfp->f_mutex);
 		if (s_wr_mask & SG_SEIM_SHARE_FD) {
 			result = sg_fd_share(sfp, (int)seip->share_fd);
-			if (ret == 0 && result)
+			if (ret == 0 && unlikely(result))
 				ret = result;
 		}
 		/* if share then yield device number of (other) read-side */
@@ -3670,7 +3717,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 		mutex_lock(&sfp->f_mutex);
 		if (s_wr_mask & SG_SEIM_CHG_SHARE_FD) {
 			result = sg_fd_reshare(sfp, (int)seip->share_fd);
-			if (ret == 0 && result)
+			if (ret == 0 && unlikely(result))
 				ret = result;
 		}
 		/* if share then yield device number of (other) write-side */
@@ -3718,7 +3765,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 	if (s_wr_mask & SG_SEIM_RESERVED_SIZE) {
 		mutex_lock(&sfp->f_mutex);
 		result = sg_set_reserved_sz(sfp, (int)seip->reserved_sz);
-		if (ret == 0 && result)
+		if (ret == 0 && unlikely(result))
 			ret = result;
 		mutex_unlock(&sfp->f_mutex);
 	}
@@ -3743,7 +3790,8 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 static int
 sg_ctl_req_tbl(struct sg_fd *sfp, void __user *p)
 {
-	int k, result, val;
+	int k, val;
+	int result = 0;
 	unsigned long idx;
 	struct sg_request *srp;
 	struct sg_req_info *rinfop;
@@ -3751,11 +3799,11 @@ sg_ctl_req_tbl(struct sg_fd *sfp, void __user *p)
 	SG_LOG(3, sfp, "%s:    SG_GET_REQUEST_TABLE\n", __func__);
 	k = SG_MAX_QUEUE;
 	rinfop = kcalloc(k, SZ_SG_REQ_INFO, GFP_KERNEL);
-	if (!rinfop)
+	if (unlikely(!rinfop))
 		return -ENOMEM;
 	val = 0;
 	xa_for_each(&sfp->srp_arr, idx, srp) {
-		if (val >= SG_MAX_QUEUE)
+		if (unlikely(val >= SG_MAX_QUEUE))
 			break;
 		if (xa_get_mark(&sfp->srp_arr, idx, SG_XA_RQ_INACTIVE))
 			continue;
@@ -3763,7 +3811,7 @@ sg_ctl_req_tbl(struct sg_fd *sfp, void __user *p)
 		val++;
 	}
 	xa_for_each(&sfp->srp_arr, idx, srp) {
-		if (val >= SG_MAX_QUEUE)
+		if (unlikely(val >= SG_MAX_QUEUE))
 			break;
 		if (!xa_get_mark(&sfp->srp_arr, idx, SG_XA_RQ_INACTIVE))
 			continue;
@@ -3825,34 +3873,34 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 
 	switch (cmd_in) {
 	case SG_IO:
-		if (unlikely(SG_IS_DETACHING(sdp)))
+		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
 		return sg_ctl_sg_io(sdp, sfp, p);
 	case SG_IOSUBMIT:
 		SG_LOG(3, sfp, "%s:    SG_IOSUBMIT\n", __func__);
-		if (unlikely(SG_IS_DETACHING(sdp)))
+		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
 		return sg_ctl_iosubmit(sfp, p);
 	case SG_IOSUBMIT_V3:
 		SG_LOG(3, sfp, "%s:    SG_IOSUBMIT_V3\n", __func__);
-		if (unlikely(SG_IS_DETACHING(sdp)))
+		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
 		return sg_ctl_iosubmit_v3(sfp, p);
 	case SG_IORECEIVE:
 		SG_LOG(3, sfp, "%s:    SG_IORECEIVE\n", __func__);
-		if (unlikely(SG_IS_DETACHING(sdp)))
+		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
 		return sg_ctl_ioreceive(sfp, p);
 	case SG_IORECEIVE_V3:
 		SG_LOG(3, sfp, "%s:    SG_IORECEIVE_V3\n", __func__);
-		if (unlikely(SG_IS_DETACHING(sdp)))
+		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
 		return sg_ctl_ioreceive_v3(sfp, p);
 	case SG_IOABORT:
 		SG_LOG(3, sfp, "%s:    SG_IOABORT\n", __func__);
-		if (unlikely(SG_IS_DETACHING(sdp)))
+		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
-		if (read_only)
+		if (unlikely(read_only))
 			return -EPERM;
 		mutex_lock(&sfp->f_mutex);
 		res = sg_ctl_abort(sdp, sfp, p);
@@ -3866,7 +3914,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	case SG_SET_FORCE_PACK_ID:
 		SG_LOG(3, sfp, "%s:    SG_SET_FORCE_PACK_ID\n", __func__);
 		res = get_user(val, ip);
-		if (res)
+		if (unlikely(res))
 			return res;
 		assign_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm, !!val);
 		return 0;
@@ -3905,8 +3953,8 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		return put_user(sdp->max_sgat_sz, ip);
 	case SG_SET_RESERVED_SIZE:
 		res = get_user(val, ip);
-		if (!res) {
-			if (val >= 0 && val <= (1024 * 1024 * 1024)) {
+		if (likely(!res)) {
+			if (likely(val >= 0 && val <= (1024 * 1024 * 1024))) {
 				mutex_lock(&sfp->f_mutex);
 				res = sg_set_reserved_sz(sfp, val);
 				mutex_unlock(&sfp->f_mutex);
@@ -3921,14 +3969,14 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		val = min_t(int, sfp->rsv_srp->sgatp->buflen,
 			    sdp->max_sgat_sz);
 		mutex_unlock(&sfp->f_mutex);
-		SG_LOG(3, sfp, "%s:    SG_GET_RESERVED_SIZE=%d\n",
-		       __func__, val);
+		SG_LOG(3, sfp, "%s:    SG_GET_RESERVED_SIZE=%d\n", __func__,
+		       val);
 		res = put_user(val, ip);
 		return res;
 	case SG_SET_COMMAND_Q:
 		SG_LOG(3, sfp, "%s:    SG_SET_COMMAND_Q\n", __func__);
 		res = get_user(val, ip);
-		if (res)
+		if (unlikely(res))
 			return res;
 		assign_bit(SG_FFD_CMD_Q, sfp->ffd_bm, !!val);
 		return 0;
@@ -3938,7 +3986,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	case SG_SET_KEEP_ORPHAN:
 		SG_LOG(3, sfp, "%s:    SG_SET_KEEP_ORPHAN\n", __func__);
 		res = get_user(val, ip);
-		if (res)
+		if (unlikely(res))
 			return res;
 		assign_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm, !!val);
 		return 0;
@@ -3957,9 +4005,9 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	case SG_SET_TIMEOUT:
 		SG_LOG(3, sfp, "%s:    SG_SET_TIMEOUT\n", __func__);
 		res = get_user(val, ip);
-		if (res)
+		if (unlikely(res))
 			return res;
-		if (val < 0)
+		if (unlikely(val < 0))
 			return -EIO;
 		if (val >= mult_frac((s64)INT_MAX, USER_HZ, HZ))
 			val = min_t(s64, mult_frac((s64)INT_MAX, USER_HZ, HZ),
@@ -3985,9 +4033,9 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	case SG_NEXT_CMD_LEN:	/* active only in v2 interface */
 		SG_LOG(3, sfp, "%s:    SG_NEXT_CMD_LEN\n", __func__);
 		res = get_user(val, ip);
-		if (res)
+		if (unlikely(res))
 			return res;
-		if (val > SG_MAX_CDB_SIZE)
+		if (unlikely(val > SG_MAX_CDB_SIZE))
 			return -ENOMEM;
 		mutex_lock(&sfp->f_mutex);
 		sfp->next_cmd_len = max_t(int, val, 0);
@@ -4000,7 +4048,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		return put_user(val, ip);
 	case SG_EMULATED_HOST:
 		SG_LOG(3, sfp, "%s:    SG_EMULATED_HOST\n", __func__);
-		if (unlikely(SG_IS_DETACHING(sdp)))
+		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
 		return put_user(sdev->host->hostt->emulated, ip);
 	case SCSI_IOCTL_SEND_COMMAND:
@@ -4010,7 +4058,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	case SG_SET_DEBUG:
 		SG_LOG(3, sfp, "%s:    SG_SET_DEBUG\n", __func__);
 		res = get_user(val, ip);
-		if (res)
+		if (unlikely(res))
 			return res;
 		assign_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm, !!val);
 		if (val == 0)	/* user can force recalculation */
@@ -4072,7 +4120,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 
 	sfp = filp->private_data;
 	sdp = sfp->parentdp;
-	if (!sdp)
+	if (unlikely(!sdp))
 		return -ENXIO;
 
 	ret = sg_ioctl_common(filp, sdp, sfp, cmd_in, p);
@@ -4189,7 +4237,7 @@ sg_poll(struct file *filp, poll_table *wait)
 	if (num > 0)
 		p_res = EPOLLIN | EPOLLRDNORM;
 
-	if (unlikely(SG_IS_DETACHING(sfp->parentdp)))
+	if (SG_IS_DETACHING(sfp->parentdp))
 		p_res |= EPOLLHUP;
 	else if (likely(test_bit(SG_FFD_CMD_Q, sfp->ffd_bm)))
 		p_res |= EPOLLOUT | EPOLLWRNORM;
@@ -4248,29 +4296,29 @@ sg_vma_fault(struct vm_fault *vmf)
 	struct sg_fd *sfp;
 	const char *nbp = "==NULL, bad";
 
-	if (!vma) {
+	if (unlikely(!vma)) {
 		pr_warn("%s: vma%s\n", __func__, nbp);
 		goto out_err;
 	}
 	sfp = vma->vm_private_data;
-	if (!sfp) {
+	if (unlikely(!sfp)) {
 		pr_warn("%s: sfp%s\n", __func__, nbp);
 		goto out_err;
 	}
 	sdp = sfp->parentdp;
-	if (sdp && unlikely(SG_IS_DETACHING(sdp))) {
+	if (sdp && SG_IS_DETACHING(sdp)) {
 		SG_LOG(1, sfp, "%s: device detaching\n", __func__);
 		goto out_err;
 	}
 	srp = sfp->rsv_srp;
-	if (!srp) {
+	if (unlikely(!srp)) {
 		SG_LOG(1, sfp, "%s: srp%s\n", __func__, nbp);
 		goto out_err;
 	}
 	mutex_lock(&sfp->f_mutex);
 	rsv_schp = srp->sgatp;
 	offset = vmf->pgoff << PAGE_SHIFT;
-	if (offset >= (unsigned int)rsv_schp->buflen) {
+	if (unlikely(offset >= (unsigned int)rsv_schp->buflen)) {
 		SG_LOG(1, sfp, "%s: offset[%lu] >= rsv.buflen\n", __func__,
 		       offset);
 		goto out_err_unlock;
@@ -4309,10 +4357,10 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	struct sg_fd *sfp;
 	struct sg_request *srp;
 
-	if (!filp || !vma)
+	if (unlikely(!filp || !vma))
 		return -ENXIO;
 	sfp = filp->private_data;
-	if (!sfp) {
+	if (unlikely(!sfp)) {
 		pr_warn("sg: %s: sfp is NULL\n", __func__);
 		return -ENXIO;
 	}
@@ -4330,7 +4378,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 		res = -EBUSY;
 		goto fini;
 	}
-	if (req_sz > SG_WRITE_COUNT_LIMIT) {	/* sanity check */
+	if (unlikely(req_sz > SG_WRITE_COUNT_LIMIT)) {	/* sanity check */
 		res = -ENOMEM;
 		goto fini;
 	}
@@ -4368,17 +4416,17 @@ sg_rq_end_io_usercontext(struct work_struct *work)
 					      ew_orph.work);
 	struct sg_fd *sfp;
 
-	if (!srp) {
+	if (unlikely(!srp)) {
 		WARN_ONCE(1, "%s: srp unexpectedly NULL\n", __func__);
 		return;
 	}
 	sfp = srp->parentfp;
-	if (!sfp) {
+	if (unlikely(!sfp)) {
 		WARN_ONCE(1, "%s: sfp unexpectedly NULL\n", __func__);
 		return;
 	}
 	SG_LOG(3, sfp, "%s: srp=0x%pK\n", __func__, srp);
-	if (test_bit(SG_FRQ_DEACT_ORPHAN, srp->frq_bm)) {
+	if (unlikely(test_bit(SG_FRQ_DEACT_ORPHAN, srp->frq_bm))) {
 		sg_finish_scsi_blk_rq(srp);	/* clean up orphan case */
 		sg_deact_request(sfp, srp);
 	}
@@ -4411,7 +4459,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	slen = min_t(int, scsi_rp->sense_len, SCSI_SENSE_BUFFERSIZE);
 	a_resid = scsi_rp->resid_len;
 
-	if (a_resid) {
+	if (unlikely(a_resid)) {
 		if (test_bit(SG_FRQ_IS_V4I, srp->frq_bm)) {
 			if (rq_data_dir(rqq) == READ)
 				srp->in_resid = a_resid;
@@ -4421,7 +4469,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 			srp->in_resid = a_resid;
 		}
 	}
-	if (test_bit(SG_FRQ_ABORTING, srp->frq_bm) && rq_result == 0)
+	if (unlikely(test_bit(SG_FRQ_ABORTING, srp->frq_bm)) && rq_result == 0)
 		srp->rq_result |= (DRIVER_HARD << 24);
 
 	SG_LOG(6, sfp, "%s: pack/tag_id=%d/%d, cmd=0x%x, res=0x%x\n", __func__,
@@ -4435,11 +4483,12 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 		    (rq_result & 0xff) == SAM_STAT_COMMAND_TERMINATED)
 			__scsi_print_sense(sdp->device, __func__, scsi_rp->sense, slen);
 	}
-	if (slen > 0) {
-		if (scsi_rp->sense && !srp->sense_bp) {
-			srp->sense_bp = mempool_alloc(sg_sense_pool,
-						      GFP_ATOMIC);
-			if (srp->sense_bp) {
+	if (unlikely(slen > 0)) {
+		if (likely(scsi_rp->sense && !srp->sense_bp)) {
+			srp->sense_bp =
+				mempool_alloc(sg_sense_pool,
+					      GFP_ATOMIC   /* <-- leave */);
+			if (likely(srp->sense_bp)) {
 				memcpy(srp->sense_bp, scsi_rp->sense, slen);
 				if (slen < SCSI_SENSE_BUFFERSIZE)
 					memset(srp->sense_bp + slen, 0,
@@ -4449,7 +4498,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 				pr_warn("%s: sense but can't alloc buffer\n",
 					__func__);
 			}
-		} else if (srp->sense_bp) {
+		} else if (unlikely(srp->sense_bp)) {
 			slen = 0;
 			pr_warn("%s: non-NULL srp->sense_bp ? ?\n", __func__);
 		} else {
@@ -4536,14 +4585,14 @@ sg_add_device_helper(struct gendisk *disk, struct scsi_device *scsidp)
 	unsigned long iflags;
 
 	sdp = kzalloc(sizeof(*sdp), GFP_KERNEL);
-	if (!sdp)
+	if (unlikely(!sdp))
 		return ERR_PTR(-ENOMEM);
 
 	idr_preload(GFP_KERNEL);
 	write_lock_irqsave(&sg_index_lock, iflags);
 
 	error = idr_alloc(&sg_index_idr, sdp, 0, SG_MAX_DEVS, GFP_NOWAIT);
-	if (error < 0) {
+	if (unlikely(error < 0)) {
 		if (error == -ENOSPC) {
 			sdev_printk(KERN_WARNING, scsidp,
 				    "Unable to attach sg device type=%d, minor number exceeds %d\n",
@@ -4577,7 +4626,7 @@ sg_add_device_helper(struct gendisk *disk, struct scsi_device *scsidp)
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 	idr_preload_end();
 
-	if (error) {
+	if (unlikely(error)) {
 		kfree(sdp);
 		return ERR_PTR(error);
 	}
@@ -4595,7 +4644,7 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 	unsigned long iflags;
 
 	disk = alloc_disk(1);
-	if (!disk) {
+	if (unlikely(!disk)) {
 		pr_warn("%s: alloc_disk failed\n", __func__);
 		return -ENOMEM;
 	}
@@ -4603,7 +4652,7 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 
 	error = -ENOMEM;
 	cdev = cdev_alloc();
-	if (!cdev) {
+	if (unlikely(!cdev)) {
 		pr_warn("%s: cdev_alloc failed\n", __func__);
 		goto out;
 	}
@@ -4617,7 +4666,7 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 	}
 
 	error = cdev_add(cdev, MKDEV(SCSI_GENERIC_MAJOR, sdp->index), 1);
-	if (error)
+	if (unlikely(error))
 		goto cdev_add_err;
 
 	sdp->cdev = cdev;
@@ -4693,7 +4742,7 @@ sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 	unsigned long idx;
 	struct sg_fd *sfp;
 
-	if (!sdp)
+	if (unlikely(!sdp))
 		return;
 	/* set this flag as soon as possible as it could be a surprise */
 	if (test_and_set_bit(SG_FDEV_DETACHING, sdp->fdev_bm))
@@ -4734,21 +4783,21 @@ init_sg(void)
 
 	rc = register_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0),
 				    SG_MAX_DEVS, "sg");
-	if (rc)
+	if (unlikely(rc))
 		return rc;
 
 	sg_sense_cache = kmem_cache_create_usercopy
 				("sg_sense", SCSI_SENSE_BUFFERSIZE, 0,
 				 SLAB_HWCACHE_ALIGN, 0,
 				 SCSI_SENSE_BUFFERSIZE, NULL);
-	if (!sg_sense_cache) {
+	if (unlikely(!sg_sense_cache)) {
 		pr_err("sg: can't init sense cache\n");
 		rc = -ENOMEM;
 		goto err_out_unreg;
 	}
 	sg_sense_pool = mempool_create_slab_pool(SG_MEMPOOL_MIN_NR,
 						 sg_sense_cache);
-	if (!sg_sense_pool) {
+	if (unlikely(!sg_sense_pool)) {
 		pr_err("sg: can't init sense pool\n");
 		rc = -ENOMEM;
 		goto err_out_cache;
@@ -4764,7 +4813,7 @@ init_sg(void)
 	}
 	sg_sysfs_valid = true;
 	rc = scsi_register_interface(&sg_interface);
-	if (rc == 0) {
+	if (likely(rc == 0)) {
 		sg_proc_init();
 		sg_dfs_init();
 		return 0;
@@ -4888,13 +4937,13 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	sdp = sfp->parentdp;
 	if (cwrp->cmd_len > BLK_MAX_CDB) {	/* for longer SCSI cdb_s */
 		long_cmdp = kzalloc(cwrp->cmd_len, GFP_KERNEL);
-		if (!long_cmdp) {
+		if (unlikely(!long_cmdp)) {
 			res = -ENOMEM;
 			goto err_out;
 		}
 		SG_LOG(5, sfp, "%s: long_cmdp=0x%pK ++\n", __func__, long_cmdp);
 	}
-	if (test_bit(SG_FRQ_IS_V4I, srp->frq_bm)) {
+	if (likely(test_bit(SG_FRQ_IS_V4I, srp->frq_bm))) {
 		struct sg_io_v4 *h4p = cwrp->h4p;
 
 		if (dxfer_dir == SG_DXFER_TO_DEV) {
@@ -4947,11 +4996,11 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	if (cwrp->u_cmdp)
 		res = sg_fetch_cmnd(sfp, cwrp->u_cmdp, cwrp->cmd_len,
 				    scsi_rp->cmd);
-	else if (cwrp->cmdp)
+	else if (likely(cwrp->cmdp))
 		memcpy(scsi_rp->cmd, cwrp->cmdp, cwrp->cmd_len);
 	else
 		res = -EPROTO;
-	if (res)
+	if (unlikely(res))
 		goto err_out;
 	scsi_rp->cmd_len = cwrp->cmd_len;
 	srp->cmd_opcode = scsi_rp->cmd[0];
@@ -4966,7 +5015,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		SG_LOG(4, sfp, "%s: no data xfer [0x%pK]\n", __func__, srp);
 		clear_bit(SG_FRQ_US_XFER, srp->frq_bm);
 		goto fini;	/* path of reqs with no din nor dout */
-	} else if ((rq_flags & SG_FLAG_DIRECT_IO) && iov_count == 0 &&
+	} else if (unlikely(rq_flags & SG_FLAG_DIRECT_IO) && iov_count == 0 &&
 		   !sdp->device->host->unchecked_isa_dma &&
 		   blk_rq_aligned(q, (unsigned long)up, dxfer_len)) {
 		srp->rq_info |= SG_INFO_DIRECT_IO;
@@ -4980,7 +5029,8 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	if (likely(md)) {	/* normal, "indirect" IO */
 		if (unlikely(rq_flags & SG_FLAG_MMAP_IO)) {
 			/* mmap IO must use and fit in reserve request */
-			if (!reserved || dxfer_len > req_schp->buflen)
+			if (unlikely(!reserved ||
+				     dxfer_len > req_schp->buflen))
 				res = reserved ? -ENOMEM : -EBUSY;
 		} else if (req_schp->buflen == 0) {
 			int up_sz = max_t(int, dxfer_len, sfp->sgat_elem_sz);
@@ -5003,7 +5053,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 			goto fini;
 
 		iov_iter_truncate(&i, dxfer_len);
-		if (!iov_iter_count(&i)) {
+		if (unlikely(!iov_iter_count(&i))) {
 			kfree(iov);
 			res = -EINVAL;
 			goto fini;
@@ -5016,9 +5066,11 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 			cp = "iov_count > 0";
 	} else if (us_xfer) { /* setup for transfer data to/from user space */
 		res = blk_rq_map_user(q, rqq, md, up, dxfer_len, GFP_ATOMIC);
-		if (IS_ENABLED(CONFIG_SCSI_PROC_FS) && res)
+#if IS_ENABLED(SG_LOG_ACTIVE)
+		if (unlikely(res))
 			SG_LOG(1, sfp, "%s: blk_rq_map_user() res=%d\n",
 			       __func__, res);
+#endif
 	} else {	/* transfer data to/from kernel buffers */
 		res = sg_rq_map_kern(srp, q, rqq, r0w);
 	}
@@ -5067,14 +5119,14 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 			scsi_req_free_cmd(scsi_req(rqq));
 		blk_put_request(rqq);
 	}
-	if (srp->bio) {
+	if (likely(srp->bio)) {
 		bool us_xfer = test_bit(SG_FRQ_US_XFER, srp->frq_bm);
 		struct bio *bio = srp->bio;
 
 		srp->bio = NULL;
 		if (us_xfer && bio) {
 			ret = blk_rq_unmap_user(bio);
-			if (ret) {	/* -EINTR (-4) can be ignored */
+			if (unlikely(ret)) {	/* -EINTR (-4) can be ignored */
 				SG_LOG(6, sfp,
 				       "%s: blk_rq_unmap_user() --> %d\n",
 				       __func__, ret);
@@ -5282,7 +5334,7 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 		     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
 			if (test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm))
 				continue;
-			if (is_tag) {
+			if (unlikely(is_tag)) {
 				if (srp->tag != id)
 					continue;
 			} else {
@@ -5359,7 +5411,7 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 			__maybe_unused const char *cptp = is_tag ? "tag=" :
 								   "pack_id=";
 
-			if (is_bad_st)
+			if (unlikely(is_bad_st))
 				SG_LOG(1, sfp, "%s: %s%d wrong state: %s\n",
 				       __func__, cptp, id,
 				       sg_rq_st_str(bad_sr_st, true));
@@ -5391,7 +5443,7 @@ sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
 	struct sg_request *srp;
 	struct xarray *xafp = &sfp->srp_arr;
 
-	if (unlikely(SG_IS_DETACHING(sfp->parentdp))) {
+	if (SG_IS_DETACHING(sfp->parentdp)) {
 		*srpp = ERR_PTR(-ENODEV);
 		return true;
 	}
@@ -5450,7 +5502,7 @@ sg_mk_srp(struct sg_fd *sfp, bool first)
 		srp = kzalloc(sizeof(*srp), gfp | GFP_KERNEL);
 	else
 		srp = kzalloc(sizeof(*srp), gfp | GFP_ATOMIC);
-	if (srp) {
+	if (likely(srp)) {
 		atomic_set(&srp->rq_st, SG_RQ_BUSY);
 		srp->sh_var = SG_SHR_NONE;
 		srp->parentfp = sfp;
@@ -5505,7 +5557,7 @@ sg_build_reserve(struct sg_fd *sfp, int buflen)
 			go_out = true;
 		}
 		res = sg_mk_sgat(srp, sfp, buflen);
-		if (res == 0) {
+		if (likely(res == 0)) {
 			SG_LOG(4, sfp, "%s: final buflen=%d, srp=0x%pK ++\n",
 			       __func__, buflen, srp);
 			return srp;
@@ -5575,7 +5627,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		break;
 	case SG_SHR_WS_RQ:
 		rs_sfp = sg_fd_share_ptr(fp);
-		if (!sg_fd_is_shared(fp)) {
+		if (unlikely(!rs_sfp)) {
 			r_srp = ERR_PTR(-EPROTO);
 			break;
 		}
@@ -5589,7 +5641,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		rs_sr_st = atomic_read(&rs_rsv_srp->rq_st);
 		switch (rs_sr_st) {
 		case SG_RQ_AWAIT_RCV:
-			if (rs_rsv_srp->rq_result & SG_ML_RESULT_MSK) {
+			if (unlikely(rs_rsv_srp->rq_result & SG_ML_RESULT_MSK)) {
 				/* read-side done but error occurred */
 				r_srp = ERR_PTR(-ENOSTR);
 				break;
@@ -5597,7 +5649,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 			fallthrough;
 		case SG_RQ_SHR_SWAP:
 			ws_rq = true;
-			if (rs_sr_st == SG_RQ_AWAIT_RCV)
+			if (unlikely(rs_sr_st == SG_RQ_AWAIT_RCV))
 				break;
 			res = sg_rq_chg_state(rs_rsv_srp, rs_sr_st, SG_RQ_SHR_IN_WS);
 			if (unlikely(res))
@@ -5633,8 +5685,8 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 	}
 	cp = "";
 
-	if (ws_rq) {	/* write-side dlen may be smaller than read-side's dlen */
-		if (dxfr_len > rs_rsv_srp->sgatp->dlen) {
+	if (ws_rq) {	/* write-side dlen may be <= read-side's dlen */
+		if (unlikely(dxfr_len > rs_rsv_srp->sgatp->dlen)) {
 			SG_LOG(4, fp, "%s: write-side dlen [%d] > read-side dlen\n",
 			       __func__, dxfr_len);
 			r_srp = ERR_PTR(-E2BIG);
@@ -5650,7 +5702,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		mk_new_srp = true;
 	} else if (atomic_read(&fp->inactives) <= 0) {
 		mk_new_srp = true;
-	} else if (!try_harder && dxfr_len < SG_DEF_SECTOR_SZ) {
+	} else if (likely(!try_harder) && dxfr_len < SG_DEF_SECTOR_SZ) {
 		l_used_idx = READ_ONCE(fp->low_used_idx);
 		s_idx = (l_used_idx < 0) ? 0 : l_used_idx;
 		if (l_used_idx >= 0 && xa_get_mark(xafp, s_idx, SG_XA_RQ_INACTIVE)) {
@@ -5675,7 +5727,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		/* If dxfr_len is small, use lowest inactive request */
 		if (low_srp) {
 			r_srp = low_srp;
-			if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
+			if (unlikely(sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY)))
 				goto start_again; /* gone to another thread */
 			atomic_dec(&fp->inactives);
 			cp = "lowest inactive in srp_arr";
@@ -5732,7 +5784,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 			goto fini;
 		} else if (fp->tot_fd_thresh > 0) {
 			sum_dlen = atomic_read(&fp->sum_fd_dlens) + dxfr_len;
-			if (sum_dlen > (u32)fp->tot_fd_thresh) {
+			if (unlikely(sum_dlen > (u32)fp->tot_fd_thresh)) {
 				r_srp = ERR_PTR(-E2BIG);
 				SG_LOG(2, fp, "%s: sum_of_dlen(%u) > %s\n",
 				       __func__, sum_dlen, "tot_fd_thresh");
@@ -5750,7 +5802,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		xa_lock_irqsave(xafp, iflags);
 		res = __xa_alloc(xafp, &n_idx, r_srp, xa_limit_32b, GFP_KERNEL);
 		xa_unlock_irqrestore(xafp, iflags);
-		if (res < 0) {
+		if (unlikely(res < 0)) {
 			sg_remove_sgat(r_srp);
 			kfree(r_srp);
 			r_srp = ERR_PTR(-EPROTOTYPE);
@@ -5838,7 +5890,7 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 	struct xarray *xafp;
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
-	if (!sfp)
+	if (unlikely(!sfp))
 		return ERR_PTR(-ENOMEM);
 	init_waitqueue_head(&sfp->cmpl_wait);
 	xa_init_flags(&sfp->srp_arr, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
@@ -5869,7 +5921,7 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 	atomic_set(&sfp->waiting, 0);
 	atomic_set(&sfp->inactives, 0);
 
-	if (unlikely(SG_IS_DETACHING(sdp))) {
+	if (SG_IS_DETACHING(sdp)) {
 		SG_LOG(1, sfp, "%s: detaching\n", __func__);
 		kfree(sfp);
 		return ERR_PTR(-ENODEV);
@@ -5918,7 +5970,7 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 	xa_lock_irqsave(xadp, iflags);
 	res = __xa_alloc(xadp, &idx, sfp, xa_limit_32b, GFP_KERNEL);
 	xa_unlock_irqrestore(xadp, iflags);
-	if (res < 0) {
+	if (unlikely(res < 0)) {
 		pr_warn("%s: xa_alloc(sdp) bad, o_count=%d, errno=%d\n",
 			__func__, atomic_read(&sdp->open_cnt), -res);
 		if (srp) {
@@ -5958,7 +6010,7 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 	struct xarray *xafp = &sfp->srp_arr;
 	struct xarray *xadp;
 
-	if (!sfp) {
+	if (unlikely(!sfp)) {
 		pr_warn("sg: %s: sfp is NULL\n", __func__);
 		return;
 	}
@@ -5971,14 +6023,14 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 			sg_finish_scsi_blk_rq(srp);
 		if (srp->sgatp->buflen > 0)
 			sg_remove_sgat(srp);
-		if (srp->sense_bp) {
+		if (unlikely(srp->sense_bp)) {
 			mempool_free(srp->sense_bp, sg_sense_pool);
 			srp->sense_bp = NULL;
 		}
 		xa_lock_irqsave(xafp, iflags);
 		e_srp = __xa_erase(xafp, srp->rq_idx);
 		xa_unlock_irqrestore(xafp, iflags);
-		if (srp != e_srp)
+		if (unlikely(srp != e_srp))
 			SG_LOG(1, sfp, "%s: xa_erase() return unexpected\n",
 			       __func__);
 		SG_LOG(6, sfp, "%s: kfree: srp=%pK --\n", __func__, srp);
@@ -6033,7 +6085,7 @@ sg_get_dev(int min_dev)
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = sg_lookup_dev(min_dev);
-	if (!sdp)
+	if (unlikely(!sdp))
 		sdp = ERR_PTR(-ENXIO);
 	else if (SG_IS_DETACHING(sdp)) {
 		/* If detaching, then the refcount may already be 0, in
@@ -6139,7 +6191,7 @@ dev_seq_start(struct seq_file *s, loff_t *pos)
 	struct sg_proc_deviter *it = kzalloc(sizeof(*it), GFP_KERNEL);
 
 	s->private = it;
-	if (!it)
+	if (unlikely(!it))
 		return NULL;
 
 	it->index = *pos;
@@ -6189,10 +6241,10 @@ sg_proc_write_adio(struct file *filp, const char __user *buffer,
 	int err;
 	unsigned long num;
 
-	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+	if (unlikely(!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO)))
 		return -EACCES;
 	err = kstrtoul_from_user(buffer, count, 0, &num);
-	if (err)
+	if (unlikely(err))
 		return err;
 	sg_allow_dio = num ? 1 : 0;
 	return count;
@@ -6211,13 +6263,13 @@ sg_proc_write_dressz(struct file *filp, const char __user *buffer,
 	int err;
 	unsigned long k = ULONG_MAX;
 
-	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+	if (unlikely(!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO)))
 		return -EACCES;
 
 	err = kstrtoul_from_user(buffer, count, 0, &k);
-	if (err)
+	if (unlikely(err))
 		return err;
-	if (k <= 1048576) {	/* limit "big buff" to 1 MB */
+	if (likely(k <= 1048576)) {	/* limit "big buff" to 1 MB */
 		sg_big_buff = k;
 		return count;
 	}
@@ -6249,7 +6301,7 @@ sg_proc_seq_show_dev(struct seq_file *s, void *v)
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if (!sdp || !sdp->device || SG_IS_DETACHING(sdp))
+	if (unlikely(!sdp || !sdp->device || SG_IS_DETACHING(sdp)))
 		seq_puts(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
 	else {
 		scsidp = sdp->device;
@@ -6301,7 +6353,7 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, char *obp,
 	const char *cp;
 	const char *tp = t_in_ns ? "ns" : "ms";
 
-	if (len < 1)
+	if (unlikely(len < 1))
 		return 0;
 	v4 = test_bit(SG_FRQ_IS_V4I, srp->frq_bm);
 	is_v3v4 = v4 ? true : (srp->s_hdr3.interface_id != '\0');
@@ -6467,14 +6519,14 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v, bool reduced)
 			   (int)it->max, def_reserved_size);
 	fdi_p = it ? &it->fd_index : &k;
 	bp = kzalloc(bp_len, __GFP_NOWARN | GFP_KERNEL);
-	if (!bp) {
+	if (unlikely(!bp)) {
 		seq_printf(s, "%s: Unable to allocate %d on heap, finish\n",
 			   __func__, bp_len);
 		return -ENOMEM;
 	}
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if (!sdp)
+	if (unlikely(!sdp))
 		goto skip;
 	sd_n = dev_arr[0];
 	if (sd_n != -1 && sd_n != sdp->index && sd_n != dev_arr[1]) {
@@ -6530,7 +6582,7 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v, bool reduced)
 					   "due to buffer size");
 		} else if (b1[0]) {
 			seq_puts(s, b1);
-			if (seq_has_overflowed(s))
+			if (unlikely(seq_has_overflowed(s)))
 				goto s_ovfl;
 		}
 	}
@@ -6605,7 +6657,7 @@ sg_proc_init(void)
 	struct proc_dir_entry *p;
 
 	p = proc_mkdir("scsi/sg", NULL);
-	if (!p)
+	if (unlikely(!p))
 		return 1;
 
 	proc_create("allow_dio", 0644, p, &adio_proc_ops);
@@ -6731,7 +6783,7 @@ sg_dfs_write(struct file *file, const char __user *buf, size_t count,
 	 * Attributes that only implement .seq_ops are read-only and 'attr' is
 	 * the same with 'data' in this case.
 	 */
-	if (attr == data || !attr->write)
+	if (unlikely(attr == data || !attr->write))
 		return -EPERM;
 	return attr->write(data, buf, count, ppos);
 }
-- 
2.25.1

