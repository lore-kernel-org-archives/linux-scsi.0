From: John Garry <john.garry@huawei.com>
Subject: [PATCH 9/9] scsi: hisi_sas: Add SATA FIS check for v3 hw
Date: Wed, 18 Jul 2018 22:14:33 +0800
Message-ID: <1531923273-193768-10-git-send-email-john.garry@huawei.com>
References: <1531923273-193768-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531923273-193768-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Add a check ERR bit of status to decide whether there is something wrong
with initial register-D2H FIS. If error exist, PHY link reset the channel
to restart OOB.

Directly call work HISI_PHYE_LINK_RESET replacing disable_phy_vx_hw() and
enable_phy_vx_hw().

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  3 +--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 ++++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 5a3d6a7..9c5c5a6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3240,8 +3240,7 @@ static irqreturn_t sata_int_v2_hw(int irq_no, void *p)
 	if (fis->status & ATA_ERR) {
 		dev_warn(dev, "sata int: phy%d FIS status: 0x%x\n", phy_no,
 				fis->status);
-		disable_phy_v2_hw(hisi_hba, phy_no);
-		enable_phy_v2_hw(hisi_hba, phy_no);
+		hisi_sas_notify_phy_event(phy, HISI_PHYE_LINK_RESET);
 		res = IRQ_NONE;
 		goto end;
 	}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 70e2299..08b503e2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1191,6 +1191,16 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 		dev_info(dev, "phyup: phy%d link_rate=%d(sata)\n", phy_no, link_rate);
 		initial_fis = &hisi_hba->initial_fis[phy_no];
 		fis = &initial_fis->fis;
+
+		/* check ERR bit of Status Register */
+		if (fis->status & ATA_ERR) {
+			dev_warn(dev, "sata int: phy%d FIS status: 0x%x\n",
+				 phy_no, fis->status);
+			hisi_sas_notify_phy_event(phy, HISI_PHYE_LINK_RESET);
+			res = IRQ_NONE;
+			goto end;
+		}
+
 		sas_phy->oob_mode = SATA_OOB_MODE;
 		attached_sas_addr[0] = 0x50;
 		attached_sas_addr[7] = phy_no;
-- 
1.9.1
