Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3F5C07E9D
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Sep 2022 07:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiIXHYc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Sep 2022 03:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbiIXHYX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Sep 2022 03:24:23 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED08C13D867;
        Sat, 24 Sep 2022 00:24:21 -0700 (PDT)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MZL7M1Vs9zHqM9;
        Sat, 24 Sep 2022 15:22:07 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 24 Sep
 2022 15:24:19 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.com>, <hch@lst.de>, <bvanassche@acm.org>,
        <john.garry@huawei.com>, <jinpu.wang@cloud.ionos.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 7/8] scsi: libsas: use sas_phy_addr_same() instead of open coded
Date:   Sat, 24 Sep 2022 15:34:54 +0800
Message-ID: <20220924073455.2186805-8-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220924073455.2186805-1-yanaijie@huawei.com>
References: <20220924073455.2186805-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sas address comparation of expander phys is open coded. Now we can
replace it with sas_phy_addr_same().

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index b2b5103c3e76..c9d738ad8176 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2058,8 +2058,7 @@ static int sas_rediscover(struct domain_device *dev, const int phy_id)
 
 			if (i == phy_id)
 				continue;
-			if (SAS_ADDR(phy->attached_sas_addr) ==
-			    SAS_ADDR(changed_phy->attached_sas_addr)) {
+			if (sas_phy_addr_same(phy, changed_phy)) {
 				last = false;
 				break;
 			}
-- 
2.31.1

