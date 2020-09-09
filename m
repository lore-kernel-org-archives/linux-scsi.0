Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCD1C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 08:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 587CC2087C
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 08:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgIIITs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 04:19:48 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52396 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728611AbgIIITp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Sep 2020 04:19:45 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EC0B351BCE9E82517DBE;
        Wed,  9 Sep 2020 16:19:40 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 16:19:33 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH] scsi: gdth: Remove set but used 'cmd_index'
Date:   Wed, 9 Sep 2020 16:26:26 +0800
Message-ID: <20200909082627.101984-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.16.2.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This addresses the following gcc warning with "make W=1":

drivers/scsi/gdth.c: In function ‘gdth_async_event’:
drivers/scsi/gdth.c:3010:9: warning: variable ‘cmd_index’ set but not
used [-Wunused-but-set-variable]
     int cmd_index;

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/gdth.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 7f150d52b4a6..dc0e17729acf 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3007,7 +3007,6 @@ static char *async_cache_tab[] = {
 static int gdth_async_event(gdth_ha_str *ha)
 {
     gdth_cmd_str *cmdp;
-    int cmd_index;
 
     cmdp= ha->pccb;
     TRACE2(("gdth_async_event() ha %d serv %d\n",
@@ -3019,7 +3018,6 @@ static int gdth_async_event(gdth_ha_str *ha)
                 gdth_delay(0);
             cmdp->Service       = SCREENSERVICE;
             cmdp->RequestBuffer = SCREEN_CMND;
-            cmd_index = gdth_get_cmd_index(ha);
             gdth_set_sema0(ha);
             cmdp->OpCode        = GDT_READ;
             cmdp->BoardNode     = LOCALBOARD;
-- 
2.16.2.dirty

