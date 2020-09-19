Return-Path: <SRS0=lXoO=C4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 081FFC43464
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 02:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB36C235F8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 02:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgISCvt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 22:51:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43186 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbgISCvn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Sep 2020 22:51:43 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4C23BE540AD0EEDBBE14;
        Sat, 19 Sep 2020 10:51:42 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 10:51:32 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Qinglang Miao" <miaoqinglang@huawei.com>
Subject: [PATCH -next v2] scsi: snic: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Sat, 19 Sep 2020 10:52:04 +0800
Message-ID: <20200919025204.17597-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
v2: based on linux-next(20200917), and can be applied to
    mainline cleanly now.

 drivers/scsi/snic/snic_debugfs.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/scsi/snic/snic_debugfs.c b/drivers/scsi/snic/snic_debugfs.c
index 2b3493655..a142e17aa 100644
--- a/drivers/scsi/snic/snic_debugfs.c
+++ b/drivers/scsi/snic/snic_debugfs.c
@@ -334,25 +334,7 @@ snic_stats_show(struct seq_file *sfp, void *data)
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
2.23.0

