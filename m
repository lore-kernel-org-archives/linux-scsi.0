Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F26C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 15:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D26E62078E
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 15:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbgIIPss (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 11:48:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40376 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730547AbgIIPsq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Sep 2020 11:48:46 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C63FB72172B65730FA36;
        Wed,  9 Sep 2020 21:55:58 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 21:55:48 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <hare@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v4] scsi: libfc: Fix passing zero to 'PTR_ERR' warning
Date:   Wed, 9 Sep 2020 21:54:32 +0800
Message-ID: <20200909135432.36772-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20200818114235.51052-1-yuehaibing@huawei.com>
References: <20200818114235.51052-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

drivers/scsi/libfc/fc_disc.c:304
 fc_disc_error() warn: passing zero to 'PTR_ERR'

fp maybe NULL in fc_disc_error(), use PTR_ERR_OR_ZERO to handle this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v4: fix error print type 
v3: use PTR_ERR_OR_ZERO
v2: use use IS_ERR in fc_disc_error()
---
 drivers/scsi/libfc/fc_disc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index e67abb184a8a..942fc60f7c21 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -301,8 +301,8 @@ static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
 	struct fc_lport *lport = fc_disc_lport(disc);
 	unsigned long delay = 0;
 
-	FC_DISC_DBG(disc, "Error %ld, retries %d/%d\n",
-		    PTR_ERR(fp), disc->retry_count,
+	FC_DISC_DBG(disc, "Error %d, retries %d/%d\n",
+		    PTR_ERR_OR_ZERO(fp), disc->retry_count,
 		    FC_DISC_RETRY_LIMIT);
 
 	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
-- 
2.17.1


