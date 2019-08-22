Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948D0C3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7279522CE3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731989AbfHVN63 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 09:58:29 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33946 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731965AbfHVN62 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 09:58:28 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3B2A06CD05FAB9B881FA;
        Thu, 22 Aug 2019 21:58:24 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 21:58:14 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <hare@suse.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 3/3] scsi: aic7xxx: remove set but not used variables 'tinfo','lqistat2'
Date:   Thu, 22 Aug 2019 22:04:45 +0800
Message-ID: <1566482685-117305-4-git-send-email-zhengbin13@huawei.com>
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

drivers/scsi/aic7xxx/aic79xx_core.c: In function ahd_dump_sglist:
drivers/scsi/aic7xxx/aic79xx_core.c:1738:14: warning: variable len set but not used [-Wunused-but-set-variable]
drivers/scsi/aic7xxx/aic79xx_core.c: In function ahd_handle_seqint:
drivers/scsi/aic7xxx/aic79xx_core.c:1911:26: warning: variable tinfo set but not used [-Wunused-but-set-variable]
drivers/scsi/aic7xxx/aic79xx_core.c: In function ahd_handle_transmission_error:
drivers/scsi/aic7xxx/aic79xx_core.c:2672:8: warning: variable lqistat2 set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 7e5044b..75d94d6 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -1743,8 +1743,8 @@ ahd_dump_sglist(struct scb *scb)
 				       i,
 				       (uint32_t)((addr >> 32) & 0xFFFFFFFF),
 				       (uint32_t)(addr & 0xFFFFFFFF),
-				       sg_list[i].len & AHD_SG_LEN_MASK,
-				       (sg_list[i].len & AHD_DMA_LAST_SEG)
+				       len & AHD_SG_LEN_MASK,
+				       (len & AHD_DMA_LAST_SEG)
 				     ? " Last" : "");
 			}
 		} else {
@@ -1906,9 +1906,6 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat)
 		{
 			struct	ahd_devinfo devinfo;
 			struct	scb *scb;
-			struct	ahd_initiator_tinfo *targ_info;
-			struct	ahd_tmode_tstate *tstate;
-			struct	ahd_transinfo *tinfo;
 			u_int	scbid;

 			/*
@@ -1936,12 +1933,6 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat)
 					    SCB_GET_LUN(scb),
 					    SCB_GET_CHANNEL(ahd, scb),
 					    ROLE_INITIATOR);
-			targ_info = ahd_fetch_transinfo(ahd,
-							devinfo.channel,
-							devinfo.our_scsiid,
-							devinfo.target,
-							&tstate);
-			tinfo = &targ_info->curr;
 			ahd_set_width(ahd, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
 				      AHD_TRANS_ACTIVE, /*paused*/TRUE);
 			ahd_set_syncrate(ahd, &devinfo, /*period*/0,
@@ -2669,7 +2660,6 @@ ahd_handle_transmission_error(struct ahd_softc *ahd)
 	struct	scb *scb;
 	u_int	scbid;
 	u_int	lqistat1;
-	u_int	lqistat2;
 	u_int	msg_out;
 	u_int	curphase;
 	u_int	lastphase;
@@ -2680,7 +2670,6 @@ ahd_handle_transmission_error(struct ahd_softc *ahd)
 	scb = NULL;
 	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
 	lqistat1 = ahd_inb(ahd, LQISTAT1) & ~(LQIPHASE_LQ|LQIPHASE_NLQ);
-	lqistat2 = ahd_inb(ahd, LQISTAT2);
 	if ((lqistat1 & (LQICRCI_NLQ|LQICRCI_LQ)) == 0
 	 && (ahd->bugs & AHD_NLQICRC_DELAYED_BUG) != 0) {
 		u_int lqistate;
--
2.7.4

