Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADC4C6FD1F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Mar 2023 03:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCTDD5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Mar 2023 23:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCTDDu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Mar 2023 23:03:50 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A625D1995
        for <linux-scsi@vger.kernel.org>; Sun, 19 Mar 2023 20:03:47 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Pg00R2wnlzrTtl;
        Mon, 20 Mar 2023 11:02:47 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 11:03:45 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        Xingui Yang <yangxingui@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 2/4] scsi: hisi_sas: Handle NCQ error when IPTT is valid
Date:   Mon, 20 Mar 2023 11:34:23 +0800
Message-ID: <1679283265-115066-3-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1679283265-115066-1-git-send-email-chenxiang66@hisilicon.com>
References: <1679283265-115066-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xingui Yang <yangxingui@huawei.com>

If an NCQ error occurs when the IPTT is valid and slot->abort flag is set
in completion path, sas_task_abort() will be called to abort only one NCQ
command now, and the host would be set to SHOST_RECOVERY state. But this
may not kick-off EH Immediately until other outstanding QCs timeouts. As a
result, the host may remain in the SHOST_RECOVERY state for up to 30
seconds, such as follows:

[7972317.645234] hisi_sas_v3_hw 0000:74:04.0: erroneous completion iptt=3264 task=00000000466116b8 dev id=2 sas_addr=0x5000000000000502 CQ hdr: 0x1883 0x20cc0 0x40000 0x20420000 Error info: 0x0 0x0 0x200000 0x0
[7972341.508264] sas: Enter sas_scsi_recover_host busy: 32 failed: 32
[7972341.984731] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 32 tries: 1

So all NCQ commands that are in the queue should be aborted when an NCQ
error occurs in this scenario.

Fixes: 05d91b557af9 ("scsi: hisi_sas: Directly trigger SCSI error handling for completion errors")

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 6 +++++-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 6 +++++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 6 +++++-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 7ea36659..76176b1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1258,7 +1258,11 @@ static void slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 
 		slot_err_v1_hw(hisi_hba, task, slot);
 		if (unlikely(slot->abort)) {
-			sas_task_abort(task);
+			if (dev_is_sata(device) && task->ata_task.use_ncq)
+				sas_ata_device_link_abort(device, true);
+			else
+				sas_task_abort(task);
+
 			return;
 		}
 		goto out;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index ef896ef..746e4d7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2404,7 +2404,11 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
 				 error_info[2], error_info[3]);
 
 		if (unlikely(slot->abort)) {
-			sas_task_abort(task);
+			if (dev_is_sata(device) && task->ata_task.use_ncq)
+				sas_ata_device_link_abort(device, true);
+			else
+				sas_task_abort(task);
+
 			return;
 		}
 		goto out;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 8c78a6b..791c0eab 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2327,7 +2327,11 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 					error_info[0], error_info[1],
 					error_info[2], error_info[3]);
 			if (unlikely(slot->abort)) {
-				sas_task_abort(task);
+				if (dev_is_sata(device) && task->ata_task.use_ncq)
+					sas_ata_device_link_abort(device, true);
+				else
+					sas_task_abort(task);
+
 				return;
 			}
 			goto out;
-- 
2.8.1

