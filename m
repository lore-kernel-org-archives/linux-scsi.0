Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4EEDECAAD4
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Aug 2022 10:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343571AbiHZK0c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Aug 2022 06:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343629AbiHZK0Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2022 06:26:24 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405E8CD525
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:23 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q6TUeP001371
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=a0qjndoE0Op/GvBY6VIHk6QW5pN8Sr2ViIwQ4vWKiaA=;
 b=W70J8CIQnkz0NEfxv0XmYDDZu6rE6yXaowvEBqm7vEicCBniFSUPdoM5LKDi/E2EHPn+
 J9Ce/2uavIc8n2Wl2uBBYC8C8xO5zxc6Xwx/CKy19+jLMnWuti2denUMsoBqpAV6bH8i
 VfrSdxpkIKGzadQvNbjHguohp+287A1NBirpV52xWPp+OtU4WknpdSdFRsiDw9qSFGtY
 9UIh4+g5j/2fITga9KaRih0RZ7Wyc4UwA/2rzz0hgDRCdE1AxeOeAAXHE12ktvIxRfEI
 FuJr3r2WMq2LAr9OyunBOdWW7nHVF1WlMXMKNIzrbXqrLWzf7TKqHsxLMBrVIBWSijDf fQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3j5a67na2n-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 26 Aug
 2022 03:26:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 26 Aug 2022 03:26:19 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0F1493F70BA;
        Fri, 26 Aug 2022 03:26:18 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH v2 5/7] qla2xxx: Enhance driver tracing with separate tunable and more
Date:   Fri, 26 Aug 2022 03:25:57 -0700
Message-ID: <20220826102559.17474-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220826102559.17474-1-njavali@marvell.com>
References: <20220826102559.17474-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: _akUQi_sBhXPnmoLs_B0msPOcaXoiONa
X-Proofpoint-GUID: _akUQi_sBhXPnmoLs_B0msPOcaXoiONa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_04,2022-08-25_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Older tracing of driver messages was to:
    - log only debug messages to kernel main trace buffer AND
    - log only if extended logging bits corresponding to this
      message is off

This has been modified and extended as follows:
    - Tracing is now controlled via ql2xextended_error_logging_ktrace
      module parameter. Bit usages same as ql2xextended_error_logging.
    - Tracing uses "qla2xxx" trace instance, unless instance creation
      have issues.
    - Tracing is enabled (compile time tunable).
    - All driver messages, include debug and log messages are now traced
      in kernel trace buffer.

Trace messages can be viewed by looking at the qla2xxx instance at:
    /sys/kernel/tracing/instances/qla2xxx/trace

Trace tunable that takes the same bit mask as ql2xextended_error_logging
is:
    ql2xextended_error_logging_ktrace (default=1)

Suggested-by: Daniel Wagner <dwagner@suse.de>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 50 ++++++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_dbg.h | 43 +++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h |  1 +
 drivers/scsi/qla2xxx/qla_os.c  | 35 ++++++++++++++++++++++++
 4 files changed, 115 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 7cf1f78cbaee..d7e8454304ce 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2455,7 +2455,7 @@ qla83xx_fw_dump(scsi_qla_host_t *vha)
 /****************************************************************************/
 
 /* Write the debug message prefix into @pbuf. */
-static void ql_dbg_prefix(char *pbuf, int pbuf_size,
+static void ql_dbg_prefix(char *pbuf, int pbuf_size, struct pci_dev *pdev,
 			  const scsi_qla_host_t *vha, uint msg_id)
 {
 	if (vha) {
@@ -2464,6 +2464,9 @@ static void ql_dbg_prefix(char *pbuf, int pbuf_size,
 		/* <module-name> [<dev-name>]-<msg-id>:<host>: */
 		snprintf(pbuf, pbuf_size, "%s [%s]-%04x:%lu: ", QL_MSGHDR,
 			 dev_name(&(pdev->dev)), msg_id, vha->host_no);
+	} else if (pdev) {
+		snprintf(pbuf, pbuf_size, "%s [%s]-%04x: : ", QL_MSGHDR,
+			 dev_name(&pdev->dev), msg_id);
 	} else {
 		/* <module-name> [<dev-name>]-<msg-id>: : */
 		snprintf(pbuf, pbuf_size, "%s [%s]-%04x: : ", QL_MSGHDR,
@@ -2491,20 +2494,20 @@ ql_dbg(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...)
 	struct va_format vaf;
 	char pbuf[64];
 
-	if (!ql_mask_match(level) && !trace_ql_dbg_log_enabled())
+	ql_ktrace(1, level, pbuf, NULL, vha, id, fmt);
+
+	if (!ql_mask_match(level))
 		return;
 
+	if (!pbuf[0]) /* set by ql_ktrace */
+		ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL, vha, id);
+
 	va_start(va, fmt);
 
 	vaf.fmt = fmt;
 	vaf.va = &va;
 
-	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), vha, id);
-
-	if (!ql_mask_match(level))
-		trace_ql_dbg_log(pbuf, &vaf);
-	else
-		pr_warn("%s%pV", pbuf, &vaf);
+	pr_warn("%s%pV", pbuf, &vaf);
 
 	va_end(va);
 
@@ -2533,6 +2536,9 @@ ql_dbg_pci(uint level, struct pci_dev *pdev, uint id, const char *fmt, ...)
 
 	if (pdev == NULL)
 		return;
+
+	ql_ktrace(1, level, pbuf, pdev, NULL, id, fmt);
+
 	if (!ql_mask_match(level))
 		return;
 
@@ -2541,7 +2547,9 @@ ql_dbg_pci(uint level, struct pci_dev *pdev, uint id, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &va;
 
-	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL, id + ql_dbg_offset);
+	if (!pbuf[0]) /* set by ql_ktrace */
+		ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), pdev, NULL,
+			      id + ql_dbg_offset);
 	pr_warn("%s%pV", pbuf, &vaf);
 
 	va_end(va);
@@ -2570,7 +2578,10 @@ ql_log(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...)
 	if (level > ql_errlev)
 		return;
 
-	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), vha, id);
+	ql_ktrace(0, level, pbuf, NULL, vha, id, fmt);
+
+	if (!pbuf[0]) /* set by ql_ktrace */
+		ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL, vha, id);
 
 	va_start(va, fmt);
 
@@ -2621,7 +2632,10 @@ ql_log_pci(uint level, struct pci_dev *pdev, uint id, const char *fmt, ...)
 	if (level > ql_errlev)
 		return;
 
-	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL, id);
+	ql_ktrace(0, level, pbuf, pdev, NULL, id, fmt);
+
+	if (!pbuf[0]) /* set by ql_ktrace */
+		ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), pdev, NULL, id);
 
 	va_start(va, fmt);
 
@@ -2716,7 +2730,11 @@ ql_log_qp(uint32_t level, struct qla_qpair *qpair, int32_t id,
 	if (level > ql_errlev)
 		return;
 
-	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), qpair ? qpair->vha : NULL, id);
+	ql_ktrace(0, level, pbuf, NULL, qpair ? qpair->vha : NULL, id, fmt);
+
+	if (!pbuf[0]) /* set by ql_ktrace */
+		ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL,
+			      qpair ? qpair->vha : NULL, id);
 
 	va_start(va, fmt);
 
@@ -2762,6 +2780,8 @@ ql_dbg_qp(uint32_t level, struct qla_qpair *qpair, int32_t id,
 	struct va_format vaf;
 	char pbuf[128];
 
+	ql_ktrace(1, level, pbuf, NULL, qpair ? qpair->vha : NULL, id, fmt);
+
 	if (!ql_mask_match(level))
 		return;
 
@@ -2770,8 +2790,10 @@ ql_dbg_qp(uint32_t level, struct qla_qpair *qpair, int32_t id,
 	vaf.fmt = fmt;
 	vaf.va = &va;
 
-	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), qpair ? qpair->vha : NULL,
-		      id + ql_dbg_offset);
+	if (!pbuf[0]) /* set by ql_ktrace */
+		ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL,
+			      qpair ? qpair->vha : NULL, id + ql_dbg_offset);
+
 	pr_warn("%s%pV", pbuf, &vaf);
 
 	va_end(va);
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index feeb1666227f..70482b55d240 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -385,3 +385,46 @@ ql_mask_match(uint level)
 
 	return level && ((level & ql2xextended_error_logging) == level);
 }
+
+static inline int
+ql_mask_match_ext(uint level, int *log_tunable)
+{
+	if (*log_tunable == 1)
+		*log_tunable = QL_DBG_DEFAULT1_MASK;
+
+	return (level & *log_tunable) == level;
+}
+
+/* Assumes local variable pbuf and pbuf_ready present. */
+#define ql_ktrace(dbg_msg, level, pbuf, pdev, vha, id, fmt) do {	\
+	struct va_format _vaf;						\
+	va_list _va;							\
+	u32 dbg_off = dbg_msg ? ql_dbg_offset : 0;			\
+									\
+	pbuf[0] = 0;							\
+	if (!trace_ql_dbg_log_enabled())				\
+		break;							\
+									\
+	if (dbg_msg && !ql_mask_match_ext(level,			\
+				&ql2xextended_error_logging_ktrace))	\
+		break;							\
+									\
+	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), pdev, vha, id + dbg_off);	\
+									\
+	va_start(_va, fmt);						\
+	_vaf.fmt = fmt;							\
+	_vaf.va = &_va;							\
+									\
+	trace_ql_dbg_log(pbuf, &_vaf);					\
+									\
+	va_end(_va);							\
+} while (0)
+
+#define QLA_ENABLE_KERNEL_TRACING
+
+#ifdef QLA_ENABLE_KERNEL_TRACING
+#define QLA_TRACE_ENABLE(_tr) \
+	trace_array_set_clr_event(_tr, "qla", NULL, true)
+#else /* QLA_ENABLE_KERNEL_TRACING */
+#define QLA_TRACE_ENABLE(_tr)
+#endif /* QLA_ENABLE_KERNEL_TRACING */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index bb69fa8b956a..2fc280e61306 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -163,6 +163,7 @@ extern int ql2xrdpenable;
 extern int ql2xsmartsan;
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
+extern int ql2xextended_error_logging_ktrace;
 extern int ql2xiidmaenable;
 extern int ql2xmqsupport;
 extern int ql2xfwloadbin;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1c7fb6484db2..4a55c1e81327 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -15,6 +15,8 @@
 #include <linux/blk-mq-pci.h>
 #include <linux/refcount.h>
 #include <linux/crash_dump.h>
+#include <linux/trace_events.h>
+#include <linux/trace.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -35,6 +37,8 @@ static int apidev_major;
  */
 struct kmem_cache *srb_cachep;
 
+struct trace_array *qla_trc_array;
+
 int ql2xfulldump_on_mpifail;
 module_param(ql2xfulldump_on_mpifail, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql2xfulldump_on_mpifail,
@@ -117,6 +121,11 @@ MODULE_PARM_DESC(ql2xextended_error_logging,
 		"ql2xextended_error_logging=1).\n"
 		"\t\tDo LOGICAL OR of the value to enable more than one level");
 
+int ql2xextended_error_logging_ktrace = 1;
+module_param(ql2xextended_error_logging_ktrace, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(ql2xextended_error_logging_ktrace,
+		"Same BIT definiton as ql2xextended_error_logging, but used to control logging to kernel trace buffer (default=1).\n");
+
 int ql2xshiftctondsd = 6;
 module_param(ql2xshiftctondsd, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xshiftctondsd,
@@ -2839,6 +2848,27 @@ static void qla2x00_iocb_work_fn(struct work_struct *work)
 	spin_unlock_irqrestore(&vha->work_lock, flags);
 }
 
+static void
+qla_trace_init(void)
+{
+	qla_trc_array = trace_array_get_by_name("qla2xxx");
+	if (!qla_trc_array) {
+		ql_log(ql_log_fatal, NULL, 0x0001,
+		       "Unable to create qla2xxx trace instance, instance logging will be disabled.\n");
+		return;
+	}
+
+	QLA_TRACE_ENABLE(qla_trc_array);
+}
+
+static void
+qla_trace_uninit(void)
+{
+	if (!qla_trc_array)
+		return;
+	trace_array_put(qla_trc_array);
+}
+
 /*
  * PCI driver interface
  */
@@ -8181,6 +8211,8 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(sw_info_t) != 32);
 	BUILD_BUG_ON(sizeof(target_id_t) != 2);
 
+	qla_trace_init();
+
 	/* Allocate cache for SRBs. */
 	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
 	    SLAB_HWCACHE_ALIGN, NULL);
@@ -8259,6 +8291,8 @@ qla2x00_module_init(void)
 
 destroy_cache:
 	kmem_cache_destroy(srb_cachep);
+
+	qla_trace_uninit();
 	return ret;
 }
 
@@ -8277,6 +8311,7 @@ qla2x00_module_exit(void)
 	fc_release_transport(qla2xxx_transport_template);
 	qlt_exit();
 	kmem_cache_destroy(srb_cachep);
+	qla_trace_uninit();
 }
 
 module_init(qla2x00_module_init);
-- 
2.19.0.rc0

