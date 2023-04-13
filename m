Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C51EC77B6C
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Apr 2023 11:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjDMLQL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Apr 2023 07:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjDMLQJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2023 07:16:09 -0400
Received: from mail.nfschina.com (unknown [42.101.60.195])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id C57405BB1;
        Thu, 13 Apr 2023 04:16:06 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
        by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 01C6518010E36D;
        Thu, 13 Apr 2023 19:15:58 +0800 (CST)
X-MD-Sfrom: liqiong@nfschina.com
X-MD-SrcIP: 180.167.10.98
From:   Li Qiong <liqiong@nfschina.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Qiong <liqiong@nfschina.com>
Subject: [PATCH 4/4] scsi: snic: Remove unnecessary (void*) conversions
Date:   Thu, 13 Apr 2023 19:15:11 +0800
Message-Id: <20230413111511.15579-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No need to cast (void*) pointer to other type.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
---
 drivers/scsi/snic/snic_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic_debugfs.c b/drivers/scsi/snic/snic_debugfs.c
index 9dd975b36b5b..06de583caed1 100644
--- a/drivers/scsi/snic/snic_debugfs.c
+++ b/drivers/scsi/snic/snic_debugfs.c
@@ -164,7 +164,7 @@ snic_reset_stats_release(struct inode *inode, struct file *filp)
 static int
 snic_stats_show(struct seq_file *sfp, void *data)
 {
-	struct snic *snic = (struct snic *) sfp->private;
+	struct snic *snic = sfp->private;
 	struct snic_stats *stats = &snic->s_stats;
 	struct timespec64 last_isr_tms, last_ack_tms;
 	u64 maxio_tm;
-- 
2.11.0

