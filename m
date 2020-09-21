Return-Path: <SRS0=3eE7=C6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5564EC43466
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 14:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C1B821D91
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 14:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgIUO0R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 10:26:17 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52140 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727131AbgIUO0Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Sep 2020 10:26:16 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 73DA09497FF7D3A6D33C;
        Mon, 21 Sep 2020 22:26:13 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Mon, 21 Sep 2020
 22:26:06 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <hare@suse.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: aic7xxx: move declaration of 'aic79xx_slowcrc' to aic79xx_osm.h
Date:   Mon, 21 Sep 2020 22:27:16 +0800
Message-ID: <20200921142716.874975-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This addresses the following sparse warning:

drivers/scsi/aic7xxx/aic79xx_osm.c:312:10: warning: symbol
'aic79xx_slowcrc' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.h | 1 +
 drivers/scsi/aic7xxx/aic79xx_pci.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
index 8a8b7ae7aed3..fd3b5e07b9c9 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -679,5 +679,6 @@ void	ahd_print_path(struct ahd_softc *, struct scb *);
 #endif
 #define bootverbose aic79xx_verbose
 extern uint32_t aic79xx_verbose;
+extern uint32_t aic79xx_slowcrc;
 
 #endif /* _AIC79XX_LINUX_H_ */
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index 8397ae93f7dd..a29a9cf84f05 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -965,7 +965,6 @@ ahd_aic790X_setup(struct ahd_softc *ahd)
 			AHD_SET_SLEWRATE(ahd, AHD_SLEWRATE_DEF_REVA);
 	} else {
 		/* This is revision B and newer. */
-		extern uint32_t aic79xx_slowcrc;
 		u_int devconfig1;
 
 		ahd->features |= AHD_RTI|AHD_NEW_IOCELL_OPTS
-- 
2.25.4

