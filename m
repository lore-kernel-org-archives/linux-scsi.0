From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 05/23] scsi: hisi_sas: relocate sata_done_v2_hw()
Date: Wed, 31 May 2017 22:32:57 +0800
Message-ID: <1496241195-217678-6-git-send-email-john.garry@huawei.com>
References: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:7292 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdEaOFL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 10:05:11 -0400
In-Reply-To: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

Relocate get_ata_protocol() to a common location, as future hw
versions will require it.
Also rename with "hisi_sas_" prefix for consistency.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  2 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 15 +++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 18 ++----------------
 3 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 8ed1199..f2d69cd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -358,6 +358,8 @@ struct hisi_sas_command_table_ssp {
 
 extern u8 hisi_sas_get_ata_protocol(u8 cmd, int direction);
 extern struct hisi_sas_port *to_hisi_sas_port(struct asd_sas_port *sas_port);
+extern void hisi_sas_sata_done(struct sas_task *task,
+			    struct hisi_sas_slot *slot);
 extern int hisi_sas_probe(struct platform_device *pdev,
 			  const struct hisi_sas_hw *ops);
 extern int hisi_sas_remove(struct platform_device *pdev);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f71590c..88ace7c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -88,6 +88,21 @@ u8 hisi_sas_get_ata_protocol(u8 cmd, int direction)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_get_ata_protocol);
 
+void hisi_sas_sata_done(struct sas_task *task,
+			    struct hisi_sas_slot *slot)
+{
+	struct task_status_struct *ts = &task->task_status;
+	struct ata_task_resp *resp = (struct ata_task_resp *)ts->buf;
+	struct dev_to_host_fis *d2h = slot->status_buffer +
+				      sizeof(struct hisi_sas_err_record);
+
+	resp->frame_len = sizeof(struct dev_to_host_fis);
+	memcpy(&resp->ending_fis[0], d2h, sizeof(struct dev_to_host_fis));
+
+	ts->buf_valid_size = sizeof(*resp);
+}
+EXPORT_SYMBOL_GPL(hisi_sas_sata_done);
+
 static struct hisi_hba *dev_to_hisi_hba(struct domain_device *device)
 {
 	return device->port->ha->lldd_ha;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index d9314c4..fdd7019 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1683,20 +1683,6 @@ static int prep_ssp_v2_hw(struct hisi_hba *hisi_hba,
 	return 0;
 }
 
-static void sata_done_v2_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
-			    struct hisi_sas_slot *slot)
-{
-	struct task_status_struct *ts = &task->task_status;
-	struct ata_task_resp *resp = (struct ata_task_resp *)ts->buf;
-	struct dev_to_host_fis *d2h = slot->status_buffer +
-				      sizeof(struct hisi_sas_err_record);
-
-	resp->frame_len = sizeof(struct dev_to_host_fis);
-	memcpy(&resp->ending_fis[0], d2h, sizeof(struct dev_to_host_fis));
-
-	ts->buf_valid_size = sizeof(*resp);
-}
-
 #define TRANS_TX_ERR	0
 #define TRANS_RX_ERR	1
 #define DMA_TX_ERR		2
@@ -2189,7 +2175,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 			break;
 		}
 		}
-		sata_done_v2_hw(hisi_hba, task, slot);
+		hisi_sas_sata_done(task, slot);
 	}
 		break;
 	default:
@@ -2317,7 +2303,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
 	{
 		ts->stat = SAM_STAT_GOOD;
-		sata_done_v2_hw(hisi_hba, task, slot);
+		hisi_sas_sata_done(task, slot);
 		break;
 	}
 	default:
-- 
1.9.1
