Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F32ECA9EBC
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F16302070B
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502832AbfJXOZK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:25:10 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:32862 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2409438AbfJXOZJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 10:25:09 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4B66193F067BE1EE2EF5;
        Thu, 24 Oct 2019 22:24:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Thu, 24 Oct 2019 22:24:40 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, <hare@suse.com>,
        <ming.lei@redhat.com>, "John Garry" <john.garry@huawei.com>
Subject: [PATCH 2/6] scsi: hisi_sas: Pass scsi_cmnd pointer to hisi_sas_hw.slot_index_alloc
Date:   Thu, 24 Oct 2019 22:21:17 +0800
Message-ID: <1571926881-75524-3-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
References: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In future we will want to pass both the domain_device and scsi_cmnd
pointers to hisi_sas_hw.slot_index_alloc.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 3 ++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index fbfaa92765cf..4eb8f1c53f78 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -278,7 +278,8 @@ struct hisi_sas_hw {
 	void (*setup_itct)(struct hisi_hba *hisi_hba,
 			   struct hisi_sas_device *device);
 	int (*slot_index_alloc)(struct hisi_hba *hisi_hba,
-				struct domain_device *device);
+				struct domain_device *device,
+				struct scsi_cmnd *scmd);
 	void (*slot_index_free)(struct hisi_hba *hisi_hba, int slot_idx);
 	int (*bitmaps_alloc)(struct hisi_hba *hisi_hba);
 	struct hisi_sas_device *(*alloc_dev)(struct domain_device *device);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f4937da9baf8..53802c1cc1d0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -438,7 +438,7 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	}
 
 	if (hisi_hba->hw->slot_index_alloc)
-		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device);
+		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device, NULL);
 	else {
 		struct scsi_cmnd *scsi_cmnd = NULL;
 
@@ -1929,7 +1929,7 @@ hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
 
 	/* simply get a slot and send abort command */
 	if (hisi_hba->hw->slot_index_alloc)
-		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device);
+		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device, NULL);
 	else
 		rc = hisi_sas_slot_index_alloc(hisi_hba, NULL);
 	if (rc < 0)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 683e1b99c9ae..b98ae960964b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -791,7 +791,8 @@ static int bitmaps_alloc_v2_hw(struct hisi_hba *hisi_hba)
 
 static int
 slot_index_alloc_quirk_v2_hw(struct hisi_hba *hisi_hba,
-			     struct domain_device *device)
+			     struct domain_device *device,
+			     struct scsi_cmnd *scmd)
 {
 	struct sbitmap *slot_index_tags;
 	int sata_dev = dev_is_sata(device);
-- 
2.17.1

