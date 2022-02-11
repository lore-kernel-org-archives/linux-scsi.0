Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300AAC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 06:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345105AbiBKGsW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 01:48:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240644AbiBKGsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 01:48:22 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CB710B4
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 22:48:20 -0800 (PST)
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Jw41052qkzccwr;
        Fri, 11 Feb 2022 14:47:16 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Fri, 11 Feb 2022 14:48:18 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 3/4] scsi: libsas: Remove unused parameter for function sas_ata_eh()
Date:   Fri, 11 Feb 2022 14:42:57 +0800
Message-ID: <1644561778-183074-4-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1644561778-183074-1-git-send-email-chenxiang66@hisilicon.com>
References: <1644561778-183074-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Input parameter work_q is not unused in function sas_ata_eh(), so remove it.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_ata.c       | 3 +--
 drivers/scsi/libsas/sas_scsi_host.c | 2 +-
 include/scsi/sas_ata.h              | 6 ++----
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 8dbd5a771824..e0030a093994 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -782,8 +782,7 @@ void sas_ata_strategy_handler(struct Scsi_Host *shost)
 	sas_enable_revalidation(sas_ha);
 }
 
-void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
-		struct list_head *done_q)
+void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q)
 {
 	struct scsi_cmnd *cmd, *n;
 	struct domain_device *eh_dev;
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index fb19e739a39c..bcb391b0c7ed 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -757,7 +757,7 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 	 * scsi_unjam_host does, but we skip scsi_eh_abort_cmds because any
 	 * command we see here has no sas_task and is thus unknown to the HA.
 	 */
-	sas_ata_eh(shost, &eh_work_q, &ha->eh_done_q);
+	sas_ata_eh(shost, &eh_work_q);
 	if (!scsi_eh_get_sense(&eh_work_q, &ha->eh_done_q))
 		scsi_eh_ready_devs(shost, &eh_work_q, &ha->eh_done_q);
 
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 416c9c47d0e7..21e7c10c6295 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -25,8 +25,7 @@ int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy);
 int sas_ata_init(struct domain_device *dev);
 void sas_ata_task_abort(struct sas_task *task);
 void sas_ata_strategy_handler(struct Scsi_Host *shost);
-void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
-		struct list_head *done_q);
+void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q);
 void sas_ata_schedule_reset(struct domain_device *dev);
 void sas_ata_wait_eh(struct domain_device *dev);
 void sas_probe_sata(struct asd_sas_port *port);
@@ -52,8 +51,7 @@ static inline void sas_ata_strategy_handler(struct Scsi_Host *shost)
 {
 }
 
-static inline void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
-			      struct list_head *done_q)
+static inline void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q)
 {
 }
 
-- 
2.33.0

