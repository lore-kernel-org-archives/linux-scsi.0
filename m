From: John Garry <john.garry@huawei.com>
Subject: [RESEND PATCH v2 03/23] hisi_sas: set max commands as configurable
Date: Tue, 26 Jan 2016 02:47:03 +0800
Message-ID: <1453747643-61875-4-git-send-email-john.garry@huawei.com>
References: <1453747643-61875-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453747643-61875-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Since v2 hardware permits different numbers of
commands to v1, set this as configurable in
hisi_sas_hw.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 24 ++++++++++++------------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  3 +++
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 21eb2bb..5ed5cf1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -27,7 +27,6 @@
 #define HISI_SAS_QUEUE_SLOTS 512
 #define HISI_SAS_MAX_ITCT_ENTRIES 4096
 #define HISI_SAS_MAX_DEVICES HISI_SAS_MAX_ITCT_ENTRIES
-#define HISI_SAS_COMMAND_ENTRIES 8192
 
 #define HISI_SAS_STATUS_BUF_SZ \
 		(sizeof(struct hisi_sas_err_record) + 1024)
@@ -144,6 +143,7 @@ struct hisi_sas_hw {
 	void (*free_device)(struct hisi_hba *hisi_hba,
 			    struct hisi_sas_device *dev);
 	int (*get_wideport_bitmap)(struct hisi_hba *hisi_hba, int port_id);
+	int max_command_entries;
 	int complete_hdr_size;
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 7689939..c48df6d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -973,9 +973,9 @@ static struct sas_domain_function_template hisi_sas_transport_ops = {
 
 static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 {
-	int i, s;
 	struct platform_device *pdev = hisi_hba->pdev;
 	struct device *dev = &pdev->dev;
+	int i, s, max_command_entries = hisi_hba->hw->max_command_entries;
 
 	spin_lock_init(&hisi_hba->lock);
 	for (i = 0; i < hisi_hba->n_phy; i++) {
@@ -1035,13 +1035,13 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 
 	memset(hisi_hba->itct, 0, s);
 
-	hisi_hba->slot_info = devm_kcalloc(dev, HISI_SAS_COMMAND_ENTRIES,
+	hisi_hba->slot_info = devm_kcalloc(dev, max_command_entries,
 					   sizeof(struct hisi_sas_slot),
 					   GFP_KERNEL);
 	if (!hisi_hba->slot_info)
 		goto err_out;
 
-	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_iost);
+	s = max_command_entries * sizeof(struct hisi_sas_iost);
 	hisi_hba->iost = dma_alloc_coherent(dev, s, &hisi_hba->iost_dma,
 					    GFP_KERNEL);
 	if (!hisi_hba->iost)
@@ -1049,7 +1049,7 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 
 	memset(hisi_hba->iost, 0, s);
 
-	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_breakpoint);
+	s = max_command_entries * sizeof(struct hisi_sas_breakpoint);
 	hisi_hba->breakpoint = dma_alloc_coherent(dev, s,
 				&hisi_hba->breakpoint_dma, GFP_KERNEL);
 	if (!hisi_hba->breakpoint)
@@ -1057,7 +1057,7 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 
 	memset(hisi_hba->breakpoint, 0, s);
 
-	hisi_hba->slot_index_count = HISI_SAS_COMMAND_ENTRIES;
+	hisi_hba->slot_index_count = max_command_entries;
 	s = hisi_hba->slot_index_count / sizeof(unsigned long);
 	hisi_hba->slot_index_tags = devm_kzalloc(dev, s, GFP_KERNEL);
 	if (!hisi_hba->slot_index_tags)
@@ -1075,7 +1075,7 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 		goto err_out;
 	memset(hisi_hba->initial_fis, 0, s);
 
-	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_breakpoint) * 2;
+	s = max_command_entries * sizeof(struct hisi_sas_breakpoint) * 2;
 	hisi_hba->sata_breakpoint = dma_alloc_coherent(dev, s,
 				&hisi_hba->sata_breakpoint_dma, GFP_KERNEL);
 	if (!hisi_hba->sata_breakpoint)
@@ -1098,7 +1098,7 @@ err_out:
 static void hisi_sas_free(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = &hisi_hba->pdev->dev;
-	int i, s;
+	int i, s, max_command_entries = hisi_hba->hw->max_command_entries;
 
 	for (i = 0; i < hisi_hba->queue_count; i++) {
 		s = sizeof(struct hisi_sas_cmd_hdr) * HISI_SAS_QUEUE_SLOTS;
@@ -1123,12 +1123,12 @@ static void hisi_sas_free(struct hisi_hba *hisi_hba)
 		dma_free_coherent(dev, s,
 				  hisi_hba->itct, hisi_hba->itct_dma);
 
-	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_iost);
+	s = max_command_entries * sizeof(struct hisi_sas_iost);
 	if (hisi_hba->iost)
 		dma_free_coherent(dev, s,
 				  hisi_hba->iost, hisi_hba->iost_dma);
 
-	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_breakpoint);
+	s = max_command_entries * sizeof(struct hisi_sas_breakpoint);
 	if (hisi_hba->breakpoint)
 		dma_free_coherent(dev, s,
 				  hisi_hba->breakpoint,
@@ -1141,7 +1141,7 @@ static void hisi_sas_free(struct hisi_hba *hisi_hba)
 				  hisi_hba->initial_fis,
 				  hisi_hba->initial_fis_dma);
 
-	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_breakpoint) * 2;
+	s = max_command_entries * sizeof(struct hisi_sas_breakpoint) * 2;
 	if (hisi_hba->sata_breakpoint)
 		dma_free_coherent(dev, s,
 				  hisi_hba->sata_breakpoint,
@@ -1273,8 +1273,8 @@ int hisi_sas_probe(struct platform_device *pdev,
 	shost->max_channel = 1;
 	shost->max_cmd_len = 16;
 	shost->sg_tablesize = min_t(u16, SG_ALL, HISI_SAS_SGE_PAGE_CNT);
-	shost->can_queue = HISI_SAS_COMMAND_ENTRIES;
-	shost->cmd_per_lun = HISI_SAS_COMMAND_ENTRIES;
+	shost->can_queue = hisi_hba->hw->max_command_entries;
+	shost->cmd_per_lun = hisi_hba->hw->max_command_entries;
 
 	sha->sas_ha_name = DRV_NAME;
 	sha->dev = &hisi_hba->pdev->dev;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 3d562de..9bbcf6d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -392,6 +392,8 @@ enum {
 	TRANS_RX_SMP_RESP_TIMEOUT_ERR, /* 0x31a */
 };
 
+#define HISI_SAS_COMMAND_ENTRIES_V1_HW 8192
+
 #define HISI_SAS_PHY_MAX_INT_NR (HISI_SAS_PHY_INT_NR * HISI_SAS_MAX_PHYS)
 #define HISI_SAS_CQ_MAX_INT_NR (HISI_SAS_MAX_QUEUES)
 #define HISI_SAS_FATAL_INT_NR (2)
@@ -1799,6 +1801,7 @@ static const struct hisi_sas_hw hisi_sas_v1_hw = {
 	.phy_disable = disable_phy_v1_hw,
 	.phy_hard_reset = phy_hard_reset_v1_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v1_hw,
+	.max_command_entries = HISI_SAS_COMMAND_ENTRIES_V1_HW,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v1_hdr),
 };
 
-- 
1.9.1
