Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1843EC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 02:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 032952067C
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 02:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgHSCGY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 22:06:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9769 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726884AbgHSCGY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 22:06:24 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D466F3F041F0498E387F;
        Wed, 19 Aug 2020 10:06:19 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Wed, 19 Aug 2020
 10:06:12 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <hare@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2] scsi: libfc: Fix passing zero to 'PTR_ERR' warning
Date:   Wed, 19 Aug 2020 10:05:46 +0800
Message-ID: <20200819020546.59172-1-yuehaibing@huawei.com>
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

fp maybe NULL in fc_disc_error(), use IS_ERR to handle this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: use IS_ERR in fc_disc_error()
---
 drivers/scsi/libfc/fc_disc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index d8cbc9c0e766..574e842cefed 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -302,7 +302,7 @@ static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
 	unsigned long delay = 0;
 
 	FC_DISC_DBG(disc, "Error %ld, retries %d/%d\n",
-		    PTR_ERR(fp), disc->retry_count,
+		    IS_ERR(fp) ? PTR_ERR(fp) : 0, disc->retry_count,
 		    FC_DISC_RETRY_LIMIT);
 
 	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
-- 
2.17.1


