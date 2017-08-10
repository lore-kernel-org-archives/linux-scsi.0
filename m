From: John Garry <john.garry@huawei.com>
Subject: [PATCH 02/19] scsi: hisi_sas: avoid potential v2 hw interrupt issue
Date: Fri, 11 Aug 2017 00:09:27 +0800
Message-ID: <1502381384-219889-3-git-send-email-john.garry@huawei.com>
References: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3047 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752389AbdHJPmu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2017 11:42:50 -0400
In-Reply-To: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bianpan2016@163.com, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

When some interrupts happen together, we need to process
every interrupt one-by-one, and should not return
immediately when one interrupt process is finished being
processed.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index a6be33c..8c504b4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2606,6 +2606,7 @@ static irqreturn_t int_phy_updown_v2_hw(int irq_no, void *p)
 	struct hisi_hba *hisi_hba = p;
 	u32 irq_msk;
 	int phy_no = 0;
+	irqreturn_t res = IRQ_NONE;
 
 	irq_msk = (hisi_sas_read32(hisi_hba, HGC_INVLD_DQE_INFO)
 		   >> HGC_INVLD_DQE_INFO_FB_CH0_OFF) & 0x1ff;
@@ -2620,15 +2621,15 @@ static irqreturn_t int_phy_updown_v2_hw(int irq_no, void *p)
 			case CHL_INT0_SL_PHY_ENABLE_MSK:
 				/* phy up */
 				if (phy_up_v2_hw(phy_no, hisi_hba) ==
-				    IRQ_NONE)
-					return IRQ_NONE;
+				    IRQ_HANDLED)
+					res = IRQ_HANDLED;
 				break;
 
 			case CHL_INT0_NOT_RDY_MSK:
 				/* phy down */
 				if (phy_down_v2_hw(phy_no, hisi_hba) ==
-				    IRQ_NONE)
-					return IRQ_NONE;
+				    IRQ_HANDLED)
+					res = IRQ_HANDLED;
 				break;
 
 			case (CHL_INT0_NOT_RDY_MSK |
@@ -2638,13 +2639,13 @@ static irqreturn_t int_phy_updown_v2_hw(int irq_no, void *p)
 				if (reg_value & BIT(phy_no)) {
 					/* phy up */
 					if (phy_up_v2_hw(phy_no, hisi_hba) ==
-					    IRQ_NONE)
-						return IRQ_NONE;
+					    IRQ_HANDLED)
+						res = IRQ_HANDLED;
 				} else {
 					/* phy down */
 					if (phy_down_v2_hw(phy_no, hisi_hba) ==
-					    IRQ_NONE)
-						return IRQ_NONE;
+					    IRQ_HANDLED)
+						res = IRQ_HANDLED;
 				}
 				break;
 
@@ -2657,7 +2658,7 @@ static irqreturn_t int_phy_updown_v2_hw(int irq_no, void *p)
 		phy_no++;
 	}
 
-	return IRQ_HANDLED;
+	return res;
 }
 
 static void phy_bcast_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
-- 
1.9.1
