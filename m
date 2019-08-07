Return-Path: <SRS0=ayNI=WD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60576C32751
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Aug 2019 11:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3840C21BF6
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Aug 2019 11:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbfHGLnD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Aug 2019 07:43:03 -0400
Received: from smtp.infotech.no ([82.134.31.41]:45250 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbfHGLm7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Aug 2019 07:42:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 9A8E4204273;
        Wed,  7 Aug 2019 13:42:54 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jsP3vdAQiLsS; Wed,  7 Aug 2019 13:42:54 +0200 (CEST)
Received: from xtwo70.infotech.no (unknown [82.134.31.183])
        by smtp.infotech.no (Postfix) with ESMTPA id 387D0204269;
        Wed,  7 Aug 2019 13:42:54 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v3 19/20] sg: first debugfs support
Date:   Wed,  7 Aug 2019 13:42:51 +0200
Message-Id: <20190807114252.2565-20-dgilbert@interlog.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190807114252.2565-1-dgilbert@interlog.com>
References: <20190807114252.2565-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Duplicate the semantics of 'cat /proc/scsi/sg/debug' on
'cat /sys/kernel/debug/scsi_generic/snapshot'. Make code
that generates the snapshot conditional on either
CONFIG_SCSI_PROC_FS or CONFIG_DEBUG_FS being defined.

-

Use "scsi_generic" in the debugfs path as "sg" may be
confused with scatter gather in the wider kernel.
As implemented, the snapshot is on all sg devices. If many sg
devices are in use, restricting the output to one (or a list)
of sg device numbers may declutter the output. Perhaps a
writable snapshot_devs attribute could be added that takes a
single integer, a comma separated list or integers, or '*'
which maps to -1 which is the default and means all devices.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 207 ++++++++++++++++++++++++++++++----------------
 1 file changed, 136 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index fe79f5f354f2..82c4147ba4f1 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -43,6 +43,7 @@ static char *sg_version_date = "20190606";
 #include <linux/uio.h>
 #include <linux/cred.h>			/* for sg_check_file_access() */
 #include <linux/proc_fs.h>
+#include <linux/debugfs.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_eh.h>
@@ -68,6 +69,10 @@ static char *sg_version_date = "20190606";
 #endif
 #endif
 
+#if IS_ENABLED(CONFIG_SCSI_PROC_FS) || IS_ENABLED(CONFIG_DEBUG_FS)
+#define SG_PROC_OR_DEBUG_FS 1
+#endif
+
 /* SG_MAX_CDB_SIZE should be 260 (spc4r37 section 3.1.30) however the type
  * of sg_io_hdr::cmd_len can only represent 255. All SCSI commands greater
  * than 16 bytes are "variable length" whose length is a multiple of 4, so:
@@ -268,6 +273,8 @@ struct sg_comm_wr_t {	/* arguments to sg_common_write() */
 static void sg_rq_end_io(struct request *rq, blk_status_t status);
 /* Declarations of other static functions used before they are defined */
 static int sg_proc_init(void);
+static void sg_dfs_init(void);
+static void sg_dfs_exit(void);
 static int sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp,
 			int dxfer_dir);
 static void sg_finish_scsi_blk_rq(struct sg_request *srp);
@@ -341,7 +348,7 @@ static void sg_rep_rq_state_fail(struct sg_fd *sfp,
 			pr_info("sg: sdp or sfp NULL, " fmt, ##a);	\
 	} while (0)
 #else
-#define SG_LOG(depth, sfp, fmt, a...)
+#define SG_LOG(depth, sfp, fmt, a...) do { } while (0)
 #endif	/* end of CONFIG_SCSI_LOGGING && SG_DEBUG conditional */
 
 
@@ -2650,6 +2657,7 @@ init_sg(void)
 	rc = scsi_register_interface(&sg_interface);
 	if (rc == 0) {
 		sg_proc_init();
+		sg_dfs_init();
 		return 0;
 	}
 	class_destroy(sg_sysfs_class);
@@ -2674,6 +2682,7 @@ sg_proc_init(void)
 static void __exit
 exit_sg(void)
 {
+	sg_dfs_exit();
 	if (IS_ENABLED(CONFIG_SCSI_PROC_FS))
 		remove_proc_subtree("scsi/sg", NULL);
 	scsi_unregister_interface(&sg_interface);
@@ -3130,7 +3139,7 @@ sg_find_srp_by_id(struct sg_fd *sfp, int pack_id)
 	rcu_read_unlock();
 	if (IS_ENABLED(CONFIG_SCSI_PROC_FS)) {
 		if (search_for_1) {
-			const char *cptp = "pack_id=";
+			__maybe_unused const char *cptp = "pack_id=";
 
 			if (is_bad_st)
 				SG_LOG(1, sfp, "%s: %s%d wrong state: %s\n",
@@ -3248,7 +3257,7 @@ sg_add_request(struct sg_comm_wr_t *cwrp, int dxfr_len)
 	enum sg_rq_state sr_st;
 	struct sg_fd *fp = cwrp->sfp;
 	struct sg_request *r_srp = NULL;	/* request to return */
-	struct sg_request *rsv_srp;	/* current fd's reserve request */
+	__maybe_unused struct sg_request *rsv_srp;
 	__maybe_unused const char *cp;
 
 	spin_lock_irqsave(&fp->rq_list_lock, iflags);
@@ -3348,7 +3357,7 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 	u8 *sbp;
 	struct sg_request *t_srp;
 	struct sg_scatter_hold *schp;
-	const char *cp = "head";
+	__maybe_unused const char *cp = "head";
 
 	if (WARN_ON(!sfp || !srp))
 		return;
@@ -3551,18 +3560,6 @@ sg_remove_sfp(struct kref *kref)
 	schedule_work(&sfp->ew_fd.work);
 }
 
-static int
-sg_idr_max_id(int id, void *p, void *data)
-		__must_hold(&sg_index_lock)
-{
-	int *k = data;
-
-	if (*k < id)
-		*k = id;
-
-	return 0;
-}
-
 /* must be called with sg_index_lock held */
 static struct sg_device *
 sg_lookup_dev(int dev)
@@ -3592,7 +3589,7 @@ sg_get_dev(int dev)
 	return sdp;
 }
 
-#if IS_ENABLED(CONFIG_SCSI_PROC_FS)
+#if IS_ENABLED(SG_PROC_OR_DEBUG_FS)
 static const char *
 sg_rq_st_str(enum sg_rq_state rq_st, bool long_str)
 {
@@ -3619,7 +3616,72 @@ sg_rq_st_str(enum sg_rq_state rq_st, bool long_str)
 }
 #endif
 
-#if IS_ENABLED(CONFIG_SCSI_PROC_FS)     /* long, almost to end of file */
+#if IS_ENABLED(SG_PROC_OR_DEBUG_FS)
+
+struct sg_proc_deviter {
+	loff_t	index;
+	size_t	max;
+	int fd_index;
+};
+
+static int
+sg_idr_max_id(int id, void *p, void *data)
+		__must_hold(&sg_index_lock)
+{
+	int *k = data;
+
+	if (*k < id)
+		*k = id;
+	return 0;
+}
+
+static int
+sg_last_dev(void)
+{
+	int k = -1;
+	unsigned long iflags;
+
+	read_lock_irqsave(&sg_index_lock, iflags);
+	idr_for_each(&sg_index_idr, sg_idr_max_id, &k);
+	read_unlock_irqrestore(&sg_index_lock, iflags);
+	return k + 1;		/* origin 1 */
+}
+
+static void *
+dev_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct sg_proc_deviter *it = kzalloc(sizeof(*it), GFP_KERNEL);
+
+	s->private = it;
+	if (!it)
+		return NULL;
+
+	it->index = *pos;
+	it->max = sg_last_dev();
+	if (it->index >= it->max)
+		return NULL;
+	return it;
+}
+
+static void *
+dev_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct sg_proc_deviter *it = s->private;
+
+	*pos = ++it->index;
+	return (it->index < it->max) ? it : NULL;
+}
+
+static void
+dev_seq_stop(struct seq_file *s, void *v)
+{
+	kfree(s->private);
+}
+
+#endif			/* SG_PROC_OR_DEBUG_FS */
+
+#if IS_ENABLED(CONFIG_SCSI_PROC_FS)     /* long, around 200 lines */
+
 static int sg_proc_seq_show_int(struct seq_file *s, void *v);
 
 static int sg_proc_single_open_adio(struct inode *inode, struct file *filp);
@@ -3649,9 +3711,6 @@ static const struct file_operations dressz_fops = {
 static int sg_proc_seq_show_version(struct seq_file *s, void *v);
 static int sg_proc_seq_show_devhdr(struct seq_file *s, void *v);
 static int sg_proc_seq_show_dev(struct seq_file *s, void *v);
-static void * dev_seq_start(struct seq_file *s, loff_t *pos);
-static void * dev_seq_next(struct seq_file *s, void *v, loff_t *pos);
-static void dev_seq_stop(struct seq_file *s, void *v);
 static const struct seq_operations dev_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
@@ -3694,18 +3753,6 @@ sg_proc_init(void)
 	return 0;
 }
 
-static int
-sg_last_dev(void)
-{
-	int k = -1;
-	unsigned long iflags;
-
-	read_lock_irqsave(&sg_index_lock, iflags);
-	idr_for_each(&sg_index_idr, sg_idr_max_id, &k);
-	read_unlock_irqrestore(&sg_index_lock, iflags);
-	return k + 1;		/* origin 1 */
-}
-
 static int
 sg_proc_seq_show_int(struct seq_file *s, void *v)
 {
@@ -3776,43 +3823,6 @@ sg_proc_seq_show_devhdr(struct seq_file *s, void *v)
 	return 0;
 }
 
-struct sg_proc_deviter {
-	loff_t	index;
-	size_t	max;
-	int fd_index;
-};
-
-static void *
-dev_seq_start(struct seq_file *s, loff_t *pos)
-{
-	struct sg_proc_deviter *it = kzalloc(sizeof(*it), GFP_KERNEL);
-
-	s->private = it;
-	if (! it)
-		return NULL;
-
-	it->index = *pos;
-	it->max = sg_last_dev();
-	if (it->index >= it->max)
-		return NULL;
-	return it;
-}
-
-static void *
-dev_seq_next(struct seq_file *s, void *v, loff_t *pos)
-{
-	struct sg_proc_deviter *it = s->private;
-
-	*pos = ++it->index;
-	return (it->index < it->max) ? it : NULL;
-}
-
-static void
-dev_seq_stop(struct seq_file *s, void *v)
-{
-	kfree(s->private);
-}
-
 static int
 sg_proc_seq_show_dev(struct seq_file *s, void *v)
 {
@@ -3859,6 +3869,10 @@ sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 	return 0;
 }
 
+#endif				/* CONFIG_SCSI_PROC_FS (~200 lines back) */
+
+#if IS_ENABLED(SG_PROC_OR_DEBUG_FS)
+
 /* Writes debug info for one sg_request in obp buffer */
 static int
 sg_proc_debug_sreq(struct sg_request *srp, int to, char *obp, int len)
@@ -4049,7 +4063,58 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v)
 	return 0;
 }
 
-#endif				/* CONFIG_SCSI_PROC_FS (~400 lines back) */
+#endif				/* SG_PROC_OR_DEBUG_FS */
+
+#if IS_ENABLED(CONFIG_DEBUG_FS)
+
+static int
+sg_dfs_snapshot_show(struct seq_file *s, void *v)
+{
+	int res = 0;
+	loff_t my_pos = 0;
+	void *it;
+
+	it = dev_seq_start(s, &my_pos);
+	while (it) {
+		res = sg_proc_seq_show_debug(s, it);
+		if (res)
+			break;
+		it = dev_seq_next(s, it, &my_pos);
+	}
+	dev_seq_stop(s, it);
+	return res;
+}
+DEFINE_SHOW_ATTRIBUTE(sg_dfs_snapshot);
+
+static struct dentry *sg_dfs_rootdir;
+static struct dentry *sg_dfs_snapshot;
+
+static void
+sg_dfs_init(void)
+{
+	/* /sys/kernel/debug/scsi_generic/ */
+	if (!sg_dfs_rootdir)
+		sg_dfs_rootdir = debugfs_create_dir("scsi_generic", NULL);
+
+	sg_dfs_snapshot = debugfs_create_file("snapshot", S_IFREG | 0444,
+					      sg_dfs_rootdir, NULL,
+					      &sg_dfs_snapshot_fops);
+}
+
+static void
+sg_dfs_exit(void)
+{
+	debugfs_remove(sg_dfs_snapshot);
+	debugfs_remove(sg_dfs_rootdir);
+}
+
+#else		/* not  defined: CONFIG_DEBUG_FS */
+
+static void sg_dfs_init(void) {}
+static void sg_dfs_exit(void) {}
+
+#endif		/* CONFIG_DEBUG_FS */
+
 
 module_init(init_sg);
 module_exit(exit_sg);
-- 
2.22.0

