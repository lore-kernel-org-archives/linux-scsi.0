Return-Path: <SRS0=de5d=CV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC2F4C10DAA
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Sep 2020 03:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7462F22206
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Sep 2020 03:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgILDil (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 23:38:41 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12238 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbgILDik (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Sep 2020 23:38:40 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 372FE63358678070A603;
        Sat, 12 Sep 2020 11:38:36 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Sat, 12 Sep 2020
 11:38:29 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <aacraid@microsemi.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: aacraid: make some symbols static in aachba.c
Date:   Sat, 12 Sep 2020 11:37:49 +0800
Message-ID: <20200912033749.142488-1-yanaijie@huawei.com>
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

drivers/scsi/aacraid/aachba.c:245:5: warning: symbol 'aac_convert_sgl'
was not declared. Should it be static?
drivers/scsi/aacraid/aachba.c:293:5: warning: symbol 'acbsize' was not
declared. Should it be static?
drivers/scsi/aacraid/aachba.c:324:5: warning: symbol 'aac_wwn' was not
declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/aacraid/aachba.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 6a44d385c745..31233f6a0274 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -242,7 +242,7 @@ int aac_commit = -1;
 int startup_timeout = 180;
 int aif_timeout = 120;
 int aac_sync_mode;  /* Only Sync. transfer - disabled */
-int aac_convert_sgl = 1;	/* convert non-conformable s/g list - enabled */
+static int aac_convert_sgl = 1;	/* convert non-conformable s/g list - enabled */
 
 module_param(aac_sync_mode, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(aac_sync_mode, "Force sync. transfer mode"
@@ -290,7 +290,7 @@ MODULE_PARM_DESC(numacb, "Request a limit to the number of adapter control"
 	" blocks (FIB) allocated. Valid values are 512 and down. Default is"
 	" to use suggestion from Firmware.");
 
-int acbsize = -1;
+static int acbsize = -1;
 module_param(acbsize, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(acbsize, "Request a specific adapter control block (FIB)"
 	" size. Valid values are 512, 2048, 4096 and 8192. Default is to use"
@@ -321,7 +321,7 @@ int aac_reset_devices;
 module_param_named(reset_devices, aac_reset_devices, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(reset_devices, "Force an adapter reset at initialization.");
 
-int aac_wwn = 1;
+static int aac_wwn = 1;
 module_param_named(wwn, aac_wwn, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(wwn, "Select a WWN type for the arrays:\n"
 	"\t0 - Disable\n"
-- 
2.25.4

