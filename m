From: John Garry <john.garry@huawei.com>
Subject: [PATCH 19/23] scsi: hisi_sas: add hisi_sas_clear_nexus_ha()
Date: Thu, 23 Mar 2017 01:25:35 +0800
Message-ID: <1490203539-228029-20-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:4381 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S934865AbdCVQ65 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 12:58:57 -0400
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>

Add function for upper-layer to reset controller
when all else fails.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 3d63a24..f86263b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1070,6 +1070,13 @@ static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
 	return rc;
 }
 
+static int hisi_sas_clear_nexus_ha(struct sas_ha_struct *sas_ha)
+{
+	struct hisi_hba *hisi_hba = sas_ha->lldd_ha;
+
+	return hisi_sas_controller_reset(hisi_hba);
+}
+
 static int hisi_sas_query_task(struct sas_task *task)
 {
 	struct scsi_lun lun;
@@ -1368,6 +1375,7 @@ void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 old_state,
 	.lldd_I_T_nexus_reset	= hisi_sas_I_T_nexus_reset,
 	.lldd_lu_reset		= hisi_sas_lu_reset,
 	.lldd_query_task	= hisi_sas_query_task,
+	.lldd_clear_nexus_ha = hisi_sas_clear_nexus_ha,
 	.lldd_port_formed	= hisi_sas_port_formed,
 };
 
-- 
1.9.1
