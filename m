Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE095C3A5A7
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 02:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D82D22CED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 02:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfH2C1e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 22:27:34 -0400
Received: from smtp.infotech.no ([82.134.31.41]:40133 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727216AbfH2C1d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Aug 2019 22:27:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 6AC0D204269;
        Thu, 29 Aug 2019 04:27:31 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id y9QW4ENiRiH8; Thu, 29 Aug 2019 04:27:28 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 60462204255;
        Thu, 29 Aug 2019 04:27:27 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@infradead.org,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH v4 16/22] sg: expand sg_comm_wr_t
Date:   Wed, 28 Aug 2019 22:26:53 -0400
Message-Id: <20190829022659.23130-17-dgilbert@interlog.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190829022659.23130-1-dgilbert@interlog.com>
References: <20190829022659.23130-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The internal struct sg_comm_wr_t was added when the number of
arguments to sg_common_write() became excessive. Expand this idea
so multiple calls to sg_fetch_cmnd() can be deferred until a
scsi_request object is ready to receive the command. This saves
a 252 byte stack allocation on every submit path. Prior to this
and a few other changes, the kernel infrastructure was warning
about excessive stack usage.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 178 ++++++++++++++++++++++++----------------------
 1 file changed, 92 insertions(+), 86 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4470aa0b2168..51a8511dc331 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -253,35 +253,37 @@ struct sg_device { /* holds the state of each scsi generic device */
 
 struct sg_comm_wr_t {	/* arguments to sg_common_write() */
 	int timeout;
+	int cmd_len;
 	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
 	union {		/* selector is frq_bm.SG_FRQ_IS_V4I */
 		struct sg_io_hdr *h3p;
 		struct sg_io_v4 *h4p;
 	};
-	u8 *cmnd;
+	struct sg_fd *sfp;
+	struct file *filp;
+	const u8 __user *u_cmdp;
 };
 
 /* tasklet or soft irq callback */
 static void sg_rq_end_io(struct request *rq, blk_status_t status);
 /* Declarations of other static functions used before they are defined */
 static int sg_proc_init(void);
-static int sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
-			struct sg_io_v4 *h4p, int dxfer_dir);
+static int sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp,
+			int dxfer_dir);
 static void sg_finish_scsi_blk_rq(struct sg_request *srp);
 static int sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen);
 static int sg_v3_submit(struct file *filp, struct sg_fd *sfp,
 			struct sg_io_hdr *hp, bool sync,
 			struct sg_request **o_srp);
-static struct sg_request *sg_common_write(struct sg_fd *sfp,
-					  struct sg_comm_wr_t *cwp);
+static struct sg_request *sg_common_write(struct sg_comm_wr_t *cwp);
 static int sg_rd_append(struct sg_request *srp, void __user *outp,
 			int num_xfer);
 static void sg_remove_sgat(struct sg_request *srp);
 static struct sg_fd *sg_add_sfp(struct sg_device *sdp);
 static void sg_remove_sfp(struct kref *);
 static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int id);
-static struct sg_request *sg_add_request(struct sg_fd *sfp, int dxfr_len,
-					 struct sg_comm_wr_t *cwrp);
+static struct sg_request *sg_add_request(struct sg_comm_wr_t *cwrp,
+					 int dxfr_len);
 static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int min_dev);
 static void sg_device_destroy(struct kref *kref);
@@ -578,7 +580,6 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
 	struct sg_request *srp;
-	u8 cmnd[SG_MAX_CDB_SIZE];
 	struct sg_header ov2hdr;
 	struct sg_io_hdr v3hdr;
 	struct sg_header *ohp = &ov2hdr;
@@ -663,9 +664,6 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	h3p->flags = input_size;         /* structure abuse ... */
 	h3p->pack_id = ohp->pack_id;
 	h3p->usr_ptr = NULL;
-	cmnd[0] = opcode;
-	if (__copy_from_user(cmnd + 1, p + 1, cmd_size - 1))
-		return -EFAULT;
 	/*
 	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
 	 * but it is possible that the app intended SG_DXFER_TO_DEV, because
@@ -676,13 +674,16 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 			"%s: data in/out %d/%d bytes for SCSI command 0x%x-- guessing data in;\n"
 			"   program %s not setting count and/or reply_len properly\n",
 			__func__, ohp->reply_len - (int)SZ_SG_HEADER,
-			input_size, (unsigned int)cmnd[0], current->comm);
+			input_size, (unsigned int)opcode, current->comm);
 	}
-	cwr.frq_bm[0] = 0;	/* initial state clear for all req flags */
+	memset(&cwr, 0, sizeof(cwr));
 	cwr.h3p = h3p;
 	cwr.timeout = sfp->timeout;
-	cwr.cmnd = cmnd;
-	srp = sg_common_write(sfp, &cwr);
+	cwr.cmd_len = cmd_size;
+	cwr.filp = filp;
+	cwr.sfp = sfp;
+	cwr.u_cmdp = p;
+	srp = sg_common_write(&cwr);
 	return (IS_ERR(srp)) ? PTR_ERR(srp) : (int)count;
 }
 
@@ -711,11 +712,9 @@ static int
 sg_v3_submit(struct file *filp, struct sg_fd *sfp, struct sg_io_hdr *hp,
 	     bool sync, struct sg_request **o_srp)
 {
-	int res, timeout;
 	unsigned long ul_timeout;
 	struct sg_request *srp;
 	struct sg_comm_wr_t cwr;
-	u8 cmnd[SG_MAX_CDB_SIZE];
 
 	/* now doing v3 blocking (sync) or non-blocking submission */
 	if (hp->flags & SG_FLAG_MMAP_IO) {
@@ -729,16 +728,15 @@ sg_v3_submit(struct file *filp, struct sg_fd *sfp, struct sg_io_hdr *hp,
 	/* when v3 seen, allow cmd_q on this fd (def: no cmd_q) */
 	set_bit(SG_FFD_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(hp->timeout);
-	timeout = min_t(unsigned long, ul_timeout, INT_MAX);
-	res = sg_fetch_cmnd(filp, sfp, hp->cmdp, hp->cmd_len, cmnd);
-	if (res)
-		return res;
-	cwr.frq_bm[0] = 0;
+	memset(&cwr, 0, sizeof(cwr));
 	__assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)sync);
 	cwr.h3p = hp;
-	cwr.timeout = timeout;
-	cwr.cmnd = cmnd;
-	srp = sg_common_write(sfp, &cwr);
+	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
+	cwr.cmd_len = hp->cmd_len;
+	cwr.filp = filp;
+	cwr.sfp = sfp;
+	cwr.u_cmdp = hp->cmdp;
+	srp = sg_common_write(&cwr);
 	if (IS_ERR(srp))
 		return PTR_ERR(srp);
 	if (o_srp)
@@ -750,12 +748,15 @@ static int
 sg_v4_submit(struct file *filp, struct sg_fd *sfp, void __user *p,
 	     struct sg_io_v4 *h4p, bool sync, struct sg_request **o_srp)
 {
-	int timeout, res;
+	int res = 0;
 	unsigned long ul_timeout;
 	struct sg_request *srp;
 	struct sg_comm_wr_t cwr;
-	u8 cmnd[SG_MAX_CDB_SIZE];
 
+	memset(&cwr, 0, sizeof(cwr));
+	cwr.filp = filp;
+	cwr.sfp = sfp;
+	cwr.h4p = h4p;
 	if (h4p->flags & SG_FLAG_MMAP_IO) {
 		int len = 0;
 
@@ -773,18 +774,13 @@ sg_v4_submit(struct file *filp, struct sg_fd *sfp, void __user *p,
 	/* once v4 (or v3) seen, allow cmd_q on this fd (def: no cmd_q) */
 	set_bit(SG_FFD_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(h4p->timeout);
-	timeout = min_t(unsigned long, ul_timeout, INT_MAX);
-	res = sg_fetch_cmnd(filp, sfp, cuptr64(h4p->request), h4p->request_len,
-			    cmnd);
-	if (res)
-		return res;
-	cwr.frq_bm[0] = 0;
-	assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)sync);
-	set_bit(SG_FRQ_IS_V4I, cwr.frq_bm);
+	__assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)sync);
+	__set_bit(SG_FRQ_IS_V4I, cwr.frq_bm);
 	cwr.h4p = h4p;
-	cwr.timeout = timeout;
-	cwr.cmnd = cmnd;
-	srp = sg_common_write(sfp, &cwr);
+	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
+	cwr.cmd_len = h4p->request_len;
+	cwr.u_cmdp = cuptr64(h4p->request);
+	srp = sg_common_write(&cwr);
 	if (IS_ERR(srp))
 		return PTR_ERR(srp);
 	if (o_srp)
@@ -862,13 +858,14 @@ sg_rstate_chg(struct sg_request *srp, enum sg_rq_state old_st,
  * N.B. pack_id placed in sg_io_v4::request_extra field.
  */
 static struct sg_request *
-sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
+sg_common_write(struct sg_comm_wr_t *cwrp)
 {
 	int res = 0;
-	int dxfr_len, dir, cmd_len;
+	int dxfr_len, dir;
 	int pack_id = SG_PACK_ID_WILDCARD;
 	u32 rq_flags;
-	struct sg_device *sdp = sfp->parentdp;
+	struct sg_fd *fp = cwrp->sfp;
+	struct sg_device *sdp = fp->parentdp;
 	struct sg_request *srp;
 	struct sg_io_hdr *hi_p;
 	struct sg_io_v4 *h4p;
@@ -900,7 +897,7 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 	if (dxfr_len >= SZ_256M)
 		return ERR_PTR(-EINVAL);
 
-	srp = sg_add_request(sfp, dxfr_len, cwrp);
+	srp = sg_add_request(cwrp, dxfr_len);
 	if (IS_ERR(srp))
 		return srp;
 	srp->rq_flags = rq_flags;
@@ -913,18 +910,14 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 		srp->s_hdr4.max_sb_len = h4p->max_response_len;
 		srp->s_hdr4.cmd_len = h4p->request_len;
 		srp->s_hdr4.dir = dir;
-		cmd_len = h4p->request_len;
 	} else {	/* v3 interface active */
-		cmd_len = hi_p->cmd_len;
 		memcpy(&srp->s_hdr3, hi_p, sizeof(srp->s_hdr3));
 	}
-	srp->cmd_opcode = cwrp->cmnd[0];/* hold opcode of command for debug */
-	SG_LOG(4, sfp, "%s: opcode=0x%02x, cdb_sz=%d, pack_id=%d\n", __func__,
-	       (int)cwrp->cmnd[0], cmd_len, pack_id);
-
-	res = sg_start_req(srp, cwrp->cmnd, cmd_len, h4p, dir);
+	res = sg_start_req(srp, cwrp, dir);
 	if (res < 0)		/* probably out of space --> -ENOMEM */
 		goto err_out;
+	SG_LOG(4, fp, "%s: opcode=0x%02x, cdb_sz=%d, pack_id=%d\n", __func__,
+	       srp->cmd_opcode, cwrp->cmd_len, pack_id);
 	if (unlikely(SG_IS_DETACHING(sdp))) {
 		res = -ENODEV;
 		goto err_out;
@@ -934,11 +927,11 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 		goto err_out;
 	}
 	srp->rq->timeout = cwrp->timeout;
-	sg_execute_cmd(sfp, srp);
+	sg_execute_cmd(fp, srp);
 	return srp;
 err_out:
 	sg_finish_scsi_blk_rq(srp);
-	sg_deact_request(sfp, srp);
+	sg_deact_request(fp, srp);
 	return ERR_PTR(res);
 }
 
@@ -1171,8 +1164,8 @@ sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
 								id));
 		if (unlikely(SG_IS_DETACHING(sdp)))
 			return -ENODEV;
-		if (res)	/* -ERESTARTSYS as signal hit process */
-			return res;
+		if (res)
+			return res;	/* signal --> -ERESTARTSYS */
 	}	/* now srp should be valid */
 	return sg_v4_receive(sfp, srp, p, h4p);
 }
@@ -2574,7 +2567,7 @@ init_sg(void)
 	}
 	sg_sysfs_valid = true;
 	rc = scsi_register_interface(&sg_interface);
-	if (0 == rc) {
+	if (rc == 0) {
 		sg_proc_init();
 		return 0;
 	}
@@ -2638,8 +2631,7 @@ sg_set_map_data(const struct sg_scatter_hold *schp, bool up_valid,
 }
 
 static int
-sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
-	     struct sg_io_v4 *h4p, int dxfer_dir)
+sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 {
 	bool reserved, us_xfer;
 	int res = 0;
@@ -2649,7 +2641,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
 	void __user *up;
 	struct request *rq;
 	struct scsi_request *scsi_rp;
-	struct sg_fd *sfp = srp->parentfp;
+	struct sg_fd *sfp = cwrp->sfp;
 	struct sg_device *sdp;
 	struct sg_scatter_hold *req_schp;
 	struct request_queue *q;
@@ -2659,20 +2651,21 @@ sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
 	struct rq_map_data map_data;
 
 	sdp = sfp->parentdp;
-	if (cmd_len > BLK_MAX_CDB) {	/* for longer SCSI cdb_s */
-		long_cmdp = kzalloc(cmd_len, GFP_KERNEL);
+	if (cwrp->cmd_len > BLK_MAX_CDB) {	/* for longer SCSI cdb_s */
+		long_cmdp = kzalloc(cwrp->cmd_len, GFP_KERNEL);
 		if (!long_cmdp)
 			return -ENOMEM;
 		SG_LOG(5, sfp, "%s: long_cmdp=0x%p ++\n", __func__, long_cmdp);
 	}
-	if (h4p) {
+	if (test_bit(SG_FRQ_IS_V4I, srp->frq_bm)) {
+		struct sg_io_v4 *h4p = cwrp->h4p;
+
 		if (dxfer_dir == SG_DXFER_TO_DEV) {
 			r0w = WRITE;
 			up = uptr64(h4p->dout_xferp);
 			dxfer_len = (int)h4p->dout_xfer_len;
 			iov_count = h4p->dout_iovec_count;
 		} else if (dxfer_dir == SG_DXFER_FROM_DEV) {
-			r0w = READ;
 			up = uptr64(h4p->din_xferp);
 			dxfer_len = (int)h4p->din_xfer_len;
 			iov_count = h4p->din_iovec_count;
@@ -2703,7 +2696,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
 	 * not expect an EWOULDBLOCK from this condition.
 	 */
 	rq = blk_get_request(q, (r0w ? REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN), 0);
-	if (unlikely(IS_ERR(rq))) {
+	if (IS_ERR(rq)) {
 		kfree(long_cmdp);
 		return PTR_ERR(rq);
 	}
@@ -2711,10 +2704,19 @@ sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
 	scsi_rp = scsi_req(rq);
 	srp->rq = rq;
 
-	if (cmd_len > BLK_MAX_CDB)
+	if (cwrp->cmd_len > BLK_MAX_CDB)
 		scsi_rp->cmd = long_cmdp;
-	memcpy(scsi_rp->cmd, cmd, cmd_len);
-	scsi_rp->cmd_len = cmd_len;
+	if (cwrp->u_cmdp)
+		res = sg_fetch_cmnd(cwrp->filp, sfp, cwrp->u_cmdp,
+				    cwrp->cmd_len, scsi_rp->cmd);
+	else
+		res = -EPROTO;
+	if (res) {
+		kfree(long_cmdp);
+		return res;
+	}
+	scsi_rp->cmd_len = cwrp->cmd_len;
+	srp->cmd_opcode = scsi_rp->cmd[0];
 	us_xfer = !(srp->rq_flags & SG_FLAG_NO_DXFER);
 	assign_bit(SG_FRQ_NO_US_XFER, srp->frq_bm, !us_xfer);
 	reserved = (sfp->rsv_srp == srp);
@@ -2738,7 +2740,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
 	}
 
 	if (likely(md)) {	/* normal, "indirect" IO */
-		if (unlikely((srp->rq_flags & SG_FLAG_MMAP_IO))) {
+		if (unlikely(srp->rq_flags & SG_FLAG_MMAP_IO)) {
 			/* mmap IO must use and fit in reserve request */
 			if (!reserved || dxfer_len > req_schp->buflen)
 				res = reserved ? -ENOMEM : -EBUSY;
@@ -2747,7 +2749,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
 
 			res = sg_mk_sgat(srp, sfp, up_sz);
 		}
-		if (res)
+		if (unlikely(res))
 			goto fini;
 
 		sg_set_map_data(req_schp, !!up, md);
@@ -3104,7 +3106,7 @@ sg_mk_srp_sgat(struct sg_fd *sfp, bool first, int db_len)
 		return n_srp;
 	if (db_len > 0) {
 		res = sg_mk_sgat(n_srp, sfp, db_len);
-		if (res) {
+		if (unlikely(res)) {
 			kfree(n_srp);
 			return ERR_PTR(res);
 		}
@@ -3157,27 +3159,28 @@ sg_build_reserve(struct sg_fd *sfp, int buflen)
  * failure returns a negated errno value twisted by ERR_PTR() macro.
  */
 static struct sg_request *
-sg_add_request(struct sg_fd *sfp, int dxfr_len, struct sg_comm_wr_t *cwrp)
+sg_add_request(struct sg_comm_wr_t *cwrp, int dxfr_len)
 {
 	bool act_empty = false;
 	bool mk_new_srp = true;
 	unsigned long iflags;
 	enum sg_rq_state sr_st;
+	struct sg_fd *fp = cwrp->sfp;
 	struct sg_request *r_srp = NULL;	/* request to return */
 	struct sg_request *rsv_srp;	/* current fd's reserve request */
 	__maybe_unused const char *cp;
 
-	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
-	rsv_srp = sfp->rsv_srp;
+	spin_lock_irqsave(&fp->rq_list_lock, iflags);
+	rsv_srp = fp->rsv_srp;
 	cp = "";
 	/*
 	 * Check the free list (fl) for candidates. Pick zero data length
 	 * requests from the back of the fl, the rest from the front.
 	 */
-	if (list_empty(&sfp->rq_fl)) {
+	if (list_empty(&fp->rq_fl)) {
 		act_empty = true;
 	} else if (dxfr_len < 1) {  /* 0 data length requests at back of fl */
-		list_for_each_entry_reverse(r_srp, &sfp->rq_fl, fl_entry) {
+		list_for_each_entry_reverse(r_srp, &fp->rq_fl, fl_entry) {
 			sr_st = atomic_read(&r_srp->rq_st);
 			if (sr_st == SG_RS_INACTIVE) {
 				if (likely(sg_rstate_chg(r_srp, sr_st,
@@ -3189,7 +3192,7 @@ sg_add_request(struct sg_fd *sfp, int dxfr_len, struct sg_comm_wr_t *cwrp)
 			}
 		}
 	} else { /*     find request with large enough dlen */
-		list_for_each_entry(r_srp, &sfp->rq_fl, fl_entry) {
+		list_for_each_entry(r_srp, &fp->rq_fl, fl_entry) {
 			sr_st = atomic_read(&r_srp->rq_st);
 			if (sr_st == SG_RS_INACTIVE &&
 			    r_srp->sgat_h.buflen >= dxfr_len) {
@@ -3204,23 +3207,23 @@ sg_add_request(struct sg_fd *sfp, int dxfr_len, struct sg_comm_wr_t *cwrp)
 	}
 
 	if (mk_new_srp) {	/* Need new sg_request object */
-		bool allow_cmd_q = test_bit(SG_FFD_CMD_Q, sfp->ffd_bm);
+		bool allow_cmd_q = test_bit(SG_FFD_CMD_Q, fp->ffd_bm);
 
 		r_srp = NULL;
-		if (!allow_cmd_q && !list_empty(&sfp->rq_list)) {
+		if (!allow_cmd_q && !list_empty(&fp->rq_list)) {
 			r_srp = ERR_PTR(-EDOM);
-			SG_LOG(6, sfp, "%s: trying 2nd req but cmd_q=false\n",
+			SG_LOG(6, fp, "%s: trying 2nd req but cmd_q=false\n",
 			       __func__);
 		}
-		spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+		spin_unlock_irqrestore(&fp->rq_list_lock, iflags);
 		if (IS_ERR(r_srp))        /* NULL is not an ERR here */
 			goto err_no_lock;
 		/* releasing rq_list_lock because next line could take time */
-		r_srp = sg_mk_srp_sgat(sfp, act_empty, dxfr_len);
+		r_srp = sg_mk_srp_sgat(fp, act_empty, dxfr_len);
 		if (IS_ERR(r_srp))
 			goto err_no_lock;
 		cp = "new";
-		SG_LOG(4, sfp, "%s: mk_new_srp=0x%p ++\n", __func__, r_srp);
+		SG_LOG(4, fp, "%s: mk_new_srp=0x%p ++\n", __func__, r_srp);
 		atomic_set(&r_srp->rq_st, SG_RS_BUSY);
 	} else {	/* otherwise found srp is on fl, remove from fl */
 		list_del_rcu(&r_srp->fl_entry);
@@ -3230,20 +3233,21 @@ sg_add_request(struct sg_fd *sfp, int dxfr_len, struct sg_comm_wr_t *cwrp)
 	}
 	if (!mk_new_srp)
 		spin_lock(&r_srp->req_lck);
-	r_srp->frq_bm[0] = cwrp->frq_bm[0];	/* assumes <= 32 req flags */
+	/* following copes with unlikely case where frq_bm > one ulong */
+	memcpy(r_srp->frq_bm, cwrp->frq_bm, sizeof(r_srp->frq_bm));
 	r_srp->sgat_h.dlen = dxfr_len;/* must be <= r_srp->sgat_h.buflen */
 	r_srp->cmd_opcode = 0xff;  /* set invalid opcode (VS), 0x0 is TUR */
 	if (mk_new_srp)
-		spin_lock_irqsave(&sfp->rq_list_lock, iflags);
-	list_add_tail_rcu(&r_srp->rq_entry, &sfp->rq_list);
+		spin_lock_irqsave(&fp->rq_list_lock, iflags);
+	list_add_tail_rcu(&r_srp->rq_entry, &fp->rq_list);
 	if (!mk_new_srp)
 		spin_unlock(&r_srp->req_lck);
-	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	spin_unlock_irqrestore(&fp->rq_list_lock, iflags);
 err_no_lock:
 	if (IS_ERR(r_srp))
-		SG_LOG(1, sfp, "%s: err=%ld\n", __func__, PTR_ERR(r_srp));
+		SG_LOG(1, fp, "%s: err=%ld\n", __func__, PTR_ERR(r_srp));
 	if (!IS_ERR(r_srp))
-		SG_LOG(4, sfp, "%s: %s %sr_srp=0x%p\n", __func__, cp,
+		SG_LOG(4, fp, "%s: %s %sr_srp=0x%p\n", __func__, cp,
 		       ((r_srp == rsv_srp) ? "[rsv] " : ""), r_srp);
 	return r_srp;
 }
@@ -3335,6 +3339,8 @@ sg_add_sfp(struct sg_device *sdp)
 	__assign_bit(SG_FFD_CMD_Q, sfp->ffd_bm, SG_DEF_COMMAND_Q);
 	__assign_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm, SG_DEF_KEEP_ORPHAN);
 	__assign_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm, SG_DEFAULT_Q_AT);
+	atomic_set(&sfp->submitted, 0);
+	atomic_set(&sfp->waiting, 0);
 	/*
 	 * SG_SCATTER_SZ initializes scatter_elem_sz but different value may
 	 * be given as driver/module parameter (e.g. 'scatter_elem_sz=8192').
-- 
2.23.0

