Return-Path: <SRS0=MD5Y=4P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06673C35677
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 16:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D327F2469F
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 16:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbgB0Q7m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Feb 2020 11:59:42 -0500
Received: from smtp.infotech.no ([82.134.31.41]:47209 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729581AbgB0Q7m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Feb 2020 11:59:42 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id DC26D204197;
        Thu, 27 Feb 2020 17:59:39 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hCwfWRn2g0lO; Thu, 27 Feb 2020 17:59:37 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id E80D8204190;
        Thu, 27 Feb 2020 17:59:31 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v7 19/38] sg: introduce request state machine
Date:   Thu, 27 Feb 2020 11:58:43 -0500
Message-Id: <20200227165902.11861-20-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227165902.11861-1-dgilbert@interlog.com>
References: <20200227165902.11861-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The introduced request state machine is not wired in so that
the size of one of the following patches is reduced. Bit
operation defines for the request and file descriptor level
are also introduced. Minor rework og sg_read_append() function.

*** Reviewed-by: Hannes Reinecke <hare@suse.de>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 231 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 173 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b60bbc7add82..b0dc73a6bc20 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -72,7 +72,43 @@ static char *sg_version_date = "20190606";
  */
 #define SG_MAX_CDB_SIZE 252
 
+/* Following enum contains the states of sg_request::rq_st */
+enum sg_rq_state {
+	SG_RS_INACTIVE = 0,	/* request not in use (e.g. on fl) */
+	SG_RS_INFLIGHT,		/* active: cmd/req issued, no response yet */
+	SG_RS_AWAIT_RCV,	/* have response from LLD, awaiting receive */
+	SG_RS_RCV_DONE,		/* receive is ongoing or done */
+	SG_RS_BUSY,		/* temporary state should rarely be seen */
+};
+
+#define SG_TIME_UNIT_MS 0	/* milliseconds */
+#define SG_DEF_TIME_UNIT SG_TIME_UNIT_MS
 #define SG_DEFAULT_TIMEOUT mult_frac(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
+#define SG_FD_Q_AT_HEAD 0
+#define SG_DEFAULT_Q_AT SG_FD_Q_AT_HEAD /* for backward compatibility */
+#define SG_FL_MMAP_DIRECT (SG_FLAG_MMAP_IO | SG_FLAG_DIRECT_IO)
+
+/* Only take lower 4 bits of driver byte, all host byte and sense byte */
+#define SG_ML_RESULT_MSK 0x0fff00ff	/* mid-level's 32 bit result value */
+
+#define SG_PACK_ID_WILDCARD (-1)
+
+#define SG_ADD_RQ_MAX_RETRIES 40	/* to stop infinite _trylock(s) */
+
+/* Bit positions (flags) for sg_request::frq_bm bitmask follow */
+#define SG_FRQ_IS_ORPHAN	1	/* owner of request gone */
+#define SG_FRQ_SYNC_INVOC	2	/* synchronous (blocking) invocation */
+#define SG_FRQ_DIO_IN_USE	3	/* false->indirect_IO,mmap; 1->dio */
+#define SG_FRQ_NO_US_XFER	4	/* no user space transfer of data */
+#define SG_FRQ_DEACT_ORPHAN	7	/* not keeping orphan so de-activate */
+#define SG_FRQ_BLK_PUT_REQ	9	/* set when blk_put_request() called */
+
+/* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
+#define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
+#define SG_FFD_CMD_Q		1	/* clear: only 1 active req per fd */
+#define SG_FFD_KEEP_ORPHAN	2	/* policy for this fd */
+#define SG_FFD_MMAP_CALLED	3	/* mmap(2) system call made on fd */
+#define SG_FFD_Q_AT_TAIL	5	/* set: queue reqs at tail of blk q */
 
 /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
 #define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
@@ -80,12 +116,11 @@ static char *sg_version_date = "20190606";
 #define SG_FDEV_LOG_SENSE	2	/* set by ioctl(SG_SET_DEBUG) */
 
 int sg_big_buff = SG_DEF_RESERVED_SIZE;
-/* N.B. This variable is readable and writeable via
-   /proc/scsi/sg/def_reserved_size . Each time sg_open() is called a buffer
-   of this size (or less if there is not enough memory) will be reserved
-   for use by this file descriptor. [Deprecated usage: this variable is also
-   readable via /proc/sys/kernel/sg-big-buff if the sg driver is built into
-   the kernel (i.e. it is not a module).] */
+/*
+ * This variable is accessible via /proc/scsi/sg/def_reserved_size . Each
+ * time sg_open() is called a sg_request of this size (or less if there is
+ * not enough memory) will be reserved for use by this file descriptor.
+ */
 static int def_reserved_size = -1;	/* picks up init parameter */
 static int sg_allow_dio = SG_ALLOW_DIO_DEF;
 
@@ -129,6 +164,7 @@ struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
 	/* done protected by rq_list_lock */
 	char done;		/* 0->before bh, 1->before read, 2->read */
+	atomic_t rq_st;		/* request state, holds a enum sg_rq_state */
 	struct request *rq;	/* released in sg_rq_end_io(), bio kept */
 	struct bio *bio;	/* kept until this req -->SG_RS_INACTIVE */
 	struct execute_work ew_orph;	/* harvest orphan request */
@@ -205,10 +241,15 @@ static void sg_unlink_reserve(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_fd *sg_add_sfp(struct sg_device *sdp);
 static void sg_remove_sfp(struct kref *);
 static struct sg_request *sg_add_request(struct sg_fd *sfp);
-static int sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
+static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int dev);
 static void sg_device_destroy(struct kref *kref);
 static void sg_calc_sgat_param(struct sg_device *sdp);
+static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
+static void sg_rep_rq_state_fail(struct sg_fd *sfp,
+				 enum sg_rq_state exp_old_st,
+				 enum sg_rq_state want_st,
+				 enum sg_rq_state act_old_st);
 
 #define SZ_SG_HEADER ((int)sizeof(struct sg_header))	/* v1 and v2 header */
 #define SZ_SG_IO_HDR ((int)sizeof(struct sg_io_hdr))	/* v3 header */
@@ -216,6 +257,8 @@ static void sg_calc_sgat_param(struct sg_device *sdp);
 
 #define SG_IS_DETACHING(sdp) test_bit(SG_FDEV_DETACHING, (sdp)->fdev_bm)
 #define SG_HAVE_EXCLUDE(sdp) test_bit(SG_FDEV_EXCLUDE, (sdp)->fdev_bm)
+#define SG_RS_ACTIVE(srp) (atomic_read(&(srp)->rq_st) != SG_RS_INACTIVE)
+#define SG_RS_AWAIT_READ(srp) (atomic_read(&(srp)->rq_st) == SG_RS_AWAIT_RCV)
 
 /*
  * Kernel needs to be built with CONFIG_SCSI_LOGGING to see log messages.
@@ -379,15 +422,6 @@ sg_open(struct inode *inode, struct file *filp)
 	res = sg_allow_if_err_recovery(sdp, non_block);
 	if (res)
 		goto error_out;
-	/* scsi_block_when_processing_errors() may block so bypass
-	 * check if O_NONBLOCK. Permits SCSI commands to be issued
-	 * during error recovery. Tread carefully. */
-	if (!((op_flags & O_NONBLOCK) ||
-	      scsi_block_when_processing_errors(sdp->device))) {
-		res = -ENXIO;
-		/* we are in error recovery for this device */
-		goto error_out;
-	}
 
 	mutex_lock(&sdp->open_rel_lock);
 	if (op_flags & O_NONBLOCK) {
@@ -486,12 +520,12 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
 	struct sg_request *srp;
+	u8 cmnd[SG_MAX_CDB_SIZE];
 	struct sg_header ov2hdr;
 	struct sg_io_hdr v3hdr;
 	struct sg_header *ohp = &ov2hdr;
 	struct sg_io_hdr *h3p = &v3hdr;
 	struct sg_comm_wr_t cwr;
-	u8 cmnd[SG_MAX_CDB_SIZE];
 
 	res = sg_check_file_access(filp, __func__);
 	if (res)
@@ -743,10 +777,25 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 	return 0;
 }
 
+static inline int
+sg_rstate_chg(struct sg_request *srp, enum sg_rq_state old_st,
+	      enum sg_rq_state new_st)
+{
+	enum sg_rq_state act_old_st = (enum sg_rq_state)
+				atomic_cmpxchg(&srp->rq_st, old_st, new_st);
+
+	if (act_old_st == old_st)
+		return 0;	/* implies new_st --> srp->rq_st */
+	else if (IS_ENABLED(CONFIG_SCSI_LOGGING))
+		sg_rep_rq_state_fail(srp->parentfp, old_st, new_st,
+				     act_old_st);
+	return -EPROTOTYPE;
+}
+
 /*
- * read(2) related functions follow. They are shown after write(2) related
- * functions. Apart from read(2) itself, ioctl(SG_IORECEIVE) and the second
- * half of the ioctl(SG_IO) share code with read(2).
+ * This function is called by wait_event_interruptible in sg_read() and
+ * sg_ctl_ioreceive(). wait_event_interruptible will return if this one
+ * returns true (or an event like a signal (e.g. control-C) occurs).
  */
 
 static struct sg_request *
@@ -781,6 +830,32 @@ srp_done(struct sg_fd *sfp, struct sg_request *srp)
 	return ret;
 }
 
+#if IS_ENABLED(CONFIG_SCSI_LOGGING)
+static void
+sg_rep_rq_state_fail(struct sg_fd *sfp, enum sg_rq_state exp_old_st,
+		     enum sg_rq_state want_st, enum sg_rq_state act_old_st)
+{
+	const char *eors = "expected old rq_st: ";
+	const char *aors = "actual old rq_st: ";
+
+	if (IS_ENABLED(CONFIG_SCSI_PROC_FS))
+		SG_LOG(1, sfp, "%s: %s%s, %s%s, wanted rq_st: %s\n", __func__,
+		       eors, sg_rq_st_str(exp_old_st, false),
+		       aors, sg_rq_st_str(act_old_st, false),
+		       sg_rq_st_str(want_st, false));
+	else
+		pr_info("sg: %s: %s%d, %s%d, wanted rq_st: %d\n", __func__,
+			eors, (int)exp_old_st, aors, (int)act_old_st,
+			(int)want_st);
+}
+#else
+static void
+sg_rep_rq_state_fail(struct sg_fd *sfp, enum sg_rq_state exp_old_st,
+		     enum sg_rq_state want_st, enum sg_rq_state act_old_st)
+{
+}
+#endif
+
 static ssize_t
 sg_receive_v3(struct sg_fd *sfp, char __user *buf, size_t count,
 	      struct sg_request *srp)
@@ -1308,7 +1383,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	case SG_GET_LOW_DMA:
 		SG_LOG(3, sfp, "%s:    SG_GET_LOW_DMA\n", __func__);
 		return put_user((int)sdev->host->unchecked_isa_dma, ip);
-	case SG_NEXT_CMD_LEN:
+	case SG_NEXT_CMD_LEN:	/* active only in v2 interface */
 		SG_LOG(3, sfp, "%s:    SG_NEXT_CMD_LEN\n", __func__);
 		result = get_user(val, ip);
 		if (result)
@@ -2251,48 +2326,37 @@ sg_remove_sgat(struct sg_fd *sfp, struct sg_scatter_hold *schp)
 static int
 sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
 {
+	int k, num, res;
+	struct page *pgp;
 	struct sg_scatter_hold *schp = &srp->data;
-	int k, num;
 
 	SG_LOG(4, srp->parentfp, "%s: num_xfer=%d\n", __func__, num_xfer);
-	if (!outp || num_xfer <= 0)
-		return 0;
+	if (unlikely(!outp || num_xfer <= 0))
+		return (num_xfer == 0 && outp) ? 0 : -EINVAL;
 
 	num = 1 << (PAGE_SHIFT + schp->page_order);
-	for (k = 0; k < schp->num_sgat && schp->pages[k]; k++) {
+	for (k = 0, res = 0; k < schp->num_sgat; ++k) {
+		pgp = schp->pages[k];
+		if (unlikely(!pgp)) {
+			res = -ENXIO;
+			break;
+		}
 		if (num > num_xfer) {
-			if (copy_to_user(outp, page_address(schp->pages[k]),
-					 num_xfer))
-				return -EFAULT;
+			if (__copy_to_user(outp, page_address(pgp), num_xfer))
+				res = -EFAULT;
 			break;
 		} else {
-			if (copy_to_user(outp, page_address(schp->pages[k]),
-					 num))
-				return -EFAULT;
+			if (__copy_to_user(outp, page_address(pgp), num)) {
+				res = -EFAULT;
+				break;
+			}
 			num_xfer -= num;
 			if (num_xfer <= 0)
 				break;
 			outp += num;
 		}
 	}
-	return 0;
-}
-
-static void
-sg_build_reserve(struct sg_fd *sfp, int req_size)
-{
-	struct sg_scatter_hold *schp = &sfp->reserve;
-
-	SG_LOG(3, sfp, "%s: buflen=%d\n", __func__, req_size);
-	do {
-		if (req_size < PAGE_SIZE)
-			req_size = PAGE_SIZE;
-		if (sg_mk_sgat(schp, sfp, req_size) == 0)
-			return;
-		else
-			sg_remove_sgat(sfp, schp);
-		req_size >>= 1;	/* divide by 2 */
-	} while (req_size > (PAGE_SIZE / 2));
+	return res;
 }
 
 static void
@@ -2341,6 +2405,22 @@ sg_unlink_reserve(struct sg_fd *sfp, struct sg_request *srp)
 	sfp->res_in_use = 0;
 }
 
+static void
+sg_build_reserve(struct sg_fd *sfp, int req_size)
+{
+	struct sg_scatter_hold *schp = &sfp->reserve;
+
+	SG_LOG(3, sfp, "%s: buflen=%d\n", __func__, req_size);
+	do {
+		if (req_size < PAGE_SIZE)
+			req_size = PAGE_SIZE;
+		if (sg_mk_sgat(schp, sfp, req_size) == 0)
+			return;
+		sg_remove_sgat(sfp, schp);
+		req_size >>= 1;	/* divide by 2 */
+	} while (req_size > (PAGE_SIZE / 2));
+}
+
 /* always adds to end of list */
 static struct sg_request *
 sg_add_request(struct sg_fd *sfp)
@@ -2372,23 +2452,21 @@ sg_add_request(struct sg_fd *sfp)
 	return NULL;
 }
 
-/* Return of 1 for found; 0 for not found */
-static int
+static void
 sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 {
 	unsigned long iflags;
-	int res = 0;
 
-	if (!sfp || !srp || list_empty(&sfp->rq_list))
-		return res;
+	if (WARN_ON(!sfp || !srp))
+		return;
+	if (list_empty(&sfp->rq_list))
+		return;
 	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
 	if (!list_empty(&srp->entry)) {
 		list_del(&srp->entry);
 		srp->parentfp = NULL;
-		res = 1;
 	}
 	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return res;
 }
 
 static struct sg_fd *
@@ -2446,6 +2524,15 @@ sg_add_sfp(struct sg_device *sdp)
 	return sfp;
 }
 
+/*
+ * A successful call to sg_release() will result, at some later time, to this
+ * function being invoked. All requests associated with this file descriptor
+ * should be completed or cancelled when this function is called (due to
+ * sfp->f_ref). Also the file descriptor itself has not been accessible since
+ * it was list_del()-ed by the preceding sg_remove_sfp() call. So no locking
+ * is required. sdp should never be NULL but to make debugging more robust,
+ * this function will not blow up in that case.
+ */
 static void
 sg_remove_sfp_usercontext(struct work_struct *work)
 {
@@ -2541,6 +2628,33 @@ sg_get_dev(int dev)
 	return sdp;
 }
 
+#if IS_ENABLED(CONFIG_SCSI_PROC_FS)
+static const char *
+sg_rq_st_str(enum sg_rq_state rq_st, bool long_str)
+{
+	switch (rq_st) {	/* request state */
+	case SG_RS_INACTIVE:
+		return long_str ? "inactive" :  "ina";
+	case SG_RS_INFLIGHT:
+		return long_str ? "inflight" : "act";
+	case SG_RS_AWAIT_RCV:
+		return long_str ? "await_receive" : "rcv";
+	case SG_RS_RCV_DONE:
+		return long_str ? "receive_done" : "fin";
+	case SG_RS_BUSY:
+		return long_str ? "busy" : "bsy";
+	default:
+		return long_str ? "unknown" : "unk";
+	}
+}
+#else
+static const char *
+sg_rq_st_str(enum sg_rq_state rq_st, bool long_str)
+{
+	return "";
+}
+#endif
+
 #if IS_ENABLED(CONFIG_SCSI_PROC_FS)     /* long, almost to end of file */
 static int sg_proc_seq_show_int(struct seq_file *s, void *v);
 
@@ -2837,8 +2951,9 @@ sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 						  jiffies_to_msecs(fp->timeout)),
 					(ms > hp->duration ? ms - hp->duration : 0));
 			}
-			seq_printf(s, "ms sgat=%d op=0x%02x\n", usg,
-				   (int) srp->data.cmd_opcode);
+			seq_printf(s, "ms sgat=%d op=0x%02x dummy: %s\n", usg,
+				   (int)srp->data.cmd_opcode,
+				   sg_rq_st_str(SG_RS_INACTIVE, false));
 		}
 		if (list_empty(&fp->rq_list))
 			seq_puts(s, "     No requests active\n");
-- 
2.25.1

