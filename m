Return-Path: <SRS0=MD5Y=4P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE4BC35DF9
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 16:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9ABB2469F
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 16:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgB0Q75 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Feb 2020 11:59:57 -0500
Received: from smtp.infotech.no ([82.134.31.41]:47269 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729768AbgB0Q74 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Feb 2020 11:59:56 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 91AB920418E;
        Thu, 27 Feb 2020 17:59:50 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eBFoM+7ntCbY; Thu, 27 Feb 2020 17:59:45 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id A973E204194;
        Thu, 27 Feb 2020 17:59:38 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v7 25/38] sg: replace rq array with lists
Date:   Thu, 27 Feb 2020 11:58:49 -0500
Message-Id: <20200227165902.11861-26-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227165902.11861-1-dgilbert@interlog.com>
References: <20200227165902.11861-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the fixed size array of 16 request elements per file
descriptor and replace with the xarray added in the previous
patch. All sg_request objects are now kept, available for
re-use, until their owning file descriptor is closed. The
sg_request deletions are in sg_remove_sfp_usercontext().
Each active sg_request object has an associated block
request and a scsi_request object but they have different
lifetimes. The block request and the scsi_request object
are released much earlier; their lifetime is the same as it
was in the v3 sg driver. The lifetime of the bio is also the
same (but is stretched in a later patch).

Collect various flags into bit maps: one for requests
(SG_FRQ_*) and the other for file descriptors (SG_FFD_*).
They join a per sg_device bit map (SG_FDEV_*) added in an
earlier patch.

Prior to a new sg_request object being (re-)built, information
that will be placed in it uses a new struct sg_comm_wr_t
object.

Since the above changes touch almost every function and low
level structures, this patch is big.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 1568 +++++++++++++++++++++++++++++----------------
 1 file changed, 1008 insertions(+), 560 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ef3674b9a5dc..cc008cfba392 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -144,36 +144,51 @@ static struct class_interface sg_interface = {
 	.remove_dev     = sg_remove_device,
 };
 
+/* Subset of sg_io_hdr found in <scsi/sg.h>, has only [i] and [i->o] fields */
+struct sg_slice_hdr3 {
+	int interface_id;
+	int dxfer_direction;
+	u8 cmd_len;
+	u8 mx_sb_len;
+	u16 iovec_count;
+	unsigned int dxfer_len;
+	void __user *dxferp;
+	u8 __user *cmdp;
+	void __user *sbp;
+	unsigned int timeout;
+	unsigned int flags;
+	int pack_id;
+	void __user *usr_ptr;
+};
+
 struct sg_scatter_hold {     /* holding area for scsi scatter gather info */
 	struct page **pages;	/* num_sgat element array of struct page* */
 	int buflen;		/* capacity in bytes (dlen<=buflen) */
 	int dlen;		/* current valid data length of this req */
 	u16 page_order;		/* byte_len = (page_size*(2**page_order)) */
 	u16 num_sgat;		/* actual number of scatter-gather segments */
-	unsigned int sglist_len; /* size of malloc'd scatter-gather list ++ */
-	char dio_in_use;	/* 0->indirect IO (or mmap), 1->dio */
-	u8 cmd_opcode;		/* first byte of command */
 };
 
 struct sg_device;		/* forward declarations */
 struct sg_fd;
 
-struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
-	struct sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
-	struct sg_io_hdr header;  /* scsi command+info, see <scsi/sg.h> */
+struct sg_request {	/* active SCSI command or inactive request */
+	struct sg_scatter_hold sgat_h;	/* hold buffer, perhaps scatter list */
+	struct sg_slice_hdr3 s_hdr3;  /* subset of sg_io_hdr */
 	u8 sense_b[SCSI_SENSE_BUFFERSIZE];
 	u32 duration;		/* cmd duration in milliseconds */
+	u32 rq_flags;		/* hold user supplied flags */
 	u32 rq_idx;		/* my index within parent's srp_arr */
-	char res_used;		/* 1 -> using reserve buffer, 0 -> not ... */
-	char orphan;		/* 1 -> drop on sight, 0 -> normal */
+	u32 rq_info;		/* info supplied by v3 and v4 interfaces */
 	u32 rq_result;		/* packed scsi request result from LLD */
-	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
-	/* done protected by rq_list_lock */
-	char done;		/* 0->before bh, 1->before read, 2->read */
+	int in_resid;		/* requested-actual byte count on data-in */
+	int pack_id;		/* user provided packet identifier field */
+	int sense_len;		/* actual sense buffer length (data-in) */
 	atomic_t rq_st;		/* request state, holds a enum sg_rq_state */
-	u64 start_ns;           /* starting point of command duration calc */
-	unsigned long frq_bm[1];        /* see SG_FRQ_* defines above */
-	struct sg_fd *parentfp; /* pointer to owning fd, even when on fl */
+	u8 cmd_opcode;		/* first byte of SCSI cdb */
+	u64 start_ns;		/* starting point of command duration calc */
+	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
+	struct sg_fd *parentfp;	/* pointer to owning fd, even when on fl */
 	struct request *rq;	/* released in sg_rq_end_io(), bio kept */
 	struct bio *bio;	/* kept until this req -->SG_RS_INACTIVE */
 	struct execute_work ew_orph;	/* harvest orphan request */
@@ -182,7 +197,7 @@ struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 struct sg_fd {		/* holds the state of a file descriptor */
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
-	struct mutex f_mutex;	/* protect against changes in this fd */
+	struct mutex f_mutex;	/* serialize ioctls on this fd */
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
 	u32 idx;		/* my index within parent's sfp_arr */
@@ -190,15 +205,12 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	atomic_t waiting;	/* number of requests awaiting receive */
 	atomic_t req_cnt;	/* number of requests */
 	int sgat_elem_sz;	/* initialized to scatter_elem_sz */
-	struct sg_scatter_hold reserve;	/* buffer for this file descriptor */
-	char force_packid;	/* 1 -> pack_id input to read(), 0 -> ignored */
-	char cmd_q;		/* 1 -> allow command queuing, 0 -> don't */
+	unsigned long ffd_bm[1];	/* see SG_FFD_* defines above */
+	pid_t tid;		/* thread id when opened */
 	u8 next_cmd_len;	/* 0: automatic, >0: use on next write() */
-	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
-	char mmap_called;	/* 0 -> mmap() never called on this fd */
-	char res_in_use;	/* 1 -> 'reserve' array in use */
-	struct fasync_struct *async_qp;	/* used by asynchronous notification */
-	struct xarray srp_arr;
+	struct sg_request *rsv_srp;/* one reserve request per fd */
+	struct fasync_struct *async_qp; /* used by asynchronous notification */
+	struct xarray srp_arr;	/* xarray of sg_request object pointers */
 	struct kref f_ref;
 	struct execute_work ew_fd;  /* harvest all fd resources and lists */
 };
@@ -221,8 +233,8 @@ struct sg_device { /* holds the state of each scsi generic device */
 
 struct sg_comm_wr_t {  /* arguments to sg_common_write() */
 	int timeout;
-	int blocking;
-	struct sg_request *srp;
+	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
+	struct sg_io_hdr *h3p;
 	u8 *cmnd;
 };
 
@@ -230,31 +242,32 @@ struct sg_comm_wr_t {  /* arguments to sg_common_write() */
 static void sg_rq_end_io(struct request *rq, blk_status_t status);
 /* Declarations of other static functions used before they are defined */
 static int sg_proc_init(void);
-static int sg_start_req(struct sg_request *srp, u8 *cmd);
+static int sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len,
+			int dxfer_dir);
 static void sg_finish_scsi_blk_rq(struct sg_request *srp);
-static int sg_mk_sgat(struct sg_scatter_hold *schp, struct sg_fd *sfp,
-		      int minlen);
-static ssize_t sg_submit(struct sg_fd *sfp, struct file *filp,
-			 const char __user *buf, size_t count, bool blocking,
-			 bool read_only, bool sg_io_owned,
-			 struct sg_request **o_srp);
-static int sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp);
+static int sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen);
+static int sg_submit(struct file *filp, struct sg_fd *sfp,
+		     struct sg_io_hdr *hp, bool sync,
+		     struct sg_request **o_srp);
+static struct sg_request *sg_common_write(struct sg_fd *sfp,
+					  struct sg_comm_wr_t *cwrp);
 static int sg_read_append(struct sg_request *srp, void __user *outp,
 			  int num_xfer);
-static void sg_remove_sgat(struct sg_fd *sfp, struct sg_scatter_hold *schp);
-static void sg_build_reserve(struct sg_fd *sfp, int req_size);
-static void sg_link_reserve(struct sg_fd *sfp, struct sg_request *srp,
-			    int size);
-static void sg_unlink_reserve(struct sg_fd *sfp, struct sg_request *srp);
+static void sg_remove_sgat(struct sg_request *srp);
 static struct sg_fd *sg_add_sfp(struct sg_device *sdp);
 static void sg_remove_sfp(struct kref *);
 static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int pack_id);
-static struct sg_request *sg_add_request(struct sg_fd *sfp);
+static struct sg_request *sg_add_request(struct sg_fd *sfp, int dxfr_len,
+					 struct sg_comm_wr_t *cwrp);
 static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int dev);
 static void sg_device_destroy(struct kref *kref);
+static struct sg_request *sg_mk_srp_sgat(struct sg_fd *sfp, bool first,
+					 int db_len);
 static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
 
+#define SG_WRITE_COUNT_LIMIT (32 * 1024 * 1024)
+
 #define SZ_SG_HEADER ((int)sizeof(struct sg_header))	/* v1 and v2 header */
 #define SZ_SG_IO_HDR ((int)sizeof(struct sg_io_hdr))	/* v3 header */
 #define SZ_SG_REQ_INFO ((int)sizeof(struct sg_req_info))
@@ -522,6 +535,7 @@ sg_release(struct inode *inode, struct file *filp)
 static ssize_t
 sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 {
+	bool get_v3_hdr;
 	int mxsize, cmd_size, input_size, res;
 	u8 opcode;
 	struct sg_device *sdp;
@@ -544,36 +558,61 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	res = sg_allow_if_err_recovery(sdp, !!(filp->f_flags & O_NONBLOCK));
 	if (res)
 		return res;
-
-	if (count < SZ_SG_HEADER)
+	if (count < SZ_SG_HEADER || count > SG_WRITE_COUNT_LIMIT)
 		return -EIO;
-	if (copy_from_user(ohp, p, SZ_SG_HEADER))
-		return -EFAULT;
-	if (ohp->reply_len < 0) {	/* assume this is v3 */
-		struct sg_io_hdr *reinter_2p = (struct sg_io_hdr *)ohp;
+#ifdef CONFIG_COMPAT
+	if (in_compat_syscall())
+		get_v3_hdr = (count == sizeof(struct compat_sg_io_hdr));
+	else
+		get_v3_hdr = (count == sizeof(struct sg_io_hdr));
+#else
+	get_v3_hdr = (count == sizeof(struct sg_io_hdr));
+#endif
+	if (get_v3_hdr) {
+		if (get_sg_io_hdr(h3p, p))
+			return -EFAULT;
+	} else {
+		if (copy_from_user(ohp, p, SZ_SG_HEADER))
+			return -EFAULT;
+		if (ohp->reply_len < 0) {	/* not v2, may be v3 */
+			bool lt = false;
 
-		if (count < SZ_SG_IO_HDR)
-			return -EIO;
-		if (reinter_2p->interface_id != 'S') {
+#ifdef CONFIG_COMPAT
+			if (in_compat_syscall())
+				lt = (count < sizeof(struct compat_sg_io_hdr));
+			else
+				lt = (count < sizeof(struct sg_io_hdr));
+#else
+			lt = (count < sizeof(struct sg_io_hdr));
+#endif
+			if (lt)
+				return -EIO;
+			get_v3_hdr = true;
+			if (get_sg_io_hdr(h3p, p))
+				return -EFAULT;
+		}
+	}
+	if (get_v3_hdr) {
+		/* v3 dxfer_direction_s are all negative values by design */
+		if (h3p->dxfer_direction >= 0) {	/* so it is not v3 */
+			memcpy(ohp, h3p, count);
+			goto to_v2;
+		}
+		if (h3p->interface_id != 'S') {
 			pr_info_once("sg: %s: v3 interface only here\n",
 				     __func__);
 			return -EPERM;
 		}
-		return sg_submit(sfp, filp, p, count,
-				 !(filp->f_flags & O_NONBLOCK), false, false,
-				 NULL);
+		res = sg_submit(filp, sfp, h3p, false, NULL);
+		return res < 0 ? res : (int)count;
 	}
+to_v2:
+	/* v1 and v2 interfaces processed below this point */
 	if (count < (SZ_SG_HEADER + 6))
-		return -EIO;	/* The minimum scsi command length is 6 bytes. */
-
+		return -EIO;    /* minimum scsi command length is 6 bytes */
 	p += SZ_SG_HEADER;
 	if (get_user(opcode, p))
 		return -EFAULT;
-
-	if (!(srp = sg_add_request(sfp))) {
-		SG_LOG(1, sfp, "%s: queue full\n", __func__);
-		return -EDOM;
-	}
 	mutex_lock(&sfp->f_mutex);
 	if (sfp->next_cmd_len > 0) {
 		cmd_size = sfp->next_cmd_len;
@@ -590,12 +629,10 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	mxsize = max_t(int, input_size, ohp->reply_len);
 	mxsize -= SZ_SG_HEADER;
 	input_size -= SZ_SG_HEADER;
-	if (input_size < 0) {
-		sg_deact_request(sfp, srp);
-		return -EIO;	/* User did not pass enough bytes for this command. */
-	}
-	h3p = &srp->header;
-	h3p->interface_id = '\0';  /* indicator of old interface tunnelled */
+	if (input_size < 0)
+		return -EIO; /* Insufficient bytes passed for this command. */
+	memset(h3p, 0, sizeof(*h3p));
+	h3p->interface_id = '\0';/* indicate v1 or v2 interface (tunnelled) */
 	h3p->cmd_len = (u8)cmd_size;
 	h3p->iovec_count = 0;
 	h3p->mx_sb_len = 0;
@@ -616,7 +653,8 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	h3p->flags = input_size;	/* structure abuse ... */
 	h3p->pack_id = ohp->pack_id;
 	h3p->usr_ptr = NULL;
-	if (copy_from_user(cmnd, p, cmd_size))
+	cmnd[0] = opcode;
+	if (copy_from_user(cmnd + 1, p + 1, cmd_size - 1))
 		return -EFAULT;
 	/*
 	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
@@ -631,23 +669,23 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 			 __func__, ohp->reply_len - (int)SZ_SG_HEADER,
 			 input_size, (unsigned int)cmnd[0], current->comm);
 	}
+	cwr.frq_bm[0] = 0;	/* initial state clear for all req flags */
+	cwr.h3p = h3p;
 	cwr.timeout = sfp->timeout;
-	cwr.blocking = !(filp->f_flags & O_NONBLOCK);
-	cwr.srp = srp;
 	cwr.cmnd = cmnd;
-	res = sg_common_write(sfp, &cwr);
-	return (res < 0) ? res : count;
+	srp = sg_common_write(sfp, &cwr);
+	return (IS_ERR(srp)) ? PTR_ERR(srp) : (int)count;
 }
 
 static inline int
 sg_chk_mmap(struct sg_fd *sfp, int rq_flags, int len)
 {
-	if (len > sfp->reserve.buflen)
-		return -ENOMEM;	/* MMAP_IO size must fit in reserve buffer */
+	if (!xa_empty(&sfp->srp_arr))
+		return -EBUSY;  /* already active requests on fd */
+	if (len > sfp->rsv_srp->sgat_h.buflen)
+		return -ENOMEM; /* MMAP_IO size must fit in reserve */
 	if (rq_flags & SG_FLAG_DIRECT_IO)
-		return -EINVAL;	/* either MMAP_IO or DIRECT_IO (not both) */
-	if (sfp->res_in_use)
-		return -EBUSY;	/* reserve buffer already being used */
+		return -EINVAL; /* not both MMAP_IO and DIRECT_IO */
 	return 0;
 }
 
@@ -672,61 +710,40 @@ sg_fetch_cmnd(struct file *filp, struct sg_fd *sfp, const u8 __user *u_cdbp,
 	return 0;
 }
 
-static ssize_t
-sg_submit(struct sg_fd *sfp, struct file *filp, const char __user *buf,
-	  size_t count, bool blocking, bool read_only, bool sg_io_owned,
-	  struct sg_request **o_srp)
+static int
+sg_submit(struct file *filp, struct sg_fd *sfp, struct sg_io_hdr *hp,
+	  bool sync, struct sg_request **o_srp)
 {
-	int k, res, timeout;
+	int res, timeout;
+	unsigned long ul_timeout;
 	struct sg_request *srp;
-	struct sg_io_hdr *hp;
 	struct sg_comm_wr_t cwr;
 	u8 cmnd[SG_MAX_CDB_SIZE];
-	unsigned long ul_timeout;
-
-	if (count < SZ_SG_IO_HDR)
-		return -EINVAL;
 
-	sfp->cmd_q = 1;	/* when sg_io_hdr seen, set command queuing on */
-	if (!(srp = sg_add_request(sfp))) {
-		SG_LOG(1, sfp, "%s: queue full\n", __func__);
-		return -EDOM;
-	}
-	srp->sg_io_owned = sg_io_owned;
-	hp = &srp->header;
-	/* get_sg_io_hdr() is defined in block/scsi_ioctl.c */
-	if (get_sg_io_hdr(hp, buf)) {
-		sg_deact_request(sfp, srp);
-		return -EFAULT;
-	}
-	if (hp->interface_id != 'S') {
-		sg_deact_request(sfp, srp);
-		return -ENOSYS;
-	}
+	/* now doing v3 blocking (sync) or non-blocking submission */
 	if (hp->flags & SG_FLAG_MMAP_IO) {
 		res = sg_chk_mmap(sfp, hp->flags, hp->dxfer_len);
-		if (res) {
-			sg_deact_request(sfp, srp);
+		if (res)
 			return res;
-		}
 	}
-	ul_timeout = msecs_to_jiffies(srp->header.timeout);
-	timeout = (ul_timeout < INT_MAX) ? ul_timeout : INT_MAX;
+	/* when v3 seen, allow cmd_q on this fd (def: no cmd_q) */
+	set_bit(SG_FFD_CMD_Q, sfp->ffd_bm);
+	ul_timeout = msecs_to_jiffies(hp->timeout);
+	timeout = min_t(unsigned long, ul_timeout, INT_MAX);
 	res = sg_fetch_cmnd(filp, sfp, hp->cmdp, hp->cmd_len, cmnd);
-	if (res) {
-		sg_deact_request(sfp, srp);
+	if (res)
 		return res;
-	}
+	cwr.frq_bm[0] = 0;
+	__assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)sync);
+	cwr.h3p = hp;
 	cwr.timeout = timeout;
-	cwr.blocking = blocking;
-	cwr.srp = srp;
 	cwr.cmnd = cmnd;
-	k = sg_common_write(sfp, &cwr);
-	if (k < 0)
-		return k;
+	srp = sg_common_write(sfp, &cwr);
+	if (IS_ERR(srp))
+		return PTR_ERR(srp);
 	if (o_srp)
-		*o_srp = cwr.srp;
-	return count;
+		*o_srp = srp;
+	return 0;
 }
 
 #if IS_ENABLED(SG_LOG_ACTIVE)
@@ -848,73 +865,79 @@ sg_rq_state_chg(struct sg_request *srp, enum sg_rq_state old_st,
  * sg_request object holding the request just issued or a negated errno
  * value twisted by ERR_PTR.
  */
-static int
+static struct sg_request *
 sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 {
 	bool at_head;
-	int k;
+	int res = 0;
+	int dxfr_len, dir, cmd_len;
+	int pack_id = SG_PACK_ID_WILDCARD;
+	u32 rq_flags;
 	struct sg_device *sdp = sfp->parentdp;
-	struct sg_request *srp = cwrp->srp;
-	struct sg_io_hdr *hp = &srp->header;
-
-	srp->data.cmd_opcode = cwrp->cmnd[0];	/* hold opcode of command */
-	hp->status = 0;
-	hp->masked_status = 0;
-	hp->msg_status = 0;
-	hp->info = 0;
-	hp->host_status = 0;
-	hp->driver_status = 0;
-	hp->resid = 0;
-	SG_LOG(4, sfp, "%s:  opcode=0x%02x, cmd_sz=%d\n", __func__,
-	       (int)cwrp->cmnd[0], hp->cmd_len);
-
-	if (hp->dxfer_len >= SZ_256M)
-		return -EINVAL;
-
-	k = sg_start_req(srp, cwrp->cmnd);
-	if (k) {
-		SG_LOG(1, sfp, "%s: start_req err=%d\n", __func__, k);
-		sg_finish_scsi_blk_rq(srp);
-		sg_deact_request(sfp, srp);
-		return k;	/* probably out of space --> ENOMEM */
+	struct sg_request *srp;
+	struct sg_io_hdr *hi_p;
+
+	hi_p = cwrp->h3p;
+	dir = hi_p->dxfer_direction;
+	dxfr_len = hi_p->dxfer_len;
+	rq_flags = hi_p->flags;
+	pack_id = hi_p->pack_id;
+	if (dxfr_len >= SZ_256M)
+		return ERR_PTR(-EINVAL);
+
+	srp = sg_add_request(sfp, dxfr_len, cwrp);
+	if (IS_ERR(srp))
+		return srp;
+	srp->rq_flags = rq_flags;
+	srp->pack_id = pack_id;
+
+	cmd_len = hi_p->cmd_len;
+	memcpy(&srp->s_hdr3, hi_p, sizeof(srp->s_hdr3));
+	srp->cmd_opcode = cwrp->cmnd[0];/* hold opcode of command for debug */
+	SG_LOG(4, sfp, "%s: opcode=0x%02x, cdb_sz=%d, pack_id=%d\n", __func__,
+	       (int)cwrp->cmnd[0], cmd_len, pack_id);
+
+	res = sg_start_req(srp, cwrp->cmnd, cmd_len, dir);
+	if (res < 0)		/* probably out of space --> -ENOMEM */
+		goto err_out;
+	if (unlikely(SG_IS_DETACHING(sdp))) {
+		res = -ENODEV;
+		goto err_out;
 	}
-	if (SG_IS_DETACHING(sdp))
+	if (unlikely(test_bit(SG_FRQ_BLK_PUT_REQ, srp->frq_bm) || !srp->rq)) {
+		res = -EIDRM;	/* this failure unexpected but observed */
 		goto err_out;
-
-	hp->duration = jiffies_to_msecs(jiffies);
-	if (hp->interface_id != '\0' &&	/* v3 (or later) interface */
-	    (SG_FLAG_Q_AT_TAIL & hp->flags))
-		at_head = false;
-	else
-		at_head = true;
-
-	if (!xa_get_mark(&sfp->srp_arr, srp->rq_idx, SG_XA_RQ_FREE)) {
+	}
+	if (xa_get_mark(&sfp->srp_arr, srp->rq_idx, SG_XA_RQ_FREE)) {
 		SG_LOG(1, sfp, "%s: ahhh, request erased!!!\n", __func__);
+		res = -ENODEV;
 		goto err_out;
 	}
-	if (!srp->sg_io_owned)
-		atomic_inc(&sfp->submitted);
 	srp->rq->timeout = cwrp->timeout;
 	kref_get(&sfp->f_ref); /* sg_rq_end_io() does kref_put(). */
+	res = sg_rq_state_chg(srp, SG_RS_BUSY, SG_RS_INFLIGHT, false,
+			      __func__);
+	if (res)
+		goto err_out;
+	srp->start_ns = ktime_get_boottime_ns();
+	srp->duration = 0;
+
+	if (srp->s_hdr3.interface_id == '\0')
+		at_head = true; /* backward compatibility: v1+v2 interfaces */
+	else if (test_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm))
+	/* cmd flags can override sfd setting */
+		at_head = !!(srp->rq_flags & SG_FLAG_Q_AT_HEAD);
+	else            /* this sfd is defaulting to head */
+		at_head = !(srp->rq_flags & SG_FLAG_Q_AT_TAIL);
+	if (!test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm))
+		atomic_inc(&sfp->submitted);
 	blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
 			      srp->rq, at_head, sg_rq_end_io);
-	return 0;
+	return srp;
 err_out:
-	if (srp->bio) {
-		scsi_req_free_cmd(scsi_req(srp->rq));
-		blk_put_request(srp->rq);
-		srp->rq = NULL;
-	}
 	sg_finish_scsi_blk_rq(srp);
 	sg_deact_request(sfp, srp);
-	return -ENODEV;
-}
-
-static inline int
-sg_rstate_chg(struct sg_request *srp, enum sg_rq_state old_st,
-	      enum sg_rq_state new_st)
-{
-	return sg_rq_state_chg(srp, old_st, new_st, false, __func__);
+	return ERR_PTR(res);
 }
 
 /*
@@ -945,21 +968,26 @@ static int
 sg_copy_sense(struct sg_request *srp)
 {
 	int sb_len_ret = 0;
-	struct sg_io_hdr *hp = &srp->header;
+	int scsi_stat;
 
 	/* If need be, copy the sense buffer to the user space */
-	if ((CHECK_CONDITION & hp->masked_status) ||
-	    (DRIVER_SENSE & hp->driver_status)) {
-		int sb_len = SCSI_SENSE_BUFFERSIZE;
-		void __user *up = hp->sbp;
-
-		sb_len = min_t(int, hp->mx_sb_len, sb_len);
-		/* Additional sense length field */
-		sb_len_ret = 8 + (int)srp->sense_b[7];
-		sb_len_ret = min_t(int, sb_len_ret, sb_len);
-		if (copy_to_user(up, srp->sense_b, sb_len_ret))
-			return -EFAULT;
-		hp->sb_len_wr = sb_len_ret;
+	scsi_stat = srp->rq_result & 0xff;
+	if ((scsi_stat & SAM_STAT_CHECK_CONDITION) ||
+	    (driver_byte(srp->rq_result) & DRIVER_SENSE)) {
+		int sb_len = min_t(int, SCSI_SENSE_BUFFERSIZE, srp->sense_len);
+		int mx_sb_len = srp->s_hdr3.mx_sb_len;
+		void __user *up = srp->s_hdr3.sbp;
+
+		if (up && mx_sb_len > 0) {
+			sb_len = min_t(int, mx_sb_len, sb_len);
+			/* Additional sense length field */
+			sb_len_ret = 8 + (int)srp->sense_b[7];
+			sb_len_ret = min_t(int, sb_len_ret, sb_len);
+			if (copy_to_user(up, srp->sense_b, sb_len_ret))
+				sb_len_ret = -EFAULT;
+		} else {
+			sb_len_ret = 0;
+		}
 	}
 	return sb_len_ret;
 }
@@ -968,12 +996,15 @@ static int
 sg_rec_state_v3(struct sg_fd *sfp, struct sg_request *srp)
 {
 	int sb_len_wr;
+	u32 rq_res = srp->rq_result;
 
 	sb_len_wr = sg_copy_sense(srp);
 	if (sb_len_wr < 0)
 		return sb_len_wr;
+	if (rq_res & SG_ML_RESULT_MSK)
+		srp->rq_info |= SG_INFO_CHECK;
 	if (unlikely(SG_IS_DETACHING(sfp->parentdp)))
-		return -ENODEV;
+		srp->rq_info |= SG_INFO_DEVICE_DETACHING;
 	return 0;
 }
 
@@ -981,8 +1012,10 @@ static ssize_t
 sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, size_t count,
 	      void __user *p)
 {
-	int err = 0;
-	struct sg_io_hdr *hp = &srp->header;
+	int err, err2;
+	int rq_result = srp->rq_result;
+	struct sg_io_hdr hdr3;
+	struct sg_io_hdr *hp = &hdr3;
 
 	if (in_compat_syscall()) {
 		if (count < sizeof(struct compat_sg_io_hdr)) {
@@ -995,9 +1028,23 @@ sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, size_t count,
 	}
 	SG_LOG(3, sfp, "%s: srp=0x%pK\n", __func__, srp);
 	err = sg_rec_state_v3(sfp, srp);
-	if (hp->masked_status || hp->host_status || hp->driver_status)
-		hp->info |= SG_INFO_CHECK;
-	err = put_sg_io_hdr(hp, p);
+	memset(hp, 0, sizeof(*hp));
+	memcpy(hp, &srp->s_hdr3, sizeof(srp->s_hdr3));
+	hp->sb_len_wr = srp->sense_len;
+	hp->info = srp->rq_info;
+	hp->resid = srp->in_resid;
+	hp->duration = srp->duration;
+	hp->status = rq_result & 0xff;
+	hp->masked_status = status_byte(rq_result);
+	hp->msg_status = msg_byte(rq_result);
+	hp->host_status = host_byte(rq_result);
+	hp->driver_status = driver_byte(rq_result);
+	err2 = put_sg_io_hdr(hp, p);
+	err = err ? err : err2;
+	err2 = sg_rq_state_chg(srp, atomic_read(&srp->rq_st), SG_RS_RCV_DONE,
+			       false, __func__);
+	if (err2)
+		err = err ? err : err2;
 err_out:
 	sg_finish_scsi_blk_rq(srp);
 	sg_deact_request(sfp, srp);
@@ -1014,26 +1061,27 @@ sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 	     struct sg_request *srp)
 {
 	int res = 0;
-	struct sg_io_hdr *sh3p = &srp->header;
+	u32 rq_result = srp->rq_result;
 	struct sg_header *h2p;
+	struct sg_slice_hdr3 *sh3p;
 	struct sg_header a_v2hdr;
 
 	h2p = &a_v2hdr;
 	memset(h2p, 0, SZ_SG_HEADER);
+	sh3p = &srp->s_hdr3;
 	h2p->reply_len = (int)sh3p->timeout;
 	h2p->pack_len = h2p->reply_len; /* old, strange behaviour */
 	h2p->pack_id = sh3p->pack_id;
-	h2p->twelve_byte = (srp->data.cmd_opcode >= 0xc0 &&
-			    sh3p->cmd_len == 12);
-	h2p->target_status = sh3p->masked_status;
-	h2p->host_status = sh3p->host_status;
-	h2p->driver_status = sh3p->driver_status;
-	if ((CHECK_CONDITION & h2p->target_status) ||
-	    (DRIVER_SENSE & sh3p->driver_status)) {
+	h2p->twelve_byte = (srp->cmd_opcode >= 0xc0 && sh3p->cmd_len == 12);
+	h2p->target_status = status_byte(rq_result);
+	h2p->host_status = host_byte(rq_result);
+	h2p->driver_status = driver_byte(rq_result);
+	if ((CHECK_CONDITION & status_byte(rq_result)) ||
+	    (DRIVER_SENSE & driver_byte(rq_result))) {
 		memcpy(h2p->sense_buffer, srp->sense_b,
 		       sizeof(h2p->sense_buffer));
 	}
-	switch (h2p->host_status) {
+	switch (host_byte(rq_result)) {
 	/*
 	 * This following setting of 'result' is for backward compatibility
 	 * and is best ignored by the user who should use target, host and
@@ -1057,7 +1105,7 @@ sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 		h2p->result = EIO;
 		break;
 	case DID_ERROR:
-		h2p->result = (h2p->target_status == GOOD) ? 0 : EIO;
+		h2p->result = (status_byte(rq_result) == GOOD) ? 0 : EIO;
 		break;
 	default:
 		h2p->result = EIO;
@@ -1078,6 +1126,7 @@ sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 	} else {
 		res = (h2p->result == 0) ? 0 : -EIO;
 	}
+	atomic_set(&srp->rq_st, SG_RS_RCV_DONE);
 	sg_finish_scsi_blk_rq(srp);
 	sg_deact_request(sfp, srp);
 	return res;
@@ -1121,13 +1170,13 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 	hlen = could_be_v3 ? SZ_SG_IO_HDR : SZ_SG_HEADER;
 	h2p = (struct sg_header *)&a_sg_io_hdr;
 
-	if (sfp->force_packid && count >= hlen) {
+	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm) && (int)count >= hlen) {
 		/*
 		 * Even though this is a user space read() system call, this
 		 * code is cheating to fetch the pack_id.
 		 * Only need first three 32 bit ints to determine interface.
 		 */
-		if (unlikely(copy_from_user(h2p, p, 3 * sizeof(int))))
+		if (copy_from_user(h2p, p, 3 * sizeof(int)))
 			return -EFAULT;
 		if (h2p->reply_len < 0 && could_be_v3) {
 			struct sg_io_hdr *v3_hdr = (struct sg_io_hdr *)h2p;
@@ -1148,20 +1197,20 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 	}
 	srp = sg_find_srp_by_id(sfp, want_id);
 	if (!srp) {	/* nothing available so wait on packet to arrive or */
-		if (SG_IS_DETACHING(sdp))
+		if (unlikely(SG_IS_DETACHING(sdp)))
 			return -ENODEV;
 		if (non_block) /* O_NONBLOCK or v3::flags & SGV4_FLAG_IMMED */
 			return -EAGAIN;
 		ret = wait_event_interruptible(sfp->read_wait,
 					       sg_get_ready_srp(sfp, &srp,
 								want_id));
-		if (SG_IS_DETACHING(sdp))
+		if (unlikely(SG_IS_DETACHING(sdp)))
 			return -ENODEV;
 		if (ret)	/* -ERESTARTSYS as signal hit process */
 			return ret;
 		/* otherwise srp should be valid */
 	}
-	if (srp->header.interface_id == '\0')
+	if (srp->s_hdr3.interface_id == '\0')
 		ret = sg_read_v1v2(p, (int)count, sfp, srp);
 	else
 		ret = sg_receive_v3(sfp, srp, count, p);
@@ -1263,34 +1312,63 @@ static void
 sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp,
 			struct sg_req_info *rip)
 {
-	unsigned int ms;
+	unsigned long iflags;
 
-	rip->req_state = srp->done + 1;
-	rip->problem = srp->header.masked_status &
-		       srp->header.host_status &
-		       srp->header.driver_status;
-	rip->duration = sg_get_dur(srp, NULL, NULL); /* dummy */
-	if (srp->done) {
-		rip->duration = srp->header.duration;
-	} else {
-		ms = jiffies_to_msecs(jiffies);
-		rip->duration = (ms > srp->header.duration) ?
-				(ms - srp->header.duration) : 0;
-	}
-	rip->orphan = srp->orphan;
-	rip->sg_io_owned = srp->sg_io_owned;
-	rip->pack_id = srp->header.pack_id;
-	rip->usr_ptr = srp->header.usr_ptr;
+	xa_lock_irqsave(&sfp->srp_arr, iflags);
+	rip->duration = sg_get_dur(srp, NULL, NULL);
+	if (rip->duration == U32_MAX)
+		rip->duration = 0;
+	rip->orphan = test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
+	rip->sg_io_owned = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
+	rip->problem = !!(srp->rq_result & SG_ML_RESULT_MSK);
+	rip->pack_id = srp->pack_id;
+	rip->usr_ptr = srp->s_hdr3.usr_ptr;
+	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
+}
 
+static inline bool
+sg_rq_landed(struct sg_device *sdp, struct sg_request *srp)
+{
+	return atomic_read(&srp->rq_st) != SG_RS_INFLIGHT ||
+	       unlikely(SG_IS_DETACHING(sdp));
 }
 
+/*
+ * This is a blocking wait for a specific srp. When h4p is non-NULL, it is
+ * the blocking multiple request case
+ */
 static int
-srp_done(struct sg_fd *sfp, struct sg_request *srp)
+sg_wait_event_srp(struct file *filp, struct sg_fd *sfp, void __user *p,
+		  struct sg_request *srp)
 {
-	int ret;
+	int res;
+	enum sg_rq_state sr_st;
+	struct sg_device *sdp = sfp->parentdp;
 
-	ret = srp->done;
-	return ret;
+	SG_LOG(3, sfp, "%s: about to wait_event...()\n", __func__);
+	/* usually will be woken up by sg_rq_end_io() callback */
+	res = wait_event_interruptible(sfp->read_wait,
+				       sg_rq_landed(sdp, srp));
+	if (unlikely(res)) { /* -ERESTARTSYS because signal hit thread */
+		set_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
+		/* orphans harvested when sfp->keep_orphan is false */
+		atomic_set(&srp->rq_st, SG_RS_INFLIGHT);
+		SG_LOG(1, sfp, "%s:  wait_event_interruptible gave %d\n",
+		       __func__, res);
+		return res;
+	}
+	if (unlikely(SG_IS_DETACHING(sdp))) {
+		atomic_set(&srp->rq_st, SG_RS_INACTIVE);
+		return -ENODEV;
+	}
+	sr_st = atomic_read(&srp->rq_st);
+	if (unlikely(sr_st != SG_RS_AWAIT_RCV))
+		return -EPROTO;         /* Logic error */
+	res = sg_rq_state_chg(srp, sr_st, SG_RS_BUSY, false, __func__);
+	if (unlikely(res))
+		return res;
+	res = sg_receive_v3(sfp, srp, SZ_SG_IO_HDR, p);
+	return (res < 0) ? res : 0;
 }
 
 /*
@@ -1301,42 +1379,118 @@ static int
 sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	     void __user *p)
 {
-	bool read_only = O_RDWR != (filp->f_flags & O_ACCMODE);
 	int res;
-	struct sg_request *srp;
+	struct sg_request *srp = NULL;
+	u8 hu8arr[SZ_SG_IO_HDR];
+	struct sg_io_hdr *h3p = (struct sg_io_hdr *)hu8arr;
 
+	SG_LOG(3, sfp, "%s:  SG_IO%s\n", __func__,
+	       ((filp->f_flags & O_NONBLOCK) ? " O_NONBLOCK ignored" : ""));
 	res = sg_allow_if_err_recovery(sdp, false);
 	if (res)
 		return res;
-	res = sg_submit(sfp, filp, p, SZ_SG_IO_HDR, true, read_only,
-			true, &srp);
-	if (res < 0)
+	if (get_sg_io_hdr(h3p, p))
+		return -EFAULT;
+	if (h3p->interface_id == 'S')
+		res = sg_submit(filp, sfp, h3p, true, &srp);
+	else
+		return -EPERM;
+	if (unlikely(res < 0))
 		return res;
-	res = wait_event_interruptible
-		(sfp->read_wait, (srp_done(sfp, srp) || SG_IS_DETACHING(sdp)));
-	if (SG_IS_DETACHING(sdp))
-		return -ENODEV;
-	if (srp->done) {
-		srp->done = 2;
-		res = sg_receive_v3(sfp, srp, SZ_SG_IO_HDR, p);
-		return (res < 0) ? res : 0;
-	}
-	srp->orphan = 1;
+	if (!srp)	/* mrq case: already processed all responses */
+		return res;
+	res = sg_wait_event_srp(filp, sfp, p, srp);
+	if (res)
+		SG_LOG(1, sfp, "%s: %s=0x%pK  state: %s\n", __func__,
+		       "unexpected srp", srp,
+		       sg_rq_st_str(atomic_read(&srp->rq_st), false));
 	return res;
 }
 
+/*
+ * First normalize want_rsv_sz to be >= sfp->sgat_elem_sz and
+ * <= max_segment_size. Exit if that is the same as old size; otherwise
+ * create a new candidate request of the new size. Then decide whether to
+ * re-use an existing free list request (least buflen >= required size) or
+ * use the new candidate. If new one used, leave old one but it is no longer
+ * the reserved request. Returns 0 on success, else a negated errno value.
+ */
 static int
 sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 {
-	if (want_rsv_sz != sfp->reserve.buflen) {
-		if (sfp->mmap_called ||
-		    sfp->res_in_use) {
-			return -EBUSY;
+	bool use_new_srp = false;
+	int res = 0;
+	int new_sz, blen;
+	unsigned long idx, iflags;
+	struct sg_request *o_srp;       /* prior reserve sg_request */
+	struct sg_request *n_srp;       /* new sg_request, may be used */
+	struct sg_request *t_srp;       /* other fl entries */
+	struct sg_device *sdp = sfp->parentdp;
+	struct xarray *xafp = &sfp->srp_arr;
+
+	o_srp = sfp->rsv_srp;
+	if (!o_srp)
+		return -EPROTO;
+	new_sz = min_t(int, want_rsv_sz, sdp->max_sgat_sz);
+	new_sz = max_t(int, new_sz, sfp->sgat_elem_sz);
+	blen = o_srp->sgat_h.buflen;
+	SG_LOG(3, sfp, "%s: was=%d, ask=%d, new=%d (sgat_elem_sz=%d)\n",
+	       __func__, blen, want_rsv_sz, new_sz, sfp->sgat_elem_sz);
+	if (blen == new_sz)
+		return 0;
+	n_srp = sg_mk_srp_sgat(sfp, true /* can take time */, new_sz);
+	if (IS_ERR(n_srp))
+		return PTR_ERR(n_srp);
+	/* new sg_request object, sized correctly is now available */
+try_again:
+	o_srp = sfp->rsv_srp;
+	if (!o_srp) {
+		res = -EPROTO;
+		goto fini;
+	}
+	if (SG_RS_ACTIVE(o_srp) ||
+	    test_bit(SG_FFD_MMAP_CALLED, sfp->ffd_bm)) {
+		res = -EBUSY;
+		goto fini;
+	}
+	use_new_srp = true;
+	xa_for_each(xafp, idx, t_srp) {
+		if (t_srp != o_srp && new_sz <= t_srp->sgat_h.buflen &&
+		    !SG_RS_ACTIVE(t_srp)) {
+			/* good candidate on free list, use */
+			use_new_srp = false;
+			sfp->rsv_srp = t_srp;
+			break;
 		}
-		sg_remove_sgat(sfp, &sfp->reserve);
-		sg_build_reserve(sfp, want_rsv_sz);
 	}
-	return 0;
+	if (use_new_srp) {
+		struct sg_request *cxc_srp;
+
+		xa_lock_irqsave(xafp, iflags);
+		n_srp->rq_idx = o_srp->rq_idx;
+		idx = o_srp->rq_idx;
+		cxc_srp = __xa_cmpxchg(xafp, idx, o_srp, n_srp, GFP_ATOMIC);
+		if (o_srp == cxc_srp) {
+			sfp->rsv_srp = n_srp;
+			__xa_set_mark(xafp, idx, SG_XA_RQ_INACTIVE);
+			xa_unlock_irqrestore(xafp, iflags);
+			SG_LOG(6, sfp, "%s: new rsv srp=0x%pK ++\n", __func__,
+			       n_srp);
+			sg_remove_sgat(o_srp);
+			kfree(o_srp);
+		} else {
+			xa_unlock_irqrestore(xafp, iflags);
+			SG_LOG(1, sfp, "%s: xa_cmpxchg() failed, again\n",
+			       __func__);
+			goto try_again;
+		}
+	}
+fini:
+	if (!use_new_srp) {
+		sg_remove_sgat(n_srp);
+		kfree(n_srp);   /* no-one else has seen n_srp, so safe */
+	}
+	return res;
 }
 
 #ifdef CONFIG_COMPAT
@@ -1366,26 +1520,43 @@ static int put_compat_request_table(struct compat_sg_req_info __user *o,
 }
 #endif
 
+/*
+ * For backward compatibility, output SG_MAX_QUEUE sg_req_info objects. First
+ * fetch from the active list then, if there is still room, from the free
+ * list. Some of the trailing elements may be empty which is indicated by all
+ * fields being zero. Any requests beyond SG_MAX_QUEUE are ignored.
+ */
 static int
 sg_ctl_req_tbl(struct sg_fd *sfp, void __user *p)
 {
-	int result, val;
+	int k, result, val;
 	unsigned long idx;
 	struct sg_request *srp;
-	sg_req_info_t *rinfop;
+	struct sg_req_info *rinfop;
 
-	rinfop = kcalloc(SG_MAX_QUEUE, SZ_SG_REQ_INFO,
-			 GFP_KERNEL);
+	SG_LOG(3, sfp, "%s:    SG_GET_REQUEST_TABLE\n", __func__);
+	k = SG_MAX_QUEUE;
+	rinfop = kcalloc(k, SZ_SG_REQ_INFO, GFP_KERNEL);
 	if (!rinfop)
 		return -ENOMEM;
 	val = 0;
 	xa_for_each(&sfp->srp_arr, idx, srp) {
 		if (!srp)
 			continue;
-		if (xa_get_mark(&sfp->srp_arr, idx, SG_XA_RQ_AWAIT))
+		if (val >= SG_MAX_QUEUE)
+			break;
+		if (xa_get_mark(&sfp->srp_arr, idx, SG_XA_RQ_INACTIVE))
+			continue;
+		sg_fill_request_element(sfp, srp, rinfop + val);
+		val++;
+	}
+	xa_for_each(&sfp->srp_arr, idx, srp) {
+		if (!srp)
 			continue;
 		if (val >= SG_MAX_QUEUE)
 			break;
+		if (!xa_get_mark(&sfp->srp_arr, idx, SG_XA_RQ_INACTIVE))
+			continue;
 		sg_fill_request_element(sfp, srp, rinfop + val);
 		val++;
 	}
@@ -1452,18 +1623,15 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		result = get_user(val, ip);
 		if (result)
 			return result;
-		sfp->force_packid = val ? 1 : 0;
+		assign_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm, !!val);
 		return 0;
 	case SG_GET_PACK_ID:    /* or tag of oldest "read"-able, -1 if none */
 		val = -1;
-		srp = NULL;
 		xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
 			if (!srp)
 				continue;
-			if ((1 == srp->done) && (!srp->sg_io_owned)) {
-				val = srp->header.pack_id;
-				break;
-			}
+			val = srp->pack_id;
+			break;
 		}
 		SG_LOG(3, sfp, "%s:    SG_GET_PACK_ID=%d\n", __func__, val);
 		return put_user(val, ip);
@@ -1474,44 +1642,48 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		       sdp->max_sgat_sz);
 		return put_user(sdp->max_sgat_sz, ip);
 	case SG_SET_RESERVED_SIZE:
-		mutex_lock(&sfp->f_mutex);
 		result = get_user(val, ip);
 		if (!result) {
 			if (val >= 0 && val <= (1024 * 1024 * 1024)) {
+				mutex_lock(&sfp->f_mutex);
 				result = sg_set_reserved_sz(sfp, val);
+				mutex_unlock(&sfp->f_mutex);
 			} else {
 				SG_LOG(3, sfp, "%s: invalid size\n", __func__);
 				result = -EINVAL;
 			}
 		}
-		mutex_unlock(&sfp->f_mutex);
 		return result;
 	case SG_GET_RESERVED_SIZE:
-		val = min_t(int, sfp->reserve.buflen,
-			    max_sectors_bytes(sdev->request_queue));
+		mutex_lock(&sfp->f_mutex);
+		val = min_t(int, sfp->rsv_srp->sgat_h.buflen,
+			    sdp->max_sgat_sz);
+		mutex_unlock(&sfp->f_mutex);
 		SG_LOG(3, sfp, "%s:    SG_GET_RESERVED_SIZE=%d\n",
 		       __func__, val);
-		return put_user(val, ip);
+		result = put_user(val, ip);
+		return result;
 	case SG_SET_COMMAND_Q:
 		SG_LOG(3, sfp, "%s:    SG_SET_COMMAND_Q\n", __func__);
 		result = get_user(val, ip);
 		if (result)
 			return result;
-		sfp->cmd_q = val ? 1 : 0;
+		assign_bit(SG_FFD_CMD_Q, sfp->ffd_bm, !!val);
 		return 0;
 	case SG_GET_COMMAND_Q:
 		SG_LOG(3, sfp, "%s:    SG_GET_COMMAND_Q\n", __func__);
-		return put_user((int) sfp->cmd_q, ip);
+		return put_user(test_bit(SG_FFD_CMD_Q, sfp->ffd_bm), ip);
 	case SG_SET_KEEP_ORPHAN:
 		SG_LOG(3, sfp, "%s:    SG_SET_KEEP_ORPHAN\n", __func__);
 		result = get_user(val, ip);
 		if (result)
 			return result;
-		sfp->keep_orphan = val;
+		assign_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm, !!val);
 		return 0;
 	case SG_GET_KEEP_ORPHAN:
 		SG_LOG(3, sfp, "%s:    SG_GET_KEEP_ORPHAN\n", __func__);
-		return put_user((int) sfp->keep_orphan, ip);
+		return put_user(test_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm),
+				ip);
 	case SG_GET_VERSION_NUM:
 		SG_LOG(3, sfp, "%s:    SG_GET_VERSION_NUM\n", __func__);
 		return put_user(sg_version_num, ip);
@@ -1566,6 +1738,8 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		return put_user(val, ip);
 	case SG_EMULATED_HOST:
 		SG_LOG(3, sfp, "%s:    SG_EMULATED_HOST\n", __func__);
+		if (unlikely(SG_IS_DETACHING(sdp)))
+			return -ENODEV;
 		return put_user(sdev->host->hostt->emulated, ip);
 	case SCSI_IOCTL_SEND_COMMAND:
 		SG_LOG(3, sfp, "%s:    SCSI_IOCTL_SEND_COMMAND\n", __func__);
@@ -1576,7 +1750,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		result = get_user(val, ip);
 		if (result)
 			return result;
-		assign_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm, val);
+		assign_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm, !!val);
 		if (val == 0)	/* user can force recalculation */
 			sg_calc_sgat_param(sdp);
 		return 0;
@@ -1621,7 +1795,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		break;
 	}
 	result = sg_allow_if_err_recovery(sdp, filp->f_flags & O_NDELAY);
-	if (result)
+	if (unlikely(result))
 		return result;
 	return -ENOIOCTLCMD;
 }
@@ -1684,7 +1858,7 @@ sg_poll(struct file *filp, poll_table * wait)
 
 	if (unlikely(SG_IS_DETACHING(sfp->parentdp)))
 		p_res |= EPOLLHUP;
-	else if (likely(sfp->cmd_q))
+	else if (likely(test_bit(SG_FFD_CMD_Q, sfp->ffd_bm)))
 		p_res |= EPOLLOUT | EPOLLWRNORM;
 	else if (atomic_read(&sfp->submitted) == 0)
 		p_res |= EPOLLOUT | EPOLLWRNORM;
@@ -1706,9 +1880,10 @@ static vm_fault_t
 sg_vma_fault(struct vm_fault *vmf)
 {
 	int k, length;
-	unsigned long offset, len, sa;
+	unsigned long offset, len, sa, iflags;
 	struct vm_area_struct *vma = vmf->vma;
 	struct sg_scatter_hold *rsv_schp;
+	struct sg_request *srp;
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
 	const char *nbp = "==NULL, bad";
@@ -1727,12 +1902,18 @@ sg_vma_fault(struct vm_fault *vmf)
 		SG_LOG(1, sfp, "%s: device detaching\n", __func__);
 		goto out_err;
 	}
-	rsv_schp = &sfp->reserve;
+	srp = sfp->rsv_srp;
+	if (!srp) {
+		SG_LOG(1, sfp, "%s: srp%s\n", __func__, nbp);
+		goto out_err;
+	}
+	xa_lock_irqsave(&sfp->srp_arr, iflags);
+	rsv_schp = &srp->sgat_h;
 	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= (unsigned int)rsv_schp->buflen) {
 		SG_LOG(1, sfp, "%s: offset[%lu] >= rsv.buflen\n", __func__,
 		       offset);
-		goto out_err;
+		goto out_err_unlock;
 	}
 	sa = vma->vm_start;
 	SG_LOG(3, sfp, "%s: vm_start=0x%lx, off=%lu\n", __func__, sa, offset);
@@ -1745,6 +1926,7 @@ sg_vma_fault(struct vm_fault *vmf)
 			struct page *pp;
 
 			pp = rsv_schp->pages[k];
+			xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 			page = nth_page(pp, offset >> PAGE_SHIFT);
 			get_page(page); /* increment page count */
 			vmf->page = page;
@@ -1753,6 +1935,8 @@ sg_vma_fault(struct vm_fault *vmf)
 		sa += len;
 		offset -= len;
 	}
+out_err_unlock:
+	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 out_err:
 	return VM_FAULT_SIGBUS;
 }
@@ -1767,9 +1951,10 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	int k, length;
 	int ret = 0;
-	unsigned long req_sz, len, sa;
+	unsigned long req_sz, len, sa, iflags;
 	struct sg_scatter_hold *rsv_schp;
 	struct sg_fd *sfp;
+	struct sg_request *srp;
 
 	if (!filp || !vma)
 		return -ENXIO;
@@ -1785,11 +1970,13 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 		return -EINVAL; /* only an offset of 0 accepted */
 	/* Check reserve request is inactive and has large enough buffer */
 	mutex_lock(&sfp->f_mutex);
-	if (sfp->res_in_use) {
+	srp = sfp->rsv_srp;
+	xa_lock_irqsave(&sfp->srp_arr, iflags);
+	if (SG_RS_ACTIVE(srp)) {
 		ret = -EBUSY;
 		goto out;
 	}
-	rsv_schp = &sfp->reserve;
+	rsv_schp = &srp->sgat_h;
 	if (req_sz > (unsigned long)rsv_schp->buflen) {
 		ret = -ENOMEM;
 		goto out;
@@ -1802,15 +1989,23 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 		sa += len;
 	}
 
-	sfp->mmap_called = 1;
+	set_bit(SG_FFD_MMAP_CALLED, sfp->ffd_bm);
 	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data = sfp;
 	vma->vm_ops = &sg_mmap_vm_ops;
 out:
+	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 	mutex_unlock(&sfp->f_mutex);
 	return ret;
 }
 
+/*
+ * This user context function is called from sg_rq_end_io() in 2 situations.
+ * The first case is when a slave was in SWAIT state and sg_rq_end_io() has
+ * just been called on the corresponding master request.
+ * The second case is an orphaned request that needs to be cleaned up (e.g.
+ * when control C is typed while an ioctl(SG_IO) is active).
+ */
 static void
 sg_rq_end_io_usercontext(struct work_struct *work)
 {
@@ -1828,8 +2023,10 @@ sg_rq_end_io_usercontext(struct work_struct *work)
 		return;
 	}
 	SG_LOG(3, sfp, "%s: srp=0x%pK\n", __func__, srp);
-	sg_finish_scsi_blk_rq(srp);
-	sg_deact_request(sfp, srp);
+	if (test_bit(SG_FRQ_DEACT_ORPHAN, srp->frq_bm)) {
+		sg_finish_scsi_blk_rq(srp);	/* clean up orphan case */
+		sg_deact_request(sfp, srp);
+	}
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 }
 
@@ -1867,85 +2064,100 @@ sg_check_sense(struct sg_device *sdp, struct sg_request *srp, int sense_len)
 }
 
 /*
- * This function is a "bottom half" handler that is called by the mid
- * level when a command is completed (or has failed).
+ * This "bottom half" (soft interrupt) handler is called by the mid-level
+ * when a request has completed or failed. This callback is registered in a
+ * blk_execute_rq_nowait() call in the sg_common_write(). For ioctl(SG_IO)
+ * (sync) usage, sg_ctl_sg_io() waits to be woken up by this callback.
  */
 static void
 sg_rq_end_io(struct request *rq, blk_status_t status)
 {
+	enum sg_rq_state rqq_state = SG_RS_AWAIT_RCV;
+	int a_resid, slen;
 	struct sg_request *srp = rq->end_io_data;
 	struct scsi_request *scsi_rp = scsi_req(rq);
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
-	unsigned int ms;
-	int resid, slen;
-	int done = 1;
-	unsigned long iflags;
 
-	if (WARN_ON(srp->done != 0))
+	if (!scsi_rp) {
+		WARN_ONCE("%s: scsi_req(rq) unexpectedly NULL\n", __func__);
 		return;
-
-	sfp = srp->parentfp;
-	if (WARN_ON(sfp == NULL))
+	}
+	if (!srp) {
+		WARN_ONCE("%s: srp unexpectedly NULL\n", __func__);
 		return;
-
+	}
+	/* Expect 0 --> 1 transition, otherwise processed elsewhere */
+	if (unlikely(test_and_set_bit(SG_FRQ_BLK_PUT_REQ, srp->frq_bm))) {
+		pr_info("%s: srp=%pK already completed\n", __func__, srp);
+		return;
+	}
+	if (WARN_ON(atomic_read(&srp->rq_st) != SG_RS_INFLIGHT)) {
+		pr_warn("%s: bad rq_st=%d\n", __func__,
+			atomic_read(&srp->rq_st));
+		goto early_err;
+	}
+	sfp = srp->parentfp;
+	if (unlikely(!sfp)) {
+		WARN_ONCE(1, "%s: sfp unexpectedly NULL", __func__);
+		goto early_err;
+	}
 	sdp = sfp->parentdp;
 	if (unlikely(SG_IS_DETACHING(sdp)))
 		pr_info("%s: device detaching\n", __func__);
 
 	srp->rq_result = scsi_rp->result;
-	resid = scsi_rp->resid_len;
-
-	srp->header.resid = resid;
-
 	slen = min_t(int, scsi_rp->sense_len, SCSI_SENSE_BUFFERSIZE);
+	a_resid = scsi_rp->resid_len;
+
+	if (a_resid)
+		srp->in_resid = a_resid;
 
-	SG_LOG(6, sfp, "%s: pack_id=%d, res=0x%x\n", __func__,
-	       srp->header.pack_id, srp->rq_result);
-	ms = jiffies_to_msecs(jiffies);
-	srp->header.duration = (ms > srp->header.duration) ?
-				(ms - srp->header.duration) : 0;
-	if (srp->rq_result != 0 && slen > 0)
+	SG_LOG(6, sfp, "%s: pack_id=%d, res=0x%x\n", __func__, srp->pack_id,
+	       srp->rq_result);
+	srp->duration = sg_calc_rq_dur(srp);
+	if (unlikely((srp->rq_result & SG_ML_RESULT_MSK) && slen > 0))
 		sg_check_sense(sdp, srp, slen);
 	if (slen > 0)
 		memcpy(srp->sense_b, scsi_rp->sense, slen);
-
-	/* Rely on write phase to clean out srp status values, so no "else" */
-
-	if (!srp->sg_io_owned)
+	srp->sense_len = slen;
+	if (unlikely(test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm))) {
+		if (test_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm)) {
+			clear_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
+		} else {
+			rqq_state = SG_RS_BUSY;
+			set_bit(SG_FRQ_DEACT_ORPHAN, srp->frq_bm);
+		}
+	}
+	if (!test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm))
 		atomic_inc(&sfp->waiting);
+	if (unlikely(sg_rq_state_chg(srp, SG_RS_INFLIGHT, rqq_state,
+				     false, __func__)))
+		pr_warn("%s: can't set rq_st\n", __func__);
 	/*
-	 * Free the request as soon as it is complete so that its resources
-	 * can be reused without waiting for userspace to read() the
-	 * result.  But keep the associated bio (if any) around until
-	 * blk_rq_unmap_user() can be called from user context.
+	 * Free the mid-level resources apart from the bio (if any). The bio's
+	 * blk_rq_unmap_user() can be called later from user context.
 	 */
 	srp->rq = NULL;
-	scsi_req_free_cmd(scsi_req(rq));
+	scsi_req_free_cmd(scsi_rp);
 	blk_put_request(rq);
 
-	if (unlikely(srp->orphan)) {
-		if (sfp->keep_orphan)
-			srp->sg_io_owned = 0;
-		else
-			done = 0;
-	}
-	srp->done = done;
-
-	if (likely(done)) {
-		/* Now wake up any sg_read() that is waiting for this
-		 * packet.
-		 */
-		xa_lock_irqsave(&sfp->srp_arr, iflags);
-		__xa_set_mark(&sfp->srp_arr, srp->rq_idx, SG_XA_RQ_AWAIT);
-		xa_unlock_irqrestore(&sfp->srp_arr, iflags);
+	if (likely(rqq_state == SG_RS_AWAIT_RCV)) {
+		/* Wake any sg_read()/ioctl(SG_IORECEIVE) awaiting this req */
 		wake_up_interruptible(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
 		kref_put(&sfp->f_ref, sg_remove_sfp);
-	} else {
+	} else {        /* clean up orphaned request that aren't being kept */
 		INIT_WORK(&srp->ew_orph.work, sg_rq_end_io_usercontext);
 		schedule_work(&srp->ew_orph.work);
 	}
+	return;
+
+early_err:
+	srp->rq = NULL;
+	if (scsi_rp)
+		scsi_req_free_cmd(scsi_rp);
+	blk_put_request(rq);
 }
 
 static const struct file_operations sg_fops = {
@@ -1973,9 +2185,9 @@ static struct sg_device *
 sg_add_device_helper(struct gendisk *disk, struct scsi_device *scsidp)
 {
 	struct sg_device *sdp;
-	unsigned long iflags;
 	int error;
 	u32 k;
+	unsigned long iflags;
 
 	sdp = kzalloc(sizeof(*sdp), GFP_KERNEL);
 	if (!sdp)
@@ -1993,7 +2205,7 @@ sg_add_device_helper(struct gendisk *disk, struct scsi_device *scsidp)
 			error = -ENODEV;
 		} else {
 			sdev_printk(KERN_WARNING, scsidp,
-				    "%s: idr alloc sg_device failure: %d\n",
+				"%s: idr allocation sg_device failure: %d\n",
 				    __func__, error);
 		}
 		goto out_unlock;
@@ -2195,6 +2407,7 @@ init_sg(void)
 				    SG_MAX_DEVS, "sg");
 	if (rc)
 		return rc;
+
 	pr_info("Registered %s[char major=0x%x], version: %s, date: %s\n",
 		"sg device ", SCSI_GENERIC_MAJOR, SG_VERSION_STR,
 		sg_version_date);
@@ -2210,6 +2423,7 @@ init_sg(void)
 		return 0;
 	}
 	class_destroy(sg_sysfs_class);
+
 err_out_unreg:
 	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), SG_MAX_DEVS);
 	return rc;
@@ -2236,6 +2450,19 @@ exit_sg(void)
 	idr_destroy(&sg_index_idr);
 }
 
+static inline bool
+sg_chk_dio_allowed(struct sg_device *sdp, struct sg_request *srp,
+		   int iov_count, int dir)
+{
+	if (sg_allow_dio && (srp->rq_flags & SG_FLAG_DIRECT_IO)) {
+		if (dir != SG_DXFER_UNKNOWN && !iov_count) {
+			if (!sdp->device->host->unchecked_isa_dma)
+				return true;
+		}
+	}
+	return false;
+}
+
 static void
 sg_set_map_data(const struct sg_scatter_hold *schp, bool up_valid,
 		struct rq_map_data *mdp)
@@ -2249,31 +2476,40 @@ sg_set_map_data(const struct sg_scatter_hold *schp, bool up_valid,
 }
 
 static int
-sg_start_req(struct sg_request *srp, u8 *cmd)
+sg_start_req(struct sg_request *srp, u8 *cmd, int cmd_len, int dxfer_dir)
 {
-	int res;
+	bool reserved, us_xfer;
+	int res = 0;
+	int dxfer_len = 0;
+	int r0w = READ;
+	unsigned int iov_count = 0;
+	void __user *up;
 	struct request *rq;
-	struct scsi_request *req;
+	struct scsi_request *scsi_rp;
 	struct sg_fd *sfp = srp->parentfp;
-	struct sg_io_hdr *hp = &srp->header;
-	int dxfer_len = (int) hp->dxfer_len;
-	int dxfer_dir = hp->dxfer_direction;
-	unsigned int iov_count = hp->iovec_count;
-	struct sg_scatter_hold *req_schp = &srp->data;
-	struct sg_scatter_hold *rsv_schp = &sfp->reserve;
-	struct request_queue *q = sfp->parentdp->device->request_queue;
-	struct rq_map_data *md, map_data;
-	int r0w = hp->dxfer_direction == SG_DXFER_TO_DEV ? WRITE : READ;
+	struct sg_device *sdp;
+	struct sg_scatter_hold *req_schp;
+	struct request_queue *q;
+	struct rq_map_data *md = (void *)srp; /* want any non-NULL value */
 	u8 *long_cmdp = NULL;
+	__maybe_unused const char *cp = "";
+	struct sg_slice_hdr3 *sh3p = &srp->s_hdr3;
+	struct rq_map_data map_data;
 
-	if (hp->cmd_len > BLK_MAX_CDB) {
-		long_cmdp = kzalloc(hp->cmd_len, GFP_KERNEL);
+	sdp = sfp->parentdp;
+	if (cmd_len > BLK_MAX_CDB) {	/* for longer SCSI cdb_s */
+		long_cmdp = kzalloc(cmd_len, GFP_KERNEL);
 		if (!long_cmdp)
 			return -ENOMEM;
 		SG_LOG(5, sfp, "%s: long_cmdp=0x%pK ++\n", __func__, long_cmdp);
 	}
+	up = sh3p->dxferp;
+	dxfer_len = (int)sh3p->dxfer_len;
+	iov_count = sh3p->iovec_count;
+	r0w = dxfer_dir == SG_DXFER_TO_DEV ? WRITE : READ;
 	SG_LOG(4, sfp, "%s: dxfer_len=%d, data-%s\n", __func__, dxfer_len,
 	       (r0w ? "OUT" : "IN"));
+	q = sdp->device->request_queue;
 
 	/*
 	 * NOTE
@@ -2286,132 +2522,157 @@ sg_start_req(struct sg_request *srp, u8 *cmd)
 	 * do not want to use BLK_MQ_REQ_NOWAIT here because userspace might
 	 * not expect an EWOULDBLOCK from this condition.
 	 */
-	rq = blk_get_request(q, hp->dxfer_direction == SG_DXFER_TO_DEV ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, 0);
+	rq = blk_get_request(q, (r0w ? REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN), 0);
 	if (IS_ERR(rq)) {
 		kfree(long_cmdp);
 		return PTR_ERR(rq);
 	}
-	req = scsi_req(rq);
-
-	if (hp->cmd_len > BLK_MAX_CDB)
-		req->cmd = long_cmdp;
-	memcpy(req->cmd, cmd, hp->cmd_len);
-	req->cmd_len = hp->cmd_len;
-
+	/* current sg_request protected by SG_RS_BUSY state */
+	scsi_rp = scsi_req(rq);
 	srp->rq = rq;
-	rq->end_io_data = srp;
-	req->retries = SG_DEFAULT_RETRIES;
 
-	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
-		return 0;
-
-	if (sg_allow_dio && hp->flags & SG_FLAG_DIRECT_IO &&
-	    dxfer_dir != SG_DXFER_UNKNOWN && !iov_count &&
-	    !sfp->parentdp->device->host->unchecked_isa_dma &&
-	    blk_rq_aligned(q, (unsigned long)hp->dxferp, dxfer_len))
+	if (cmd_len > BLK_MAX_CDB)
+		scsi_rp->cmd = long_cmdp;
+	memcpy(scsi_rp->cmd, cmd, cmd_len);
+	scsi_rp->cmd_len = cmd_len;
+	us_xfer = !(srp->rq_flags & SG_FLAG_NO_DXFER);
+	assign_bit(SG_FRQ_NO_US_XFER, srp->frq_bm, !us_xfer);
+	reserved = (sfp->rsv_srp == srp);
+	rq->end_io_data = srp;
+	scsi_rp->retries = SG_DEFAULT_RETRIES;
+	req_schp = &srp->sgat_h;
+
+	if (dxfer_len <= 0 || dxfer_dir == SG_DXFER_NONE) {
+		SG_LOG(4, sfp, "%s: no data xfer [0x%pK]\n", __func__, srp);
+		set_bit(SG_FRQ_NO_US_XFER, srp->frq_bm);
+		goto fini;	/* path of reqs with no din nor dout */
+	} else if (sg_chk_dio_allowed(sdp, srp, iov_count, dxfer_dir) &&
+		   blk_rq_aligned(q, (unsigned long)up, dxfer_len)) {
+		set_bit(SG_FRQ_DIO_IN_USE, srp->frq_bm);
+		srp->rq_info |= SG_INFO_DIRECT_IO;
 		md = NULL;
-	else
+		if (IS_ENABLED(CONFIG_SCSI_PROC_FS))
+			cp = "direct_io, ";
+	} else {	/* normal IO and failed conditions for dio path */
 		md = &map_data;
+	}
 
-	if (md) {
-		mutex_lock(&sfp->f_mutex);
-		if (dxfer_len <= rsv_schp->buflen &&
-		    !sfp->res_in_use) {
-			sfp->res_in_use = 1;
-			sg_link_reserve(sfp, srp, dxfer_len);
-		} else if (hp->flags & SG_FLAG_MMAP_IO) {
-			res = -EBUSY; /* sfp->res_in_use == 1 */
-			if (dxfer_len > rsv_schp->buflen)
-				res = -ENOMEM;
-			mutex_unlock(&sfp->f_mutex);
-			return res;
-		} else {
-			res = sg_mk_sgat(req_schp, sfp, dxfer_len);
-			if (res) {
-				mutex_unlock(&sfp->f_mutex);
-				return res;
-			}
+	if (likely(md)) {	/* normal, "indirect" IO */
+		if (unlikely((srp->rq_flags & SG_FLAG_MMAP_IO))) {
+			/* mmap IO must use and fit in reserve request */
+			if (!reserved || dxfer_len > req_schp->buflen)
+				res = reserved ? -ENOMEM : -EBUSY;
+		} else if (req_schp->buflen == 0) {
+			int up_sz = max_t(int, dxfer_len, sfp->sgat_elem_sz);
+
+			res = sg_mk_sgat(srp, sfp, up_sz);
 		}
-		mutex_unlock(&sfp->f_mutex);
+		if (res)
+			goto fini;
 
-		sg_set_map_data(req_schp, !!hp->dxferp, md);
+		sg_set_map_data(req_schp, !!up, md);
 		md->from_user = (dxfer_dir == SG_DXFER_TO_FROM_DEV);
 	}
 
-	if (iov_count) {
+	if (unlikely(iov_count)) {
 		struct iovec *iov = NULL;
 		struct iov_iter i;
 
 #ifdef CONFIG_COMPAT
 		if (in_compat_syscall())
-			res = compat_import_iovec(r0w, hp->dxferp, iov_count,
+			res = compat_import_iovec(r0w, up, iov_count,
 						  0, &iov, &i);
 		else
+			res = import_iovec(r0w, up, iov_count, 0, &iov, &i);
+#else
+		res = import_iovec(r0w, up, iov_count, 0, &iov, &i);
 #endif
-			res = import_iovec(r0w, hp->dxferp, iov_count,
-					   0, &iov, &i);
 		if (res < 0)
-			return res;
+			goto fini;
 
-		iov_iter_truncate(&i, hp->dxfer_len);
+		iov_iter_truncate(&i, dxfer_len);
 		if (!iov_iter_count(&i)) {
 			kfree(iov);
-			return -EINVAL;
+			res = -EINVAL;
+			goto fini;
 		}
 
-		res = blk_rq_map_user_iov(q, rq, md, &i, GFP_ATOMIC);
+		if (us_xfer)
+			res = blk_rq_map_user_iov(q, rq, md, &i, GFP_ATOMIC);
 		kfree(iov);
-	} else
-		res = blk_rq_map_user(q, rq, md, hp->dxferp,
-				      hp->dxfer_len, GFP_ATOMIC);
-
-	if (!res) {
-		srp->bio = rq->bio;
-
-		if (!md) {
-			req_schp->dio_in_use = 1;
-			hp->info |= SG_INFO_DIRECT_IO;
+		if (IS_ENABLED(CONFIG_SCSI_PROC_FS))
+			cp = "iov_count > 0";
+	} else if (us_xfer) { /* setup for transfer data to/from user space */
+		res = blk_rq_map_user(q, rq, md, up, dxfer_len, GFP_ATOMIC);
+		if (IS_ENABLED(CONFIG_SCSI_PROC_FS) && res)
+			SG_LOG(1, sfp, "%s: blk_rq_map_user() res=%d\n",
+			       __func__, res);
+	}
+fini:
+	if (unlikely(res)) {		/* failure, free up resources */
+		scsi_req_free_cmd(scsi_rp);
+		if (likely(!test_and_set_bit(SG_FRQ_BLK_PUT_REQ,
+					     srp->frq_bm))) {
+			srp->rq = NULL;
+			blk_put_request(rq);
 		}
+	} else {
+		srp->bio = rq->bio;
 	}
+	SG_LOG((res ? 1 : 4), sfp, "%s: %s res=%d [0x%pK]\n", __func__, cp,
+	       res, srp);
 	return res;
 }
 
+/*
+ * Clean up mid-level and block layer resources of finished request. Sometimes
+ * blk_rq_unmap_user() returns -4 (-EINTR) and this is why: "If we're in a
+ * workqueue, the request is orphaned, so don't copy into a random user
+ * address space, just free and return -EINTR so user space doesn't expect
+ * any data." [block/bio.c]
+ */
 static void
 sg_finish_scsi_blk_rq(struct sg_request *srp)
 {
 	int ret;
-
 	struct sg_fd *sfp = srp->parentfp;
-	struct sg_scatter_hold *req_schp = &srp->data;
 
 	SG_LOG(4, sfp, "%s: srp=0x%pK%s\n", __func__, srp,
-	       (srp->res_used) ? " rsv" : "");
-	if (!srp->sg_io_owned) {
+	       (srp->parentfp->rsv_srp == srp) ? " rsv" : "");
+	if (!test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm)) {
 		atomic_dec(&sfp->submitted);
 		atomic_dec(&sfp->waiting);
 	}
 	if (srp->bio) {
-		ret = blk_rq_unmap_user(srp->bio);
-		if (ret)	/* -EINTR (-4) can be ignored */
-			SG_LOG(6, sfp, "%s: blk_rq_unmap_user() --> %d\n",
-			       __func__, ret);
+		bool us_xfer = !test_bit(SG_FRQ_NO_US_XFER, srp->frq_bm);
+
+		if (us_xfer) {
+			ret = blk_rq_unmap_user(srp->bio);
+			if (ret) {	/* -EINTR (-4) can be ignored */
+				SG_LOG(6, sfp,
+				       "%s: blk_rq_unmap_user() --> %d\n",
+				       __func__, ret);
+			}
+		}
 		srp->bio = NULL;
 	}
+	/* In worst case READ data returned to user space by this point */
 
-	if (srp->rq) {
-		scsi_req_free_cmd(scsi_req(srp->rq));
-		blk_put_request(srp->rq);
-	}
+	/* Expect blk_put_request(rq) already called in sg_rq_end_io() */
+	if (unlikely(!test_and_set_bit(SG_FRQ_BLK_PUT_REQ, srp->frq_bm))) {
+		struct request *rq = srp->rq;
 
-	if (srp->res_used)
-		sg_unlink_reserve(sfp, srp);
-	else
-		sg_remove_sgat(sfp, req_schp);
+		if (rq) {       /* blk_get_request() may have failed */
+			if (scsi_req(rq))
+				scsi_req_free_cmd(scsi_req(rq));
+			srp->rq = NULL;
+			blk_put_request(rq);
+		}
+	}
 }
 
 static int
-sg_mk_sgat(struct sg_scatter_hold *schp, struct sg_fd *sfp, int minlen)
+sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen)
 {
 	int j, k, rem_sz, order, align_sz;
 	__maybe_unused int o_order;
@@ -2423,6 +2684,7 @@ sg_mk_sgat(struct sg_scatter_hold *schp, struct sg_fd *sfp, int minlen)
 	gfp_t mask_ap = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
 	gfp_t mask_kz = GFP_ATOMIC | __GFP_NOWARN;
 	struct sg_device *sdp = sfp->parentdp;
+	struct sg_scatter_hold *schp = &srp->sgat_h;
 
 	if (unlikely(m_size < 0))
 		return -EFAULT;
@@ -2432,9 +2694,8 @@ sg_mk_sgat(struct sg_scatter_hold *schp, struct sg_fd *sfp, int minlen)
 	align_sz = ALIGN(m_size, SG_DEF_SECTOR_SZ);
 
 	schp->pages = kcalloc(mx_sgat_elems, struct_page_sz, mask_kz);
-	SG_LOG(4, sfp, "%s: minlen=%d, align_sz=%d [sz=%zu, 0x%pK ++]\n",
-	       __func__, minlen, align_sz, mx_sgat_elems * struct_page_sz,
-	       schp->pages);
+	SG_LOG(4, sfp, "%s: minlen=%d [sz=%zu, 0x%pK ++]\n", __func__, minlen,
+	       mx_sgat_elems * struct_page_sz, schp->pages);
 	if (unlikely(!schp->pages))
 		return -ENOMEM;
 
@@ -2498,12 +2759,15 @@ sg_remove_sgat_helper(struct sg_fd *sfp, struct sg_scatter_hold *schp)
 
 /* Remove the data (possibly a sgat list) held by srp, not srp itself */
 static void
-sg_remove_sgat(struct sg_fd *sfp, struct sg_scatter_hold *schp)
+sg_remove_sgat(struct sg_request *srp)
 {
+	struct sg_scatter_hold *schp = &srp->sgat_h; /* care: remove own data */
+	struct sg_fd *sfp = srp->parentfp;
+
 	SG_LOG(4, sfp, "%s: num_sgat=%d%s\n", __func__, schp->num_sgat,
-	       ((sfp ? (&sfp->reserve == schp) : false) ?
+	       ((srp->parentfp ? (sfp->rsv_srp == srp) : false) ?
 		" [rsv]" : ""));
-	if (!schp->dio_in_use)
+	if (!test_bit(SG_FRQ_DIO_IN_USE, srp->frq_bm))
 		sg_remove_sgat_helper(sfp, schp);
 
 	memset(schp, 0, sizeof(*schp));         /* zeros buflen and dlen */
@@ -2519,7 +2783,7 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
 {
 	int k, num, res;
 	struct page *pgp;
-	struct sg_scatter_hold *schp = &srp->data;
+	struct sg_scatter_hold *schp = &srp->sgat_h;
 
 	SG_LOG(4, srp->parentfp, "%s: num_xfer=%d\n", __func__, num_xfer);
 	if (unlikely(!outp || num_xfer <= 0))
@@ -2533,11 +2797,11 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
 			break;
 		}
 		if (num > num_xfer) {
-			if (__copy_to_user(outp, page_address(pgp), num_xfer))
+			if (copy_to_user(outp, page_address(pgp), num_xfer))
 				res = -EFAULT;
 			break;
 		} else {
-			if (__copy_to_user(outp, page_address(pgp), num)) {
+			if (copy_to_user(outp, page_address(pgp), num)) {
 				res = -EFAULT;
 				break;
 			}
@@ -2560,135 +2824,274 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
 static struct sg_request *
 sg_find_srp_by_id(struct sg_fd *sfp, int pack_id)
 {
+	__maybe_unused bool is_bad_st = false;
+	__maybe_unused enum sg_rq_state bad_sr_st = SG_RS_INACTIVE;
+	bool search_for_1 = (pack_id != SG_PACK_ID_WILDCARD);
+	int res;
+	int num_waiting = atomic_read(&sfp->waiting);
 	unsigned long idx;
-	struct sg_request *resp;
+	struct sg_request *srp = NULL;
+	struct xarray *xafp = &sfp->srp_arr;
 
-	xa_for_each_marked(&sfp->srp_arr, idx, resp, SG_XA_RQ_AWAIT) {
-		if (!resp)
-			continue;
-		/* look for requests that are ready + not SG_IO owned */
-		if (resp->done == 1 && !resp->sg_io_owned &&
-		    (-1 == pack_id || resp->header.pack_id == pack_id)) {
-			resp->done = 2;	/* guard against other readers */
-			return resp;
+	if (num_waiting < 1)
+		return NULL;
+	if (unlikely(search_for_1)) {
+		xa_for_each_marked(xafp, idx, srp, SG_XA_RQ_AWAIT) {
+			if (!srp)
+				continue;
+			if (srp->pack_id != pack_id)
+				continue;
+			res = sg_rq_state_chg(srp, SG_RS_AWAIT_RCV, SG_RS_BUSY,
+					      false, __func__);
+			if (likely(res == 0))
+				goto good;
+			/* else another caller got it, move on */
+			if (IS_ENABLED(CONFIG_SCSI_PROC_FS)) {
+				is_bad_st = true;
+				bad_sr_st = atomic_read(&srp->rq_st);
+			}
+			break;
+		}
+	} else {        /* search for any request is more likely */
+		xa_for_each_marked(xafp, idx, srp, SG_XA_RQ_AWAIT) {
+			if (!srp)
+				continue;
+			res = sg_rq_state_chg(srp, SG_RS_AWAIT_RCV, SG_RS_BUSY,
+					      false, __func__);
+			if (likely(res == 0))
+				goto good;
+		}
+	}
+	/* here if one of above loops does _not_ find a match */
+	if (IS_ENABLED(CONFIG_SCSI_PROC_FS)) {
+		if (search_for_1) {
+			const char *cptp = "pack_id=";
+
+			if (is_bad_st)
+				SG_LOG(1, sfp, "%s: %s%d wrong state: %s\n",
+				       __func__, cptp, pack_id,
+				       sg_rq_st_str(bad_sr_st, true));
+			else
+				SG_LOG(6, sfp, "%s: %s%d not awaiting read\n",
+				       __func__, cptp, pack_id);
 		}
 	}
 	return NULL;
+good:
+	SG_LOG(6, sfp, "%s: %s%d found [srp=0x%pK]\n", __func__, "pack_id=",
+	       pack_id, srp);
+	return srp;
 }
 
-static void
-sg_link_reserve(struct sg_fd *sfp, struct sg_request *srp, int size)
+/*
+ * Makes a new sg_request object. If 'first' is set then use GFP_KERNEL which
+ * may take time but has improved chance of success, otherwise use GFP_ATOMIC.
+ * Note that basic initialization is done but srp is not added to either sfp
+ * list. On error returns twisted negated errno value (not NULL).
+ */
+static struct sg_request *
+sg_mk_srp(struct sg_fd *sfp, bool first)
 {
-	struct sg_scatter_hold *req_schp = &srp->data;
-	struct sg_scatter_hold *rsv_schp = &sfp->reserve;
-	int k, num, rem;
-
-	srp->res_used = 1;
-	SG_LOG(4, sfp, "%s: size=%d\n", __func__, size);
-	rem = size;
-
-	num = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->num_sgat; k++) {
-		if (rem <= num) {
-			req_schp->num_sgat = k + 1;
-			req_schp->sglist_len = rsv_schp->sglist_len;
-			req_schp->pages = rsv_schp->pages;
+	struct sg_request *srp;
+	int gfp =  __GFP_NOWARN;
 
-			req_schp->buflen = size;
-			req_schp->page_order = rsv_schp->page_order;
-			break;
-		} else
-			rem -= num;
+	if (first)      /* prepared to wait if none already outstanding */
+		srp = kzalloc(sizeof(*srp), gfp | GFP_KERNEL);
+	else
+		srp = kzalloc(sizeof(*srp), gfp | GFP_ATOMIC);
+	if (srp) {
+		atomic_set(&srp->rq_st, SG_RS_INACTIVE);
+		srp->parentfp = sfp;
+		return srp;
+	} else {
+		return ERR_PTR(-ENOMEM);
 	}
-
-	if (k >= rsv_schp->num_sgat)
-		SG_LOG(1, sfp, "%s: BAD size\n", __func__);
 }
 
-static void
-sg_unlink_reserve(struct sg_fd *sfp, struct sg_request *srp)
+static struct sg_request *
+sg_mk_srp_sgat(struct sg_fd *sfp, bool first, int db_len)
 {
-	struct sg_scatter_hold *req_schp = &srp->data;
+	int res;
+	struct sg_request *n_srp = sg_mk_srp(sfp, first);
 
-	SG_LOG(4, srp->parentfp, "%s: req->num_sgat=%d\n", __func__,
-	       (int)req_schp->num_sgat);
-	req_schp->num_sgat = 0;
-	req_schp->buflen = 0;
-	req_schp->pages = NULL;
-	req_schp->page_order = 0;
-	req_schp->sglist_len = 0;
-	srp->res_used = 0;
-	/* Called without mutex lock to avoid deadlock */
-	sfp->res_in_use = 0;
+	if (IS_ERR(n_srp))
+		return n_srp;
+	if (db_len > 0) {
+		res = sg_mk_sgat(n_srp, sfp, db_len);
+		if (res) {
+			kfree(n_srp);
+			return ERR_PTR(res);
+		}
+	}
+	return n_srp;
 }
 
-static void
-sg_build_reserve(struct sg_fd *sfp, int req_size)
+/*
+ * Irrespective of the given reserve request size, the minimum size requested
+ * will be PAGE_SIZE (often 4096 bytes). Returns a pointer to reserve object or
+ * a negated errno value twisted by ERR_PTR() macro. The actual number of bytes
+ * allocated (maybe less than buflen) is in srp->sgat_h.buflen . Note that this
+ * function is only called in contexts where locking is not required.
+ */
+static struct sg_request *
+sg_build_reserve(struct sg_fd *sfp, int buflen)
 {
-	struct sg_scatter_hold *schp = &sfp->reserve;
+	bool go_out = false;
+	int res;
+	struct sg_request *srp;
 
-	SG_LOG(3, sfp, "%s: buflen=%d\n", __func__, req_size);
+	SG_LOG(3, sfp, "%s: buflen=%d\n", __func__, buflen);
+	srp = sg_mk_srp(sfp, xa_empty(&sfp->srp_arr));
+	if (IS_ERR(srp))
+		return srp;
+	sfp->rsv_srp = srp;
 	do {
-		if (req_size < PAGE_SIZE)
-			req_size = PAGE_SIZE;
-		if (sg_mk_sgat(schp, sfp, req_size) == 0)
-			return;
-		sg_remove_sgat(sfp, schp);
-		req_size >>= 1;	/* divide by 2 */
-	} while (req_size > (PAGE_SIZE / 2));
+		if (buflen < (int)PAGE_SIZE) {
+			buflen = PAGE_SIZE;
+			go_out = true;
+		}
+		res = sg_mk_sgat(srp, sfp, buflen);
+		if (res == 0) {
+			SG_LOG(4, sfp, "%s: final buflen=%d, srp=0x%pK ++\n",
+			       __func__, buflen, srp);
+			return srp;
+		}
+		if (go_out)
+			return ERR_PTR(res);
+		/* failed so remove, halve buflen, try again */
+		sg_remove_sgat(srp);
+		buflen >>= 1;   /* divide by 2 */
+	} while (true);
 }
 
-/* always adds to end of list */
+/*
+ * Adds an active request (soon to carry a SCSI command) to the current file
+ * descriptor by creating a new one or re-using a request from the free
+ * list (fl). If successful returns a valid pointer in SG_RS_BUSY state. On
+ * failure returns a negated errno value twisted by ERR_PTR() macro.
+ */
 static struct sg_request *
-sg_add_request(struct sg_fd *sfp)
+sg_add_request(struct sg_fd *sfp, int dxfr_len, struct sg_comm_wr_t *cwrp)
 {
+	bool act_empty = false;
 	bool found = false;
+	bool mk_new_srp = false;
+	bool try_harder = false;
 	int res;
-	unsigned long idx, iflags;
-	struct sg_request *rp;
+	int num_inactive = 0;
+	unsigned long idx, last_idx, iflags;
+	struct sg_request *r_srp = NULL;	/* request to return */
 	struct xarray *xafp = &sfp->srp_arr;
-
-	if (!xa_empty(xafp)) {
-		xa_for_each_marked(xafp, idx, rp, SG_XA_RQ_INACTIVE) {
-			if (!rp)
+	__maybe_unused const char *cp;
+
+start_again:
+	cp = "";
+	if (xa_empty(xafp)) {
+		act_empty = true;
+		mk_new_srp = true;
+	} else if (!try_harder && dxfr_len < SG_DEF_SECTOR_SZ) {
+		last_idx = ~0UL;
+		xa_for_each_marked(xafp, idx, r_srp, SG_XA_RQ_INACTIVE) {
+			if (!r_srp)
 				continue;
-			if (sg_rstate_chg(rp, SG_RS_INACTIVE, SG_RS_BUSY))
+			++num_inactive;
+			if (dxfr_len < SG_DEF_SECTOR_SZ) {
+				last_idx = idx;
 				continue;
-			memset(rp, 0, sizeof(*rp));
-			rp->rq_idx = idx;
-			xa_lock_irqsave(xafp, iflags);
-			__xa_clear_mark(xafp, idx, SG_XA_RQ_INACTIVE);
-			xa_unlock_irqrestore(xafp, iflags);
+			}
+		}
+		/* If dxfr_len is small, use last inactive request */
+		if (last_idx != ~0UL) {
+			idx = last_idx;
+			r_srp = xa_load(xafp, idx);
+			if (!r_srp)
+				goto start_again;
+			if (sg_rq_state_chg(r_srp, SG_RS_INACTIVE, SG_RS_BUSY,
+					    false, __func__))
+				goto start_again; /* gone to another thread */
+			cp = "toward back of srp_arr";
 			found = true;
-			break;
+		}
+	} else {
+		xa_for_each_marked(xafp, idx, r_srp, SG_XA_RQ_INACTIVE) {
+			if (!r_srp)
+				continue;
+			if (r_srp->sgat_h.buflen >= dxfr_len) {
+				if (sg_rq_state_chg
+					(r_srp, SG_RS_INACTIVE, SG_RS_BUSY,
+					 false, __func__))
+					continue;
+				cp = "from front of srp_arr";
+				found = true;
+				break;
+			}
 		}
 	}
-	if (!found) {
-		rp = kzalloc(sizeof(*rp), GFP_KERNEL);
-		if (!rp)
-			return NULL;
+	if (found) {
+		r_srp->rq_idx = idx;
+		r_srp->in_resid = 0;
+		r_srp->rq_info = 0;
+		r_srp->sense_len = 0;
+		mk_new_srp = false;
+	} else {
+		mk_new_srp = true;
 	}
-	rp->parentfp = sfp;
-	rp->header.duration = jiffies_to_msecs(jiffies);
-	if (!found) {
+	if (mk_new_srp) {
+		bool allow_cmd_q = test_bit(SG_FFD_CMD_Q, sfp->ffd_bm);
 		u32 n_idx;
 		struct xa_limit xal = { .max = 0, .min = 0 };
 
-		atomic_set(&rp->rq_st, SG_RS_BUSY);
+		cp = "new";
+		if (!allow_cmd_q && atomic_read(&sfp->submitted) > 0) {
+			r_srp = ERR_PTR(-EDOM);
+			SG_LOG(6, sfp, "%s: trying 2nd req but cmd_q=false\n",
+			       __func__);
+			goto fini;
+		}
+		r_srp = sg_mk_srp_sgat(sfp, act_empty, dxfr_len);
+		if (IS_ERR(r_srp)) {
+			if (!try_harder && dxfr_len < SG_DEF_SECTOR_SZ &&
+			    num_inactive > 0) {
+				try_harder = true;
+				goto start_again;
+			}
+			goto fini;
+		}
+		atomic_set(&r_srp->rq_st, SG_RS_BUSY);
 		xa_lock_irqsave(xafp, iflags);
 		xal.max = atomic_inc_return(&sfp->req_cnt);
-		res = __xa_alloc(xafp, &n_idx, rp, xal, GFP_KERNEL);
+		res = __xa_alloc(xafp, &n_idx, r_srp, xal, GFP_KERNEL);
 		xa_unlock_irqrestore(xafp, iflags);
 		if (res < 0) {
-			pr_warn("%s: don't expect xa_alloc() to fail, errno=%d\n",
-				__func__,  -res);
-			return NULL;
+			SG_LOG(1, sfp, "%s: xa_alloc() failed, errno=%d\n",
+			       __func__,  -res);
+			sg_remove_sgat(r_srp);
+			kfree(r_srp);
+			r_srp = ERR_PTR(-EPROTOTYPE);
+			goto fini;
 		}
-		rp->rq_idx = n_idx;
-	}
-	return rp;
+		idx = n_idx;
+		r_srp->rq_idx = idx;
+		r_srp->parentfp = sfp;
+		SG_LOG(4, sfp, "%s: mk_new_srp=0x%pK ++\n", __func__, r_srp);
+	}
+	r_srp->frq_bm[0] = cwrp->frq_bm[0];	/* assumes <= 32 req flags */
+	r_srp->sgat_h.dlen = dxfr_len;/* must be <= r_srp->sgat_h.buflen */
+	r_srp->cmd_opcode = 0xff;  /* set invalid opcode (VS), 0x0 is TUR */
+fini:
+	if (IS_ERR(r_srp))
+		SG_LOG(1, sfp, "%s: err=%ld\n", __func__, PTR_ERR(r_srp));
+	if (!IS_ERR(r_srp))
+		SG_LOG(4, sfp, "%s: %s r_srp=0x%pK\n", __func__, cp, r_srp);
+	return r_srp;
 }
 
+/*
+ * Moves a completed sg_request object to the free list and sets it to
+ * SG_RS_INACTIVE which makes it available for re-use. Requests with no data
+ * associated are appended to the tail of the free list while other requests
+ * are prepended to the head of the free list.
+ */
 static void
 sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 {
@@ -2696,34 +3099,43 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 
 	if (WARN_ON(!sfp || !srp))
 		return;
+	atomic_set(&srp->rq_st, SG_RS_INACTIVE);
 	xa_lock_irqsave(&sfp->srp_arr, iflags);
 	__xa_set_mark(&sfp->srp_arr, srp->rq_idx, SG_XA_RQ_INACTIVE);
+	__xa_clear_mark(&sfp->srp_arr, srp->rq_idx, SG_XA_RQ_AWAIT);
 	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
-	atomic_set(&srp->rq_st, SG_RS_INACTIVE);
 }
 
+/* Returns pointer to sg_fd object or negated errno twisted by ERR_PTR */
 static struct sg_fd *
 sg_add_sfp(struct sg_device *sdp)
 {
+	bool reduced = false;
 	int rbuf_len, res;
 	u32 idx;
+	long err;
 	unsigned long iflags;
 	struct sg_fd *sfp;
+	struct sg_request *srp = NULL;
+	struct xarray *xadp = &sdp->sfp_arr;
+	struct xarray *xafp;
 	struct xa_limit xal;
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
 		return ERR_PTR(-ENOMEM);
-
 	init_waitqueue_head(&sfp->read_wait);
 	xa_init_flags(&sfp->srp_arr, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
+	xafp = &sfp->srp_arr;
 	kref_init(&sfp->f_ref);
 	mutex_init(&sfp->f_mutex);
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
 	sfp->timeout_user = SG_DEFAULT_TIMEOUT_USER;
-	sfp->force_packid = SG_DEF_FORCE_PACK_ID;
-	sfp->cmd_q = SG_DEF_COMMAND_Q;
-	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
+	/* other bits in sfp->ffd_bm[1] cleared by kzalloc() above */
+	__assign_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm, SG_DEF_FORCE_PACK_ID);
+	__assign_bit(SG_FFD_CMD_Q, sfp->ffd_bm, SG_DEF_COMMAND_Q);
+	__assign_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm, SG_DEF_KEEP_ORPHAN);
+	__assign_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm, SG_DEFAULT_Q_AT);
 	/*
 	 * SG_SCATTER_SZ initializes scatter_elem_sz but different value may
 	 * be given as driver/module parameter (e.g. 'scatter_elem_sz=8192').
@@ -2737,28 +3149,64 @@ sg_add_sfp(struct sg_device *sdp)
 	atomic_set(&sfp->waiting, 0);
 	atomic_set(&sfp->req_cnt, 0);
 
-	if (SG_IS_DETACHING(sdp)) {
+	if (unlikely(SG_IS_DETACHING(sdp))) {
+		SG_LOG(1, sfp, "%s: detaching\n", __func__);
 		kfree(sfp);
 		return ERR_PTR(-ENODEV);
 	}
-	SG_LOG(3, sfp, "%s: sfp=0x%pK\n", __func__, sfp);
 	if (unlikely(sg_big_buff != def_reserved_size))
 		sg_big_buff = def_reserved_size;
 
 	rbuf_len = min_t(int, sg_big_buff, sdp->max_sgat_sz);
-	if (rbuf_len > 0)
-		sg_build_reserve(sfp, rbuf_len);
-
-	xa_lock_irqsave(&sdp->sfp_arr, iflags);
+	if (rbuf_len > 0) {
+		struct xa_limit xalrq = { .max = 0, .min = 0 };
+
+		srp = sg_build_reserve(sfp, rbuf_len);
+		if (IS_ERR(srp)) {
+			kfree(sfp);
+			err = PTR_ERR(srp);
+			SG_LOG(1, sfp, "%s: build reserve err=%ld\n", __func__,
+			       -err);
+			return ERR_PTR(err);
+		}
+		if (srp->sgat_h.buflen < rbuf_len) {
+			reduced = true;
+			SG_LOG(2, sfp,
+			       "%s: reserve reduced from %d to buflen=%d\n",
+			       __func__, rbuf_len, srp->sgat_h.buflen);
+		}
+		xa_lock_irqsave(xafp, iflags);
+		xalrq.max = atomic_inc_return(&sfp->req_cnt);
+		res = __xa_alloc(xafp, &idx, srp, xalrq, GFP_KERNEL);
+		xa_unlock_irqrestore(xafp, iflags);
+		if (res < 0) {
+			SG_LOG(1, sfp, "%s: xa_alloc(srp) bad, errno=%d\n",
+			       __func__,  -res);
+			sg_remove_sgat(srp);
+			kfree(srp);
+			kfree(sfp);
+			return ERR_PTR(-EPROTOTYPE);
+		}
+		srp->rq_idx = idx;
+		srp->parentfp = sfp;
+		sg_rq_state_chg(srp, 0, SG_RS_INACTIVE, true, __func__);
+	}
+	if (!reduced) {
+		SG_LOG(4, sfp, "%s: built reserve buflen=%d\n", __func__,
+		       rbuf_len);
+	}
+	xa_lock_irqsave(xadp, iflags);
 	xal.min = 0;
 	xal.max = atomic_read(&sdp->open_cnt);
-	res = __xa_alloc(&sdp->sfp_arr, &idx, sfp, xal, GFP_KERNEL);
-	xa_unlock_irqrestore(&sdp->sfp_arr, iflags);
+	res = __xa_alloc(xadp, &idx, sfp, xal, GFP_KERNEL);
+	xa_unlock_irqrestore(xadp, iflags);
 	if (res < 0) {
 		pr_warn("%s: xa_alloc(sdp) bad, o_count=%d, errno=%d\n",
 			__func__, xal.max, -res);
-		if (rbuf_len > 0)
-			sg_remove_sgat(sfp, &sfp->reserve);
+		if (srp) {
+			sg_remove_sgat(srp);
+			kfree(srp);
+		}
 		kfree(sfp);
 		return ERR_PTR(res);
 	}
@@ -2789,12 +3237,14 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 	struct sg_request *srp;
 	struct sg_request *e_srp;
 	struct xarray *xafp = &sfp->srp_arr;
+	struct xarray *xadp;
 
 	if (!sfp) {
 		pr_warn("sg: %s: sfp is NULL\n", __func__);
 		return;
 	}
 	sdp = sfp->parentdp;
+	xadp = &sdp->sfp_arr;
 
 	/* Cleanup any responses which were never read(). */
 	xa_for_each(xafp, idx, srp) {
@@ -2802,24 +3252,20 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 			continue;
 		if (!xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE))
 			sg_finish_scsi_blk_rq(srp);
+		sg_remove_sgat(srp);
 		xa_lock_irqsave(xafp, iflags);
 		e_srp = __xa_erase(xafp, srp->rq_idx);
 		xa_unlock_irqrestore(xafp, iflags);
 		if (srp != e_srp)
 			SG_LOG(1, sfp, "%s: xa_erase() return unexpected\n",
 			       __func__);
+		SG_LOG(6, sfp, "%s: kfree: srp=%pK --\n", __func__, srp);
 		kfree(srp);
 	}
 	xa_destroy(xafp);
-	if (sfp->reserve.buflen > 0) {
-		SG_LOG(6, sfp, "%s:    buflen=%d, num_sgat=%d\n", __func__,
-		       (int)sfp->reserve.buflen, (int)sfp->reserve.num_sgat);
-		sg_remove_sgat(sfp, &sfp->reserve);
-	}
-
-	xa_lock_irqsave(&sdp->sfp_arr, iflags);
-	e_sfp = __xa_erase(&sdp->sfp_arr, sfp->idx);
-	xa_unlock_irqrestore(&sdp->sfp_arr, iflags);
+	xa_lock_irqsave(xadp, iflags);
+	e_sfp = __xa_erase(xadp, sfp->idx);
+	xa_unlock_irqrestore(xadp, iflags);
 	if (unlikely(sfp != e_sfp))
 		SG_LOG(1, sfp, "%s: xa_erase() return unexpected\n",
 		       __func__);
@@ -3071,6 +3517,7 @@ sg_proc_seq_show_devhdr(struct seq_file *s, void *v)
 struct sg_proc_deviter {
 	loff_t	index;
 	size_t	max;
+	int fd_index;
 };
 
 static void *
@@ -3154,11 +3601,10 @@ sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 static void
 sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 {
-	int k, new_interface, blen, usg;
+	int k;
 	unsigned long idx, idx2;
 	struct sg_request *srp;
 	struct sg_fd *fp;
-	const struct sg_io_hdr *hp;
 	const char * cp;
 	unsigned int ms;
 
@@ -3169,51 +3615,53 @@ sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 		k++;
 		seq_printf(s, "   FD(%d): timeout=%dms buflen=%d (res)sgat=%d low_dma=%d idx=%lu\n",
 			   k, jiffies_to_msecs(fp->timeout),
-			   fp->reserve.buflen, (int)fp->reserve.num_sgat,
+			   fp->rsv_srp->sgat_h.buflen,
+			   (int)fp->rsv_srp->sgat_h.num_sgat,
 			   (int)sdp->device->host->unchecked_isa_dma, idx);
 		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=0\n",
-			   (int) fp->cmd_q, (int) fp->force_packid,
-			   (int) fp->keep_orphan);
+			   (int)test_bit(SG_FFD_CMD_Q, fp->ffd_bm),
+			   (int)test_bit(SG_FFD_FORCE_PACKID, fp->ffd_bm),
+			   (int)test_bit(SG_FFD_KEEP_ORPHAN, fp->ffd_bm));
 		seq_printf(s, "   submitted=%d waiting=%d\n",
 			   atomic_read(&fp->submitted),
 			   atomic_read(&fp->waiting));
 		xa_for_each(&fp->srp_arr, idx2, srp) {
+			const struct sg_slice_hdr3 *sh3p = &srp->s_hdr3;
+			bool is_v3 = (sh3p->interface_id != '\0');
+			enum sg_rq_state rq_st = atomic_read(&srp->rq_st);
+
 			if (!srp)
 				continue;
-			hp = &srp->header;
-			new_interface = (hp->interface_id == '\0') ? 0 : 1;
-			if (srp->res_used) {
-				if (new_interface &&
-				    (SG_FLAG_MMAP_IO & hp->flags))
+			if (srp->parentfp->rsv_srp == srp) {
+				if (is_v3 && (SG_FLAG_MMAP_IO & sh3p->flags))
 					cp = "     mmap>> ";
 				else
 					cp = "     rb>> ";
 			} else {
-				if (SG_INFO_DIRECT_IO_MASK & hp->info)
+				if (SG_INFO_DIRECT_IO_MASK & srp->rq_info)
 					cp = "     dio>> ";
 				else
 					cp = "     ";
 			}
 			seq_puts(s, cp);
-			blen = srp->data.buflen;
-			usg = srp->data.num_sgat;
-			seq_puts(s, srp->done ?
-				 ((1 == srp->done) ?  "rcv:" : "fin:")
-				  : "act:");
-			seq_printf(s, " id=%d blen=%d",
-				   srp->header.pack_id, blen);
-			if (srp->done)
-				seq_printf(s, " dur=%d", hp->duration);
-			else {
-				ms = jiffies_to_msecs(jiffies);
-				seq_printf(s, " t_o/elap=%d/%d",
-					(new_interface ? hp->timeout :
-						  jiffies_to_msecs(fp->timeout)),
-					(ms > hp->duration ? ms - hp->duration : 0));
+			seq_puts(s, sg_rq_st_str(rq_st, false));
+			seq_printf(s, ": id=%d len/blen=%d/%d",
+				   srp->pack_id, srp->sgat_h.dlen,
+				   srp->sgat_h.buflen);
+			if (rq_st == SG_RS_AWAIT_RCV ||
+			    rq_st == SG_RS_RCV_DONE) {
+				seq_printf(s, " dur=%d", srp->duration);
+				goto fin_line;
 			}
-			seq_printf(s, "ms sgat=%d op=0x%02x dummy: %s\n", usg,
-				   (int)srp->data.cmd_opcode,
-				   sg_rq_st_str(SG_RS_INACTIVE, false));
+			ms = jiffies_to_msecs(jiffies);
+			seq_printf(s, " t_o/elap=%d/%d",
+				   (is_v3 ? sh3p->timeout :
+					    jiffies_to_msecs(fp->timeout)),
+				   (ms > srp->duration ?  ms - srp->duration :
+							  0));
+fin_line:
+			seq_printf(s, "ms sgat=%d op=0x%02x\n",
+				   srp->sgat_h.num_sgat, (int)srp->cmd_opcode);
 		}
 		if (xa_empty(&fp->srp_arr))
 			seq_puts(s, "     No requests active\n");
-- 
2.25.1

