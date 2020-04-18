Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140D3C352BE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 09:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F04F321D7E
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 09:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgDRJdX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 05:33:23 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58614 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725857AbgDRJdW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Apr 2020 05:33:22 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C93FDDA43FC81A956E8D;
        Sat, 18 Apr 2020 17:33:20 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Apr 2020
 17:33:13 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <hare@suse.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <yanaijie@huawei.com>,
        <alex.dewar@gmx.co.uk>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: aic7xxx: aic97xx: remove NULL check before some freeing functions
Date:   Sat, 18 Apr 2020 17:59:39 +0800
Message-ID: <20200418095939.35626-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

drivers/scsi/aic7xxx/aic79xx_core.c:6186:2-7: WARNING: NULL check before
some freeing functions is not needed.
drivers/scsi/aic7xxx/aic79xx_core.c:6188:2-7: WARNING: NULL check before
some freeing functions is not needed.
drivers/scsi/aic7xxx/aic79xx_core.c:6190:2-7: WARNING: NULL check before
some freeing functions is not needed.
drivers/scsi/aic7xxx/aic79xx_core.c:3666:2-7: WARNING: NULL check before
some freeing functions is not needed.
drivers/scsi/aic7xxx/aic79xx_core.c:6124:2-7: WARNING: NULL check before
some freeing functions is not needed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index a336a458c978..72eaad4aef9c 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -3662,8 +3662,7 @@ ahd_free_tstate(struct ahd_softc *ahd, u_int scsi_id, char channel, int force)
 		return;
 
 	tstate = ahd->enabled_targets[scsi_id];
-	if (tstate != NULL)
-		kfree(tstate);
+	kfree(tstate);
 	ahd->enabled_targets[scsi_id] = NULL;
 }
 #endif
@@ -6120,8 +6119,7 @@ ahd_set_unit(struct ahd_softc *ahd, int unit)
 void
 ahd_set_name(struct ahd_softc *ahd, char *name)
 {
-	if (ahd->name != NULL)
-		kfree(ahd->name);
+	kfree(ahd->name);
 	ahd->name = name;
 }
 
@@ -6182,12 +6180,9 @@ ahd_free(struct ahd_softc *ahd)
 		kfree(ahd->black_hole);
 	}
 #endif
-	if (ahd->name != NULL)
-		kfree(ahd->name);
-	if (ahd->seep_config != NULL)
-		kfree(ahd->seep_config);
-	if (ahd->saved_stack != NULL)
-		kfree(ahd->saved_stack);
+	kfree(ahd->name);
+	kfree(ahd->seep_config);
+	kfree(ahd->saved_stack);
 	kfree(ahd);
 	return;
 }
-- 
2.21.1

