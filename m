From: John Garry <john.garry@huawei.com>
Subject: [PATCH 3/7] scsi: hisi_sas: downgrade refclk message
Date: Thu, 19 Jan 2017 00:32:49 +0800
Message-ID: <1484757173-235951-4-git-send-email-john.garry@huawei.com>
References: <1484757173-235951-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:36145 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753038AbdARQDj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2017 11:03:39 -0500
In-Reply-To: <1484757173-235951-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

The message to inform that the controller has no refclk
is currently at warning level, which is unnecessary, so
downgrade to debug.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 22dba01..eee7ae2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1453,7 +1453,7 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 
 	refclk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(refclk))
-		dev_info(dev, "no ref clk property\n");
+		dev_dbg(dev, "no ref clk property\n");
 	else
 		hisi_hba->refclk_frequency_mhz = clk_get_rate(refclk) / 1000000;
 
-- 
1.9.1

