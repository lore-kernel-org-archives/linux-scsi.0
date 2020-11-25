Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3E4C64E8A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 06:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8432C206E0
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 06:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgKYGqX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 01:46:23 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7984 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgKYGqW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2020 01:46:22 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Cgry52hvCzhh9C;
        Wed, 25 Nov 2020 14:46:05 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Wed, 25 Nov 2020 14:46:09 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Qinglang Miao" <miaoqinglang@huawei.com>
Subject: [PATCH] scsi: aic94xx: Fix error return code in asd_process_ms
Date:   Wed, 25 Nov 2020 14:50:33 +0800
Message-ID: <20201125065033.154172-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix to return the error code -EINVAL when size == 0 after
asd_find_flash_de instead of zero.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/scsi/aic94xx/aic94xx_sds.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index 105adba55..3aad00458 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -860,8 +860,10 @@ static int asd_process_ms(struct asd_ha_struct *asd_ha,
 		goto out;
 	}
 
-	if (size == 0)
+	if (size == 0) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	err = -ENOMEM;
 	manuf_sec = kmalloc(size, GFP_KERNEL);
@@ -989,8 +991,10 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 		goto out_process;
 	}
 
-	if (size == 0)
+	if (size == 0) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	err = -ENOMEM;
 	el = kmalloc(size, GFP_KERNEL);
-- 
2.23.0

