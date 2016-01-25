From: j00310691 <john.garry@huawei.com>
Subject: [PATCH v2 05/23] hisi_sas: add hisi_sas_err_record_v1
Date: Tue, 26 Jan 2016 01:21:54 +0800
Message-ID: <1453742532-53092-6-git-send-email-john.garry@huawei.com>
References: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: John Garry <john.garry@huawei.com>

Since the error record structure is different for
v2 hw, make hisi_sas_err_record opaque and add
hisi_sas_err_record_v1.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 12 +-----------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 7c05eb3..e5a58c5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -270,17 +270,7 @@ struct hisi_sas_iost {
 };
 
 struct hisi_sas_err_record {
-	/* dw0 */
-	__le32 dma_err_type;
-
-	/* dw1 */
-	__le32 trans_tx_fail_type;
-
-	/* dw2 */
-	__le32 trans_rx_fail_type;
-
-	/* dw3 */
-	u32 rsvd;
+	u32	data[4];
 };
 
 struct hisi_sas_initial_fis {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 9bbcf6d..87a0622 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -288,6 +288,20 @@ struct hisi_sas_complete_v1_hdr {
 	__le32 data;
 };
 
+struct hisi_sas_err_record_v1 {
+	/* dw0 */
+	__le32 dma_err_type;
+
+	/* dw1 */
+	__le32 trans_tx_fail_type;
+
+	/* dw2 */
+	__le32 trans_rx_fail_type;
+
+	/* dw3 */
+	u32 rsvd;
+};
+
 enum {
 	HISI_SAS_PHY_BCAST_ACK = 0,
 	HISI_SAS_PHY_SL_PHY_ENABLED,
@@ -1098,7 +1112,7 @@ static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
 			   struct hisi_sas_slot *slot)
 {
 	struct task_status_struct *ts = &task->task_status;
-	struct hisi_sas_err_record *err_record = slot->status_buffer;
+	struct hisi_sas_err_record_v1 *err_record = slot->status_buffer;
 	struct device *dev = &hisi_hba->pdev->dev;
 
 	switch (task->task_proto) {
@@ -1222,7 +1236,6 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 	struct domain_device *device;
 	enum exec_status sts;
 	struct hisi_sas_complete_v1_hdr *complete_queue =
-			(struct hisi_sas_complete_v1_hdr *)
 			hisi_hba->complete_hdr[slot->cmplt_queue];
 	struct hisi_sas_complete_v1_hdr *complete_hdr;
 	u32 cmplt_hdr_data;
-- 
1.9.1
