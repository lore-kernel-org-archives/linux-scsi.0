Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8744C3A5A7
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 02:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA05D22CED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 02:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfH2C1a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 22:27:30 -0400
Received: from smtp.infotech.no ([82.134.31.41]:40120 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbfH2C1a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Aug 2019 22:27:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 4D4DE2041B2;
        Thu, 29 Aug 2019 04:27:28 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tt6PqNzbvlYo; Thu, 29 Aug 2019 04:27:26 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 921C8204259;
        Thu, 29 Aug 2019 04:27:24 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@infradead.org
Subject: [PATCH v4 14/22] sg: rework debug info
Date:   Wed, 28 Aug 2019 22:26:51 -0400
Message-Id: <20190829022659.23130-15-dgilbert@interlog.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190829022659.23130-1-dgilbert@interlog.com>
References: <20190829022659.23130-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the version 2 driver, the state of the driver can be found
with 'cat /proc/scsi/sg/debug'. As the driver becomes more
threaded and IO faster (e.g. scsi_debug with a command timer
of 5 microseconds), the existing state dump can become
misleading as the state can change during the "snapshot". The
new approach in this patch is to allocate a buffer of
SG_PROC_DEBUG_SZ bytes and use scnprintf() to populate it. Only
when the whole state is captured (or the buffer fills) is the
output to the caller's terminal performed. The previous
approach was line based: assemble a line of information and
then output it.

Locks are taken as required for short periods and should not
interfere with a disk IO intensive program. Operations
such as closing a sg file descriptor or removing a sg device
may be held up for a short while (microseconds).

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 235 +++++++++++++++++++++++++++++++---------------
 1 file changed, 157 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3da326677de4..79eb9089dc2c 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -3769,115 +3769,194 @@ sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 	return 0;
 }
 
-/* must be called while holding sg_index_lock */
-static void
-sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
+/* Writes debug info for one sg_request in obp buffer */
+static int
+sg_proc_debug_sreq(struct sg_request *srp, int to, char *obp, int len)
 {
-	int k;
+	bool is_v3v4, v4, is_dur;
+	int n = 0;
+	u32 dur;
+	enum sg_rq_state rq_st;
+	const char *cp;
+
+	if (len < 1)
+		return 0;
+	v4 = test_bit(SG_FRQ_IS_V4I, srp->frq_bm);
+	is_v3v4 = v4 ? true : (srp->s_hdr3.interface_id != '\0');
+	if (srp->parentfp->rsv_srp == srp)
+		cp = (is_v3v4 && (srp->rq_flags & SG_FLAG_MMAP_IO)) ?
+				"     mmap>> " : "     rsv>> ";
+	else
+		cp = (srp->rq_info & SG_INFO_DIRECT_IO_MASK) ?
+				"     dio>> " : "     ";
+	rq_st = atomic_read(&srp->rq_st);
+	dur = sg_get_dur(srp, &rq_st, &is_dur);
+	n += scnprintf(obp + n, len - n, "%s%s: dlen=%d/%d id=%d", cp,
+		       sg_rq_st_str(rq_st, false), srp->sgat_h.dlen,
+		       srp->sgat_h.buflen, (int)srp->pack_id);
+	if (is_dur)	/* cmd/req has completed, waiting for ... */
+		n += scnprintf(obp + n, len - n, " dur=%ums", dur);
+	else if (dur < U32_MAX)	/* in-flight or busy (so ongoing) */
+		n += scnprintf(obp + n, len - n, " t_o/elap=%us/%ums",
+			       to / 1000, dur);
+	n += scnprintf(obp + n, len - n, " sgat=%d op=0x%02x\n",
+		       srp->sgat_h.num_sgat, srp->cmd_opcode);
+	return n;
+}
+
+/* Writes debug info for one sg fd (including its sg requests) in obp buffer */
+static int
+sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len)
+{
+	bool first_fl;
+	int n = 0;
+	int to;
 	struct sg_request *srp;
-	struct sg_fd *fp;
-	const char * cp;
-	unsigned int ms;
 
-	k = 0;
-	list_for_each_entry(fp, &sdp->sfds, sfd_entry) {
-		k++;
-		spin_lock(&fp->rq_list_lock); /* irqs already disabled */
-		seq_printf(s, "   FD(%d): timeout=%dms bufflen=%d "
-			   "(res)sgat=%d low_dma=%d\n", k,
-			   jiffies_to_msecs(fp->timeout),
-			   fp->rsv_srp->sgat_h.buflen,
-			   (int)fp->rsv_srp->sgat_h.num_sgat,
-			   (int) sdp->device->host->unchecked_isa_dma);
-		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=0\n",
-			   (int)test_bit(SG_FFD_CMD_Q, fp->ffd_bm),
-			   (int)test_bit(SG_FFD_FORCE_PACKID, fp->ffd_bm),
-			   (int)test_bit(SG_FFD_KEEP_ORPHAN, fp->ffd_bm));
-		seq_printf(s, "   submitted=%d waiting=%d\n",
-			   atomic_read(&fp->submitted),
-			   atomic_read(&fp->waiting));
-		list_for_each_entry(srp, &fp->rq_list, rq_entry) {
-			const struct sg_slice_hdr3 *sh3p = &srp->s_hdr3;
-			bool is_v3 = (sh3p->interface_id != '\0');
-			enum sg_rq_state rq_st = atomic_read(&srp->rq_st);
-
-			if (srp->parentfp->rsv_srp == srp) {
-				if (is_v3 && (SG_FLAG_MMAP_IO & sh3p->flags))
-					cp = "     mmap>> ";
-				else
-					cp = "     rb>> ";
-			} else {
-				if (SG_INFO_DIRECT_IO_MASK & srp->rq_info)
-					cp = "     dio>> ";
-				else
-					cp = "     ";
-			}
-			seq_puts(s, cp);
-			seq_puts(s, sg_rq_st_str(rq_st, false));
-			seq_printf(s, ": id=%d len/blen=%d/%d",
-				   srp->pack_id, srp->sgat_h.dlen,
-				   srp->sgat_h.buflen);
-			if (rq_st == SG_RS_AWAIT_RD || rq_st == SG_RS_DONE_RD) {
-				seq_printf(s, " dur=%d", srp->duration);
-				goto fin_line;
-			}
-			ms = jiffies_to_msecs(jiffies);
-			seq_printf(s, " t_o/elap=%d/%d",
-				   (is_v3 ? sh3p->timeout :
-					    jiffies_to_msecs(fp->timeout)),
-				   (ms > srp->duration ?  ms - srp->duration :
-							  0));
-fin_line:
-			seq_printf(s, "ms sgat=%d op=0x%02x\n",
-				   srp->sgat_h.num_sgat, (int)srp->cmd_opcode);
+	/* sgat=-1 means unavailable */
+	to = jiffies_to_msecs(fp->timeout);
+	if (to % 1000)
+		n += scnprintf(obp + n, len - n, "timeout=%dms rs", to);
+	else
+		n += scnprintf(obp + n, len - n, "timeout=%ds rs", to / 1000);
+	n += scnprintf(obp + n, len - n, "v_buflen=%d\n   cmd_q=%d ",
+		       fp->rsv_srp->sgat_h.buflen,
+		       (int)test_bit(SG_FFD_CMD_Q, fp->ffd_bm));
+	n += scnprintf(obp + n, len - n,
+		       "f_packid=%d k_orphan=%d ffd_bm=0x%lx\n",
+		       (int)test_bit(SG_FFD_FORCE_PACKID, fp->ffd_bm),
+		       (int)test_bit(SG_FFD_KEEP_ORPHAN, fp->ffd_bm),
+		       fp->ffd_bm[0]);
+	n += scnprintf(obp + n, len - n, "   mmap_called=%d\n",
+		       test_bit(SG_FFD_MMAP_CALLED, fp->ffd_bm));
+	n += scnprintf(obp + n, len - n,
+		       "   submitted=%d waiting=%d   open thr_id=%d\n",
+		       atomic_read(&fp->submitted),
+		       atomic_read(&fp->waiting), fp->tid);
+	list_for_each_entry_rcu(srp, &fp->rq_list, rq_entry) {
+		spin_lock(&srp->req_lck);
+		n += sg_proc_debug_sreq(srp, fp->timeout, obp + n, len - n);
+		spin_unlock(&srp->req_lck);
+	}
+	if (list_empty(&fp->rq_list))
+		n += scnprintf(obp + n, len - n, "     No requests active\n");
+	first_fl = true;
+	list_for_each_entry_rcu(srp, &fp->rq_fl, fl_entry) {
+		if (first_fl) {
+			n += scnprintf(obp + n, len - n, "   Free list:\n");
+			first_fl = false;
 		}
-		if (list_empty(&fp->rq_list))
-			seq_puts(s, "     No requests active\n");
-		spin_unlock(&fp->rq_list_lock);
+		spin_lock(&srp->req_lck);
+		n += sg_proc_debug_sreq(srp, fp->timeout, obp + n, len - n);
+		spin_unlock(&srp->req_lck);
+	}
+	return n;
+}
+
+/* Writes debug info for one sg device (including its sg fds) in obp buffer */
+static int
+sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len, int *fd_counterp)
+{
+	int n = 0;
+	int my_count = 0;
+	struct scsi_device *ssdp = sdp->device;
+	struct sg_fd *fp;
+	char *disk_name;
+	int *countp;
+
+	countp = fd_counterp ? fd_counterp : &my_count;
+	disk_name = (sdp->disk ? sdp->disk->disk_name : "?_?");
+	n += scnprintf(obp + n, len - n, " >>> device=%s ", disk_name);
+	n += scnprintf(obp + n, len - n, "%d:%d:%d:%llu ", ssdp->host->host_no,
+		       ssdp->channel, ssdp->id, ssdp->lun);
+	n += scnprintf(obp + n, len - n,
+		       "  max_sgat_sz,elems=2^%d,%d excl=%d open_cnt=%d\n",
+		       ilog2(sdp->max_sgat_sz), sdp->max_sgat_elems,
+		       SG_HAVE_EXCLUDE(sdp), atomic_read(&sdp->open_cnt));
+	list_for_each_entry(fp, &sdp->sfds, sfd_entry) {
+		++*countp;
+		rcu_read_lock(); /* assume irqs disabled */
+		n += scnprintf(obp + n, len - n, "  FD(%d): ", *countp);
+		n += sg_proc_debug_fd(fp, obp + n, len - n);
+		rcu_read_unlock();
 	}
+	return n;
 }
 
+/* Called via dbg_seq_ops once for each sg device */
 static int
 sg_proc_seq_show_debug(struct seq_file *s, void *v)
 {
+	bool found = false;
+	bool trunc = false;
+	const int bp_len = SG_PROC_DEBUG_SZ;
+	int n = 0;
+	int k = 0;
+	unsigned long iflags;
 	struct sg_proc_deviter *it = (struct sg_proc_deviter *)v;
 	struct sg_device *sdp;
-	unsigned long iflags;
+	int *fdi_p;
+	char *bp;
+	char *disk_name;
+	char b1[128];
 
+	b1[0] = '\0';
 	if (it && (0 == it->index))
 		seq_printf(s, "max_active_device=%d  def_reserved_size=%d\n",
-			   (int)it->max, sg_big_buff);
-
+			   (int)it->max, def_reserved_size);
+	fdi_p = it ? &it->fd_index : &k;
+	bp = kzalloc(bp_len, __GFP_NOWARN | GFP_KERNEL);
+	if (!bp) {
+		seq_printf(s, "%s: Unable to allocate %d on heap, finish\n",
+			   __func__, bp_len);
+		return -1;
+	}
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
 	if (NULL == sdp)
 		goto skip;
 	read_lock(&sdp->sfd_lock);
 	if (!list_empty(&sdp->sfds)) {
-		seq_printf(s, " >>> device=%s ", sdp->disk->disk_name);
+		found = true;
+		disk_name = (sdp->disk ? sdp->disk->disk_name : "?_?");
 		if (SG_IS_DETACHING(sdp))
-			seq_puts(s, "detaching pending close ");
+			snprintf(b1, sizeof(b1), " >>> device=%s  %s\n",
+				 disk_name, "detaching pending close\n");
 		else if (sdp->device) {
-			struct scsi_device *scsidp = sdp->device;
-
-			seq_printf(s, "%d:%d:%d:%llu   em=%d",
-				   scsidp->host->host_no,
-				   scsidp->channel, scsidp->id,
-				   scsidp->lun,
-				   scsidp->host->hostt->emulated);
+			n = sg_proc_debug_sdev(sdp, bp, bp_len, fdi_p);
+			if (n >= bp_len - 1) {
+				trunc = true;
+				if (bp[bp_len - 2] != '\n')
+					bp[bp_len - 2] = '\n';
+			}
+		} else {
+			snprintf(b1, sizeof(b1), " >>> device=%s  %s\n",
+				 disk_name, "sdp->device==NULL, skip");
 		}
-		seq_printf(s, " max_sgat_elems=%d excl=%d open_cnt=%d\n",
-			   sdp->max_sgat_elems, SG_HAVE_EXCLUDE(sdp),
-			   atomic_read(&sdp->open_cnt));
-		sg_proc_debug_helper(s, sdp);
 	}
 	read_unlock(&sdp->sfd_lock);
 skip:
 	read_unlock_irqrestore(&sg_index_lock, iflags);
+	if (found) {
+		if (n > 0) {
+			seq_puts(s, bp);
+			if (seq_has_overflowed(s))
+				goto s_ovfl;
+			if (trunc)
+				seq_printf(s, "   >> Output truncated %s\n",
+					   "due to buffer size");
+		} else if (b1[0]) {
+			seq_puts(s, b1);
+			if (seq_has_overflowed(s))
+				goto s_ovfl;
+		}
+	}
+s_ovfl:
+	kfree(bp);
 	return 0;
 }
 
-#endif				/* CONFIG_SCSI_PROC_FS (~300 lines back) */
+#endif				/* CONFIG_SCSI_PROC_FS (~400 lines back) */
 
 module_init(init_sg);
 module_exit(exit_sg);
-- 
2.23.0

