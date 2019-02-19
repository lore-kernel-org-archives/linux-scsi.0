From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: hisi_sas: remove duplicated code
Date: Tue, 19 Feb 2019 22:40:38 +0800
Message-ID: <20190219144038.26384-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: john.garry@huawei.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

move some functions to hisi_sas_main.c,
which can eliminate redundant code.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  6 ++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 37 +++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 38 ----------------------------------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 37 ---------------------------------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 37 ---------------------------------
 5 files changed, 43 insertions(+), 112 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 6c87bd3..3b00bf6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -561,4 +561,10 @@ extern void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba);
 extern void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba);
 extern void hisi_sas_debugfs_exit(struct hisi_hba *hisi_hba);
 extern void hisi_sas_debugfs_work_handler(struct work_struct *work);
+u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off);
+u32 hisi_sas_read32_relaxed(struct hisi_hba *hisi_hba, u32 off);
+void hisi_sas_write32(struct hisi_hba *hisi_hba, u32 off, u32 val);
+void hisi_sas_phy_write32(struct hisi_hba *hisi_hba, int phy_no,
+			  u32 off, u32 val);
+u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba, int phy_no, u32 off);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9232966..56e98fc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -28,6 +28,43 @@ static void hisi_sas_release_task(struct hisi_hba *hisi_hba,
 				  struct domain_device *device);
 static void hisi_sas_dev_gone(struct domain_device *device);
 
+u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
+{
+	void __iomem *regs = hisi_hba->regs + off;
+
+	return readl(regs);
+}
+
+u32 hisi_sas_read32_relaxed(struct hisi_hba *hisi_hba, u32 off)
+{
+	void __iomem *regs = hisi_hba->regs + off;
+
+	return readl_relaxed(regs);
+}
+
+void hisi_sas_write32(struct hisi_hba *hisi_hba, u32 off, u32 val)
+{
+	void __iomem *regs = hisi_hba->regs + off;
+
+	writel(val, regs);
+}
+
+void hisi_sas_phy_write32(struct hisi_hba *hisi_hba, int phy_no,
+			  u32 off, u32 val)
+{
+	void __iomem *regs = hisi_hba->regs + (0x400 * phy_no) + off;
+
+	writel(val, regs);
+}
+
+u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba,
+			int phy_no, u32 off)
+{
+	void __iomem *regs = hisi_hba->regs + (0x400 * phy_no) + off;
+
+	return readl(regs);
+}
+
 u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis, int direction)
 {
 	switch (fis->command) {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 2938074..41671b2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -416,44 +416,6 @@ enum {
 	(HISI_SAS_PHY_MAX_INT_NR + HISI_SAS_CQ_MAX_INT_NR +\
 	HISI_SAS_FATAL_INT_NR)
 
-static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
-{
-	void __iomem *regs = hisi_hba->regs + off;
-
-	return readl(regs);
-}
-
-static u32 hisi_sas_read32_relaxed(struct hisi_hba *hisi_hba, u32 off)
-{
-	void __iomem *regs = hisi_hba->regs + off;
-
-	return readl_relaxed(regs);
-}
-
-static void hisi_sas_write32(struct hisi_hba *hisi_hba,
-				    u32 off, u32 val)
-{
-	void __iomem *regs = hisi_hba->regs + off;
-
-	writel(val, regs);
-}
-
-static void hisi_sas_phy_write32(struct hisi_hba *hisi_hba,
-					int phy_no, u32 off, u32 val)
-{
-	void __iomem *regs = hisi_hba->regs + (0x400 * phy_no) + off;
-
-	writel(val, regs);
-}
-
-static u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba,
-				      int phy_no, u32 off)
-{
-	void __iomem *regs = hisi_hba->regs + (0x400 * phy_no) + off;
-
-	return readl(regs);
-}
-
 static void config_phy_opt_mode_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index e40cc6b..3827d11 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -731,43 +731,6 @@ enum {
 
 static void link_timeout_disable_link(struct timer_list *t);
 
-static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
-{
-	void __iomem *regs = hisi_hba->regs + off;
-
-	return readl(regs);
-}
-
-static u32 hisi_sas_read32_relaxed(struct hisi_hba *hisi_hba, u32 off)
-{
-	void __iomem *regs = hisi_hba->regs + off;
-
-	return readl_relaxed(regs);
-}
-
-static void hisi_sas_write32(struct hisi_hba *hisi_hba, u32 off, u32 val)
-{
-	void __iomem *regs = hisi_hba->regs + off;
-
-	writel(val, regs);
-}
-
-static void hisi_sas_phy_write32(struct hisi_hba *hisi_hba, int phy_no,
-				 u32 off, u32 val)
-{
-	void __iomem *regs = hisi_hba->regs + (0x400 * phy_no) + off;
-
-	writel(val, regs);
-}
-
-static u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba,
-				      int phy_no, u32 off)
-{
-	void __iomem *regs = hisi_hba->regs + (0x400 * phy_no) + off;
-
-	return readl(regs);
-}
-
 /* This function needs to be protected from pre-emption. */
 static int
 slot_index_alloc_quirk_v2_hw(struct hisi_hba *hisi_hba,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0420df2..4f30eda 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -418,43 +418,6 @@ module_param(auto_affine_msi_experimental, bool, 0444);
 MODULE_PARM_DESC(auto_affine_msi_experimental, "Enable auto-affinity of MSI IRQs as experimental:\n"
 		 "default is off");
 
-static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
-{
-	void __iomem *regs = hisi_hba->regs + off;
-
-	return readl(regs);
-}
-
-static u32 hisi_sas_read32_relaxed(struct hisi_hba *hisi_hba, u32 off)
-{
-	void __iomem *regs = hisi_hba->regs + off;
-
-	return readl_relaxed(regs);
-}
-
-static void hisi_sas_write32(struct hisi_hba *hisi_hba, u32 off, u32 val)
-{
-	void __iomem *regs = hisi_hba->regs + off;
-
-	writel(val, regs);
-}
-
-static void hisi_sas_phy_write32(struct hisi_hba *hisi_hba, int phy_no,
-				 u32 off, u32 val)
-{
-	void __iomem *regs = hisi_hba->regs + (0x400 * phy_no) + off;
-
-	writel(val, regs);
-}
-
-static u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba,
-				      int phy_no, u32 off)
-{
-	void __iomem *regs = hisi_hba->regs + (0x400 * phy_no) + off;
-
-	return readl(regs);
-}
-
 #define hisi_sas_read32_poll_timeout(off, val, cond, delay_us,		\
 				     timeout_us)			\
 ({									\
-- 
2.7.0
