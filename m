From: John Garry <john.garry@huawei.com>
Subject: [PATCH v5 23/23] scsi: hisi_sas: modify internal abort dev flow for v3 hw
Date: Fri, 9 Jun 2017 22:16:36 +0800
Message-ID: <1497017796-105067-24-git-send-email-john.garry@huawei.com>
References: <1497017796-105067-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:7797 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbdFINtm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2017 09:49:42 -0400
In-Reply-To: <1497017796-105067-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linuxarm@huawei.com, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

There is a change for abort dev for v3 hw: add registers to configure
unaborted iptt for a device, and then inform this to logic.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  2 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 15 +++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 28 ++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index e89f6ae..4fc2308 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -188,6 +188,8 @@ struct hisi_sas_hw {
 	void (*free_device)(struct hisi_hba *hisi_hba,
 			    struct hisi_sas_device *dev);
 	int (*get_wideport_bitmap)(struct hisi_hba *hisi_hba, int port_id);
+	void (*dereg_device)(struct hisi_hba *hisi_hba,
+				struct domain_device *device);
 	int (*soft_reset)(struct hisi_hba *hisi_hba);
 	int max_command_entries;
 	int complete_hdr_size;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 92b7068..c4cefa88 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -725,6 +725,13 @@ static void hisi_sas_release_tasks(struct hisi_hba *hisi_hba)
 	}
 }
 
+static void hisi_sas_dereg_device(struct hisi_hba *hisi_hba,
+				struct domain_device *device)
+{
+	if (hisi_hba->hw->dereg_device)
+		hisi_hba->hw->dereg_device(hisi_hba, device);
+}
+
 static void hisi_sas_dev_gone(struct domain_device *device)
 {
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
@@ -738,6 +745,8 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 	hisi_sas_internal_task_abort(hisi_hba, device,
 				     HISI_SAS_INT_ABT_DEV, 0);
 
+	hisi_sas_dereg_device(hisi_hba, device);
+
 	hisi_hba->hw->free_device(hisi_hba, sas_dev);
 	device->lldd_dev = NULL;
 	memset(sas_dev, 0, sizeof(*sas_dev));
@@ -1069,6 +1078,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		if (task->dev->dev_type == SAS_SATA_DEV) {
 			hisi_sas_internal_task_abort(hisi_hba, device,
 						     HISI_SAS_INT_ABT_DEV, 0);
+			hisi_sas_dereg_device(hisi_hba, device);
 			rc = hisi_sas_softreset_ata_disk(device);
 		}
 	} else if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SMP) {
@@ -1135,6 +1145,10 @@ static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
 		return TMF_RESP_FUNC_FAILED;
 	sas_dev->dev_status = HISI_SAS_DEV_NORMAL;
 
+	hisi_sas_internal_task_abort(hisi_hba, device,
+					HISI_SAS_INT_ABT_DEV, 0);
+	hisi_sas_dereg_device(hisi_hba, device);
+
 	rc = hisi_sas_debug_I_T_nexus_reset(device);
 
 	if (rc == TMF_RESP_FUNC_COMPLETE) {
@@ -1162,6 +1176,7 @@ static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
 						  HISI_SAS_INT_ABT_DEV, 0);
 		if (rc == TMF_RESP_FUNC_FAILED)
 			goto out;
+		hisi_sas_dereg_device(hisi_hba, device);
 
 		phy = sas_get_local_phy(device);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 3688051..6494388 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -50,6 +50,10 @@
 #define CFG_ABT_SET_QUERY_IPTT	0xd4
 #define CFG_SET_ABORTED_IPTT_OFF	0
 #define CFG_SET_ABORTED_IPTT_MSK	(0xfff << CFG_SET_ABORTED_IPTT_OFF)
+#define CFG_SET_ABORTED_EN_OFF	12
+#define CFG_ABT_SET_IPTT_DONE	0xd8
+#define CFG_ABT_SET_IPTT_DONE_OFF	0
+#define HGC_IOMB_PROC1_STATUS	0x104
 #define CFG_1US_TIMER_TRSH		0xcc
 #define HGC_LM_DFX_STATUS2		0x128
 #define HGC_LM_DFX_STATUS2_IOSTLIST_OFF		0
@@ -651,6 +655,29 @@ static void free_device_v3_hw(struct hisi_hba *hisi_hba,
 	}
 }
 
+static void dereg_device_v3_hw(struct hisi_hba *hisi_hba,
+				struct domain_device *device)
+{
+	struct hisi_sas_slot *slot, *slot2;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	u32 cfg_abt_set_query_iptt;
+
+	cfg_abt_set_query_iptt = hisi_sas_read32(hisi_hba,
+		CFG_ABT_SET_QUERY_IPTT);
+	list_for_each_entry_safe(slot, slot2, &sas_dev->list, entry) {
+		cfg_abt_set_query_iptt &= ~CFG_SET_ABORTED_IPTT_MSK;
+		cfg_abt_set_query_iptt |= (1 << CFG_SET_ABORTED_EN_OFF) |
+			(slot->idx << CFG_SET_ABORTED_IPTT_OFF);
+		hisi_sas_write32(hisi_hba, CFG_ABT_SET_QUERY_IPTT,
+			cfg_abt_set_query_iptt);
+	}
+	cfg_abt_set_query_iptt &= ~(1 << CFG_SET_ABORTED_EN_OFF);
+	hisi_sas_write32(hisi_hba, CFG_ABT_SET_QUERY_IPTT,
+		cfg_abt_set_query_iptt);
+	hisi_sas_write32(hisi_hba, CFG_ABT_SET_IPTT_DONE,
+					1 << CFG_ABT_SET_IPTT_DONE_OFF);
+}
+
 static int hw_init_v3_hw(struct hisi_hba *hisi_hba)
 {
 	init_reg_v3_hw(hisi_hba);
@@ -2006,6 +2033,7 @@ static int hisi_sas_v3_init(struct hisi_hba *hisi_hba)
 	.phy_disable = disable_phy_v3_hw,
 	.phy_hard_reset = phy_hard_reset_v3_hw,
 	.phy_get_max_linkrate = phy_get_max_linkrate_v3_hw,
+	.dereg_device = dereg_device_v3_hw,
 };
 
 static struct Scsi_Host *
-- 
1.9.1
