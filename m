From: John Garry <john.garry@huawei.com>
Subject: [PATCH 17/19] scsi: hisi_sas: fix SAS_QUEUE_FULL problem while running IO
Date: Sat, 9 Dec 2017 01:16:48 +0800
Message-ID: <1512753410-50924-18-git-send-email-john.garry@huawei.com>
References: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:36074 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754199AbdLHQbD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Dec 2017 11:31:03 -0500
In-Reply-To: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

This patch fix SAS_QUEUE_FULL problem. The test situation is
close port while running IO.

In sas_eh_handle_sas_errors(), SCSI EH will free sas_task of
the device if lldd_I_T_nexus_reset() return
TMF_RESP_FUNC_COMPLETE or -ENODEV.
But in our SAS driver, we only free slots of the device when
the return value is TMF_RESP_FUNC_COMPLETE. So if the return
value is -ENODEV, the slot resource will not free any more.

As an solution, we should also free slots of the device in
lldd_I_T_nexus_reset() if the return value is -ENODEV.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 302da84..9bd98e5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1308,7 +1308,7 @@ static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
 
 	rc = hisi_sas_debug_I_T_nexus_reset(device);
 
-	if (rc == TMF_RESP_FUNC_COMPLETE) {
+	if ((rc == TMF_RESP_FUNC_COMPLETE) || (rc == -ENODEV)) {
 		spin_lock_irqsave(&hisi_hba->lock, flags);
 		hisi_sas_release_task(hisi_hba, device);
 		spin_unlock_irqrestore(&hisi_hba->lock, flags);
-- 
1.9.1
