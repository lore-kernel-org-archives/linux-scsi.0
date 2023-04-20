Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80393C77B72
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Apr 2023 14:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjDTOem (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Apr 2023 10:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjDTOek (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2023 10:34:40 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1303C1D
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2023 07:34:34 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q2KrW3jygzsRMw;
        Thu, 20 Apr 2023 22:32:59 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm100004.china.huawei.com
 (7.192.105.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 20 Apr
 2023 22:34:30 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 2/3] scsi: libsas: Remove an empty branch in sas_check_parent_topology()
Date:   Thu, 20 Apr 2023 22:33:38 +0800
Message-ID: <20230420143339.2769414-3-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230420143339.2769414-1-yanaijie@huawei.com>
References: <20230420143339.2769414-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is an empty "All good" branch in sas_check_parent_topology(). We can
reverse the test statement and remove the empty branch.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 70fd4f439664..bbf73e74530e 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1285,11 +1285,9 @@ static int sas_check_parent_topology(struct domain_device *child)
 					res = -ENODEV;
 				}
 			} else if (parent_phy->routing_attr == TABLE_ROUTING) {
-				if (child_phy->routing_attr == SUBTRACTIVE_ROUTING ||
-				    (child_phy->routing_attr == TABLE_ROUTING &&
-				     child_ex->t2t_supp && parent_ex->t2t_supp)) {
-					/* All good */;
-				} else {
+				if (child_phy->routing_attr != SUBTRACTIVE_ROUTING &&
+				    (child_phy->routing_attr != TABLE_ROUTING ||
+				     !child_ex->t2t_supp || !parent_ex->t2t_supp)) {
 					sas_print_parent_topology_bug(child, parent_phy, child_phy);
 					res = -ENODEV;
 				}
-- 
2.31.1

