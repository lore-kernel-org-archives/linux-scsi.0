From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 23/25] scsi: hisi_sas: add control phy handler
Date: Mon, 12 Oct 2015 23:20:35 +0800
Message-ID: <1444663237-238302-24-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Cc: linux-kernel-u79uwXL29TZ19SzzRMN9sA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Add method for lldd_control_phy. Currently link rate
control and spinup hold is unsupported.

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  7 ++++
 drivers/scsi/hisi_sas/hisi_sas_init.c  |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 64 ++++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 22 ++++++++++++
 4 files changed, 94 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index b488fe3..be91b8c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -133,6 +133,7 @@ struct hisi_sas_tei {
 };
 
 enum hisi_sas_wq_event {
+	CONTROL_PHY,
 	PHYUP,
 };
 
@@ -360,6 +361,9 @@ void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int i);
 int hisi_sas_dev_found(struct domain_device *dev);
 void hisi_sas_dev_gone(struct domain_device *dev);
 int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags);
+int hisi_sas_control_phy(struct asd_sas_phy *sas_phy,
+			enum phy_func func,
+			void *funcdata);
 int hisi_sas_abort_task(struct sas_task *task);
 int hisi_sas_abort_task_set(struct domain_device *dev, u8 *lun);
 int hisi_sas_clear_aca(struct domain_device *dev, u8 *lun);
@@ -375,6 +379,7 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 			struct hisi_sas_slot *slot);
 
 /* hw specific functions */
+extern void hard_phy_reset_v1_hw(struct hisi_hba *hisi_hba, int phy_no);
 extern int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 			       struct hisi_sas_slot *slot,
 			       int abort);
@@ -392,8 +397,10 @@ extern int interrupt_openall_v1_hw(struct hisi_hba *hisi_hba);
 extern int hw_init_v1_hw(struct hisi_hba *hisi_hba);
 extern int free_device_v1_hw(struct hisi_hba *hisi_hba,
 			     struct hisi_sas_device *dev);
+extern void enable_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no);
 extern int phys_init_v1_hw(struct hisi_hba *hisi_hba);
 extern void sl_notify_v1_hw(struct hisi_hba *hisi_hba, int phy_no);
 extern void setup_itct_v1_hw(struct hisi_hba *hisi_hba,
 			     struct hisi_sas_device *device);
+extern void disable_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
index b6272d8..af4d613e1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
@@ -38,6 +38,7 @@ static struct sas_domain_function_template hisi_sas_transport_ops = {
 	.lldd_dev_found		= hisi_sas_dev_found,
 	.lldd_dev_gone		= hisi_sas_dev_gone,
 	.lldd_execute_task	= hisi_sas_queue_command,
+	.lldd_control_phy	= hisi_sas_control_phy,
 	.lldd_abort_task	= hisi_sas_abort_task,
 	.lldd_abort_task_set	= hisi_sas_abort_task_set,
 	.lldd_clear_aca		= hisi_sas_clear_aca,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 12af29c..1e42611 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -472,6 +472,32 @@ int hisi_sas_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	return 1;
 }
 
+static void hisi_sas_control_phy_work(struct hisi_hba *hisi_hba,
+				int func,
+				int phy_no)
+{
+	struct device *dev = &hisi_hba->pdev->dev;
+
+	switch (func) {
+	case PHY_FUNC_HARD_RESET:
+		hard_phy_reset_v1_hw(hisi_hba, phy_no);
+		break;
+
+	case PHY_FUNC_LINK_RESET:
+		enable_phy_v1_hw(hisi_hba, phy_no);
+		hard_phy_reset_v1_hw(hisi_hba, phy_no);
+		break;
+
+	case PHY_FUNC_DISABLE:
+		disable_phy_v1_hw(hisi_hba, phy_no);
+		break;
+
+	case PHY_FUNC_SET_LINK_RATE:
+	case PHY_FUNC_RELEASE_SPINUP_HOLD:
+	default:
+		dev_err(dev, "Control phy func %d unsupported\n", func);
+	}
+}
 
 static void hisi_sas_phyup_work(struct hisi_hba *hisi_hba,
 				      int phy_no)
@@ -487,8 +513,12 @@ void hisi_sas_wq_process(struct work_struct *work)
 	struct hisi_hba *hisi_hba = wq->hisi_hba;
 	int event = wq->event;
 	int phy_no = wq->phy_no;
+	int func = wq->data;
 
 	switch (event) {
+	case CONTROL_PHY:
+		hisi_sas_control_phy_work(hisi_hba, func, phy_no);
+		break;
 	case PHYUP:
 		hisi_sas_phyup_work(hisi_hba, phy_no);
 		break;
@@ -681,6 +711,40 @@ int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 	return hisi_sas_task_exec(task, gfp_flags, NULL, 0, NULL);
 }
 
+int hisi_sas_control_phy(struct asd_sas_phy *sas_phy,
+			enum phy_func func,
+			void *funcdata)
+{
+	struct sas_ha_struct *sas_ha = sas_phy->ha;
+	struct hisi_hba *hisi_hba = NULL;
+	struct hisi_sas_phy *phy = NULL;
+	int phy_no = 0;
+	struct hisi_sas_wq *wq = kmalloc(sizeof(*wq), GFP_ATOMIC);
+
+	if (!wq)
+		return -ENOMEM;
+
+	while (sas_ha->sas_phy[phy_no]) {
+		if (sas_ha->sas_phy[phy_no] == sas_phy) {
+			hisi_hba = (struct hisi_hba *)sas_ha->lldd_ha;
+			break;
+		}
+		phy_no++;
+	}
+
+	phy = &hisi_hba->phy[phy_no];
+
+	wq->event = CONTROL_PHY;
+	wq->data = func;
+	wq->hisi_hba = hisi_hba;
+	wq->phy_no = phy_no;
+
+	INIT_WORK(&wq->work_struct, hisi_sas_wq_process);
+
+	queue_work(hisi_hba->wq, &wq->work_struct);
+
+	return 0;
+}
 
 static void hisi_sas_task_done(struct sas_task *task)
 {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index b470c72..b5ba46a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -766,6 +766,13 @@ void enable_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
 }
 
+void disable_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
+
+	cfg &= ~PHY_CFG_ENA_MSK;
+	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
+}
 
 static void start_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
@@ -775,6 +782,21 @@ static void start_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 	enable_phy_v1_hw(hisi_hba, phy_no);
 }
 
+static void stop_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	disable_phy_v1_hw(hisi_hba, phy_no);
+}
+
+void hard_phy_reset_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	struct sas_ha_struct *sha = &hisi_hba->sha;
+
+	stop_phy_v1_hw(hisi_hba, phy_no);
+	sas_drain_work(sha);
+	msleep(100);
+	start_phy_v1_hw(hisi_hba, phy_no);
+}
+
 static void start_phys_v1_hw(unsigned long data)
 {
 	struct hisi_hba *hisi_hba = (struct hisi_hba *)data;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
