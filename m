Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95458C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 06:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 660AA619CD
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 06:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhCaGyv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 02:54:51 -0400
Received: from m12-15.163.com ([220.181.12.15]:37761 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233882AbhCaGy3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Mar 2021 02:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=oq8zk
        QsfRmP+TwGtngegVNID8FxzD/vz8LfBVGUEitY=; b=n+sb+1lSil55V04CxwAbB
        RgghwsOHNkkDrnWebTteVbrKyOM5HUiLrquSnn8z9LAjxna7mT80zfJzAaP2mD/i
        5HXrKIk+qSMFwJ2otYxlAKHNWdcHOaXqqTHZadckW7n+BXjOo0AALa48NNikvVUE
        /NbEIpQRaHs/WOENbsfKqo=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp11 (Coremail) with SMTP id D8CowAD3UYByHGRgP7ZeAA--.11704S2;
        Wed, 31 Mar 2021 14:53:41 +0800 (CST)
From:   dingsenjie@163.com
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] scsi: snic: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Wed, 31 Mar 2021 14:53:25 +0800
Message-Id: <20210331065326.18804-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: D8CowAD3UYByHGRgP7ZeAA--.11704S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xw4rXF1xGw43KrWxKFW8tFb_yoWkuwbE9a
        y8tr13Cry8trWxJ34vgryvvFWSvayUWw1vgrsaqFWfCwnxZF95Ar1kWFW7Zw4UWr47JF90
        9ryfXF1Yyr1UujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8UKsUUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbipRVmyFUMdIMmrwAAs5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 drivers/scsi/snic/snic_debugfs.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/scsi/snic/snic_debugfs.c b/drivers/scsi/snic/snic_debugfs.c
index 4471c4c..3aeee85 100644
--- a/drivers/scsi/snic/snic_debugfs.c
+++ b/drivers/scsi/snic/snic_debugfs.c
@@ -334,25 +334,7 @@ void snic_debugfs_init(void)
 	return 0;
 }
 
-/*
- * snic_stats_open - Open the stats file for specific host
- *
- * Description:
- * This routine opens a debugfs file stats of specific host
- */
-static int
-snic_stats_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, snic_stats_show, inode->i_private);
-}
-
-static const struct file_operations snic_stats_fops = {
-	.owner	= THIS_MODULE,
-	.open	= snic_stats_open,
-	.read	= seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(snic_stats);
 
 static const struct file_operations snic_reset_stats_fops = {
 	.owner = THIS_MODULE,
-- 
1.9.1


