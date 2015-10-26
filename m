From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 30/32] scsi: hisi_sas: add control phy handler
Date: Mon, 26 Oct 2015 22:15:01 +0800
Message-ID: <1445868903-183817-31-git-send-email-john.garry@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Add method for lldd_control_phy. Currently link rate
control and spinup hold is unsupported.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 +++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 37 ++++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 23 +++++++++++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index fae73cd..982b51d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -140,6 +140,9 @@ struct hisi_sas_hw {
 			struct hisi_sas_slot *slot);
 	int (*slot_complete)(struct hisi_hba *hisi_hba,
 			     struct hisi_sas_slot *slot, int abort);
+	void (*phy_enable)(struct hisi_hba *hisi_hba, int phy_no);
+	void (*phy_disable)(struct hisi_hba *hisi_hba, int phy_no);
+	void (*phy_hard_reset)(struct hisi_hba *hisi_hba, int phy_no);
 	void (*free_device)(struct hisi_hba *hisi_hba,
 			    struct hisi_sas_device *dev);
 	int (*get_wideport_bitmap)(struct hisi_hba *hisi_hba, int port_id);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 4f3a818..d21491a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -641,6 +641,42 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 	return hisi_sas_task_exec(task, gfp_flags, NULL, 0, NULL);
 }
 
+static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
+				void *funcdata)
+{
+	struct sas_ha_struct *sas_ha = sas_phy->ha;
+	struct hisi_hba *hisi_hba = NULL;
+	int phy_no = 0;
+
+	while (sas_ha->sas_phy[phy_no]) {
+		if (sas_ha->sas_phy[phy_no] == sas_phy) {
+			hisi_hba = (struct hisi_hba *)sas_ha->lldd_ha;
+			break;
+		}
+		phy_no++;
+	}
+
+	switch (func) {
+	case PHY_FUNC_HARD_RESET:
+		hisi_hba->hw->phy_hard_reset(hisi_hba, phy_no);
+		break;
+
+	case PHY_FUNC_LINK_RESET:
+		hisi_hba->hw->phy_enable(hisi_hba, phy_no);
+		hisi_hba->hw->phy_hard_reset(hisi_hba, phy_no);
+		break;
+
+	case PHY_FUNC_DISABLE:
+		hisi_hba->hw->phy_disable(hisi_hba, phy_no);
+		break;
+
+	case PHY_FUNC_SET_LINK_RATE:
+	case PHY_FUNC_RELEASE_SPINUP_HOLD:
+	default:
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
 
 static void hisi_sas_task_done(struct sas_task *task)
 {
@@ -1027,6 +1063,7 @@ static struct sas_domain_function_template hisi_sas_transport_ops = {
 	.lldd_dev_found		= hisi_sas_dev_found,
 	.lldd_dev_gone		= hisi_sas_dev_gone,
 	.lldd_execute_task	= hisi_sas_queue_command,
+	.lldd_control_phy	= hisi_sas_control_phy,
 	.lldd_abort_task	= hisi_sas_abort_task,
 	.lldd_abort_task_set	= hisi_sas_abort_task_set,
 	.lldd_clear_aca		= hisi_sas_clear_aca,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 0a2f97e..d7ad515 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -763,6 +763,14 @@ static void enable_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
 }
 
+static void disable_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
+
+	cfg &= ~PHY_CFG_ENA_MSK;
+	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
+}
+
 static void start_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	config_id_frame_v1_hw(hisi_hba, phy_no);
@@ -771,6 +779,18 @@ static void start_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 	enable_phy_v1_hw(hisi_hba, phy_no);
 }
 
+static void stop_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	disable_phy_v1_hw(hisi_hba, phy_no);
+}
+
+static void phy_hard_reset_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	stop_phy_v1_hw(hisi_hba, phy_no);
+	msleep(100);
+	start_phy_v1_hw(hisi_hba, phy_no);
+}
+
 static void start_phys_v1_hw(unsigned long data)
 {
 	struct hisi_hba *hisi_hba = (struct hisi_hba *)data;
@@ -1713,6 +1733,9 @@ static const struct hisi_sas_hw hisi_sas_v1_hw = {
 	.get_free_slot = get_free_slot_v1_hw,
 	.start_delivery = start_delivery_v1_hw,
 	.slot_complete = slot_complete_v1_hw,
+	.phy_enable = enable_phy_v1_hw,
+	.phy_disable = disable_phy_v1_hw,
+	.phy_hard_reset = phy_hard_reset_v1_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v1_hw,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v1_hdr),
 };
-- 
1.9.1
