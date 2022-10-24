Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8CFDC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiJXD0X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiJXDYS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:24:18 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A9F67963B
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:22:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 0E47C2041BD;
        Mon, 24 Oct 2022 05:22:06 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EVAOLcW3-VQf; Mon, 24 Oct 2022 05:22:05 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id 844B32041AF;
        Mon, 24 Oct 2022 05:22:04 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH v25 43/44] sg: rework command completion when removed device
Date:   Sun, 23 Oct 2022 23:20:57 -0400
Message-Id: <20221024032058.14077-44-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024032058.14077-1-dgilbert@interlog.com>
References: <20221024032058.14077-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On advice from Tony Battersby, the author of mainline patch:
3455607fd7be10b449f5135c00dc306b85dc0d21
rework the logic introduced in that patch. Previously when there
were no requests in SG_RS_AWAIT_RCV state, and IS_DETACHING() is
true, and there was at least one request in SG_RS_INFLIGHT state
then the passed output parameter *busy was set to true. Replace
*busy with ERR_PTR(-ENODEV), which is returned only when
SG_IS_DETACHING() and there are no SG_RS_AWAIT_RCV requests to
return or SG_RS_INFLIGHT requests to wait for.

To summarize, if IS_DETACHING() is true:
  - don't accept any new requests on that device
  - process all requests already in SG_RS_AWAIT_RCV state
  - if there are any requests in SG_RS_INFLIGHT state spin
    until they transition to SG_RS_AWAIT_RCV state or time out

Reported-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 180 +++++++++++++++++++++++++---------------------
 1 file changed, 97 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4bf2363d1b17..9b362583b610 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -315,8 +315,7 @@ static int sg_read_append(struct sg_request *srp, void __user *outp,
 static void sg_remove_sgat(struct sg_request *srp);
 static struct sg_fd *sg_add_sfp(struct sg_device *sdp);
 static void sg_remove_sfp(struct kref *);
-static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int id,
-					    bool *busy);
+static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int id);
 static struct sg_request *sg_setup_req(struct sg_comm_wr_t *cwrp,
 				       int dxfr_len);
 static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
@@ -457,11 +456,11 @@ sg_wait_open_event(struct sg_device *sdp, bool o_excl)
  * Returns 0 for ok (i.e. allow), -EPROTO if sdp is NULL, otherwise -ENXIO .
  */
 static inline int
-sg_allow_if_err_recovery(struct sg_device *sdp, bool non_block)
+sg_allow_if_err_recovery(struct sg_device *sdp, bool non_block, bool ioreceive)
 {
 	if (!sdp)
 		return -EPROTO;
-	if (SG_IS_DETACHING(sdp))
+	if (SG_IS_DETACHING(sdp) && !ioreceive)
 		return -ENODEV;
 	if (non_block)
 		return 0;
@@ -504,7 +503,7 @@ sg_open(struct inode *inode, struct file *filp)
 	res = scsi_autopm_get_device(sdp->device);
 	if (res)
 		goto sdp_put;
-	res = sg_allow_if_err_recovery(sdp, non_block);
+	res = sg_allow_if_err_recovery(sdp, non_block, false);
 	if (res)
 		goto error_out;
 
@@ -625,7 +624,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	sfp = filp->private_data;
 	sdp = sfp->parentdp;
 	SG_LOG(3, sfp, "%s: write(3rd arg) count=%d\n", __func__, (int)count);
-	res = sg_allow_if_err_recovery(sdp, !!(filp->f_flags & O_NONBLOCK));
+	res = sg_allow_if_err_recovery(sdp, !!(filp->f_flags & O_NONBLOCK), false);
 	if (res)
 		return res;
 	if (count < SZ_SG_HEADER || count > SG_WRITE_COUNT_LIMIT)
@@ -870,7 +869,7 @@ sg_ctl_iosubmit(struct file *filp, struct sg_fd *sfp, void __user *p)
 	struct sg_io_v4 *h4p = (struct sg_io_v4 *)hdr_store;
 	struct sg_device *sdp = sfp->parentdp;
 
-	res = sg_allow_if_err_recovery(sdp, (filp->f_flags & O_NONBLOCK));
+	res = sg_allow_if_err_recovery(sdp, (filp->f_flags & O_NONBLOCK), false);
 	if (res)
 		return res;
 	if (copy_from_user(hdr_store, p, SZ_SG_IO_V4))
@@ -888,7 +887,7 @@ sg_ctl_iosubmit_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
 	struct sg_io_hdr *h3p = (struct sg_io_hdr *)hdr_store;
 	struct sg_device *sdp = sfp->parentdp;
 
-	res = sg_allow_if_err_recovery(sdp, (filp->f_flags & O_NONBLOCK));
+	res = sg_allow_if_err_recovery(sdp, (filp->f_flags & O_NONBLOCK), false);
 	if (unlikely(res))
 		return res;
 	if (copy_from_user(h3p, p, SZ_SG_IO_HDR))
@@ -1167,10 +1166,9 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
  * returns true (or an event like a signal (e.g. control-C) occurs).
  */
 static inline bool
-sg_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp, int pack_id,
-		 bool *busy)
+sg_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp, int pack_id)
 {
-	struct sg_request *srp = sg_find_srp_by_id(sfp, pack_id, busy);
+	struct sg_request *srp = sg_find_srp_by_id(sfp, pack_id);
 
 	*srpp = srp;
 	return !!srp;
@@ -1367,7 +1365,6 @@ static int
 sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
 {
 	bool non_block = !!(filp->f_flags & O_NONBLOCK);
-	bool busy;
 	int res, id;
 	int pack_id = SG_PACK_ID_WILDCARD;
 	u8 v4_holder[SZ_SG_IO_V4];
@@ -1375,7 +1372,7 @@ sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
 	struct sg_device *sdp = sfp->parentdp;
 	struct sg_request *srp;
 
-	res = sg_allow_if_err_recovery(sdp, non_block);
+	res = sg_allow_if_err_recovery(sdp, non_block, true);
 	if (res)
 		return res;
 	/* Get first three 32 bit integers: guard, proto+subproto */
@@ -1390,19 +1387,19 @@ sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
 	/* read in part of v3 or v4 header for pack_id or tag based find */
 	id = pack_id;
 try_again:
-	srp = sg_find_srp_by_id(sfp, id, &busy);
-	while (!srp) {	/* nothing available so wait on packet or */
-		if (unlikely(!busy && SG_IS_DETACHING(sdp)))
-			return -ENODEV;
+	srp = sg_find_srp_by_id(sfp, id);
+	if (IS_ERR(srp))
+		return PTR_ERR(srp);
+	if (!srp) {	/* nothing available so wait on packet or */
 		if (non_block)
 			return -EAGAIN;
 		res = wait_event_interruptible(sfp->read_wait,
 					       sg_get_ready_srp(sfp, &srp,
-								id, &busy));
-		if (unlikely(!busy && SG_IS_DETACHING(sdp)))
-			return -ENODEV;
-		if (res)
-			return res;	/* signal --> -ERESTARTSYS */
+								id));
+		if (IS_ERR(srp))
+			return PTR_ERR(srp);
+		if (unlikely(!srp))
+			return res; /* signal --> -ERESTARTSYS */
 	}
 	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
 		cpu_relax();
@@ -1421,7 +1418,6 @@ sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
 static int
 sg_ctl_ioreceive_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
 {
-	bool busy;
 	bool non_block = !!(filp->f_flags & O_NONBLOCK);
 	int res;
 	int pack_id = SG_PACK_ID_WILDCARD;
@@ -1430,7 +1426,7 @@ sg_ctl_ioreceive_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
 	struct sg_device *sdp = sfp->parentdp;
 	struct sg_request *srp;
 
-	res = sg_allow_if_err_recovery(sdp, non_block);
+	res = sg_allow_if_err_recovery(sdp, non_block, true);
 	if (unlikely(res))
 		return res;
 	/* Get first three 32 bit integers: guard, proto+subproto */
@@ -1446,17 +1442,19 @@ sg_ctl_ioreceive_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
 	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm))
 		pack_id = h3p->pack_id;
 try_again:
-	srp = sg_find_srp_by_id(sfp, pack_id, &busy);
-	while (!srp) {	/* nothing available so wait on packet or */
-		if (unlikely(!busy && SG_IS_DETACHING(sdp)))
-			return -ENODEV;
+	srp = sg_find_srp_by_id(sfp, pack_id);
+	if (IS_ERR(srp))
+		return PTR_ERR(srp);
+	if (!srp) {	/* nothing available so wait on packet or */
 		if (non_block)
 			return -EAGAIN;
 		res = wait_event_interruptible
 				(sfp->read_wait,
-				 sg_get_ready_srp(sfp, &srp, pack_id, &busy));
-		if (unlikely(res))
-			return res;	/* signal --> -ERESTARTSYS */
+				 sg_get_ready_srp(sfp, &srp, pack_id));
+		if (IS_ERR(srp))
+			return PTR_ERR(srp);
+		if (unlikely(!srp))
+			return res; /* signal --> -ERESTARTSYS */
 	}
 	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
 		cpu_relax();
@@ -1587,10 +1585,8 @@ static ssize_t
 sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 {
 	bool non_block = !!(filp->f_flags & O_NONBLOCK);
-	bool busy;
 	int ret;
 	int req_pack_id = -1;
-	struct sg_device *sdp;
 	struct sg_fd *sfp;
 	struct sg_request *srp;
 
@@ -1603,7 +1599,6 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 		return ret;
 
 	sfp = filp->private_data;
-	sdp = sfp->parentdp;
 	SG_LOG(3, sfp, "%s: read() count=%d\n", __func__, (int)count);
 
 	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm)) {
@@ -1613,20 +1608,19 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 	}
 
 try_again:
-	srp = sg_find_srp_by_id(sfp, req_pack_id, &busy);
-	while (!srp) {	/* now wait on packet to arrive */
-		if (unlikely(!busy && SG_IS_DETACHING(sdp)))
-			return -ENODEV;
+	srp = sg_find_srp_by_id(sfp, req_pack_id);
+	if (IS_ERR(srp))
+		return PTR_ERR(srp);
+	if (!srp) {	/* now wait on packet to arrive */
 		if (non_block) /* O_NONBLOCK or v3::flags & SGV4_FLAG_IMMED */
 			return -EAGAIN;
 		ret = wait_event_interruptible(sfp->read_wait,
-			((srp = sg_find_srp_by_id(sfp, req_pack_id, &busy)) ||
-			(!busy && SG_IS_DETACHING(sdp))));
-		if (unlikely(SG_IS_DETACHING(sdp)))
-			return -ENODEV;
-		if (ret)	/* -ERESTARTSYS as signal hit process */
-			return ret;
-		/* otherwise srp should be valid */
+					       sg_get_ready_srp(sfp, &srp,
+								req_pack_id));
+		if (IS_ERR(srp))
+			return PTR_ERR(srp);
+		if (unlikely(!srp))
+			return ret; /* signal --> -ERESTARTSYS */
 	}
 	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
 		cpu_relax();
@@ -1740,10 +1734,9 @@ sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp,
 }
 
 static inline bool
-sg_rq_landed(struct sg_device *sdp, struct sg_request *srp)
+sg_rq_landed(struct sg_request *srp)
 {
-	return atomic_read_acquire(&srp->rq_st) != SG_RS_INFLIGHT ||
-	       unlikely(SG_IS_DETACHING(sdp));
+	return atomic_read_acquire(&srp->rq_st) != SG_RS_INFLIGHT;
 }
 
 /*
@@ -1770,7 +1763,7 @@ sg_wait_event_srp(struct file *filp, struct sg_fd *sfp, void __user *p,
 	SG_LOG(3, sfp, "%s: about to wait_event...()\n", __func__);
 	/* usually will be woken up by sg_rq_end_io() callback */
 	res = wait_event_interruptible(sfp->read_wait,
-				       sg_rq_landed(sdp, srp));
+				       sg_rq_landed(srp));
 	if (unlikely(res)) { /* -ERESTARTSYS because signal hit thread */
 		set_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
 		/* orphans harvested when sfp->keep_orphan is false */
@@ -1780,11 +1773,6 @@ sg_wait_event_srp(struct file *filp, struct sg_fd *sfp, void __user *p,
 		return res;
 	}
 skip_wait:
-	if (unlikely(SG_IS_DETACHING(sdp))) {
-		sg_rq_chg_state_force(srp, SG_RS_INACTIVE);
-		atomic_inc(&sfp->inactives);
-		return -ENODEV;
-	}
 	sr_st = atomic_read(&srp->rq_st);
 	if (unlikely(sr_st != SG_RS_AWAIT_RCV))
 		return -EPROTO;         /* Logic error */
@@ -1818,7 +1806,7 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 
 	SG_LOG(3, sfp, "%s:  SG_IO%s\n", __func__,
 	       ((filp->f_flags & O_NONBLOCK) ? " O_NONBLOCK ignored" : ""));
-	res = sg_allow_if_err_recovery(sdp, false);
+	res = sg_allow_if_err_recovery(sdp, false, false);
 	if (res)
 		return res;
 	if (get_sg_io_hdr(h3p, buf))
@@ -2007,8 +1995,6 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 
 	SG_LOG(6, sfp, "%s: cmd=0x%x, O_NONBLOCK=%d\n", __func__, cmd_in,
 	       !!(filp->f_flags & O_NONBLOCK));
-	if (unlikely(SG_IS_DETACHING(sdp)))
-		return -ENODEV;
 	sdev = sdp->device;
 
 	switch (cmd_in) {
@@ -2027,6 +2013,8 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		SG_LOG(3, sfp, "%s:    SG_IORECEIVE_V3\n", __func__);
 		return sg_ctl_ioreceive_v3(filp, sfp, p);
 	case SG_GET_SCSI_ID:
+		if (unlikely(SG_IS_DETACHING(sdp)))
+			return -ENODEV;
 		return sg_ctl_scsi_id(sdev, sfp, p);
 	case SG_SET_FORCE_PACK_ID:
 		SG_LOG(3, sfp, "%s:    SG_SET_FORCE_PACK_ID\n", __func__);
@@ -2158,6 +2146,8 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		return put_user(sdev->host->hostt->emulated, ip);
 	case SCSI_IOCTL_SEND_COMMAND:
 		SG_LOG(3, sfp, "%s:    SCSI_IOCTL_SEND_COMMAND\n", __func__);
+		if (unlikely(SG_IS_DETACHING(sdp)))
+			return -ENODEV;
 		return scsi_ioctl(sdp->device, filp->f_mode, cmd_in, p);
 	case SG_SET_DEBUG:
 		SG_LOG(3, sfp, "%s:    SG_SET_DEBUG\n", __func__);
@@ -2207,7 +2197,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 			return -EPERM;	/* don't know, so take safer approach */
 		break;
 	}
-	result = sg_allow_if_err_recovery(sdp, filp->f_flags & O_NDELAY);
+	result = sg_allow_if_err_recovery(sdp, filp->f_flags & O_NDELAY, false);
 	if (unlikely(result))
 		return result;
 	return -ENOIOCTLCMD;
@@ -2422,7 +2412,6 @@ sg_vma_fault(struct vm_fault *vmf)
 	struct page *page;
 	struct sg_scatter_hold *rsv_schp;
 	struct sg_request *srp;
-	struct sg_device *sdp;
 	struct sg_fd *sfp;
 	const char *nbp = "==NULL, bad";
 
@@ -2435,11 +2424,6 @@ sg_vma_fault(struct vm_fault *vmf)
 		pr_warn("%s: sfp%s\n", __func__, nbp);
 		goto out_err;
 	}
-	sdp = sfp->parentdp;
-	if (sdp && unlikely(SG_IS_DETACHING(sdp))) {
-		SG_LOG(1, sfp, "%s: device detaching\n", __func__);
-		goto out_err;
-	}
 	srp = sfp->rsv_srp;
 	if (!srp) {
 		SG_LOG(1, sfp, "%s: srp%s\n", __func__, nbp);
@@ -3237,8 +3221,17 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 	SG_LOG(4, sfp, "%s: srp=0x%pK%s\n", __func__, srp,
 	       (srp->parentfp->rsv_srp == srp) ? " rsv" : "");
 	if (test_and_clear_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
-		if (atomic_dec_and_test(&sfp->submitted))
+		if (atomic_dec_and_test(&sfp->submitted)) {
 			clear_bit(SG_FFD_POLLED_SEEN, sfp->ffd_bm);
+
+			/*
+			 * If the device is detaching, wakeup any ioreceives in
+			 * case we just finished the last response, which would
+			 * leave nothing for them to return other than -ENODEV.
+			 */
+			if (unlikely(SG_IS_DETACHING(sfp->parentdp)))
+				wake_up_interruptible_all(&sfp->read_wait);
+		}
 		atomic_dec(&sfp->waiting);
 	}
 
@@ -3410,15 +3403,14 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
  * If there are multiple requests outstanding, the speed of this function is
  * important. SG_PACK_ID_WILDCARD is -1 and that case is typically the fast
  * path. This function is only used in the non-blocking cases. Returns pointer
- * to (first) matching sg_request or NULL. If found, sg_request state is moved
- * from SG_RS_AWAIT_RCV to SG_RS_BUSY.
- * The 'busy' pointer is only set to true when no requests are found in the
- * SG_RS_AWAIT_RCV state and SG_IS_DETACHING() is true and there is at least
- * one request in SG_RS_INFLIGHT state; in all other cases *busy is set false.
+ * to (first) matching sg_request, or NULL if the caller should wait for
+ * request completion, or an ERR_PTR if the caller should return an error
+ * without waiting for request completion. If a request is found, sg_request
+ * state is moved from SG_RS_AWAIT_RCV to SG_RS_BUSY.
  */
 
 static struct sg_request *
-sg_find_srp_by_id(struct sg_fd *sfp, int pack_id, bool *busy)
+sg_find_srp_by_id(struct sg_fd *sfp, int pack_id)
 {
 	__maybe_unused bool is_bad_st = false;
 	__maybe_unused enum sg_rq_state bad_sr_st = SG_RS_INACTIVE;
@@ -3432,13 +3424,12 @@ sg_find_srp_by_id(struct sg_fd *sfp, int pack_id, bool *busy)
 	struct sg_request *srp = NULL;
 	struct xarray *xafp = &sfp->srp_arr;
 
-	*busy = false;
 	if (test_bit(SG_FFD_POLLED_SEEN, sfp->ffd_bm))
 		sg_sfp_bio_poll(sfp, 0);	/* LLD may have some ready to push up */
 	if (num_waiting < 1) {
 		num_waiting = atomic_read_acquire(&sfp->waiting);
 		if (num_waiting < 1)
-			return NULL;
+			goto check_detach;
 	}
 
 	s_idx = (l_await_idx < 0) ? 0 : l_await_idx;
@@ -3502,16 +3493,6 @@ sg_find_srp_by_id(struct sg_fd *sfp, int pack_id, bool *busy)
 		}
 	}
 	/* here if one of above loops does _not_ find a match */
-	if (unlikely(SG_IS_DETACHING(sfp->parentdp))) {
-		xa_for_each(xafp, idx, srp) {
-			if (!srp)
-				continue;
-			if (atomic_read(&srp->rq_st) == SG_RS_INFLIGHT) {
-				*busy = true;
-				return NULL;
-			}
-		}
-	}
 	if (IS_ENABLED(CONFIG_SCSI_PROC_FS)) {
 		if (search_for_1) {
 			__maybe_unused const char *cptp = "pack_id=";
@@ -3525,6 +3506,39 @@ sg_find_srp_by_id(struct sg_fd *sfp, int pack_id, bool *busy)
 				       __func__, cptp, pack_id);
 		}
 	}
+check_detach:
+	if (unlikely(SG_IS_DETACHING(sfp->parentdp))) {
+		/*
+		 * The device is being removed, but we still want to allow
+		 * inflight commands to complete.  Return NULL when there are
+		 * still inflight commands that will generate responses to
+		 * receive.  Return ERR_PTR(-ENODEV) when there are no commands
+		 * left.
+		 */
+		if (atomic_read(&sfp->submitted) == 0)
+			return ERR_PTR(-ENODEV);
+		if (search_for_1) {
+			xa_for_each(xafp, idx, srp) {
+				if (srp && pack_id == srp->pack_id) {
+					switch (atomic_read(&srp->rq_st)) {
+					case SG_RS_INFLIGHT:
+					case SG_RS_AWAIT_RCV:
+						/*
+						 * Wait to return this
+						 * response.
+						 */
+						return NULL;
+
+					default:
+						break;
+					}
+				}
+			}
+			/* No command matching pack_id. */
+			return ERR_PTR(-ENODEV);
+		}
+		/* else return NULL below */
+	}
 	return NULL;
 good:
 	SG_LOG(5, sfp, "%s: %s%d found [srp=0x%pK]\n", __func__, "pack_id=",
-- 
2.37.3

