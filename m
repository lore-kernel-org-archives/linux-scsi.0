Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDC2C3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 14:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DE6322CE3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 14:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732545AbfHVODf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 10:03:35 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33924 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732528AbfHVODe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 10:03:34 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0F1A2CB1AED9F1B8F5D7;
        Thu, 22 Aug 2019 21:58:24 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 21:58:14 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <hare@suse.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 2/3] scsi: aic7xxx: remove set but not used variables 'ahc','targ'
Date:   Thu, 22 Aug 2019 22:04:44 +0800
Message-ID: <1566482685-117305-3-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566482685-117305-1-git-send-email-zhengbin13@huawei.com>
References: <1566482685-117305-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/aic7xxx/aic7xxx_osm.c: In function ahc_linux_slave_configure:
drivers/scsi/aic7xxx/aic7xxx_osm.c:674:20: warning: variable ahc set but not used [-Wunused-but-set-variable]
drivers/scsi/aic7xxx/aic7xxx_osm.c: In function ahc_send_async:
drivers/scsi/aic7xxx/aic7xxx_osm.c:1611:28: warning: variable targ set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index d5c4a0d..57041cc 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -671,10 +671,6 @@ ahc_linux_slave_alloc(struct scsi_device *sdev)
 static int
 ahc_linux_slave_configure(struct scsi_device *sdev)
 {
-	struct	ahc_softc *ahc;
-
-	ahc = *((struct ahc_softc **)sdev->host->hostdata);
-
 	if (bootverbose)
 		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");

@@ -1608,7 +1604,6 @@ ahc_send_async(struct ahc_softc *ahc, char channel,
 	case AC_TRANSFER_NEG:
 	{
 		struct	scsi_target *starget;
-		struct	ahc_linux_target *targ;
 		struct	ahc_initiator_tinfo *tinfo;
 		struct	ahc_tmode_tstate *tstate;
 		int	target_offset;
@@ -1642,7 +1637,6 @@ ahc_send_async(struct ahc_softc *ahc, char channel,
 		starget = ahc->platform_data->starget[target_offset];
 		if (starget == NULL)
 			break;
-		targ = scsi_transport_target_data(starget);

 		target_ppr_options =
 			(spi_dt(starget) ? MSG_EXT_PPR_DT_REQ : 0)
--
2.7.4

