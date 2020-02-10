Return-Path: <SRS0=AJIY=36=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A003C35254
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 17:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F8492080C
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 17:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgBJRhQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Feb 2020 12:37:16 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:33056 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727697AbgBJRhP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Feb 2020 12:37:15 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8AAA72BF909F7F6ABD38;
        Tue, 11 Feb 2020 01:37:11 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Tue, 11 Feb 2020 01:37:03 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: Delete scsi_use_blk_mq
Date:   Tue, 11 Feb 2020 01:33:12 +0800
Message-ID: <1581355992-139274-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Module param scsi_use_blk_mq has not been referenced for some time, so
zap it.

Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 930e4803d888..4b9fdfab77d9 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -764,10 +764,6 @@ MODULE_LICENSE("GPL");
 module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
 
-/* This should go away in the future, it doesn't do anything anymore */
-bool scsi_use_blk_mq = true;
-module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | S_IRUGO);
-
 static int __init init_scsi(void)
 {
 	int error;
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 3bff9f7aa684..25b0aaaf5ae8 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -29,7 +29,6 @@ extern int scsi_init_hosts(void);
 extern void scsi_exit_hosts(void);
 
 /* scsi.c */
-extern bool scsi_use_blk_mq;
 int scsi_init_sense_cache(struct Scsi_Host *shost);
 void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd);
 #ifdef CONFIG_SCSI_LOGGING
-- 
2.17.1

