From: John Garry <john.garry@huawei.com>
Subject: [PATCH 6/9] scsi: hisi_sas: Release all remaining resources in clear nexus ha
Date: Thu, 31 May 2018 20:50:47 +0800
Message-ID: <1527771050-200916-7-git-send-email-john.garry@huawei.com>
References: <1527771050-200916-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527771050-200916-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

In host reset, we use TMF or soft-reset to re-init device, and if success,
we will release all LLDD resources of this device. If the init fails -
maybe because the device was removed or link has not come up - then do not
release the LLDD resources, but rather rely on SCSI EH to handle the
timeout for these resources later on.

But if clear nexus ha calls host reset, which is the last effort of SCSI
EH, we should release all LLDD remain resources. Because SCSI EH will
release all tasks after clear nexus ha.

Before release, we do I_T nexus reset to try to clear target remain IOs.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 006e776..da1d5fe 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1652,14 +1652,32 @@ static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
 static int hisi_sas_clear_nexus_ha(struct sas_ha_struct *sas_ha)
 {
 	struct hisi_hba *hisi_hba = sas_ha->lldd_ha;
+	struct device *dev = hisi_hba->dev;
 	HISI_SAS_DECLARE_RST_WORK_ON_STACK(r);
+	int rc, i;
 
 	queue_work(hisi_hba->wq, &r.work);
 	wait_for_completion(r.completion);
-	if (r.done)
-		return TMF_RESP_FUNC_COMPLETE;
+	if (!r.done)
+		return TMF_RESP_FUNC_FAILED;
+
+	for (i = 0; i < HISI_SAS_MAX_DEVICES; i++) {
+		struct hisi_sas_device *sas_dev = &hisi_hba->devices[i];
+		struct domain_device *device = sas_dev->sas_device;
+
+		if ((sas_dev->dev_type == SAS_PHY_UNUSED) || !device ||
+		    DEV_IS_EXPANDER(device->dev_type))
+			continue;
+
+		rc = hisi_sas_debug_I_T_nexus_reset(device);
+		if (rc != TMF_RESP_FUNC_COMPLETE)
+			dev_info(dev, "clear nexus ha: for device[%d] rc=%d\n",
+				 sas_dev->device_id, rc);
+	}
+
+	hisi_sas_release_tasks(hisi_hba);
 
-	return TMF_RESP_FUNC_FAILED;
+	return TMF_RESP_FUNC_COMPLETE;
 }
 
 static int hisi_sas_query_task(struct sas_task *task)
-- 
1.9.1
