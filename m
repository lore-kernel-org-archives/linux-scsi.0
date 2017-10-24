From: John Garry <john.garry@huawei.com>
Subject: [PATCH 10/19] scsi: hisi_sas: report ECC errors in v2 hw to userspace
Date: Tue, 24 Oct 2017 23:51:40 +0800
Message-ID: <1508860309-212397-11-git-send-email-john.garry@huawei.com>
References: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Shiju Jose <shiju.jose@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Shiju Jose <shiju.jose@huawei.com>

This patch adds reporting ECC errors in the SAS V2 driver to
userspace as non-standard trace events.

rasdaemon can be used to read and log these ECC errors in
userspace.

Rasdaemon log for the SAS errors with the decoding sample:
cpu 00:[   70.025830] hisi_sas_v2_hw HISI0162:01: phy7, wait tx fifo need send break
          <idle>-0     [4204528]     0.000007: non_standard_event:   2017-09-06 11:14:49 +0000
 Recoverable
 section type: daffd814-6eba-4d8c-8a91-bc9bbf4aa301 fru text: HISI0162:01 fru id: 00000000-0000-0000-0000-000000000000
 length: 24
 error:
  00000000: 00000007 00000000 0000013c 00000000
  00000010: 00000000 00000001
HISI HIP07: SAS error: [phy addr = 0x0x13c: single-bit ecc: error type = hgc_dqe ecc]

cpu 00:          <idle>-0     [4204552]     0.000007: non_standard_event:   2017-09-06 11:14:49 +0000
 Fatal
 section type: daffd814-6eba-4d8c-8a91-bc9bbf4aa301 fru text: HISI0162:01 fru id: 00000000-0000-0000-0000-000000000000
 length: 24
 error:
  00000000: 00000007 00000000 0000013c 00000000
  00000010: 00000001 00000001
HISI HIP07: SAS error: [phy addr = 0x0x13c: multi-bit ecc: error type = hgc_dqe ecc]

Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  9 ++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 95 +++++++++++++++++++++++++++++++++-
 2 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index d2d384b..58bc69e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -12,6 +12,7 @@
 #ifndef _HISI_SAS_H_
 #define _HISI_SAS_H_
 
+#include <acpi/ghes.h>
 #include <linux/acpi.h>
 #include <linux/clk.h>
 #include <linux/dmapool.h>
@@ -22,7 +23,9 @@
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/property.h>
+#include <linux/ras.h>
 #include <linux/regmap.h>
+#include <ras/ras_event.h>
 #include <scsi/sas_ata.h>
 #include <scsi/libsas.h>
 
@@ -96,9 +99,15 @@ struct hisi_sas_hw_error {
 	int shift;
 	const char *msg;
 	int reg;
+	u32 type;
 	const struct hisi_sas_hw_error *sub;
 };
 
+enum hisi_sas_bit_err_type {
+	HISI_SAS_ERR_SINGLE_BIT_ECC = 0x0,
+	HISI_SAS_ERR_MULTI_BIT_ECC = 0x1,
+};
+
 struct hisi_sas_phy {
 	struct hisi_hba	*hisi_hba;
 	struct hisi_sas_port	*port;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index ee34f2e..0cf8244 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -379,6 +379,17 @@
 
 #define HISI_SAS_FATAL_INT_NR	2
 
+#define HISI_SAS_ECC_ERR_HGC_DQE	BIT(0)
+#define HISI_SAS_ECC_ERR_HGC_IOST	BIT(1)
+#define HISI_SAS_ECC_ERR_HGC_ITCT	BIT(2)
+#define HISI_SAS_ECC_ERR_HGC_IOSTLIST	BIT(3)
+#define HISI_SAS_ECC_ERR_HGC_ITCTLIST	BIT(4)
+#define HISI_SAS_ECC_ERR_HGC_CQE	BIT(5)
+#define HISI_SAS_ECC_ERR_HGC_RXM_MEM0	BIT(6)
+#define HISI_SAS_ECC_ERR_HGC_RXM_MEM1	BIT(7)
+#define HISI_SAS_ECC_ERR_HGC_RXM_MEM2	BIT(8)
+#define HISI_SAS_ECC_ERR_HGC_RXM_MEM3	BIT(9)
+
 struct hisi_sas_complete_v2_hdr {
 	__le32 dw0;
 	__le32 dw1;
@@ -401,6 +412,13 @@ struct hisi_sas_err_record_v2 {
 	__le32 dma_rx_err_type;
 };
 
+struct hisi_sas_hw_err_info {
+	u64   validation_bits;
+	u64   physical_addr;
+	u32   mb_err;
+	u32   type;
+};
+
 static const struct hisi_sas_hw_error one_bit_ecc_errors[] = {
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_DQE_ECC_1B_OFF),
@@ -408,6 +426,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_DQE_ECC_1B_ADDR_OFF,
 		.msg = "hgc_dqe_acc1b_intr found: Ram address is 0x%08X\n",
 		.reg = HGC_DQE_ECC_ADDR,
+		.type = HISI_SAS_ECC_ERR_HGC_DQE,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_IOST_ECC_1B_OFF),
@@ -415,6 +434,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_IOST_ECC_1B_ADDR_OFF,
 		.msg = "hgc_iost_acc1b_intr found: Ram address is 0x%08X\n",
 		.reg = HGC_IOST_ECC_ADDR,
+		.type = HISI_SAS_ECC_ERR_HGC_IOST,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_ITCT_ECC_1B_OFF),
@@ -422,6 +442,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_ITCT_ECC_1B_ADDR_OFF,
 		.msg = "hgc_itct_acc1b_intr found: am address is 0x%08X\n",
 		.reg = HGC_ITCT_ECC_ADDR,
+		.type = HISI_SAS_ECC_ERR_HGC_ITCT,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_IOSTLIST_ECC_1B_OFF),
@@ -429,6 +450,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_LM_DFX_STATUS2_IOSTLIST_OFF,
 		.msg = "hgc_iostl_acc1b_intr found: memory address is 0x%08X\n",
 		.reg = HGC_LM_DFX_STATUS2,
+		.type = HISI_SAS_ECC_ERR_HGC_IOSTLIST,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_ITCTLIST_ECC_1B_OFF),
@@ -436,6 +458,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_LM_DFX_STATUS2_ITCTLIST_OFF,
 		.msg = "hgc_itctl_acc1b_intr found: memory address is 0x%08X\n",
 		.reg = HGC_LM_DFX_STATUS2,
+		.type = HISI_SAS_ECC_ERR_HGC_ITCTLIST,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_CQE_ECC_1B_OFF),
@@ -443,6 +466,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_CQE_ECC_1B_ADDR_OFF,
 		.msg = "hgc_cqe_acc1b_intr found: Ram address is 0x%08X\n",
 		.reg = HGC_CQE_ECC_ADDR,
+		.type = HISI_SAS_ECC_ERR_HGC_CQE,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM0_ECC_1B_OFF),
@@ -450,6 +474,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_RXM_DFX_STATUS14_MEM0_OFF,
 		.msg = "rxm_mem0_acc1b_intr found: memory address is 0x%08X\n",
 		.reg = HGC_RXM_DFX_STATUS14,
+		.type = HISI_SAS_ECC_ERR_HGC_RXM_MEM0,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM1_ECC_1B_OFF),
@@ -457,6 +482,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_RXM_DFX_STATUS14_MEM1_OFF,
 		.msg = "rxm_mem1_acc1b_intr found: memory address is 0x%08X\n",
 		.reg = HGC_RXM_DFX_STATUS14,
+		.type = HISI_SAS_ECC_ERR_HGC_RXM_MEM1,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM2_ECC_1B_OFF),
@@ -464,6 +490,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_RXM_DFX_STATUS14_MEM2_OFF,
 		.msg = "rxm_mem2_acc1b_intr found: memory address is 0x%08X\n",
 		.reg = HGC_RXM_DFX_STATUS14,
+		.type = HISI_SAS_ECC_ERR_HGC_RXM_MEM2,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM3_ECC_1B_OFF),
@@ -471,6 +498,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_RXM_DFX_STATUS15_MEM3_OFF,
 		.msg = "rxm_mem3_acc1b_intr found: memory address is 0x%08X\n",
 		.reg = HGC_RXM_DFX_STATUS15,
+		.type = HISI_SAS_ECC_ERR_HGC_RXM_MEM3,
 	},
 };
 
@@ -481,6 +509,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_DQE_ECC_MB_ADDR_OFF,
 		.msg = "hgc_dqe_accbad_intr (0x%x) found: Ram address is 0x%08X\n",
 		.reg = HGC_DQE_ECC_ADDR,
+		.type = HISI_SAS_ECC_ERR_HGC_DQE,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_IOST_ECC_MB_OFF),
@@ -488,6 +517,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_IOST_ECC_MB_ADDR_OFF,
 		.msg = "hgc_iost_accbad_intr (0x%x) found: Ram address is 0x%08X\n",
 		.reg = HGC_IOST_ECC_ADDR,
+		.type = HISI_SAS_ECC_ERR_HGC_IOST,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_ITCT_ECC_MB_OFF),
@@ -495,6 +525,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_ITCT_ECC_MB_ADDR_OFF,
 		.msg = "hgc_itct_accbad_intr (0x%x) found: Ram address is 0x%08X\n",
 		.reg = HGC_ITCT_ECC_ADDR,
+		.type = HISI_SAS_ECC_ERR_HGC_ITCT,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_IOSTLIST_ECC_MB_OFF),
@@ -502,6 +533,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_LM_DFX_STATUS2_IOSTLIST_OFF,
 		.msg = "hgc_iostl_accbad_intr (0x%x) found: memory address is 0x%08X\n",
 		.reg = HGC_LM_DFX_STATUS2,
+		.type = HISI_SAS_ECC_ERR_HGC_IOSTLIST,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_ITCTLIST_ECC_MB_OFF),
@@ -509,6 +541,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_LM_DFX_STATUS2_ITCTLIST_OFF,
 		.msg = "hgc_itctl_accbad_intr (0x%x) found: memory address is 0x%08X\n",
 		.reg = HGC_LM_DFX_STATUS2,
+		.type = HISI_SAS_ECC_ERR_HGC_ITCTLIST,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_CQE_ECC_MB_OFF),
@@ -516,6 +549,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_CQE_ECC_MB_ADDR_OFF,
 		.msg = "hgc_cqe_accbad_intr (0x%x) found: Ram address is 0x%08X\n",
 		.reg = HGC_CQE_ECC_ADDR,
+		.type = HISI_SAS_ECC_ERR_HGC_CQE,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM0_ECC_MB_OFF),
@@ -523,6 +557,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_RXM_DFX_STATUS14_MEM0_OFF,
 		.msg = "rxm_mem0_accbad_intr (0x%x) found: memory address is 0x%08X\n",
 		.reg = HGC_RXM_DFX_STATUS14,
+		.type = HISI_SAS_ECC_ERR_HGC_RXM_MEM0,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM1_ECC_MB_OFF),
@@ -530,6 +565,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_RXM_DFX_STATUS14_MEM1_OFF,
 		.msg = "rxm_mem1_accbad_intr (0x%x) found: memory address is 0x%08X\n",
 		.reg = HGC_RXM_DFX_STATUS14,
+		.type = HISI_SAS_ECC_ERR_HGC_RXM_MEM1,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM2_ECC_MB_OFF),
@@ -537,6 +573,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_RXM_DFX_STATUS14_MEM2_OFF,
 		.msg = "rxm_mem2_accbad_intr (0x%x) found: memory address is 0x%08X\n",
 		.reg = HGC_RXM_DFX_STATUS14,
+		.type = HISI_SAS_ECC_ERR_HGC_RXM_MEM2,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM3_ECC_MB_OFF),
@@ -544,6 +581,7 @@ struct hisi_sas_err_record_v2 {
 		.shift = HGC_RXM_DFX_STATUS15_MEM3_OFF,
 		.msg = "rxm_mem3_accbad_intr (0x%x) found: memory address is 0x%08X\n",
 		.reg = HGC_RXM_DFX_STATUS15,
+		.type = HISI_SAS_ECC_ERR_HGC_RXM_MEM3,
 	},
 };
 
@@ -702,6 +740,15 @@ enum {
 #define DIR_TO_DEVICE 2
 #define DIR_RESERVED 3
 
+/* Vendor specific CPER SEC TYPE for HISI SAS Memory errors */
+#define CPER_SEC_TYPE_HISI_SAS                                           \
+	UUID_LE(0xDAFFD814, 0x6EBA, 0x4D8C, 0x8A, 0x91, 0xBC, 0x9B,     \
+	0xBF, 0x4A, 0xA3, 0x01)
+
+#define HISI_SAS_VALID_PA		BIT(0)
+#define HISI_SAS_VALID_MB_ERR		BIT(1)
+#define HISI_SAS_VALID_ERR_TYPE		BIT(2)
+
 #define ERR_ON_TX_PHASE(err_phase) (err_phase == 0x2 || \
 		err_phase == 0x4 || err_phase == 0x8 ||\
 		err_phase == 0x6 || err_phase == 0xa)
@@ -2882,6 +2929,17 @@ static irqreturn_t int_chnl_int_v2_hw(int irq_no, void *p)
 	const struct hisi_sas_hw_error *ecc_error;
 	u32 val;
 	int i;
+	struct hisi_sas_hw_err_info err_data;
+	bool trace_ns_event_enabled = trace_non_standard_event_enabled();
+
+	if (trace_ns_event_enabled) {
+		memset(&err_data, 0, sizeof(err_data));
+		err_data.validation_bits =
+					HISI_SAS_VALID_PA |
+					HISI_SAS_VALID_MB_ERR |
+					HISI_SAS_VALID_ERR_TYPE;
+		err_data.mb_err = HISI_SAS_ERR_SINGLE_BIT_ECC;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(one_bit_ecc_errors); i++) {
 		ecc_error = &one_bit_ecc_errors[i];
@@ -2889,7 +2947,18 @@ static irqreturn_t int_chnl_int_v2_hw(int irq_no, void *p)
 			val = hisi_sas_read32(hisi_hba, ecc_error->reg);
 			val &= ecc_error->msk;
 			val >>= ecc_error->shift;
-			dev_warn(dev, ecc_error->msg, val);
+			if (trace_ns_event_enabled) {
+				err_data.physical_addr = val;
+				err_data.type = ecc_error->type;
+				log_non_standard_event(&CPER_SEC_TYPE_HISI_SAS,
+						       &NULL_UUID_LE,
+						       dev_name(dev),
+						       GHES_SEV_RECOVERABLE,
+						       (const u8 *)&err_data,
+						       sizeof(err_data));
+			} else {
+				dev_warn(dev, ecc_error->msg, val);
+			}
 		}
 	}
 }
@@ -2901,6 +2970,17 @@ static void multi_bit_ecc_error_process_v2_hw(struct hisi_hba *hisi_hba,
 	const struct hisi_sas_hw_error *ecc_error;
 	u32 val;
 	int i;
+	struct hisi_sas_hw_err_info err_data;
+	bool trace_ns_event_enabled = trace_non_standard_event_enabled();
+
+	if (trace_ns_event_enabled) {
+		memset(&err_data, 0, sizeof(err_data));
+		err_data.validation_bits =
+					HISI_SAS_VALID_PA |
+					HISI_SAS_VALID_MB_ERR |
+					HISI_SAS_VALID_ERR_TYPE;
+		err_data.mb_err = HISI_SAS_ERR_MULTI_BIT_ECC;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(multi_bit_ecc_errors); i++) {
 		ecc_error = &multi_bit_ecc_errors[i];
@@ -2908,7 +2988,18 @@ static void multi_bit_ecc_error_process_v2_hw(struct hisi_hba *hisi_hba,
 			val = hisi_sas_read32(hisi_hba, ecc_error->reg);
 			val &= ecc_error->msk;
 			val >>= ecc_error->shift;
-			dev_warn(dev, ecc_error->msg, irq_value, val);
+			if (trace_ns_event_enabled) {
+				err_data.physical_addr = val;
+				err_data.type = ecc_error->type;
+				log_non_standard_event(&CPER_SEC_TYPE_HISI_SAS,
+						       &NULL_UUID_LE,
+						       dev_name(dev),
+						       GHES_SEV_PANIC,
+						       (const u8 *)&err_data,
+						       sizeof(err_data));
+			} else {
+				dev_warn(dev, ecc_error->msg, irq_value, val);
+			}
 			queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 		}
 	}
-- 
1.9.1
