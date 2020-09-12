Return-Path: <SRS0=de5d=CV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8619FC43461
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Sep 2020 03:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 595AB221ED
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Sep 2020 03:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgILDiw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 23:38:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:32922 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbgILDiv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Sep 2020 23:38:51 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 40232392D70814023D20;
        Sat, 12 Sep 2020 11:38:49 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Sat, 12 Sep 2020
 11:38:39 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <skashyap@marvell.com>, <jhasan@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <lee.jones@linaro.org>,
        <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: bnx2fc: make a bunch of symbols static in bnx2fc_fcoe.c
Date:   Sat, 12 Sep 2020 11:37:58 +0800
Message-ID: <20200912033758.142601-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This eliminates the following sparse warning:

drivers/scsi/bnx2fc/bnx2fc_fcoe.c:53:1: warning: symbol
'bnx2fc_global_lock' was not declared. Should it be static?
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:111:6: warning: symbol
'bnx2fc_devloss_tmo' was not declared. Should it be static?
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:116:6: warning: symbol
'bnx2fc_max_luns' was not declared. Should it be static?
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:121:6: warning: symbol
'bnx2fc_queue_depth' was not declared. Should it be static?
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:126:6: warning: symbol
'bnx2fc_log_fka' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 5cdeeb3539fd..6890bbe04a8c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -50,7 +50,7 @@ struct workqueue_struct *bnx2fc_wq;
  * Here the io threads are per cpu but the l2 thread is just one
  */
 struct fcoe_percpu_s bnx2fc_global;
-DEFINE_SPINLOCK(bnx2fc_global_lock);
+static DEFINE_SPINLOCK(bnx2fc_global_lock);
 
 static struct cnic_ulp_ops bnx2fc_cnic_cb;
 static struct libfc_function_template bnx2fc_libfc_fcn_templ;
@@ -108,22 +108,22 @@ MODULE_PARM_DESC(debug_logging,
 		"\t\t0x10 - fcoe L2 fame related logs.\n"
 		"\t\t0xff - LOG all messages.");
 
-uint bnx2fc_devloss_tmo;
+static uint bnx2fc_devloss_tmo;
 module_param_named(devloss_tmo, bnx2fc_devloss_tmo, uint, S_IRUGO);
 MODULE_PARM_DESC(devloss_tmo, " Change devloss_tmo for the remote ports "
 	"attached via bnx2fc.");
 
-uint bnx2fc_max_luns = BNX2FC_MAX_LUN;
+static uint bnx2fc_max_luns = BNX2FC_MAX_LUN;
 module_param_named(max_luns, bnx2fc_max_luns, uint, S_IRUGO);
 MODULE_PARM_DESC(max_luns, " Change the default max_lun per SCSI host. Default "
 	"0xffff.");
 
-uint bnx2fc_queue_depth;
+static uint bnx2fc_queue_depth;
 module_param_named(queue_depth, bnx2fc_queue_depth, uint, S_IRUGO);
 MODULE_PARM_DESC(queue_depth, " Change the default queue depth of SCSI devices "
 	"attached via bnx2fc.");
 
-uint bnx2fc_log_fka;
+static uint bnx2fc_log_fka;
 module_param_named(log_fka, bnx2fc_log_fka, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(log_fka, " Print message to kernel log when fcoe is "
 	"initiating a FIP keep alive when debug logging is enabled.");
-- 
2.25.4

