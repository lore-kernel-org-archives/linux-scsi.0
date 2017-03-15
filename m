From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 08/14] qla2xxx: Export DIF stats via debugfs
Date: Wed, 15 Mar 2017 09:48:50 -0700
Message-ID: <20170315164856.17255-9-himanshu.madhani@cavium.com>
References: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0086.outbound.protection.outlook.com ([104.47.42.86]:35545
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753117AbdCOQt1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 12:49:27 -0400
In-Reply-To: <20170315164856.17255-1-himanshu.madhani@cavium.com>
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
index 9d1d3dcf1c87..8228dfac6a31 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3108,6 +3108,16 @@ struct qla_chip_state_84xx {
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
@@ -3120,6 +3130,8 @@ struct qla_statistics {
 	uint32_t stat_max_pend_cmds;
 	uint32_t stat_max_qfull_cmds_alloc;
 	uint32_t stat_max_qfull_cmds_dropped;
+
+	struct qla_dif_statistics qla_dif_stats;
 };
 
 struct bidi_statistics {
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index b48cce696bac..3b35905619b0 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -114,6 +114,21 @@ qla_dfs_tgt_counters_show(struct seq_file *s, void *unused)
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
2.12.0
