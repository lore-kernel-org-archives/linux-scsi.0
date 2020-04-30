Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70AF4C8300C
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59C322076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgD3NU2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:60868 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbgD3NUQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CDA4CAF7F;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH RFC v3 38/41] scsi: hisi_sas: Use libsas slow task SCSI command
Date:   Thu, 30 Apr 2020 15:19:01 +0200
Message-Id: <20200430131904.5847-39-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: John Garry <john.garry@huawei.com>

Now that a SCSI command can be allocated for a libsas slow tasks, make the
task prep code use it.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 5 ++++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 5 +++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 991241ab87d1..2aa8a4124cfb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -477,8 +477,10 @@ static int hisi_sas_task_prep(struct sas_task *task,
 			} else {
 				scsi_cmnd = task->uldd_task;
 			}
+		} else if (task->slow_task) {
+			scsi_cmnd = task->slow_task->scmd;
 		}
-		rc  = hisi_sas_slot_index_alloc(hisi_hba, scsi_cmnd);
+		rc = hisi_sas_slot_index_alloc(hisi_hba, scsi_cmnd);
 	}
 	if (rc < 0)
 		goto err_out_dif_dma_unmap;
@@ -2670,6 +2672,7 @@ int hisi_sas_probe(struct platform_device *pdev,
 	} else {
 		shost->can_queue = HISI_SAS_UNRESERVED_IPTT;
 		shost->cmd_per_lun = HISI_SAS_UNRESERVED_IPTT;
+		shost->nr_reserved_cmds = HISI_SAS_RESERVED_IPTT;
 	}
 
 	sha->sas_ha_name = DRV_NAME;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 374885aa8d77..9c691c9a09f1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3238,8 +3238,9 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
2.16.4

