From: John Garry <john.garry@huawei.com>
Subject: [PATCH 6/7] scsi: hisi_sas: fix probe ordering problem
Date: Thu, 19 Jan 2017 00:32:52 +0800
Message-ID: <1484757173-235951-7-git-send-email-john.garry@huawei.com>
References: <1484757173-235951-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484757173-235951-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

There is a potential probe issue in how we trigger the hw initialisation.
Although we use 1s timer to delay hw initialisation, there is still a
potential that sas_register_ha() is not be finished before we start
the PHY init from hw->hw_init().
To avoid this issue, initialise the hw after sas_register_ha() in the
same probe context.
Note: it is not necessary to use 1s timer now (modified v2 hw only).

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 8 ++++----
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 8 ++------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index b2782ce..8601cec 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1552,10 +1552,6 @@ int hisi_sas_probe(struct platform_device *pdev,
 
 	hisi_sas_init_add(hisi_hba);
 
-	rc = hisi_hba->hw->hw_init(hisi_hba);
-	if (rc)
-		goto err_out_ha;
-
 	rc = scsi_add_host(shost, &pdev->dev);
 	if (rc)
 		goto err_out_ha;
@@ -1564,6 +1560,10 @@ int hisi_sas_probe(struct platform_device *pdev,
 	if (rc)
 		goto err_out_register_ha;
 
+	rc = hisi_hba->hw->hw_init(hisi_hba);
+	if (rc)
+		goto err_out_register_ha;
+
 	scsi_scan_host(shost);
 
 	return 0;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 7519772..62655c7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1090,9 +1090,8 @@ static void phy_hard_reset_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 	start_phy_v2_hw(hisi_hba, phy_no);
 }
 
-static void start_phys_v2_hw(unsigned long data)
+static void start_phys_v2_hw(struct hisi_hba *hisi_hba)
 {
-	struct hisi_hba *hisi_hba = (struct hisi_hba *)data;
 	int i;
 
 	for (i = 0; i < hisi_hba->n_phy; i++)
@@ -1101,10 +1100,7 @@ static void start_phys_v2_hw(unsigned long data)
 
 static void phys_init_v2_hw(struct hisi_hba *hisi_hba)
 {
-	struct timer_list *timer = &hisi_hba->timer;
-
-	setup_timer(timer, start_phys_v2_hw, (unsigned long)hisi_hba);
-	mod_timer(timer, jiffies + HZ);
+	start_phys_v2_hw(hisi_hba);
 }
 
 static void sl_notify_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
-- 
1.9.1
