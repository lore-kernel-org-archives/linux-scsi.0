Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4B5C3A59D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiJXD0K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiJXDXA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:23:00 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A9D35FAD3
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:21:29 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 01EE52041E3;
        Mon, 24 Oct 2022 05:21:29 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id K1Hq-LJDd4HT; Mon, 24 Oct 2022 05:21:28 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id CD2C72041AF;
        Mon, 24 Oct 2022 05:21:27 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v25 18/44] sg: introduce request state machine
Date:   Sun, 23 Oct 2022 23:20:32 -0400
Message-Id: <20221024032058.14077-19-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024032058.14077-1-dgilbert@interlog.com>
References: <20221024032058.14077-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The introduced request state machine is not wired in so that
the size of one of the following patches is reduced. Bit
operation defines for the request and file descriptor level
are also introduced. Minor rework og sg_read_append() function.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 176 +++++++++++++++++++++++++++++++---------------
 1 file changed, 120 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 68950cdae163..18881e551702 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -77,7 +77,40 @@ static char *sg_version_date = "20190606";
  */
 #define SG_MAX_CDB_SIZE 252
 
+/* Following enum contains the states of sg_request::rq_st */
+enum sg_rq_state {
+	SG_RS_INACTIVE = 0,	/* request not in use (e.g. on fl) */
+	SG_RS_INFLIGHT,		/* active: cmd/req issued, no response yet */
+	SG_RS_AWAIT_RCV,	/* have response from LLD, awaiting receive */
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
+#define SG_FRQ_NO_US_XFER	3	/* no user space transfer of data */
+#define SG_FRQ_DEACT_ORPHAN	6	/* not keeping orphan so de-activate */
+
+/* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
+#define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
+#define SG_FFD_CMD_Q		1	/* clear: only 1 active req per fd */
+#define SG_FFD_KEEP_ORPHAN	2	/* policy for this fd */
+#define SG_FFD_MMAP_CALLED	3	/* mmap(2) system call made on fd */
+#define SG_FFD_Q_AT_TAIL	5	/* set: queue reqs at tail of blk q */
 
 /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
 #define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
@@ -85,12 +118,11 @@ static char *sg_version_date = "20190606";
 #define SG_FDEV_LOG_SENSE	2	/* set by ioctl(SG_SET_DEBUG) */
 
 static int sg_big_buff = SG_DEF_RESERVED_SIZE;
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
 
@@ -134,6 +166,7 @@ struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
 	/* done protected by rq_list_lock */
 	char done;		/* 0->before bh, 1->before read, 2->read */
+	atomic_t rq_st;		/* request state, holds a enum sg_rq_state */
 	struct request *rq;	/* released in sg_rq_end_io(), bio kept */
 	struct bio *bio;	/* kept until this req -->SG_RS_INACTIVE */
 	struct execute_work ew_orph;	/* harvest orphan request */
@@ -212,10 +245,11 @@ static void sg_remove_sfp(struct kref *);
 static struct sg_request *sg_get_rq_mark(struct sg_fd *sfp, int pack_id,
 					 bool *busy);
 static struct sg_request *sg_setup_req(struct sg_fd *sfp);
-static int sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
+static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int dev);
 static void sg_device_destroy(struct kref *kref);
 static void sg_calc_sgat_param(struct sg_device *sdp);
+static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
 
 #define SZ_SG_HEADER ((int)sizeof(struct sg_header))	/* v1 and v2 header */
 #define SZ_SG_IO_HDR ((int)sizeof(struct sg_io_hdr))	/* v3 header */
@@ -223,6 +257,8 @@ static void sg_calc_sgat_param(struct sg_device *sdp);
 
 #define SG_IS_DETACHING(sdp) test_bit(SG_FDEV_DETACHING, (sdp)->fdev_bm)
 #define SG_HAVE_EXCLUDE(sdp) test_bit(SG_FDEV_EXCLUDE, (sdp)->fdev_bm)
+#define SG_RS_ACTIVE(srp) (atomic_read(&(srp)->rq_st) != SG_RS_INACTIVE)
+#define SG_RS_AWAIT_READ(srp) (atomic_read(&(srp)->rq_st) == SG_RS_AWAIT_RCV)
 
 /*
  * Kernel needs to be built with CONFIG_SCSI_LOGGING to see log messages.
@@ -381,15 +417,6 @@ sg_open(struct inode *inode, struct file *filp)
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
@@ -488,12 +515,12 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
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
@@ -1283,7 +1310,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	case SG_GET_LOW_DMA:
 		SG_LOG(3, sfp, "%s:    SG_GET_LOW_DMA\n", __func__);
 		return put_user(0, ip);
-	case SG_NEXT_CMD_LEN:
+	case SG_NEXT_CMD_LEN:	/* active only in v2 interface */
 		SG_LOG(3, sfp, "%s:    SG_NEXT_CMD_LEN\n", __func__);
 		result = get_user(val, ip);
 		if (result)
@@ -2173,48 +2200,37 @@ sg_remove_sgat(struct sg_fd *sfp, struct sg_scatter_hold *schp)
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
@@ -2292,6 +2308,22 @@ sg_get_rq_mark(struct sg_fd *sfp, int pack_id, bool *busy)
 	return NULL;
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
 sg_setup_req(struct sg_fd *sfp)
@@ -2323,20 +2355,19 @@ sg_setup_req(struct sg_fd *sfp)
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
 
@@ -2347,8 +2378,6 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 	 */
 	if (unlikely(SG_IS_DETACHING(sfp->parentdp)))
 		wake_up_interruptible_all(&sfp->read_wait);
-
-	return res;
 }
 
 static struct sg_fd *
@@ -2406,6 +2435,15 @@ sg_add_sfp(struct sg_device *sdp)
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
@@ -2499,6 +2537,31 @@ sg_get_dev(int dev)
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
 
@@ -2795,8 +2858,9 @@ sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
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
2.37.3

