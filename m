Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8FBC43462
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2CB9613FE
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbhD0WAe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:34 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38953 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237086AbhD0V74 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 275FA2041D4;
        Tue, 27 Apr 2021 23:59:11 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Zd5weQjFiC1z; Tue, 27 Apr 2021 23:59:09 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id D2D64204295;
        Tue, 27 Apr 2021 23:59:07 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 61/83] sg: optionally output sg_request.frq_bm flags
Date:   Tue, 27 Apr 2021 17:57:11 -0400
Message-Id: <20210427215733.417746-63-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add this option to the little used ioctl(SG_SET_DEBUG). Once set
then 'cat /proc/scsi/sg/debug' or
'cat /sys/kernel/debug/scsi_generic/snapshot' will prefix each
request output line with its flags (sg_request::frq_bm) in hex.
It is a bitmask. To decode the hex see the SG_FRQ_* defines.

Use non_block boolean in sg_open(). Rework
sg_change_after_read_side_rq() helper.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 57 ++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 8e0ae40cde87..5e6c67bac5cd 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -359,6 +359,7 @@ static struct sg_device *sg_get_dev(int min_dev);
 static void sg_device_destroy(struct kref *kref);
 static struct sg_request *sg_mk_srp_sgat(struct sg_fd *sfp, bool first,
 					 int db_len);
+static int sg_abort_req(struct sg_fd *sfp, struct sg_request *srp);
 static int sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count);
 static int sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q,
 			     int loop_count);
@@ -552,7 +553,7 @@ sg_open(struct inode *inode, struct file *filp)
 		goto error_out;
 
 	mutex_lock(&sdp->open_rel_lock);
-	if (op_flags & O_NONBLOCK) {
+	if (non_block) {
 		if (unlikely(o_excl)) {
 			if (atomic_read(&sdp->open_cnt) > 0) {
 				res = -EBUSY;
@@ -587,7 +588,7 @@ sg_open(struct inode *inode, struct file *filp)
 	mutex_unlock(&sdp->open_rel_lock);
 	SG_LOG(3, sfp, "%s: o_count after=%d on minor=%d, op_flags=0x%x%s\n",
 	       __func__, o_count, min_dev, op_flags,
-	       ((op_flags & O_NONBLOCK) ? " O_NONBLOCK" : ""));
+	       (non_block ? " O_NONBLOCK" : ""));
 
 	res = 0;
 sg_put:
@@ -651,8 +652,8 @@ sg_release(struct inode *inode, struct file *filp)
 		return -ENXIO;
 
 	if (unlikely(xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_FREE))) {
-		SG_LOG(1, sfp, "%s: sfp erased!!!\n", __func__);
-		return 0;	/* get out but can't fail */
+		SG_LOG(1, sfp, "%s: sfp already erased!!!\n", __func__);
+		return 0;       /* yell out but can't fail */
 	}
 
 	mutex_lock(&sdp->open_rel_lock);
@@ -2048,6 +2049,7 @@ sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_mrqs,
 }
 
 /*
+ * Invoked when user calls ioctl(SG_IORECEIVE, SGV4_FLAG_MULTIPLE_REQS).
  * Expected race as multiple concurrent calls with the same pack_id/tag can
  * occur. Only one should succeed per request (more may succeed but will get
  * different requests).
@@ -2090,7 +2092,7 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p,
 		if (copy_to_user(pp, rsp_v4_arr, len))
 			res = -EFAULT;
 	} else {
-		pr_info("%s: cop->din_xferp==NULL ?_?\n", __func__);
+		SG_LOG(1, sfp, "%s: cop->din_xferp==NULL ?_?\n", __func__);
 	}
 fini:
 	kfree(rsp_v4_arr);
@@ -2518,28 +2520,26 @@ sg_calc_sgat_param(struct sg_device *sdp)
 static int
 sg_change_after_read_side_rq(struct sg_fd *sfp, bool fini1_again0)
 {
-	int res = 0;
+	int res = -EINVAL;
 	enum sg_rq_state sr_st;
 	unsigned long iflags;
 	struct sg_fd *rs_sfp;
-	struct sg_request *rs_rsv_srp = NULL;
+	struct sg_request *rs_rsv_srp;
 	struct sg_device *sdp = sfp->parentdp;
 
 	rs_sfp = sg_fd_share_ptr(sfp);
-	if (unlikely(!rs_sfp)) {
-		res = -EINVAL;
-	} else if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_RS_SHARE)) {
-		rs_rsv_srp = sfp->rsv_srp;
+	if (unlikely(!rs_sfp))
+		goto fini;
+	if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_RS_SHARE))
 		rs_sfp = sfp;
-	} else {	/* else called on write-side */
-		rs_rsv_srp = rs_sfp->rsv_srp;
-	}
-	if (res || !rs_rsv_srp)
+	rs_rsv_srp = sfp->rsv_srp;
+	if (IS_ERR_OR_NULL(rs_rsv_srp))
 		goto fini;
 
+	res = 0;
 	xa_lock_irqsave(&rs_sfp->srp_arr, iflags);
 	sr_st = atomic_read(&rs_rsv_srp->rq_st);
-	if (fini1_again0) {
+	if (fini1_again0) {	/* finish req share after read-side req */
 		switch (sr_st) {
 		case SG_RQ_SHR_SWAP:
 			rs_rsv_srp->sh_var = SG_SHR_RS_NOT_SRQ;
@@ -2556,7 +2556,7 @@ sg_change_after_read_side_rq(struct sg_fd *sfp, bool fini1_again0)
 			res = -EINVAL;
 			break;
 		}
-	} else {
+	} else {	/* again: tweak state to allow another write-side request */
 		switch (sr_st) {
 		case SG_RQ_INACTIVE:
 			rs_rsv_srp->sh_var = SG_SHR_RS_RQ;
@@ -5827,8 +5827,8 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 	struct sg_request *rs_rsv_srp = NULL;
 	struct sg_fd *rs_sfp = NULL;
 	struct xarray *xafp = &fp->srp_arr;
-	__maybe_unused const char *cp;
-	char b[48];
+	__maybe_unused const char *cp = NULL;
+	__maybe_unused char b[64];
 
 	b[0] = '\0';
 	rsv_srp = fp->rsv_srp;
@@ -6638,6 +6638,7 @@ static int
 sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 		 bool reduced)
 {
+	bool set_debug;
 	bool t_in_ns = test_bit(SG_FFD_TIME_IN_NS, fp->ffd_bm);
 	int n = 0;
 	int to, k;
@@ -6651,6 +6652,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 			" shr_rs" : " shr_rs";
 	else
 		cp = "";
+	set_debug = test_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm);
 	/* sgat=-1 means unavailable */
 	to = (fp->timeout >= 0) ? jiffies_to_msecs(fp->timeout) : -999;
 	if (to < 0)
@@ -6687,10 +6689,16 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 				       idx, srp->rq_idx);
 		if (xa_get_mark(&fp->srp_arr, idx, SG_XA_RQ_INACTIVE))
 			continue;
+		if (set_debug)
+			n += scnprintf(obp + n, len - n, "     frq_bm=0x%lx  ",
+				       srp->frq_bm[0]);
+		else if (test_bit(SG_FRQ_ABORTING, srp->frq_bm))
+			n += scnprintf(obp + n, len - n,
+				       "     abort>> ");
 		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns, obp + n,
 					len - n);
 		++k;
-		if ((k % 8) == 0) {     /* don't hold up isr_s too long */
+		if ((k % 8) == 0) {	/* don't hold up isr_s too long */
 			xa_unlock_irqrestore(&fp->srp_arr, iflags);
 			cpu_relax();
 			xa_lock_irqsave(&fp->srp_arr, iflags);
@@ -6702,10 +6710,13 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 	xa_for_each_marked(&fp->srp_arr, idx, srp, SG_XA_RQ_INACTIVE) {
 		if (k == 0)
 			n += scnprintf(obp + n, len - n, "   Inactives:\n");
+		if (set_debug)
+			n += scnprintf(obp + n, len - n, "     frq_bm=0x%lx  ",
+				       srp->frq_bm[0]);
 		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns,
 					obp + n, len - n);
 		++k;
-		if ((k % 8) == 0) {     /* don't hold up isr_s too long */
+		if ((k % 8) == 0) {	/* don't hold up isr_s too long */
 			xa_unlock_irqrestore(&fp->srp_arr, iflags);
 			cpu_relax();
 			xa_lock_irqsave(&fp->srp_arr, iflags);
@@ -6805,8 +6816,8 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v, bool reduced)
 		found = true;
 		disk_name = (sdp->disk ? sdp->disk->disk_name : "?_?");
 		if (SG_IS_DETACHING(sdp)) {
-			snprintf(b1, sizeof(b1), " >>> device=%s  %s\n",
-				 disk_name, "detaching pending close\n");
+			snprintf(b1, sizeof(b1), " >>> %s %s\n", disk_name,
+				 "detaching pending close\n");
 		} else if (sdp->device) {
 			n = sg_proc_debug_sdev(sdp, bp, bp_len, fdi_p,
 					       reduced);
-- 
2.25.1

