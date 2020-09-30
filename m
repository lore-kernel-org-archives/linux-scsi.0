Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D5ABC4727C
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 02:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DB8D20B1F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 02:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgI3CPu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 22:15:50 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14727 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729322AbgI3CPt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 22:15:49 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B7806E2B37CD7E854288;
        Wed, 30 Sep 2020 10:15:48 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Wed, 30 Sep 2020
 10:15:39 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <hare@kernel.org>, <linux-scsi@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: myrb: Fix inconsistent of format with argument type in myrb.c
Date:   Wed, 30 Sep 2020 10:16:37 +0800
Message-ID: <20200930021637.2831618-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix follow warnings:
[drivers/scsi/myrb.c:1052]: (warning) %d in format string (no. 1)
	requires 'int' but the argument type is 'unsigned int'.
[drivers/scsi/myrb.c:1052]: (warning) %d in format string (no. 2)
	requires 'int' but the argument type is 'unsigned int'.
[drivers/scsi/myrb.c:1052]: (warning) %d in format string (no. 4)
	requires 'int' but the argument type is 'unsigned int'.
[drivers/scsi/myrb.c:2170]: (warning) %d in format string (no. 1)
	requires 'int' but the argument type is 'unsigned int'.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/myrb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index cbf1e8b091b9..df4ac3f1ca3f 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1050,7 +1050,7 @@ static int myrb_get_hba_config(struct myrb_hba *cb)
 		enquiry2->fw.turn_id = 0;
 	}
 	snprintf(cb->fw_version, sizeof(cb->fw_version),
-		"%d.%02d-%c-%02d",
+		"%u.%02u-%c-%02u",
 		enquiry2->fw.major_version,
 		enquiry2->fw.minor_version,
 		enquiry2->fw.firmware_type,
@@ -2167,7 +2167,7 @@ static ssize_t ctlr_num_show(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct myrb_hba *cb = shost_priv(shost);
 
-	return snprintf(buf, 20, "%d\n", cb->ctlr_num);
+	return snprintf(buf, 20, "%u\n", cb->ctlr_num);
 }
 static DEVICE_ATTR_RO(ctlr_num);
 
-- 
2.25.4

