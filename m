From: John Garry <john.garry@huawei.com>
Subject: [PATCH 07/15] hisi_sas: fix phy8 linkrate calculation in phy_up_v2_hw()
Date: Tue, 6 Sep 2016 23:36:17 +0800
Message-ID: <1473176185-217808-8-git-send-email-john.garry@huawei.com>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:47499 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935767AbcIFPXx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2016 11:23:53 -0400
In-Reply-To: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>

In function phy_up_v2_hw(), we needlessly recalculate the
phy linkrate for all phys, and the calculation is incorrect
for phy8, so remove this code.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index aca2b80..ae44443 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1876,9 +1876,6 @@ static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 		frame_rcvd[i] = __swab32(idaf);
 	}
 
-	/* Get the linkrates */
-	link_rate = hisi_sas_read32(hisi_hba, PHY_CONN_RATE);
-	link_rate = (link_rate >> (phy_no * 4)) & 0xf;
 	sas_phy->linkrate = link_rate;
 	hard_phy_linkrate = hisi_sas_phy_read32(hisi_hba, phy_no,
 						HARD_PHY_LINKRATE);
-- 
1.9.1

