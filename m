From: John Garry <john.garry@huawei.com>
Subject: [PATCH 4/7] scsi: hisi_sas: modify hard reset for directed-attached disk
Date: Thu, 19 Jan 2017 00:32:50 +0800
Message-ID: <1484757173-235951-5-git-send-email-john.garry@huawei.com>
References: <1484757173-235951-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:36147 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753033AbdARQDr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2017 11:03:47 -0500
In-Reply-To: <1484757173-235951-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

Correctly set registers in v2 for root PHY hardreset for directly
attached disk.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 452e329..7519772 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -207,6 +207,8 @@
 #define TXID_AUTO			(PORT_BASE + 0xb8)
 #define TXID_AUTO_CT3_OFF		1
 #define TXID_AUTO_CT3_MSK		(0x1 << TXID_AUTO_CT3_OFF)
+#define TX_HARDRST_OFF          2
+#define TX_HARDRST_MSK          (0x1 << TX_HARDRST_OFF)
 #define RX_IDAF_DWORD0			(PORT_BASE + 0xc4)
 #define RX_IDAF_DWORD1			(PORT_BASE + 0xc8)
 #define RX_IDAF_DWORD2			(PORT_BASE + 0xcc)
@@ -1075,7 +1077,15 @@ static void stop_phy_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 
 static void phy_hard_reset_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	u32 txid_auto;
+
 	stop_phy_v2_hw(hisi_hba, phy_no);
+	if (phy->identify.device_type == SAS_END_DEVICE) {
+		txid_auto = hisi_sas_phy_read32(hisi_hba, phy_no, TXID_AUTO);
+		hisi_sas_phy_write32(hisi_hba, phy_no, TXID_AUTO,
+					txid_auto | TX_HARDRST_MSK);
+	}
 	msleep(100);
 	start_phy_v2_hw(hisi_hba, phy_no);
 }
-- 
1.9.1

