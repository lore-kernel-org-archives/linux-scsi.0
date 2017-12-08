From: John Garry <john.garry@huawei.com>
Subject: [PATCH 13/19] scsi: hisi_sas: use an general way to delay PHY work
Date: Sat, 9 Dec 2017 01:16:44 +0800
Message-ID: <1512753410-50924-14-git-send-email-john.garry@huawei.com>
References: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

Use an general way to do delay work for a PHY. Then it will
be easier to add new delayed work for a PHY in future.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  9 ++++++++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 22 ++++++++++++++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  2 +-
 5 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 71bc8ea..aa14638 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -124,12 +124,17 @@ enum hisi_sas_bit_err_type {
 	HISI_SAS_ERR_MULTI_BIT_ECC = 0x1,
 };
 
+enum hisi_sas_phy_event {
+	HISI_PHYE_PHY_UP   = 0U,
+	HISI_PHYES_NUM,
+};
+
 struct hisi_sas_phy {
+	struct work_struct	works[HISI_PHYES_NUM];
 	struct hisi_hba	*hisi_hba;
 	struct hisi_sas_port	*port;
 	struct asd_sas_phy	sas_phy;
 	struct sas_identify	identify;
-	struct work_struct	phyup_ws;
 	u64		port_id; /* from hw */
 	u64		dev_sas_addr;
 	u64		frame_rcvd_size;
@@ -453,4 +458,6 @@ extern void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
 extern void hisi_sas_rst_work_handler(struct work_struct *work);
 extern void hisi_sas_sync_rst_work_handler(struct work_struct *work);
 extern void hisi_sas_kill_tasklets(struct hisi_hba *hisi_hba);
+extern bool hisi_sas_notify_phy_event(struct hisi_sas_phy *phy,
+				enum hisi_sas_phy_event event);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 1f6f063..326dc81 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -622,7 +622,7 @@ static int hisi_sas_scan_finished(struct Scsi_Host *shost, unsigned long time)
 static void hisi_sas_phyup_work(struct work_struct *work)
 {
 	struct hisi_sas_phy *phy =
-		container_of(work, struct hisi_sas_phy, phyup_ws);
+		container_of(work, typeof(*phy), works[HISI_PHYE_PHY_UP]);
 	struct hisi_hba *hisi_hba = phy->hisi_hba;
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	int phy_no = sas_phy->id;
@@ -631,10 +631,27 @@ static void hisi_sas_phyup_work(struct work_struct *work)
 	hisi_sas_bytes_dmaed(hisi_hba, phy_no);
 }
 
+static const work_func_t hisi_sas_phye_fns[HISI_PHYES_NUM] = {
+	[HISI_PHYE_PHY_UP] = hisi_sas_phyup_work,
+};
+
+bool hisi_sas_notify_phy_event(struct hisi_sas_phy *phy,
+				enum hisi_sas_phy_event event)
+{
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+
+	if (WARN_ON(event >= HISI_PHYES_NUM))
+		return false;
+
+	return queue_work(hisi_hba->wq, &phy->works[event]);
+}
+EXPORT_SYMBOL_GPL(hisi_sas_notify_phy_event);
+
 static void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 {
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	int i;
 
 	phy->hisi_hba = hisi_hba;
 	phy->port = NULL;
@@ -652,7 +669,8 @@ static void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 	sas_phy->ha = (struct sas_ha_struct *)hisi_hba->shost->hostdata;
 	sas_phy->lldd_phy = phy;
 
-	INIT_WORK(&phy->phyup_ws, hisi_sas_phyup_work);
+	for (i = 0; i < HISI_PHYES_NUM; i++)
+		INIT_WORK(&phy->works[i], hisi_sas_phye_fns[i]);
 }
 
 static void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 8cb9061..679e76f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1482,7 +1482,7 @@ static irqreturn_t int_phyup_v1_hw(int irq_no, void *p)
 	else if (phy->identify.device_type != SAS_PHY_UNUSED)
 		phy->identify.target_port_protocols =
 			SAS_PROTOCOL_SMP;
-	queue_work(hisi_hba->wq, &phy->phyup_ws);
+	hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP);
 
 end:
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 7257311..e521c42 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2708,7 +2708,7 @@ static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 		if (!timer_pending(&hisi_hba->timer))
 			set_link_timer_quirk(hisi_hba);
 	}
-	queue_work(hisi_hba->wq, &phy->phyup_ws);
+	hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP);
 
 end:
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
@@ -3262,7 +3262,7 @@ static irqreturn_t sata_int_v2_hw(int irq_no, void *p)
 	phy->identify.device_type = SAS_SATA_DEV;
 	phy->frame_rcvd_size = sizeof(struct dev_to_host_fis);
 	phy->identify.target_port_protocols = SAS_PROTOCOL_SATA;
-	queue_work(hisi_hba->wq, &phy->phyup_ws);
+	hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP);
 
 end:
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC1 + offset, ent_tmp);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 67020bd..4b7f251 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1192,7 +1192,7 @@ static int phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 
 	phy->port_id = port_id;
 	phy->phy_attached = 1;
-	queue_work(hisi_hba->wq, &phy->phyup_ws);
+	hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP);
 
 end:
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
-- 
1.9.1
