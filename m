From: <shiju.jose@huawei.com>
Subject: [PATCH 1/1] scsi: hisi_sas: fix for the build error
 log_non_standard_event undefined
Date: Tue, 31 Oct 2017 12:25:51 +0000
Message-ID: <3f14f745-6fdf-4948-85bb-d21d565dbcab@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: john.garry@huawei.com, xuwei5@hisilicon.com, shiju.jose@huawei.com
List-Id: linux-scsi@vger.kernel.org

This patch fix the build error log_non_standard_event undefined
for the i386 build for COMPILE_TEST.

https://lists.01.org/pipermail/kbuild-all/2017-October/039518.html

The function call log_non_standard_event is replaced with the
function call trace_non_standard_event.

Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 41 ++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 433412a..72f606a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2959,12 +2959,13 @@ static irqreturn_t int_chnl_int_v2_hw(int irq_no, void *p)
 			if (trace_ns_event_enabled) {
 				err_data.physical_addr = val;
 				err_data.type = ecc_error->type;
-				log_non_standard_event(&CPER_SEC_TYPE_HISI_SAS,
-						       &NULL_UUID_LE,
-						       dev_name(dev),
-						       GHES_SEV_RECOVERABLE,
-						       (const u8 *)&err_data,
-						       sizeof(err_data));
+				trace_non_standard_event(
+						&CPER_SEC_TYPE_HISI_SAS,
+						&NULL_UUID_LE,
+						dev_name(dev),
+						GHES_SEV_RECOVERABLE,
+						(const u8 *)&err_data,
+						sizeof(err_data));
 			} else {
 				dev_warn(dev, ecc_error->msg, val);
 			}
@@ -3000,12 +3001,13 @@ static void multi_bit_ecc_error_process_v2_hw(struct hisi_hba *hisi_hba,
 			if (trace_ns_event_enabled) {
 				err_data.physical_addr = val;
 				err_data.type = ecc_error->type;
-				log_non_standard_event(&CPER_SEC_TYPE_HISI_SAS,
-						       &NULL_UUID_LE,
-						       dev_name(dev),
-						       GHES_SEV_PANIC,
-						       (const u8 *)&err_data,
-						       sizeof(err_data));
+				trace_non_standard_event(
+						&CPER_SEC_TYPE_HISI_SAS,
+						&NULL_UUID_LE,
+						dev_name(dev),
+						GHES_SEV_PANIC,
+						(const u8 *)&err_data,
+						sizeof(err_data));
 			} else {
 				dev_warn(dev, ecc_error->msg, irq_value, val);
 			}
@@ -3135,7 +3137,7 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 						HISI_SAS_VALID_AXI_ERR_INFO;
 					err_data.type = axi_error->type;
 					err_data.axi_err_info = sub->msk;
-					log_non_standard_event(
+					trace_non_standard_event(
 							&CPER_SEC_TYPE_HISI_SAS,
 							&NULL_UUID_LE,
 							dev_name(dev),
@@ -3152,12 +3154,13 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 				err_data.validation_bits =
 						HISI_SAS_VALID_ERR_TYPE;
 				err_data.type = axi_error->type;
-				log_non_standard_event(&CPER_SEC_TYPE_HISI_SAS,
-						       &NULL_UUID_LE,
-						       dev_name(dev),
-						       GHES_SEV_PANIC,
-						       (const u8 *)&err_data,
-						       sizeof(err_data));
+				trace_non_standard_event(
+						&CPER_SEC_TYPE_HISI_SAS,
+						&NULL_UUID_LE,
+						dev_name(dev),
+						GHES_SEV_PANIC,
+						(const u8 *)&err_data,
+						sizeof(err_data));
 			} else
 				dev_warn(dev, "%s (0x%x) found!\n",
 					 axi_error->msg, irq_value);
-- 
1.9.1
