Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8D5C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0C6F64E5C
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhBVNav (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:30:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:47796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231260AbhBVN2R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:28:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4CD8FB01D;
        Mon, 22 Feb 2021 13:24:16 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/31] pm8001: kill 'dev' argument from pm8001_exec_internal_task_abort()
Date:   Mon, 22 Feb 2021 14:23:57 +0100
Message-Id: <20210222132405.91369-24-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
References: <20210222132405.91369-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'dev' is always pm8001_dev->sas_device, so we can kill it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/pm8001/pm8001_sas.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 6e1c1bbbfdd9..01e91347eb41 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -791,9 +791,10 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 
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
@@ -879,8 +880,8 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			   pm8001_dev->device_id, pm8001_dev->dev_type);
 		if (atomic_read(&pm8001_dev->running_req)) {
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-			pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-				dev, 1, 0);
+			pm8001_exec_internal_task_abort(pm8001_ha,
+				pm8001_dev, 1, 0);
 			while (atomic_read(&pm8001_dev->running_req))
 				msleep(20);
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
@@ -1003,8 +1004,8 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)
 			goto out;
 		}
 		msleep(2000);
-		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-			dev, 1, 0);
+		rc = pm8001_exec_internal_task_abort(pm8001_ha,
+			pm8001_dev, 1, 0);
 		if (rc) {
 			pm8001_dbg(pm8001_ha, EH, "task abort failed %x\n"
 				   "with rc %d\n", pm8001_dev->device_id, rc);
@@ -1049,8 +1050,8 @@ int pm8001_I_T_nexus_event_handler(struct domain_device *dev)
 			goto out;
 		}
 		/* send internal ssp/sata/smp abort command to FW */
-		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-							dev, 1, 0);
+		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
+						     1, 0);
 		msleep(100);
 
 		/* deregister the target device */
@@ -1065,8 +1066,8 @@ int pm8001_I_T_nexus_event_handler(struct domain_device *dev)
 		wait_for_completion(&completion_setstate);
 	} else {
 		/* send internal ssp/sata/smp abort command to FW */
-		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
-							dev, 1, 0);
+		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
+						     1, 0);
 		msleep(100);
 
 		/* deregister the target device */
@@ -1094,8 +1095,8 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
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
@@ -1210,7 +1211,7 @@ int pm8001_abort_task(struct sas_task *task)
 						   &tmf_task);
 		if (rc == TMF_RESP_FUNC_SUCC)
 			pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
-				pm8001_dev->sas_device, 0, tag);
+				0, tag);
 	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
 		task->task_proto & SAS_PROTOCOL_STP) {
 		if (pm8001_ha->chip_id == chip_8006) {
@@ -1279,7 +1280,7 @@ int pm8001_abort_task(struct sas_task *task)
 			 * going to free the task.
 			 */
 			ret = pm8001_exec_internal_task_abort(pm8001_ha,
-				pm8001_dev, pm8001_dev->sas_device, 1, tag);
+				pm8001_dev, 1, tag);
 			if (ret)
 				goto out;
 			ret = wait_for_completion_timeout(
@@ -1296,13 +1297,13 @@ int pm8001_abort_task(struct sas_task *task)
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
2.29.2

