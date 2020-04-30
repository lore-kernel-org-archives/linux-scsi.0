Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5449C8300B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93CDF2076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgD3NUb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:60764 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbgD3NUK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A890EAF6C;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 37/41] libsas: add tag to struct sas_task
Date:   Thu, 30 Apr 2020 15:19:00 +0200
Message-Id: <20200430131904.5847-38-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
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
index 5d716d388707..897007343b3d 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -211,6 +211,10 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 
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
index 5aa8593b88b5..0d32cb49d0af 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -53,6 +53,7 @@ struct sas_task *sas_alloc_slow_task(struct sas_ha_struct *ha,
 	if (!slow)
 		goto out_err_slow;
 
+	task->tag = -1;
 	if (shost->nr_reserved_cmds) {
 		struct scsi_device *sdev;
 
@@ -66,6 +67,7 @@ struct sas_task *sas_alloc_slow_task(struct sas_ha_struct *ha,
 		slow->scmd = scsi_get_reserved_cmd(sdev, DMA_NONE, false);
 		if (!slow->scmd)
 			goto out_err_scmd;
+		task->tag = slow->scmd->request->tag;
 		ASSIGN_SAS_TASK(slow->scmd, task);
 	}
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index c5a430e3fa2d..585e0df5fce2 100644
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
index c927228019c9..af864f68b5cc 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -594,6 +594,8 @@ struct sas_task {
 	u32    total_xfer_len;
 	u8     data_dir:2;	  /* Use PCI_DMA_... */
 
+	u32    tag;
+
 	struct task_status_struct task_status;
 	void   (*task_done)(struct sas_task *);
 
-- 
2.16.4

