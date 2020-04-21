Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A7AC54FC9
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 12:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CACC2076C
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 12:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgDUMX6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 08:23:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48588 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728391AbgDUMX6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 08:23:58 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 62CB9E3A20F88D91D6E8;
        Tue, 21 Apr 2020 20:23:56 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Tue, 21 Apr 2020 20:23:47 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <hare@suse.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] scsi: aic7xxx: fix kzalloc-simple.cocci warnings
Date:   Tue, 21 Apr 2020 20:30:07 +0800
Message-ID: <1587472207-105095-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes below warning reported by coccicheck

drivers/scsi/aic7xxx/aic7xxx_core.c:4387:7-14: WARNING: kzalloc
should be used for ahc, instead of kmalloc/memset

Fixes: 48813cf989eb ("[SCSI] aic7xxx: Remove OS utility wrappers")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 84fc499..999de19 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -4384,13 +4384,12 @@ ahc_alloc(void *platform_arg, char *name)
 	struct  ahc_softc *ahc;
 	int	i;
 
-	ahc = kmalloc(sizeof(*ahc), GFP_ATOMIC);
+	ahc = kzalloc(sizeof(*ahc), GFP_ATOMIC);
 	if (!ahc) {
 		printk("aic7xxx: cannot malloc softc!\n");
 		kfree(name);
 		return NULL;
 	}
-	memset(ahc, 0, sizeof(*ahc));
 	ahc->seep_config = kmalloc(sizeof(*ahc->seep_config), GFP_ATOMIC);
 	if (ahc->seep_config == NULL) {
 		kfree(ahc);
-- 
2.6.2

