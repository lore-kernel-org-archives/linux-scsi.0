From: John Garry <john.garry@huawei.com>
Subject: [PATCH 09/13] scsi: hisi_sas: Fix losing directly attached disk when hot-plug
Date: Fri, 25 Jan 2019 22:22:35 +0800
Message-ID: <1548426159-225679-10-git-send-email-john.garry@huawei.com>
References: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

Hot-plugging SAS wire of direct hard disk backplane may cause
disk lost. We have done this test with several types of SATA disk from
different venders, and only two models from Seagate has this problem,
ST4000NM0035-1V4107 and ST3000VM002-1ET166.

The root cause is that the disk doesn't send D2H frame after OOB
finished. SAS controller will issue phyup interrupt only when D2H frame
is received, otherwise, will be waiting there all the time.

When this issue happen, we can find the disk again with link reset.
To fix this issue, we setup an timer after OOB finished. If the PHY is
not up in 20s, do link reset. Notes: the 20s is an experience value.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  4 ++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 26 ++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  8 ++++++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 27 ++++++++++++++++++---------
 4 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 235b819..9b35f84 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -76,6 +76,8 @@
 
 #define HISI_SAS_PROT_MASK (HISI_SAS_DIF_PROT_MASK)
 
+#define HISI_SAS_WAIT_PHYUP_TIMEOUT 20
+
 struct hisi_hba;
 
 enum {
@@ -141,6 +143,7 @@ struct hisi_sas_phy {
 	struct asd_sas_phy	sas_phy;
 	struct sas_identify	identify;
 	struct completion *reset_completion;
+	struct timer_list timer;
 	spinlock_t lock;
 	u64		port_id; /* from hw */
 	u64		frame_rcvd_size;
@@ -522,6 +525,7 @@ extern void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
 extern void hisi_sas_rst_work_handler(struct work_struct *work);
 extern void hisi_sas_sync_rst_work_handler(struct work_struct *work);
 extern void hisi_sas_kill_tasklets(struct hisi_hba *hisi_hba);
+extern void hisi_sas_phy_oob_ready(struct hisi_hba *hisi_hba, int phy_no);
 extern bool hisi_sas_notify_phy_event(struct hisi_sas_phy *phy,
 				enum hisi_sas_phy_event event);
 extern void hisi_sas_release_tasks(struct hisi_hba *hisi_hba);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 32f6928..0a817e9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -808,6 +808,30 @@ bool hisi_sas_notify_phy_event(struct hisi_sas_phy *phy,
 }
 EXPORT_SYMBOL_GPL(hisi_sas_notify_phy_event);
 
+static void hisi_sas_wait_phyup_timedout(struct timer_list *t)
+{
+	struct hisi_sas_phy *phy = from_timer(phy, t, timer);
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	struct device *dev = hisi_hba->dev;
+	int phy_no = phy->sas_phy.id;
+
+	dev_warn(dev, "phy%d wait phyup timeout, issuing link reset\n", phy_no);
+	hisi_sas_notify_phy_event(phy, HISI_PHYE_LINK_RESET);
+}
+
+void hisi_sas_phy_oob_ready(struct hisi_hba *hisi_hba, int phy_no)
+{
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct device *dev = hisi_hba->dev;
+
+	if (!timer_pending(&phy->timer)) {
+		dev_dbg(dev, "phy%d OOB ready\n", phy_no);
+		phy->timer.expires = jiffies + HISI_SAS_WAIT_PHYUP_TIMEOUT * HZ;
+		add_timer(&phy->timer);
+	}
+}
+EXPORT_SYMBOL_GPL(hisi_sas_phy_oob_ready);
+
 static void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 {
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
@@ -836,6 +860,8 @@ static void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 		INIT_WORK(&phy->works[i], hisi_sas_phye_fns[i]);
 
 	spin_lock_init(&phy->lock);
+
+	timer_setup(&phy->timer, hisi_sas_wait_phyup_timedout, 0);
 }
 
 static void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 85236ef..6eb76f3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2676,6 +2676,8 @@ static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 	if (is_sata_phy_v2_hw(hisi_hba, phy_no))
 		goto end;
 
+	del_timer(&phy->timer);
+
 	if (phy_no == 8) {
 		u32 port_state = hisi_sas_read32(hisi_hba, PORT_STATE);
 
@@ -2755,6 +2757,7 @@ static int phy_down_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 	struct hisi_sas_port *port = phy->port;
 	struct device *dev = hisi_hba->dev;
 
+	del_timer(&phy->timer);
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_NOT_RDY_MSK, 1);
 
 	phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
@@ -2943,6 +2946,9 @@ static irqreturn_t int_chnl_int_v2_hw(int irq_no, void *p)
 			if (irq_value0 & CHL_INT0_SL_RX_BCST_ACK_MSK)
 				phy_bcast_v2_hw(phy_no, hisi_hba);
 
+			if (irq_value0 & CHL_INT0_PHY_RDY_MSK)
+				hisi_sas_phy_oob_ready(hisi_hba, phy_no);
+
 			hisi_sas_phy_write32(hisi_hba, phy_no,
 					CHL_INT0, irq_value0
 					& (~CHL_INT0_HOTPLUG_TOUT_MSK)
@@ -3226,6 +3232,8 @@ static irqreturn_t sata_int_v2_hw(int irq_no, void *p)
 	unsigned long flags;
 	int phy_no, offset;
 
+	del_timer(&phy->timer);
+
 	phy_no = sas_phy->id;
 	initial_fis = &hisi_hba->initial_fis[phy_no];
 	fis = &initial_fis->fis;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 4b628c2..f1009e2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1290,6 +1290,7 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 	struct device *dev = hisi_hba->dev;
 	unsigned long flags;
 
+	del_timer(&phy->timer);
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_PHY_ENA_MSK, 1);
 
 	port_id = hisi_sas_read32(hisi_hba, PHY_PORT_NUM_MA);
@@ -1383,9 +1384,11 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 
 static irqreturn_t phy_down_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	u32 phy_state, sl_ctrl, txid_auto;
 	struct device *dev = hisi_hba->dev;
 
+	del_timer(&phy->timer);
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_NOT_RDY_MSK, 1);
 
 	phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
@@ -1554,6 +1557,19 @@ static void handle_chl_int2_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2, irq_value);
 }
 
+static void handle_chl_int0_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 irq_value0 = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT0);
+
+	if (irq_value0 & CHL_INT0_PHY_RDY_MSK)
+		hisi_sas_phy_oob_ready(hisi_hba, phy_no);
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
+			     irq_value0 & (~CHL_INT0_SL_RX_BCST_ACK_MSK)
+			     & (~CHL_INT0_SL_PHY_ENABLE_MSK)
+			     & (~CHL_INT0_NOT_RDY_MSK));
+}
+
 static irqreturn_t int_chnl_int_v3_hw(int irq_no, void *p)
 {
 	struct hisi_hba *hisi_hba = p;
@@ -1564,8 +1580,8 @@ static irqreturn_t int_chnl_int_v3_hw(int irq_no, void *p)
 				& 0xeeeeeeee;
 
 	while (irq_msk) {
-		u32 irq_value0 = hisi_sas_phy_read32(hisi_hba, phy_no,
-						     CHL_INT0);
+		if (irq_msk & (2 << (phy_no * 4)))
+			handle_chl_int0_v3_hw(hisi_hba, phy_no);
 
 		if (irq_msk & (4 << (phy_no * 4)))
 			handle_chl_int1_v3_hw(hisi_hba, phy_no);
@@ -1573,13 +1589,6 @@ static irqreturn_t int_chnl_int_v3_hw(int irq_no, void *p)
 		if (irq_msk & (8 << (phy_no * 4)))
 			handle_chl_int2_v3_hw(hisi_hba, phy_no);
 
-		if (irq_msk & (2 << (phy_no * 4)) && irq_value0) {
-			hisi_sas_phy_write32(hisi_hba, phy_no,
-					CHL_INT0, irq_value0
-					& (~CHL_INT0_SL_RX_BCST_ACK_MSK)
-					& (~CHL_INT0_SL_PHY_ENABLE_MSK)
-					& (~CHL_INT0_NOT_RDY_MSK));
-		}
 		irq_msk &= ~(0xe << (phy_no * 4));
 		phy_no++;
 	}
-- 
1.9.1
