From: John Garry <john.garry@huawei.com>
Subject: [PATCH 07/23] scsi: hisi_sas: only reset link for PHY_FUNC_LINK_RESET
Date: Thu, 23 Mar 2017 01:25:23 +0800
Message-ID: <1490203539-228029-8-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

We currently do a hard reset for a link reset. Change this
to do a link reset only.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 7c1fb75..00068d2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -659,8 +659,9 @@ static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 
 	case PHY_FUNC_LINK_RESET:
+		hisi_hba->hw->phy_disable(hisi_hba, phy_no);
+		msleep(100);
 		hisi_hba->hw->phy_enable(hisi_hba, phy_no);
-		hisi_hba->hw->phy_hard_reset(hisi_hba, phy_no);
 		break;
 
 	case PHY_FUNC_DISABLE:
-- 
1.9.1
