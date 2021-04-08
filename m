Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE866C433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 12:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B400161132
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 12:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhDHM4b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 08:56:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15191 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbhDHM41 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 08:56:27 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FGLm80TGfzpVfM;
        Thu,  8 Apr 2021 20:53:28 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Thu, 8 Apr 2021
 20:56:08 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <jinpu.wang@cloud.ionos.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <luojiaxing@huawei.com>
Subject: [PATCH v3 1/2] scsi: pm8001: clean up for white space
Date:   Thu, 8 Apr 2021 20:56:32 +0800
Message-ID: <1617886593-36421-2-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617886593-36421-1-git-send-email-luojiaxing@huawei.com>
References: <1617886593-36421-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some errors are found like below when run checkpatch.pl

ERROR: space prohibited before that ',' (ctx:WxW)
+int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha , void *piomb);

It all about white space, so fix them.

Signed-off-by: Jianqin Xie <xiejianqin@hisilicon.com>
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 20 +++++++++-----------
 drivers/scsi/pm8001/pm8001_ctl.h |  5 +++++
 drivers/scsi/pm8001/pm8001_hwi.c | 14 +++++++-------
 drivers/scsi/pm8001/pm8001_sas.c | 20 ++++++++++----------
 drivers/scsi/pm8001/pm8001_sas.h |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c | 14 +++++++-------
 6 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 12035ba..90b816f 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -369,24 +369,22 @@ static ssize_t pm8001_ctl_aap_log_show(struct device *cdev,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+	u8 *ptr = (u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr;
 	int i;
-#define AAP1_MEMMAP(r, c) \
-	(*(u32 *)((u8*)pm8001_ha->memoryMap.region[AAP1].virt_ptr + (r) * 32 \
-	+ (c)))
 
 	char *str = buf;
 	int max = 2;
 	for (i = 0; i < max; i++) {
 		str += sprintf(str, "0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x"
 			       "0x%08x 0x%08x\n",
-			       AAP1_MEMMAP(i, 0),
-			       AAP1_MEMMAP(i, 4),
-			       AAP1_MEMMAP(i, 8),
-			       AAP1_MEMMAP(i, 12),
-			       AAP1_MEMMAP(i, 16),
-			       AAP1_MEMMAP(i, 20),
-			       AAP1_MEMMAP(i, 24),
-			       AAP1_MEMMAP(i, 28));
+			       pm8001_ctl_aap1_memmap(ptr, i, 0),
+			       pm8001_ctl_aap1_memmap(ptr, i, 4),
+			       pm8001_ctl_aap1_memmap(ptr, i, 8),
+			       pm8001_ctl_aap1_memmap(ptr, i, 12),
+			       pm8001_ctl_aap1_memmap(ptr, i, 16),
+			       pm8001_ctl_aap1_memmap(ptr, i, 20),
+			       pm8001_ctl_aap1_memmap(ptr, i, 24),
+			       pm8001_ctl_aap1_memmap(ptr, i, 28));
 	}
 
 	return str - buf;
diff --git a/drivers/scsi/pm8001/pm8001_ctl.h b/drivers/scsi/pm8001/pm8001_ctl.h
index d0d43a2..4743f0d 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.h
+++ b/drivers/scsi/pm8001/pm8001_ctl.h
@@ -59,5 +59,10 @@
 #define SYSFS_OFFSET                    1024
 #define PM80XX_IB_OB_QUEUE_SIZE         (32 * 1024)
 #define PM8001_IB_OB_QUEUE_SIZE         (16 * 1024)
+
+static inline u32 pm8001_ctl_aap1_memmap(u8 *ptr, int idx, int off)
+{
+	return *(u32 *)(ptr + idx * 32 + off);
+}
 #endif /* PM8001_CTL_H_INCLUDED */
 
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 49bf2f7..6887fa3 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1826,7 +1826,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
  * that the task has been finished.
  */
 static void
-mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
+mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
 	struct sas_task *t;
 	struct pm8001_ccb_info *ccb;
@@ -2058,7 +2058,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 }
 
 /*See the comments for mpi_ssp_completion */
-static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
+static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
 	struct sas_task *t;
 	unsigned long flags;
@@ -2294,9 +2294,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		(status != IO_UNDERFLOW)) {
 		if (!((t->dev->parent) &&
 			(dev_is_expander(t->dev->parent->dev_type)))) {
-			for (i = 0 , j = 4; j <= 7 && i <= 3; i++ , j++)
+			for (i = 0, j = 4; j <= 7 && i <= 3; i++, j++)
 				sata_addr_low[i] = pm8001_ha->sas_addr[j];
-			for (i = 0 , j = 0; j <= 3 && i <= 3; i++ , j++)
+			for (i = 0, j = 0; j <= 3 && i <= 3; i++, j++)
 				sata_addr_hi[i] = pm8001_ha->sas_addr[j];
 			memcpy(&temp_sata_addr_low, sata_addr_low,
 				sizeof(sata_addr_low));
@@ -2625,7 +2625,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 }
 
 /*See the comments for mpi_ssp_completion */
-static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
+static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
 	struct sas_task *t;
 	struct task_status_struct *ts;
@@ -3602,7 +3602,7 @@ int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha,
 	return 0;
 }
 
-int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
+int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
 	u32 status;
 	int i;
@@ -3685,7 +3685,7 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
  * @pm8001_ha: our hba card information
  * @piomb: IO message buffer
  */
-static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
+static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
 	unsigned long flags;
 	struct hw_event_resp *pPayload =
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index a98d449..43b77ac 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -877,8 +877,8 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			   pm8001_dev->device_id, pm8001_dev->dev_type);
 		if (atomic_read(&pm8001_dev->running_req)) {
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-			pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-				dev, 1, 0);
+			pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
+							dev, 1, 0);
 			while (atomic_read(&pm8001_dev->running_req))
 				msleep(20);
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
@@ -1013,8 +1013,8 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)
 			goto out;
 		}
 		msleep(2000);
-		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-			dev, 1, 0);
+		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
+						     dev, 1, 0);
 		if (rc) {
 			pm8001_dbg(pm8001_ha, EH, "task abort failed %x\n"
 				   "with rc %d\n", pm8001_dev->device_id, rc);
@@ -1059,8 +1059,8 @@ int pm8001_I_T_nexus_event_handler(struct domain_device *dev)
 			goto out;
 		}
 		/* send internal ssp/sata/smp abort command to FW */
-		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-							dev, 1, 0);
+		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
+						     dev, 1, 0);
 		msleep(100);
 
 		/* deregister the target device */
@@ -1075,8 +1075,8 @@ int pm8001_I_T_nexus_event_handler(struct domain_device *dev)
 		wait_for_completion(&completion_setstate);
 	} else {
 		/* send internal ssp/sata/smp abort command to FW */
-		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-							dev, 1, 0);
+		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
+						     dev, 1, 0);
 		msleep(100);
 
 		/* deregister the target device */
@@ -1104,8 +1104,8 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
 	DECLARE_COMPLETION_ONSTACK(completion_setstate);
 	if (dev_is_sata(dev)) {
 		struct sas_phy *phy = sas_get_local_phy(dev);
-		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-			dev, 1, 0);
+		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
+						     dev, 1, 0);
 		rc = sas_phy_reset(phy, 1);
 		sas_put_local_phy(phy);
 		pm8001_dev->setds_completion = &completion_setstate;
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 039ed91..e7f693a 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -705,7 +705,7 @@ int pm8001_mpi_reg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb);
 int pm8001_mpi_dereg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb);
 int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha,
 							void *piomb);
-int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha , void *piomb);
+int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha, void *piomb);
 int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb);
 struct sas_task *pm8001_alloc_task(void);
 void pm8001_task_done(struct sas_task *task);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 8431556..5e02446 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -90,7 +90,7 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
 	void __iomem *fatal_table_address = pm8001_ha->fatal_tbl_addr;
-	u32 accum_len , reg_val, index, *temp;
+	u32 accum_len, reg_val, index, *temp;
 	u32 status = 1;
 	unsigned long start;
 	u8 *direct_data;
@@ -1904,7 +1904,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
  * that the task has been finished.
  */
 static void
-mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
+mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
 	struct sas_task *t;
 	struct pm8001_ccb_info *ccb;
@@ -2194,7 +2194,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 }
 
 /*See the comments for mpi_ssp_completion */
-static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
+static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
 	struct sas_task *t;
 	unsigned long flags;
@@ -2444,9 +2444,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		(status != IO_UNDERFLOW)) {
 		if (!((t->dev->parent) &&
 			(dev_is_expander(t->dev->parent->dev_type)))) {
-			for (i = 0 , j = 4; i <= 3 && j <= 7; i++ , j++)
+			for (i = 0, j = 4; i <= 3 && j <= 7; i++, j++)
 				sata_addr_low[i] = pm8001_ha->sas_addr[j];
-			for (i = 0 , j = 0; i <= 3 && j <= 3; i++ , j++)
+			for (i = 0, j = 0; i <= 3 && j <= 3; i++, j++)
 				sata_addr_hi[i] = pm8001_ha->sas_addr[j];
 			memcpy(&temp_sata_addr_low, sata_addr_low,
 				sizeof(sata_addr_low));
@@ -2788,7 +2788,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 }
 
 /*See the comments for mpi_ssp_completion */
-static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
+static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
 	struct sas_task *t;
 	struct task_status_struct *ts;
@@ -4918,7 +4918,7 @@ static void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
 				    u32 operation, u32 phyid,
 				    u32 length, u32 *buf)
 {
-	u32 tag , i, j = 0;
+	u32 tag, i, j = 0;
 	int rc;
 	struct set_phy_profile_req payload;
 	struct inbound_queue_table *circularQ;
-- 
2.7.4

