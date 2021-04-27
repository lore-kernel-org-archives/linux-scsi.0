Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD8CC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD8CE613B0
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239524AbhD0WAd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:33 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38909 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239446AbhD0V7w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id D2086204196;
        Tue, 27 Apr 2021 23:59:07 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VSNDZ7htTjSz; Tue, 27 Apr 2021 23:59:05 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 8F1BC2041AC;
        Tue, 27 Apr 2021 23:59:04 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 59/83] sg: add snap_dev flag and snapped in debugfs
Date:   Tue, 27 Apr 2021 17:57:09 -0400
Message-Id: <20210427215733.417746-61-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add SG_CTL_FLAGM_SNAP_DEV flag to ioctl(SG_SET_GET_EXTENDED)
to allow a snapshot of the current device's data structures
to be sent to /sys/kernel/debug/scsi_generic/snapped
programmatically. The format of the output is similar to what
is seen in: 'cat /sys/kernel/debug/scsi_generic/snapshot' .
Each "snap_dev" is prefixed by a "UTC time: <timestamp>". The
timestamp has microsecond resolution. Each "snap_dev" is
appended to the single internal buffer which is reset to
position zero after that buffer becomes half full.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 107 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/scsi/sg.h |   3 +-
 2 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 7f62cd9bffe0..045aa96addac 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -194,6 +194,9 @@ static struct class_interface sg_interface = {
 	.remove_dev     = sg_remove_device,
 };
 
+static DEFINE_MUTEX(snapped_mutex);
+static char *snapped_buf;
+
 /* Subset of sg_io_hdr found in <scsi/sg.h>, has only [i] and [i->o] fields */
 struct sg_slice_hdr3 {
 	int interface_id;
@@ -363,6 +366,11 @@ static int sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q,
 static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
 static const char *sg_shr_str(enum sg_shr_var sh_var, bool long_str);
 #endif
+#if IS_ENABLED(SG_PROC_OR_DEBUG_FS)
+static int sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len,
+			      int *fd_counterp, bool reduced);
+static void sg_take_snap(struct sg_fd *sfp, bool clear_first);
+#endif
 
 #define SG_WRITE_COUNT_LIMIT (32 * 1024 * 1024)
 
@@ -390,6 +398,7 @@ static const char *sg_shr_str(enum sg_shr_var sh_var, bool long_str);
  */
 
 #define SG_PROC_DEBUG_SZ 8192
+#define SG_SNAP_BUFF_SZ (SG_PROC_DEBUG_SZ * 8)
 
 #if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(SG_DEBUG)
 #define SG_LOG_BUFF_SZ 48
@@ -3574,6 +3583,62 @@ sg_any_persistent_orphans(struct sg_fd *sfp)
 	return false;
 }
 
+/* Ignore append if size already over half of available buffer */
+static void
+sg_take_snap(struct sg_fd *sfp, bool dont_append)
+{
+	u32 hour, minute, second;
+	u64 n;
+	struct sg_device *sdp = sfp->parentdp;
+	struct timespec64 ts64;
+	char b[64];
+
+	if (!sdp)
+		return;
+	ktime_get_real_ts64(&ts64);
+	/* prefer local time but sys_tz.tz_minuteswest is always 0 */
+	n = ts64.tv_sec;
+	second = (u32)do_div(n, 60);
+	minute = (u32)do_div(n, 60);
+	hour = (u32)do_div(n, 24);	/* hour within a UTC day */
+	snprintf(b, sizeof(b), "UTC time: %.2u:%.2u:%.2u:%.6u [tid=%d]",
+		 hour, minute, second, (u32)ts64.tv_nsec / 1000,
+		 (current ? current->pid : -1));
+	mutex_lock(&snapped_mutex);
+	if (!snapped_buf) {
+		snapped_buf = kzalloc(SG_SNAP_BUFF_SZ,
+				      GFP_KERNEL | __GFP_NOWARN);
+		if (!snapped_buf)
+			goto fini;
+	} else if (dont_append) {
+		memset(snapped_buf, 0, SG_SNAP_BUFF_SZ);
+	}
+#if IS_ENABLED(SG_PROC_OR_DEBUG_FS)
+	if (true) {	/* for some declarations */
+		int n, prevlen, bp_len;
+		char *bp;
+
+		prevlen = strlen(snapped_buf);
+		if (prevlen > SG_SNAP_BUFF_SZ / 2)
+			prevlen = 0;
+		bp_len = SG_SNAP_BUFF_SZ - prevlen;
+		bp = snapped_buf + prevlen;
+		n = scnprintf(bp, bp_len, "%s\n", b);
+		bp += n;
+		bp_len -= n;
+		if (bp_len < 2)
+			goto fini;
+		n = sg_proc_debug_sdev(sdp, bp, bp_len, NULL, false);
+		if (n >= bp_len - 1) {
+			if (bp[bp_len - 2] != '\n')
+				bp[bp_len - 2] = '\n';
+		}
+	}
+#endif
+fini:
+	mutex_unlock(&snapped_mutex);
+}
+
 /*
  * Processing of ioctl(SG_SET_GET_EXTENDED(SG_SEIM_CTL_FLAGS)) which is a set
  * of boolean flags. Access abbreviations: [rw], read-write; [ro], read-only;
@@ -3728,6 +3793,20 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 		else
 			c_flgs_val_out &= ~SG_CTL_FLAGM_EXCL_WAITQ;
 	}
+	/* SNAP_DEV boolean, [rbw] */
+	if (c_flgs_rm & SG_CTL_FLAGM_SNAP_DEV) {
+		mutex_lock(&snapped_mutex);
+		flg = (snapped_buf && strlen(snapped_buf) > 0);
+		mutex_unlock(&snapped_mutex);
+	}
+	if (c_flgs_wm & SG_CTL_FLAGM_SNAP_DEV)
+		sg_take_snap(sfp, !!(c_flgs_val_in & SG_CTL_FLAGM_SNAP_DEV));
+	if (c_flgs_rm & SG_CTL_FLAGM_SNAP_DEV) {
+		if (flg)
+			c_flgs_val_out |= SG_CTL_FLAGM_SNAP_DEV;
+		else
+			c_flgs_val_out &= ~SG_CTL_FLAGM_SNAP_DEV;
+	}
 
 	if (c_flgs_val_in != c_flgs_val_out)
 		seip->ctl_flags = c_flgs_val_out;
@@ -4977,6 +5056,7 @@ exit_sg(void)
 	sg_dfs_exit();
 	if (IS_ENABLED(CONFIG_SCSI_PROC_FS))
 		remove_proc_subtree("scsi/sg", NULL);
+	kfree(snapped_buf);
 	scsi_unregister_interface(&sg_interface);
 	mempool_destroy(sg_sense_pool);
 	kmem_cache_destroy(sg_sense_cache);
@@ -6599,6 +6679,10 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 	k = 0;
 	xa_lock_irqsave(&fp->srp_arr, iflags);
 	xa_for_each(&fp->srp_arr, idx, srp) {
+		if (srp->rq_idx != (unsigned long)idx)
+			n += scnprintf(obp + n, len - n,
+				       ">>> xa_index=%lu, rq_idx=%d, bad\n",
+				       idx, srp->rq_idx);
 		if (xa_get_mark(&fp->srp_arr, idx, SG_XA_RQ_INACTIVE))
 			continue;
 		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns, obp + n,
@@ -6858,6 +6942,28 @@ struct sg_dfs_attr {
 	const struct seq_operations *seq_ops;
 };
 
+static int
+sg_dfs_snapped_show(void *data, struct seq_file *m)
+{
+	mutex_lock(&snapped_mutex);
+	if (snapped_buf && snapped_buf[0])
+		seq_puts(m, snapped_buf);
+	mutex_unlock(&snapped_mutex);
+	return 0;
+}
+
+static ssize_t
+sg_dfs_snapped_write(void *data, const char __user *buf, size_t count,
+		     loff_t *ppos)
+{
+	/* Any write clears snapped buffer */
+	mutex_lock(&snapped_mutex);
+	kfree(snapped_buf);
+	snapped_buf = NULL;
+	mutex_unlock(&snapped_mutex);
+	return count;
+}
+
 static int
 sg_dfs_snapshot_devs_show(void *data, struct seq_file *m)
 {
@@ -7019,6 +7125,7 @@ static const struct seq_operations sg_snapshot_summ_seq_ops = {
 };
 
 static const struct sg_dfs_attr sg_dfs_attrs[] = {
+	{"snapped", 0600, sg_dfs_snapped_show, sg_dfs_snapped_write},
 	{"snapshot", 0400, .seq_ops = &sg_snapshot_seq_ops},
 	{"snapshot_devs", 0600, sg_dfs_snapshot_devs_show,
 	 sg_dfs_snapshot_devs_write},
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index 8b3fe773dfd5..bf947ebe06dd 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -211,7 +211,8 @@ typedef struct sg_req_info {	/* used by SG_GET_REQUEST_TABLE ioctl() */
 #define SG_CTL_FLAGM_NO_DURATION 0x400	/* don't calc command duration */
 #define SG_CTL_FLAGM_MORE_ASYNC	0x800	/* yield EAGAIN in more cases */
 #define SG_CTL_FLAGM_EXCL_WAITQ 0x1000	/* only 1 wake up per response */
-#define SG_CTL_FLAGM_ALL_BITS	0x1fff	/* should be OR of previous items */
+#define SG_CTL_FLAGM_SNAP_DEV	0x2000	/* output to debugfs::snapped */
+#define SG_CTL_FLAGM_ALL_BITS	0x3fff	/* should be OR of previous items */
 
 /* Write one of the following values to sg_extended_info::read_value, get... */
 #define SG_SEIRV_INT_MASK	0x0	/* get SG_SEIM_ALL_BITS */
-- 
2.25.1

