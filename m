Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC2DC5518C
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A295920724
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgDUVxu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 17:53:50 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43166 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgDUVxq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 17:53:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 822D8204258;
        Tue, 21 Apr 2020 23:53:44 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PBBTg4W92S9T; Tue, 21 Apr 2020 23:53:41 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 2AE352041CF;
        Tue, 21 Apr 2020 23:53:37 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v9 30/40] sg: expand sg_comm_wr_t
Date:   Tue, 21 Apr 2020 17:52:48 -0400
Message-Id: <20200421215258.14348-31-dgilbert@interlog.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200421215258.14348-1-dgilbert@interlog.com>
References: <20200421215258.14348-1-dgilbert@interlog.com>
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

*** Reviewed-by: Hannes Reinecke <hare@suse.com>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 175 ++++++++++++++++++++++++----------------------
 1 file changed, 90 insertions(+), 85 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 93cc29185a29..f6758287d793 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -253,35 +253,37 @@ struct sg_device { /* holds the state of each scsi generic device */
 
 struct sg_comm_wr_t {  /* arguments to sg_common_write() */
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
-					  struct sg_comm_wr_t *cwrp);
+static struct sg_request *sg_common_write(struct sg_comm_wr_t *cwrp);
 static int sg_read_append(struct sg_request *srp, void __user *outp,
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
@@ -572,7 +574,6 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
 	struct sg_request *srp;
-	u8 cmnd[SG_MAX_CDB_SIZE];
 	struct sg_header ov2hdr;
 	struct sg_io_hdr v3hdr;
 	struct sg_header *ohp = &ov2hdr;
@@ -684,9 +685,6 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	h3p->flags = input_size;	/* structure abuse ... */
 	h3p->pack_id = ohp->pack_id;
 	h3p->usr_ptr = NULL;
-	cmnd[0] = opcode;
-	if (copy_from_user(cmnd + 1, p + 1, cmd_size - 1))
-		return -EFAULT;
 	/*
 	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
 	 * but it is possible that the app intended SG_DXFER_TO_DEV, because
@@ -698,13 +696,16 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 			 "%s: data in/out %d/%d bytes for SCSI command 0x%x-- guessing data in;\n"
 			 "   program %s not setting count and/or reply_len properly\n",
 			 __func__, ohp->reply_len - (int)SZ_SG_HEADER,
-			 input_size, (unsigned int)cmnd[0], current->comm);
+			 input_size, (unsigned int)opcode, current->comm);
 	}
-	cwr.frq_bm[0] = 0;	/* initial state clear for all req flags */
 	cwr.h3p = h3p;
+	cwr.frq_bm[0] = 0;
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
 
@@ -745,31 +746,29 @@ static int
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
-		res = sg_chk_mmap(sfp, hp->flags, hp->dxfer_len);
+		int res = sg_chk_mmap(sfp, hp->flags, hp->dxfer_len);
+
 		if (res)
 			return res;
 	}
 	/* when v3 seen, allow cmd_q on this fd (def: no cmd_q) */
 	set_bit(SG_FFD_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(hp->timeout);
-	timeout = min_t(unsigned long, ul_timeout, INT_MAX);
-	res = sg_fetch_cmnd(filp, sfp, hp->cmdp, hp->cmd_len, cmnd);
-	if (res)
-		return res;
 	cwr.frq_bm[0] = 0;
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
@@ -781,11 +780,10 @@ static int
 sg_submit_v4(struct file *filp, struct sg_fd *sfp, void __user *p,
 	     struct sg_io_v4 *h4p, bool sync, struct sg_request **o_srp)
 {
-	int timeout, res;
+	int res = 0;
 	unsigned long ul_timeout;
 	struct sg_request *srp;
 	struct sg_comm_wr_t cwr;
-	u8 cmnd[SG_MAX_CDB_SIZE];
 
 	if (h4p->flags & SG_FLAG_MMAP_IO) {
 		int len = 0;
@@ -801,18 +799,16 @@ sg_submit_v4(struct file *filp, struct sg_fd *sfp, void __user *p,
 	/* once v4 (or v3) seen, allow cmd_q on this fd (def: no cmd_q) */
 	set_bit(SG_FFD_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(h4p->timeout);
-	timeout = min_t(unsigned long, ul_timeout, INT_MAX);
-	res = sg_fetch_cmnd(filp, sfp, cuptr64(h4p->request), h4p->request_len,
-			    cmnd);
-	if (res)
-		return res;
+	cwr.filp = filp;
+	cwr.sfp = sfp;
 	cwr.frq_bm[0] = 0;
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
@@ -986,13 +982,14 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
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
@@ -1024,31 +1021,27 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 	if (dxfr_len >= SZ_256M)
 		return ERR_PTR(-EINVAL);
 
-	srp = sg_add_request(sfp, dxfr_len, cwrp);
+	srp = sg_add_request(cwrp, dxfr_len);
 	if (IS_ERR(srp))
 		return srp;
 	srp->rq_flags = rq_flags;
 	srp->pack_id = pack_id;
 
 	if (h4p) {
-		memset(&srp->s_hdr4, 0, sizeof(srp->s_hdr4));
 		srp->s_hdr4.usr_ptr = h4p->usr_ptr;
 		srp->s_hdr4.sbp = uptr64(h4p->response);
 		srp->s_hdr4.max_sb_len = h4p->max_response_len;
 		srp->s_hdr4.cmd_len = h4p->request_len;
 		srp->s_hdr4.dir = dir;
-		cmd_len = h4p->request_len;
+		srp->s_hdr4.out_resid = 0;
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
@@ -1057,17 +1050,17 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 		res = -EIDRM;	/* this failure unexpected but observed */
 		goto err_out;
 	}
-	if (xa_get_mark(&sfp->srp_arr, srp->rq_idx, SG_XA_RQ_FREE)) {
-		SG_LOG(1, sfp, "%s: ahhh, request erased!!!\n", __func__);
+	if (xa_get_mark(&fp->srp_arr, srp->rq_idx, SG_XA_RQ_FREE)) {
+		SG_LOG(1, fp, "%s: ahhh, request erased!!!\n", __func__);
 		res = -ENODEV;
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
 
@@ -1284,8 +1277,8 @@ sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
 								id));
 		if (unlikely(SG_IS_DETACHING(sdp)))
 			return -ENODEV;
-		if (res)	/* -ERESTARTSYS as signal hit process */
-			return res;
+		if (res)
+			return res;	/* signal --> -ERESTARTSYS */
 	}	/* now srp should be valid */
 	return sg_receive_v4(sfp, srp, p, h4p);
 }
@@ -2731,7 +2724,7 @@ init_sg(void)
 	}
 	sg_sysfs_valid = true;
 	rc = scsi_register_interface(&sg_interface);
-	if (0 == rc) {
+	if (rc == 0) {
 		sg_proc_init();
 		return 0;
 	}
@@ -2782,11 +2775,10 @@ sg_chk_dio_allowed(struct sg_device *sdp, struct sg_request *srp,
 	return false;
 }
 
-static void
+static inline void
 sg_set_map_data(const struct sg_scatter_hold *schp, bool up_valid,
 		struct rq_map_data *mdp)
 {
-	memset(mdp, 0, sizeof(*mdp));
 	mdp->pages = schp->pages;
 	mdp->page_order = schp->page_order;
 	mdp->nr_entries = schp->num_sgat;
@@ -2795,8 +2787,7 @@ sg_set_map_data(const struct sg_scatter_hold *schp, bool up_valid,
 }
 
 static int
-sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
-	     struct sg_io_v4 *h4p, int dxfer_dir)
+sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 {
 	bool reserved, us_xfer;
 	int res = 0;
@@ -2806,7 +2797,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
 	void __user *up;
 	struct request *rq;
 	struct scsi_request *scsi_rp;
-	struct sg_fd *sfp = srp->parentfp;
+	struct sg_fd *sfp = cwrp->sfp;
 	struct sg_device *sdp;
 	struct sg_scatter_hold *req_schp;
 	struct request_queue *q;
@@ -2816,20 +2807,21 @@ sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
 	struct rq_map_data map_data;
 
 	sdp = sfp->parentdp;
-	if (cmd_len > BLK_MAX_CDB) {	/* for longer SCSI cdb_s */
-		long_cmdp = kzalloc(cmd_len, GFP_KERNEL);
+	if (cwrp->cmd_len > BLK_MAX_CDB) {	/* for longer SCSI cdb_s */
+		long_cmdp = kzalloc(cwrp->cmd_len, GFP_KERNEL);
 		if (!long_cmdp)
 			return -ENOMEM;
 		SG_LOG(5, sfp, "%s: long_cmdp=0x%pK ++\n", __func__, long_cmdp);
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
@@ -2868,10 +2860,19 @@ sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
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
@@ -2894,7 +2895,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
 	}
 
 	if (likely(md)) {	/* normal, "indirect" IO */
-		if (unlikely((srp->rq_flags & SG_FLAG_MMAP_IO))) {
+		if (unlikely(srp->rq_flags & SG_FLAG_MMAP_IO)) {
 			/* mmap IO must use and fit in reserve request */
 			if (!reserved || dxfer_len > req_schp->buflen)
 				res = reserved ? -ENOMEM : -EBUSY;
@@ -2903,7 +2904,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
 
 			res = sg_mk_sgat(srp, sfp, up_sz);
 		}
-		if (res)
+		if (unlikely(res))
 			goto fini;
 
 		sg_set_map_data(req_schp, !!up, md);
@@ -3253,7 +3254,7 @@ sg_mk_srp_sgat(struct sg_fd *sfp, bool first, int db_len)
 		return n_srp;
 	if (db_len > 0) {
 		res = sg_mk_sgat(n_srp, sfp, db_len);
-		if (res) {
+		if (unlikely(res)) {
 			kfree(n_srp);
 			return ERR_PTR(res);
 		}
@@ -3306,18 +3307,18 @@ sg_build_reserve(struct sg_fd *sfp, int buflen)
  * failure returns a negated errno value twisted by ERR_PTR() macro.
  */
 static struct sg_request *
-sg_add_request(struct sg_fd *sfp, int dxfr_len, struct sg_comm_wr_t *cwrp)
+sg_add_request(struct sg_comm_wr_t *cwrp, int dxfr_len)
 {
 	bool act_empty = false;
 	bool found = false;
-	bool mk_new_srp = false;
+	bool mk_new_srp = true;
 	bool try_harder = false;
-	int res;
 	int num_inactive = 0;
 	unsigned long idx, last_idx, iflags;
+	struct sg_fd *fp = cwrp->sfp;
 	struct sg_request *r_srp = NULL;	/* request to return */
 	struct sg_request *last_srp = NULL;
-	struct xarray *xafp = &sfp->srp_arr;
+	struct xarray *xafp = &fp->srp_arr;
 	__maybe_unused const char *cp;
 
 start_again:
@@ -3371,18 +3372,19 @@ sg_add_request(struct sg_fd *sfp, int dxfr_len, struct sg_comm_wr_t *cwrp)
 		mk_new_srp = true;
 	}
 	if (mk_new_srp) {
-		bool allow_cmd_q = test_bit(SG_FFD_CMD_Q, sfp->ffd_bm);
+		bool allow_cmd_q = test_bit(SG_FFD_CMD_Q, fp->ffd_bm);
+		int res;
 		u32 n_idx;
 		struct xa_limit xal = { .max = 0, .min = 0 };
 
 		cp = "new";
-		if (!allow_cmd_q && atomic_read(&sfp->submitted) > 0) {
+		if (!allow_cmd_q && atomic_read(&fp->submitted) > 0) {
 			r_srp = ERR_PTR(-EDOM);
-			SG_LOG(6, sfp, "%s: trying 2nd req but cmd_q=false\n",
+			SG_LOG(6, fp, "%s: trying 2nd req but cmd_q=false\n",
 			       __func__);
 			goto fini;
 		}
-		r_srp = sg_mk_srp_sgat(sfp, act_empty, dxfr_len);
+		r_srp = sg_mk_srp_sgat(fp, act_empty, dxfr_len);
 		if (IS_ERR(r_srp)) {
 			if (!try_harder && dxfr_len < SG_DEF_SECTOR_SZ &&
 			    num_inactive > 0) {
@@ -3393,11 +3395,11 @@ sg_add_request(struct sg_fd *sfp, int dxfr_len, struct sg_comm_wr_t *cwrp)
 		}
 		atomic_set(&r_srp->rq_st, SG_RS_BUSY);
 		xa_lock_irqsave(xafp, iflags);
-		xal.max = atomic_inc_return(&sfp->req_cnt);
+		xal.max = atomic_inc_return(&fp->req_cnt);
 		res = __xa_alloc(xafp, &n_idx, r_srp, xal, GFP_KERNEL);
 		xa_unlock_irqrestore(xafp, iflags);
 		if (res < 0) {
-			SG_LOG(1, sfp, "%s: xa_alloc() failed, errno=%d\n",
+			SG_LOG(1, fp, "%s: xa_alloc() failed, errno=%d\n",
 			       __func__,  -res);
 			sg_remove_sgat(r_srp);
 			kfree(r_srp);
@@ -3406,17 +3408,18 @@ sg_add_request(struct sg_fd *sfp, int dxfr_len, struct sg_comm_wr_t *cwrp)
 		}
 		idx = n_idx;
 		r_srp->rq_idx = idx;
-		r_srp->parentfp = sfp;
-		SG_LOG(4, sfp, "%s: mk_new_srp=0x%pK ++\n", __func__, r_srp);
+		r_srp->parentfp = fp;
+		SG_LOG(4, fp, "%s: mk_new_srp=0x%pK ++\n", __func__, r_srp);
 	}
 	r_srp->frq_bm[0] = cwrp->frq_bm[0];	/* assumes <= 32 req flags */
 	r_srp->sgat_h.dlen = dxfr_len;/* must be <= r_srp->sgat_h.buflen */
 	r_srp->cmd_opcode = 0xff;  /* set invalid opcode (VS), 0x0 is TUR */
 fini:
 	if (IS_ERR(r_srp))
-		SG_LOG(1, sfp, "%s: err=%ld\n", __func__, PTR_ERR(r_srp));
+		SG_LOG(1, fp, "%s: err=%ld\n", __func__, PTR_ERR(r_srp));
 	if (!IS_ERR(r_srp))
-		SG_LOG(4, sfp, "%s: %s r_srp=0x%pK\n", __func__, cp, r_srp);
+		SG_LOG(4, fp, "%s: %s %sr_srp=0x%pK\n", __func__, cp,
+		       ((r_srp == fp->rsv_srp) ? "[rsv] " : ""), r_srp);
 	return r_srp;
 }
 
@@ -3471,6 +3474,8 @@ sg_add_sfp(struct sg_device *sdp)
 	__assign_bit(SG_FFD_CMD_Q, sfp->ffd_bm, SG_DEF_COMMAND_Q);
 	__assign_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm, SG_DEF_KEEP_ORPHAN);
 	__assign_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm, SG_DEFAULT_Q_AT);
+	atomic_set(&sfp->submitted, 0);
+	atomic_set(&sfp->waiting, 0);
 	/*
 	 * SG_SCATTER_SZ initializes scatter_elem_sz but different value may
 	 * be given as driver/module parameter (e.g. 'scatter_elem_sz=8192').
-- 
2.26.1

