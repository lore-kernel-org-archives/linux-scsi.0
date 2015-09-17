From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v2 07/11] scsi: ufs: add add specific callback for hibern8
Date: Thu, 17 Sep 2015 15:15:33 +0530
Message-ID: <1442483137-32376-8-git-send-email-alim.akhtar@samsung.com>
References: <1442483137-32376-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:55923 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbbIQJyy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2015 05:54:54 -0400
In-reply-to: <1442483137-32376-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org

From: Seungwon Jeon <essuuj@gmail.com>

Some host controller needs specific handling before/after
(un)hibernation, This change adds specific callback function
to support vendor's implementation.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |   36 ++++++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h |    3 +++
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2f0de4b..ccf7c83 100644
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
@@ -2395,7 +2404,7 @@ out:
 	return ret;
 }
 
-static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
+static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 {
 	struct uic_command uic_cmd = {0};
 
@@ -2404,7 +2413,7 @@ static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 	return ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 }
 
-static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
+static int __ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 {
 	struct uic_command uic_cmd = {0};
 	int ret;
@@ -2419,6 +2428,25 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	return ret;
 }
 
+static int ufshcd_uic_hibern8_ctrl(struct ufs_hba *hba, bool en)
+{
+	int ret;
+
+	if (hba->vops && hba->vops->hibern8_notify)
+		hba->vops->hibern8_notify(hba, en, PRE_CHANGE);
+
+	ret = en ? __ufshcd_uic_hibern8_enter(hba) :
+			__ufshcd_uic_hibern8_exit(hba);
+	if (ret)
+		goto out;
+
+	if (hba->vops && hba->vops->hibern8_notify)
+		hba->vops->hibern8_notify(hba, en, POST_CHANGE);
+
+out:
+	return ret;
+}
+
  /**
  * ufshcd_init_pwr_info - setting the POR (power on reset)
  * values in hba power info
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 149d74e..2fd0c3c 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -260,6 +260,8 @@ struct ufs_pwr_mode_info {
  * @specify_nexus_t_xfer_req:
  * @specify_nexus_t_tm_req: called before command is issued to allow vendor
  *			specific handling to be set for nexus type.
+ * @hibern8_notify: called before and after hibernate/unhibernate is carried out
+ *		    to allow vendor spesific implementation.
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
  */
@@ -276,6 +278,7 @@ struct ufs_hba_variant_ops {
 	int	(*pwr_change_notify)(struct ufs_hba *,
 					bool, struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
+	void	(*hibern8_notify)(struct ufs_hba *, bool, bool);
 	void	(*specify_nexus_t_xfer_req)(struct ufs_hba *,
 					    int, struct scsi_cmnd *);
 	void	(*specify_nexus_t_tm_req)(struct ufs_hba *, int, u8);
-- 
1.7.10.4

