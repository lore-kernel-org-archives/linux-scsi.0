Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBEEC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 06:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiGOGCq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 02:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiGOGCg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 02:02:36 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC20B7A53C
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:34 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26F1ifoA013575
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=zgOS0yBZ3xA72UvgJZ2lsFILTGx9fkGbWOJGG/H1kVo=;
 b=i3BjEx3FSQDUmLe4nciLlLPmTs2xgLqBSWX7D6Kupb8bOsPyC1sT8H1QdZRiHO12gXYN
 4JRGCLlru/FXBv3HwTqZ5Y5rdZ6y8yvQ5mAHKVotKcmrN+DWtL+SjVwxc8ryee+iyaHC
 hQ43lryUMHJ3fYpfV5GGjRfXZjTnuT3ND+KzmbCrOxC7fZVfqkk9uyOCSJ+zymZtxJh3
 UwB0sw8fEG0FaZem0RCN2AnQt75fQhx9C6mbtIQc1yI1Xrs3KIoOqdgDr3kkOtlQRT/N
 qbhA+a3PGenA9XrYWn6k2n0TuIeJEzcxDr71D72kDyacRBw0wSI4q0GOUftPWDRnZtOP Vw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3haxu9gkug-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Jul
 2022 23:02:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 Jul 2022 23:02:32 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9FDAE3F7072;
        Thu, 14 Jul 2022 23:02:32 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH 4/6] qla2xxx: Add srb tracing
Date:   Thu, 14 Jul 2022 23:02:25 -0700
Message-ID: <20220715060227.23923-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220715060227.23923-1-njavali@marvell.com>
References: <20220715060227.23923-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: B3s9v5QdRfDW4vU5Bt5PJKY6Y3LPjowo
X-Proofpoint-GUID: B3s9v5QdRfDW4vU5Bt5PJKY6Y3LPjowo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_02,2022-07-14_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Add a separate driver internal trace to capture srb
related info. The debugfs file is:
	/sys/kernel/debug/qla2xxx/qla2xxx_<host#>/srb_trace

Like message trace, enable/disable/resize operations are possible
by writing:
            enable/disable/resize=<nlines>
..to the debugfs file.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dbg.h    | 67 +++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h    | 17 +++++---
 drivers/scsi/qla2xxx/qla_dfs.c    | 17 ++++++++
 drivers/scsi/qla2xxx/qla_inline.h | 12 ++++++
 drivers/scsi/qla2xxx/qla_iocb.c   |  4 ++
 drivers/scsi/qla2xxx/qla_isr.c    |  5 +++
 drivers/scsi/qla2xxx/qla_os.c     | 28 +++++++++++++
 7 files changed, 144 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 9704cb13aacf..056fbdbc6794 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -342,6 +342,22 @@ extern uint ql_errlev;
 extern int ql2xnum_msg_trace;
 extern int ql2xextended_error_logging_msg_trace;
 
+#define QLA_SRB_TRACE_DEFINES \
+	int ql2xextended_error_logging_srb_trace = 1; \
+	module_param(ql2xextended_error_logging_srb_trace, int, \
+						S_IRUGO|S_IWUSR); \
+	MODULE_PARM_DESC(ql2xextended_error_logging_srb_trace, \
+		"Option to log srb messages to buffer; uses same " \
+			"ql2xextended_error_logging masks."); \
+	\
+	int ql2xnum_srb_trace = 0;	\
+	module_param(ql2xnum_srb_trace, int, S_IRUGO);	\
+	MODULE_PARM_DESC(ql2xnum_srb_trace, \
+		"Number of srb trace entries in power of 2. (default 0)");
+
+extern int ql2xnum_srb_trace;
+extern int ql2xextended_error_logging_srb_trace;
+
 extern struct qla_trace qla_message_trace;
 extern void qla_tracing_init(void);
 extern void qla_tracing_exit(void);
@@ -495,6 +511,57 @@ __ql_msg_trace(struct qla_trace *trc, scsi_qla_host_t *vha,
 	qla_trace_put(trc);
 }
 
+#define ql_srb_trace_ext(_level, _vha, _fcport, _fmt, _args...) do {	\
+	if (_fcport) {							\
+		__ql_srb_trace(_level, _vha,				\
+			DBG_FCPORT_PRFMT(_fcport, _fmt, ##_args));	\
+	} else {							\
+		__ql_srb_trace(_level, _vha,				\
+			"%s: " _fmt "\n", __func__, ##_args);		\
+	}								\
+} while (0)
+
+#define ql_srb_trace(_level, _vha, _fmt, _args...) \
+	__ql_srb_trace(_level, _vha, _fmt, ##_args)
+
+static inline void
+__ql_srb_trace(int level, scsi_qla_host_t *vha, const char *fmt, ...)
+{
+	int tl;
+	char *buf;
+	u64 t_us;
+	uint cpu;
+	struct va_format vaf;
+	va_list va;
+
+	if (!test_bit(QLA_TRACE_ENABLED, &vha->hw->srb_trace.flags))
+		return;
+
+	if (!ql_mask_match_ext(level, &ql2xextended_error_logging_srb_trace))
+		return;
+
+	t_us = ktime_to_us(ktime_get());
+	cpu = raw_smp_processor_id();
+	buf = qla_get_trace_next(&vha->hw->srb_trace);
+	if (!buf)
+		return;
+
+	va_start(va, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &va;
+
+	tl = snprintf(buf, QLA_TRACE_LINE_SIZE, "%12llu %03u %pV",
+			t_us, cpu, &vaf);
+
+	tl = min(tl, QLA_TRACE_LINE_SIZE - 1);
+	buf[tl] = '\0';
+
+	qla_trace_put(&vha->hw->srb_trace);
+
+	va_end(va);
+}
+
 static inline void
 qla_trace_init(struct qla_trace *trc, char *name, u32 num_entries)
 {
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 39322105e7be..e1528a4e6ee4 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4793,6 +4793,11 @@ struct qla_hw_data {
 	spinlock_t sadb_lock;	/* protects list */
 	struct els_reject elsrej;
 	u8 edif_post_stop_cnt_down;
+
+#ifdef QLA_TRACING
+	QLA_DFS_DEFINE_DENTRY(srb_trace);
+	struct qla_trace srb_trace;
+#endif /* QLA_TRACING */
 };
 
 #define RX_ELS_SIZE (roundup(sizeof(struct enode) + ELS_MAX_PAYLOAD, SMP_CACHE_BYTES))
@@ -5493,6 +5498,12 @@ struct ql_vnd_tgt_stats_resp {
 	struct ql_vnd_stats stats;
 } __packed;
 
+#define DBG_FCPORT_PRFMT(_fp, _fmt, _args...) \
+	"%s: %8phC: " _fmt " (state=%d disc_state=%d scan_state=%d loopid=0x%x deleted=%d flags=0x%x)\n", \
+	__func__, _fp->port_name, ##_args, atomic_read(&_fp->state), \
+	_fp->disc_state, _fp->scan_state, _fp->loop_id, _fp->deleted, \
+	_fp->flags
+
 #include "qla_target.h"
 #include "qla_gbl.h"
 #include "qla_dbg.h"
@@ -5501,10 +5512,4 @@ struct ql_vnd_tgt_stats_resp {
 #define IS_SESSION_DELETED(_fcport) (_fcport->disc_state == DSC_DELETE_PEND || \
 				      _fcport->disc_state == DSC_DELETED)
 
-#define DBG_FCPORT_PRFMT(_fp, _fmt, _args...) \
-	"%s: %8phC: " _fmt " (state=%d disc_state=%d scan_state=%d loopid=0x%x deleted=%d flags=0x%x)\n", \
-	__func__, _fp->port_name, ##_args, atomic_read(&_fp->state), \
-	_fp->disc_state, _fp->scan_state, _fp->loop_id, _fp->deleted, \
-	_fp->flags
-
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index d3f9f6af43f2..806cb4afcb30 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -599,12 +599,26 @@ qla_dfs_message_trace_show(struct seq_file *s, void *unused)
 {
 	return qla_dfs_trace_show(s, unused);
 }
+
 static ssize_t
 qla_dfs_message_trace_write(struct file *file, const char __user *buffer,
 	size_t count, loff_t *pos)
 {
 	return qla_dfs_trace_write(file, buffer, count, pos);
 }
+
+static int
+qla_dfs_srb_trace_show(struct seq_file *s, void *unused)
+{
+	return qla_dfs_trace_show(s, unused);
+}
+
+static ssize_t
+qla_dfs_srb_trace_write(struct file *file, const char __user *buffer,
+	size_t count, loff_t *pos)
+{
+	return qla_dfs_trace_write(file, buffer, count, pos);
+}
 #endif /* QLA_TRACING */
 
 /*
@@ -699,6 +713,7 @@ static const struct file_operations qla_dfs_##_name##_ops = {		\
 
 #ifdef QLA_TRACING
 QLA_DFS_SETUP_RW(message_trace, struct qla_trace *);
+QLA_DFS_SETUP_RW(srb_trace, struct qla_trace *);
 #endif /* QLA_TRACING */
 
 static int
@@ -811,6 +826,7 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 #ifdef QLA_TRACING
 	QLA_DFS_ROOT_CREATE_FILE(message_trace, 0600, &qla_message_trace);
 
+	QLA_DFS_CREATE_FILE(ha, srb_trace, 0600, ha->dfs_dir, &ha->srb_trace);
 #endif /* QLA_TRACING */
 
 	if (IS_QLA27XX(ha) || IS_QLA83XX(ha) || IS_QLA28XX(ha)) {
@@ -875,6 +891,7 @@ qla2x00_dfs_remove(scsi_qla_host_t *vha)
 #ifdef QLA_TRACING
 	QLA_DFS_ROOT_REMOVE_FILE(message_trace);
 
+	QLA_DFS_REMOVE_FILE(ha, srb_trace);
 #endif /* QLA_TRACING */
 
 	if (ha->dfs_dir) {
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index db17f7f410cd..19f334693a38 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -201,6 +201,10 @@ qla2xxx_get_qpair_sp(scsi_qla_host_t *vha, struct qla_qpair *qpair,
 		return NULL;
 
 	sp = mempool_alloc(qpair->srb_mempool, flag);
+	/* Avoid trace for calls from qla2x00_get_sp */
+	if (vha->hw->base_qpair != qpair)
+		ql_srb_trace_ext(ql_dbg_io, vha, fcport,
+			"sp=%px", sp);
 	if (sp)
 		qla2xxx_init_sp(sp, vha, qpair, fcport);
 	else
@@ -214,6 +218,10 @@ void qla2xxx_rel_free_warning(srb_t *sp);
 static inline void
 qla2xxx_rel_qpair_sp(struct qla_qpair *qpair, srb_t *sp)
 {
+	/* Avoid trace for calls from qla2x00_get_sp */
+	if (qpair->vha->hw->base_qpair != qpair)
+		ql_srb_trace_ext(ql_dbg_io, sp->vha, sp->fcport,
+			"sp=%px type=%d", sp, sp->type);
 	sp->qpair = NULL;
 	sp->done = qla2xxx_rel_done_warning;
 	sp->free = qla2xxx_rel_free_warning;
@@ -234,6 +242,7 @@ qla2x00_get_sp(scsi_qla_host_t *vha, fc_port_t *fcport, gfp_t flag)
 
 	qpair = vha->hw->base_qpair;
 	sp = qla2xxx_get_qpair_sp(vha, qpair, fcport, flag);
+	ql_srb_trace_ext(ql_dbg_disc, vha, fcport, "sp=%px", sp);
 	if (!sp)
 		goto done;
 
@@ -247,6 +256,9 @@ qla2x00_get_sp(scsi_qla_host_t *vha, fc_port_t *fcport, gfp_t flag)
 static inline void
 qla2x00_rel_sp(srb_t *sp)
 {
+	ql_srb_trace_ext(ql_dbg_disc, sp->vha, sp->fcport,
+		"sp=%px type=%d", sp, sp->type);
+
 	QLA_VHA_MARK_NOT_BUSY(sp->vha);
 	qla2xxx_rel_qpair_sp(sp->qpair, sp);
 }
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 42ce4e1fe744..4fe569ef27ae 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3826,6 +3826,10 @@ qla2x00_start_sp(srb_t *sp)
 	if (vha->hw->flags.eeh_busy)
 		return -EIO;
 
+	ql_srb_trace_ext(ql_dbg_disc, vha, sp->fcport,
+			"caller=%ps sp=%px type=%d",
+			__builtin_return_address(0), sp, sp->type);
+
 	spin_lock_irqsave(qp->qp_lock_ptr, flags);
 	pkt = __qla2x00_alloc_iocbs(sp->qpair, sp);
 	if (!pkt) {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 76e79f350a22..af368d3beeab 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3197,6 +3197,11 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		}
 		return;
 	}
+
+	ql_srb_trace_ext(ql_dbg_io, vha, sp->fcport,
+			 "sp=%px handle=0x%x type=%d done=%ps",
+			 sp, sp->handle, sp->type, sp->done);
+
 	qla_put_iocbs(sp->qpair, &sp->iores);
 
 	if (sp->cmd_type != TYPE_SRB) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b937283f5e53..4f9d2c1680c1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -119,6 +119,8 @@ MODULE_PARM_DESC(ql2xextended_error_logging,
 
 QLA_MESSAGE_TRACE_DEFINES;
 
+QLA_SRB_TRACE_DEFINES;
+
 int ql2xshiftctondsd = 6;
 module_param(ql2xshiftctondsd, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xshiftctondsd,
@@ -752,6 +754,10 @@ void qla2x00_sp_compl(srb_t *sp, int res)
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	struct completion *comp = sp->comp;
 
+	ql_srb_trace_ext(ql_dbg_io, sp->vha, sp->fcport,
+			 "sp=%px handle=0x%x cmd=%px res=%x",
+			 sp, sp->handle, cmd, res);
+
 	/* kref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	cmd->result = res;
@@ -844,6 +850,10 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	struct completion *comp = sp->comp;
 
+	ql_srb_trace_ext(ql_dbg_io, sp->vha, sp->fcport,
+			 "sp=%px handle=0x%x cmd=%px res=%x",
+			 sp, sp->handle, cmd, res);
+
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	cmd->result = res;
@@ -870,6 +880,10 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		goto qc24_fail_command;
 	}
 
+	ql_srb_trace_ext(ql_dbg_io, fcport->vha, fcport,
+		"cmd=%px mq=%d remchk=0x%x",
+		cmd, ha->mqenable, fc_remote_port_chkready(rport));
+
 	if (ha->mqenable) {
 		uint32_t tag;
 		uint16_t hwq;
@@ -877,6 +891,10 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 		tag = blk_mq_unique_tag(scsi_cmd_to_rq(cmd));
 		hwq = blk_mq_unique_tag_to_hwq(tag);
+
+		ql_srb_trace_ext(ql_dbg_io, fcport->vha, fcport,
+				 "tag=%px hwq=%d", tag, hwq);
+
 		qpair = ha->queue_pair_map[hwq];
 
 		if (qpair)
@@ -1298,6 +1316,10 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 	vha->cmd_timeout_cnt++;
 
+	ql_srb_trace_ext(ql_dbg_io, sp->vha, sp->fcport,
+			 "sp=%px cmd=%px fast_fail_sts=0x%x",
+			 sp, cmd, fast_fail_status);
+
 	if ((sp->fcport && sp->fcport->deleted) || !qpair)
 		return fast_fail_status != SUCCESS ? fast_fail_status : FAILED;
 
@@ -3528,6 +3550,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ql_dbg(ql_dbg_init, base_vha, 0x00f2,
 	    "Init done and hba is online.\n");
 
+	qla_trace_init(&ha->srb_trace, "srb_trace", ql2xnum_srb_trace);
+
 	if (qla_ini_mode_enabled(base_vha) ||
 		qla_dual_mode_enabled(base_vha))
 		scsi_scan_host(host);
@@ -3600,6 +3624,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	rsp = NULL;
 
 probe_hw_failed:
+	qla_trace_uninit(&ha->srb_trace);
+
 	qla2x00_mem_free(ha);
 	qla2x00_free_req_que(ha, req);
 	qla2x00_free_rsp_que(ha, rsp);
@@ -3883,6 +3909,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	qla2x00_delete_all_vps(ha, base_vha);
 
+	qla_trace_uninit(&ha->srb_trace);
+
 	qla2x00_dfs_remove(base_vha);
 
 	qla84xx_put_chip(base_vha);
-- 
2.19.0.rc0

