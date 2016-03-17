From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH 1/8] snic: Added additional stats
Date: Thu, 17 Mar 2016 00:51:10 -0700
Message-ID: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-1.cisco.com ([173.37.142.88]:39375 "EHLO
	alln-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645AbcCQH5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2016 03:57:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

Adding additional stats, and fixed logging messages.
- Added qdepth change stats
- Added separate isr stats for each type of interrupt
- Fixed race in updating active IOs
- Suppressed Link event message for DAS backend.

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/snic/snic_ctl.c     |  8 +++-----
 drivers/scsi/snic/snic_debugfs.c | 20 ++++++++++++++++----
 drivers/scsi/snic/snic_isr.c     |  6 +++---
 drivers/scsi/snic/snic_main.c    |  9 ++++++++-
 drivers/scsi/snic/snic_scsi.c    | 27 ++++++++++++++++++++-------
 drivers/scsi/snic/snic_stats.h   | 12 +++++++++---
 6 files changed, 59 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/snic/snic_ctl.c b/drivers/scsi/snic/snic_ctl.c
index aebe753..229b199 100644
--- a/drivers/scsi/snic/snic_ctl.c
+++ b/drivers/scsi/snic/snic_ctl.c
@@ -39,17 +39,15 @@ snic_handle_link(struct work_struct *work)
 {
 	struct snic *snic = container_of(work, struct snic, link_work);
 
-	if (snic->config.xpt_type != SNIC_DAS) {
-		SNIC_HOST_INFO(snic->shost, "Link Event Received.\n");
-		SNIC_ASSERT_NOT_IMPL(1);
-
+	if (snic->config.xpt_type == SNIC_DAS)
 		return;
-	}
 
 	snic->link_status = svnic_dev_link_status(snic->vdev);
 	snic->link_down_cnt = svnic_dev_link_down_cnt(snic->vdev);
 	SNIC_HOST_INFO(snic->shost, "Link Event: Link %s.\n",
 		       ((snic->link_status) ? "Up" : "Down"));
+
+	SNIC_ASSERT_NOT_IMPL(1);
 }
 
 
diff --git a/drivers/scsi/snic/snic_debugfs.c b/drivers/scsi/snic/snic_debugfs.c
index 1686f01..d302803 100644
--- a/drivers/scsi/snic/snic_debugfs.c
+++ b/drivers/scsi/snic/snic_debugfs.c
@@ -264,12 +264,14 @@ snic_stats_show(struct seq_file *sfp, void *data)
 		   "Aborts Fail                 : %lld\n"
 		   "Aborts Driver Timeout       : %lld\n"
 		   "Abort FW Timeout            : %lld\n"
-		   "Abort IO NOT Found          : %lld\n",
+		   "Abort IO NOT Found          : %lld\n"
+		   "Abort Queuing Failed        : %lld\n",
 		   (u64) atomic64_read(&stats->abts.num),
 		   (u64) atomic64_read(&stats->abts.fail),
 		   (u64) atomic64_read(&stats->abts.drv_tmo),
 		   (u64) atomic64_read(&stats->abts.fw_tmo),
-		   (u64) atomic64_read(&stats->abts.io_not_found));
+		   (u64) atomic64_read(&stats->abts.io_not_found),
+		   (u64) atomic64_read(&stats->abts.q_fail));
 
 	/* Dump Reset Stats */
 	seq_printf(sfp,
@@ -316,7 +318,9 @@ snic_stats_show(struct seq_file *sfp, void *data)
 	seq_printf(sfp,
 		   "Last ISR Time               : %llu (%8lu.%8lu)\n"
 		   "Last Ack Time               : %llu (%8lu.%8lu)\n"
-		   "ISRs                        : %llu\n"
+		   "Ack ISRs                    : %llu\n"
+		   "IO Cmpl ISRs                : %llu\n"
+		   "Err Notify ISRs             : %llu\n"
 		   "Max CQ Entries              : %lld\n"
 		   "Data Count Mismatch         : %lld\n"
 		   "IOs w/ Timeout Status       : %lld\n"
@@ -324,12 +328,17 @@ snic_stats_show(struct seq_file *sfp, void *data)
 		   "IOs w/ SGL Invalid Stat     : %lld\n"
 		   "WQ Desc Alloc Fail          : %lld\n"
 		   "Queue Full                  : %lld\n"
+		   "Queue Ramp Up               : %lld\n"
+		   "Queue Ramp Down             : %lld\n"
+		   "Queue Last Queue Depth      : %lld\n"
 		   "Target Not Ready            : %lld\n",
 		   (u64) stats->misc.last_isr_time,
 		   last_isr_tms.tv_sec, last_isr_tms.tv_nsec,
 		   (u64)stats->misc.last_ack_time,
 		   last_ack_tms.tv_sec, last_ack_tms.tv_nsec,
-		   (u64) atomic64_read(&stats->misc.isr_cnt),
+		   (u64) atomic64_read(&stats->misc.ack_isr_cnt),
+		   (u64) atomic64_read(&stats->misc.cmpl_isr_cnt),
+		   (u64) atomic64_read(&stats->misc.errnotify_isr_cnt),
 		   (u64) atomic64_read(&stats->misc.max_cq_ents),
 		   (u64) atomic64_read(&stats->misc.data_cnt_mismat),
 		   (u64) atomic64_read(&stats->misc.io_tmo),
@@ -337,6 +346,9 @@ snic_stats_show(struct seq_file *sfp, void *data)
 		   (u64) atomic64_read(&stats->misc.sgl_inval),
 		   (u64) atomic64_read(&stats->misc.wq_alloc_fail),
 		   (u64) atomic64_read(&stats->misc.qfull),
+		   (u64) atomic64_read(&stats->misc.qsz_rampup),
+		   (u64) atomic64_read(&stats->misc.qsz_rampdown),
+		   (u64) atomic64_read(&stats->misc.last_qsz),
 		   (u64) atomic64_read(&stats->misc.tgt_not_rdy));
 
 	return 0;
diff --git a/drivers/scsi/snic/snic_isr.c b/drivers/scsi/snic/snic_isr.c
index a85fae2..f552003 100644
--- a/drivers/scsi/snic/snic_isr.c
+++ b/drivers/scsi/snic/snic_isr.c
@@ -38,7 +38,7 @@ snic_isr_msix_wq(int irq, void *data)
 	unsigned long wq_work_done = 0;
 
 	snic->s_stats.misc.last_isr_time = jiffies;
-	atomic64_inc(&snic->s_stats.misc.isr_cnt);
+	atomic64_inc(&snic->s_stats.misc.ack_isr_cnt);
 
 	wq_work_done = snic_wq_cmpl_handler(snic, -1);
 	svnic_intr_return_credits(&snic->intr[SNIC_MSIX_WQ],
@@ -56,7 +56,7 @@ snic_isr_msix_io_cmpl(int irq, void *data)
 	unsigned long iocmpl_work_done = 0;
 
 	snic->s_stats.misc.last_isr_time = jiffies;
-	atomic64_inc(&snic->s_stats.misc.isr_cnt);
+	atomic64_inc(&snic->s_stats.misc.cmpl_isr_cnt);
 
 	iocmpl_work_done = snic_fwcq_cmpl_handler(snic, -1);
 	svnic_intr_return_credits(&snic->intr[SNIC_MSIX_IO_CMPL],
@@ -73,7 +73,7 @@ snic_isr_msix_err_notify(int irq, void *data)
 	struct snic *snic = data;
 
 	snic->s_stats.misc.last_isr_time = jiffies;
-	atomic64_inc(&snic->s_stats.misc.isr_cnt);
+	atomic64_inc(&snic->s_stats.misc.errnotify_isr_cnt);
 
 	svnic_intr_return_all_credits(&snic->intr[SNIC_MSIX_ERR_NOTIFY]);
 	snic_log_q_error(snic);
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 2b3c253..37ec507 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -98,11 +98,18 @@ snic_slave_configure(struct scsi_device *sdev)
 static int
 snic_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
+	struct snic *snic = shost_priv(sdev->host);
 	int qsz = 0;
 
 	qsz = min_t(u32, qdepth, SNIC_MAX_QUEUE_DEPTH);
+	if (qsz < sdev->queue_depth)
+		atomic64_inc(&snic->s_stats.misc.qsz_rampdown);
+	else if (qsz > sdev->queue_depth)
+		atomic64_inc(&snic->s_stats.misc.qsz_rampup);
+
+	atomic64_set(&snic->s_stats.misc.last_qsz, sdev->queue_depth);
+
 	scsi_change_queue_depth(sdev, qsz);
-	SNIC_INFO("QDepth Changed to %d\n", sdev->queue_depth);
 
 	return sdev->queue_depth;
 }
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 2c7b4c3..e423eaa 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -221,11 +221,15 @@ snic_queue_icmnd_req(struct snic *snic,
 			pa, /* sense buffer pa */
 			SCSI_SENSE_BUFFERSIZE);
 
+	atomic64_inc(&snic->s_stats.io.active);
 	ret = snic_queue_wq_desc(snic, rqi->req, rqi->req_len);
-	if (ret)
+	if (ret) {
+		atomic64_dec(&snic->s_stats.io.active);
 		SNIC_HOST_ERR(snic->shost,
 			      "QIcmnd: Queuing Icmnd Failed. ret = %d\n",
 			      ret);
+	} else
+		snic_stats_update_active_ios(&snic->s_stats);
 
 	return ret;
 } /* end of snic_queue_icmnd_req */
@@ -361,8 +365,7 @@ snic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	if (ret) {
 		SNIC_HOST_ERR(shost, "Failed to Q, Scsi Req w/ err %d.\n", ret);
 		ret = SCSI_MLQUEUE_HOST_BUSY;
-	} else
-		snic_stats_update_active_ios(&snic->s_stats);
+	}
 
 	atomic_dec(&snic->ios_inflight);
 
@@ -1001,10 +1004,11 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 	unsigned long flags, gflags;
 	int ret = 0;
 
+	snic_io_hdr_dec(&fwreq->hdr, &typ, &hdr_stat, &cmnd_id, &hid, &ctx);
 	SNIC_HOST_INFO(snic->shost,
-		       "reset_cmpl:HBA Reset Completion received.\n");
+		       "reset_cmpl:Tag %d ctx %lx cmpl status %s HBA Reset Completion received.\n",
+		       cmnd_id, ctx, snic_io_status_to_str(hdr_stat));
 
-	snic_io_hdr_dec(&fwreq->hdr, &typ, &hdr_stat, &cmnd_id, &hid, &ctx);
 	SNIC_SCSI_DBG(snic->shost,
 		      "reset_cmpl: type = %x, hdr_stat = %x, cmnd_id = %x, hid = %x, ctx = %lx\n",
 		      typ, hdr_stat, cmnd_id, hid, ctx);
@@ -1012,6 +1016,9 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 	/* spl case, host reset issued through ioctl */
 	if (cmnd_id == SCSI_NO_TAG) {
 		rqi = (struct snic_req_info *) ctx;
+		SNIC_HOST_INFO(snic->shost,
+			       "reset_cmpl:Tag %d ctx %lx cmpl stat %s\n",
+			       cmnd_id, ctx, snic_io_status_to_str(hdr_stat));
 		sc = rqi->sc;
 
 		goto ioctl_hba_rst;
@@ -1038,6 +1045,10 @@ ioctl_hba_rst:
 		return ret;
 	}
 
+	SNIC_HOST_INFO(snic->shost,
+		       "reset_cmpl: sc %p rqi %p Tag %d flags 0x%llx\n",
+		       sc, rqi, cmnd_id, CMD_FLAGS(sc));
+
 	io_lock = snic_io_lock_hash(snic, sc);
 	spin_lock_irqsave(io_lock, flags);
 
@@ -1554,6 +1565,7 @@ snic_send_abort_and_wait(struct snic *snic, struct scsi_cmnd *sc)
 	/* Now Queue the abort command to firmware */
 	ret = snic_queue_abort_req(snic, rqi, sc, tmf);
 	if (ret) {
+		atomic64_inc(&snic->s_stats.abts.q_fail);
 		SNIC_HOST_ERR(snic->shost,
 			      "send_abt_cmd: IO w/ Tag 0x%x fail w/ err %d flags 0x%llx\n",
 			      tag, ret, CMD_FLAGS(sc));
@@ -2459,8 +2471,9 @@ snic_scsi_cleanup(struct snic *snic, int ex_tag)
 cleanup:
 		sc->result = DID_TRANSPORT_DISRUPTED << 16;
 		SNIC_HOST_INFO(snic->shost,
-			       "sc_clean: DID_TRANSPORT_DISRUPTED for sc %p. rqi %p duration %llu msecs\n",
-			       sc, rqi, (jiffies - st_time));
+			       "sc_clean: DID_TRANSPORT_DISRUPTED for sc %p, Tag %d flags 0x%llx rqi %p duration %u msecs\n",
+			       sc, sc->request->tag, CMD_FLAGS(sc), rqi,
+			       jiffies_to_msecs(jiffies - st_time));
 
 		/* Update IO stats */
 		snic_stats_update_io_cmpl(&snic->s_stats);
diff --git a/drivers/scsi/snic/snic_stats.h b/drivers/scsi/snic/snic_stats.h
index 11e6148..fd1066b 100644
--- a/drivers/scsi/snic/snic_stats.h
+++ b/drivers/scsi/snic/snic_stats.h
@@ -42,6 +42,7 @@ struct snic_abort_stats {
 	atomic64_t drv_tmo;	/* Abort Driver Timeouts */
 	atomic64_t fw_tmo;	/* Abort Firmware Timeouts */
 	atomic64_t io_not_found;/* Abort IO Not Found */
+	atomic64_t q_fail;	/* Abort Queuing Failed */
 };
 
 struct snic_reset_stats {
@@ -69,7 +70,9 @@ struct snic_fw_stats {
 struct snic_misc_stats {
 	u64	last_isr_time;
 	u64	last_ack_time;
-	atomic64_t isr_cnt;
+	atomic64_t ack_isr_cnt;
+	atomic64_t cmpl_isr_cnt;
+	atomic64_t errnotify_isr_cnt;
 	atomic64_t max_cq_ents;		/* Max CQ Entries */
 	atomic64_t data_cnt_mismat;	/* Data Count Mismatch */
 	atomic64_t io_tmo;
@@ -81,6 +84,9 @@ struct snic_misc_stats {
 	atomic64_t no_icmnd_itmf_cmpls;
 	atomic64_t io_under_run;
 	atomic64_t qfull;
+	atomic64_t qsz_rampup;
+	atomic64_t qsz_rampdown;
+	atomic64_t last_qsz;
 	atomic64_t tgt_not_rdy;
 };
 
@@ -101,9 +107,9 @@ static inline void
 snic_stats_update_active_ios(struct snic_stats *s_stats)
 {
 	struct snic_io_stats *io = &s_stats->io;
-	u32 nr_active_ios;
+	int nr_active_ios;
 
-	nr_active_ios = atomic64_inc_return(&io->active);
+	nr_active_ios = atomic64_read(&io->active);
 	if (atomic64_read(&io->max_active) < nr_active_ios)
 		atomic64_set(&io->max_active, nr_active_ios);
 
-- 
1.8.5.4

