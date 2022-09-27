Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EBEBC6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 02:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiI0CTO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiI0CTJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 22:19:09 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC0793233;
        Mon, 26 Sep 2022 19:19:08 -0700 (PDT)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mc39S6PWzz1P6j2;
        Tue, 27 Sep 2022 10:14:52 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 10:19:06 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.com>, <hch@lst.de>, <bvanassche@acm.org>,
        <john.garry@huawei.com>, <jinpu.wang@cloud.ionos.com>,
        Jason Yan <yanaijie@huawei.com>,
        Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH v3 5/8] scsi: hisi_sas: use sas_find_attathed_phy() instead of open coded
Date:   Tue, 27 Sep 2022 10:29:38 +0800
Message-ID: <20220927022941.4029476-6-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220927022941.4029476-1-yanaijie@huawei.com>
References: <20220927022941.4029476-1-yanaijie@huawei.com>
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

The attached phy finding is open coded. Now we can replace it with
sas_find_attached_phy().

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 33af5b8dede2..995ccb13fb9d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -792,17 +792,9 @@ static int hisi_sas_dev_found(struct domain_device *device)
 
 	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
 		int phy_no;
-		u8 phy_num = parent_dev->ex_dev.num_phys;
-		struct ex_phy *phy;
 
-		for (phy_no = 0; phy_no < phy_num; phy_no++) {
-			phy = &parent_dev->ex_dev.ex_phy[phy_no];
-			if (SAS_ADDR(phy->attached_sas_addr) ==
-				SAS_ADDR(device->sas_addr))
-				break;
-		}
-
-		if (phy_no == phy_num) {
+		phy_no = sas_find_attached_phy(&parent_dev->ex_dev, device);
+		if (phy_no == -ENODEV) {
 			dev_info(dev, "dev found: no attached "
 				 "dev:%016llx at ex:%016llx\n",
 				 SAS_ADDR(device->sas_addr),
-- 
2.31.1

