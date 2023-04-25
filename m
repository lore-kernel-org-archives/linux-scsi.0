Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE64C77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 08:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbjDYIBV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 04:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbjDYIBJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 04:01:09 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BF362D52
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 01:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=cUey7
        z1k8E/46MdL9dggWT7jm+NhuSq1kEgtGgpEXCY=; b=hMp9/yvNQZC5RcsOkWls8
        AhkWJm9vZT8D61kpEBuUbq5oR3nhh/mWQJ7czCcpYUutQ09nvUz3rRNCmqd45lK0
        BPv1/td2Lq/Eus1pRFAT2z9SEBs8sZuVS8pN6Alu3BXYTEoDbbhD5cfaxmgYSqDW
        jDwflro1Ky4ZYP10qFWyjE=
Received: from localhost.localdomain (unknown [114.247.186.100])
        by zwqz-smtp-mta-g5-2 (Coremail) with SMTP id _____wDn8fCviEdk2ANLAA--.19458S2;
        Tue, 25 Apr 2023 16:00:48 +0800 (CST)
From:   "longguang.yue" <bigclouds@163.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, "longguang.yue" <bigclouds@163.com>
Subject: [PATCH] Add a parameter to set sd driver's probe mode.
Date:   Tue, 25 Apr 2023 15:59:48 +0800
Message-Id: <20230425075948.87632-1-bigclouds@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDn8fCviEdk2ANLAA--.19458S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7JFWUJr15ZF17Aw4UWrWfXwb_yoW8Jr1fpF
        18A3yqyr4Uta12ga1UA39Fy3WSg3y8J34rWF9xK34avF1jkrWvqwnrJFy7XFWDGFZ2yas7
        ZF45JFyYgayxAF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zi0tCfUUUUU=
X-Originating-IP: [114.247.186.100]
X-CM-SenderInfo: peljuzprxg2qqrwthudrp/1tbiNhNcQ1WBspmk2AAAs5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Asynchronous probe leads to the change of disk name, so it is hard
to trace disk by its name for monitoring system.

Signed-off-by: longguang.yue <bigclouds@163.com>
---
 drivers/scsi/sd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4bb87043e6db..ea0ac8823599 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -99,6 +99,11 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 
 #define SD_MINORS	16
 
+static unsigned int async = PROBE_PREFER_ASYNCHRONOUS;
+module_param(async, uint, 0644);
+MODULE_PARM_DESC(async,
+		 "probe scsi disk asynchronously or not. Default is 1 asynchronous.");
+
 static void sd_config_discard(struct scsi_disk *, unsigned int);
 static void sd_config_write_same(struct scsi_disk *);
 static int  sd_revalidate_disk(struct gendisk *);
@@ -3839,6 +3844,9 @@ static int __init init_sd(void)
 
 	SCSI_LOG_HLQUEUE(3, printk("init_sd: sd driver entry point\n"));
 
+	if (async != PROBE_PREFER_ASYNCHRONOUS)
+		sd_template.gendrv.probe_type = PROBE_FORCE_SYNCHRONOUS;
+
 	for (i = 0; i < SD_MAJORS; i++) {
 		if (__register_blkdev(sd_major(i), "sd", sd_default_probe))
 			continue;
-- 
2.34.1

