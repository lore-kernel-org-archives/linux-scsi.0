From: John Garry <john.garry@huawei.com>
Subject: [PATCH 11/19] scsi: hisi_sas: report v2 hw AXI errors to userspace
Date: Tue, 24 Oct 2017 23:51:41 +0800
Message-ID: <1508860309-212397-12-git-send-email-john.garry@huawei.com>
References: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:9047 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbdJXPJR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2017 11:09:17 -0400
In-Reply-To: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Shiju Jose <shiju.jose@huawei.com>, John Garry <john.garry@huawei.com>

From: Shiju Jose <shiju.jose@huawei.com>

This patch adds reporting of AXI errors in the SAS v2 hw
driver to userspace as non-standard trace events.

rasdaemon can be used to read and log these AXI errors
in userspace.

Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 54 +++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 0cf8244..8626d9f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -389,6 +389,13 @@
 #define HISI_SAS_ECC_ERR_HGC_RXM_MEM1	BIT(7)
 #define HISI_SAS_ECC_ERR_HGC_RXM_MEM2	BIT(8)
 #define HISI_SAS_ECC_ERR_HGC_RXM_MEM3	BIT(9)
+#define HISI_SAS_ERR_WP_DEPTH		BIT(10)
+#define HISI_SAS_ERR_IPTT_SLOT_NOMATCH	BIT(11)
+#define HISI_SAS_ERR_RP_DEPTH		BIT(12)
+#define HISI_SAS_ERR_AXI		BIT(13)
+#define HISI_SAS_ERR_FIFO		BIT(14)
+#define HISI_SAS_ERR_LM_ADD_FETCH_LIST	BIT(15)
+#define HISI_SAS_ERR_HGC_ABT_FETCH_LM	BIT(16)
 
 struct hisi_sas_complete_v2_hdr {
 	__le32 dw0;
@@ -417,6 +424,7 @@ struct hisi_sas_hw_err_info {
 	u64   physical_addr;
 	u32   mb_err;
 	u32   type;
+	u32   axi_err_info;
 };
 
 static const struct hisi_sas_hw_error one_bit_ecc_errors[] = {
@@ -748,6 +756,7 @@ enum {
 #define HISI_SAS_VALID_PA		BIT(0)
 #define HISI_SAS_VALID_MB_ERR		BIT(1)
 #define HISI_SAS_VALID_ERR_TYPE		BIT(2)
+#define HISI_SAS_VALID_AXI_ERR_INFO	BIT(3)
 
 #define ERR_ON_TX_PHASE(err_phase) (err_phase == 0x2 || \
 		err_phase == 0x4 || err_phase == 0x8 ||\
@@ -3052,32 +3061,39 @@ static irqreturn_t fatal_ecc_int_v2_hw(int irq_no, void *p)
 	{
 		.irq_msk = BIT(ENT_INT_SRC3_WP_DEPTH_OFF),
 		.msg = "write pointer and depth",
+		.type = HISI_SAS_ERR_WP_DEPTH,
 	},
 	{
 		.irq_msk = BIT(ENT_INT_SRC3_IPTT_SLOT_NOMATCH_OFF),
 		.msg = "iptt no match slot",
+		.type = HISI_SAS_ERR_IPTT_SLOT_NOMATCH,
 	},
 	{
 		.irq_msk = BIT(ENT_INT_SRC3_RP_DEPTH_OFF),
 		.msg = "read pointer and depth",
+		.type = HISI_SAS_ERR_RP_DEPTH,
 	},
 	{
 		.irq_msk = BIT(ENT_INT_SRC3_AXI_OFF),
 		.reg = HGC_AXI_FIFO_ERR_INFO,
+		.type = HISI_SAS_ERR_AXI,
 		.sub = axi_error,
 	},
 	{
 		.irq_msk = BIT(ENT_INT_SRC3_FIFO_OFF),
 		.reg = HGC_AXI_FIFO_ERR_INFO,
+		.type = HISI_SAS_ERR_FIFO,
 		.sub = fifo_error,
 	},
 	{
 		.irq_msk = BIT(ENT_INT_SRC3_LM_OFF),
 		.msg = "LM add/fetch list",
+		.type = HISI_SAS_ERR_LM_ADD_FETCH_LIST,
 	},
 	{
 		.irq_msk = BIT(ENT_INT_SRC3_ABT_OFF),
 		.msg = "SAS_HGC_ABT fetch LM list",
+		.type = HISI_SAS_ERR_HGC_ABT_FETCH_LM,
 	},
 };
 
@@ -3088,12 +3104,17 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 	struct device *dev = hisi_hba->dev;
 	const struct hisi_sas_hw_error *axi_error;
 	int i;
+	struct hisi_sas_hw_err_info err_data;
+	bool trace_ns_event_enabled = trace_non_standard_event_enabled();
 
 	irq_msk = hisi_sas_read32(hisi_hba, ENT_INT_SRC_MSK3);
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, irq_msk | 0xfffffffe);
 
 	irq_value = hisi_sas_read32(hisi_hba, ENT_INT_SRC3);
 
+	if (trace_ns_event_enabled)
+		memset(&err_data, 0, sizeof(err_data));
+
 	for (i = 0; i < ARRAY_SIZE(fatal_axi_errors); i++) {
 		axi_error = &fatal_axi_errors[i];
 		if (!(irq_value & axi_error->irq_msk))
@@ -3108,13 +3129,38 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 			for (; sub->msk || sub->msg; sub++) {
 				if (!(err_value & sub->msk))
 					continue;
-				dev_warn(dev, "%s (0x%x) found!\n",
-					 sub->msg, irq_value);
+				if (trace_ns_event_enabled) {
+					err_data.validation_bits =
+						HISI_SAS_VALID_ERR_TYPE |
+						HISI_SAS_VALID_AXI_ERR_INFO;
+					err_data.type = axi_error->type;
+					err_data.axi_err_info = sub->msk;
+					log_non_standard_event(
+							&CPER_SEC_TYPE_HISI_SAS,
+							&NULL_UUID_LE,
+							dev_name(dev),
+							GHES_SEV_PANIC,
+							(const u8 *)&err_data,
+							sizeof(err_data));
+				} else
+					dev_warn(dev, "%s (0x%x) found!\n",
+						 sub->msg, irq_value);
 				queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 			}
 		} else {
-			dev_warn(dev, "%s (0x%x) found!\n",
-				 axi_error->msg, irq_value);
+			if (trace_ns_event_enabled) {
+				err_data.validation_bits =
+						HISI_SAS_VALID_ERR_TYPE;
+				err_data.type = axi_error->type;
+				log_non_standard_event(&CPER_SEC_TYPE_HISI_SAS,
+						       &NULL_UUID_LE,
+						       dev_name(dev),
+						       GHES_SEV_PANIC,
+						       (const u8 *)&err_data,
+						       sizeof(err_data));
+			} else
+				dev_warn(dev, "%s (0x%x) found!\n",
+					 axi_error->msg, irq_value);
 			queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 		}
 	}
-- 
1.9.1
