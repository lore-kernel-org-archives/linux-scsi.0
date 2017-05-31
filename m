From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 23/23] scsi: hisi_sas: modify internal abort dev flow for v3 hw
Date: Wed, 31 May 2017 22:33:15 +0800
Message-ID: <1496241195-217678-24-git-send-email-john.garry@huawei.com>
References: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

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
index d7545ff..cf2a593 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -182,6 +182,8 @@ struct hisi_sas_hw {
 	void (*free_device)(struct hisi_hba *hisi_hba,
 			    struct hisi_sas_device *dev);
 	int (*get_wideport_bitmap)(struct hisi_hba *hisi_hba, int port_id);
+	void (*dereg_device)(struct hisi_hba *hisi_hba,
+				struct domain_device *device);
 	int (*soft_reset)(struct hisi_hba *hisi_hba);
 	int max_command_entries;
 	int complete_hdr_size;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index b90eb50..96a23af 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -763,6 +763,13 @@ static void hisi_sas_release_tasks(struct hisi_hba *hisi_hba)
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
@@ -776,6 +783,8 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 	hisi_sas_internal_task_abort(hisi_hba, device,
 				     HISI_SAS_INT_ABT_DEV, 0);
 
+	hisi_sas_dereg_device(hisi_hba, device);
+
 	hisi_hba->hw->free_device(hisi_hba, sas_dev);
 	device->lldd_dev = NULL;
 	memset(sas_dev, 0, sizeof(*sas_dev));
@@ -1107,6 +1116,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		if (task->dev->dev_type == SAS_SATA_DEV) {
 			hisi_sas_internal_task_abort(hisi_hba, device,
 						     HISI_SAS_INT_ABT_DEV, 0);
+			hisi_sas_dereg_device(hisi_hba, device);
 			rc = hisi_sas_softreset_ata_disk(device);
 		}
 	} else if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SMP) {
@@ -1173,6 +1183,10 @@ static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
 		return TMF_RESP_FUNC_FAILED;
 	sas_dev->dev_status = HISI_SAS_DEV_NORMAL;
 
+	hisi_sas_internal_task_abort(hisi_hba, device,
+					HISI_SAS_INT_ABT_DEV, 0);
+	hisi_sas_dereg_device(hisi_hba, device);
+
 	rc = hisi_sas_debug_I_T_nexus_reset(device);
 
 	if (rc == TMF_RESP_FUNC_COMPLETE) {
@@ -1200,6 +1214,7 @@ static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
 						  HISI_SAS_INT_ABT_DEV, 0);
 		if (rc == TMF_RESP_FUNC_FAILED)
 			goto out;
+		hisi_sas_dereg_device(hisi_hba, device);
 
 		phy = sas_get_local_phy(device);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 17f9ac9..63239ca 100644
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
@@ -635,6 +639,29 @@ static void free_device_v3_hw(struct hisi_hba *hisi_hba,
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
@@ -2016,6 +2043,7 @@ static int hisi_sas_v3_init(struct hisi_hba *hisi_hba)
 	.phy_disable = disable_phy_v3_hw,
 	.phy_hard_reset = phy_hard_reset_v3_hw,
 	.phy_get_max_linkrate = phy_get_max_linkrate_v3_hw,
+	.dereg_device = dereg_device_v3_hw,
 };
 
 static struct Scsi_Host *
-- 
1.9.1
