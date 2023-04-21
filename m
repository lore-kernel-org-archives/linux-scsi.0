Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3D4C7618E
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 09:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbjDUJjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Apr 2023 05:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbjDUJi5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2023 05:38:57 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FA4AF01
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2023 02:38:54 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q2qCZ6ynLzL2Dv;
        Fri, 21 Apr 2023 17:36:10 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm100004.china.huawei.com
 (7.192.105.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 21 Apr
 2023 17:38:52 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v3 3/3] scsi: libsas: factor out sas_check_fanout_expander_topo()
Date:   Fri, 21 Apr 2023 17:37:44 +0800
Message-ID: <20230421093744.1583609-4-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230421093744.1583609-1-yanaijie@huawei.com>
References: <20230421093744.1583609-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To be consistent with sas_check_edge_expander_topo(), factor out
sas_check_fanout_expander_topo(). And remove the comment since we
are not spilling over 80 colums now.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 1b4eb01d14ec..adcac57aaee6 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1271,11 +1271,25 @@ static int sas_check_edge_expander_topo(struct domain_device *child,
 	return -ENODEV;
 }
 
-/* Here we spill over 80 columns.  It is intentional.
- */
-static int sas_check_parent_topology(struct domain_device *child)
+static int sas_check_fanout_expander_topo(struct domain_device *child,
+					  struct ex_phy *parent_phy)
 {
 	struct expander_device *child_ex = &child->ex_dev;
+	struct ex_phy *child_phy;
+
+	child_phy = &child_ex->ex_phy[parent_phy->attached_phy_id];
+
+	if (parent_phy->routing_attr == TABLE_ROUTING &&
+	    child_phy->routing_attr == SUBTRACTIVE_ROUTING)
+		return 0;
+
+	sas_print_parent_topology_bug(child, parent_phy, child_phy);
+
+	return -ENODEV;
+}
+
+static int sas_check_parent_topology(struct domain_device *child)
+{
 	struct expander_device *parent_ex;
 	int i;
 	int res = 0;
@@ -1290,7 +1304,6 @@ static int sas_check_parent_topology(struct domain_device *child)
 
 	for (i = 0; i < parent_ex->num_phys; i++) {
 		struct ex_phy *parent_phy = &parent_ex->ex_phy[i];
-		struct ex_phy *child_phy;
 
 		if (parent_phy->phy_state == PHY_VACANT ||
 		    parent_phy->phy_state == PHY_NOT_PRESENT)
@@ -1299,19 +1312,14 @@ static int sas_check_parent_topology(struct domain_device *child)
 		if (!sas_phy_match_dev_addr(child, parent_phy))
 			continue;
 
-		child_phy = &child_ex->ex_phy[parent_phy->attached_phy_id];
-
 		switch (child->parent->dev_type) {
 		case SAS_EDGE_EXPANDER_DEVICE:
 			if (sas_check_edge_expander_topo(child, parent_phy))
 				res = -ENODEV;
 			break;
 		case SAS_FANOUT_EXPANDER_DEVICE:
-			if (parent_phy->routing_attr != TABLE_ROUTING ||
-			    child_phy->routing_attr != SUBTRACTIVE_ROUTING) {
-				sas_print_parent_topology_bug(child, parent_phy, child_phy);
+			if (sas_check_fanout_expander_topo(child, parent_phy))
 				res = -ENODEV;
-			}
 			break;
 		default:
 			break;
-- 
2.31.1

