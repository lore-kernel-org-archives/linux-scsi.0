Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF8AC43333
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 873DA64DD0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhBVNcx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:32:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:48670 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231402AbhBVN2n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:28:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 265DAB009;
        Mon, 22 Feb 2021 13:24:16 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/31] pm8001: kill pm8001_issue_ssp_tmf()
Date:   Mon, 22 Feb 2021 14:23:56 +0100
Message-Id: <20210222132405.91369-23-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
References: <20210222132405.91369-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just a wrapper around pm8001_exec_internal_tmf_task(), so call it
directly and kill the wrapper.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/pm8001/pm8001_sas.c | 42 +++++++++++++-------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index a98d4496ff8b..6e1c1bbbfdd9 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -697,16 +697,15 @@ static void pm8001_tmf_timedout(struct timer_list *t)
 /**
   * pm8001_exec_internal_tmf_task - execute some task management commands.
   * @dev: the wanted device.
+  * @lun: the logical unit number of the device
   * @tmf: which task management wanted to be take.
-  * @para_len: para_len.
-  * @parameter: ssp task parameter.
   *
   * when errors or exception happened, we may want to do something, for example
   * abort the issued task which result in this execption, it is done by calling
   * this function, note it is also with the task execute interface.
   */
 static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
-	void *parameter, u32 para_len, struct pm8001_tmf_task *tmf)
+	u8 *lun, struct pm8001_tmf_task *tmf)
 {
 	int res, retry;
 	struct sas_task *task = NULL;
@@ -714,6 +713,9 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
 	DECLARE_COMPLETION_ONSTACK(completion_setstate);
 
+	if (!(dev->tproto & SAS_PROTOCOL_SSP))
+		return TMF_RESP_FUNC_ESUPP;
+
 	for (retry = 0; retry < 3; retry++) {
 		task = sas_alloc_slow_task(GFP_KERNEL);
 		if (!task)
@@ -721,7 +723,7 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 
 		task->dev = dev;
 		task->task_proto = dev->tproto;
-		memcpy(&task->ssp_task, parameter, para_len);
+		memcpy(task->ssp_task.LUN, lun, 8);
 		task->task_done = pm8001_task_done;
 		task->slow_task->timer.function = pm8001_tmf_timedout;
 		task->slow_task->timer.expires = jiffies + PM8001_TASK_TIMEOUT*HZ;
@@ -897,18 +899,6 @@ void pm8001_dev_gone(struct domain_device *dev)
 	pm8001_dev_gone_notify(dev);
 }
 
-static int pm8001_issue_ssp_tmf(struct domain_device *dev,
-	u8 *lun, struct pm8001_tmf_task *tmf)
-{
-	struct sas_ssp_task ssp_task;
-	if (!(dev->tproto & SAS_PROTOCOL_SSP))
-		return TMF_RESP_FUNC_ESUPP;
-
-	memcpy((u8 *)&ssp_task.LUN, lun, 8);
-	return pm8001_exec_internal_tmf_task(dev, &ssp_task, sizeof(ssp_task),
-		tmf);
-}
-
 /* retry commands by ha, by task and/or by device */
 void pm8001_open_reject_retry(
 	struct pm8001_hba_info *pm8001_ha,
@@ -1114,7 +1104,7 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
 		wait_for_completion(&completion_setstate);
 	} else {
 		tmf_task.tmf = TMF_LU_RESET;
-		rc = pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
+		rc = pm8001_exec_internal_tmf_task(dev, lun, &tmf_task);
 	}
 	/* If failed, fall-through I_T_Nexus reset */
 	pm8001_dbg(pm8001_ha, EH, "for device[%x]:rc=%d\n",
@@ -1145,10 +1135,10 @@ int pm8001_query_task(struct sas_task *task)
 			return rc;
 		}
 		pm8001_dbg(pm8001_ha, EH, "Query:[%16ph]\n", cmnd->cmnd);
-		tmf_task.tmf = 	TMF_QUERY_TASK;
+		tmf_task.tmf =	TMF_QUERY_TASK;
 		tmf_task.tag_of_task_to_be_managed = tag;
 
-		rc = pm8001_issue_ssp_tmf(dev, lun.scsi_lun, &tmf_task);
+		rc = pm8001_exec_internal_tmf_task(dev, lun.scsi_lun, &tmf_task);
 		switch (rc) {
 		/* The task is still in Lun, release it then */
 		case TMF_RESP_FUNC_SUCC:
@@ -1216,9 +1206,11 @@ int pm8001_abort_task(struct sas_task *task)
 		int_to_scsilun(cmnd->device->lun, &lun);
 		tmf_task.tmf = TMF_ABORT_TASK;
 		tmf_task.tag_of_task_to_be_managed = tag;
-		rc = pm8001_issue_ssp_tmf(dev, lun.scsi_lun, &tmf_task);
-		pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
-			pm8001_dev->sas_device, 0, tag);
+		rc = pm8001_exec_internal_tmf_task(dev, lun.scsi_lun,
+						   &tmf_task);
+		if (rc == TMF_RESP_FUNC_SUCC)
+			pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
+				pm8001_dev->sas_device, 0, tag);
 	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
 		task->task_proto & SAS_PROTOCOL_STP) {
 		if (pm8001_ha->chip_id == chip_8006) {
@@ -1328,7 +1320,7 @@ int pm8001_abort_task_set(struct domain_device *dev, u8 *lun)
 	struct pm8001_tmf_task tmf_task;
 
 	tmf_task.tmf = TMF_ABORT_TASK_SET;
-	return pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
+	return pm8001_exec_internal_tmf_task(dev, lun, &tmf_task);
 }
 
 int pm8001_clear_aca(struct domain_device *dev, u8 *lun)
@@ -1336,7 +1328,7 @@ int pm8001_clear_aca(struct domain_device *dev, u8 *lun)
 	struct pm8001_tmf_task tmf_task;
 
 	tmf_task.tmf = TMF_CLEAR_ACA;
-	return pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
+	return pm8001_exec_internal_tmf_task(dev, lun, &tmf_task);
 }
 
 int pm8001_clear_task_set(struct domain_device *dev, u8 *lun)
@@ -1348,5 +1340,5 @@ int pm8001_clear_task_set(struct domain_device *dev, u8 *lun)
 	pm8001_dbg(pm8001_ha, EH, "I_T_L_Q clear task set[%x]\n",
 		   pm8001_dev->device_id);
 	tmf_task.tmf = TMF_CLEAR_TASK_SET;
-	return pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
+	return pm8001_exec_internal_tmf_task(dev, lun, &tmf_task);
 }
-- 
2.29.2

