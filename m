Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F2CC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 14:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 643D02078B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 14:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgIAOzM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:55:12 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44770 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726984AbgIALeb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Sep 2020 07:34:31 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 41B54EC1076991CB71A6;
        Tue,  1 Sep 2020 19:17:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Sep 2020 19:16:58 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 1/8] scsi: hisi_sas: Avoid accessing to SSP task for SMP IOs
Date:   Tue, 1 Sep 2020 19:13:03 +0800
Message-ID: <1598958790-232272-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1598958790-232272-1-git-send-email-john.garry@huawei.com>
References: <1598958790-232272-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

In function hisi_sas_slot_task_free(), it accesses to SSP task for
non-ATA task. But if it is SMP task here, it accesses to wrong structure
though it may not cause any issue.

To avoid it, only access to ssp task when slot->n_elem_dif is not 0
which indicates this is SSP task.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 11caa4b0d797..fdf5f0f1b60b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -229,17 +229,18 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 		task->lldd_task = NULL;
 
 		if (!sas_protocol_ata(task->task_proto)) {
-			struct sas_ssp_task *ssp_task = &task->ssp_task;
-			struct scsi_cmnd *scsi_cmnd = ssp_task->cmd;
-
 			if (slot->n_elem)
 				dma_unmap_sg(dev, task->scatter,
 					     task->num_scatter,
 					     task->data_dir);
-			if (slot->n_elem_dif)
+			if (slot->n_elem_dif) {
+				struct sas_ssp_task *ssp_task = &task->ssp_task;
+				struct scsi_cmnd *scsi_cmnd = ssp_task->cmd;
+
 				dma_unmap_sg(dev, scsi_prot_sglist(scsi_cmnd),
 					     scsi_prot_sg_count(scsi_cmnd),
 					     task->data_dir);
+			}
 		}
 	}
 
-- 
2.26.2

