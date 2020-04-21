Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A09C55186
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD34820724
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgDUVxr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 17:53:47 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43101 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbgDUVxo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 17:53:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 907842041AF;
        Tue, 21 Apr 2020 23:53:42 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bysHpQ8tL9lf; Tue, 21 Apr 2020 23:53:40 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id D5B142041D4;
        Tue, 21 Apr 2020 23:53:34 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v9 28/40] sg: rework debug info
Date:   Tue, 21 Apr 2020 17:52:46 -0400
Message-Id: <20200421215258.14348-29-dgilbert@interlog.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200421215258.14348-1-dgilbert@interlog.com>
References: <20200421215258.14348-1-dgilbert@interlog.com>
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
 drivers/scsi/sg.c | 256 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 177 insertions(+), 79 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3301791398cc..0233a36d2ce9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2393,7 +2393,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 	if (unlikely((srp->rq_result & SG_ML_RESULT_MSK) && slen > 0))
 		sg_check_sense(sdp, srp, slen);
 	if (slen > 0) {
-		if (scsi_rp->sense) {
+		if (scsi_rp->sense && !srp->sense_bp) {
 			srp->sense_bp = mempool_alloc(sg_sense_pool,
 						      GFP_ATOMIC);
 			if (srp->sense_bp) {
@@ -2406,6 +2406,9 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 				pr_warn("%s: sense but can't alloc buffer\n",
 					__func__);
 			}
+		} else if (srp->sense_bp) {
+			slen = 0;
+			pr_warn("%s: non-NULL srp->sense_bp ? ?\n", __func__);
 		} else {
 			slen = 0;
 			pr_warn("%s: sense_len>0 but sense==NULL\n", __func__);
@@ -3932,116 +3935,211 @@ sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
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
-	unsigned long idx, idx2;
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
+sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
+{
+	int n = 0;
+	int to, k;
+	unsigned long iflags;
 	struct sg_request *srp;
-	struct sg_fd *fp;
-	const char * cp;
-	unsigned int ms;
 
+	/* sgat=-1 means unavailable */
+	to = (fp->timeout >= 0) ? jiffies_to_msecs(fp->timeout) : -999;
+	if (to < 0)
+		n += scnprintf(obp + n, len - n, "BAD timeout=%d",
+			       fp->timeout);
+	else if (to % 1000)
+		n += scnprintf(obp + n, len - n, "timeout=%dms rs", to);
+	else
+		n += scnprintf(obp + n, len - n, "timeout=%ds rs", to / 1000);
+	n += scnprintf(obp + n, len - n, "v_buflen=%d idx=%lu\n   cmd_q=%d ",
+		       fp->rsv_srp->sgat_h.buflen, idx,
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
+	k = 0;
+	xa_lock_irqsave(&fp->srp_arr, iflags);
+	xa_for_each(&fp->srp_arr, idx, srp) {
+		if (!srp)
+			continue;
+		if (xa_get_mark(&fp->srp_arr, idx, SG_XA_RQ_INACTIVE))
+			continue;
+		n += sg_proc_debug_sreq(srp, fp->timeout, obp + n, len - n);
+		++k;
+		if ((k % 8) == 0) {     /* don't hold up isr_s too long */
+			xa_unlock_irqrestore(&fp->srp_arr, iflags);
+			cpu_relax();
+			xa_lock_irqsave(&fp->srp_arr, iflags);
+		}
+	}
+	if (k == 0)
+		n += scnprintf(obp + n, len - n, "     No requests active\n");
 	k = 0;
+	xa_for_each_marked(&fp->srp_arr, idx, srp, SG_XA_RQ_INACTIVE) {
+		if (!srp)
+			continue;
+		if (k == 0)
+			n += scnprintf(obp + n, len - n, "   Inactives:\n");
+		n += sg_proc_debug_sreq(srp, fp->timeout, obp + n, len - n);
+		++k;
+		if ((k % 8) == 0) {     /* don't hold up isr_s too long */
+			xa_unlock_irqrestore(&fp->srp_arr, iflags);
+			cpu_relax();
+			xa_lock_irqsave(&fp->srp_arr, iflags);
+		}
+	}
+	xa_unlock_irqrestore(&fp->srp_arr, iflags);
+	return n;
+}
+
+/* Writes debug info for one sg device (including its sg fds) in obp buffer */
+static int
+sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len, int *fd_counterp)
+{
+	int n = 0;
+	int my_count = 0;
+	unsigned long idx;
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
 	xa_for_each(&sdp->sfp_arr, idx, fp) {
 		if (!fp)
 			continue;
-		k++;
-		seq_printf(s, "   FD(%d): timeout=%dms buflen=%d (res)sgat=%d low_dma=%d idx=%lu\n",
-			   k, jiffies_to_msecs(fp->timeout),
-			   fp->rsv_srp->sgat_h.buflen,
-			   (int)fp->rsv_srp->sgat_h.num_sgat,
-			   (int)sdp->device->host->unchecked_isa_dma, idx);
-		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=0\n",
-			   (int)test_bit(SG_FFD_CMD_Q, fp->ffd_bm),
-			   (int)test_bit(SG_FFD_FORCE_PACKID, fp->ffd_bm),
-			   (int)test_bit(SG_FFD_KEEP_ORPHAN, fp->ffd_bm));
-		seq_printf(s, "   submitted=%d waiting=%d\n",
-			   atomic_read(&fp->submitted),
-			   atomic_read(&fp->waiting));
-		xa_for_each(&fp->srp_arr, idx2, srp) {
-			const struct sg_slice_hdr3 *sh3p = &srp->s_hdr3;
-			bool is_v3 = (sh3p->interface_id != '\0');
-			enum sg_rq_state rq_st = atomic_read(&srp->rq_st);
-
-			if (!srp)
-				continue;
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
-			if (rq_st == SG_RS_AWAIT_RCV ||
-			    rq_st == SG_RS_RCV_DONE) {
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
-		}
-		if (xa_empty(&fp->srp_arr))
-			seq_puts(s, "     No requests active\n");
+		++*countp;
+		n += scnprintf(obp + n, len - n, "  FD(%d): ", *countp);
+		n += sg_proc_debug_fd(fp, obp + n, len - n, idx);
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
 	if (!xa_empty(&sdp->sfp_arr)) {
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
-		seq_printf(s, " max_sgat_sz=%d excl=%d open_cnt=%d\n",
-			   sdp->max_sgat_sz, SG_HAVE_EXCLUDE(sdp),
-			   atomic_read(&sdp->open_cnt));
-		sg_proc_debug_helper(s, sdp);
 	}
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
2.26.1

