From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 07/14] qla2xxx: Export DIF stats via debugfs
Date: Fri, 24 Feb 2017 13:37:36 -0800
Message-ID: <1487972263-3795-8-git-send-email-himanshu.madhani@cavium.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0045.outbound.protection.outlook.com ([104.47.42.45]:35337
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751292AbdBXViR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Feb 2017 16:38:17 -0500
In-Reply-To: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Anil Gurumurthy <anil.gurumurthy@cavium.com>

Signed-off-by: Anil Gurumurthy <anil.gurumurthy@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 12 ++++++++++++
 drivers/scsi/qla2xxx/qla_dfs.c | 15 +++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1fcd829..5e2f149 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3112,6 +3112,16 @@ struct qla_chip_state_84xx {
 	uint32_t gold_fw_version;
 };
 
+struct qla_dif_statistics {
+	uint64_t dif_input_bytes;
+	uint64_t dif_output_bytes;
+	uint64_t dif_input_requests;
+	uint64_t dif_output_requests;
+	uint32_t dif_guard_err;
+	uint32_t dif_ref_tag_err;
+	uint32_t dif_app_tag_err;
+};
+
 struct qla_statistics {
 	uint32_t total_isp_aborts;
 	uint64_t input_bytes;
@@ -3124,6 +3134,8 @@ struct qla_statistics {
 	uint32_t stat_max_pend_cmds;
 	uint32_t stat_max_qfull_cmds_alloc;
 	uint32_t stat_max_qfull_cmds_dropped;
+
+	struct qla_dif_statistics qla_dif_stats;
 };
 
 struct bidi_statistics {
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index dabeb8b..0252c2f 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -185,6 +185,21 @@
 	seq_printf(s, "num Q full sent = %lld\n",
 		vha->tgt_counters.num_q_full_sent);
 
+	/* DIF stats */
+	seq_printf(s, "DIF Inp Bytes = %lld\n",
+		vha->qla_stats.qla_dif_stats.dif_input_bytes);
+	seq_printf(s, "DIF Outp Bytes = %lld\n",
+		vha->qla_stats.qla_dif_stats.dif_output_bytes);
+	seq_printf(s, "DIF Inp Req = %lld\n",
+		vha->qla_stats.qla_dif_stats.dif_input_requests);
+	seq_printf(s, "DIF Outp Req = %lld\n",
+		vha->qla_stats.qla_dif_stats.dif_output_requests);
+	seq_printf(s, "DIF Guard err = %d\n",
+		vha->qla_stats.qla_dif_stats.dif_guard_err);
+	seq_printf(s, "DIF Ref tag err = %d\n",
+		vha->qla_stats.qla_dif_stats.dif_ref_tag_err);
+	seq_printf(s, "DIF App tag err = %d\n",
+		vha->qla_stats.qla_dif_stats.dif_app_tag_err);
 	return 0;
 }
 
-- 
1.8.3.1
