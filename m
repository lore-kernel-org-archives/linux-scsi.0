Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4FCC83012
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 062672076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgD3NUb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:60750 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbgD3NUK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8B4E0AF5A;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 33/41] pm8001: kill 'dev' argument from pm8001_exec_internal_task_abort()
Date:   Thu, 30 Apr 2020 15:18:56 +0200
Message-Id: <20200430131904.5847-34-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'dev' is always pm8001_dev->sas_device, so we can kill it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/pm8001/pm8001_sas.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index eb645e4a5940..ae25a8b62fcc 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -798,9 +798,10 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 
 static int
 pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
-	struct pm8001_device *pm8001_dev, struct domain_device *dev, u32 flag,
+	struct pm8001_device *pm8001_dev, u32 flag,
 	u32 task_tag)
 {
+	struct domain_device *dev = pm8001_dev->sas_device;
 	int res, retry;
 	u32 ccb_tag;
 	struct pm8001_ccb_info *ccb;
@@ -890,8 +891,8 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			pm8001_dev->device_id, pm8001_dev->dev_type));
 		if (pm8001_dev->running_req) {
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-			pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-				dev, 1, 0);
+			pm8001_exec_internal_task_abort(pm8001_ha,
+				pm8001_dev, 1, 0);
 			while (pm8001_dev->running_req)
 				msleep(20);
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
@@ -1014,8 +1015,8 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)
 			goto out;
 		}
 		msleep(2000);
-		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-			dev, 1, 0);
+		rc = pm8001_exec_internal_task_abort(pm8001_ha,
+			pm8001_dev, 1, 0);
 		if (rc) {
 			PM8001_EH_DBG(pm8001_ha,
 			pm8001_printk("task abort failed %x\n"
@@ -1062,8 +1063,8 @@ int pm8001_I_T_nexus_event_handler(struct domain_device *dev)
 			goto out;
 		}
 		/* send internal ssp/sata/smp abort command to FW */
-		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-							dev, 1, 0);
+		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
+						     1, 0);
 		msleep(100);
 
 		/* deregister the target device */
@@ -1078,8 +1079,8 @@ int pm8001_I_T_nexus_event_handler(struct domain_device *dev)
 		wait_for_completion(&completion_setstate);
 	} else {
 		/* send internal ssp/sata/smp abort command to FW */
-		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-							dev, 1, 0);
+		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
+						     1, 0);
 		msleep(100);
 
 		/* deregister the target device */
@@ -1107,8 +1108,8 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
 	DECLARE_COMPLETION_ONSTACK(completion_setstate);
 	if (dev_is_sata(dev)) {
 		struct sas_phy *phy = sas_get_local_phy(dev);
-		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-			dev, 1, 0);
+		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
+			1, 0);
 		rc = sas_phy_reset(phy, 1);
 		sas_put_local_phy(phy);
 		pm8001_dev->setds_completion = &completion_setstate;
@@ -1219,7 +1220,7 @@ int pm8001_abort_task(struct sas_task *task)
 						   &tmf_task);
 		if (rc == TMF_RESP_FUNC_SUCC)
 			pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
-				pm8001_dev->sas_device, 0, tag);
+				0, tag);
 	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
 		task->task_proto & SAS_PROTOCOL_STP) {
 		if (pm8001_ha->chip_id == chip_8006) {
@@ -1288,7 +1289,7 @@ int pm8001_abort_task(struct sas_task *task)
 			 * going to free the task.
 			 */
 			ret = pm8001_exec_internal_task_abort(pm8001_ha,
-				pm8001_dev, pm8001_dev->sas_device, 1, tag);
+				pm8001_dev, 1, tag);
 			if (ret)
 				goto out;
 			ret = wait_for_completion_timeout(
@@ -1305,13 +1306,13 @@ int pm8001_abort_task(struct sas_task *task)
 			wait_for_completion(&completion);
 		} else {
 			rc = pm8001_exec_internal_task_abort(pm8001_ha,
-				pm8001_dev, pm8001_dev->sas_device, 0, tag);
+				pm8001_dev, 0, tag);
 		}
 		rc = TMF_RESP_FUNC_COMPLETE;
 	} else if (task->task_proto & SAS_PROTOCOL_SMP) {
 		/* SMP */
 		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
-			pm8001_dev->sas_device, 0, tag);
+			0, tag);
 
 	}
 out:
-- 
2.16.4

