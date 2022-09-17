Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E2BECAAD3
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Sep 2022 10:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiIQKcg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Sep 2022 06:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIQKc1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Sep 2022 06:32:27 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44FE831DC4;
        Sat, 17 Sep 2022 03:32:26 -0700 (PDT)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MV6d001SDzpSvH;
        Sat, 17 Sep 2022 18:29:39 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 17 Sep
 2022 18:32:24 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.com>, <hch@lst.de>, <bvanassche@acm.org>,
        <john.garry@huawei.com>, <jinpu.wang@cloud.ionos.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 5/7] scsi: hisi_sas: use dev_and_phy_addr_same() instead of open coded
Date:   Sat, 17 Sep 2022 18:43:09 +0800
Message-ID: <20220917104311.1878250-6-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220917104311.1878250-1-yanaijie@huawei.com>
References: <20220917104311.1878250-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sas address comparation of domain device and expander phy is open
coded. Now we can replace it with dev_and_phy_addr_same().

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 33af5b8dede2..4a11b717d03b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -797,8 +797,7 @@ static int hisi_sas_dev_found(struct domain_device *device)
 
 		for (phy_no = 0; phy_no < phy_num; phy_no++) {
 			phy = &parent_dev->ex_dev.ex_phy[phy_no];
-			if (SAS_ADDR(phy->attached_sas_addr) ==
-				SAS_ADDR(device->sas_addr))
+			if (dev_and_phy_addr_same(device, phy))
 				break;
 		}
 
-- 
2.31.1

