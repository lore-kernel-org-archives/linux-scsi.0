From: chenxiang <chenxiang66@hisilicon.com>
Subject: [PATCH 2/2] scsi: hisi_sas: Change frame type for SET MAX commands
Date: Thu, 28 Dec 2017 18:20:47 +0800
Message-ID: <1514456447-213928-3-git-send-email-chenxiang66@hisilicon.com>
References: <1514456447-213928-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3236 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751431AbdL1JeG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Dec 2017 04:34:06 -0500
In-Reply-To: <1514456447-213928-1-git-send-email-chenxiang66@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linuxarm@huawei.com, chenxiang <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

According to ATA protocol, SET MAX commands belong to different frame types.
So judge features field of SET MAX commands to decide which frame type they
belongs to.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 20 ++++++++++++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  2 +-
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index cc05029..4000de4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -441,7 +441,8 @@ struct hisi_sas_slot_buf_table {
 extern void hisi_sas_init_add(struct hisi_hba *hisi_hba);
 extern int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost);
 extern void hisi_sas_free(struct hisi_hba *hisi_hba);
-extern u8 hisi_sas_get_ata_protocol(u8 cmd, int direction);
+extern u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis,
+				int direction);
 extern struct hisi_sas_port *to_hisi_sas_port(struct asd_sas_port *sas_port);
 extern void hisi_sas_sata_done(struct sas_task *task,
 			    struct hisi_sas_slot *slot);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 04e1172b..6792c1a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -25,9 +25,9 @@ static int hisi_sas_debug_issue_ssp_tmf(struct domain_device *device,
 static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
 				void *funcdata);
 
-u8 hisi_sas_get_ata_protocol(u8 cmd, int direction)
+u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis, int direction)
 {
-	switch (cmd) {
+	switch (fis->command) {
 	case ATA_CMD_FPDMA_WRITE:
 	case ATA_CMD_FPDMA_READ:
 	case ATA_CMD_FPDMA_RECV:
@@ -79,10 +79,26 @@ u8 hisi_sas_get_ata_protocol(u8 cmd, int direction)
 	case ATA_CMD_ZAC_MGMT_OUT:
 	return HISI_SAS_SATA_PROTOCOL_NONDATA;
 	default:
+	{
+		if (fis->command == ATA_CMD_SET_MAX) {
+			switch (fis->features) {
+			case ATA_SET_MAX_PASSWD:
+			case ATA_SET_MAX_LOCK:
+			return HISI_SAS_SATA_PROTOCOL_PIO;
+
+			case ATA_SET_MAX_PASSWD_DMA:
+			case ATA_SET_MAX_UNLOCK_DMA:
+			return HISI_SAS_SATA_PROTOCOL_DMA;
+
+			default:
+			return HISI_SAS_SATA_PROTOCOL_NONDATA;
+			}
+		}
 		if (direction == DMA_NONE)
 			return HISI_SAS_SATA_PROTOCOL_NONDATA;
 		return HISI_SAS_SATA_PROTOCOL_PIO;
 	}
+	}
 }
 EXPORT_SYMBOL_GPL(hisi_sas_get_ata_protocol);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index b8fe08d..ebee2e4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2539,7 +2539,7 @@ static int prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 		dw1 |= 1 << CMD_HDR_RESET_OFF;
 
 	dw1 |= (hisi_sas_get_ata_protocol(
-		task->ata_task.fis.command, task->data_dir))
+		&task->ata_task.fis, task->data_dir))
 		<< CMD_HDR_FRAME_TYPE_OFF;
 	dw1 |= sas_dev->device_id << CMD_HDR_DEV_ID_OFF;
 	hdr->dw1 = cpu_to_le32(dw1);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 6a408d2..a1f1868 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1047,7 +1047,7 @@ static int prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 		dw1 |= 1 << CMD_HDR_RESET_OFF;
 
 	dw1 |= (hisi_sas_get_ata_protocol(
-		task->ata_task.fis.command, task->data_dir))
+		&task->ata_task.fis, task->data_dir))
 		<< CMD_HDR_FRAME_TYPE_OFF;
 	dw1 |= sas_dev->device_id << CMD_HDR_DEV_ID_OFF;
 
-- 
1.9.1
