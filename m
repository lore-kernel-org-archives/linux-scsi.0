From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v4 08/11] scsi: ufs: add add specific callback for hibern8
Date: Wed, 14 Oct 2015 18:25:48 +0530
Message-ID: <1444827351-24128-9-git-send-email-alim.akhtar@samsung.com>
References: <1444827351-24128-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1444827351-24128-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, alim.akhtar@samsung.com, arnd@arndb.de
List-Id: linux-scsi@vger.kernel.org

From: Seungwon Jeon <essuuj@gmail.com>

Some host controller needs specific handling before/after
(un)hibernation, This change adds specific callback function
to support vendor's implementation.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |   33 +++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h |   10 ++++++++++
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index eeb7835c52ab..075b7bf13080 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -181,8 +181,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba);
 static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 				 bool skip_ref_clk);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
-static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
-static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
+static int ufshcd_uic_hibern8_ctrl(struct ufs_hba *hba, bool en);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
@@ -215,6 +214,16 @@ static inline void ufshcd_disable_irq(struct ufs_hba *hba)
 	}
 }
 
+static inline int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
+{
+	return ufshcd_uic_hibern8_ctrl(hba, true);
+}
+
+static inline int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
+{
+	return ufshcd_uic_hibern8_ctrl(hba, false);
+}
+
 /*
  * ufshcd_wait_for_register - wait for register value to change
  * @hba - per-adapter interface
@@ -2394,7 +2403,7 @@ out:
 	return ret;
 }
 
-static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
+static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 {
 	struct uic_command uic_cmd = {0};
 
@@ -2403,7 +2412,7 @@ static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 	return ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 }
 
-static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
+static int __ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 {
 	struct uic_command uic_cmd = {0};
 	int ret;
@@ -2418,6 +2427,22 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	return ret;
 }
 
+static int ufshcd_uic_hibern8_ctrl(struct ufs_hba *hba, bool en)
+{
+	int ret;
+
+	ufshcd_vops_hibern8_notify(hba, en, PRE_CHANGE);
+	ret = en ? __ufshcd_uic_hibern8_enter(hba) :
+			__ufshcd_uic_hibern8_exit(hba);
+	if (ret)
+		goto out;
+
+	ufshcd_vops_hibern8_notify(hba, en, POST_CHANGE);
+
+out:
+	return ret;
+}
+
  /**
  * ufshcd_init_pwr_info - setting the POR (power on reset)
  * values in hba power info
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b3dd08420100..9c69dd2f3672 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -262,6 +262,8 @@ struct ufs_pwr_mode_info {
  * @specify_nexus_t_xfer_req:
  * @specify_nexus_t_tm_req: called before command is issued to allow vendor
  *			specific handling to be set for nexus type.
+ * @hibern8_notify: called before and after hibernate/unhibernate is carried out
+ *		    to allow vendor spesific implementation.
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
  * @dbg_register_dump: used to dump controller debug information
@@ -283,6 +285,7 @@ struct ufs_hba_variant_ops {
 					enum ufs_notify_change_status status,
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
+	void	(*hibern8_notify)(struct ufs_hba *, bool, bool);
 	void	(*specify_nexus_t_xfer_req)(struct ufs_hba *,
 					    int, struct scsi_cmnd *);
 	void	(*specify_nexus_t_tm_req)(struct ufs_hba *, int, u8);
@@ -830,4 +833,11 @@ static inline void ufshcd_vops_specify_nexus_t_tm_req(struct ufs_hba *hba,
 	if (hba->vops && hba->vops->specify_nexus_t_tm_req)
 		hba->vops->specify_nexus_t_tm_req(hba, free_slot, tm_function);
 }
+
+static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
+				bool en, enum ufs_notify_change_status status)
+{
+	if (hba->vops && hba->vops->hibern8_notify)
+		hba->vops->hibern8_notify(hba, en, status);
+}
 #endif /* End of Header */
-- 
1.7.10.4
