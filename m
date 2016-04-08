From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/5] hisi_sas: fix v2 hw multiple SATA disk issue
Date: Fri, 8 Apr 2016 17:23:12 +0800
Message-ID: <1460107395-24501-3-git-send-email-john.garry@huawei.com>
References: <1460107395-24501-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460107395-24501-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Intermittently it is found that when multiple SATA
disks are directly connected to the host that some
disks are not detected.
The problem is that all set bitfields in ENT_INT_SRC1
are cleared for all phys in sata_int_v2_hw() - it
should clear the set bit for the phy being serviced.

Also unnecessary double-write to ENT_INT_SRC1 and
ENT_INT_SRC_MSK1 is removed (remaining writes are
done at end label).

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index f462fc4..5a7f709 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2003,12 +2003,10 @@ static irqreturn_t sata_int_v2_hw(int irq_no, void *p)
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1, ent_msk | 1 << phy_no);
 
 	ent_int = hisi_sas_read32(hisi_hba, ENT_INT_SRC1);
-	ent_tmp = ent_int;
+	ent_tmp = ent_int & (1 << (ENT_INT_SRC1_D2H_FIS_CH1_OFF * phy_no));
 	ent_int >>= ENT_INT_SRC1_D2H_FIS_CH1_OFF * (phy_no % 4);
 	if ((ent_int & ENT_INT_SRC1_D2H_FIS_CH0_MSK) == 0) {
 		dev_warn(dev, "sata int: phy%d did not receive FIS\n", phy_no);
-		hisi_sas_write32(hisi_hba, ENT_INT_SRC1, ent_tmp);
-		hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1, ent_msk);
 		res = IRQ_NONE;
 		goto end;
 	}
-- 
1.9.1
