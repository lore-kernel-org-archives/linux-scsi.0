Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31056C07E9D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 12:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbiI0MRt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 08:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiI0MRd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 08:17:33 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E0444574;
        Tue, 27 Sep 2022 05:17:31 -0700 (PDT)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4McJTQ3FJYzpTqZ;
        Tue, 27 Sep 2022 20:14:34 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 20:17:29 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.com>, <hch@lst.de>, <bvanassche@acm.org>,
        <john.garry@huawei.com>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v5 7/8] scsi: libsas: use sas_phy_addr_match() instead of open coded
Date:   Tue, 27 Sep 2022 20:39:25 +0800
Message-ID: <20220927123926.953297-8-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220927123926.953297-1-yanaijie@huawei.com>
References: <20220927123926.953297-1-yanaijie@huawei.com>
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

The sas address comparison of expander phys is open coded. Now we can
replace it with sas_phy_addr_match().

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/libsas/sas_expander.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 9393ab83358c..38ed42b14fa0 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2058,8 +2058,7 @@ static int sas_rediscover(struct domain_device *dev, const int phy_id)
 
 			if (i == phy_id)
 				continue;
-			if (SAS_ADDR(phy->attached_sas_addr) ==
-			    SAS_ADDR(changed_phy->attached_sas_addr)) {
+			if (sas_phy_addr_match(phy, changed_phy)) {
 				last = false;
 				break;
 			}
-- 
2.31.1

