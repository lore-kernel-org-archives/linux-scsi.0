Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99C2C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A32BB64E40
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhBVNbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:31:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:47810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231240AbhBVN2Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:28:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4C949B01C;
        Mon, 22 Feb 2021 13:24:16 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 27/31] libsas: add tag to struct sas_task
Date:   Mon, 22 Feb 2021 14:24:01 +0100
Message-Id: <20210222132405.91369-28-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
References: <20210222132405.91369-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All block layer commands now have a tag, so we should be storing
it in the sas_task structure for easier lookup.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/libsas/sas_ata.c       | 4 ++++
 drivers/scsi/libsas/sas_init.c      | 2 ++
 drivers/scsi/libsas/sas_scsi_host.c | 2 +-
 include/scsi/libsas.h               | 2 ++
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 024e5a550759..2b05ca68d091 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -214,6 +214,10 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 	else
 		task->data_dir = qc->dma_dir;
 	task->scatter = qc->sg;
+	if (qc->scsicmd)
+		task->tag = qc->scsicmd->request->tag;
+	else
+		task->tag = qc->tag;
 	task->ata_task.retry_count = 1;
 	task->task_state_flags = SAS_TASK_STATE_PENDING;
 	qc->lldd_task = task;
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 9d0448b76a2f..a2f1789c7a6a 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -53,6 +53,7 @@ struct sas_task *sas_alloc_slow_task(struct sas_ha_struct *ha,
 	if (!slow)
 		goto out_err_slow;
 
+	task->tag = -1;
 	if (shost->nr_reserved_cmds) {
 		struct scsi_device *sdev;
 
@@ -67,6 +68,7 @@ struct sas_task *sas_alloc_slow_task(struct sas_ha_struct *ha,
 						   REQ_NOWAIT);
 		if (!slow->scmd)
 			goto out_err_scmd;
+		task->tag = slow->scmd->request->tag;
 		ASSIGN_SAS_TASK(slow->scmd, task);
 	}
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index ae247aed857f..37b9ca483522 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -149,7 +149,7 @@ static struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
 	memcpy(task->ssp_task.LUN, &lun.scsi_lun, 8);
 	task->ssp_task.task_attr = TASK_ATTR_SIMPLE;
 	task->ssp_task.cmd = cmd;
-
+	task->tag = cmd->request->tag;
 	task->scatter = scsi_sglist(cmd);
 	task->num_scatter = scsi_sg_count(cmd);
 	task->total_xfer_len = scsi_bufflen(cmd);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 9b8c06a8329a..d047b7734343 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -590,6 +590,8 @@ struct sas_task {
 	u32    total_xfer_len;
 	u8     data_dir:2;	  /* Use PCI_DMA_... */
 
+	u32    tag;
+
 	struct task_status_struct task_status;
 	void   (*task_done)(struct sas_task *);
 
-- 
2.29.2

