From: John Garry <john.garry@huawei.com>
Subject: [PATCH 13/19] scsi: hisi_sas: init connect cfg register for v3 hw
Date: Tue, 24 Oct 2017 23:51:43 +0800
Message-ID: <1508860309-212397-14-git-send-email-john.garry@huawei.com>
References: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:9042 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751691AbdJXPIt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2017 11:08:49 -0400
In-Reply-To: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>

From: Xiaofei Tan <tanxiaofei@huawei.com>

Add initialization of register CON_CFG_DRIVER for v3 hw,
to limit number of the times of setup connection.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index c88e787..5fbd121 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -135,6 +135,7 @@
 #define RX_IDAF_DWORD0			(PORT_BASE + 0xc4)
 #define RXOP_CHECK_CFG_H		(PORT_BASE + 0xfc)
 #define STP_LINK_TIMER			(PORT_BASE + 0x120)
+#define CON_CFG_DRIVER			(PORT_BASE + 0x130)
 #define SAS_SSP_CON_TIMER_CFG		(PORT_BASE + 0x134)
 #define SAS_SMP_CON_TIMER_CFG		(PORT_BASE + 0x138)
 #define SAS_STP_CON_TIMER_CFG		(PORT_BASE + 0x13c)
@@ -422,6 +423,8 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 				     0xa03e8);
 		hisi_sas_phy_write32(hisi_hba, i, STP_LINK_TIMER,
 				     0x7f7a120);
+		hisi_sas_phy_write32(hisi_hba, i, CON_CFG_DRIVER,
+				     0x2a0a80);
 	}
 	for (i = 0; i < hisi_hba->queue_count; i++) {
 		/* Delivery queue */
-- 
1.9.1
