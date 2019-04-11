From: John Garry <john.garry@huawei.com>
Subject: [PATCH 5/9] scsi: hisi_sas: allocate different SAS address for directly attached situation
Date: Thu, 11 Apr 2019 20:46:40 +0800
Message-ID: <1554986804-233706-6-git-send-email-john.garry@huawei.com>
References: <1554986804-233706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554986804-233706-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

In commit 8b8d66531555 ("scsi: hisi_sas: make SAS address of SATA
disks unique"), we ensured that each SATA disk in the system has a
unique SAS address, even if it is fake. That was for v2 hw.

Add this for v3 hw.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 3b33816ea6e6..89551b772cd4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1380,6 +1380,7 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 		struct hisi_sas_initial_fis *initial_fis;
 		struct dev_to_host_fis *fis;
 		u8 attached_sas_addr[SAS_ADDR_SIZE] = {0};
+		struct Scsi_Host *shost = hisi_hba->shost;
 
 		dev_info(dev, "phyup: phy%d link_rate=%d(sata)\n", phy_no, link_rate);
 		initial_fis = &hisi_hba->initial_fis[phy_no];
@@ -1396,6 +1397,7 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 
 		sas_phy->oob_mode = SATA_OOB_MODE;
 		attached_sas_addr[0] = 0x50;
+		attached_sas_addr[6] = shost->host_no;
 		attached_sas_addr[7] = phy_no;
 		memcpy(sas_phy->attached_sas_addr,
 		       attached_sas_addr,
-- 
2.17.1
