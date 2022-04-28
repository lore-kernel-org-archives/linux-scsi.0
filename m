Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98130C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Apr 2022 07:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241640AbiD1HIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Apr 2022 03:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244769AbiD1HIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Apr 2022 03:08:01 -0400
Received: from m12-13.163.com (m12-13.163.com [220.181.12.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91ED298F44;
        Thu, 28 Apr 2022 00:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=v7ddE
        ZSDRf6xzmmtMm6vxzsMFaKIpnIxHYegWszCApk=; b=Br6R/9swlPSl10JEdBB33
        yMX3nJpam/10siAqVrgByKkuWzQQBrxpTeCvEFdJvL/OxWDi+g0JC6Ed1VT3Q2R2
        USLimbFlLkjyASuccmhYDC2JEwc1LOIIFJyoh0wGC+Wq6+o9g0mQKyahTt3sdXQr
        SwZdl6BrYm7yVrV2wCrq5k=
Received: from carlis (unknown [218.17.89.92])
        by smtp9 (Coremail) with SMTP id DcCowADHjHsXPGpiuFB+Dw--.17805S2;
        Thu, 28 Apr 2022 15:02:47 +0800 (CST)
From:   Xuezhi Zhang <zhangxuezhi1@coolpad.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuezhi Zhang <zhangxuezhi1@coolpad.com>
Subject: [PATCH] scsi: pmcraid: convert sysfs snprintf to sysfs_emit
Date:   Thu, 28 Apr 2022 07:02:45 +0000
Message-Id: <20220428070245.255827-1-zhangxuezhi1@coolpad.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowADHjHsXPGpiuFB+Dw--.17805S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF48CF18tr47Zr45uFy8Zrb_yoW8WF4xpa
        yrGryUAa1DJr15AryUXay0v3WFvayxJa4DtFWkZ3savF9ayrWkJ39rAFWagFs5Gr4kur9x
        Zw4qyw1Y9a1jyrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jlbyZUUUUU=
X-Originating-IP: [218.17.89.92]
Sender: llyz108@163.com
X-CM-SenderInfo: xoo16iiqy6il2tof0z/1tbiDxnwhVUMdGFAjgAAsh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warnings:
drivers/scsi/pmcraid.c:3591:8-16:
WARNING: use scnprintf or sprintf
drivers/scsi/pmcraid.c:3557:8-16:
WARNING: use scnprintf or sprintf
drivers/scsi/pmcraid.c:3496:8-16:
WARNING: use scnprintf or sprintf

Signed-off-by: Xuezhi Zhang <zhangxuezhi1@coolpad.com>
---
 drivers/scsi/pmcraid.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 3d5cd337a2a6..299553ff2277 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3493,7 +3493,7 @@ static ssize_t pmcraid_show_log_level(
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct pmcraid_instance *pinstance =
 		(struct pmcraid_instance *)shost->hostdata;
-	return snprintf(buf, PAGE_SIZE, "%d\n", pinstance->current_log_level);
+	return sysfs_emit(buf, "%d\n", pinstance->current_log_level);
 }
 
 /**
@@ -3554,8 +3554,7 @@ static ssize_t pmcraid_show_drv_version(
 	char *buf
 )
 {
-	return snprintf(buf, PAGE_SIZE, "version: %s\n",
-			PMCRAID_DRIVER_VERSION);
+	return sysfs_emt(buf, "version: %s\n", PMCRAID_DRIVER_VERSION);
 }
 
 static struct device_attribute pmcraid_driver_version_attr = {
@@ -3588,8 +3587,7 @@ static ssize_t pmcraid_show_adapter_id(
 		pinstance->pdev->devfn;
 	u32 aen_group = pmcraid_event_family.id;
 
-	return snprintf(buf, PAGE_SIZE,
-			"adapter id: %d\nminor: %d\naen group: %d\n",
+	return sysfs_emit(buf, "adapter id: %d\nminor: %d\naen group: %d\n",
 			adapter_id, MINOR(pinstance->cdev.dev), aen_group);
 }
 
-- 
2.25.1

