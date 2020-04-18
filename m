Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D8DC352BE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 09:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2971A2220A
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 09:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgDRJdK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 05:33:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2797 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725857AbgDRJdK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Apr 2020 05:33:10 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4B982CC0B6FFC8E55697;
        Sat, 18 Apr 2020 17:33:09 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Apr 2020
 17:33:01 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <hare@suse.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <yanaijie@huawei.com>,
        <alex.dewar@gmx.co.uk>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: aic7xxx: remove NULL check before some freeing functions
Date:   Sat, 18 Apr 2020 17:59:27 +0800
Message-ID: <20200418095927.35460-1-yanaijie@huawei.com>
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

drivers/scsi/aic7xxx/aic7xxx_core.c:4931:2-7: WARNING: NULL check before
some freeing functions is not needed.
drivers/scsi/aic7xxx/aic7xxx_core.c:4519:2-7: WARNING: NULL check before
some freeing functions is not needed.
drivers/scsi/aic7xxx/aic7xxx_core.c:4521:2-7: WARNING: NULL check before
some freeing functions is not needed.
drivers/scsi/aic7xxx/aic7xxx_core.c:2182:2-7: WARNING: NULL check before
some freeing functions is not needed.
drivers/scsi/aic7xxx/aic7xxx_core.c:4457:2-7: WARNING: NULL check before
some freeing functions is not needed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 84fc499cb1e6..5a10feea17fe 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -2178,8 +2178,7 @@ ahc_free_tstate(struct ahc_softc *ahc, u_int scsi_id, char channel, int force)
 	if (channel == 'B')
 		scsi_id += 8;
 	tstate = ahc->enabled_targets[scsi_id];
-	if (tstate != NULL)
-		kfree(tstate);
+	kfree(tstate);
 	ahc->enabled_targets[scsi_id] = NULL;
 }
 #endif
@@ -4453,8 +4452,7 @@ ahc_set_unit(struct ahc_softc *ahc, int unit)
 void
 ahc_set_name(struct ahc_softc *ahc, char *name)
 {
-	if (ahc->name != NULL)
-		kfree(ahc->name);
+	kfree(ahc->name);
 	ahc->name = name;
 }
 
@@ -4515,10 +4513,8 @@ ahc_free(struct ahc_softc *ahc)
 		kfree(ahc->black_hole);
 	}
 #endif
-	if (ahc->name != NULL)
-		kfree(ahc->name);
-	if (ahc->seep_config != NULL)
-		kfree(ahc->seep_config);
+	kfree(ahc->name);
+	kfree(ahc->seep_config);
 	kfree(ahc);
 	return;
 }
@@ -4927,8 +4923,7 @@ ahc_fini_scbdata(struct ahc_softc *ahc)
 	case 0:
 		break;
 	}
-	if (scb_data->scbarray != NULL)
-		kfree(scb_data->scbarray);
+	kfree(scb_data->scbarray);
 }
 
 static void
-- 
2.21.1

