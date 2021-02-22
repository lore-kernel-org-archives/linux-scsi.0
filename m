Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 023DDC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A326464E32
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhBVNch (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:32:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:48668 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231361AbhBVN2n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:28:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1FC99B008;
        Mon, 22 Feb 2021 13:24:16 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 21/31] mv_sas: kill mvsas_debug_issue_ssp_tmf()
Date:   Mon, 22 Feb 2021 14:23:55 +0100
Message-Id: <20210222132405.91369-22-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
References: <20210222132405.91369-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just a wrapper around mvs_exec_internal_tmf_task(), so call
it directly and kill the wrapper.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/mvsas/mv_sas.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 1acea528f27f..543b435f4c8c 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1275,11 +1275,14 @@ static void mvs_tmf_timedout(struct timer_list *t)
 
 #define MVS_TASK_TIMEOUT 20
 static int mvs_exec_internal_tmf_task(struct domain_device *dev,
-			void *parameter, u32 para_len, struct mvs_tmf_task *tmf)
+				      u8 *lun, struct mvs_tmf_task *tmf)
 {
 	int res, retry;
 	struct sas_task *task = NULL;
 
+	if (!(dev->tproto & SAS_PROTOCOL_SSP))
+		return TMF_RESP_FUNC_ESUPP;
+
 	for (retry = 0; retry < 3; retry++) {
 		task = sas_alloc_slow_task(GFP_KERNEL);
 		if (!task)
@@ -1288,7 +1291,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 		task->dev = dev;
 		task->task_proto = dev->tproto;
 
-		memcpy(&task->ssp_task, parameter, para_len);
+		memcpy(task->ssp_task.LUN, lun, 8);
 		task->task_done = mvs_task_done;
 
 		task->slow_task->timer.function = mvs_tmf_timedout;
@@ -1349,20 +1352,6 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 	return res;
 }
 
-static int mvs_debug_issue_ssp_tmf(struct domain_device *dev,
-				u8 *lun, struct mvs_tmf_task *tmf)
-{
-	struct sas_ssp_task ssp_task;
-	if (!(dev->tproto & SAS_PROTOCOL_SSP))
-		return TMF_RESP_FUNC_ESUPP;
-
-	memcpy(ssp_task.LUN, lun, 8);
-
-	return mvs_exec_internal_tmf_task(dev, &ssp_task,
-				sizeof(ssp_task), tmf);
-}
-
-
 /*  Standard mandates link reset for ATA  (type 0)
     and hard reset for SSP (type 1) , only for RECOVERY */
 static int mvs_debug_I_T_nexus_reset(struct domain_device *dev)
@@ -1388,7 +1377,7 @@ int mvs_lu_reset(struct domain_device *dev, u8 *lun)
 
 	tmf_task.tmf = TMF_LU_RESET;
 	mvi_dev->dev_status = MVS_DEV_EH;
-	rc = mvs_debug_issue_ssp_tmf(dev, lun, &tmf_task);
+	rc = mvs_exec_internal_tmf_task(dev, lun, &tmf_task);
 	if (rc == TMF_RESP_FUNC_COMPLETE) {
 		spin_lock_irqsave(&mvi->lock, flags);
 		mvs_release_task(mvi, dev);
@@ -1445,7 +1434,7 @@ int mvs_query_task(struct sas_task *task)
 		tmf_task.tmf = TMF_QUERY_TASK;
 		tmf_task.tag_of_task_to_be_managed = cpu_to_le16(tag);
 
-		rc = mvs_debug_issue_ssp_tmf(dev, lun.scsi_lun, &tmf_task);
+		rc = mvs_exec_internal_tmf_task(dev, lun.scsi_lun, &tmf_task);
 		switch (rc) {
 		/* The task is still in Lun, release it then */
 		case TMF_RESP_FUNC_SUCC:
@@ -1500,7 +1489,7 @@ int mvs_abort_task(struct sas_task *task)
 		tmf_task.tmf = TMF_ABORT_TASK;
 		tmf_task.tag_of_task_to_be_managed = cpu_to_le16(tag);
 
-		rc = mvs_debug_issue_ssp_tmf(dev, lun.scsi_lun, &tmf_task);
+		rc = mvs_exec_internal_tmf_task(dev, lun.scsi_lun, &tmf_task);
 
 		/* if successful, clear the task and callback forwards.*/
 		if (rc == TMF_RESP_FUNC_COMPLETE) {
@@ -1543,7 +1532,7 @@ int mvs_abort_task_set(struct domain_device *dev, u8 *lun)
 	struct mvs_tmf_task tmf_task;
 
 	tmf_task.tmf = TMF_ABORT_TASK_SET;
-	rc = mvs_debug_issue_ssp_tmf(dev, lun, &tmf_task);
+	rc = mvs_exec_internal_tmf_task(dev, lun, &tmf_task);
 
 	return rc;
 }
@@ -1554,7 +1543,7 @@ int mvs_clear_aca(struct domain_device *dev, u8 *lun)
 	struct mvs_tmf_task tmf_task;
 
 	tmf_task.tmf = TMF_CLEAR_ACA;
-	rc = mvs_debug_issue_ssp_tmf(dev, lun, &tmf_task);
+	rc = mvs_exec_internal_tmf_task(dev, lun, &tmf_task);
 
 	return rc;
 }
@@ -1565,7 +1554,7 @@ int mvs_clear_task_set(struct domain_device *dev, u8 *lun)
 	struct mvs_tmf_task tmf_task;
 
 	tmf_task.tmf = TMF_CLEAR_TASK_SET;
-	rc = mvs_debug_issue_ssp_tmf(dev, lun, &tmf_task);
+	rc = mvs_exec_internal_tmf_task(dev, lun, &tmf_task);
 
 	return rc;
 }
-- 
2.29.2

