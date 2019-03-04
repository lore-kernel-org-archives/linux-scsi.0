From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/4] scsi: ufs: hisi: fix ufs_hba_variant_ops passing
Date: Mon,  4 Mar 2019 20:39:11 +0100
Message-ID: <20190304193917.702601-4-arnd@arndb.de>
References: <20190304193917.702601-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190304193917.702601-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Wei Li <liwei213@huawei.com>, Subhash Jadavani <subhashj@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Without CONFIG_OF, the of_match_node() helper does not evaluate
its argument, and the compiler warns about the unused variable:

drivers/scsi/ufs/ufs-hisi.c: In function 'ufs_hisi_probe':
drivers/scsi/ufs/ufs-hisi.c:673:17: error: unused variable 'dev' [-Werror=unused-variable]

Rework this code to pass the data directly, and while we're
at it, correctly handle the const pointers.

Fixes: 653fcb07d95e ("scsi: ufs: Add HI3670 SoC UFS driver support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/ufs/ufs-hisi.c      | 11 ++++-------
 drivers/scsi/ufs/ufshcd-pltfrm.c |  2 +-
 drivers/scsi/ufs/ufshcd-pltfrm.h |  2 +-
 drivers/scsi/ufs/ufshcd.h        |  2 +-
 4 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index f2d3df357a97..0e855b5afe82 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -640,7 +640,7 @@ static int ufs_hi3670_init(struct ufs_hba *hba)
 	return 0;
 }
 
-static struct ufs_hba_variant_ops ufs_hba_hi3660_vops = {
+static const struct ufs_hba_variant_ops ufs_hba_hi3660_vops = {
 	.name = "hi3660",
 	.init = ufs_hi3660_init,
 	.link_startup_notify = ufs_hisi_link_startup_notify,
@@ -649,7 +649,7 @@ static struct ufs_hba_variant_ops ufs_hba_hi3660_vops = {
 	.resume = ufs_hisi_resume,
 };
 
-static struct ufs_hba_variant_ops ufs_hba_hi3670_vops = {
+static const struct ufs_hba_variant_ops ufs_hba_hi3670_vops = {
 	.name = "hi3670",
 	.init = ufs_hi3670_init,
 	.link_startup_notify = ufs_hisi_link_startup_notify,
@@ -669,13 +669,10 @@ MODULE_DEVICE_TABLE(of, ufs_hisi_of_match);
 static int ufs_hisi_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id;
-	struct ufs_hba_variant_ops *vops;
-	struct device *dev = &pdev->dev;
 
-	of_id = of_match_node(ufs_hisi_of_match, dev->of_node);
-	vops = (struct ufs_hba_variant_ops *)of_id->data;
+	of_id = of_match_node(ufs_hisi_of_match, pdev->dev.of_node);
 
-	return ufshcd_pltfrm_init(pdev, vops);
+	return ufshcd_pltfrm_init(pdev, of_id->data);
 }
 
 static int ufs_hisi_remove(struct platform_device *pdev)
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 895a9b5ac989..27213676329c 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -297,7 +297,7 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
  * Returns 0 on success, non-zero value on failure
  */
 int ufshcd_pltfrm_init(struct platform_device *pdev,
-		       struct ufs_hba_variant_ops *vops)
+		       const struct ufs_hba_variant_ops *vops)
 {
 	struct ufs_hba *hba;
 	void __iomem *mmio_base;
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.h b/drivers/scsi/ufs/ufshcd-pltfrm.h
index df64c4180340..1f29e1fd6d52 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.h
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.h
@@ -17,7 +17,7 @@
 #include "ufshcd.h"
 
 int ufshcd_pltfrm_init(struct platform_device *pdev,
-		       struct ufs_hba_variant_ops *vops);
+		       const struct ufs_hba_variant_ops *vops);
 void ufshcd_pltfrm_shutdown(struct platform_device *pdev);
 
 #ifdef CONFIG_PM
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 69ba7445d2b3..ecfa898b9ccc 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -546,7 +546,7 @@ struct ufs_hba {
 	int nutrs;
 	int nutmrs;
 	u32 ufs_version;
-	struct ufs_hba_variant_ops *vops;
+	const struct ufs_hba_variant_ops *vops;
 	void *priv;
 	unsigned int irq;
 	bool is_irq_enabled;
-- 
2.20.0
