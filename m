From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 2/3] scsi: libsas: fix error when getting phy events
Date: Tue, 2 Jan 2018 20:15:09 +0800
Message-ID: <20180102121510.12570-3-yanaijie@huawei.com>
References: <20180102121510.12570-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3260 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752158AbeABMIR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Jan 2018 07:08:17 -0500
In-Reply-To: <20180102121510.12570-1-yanaijie@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, zhaohongjiang@huawei.com, miaoxie@huawei.com, hch@lst.de, hare@suse.com, Jason Yan <yanaijie@huawei.com>, John Garry <john.garry@huawei.com>, chenqilin <chenqilin2@huawei.com>, chenxiang <chenxiang66@hisilicon.com>

The intend purpose here was to goto out if smp_execute_task() returned
error. Obviously something got screwed up. We will never get these link
error statistics below:

~:/sys/class/sas_phy/phy-1:0:12 # cat invalid_dword_count
0
~:/sys/class/sas_phy/phy-1:0:12 # cat running_disparity_error_count
0
~:/sys/class/sas_phy/phy-1:0:12 # cat loss_of_dword_sync_count
0
~:/sys/class/sas_phy/phy-1:0:12 # cat phy_reset_problem_count
0

Obviously we should goto error handler if smp_execute_task() returns
non-zero.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: chenqilin <chenqilin2@huawei.com>
CC: chenxiang <chenxiang66@hisilicon.com>
---
 drivers/scsi/libsas/sas_expander.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 4b0c67f..6eab487 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -686,7 +686,7 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
 	res = smp_execute_task(dev, req, RPEL_REQ_SIZE,
 			            resp, RPEL_RESP_SIZE);
 
-	if (!res)
+	if (res)
 		goto out;
 
 	phy->invalid_dword_count = scsi_to_u32(&resp[12]);
-- 
2.9.5
