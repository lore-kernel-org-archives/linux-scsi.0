Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A513EC18E5C
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B7F020848
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgCJQbR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:31:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11219 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727464AbgCJQbQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:31:16 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C9E836DEA0F079C9BFAD;
        Wed, 11 Mar 2020 00:30:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 00:30:32 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hch@infradead.org>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v2 24/24] scsi: hisi_sas: Use libsas slow task SCSI command
Date:   Wed, 11 Mar 2020 00:25:50 +0800
Message-ID: <1583857550-12049-25-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that a SCSI command can be allocated for a libsas slow tasks, make the
task prep code use it.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 5 ++++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 5 +++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index c7951ac8b075..61039f3608c8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -476,8 +476,10 @@ static int hisi_sas_task_prep(struct sas_task *task,
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
@@ -2650,6 +2652,7 @@ int hisi_sas_probe(struct platform_device *pdev,
 	} else {
 		shost->can_queue = HISI_SAS_UNRESERVED_IPTT;
 		shost->cmd_per_lun = HISI_SAS_UNRESERVED_IPTT;
+		shost->nr_reserved_cmds = HISI_SAS_RESERVED_IPTT;
 	}
 
 	sha->sas_ha_name = DRV_NAME;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index a2debe0c8185..44530f8c0319 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3237,8 +3237,9 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
2.17.1

