Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF57FC8300C
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BD5E2076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgD3NUV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:32920 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727030AbgD3NUQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CBEB1AF7E;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 39/41] hisi_sas: use task tag to reference the slot
Date:   Thu, 30 Apr 2020 15:19:02 +0200
Message-Id: <20200430131904.5847-40-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the task task to reference the command slot and drop the
internal slot bitmap.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 61 +++--------------------------------
 1 file changed, 5 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 2aa8a4124cfb..b982097a2398 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -172,41 +172,6 @@ static void hisi_sas_slot_index_free(struct hisi_hba *hisi_hba, int slot_idx)
 	}
 }
 
-static void hisi_sas_slot_index_set(struct hisi_hba *hisi_hba, int slot_idx)
-{
-	void *bitmap = hisi_hba->slot_index_tags;
-
-	set_bit(slot_idx, bitmap);
-}
-
-static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
-				     struct scsi_cmnd *scsi_cmnd)
-{
-	int index;
-	void *bitmap = hisi_hba->slot_index_tags;
-
-	if (scsi_cmnd)
-		return scsi_cmnd->request->tag;
-
-	spin_lock(&hisi_hba->lock);
-	index = find_next_zero_bit(bitmap, hisi_hba->slot_index_count,
-				   hisi_hba->last_slot_index + 1);
-	if (index >= hisi_hba->slot_index_count) {
-		index = find_next_zero_bit(bitmap,
-				hisi_hba->slot_index_count,
-				HISI_SAS_UNRESERVED_IPTT);
-		if (index >= hisi_hba->slot_index_count) {
-			spin_unlock(&hisi_hba->lock);
-			return -SAS_QUEUE_FULL;
-		}
-	}
-	hisi_sas_slot_index_set(hisi_hba, index);
-	hisi_hba->last_slot_index = index;
-	spin_unlock(&hisi_hba->lock);
-
-	return index;
-}
-
 static void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
 {
 	int i;
@@ -465,23 +430,9 @@ static int hisi_sas_task_prep(struct sas_task *task,
 
 	if (hisi_hba->hw->slot_index_alloc)
 		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device);
-	else {
-		struct scsi_cmnd *scsi_cmnd = NULL;
-
-		if (task->uldd_task) {
-			struct ata_queued_cmd *qc;
+	else
+		rc = (task->tag == -1) ? -EINVAL : task->tag;
 
-			if (dev_is_sata(device)) {
-				qc = task->uldd_task;
-				scsi_cmnd = qc->scsicmd;
-			} else {
-				scsi_cmnd = task->uldd_task;
-			}
-		} else if (task->slow_task) {
-			scsi_cmnd = task->slow_task->scmd;
-		}
-		rc = hisi_sas_slot_index_alloc(hisi_hba, scsi_cmnd);
-	}
 	if (rc < 0)
 		goto err_out_dif_dma_unmap;
 
@@ -1970,12 +1921,10 @@ hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
 
 	port = to_hisi_sas_port(sas_port);
 
-	/* simply get a slot and send abort command */
-	rc = hisi_sas_slot_index_alloc(hisi_hba, NULL);
-	if (rc < 0)
-		goto err_out;
+	slot_idx = task->tag;
+	if (task->tag == -1)
+		return -EAGAIN;
 
-	slot_idx = rc;
 	slot = &hisi_hba->slot_info[slot_idx];
 
 	spin_lock(&dq->lock);
-- 
2.16.4

