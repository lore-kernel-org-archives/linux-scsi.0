From: John Garry <john.garry@huawei.com>
Subject: [PATCH 08/13] scsi: hisi_sas: Reject setting programmed minimum linkrate > 1.5G
Date: Fri, 25 Jan 2019 22:22:34 +0800
Message-ID: <1548426159-225679-9-git-send-email-john.garry@huawei.com>
References: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

The SAS controller cannot support a programmed minimum linkrate of
> 1.5G (it will always negotiate to 1.5G at least), so just reject it.

This solves a strange situation where the PHY negotiated linkrate may
be less than the programmed minimum linkrate.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 8f7f82d..32f6928 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -946,7 +946,7 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 	return hisi_sas_task_exec(task, gfp_flags, 0, NULL);
 }
 
-static void hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
+static int hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
 			struct sas_phy_linkrates *r)
 {
 	struct sas_phy_linkrates _r;
@@ -955,6 +955,9 @@ static void hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	enum sas_linkrate min, max;
 
+	if (r->minimum_linkrate > SAS_LINK_RATE_1_5_GBPS)
+		return -EINVAL;
+
 	if (r->maximum_linkrate == SAS_LINK_RATE_UNKNOWN) {
 		max = sas_phy->phy->maximum_linkrate;
 		min = r->minimum_linkrate;
@@ -962,7 +965,7 @@ static void hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
 		max = r->maximum_linkrate;
 		min = sas_phy->phy->minimum_linkrate;
 	} else
-		return;
+		return -EINVAL;
 
 	_r.maximum_linkrate = max;
 	_r.minimum_linkrate = min;
@@ -974,6 +977,8 @@ static void hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
 	msleep(100);
 	hisi_hba->hw->phy_set_linkrate(hisi_hba, phy_no, &_r);
 	hisi_hba->hw->phy_start(hisi_hba, phy_no);
+
+	return 0;
 }
 
 static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
@@ -999,8 +1004,7 @@ static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 
 	case PHY_FUNC_SET_LINK_RATE:
-		hisi_sas_phy_set_linkrate(hisi_hba, phy_no, funcdata);
-		break;
+		return hisi_sas_phy_set_linkrate(hisi_hba, phy_no, funcdata);
 	case PHY_FUNC_GET_EVENTS:
 		if (hisi_hba->hw->get_events) {
 			hisi_hba->hw->get_events(hisi_hba, phy_no);
-- 
1.9.1
