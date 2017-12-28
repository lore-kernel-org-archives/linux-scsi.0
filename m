From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 04/37] qla2xxx: Add boundary checks for exchanges to be offloaded
Date: Thu, 28 Dec 2017 12:33:12 -0800
Message-ID: <20171228203345.2702-5-himanshu.madhani@cavium.com>
References: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0081.outbound.protection.outlook.com ([104.47.41.81]:16143
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751220AbdL1Udz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Dec 2017 15:33:55 -0500
In-Reply-To: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Max boundary for exchange off load is 32k exchanges. If a system
is unable to allocate large memory buffer to support this feature,
then driver will reduce the number of exchanges down to a value
system can support.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  3 +++
 drivers/scsi/qla2xxx/qla_os.c  | 39 ++++++++++++++++++++++++++++++---------
 2 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 969a7dee9f72..043dd51a2760 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -288,6 +288,8 @@ struct name_list_extended {
 #define ATIO_ENTRY_CNT_24XX		4096	/* Number of ATIO entries. */
 #define RESPONSE_ENTRY_CNT_FX00		256     /* Number of response entries.*/
 #define FW_DEF_EXCHANGES_CNT 2048
+#define FW_MAX_EXCHANGES_CNT (32 * 1024)
+#define REDUCE_EXCHANGES_CNT  (8 * 1024)
 
 struct req_que;
 struct qla_tgt_sess;
@@ -3506,6 +3508,7 @@ struct qla_hw_data {
 		uint32_t	using_lr_setting:1;
 	} flags;
 
+	uint16_t max_exchg;
 	uint16_t long_range_distance;	/* 32G & above */
 #define LR_DISTANCE_5K  1
 #define LR_DISTANCE_10K 0
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 987bade1c606..029b95b2bd8a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2789,6 +2789,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->init_cb_size = sizeof(init_cb_t);
 	ha->link_data_rate = PORT_SPEED_UNKNOWN;
 	ha->optrom_size = OPTROM_SIZE_2300;
+	ha->max_exchg = FW_MAX_EXCHANGES_CNT;
 
 	/* Assign ISP specific operations. */
 	if (IS_QLA2100(ha)) {
@@ -4230,6 +4231,9 @@ qla2x00_number_of_exch(scsi_qla_host_t *vha, u32 *ret_cnt, u16 max_cnt)
 	u32 temp;
 	*ret_cnt = FW_DEF_EXCHANGES_CNT;
 
+	if (max_cnt > vha->hw->max_exchg)
+		max_cnt = vha->hw->max_exchg;
+
 	if (qla_ini_mode_enabled(vha)) {
 		if (ql2xiniexchg > max_cnt)
 			ql2xiniexchg = max_cnt;
@@ -4259,8 +4263,8 @@ int
 qla2x00_set_exchoffld_buffer(scsi_qla_host_t *vha)
 {
 	int rval;
-	u16 size, max_cnt;
-	u32 temp;
+	u16	size, max_cnt;
+	u32 actual_cnt, totsz;
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!ha->flags.exchoffld_enabled)
@@ -4277,16 +4281,19 @@ qla2x00_set_exchoffld_buffer(scsi_qla_host_t *vha)
 		return rval;
 	}
 
-	qla2x00_number_of_exch(vha, &temp, max_cnt);
-	temp *= size;
+	qla2x00_number_of_exch(vha, &actual_cnt, max_cnt);
+	ql_log(ql_log_info, vha, 0xd014,
+	    "Actual exchange offload count: %d.\n", actual_cnt);
+
+	totsz = actual_cnt * size;
 
-	if (temp != ha->exchoffld_size) {
+	if (totsz != ha->exchoffld_size) {
 		qla2x00_free_exchoffld_buffer(ha);
-		ha->exchoffld_size = temp;
+		ha->exchoffld_size = totsz;
 
 		ql_log(ql_log_info, vha, 0xd016,
-		    "Exchange offload: max_count=%d, buffers=0x%x, total=%d.\n",
-		    max_cnt, size, temp);
+		    "Exchange offload: max_count=%d, actual count=%d entry sz=0x%x, total sz=0x%x\n",
+		    max_cnt, actual_cnt, size, totsz);
 
 		ql_log(ql_log_info, vha, 0xd017,
 		    "Exchange Buffers requested size = 0x%x\n",
@@ -4297,7 +4304,21 @@ qla2x00_set_exchoffld_buffer(scsi_qla_host_t *vha)
 			ha->exchoffld_size, &ha->exchoffld_buf_dma, GFP_KERNEL);
 		if (!ha->exchoffld_buf) {
 			ql_log_pci(ql_log_fatal, ha->pdev, 0xd013,
-			"Failed to allocate memory for exchoffld_buf_dma.\n");
+			"Failed to allocate memory for Exchange Offload.\n");
+
+			if (ha->max_exchg >
+			    (FW_DEF_EXCHANGES_CNT + REDUCE_EXCHANGES_CNT)) {
+				ha->max_exchg -= REDUCE_EXCHANGES_CNT;
+			} else if (ha->max_exchg >
+			    (FW_DEF_EXCHANGES_CNT + 512)) {
+				ha->max_exchg -= 512;
+			} else {
+				ha->flags.exchoffld_enabled = 0;
+				ql_log_pci(ql_log_fatal, ha->pdev, 0xd013,
+				    "Disabling Exchange offload due to lack of memory\n");
+			}
+			ha->exchoffld_size = 0;
+
 			return -ENOMEM;
 		}
 	}
-- 
2.12.0
