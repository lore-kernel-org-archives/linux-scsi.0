Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B188C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 06:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiGOGCm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 02:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiGOGCi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 02:02:38 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BDF7A536
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:36 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EMB5Z8009903
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=aMsiJr7gIGzkLBNAywjHJEYWs+/665M5djfLk+Lthxc=;
 b=b1iAGvYp3rKj8TCbClEr3trIGSYx3ngLmWXwdTl8kND/EJsFvfpckX33vTX92BG5No2m
 J/+bn5QZ/DXWOIMduH/gXng/XvxQletKT+cfcuTzLKCN5uf+k9mWv1IviwX/e8M09WSc
 /NmDvIQKplZQpAJ6LSPK0DPzrSN1B13LvnSGsZSviznPHeCnJw54MRYWNAjUabOgXJ8e
 eVwXMABDzgs1dQvr7zpNmj51T5EchSA3bN3PqUb+s67Es2hz+BRzQsocubS02YLXL48g
 VQbCSlQT0eLifoRSLuSkHYduqcISyrlCarkfXLBLkAC0qc3jXHIXIz0Ut2duRagVg2ph ZQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h9udu8g1u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:35 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 Jul
 2022 23:02:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 14 Jul 2022 23:02:32 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7B6473F7065;
        Thu, 14 Jul 2022 23:02:32 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH 3/6] qla2xxx: Add driver console messages tracing
Date:   Thu, 14 Jul 2022 23:02:24 -0700
Message-ID: <20220715060227.23923-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220715060227.23923-1-njavali@marvell.com>
References: <20220715060227.23923-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: B4xt4DN73wNvor2OaxFwz2jhY8Sl5yPz
X-Proofpoint-ORIG-GUID: B4xt4DN73wNvor2OaxFwz2jhY8Sl5yPz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_02,2022-07-14_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Driver messages, using the default log settings of 1 are captured
by default in an internal trace buffer.
Traces can be read from:
	/sys/kernel/debug/qla2xxx/message_trace

Enable/disable/resize operations are possible by writing
enable/disable/resize=<nlines> to the debugfs file.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 14 +++++-
 drivers/scsi/qla2xxx/qla_dbg.h | 79 ++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_dfs.c | 30 +++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h |  1 +
 drivers/scsi/qla2xxx/qla_os.c  |  2 +
 5 files changed, 125 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index c4ba8ac51d27..3d12a5bf54b9 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -68,7 +68,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/qla.h>
 
-static uint32_t ql_dbg_offset = 0x800;
+uint32_t ql_dbg_offset = 0x800;
 
 static inline void
 qla2xxx_prep_dump(struct qla_hw_data *ha, struct qla2xxx_fw_dump *fw_dump)
@@ -2491,6 +2491,8 @@ ql_dbg(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...)
 	struct va_format vaf;
 	char pbuf[64];
 
+	ql_msg_trace(1, level, vha, NULL, id, fmt);
+
 	if (!ql_mask_match(level) && !trace_ql_dbg_log_enabled())
 		return;
 
@@ -2533,6 +2535,9 @@ ql_dbg_pci(uint level, struct pci_dev *pdev, uint id, const char *fmt, ...)
 
 	if (pdev == NULL)
 		return;
+
+	ql_msg_trace(1, level, NULL, pdev, id, fmt);
+
 	if (!ql_mask_match(level))
 		return;
 
@@ -2570,6 +2575,8 @@ ql_log(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...)
 	if (level > ql_errlev)
 		return;
 
+	ql_msg_trace(0, level, vha, NULL, id, fmt);
+
 	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), vha, id);
 
 	va_start(va, fmt);
@@ -2621,6 +2628,8 @@ ql_log_pci(uint level, struct pci_dev *pdev, uint id, const char *fmt, ...)
 	if (level > ql_errlev)
 		return;
 
+	ql_msg_trace(0, level, NULL, pdev, id, fmt);
+
 	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL, id);
 
 	va_start(va, fmt);
@@ -2783,9 +2792,12 @@ void qla_tracing_init(void)
 {
 	if (is_kdump_kernel())
 		return;
+
+	qla_trace_init(&qla_message_trace, "message_trace", ql2xnum_msg_trace);
 }
 
 void qla_tracing_exit(void)
 {
+	qla_trace_uninit(&qla_message_trace);
 }
 #endif /* QLA_TRACING */
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index e0d91a1f81c0..9704cb13aacf 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -325,6 +325,24 @@ extern uint ql_errlev;
 #ifdef QLA_TRACING
 #include <linux/crash_dump.h>
 
+#define QLA_MTRC_DEF_NUM_REC		(4*1024) /* Has to be power of 2 */
+#define QLA_MESSAGE_TRACE_DEFINES \
+	struct qla_trace qla_message_trace;	\
+	int ql2xextended_error_logging_msg_trace = 1; \
+	module_param(ql2xextended_error_logging_msg_trace, int, 0600); \
+	MODULE_PARM_DESC(ql2xextended_error_logging_msg_trace, \
+		"Option to log console messages to buffer; uses same " \
+			"ql2xextended_error_logging masks."); \
+	\
+	int ql2xnum_msg_trace = QLA_MTRC_DEF_NUM_REC;	\
+	module_param(ql2xnum_msg_trace, int, 0600);	\
+	MODULE_PARM_DESC(ql2xnum_msg_trace, \
+		"Number of trace entries in power of 2. (default 4k)");
+
+extern int ql2xnum_msg_trace;
+extern int ql2xextended_error_logging_msg_trace;
+
+extern struct qla_trace qla_message_trace;
 extern void qla_tracing_init(void);
 extern void qla_tracing_exit(void);
 
@@ -422,6 +440,61 @@ qla_trace_quiesce(struct qla_trace *trc)
 	return ret;
 }
 
+#define ql_msg_trace(dbg_msg, level, vha, pdev, id, fmt) do {		\
+	struct va_format _vaf;						\
+	va_list _va;							\
+	u32 dbg_off = dbg_msg ? ql_dbg_offset : 0;			\
+									\
+	if (!test_bit(QLA_TRACE_ENABLED, &qla_message_trace.flags))	\
+		break;							\
+									\
+	if (dbg_msg && !ql_mask_match_ext(level,			\
+				&ql2xextended_error_logging_msg_trace))	\
+		break;							\
+									\
+	va_start(_va, fmt);						\
+									\
+	_vaf.fmt = fmt;							\
+	_vaf.va = &_va;							\
+	__ql_msg_trace(&qla_message_trace, vha, pdev,			\
+						id + dbg_off, &_vaf);	\
+									\
+	va_end(_va);							\
+} while (0)
+
+/* Messages beyond QLA_TRACE_LINE_SIZE characters are not printed */
+static inline void
+__ql_msg_trace(struct qla_trace *trc, scsi_qla_host_t *vha,
+		struct pci_dev *pdev, uint id, struct va_format *vaf)
+{
+	int tl;
+	char *buf;
+	u64 t_us = ktime_to_us(ktime_get());
+	uint cpu = raw_smp_processor_id();
+
+	buf = qla_get_trace_next(trc);
+	if (!buf)
+		return;
+
+	if (vha) {
+		const struct pci_dev *_pdev = vha->hw->pdev;
+		tl = snprintf(buf, QLA_TRACE_LINE_SIZE,
+			"%12llu %03u %s [%s]-%04x:%ld: %pV", t_us, cpu,
+			QL_MSGHDR, dev_name(&(_pdev->dev)), id,
+			vha->host_no, vaf);
+	} else {
+		tl = snprintf(buf, QLA_TRACE_LINE_SIZE,
+			"%12llu %03u %s [%s]-%04x: : %pV", t_us, cpu, QL_MSGHDR,
+			pdev ? dev_name(&(pdev->dev)) : "0000:00:00.0",
+			id, vaf);
+	}
+
+	tl = min(tl, QLA_TRACE_LINE_SIZE - 1);
+	buf[tl] = '\0';
+
+	qla_trace_put(trc);
+}
+
 static inline void
 qla_trace_init(struct qla_trace *trc, char *name, u32 num_entries)
 {
@@ -455,10 +528,16 @@ qla_trace_uninit(struct qla_trace *trc)
 }
 
 #else /* QLA_TRACING */
+#define ql_msg_trace(dbg_msg, level, vha, pdev, id, fmt) do { } while (0)
 #define qla_trace_init(trc, name, num)
 #define qla_trace_uninit(trc)
 #define qla_tracing_init()
 #define qla_tracing_exit()
+#define QLA_MESSAGE_TRACE_DEFINES
+
+#define ql_srb_trace_ext(_level, _vha, _fcport, _fmt, _args...) do { } while (0)
+#define ql_srb_trace(_level, _vha, _fmt, _args...) do { } while (0)
+#define QLA_SRB_TRACE_DEFINES
 #endif /* QLA_TRACING */
 
 void __attribute__((format (printf, 4, 5)))
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 98c6390ad1f1..d3f9f6af43f2 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -11,6 +11,10 @@
 static struct dentry *qla2x00_dfs_root;
 static atomic_t qla2x00_dfs_root_count;
 
+#ifdef QLA_TRACING
+static QLA_DFS_ROOT_DEFINE_DENTRY(message_trace); /* qla_dfs_message_trace */
+#endif /* QLA_TRACING */
+
 #define QLA_DFS_RPORT_DEVLOSS_TMO	1
 
 static int
@@ -589,6 +593,18 @@ qla_dfs_trace_write(struct file *file, const char __user *buffer,
 done:
 	return ret;
 }
+
+static int
+qla_dfs_message_trace_show(struct seq_file *s, void *unused)
+{
+	return qla_dfs_trace_show(s, unused);
+}
+static ssize_t
+qla_dfs_message_trace_write(struct file *file, const char __user *buffer,
+	size_t count, loff_t *pos)
+{
+	return qla_dfs_trace_write(file, buffer, count, pos);
+}
 #endif /* QLA_TRACING */
 
 /*
@@ -681,6 +697,10 @@ static const struct file_operations qla_dfs_##_name##_ops = {		\
 		}							\
 	} while (0)
 
+#ifdef QLA_TRACING
+QLA_DFS_SETUP_RW(message_trace, struct qla_trace *);
+#endif /* QLA_TRACING */
+
 static int
 qla_dfs_naqp_open(struct inode *inode, struct file *file)
 {
@@ -788,6 +808,11 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 	ha->tgt.dfs_tgt_sess = debugfs_create_file("tgt_sess",
 		S_IRUSR, ha->dfs_dir, vha, &qla2x00_dfs_tgt_sess_fops);
 
+#ifdef QLA_TRACING
+	QLA_DFS_ROOT_CREATE_FILE(message_trace, 0600, &qla_message_trace);
+
+#endif /* QLA_TRACING */
+
 	if (IS_QLA27XX(ha) || IS_QLA83XX(ha) || IS_QLA28XX(ha)) {
 		ha->tgt.dfs_naqp = debugfs_create_file("naqp",
 		    0400, ha->dfs_dir, vha, &dfs_naqp_ops);
@@ -847,6 +872,11 @@ qla2x00_dfs_remove(scsi_qla_host_t *vha)
 		vha->dfs_rport_root = NULL;
 	}
 
+#ifdef QLA_TRACING
+	QLA_DFS_ROOT_REMOVE_FILE(message_trace);
+
+#endif /* QLA_TRACING */
+
 	if (ha->dfs_dir) {
 		debugfs_remove(ha->dfs_dir);
 		ha->dfs_dir = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5dd2932382ee..8c149a3482cb 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -163,6 +163,7 @@ extern int ql2xrdpenable;
 extern int ql2xsmartsan;
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
+extern uint32_t ql_dbg_offset;
 extern int ql2xiidmaenable;
 extern int ql2xmqsupport;
 extern int ql2xfwloadbin;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0d2397069cac..b937283f5e53 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -117,6 +117,8 @@ MODULE_PARM_DESC(ql2xextended_error_logging,
 		"ql2xextended_error_logging=1).\n"
 		"\t\tDo LOGICAL OR of the value to enable more than one level");
 
+QLA_MESSAGE_TRACE_DEFINES;
+
 int ql2xshiftctondsd = 6;
 module_param(ql2xshiftctondsd, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xshiftctondsd,
-- 
2.19.0.rc0

