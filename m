From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/7] scsi: hisi_sas: Feed back linkrate(max/min) when re-attached
Date: Mon, 24 Sep 2018 23:06:28 +0800
Message-ID: <1537801594-207139-2-git-send-email-john.garry@huawei.com>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

At directly attached situation, if the user modifies the sysfs interface
of maximum_linkrate and minimum_linkrate to renegotiate the linkrate
between SAS controller and target, the value of both files mentioned above
should have change to user setting after renegotiate is over, but it remain
unchanged.

To fix this bug, maximum_linkrate and minimum_linkrate will be directly
fed back to relevant sas_phy structure.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index a4e2e6a..ba6fb535 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -904,6 +904,9 @@ static void hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
 	_r.maximum_linkrate = max;
 	_r.minimum_linkrate = min;
 
+	sas_phy->phy->maximum_linkrate = max;
+	sas_phy->phy->minimum_linkrate = min;
+
 	hisi_hba->hw->phy_disable(hisi_hba, phy_no);
 	msleep(100);
 	hisi_hba->hw->phy_set_linkrate(hisi_hba, phy_no, &_r);
-- 
1.9.1
