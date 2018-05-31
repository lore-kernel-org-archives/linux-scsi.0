From: John Garry <john.garry@huawei.com>
Subject: [PATCH 5/9] scsi: hisi_sas: Add a flag to filter PHY events during reset
Date: Thu, 31 May 2018 20:50:46 +0800
Message-ID: <1527771050-200916-6-git-send-email-john.garry@huawei.com>
References: <1527771050-200916-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527771050-200916-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

During reset, we don't want PHY events reported to libsas for PHYs which
were previously attached prior to reset.

So check hisi_hba->flags for HISI_SAS_RESET_BIT to filter PHY events
during reset.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 3 ++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 3 ++-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 3 ++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 090d3e0..006e776 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1927,7 +1927,8 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
 	} else {
 		struct hisi_sas_port *port  = phy->port;
 
-		if (phy->in_reset) {
+		if (test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags) ||
+		    phy->in_reset) {
 			dev_info(dev, "ignore flutter phy%d down\n", phy_no);
 			return;
 		}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 89ab18c..3277442 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1469,7 +1469,8 @@ static irqreturn_t int_bcast_v1_hw(int irq, void *p)
 		goto end;
 	}
 
-	sha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+	if (!test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
+		sha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 
 end:
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 213c530..159576e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2840,7 +2840,8 @@ static void phy_bcast_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 1);
 	bcast_status = hisi_sas_phy_read32(hisi_hba, phy_no, RX_PRIMS_STATUS);
-	if (bcast_status & RX_BCAST_CHG_MSK)
+	if ((bcast_status & RX_BCAST_CHG_MSK) &&
+	    !test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
 		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
 			     CHL_INT0_SL_RX_BCST_ACK_MSK);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index c40fdb8..e43881d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1263,7 +1263,8 @@ static irqreturn_t phy_bcast_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 1);
 	bcast_status = hisi_sas_phy_read32(hisi_hba, phy_no, RX_PRIMS_STATUS);
-	if (bcast_status & RX_BCAST_CHG_MSK)
+	if ((bcast_status & RX_BCAST_CHG_MSK) &&
+	    !test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
 		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
 			     CHL_INT0_SL_RX_BCST_ACK_MSK);
-- 
1.9.1
