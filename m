From: John Garry <john.garry@huawei.com>
Subject: [PATCH 09/11] hisi_sas: check SATA FIS when directly attaching SATA device
Date: Mon, 7 Nov 2016 20:48:38 +0800
Message-ID: <1478522920-108145-10-git-send-email-john.garry@huawei.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, john.garry2@mail.dcu.ie, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Check ERR bit of status to decide whether there is something wrong with
initial register-D2H FIS. If error exists, PHY reset the channel to
restart OOB.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index a5faa4d..cda3baf 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2537,6 +2537,16 @@ static irqreturn_t sata_int_v2_hw(int irq_no, void *p)
 		goto end;
 	}
 
+	/* check ERR bit of Status Register */
+	if (fis->status & ATA_ERR) {
+		dev_warn(dev, "sata int: phy%d FIS status: 0x%x\n", phy_no,
+				fis->status);
+		disable_phy_v2_hw(hisi_hba, phy_no);
+		enable_phy_v2_hw(hisi_hba, phy_no);
+		res = IRQ_NONE;
+		goto end;
+	}
+
 	if (unlikely(phy_no == 8)) {
 		u32 port_state = hisi_sas_read32(hisi_hba, PORT_STATE);
 
-- 
1.9.1
