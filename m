Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F0AC3A59D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiJXDZA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiJXDW5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:22:57 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C5A75E64D
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:21:30 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 56BE92041F1;
        Mon, 24 Oct 2022 05:21:30 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id T7ofHgstHUVV; Mon, 24 Oct 2022 05:21:30 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id 2C93C2041AF;
        Mon, 24 Oct 2022 05:21:29 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v25 19/44] sg: sg_find_srp_by_id
Date:   Sun, 23 Oct 2022 23:20:33 -0400
Message-Id: <20221024032058.14077-20-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024032058.14077-1-dgilbert@interlog.com>
References: <20221024032058.14077-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace sg_get_rq_mark() with sg_find_srp_by_id() and
sg_get_ready_srp(). Add sg_chk_mmap() to check flags and
reserve buffer available for mmap() based requests. Add
sg_copy_sense() and sg_rec_state_v3() which is just
refactoring. Add sg_calc_rq_dur() and sg_get_dur() in
preparation for optional nanosecond duration timing.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 345 ++++++++++++++++++++++++++++++----------------
 1 file changed, 229 insertions(+), 116 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 18881e551702..91bcb4d199b1 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -157,16 +157,19 @@ struct sg_fd;
 
 struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 	struct list_head entry;	/* list entry */
-	struct sg_fd *parentfp;	/* NULL -> not in use */
 	struct sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
 	struct sg_io_hdr header;  /* scsi command+info, see <scsi/sg.h> */
 	u8 sense_b[SCSI_SENSE_BUFFERSIZE];
+	u32 duration;		/* cmd duration in milliseconds */
 	char res_used;		/* 1 -> using reserve buffer, 0 -> not ... */
 	char orphan;		/* 1 -> drop on sight, 0 -> normal */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
 	/* done protected by rq_list_lock */
 	char done;		/* 0->before bh, 1->before read, 2->read */
 	atomic_t rq_st;		/* request state, holds a enum sg_rq_state */
+	u64 start_ns;		/* starting point of command duration calc */
+	unsigned long frq_bm[1];        /* see SG_FRQ_* defines above */
+	struct sg_fd *parentfp; /* pointer to owning fd, even when on fl */
 	struct request *rq;	/* released in sg_rq_end_io(), bio kept */
 	struct bio *bio;	/* kept until this req -->SG_RS_INACTIVE */
 	struct execute_work ew_orph;	/* harvest orphan request */
@@ -232,7 +235,7 @@ static ssize_t sg_submit(struct sg_fd *sfp, struct file *filp,
 			 const char __user *buf, size_t count, bool blocking,
 			 bool read_only, bool sg_io_owned,
 			 struct sg_request **o_srp);
-static int sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwp);
+static int sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp);
 static int sg_read_append(struct sg_request *srp, void __user *outp,
 			  int num_xfer);
 static void sg_remove_sgat(struct sg_fd *sfp, struct sg_scatter_hold *schp);
@@ -242,8 +245,8 @@ static void sg_link_reserve(struct sg_fd *sfp, struct sg_request *srp,
 static void sg_unlink_reserve(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_fd *sg_add_sfp(struct sg_device *sdp);
 static void sg_remove_sfp(struct kref *);
-static struct sg_request *sg_get_rq_mark(struct sg_fd *sfp, int pack_id,
-					 bool *busy);
+static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int pack_id,
+					    bool *busy);
 static struct sg_request *sg_setup_req(struct sg_fd *sfp);
 static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int dev);
@@ -446,7 +449,8 @@ sg_open(struct inode *inode, struct file *filp)
 	sfp = sg_add_sfp(sdp);		/* increments sdp->d_ref */
 	if (IS_ERR(sfp)) {
 		res = PTR_ERR(sfp);
-		goto out_undo; }
+		goto out_undo;
+	}
 
 	filp->private_data = sfp;
 	atomic_inc(&sdp->open_cnt);
@@ -509,7 +513,6 @@ sg_release(struct inode *inode, struct file *filp)
 static ssize_t
 sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 {
-	bool blocking = !(filp->f_flags & O_NONBLOCK);
 	int mxsize, cmd_size, input_size, res;
 	u8 opcode;
 	struct sg_device *sdp;
@@ -611,21 +614,19 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	}
 	/*
 	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
-	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
-	 * is a non-zero input_size, so emit a warning.
+	 * but it is possible that the app intended SG_DXFER_TO_DEV, because
+	 * there is a non-zero input_size, so emit a warning.
 	 */
 	if (h3p->dxfer_direction == SG_DXFER_TO_FROM_DEV) {
-		printk_ratelimited(KERN_WARNING
-				   "sg_write: data in/out %d/%d bytes "
-				   "for SCSI command 0x%x-- guessing "
-				   "data in;\n   program %s not setting "
-				   "count and/or reply_len properly\n",
-				   ohp->reply_len - (int)SZ_SG_HEADER,
-				   input_size, (unsigned int) cmnd[0],
-				   current->comm);
+		printk_ratelimited
+			(KERN_WARNING
+			 "%s: data in/out %d/%d bytes for SCSI command 0x%x-- guessing data in;\n"
+			 "   program %s not setting count and/or reply_len properly\n",
+			 __func__, ohp->reply_len - (int)SZ_SG_HEADER,
+			 input_size, (unsigned int)cmnd[0], current->comm);
 	}
 	cwr.timeout = sfp->timeout;
-	cwr.blocking = blocking;
+	cwr.blocking = !(filp->f_flags & O_NONBLOCK);
 	cwr.srp = srp;
 	cwr.cmnd = cmnd;
 	res = sg_common_write(sfp, &cwr);
@@ -654,6 +655,18 @@ sg_fetch_cmnd(struct file *filp, struct sg_fd *sfp, const u8 __user *u_cdbp,
 	return 0;
 }
 
+static inline int
+sg_chk_mmap(struct sg_fd *sfp, int rq_flags, int len)
+{
+	if (len > sfp->reserve.buflen)
+		return -ENOMEM;	/* MMAP_IO size must fit in reserve buffer */
+	if (rq_flags & SG_FLAG_DIRECT_IO)
+		return -EINVAL;	/* either MMAP_IO or DIRECT_IO (not both) */
+	if (sfp->res_in_use)
+		return -EBUSY;	/* reserve buffer already being used */
+	return 0;
+}
+
 static ssize_t
 sg_submit(struct sg_fd *sfp, struct file *filp, const char __user *buf,
 	  size_t count, bool blocking, bool read_only, bool sg_io_owned,
@@ -687,17 +700,10 @@ sg_submit(struct sg_fd *sfp, struct file *filp, const char __user *buf,
 		return -ENOSYS;
 	}
 	if (hp->flags & SG_FLAG_MMAP_IO) {
-		if (hp->dxfer_len > sfp->reserve.buflen) {
+		res = sg_chk_mmap(sfp, hp->flags, hp->dxfer_len);
+		if (res) {
 			sg_deact_request(sfp, srp);
-			return -ENOMEM;	/* MMAP_IO size must fit in reserve buffer */
-		}
-		if (hp->flags & SG_FLAG_DIRECT_IO) {
-			sg_deact_request(sfp, srp);
-			return -EINVAL;	/* either MMAP_IO or DIRECT_IO (not both) */
-		}
-		if (sfp->res_in_use) {
-			sg_deact_request(sfp, srp);
-			return -EBUSY;	/* reserve buffer already being used */
+			return res;
 		}
 	}
 	ul_timeout = msecs_to_jiffies(srp->header.timeout);
@@ -719,6 +725,12 @@ sg_submit(struct sg_fd *sfp, struct file *filp, const char __user *buf,
 	return count;
 }
 
+/*
+ * All writes and submits converge on this function to launch the SCSI
+ * command/request (via blk_execute_rq_nowait). Returns a pointer to a
+ * sg_request object holding the request just issued or a negated errno
+ * value twisted by ERR_PTR.
+ */
 static int
 sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 {
@@ -778,58 +790,69 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 	return 0;
 }
 
-static int
-get_sg_io_pack_id(int *pack_id, void __user *buf, size_t count)
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
+/*
+ * This function is called by wait_event_interruptible in sg_read() and
+ * sg_ctl_ioreceive(). wait_event_interruptible will return if this one
+ * returns true (or an event like a signal (e.g. control-C) occurs).
+ */
 
-		if (in_compat_syscall() &&
-		    count >= sizeof(struct compat_sg_io_hdr)) {
-			struct compat_sg_io_hdr __user *hp = buf;
+static inline bool
+sg_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp, int pack_id,
+		 bool *busy)
+{
+	struct sg_request *srp = sg_find_srp_by_id(sfp, pack_id, busy);
 
-			return get_user(*pack_id, &hp->pack_id);
-		}
+	*srpp = srp;
+	return !!srp;
+}
 
-		if (count >= sizeof(struct sg_io_hdr)) {
-			struct sg_io_hdr __user *hp = buf;
+/*
+ * Returns number of bytes copied to user space provided sense buffer or
+ * negated errno value.
+ */
+static int
+sg_copy_sense(struct sg_request *srp)
+{
+	int sb_len_ret = 0;
+	struct sg_io_hdr *hp = &srp->header;
 
-			return get_user(*pack_id, &hp->pack_id);
-		}
+	/* If need be, copy the sense buffer to the user space */
+	if ((CHECK_CONDITION & hp->masked_status) ||
+	    (srp->sense_b[0] & 0x70) == 0x70) {
+		int sb_len = SCSI_SENSE_BUFFERSIZE;
+		void __user *up = hp->sbp;
+
+		sb_len = min_t(int, hp->mx_sb_len, sb_len);
+		/* Additional sense length field */
+		sb_len_ret = 8 + (int)srp->sense_b[7];
+		sb_len_ret = min_t(int, sb_len_ret, sb_len);
+		if (copy_to_user(up, srp->sense_b, sb_len_ret))
+			return -EFAULT;
+		hp->sb_len_wr = sb_len_ret;
 	}
-
-	/* no valid header was passed, so ignore the pack_id */
-	*pack_id = -1;
-	return 0;
+	return sb_len_ret;
 }
 
 static int
-srp_done(struct sg_fd *sfp, struct sg_request *srp)
+sg_rec_state_v3(struct sg_fd *sfp, struct sg_request *srp)
 {
-	unsigned long flags;
-	int ret;
+	int sb_len_wr;
 
-	spin_lock_irqsave(&sfp->rq_list_lock, flags);
-	ret = srp->done;
-	spin_unlock_irqrestore(&sfp->rq_list_lock, flags);
-	return ret;
+	sb_len_wr = sg_copy_sense(srp);
+	if (sb_len_wr < 0)
+		return sb_len_wr;
+	if (unlikely(SG_IS_DETACHING(sfp->parentdp)))
+		return -ENODEV;
+	return 0;
 }
 
+
 static ssize_t
-sg_receive_v3(struct sg_fd *sfp, char __user *buf, size_t count,
-	      struct sg_request *srp)
+sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, size_t count,
+	      void __user *buf)
 {
-	struct sg_io_hdr *hp = &srp->header;
 	int err = 0;
-	int len;
+	struct sg_io_hdr *hp = &srp->header;
 
 	if (in_compat_syscall()) {
 		if (count < sizeof(struct compat_sg_io_hdr)) {
@@ -840,22 +863,9 @@ sg_receive_v3(struct sg_fd *sfp, char __user *buf, size_t count,
 		err = -EINVAL;
 		goto err_out;
 	}
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
+	err = sg_rec_state_v3(sfp, srp);
+	if (err < 0)
+		goto err_out;
 	if (hp->masked_status || hp->host_status || hp->driver_status)
 		hp->info |= SG_INFO_CHECK;
 	err = put_sg_io_hdr(hp, buf);
@@ -940,6 +950,39 @@ sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 	return res;
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
 static ssize_t
 sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 {
@@ -968,12 +1011,12 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 	if (ret)
 		return ret;
 
-	srp = sg_get_rq_mark(sfp, req_pack_id, &busy);
+	srp = sg_find_srp_by_id(sfp, req_pack_id, &busy);
 	if (!srp) {		/* now wait on packet to arrive */
 		if (non_block)
 			return -EAGAIN;
 		ret = wait_event_interruptible(sfp->read_wait,
-			((srp = sg_get_rq_mark(sfp, req_pack_id, &busy)) ||
+			((srp = sg_find_srp_by_id(sfp, req_pack_id, &busy)) ||
 			(!busy && SG_IS_DETACHING(sdp))));
 		if (!srp)
 			/* signal or detaching */
@@ -982,7 +1025,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 	if (srp->header.interface_id == '\0')
 		ret = sg_read_v1v2(buf, (int)count, sfp, srp);
 	else
-		ret = sg_receive_v3(sfp, buf, count, srp);
+		ret = sg_receive_v3(sfp, srp, count, buf);
 	if (ret < 0)
 		SG_LOG(1, sfp, "%s: negated errno: %d\n", __func__, ret);
 	return ret < 0 ? ret : (int)count;
@@ -1031,6 +1074,51 @@ sg_calc_sgat_param(struct sg_device *sdp)
 	sdp->max_sgat_sz = sz;
 }
 
+static u32
+sg_calc_rq_dur(const struct sg_request *srp)
+{
+	ktime_t ts0 = ns_to_ktime(srp->start_ns);
+	ktime_t now_ts;
+	s64 diff;
+
+	if (ts0 == 0)
+		return 0;
+	if (unlikely(ts0 == S64_MAX))	/* _prior_ to issuing req */
+		return 999999999;	/* eye catching */
+	now_ts = ktime_get_boottime();
+	if (unlikely(ts0 > now_ts))
+		return 999999998;
+	/* unlikely req duration will exceed 2**32 milliseconds */
+	diff = ktime_ms_delta(now_ts, ts0);
+	return (diff > (s64)U32_MAX) ? 3999999999U : (u32)diff;
+}
+
+/* Return of U32_MAX means srp is inactive */
+static u32
+sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,
+	   bool *is_durp)
+{
+	bool is_dur = false;
+	u32 res = U32_MAX;
+
+	switch (sr_stp ? *sr_stp : atomic_read(&srp->rq_st)) {
+	case SG_RS_INFLIGHT:
+	case SG_RS_BUSY:
+		res = sg_calc_rq_dur(srp);
+		break;
+	case SG_RS_AWAIT_RCV:
+	case SG_RS_INACTIVE:
+		res = srp->duration;
+		is_dur = true;	/* completion has occurred, timing finished */
+		break;
+	default:
+		break;
+	}
+	if (is_durp)
+		*is_durp = is_dur;
+	return res;
+}
+
 static void
 sg_fill_request_table(struct sg_fd *sfp, struct sg_req_info *rinfo)
 {
@@ -1047,6 +1135,7 @@ sg_fill_request_table(struct sg_fd *sfp, struct sg_req_info *rinfo)
 			srp->header.masked_status &
 			srp->header.host_status &
 			srp->header.driver_status;
+		rinfo[val].duration = sg_get_dur(srp, NULL, NULL); /* dummy */
 		if (srp->done)
 			rinfo[val].duration =
 				srp->header.duration;
@@ -1064,13 +1153,25 @@ sg_fill_request_table(struct sg_fd *sfp, struct sg_req_info *rinfo)
 	}
 }
 
+static int
+srp_done(struct sg_fd *sfp, struct sg_request *srp)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&sfp->rq_list_lock, flags);
+	ret = srp->done;
+	spin_unlock_irqrestore(&sfp->rq_list_lock, flags);
+	return ret;
+}
+
 /*
  * Handles ioctl(SG_IO) for blocking (sync) usage of v3 or v4 interface.
  * Returns 0 on success else a negated errno.
  */
 static int
 sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
-	     void __user *p)
+	     void __user *buf)
 {
 	bool read_only = O_RDWR != (filp->f_flags & O_ACCMODE);
 	int res;
@@ -1079,7 +1180,7 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	res = sg_allow_if_err_recovery(sdp, false);
 	if (res)
 		return res;
-	res = sg_submit(sfp, filp, p, SZ_SG_IO_HDR, true, read_only,
+	res = sg_submit(sfp, filp, buf, SZ_SG_IO_HDR, true, read_only,
 			true, &srp);
 	if (res < 0)
 		return res;
@@ -1089,7 +1190,7 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	if (srp->done) {
 		srp->done = 2;
 		spin_unlock_irq(&sfp->rq_list_lock);
-		res = sg_receive_v3(sfp, p, SZ_SG_IO_HDR, srp);
+		res = sg_receive_v3(sfp, srp, SZ_SG_IO_HDR, buf);
 		return (res < 0) ? res : 0;
 	}
 	srp->orphan = 1;
@@ -1317,7 +1418,9 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 			return result;
 		if (val > SG_MAX_CDB_SIZE)
 			return -ENOMEM;
-		sfp->next_cmd_len = (val > 0) ? val : 0;
+		mutex_lock(&sfp->f_mutex);
+		sfp->next_cmd_len = max_t(int, val, 0);
+		mutex_unlock(&sfp->f_mutex);
 		return 0;
 	case SG_GET_ACCESS_COUNT:
 		SG_LOG(3, sfp, "%s:    SG_GET_ACCESS_COUNT\n", __func__);
@@ -2233,6 +2336,45 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
 	return res;
 }
 
+/*
+ * If there are multiple requests outstanding, the speed of this function is
+ * important. SG_PACK_ID_WILDCARD is -1 and that case is typically the fast
+ * path. This function is only used in the non-blocking cases. Returns pointer
+ * to (first) matching sg_request or NULL. If found, sg_request state is moved
+ * from SG_RS_AWAIT_RCV to SG_RS_BUSY.
+ * The 'busy' pointer is only set to true when no requests are found in the
+ * SG_RS_AWAIT_RCV state and SG_IS_DETACHING() is true and there is at least
+ * one request in SG_RS_INFLIGHT state; in all other cases *busy is set false.
+ */
+static struct sg_request *
+sg_find_srp_by_id(struct sg_fd *sfp, int pack_id, bool *busy)
+{
+	struct sg_request *resp;
+	unsigned long iflags;
+
+	*busy = false;
+	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
+	list_for_each_entry(resp, &sfp->rq_list, entry) {
+		/* look for requests that are not SG_IO owned */
+		if ((!resp->sg_io_owned) &&
+		    ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
+			switch (resp->done) {
+			case 0: /* request active */
+				*busy = true;
+				break;
+			case 1: /* request done; response ready to return */
+				resp->done = 2;	/* guard against other readers */
+				spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+				return resp;
+			case 2: /* response already being returned */
+				break;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	return NULL;
+}
+
 static void
 sg_link_reserve(struct sg_fd *sfp, struct sg_request *srp, int size)
 {
@@ -2279,35 +2421,6 @@ sg_unlink_reserve(struct sg_fd *sfp, struct sg_request *srp)
 	sfp->res_in_use = 0;
 }
 
-static struct sg_request *
-sg_get_rq_mark(struct sg_fd *sfp, int pack_id, bool *busy)
-{
-	struct sg_request *resp;
-	unsigned long iflags;
-
-	*busy = false;
-	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
-	list_for_each_entry(resp, &sfp->rq_list, entry) {
-		/* look for requests that are not SG_IO owned */
-		if ((!resp->sg_io_owned) &&
-		    ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
-			switch (resp->done) {
-			case 0: /* request active */
-				*busy = true;
-				break;
-			case 1: /* request done; response ready to return */
-				resp->done = 2;	/* guard against other readers */
-				spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-				return resp;
-			case 2: /* response already being returned */
-				break;
-			}
-		}
-	}
-	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return NULL;
-}
-
 static void
 sg_build_reserve(struct sg_fd *sfp, int req_size)
 {
-- 
2.37.3

