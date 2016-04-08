From: John Garry <john.garry@huawei.com>
Subject: [PATCH 3/5] hisi_sas: add v2 hw support for >4 SATA phys
Date: Fri, 8 Apr 2016 17:23:13 +0800
Message-ID: <1460107395-24501-4-git-send-email-john.garry@huawei.com>
References: <1460107395-24501-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:2255 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbcDHJI3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2016 05:08:29 -0400
In-Reply-To: <1460107395-24501-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

This patch adds support for directly attaching SATA
disks to phy 4-8. The problem was that only registers
concerned with phy 0-3 were being considered in
sata_int_v2_hw().
The issue was not detected previously as the
development board only exposed phy 0-3; the new
board provides access to 8 phys.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 5a7f709..cc083b9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1993,17 +1993,20 @@ static irqreturn_t sata_int_v2_hw(int irq_no, void *p)
 	u32 ent_tmp, ent_msk, ent_int, port_id, link_rate, hard_phy_linkrate;
 	irqreturn_t res = IRQ_HANDLED;
 	u8 attached_sas_addr[SAS_ADDR_SIZE] = {0};
-	int phy_no;
+	int phy_no, offset;
 
 	phy_no = sas_phy->id;
 	initial_fis = &hisi_hba->initial_fis[phy_no];
 	fis = &initial_fis->fis;
 
-	ent_msk = hisi_sas_read32(hisi_hba, ENT_INT_SRC_MSK1);
-	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1, ent_msk | 1 << phy_no);
+	offset = 4 * (phy_no / 4);
+	ent_msk = hisi_sas_read32(hisi_hba, ENT_INT_SRC_MSK1 + offset);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1 + offset,
+			 ent_msk | 1 << ((phy_no % 4) * 8));
 
-	ent_int = hisi_sas_read32(hisi_hba, ENT_INT_SRC1);
-	ent_tmp = ent_int & (1 << (ENT_INT_SRC1_D2H_FIS_CH1_OFF * phy_no));
+	ent_int = hisi_sas_read32(hisi_hba, ENT_INT_SRC1 + offset);
+	ent_tmp = ent_int & (1 << (ENT_INT_SRC1_D2H_FIS_CH1_OFF *
+			     (phy_no % 4)));
 	ent_int >>= ENT_INT_SRC1_D2H_FIS_CH1_OFF * (phy_no % 4);
 	if ((ent_int & ENT_INT_SRC1_D2H_FIS_CH0_MSK) == 0) {
 		dev_warn(dev, "sata int: phy%d did not receive FIS\n", phy_no);
@@ -2054,8 +2057,8 @@ static irqreturn_t sata_int_v2_hw(int irq_no, void *p)
 	queue_work(hisi_hba->wq, &phy->phyup_ws);
 
 end:
-	hisi_sas_write32(hisi_hba, ENT_INT_SRC1, ent_tmp);
-	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1, ent_msk);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC1 + offset, ent_tmp);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1 + offset, ent_msk);
 
 	return res;
 }
-- 
1.9.1

