From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/8] hisi_sas: for internal abort in hisi_sas_dev_gone()
Date: Wed, 10 Aug 2016 21:19:59 +0800
Message-ID: <1470835205-65684-3-git-send-email-john.garry@huawei.com>
References: <1470835205-65684-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dfwrgout.huawei.com ([206.16.17.72]:35134 "EHLO
	dfwrgout.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933587AbcHJTUs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2016 15:20:48 -0400
In-Reply-To: <1470835205-65684-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

Execute an internal abort for that device when it is removed,
so that commands for that device are not processed.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d30ece2..9540953 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -621,6 +621,8 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 	dev_info(dev, "found dev[%lld:%x] is gone\n",
 		 sas_dev->device_id, sas_dev->dev_type);
 
+	hisi_sas_internal_task_abort(hisi_hba, device, 1, 0);
+
 	hisi_hba->hw->free_device(hisi_hba, sas_dev);
 	device->lldd_dev = NULL;
 	memset(sas_dev, 0, sizeof(*sas_dev));
-- 
1.9.1

