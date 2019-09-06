Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AE5C43140
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C0FD2082C
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404914AbfIFM6P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 08:58:15 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7133 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404902AbfIFM6O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 08:58:14 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D2D1013A5BD820EA3CEE;
        Fri,  6 Sep 2019 20:58:10 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Sep 2019 20:58:03 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 07/13] scsi: hisi_sas: Assign NCQ tag for all NCQ commands
Date:   Fri, 6 Sep 2019 20:55:31 +0800
Message-ID: <1567774537-20003-8-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
References: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Currently the NCQ tag is only assigned for FPDMA READ and FPDMA WRITE
commands, and for other NCQ commands (such as FPDMA SEND), their NCQ
tags are set in the delivery command to 0.

So for all the NCQ commands, we also need to assign normal NCQ tag for
them, so drop the command type check in hisi_sas_get_ncq_tag() [drop
hisi_sas_get_ncq_tag() altogether actually], and always use the ATA
command NCQ tag when appropriate.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 -
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 15 ---------------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  5 ++++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  5 ++++-
 4 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index fd998d07ffcd..a72d06d973ff 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -559,7 +559,6 @@ extern u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis,
 extern struct hisi_sas_port *to_hisi_sas_port(struct asd_sas_port *sas_port);
 extern void hisi_sas_sata_done(struct sas_task *task,
 			    struct hisi_sas_slot *slot);
-extern int hisi_sas_get_ncq_tag(struct sas_task *task, u32 *tag);
 extern int hisi_sas_get_fw_info(struct hisi_hba *hisi_hba);
 extern int hisi_sas_probe(struct platform_device *pdev,
 			  const struct hisi_sas_hw *ops);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 4c279a285c20..efd0ddf24e99 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -118,21 +118,6 @@ void hisi_sas_sata_done(struct sas_task *task,
 }
 EXPORT_SYMBOL_GPL(hisi_sas_sata_done);
 
-int hisi_sas_get_ncq_tag(struct sas_task *task, u32 *tag)
-{
-	struct ata_queued_cmd *qc = task->uldd_task;
-
-	if (qc) {
-		if (qc->tf.command == ATA_CMD_FPDMA_WRITE ||
-			qc->tf.command == ATA_CMD_FPDMA_READ) {
-			*tag = qc->tag;
-			return 1;
-		}
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(hisi_sas_get_ncq_tag);
-
 /*
  * This function assumes linkrate mask fits in 8 bits, which it
  * does for all HW versions supported.
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index fba4fcad4735..9d316f28c74c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2534,7 +2534,10 @@ static void prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 	hdr->dw1 = cpu_to_le32(dw1);
 
 	/* dw2 */
-	if (task->ata_task.use_ncq && hisi_sas_get_ncq_tag(task, &hdr_tag)) {
+	if (task->ata_task.use_ncq) {
+		struct ata_queued_cmd *qc = task->uldd_task;
+
+		hdr_tag = qc->tag;
 		task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
 		dw2 |= hdr_tag << CMD_HDR_NCQ_TAG_OFF;
 	}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 4c32088b9199..cd901213a59b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1356,7 +1356,10 @@ static void prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 	hdr->dw1 = cpu_to_le32(dw1);
 
 	/* dw2 */
-	if (task->ata_task.use_ncq && hisi_sas_get_ncq_tag(task, &hdr_tag)) {
+	if (task->ata_task.use_ncq) {
+		struct ata_queued_cmd *qc = task->uldd_task;
+
+		hdr_tag = qc->tag;
 		task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
 		dw2 |= hdr_tag << CMD_HDR_NCQ_TAG_OFF;
 	}
-- 
2.17.1

