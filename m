Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C5FC3A5A7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 08:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiLHIWk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 03:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiLHIWi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 03:22:38 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2683AF78
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 00:22:36 -0800 (PST)
Received: from dggpeml500019.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NSRvW4l6pzmWLC;
        Thu,  8 Dec 2022 16:21:43 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500019.china.huawei.com
 (7.185.36.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 8 Dec
 2022 16:22:34 +0800
From:   Wu Bo <wubo40@huawei.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <qiuchangqi.qiu@huawei.com>, <wubo40@huawei.com>
Subject: [PATCH] scsi: core: Add a helper for retry scsi cmnd
Date:   Thu, 8 Dec 2022 17:03:24 +0800
Message-ID: <1670490204-10239-1-git-send-email-wubo40@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500019.china.huawei.com (7.185.36.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

Without any functional modifications,
just adding a helper function for retry scsi cmnd.

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
 drivers/scsi/scsi_error.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6995c8979230..8fde072192dd 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -133,6 +133,16 @@ static bool scsi_eh_should_retry_cmd(struct scsi_cmnd *cmd)
 	return true;
 }
 
+static bool scsi_need_retry_cmd(struct scsi_cmnd *scmd)
+{
+	if (!scsi_noretry_cmd(scmd) &&
+	    scsi_cmd_retry_allowed(scmd) &&
+	    scsi_eh_should_retry_cmd(scmd))
+		return true;
+
+	return false;
+}
+
 /**
  * scmd_eh_abort_handler - Handle command aborts
  * @work:	command to be aborted.
@@ -195,9 +205,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	if (!scsi_noretry_cmd(scmd) &&
-	    scsi_cmd_retry_allowed(scmd) &&
-	    scsi_eh_should_retry_cmd(scmd)) {
+	if (scsi_need_retry_cmd(scmd)) {
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_WARNING, scmd,
 				    "retry aborted command\n"));
@@ -2149,8 +2157,7 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
-		    !scsi_noretry_cmd(scmd) && scsi_cmd_retry_allowed(scmd) &&
-			scsi_eh_should_retry_cmd(scmd)) {
+		    scsi_need_retry_cmd(scmd)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
 					     "%s: flush retry cmd\n",
-- 
2.33.0

