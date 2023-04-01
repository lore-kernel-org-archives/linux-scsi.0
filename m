Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4988FC77B60
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Apr 2023 08:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbjDAIQD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Apr 2023 04:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbjDAIQB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Apr 2023 04:16:01 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142B993EA
        for <linux-scsi@vger.kernel.org>; Sat,  1 Apr 2023 01:16:00 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PpVJN6zQMznZHH;
        Sat,  1 Apr 2023 16:12:36 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm100004.china.huawei.com
 (7.192.105.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Sat, 1 Apr
 2023 16:15:56 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 2/3] scsi: libsas: Remove an empty branch in sas_check_parent_topology()
Date:   Sat, 1 Apr 2023 16:15:25 +0800
Message-ID: <20230401081526.1655279-3-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230401081526.1655279-1-yanaijie@huawei.com>
References: <20230401081526.1655279-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
index 048a931d856a..c0841652f0e0 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1284,11 +1284,9 @@ static int sas_check_parent_topology(struct domain_device *child)
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

