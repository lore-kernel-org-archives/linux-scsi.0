Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE87C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FD0164E32
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhBVNcn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:32:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:48680 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231602AbhBVN2n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:28:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9261AB113;
        Mon, 22 Feb 2021 13:24:16 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 28/31] scsi: hisi_sas: Use libsas slow task SCSI command
Date:   Mon, 22 Feb 2021 14:24:02 +0100
Message-Id: <20210222132405.91369-29-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
References: <20210222132405.91369-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: John Garry <john.garry@huawei.com>

Now that a SCSI command can be allocated for a libsas slow tasks, make the
task prep code use it.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 17 ++++++++++-------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  5 +++--
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 6a69a90a1b82..af653f4393ea 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -179,15 +179,11 @@ static void hisi_sas_slot_index_set(struct hisi_hba *hisi_hba, int slot_idx)
 	set_bit(slot_idx, bitmap);
 }
 
-static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
-				     struct scsi_cmnd *scsi_cmnd)
+static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba)
 {
 	int index;
 	void *bitmap = hisi_hba->slot_index_tags;
 
-	if (scsi_cmnd)
-		return scsi_cmnd->request->tag;
-
 	spin_lock(&hisi_hba->lock);
 	index = find_next_zero_bit(bitmap, hisi_hba->slot_index_count,
 				   hisi_hba->last_slot_index + 1);
@@ -444,6 +440,8 @@ static int hisi_sas_task_prep(struct sas_task *task,
 		} else {
 			scmd = task->uldd_task;
 		}
+	} else {
+		scmd = task->slow_task->scmd;
 	}
 
 	if (scmd) {
@@ -484,8 +482,10 @@ static int hisi_sas_task_prep(struct sas_task *task,
 
 	if (hisi_hba->hw->slot_index_alloc)
 		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device);
+	else if (scmd)
+		rc = scmd->request->tag;
 	else
-		rc = hisi_sas_slot_index_alloc(hisi_hba, scmd);
+		rc = hisi_sas_slot_index_alloc(hisi_hba);
 
 	if (rc < 0)
 		goto err_out_dif_dma_unmap;
@@ -1975,7 +1975,9 @@ hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
 	port = to_hisi_sas_port(sas_port);
 
 	/* simply get a slot and send abort command */
-	rc = hisi_sas_slot_index_alloc(hisi_hba, NULL);
+	rc = = task->tag;
+	if (rc < 0)
+		rc = hisi_sas_slot_index_alloc(hisi_hba);
 	if (rc < 0)
 		goto err_out;
 
@@ -2683,6 +2685,7 @@ int hisi_sas_probe(struct platform_device *pdev,
 	} else {
 		shost->can_queue = HISI_SAS_UNRESERVED_IPTT;
 		shost->cmd_per_lun = HISI_SAS_UNRESERVED_IPTT;
+		shost->nr_reserved_cmds = HISI_SAS_RESERVED_IPTT;
 	}
 
 	sha->sas_ha_name = DRV_NAME;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 4580e081e489..c728c782e21a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4720,8 +4720,9 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_lun = ~0;
 	shost->max_channel = 1;
 	shost->max_cmd_len = 16;
-	shost->can_queue = HISI_SAS_UNRESERVED_IPTT;
-	shost->cmd_per_lun = HISI_SAS_UNRESERVED_IPTT;
+	shost->can_queue = HISI_SAS_MAX_COMMANDS;
+	shost->cmd_per_lun = HISI_SAS_MAX_COMMANDS;
+	shost->nr_reserved_cmds = HISI_SAS_RESERVED_IPTT;
 
 	sha->sas_ha_name = DRV_NAME;
 	sha->dev = dev;
-- 
2.29.2

