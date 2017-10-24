From: John Garry <john.garry@huawei.com>
Subject: [PATCH 12/19] scsi: hisi_sas: check PHY state in get_wideport_bitmap_v3_hw()
Date: Tue, 24 Oct 2017 23:51:42 +0800
Message-ID: <1508860309-212397-13-git-send-email-john.garry@huawei.com>
References: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

We should check register PHY_STATE when getting the bitmap
of a wideport, as, if the PHY is not ready, the value of
register PHY_PORT_NUM_MA is not valid.

V2 hw has done this check, and v3 hw should do this check too.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 67ebd8f..c88e787 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -755,10 +755,12 @@ static int get_wideport_bitmap_v3_hw(struct hisi_hba *hisi_hba, int port_id)
 {
 	int i, bitmap = 0;
 	u32 phy_port_num_ma = hisi_sas_read32(hisi_hba, PHY_PORT_NUM_MA);
+	u32 phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
 
 	for (i = 0; i < hisi_hba->n_phy; i++)
-		if (((phy_port_num_ma >> (i * 4)) & 0xf) == port_id)
-			bitmap |= 1 << i;
+		if (phy_state & BIT(i))
+			if (((phy_port_num_ma >> (i * 4)) & 0xf) == port_id)
+				bitmap |= BIT(i);
 
 	return bitmap;
 }
-- 
1.9.1
