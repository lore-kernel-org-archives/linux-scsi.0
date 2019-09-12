Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232B7ECDE20
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 08:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE94F214DA
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 08:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbfILIff (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 04:35:35 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:51327 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726159AbfILIff (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Sep 2019 04:35:35 -0400
X-UUID: bd63f85869c5425ebf86acd6c96f0c22-20190912
X-UUID: bd63f85869c5425ebf86acd6c96f0c22-20190912
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 68503579; Thu, 12 Sep 2019 16:35:30 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Sep 2019 16:35:28 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Sep 2019 16:35:28 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <martin.petersen@oracle.com>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <matthias.bgg@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 2/2] scsi: core: remove dummy q->dev check
Date:   Thu, 12 Sep 2019 16:35:28 +0800
Message-ID: <1568277328-4597-3-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1568277328-4597-1-git-send-email-stanley.chu@mediatek.com>
References: <1568277328-4597-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 7430DA2F2846D4A29875BAA5248E9505066D37ECD9ADF235ABEDC7883C4C01B42000:8
X-MTK:  N
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently blk_set_runtime_active() is checking if q->dev is null by
itself, thus remove the same checking in its user: scsi_dev_type_resume().

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/scsi_pm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 74ded5f3c236..3717eea37ecb 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -94,8 +94,7 @@ static int scsi_dev_type_resume(struct device *dev,
 		if (!err && scsi_is_sdev_device(dev)) {
 			struct scsi_device *sdev = to_scsi_device(dev);
 
-			if (sdev->request_queue->dev)
-				blk_set_runtime_active(sdev->request_queue);
+			blk_set_runtime_active(sdev->request_queue);
 		}
 	}
 
-- 
2.18.0

