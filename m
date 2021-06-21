Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32E3C48BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 03:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89EE661206
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 03:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhFUDsw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Jun 2021 23:48:52 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:39078 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229905AbhFUDsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Jun 2021 23:48:51 -0400
X-UUID: ec1784ace07e47e385686cc1c6dbfcdf-20210621
X-UUID: ec1784ace07e47e385686cc1c6dbfcdf-20210621
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <ed.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1539177191; Mon, 21 Jun 2021 11:46:35 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 21 Jun 2021 11:46:32 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 21 Jun 2021 11:46:32 +0800
From:   Ed Tsai <ed.tsai@mediatek.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ed Tsai <ed.tsai@mediatek.com>
Subject: [PATCH] scsi: remove reduntant assignment when alloc sdev
Date:   Mon, 21 Jun 2021 11:45:55 +0800
Message-ID: <20210621034555.4039-1-ed.tsai@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sdev->reqeust_queue and its queuedata have been set up in
scsi_mq_alloc_queue(). No need to do that again.

Signed-off-by: Ed Tsai <ed.tsai@mediatek.com>
---
 drivers/scsi/scsi_scan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 12f54571b83e..82c1792f1de2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -266,8 +266,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	 */
 	sdev->borken = 1;
 
-	sdev->request_queue = scsi_mq_alloc_queue(sdev);
-	if (!sdev->request_queue) {
+	if (!scsi_mq_alloc_queue(sdev)) {
 		/* release fn is set up in scsi_sysfs_device_initialise, so
 		 * have to free and put manually here */
 		put_device(&starget->dev);
@@ -275,7 +274,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 		goto out;
 	}
 	WARN_ON_ONCE(!blk_get_queue(sdev->request_queue));
-	sdev->request_queue->queuedata = sdev;
 
 	depth = sdev->host->cmd_per_lun ?: 1;
 
-- 
2.18.0

