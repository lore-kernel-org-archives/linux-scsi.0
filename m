From: John Garry <john.garry@huawei.com>
Subject: [PATCH 3/9] scsi: hisi_sas: Fix for setting the PHY linkrate when disconnected
Date: Thu, 11 Apr 2019 20:46:38 +0800
Message-ID: <1554986804-233706-4-git-send-email-john.garry@huawei.com>
References: <1554986804-233706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554986804-233706-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

In commit efdcad62e7b8 ("scsi: hisi_sas: Set PHY linkrate when
disconnected"), we use the sas_phy_data.enable flag to track whether
the PHY was enabled or not, so that we know if we should set the
PHY negotiated linkrate at SAS_LINK_RATE_UNKNOWN or SAS_PHY_DISABLED.

However, it is not proper to use sas_phy_data.enable, since it is
only set when libsas attempts to set the PHY disabled/enabled; hence,
it may not even have an initial value.

As a solution to this problem, introduce hisi_sas_phy.enable to track
whether the PHY is enabled or not, so that we can set the negotiated
linkrate properly when the PHY comes down.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 43 ++++++++++++++++++++------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 11 ++-----
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  6 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  6 ++--
 5 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 9bfa9f12d81e..fc87994b5d73 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -170,6 +170,7 @@ struct hisi_sas_phy {
 	u32		code_violation_err_count;
 	enum sas_linkrate	minimum_linkrate;
 	enum sas_linkrate	maximum_linkrate;
+	int enable;
 };
 
 struct hisi_sas_port {
@@ -551,6 +552,8 @@ extern int hisi_sas_slave_configure(struct scsi_device *sdev);
 extern int hisi_sas_scan_finished(struct Scsi_Host *shost, unsigned long time);
 extern void hisi_sas_scan_start(struct Scsi_Host *shost);
 extern int hisi_sas_host_reset(struct Scsi_Host *shost, int reset_type);
+extern void hisi_sas_phy_enable(struct hisi_hba *hisi_hba, int phy_no,
+				int enable);
 extern void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy);
 extern void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
 				    struct sas_task *task,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index e7401e2bea27..d4da537f9a45 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -10,7 +10,6 @@
  */
 
 #include "hisi_sas.h"
-#include "../libsas/sas_internal.h"
 #define DRV_NAME "hisi_sas"
 
 #define DEV_IS_GONE(dev) \
@@ -171,7 +170,7 @@ void hisi_sas_stop_phys(struct hisi_hba *hisi_hba)
 	int phy_no;
 
 	for (phy_no = 0; phy_no < hisi_hba->n_phy; phy_no++)
-		hisi_hba->hw->phy_disable(hisi_hba, phy_no);
+		hisi_sas_phy_enable(hisi_hba, phy_no, 0);
 }
 EXPORT_SYMBOL_GPL(hisi_sas_stop_phys);
 
@@ -976,6 +975,30 @@ static void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 	timer_setup(&phy->timer, hisi_sas_wait_phyup_timedout, 0);
 }
 
+/* Wrapper to ensure we track hisi_sas_phy.enable properly */
+void hisi_sas_phy_enable(struct hisi_hba *hisi_hba, int phy_no, int enable)
+{
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct asd_sas_phy *aphy = &phy->sas_phy;
+	struct sas_phy *sphy = aphy->phy;
+	unsigned long flags;
+
+	spin_lock_irqsave(&phy->lock, flags);
+
+	if (enable) {
+		/* We may have been enabled already; if so, don't touch */
+		if (!phy->enable)
+			sphy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
+		hisi_hba->hw->phy_start(hisi_hba, phy_no);
+	} else {
+		sphy->negotiated_linkrate = SAS_PHY_DISABLED;
+		hisi_hba->hw->phy_disable(hisi_hba, phy_no);
+	}
+	phy->enable = enable;
+	spin_unlock_irqrestore(&phy->lock, flags);
+}
+EXPORT_SYMBOL_GPL(hisi_sas_phy_enable);
+
 static void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy)
 {
 	struct sas_ha_struct *sas_ha = sas_phy->ha;
@@ -1112,10 +1135,10 @@ static int hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
 	sas_phy->phy->maximum_linkrate = max;
 	sas_phy->phy->minimum_linkrate = min;
 
-	hisi_hba->hw->phy_disable(hisi_hba, phy_no);
+	hisi_sas_phy_enable(hisi_hba, phy_no, 0);
 	msleep(100);
 	hisi_hba->hw->phy_set_linkrate(hisi_hba, phy_no, &_r);
-	hisi_hba->hw->phy_start(hisi_hba, phy_no);
+	hisi_sas_phy_enable(hisi_hba, phy_no, 1);
 
 	return 0;
 }
@@ -1133,13 +1156,13 @@ static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 
 	case PHY_FUNC_LINK_RESET:
-		hisi_hba->hw->phy_disable(hisi_hba, phy_no);
+		hisi_sas_phy_enable(hisi_hba, phy_no, 0);
 		msleep(100);
-		hisi_hba->hw->phy_start(hisi_hba, phy_no);
+		hisi_sas_phy_enable(hisi_hba, phy_no, 1);
 		break;
 
 	case PHY_FUNC_DISABLE:
-		hisi_hba->hw->phy_disable(hisi_hba, phy_no);
+		hisi_sas_phy_enable(hisi_hba, phy_no, 0);
 		break;
 
 	case PHY_FUNC_SET_LINK_RATE:
@@ -2172,16 +2195,18 @@ static void hisi_sas_phy_disconnected(struct hisi_sas_phy *phy)
 {
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	struct sas_phy *sphy = sas_phy->phy;
-	struct sas_phy_data *d = sphy->hostdata;
+	unsigned long flags;
 
 	phy->phy_attached = 0;
 	phy->phy_type = 0;
 	phy->port = NULL;
 
-	if (d->enable)
+	spin_lock_irqsave(&phy->lock, flags);
+	if (phy->enable)
 		sphy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
 	else
 		sphy->negotiated_linkrate = SAS_PHY_DISABLED;
+	spin_unlock_irqrestore(&phy->lock, flags);
 }
 
 void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 078ddd3871f2..717972283acf 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -798,16 +798,11 @@ static void start_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 	enable_phy_v1_hw(hisi_hba, phy_no);
 }
 
-static void stop_phy_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
-{
-	disable_phy_v1_hw(hisi_hba, phy_no);
-}
-
 static void phy_hard_reset_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
-	stop_phy_v1_hw(hisi_hba, phy_no);
+	hisi_sas_phy_enable(hisi_hba, phy_no, 0);
 	msleep(100);
-	start_phy_v1_hw(hisi_hba, phy_no);
+	hisi_sas_phy_enable(hisi_hba, phy_no, 1);
 }
 
 static void start_phys_v1_hw(struct timer_list *t)
@@ -817,7 +812,7 @@ static void start_phys_v1_hw(struct timer_list *t)
 
 	for (i = 0; i < hisi_hba->n_phy; i++) {
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2_MSK, 0x12a);
-		start_phy_v1_hw(hisi_hba, i);
+		hisi_sas_phy_enable(hisi_hba, i, 1);
 	}
 }
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 33b72c7f72c5..3696cfe48574 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1546,14 +1546,14 @@ static void phy_hard_reset_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	u32 txid_auto;
 
-	disable_phy_v2_hw(hisi_hba, phy_no);
+	hisi_sas_phy_enable(hisi_hba, phy_no, 0);
 	if (phy->identify.device_type == SAS_END_DEVICE) {
 		txid_auto = hisi_sas_phy_read32(hisi_hba, phy_no, TXID_AUTO);
 		hisi_sas_phy_write32(hisi_hba, phy_no, TXID_AUTO,
 					txid_auto | TX_HARDRST_MSK);
 	}
 	msleep(100);
-	start_phy_v2_hw(hisi_hba, phy_no);
+	hisi_sas_phy_enable(hisi_hba, phy_no, 1);
 }
 
 static void phy_get_events_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
@@ -1586,7 +1586,7 @@ static void phys_init_v2_hw(struct hisi_hba *hisi_hba)
 		if (!sas_phy->phy->enabled)
 			continue;
 
-		start_phy_v2_hw(hisi_hba, i);
+		hisi_sas_phy_enable(hisi_hba, i, 1);
 	}
 }
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e8323d038d53..3b33816ea6e6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -856,14 +856,14 @@ static void phy_hard_reset_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	u32 txid_auto;
 
-	disable_phy_v3_hw(hisi_hba, phy_no);
+	hisi_sas_phy_enable(hisi_hba, phy_no, 0);
 	if (phy->identify.device_type == SAS_END_DEVICE) {
 		txid_auto = hisi_sas_phy_read32(hisi_hba, phy_no, TXID_AUTO);
 		hisi_sas_phy_write32(hisi_hba, phy_no, TXID_AUTO,
 					txid_auto | TX_HARDRST_MSK);
 	}
 	msleep(100);
-	start_phy_v3_hw(hisi_hba, phy_no);
+	hisi_sas_phy_enable(hisi_hba, phy_no, 1);
 }
 
 static enum sas_linkrate phy_get_max_linkrate_v3_hw(void)
@@ -882,7 +882,7 @@ static void phys_init_v3_hw(struct hisi_hba *hisi_hba)
 		if (!sas_phy->phy->enabled)
 			continue;
 
-		start_phy_v3_hw(hisi_hba, i);
+		hisi_sas_phy_enable(hisi_hba, i, 1);
 	}
 }
 
-- 
2.17.1
