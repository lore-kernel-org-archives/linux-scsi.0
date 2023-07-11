Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EB7EB64D9
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 02:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjGKCok (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jul 2023 22:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjGKCoj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2023 22:44:39 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9961E1BB
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 19:44:37 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R0Q9W2y9WzMqYn;
        Tue, 11 Jul 2023 10:41:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 11 Jul 2023 10:44:35 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        Yihang Li <liyihang9@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 2/3] scsi: hisi_sas: Block requests before a debugfs snapshot
Date:   Tue, 11 Jul 2023 11:14:59 +0800
Message-ID: <1689045300-44318-3-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1689045300-44318-1-git-send-email-chenxiang66@hisilicon.com>
References: <1689045300-44318-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yihang Li <liyihang9@huawei.com>

When FIO and debugfs snapshot occur concurrently, some SATA I/Os are failed
to return to the upper layer due to the setting of HISI_SAS_REJECT_CMD_BIT.
Then the SCSI layer invokes the error processing thread. However,
sas_ata_hard_reset() in EH also fails to be reset due to
the setting of HISI_SAS_REJECT_CMD_BIT. As a result, the device is
disabled.

Calling scsi_block_requests() in the front of a debugfs snapshot and wait
command complete before setting HISI_SAS_REJECT_CMD_BIT to avoid
SATA I/O failures.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 2f33e6b..7aad495 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3106,21 +3106,25 @@ static const struct hisi_sas_debugfs_reg debugfs_ras_reg = {
 
 static void debugfs_snapshot_prepare_v3_hw(struct hisi_hba *hisi_hba)
 {
-	set_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
-
-	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0);
+	struct Scsi_Host *shost = hisi_hba->shost;
 
+	scsi_block_requests(shost);
 	wait_cmds_complete_timeout_v3_hw(hisi_hba, 100, 5000);
 
+	set_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
 	hisi_sas_sync_cqs(hisi_hba);
+	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0);
 }
 
 static void debugfs_snapshot_restore_v3_hw(struct hisi_hba *hisi_hba)
 {
+	struct Scsi_Host *shost = hisi_hba->shost;
+
 	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE,
 			 (u32)((1ULL << hisi_hba->queue_count) - 1));
 
 	clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
+	scsi_unblock_requests(shost);
 }
 
 static void read_iost_itct_cache_v3_hw(struct hisi_hba *hisi_hba,
-- 
2.8.1

