From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 07/14] qla2xxx: Export DIF stats via debugfs
Date: Fri, 3 Feb 2017 14:40:48 -0800
Message-ID: <1486161655-2307-8-git-send-email-himanshu.madhani@cavium.com>
References: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Anil Gurumurthy <anil.gurumurthy@cavium.com>

Signed-off-by: Anil Gurumurthy <anil.gurumurthy@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 12 ++++++++++++
 drivers/scsi/qla2xxx/qla_dfs.c | 15 +++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d6436fc..a15614d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3129,6 +3129,16 @@ struct qla_chip_state_84xx {
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
@@ -3141,6 +3151,8 @@ struct qla_statistics {
 	uint32_t stat_max_pend_cmds;
 	uint32_t stat_max_qfull_cmds_alloc;
 	uint32_t stat_max_qfull_cmds_dropped;
+
+	struct qla_dif_statistics qla_dif_stats;
 };
 
 struct bidi_statistics {
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 0fb33e6..989e17b 100644
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
