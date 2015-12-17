From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH v2 13/16] qla2xxx: Disable ZIO at start time.
Date: Thu, 17 Dec 2015 14:57:08 -0500
Message-ID: <1450382231-4259-14-git-send-email-himanshu.madhani@qlogic.com>
References: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ac7a754..da35f51 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6544,10 +6544,21 @@ qlt_24xx_config_nvram_stage2(struct scsi_qla_host *vha,
 {
 	struct qla_hw_data *ha = vha->hw;
 
+	if (!QLA_TGT_MODE_ENABLED())
+		return;
+
 	if (ha->tgt.node_name_set) {
 		memcpy(icb->node_name, ha->tgt.tgt_node_name, WWN_SIZE);
 		icb->firmware_options_1 |= cpu_to_le32(BIT_14);
 	}
+
+	/* disable ZIO at start time. */
+	if (!vha->flags.init_done) {
+		uint32_t tmp;
+		tmp = le32_to_cpu(icb->firmware_options_2);
+		tmp &= ~(BIT_3 | BIT_2 | BIT_1 | BIT_0);
+		icb->firmware_options_2 = cpu_to_le32(tmp);
+	}
 }
 
 void
@@ -6638,6 +6649,15 @@ qlt_81xx_config_nvram_stage2(struct scsi_qla_host *vha,
 		memcpy(icb->node_name, ha->tgt.tgt_node_name, WWN_SIZE);
 		icb->firmware_options_1 |= cpu_to_le32(BIT_14);
 	}
+
+	/* disable ZIO at start time. */
+	if (!vha->flags.init_done) {
+		uint32_t tmp;
+		tmp = le32_to_cpu(icb->firmware_options_2);
+		tmp &= ~(BIT_3 | BIT_2 | BIT_1 | BIT_0);
+		icb->firmware_options_2 = cpu_to_le32(tmp);
+	}
+
 }
 
 void
-- 
1.7.7
